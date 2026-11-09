#!/usr/bin/env python3
"""Exact replay; the all-depth proof is Main.lean plus proof.md, not enumeration."""

import hashlib
import json
from fractions import Fraction as Q
from pathlib import Path


HERE = Path(__file__).resolve().parent
ROOT = HERE.parent.parent


def require(condition, message):
    if not condition:
        raise AssertionError(message)


def load(name):
    return json.loads((HERE / name).read_text())


def product(values):
    result = Q(1)
    for value in values:
        result *= value
    return result


def source_binding(certificate):
    source = ROOT / certificate["source_directory"]
    fragments = {
        "08-hierarchy.tex": [
            r"d(i)=d(0)G^{-i}",
            r"d_T\le d(i)/B^2",
            r"\label{hier:stopping-levels}",
            r"k_s\le k_{T(s)}",
            r"\dist(v,v')<G^{-1/4}d(i)",
            r"\left(\frac{n_{v_i(T)}}{m_{v_{i+1}(T)}}\right)^{\mu/K}",
        ],
        "11-assembly.tex": [
            r"\begin{lemma}[Expected boundary loss]\label{assembly:boundary-loss}",
            r"\E_\vartheta\|P_q(z)-\mathcal W_\vartheta(z)\|",
            r"\le L^C\epsilon n(z)",
            r"\label{assembly:one-boundary-loss}",
            r"\label{assembly:mass-inclusion}",
            r"\label{assembly:boundary-telescope}",
            r"\label{assembly:total-boundary-loss}",
            "independent translations at different",
        ],
        "05-concentration.tex": [
            r"\begin{equation}\label{eq:src-11}",
            r"\begin{equation}\label{eq:src-12}",
            "with $h_T$ in place of $h_T^{(1)}$",
        ],
    }
    for filename, required in fragments.items():
        text = (source / filename).read_text()
        for fragment in required:
            require(fragment in text, f"source binding changed: {filename}: {fragment}")
    return sum(map(len, fragments.values()))


def formal_receipt(certificate):
    formal = certificate["formal_core"]
    receipt = load(formal["compiler_result"])
    require(receipt["status"] == "success", "Lean compiler did not succeed")
    require(receipt["exit_code"] == 0, "nonzero Lean exit code")
    require(receipt["proof_holes"] == [], "Lean proof holes")
    source = (HERE / formal["source"]).read_bytes()
    fidelity = (HERE / formal["statement_fidelity"]).read_text().encode()
    require(hashlib.sha256(source).hexdigest() == receipt["source_sha256"],
            "Lean source changed since its real compiler run")
    require(hashlib.sha256(fidelity).hexdigest() == receipt["statement_fidelity_sha256"],
            "statement fidelity changed since its real compiler run")
    ledger = json.loads((ROOT / "research/MATH_STATE.json").read_text())
    claim = max((c for c in ledger["claims"] if c["claim_id"] == formal["claim"]),
                key=lambda c: c["version"])
    require(claim["formal_statement"].strip() == source.decode().strip(),
            "ledger formalization differs from the compiled source")
    recorded = load("lean_verification.json")["kernel"]["recorded"]
    require(recorded["verdict"] == "supports" and recorded["tier"] == "mechanical",
            "missing official mechanical evidence")
    require(formal["expected_version"] in recorded["produced_by"], "wrong Lean version")
    archive = json.loads((ROOT / recorded["artifact"]).read_text())
    require(archive, "empty official certificate archive")
    return {"exit_code": 0, "proof_holes": [], "version": formal["expected_version"]}


def finite_algebra(tests):
    telescopes = 0
    for k in range(tests["max_telescope_depth"] + 1):
        for r in range(tests["max_telescope_offset"] + 1):
            coefficients = [0] * k
            for i in range(k):
                coefficients[i] += 1
                if i + r < k:
                    coefficients[i + r] -= 1
            require(coefficients == [int(j < min(r, k)) for j in range(k)],
                    f"stopped telescope at k={k}, r={r}")
            telescopes += 1
    layers = 0
    for q_text in tests["geometric_ratios"]:
        q = Q(q_text)
        require(0 <= q < 1, "geometric ratio outside theorem hypotheses")
        for k in range(tests["max_geometric_depth"] + 1):
            for j in range(k):
                coefficient = sum((q**r - q**(r + 1) for r in range(j, k)), Q(0)) + q**k
                require(coefficient == q**j, "finite geometric layer coefficient")
            geometric = sum((q**j for j in range(k)), Q(0))
            require(geometric == (1 - q**k) / (1 - q), "finite geometric sum")
            require(geometric <= 1 / (1 - q), "uniform geometric sum bound")
            layers += 1
    return {"stopped_telescope_instances": telescopes, "geometric_layer_instances": layers}


