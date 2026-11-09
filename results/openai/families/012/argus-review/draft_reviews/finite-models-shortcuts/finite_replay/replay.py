"""Replay the preserved checker without invoking its certificate-writing CLI."""

import hashlib
import importlib.util
import json
import math
import platform
import sys
import time
from fractions import Fraction
from pathlib import Path


ROOT = Path(__file__).resolve().parents[4]
OUT = Path(__file__).resolve().parent
OLD = ROOT.parent / "9000012" / "research" / "adaptive-cut-transfer"
JACOBIAN = OUT.parent / "jacobian"
FINITE_FIELDS = (
    "deterministic",
    "finite_models",
    "excluded_optimizer_conditioning",
    "disconnected_extension",
    "rare_types_and_jacobian",
    "manuscript_exponents",
    "finite_size_nonvacuity",
)


def save(name, value):
    (OUT / name).write_text(json.dumps(value, indent=2, sort_keys=True) + "\n")


def digest(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def require(condition, message):
    if not condition:
        raise AssertionError(message)


def link_live_jacobian():
    payload = json.loads((JACOBIAN / "payload.json").read_text())
    output = json.loads((JACOBIAN / "output.json").read_text())
    status = json.loads((JACOBIAN / "status.json").read_text())
    operation = "probability.finite_distribution.raw_moment.compute"
    rational = lambda value: Fraction(int(value["num"]), int(value["den"]))
    p = Fraction(1, 16)
    atoms = {}
    for rare_count in range(4):
        probability = math.comb(3, rare_count) * p**rare_count * (1 - p) ** (3 - rare_count)
        mass = Fraction(4, 3) * math.comb(rare_count, 2)
        atoms[mass] = atoms.get(mass, Fraction(0)) + probability
    require(
        atoms
        == {Fraction(0): Fraction(2025, 2048), Fraction(4, 3): Fraction(45, 4096),
            Fraction(4): Fraction(1, 4096)},
        "binomial rare-type distribution",
    )
    require(status["exit_code"] == 0 and not status["timeout"] and status["error"] is None,
            "lead Jacobian run completed successfully")
    require(output["request"] == {"operation_id": operation, "payload": payload},
            "lead output binds the exact payload")
    require(output["result"]["operation_id"] == operation, "lead output operation")
    require(
        {rational(atom["value"]): rational(atom["probability"]) for atom in payload["atoms"]}
        == atoms,
        "lead payload is the normalized mass of the rare-positive triangle",
    )
    typed = output["result"]["output"]
    contributions = []
    for atom, contribution in zip(payload["atoms"], typed["contributions"], strict=True):
        value = rational(atom["value"])
        probability = rational(atom["probability"])
        expected = probability * value**2
        require(rational(contribution["value"]) == value, "contribution value")
        require(rational(contribution["probability"]) == probability, "contribution probability")
        require(rational(contribution["powered_value"]) == value**2, "contribution square")
        require(rational(contribution["contribution"]) == expected, "contribution product")
        contributions.append(expected)
    moment = sum(probability * value**2 for value, probability in atoms.items())
    require(payload["order"] == typed["order"] == 2, "raw second moment order")
    require(sum(atoms.values()) == 1, "atom probability normalization")
    require(rational(typed["moment"]) == moment == Fraction(3, 128), "raw moment linkage")
    return {
        "operation_id": operation,
        "model": "rare_positive: three independent Bernoulli(1/16) sites; E_ik=2 U_i U_k",
        "random_variable": "A=(1/3) sum_(i,k) |E_ik|=(4/3) binom(K,2), K~Binomial(3,1/16)",
        "atoms": [{"value": str(value), "probability": str(probability)}
                  for value, probability in atoms.items()],
        "contributions": [str(value) for value in contributions],
        "exact_raw_second_moment": str(moment),
        "server_version": output["server"]["version"],
        "protocol_version": output["protocol_version"],
        "adapter_exit_code": status["exit_code"],
        "timeout": status["timeout"],
        "error": status["error"],
        "replay_attribution": "Typed operation replayed by lead; this harness independently links its atoms.",
        "input_sha256": {name: digest(JACOBIAN / name)
                         for name in ("payload.json", "output.json", "status.json")},
    }


def main():
    sys.dont_write_bytecode = True
    started = time.monotonic()
    inputs = [OLD / name for name in (
        "verify.py", "exact_certificate.json", "Main.lean", "statement_fidelity.md",
        "lean_run.json", "jacobian_payload.json", "jacobian_output.json",
        "jacobian_adapter_status.json",
    )]
    inputs.append(OLD.parent / "MATH_STATE.json")
    before = {str(path): digest(path) for path in inputs}
    metadata = {
        "status": "running",
        "python_executable": sys.executable,
        "python_version": platform.python_version(),
        "python_full_version": sys.version,
        "source": str(OLD / "verify.py"),
        "source_sha256": before[str(OLD / "verify.py")],
        "entrypoint": "certify() imported with bytecode writes disabled; main() not invoked",
        "write_policy": "All replay outputs are in finite_replay; preserved inputs are read only.",
        "finite_fields": list(FINITE_FIELDS),
    }
    save("replay_status.json", metadata)
    try:
        spec = importlib.util.spec_from_file_location("preserved_review012_verify", OLD / "verify.py")
        module = importlib.util.module_from_spec(spec)
        sys.modules[spec.name] = module
        spec.loader.exec_module(module)
        print("Running every original certify() assertion; no --write-certificate.", flush=True)
        result = module.certify()
        finite = {key: result[key] for key in FINITE_FIELDS}
        save("finite_result.json", finite)
        historical = json.loads((OLD / "exact_certificate.json").read_text())
        matches = {key: finite[key] == historical[key] for key in FINITE_FIELDS}
        comparison = {
            "old_certificate": str(OLD / "exact_certificate.json"),
            "old_certificate_sha256": before[str(OLD / "exact_certificate.json")],
            "finite_field_matches": matches,
            "all_finite_fields_equal": all(matches.values()),
            "excluded_top_level_fields": sorted(set(historical) - set(FINITE_FIELDS)),
            "metadata_policy": "Historical Lean provenance and prose theorem assertions are not finite results.",
        }
        save("comparison.json", comparison)
        require(all(matches.values()), "a finite field differs from the archived exact certificate")
        save("jacobian_link.json", link_live_jacobian())
        after = {str(path): digest(path) for path in inputs}
        require(before == after, "a preserved checker input changed during replay")
        metadata.update(
            status="success",
            exit_code=0,
            original_certify_assertions_passed=True,
            all_finite_fields_equal=True,
            preserved_inputs_unchanged=True,
            input_sha256=before,
            historical_lean_check={
                "status": "original lean_core() checks passed against the old ledger and old run",
                "fresh_compile": False,
                "recorded_result": result["lean"],
                "fresh_compile_artifact": "research/draft_reviews/finite-cut-core/replay/lean_run.json",
            },
            scope="Finite regression evidence and two excluded shortcuts, not a universal transfer proof.",
        )
        print("PASS: original assertions; seven finite fields match; lead Jacobian atoms linked.", flush=True)
    except Exception as error:
        metadata.update(status="failed", exit_code=1, error_type=type(error).__name__, error=str(error))
        raise
    finally:
        metadata["duration_seconds"] = round(time.monotonic() - started, 6)
        save("replay_status.json", metadata)


if __name__ == "__main__":
    main()
