#!/usr/bin/env python3
"""Replay exact adversarial instances and the parametric Lean certificate."""

import argparse
from fractions import Fraction
from functools import lru_cache
import itertools
import json
from pathlib import Path
import subprocess


ROOT = Path(__file__).resolve().parents[2]
HERE = Path(__file__).resolve().parent
ARGUS = "$WORKSPACE/argus-live-update/.venv/bin/python"


def require(condition, message):
    if not condition:
        raise AssertionError(message)


def inertia(matrix):
    a = [[Fraction(x) for x in row] for row in matrix]
    n = len(a)
    require(all(len(row) == n for row in a), "Matrix is not square")
    require(all(a[i][j] == a[j][i] for i in range(n) for j in range(n)),
            "Matrix is not symmetric")
    pos = neg = zero = 0
    while a:
        n = len(a)
        pivot = next((i for i in range(n) if a[i][i]), None)
        if pivot is not None:
            order = [pivot] + [i for i in range(n) if i != pivot]
            a = [[a[i][j] for j in order] for i in order]
            d = a[0][0]
            pos += d > 0
            neg += d < 0
            a = [[a[i][j] - a[i][0] * a[0][j] / d
                  for j in range(1, n)] for i in range(1, n)]
            continue
        edge = next(((i, j) for i in range(n) for j in range(i + 1, n)
                     if a[i][j]), None)
        if edge is None:
            zero += n
            break
        i, j = edge
        order = [i, j] + [k for k in range(n) if k not in (i, j)]
        a = [[a[i][j] for j in order] for i in order]
        d = a[0][1]
        pos += 1
        neg += 1
        a = [[a[i][j] - (a[i][0] * a[1][j] + a[i][1] * a[0][j]) / d
              for j in range(2, n)] for i in range(2, n)]
    return [pos, neg, zero]


def laminar(groups):
    return all(a <= b or b <= a or not a & b for a in groups for b in groups)


def families(n):
    return [
        [],
        sorted({frozenset(range(n)), frozenset(range(0, n, 2)),
                frozenset(range(1, n, 2)), frozenset({0})} - {frozenset()},
               key=lambda g: (len(g), sorted(g))),
        [frozenset(range(k)) for k in sorted({1, min(3, n), n})],
    ]


