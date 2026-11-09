"""Replay exact algebra, or compile the pinned implementation's dependencies."""

import argparse
from fractions import Fraction
import hashlib
import itertools
import json
from math import isqrt
import os
from pathlib import Path
import re
import subprocess
import time

import sympy as sp


ROOT = Path(__file__).resolve().parent
PYTHON = "$WORKSPACE/argus-live-update/.venv/bin/python"
WORKSPACE = Path("$WORKSPACE/.local/share/argus-skill/mathlib-v4.31.0")
LAKE = "$WORKSPACE/.elan/bin/lake"
COMPILER_OPTIONS = ["-DautoImplicit=false", "-DmaxHeartbeats=2000000"]


def write_json(path, value):
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(json.dumps(value, indent=2) + "\n", encoding="utf-8")


def add(a, b):
    return a[0] + b[0], a[1] + b[1]


def negate(a):
    return -a[1], -a[0]


def multiply(a, b):
    values = [x * y for x in a for y in b]
    return min(values), max(values)


def power(a, exponent):
    if exponent < 0:
        if a[0] <= 0 <= a[1]:
            raise ValueError("Interval reciprocal contains zero")
        return power((1 / a[1], 1 / a[0]), -exponent)
    if exponent == 0:
        return Fraction(1), Fraction(1)
    if exponent % 2 == 0:
        upper = max(a[0] ** exponent, a[1] ** exponent)
        lower = 0 if a[0] <= 0 <= a[1] else min(
            a[0] ** exponent, a[1] ** exponent
        )
        return Fraction(lower), Fraction(upper)
    return a[0] ** exponent, a[1] ** exponent


def enclose(expression):
    if expression.is_Rational:
        value = Fraction(int(expression.p), int(expression.q))
        return value, value
    if expression.is_Add:
        result = Fraction(0), Fraction(0)
        for term in expression.args:
            result = add(result, enclose(term))
        return result
    if expression.is_Mul:
        result = Fraction(1), Fraction(1)
        for factor in expression.args:
            result = multiply(result, enclose(factor))
        return result
    if expression.is_Pow:
        base, exponent = expression.args
        if exponent == sp.Rational(1, 2) and base.is_Integer and base > 0:
            scale = 10**12
            numerator = isqrt(int(base) * scale**2)
            lower, upper = Fraction(numerator, scale), Fraction(numerator + 1, scale)
            if not lower**2 <= int(base) < upper**2:
                raise ArithmeticError("Invalid radical enclosure")
            return lower, upper
        if exponent.is_Integer:
            return power(enclose(base), int(exponent))
    raise ValueError(f"Unsupported exact interval expression: {expression}")


def sparse(expression, variables):
    polynomial = sp.Poly(expression, *variables, domain=sp.QQ)
    return {
        "variables": [str(variable) for variable in variables],
        "domain": "QQ",
        "polynomial": {
            "terms": [
                {
                    "exponents": list(exponents),
                    "coefficient": {"num": str(coefficient.p), "den": str(coefficient.q)},
                }
                for exponents, coefficient in polynomial.terms()
            ]
        },
    }