def grid_tests(grid):
    g, root_g, block = grid["G"], grid["fourth_root_G"], grid["K"]
    epsilon = Q(grid["epsilon"])
    require(root_g**4 == g and g & (g - 1) == 0, "G must be the stated dyadic fourth power")
    require(epsilon == Q(4, root_g) and epsilon < Q(1, 2), "epsilon hypothesis")
    require(Q(1, root_g) + Q(2, g) <= epsilon, "neighbor radius coverage")
    b = g**block
    d0 = Q(b * b)
    tops = [(Q(t["slope"]), Q(t["weight"]), t["last"]) for t in grid["tops"]]
    require(all(abs(s) <= 1 and h > 0 and k >= 0 for s, h, k in tops),
            "invalid finite top data")
    n = sum((h for _, h, _ in tops), Q(0))
    depth = max(k for _, _, k in tops)
    widths = [d0 / g**i for i in range(depth + 3)]

    def cell(slope, level, theta):
        return (slope - theta) // widths[level]

    def radial(t, level, radius):
        s = tops[t][0]
        return sum((h for u, h, last in tops
                    if last >= level and abs(u - s) <= radius * widths[level]), Q(0))

    def node_mass(t, level, theta):
        label = cell(tops[t][0], level, theta)
        return sum((h for u, h, last in tops
                    if last >= level and cell(u, level, theta) == label), Q(0))

    for _, _, last in tops:
        precision = Q(1, g**last)
        require(precision <= widths[last] / b**2, "last eligible cutoff")
        require(precision > widths[last + 1] / b**2, "first ineligible cutoff")
    packet_width = Q(1, g**(depth + 1))
    require(all(packet_width / Q(1, g**k) <= Q(1, g) for _, _, k in tops),
            "top lengths can be simultaneously short at a common band width")

    translations = {Q(j, 37) * d0 for j in range(37)}
    for slope, _, _ in tops:
        for i in range(depth + 2):
            for digit in (0, 1, g // 2, g - 1):
                for offset in (Q(0), widths[i] / 64, -widths[i] / 64,
                               epsilon * widths[i], -epsilon * widths[i]):
                    translations.add((slope + digit * widths[i] + offset) % d0)
    comparisons = 0
    positive_losses = 0
    excluded_endpoint_comparisons = 0
    terminal_packets = 0
    for theta in sorted(translations):
        for t, (slope, h, last) in enumerate(tops):
            parent_masses = [node_mass(t, i, theta) for i in range(last + 1)]
            boundary_masses = []
            for i in range(last):
                a = max(0, i + 1 - block)
                parent = cell(slope, i, theta)
                ancestor = cell(slope, a, theta)
                child = cell(slope, i + 1, theta)
                extra = Q(0)
                for u, weight, eligible in tops:
                    if eligible < i + 1 or cell(u, i, theta) == parent:
                        continue
                    distance = max(0, abs(cell(u, i + 1, theta) - child) - 1) * widths[i + 1]
                    if cell(u, a, theta) == ancestor and distance < widths[i] / root_g:
                        extra += weight
                        require(abs(u - slope) <= epsilon * widths[i],
                                "extra top outside the manuscript radial bound")
                mass = parent_masses[i] + extra
                boundary_masses.append(mass)
                require(0 < parent_masses[i + 1] <= parent_masses[i] <= mass
                        <= node_mass(t, a, theta) <= n, "eligible boundary mass bounds")
                fraction = (slope - theta) / widths[i] - parent
                near = min(fraction, 1 - fraction)
                endpoint = any(((u - theta) / widths[i]).denominator == 1 for u, _, _ in tops)
                require(0 <= near <= Q(1, 2), "normalized boundary distance")
                if near > epsilon:
                    require(extra == 0, "nonzero loss away from a boundary")
                elif endpoint:
                    excluded_endpoint_comparisons += 1
                else:
                    inner = radial(t, i, near)
                    outer = radial(t, i, epsilon)
                    require(parent_masses[i] >= inner > 0, "inner radial mass inclusion")
                    require(0 <= extra <= outer - inner, "disjoint extra mass inclusion")
                    require(mass / parent_masses[i] <= outer / inner,
                            "one-boundary parent-denominator comparison")
                positive_losses += int(extra > 0 and not endpoint)
                comparisons += 1
            boundary_product = Q(1)
            for stop in range(last + 1):
                if stop:
                    boundary_product *= parent_masses[stop - 1] / boundary_masses[stop - 1]
                normalized = parent_masses[0] / parent_masses[stop] * product(
                    parent_masses[i + 1] / boundary_masses[i] for i in range(stop))
                require(normalized == boundary_product and 0 < normalized <= 1,
                        "central coefficient cancellation with eligible masses")
                packet_precision = Q(1, g**stop)
                require(packet_precision >= Q(1, g**last), "assigned-top length relation")
                terminal_packets += 1

    radial_checks = 0
    for t, (_, h, last) in enumerate(tops):
        potential = [radial(t, i, epsilon) / h for i in range(last)]
        for exponent in range(last + 4):
            radius = epsilon / (2 * g**exponent)
            r = 0
            scale = epsilon
            while scale > radius:
                r += 1
                scale /= g
            ratios = []
            shifted = []
            for i in range(last):
                ratio = radial(t, i, epsilon) / radial(t, i, radius)
                after = potential[i + r] if i + r < last else Q(1)
                require(ratio <= potential[i] / after, "eligible radial inclusion at stopping")
                ratios.append(ratio)
                shifted.append(potential[i] / after)
            require(product(shifted) == product(potential[:min(r, last)]),
                    "multiplicative stopped telescope")
            require(product(ratios) <= product(potential[:min(r, last)]),
                    "logarithmic telescope after monotonicity of log")
            radial_checks += 1
    require(positive_losses > 0, "grid test is vacuous: no boundary loss occurred")
    return {"common_translations": len(translations), "boundary_comparisons": comparisons,
            "nonzero_boundary_losses": positive_losses, "central_stopping_checks": terminal_packets,
            "radial_stopping_checks": radial_checks,
            "excluded_null_endpoint_comparisons": excluded_endpoint_comparisons}


def two_top_law(tests, g):
    laws = 0
    for block in tests["block_lengths"]:
        d0 = Q(g**(2 * block))
        depths = [0, 1] + list(range(2 * block + 1,
                                    2 * block + 1 + tests["depths_after_initial_scale"]))
        for k in depths:
            widths = [d0 / g**i for i in range(k + 1)]
            gap = widths[k - 1] / 32 if k else Q(1, 32)
            if k == 1:
                gap = Q(1, 32)
            require(gap <= Q(1, 32), "two-top slopes must remain bounded")
            mean = sum((gap * (1 / widths[i] - 1 / widths[max(0, i + 1 - block)])
                        for i in range(k)), Q(0))
            strata = [(Q(1) - gap / widths[k - 1], 0), (gap / widths[0], 0)] if k else [(Q(1), 0)]
            for j in range(1, k):
                strata.append((gap * (1 / widths[j] - 1 / widths[j - 1]),
                               min(k - j, block - 1)))
            require(all(p >= 0 and loss >= 0 for p, loss in strata), "invalid exact partition")
            require(sum((p for p, _ in strata), Q(0)) == 1, "common-grid partition is incomplete")
            require(sum((p * loss for p, loss in strata), Q(0)) == mean,
                    "exact common-grid expectation disagrees with strata")
            bound = 2 * Q(1, 4) * sum((Q(1, g)**i for i in range(k)), Q(0))
            require(0 <= mean <= bound, "two-top loss violates the uniform coefficient bound")
            if block == 3 and k >= 2:
                require(mean == (1 + Q(1, g) - 2 * Q(1, g)**(k - 1)) / 32,
                        "closed-form two-top law")
            if block == 1 or k <= 1:
                require(mean == 0, "root and one-step block endpoint")
            laws += 1
    return laws


def abel_checks(max_groups):
    for n in range(max_groups + 1):
        delta = [1 - Q(2, 3)**j for j in range(n + 1)]
        increments = [delta[j + 1] - delta[j] for j in range(n)]
        vectors = [Q((-1)**j) for j in range(n)]
        suffixes = [sum(vectors[j:], Q(0)) for j in range(n)]
        lhs = sum((delta[j + 1] * vectors[j] for j in range(n)), Q(0))
        rhs = sum((increments[j] * suffixes[j] for j in range(n)), Q(0))
        require(lhs == rhs, "finite Abel identity")
        require(all(e >= 0 for e in increments), "negative deficit increment")
        require(sum(increments, Q(0)) == delta[n], "terminal deficit telescope")
        h = max((abs(s) for s in suffixes), default=Q(0))
        require(abs(lhs) <= delta[n] * h, "packet bound acquired a spurious depth factor")
    return max_groups + 1


def rational_wire(value):
    return Q(int(value["num"]), int(value["den"]))


def jacobian_check(data):
    output = load(data["output"])
    require(output["ok"] is False, "expected retained adapter admission failure")
    error = output["error"]["data"]
    require(error["code"] == data["adapter_status"] and error["stage"] == data["error_stage"],
            "different Jacobian failure than the one recorded")
    require(error["operation_id"] == data["operation_id"], "Jacobian operation mismatch")
    require(error["errors"][0]["code"] == data["error_code"], "Jacobian admission code mismatch")
    require(data["typed_mathematical_output"] is None, "adapter failure cannot certify mathematics")
    program = load(data["payload"])["program"]
    finite = data["independent_finite_lp_certificate"]
    point = list(map(Q, finite["primal"]))
    multipliers = list(map(Q, finite["row_multipliers"]))
    upper = list(map(Q, finite["upper_bound_multipliers"]))
    objective = list(map(rational_wire, program["objective"]["coefficients"]))
    require(program["objective"]["sense"] == "MAXIMIZE", "wrong diagnostic objective")
    dual_coefficients = [Q(0)] * len(point)
    dual_value = Q(0)
    for row, multiplier in zip(program["constraints"], multipliers, strict=True):
        require(row["relation"] == "LE" and multiplier >= 0, "invalid diagnostic row multiplier")
        coefficients = list(map(rational_wire, row["coefficients"]))
        rhs = rational_wire(row["rhs"])
        require(sum((a * x for a, x in zip(coefficients, point, strict=True)), Q(0)) <= rhs,
                "finite LP primal row violation")
        dual_coefficients = [a + multiplier * c
                             for a, c in zip(dual_coefficients, coefficients, strict=True)]
        dual_value += multiplier * rhs
    for j, (variable, multiplier) in enumerate(zip(program["variables"], upper, strict=True)):
        require(multiplier >= 0, "negative upper-bound multiplier")
        if variable["lower_bound"] is not None:
            require(point[j] >= rational_wire(variable["lower_bound"]), "finite LP lower bound")
        if variable["upper_bound"] is not None:
            bound = rational_wire(variable["upper_bound"])
            require(point[j] <= bound, "finite LP upper bound")
            dual_value += multiplier * bound
            dual_coefficients[j] += multiplier
        else:
            require(multiplier == 0, "certificate uses a nonexistent upper bound")
    require(dual_coefficients == objective, "finite LP dual balance")
    primal_value = sum((c * x for c, x in zip(objective, point, strict=True)), Q(0))
    require(primal_value == dual_value == Q(finite["maximum"]), "finite LP primal-dual gap")
    return {"adapter_status": data["adapter_status"], "adapter_conclusion": "none",
            "independent_finite_diagnostic_maximum": str(primal_value)}


def main():
    certificate = load("exact_certificate.json")
    tests = certificate["tests"]
    result = {"source_fragments": source_binding(certificate),
              "formal_receipt": formal_receipt(certificate),
              "finite_algebra": finite_algebra(tests),
              "actual_common_grid": grid_tests(tests["grid"]),
              "exact_two_top_translation_laws": two_top_law(tests["two_top"], tests["grid"]["G"]),
              "abel_instances": abel_checks(tests["max_abel_groups"]),
              "jacobian": jacobian_check(certificate["jacobian"]),
              "uniform_proof": "Main.lean and proof.md; finite checks do not replace either.",
              "independent_review": "Host-owned; not asserted by this replay.",
              "ok": True}
    print(json.dumps(result, indent=2))


if __name__ == "__main__":
    main()