def marginal(caps, widths, groups, eta, reflect_factors=False):
    n = len(caps)
    full_caps = tuple(caps) + tuple(x for m in widths for x in (m, m))
    require(laminar(groups), "A generated family is not laminar")
    targets = tuple(sum(full_caps[i] for i in g) // 2 for g in groups)
    if reflect_factors:
        targets = tuple(sum(full_caps[i] for i in g) - t for g, t in zip(groups, targets))
    choices = tuple(itertools.product(*(range(m + 1) for m in widths)))

    @lru_cache(maxsize=None)
    def weight(old):
        if any(x < 0 or x > m for x, m in zip(old, caps)):
            return Fraction(0)
        answer = Fraction(0)
        for ks in choices:
            full = tuple(old) + tuple(v for k, m in zip(ks, widths) for v in (k, m - k))
            require(len(full) == len(full_caps), "Incorrect pair realization")
            require(sum(full) == sum(old) + sum(widths), "Incorrect total slice")
            exponent = sum(abs(sum(full[i] for i in g) - t)
                           for g, t in zip(groups, targets))
            answer += eta ** exponent
        return answer

    return weight


def removal_matrix(weight, z, sign=-1):
    n = len(z)
    matrix = []
    for i in range(n):
        row = []
        for j in range(n):
            v = list(z)
            v[i] += sign
            v[j] += sign
            row.append(weight(tuple(v)))
        matrix.append(row)
    return matrix


def exact_search():
    require(inertia([[0, 1], [1, 0]]) == [1, 1, 0], "Zero-pivot inertia replay failed")
    require(inertia([[1, 0], [0, 1]]) == [2, 0, 0], "Positive inertia replay failed")
    require(inertia([[0, 0], [0, 0]]) == [0, 0, 2], "Zero inertia replay failed")
    require(inertia([[1, 1], [1, 1]]) == [1, 0, 1], "Singular inertia replay failed")
    require(inertia([[-2, 0], [0, -3]]) == [0, 2, 0], "Negative inertia replay failed")
    widths_list = [(), (1,), (2,), (3,), (1, 1), (1, 3), (2, 2)]
    models = matrices = limiting_matrices = repeated_diagonals = zero_rows = 0
    max_positive = 0
    for n in range(1, 5):
        capacities = itertools.product(range(3), repeat=n) if n < 4 else [(2, 2, 2, 2)]
        for caps in capacities:
            for widths in widths_list:
                for groups in families(n + 2 * len(widths)):
                    for eta in (Fraction(1, 2), Fraction(0), Fraction(1)):
                        weight = marginal(caps, widths, groups, eta)
                        reflected = marginal(caps, widths, groups, eta, reflect_factors=True)
                        models += 1
                        for z in itertools.product(*(range(m + 1) for m in caps)):
                            for sign in (-1, 1):
                                q = removal_matrix(weight, z, sign)
                                signs = inertia(q)
                                require(signs[0] <= 1,
                                        f"Counterexample: {caps=}, {widths=}, {groups=}, "
                                        f"{eta=}, {z=}, {sign=}, {q=}, {signs=}")
                                max_positive = max(max_positive, signs[0])
                                matrices += 1
                                limiting_matrices += eta == 0
                                if sign == -1:
                                    for i in range(n):
                                        if z[i] < 2:
                                            require(q[i][i] == 0, "Invalid repeated removal retained")
                                            repeated_diagonals += 1
                                        if z[i] == 0:
                                            require(all(x == 0 for x in q[i]), "Zero display row retained")
                                            zero_rows += 1
                                zr = tuple(m - v for m, v in zip(caps, z))
                                qr = removal_matrix(reflected, zr, -sign)
                                require(q == qr, "Reflection changed an addition/removal matrix")
    return {
        "kind": "finite_adversarial_instantiations_not_a_universal_proof",
        "models": models,
        "matrices": matrices,
        "finite_equality_limit_matrices": limiting_matrices,
        "invalid_repeated_diagonal_checks": repeated_diagonals,
        "zero_row_checks": zero_rows,
        "full_factor_reflection_checks": matrices,
        "maximum_positive_inertia": max_positive,
        "pair_widths": [1, 2, 3],
        "maximum_summed_pairs": 2,
        "maximum_remaining_coordinates": 4,
        "arithmetic": "fractions.Fraction; exact 1x1/2x2 congruence pivots",
    }


def local_identities():
    tested = 0
    for a, b, c, gm, g, gp, q in itertools.product(range(-1, 3), repeat=7):
        s = b * g - a * gm
        t = c * gp - b * g
        vnv = q + 2 * g * (s - t) + (a - 2 * b + c) * g * g
        lhs = vnv - a * (g - gm) ** 2 - c * (g - gp) ** 2
        rhs = q + 2 * b * g * g - a * gm * gm - c * gp * gp
        require(lhs == rhs, "Local second-difference expansion is false")
        tested += 1
    for d in range(2, 21):
        a = [0] + [k * k + 1 for k in range(1, d)] + [0, 0]
        diff = [2 * a[k] - a[max(0, k - 1)] - a[k + 1] for k in range(d + 1)]
        require(sum(diff) == 0, "Unweighted endpoints failed")
        require(sum(k * (d - k) * diff[k] for k in range(1, d)) == 2 * sum(a),
                "Weighted endpoints failed")
    return {"integer_expansion_checks": tested, "endpoint_widths": [2, 20],
            "universal_versions": ["pair_one", "sum_second_difference", "parabola_identity"]}


def example_payload():
    caps, widths, z = (3, 3, 3), (1, 3), (2, 2, 1)
    groups = [frozenset({0, 3, 5}), frozenset({1, 4, 6}), frozenset({2})]
    q = removal_matrix(marginal(caps, widths, groups, Fraction(1, 2)), z)
    payload = {
        "dimension": 3,
        "entries": [{"row": i, "col": j, "value": {"num": str(q[i][j].numerator),
                                                "den": str(q[i][j].denominator)}}
                    for i in range(3) for j in range(i, 3)],
    }
    return payload, {"old_capacities": caps, "pair_widths": widths,
                     "display": z, "required_remaining_total": 3, "full_total": 7,
                     "groups": [sorted(g) for g in groups],
                     "factor": "psi_G(t) = (1/2)^abs(t - floor(sum_G capacities/2))",
                     "matrix": [[str(x) for x in row] for row in q], "inertia": inertia(q)}


def check_jacobian(payload, example):
    output = json.loads((HERE / "jacobian_result.json").read_text())
    status = json.loads((HERE / "jacobian_status.json").read_text())
    require(status["adapter_exit_code"] == 0 and not status["timed_out"] and
            status["adapter_error"] is None, "Jacobian operation did not succeed")
    require(output["request"]["operation_id"] == "matrix.inertia.compute",
            "Wrong Jacobian operation")
    require(output["request"]["payload"] == payload, "Wrong Jacobian payload")
    require(output["server"]["version"] == status["server_version"] and
            output["protocol_version"] == status["protocol_version"], "Adapter metadata mismatch")
    typed = output["result"]["output"]
    dense = [[Fraction(int(x["num"]), int(x["den"])) for x in row]
             for row in typed["matrix"]["entries"]]
    require(dense == [[Fraction(x) for x in row] for row in example["matrix"]],
            "Jacobian retained a different source matrix")
    require([typed["n_positive"], typed["n_negative"], typed["n_zero"]] ==
            example["inertia"], "Independent exact inertia computations disagree")
    return {"operation_id": "matrix.inertia.compute", "adapter_exit_code": 0,
            "typed_output": "jacobian_result.json", "payload": "jacobian_payload.json",
            "inertia": example["inertia"], "scope": "one finite instance, not the universal proof"}


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--exact-only", action="store_true",
                        help="Run the finite checks only; does not certify the universal theorem.")
    parser.add_argument("--write-certificate", action="store_true")
    parser.add_argument("--write-jacobian-payload", action="store_true")
    args = parser.parse_args()
    result = {
        "claim": "C_SIG_CORE",
        "result_class": "independent_formal_verification",
        "universal_evidence": {
            "source": "research/signature_core/Main.lean",
            "statement_fidelity": "research/signature_core/statement_fidelity.md",
            "theorems": ["integer_signature", "integer_addition_signature",
                         "pair_weighted", "limiting_signature", "no_positive_plane"],
            "required_lean_version": "4.31.0",
            "expected_exit_code": 0,
            "expected_proof_holes": [],
        },
        "scope": "Shared algebraic core only; no downstream algorithm or mathematical novelty claim.",
        "local_identities": local_identities(),
        "finite_search": exact_search(),
    }
    payload, example = example_payload()
    result["jacobian_instance"] = example
    result["jacobian_replay"] = check_jacobian(payload, example)
    if args.write_jacobian_payload:
        (HERE / "jacobian_payload.json").write_text(json.dumps(payload, indent=2) + "\n")
    certificate = HERE / "exact_certificate.json"
    if args.write_certificate:
        certificate.write_text(json.dumps(result, indent=2) + "\n")
    else:
        require(certificate.exists(), "Missing exact_certificate.json")
        require(json.loads(certificate.read_text()) == json.loads(json.dumps(result)),
                "Exact certificate differs from this replay")
    if not args.exact_only:
        command = [
            ARGUS, "-m", "argus_skill.verticals.math.lean_evidence", "verify",
            "research/signature_core/Main.lean",
            "--project-root", str(ROOT), "--claim", "C_SIG_CORE",
            "--artifact-dir", "research/signature_core",
            "--statement-fidelity", "research/signature_core/statement_fidelity.md",
            "--timeout", "115",
        ]
        compiled = subprocess.run(command, cwd=ROOT, text=True, capture_output=True, check=False)
        require(compiled.returncode == 0,
                "Lean verification failed:\n" + compiled.stdout + compiled.stderr)
        evidence = json.loads(compiled.stdout)
        require(evidence.get("exit_code") == 0 and evidence.get("proof_holes") == [],
                "Lean returned no complete zero-hole certificate: " + compiled.stdout)
        for module in ("math_state", "proof_graph_check"):
            checked = subprocess.run(
                [ARGUS, "-m", "argus_skill.verticals.math." + module,
                 "check", "--project-root", str(ROOT)],
                cwd=ROOT, text=True, capture_output=True, check=False)
            require(checked.returncode == 0, checked.stdout + checked.stderr)
        print(json.dumps({"universal_lean": "passed", "proof_holes": [],
                          "project_root": str(ROOT), "campaign_checks": [0, 0],
                          "finite_search": result["finite_search"]}, indent=2))
    else:
        print(json.dumps({"universal_lean": "not_run", **result["finite_search"]}, indent=2))


if __name__ == "__main__":
    main()
