"""Gate: refuse to record timing results on a platform whose own noise floor
is comparable to the effect being measured.

Reviewer issue C2/M8. Run this BEFORE any latency experiment and store the
output next to the results. If ratio_p99 or ratio_max exceeds the threshold,
the run is functional-only and must not be cited as timing evidence.
"""
import json, os, time, sys

def busy(n=20000):
    s = 0.0
    for i in range(n):
        s += i * 0.5
    return s

def main(thresh_p99=1.10, thresh_max=1.25, iters=2000):
    lat = []
    for _ in range(iters):
        t0 = time.perf_counter_ns(); busy(); lat.append(time.perf_counter_ns() - t0)
    lat.sort()
    med = lat[len(lat)//2]; p99 = lat[int(len(lat)*0.99)]; mx = lat[-1]
    r = {"cpus": os.cpu_count(),
         "loadavg": open("/proc/loadavg").read().split()[:3],
         "clock_res_ns": time.get_clock_info("perf_counter").resolution * 1e9,
         "median_us": med/1e3, "p99_us": p99/1e3, "max_us": mx/1e3,
         "ratio_p99": p99/med, "ratio_max": mx/med}
    r["timing_grade"] = ("PASS" if r["ratio_p99"] <= thresh_p99 and r["ratio_max"] <= thresh_max
                         else "FUNCTIONAL_ONLY")
    print(json.dumps(r, indent=2))
    return 0 if r["timing_grade"] == "PASS" else 2

if __name__ == "__main__":
    sys.exit(main())
