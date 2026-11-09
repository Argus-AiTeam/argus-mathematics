#!/usr/bin/env python3
"""Bounded replay of the existing matrix family, not a new error search."""

import argparse
import hashlib
import importlib.util
import json
import os
from pathlib import Path
import shutil
import subprocess
import sys
import time

import sympy as sp


sys.dont_write_bytecode = True
PROJECT = Path("campaigns/9200001")
OLD = PROJECT.parent / "9000001/research/prescribed-filtration-audit"
UNIT = Path("research/draft_reviews/symbolic-frobenius")
FIXTURES = UNIT / "historical-replay"
LATTICE = Path("research/draft_reviews/lattice-obstruction")
ADAPTER = "$WORKSPACE/argus-live-update/.venv/bin/python"
OPERATION = "matrix.symbolic.linear_system.solve"
ENV = {**os.environ, "PYTHONDONTWRITEBYTECODE": "1"}
INPUTS = [
    "verify.py", "exact_certificate.json", "jacobian-linear-contract.json",
    "jacobian-payload.json", "jacobian-output.json",
]


def digest(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def write_json(path, value):
    assert not path.is_absolute()
    assert path.is_relative_to(UNIT) or path.is_relative_to(LATTICE)
    path.write_text(json.dumps(value, indent=2, ensure_ascii=False) + "\n")


def prepare():
    FIXTURES.mkdir(parents=True, exist_ok=True)
    for name in INPUTS:
        destination = FIXTURES / name
        if destination.exists():
            assert destination.read_bytes() == (OLD / name).read_bytes(), name
        else:
            shutil.copyfile(OLD / name, destination)
    payload_path = UNIT / "jacobian-payload.json"
    if not payload_path.exists():
        shutil.copyfile(OLD / "jacobian-payload.json", payload_path)


def checker():
    spec = importlib.util.spec_from_file_location(
        "historical_exact_checker", FIXTURES / "verify.py"
    )
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


def run_command(argv, timeout=90):
    started = time.monotonic()
    try:
        result = subprocess.run(
            argv, text=True, capture_output=True, timeout=timeout,
            env=ENV, check=False,
        )
        receipt = {
            "argv": argv, "cwd": str(Path.cwd()), "exit_code": result.returncode,
            "timed_out": False, "stdout": result.stdout, "stderr": result.stderr,
        }
    except subprocess.TimeoutExpired as error:
        def text(value):
            return value.decode(errors="replace") if isinstance(value, bytes) else value

        receipt = {
            "argv": argv, "cwd": str(Path.cwd()), "exit_code": None,
            "timed_out": True, "stdout": text(error.stdout) or "",
            "stderr": text(error.stderr) or "",
        }
    receipt["process_timeout_seconds"] = timeout
    receipt["duration_seconds"] = round(time.monotonic() - started, 3)
    return receipt


def adapter(stage, arguments, filename):
    receipt = run_command(
        [ADAPTER, "-B", "-m", "argus_skill.tools.jacobian", *arguments]
    )
    output = None
    parse_error = None
    try:
        output = json.loads(receipt["stdout"])
    except json.JSONDecodeError as error:
        parse_error = str(error)
    error = output.get("error") if isinstance(output, dict) else None
    completed = (
        receipt["exit_code"] == 0 and not receipt["timed_out"]
        and parse_error is None and error is None and isinstance(output, dict)
    )
    if not completed and output is None:
        output = {
            "ok": False,
            "error": {
                "kind": "PROCESS_TIMEOUT" if receipt["timed_out"] else "INVALID_OUTPUT",
                "json_parse_error": parse_error,
            },
        }
    write_json(UNIT / filename, output)
    status_path = UNIT / "jacobian-adapter-status.json"
    status = json.loads(status_path.read_text()) if status_path.exists() else {
        "schema_version": 1,
        "operation_id": OPERATION,
        "adapter_executable": ADAPTER,
        "protocol": None,
        "server": None,
        "stages": {},
        "mathematical_operation_attempts": 0,
        "failure_policy": "Timeout, UNKNOWN, and incomplete output are non-conclusions.",
    }
    if isinstance(output, dict):
        status["server"] = output.get("server", status["server"])
        status["protocol"] = output.get("protocol_version", status["protocol"])
    status["stages"][stage] = {
        **receipt,
        "output_file": str(UNIT / filename),
        "output_is_valid_json": parse_error is None,
        "json_parse_error": parse_error,
        "adapter_error": error,
        "completed": completed,
    }
    if stage == "run":
        status["mathematical_operation_attempts"] += 1
        result = output.get("result", {}) if isinstance(output, dict) else {}
        status["classification"] = result.get("output", {}).get("classification")
    write_json(status_path, status)
    print(json.dumps({
        "stage": stage, "completed": completed, "exit_code": receipt["exit_code"],
        "timed_out": receipt["timed_out"], "adapter_error": error,
        "output": str(UNIT / filename), "server": status["server"],
        "protocol": status["protocol"],
    }, indent=2))
    return output, completed


def discover():
    discovery, found = adapter(
        "find",
        ["find", "--query", "symbolic linear system rational function field",
         "--domain", "matrix", "--limit", "3"],
        "jacobian-discovery.json",
    )
    if found:
        assert OPERATION in json.dumps(discovery["result"])
    adapter(
        "inspect", ["inspect", "--operation", OPERATION],
        "jacobian-contract.json",
    )


def execute():
    status = json.loads((UNIT / "jacobian-adapter-status.json").read_text())
    assert status["mathematical_operation_attempts"] == 0, "Never repeat the solve."
    contract = json.loads((UNIT / "jacobian-contract.json").read_text())
    operation = contract["result"]["operation"]
    assert operation["operation_id"] == OPERATION and operation["read_only"]
    assert operation["input_schema"]["title"] == "SymbolicLinearSystemRequest"
    assert operation["output_schema"]["title"] == "SymbolicLinearSystemResult"
    exact = checker()
    payload = json.loads((UNIT / "jacobian-payload.json").read_text())
    assert payload == exact.payload()
    adapter(
        "run",
        ["run", "--operation", OPERATION, "--payload-file",
         str(UNIT / "jacobian-payload.json"), "--timeout", "60"],
        "jacobian-output.json",
    )


def check():
    before = {name: digest(OLD / name) for name in INPUTS}
    cache_before = (OLD / "__pycache__").exists()
    original = run_command([sys.executable, "-B", str(FIXTURES / "verify.py")])
    assert original["exit_code"] == 0 and not original["timed_out"], original
    old_stdout = json.loads(original["stdout"])
    assert old_stdout["exact_algebra"] == "PASS"
    exact = checker()
    certificate = json.loads((FIXTURES / "exact_certificate.json").read_text())
    matrix = exact.verify_frame_and_adapter(certificate)
    exact.verify_quadratic_diagnostic(certificate, matrix)
    exact.verify_integral_obstruction(certificate)
    status_path = UNIT / "jacobian-adapter-status.json"
    status = json.loads(status_path.read_text()) if status_path.exists() else None
    current_check = "NOT_EXECUTED"
    if status and status["stages"].get("run", {}).get("completed"):
        current_certificate = json.loads(json.dumps(certificate))
        current_certificate["jacobian"]["payload"] = "../jacobian-payload.json"
        current_certificate["jacobian"]["output"] = "../jacobian-output.json"
        exact.verify_frame_and_adapter(current_certificate)
        current_check = "PASS"
    t = sp.Symbol("t")
    polynomial = sp.Poly(t**2 + t + 1, t, domain=sp.QQ)

    def reduce(expression):
        return sp.rem(
            sp.Poly(sp.expand(expression), t, domain=sp.QQ), polynomial
        ).as_expr()

    def sigma(value):
        return value.applyfunc(lambda entry: reduce(entry.subs(t, -1 - t)))

    g = sp.Matrix([[1, t], [0, 1]])
    crystalline = exact.dual(sp.Matrix([[0, 1], [-sp.Rational(1, 2), 0]]))
    correct = (
        exact.dual(sigma(g)).inv() * crystalline * sigma(exact.dual(sigma(g)))
    ).applyfunc(reduce)
    wrong = (
        exact.dual(g).inv() * crystalline * sigma(exact.dual(g))
    ).applyfunc(reduce)
    difference = (correct - wrong).applyfunc(reduce)
    assert correct == sp.Matrix([[-t, 1], [-3, -1 - t]])
    assert wrong == sp.Matrix([[1 + t, 1], [-3, t]])
    assert difference == (-1 - 2 * t) * sp.eye(2)
    s = sp.Symbol("s")
    lattice = sp.Matrix([[1, 0], [1, 2]])
    projector = sp.diag(1, 0)
    action = sp.diag(1, 1 + 2 * s)
    integral = lattice.inv() * action * lattice
    transported = lattice.inv() * projector * lattice
    assert integral == sp.Matrix([[1, 0], [s, 1 + 2 * s]])
    assert sp.Poly(integral.det(), s, modulus=2).as_expr() == 1
    assert transported == sp.Matrix([[1, 0], [-sp.Rational(1, 2), 0]])
    assert action * projector == projector * action
    after = {name: digest(OLD / name) for name in INPUTS}
    assert before == after
    assert (OLD / "__pycache__").exists() == cache_before
    assert not (FIXTURES / "__pycache__").exists()
    runtime = {
        "python": sys.version,
        "executable": sys.executable,
        "sympy": sp.__version__,
        "bytecode_writes_disabled": sys.dont_write_bytecode,
        "runtime_selection":
            "argus-latest venv lacked SymPy; existing system Python used, no installation.",
    }
    receipt = {
        "schema_version": 1,
        "unit_id": "symbolic-frobenius",
        "result": "PASS",
        "runtime": runtime,
        "checker_write_behavior":
            "Inspected entire original: reads ROOT JSON, prints JSON; no file-write calls.",
        "historical_input_sha256": before,
        "source_copy_sha256": digest(FIXTURES / "verify.py"),
        "copy_equals_historical_source":
            (FIXTURES / "verify.py").read_bytes() == (OLD / "verify.py").read_bytes(),
        "historical_checker": original,
        "historical_checker_output": old_stdout,
        "historical_payload_equals_derived_frame_equations": True,
        "historical_typed_solution_exactly_verified": True,
        "current_adapter_solution_exact_check": current_check,
        "symbolic_family": {
            "field": "QQ(p,u,v)",
            "row_major_coefficient_matrix": [
                ["1", "0", "0", "0"], ["0", "1", "0", "0"],
                ["-u", "0", "1", "0"], ["0", "-u", "0", "1"],
            ],
            "right_hand_side": ["-v", "1", "-p", "0"],
            "coefficient_determinant": "1",
            "solution_matrix": [[str(v) for v in row] for row in matrix.tolist()],
            "solution_determinant": str(sp.factor(matrix.det())),
            "original_b_requires": "p != 0",
        },
        "quadratic_diagnostic": {
            "prime": 2,
            "minimal_polynomial": "t^2+t+1",
            "sigma_t": "-1-t",
            "correct": [[str(v) for v in row] for row in correct.tolist()],
            "omitted_sigma_basis": [[str(v) for v in row] for row in wrong.tolist()],
            "difference": [[str(v) for v in row] for row in difference.tolist()],
            "interpretation": "Wrong-convention diagnostic, not manuscript refutation.",
        },
        "historical_inputs_unchanged": before == after,
        "historical_pycache_before": cache_before,
        "historical_pycache_after": (OLD / "__pycache__").exists(),
        "copied_checker_pycache_created": False,
        "geometry_checked": False,
        "independent_review": "pending_native_reviewer",
    }
    write_json(UNIT / "exact-replay.json", receipt)
    lattice_receipt = {
        "schema_version": 1,
        "unit_id": "lattice-obstruction",
        "result": "PASS",
        "runtime": runtime,
        "command": [sys.executable, "-B", str(UNIT / "replay.py"), "check"],
        "cwd": str(PROJECT),
        "historical_checker_command": original["argv"],
        "historical_checker_output": old_stdout,
        "historical_checker_receipt": str(UNIT / "exact-replay.json"),
        "source_sha256": before["verify.py"],
        "certificate_sha256": before["exact_certificate.json"],
        "universal_identity": {
            "base": "Z_2",
            "quantifier": "every s in Z_2",
            "lattice_columns": [[1, 0], [1, 2]],
            "lattice_determinant": 2,
            "integral_action": [[str(v) for v in row] for row in integral.tolist()],
            "action_determinant": str(integral.det()),
            "determinant_reduction_mod_2": 1,
            "projector_in_lattice_basis":
                [[str(v) for v in row] for row in transported.tolist()],
            "projector_commutes_with_action": True,
            "nonintegral_entry_2_adic_valuation": -1,
            "standard_lattice_projector": [[1, 0], [0, 0]],
        },
        "conclusion":
            "Counterexample to arbitrary-stable-lattice integral-tensor shortcut only.",
        "not_a_counterexample_to": "PF-REALIZATION or existential abelian realization",
        "historical_inputs_unchanged": True,
        "independent_review": "pending_native_reviewer",
    }
    write_json(LATTICE / "replay.json", lattice_receipt)
    print(json.dumps({
        "exact_checker": "PASS",
        "historical_typed_solution": "PASS",
        "current_adapter_solution": current_check,
        "quadratic_diagnostic": "PASS",
        "universal_lattice_identity": "PASS",
        "receipts": [str(UNIT / "exact-replay.json"), str(LATTICE / "replay.json")],
        "runtime": runtime,
    }, indent=2))


def main():
    assert Path.cwd() == PROJECT
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("phase", choices=["discover", "execute", "check"])
    args = parser.parse_args()
    prepare()
    LATTICE.mkdir(parents=True, exist_ok=True)
    {"discover": discover, "execute": execute, "check": check}[args.phase]()


if __name__ == "__main__":
    main()
