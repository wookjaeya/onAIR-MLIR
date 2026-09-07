"""E9: allocation-structure cases (reviewer v0.4 §7).

Each case is small so that a failure isolates one mechanism. For every case we
report, from the SAME compile:
  slice_sum   sum of stream.resource.pack slice sizes (schedule-allocation)
  slab        post-layout transient alloca size (layout-slices)  <- bound used
  hal_peak    runtime HAL peak minus inputs/outputs                <- observed
and flag slice_sum vs slab vs hal_peak relations. D3 = slice_sum < hal_peak.
"""
import json, os, re, subprocess, sys, tempfile
import numpy as np

CASES = {
 # A. alignment gap: two odd-sized buffers, both live at the end
 "A_align_gap": """func.func @infer(%x: tensor<1x3xf32>, %w1: tensor<3x5xf32>, %w2: tensor<5x7xf32>, %w3: tensor<7x5xf32>) -> tensor<1x5xf32> {
  %z5 = arith.constant dense<0.0> : tensor<1x5xf32>
  %z7 = arith.constant dense<0.0> : tensor<1x7xf32>
  %t1 = linalg.matmul ins(%x, %w1 : tensor<1x3xf32>, tensor<3x5xf32>) outs(%z5 : tensor<1x5xf32>) -> tensor<1x5xf32>
  %t2 = linalg.matmul ins(%t1, %w2 : tensor<1x5xf32>, tensor<5x7xf32>) outs(%z7 : tensor<1x7xf32>) -> tensor<1x7xf32>
  %t3 = linalg.matmul ins(%t2, %w3 : tensor<1x7xf32>, tensor<7x5xf32>) outs(%z5 : tensor<1x5xf32>) -> tensor<1x5xf32>
  %o = arith.addf %t3, %t1 : tensor<1x5xf32>
  return %o : tensor<1x5xf32>
}""",
 # B. non-overlapping lifetimes: chain where early buffers die -> reuse expected
 "B_lifetime_reuse": """func.func @infer(%x: tensor<1x3xf32>, %w1: tensor<3x5xf32>, %w2: tensor<5x7xf32>, %w3: tensor<7x9xf32>, %w4: tensor<9x5xf32>) -> tensor<1x5xf32> {
  %z5 = arith.constant dense<0.0> : tensor<1x5xf32>
  %z7 = arith.constant dense<0.0> : tensor<1x7xf32>
  %z9 = arith.constant dense<0.0> : tensor<1x9xf32>
  %t1 = linalg.matmul ins(%x, %w1 : tensor<1x3xf32>, tensor<3x5xf32>) outs(%z5 : tensor<1x5xf32>) -> tensor<1x5xf32>
  %t2 = linalg.matmul ins(%t1, %w2 : tensor<1x5xf32>, tensor<5x7xf32>) outs(%z7 : tensor<1x7xf32>) -> tensor<1x7xf32>
  %t3 = linalg.matmul ins(%t2, %w3 : tensor<1x7xf32>, tensor<7x9xf32>) outs(%z9 : tensor<1x9xf32>) -> tensor<1x9xf32>
  %t4 = linalg.matmul ins(%t3, %w4 : tensor<1x9xf32>, tensor<9x5xf32>) outs(%z5 : tensor<1x5xf32>) -> tensor<1x5xf32>
  return %t4 : tensor<1x5xf32>
}""",
 # C. large buffers (alignment negligible) with reuse: checks slab < aligned-sum at scale
 "C_large_chain": """func.func @infer(%x: tensor<1x64xf32>, %w1: tensor<64x4096xf32>, %w2: tensor<4096x2048xf32>, %w3: tensor<2048x8xf32>) -> tensor<1x8xf32> {
  %za = arith.constant dense<0.0> : tensor<1x4096xf32>
  %zb = arith.constant dense<0.0> : tensor<1x2048xf32>
  %zc = arith.constant dense<0.0> : tensor<1x8xf32>
  %t1 = linalg.matmul ins(%x, %w1 : tensor<1x64xf32>, tensor<64x4096xf32>) outs(%za : tensor<1x4096xf32>) -> tensor<1x4096xf32>
  %t2 = linalg.matmul ins(%t1, %w2 : tensor<1x4096xf32>, tensor<4096x2048xf32>) outs(%zb : tensor<1x2048xf32>) -> tensor<1x2048xf32>
  %t3 = linalg.matmul ins(%t2, %w3 : tensor<1x2048xf32>, tensor<2048x8xf32>) outs(%zc : tensor<1x8xf32>) -> tensor<1x8xf32>
  return %t3 : tensor<1x8xf32>
}""",
 # D. fusion: elementwise chain between matmuls (fused or not, the bound must hold)
 "D_fusion": """func.func @infer(%x: tensor<1x16xf32>, %w1: tensor<16x32xf32>, %b: tensor<1x32xf32>, %w2: tensor<32x4xf32>) -> tensor<1x4xf32> {
  %z32 = arith.constant dense<0.0> : tensor<1x32xf32>
  %z4 = arith.constant dense<0.0> : tensor<1x4xf32>
  %t1 = linalg.matmul ins(%x, %w1 : tensor<1x16xf32>, tensor<16x32xf32>) outs(%z32 : tensor<1x32xf32>) -> tensor<1x32xf32>
  %a = arith.addf %t1, %b : tensor<1x32xf32>
  %r = arith.maximumf %a, %z32 : tensor<1x32xf32>
  %s = arith.mulf %r, %r : tensor<1x32xf32>
  %t2 = linalg.matmul ins(%s, %w2 : tensor<1x32xf32>, tensor<32x4xf32>) outs(%z4 : tensor<1x4xf32>) -> tensor<1x4xf32>
  return %t2 : tensor<1x4xf32>
}""",
}

