"""Replay the old exact diagnostics without entering its write-capable main."""

import json
import platform
import runpy
from fractions import Fraction
from pathlib import Path


ROOT = Path(__file__).resolve().parents[3]
INVENTORY = json.loads((ROOT / "PRIOR_DRAFTS.json").read_text())
OLD = Path(INVENTORY["old_workspace"])
HERE = Path(__file__).resolve().parent


def require(condition, message):
    if not condition:
        raise AssertionError(message)


def main():
    old = runpy.run_path(str(OLD / "research/entropy_refinement/verify.py"))
    spec = json.loads((OLD / "research/entropy_refinement/exact_certificate.json").read_text())
    old_algebra = old["jacobian_check"](spec["jacobian"])
    samples = old["parameter_samples"](spec["parameter_samples"])
    traces = [old["regression"](case) for case in spec["regression_cases"]]
    for trace in traces:
        expected = spec["regression_results"][trace["case"]]
        require({key: trace[key] for key in expected} == expected, "changed exact trace")
    for event in spec["required_regression_events"]:
        require(sum(trace[event] for trace in traces) > 0, f"unexercised event: {event}")

    payload = json.loads((HERE / "jacobian_payload.json").read_text())
    contract = json.loads((HERE / "jacobian_contract.json").read_text())
    response = json.loads((HERE / "jacobian_output.json").read_text())
    operation = "polynomial.multivariate.factor.compute"
    require(contract["result"]["operation"]["operation_id"] == operation, "wrong contract")
    require(response["request"] == {"operation_id": operation, "payload": payload},
            "response bound to another request")
    typed = response["result"]["output"]
    require(typed["status"] == "FACTORIZED", "no complete factorization")
    require(typed["product_reconstruction"] == "EXACT", "inexact reconstruction")
    coefficient = typed["coefficient"]
    product = {(0, 0, 0, 0): Fraction(int(coefficient["num"]), int(coefficient["den"]))}
    for factor in typed["factors"]:
        for _ in range(factor["multiplicity"]):
            product = old["multiply"](product, old["polynomial"](factor["factor"]))
    require(product == old["polynomial"](payload["polynomial"]), "wrong factor product")
    require(product == old["polynomial"](typed["reconstructed"]), "wrong reconstruction")

    widths = {
        "entry": [Fraction(3, 4), Fraction(1, 2)],
        "exit": [Fraction(2, 3), Fraction(1, 4)],
    }
    require(all(new <= previous for new, previous in zip(widths["exit"], widths["entry"])),
            "endpoint did not decrease")
    before = widths["entry"][0] - widths["entry"][1]
    after = widths["exit"][0] - widths["exit"][1]
    require(before == Fraction(1, 4) and after == Fraction(5, 12) and before < after,
            "retired shortcut was not refuted")
    print(json.dumps({
        "status": "passed",
        "python": platform.python_version(),
        "old_checker": str(OLD / "research/entropy_refinement/verify.py"),
        "execution_scope": "Exact arithmetic functions only; old main, lean_check and compile paths not called.",
        "old_algebra": old_algebra,
        "fresh_jacobian": {
            "operation_id": operation,
            "server_version": response["server"]["version"],
            "protocol_version": response["protocol_version"],
            "status": typed["status"],
            "product_reconstruction": typed["product_reconstruction"],
            "adapter_error": response.get("error"),
            "runtime_ms": response["result"]["runtime_ms"],
        },
        "parameter_samples": samples,
        "regressions": traces,
        "retired_width_shortcut": {
            "entry": [str(value) for value in widths["entry"]],
            "exit": [str(value) for value in widths["exit"]],
            "entry_width": str(before),
            "exit_width": str(after),
            "conclusion": "Counterexample to the shortcut implication only, not entropy-realized or a manuscript refutation.",
        },
        "theorem_scope": "These finite diagnostics do not replace the universal proof or validate the entropy/Fourier transfer.",
    }, indent=2))


if __name__ == "__main__":
    main()
