#!/usr/bin/env python3
"""Replay the dimension-uniform singular-tail algebra, not a dimension search.

Requires SymPy. Default operation is read-only and compares the recomputed
certificate with exact_certificate.json. The probability implication retains
the upstream premises listed in REPORT.md; this is not a Lean kernel proof.
"""

import argparse
import json
import re
from collections import Counter, defaultdict, deque
from itertools import combinations
from pathlib import Path

import sympy as sp


HERE = Path(__file__).resolve().parent
ROOT = HERE.parent.parent
SOURCE = ROOT / (
    "research/openai_manuscript/"
    "A-counterexample-to-Sidorenkos-conjecture-September-23-2026/build/sections"
)
R = sp.Rational


def require(condition, message):
    if not condition:
        raise AssertionError(message)


def b(n):
    return R(1, 2) * n * (n + 1)


def choose2(n):
    return R(1, 2) * n * (n - 1)


def complex_certificate():
    text = (SOURCE / "complex.tex").read_text()
    rows = {}
    orders = {}
    for line in text.splitlines():
        cells = [cell.strip().rstrip("\\").strip() for cell in line.split("&")]
        if (
            len(cells) == 8
            and all(cell.isdecimal() for cell in cells[:7])
            and re.fullmatch("[01]{3}", cells[7])
        ):
            face, *numbers = map(int, cells[:7])
            require(face not in rows, "Duplicate source face")
            rows[face] = (numbers[:3], numbers[3:], cells[7])
    at = text.index("\\label{tab:complex-orders}")
    start = text.rfind("\\begin{tabular}", 0, at)
    stop = text.index("\\end{tabular}", start)
    table = text[start:stop]
    body = table[table.index("\\midrule") + len("\\midrule"):table.index("\\bottomrule")]
    for row in body.replace("\\addlinespace", "").split("\\\\"):
        if not row.strip():
            continue
        cells = [cell.strip() for cell in row.split("&")]
        require(len(cells) == 4, "Source exposure table row")
        key = (int(cells[0]) - 1, int(cells[1]))
        require(key not in orders, "Duplicate source exposure order")
        orders[key] = (
            list(map(int, re.findall(r"\d+", cells[2]))),
            list(map(int, re.findall(r"\d+", cells[3]))),
        )
    require(sorted(rows) == list(range(22)), "Source face identifiers")
    require(len(orders) == 6, "Six source exposure orders required")
    faces = [rows[j][0] for j in range(22)]
    bits = [rows[j][2] for j in range(22)]
    require(all(len(set(face)) == 3 for face in faces), "Faces must be triples")
    require(set().union(*map(set, faces)) == set(range(13)), "Source points")
    on_pair = defaultdict(list)
    for j, face in enumerate(faces):
        require(face == sorted(face), "Source pair order changed")
        for pair in combinations(face, 2):
            on_pair[pair].append(j)
    edges = sorted(on_pair)
    require(len(edges) == 33, "Source has 33 pairs")
    require(all(len(js) == 2 for js in on_pair.values()), "Double pair incidence")
    adjacency = [set() for _ in faces]
    separations = []
    for edge in edges:
        j, k = on_pair[edge]
        adjacency[j].add(k)
        adjacency[k].add(j)
        count = sum(x != y for x, y in zip(bits[j], bits[k]))
        require(count >= 1, "Every pair needs positive bit separation")
        separations.append(count)
    require(separations[edges.index((0, 2))] == 3, "Distinguished separation")
    for j, face in enumerate(faces):
        for pair, neighbor in zip(combinations(face, 2), rows[j][1]):
            require(
                set(on_pair[pair]) == {j, neighbor},
                "Source opposite-face entry disagrees with point table",
            )
    diameter = 0
    for start in range(22):
        distance = {start: 0}
        queue = deque([start])
        while queue:
            j = queue.popleft()
            for neighbor in adjacency[j]:
                if neighbor not in distance:
                    distance[neighbor] = distance[j] + 1
                    queue.append(neighbor)
        require(len(distance) == 22, "Face graph must be connected")
        diameter = max(diameter, max(distance.values()))
    certificates = []
    face_multiplicity = Counter()
    pair_multiplicity = Counter()
    for (position, value), (order, new_points) in sorted(orders.items()):
        members = {j for j in range(22) if int(bits[j][position]) == value}
        require(len(members) == 11 and set(order) == members, "Bit class order")
        require(len(order) == 11 and len(new_points) == 10, "Order lengths")
        exposed = set(faces[order[0]])
        previous = {order[0]}
        parents = []
        for j, new_point in zip(order[1:], new_points):
            require(set(faces[j]) - exposed == {new_point}, "Fresh-point step")
            options = sorted(previous & adjacency[j])
            require(bool(options), "Exposure step needs a previous pair")
            parents.append(options[0])
            exposed.update(faces[j])
            previous.add(j)
        require(exposed == set(range(13)), "Class must expose all points")
        face_multiplicity.update(members)
        for edge, js in on_pair.items():
            if set(js) <= members:
                pair_multiplicity[edge] += 1
        certificates.append(
            {"position": position + 1, "value": value,
             "faces": order, "new_points": new_points, "parents": parents}
        )
    require(all(face_multiplicity[j] == 3 for j in range(22)), "Face averaging")
    require(
        all(pair_multiplicity[e] == 3 - count
            for e, count in zip(edges, separations)),
        "Internal-pair averaging",
    )
    degrees = [sum(i in edge for edge in edges) for i in range(13)]
    require(
        degrees == [4, 6, 4, 6, 5, 4, 5, 5, 5, 6, 5, 6, 5],
        "Source degree sequence",
    )
    return (
        {"faces": faces, "bits": bits, "edges": [list(e) for e in edges],
         "separation_numerators_over_3": separations,
         "face_graph_diameter": diameter, "degrees": degrees,
         "exposure_orders": certificates},
        edges,
    )


