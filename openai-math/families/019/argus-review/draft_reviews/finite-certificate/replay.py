"""Replay only the inspected, read-only finite parts of the old checker."""

import json
from pathlib import Path
import runpy
import sys


HERE = Path(__file__).resolve().parent
OLD = Path(
    "campaigns/9000019"
    "/research/collar_root_audit"
)
OPERATION = "graph.multigraph.cycle_multicover.check"


def require(condition, message):
    if not condition:
        raise ValueError(message)


def read_json(path):
    return json.loads(path.read_text(encoding="utf-8"))


def main():
    old = runpy.run_path(str(OLD / "verify.py"), run_name="review_read_only")
    historical_graph = old["replay_jacobian"]()
    arithmetic = old["replay_exact_arithmetic"]()
    certificate = read_json(OLD / "exact_certificate.json")
    require(
        historical_graph == certificate["finite_jacobian_replay"],
        "Historical finite graph replay differs from its certificate.",
    )
    require(
        arithmetic == certificate["exact_finite_controls"],
        "Historical exact arithmetic differs from its certificate.",
    )

    replay = HERE / "replay"
    payload = read_json(replay / "jacobian_payload.json")
    discovery = read_json(replay / "jacobian_find.json")
    contract = read_json(replay / "jacobian_contract.json")
    response = read_json(replay / "jacobian_result.json")
    require(payload == read_json(OLD / "jacobian_payload.json"), "Payload changed.")
    require(
        OPERATION in {m["operation_id"] for m in discovery["result"]["matches"]},
        "Operation absent from current bounded discovery.",
    )
    operation = contract["result"]["operation"]
    require(operation["operation_id"] == OPERATION, "Wrong inspected operation.")
    require(operation["read_only"] is True, "Operation is not read-only.")
    for record in (discovery, contract, response):
        require(not record.get("error"), "Adapter error is not evidence.")
        require(record["server"]["name"] == "jacobian", "Unexpected server.")
        require(record["transport"] == "mcp-stdio", "Unexpected transport.")
    require(
        response["request"]["operation_id"] == OPERATION
        and response["result"]["operation_id"] == OPERATION,
        "Operation identity differs between request and result.",
    )
    require(response["request"]["payload"] == payload, "Response payload mismatch.")
    output = response["result"]["output"]
    require(output["is_exact_k_cover"] is True, "No positive exact-cover verdict.")
    require(
        output == read_json(OLD / "jacobian_result.json")["result"]["output"],
        "Current typed output differs from the independently replayed old output.",
    )
    result = {
        "result_class": "finite_verification",
        "python_executable": sys.executable,
        "python_version": sys.version,
        "old_checker": str(OLD / "verify.py"),
        "executed_functions": ["replay_jacobian", "replay_exact_arithmetic"],
        "old_main_and_compile_and_check_executed": False,
        "historical_graph": historical_graph,
        "exact_arithmetic": arithmetic,
        "historical_certificate_comparison": "equal",
        "live_jacobian": {
            "operation_id": OPERATION,
            "server_version": response["server"]["version"],
            "protocol_version": response["protocol_version"],
            "transport": response["transport"],
            "adapter_status": "success",
            "adapter_error": None,
            "adapter_timeout": False,
            "runtime_ms": response["result"]["runtime_ms"],
            "payload_file": "research/draft_reviews/finite-certificate/replay/jacobian_payload.json",
            "typed_output_file": "research/draft_reviews/finite-certificate/replay/jacobian_result.json",
            "typed_output_matches_historical_output": True,
        },
        "scope": (
            "One three-parallel-edge graph, finite rational binomial controls, "
            "signed slopes, and numerical genus/radius identities; not "
            "universal analytic cover existence or convergence."
        ),
    }
    (replay / "replay_result.json").write_text(
        json.dumps(result, indent=2) + "\n", encoding="utf-8"
    )
    print(
        json.dumps(
            {
                "historical_graph_and_arithmetic": "passed",
                "live_typed_output": "equal",
                "result": str(replay / "replay_result.json"),
            },
            indent=2,
        )
    )


if __name__ == "__main__":
    main()
