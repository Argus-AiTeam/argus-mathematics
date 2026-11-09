"""Replay the old checker's mathematical routines without its path-bound main."""

import importlib.util
import json
from pathlib import Path


HERE = Path(__file__).resolve().parent


def main():
    spec = importlib.util.spec_from_file_location("historical_switch_checker", HERE / "verify.py")
    if spec is None or spec.loader is None:
        raise RuntimeError("Cannot load the isolated historical checker")
    checker = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(checker)
    certificate = json.loads((HERE / "exact_certificate.json").read_text())
    checker.check_universal_identities()
    finite, old_coordinate, new_coordinate = checker.check_diamond(certificate)
    checker.check_jacobian(certificate, finite)
    rejected = checker.check_negative_controls(certificate)
    print(json.dumps({
        "status": "PASS",
        "scope": "Unmodified mathematical routines from the isolated historical verify.py",
        "universal_polynomial_identities": True,
        "integral_diamond_normal_forms_pairings_and_adjugates": True,
        "parameter": "every nonzero p in a DVR; polynomial matrix identities over Z[p]",
        "finite_coordinate": str(old_coordinate),
        "singular_coordinate": str(new_coordinate),
        "coordinate_ratio": str(new_coordinate / old_coordinate),
        "negative_controls_rejected": rejected,
        "jacobian": {
            "operation_id": certificate["jacobian"]["operation_id"],
            "payload_file": "jacobian_payload.json",
            "typed_output_file": "jacobian_result.json",
            "server_version": certificate["jacobian"]["server_version"],
            "protocol_version": certificate["jacobian"]["protocol_version"],
            "historical_adapter_exit_code": certificate["jacobian"]["adapter_exit_code"],
            "historical_adapter_status": certificate["jacobian"]["adapter_status"],
            "historical_structured_error": certificate["jacobian"]["structured_error"],
            "new_adapter_invocation": False,
            "replayed": "D=U*A*V, det(U)=det(V)=1, diagonal (1,8,8,0)",
            "scope": "one retained exact integer calculation at p=8, not the universal proof"
        },
        "not_executed": [
            "original main() manuscript-label and report-string checks",
            "original check_lean() absolute historical-path/archive binding"
        ],
        "lean_replay": "separate fresh lean/lean_check.json; no fabricated active kernel status",
        "arithmetic_realization": "not established",
        "independent_review": "pending native Host-invoked Reviewer"
    }, indent=2))


if __name__ == "__main__":
    main()