def exact_algebra():
    A, B, x, y, r = variables = sp.symbols("A B x y r")
    relations = [x**2 + y**2 - 1, r**2 - A * B]
    middle = (A - B) ** 2 + 4 * A * B * y**2
    left = (A - B * (x**2 - y**2)) ** 2 + (2 * B * x * y) ** 2
    right = (-r + (A - B) * x + r * (x**2 - y**2)) ** 2 + (
        (A - B) * y + 2 * r * x * y
    ) ** 2
    basis = sp.groebner(relations, *variables, order="lex")
    remainders = [basis.reduce(sp.expand(side - middle))[1] for side in (left, right)]
    if remainders != [0, 0]:
        raise ArithmeticError(f"Radial identity failed: {remainders}")
    payload = {
        "ideal": {
            "variables": [str(variable) for variable in variables],
            "generators": [sparse(relation, variables) for relation in relations],
        },
        "polynomial": sparse(sp.expand(right - middle), variables),
        "monomial_order": "lex",
    }
    write_json(ROOT / "jacobian/radial_payload.json", payload)

    sqrt3, sqrt11 = sp.sqrt(3), sp.sqrt(11)
    first, second, tip = (sqrt3 / 2, sp.Rational(1, 2)), (
        sqrt3 / 2, sp.Rational(-1, 2)
    ), (sqrt3, sp.Integer(0))

    def rotate(point):
        a, b = point
        return (5 * a - sqrt11 * b) / 6, (sqrt11 * a + 5 * b) / 6

    vertices = [(sp.Integer(0), sp.Integer(0)), first, second, tip] + [
        rotate(point) for point in (first, second, tip)
    ]
    edges = []
    for i, j in itertools.combinations(range(7), 2):
        square = sp.simplify(
            (vertices[i][0] - vertices[j][0]) ** 2
            + (vertices[i][1] - vertices[j][1]) ** 2
        )
        if square == 1:
            edges.append([i, j])
    expected_edges = [
        [0, 1], [0, 2], [0, 4], [0, 5], [1, 2], [1, 3],
        [2, 3], [3, 6], [4, 5], [4, 6], [5, 6],
    ]
    if edges != expected_edges:
        raise ArithmeticError(f"Unexpected exact unit-distance graph: {edges}")
    count = 0
    for coloring in itertools.product(range(3), repeat=7):
        count += 1
        if all(coloring[i] != coloring[j] for i, j in edges):
            raise ArithmeticError(f"A three-coloring was found: {coloring}")
    four_coloring = next(
        coloring
        for coloring in itertools.product(range(4), repeat=7)
        if all(coloring[i] != coloring[j] for i, j in edges)
    )
    certificates = []
    for index, (a, b) in enumerate(vertices):
        shifted_x, shifted_y = a - sp.Rational(290, 250), b + sp.Rational(149, 250)
        px = sp.expand((35 * shifted_x - 12 * shifted_y) / 37)
        py = sp.expand((12 * shifted_x + 35 * shifted_y) / 37)
        ix, iy = enclose(px), enclose(py)
        length = add(power(ix, 2), power(iy, 2))
        three_x2_minus_y2 = add(
            multiply((Fraction(3), Fraction(3)), power(ix, 2)),
            negate(power(iy, 2)),
        )
        lhs = multiply(power(iy, 2), power(three_x2_minus_y2, 2))
        rhs = multiply(
            multiply(
                power(length, 3),
                add((Fraction(1), Fraction(1)), negate(
                    multiply((Fraction(1, 4), Fraction(1, 4)), length)
                )),
            ),
            power(add(length, (Fraction(-1), Fraction(-1))), 2),
        )
        gap = add(rhs, negate(lhs))
        if not (length[0] > 0 and length[1] < 4 and gap[0] > 0):
            raise ArithmeticError(f"Placed vertex {index} failed a strict region inequality")
        certificates.append({
            "vertex": index,
            "x": [str(endpoint) for endpoint in ix],
            "y": [str(endpoint) for endpoint in iy],
            "norm_squared": [str(endpoint) for endpoint in length],
            "region_gap_lower": str(gap[0]),
        })
    result = {
        "result_class": "finite_verification",
        "scope": "Supporting radial identities and the manuscript seven-point certificate only; not the five-color theorem.",
        "radial_remainders": [str(value) for value in remainders],
        "relations": ["x^2+y^2=1", "r^2=A*B"],
        "unit_distance_edges": edges,
        "three_color_assignments_excluded": count,
        "proper_four_coloring": list(four_coloring),
        "placed_vertices": certificates,
    }
    write_json(ROOT / "algebra_certificate.json", result)
    print(json.dumps({
        "radial_remainders": result["radial_remainders"],
        "unit_edges": len(edges),
        "three_color_assignments_excluded": count,
        "strictly_inside_region": len(certificates),
        "result_class": "finite_verification",
    }))
    return result


def run_jacobian():
    try:
        result = subprocess.run(
            [PYTHON, "-m", "argus_skill.tools.jacobian", "run", "--operation",
             "polynomial.ideal.normal_form.compute", "--payload-file",
             str(ROOT / "jacobian/radial_payload.json")],
            capture_output=True, text=True, timeout=90,
        )
    except subprocess.TimeoutExpired as error:
        write_json(ROOT / "jacobian/radial_error.json", {
            "operation_id": "polynomial.ideal.normal_form.compute",
            "adapter_status": "TIMEOUT",
            "timeout_seconds": error.timeout,
            "mathematical_conclusion": None,
        })
        raise
    try:
        output = json.loads(result.stdout)
    except json.JSONDecodeError:
        write_json(ROOT / "jacobian/radial_error.json", {
            "operation_id": "polynomial.ideal.normal_form.compute",
            "adapter_status": "INVALID_OUTPUT",
            "adapter_exit_code": result.returncode,
            "stdout": result.stdout,
            "stderr": result.stderr,
            "mathematical_conclusion": None,
        })
        raise
    write_json(ROOT / "jacobian/radial_result.json", {
        "adapter_exit_code": result.returncode,
        "adapter_stderr": result.stderr,
        "typed_output": output,
    })
    if result.returncode != 0:
        raise RuntimeError(f"Jacobian adapter failed with exit code {result.returncode}")
    check_jacobian()