def source_equations():
    labels = {
        "planted.tex": [
            "eq:planted-gain", "eq:planted-feasibility",
            "eq:planted-two-active-gain",
        ],
        "tail.tex": [
            "eq:global-cost", "eq:tail-excess", "eq:tail-total-slack",
            "eq:tail-feasible", "eq:slack", "eq:tail-quadratic",
            "eq:tail-linear-loss", "eq:coercivity", "eq:tail-budget",
            "eq:tail-leading-coefficient", "eq:tail-integer-slack",
        ],
    }
    result = {}
    for filename, names in labels.items():
        text = (SOURCE / filename).read_text()
        for name in names:
            marker = "\\label{" + name + "}"
            require(text.count(marker) == 1, "Unique source equation: " + name)
            at = text.index(marker)
            start = text.rfind("\\begin{equation}", 0, at)
            end = text.index("\\end{equation}", at) + len("\\end{equation}")
            require(start >= 0, "Equation environment: " + name)
            result[filename + ":" + name] = re.sub(r"\s+", "", text[start:end])
    return result


def algebra_certificate(edges):
    identities = []
    nonnegative = []

    def equal(name, left, right):
        require(sp.expand(left - right) == 0, "Polynomial identity: " + name)
        identities.append(name)

    def nn(name, expression, variables):
        poly = sp.Poly(sp.expand(expression), *variables, domain=sp.QQ)
        require(all(coefficient >= 0 for coefficient in poly.coeffs()),
                "Nonnegative-coefficient certificate: " + name)
        nonnegative.append(
            {"name": name, "nonnegative_variables": [str(v) for v in variables],
             "terms": [
                 {"powers": list(powers), "coefficient": str(coefficient)}
                 for powers, coefficient in poly.terms()
             ]}
        )

    c, d, delta, v, u, z = sp.symbols("c d delta v u z")
    p = sp.symbols("p1:4")
    t = sp.symbols("t1:4")
    P, T = sum(p), sum(t)
    s = [pi + ti for pi, ti in zip(p, t)]
    n = [2 * pi - ti for pi, ti in zip(p, t)]
    r = (d + c) / 2
    common_u = (c + delta) / 2
    w = (d - 3 * delta) / 2 - P + v
    g_common = (r + c + 1) * common_u - 2 * common_u**2
    gain = (
        g_common + sum(map(b, s)) - delta * P - sum(pi**2 for pi in p)
        - v * w - sum(map(b, t)) + b(v)
    )
    face_cost = (d + c + 1) * c + sum(map(b, s))
    beta = face_cost / 2 - sum(b(c + si) for si in s) / 6
    slack = (
        (c * (d + delta - 1) - delta * (d + 2) + 2 * delta**2) / 4
        + sum(ni * (ni - 1) / 6 + delta * pi - c * si / 6
              for ni, pi, si in zip(n, p, s)) + v * w - b(v)
    )
    quadratic = (
        (c * (d + delta) - delta * d + 2 * delta**2) / 4
        + sum(ni**2 / 6 + delta * pi - c * si / 6
              for ni, pi, si in zip(n, p, s))
        + v * ((d - 3 * delta) / 2 - P) + v**2 / 2
    )
    linear_loss = c / 4 + delta / 2 + (2 * P - T) / 6 + v / 2
    equal("slack_from_source_gain_and_baseline", beta - gain, slack)
    equal("quadratic_plus_linear", slack, quadratic - linear_loss)
    equal("pair_slack_identity", p[0]**2 + b(t[0]) - R(2, 3) * b(s[0]),
          n[0] * (n[0] - 1) / 6)
    a = sp.Symbol("a")
    equal("two_active_increment",
          (b(a) - (z + 1)**2 - b(a - z - 1))
          - (b(a) - z**2 - b(a - z)), a - 3 * z - 1)
    equal("two_active_even_maximum", b(2 * a) - a**2 - b(a), b(a))
    equal("two_active_odd_maximum",
          b(2 * a + 1) - (a + 1)**2 - b(a), b(a))
    nn("even_floor_gap_at_k_ge_1", b(2 * (z + 1)) / 3 - b(z + 1), [z])
    equal("even_floor_gap_at_zero", b(0), 0)
    nn("odd_floor_gap", b(2 * z + 1) / 3 - b(z), [z])
    equal("even_floor_quadratic_bound", (2 * z) * (2 * z + 2) / 8, b(z))
    nn("odd_floor_quadratic_bound", (2 * z + 1) * (2 * z + 3) / 8 - b(z), [z])
    h = sp.Symbol("h")
    equal("lower_active_quadratic",
          b(h) / 3 - h * (h + 2) / 8, h**2 / 24 - h / 12)
    s0, s1, s2 = sp.symbols("s0 s1 s2")
    lower_beta = ((d + c + 1) * c + b(s0) + b(s1) + b(s2)) / 2
    lower_beta -= (b(c + s0) + b(c + s1) + b(c + s2)) / 6
    equal("lower_active_baseline",
          lower_beta - b(c + s0) / 3 - b(c) / 6 - (b(s1) + b(s2)) / 3,
          c * (3 * d - (s0 + s1 + s2) - 2 * s0) / 6)
    equal("lower_active_domain_gaps",
          3 * d - (s0 + s1 + s2) - 2 * s0,
          (d - s0 - s1 - s2) + 2 * (d - s0))
    M = sp.Symbol("M")
    equal("uniform_linear_loss",
          R(3, 2) * M - c / 4 - linear_loss,
          (c - delta) / 2 + (M - c - P / 3) + (M - v) / 2 + T / 6)
    equal("common_intersection_boundary",
          slack.subs({c: 2 * a, d: 0, delta: 0, v: 0,
                      **{pi: 0 for pi in p}, **{ti: 0 for ti in t}}),
          -a / 2)

    Ps, Ts, x, y, vv, B, aa = sp.symbols("P T x y v0 B aa")
    variance = sum(ni**2 for ni in n) / 6 - (2 * P - T)**2 / 18
    equal("three_term_variance", variance,
          sum((n[i] - n[j])**2 for i, j in combinations(range(3), 2)) / 18)
    nn("nonnegative_v_branch", B * v + v**2 / 2, [B, v])
    equal("negative_v_branch_completion",
          -aa * v + v**2 / 2 + aa**2 / 2, (v - aa)**2 / 2)
    alpha = (d + delta) / 4 - (Ps + Ts) / 6
    equal("common_coefficient_domain_gaps",
          alpha, (d - Ps - Ts) / 6 + (d + 3 * delta) / 12)
    equal("d_plus_3delta_domain_gaps",
          d + 3 * delta, (d - Ps - Ts) + (Ps + 3 * delta - Ts) + 2 * Ts)
    scalar = (
        (c * (d + delta) - delta * d + 2 * delta**2) / 4
        + (2 * Ps - Ts)**2 / 18 + delta * Ps
        - c * (Ps + Ts) / 6 - vv**2 / 2
    )
    equal("common_coefficient_replacement",
          scalar - scalar.subs(c, delta), (c - delta) * alpha)
    F1 = (
        3 * delta**2 / 4 + (2 * Ps - Ts)**2 / 18
        + (5 * Ps - Ts) * delta / 6 - (Ps / 3 + delta)**2 / 2
    )
    F2 = F1 + (Ps / 3 + delta)**2 / 2 - (Ps - Ts + 3 * delta)**2 / 8
    equal("positive_delta_scalar_first",
          scalar.subs({c: delta, vv: Ps / 3 + delta}), F1)
    equal("positive_delta_scalar_second",
          scalar.subs({c: delta, vv: (Ps - Ts + 3 * delta) / 2}), F2)
    break_F, end_F = Ps / 3 + delta, Ps + 3 * delta
    equal("positive_branch_matching", F1.subs(Ts, break_F), F2.subs(Ts, break_F))
    equal("positive_first_interval",
          F1.subs(Ts, break_F - z) - F1.subs(Ts, break_F),
          z * (5 * Ps / 27 + delta / 18) + z**2 / 18)
    nn("positive_first_interval_margin",
       F1.subs(Ts, break_F - z) - F1.subs(Ts, break_F), [Ps, delta, z])
    equal("positive_concave_chord",
          (end_F - break_F) * F2
          - (end_F - Ts) * F2.subs(Ts, break_F)
          - (Ts - break_F) * F2.subs(Ts, end_F),
          R(5, 72) * (end_F - break_F) * (Ts - break_F) * (end_F - Ts))
    F_break_margin = sp.expand(F1.subs(Ts, break_F) - (Ps**2 + delta**2) / 18)
    nn("positive_breakpoint_margin", F_break_margin, [Ps, delta])
    nn("positive_endpoint_margin",
       F2.subs(Ts, end_F) - (Ps**2 + delta**2) / 18, [Ps, delta])
    G1 = y**2 / 4 + (2 * x - Ts) * y / 3 + (2 * x - Ts)**2 / 18 - x**2 / 18
    G2 = G1 + x**2 / 18 - (x - Ts)**2 / 8
    substitution = {c: y, delta: -y, Ps: x + 3 * y}
    for name, argument, target in (
        ("negative_first", x / 3, G1),
        ("negative_second", (x - Ts) / 2, G2),
    ):
        reduced = scalar.subs(substitution).subs(vv, argument)
        equal(name + "_dimension_replacement",
              reduced - reduced.subs(d, x + 3 * y + Ts),
              y * (d - x - 3 * y - Ts) / 2)
        equal(name + "_scalar", reduced.subs(d, x + 3 * y + Ts), target)
    break_G, end_G = x / 3, x
    equal("negative_branch_matching", G1.subs(Ts, break_G), G2.subs(Ts, break_G))
    nn("negative_first_interval_margin",
       G1.subs(Ts, break_G - z) - G1.subs(Ts, break_G), [x, y, z])
    equal("negative_concave_chord",
          (end_G - break_G) * G2
          - (end_G - Ts) * G2.subs(Ts, break_G)
          - (Ts - break_G) * G2.subs(Ts, end_G),
          R(5, 72) * (end_G - break_G) * (Ts - break_G) * (end_G - Ts))
    nn("negative_breakpoint_margin", G1.subs(Ts, break_G) - (x**2 + y**2) / 18, [x, y])
    nn("negative_endpoint_margin", G2.subs(Ts, end_G) - (x**2 + y**2) / 18, [x, y])
    equal("norm_bound_positive",
          19 * (Ps**2 + delta**2) - (Ps**2 + (Ps + 3 * delta)**2 + delta**2),
          16 * Ps**2 + (Ps - 3 * delta)**2)
    equal("norm_bound_negative",
          19 * (x**2 + y**2) - ((x + 3 * y)**2 + x**2 + y**2),
          16 * x**2 + (x - 3 * y)**2)
    require(18 * 19 == 342, "Coercivity denominator")

    A = (c - delta + 2 * v) / 4
    remainder = sp.expand(slack - A * d)
    require(d not in remainder.free_symbols, "Remainder must not depend on d")
    equal("half_integral_leading_coefficient",
          A.subs(delta, 2 * u - c), (c - u + v) / 2)
    coefficient_sums = Counter()
    for powers, coefficient in sp.Poly(remainder, c, delta, *p, *t, v).terms():
        degree = sum(powers)
        require(degree in (1, 2), "Only linear and quadratic remainder")
        coefficient_sums[degree] += abs(coefficient)
    require(coefficient_sums[2] == R(57, 4), "Quadratic remainder coefficient sum")
    require(coefficient_sums[1] == R(11, 4), "Linear remainder coefficient sum")
    nn("explicit_remainder_margin",
       15 * M**2 + 3 * M
       - coefficient_sums[2] * M**2 - coefficient_sums[1] * M, [M])
    C = 15 * M**2 + 3 * M
    Dstar = M + 44 * C + 2
    equal("positive_leading_coefficient_exclusion", (Dstar - M) / 2 - 22 * C, 1)
    integer_slack = (
        3 * c * (c - 1) / 4
        + sum((ni**2 + (c - 1) * ni + 3 * c * pi) / 6 for ni, pi in zip(n, p))
    )
    equal("integer_equality_slack", slack.subs({delta: c, v: 0}), integer_slack)
    equal("integer_square_completion", integer_slack,
          3 * c * (c - 1) / 4 - (c - 1)**2 / 8
          + sum((ni + (c - 1) / 2)**2 / 6 for ni in n) + c * P / 2)
    nn("c_at_least_two_strict_margin",
       ((c - 1) * (5 * c + 1) / 8).subs(c, z + 2), [z])
    require(((c - 1) * (5 * c + 1) / 8).subs(c, 2) > 0,
            "The c>=2 margin must be strictly positive")
    equal("c_one_slack", integer_slack.subs(c, 1),
          sum(ni**2 + 3 * pi for ni, pi in zip(n, p)) / 6)
    equal("c_zero_slack", integer_slack.subs(c, 0), sum(ni * (ni - 1) for ni in n) / 6)
    nn("integer_n_at_least_one", (z + 1) * z, [z])
    nn("integer_n_at_most_zero", (-z) * (-z - 1), [z])
    require(sp.Poly(z * (z - 1), z).ground_roots() == {0: 1, 1: 1},
            "Only the exact roots 0 and 1 are possible")
    zero_pairs = [
        [pi, 2 * pi - ni] for ni in (0, 1) for pi in range(ni + 1)
        if 0 <= 2 * pi - ni <= pi
    ]
    require(zero_pairs == [[0, 0], [1, 1]], "Exact integer zero classification")

    m, k = sp.symbols("m k")
    equal("nondirect_global_span_square", -k**2 + 2 * m * k, m**2 - (k - m)**2)
    equal("nondirect_probability_remainder",
          1575 - (m**2 - 4 * m + 618), (33 - m) * (m + 29))
    equal("nondirect_weighted_remainder",
          1641 - (m**2 - 2 * m + 618), (33 - m) * (m + 31))
    equal("direct_residual_gain", -3 * m + R(2, 3) * 3 * m, -m)
    hh = sp.symbols("h0:33")
    D = sp.Symbol("D")
    H = sum(hh)
    local = [sum(hi for hi, edge in zip(hh, edges) if i in edge) for i in range(13)]
    cross = sum(hh[e] * hh[f] for e, f in combinations(range(33), 2)
                if set(edges[e]) & set(edges[f]))
    equal("direct_endpoint_dimensions", sum(local), 2 * H)
    equal("direct_cross_term_identity", sum(map(choose2, local)),
          2 * sum(map(choose2, hh)) + cross)
    family_count = 2 * D * H - sum(hi**2 for hi in hh) - sum(map(choose2, hh)) - cross
    containment = -D * sum(local) + sum(map(choose2, local))
    equal("direct_count_cancellation", family_count + containment, -sum(map(b, hh)))
    increments = sp.symbols("increment0:33")
    gaps = sp.symbols("gap0:66")
    local_increments = [
        sum(increments[e] + gaps[2 * e + edge.index(i)]
            for e, edge in enumerate(edges) if i in edge)
        for i in range(13)
    ]
    equal("universal_span_increment_identity",
          sum(local_increments) - 2 * sum(increments), sum(gaps))
    Csum, weighted_pairs, Gsum = sp.symbols("Csum weighted_pairs Gsum")
    cost = Csum / 2 - weighted_pairs / 6
    equal("first_cost_integer_lattice", 6 * (cost - Gsum),
          3 * Csum - weighted_pairs - 6 * Gsum)

    return (
        {"identity_count": len(identities), "identities": identities,
         "nonnegative_polynomials": nonnegative,
         "remainder_absolute_coefficient_sums": {
             "quadratic": str(coefficient_sums[2]),
             "linear": str(coefficient_sums[1])},
         "integer_zero_pairs_p_t": zero_pairs,
         "scope": "Polynomial identities and domain-specific inequality proof schemas, valid in every permitted dimension; no ambient dimensions sampled."},
        F_break_margin,
        (Ps, delta),
    )


