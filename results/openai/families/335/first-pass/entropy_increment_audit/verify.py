#!/usr/bin/env python3
"""Replay exact entropy-algebra certificates; finite examples are not the proof."""

import argparse
import json
from math import factorial, isqrt
from pathlib import Path

import sympy as sp


ROOT = Path(__file__).resolve().parent
Q = sp.Rational


def require(condition, label):
    if not condition:
        raise AssertionError(label)


def polynomial_certificates():
    m, u, v, d, cp, theta = sp.symbols("m u v d cp theta", real=True)
    young_gap = cp * theta * (
        cp * (v**2 + theta * d**2) + m**2 * u**2 / (cp * theta)
        - m * u * (2 * v + d)
    )
    young_sos = (
        theta * (cp * v - m * u)**2
        + (cp * theta * d - m * u / 2)**2
        + (Q(3, 4) - theta) * (m * u)**2
    )
    require(sp.cancel(young_gap - young_sos) == 0, "universal Young SOS")

    s = sp.symbols("s", real=True)
    require(
        sp.expand((1 - s) * (1 + s)**2 - 1 - s * (1 - s - s**2)) == 0,
        "L-1 <= s polynomial reduction",
    )
    require(Q(1) - Q(1, 4) - Q(1, 4)**2 > 0, "stretching upper-bound domain")
    require(
        sp.expand(1 - (1 - s) * (1 + s / 2)**2 - s**2 * (3 + s) / 4) == 0,
        "L-1 >= s/2 polynomial reduction",
    )

    x, y = sp.symbols("x y", real=True)
    require(sp.expand((1-x)*(1-y) - (1-x-y) - x*y) == 0, "product induction")
    require(
        sp.expand(m**2 - 2*m*sp.Symbol("n")*sp.Symbol("l")
                  + sp.Symbol("n")**2*sp.Symbol("l")**2
                  - (m-sp.Symbol("n")*sp.Symbol("l"))**2) == 0,
        "critical square",
    )
    require(Q(4, 3)*Q(4, 3)*Q(7, 3) + 2 < 7, "BC constant 7")
    require(Q(1, 16) + Q(1, 4) <= 1, "weighted coefficient domination")
    require(16 * (Q(1, 8))**2 <= Q(1, 4), "critical variance absorption")
    require(
        sp.expand(36*(Q(5, 4)+x-1)**2-(1+Q(5, 4)+x) - (36*x*x+17*x)) == 0,
        "coarse r>=5/4 polynomial",
    )
    require(
        sp.expand(36*(1-(Q(3, 4)-x))**2-(1+Q(3, 4)-x)
                  - (36*x*x+19*x+Q(1, 2))) == 0,
        "coarse r<=3/4 polynomial",
    )

    z = sp.symbols("z", positive=True)
    potential = z - 1/z - 2*sp.log(z)
    require(
        sp.cancel(sp.diff(potential, z) - (z-1)**2/z**2) == 0,
        "global stretching derivative",
    )
    require(potential.subs(z, 1) == 0, "global stretching initial value")

    x = sp.symbols("x", real=True)
    exp_gap = sp.exp(-x) - (1-x+x**2/2-x**3/6)
    for order in range(4):
        require(sp.diff(exp_gap, x, order).subs(x, 0) == 0, "exponential initial jet")
    require(sp.diff(exp_gap, x, 4) == sp.exp(-x), "global exponential remainder")
    k = sp.symbols("k", positive=True)
    kappa = sp.symbols("kappa", positive=True)
    require(
        sp.limit((1-kappa/k)**k, k, sp.oo) == sp.exp(-kappa),
        "universal sharpness-family limit",
    )
    rank_one_coefficient = 1 - 1/(1+kappa) - kappa/(1+kappa)
    require(sp.cancel(rank_one_coefficient) == 0, "arbitrary-dimension inverse-update coefficient")
    log_gap = sp.log(1+x) - x + x**2/2
    require(sp.cancel(sp.diff(log_gap, x) - x**2/(1+x)) == 0, "log budget derivative")
    require(log_gap.subs(x, 0) == 0, "log budget initial value")
    stretch_gap = -sp.log(1-s) - s
    require(
        sp.cancel(sp.diff(stretch_gap, s) - s/(1-s)) == 0,
        "volume remainder integral",
    )
    return {
        "young_sos": "theta(cp|v|-mu)^2+(cp theta|d|-mu/2)^2+(3/4-theta)(mu)^2",
        "nonnegative_domain": "cp>0; 0<theta<=1/16; absolute values substituted for v,d",
        "bc_absolute_error_constant": 7,
        "sharp_T_error_constants": {"m_cubed": 14, "m_squared_r_defect": "1/2", "m_D_sigma": "3/2"},
        "calculus_certificates": [
            "d(L-L^-1-2log L)/dL=(L-1)^2/L^2, L>=1",
            "fourth derivative of exp(-x)-(1-x+x^2/2-x^3/6) is exp(-x)>0",
            "d(log(1+l)-l+l^2/2)/dl=l^2/(1+l)>=0",
            "d(-log(1-s)-s)/ds=s/(1-s)",
        ],
        "scope": "Exact symbolic identities plus the explicitly stated positivity/calculus argument in proof.md; not a kernel check of all matrix reasoning.",
    }


