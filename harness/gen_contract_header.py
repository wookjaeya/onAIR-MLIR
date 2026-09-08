"""Generate a C header from a contract.json so that build-time constants are
never copied by hand (reviewer v0.6 §3). Both the standalone native learner
and the cFS app include the generated header."""
import json, sys
c = json.load(open(sys.argv[1])); out = sys.argv[2]
r = c["resources"]; a = c["artifact"]; v = c.get("validity", {})
sha = a["sha256"]
lines = ["/* GENERATED from contract.json -- do not edit */",
         "#ifndef CONTRACT_GEN_H", "#define CONTRACT_GEN_H",
         f"#define CONTRACT_BOUNDED_BYTES {r['bounded_bytes']}L",
         f"#define CONTRACT_PER_CALL_BYTES {r['static_per_call_bytes']}L",
         f"#define CONTRACT_CONST_BYTES {r['module_resident_constant_bytes']}L",
         f"#define CONTRACT_ARTIFACT_BYTES {a['bytes']}L",
         f"#define CONTRACT_ARTIFACT_SHA256 \"{sha}\"",
         f"#define CONTRACT_INPUT_ELEMS {int(__import__('math').prod(v.get('input',{}).get('shape',[1,9])))}",
         f"#define CONTRACT_OUTPUT_ELEMS {int(__import__('math').prod(v.get('output',{}).get('shape',[1,2])))}",
         f"#define CONTRACT_DRIVER \"{v.get('driver','local-sync')}\"",
         "#endif"]
open(out, "w").write("\n".join(lines) + "\n"); print("wrote", out)