def jacobian_certificate(endpoint_margin, variables):
    payload = json.loads((HERE / "jacobian_payload.json").read_text())
    response = json.loads((HERE / "jacobian_output.json").read_text())
    status = json.loads((HERE / "jacobian_status.json").read_text())
    require(status["adapter_exit_code"] == 0, "Jacobian adapter did not succeed")
    require(status["stderr"] == "", "Jacobian adapter reported stderr")
    require(status["adapter_timeout"] is False, "Jacobian adapter timed out")
    require(status["structured_error"] is None, "Jacobian returned a structured error")
    require(response["request"]["payload"] == payload, "Exact Jacobian request binding")
    require(response["result"]["operation_id"] == "polynomial.box.enclosure.compute",
            "Jacobian operation")
    output = response["result"]["output"]
    require(output["polynomial"] == payload["polynomial"], "Retained polynomial")
    require(output["box"] == payload["box"], "Retained domain")
    require(payload["polynomial"]["variables"] == ["P", "delta"],
            "Jacobian polynomial axis")
    require(payload["box"]["variables"] == ["P", "delta"], "Jacobian box axis")
    require(payload["box"]["intervals"] == [
        {"lower": {"num": "0", "den": "1"}, "upper": {"num": "1", "den": "1"}},
        {"lower": {"num": "0", "den": "1"}, "upper": {"num": "1", "den": "1"}},
    ], "Jacobian domain must be the stated unit box")
    terms = payload["polynomial"]["polynomial"]["terms"]
    polynomial = 0
    for term in terms:
        coefficient = term["coefficient"]
        coefficient = R(int(coefficient["num"]), int(coefficient["den"]))
        polynomial += coefficient * sp.prod(
            variable**power for variable, power in zip(variables, term["exponents"])
        )
    require(sp.expand(polynomial - endpoint_margin) == 0, "Endpoint source binding")
    enclosure = output["enclosure"]
    lower = R(int(enclosure["lower"]["num"]), int(enclosure["lower"]["den"]))
    upper = R(int(enclosure["upper"]["num"]), int(enclosure["upper"]["den"]))
    require(lower == 0 and upper == R(125, 324), "Exact endpoint enclosure")
    return {
        "server_version": response["server"]["version"],
        "protocol_version": response["protocol_version"],
        "operation_id": response["result"]["operation_id"],
        "adapter_exit_code": status["adapter_exit_code"],
        "adapter_timeout": status["adapter_timeout"],
        "structured_error": status["structured_error"],
        "typed_output_file": "jacobian_output.json",
        "exact_payload_file": "jacobian_payload.json",
        "enclosure": {"lower": str(lower), "upper": str(upper)},
        "limitation": "Only the positive-delta breakpoint margin on [0,1]^2. The full cone is unbounded and piecewise; the independent symbolic proof supplies it.",
    }