def sqrt_bounds(value):
    scale = 10**35
    floor = isqrt(int(value.p) * scale**2 // int(value.q))
    lo, hi = Q(floor, scale), Q(floor+1, scale)
    require(lo**2 <= value < hi**2, "rational square-root enclosure")
    return lo, hi


def log_stretch_bounds(L_squared):
    x = (L_squared-1)/(L_squared+1)
    require(0 <= x < 1, "logarithm series domain")
    terms = 7
    lo = sum((x**(2*j+1)/Q(2*j+1) for j in range(terms)), Q(0))
    tail = x**(2*terms+1)/(Q(2*terms+1)*(1-x*x))
    return lo, lo+tail


def exp_negative_upper(x):
    require(x >= 0, "exponential upper-bound domain")
    return sum(((-x)**j/Q(factorial(j)) for j in range(25)), Q(0))


def critical_constant(n, K, D, c, e):
    h = K*K+K+n
    raw = (
        K**3/(3*n*n)+16*K**4/(c*D*e)+4*D*D*K
        +5*K*K/6+Q(5*n, 8)+2*h*h/(c*e)+h*K/e+Q(5, 4)
    )
    return Q(4, 3)*raw


def full_parameters(n):
    c, e = Q(1, 4), Q(1, 32)
    m0 = min(Q(1, 4), e/16)
    eta = m0/(16*(n+m0))
    km = min(Q(1, 2), m0/(4*(n+m0)), c*e/(512*n), 3*eta**3/(64*n*n))
    kappa = min(1/(16+3/km+4/c), c*e/(576*m0))
    bn = 3/(8*(n+Q(1, 4)))
    K = max(Q(1), 12/bn)
    D = max(Q(1), 8*K/c)
    l0 = min(Q(1), 1/(16*D), 1/(4*K), bn*K/(16*D*D), kappa/(16*D*D))
    return c, e, m0, kappa, K, D, l0, max(Q(1), critical_constant(n, K, D, c, e))


def ordered_model(vectors):
    n = len(vectors[0])
    H = sp.eye(n)
    records = []
    determinant_product = Q(1)
    for values in vectors:
        q = sp.Matrix(values)
        old_inverse = H.inv()
        v = old_inverse*q
        k = (q.T*v)[0]
        s = k/(1+k)
        direction = v if k else sp.eye(n)[:, 0]
        unit_denominator = k if k else H[0, 0]
        B = 1 - direction.dot(direction)/unit_denominator
        new_H = H+q*q.T
        require(new_H.inv() == old_inverse-v*v.T/(1+k), "ordered inverse identity")
        require(new_H.det() == H.det()*(1+k), "ordered determinant identity")
        require(0 <= s < 1 and 0 <= B <= 1, "angle/earlier-loss admissibility")
        records.append({
            "q": q, "direction": direction, "unit": unit_denominator,
            "s": s, "B": B, "L2": 1+k,
        })
        H = new_H
        determinant_product *= 1+k
    final_inverse = H.inv()
    m = sum((row["s"] for row in records), Q(0))
    for i, row in enumerate(records):
        s = row["s"]
        row["C"] = 1-(row["q"].T*final_inverse*row["q"])[0]/s if s else Q(0)
        forward = sum(
            ((other["q"].dot(row["direction"]))**2/row["unit"]
             for other in records[:i]), Q(0)
        )
        require(forward == row["B"], "literal earlier telescope")
        if s:
            backward = sum(
                (other["s"]*(row["q"].dot(other["direction"]))**2/other["unit"]
                 for other in records[i+1:]), Q(0)
            )/s
            require(backward == row["C"], "literal later telescope")
        require(0 <= row["C"] <= 1, "later-loss admissibility")
    earlier = sum((row["s"]*row["B"] for row in records), Q(0))
    later = sum((row["s"]*row["C"] for row in records), Q(0))
    final_energy = sum(((row["q"].T*final_inverse*row["q"])[0] for row in records), Q(0))
    require(earlier == later == m-final_energy, "exact total-loss equality")
    require(final_energy == n-sp.trace(final_inverse), "final-energy trace")
    require(H.det() == determinant_product, "full ordered determinant")
    return n, records, m, H


def challenge(name, vectors, tiny_weight=False, critical=False, r_override=None):
    n, rows, m, H = ordered_model(vectors)
    count = len(rows)
    if tiny_weight:
        nu = [Q(1, 2**256)] + [(1-Q(1, 2**256))/Q(count-1)]*(count-1)
        p = [Q(1, 2)] + [Q(1, 2*(count-1))]*(count-1)
    else:
        nu = [Q(1, count)]*count
        p = nu[:]
    require(sum(nu) == sum(p) == 1 and min(nu) > 0, "probability admissibility")
    c_full, e_full, m0, kappa, K_full, D_full, l0, C_full = full_parameters(n)
    ell_full = l0/2
    eps = e_full
    r = r_override if r_override is not None else (Q(9, 8) if tiny_weight else Q(1))
    theta = D_full*ell_full
    if critical:
        ell, c, K, eps_star = Q(1, 1024**2), Q(1, 4), Q(4), Q(1, 32)
        D = Q(128)
        theta = D*ell
        require(m <= K*ell and D >= 8*K/c, "critical-regime admissibility")
    a, lam = Q(1, 2)+theta, Q(1, 2)-2*theta
    sigma = [p_i/nu_i for p_i, nu_i in zip(p, nu)]
    u = [row["s"]/(eps*nu_i) for row, nu_i in zip(rows, nu)]
    b = m/eps
    V = [a*(sig-1)+lam*(u_i-b) for sig, u_i in zip(sigma, u)]
    variance = sum((nu_i*(u_i-b)**2 for nu_i, u_i in zip(nu, u)), Q(0))
    EV2 = sum((nu_i*v_i*v_i for nu_i, v_i in zip(nu, V)), Q(0))
    M = a*(1-r)-b/2
    defect = sum((row["s"]*max(1-sig, Q(0)) for row, sig in zip(rows, sigma)), Q(0))
    require(sum(nu_i*u_i for nu_i, u_i in zip(nu, u)) == b, "probability mean u")
    require(sum(nu_i*sig for nu_i, sig in zip(nu, sigma)) == 1, "probability mean sigma")
    require(sum(nu_i*u_i*u_i for nu_i, u_i in zip(nu, u)) == b*b+variance, "second moment")
    require(all(r*nu_i < 4 for nu_i in nu), "interior bump values 0<f_i=sqrt(r nu_i)<2")
    for cp in [Q(1, 1000), Q(1, 8), Q(3)]:
        require(
            m*defect <= cp*eps*(EV2+theta*variance)
            + m*m*eps*(b*b+variance)/(cp*theta),
            "literal probability-defect bound",
        )
    T_lower = Q(0)
    W_upper = Q(0)
    global_defect_upper = Q(0)
    eta = max(1-r, Q(0))
    for i, row in enumerate(rows):
        Llo, Lhi = sqrt_bounds(row["L2"])
        _, W_hi = log_stretch_bounds(row["L2"])
        W_upper += W_hi
        row["Llo"], row["Lhi"] = Llo, Lhi
        T_lower += row["s"]*(
            row["C"]+4*a*a*sigma[i]*row["B"]
            +(Llo-1)*(2*a*(sigma[i]+r)+u[i])
        )
        global_defect_upper += row["s"]*(
            (row["B"]+Lhi-1)*max(1-sigma[i], Q(0)) + eta*(Lhi-1)
        )
    phi_upper = 2*(m-n+n*exp_negative_upper(m/n))
    require(T_lower+global_defect_upper >= phi_upper, "nonperturbative reserve challenge")
    if m <= Q(1, 4):
        trace_square = Q(0)
        for i, row in enumerate(rows):
            B_leading, C_leading = Q(0), Q(0)
            for j, other in enumerate(rows):
                xi = row["direction"].dot(other["direction"])**2 / (
                    row["direction"].dot(row["direction"])
                    *other["direction"].dot(other["direction"])
                )
                trace_square += row["s"]*other["s"]*xi
                if j < i:
                    B_leading += other["s"]*xi
                elif j > i:
                    C_leading += other["s"]*xi
            require(abs(row["B"]-B_leading) <= 7*m*m, "BC earlier expansion")
            if row["s"]:
                require(abs(row["C"]-C_leading) <= 7*m*m, "BC later expansion")
        require(trace_square >= m*m/n, "sharp dimension coefficient")
        require(
            T_lower >= trace_square-14*m**3-m*m*eta/2-Q(3, 2)*m*defect,
            "literal sharp-T inequality",
        )
        require(
            T_lower >= m*m/n-m**3/(3*n*n)-2*m*defect-m*m*eta,
            "scalar reserve consequence",
        )
    if critical:
        Ccrit = critical_constant(n, K, D, c, eps_star)
        q_lower = T_lower+c*eps*(M*M+EV2+theta*variance)-4*theta*theta*m-r*ell**3
        budget_upper = ell*m+2*ell*r*W_upper-n*r*ell*(ell-ell**2/2)
        require(q_lower >= budget_upper-Ccrit*r*ell**3, "explicit critical entropy budget")
    else:
        reserve = T_lower+c_full*eps*(M*M+EV2+theta*variance)
        q_lower = reserve-4*theta*theta*m-r*ell_full**3
        budget_upper = ell_full*m+2*ell_full*r*W_upper-n*r*ell_full*(ell_full-ell_full**2/2)
        coarse = m >= m0 or abs(1-r) >= Q(1, 4)
        surplus = reserve/4 if coarse else Q(0)
        require(q_lower >= budget_upper-C_full*r*ell_full**3+surplus, "all-regime entropy budget")
        if coarse:
            require(reserve >= kappa*(m+r*W_upper), "coarse reserve coercivity")
    return {
        "name": name, "dimension": n, "coordinates": count,
        "small_regime": bool(m <= Q(1, 4)), "critical_regime": critical,
        "tiny_weight": tiny_weight, "r": str(r), "all_exact_assertions_passed": True,
    }


def verify_jacobian():
    metadata = json.loads((ROOT/"jacobian_operation.json").read_text())
    payload = json.loads((ROOT/"jacobian_payload.json").read_text())
    result = json.loads((ROOT/"jacobian_result.json").read_text())
    require(result["request"]["payload"] == payload, "archived exact Jacobian payload")
    require(result["server"]["version"] == metadata["server"]["version"], "Jacobian server version")
    require(result["protocol_version"] == metadata["protocol_version"], "Jacobian protocol")
    require(result["result"]["operation_id"] == metadata["selected_operation"], "Jacobian operation id")
    entries = [[Q(item["num"])/Q(item["den"]) for item in row] for row in payload["matrix"]["entries"]]
    expected = sp.Matrix(entries).det()
    typed = result["result"]["output"]["determinant"]
    require(expected == Q(typed["num"])/Q(typed["den"]) == Q(1050601, 1000000), "independent determinant replay")
    require(result["result"]["output"]["method"] == "FRACTION_FREE_BAREISS", "Jacobian method")
    return {
        "operation_id": metadata["selected_operation"],
        "server_version": metadata["server"]["version"],
        "protocol_version": metadata["protocol_version"],
        "adapter_exit_code": 0, "adapter_error": None, "timeout": False,
        "exact_output": typed, "replay_passed": True,
    }


def verify_lean_record():
    result = json.loads((ROOT/"lean_verify_result.json").read_text())
    require(result["status"] == "success" and result["exit_code"] == 0, "real Lean success")
    require(result["proof_holes"] == [], "zero Lean proof holes")
    record = result["kernel"]["recorded"]
    require(record is not None and record["tier"] == "mechanical", "claim-bound mechanical record")
    require(record["verdict"] == "supports", "formal support verdict")
    require(record["produced_by"] == "lean_evidence/lean 4.31.0", "required Lean version")
    artifact = record["artifact"]
    require(
        artifact.startswith("research/entropy_increment_audit/certificates/"),
        "formal certificate stays inside the owned directory",
    )
    archive = json.loads((ROOT.parent.parent/artifact).read_text())
    require(archive["lean_source"]["text"] == (ROOT/"Main.lean").read_text(), "compiled source text remains current")
    require(
        archive["statement_fidelity"]["text"] == (ROOT/"statement_fidelity.md").read_text(),
        "compiled fidelity text remains current",
    )
    require(archive["lean_check"]["exit_code"] == 0, "archived compiler success")
    require(archive["lean_check"]["proof_holes"] == [], "archived zero proof holes")
    require(record["subject"]["subject_id"] == "C_LEAN_WEIGHTED_DEFECT", "formal claim identity")
    return {
        "claim": "C_LEAN_WEIGHTED_DEFECT", "version": "4.31.0",
        "exit_code": 0, "proof_holes": [], "certificate": artifact,
        "source_and_fidelity_match_archive": True,
        "statement_fidelity_independent_review": "pending",
        "scope": "Arbitrary-finite-type weighted probability defect, not the matrix or scalar-curvature theorem.",
    }


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--write-certificate", action="store_true")
    args = parser.parse_args()
    symbolic = polynomial_certificates()
    jacobian = verify_jacobian()
    lean = verify_lean_record()
    v = Q(1, 10)
    noncommuting = [(v, 0, 0), (v, v, 0), (0, v, v)]
    require(
        sp.Matrix(noncommuting[0])*sp.Matrix(noncommuting[0]).T
        *sp.Matrix(noncommuting[1])*sp.Matrix(noncommuting[1]).T
        != sp.Matrix(noncommuting[1])*sp.Matrix(noncommuting[1]).T
        *sp.Matrix(noncommuting[0])*sp.Matrix(noncommuting[0]).T,
        "noncommuting stress is genuinely noncommuting",
    )
    models = [
        ("noncommuting", noncommuting, False, False, None),
        ("reverse_order", list(reversed(noncommuting)), False, False, None),
        ("tiny_probability_unbounded_sigma", noncommuting, True, False, None),
        ("zero_updates", [(0, 0, 0), *noncommuting, (0, 0, 0)], False, False, None),
        ("257_ordered_coordinates", [(Q(1, 100), 0, 0)]*257, True, False, None),
        ("large_angles", [(Q(3, 4), 0, 0), (1, 1, 0), (0, 1, 2)], True, False, None),
        ("small_r", noncommuting, False, False, Q(1, 16)),
        ("large_r", noncommuting, False, False, Q(8)),
        ("critical_near_equality", [(Q(1, 1024), 0, 0), (0, Q(1, 1024), 0), (0, 0, Q(1, 1024))], False, True, None),
    ]
    examples = [challenge(name, vectors, tiny, critical, r) for name, vectors, tiny, critical, r in models]
    certificate = {
        "claim": "C_ENTROPY_ALGEBRA",
        "result_type": "quantified_verification_theorem",
        "theorem": "Exact ordered total-loss equality, uniform BC/sharp-T/weighted-defect estimates, and an explicit all-regime entropy budget with coarse-region surplus; see proof.md Sections 1-6.",
        "nonperturbative_generalization": "T_0 >= 2[m-n(1-exp(-m/n))] minus the explicit sigma and r defects in proof.md (3.1), for arbitrary finite ordered positive rank-one updates.",
        "universal_symbolic_certificates": symbolic,
        "jacobian": jacobian,
        "lean": lean,
        "finite_exact_challenges": examples,
        "finite_challenge_scope": "Deterministic fidelity/adversarial tests only; not an exhaustion proof or a proof for arbitrary cardinality.",
        "probability_stress": {"smallest_test_weight": "1/2^256", "largest_test_sigma": "2^255", "uniform_weight_lower_bound_assumed": False},
        "analytic_dependencies": [
            "The implication to a constructed entropy increment assumes manuscript prop:sweep, including coefficient one on T_0 and a coordinate-independent positive square coefficient.",
            "Analytic graph construction, global iteration, regular descendants, and transfer remain separate open manuscript dependencies. Noncritical/coarse algebra is proved in proof.md Section 6.",
        ],
        "lean_scope": "Main.lean formalizes the arbitrary-finite-type weighted probability defect only; compiler evidence is archived separately and is not a matrix or scalar-curvature certification.",
        "false_manuscript_assertions_identified": [],
        "main_scalar_curvature_inequality": "neither verified nor refuted",
        "independent_review": "pending_host_invocation",
        "novelty_status": "not_established",
        "significance_status": "pending_independent_review",
    }
    text = json.dumps(certificate, indent=2, sort_keys=True)+"\n"
    path = ROOT/"exact_certificate.json"
    if args.write_certificate:
        path.write_text(text)
    else:
        require(path.is_file(), "missing exact_certificate.json; first run with --write-certificate")
        require(json.loads(path.read_text()) == certificate, "persistent certificate equals replay")
    print(json.dumps({
        "status": "passed", "finite_exact_challenges": len(examples),
        "symbolic_certificates": "passed", "jacobian_replay": "passed", "lean_record": "current",
        "certificate": str(path), "independent_review": "pending",
    }, sort_keys=True))


if __name__ == "__main__":
    main()