def check_jacobian():
    record = json.loads((ROOT / "jacobian/radial_result.json").read_text(encoding="utf-8"))
    payload = json.loads((ROOT / "jacobian/radial_payload.json").read_text(encoding="utf-8"))
    typed = record["typed_output"]
    output = typed["result"]["output"]
    if (
        record["adapter_exit_code"] != 0
        or typed["result"]["operation_id"] != "polynomial.ideal.normal_form.compute"
        or typed["request"]["payload"] != payload
        or output["request"] != payload
        or output["outcome"] != "COMPUTED"
        or output["in_ideal"] is not True
        or output["remainder"]["polynomial"]["terms"] != []
    ):
        raise ArithmeticError("Jacobian did not certify the exact requested zero remainder")
    print(json.dumps({
        "operation_id": typed["result"]["operation_id"],
        "server_version": typed["server"]["version"],
        "protocol_version": typed["protocol_version"],
        "outcome": output["outcome"],
        "in_ideal": output["in_ideal"],
        "adapter_exit_code": record["adapter_exit_code"],
    }))


def digest(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def build(replay=False):
    provenance = json.loads((ROOT / "source_provenance.json").read_text(encoding="utf-8"))
    published_root = ROOT / "published"
    port_root = ROOT / "ports"
    object_root = ROOT / "compiled"
    env = dict(os.environ)
    env["LEAN_PATH"] = os.pathsep.join(
        [str(object_root), env.get("LEAN_PATH", "")]
    )
    version = subprocess.run(
        [LAKE, "env", "lean", "--version"], cwd=WORKSPACE, env=env,
        capture_output=True, text=True, timeout=60, check=True,
    ).stdout.strip()
    if "version 4.31.0," not in version:
        raise RuntimeError(f"Wrong compiler: {version}")
    report_path = ROOT / "build_results.json"
    previous = json.loads(report_path.read_text()) if report_path.exists() else {}
    records = previous.get("modules", {}) if (
        previous.get("lean_version") == version
        and previous.get("compiler_options") == COMPILER_OPTIONS
    ) else {}
    report = {
        "lean_version": version,
        "compiler_options": COMPILER_OPTIONS,
        "modules": records,
        "complete": False,
    }
    failed = []
    blocked = []
    for module in provenance["topological_order"]:
        relative = module.replace(".", "/") + ".lean"
        source_root = port_root if (port_root / relative).exists() else published_root
        source = source_root / relative
        object_file = (object_root / relative).with_suffix(".olean")
        names = [name for name in provenance["imports"][module] if name.startswith("OAI.")]
        unavailable = [
            name for name in names
            if name in blocked or name not in records or records[name]["exit_code"] != 0
        ]
        if unavailable:
            blocked.append(module)
            continue
        dependencies = {
            name: records[name]["build_fingerprint"] for name in names
        }
        source_digest = digest(source)
        fingerprint = hashlib.sha256(json.dumps({
            "source_sha256": source_digest,
            "dependencies": dependencies,
            "lean_version": version,
            "compiler_options": COMPILER_OPTIONS,
        }, sort_keys=True).encode("utf-8")).hexdigest()
        old = records.get(module, {})
        if (
            not replay and old.get("exit_code", 0) != 0
            and old.get("build_fingerprint") == fingerprint
        ):
            failed.append(module)
            print(f"{module}: retaining unchanged compiler error", flush=True)
            continue
        if (
            not replay and old.get("exit_code") == 0
            and old.get("build_fingerprint") == fingerprint
            and object_file.exists() and old.get("olean_sha256") == digest(object_file)
        ):
            continue
        command = [
            LAKE, "env", "lean", *COMPILER_OPTIONS,
            "--root=" + str(source_root), "-o", str(object_file), str(source),
        ]
        object_file.parent.mkdir(parents=True, exist_ok=True)
        started = time.monotonic()
        result = subprocess.run(command, cwd=WORKSPACE, env=env, capture_output=True, text=True)
        elapsed = time.monotonic() - started
        log = ROOT / "build_logs" / (module + ".log")
        log.parent.mkdir(parents=True, exist_ok=True)
        log.write_text(result.stdout + result.stderr, encoding="utf-8")
        records[module] = {
            "source": str(source.relative_to(ROOT)),
            "source_sha256": source_digest,
            "dependencies": dependencies,
            "build_fingerprint": fingerprint,
            "object": str(object_file.relative_to(ROOT)),
            "exit_code": result.returncode,
            "elapsed_seconds": round(elapsed, 3),
            "log": str(log.relative_to(ROOT)),
        }
        if source_digest != digest(source):
            raise RuntimeError(f"Source changed during compilation: {module}")
        if result.returncode == 0:
            records[module]["olean_sha256"] = digest(object_file)
        write_json(report_path, report)
        print(f"{module}: exit={result.returncode}, seconds={elapsed:.3f}", flush=True)
        if result.returncode != 0:
            failed.append(module)
    report["failed_modules"] = failed
    report["blocked_modules"] = blocked
    if failed or blocked:
        write_json(report_path, report)
        raise RuntimeError(
            f"Source closure incomplete: {len(failed)} compiler errors and "
            f"{len(blocked)} blocked modules; see {report_path}"
        )
    report["complete"] = True
    write_json(report_path, report)
    print(json.dumps({"compiled_modules": len(records), "lean_version": version, "complete": True}))


def certify(replay=False):
    build(replay)
    env = dict(os.environ)
    env["LEAN_PATH"] = os.pathsep.join([
        str(ROOT / "compiled"), env.get("LEAN_PATH", "")
    ])
    project = ROOT.parent.parent
    command = [
        PYTHON, "-m", "argus_skill.verticals.math.lean_evidence", "verify",
        str(ROOT / "Main.lean"), "--statement-fidelity",
        str(ROOT / "STATEMENT_FIDELITY.md"), "--project-root", str(project),
        "--claim", "C9000158_MAIN",
    ]
    result = subprocess.run(
        command, cwd=project, env=env, capture_output=True, text=True,
    )
    (ROOT / "formal_runner.log").write_text(
        result.stdout + result.stderr, encoding="utf-8"
    )
    native = json.loads(result.stdout)
    write_json(ROOT / "formal_run.json", native)
    checks = {}
    for module in ("math_state", "proof_graph_check"):
        checked = subprocess.run(
            [PYTHON, "-m", f"argus_skill.verticals.math.{module}",
             "check", "--project-root", str(project)],
            cwd=project, capture_output=True, text=True,
        )
        checks[module] = {
            "exit_code": checked.returncode,
            "stdout": checked.stdout,
            "stderr": checked.stderr,
        }
    write_json(ROOT / "campaign_validation.json", {
        "project_root": str(project), "checks": checks,
    })
    if result.returncode != 0:
        raise RuntimeError(
            f"Native theorem verification failed with exit={result.returncode}; "
            f"see {ROOT / 'formal_runner.log'}"
        )
    if any(check["exit_code"] != 0 for check in checks.values()):
        raise RuntimeError("Campaign-local ledger or proof-graph check failed")
    if (
        native["status"] != "success" or native["exit_code"] != 0
        or native["proof_holes"] != [] or native["kernel"]["recorded"] is None
    ):
        raise ArithmeticError("The native run did not earn hole-free mechanical evidence")
    if (
        Path(native["lake_workspace"]).resolve() != WORKSPACE.resolve()
        or Path(native["cwd"]).resolve() != WORKSPACE.resolve()
        or Path(native["command"][0]).resolve() != Path(LAKE).resolve()
        or native["command"][1:3] != ["env", "lean"]
    ):
        raise ValueError("The native theorem run did not use the assigned Lake compiler")
    native_version = native["tools"]["lean"]["version"]
    if (
        native["tools"]["lean"]["available"] is not True
        or "version 4.31.0," not in native_version
    ):
        raise ValueError(f"Native theorem compiler is not Lean 4.31.0: {native_version}")
    name = "Audit9000158.no_unrestricted_five_coloring"
    match = re.search(
        "'" + re.escape(name) + r"' depends on axioms:\s*\[([^\]]*)\]",
        native["stdout"],
    )
    if match is None:
        raise ValueError("The compiler did not expose the named theorem's transitive axioms")
    axioms = [axiom.strip() for axiom in match.group(1).split(",") if axiom.strip()]
    if not set(axioms) <= {"propext", "Classical.choice", "Quot.sound"}:
        raise ArithmeticError(f"Non-foundational theorem axioms: {axioms}")
    if native["source_sha256"] != digest(ROOT / "Main.lean"):
        raise ValueError("The certificate is not about the current Main.lean")
    fidelity_digest = hashlib.sha256(
        (ROOT / "STATEMENT_FIDELITY.md").read_text(encoding="utf-8").encode("utf-8")
    ).hexdigest()
    if native["statement_fidelity_sha256"] != fidelity_digest:
        raise ValueError("The certificate is not paired with the current fidelity document")
    provenance = json.loads((ROOT / "source_provenance.json").read_text(encoding="utf-8"))
    for module in provenance["topological_order"]:
        source = ROOT / "published" / (module.replace(".", "/") + ".lean")
        content = source.read_bytes()
        blob = hashlib.sha1(
            b"blob " + str(len(content)).encode("ascii") + b"\0" + content
        ).hexdigest()
        if blob != provenance["records"][module]["git_blob"]:
            raise ValueError(f"The pinned original was modified: {module}")
    if replay:
        exact_algebra()
        check_jacobian()
    build_report = json.loads((ROOT / "build_results.json").read_text(encoding="utf-8"))
    for module, record in build_report["modules"].items():
        source = ROOT / record["source"]
        if (
            digest(source) != record["source_sha256"]
            or digest(ROOT / record["object"]) != record["olean_sha256"]
        ):
            raise ValueError(f"A compiled dependency changed: {module}")
    certificate = {
        "result_class": "formal_verification",
        "research_target_level": "publishable",
        "math_objective_mode": "exploratory",
        "claim": "C9000158_MAIN",
        "declaration": name,
        "statement": "No c : Complex -> Fin 5 separates every pair z,w with norm(z-w)=1; there are no additional hypotheses.",
        "unrestricted_main_certified": True,
        "publication_revision": provenance["revision"],
        "lean_version": build_report["lean_version"],
        "native_lean_version": native_version,
        "lake_workspace": native["lake_workspace"],
        "compiler_command": native["command"],
        "dependency_compiler_options": build_report["compiler_options"],
        "compiled_source_modules": len(build_report["modules"]),
        "transitive_axioms": axioms,
        "proof_holes": native["proof_holes"],
        "compiler_exit_code": native["exit_code"],
        "native_mechanical_evidence": native["kernel"]["recorded"],
        "source_sha256": native["source_sha256"],
        "statement_fidelity_sha256": native["statement_fidelity_sha256"],
        "project_root": str(project),
        "campaign_checks": {key: value["exit_code"] for key, value in checks.items()},
        "supporting_algebra": "algebra_certificate.json",
        "source_builds": "build_results.json",
        "compatibility_changes": "API_COMPATIBILITY.md",
        "independent_review": "pending",
        "novelty_status": "not_claimed",
        "significance_status": "pending_independent_review",
        "scope_limit": "This is a faithful formal verification of the published main statement, not a new geometric proof or certification of every separate prose lemma.",
    }
    write_json(ROOT / "exact_certificate.json", certificate)
    print(json.dumps({
        "claim": certificate["claim"],
        "compiler_exit_code": certificate["compiler_exit_code"],
        "proof_holes": certificate["proof_holes"],
        "transitive_axioms": axioms,
        "project_root": str(project),
        "campaign_checks": certificate["campaign_checks"],
        "independent_review": "pending",
    }))


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "operation", nargs="?", default="certify",
        choices=["algebra", "jacobian", "jacobian-check", "build", "certify"],
    )
    parser.add_argument("--replay", action="store_true", help="Compile all dependencies afresh")
    args = parser.parse_args()
    if args.operation == "algebra":
        exact_algebra()
    elif args.operation == "jacobian":
        run_jacobian()
    elif args.operation == "jacobian-check":
        check_jacobian()
    elif args.operation == "build":
        build(args.replay)
    else:
        certify(args.replay)


if __name__ == "__main__":
    main()