def verify():
    complex_data, edges = complex_certificate()
    algebra, margin, variables = algebra_certificate(edges)
    K = 151
    budget = 33
    diameter = complex_data["face_graph_diameter"]
    require(K**2 >= 2 * 342 * budget, "P+T budget")
    require(K**2 >= 24 * budget, "Lower-activity budget")
    M = (2 * K * (diameter + 1))**2
    require(M > 24 * budget, "Propagation contradicts distinguished-edge excess")
    C = 15 * M**2 + 3 * M
    threshold = M + 44 * C + 2
    require(threshold % 2 == 0 and threshold >= 1642, "Sufficient even threshold")
    degree_remainder = sum(choose2(2 * degree) for degree in complex_data["degrees"])
    require(degree_remainder == 618, "Endpoint containment remainder")
    return {
        "claim": "ST_TAIL_RATE",
        "result_class": "exact_verification_theorem",
        "independent_review": "required_not_yet_performed",
        "formal_kernel_verification": False,
        "theorem": "Subject to the recorded local-gain and orbit/count premises, every fixed even D>=D_* and every activity set have unsigned singular contribution O_D(q^(-1/6)) as q tends to infinity through odd primes.",
        "upstream_premises": [
            {"source": "planted.tex",
             "locators": ["prop:planted-gain", "eq:planted-feasibility", "lem:two-active-gain"],
             "status": "source_read_not_independently_certified_by_this_node"},
            {"source": "orbits.tex",
             "locators": ["lem:lagrangian-counts", "prop:triple-orbits"],
             "status": "source_read_not_independently_certified_by_this_node"},
        ],
        "source_equations": source_equations(),
        "complex": complex_data,
        "algebra": algebra,
        "constants": {
            "K": K, "budget": budget, "M_star": M, "C_star": C, "D_star": threshold,
            "D_star_formula": "M_star+44*(15*M_star^2+3*M_star)+2",
            "coercivity": "1/342", "first_cost_saving": "1/6",
            "direct_residual_exponent": "-sum_e b(h_e)/3 = -m",
            "nondirect_probability_exponent": "-D+1575",
            "nondirect_weighted_exponent": "-D+1641",
            "endpoint_remainder": int(degree_remainder),
        },
        "jacobian": jacobian_certificate(margin, variables),
        "not_claimed": [
            "No counterexample to a manuscript assertion has been established.",
            "No sufficiency of the relaxed dimension constraints for realizability is used.",
            "The complete rank-layer limit, activation/pinning argument, and main Sidorenko theorem are not certified.",
            "Publication significance and novelty are not established by replaying the source argument.",
            "The geometric increment and counting arguments require the mathematical proof in REPORT.md and independent review; this script is not a formal proof assistant.",
        ],
    }


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--write-certificate", action="store_true")
    args = parser.parse_args()
    result = verify()
    path = HERE / "exact_certificate.json"
    if args.write_certificate:
        path.write_text(json.dumps(result, indent=2) + "\n")
    expected = json.loads(path.read_text())
    require(result == expected, "Stored certificate differs from exact replay")
    print(json.dumps({
        "result": "PASS", "claim": result["claim"],
        "universal_identities": result["algebra"]["identity_count"],
        "nonnegative_polynomials": len(result["algebra"]["nonnegative_polynomials"]),
        "face_graph_diameter": result["complex"]["face_graph_diameter"],
        "D_star": result["constants"]["D_star"],
        "upstream_premises_retained": True, "independent_review_pending": True,
    }, sort_keys=True))


if __name__ == "__main__":
    main()