def compile_two_dumps(src, extra):
    f = tempfile.NamedTemporaryFile("w", suffix=".mlir", delete=False); f.write(src); f.close()
    out = f.name.replace(".mlir", ".vmfb")
    r = subprocess.run(["iree-compile", f.name, "--iree-hal-target-backends=llvm-cpu",
                        "--mlir-print-ir-after=iree-stream-schedule-allocation",
                        "--mlir-print-ir-after=iree-stream-layout-slices", "-o", out] + extra,
                       capture_output=True, text=True)
    return f.name, out, r.stderr

def slice_sum(ir):
    consts = {m.group(1): int(m.group(2)) for m in re.finditer(r"(%[\w#]+)\s*=\s*arith\.constant\s+(\d+)\s*:\s*index", ir)}
    # dumps are per function: pick the ScheduleAllocation dump of the entry function
    chunks = re.split(r"// -----// IR Dump After ", ir)
    seg = ""
    for c in chunks:
        if c.startswith("ScheduleAllocationPass") and "@infer" in c:
            seg = c
    total = 0
    for mm in re.finditer(r"stream\.resource\.pack[^{]*slices\(\{(.*?)\}\)", seg, re.S):
        for s2 in re.finditer(r"\[\s*\d+\s*,\s*\d+\s*\]\s*=\s*(%[\w#]+)", mm.group(1)):
            sym = s2.group(1); v = consts.get(sym)
            if v is None:
                m2 = re.fullmatch(r"%c(\d+)(?:_\d+)?", sym); v = int(m2.group(1)) if m2 else 0
            total += v
    return total

def main():
    sys.path.insert(0, os.path.dirname(__file__))
    import static_mem_bound as smb
    extra = ["--iree-llvmcpu-target-triple=x86_64-unknown-linux-gnu"]
    rows = []
    for name, src in CASES.items():
        mlir, vmfb, ir = compile_two_dumps(src, extra)
        ss = slice_sum(ir)
        # runtime check in a FRESH process: HAL allocator statistics are shared
        # across devices in one process, so peaks would leak between cases
        r = subprocess.run([sys.executable, os.path.join(os.path.dirname(__file__), "static_mem_bound.py"),
                            mlir, "--shape", "0", "0", "0", f"--extra={' '.join(extra)}"],
                           capture_output=True, text=True)
        j = json.loads(r.stdout[r.stdout.index("{"):])
        slab = j["static_transient_bytes"]
        io = j["static_external_input_bytes"] + j["static_external_output_bytes"]
        hal_transient = j["runtime_check"]["device_bytes_peak"] - io
        p = {"dispatches": j["dispatches"], "unresolved": j["unresolved_sizes"]}
        row = {"case": name, "dispatches": p["dispatches"], "slice_sum": ss, "slab_post_layout": slab,
               "hal_transient_observed": hal_transient, "io_bytes": io,
               "slice_sum_underestimates": ss < hal_transient, "slab_sound": slab >= hal_transient,
               "slab_tight": slab == hal_transient, "all_static": not p["unresolved"]}
        rows.append(row); print(json.dumps(row))
    json.dump(rows, open("results_structural_cases.json", "w"), indent=2)

if __name__ == "__main__":
    main()
