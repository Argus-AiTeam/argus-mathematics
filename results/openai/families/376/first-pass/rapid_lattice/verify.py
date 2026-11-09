#!/usr/bin/env python3
"""Replay exact experiments, symbolic identities, and source-bound Lean evidence."""

import argparse
import hashlib
import itertools
import json
from fractions import Fraction
from pathlib import Path

import sympy as sp


HERE = Path(__file__).resolve().parent
ROOT = HERE.parent.parent
FORMAL_ARCHIVE = HERE / "certificates/V_RAPID_LATTICE_CORE-75bd1c2c7438128c.json"


def require(condition, message):
    if not condition:
        raise ValueError(message)


def read_json(path):
    return json.loads(path.read_text(encoding="utf-8"))


def pack(b, d, left, right, state):
    return left + b**d * right + b ** (2 * d) * state


def decode(j, b, d):
    c = j % b ** (2 * d + 1)
    B = b**d
    return c % B, c // B % B, c // (B * B)


def literal_transition(j, b, d, valid, action):
    L, R, s = decode(j, b, d)
    l, a = L % b, R % b
    h = int(s == 0)
    if s not in valid or s == 0 or a not in valid:
        return 0, h
    next_state, written, move = action
    if move == 1:
        outL, outR = written + b * L, (R - a) // b
    elif move == -1:
        outL, outR = (L - l) // b, l + b * written + b * (R - a)
    else:
        outL, outR = L, R - a + written
    require(0 <= outL < b ** (d + 1), "left stack range")
    require(0 <= outR < b ** (d + 1), "right stack range")
    return pack(b, d + 2, outL, outR, next_state), h


