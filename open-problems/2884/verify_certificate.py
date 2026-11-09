#!/usr/bin/env python3
import json
import math
from pathlib import Path


HERE = Path(__file__).resolve().parent


def require(condition, label):
    if not condition:
        raise AssertionError(label)


def load_json(relative_path):
    with (HERE / relative_path).open(encoding="utf-8") as handle:
        return json.load(handle)


certificate = load_json("certificate.json")
checks = []

require(certificate["claim"] == "C2884", "wrong claim")
ambient = certificate["ambient"]
require(ambient["Y"] == "E(2)", "wrong elliptic surface")
require(ambient["Z"] == "S^2 x S^2", "wrong stabilization")
require(ambient["connected_sum_disjoint_from_F"], "connected sum meets F")
require(ambient["has_section"], "section hypothesis missing")
require(
    set(ambient["monodromy_cycles"]) == {"a", "b"}
    and ambient["monodromy_repetitions"] == 12,
    "vanishing cycles do not kill both fiber generators",
)
checks.append("ambient_data")

knots = certificate["knots"]
require([(k["p"], k["q"]) for k in knots] == [(2, 3), (2, 5)], "wrong knot pair")
for knot in knots:
    p, q = knot["p"], knot["q"]
    require(math.gcd(p, q) == 1 and min(p, q) > 1, f"{knot['name']} is not a torus knot")
    require(knot["bridge_number"] == min(p, q) == 2, f"{knot['name']} bridge number")
    expected = [1 if exponent % 2 == 0 else -1 for exponent in range(q)]
    require(
        knot["alexander_polynomial_ascending"] == expected,
        f"{knot['name']} Alexander polynomial",
    )
    require(knot["normalizing_shift"] == -(q - 1) // 2, f"{knot['name']} normalization")

breadths = [len(k["alexander_polynomial_ascending"]) - 1 for k in knots]
require(breadths == [2, 4], "Alexander breadths do not distinguish the knots")
require(
    [list(reversed(k["alexander_polynomial_ascending"])) for k in knots]
    == [k["alexander_polynomial_ascending"] for k in knots],
    "mirror reciprocity check failed",
)
checks.append("prime_knot_inputs_and_nonmirror_invariant")

gluing = certificate["gluing"]
require(
    gluing["source_boundary_basis"] == ["s", "mu_K", "lambda_K"]
    and gluing["target_boundary_basis"] == ["a", "b", "mu_F"]
    and gluing["images"] == ["a", "b", "-mu_F"],
    "unexpected knot-surgery boundary map",
)
require(
    certificate["locality"]["statement"] == "X_K diffeomorphic to Y_K#Z",
    "locality identity missing",
)
checks.append("fixed_gluing_and_locality")

maps = {entry["name"]: entry for entry in certificate["maps"]}
ordered = [maps[name] for name in certificate["composition_order"]]
require(ordered[0]["domain"] == "X_K1", "composition has wrong source")
for left, right in zip(ordered, ordered[1:]):
    require(left["codomain"] == right["domain"], f"map mismatch after {left['name']}")
require(ordered[-1]["codomain"] == "X_K2", "composition has wrong target")
checks.append("diffeomorphism_composition")

for source in certificate["sources"]:
    source_path = HERE / source["path"]
    require(source_path.is_file(), f"missing source {source['id']}")
    text = source_path.read_text(encoding="utf-8", errors="replace")
    require(source["needle"] in text, f"source transcription not found for {source['id']}")
checks.append("primary_source_transcriptions")

jacobian = certificate["jacobian"]
require(
    jacobian["server_version"] == "0.14.0"
    and jacobian["protocol_version"] == "2025-11-25"
    and jacobian["operation_id"] == "polynomial.factor.compute"
    and jacobian["adapter_status"] == "completed"
    and not jacobian["timeout"]
    and jacobian["structured_error"] is None,
    "Jacobian metadata or adapter status failed",
)
payload = load_json(jacobian["payload"])
output = load_json(jacobian["typed_output"])
require(output["result"]["operation_id"] == jacobian["operation_id"], "wrong Jacobian operation")
require(output["result"]["output"]["product_reconstruction"] == "EXACT", "inexact reconstruction")
factor_degrees = [
    factor["factor"]["polynomial"]["terms"][0]["exponents"][0]
    for factor in output["result"]["output"]["factors"]
]
require(factor_degrees == [2, 4], "unexpected Alexander polynomial factors")
require(
    output["request"]["payload"] == payload,
    "executed Jacobian payload differs from the preserved payload",
)
checks.append("typed_jacobian_reconstruction")

print(
    json.dumps(
        {
            "ok": True,
            "checks": checks,
            "conclusion": "exact fixed-pair candidate is internally consistent and ready for source review",
        },
        separators=(",", ":"),
    )
)
