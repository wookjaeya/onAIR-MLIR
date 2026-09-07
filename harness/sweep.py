"""Go/no-go experiment: model-size sweep of compiled vs interpreted inference
inside the real OnAIR plugin interface.

Why this experiment first
-------------------------
A preliminary run showed that for a tiny MLP the IREE-compiled kernel is
SLOWER than NumPy at the L1 boundary, because Python-to-runtime marshalling
dominates. If that holds at every size a research group would care about,
hypothesis H1 is dead and no amount of contract machinery rescues it.
So the first thing to establish is the crossover point, per boundary.

Plugins are constructed through onair.src.util.plugin_import.import_plugins,
i.e. exactly the path OnAIR itself uses, and are fed real telemetry frames.
"""
import argparse, json, os, subprocess, sys, tempfile, csv, statistics

def pct(ns, q):
    s = sorted(ns)
    return s[min(int(len(s) * q), len(s) - 1)] / 1e3

def summarize(ns):
    s = sorted(ns)
    return {"n": len(s), "median_us": pct(s, .5), "p95_us": pct(s, .95),
            "p99_us": pct(s, .99), "max_us": s[-1] / 1e3}

def load_frames(csv_path, limit):
    rows = []
    with open(csv_path) as f:
        r = csv.reader(f)
        header = next(r)
        for i, row in enumerate(r):
            if i >= limit:
                break
            rows.append(row)
    return header, rows

def run_case(onair_root, plugin_dir, name, headers, frames, repeats):
    sys.path.insert(0, onair_root)
    # OnAIR's AIPlugin base constructs a ServiceManager singleton, which must be
    # initialized once with a service dict before any plugin is instantiated.
    from onair.services.service_manager import ServiceManager
    try:
        ServiceManager({})
    except ValueError:
        pass
    from onair.src.util.plugin_import import import_plugins
    plugins = import_plugins(headers, {name: plugin_dir})
    p = plugins[0]
    for _ in range(repeats):
        for fr in frames:
            p.update(fr, {})
            p.render_reasoning()
    return p.stats()

def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--onair-root", required=True)
    ap.add_argument("--bench-root", required=True)
    ap.add_argument("--telemetry", required=True)
    ap.add_argument("--hidden", type=int, nargs="+", default=[16, 64, 256, 1024])
    ap.add_argument("--frames", type=int, default=400)
    ap.add_argument("--repeats", type=int, default=25)
    ap.add_argument("--out", default="sweep.json")
    a = ap.parse_args()

    header, frames = load_frames(a.telemetry, a.frames)
    n_in = len(header)
    results = []
    for h in a.hidden:
        rt_dir = os.path.join(a.bench_root, "plugins", "compiled_learner", "runtime")
        subprocess.run([sys.executable,
                        os.path.join(a.bench_root, "harness", "gen_model.py"),
                        "--n-in", str(n_in), "--n-hidden", str(h),
                        "--outdir", rt_dir], check=True,
                       stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
        entry = {"n_in": n_in, "hidden": h, "impls": {}}
        for label, pdir in (("compiled", "plugins/compiled_learner"),
                            ("python", "plugins/python_learner")):
            out = subprocess.run(
                [sys.executable, __file__, "--child", a.onair_root,
                 os.path.join(a.bench_root, pdir), label,
                 json.dumps(header), a.telemetry, str(a.frames), str(a.repeats)],
                capture_output=True, text=True)
            entry["impls"][label] = json.loads(out.stdout.strip().splitlines()[-1])
        c = entry["impls"]["compiled"]["boundaries"]
        p = entry["impls"]["python"]["boundaries"]
        entry["ratio_compiled_over_python"] = {
            b: round(c[b]["median_us"] / p[b]["median_us"], 3)
            for b in ("L1_kernel", "L2b_reason") if c.get(b) and p.get(b)}
        results.append(entry)
        print(json.dumps({k: entry[k] for k in
                          ("hidden", "ratio_compiled_over_python")}))
    json.dump(results, open(a.out, "w"), indent=2)

if __name__ == "__main__":
    if len(sys.argv) > 1 and sys.argv[1] == "--child":
        _, _, onair_root, pdir, label, hdr, tel, nframes, reps = sys.argv
        os.chdir(os.path.dirname(pdir) + "/..")
        header, frames = load_frames(tel, int(nframes))
        st = run_case(onair_root, pdir, label, header, frames, int(reps))
        print(json.dumps(st))
    else:
        main()