def digit_list(value, b, d):
    return [(value // b**i) % b for i in range(d)]


def from_digits(digits, b):
    return sum(a * b**i for i, a in enumerate(digits))


def reference_transition(c, b, d, valid, action):
    L, R, s = decode(c, b, d)
    left, right = digit_list(L, b, d), digit_list(R, b, d)
    if s not in valid or s == 0 or right[0] not in valid:
        return 0
    next_state, written, move = action
    if move == 1:
        new_left, new_right = [written] + left, right[1:]
    elif move == -1:
        new_left, new_right = left[1:], [left[0], written] + right[1:]
    else:
        new_left, new_right = left, [written] + right[1:]
    return pack(b, d + 2, from_digits(new_left, b), from_digits(new_right, b),
                next_state)


def full_address_experiments():
    rows = []
    for b, d in ((2, 1), (2, 2), (2, 3), (3, 1), (3, 2), (4, 1), (4, 2)):
        valid = tuple(range(b if b == 2 else b - 1))
        P, nextP = b ** (2 * d + 1), b ** (2 * (d + 2) + 1)
        counts = dict(cases=0, periodic_replays=0, invalid_state=0,
                      invalid_scanned=0, active_remote_padding=0,
                      halting_with_invalid_scanned=0)
        for action in itertools.product(valid, valid, (-1, 0, 1)):
            for c in range(P):
                output, h = literal_transition(c, b, d, valid, action)
                expected = reference_transition(c, b, d, valid, action)
                require(output == expected, f"tape mismatch: {(b, d, c, action)}")
                require(0 <= output < nextP, "totalized output range")
                L, R, s = decode(c, b, d)
                require(h == int(s == 0), "halting predicate")
                counts["cases"] += 1
                counts["invalid_state"] += int(s not in valid)
                counts["invalid_scanned"] += int(R % b not in valid)
                counts["halting_with_invalid_scanned"] += int(s == 0 and R % b not in valid)
                remote = digit_list(L, b, d) + digit_list(R, b, d)[1:]
                counts["active_remote_padding"] += int(
                    s in valid and s != 0 and R % b in valid
                    and any(a not in valid for a in remote))
                for shift in (-2, -1, 0, 1, 2):
                    require(literal_transition(c + shift * P, b, d, valid, action)
                            == (output, h), "integer-address periodicity")
                    counts["periodic_replays"] += 1
        if b > 2 and d > 1:
            require(counts["active_remote_padding"] > 0, "remote padding not exercised")
            require(counts["halting_with_invalid_scanned"] > 0, "halting padding omitted")
        rows.append(dict(base=b, width=d, **counts))
    require(literal_transition(pack(2, 2, 0, 2, 1), 2, 2, (0, 1), (1, 0, -1))[0]
            != pack(2, 4, 0, 2, 1), "left-move test failed to distinguish one shift")
    return rows


def scale_experiments():
    rows = []
    for p0 in (3, 5, 11):
        schedules = {"published": [(p0 + 10) << (n * (n + 1)) for n in range(66)]}
        for name in ("factorial", "logarithmic_ratio", "doubling"):
            K = [p0 + 10]
            for n in range(65):
                ratio = {"factorial": n + 2,
                         "logarithmic_ratio": 2 + (n + 1).bit_length() - 1,
                         "doubling": 2}[name]
                K.append(ratio * K[-1])
            schedules[name] = K
        for name, K in schedules.items():
            history_cases = derivative_cases = 0
            for n in range(65):
                p, nextp = p0 + 4 * n, p0 + 4 * (n + 1)
                require(K[n] >= p + 10, "linear exponent reserve")
                require(K[n + 1] >= 2 * K[n], "doubling")
                require(K[n + 1] - nextp >= K[n] + 6, "selector plateau reserve")
                for i in range(n):
                    require(K[n] - K[i] >= p + 6, "old-record divisibility")
                for b in (2, 3, 5):
                    modulus = b**p
                    require(pow(b, K[n], modulus) == 0, "torus seam divisibility")
                    for m in (-7, 0, 9):
                        c = lambda i: (-1)**i * (i + 3)**2
                        residue = c(n) + m * pow(b, K[n], modulus)
                        residue += sum(c(i) * pow(b, K[n] - K[i], modulus)
                                       for i in range(n))
                        require(residue % modulus == c(n) % modulus, "history residue")
                        history_cases += 1
                for k in range(13):
                    if K[n + 1] >= (k + 2) * K[n]:
                        require(K[n + 1] - nextp - k * K[n] >= K[n] + 6,
                                "arbitrary-order exponent margin")
                        derivative_cases += 1
                if name == "published":
                    require(K[n + 1] == (1 << (2 * n + 2)) * K[n],
                            "published recurrence")
                if name == "doubling":
                    require(nextp - 1 - K[n + 1] + 2 * K[n] == nextp - 1,
                            "stationary-table second-derivative lower exponent")
            rows.append(dict(p0=p0, schedule=name, slots=65,
                             history_cases=history_cases,
                             derivative_margin_cases=derivative_cases))
    return rows


def seam_experiments():
    b, d, K = 2, 1, 13
    inv, P = b**K, b ** (2 * d + 1)
    points = [Fraction(0), Fraction(1), Fraction(1, 2)]
    points += [Fraction(1, 2) + q / inv for q in
               (Fraction(-3, 8), Fraction(-1, 4), Fraction(1, 4), Fraction(3, 8))]
    for y in points:
        support = []
        for lift in (-2, -1, 0, 1, 2):
            u = (y + lift - Fraction(1, 2)) * inv
            centers = [(j % P, u - j) for j in range(u.__floor__() - 1, u.__floor__() + 2)
                       if abs(u - j) < Fraction(3, 8)]
            require(len(centers) <= 1, "overlapping selector supports")
            support.append(centers)
        require(all(s == support[0] for s in support), "torus selector seam")
    return dict(base=b, width=d, exponent=K, exact_points=len(points), lifts_per_point=5)


def path_experiments():
    b, d, p0 = 2, 2, 5
    epsilon = Fraction(1, b ** (p0 + 10))
    next_epsilon = Fraction(1, b ** (4 * (p0 + 10)))
    beta, gamma = Fraction(1, 4), next_epsilon
    pulse_values = (Fraction(0), Fraction(1, 3), Fraction(1, 2),
                    Fraction(2, 3), Fraction(1))
    cases = 0
    for L, R, action in itertools.product(range(b**d), range(b**d),
                                          itertools.product((0, 1), (0, 1), (-1, 0, 1))):
        F, h = literal_transition(pack(b, d, L, R, 1), b, d, (0, 1), action)
        require(h == 0, "nonhalting current state read as halting")
        for s in pulse_values:
            displacement = s * next_epsilon * F
            require(0 <= displacement < epsilon / 4, "writing leaves its selector")
            x = Fraction(1, 2) - beta + s * (beta - gamma)
            require(Fraction(1, 4) <= x < Fraction(1, 2), "false all-time sample detection")
            cases += 1
    halted = pack(b, d, 0, 1, 0)
    F, h = literal_transition(halted, b, d, (0, 1), (1, 0, 0))
    require((F, h) == (0, 1), "initially halted input not recognized")
    endpoint = Fraction(1, 4) + beta - gamma + 2 * gamma
    require(endpoint == Fraction(1, 2) + gamma and endpoint < 1,
            "exceptional beta_0 or first halting endpoint is wrong")
    return dict(nonhalting_segment_samples=cases, pulse_values=len(pulse_values),
                initially_halted=True, first_slot_beta="1/4",
                universal_segment_proof="RapidLattice.nonhalting_all_times and plateau_persistence")


def symbolic_identities():
    t, x, y, z, nu = sp.symbols("t x y z nu")
    v = [sp.Function("v1")(t, x, y), sp.Function("v2")(t, x, y)]
    eta = sp.Function("eta")(z)
    divv = sp.diff(v[0], x) + sp.diff(v[1], y)
    U = [sp.diff(eta, z) * v[0], sp.diff(eta, z) * v[1], -eta * divv]
    coords = (x, y, z)
    checks = {"lift_divergence": sum(sp.diff(a, q) for a, q in zip(U, coords))}
    for i in range(3):
        checks[f"convection_as_divergence_{i}"] = sum(
            U[j] * sp.diff(U[i], coords[j]) - sp.diff(U[i] * U[j], coords[j])
            for j in range(3))
    phi = sp.Function("phi")(t, x, y, z)
    gsym = [sp.Function(f"g{i}")(t, x, y, z) for i in range(3)]
    for i, q in enumerate(coords):
        checks[f"pressure_sign_{i}"] = -sp.diff(-phi, q) + gsym[i] - sp.diff(phi, q) - gsym[i]
    beta, gamma, sigma = sp.symbols("beta gamma sigma")
    checks["nonhalting_convex_distance"] = beta - sigma * (beta - gamma) - (
        (1 - sigma) * beta + sigma * gamma)
    checks["halting_endpoint"] = -beta + beta - gamma + 2 * gamma - gamma
    k1, k2, k3 = sp.symbols("k1 k2 k3", real=True)
    G1, G2, G3 = sp.symbols("G1 G2 G3")
    wave, G = (k1, k2, k3), (G1, G2, G3)
    norm2, dot = sum(k*k for k in wave), sum(k*a for k, a in zip(wave, G))
    phihat = -sp.I * dot / (2 * sp.pi * norm2)
    checks["fourier_poisson_sign"] = -4 * sp.pi**2 * norm2 * phihat - 2 * sp.pi * sp.I * dot
    checks["fourier_solenoidal_projection"] = sum(
        k * (a - 2 * sp.pi * sp.I * k * phihat) for k, a in zip(wave, G))
    for name, expression in checks.items():
        require(sp.simplify(expression) == 0, f"symbolic identity failed: {name}")
    residual = [sp.diff(a, t) + sum(U[j] * sp.diff(a, coords[j]) for j in range(3))
                - nu * sum(sp.diff(a, q, 2) for q in coords) for a in U]
    budgets = []
    for order in range(3):
        for time_order in range(2):
            derivatives = set().union(*(sp.diff(a, y, order, t, time_order).atoms(sp.Derivative)
                                        for a in residual))
            jets = [a for a in derivatives if a.expr in v]
            spatial = max(sum(n for q, n in a.variable_count if q in (x, y)) for a in jets)
            temporal = max(sum(n for q, n in a.variable_count if q == t) for a in jets)
            require(spatial <= order + 3, "lost lift/viscous spatial derivative")
            require(temporal <= time_order + 1, "lost residual time derivative")
            budgets.append(dict(spatial_order=order, time_order=time_order,
                                max_planar_order=int(spatial), max_time_order=int(temporal)))
    return dict(zero_residuals=sorted(checks), derivative_budget_experiments=budgets,
                fourier_domain="nonzero wave vector; the mean mode is treated separately")


def jacobian_evidence():
    payload = read_json(HERE / "jacobian_payload.json")
    result = read_json(HERE / "jacobian_output.json")
    status = read_json(HERE / "jacobian_status.json")
    operation = "matrix.symbolic.multiply.compute"
    require(status == dict(adapter_exit_code=0, operation_id=operation), "adapter failure")
    require(not (HERE / "jacobian_stderr.txt").read_text(), "adapter stderr is not empty")
    require(result["request"] == dict(operation_id=operation, payload=payload),
            "Jacobian output is bound to another payload")
    require(result["result"]["operation_id"] == operation, "wrong operation result")
    variables = ("eta_prime", "v1_x", "v2_y")
    symbols = sp.symbols(" ".join(variables))

    def rational_function(entry):
        require(entry["variables"] == list(variables), "wrong variable order")

        def polynomial(poly):
            return sum(sp.Rational(term["coefficient"]["num"], term["coefficient"]["den"])
                       * sp.prod(s**e for s, e in zip(symbols, term["exponents"], strict=True))
                       for term in poly["terms"])

        denominator = polynomial(entry["denominator"])
        require(denominator != 0, "zero rational-function denominator")
        return sp.cancel(polynomial(entry["numerator"]) / denominator)

    def matrix(data):
        require(data["variables"] == list(variables), "wrong matrix field")
        return sp.Matrix([[rational_function(e) for e in row] for row in data["entries"]])

    a, vx, vy = symbols
    left, right = matrix(payload["left"]), matrix(payload["right"])
    require(left == sp.Matrix([[a, a, -a]]) and right == sp.Matrix([vx, vy, vx + vy]),
            "payload no longer represents lift divergence")
    output = matrix(result["result"]["output"])
    product = (left * right).applyfunc(sp.cancel)
    require(output == product == sp.zeros(1, 1), "Jacobian exact replay mismatch")
    require(result["server"]["version"] == "0.14.0", "unreviewed Jacobian server version")
    require(result["protocol_version"] == "2025-11-25", "unreviewed protocol version")
    return dict(operation_id=operation, adapter_exit_code=0, transport=result["transport"],
                server_version=result["server"]["version"],
                protocol_version=result["protocol_version"], exact_product=[[0]])


def formal_evidence():
    archive = read_json(FORMAL_ARCHIVE)
    result = archive["lean_check"]
    source = (HERE / "Main.lean").read_text(encoding="utf-8")
    fidelity = (HERE / "statement_fidelity.md").read_text(encoding="utf-8")
    require(archive["lean_source"]["text"] == source, "archived Lean source is stale")
    require(archive["statement_fidelity"]["text"] == fidelity, "archived fidelity is stale")
    require(result["source_sha256"] == hashlib.sha256(source.encode()).hexdigest(),
            "Lean source digest mismatch")
    require(result["statement_fidelity_sha256"] == hashlib.sha256(fidelity.encode()).hexdigest(),
            "statement-fidelity digest mismatch")
    require(result["status"] == "success" and result["exit_code"] == 0
            and result["proof_holes"] == [] and result["audit_exit_code"] == 0,
            "Lean proof has not passed the real compiler and axiom audit")
    require(result["environment_failure"] == "", "Lean environment was unverified")
    require("version 4.31.0," in result["tools"]["lean"]["version"], "wrong Lean release")
    require(archive["tier"] == "mechanical" and archive["verdict"] == "supports",
            "not a mechanical support record")
    claim_id = "V_RAPID_LATTICE_CORE"
    versions = [c for c in read_json(ROOT / "research/MATH_STATE.json")["claims"]
                if c["claim_id"] == claim_id]
    require(len(versions) > 0, "missing formal claim")
    latest = max(c["version"] for c in versions)
    claims = [c for c in versions if c["version"] == latest]
    require(len(claims) == 1, "ambiguous current formal claim version")
    require(archive["subject"]["subject_id"] == claim_id
            and archive["subject"]["content_hash"] == claims[0]["content_hash"],
            "compiler evidence concerns a superseded claim")
    require(claims[0]["formal_statement"] == source, "ledger formalization differs from source")
    return dict(claim=claim_id, archive=str(FORMAL_ARCHIVE.relative_to(ROOT)),
                lean_version="4.31.0", exit_code=0, proof_holes=[], axiom_audit_exit_code=0,
                source_sha256=result["source_sha256"],
                statement_fidelity_sha256=result["statement_fidelity_sha256"])


def evidence():
    formal = formal_evidence()
    jacobian = jacobian_evidence()
    return dict(
        schema_version=1,
        result_class="new_theorem",
        classification="universal arithmetic verification and analytic scale-ratio theorem",
        independent_review="pending_host_reviewer",
        novelty_status="not_certified_by_bounded_retrieval",
        manuscript_refutation_found=False,
        theorem="For doubling integer-exponent schedules, all-order rapid decay for every "
                "finite table is equivalent to K_(n+1)/K_n tending to infinity.",
        scope="Fixed unit pulses and full spatial domain; necessity is for every-table "
              "validity, not every individual table. Effective constants require an "
              "effective divergence modulus. Analytic steps are proved in report.md.",
        finite_experiments=dict(full_addresses=full_address_experiments(),
                                scales=scale_experiments(), seams=seam_experiments(),
                                paths=path_experiments()),
        symbolic=symbolic_identities(), jacobian=jacobian, lean=formal)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--write-certificate", action="store_true")
    args = parser.parse_args()
    actual = evidence()
    target = HERE / "exact_certificate.json"
    if args.write_certificate:
        target.write_text(json.dumps(actual, indent=2, sort_keys=True) + "\n", encoding="utf-8")
    expected = json.dumps(read_json(target), sort_keys=True, allow_nan=False)
    observed = json.dumps(actual, sort_keys=True, allow_nan=False)
    require(expected == observed, "exact_certificate.json is inconsistent with replay")
    print(json.dumps(dict(ok=True, result_class=actual["result_class"],
                          lean_exit=0, proof_holes=[], independent_review="pending")))


if __name__ == "__main__":
    main()
