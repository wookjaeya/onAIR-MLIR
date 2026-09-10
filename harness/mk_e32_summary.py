import json, os, hashlib, glob
ROOT="results/e32_smartcam_aarch64"
def load(p): return json.load(open(p,encoding='utf-8'))
def sha(p): return hashlib.sha256(open(p,'rb').read()).hexdigest()
con=load(f"{ROOT}/build/smartcam.contract.json")
elf=load(f"{ROOT}/build/smartcam.elf.json")
nat=load(f"{ROOT}/native/iree_aarch64.json")
natc=load(f"{ROOT}/native/comparison.json")
cfsc=load(f"{ROOT}/cfs/comparison.json")
run=[s for s in nat["stages"] if s["stage"]=="run"][0]
res=con["resources"]
def grepjson(path, stage):
    out=[]
    for line in open(path,encoding='utf-8',errors='replace'):
        line=line.strip()
        if '"stage":"%s"'%stage in line or '"stage": "%s"'%stage in line:
            try: out.append(json.loads(line[line.index("{"):]))
            except Exception: pass
    return out
doc={
 "experiment":"E32",
 "title":"SmartCam AArch64 cFS execution (stage 2 of the ninth review's build order)",
 "plan":"docs/plans/E32_smartcam_aarch64_cfs.md (committed before measurement, 3c7295d)",
 "criteria_note":"semantic criteria inherited UNCHANGED from E25 via E31; reference values are the "
                 "ORIGINAL TFLite oracle recorded in E31, not re-run here",
 "artifact":{"vmfb":f"{ROOT}/build/smartcam.vmfb","bytes":os.path.getsize(f"{ROOT}/build/smartcam.vmfb"),
             "sha256":sha(f"{ROOT}/build/smartcam.vmfb"),
             "triple":"aarch64-unknown-linux-gnu","cpu":"cortex-a53",
             "single_invocation":con["provenance"].get("single_invocation")},
 "contract":{"bounded_bytes":res["bounded_bytes"],"per_call_bytes":res["static_per_call_bytes"],
             "constants_bytes":res["module_resident_constant_bytes"],
             "kernel_stack_bytes":res.get("kernel_stack_bytes"),
             "kernel_stack_classification":res.get("kernel_stack_classification"),
             "overrides_applied":con["provenance"].get("overrides_applied"),
             "same_as_x86_64":{"bounded":18222796,"per_call":9382092,"constants":8840704,
                               "note":"E30's x86-64 contract; identical three figures, different artifact and stack"}},
 "elf":{"any_dynamic_stack_alloc":elf["any_dynamic_stack_alloc"],
        "all_dispatch_frames_balanced":elf["all_dispatch_frames_balanced"],
        "max_dispatch_invocation_stack_bytes":elf["max_dispatch_invocation_stack_bytes"],
        "total_call_insns":elf["total_call_insns"],
        "realign_restore_forms":{f:sum(1 for x in elf["functions"] if x.get("realign_restore_form")==f)
                                 for f in ("mov_sp_from_reg","sub_sp_from_fp_imm")}},
 "cells":{
   "S_native":{"path":"native C (aarch64) under qemu-user","samples":natc["totals"]["samples"],
     "elements":natc["totals"]["elements"],"elements_failed":natc["totals"]["elements_failed"],
     "argmax_failed":natc["totals"]["argmax_failed"],"verdict":natc["verdict"],
     "worst_element":natc["worst_element"],"log":f"{ROOT}/native/iree_aarch64.json",
     "comparison":f"{ROOT}/native/comparison.json"},
   "S_cfs":{"path":"cFS AI_LEARNER in the AArch64 QEMU guest, batch replay mode",
     "samples":cfsc["totals"]["samples"],"elements":cfsc["totals"]["elements"],
     "elements_failed":cfsc["totals"]["elements_failed"],"argmax_failed":cfsc["totals"]["argmax_failed"],
     "verdict":cfsc["verdict"],"worst_element":cfsc["worst_element"],
     "declared_subset":cfsc["scope"]["declared_subset"],
     "scope_note":"fixed in the plan BEFORE measuring (3 real images + 2 edge); the 37-sample sweep is S_native's job",
     "log":f"{ROOT}/cfs/A_admit.log","comparison":f"{ROOT}/cfs/comparison.json"},
    "S_cfs_repeat":{"path":"cFS AI_LEARNER, message-replay mode, B+1 budget",
     "output_consuming_inferences":70,"failures":0,"hal_peak":9382092,
     "equals_per_call":True,"peak_within_admitted_budget":True,
     "oracle_compared":False,
     "why_not_compared":"message-replay features come from Software Bus telemetry bytes, not fixture "
                        "samples, so these outputs CANNOT be scored against the original oracle "
                        "(plan SS3.4: the two modes are never mixed)",
     "log":f"{ROOT}/cfs/A_plus.log"},
 },
 "budget_cells":{
   "native_B_minus_1":{"budget":18222795,"verdict":"NOT_ADMITTED","inferences":0,
                       "log":f"{ROOT}/native/budget_boundary.log"},
   "native_B":{"budget":18222796,"verdict":"ADMIT","log":f"{ROOT}/native/budget_boundary.log"},
   "native_B_plus_1":{"budget":18222797,"verdict":"ADMIT","log":f"{ROOT}/native/budget_boundary.log"},
   "cfs_B_plus_1":{"budget":18222797,"verdict":"ADMIT","log":f"{ROOT}/cfs/A_plus.log",
     "output_consuming_inferences":70,"failures":0,"hal_peak":9382092,
     "peak_within_admitted_budget":True,"admission_mode":"unconditional",
     "note":"Q3 for the DEPLOYMENT path: 70 message-replay inferences that read every output back, "
            "and the peak stays EXACTLY per_call. EXIT=124 is the harness timeout (timeout -s INT), "
            "the app's own counters show 70/70 completed with 0 failures."},
   "cfs_B_minus_1":{"buildable":False,
     "reason":"AI_LEARNER_BUDGET_BYTES is a compile-time macro, so bounded > budget folds statically and "
              "the post-admission code (including the contract sha256 string) is dead-code eliminated; "
              "the build's own verification then refuses. Build refusal, NOT a fail-open.",
     "observed_error":"51_build_cfs_aarch64: ERROR: contract sha256 ecffe6e0... not found in ai_learner.so",
     "plan_error":"plan SS3.2 said to give B-1 as a RUNTIME budget; the app has no such knob. Recorded as a "
                  "planning error rather than worked around."},
 },
 "D59_conditional_tier":{
   "finding":"the post-inference check compared the peak with `bounded`, not with the budget admission was "
             "granted on; a conditional deployment ran at 106.4% of its approved budget and logged "
             "peak_within_bounded: true",
   "with_replay":{"admitted_budget":9382092,"hal_peak":9984204,"ratio":round(9984204/9382092,4),
                  "log":f"{ROOT}/native/a_cond_with_replay.log"},
   "without_replay":{"admitted_budget":9382092,"hal_peak":9382092,"ratio":1.0,
                     "log":f"{ROOT}/native/a_cond_no_replay.log",
                     "note":"the control: peak is EXACTLY per_call, so the overrun is entirely the replay "
                            "pattern's second input buffer. Also an independent replication of E29's "
                            "map-arm equality on an 8.9 MB real model on AArch64."},
   "after_fix":{"hal_peak":9984204,"peak_within_bounded":True,"peak_within_admitted_budget":False,
                "admission_mode":"conditional_map","log":f"{ROOT}/native/a_cond_with_replay_after_d59.log",
                "note":"same run, same peak; the violation is now stated instead of hidden"},
   "arithmetic":{"per_call":9382092,"io":602124,"transient":8779968,
                 "input_tensor_bytes":602112,"output_bytes":12,
                 "identity":"peak == per_call + input_tensor_bytes (exact)"},
   "cfs_app_contrast":{"hal_peak":9382092,"equals_per_call":True,
                       "note":"both cFS modes reuse the resident input buffer, so the deployment adapter "
                              "keeps exactly one input live"},
 },
 "verdicts":{"Q1_semantics":"PASS","Q2_contract_admission":"PASS",
             "Q3_lifecycle":"PASS (unconditional tier) / FAILED (conditional tier) -- see D59",
             "Q4_mode_separation":"PASS",
             "stage_2_complete":False,
             "stage_2_note":"the plan fixed that all four must hold; Q3's conditional cell did not, and that "
                            "is recorded as a shortfall rather than rounded away"},
 "not_claimed":["accuracy (no evaluation set)","latency or throughput (TCG emulation, FUNCTIONAL_ONLY host)",
                "the official OnAIR plugin path (stage 3)","other models (stage 4)",
                "a fair baseline (stage 5)","real flight hardware (this is a QEMU guest)",
                "whole-process RAM (the contract covers IREE-HAL-owned allocations only)"],
}
os.makedirs(ROOT,exist_ok=True)
json.dump(doc,open(f"{ROOT}/summary.json","w",encoding='utf-8'),indent=1,ensure_ascii=False)
print("wrote",f"{ROOT}/summary.json")
print(json.dumps(doc["verdicts"],indent=1,ensure_ascii=False))
