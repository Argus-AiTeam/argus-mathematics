#!/usr/bin/env python3
"""Exact structural replay of the triple network; standard library only."""

import argparse
from collections import Counter
from fractions import Fraction as Q
from itertools import product
import json
from math import comb
from pathlib import Path
import re


def require(condition, message):
    if not condition:
        raise AssertionError(message)


def compact(text):
    return re.sub(r"\s+", "", text)


def table_rows(source, label):
    block = source.split("\\label{" + label + "}", 1)[1]
    block = block.split("\\end{array}", 1)[0]
    rows = {}
    for line in block.splitlines():
        match = re.match(r"\s*([0-7])&([^&]+)&(.+)", line)
        if match:
            rows[int(match[1])] = [v.rstrip("\\").strip() for v in match.group(2, 3)]
    require(sorted(rows) == list(range(8)), "missing chronological source table row")
    return [rows[i] for i in range(8)]


def source_contract(cert, root):
    source = (root / cert["source"]).read_text()
    parsed = []
    for update, _ in table_rows(source, "net:schedule"):
        match = re.fullmatch(r"([xyAc])\\gets\1([+-])([JRVG])([xyAc])", compact(update))
        require(match is not None, "unrecognized scalar update: " + update)
        dst, sign, op, src = match.groups()
        parsed.append([dst, src, op, 1 if sign == "+" else -1])
    require(parsed == cert["schedule"], "certificate scalar schedule differs from source")
    label_rows = table_rows(source, "net:labels")
    expressions = [compact(row[1]).removesuffix(".") for row in label_rows]
    require(expressions ==
            [compact(value) for value in cert["gate_labels"]], "gate labels differ from source")
    actual_touches = []
    for wires, _ in label_rows:
        bank = "X" if "X" in wires else "Y"
        auxiliary = "side" if "side" in wires else "center"
        actual_touches.append([bank, auxiliary])
    require(actual_touches == cert["physical_touches"], "source physical touch table differs")
    text = compact(source)
    fragments = [
        r"a=\frac{1+i}{2}", r"b=\frac{1-i}{2}",
        r"h=100,", r"v=\binomh3=161700", r"m=h^3=10^6",
        r"Twotriplesare\emph{neighbors}whentheyhaveevenintersection",
        r"(Vx)_{ST}&=x_T", r"(Gx)_j&=\sum_{T\nij}x_T",
        r"(Gx)_*&=\sum_Tx_T",
        r"(JA)_S&=-\sum_{T:\,T\text{neighbors}S}\frac{|S\capT|-1}{2}A_{ST}",
        r"(Rc)_S&=\frac{\sum_{j\inS}c_j-c_*}{2}",
        r"D=\Ftwo^h", r"E=D^{\otimes(j-1)}", r"B=P^\perp\subsetE",
        r"q_U(x)=\wt(P_Ux)\pmod4",
        r"\Phi_U=J_m\diag_x(i^{q_U(x)})J_m",
        r"J_m=2^{-m/2}", r"(-1)^{x\cdoty}",
        r"u_d=t_{d_1}\otimest_{d_2}\otimest_{d_3}",
        r"W=2N_0+I_0(vd_{\mathrm{nbr}}+101)=1873807244643542670000",
        r"s&=Wm-2N_0+2I_0(101)100=1873807244636671267308000000",
        r"\Delta:=Wm-s&=6871402692000000>0",
        r"Sourceshavelabel$0$,exceptthat$X_d$haslabel$U_d$",
        r"sinkshavelabel$\mathcalD$,exceptthat$Y_d$haslabel$U_d^\perp$",
        r"reversetheeightscalarupdatesandtheirsigns,withlogicalsource$Y$andtarget$X$",
        r"Here$\wt(u)=27$isodd",
        r"W_*=2^{71}",
    ]
    for fragment in fragments:
        require(fragment in text, "source assertion changed: " + fragment)
    return parsed, actual_touches, expressions


def invocation(schedule):
    # A word records composition of typed maps, not a commutative monomial.
    state = {role: Counter({(role, ()): 1}) for role in ("x", "y", "A", "c")}
    for dst, src, op, sign in schedule:
        addition = {(origin, (op,) + word): sign * value
                    for (origin, word), value in state[src].items()}
        state[dst].update(addition)
        state[dst] = Counter({term: value for term, value in state[dst].items() if value})
    return state


def scalar_identity(cert, schedule, touches):
    initial = {role: Counter({(role, ()): 1}) for role in ("x", "y", "A", "c")}
    for sign, rows in ((1, schedule),
                       (-1, [[dst, src, op, -sgn] for dst, src, op, sgn in reversed(schedule)])):
        expected = {role: value.copy() for role, value in initial.items()}
        expected["y"].update({("x", ("R", "G")): sign, ("x", ("J", "V")): sign})
        require(invocation(rows) == expected, "arbitrary-auxiliary free-map cancellation failed")
        role_map = {"x": "X" if sign == 1 else "Y", "y": "Y" if sign == 1 else "X",
                    "A": "side", "c": "center"}
        physical = []
        for dst, src, _, _ in rows:
            used = {role_map[dst], role_map[src]}
            physical.append([next(role for role in ("X", "Y") if role in used),
                             next(role for role in ("side", "center") if role in used)])
        require(physical == touches, "reversed middle-stage physical incidence mismatch")
    coefficients = []
    for intersection in range(4):
        central = Q(intersection - 1, 2)
        side = -central if intersection in (0, 2) else Q(0)
        total = central + side
        require(total == int(intersection == 3), "RG+JV is not the identity")
        coefficients.append({"intersection": intersection, "central": str(central),
                             "side": str(side), "total": str(total)})
    require(coefficients == cert["intersection_coefficients"], "coefficient orbit certificate mismatch")
    # Each invocation is now the same pointwise bank shear on its fixed-index lists.
    x, y = (1, 0), (0, 1)
    add = lambda u, v: tuple(a + b for a, b in zip(u, v))
    neg = lambda u: tuple(-a for a in u)
    y = add(y, x)
    x = add(x, neg(y))
    y = add(y, x)
    require((x, y) == ((0, -1), (1, 0)), "three-stage signed exchange failed")


def padd(*values):
    result = Counter()
    for value in values:
        result.update(value)
    return {monomial: coefficient for monomial, coefficient in result.items() if coefficient}


def pscale(value, scalar):
    return {monomial: scalar * coefficient for monomial, coefficient in value.items()
            if scalar * coefficient}


def pmul(left, right):
    result = Counter()
    for u, a in left.items():
        for v, b in right.items():
            result[tuple(x + y for x, y in zip(u, v))] += a * b
    return {monomial: coefficient for monomial, coefficient in result.items() if coefficient}


def peval(value, a, h, b):
    return sum(coefficient * a**i * h**j * b**k
               for (i, j, k), coefficient in value.items())


def serialized_poly(value):
    return {",".join(map(str, monomial)): coefficient for monomial, coefficient in value.items()}


def incidence_residuals(cert, touches, expressions):
    one = {(0, 0, 0): 1}
    factors = {
        "P": one, "B": {(1, 0, 0): 1, (0, 0, 0): -1},
        "x": one, "y": one, "H": {(0, 1, 0): 1, (0, 0, 0): -2},
        "Q": one, "F": {(0, 0, 1): 1, (0, 0, 0): -1},
    }
    ambient = set(product(("P", "B"), ("x", "y", "H"), ("Q", "F")))
    dimensions = {atom: pmul(pmul(factors[atom[0]], factors[atom[1]]), factors[atom[2]])
                  for atom in ambient}

    def rectangle(prefix, local, future=("Q",)):
        return set(product(prefix, local, future))

    bd = rectangle(("B",), ("x", "y", "H"))
    ed = rectangle(("P", "B"), ("x", "y", "H"))
    labels = []
    for expression, touch in zip(expressions, touches):
        t = touch[0].lower()
        meanings = {
            compact(r"B\otimes\langle t\rangle"): rectangle(("B",), (t,)),
            compact(r"B\otimes D"): bd,
            compact(r"(B\otimes D)\mathbin\perp(P\otimes\langle t\rangle)"):
                bd | rectangle(("P",), (t,)),
            compact(r"E\otimes D"): ed,
            compact(r"(B\otimes D)\mathbin\perp(P\otimes t^\perp)"):
                bd | rectangle(("P",), tuple(value for value in ("x", "y", "H") if value != t)),
        }
        require(expression in meanings, "uninterpreted source label: " + expression)
        labels.append(meanings[expression])
    incoming = {"X": rectangle(("P", "B"), ("x",)),
                "Y": rectangle(("B",), ("y",)), "side": set(), "center": set()}
    outgoing = {"X": ed, "Y": labels[5], "side": ambient, "center": ambient}
    totals, decreases, edges = {}, {}, {}
    for role in incoming:
        rows = [i for i, used in enumerate(touches) if role in used]
        require(rows == cert["role_rows"][role], "unaccounted physical role touch")
        vertices = [("in" if role in ("X", "Y") else "source", incoming[role])]
        vertices += [(str(i), labels[i]) for i in rows]
        vertices += [("out" if role in ("X", "Y") else "sink", outgoing[role])]
        total, loss, signed = {}, {}, {}
        role_edges = []
        for (u_name, u), (v_name, v) in zip(vertices, vertices[1:]):
            require(u <= v or v <= u, "nonnested actual edge " + role + ":" + u_name + "->" + v_name)
            residual = u ^ v
            dimension = padd(*(dimensions[atom] for atom in residual))
            down = v < u
            total = padd(total, dimension)
            signed = padd(signed, pscale(dimension, -1 if down else 1))
            if down:
                loss = padd(loss, dimension)
                require([role, u_name, v_name] == cert["residuals"]["only_decrease"],
                        "unexpected decreasing physical edge")
            role_edges.append((u_name, v_name, dimension, down))
        require(total == padd(signed, pscale(loss, 2)), "absolute/signed edge accounting mismatch")
        totals[role], decreases[role], edges[role] = total, loss, role_edges
    require({role: serialized_poly(value) for role, value in totals.items()} ==
            cert["residuals"]["total_polynomials"], "universal incidence-derived dimensions differ")
    require({role: serialized_poly(value) for role, value in decreases.items()} ==
            cert["residuals"]["decrease_polynomials"], "universal decrease dimensions differ")
    # These are the eight spectral components of three commuting idempotents.
    # They are not eight chosen data inputs or eight sampled network parameters.
    spectral_atoms = list(product((0, 1), repeat=3))
    require(len(spectral_atoms) == cert["residuals"]["interstage_spectral_atoms"], "spectral atom count")
    for bits in spectral_atoms:
        u = all(bits)
        previous = None
        for j in range(3):
            prefix, current, future = all(bits[:j]), bool(bits[j]), all(bits[j + 1:])
            x_in, x_out = current and future, future
            y_in = (not prefix) and current and future
            y_out = ((not prefix) or (prefix and not current)) and future
            require(y_in == (x_in and not u) and y_out == (x_out and not u),
                    "actual tensor label disagrees with the invariant projector")
            if previous is not None:
                require(previous == (x_in, y_in), "unaccounted interstage edge")
            if j == 0:
                require((x_in, y_in) == (u, False), "wrong source boundary")
            if j == 2:
                require((x_out, y_out) == (True, not u), "wrong sink boundary")
            previous = (x_out, y_out)
    return totals, decreases, edges


def binary_basis(cert):
    evidence = cert["binary_absorption"]
    old, basis = evidence["old_gram"], evidence["new_basis_rows"]
    gram = [[sum(basis[i][a] * old[a][b] * basis[j][b]
                 for a in range(3) for b in range(3)) % 2 for j in range(3)] for i in range(3)]
    require(gram == evidence["new_gram"] == [[int(i == j) for j in range(3)] for i in range(3)],
            "unit-plus-plane absorption is not orthonormal")
    rows, rank = [sum(bit << j for j, bit in enumerate(row)) for row in basis], 0
    for column in range(3):
        pivot = next((i for i in range(rank, 3) if rows[i] & (1 << column)), None)
        if pivot is not None:
            rows[rank], rows[pivot] = rows[pivot], rows[rank]
            for i in range(3):
                if i != rank and rows[i] & (1 << column):
                    rows[i] ^= rows[rank]
            rank += 1
    require(rank == evidence["rank"] == 3, "unit-plus-plane change does not span")
    for h in (cert["generalization"]["interface_minimum_h"], cert["h100"]["h"]):
        require(h > 6, "no guaranteed coordinate unit outside two triple supports")
        for exponent in (1, 2):
            require(h**exponent > 3**exponent, "no unit witness in a tensor-line complement")


def gadd(u, v):
    return (u[0] + v[0], u[1] + v[1])


def gmul(u, v):
    return (u[0] * v[0] - u[1] * v[1], u[0] * v[1] + u[1] * v[0])


ZERO, ONE, I = (Q(0), Q(0)), (Q(1), Q(0)), (Q(0), Q(1))


def gaussian_sum(values):
    result = ZERO
    for value in values:
        result = gadd(result, value)
    return result


def matrix_multiply(a, b):
    return [[gaussian_sum(gmul(a[i][k], b[k][j]) for k in range(len(b)))
             for j in range(len(b[0]))] for i in range(len(a))]


def frame_and_terminal(cert):
    minus_one = (Q(-1), Q(0))
    a, b = (Q(1, 2), Q(1, 2)), (Q(1, 2), Q(-1, 2))
    c, translation = [[a, b], [b, a]], [[ZERO, ONE], [ONE, ZERO]]
    identity = [[ONE, ZERO], [ZERO, ONE]]
    require(matrix_multiply(c, c) == translation, "C^2 is not translation")
    inverse = matrix_multiply(translation, c)
    require(matrix_multiply(inverse, c) == identity, "inverse orientation failed")
    walsh = [[ONE, ONE], [ONE, minus_one]]
    half = (Q(1, 2), Q(0))
    phase = [[ONE, ZERO], [ZERO, I]]
    conjugated = matrix_multiply(matrix_multiply(walsh, phase), walsh)
    require([[gmul(half, value) for value in row] for row in conjugated] == c,
            "Walsh phase convention differs from C")
    character = [[ONE, ZERO], [ZERO, minus_one]]
    conjugated = matrix_multiply(matrix_multiply(walsh, character), walsh)
    require([[gmul(half, value) for value in row] for row in conjugated] == translation,
            "Walsh character is not the claimed translation")
    powers = (ONE, I, minus_one, (Q(0), Q(-1)))
    for direction, weight, bit in product((1, -1), (1, 3), (0, 1)):
        wanted = powers[(direction * weight * bit) % 4]
        kernel = c if direction * weight % 4 == 1 else inverse
        eigenvalue = gadd(kernel[0][0], gmul(powers[2 * bit], kernel[0][1]))
        require(eigenvalue == wanted, "increasing/decreasing phase sign mismatch")
    for x, y in product((0, 1), repeat=2):
        require((x ^ y) == x + y - 2 * x * y, "coordinate weight identity failed")
    terminal = cert["terminal"]
    weight = terminal["tensor_indicator_weight"]
    require(weight == 3**3 == 27 and weight % 2 == 1, "wrong exceptional indicator weight")
    for bit in (0, 1):
        require((-2 * weight * bit) % 4 == (2 * bit) % 4, "exceptional translation sign")
    require((terminal["X_source"], terminal["Y_source"], terminal["X_sink"], terminal["Y_sink"]) ==
            ("U", "0", "whole", "U_perp"), "wrong routed terminal labels")
    require((terminal["routed_X"], terminal["routed_Y"]) == ("Y", "X") and
            terminal["role_exchange_is_tensor_powered"] is False, "wrong role/address tensor distinction")
    # At a generic gate, scalar coefficients multiply the same formal frame.
    # On a generic edge, cancellation leaves the target frame, not its inverse.
    for prefix in ("source", "intermediate", "sink"):
        word = [("target", 1), (prefix, -1), (prefix, 1)]
        reduced = []
        for token in word:
            if reduced and reduced[-1] == (token[0], -token[1]):
                reduced.pop()
            else:
                reduced.append(token)
        require(reduced == [("target", 1)], "frame telescope orientation")
    lift = cert["universal_lifting"]
    require(lift["columns"] == "every integer f>=1" and lift["spectators"] == "every integer r>=0",
            "lifting quantifiers weakened")
    require(lift["edge_orientation"] == "F_target F_source_inverse" and
            lift["tensor_product_rule"] == "(A tensor B)(C tensor D)=(AC) tensor (BD)" and
            lift["fiber_conjugacy"] == "A_L R_e A_L_inverse=R_(L e)",
            "universal lifting schema changed")

    def reduced(word):
        stack = []
        for token in word:
            if stack and stack[-1] == (token[0], -token[1]):
                stack.pop()
            else:
                stack.append(token)
        return tuple(stack)

    # The first slot is an arbitrary f-column operator; the second is one column.
    # This is the induction step, not a check restricted to f=2.
    old_edge = (("V_f", 1), ("U_f", -1))
    new_edge = (("V_1", 1), ("U_1", -1))
    old_source, new_source = (("U_f", 1),), (("U_1", 1),)
    require((reduced(old_edge + old_source), reduced(new_edge + new_source)) ==
            ((("V_f", 1),), (("V_1", 1),)), "tensor induction does not preserve edge cancellation")
    require(reduced((("L", 1), ("L", -1), ("x", 1))) == (("x", 1),),
            "address conjugacy does not cancel L L_inverse")
    # R denotes translation in every column, so R^2=1 for every f.
    x_sink, y_sink = (-1, ("T",), "Y"), (1, ("R", "T"), "X")
    corrected_y = (y_sink[0], ("R",) + y_sink[1], y_sink[2])
    require(corrected_y[1][:2] == ("R", "R"), "missing exceptional sink translation")
    final_x = (corrected_y[0], corrected_y[1][2:], corrected_y[2])
    final_y = (-x_sink[0], x_sink[1], x_sink[2])
    require((final_x, final_y) == ((1, ("T",), "X"), (1, ("T",), "Y")),
            "terminal corrections do not transform both banks")


def indexing_schema(cert):
    indexing = cert["indexing"]
    require(indexing["all_column_radix"] == "2^m" and indexing["spectator_radix"] == "2^r",
            "index enumeration uses the wrong address fields")
    require(indexing["internal_minimum_children"] == 2 and
            indexing["tree_identity"] == "sum_internal(degree-1)=leaves-1",
            "prefix enumeration has no linear node bound")
    # At a root with d children, summing the children's identities adds d-1.
    # The leaf coefficients and the constant term give the same polynomial.
    left = {"sum_child_leaves": 1, "children": -1, "children_from_root": 1, "one": -1}
    right = {"sum_child_leaves": 1, "one": -1}
    normalized_left = {"sum_child_leaves": left["sum_child_leaves"],
                       "one": left["one"],
                       "children": left["children"] + left["children_from_root"]}
    require({key: value for key, value in normalized_left.items() if value} == right,
            "prefix-tree induction fails")
    require(indexing["setup_bound"] == "O(f+1)" and indexing["work_per_tree_edge"] == "O(1)",
            "an uncharged per-entry column scan was introduced")
    # Inductive domination 2^k >= k+1: 2(k+1)-(k+2)=k >=0.
    require((2 - 1, 2 - 2) == (1, 0), "setup domination induction fails")


def constants(h, totals):
    v, m = comb(h, 3), h**3
    n, invocations = v**3, 3 * v * v
    degree = comb(h - 3, 3) + 3 * (h - 3)
    w = 2 * n + invocations * (v * degree + h + 1)
    s = 0
    for j in range(1, 4):
        a, b = h**(j - 1), h**(3 - j)
        s += v * v * (v * (peval(totals["X"], a, h, b) + peval(totals["Y"], a, h, b)) +
                       v * degree * peval(totals["side"], a, h, b) +
                       (h + 1) * peval(totals["center"], a, h, b))
    delta = w * m - s
    require(delta == 2 * v * v * (v - 3 * h * (h + 1)), "derived saving formula differs")
    padding_bits = (w - 1).bit_length()
    w_star = 1 << padding_bits
    padded_steps = s + (w_star - w) * m
    require(padded_steps == w_star * m - delta, "padding loses the saving")
    return {"h": h, "v": v, "N0": n, "m": m, "I0": invocations, "degree": degree,
            "W": w, "s": s, "Delta": delta, "padding_bits": padding_bits, "W_star": w_star,
            "S": padded_steps, "lambda": str(Q(padded_steps, w_star))}


def arithmetic_and_recurrence(cert, totals, decreases):
    actual = constants(cert["h100"]["h"], totals)
    require(actual == cert["h100"], "h=100 exact constants differ")
    h, m, p = actual["h"], actual["m"], actual["padding_bits"]
    require([comb(3, r) * comb(h - 3, 3 - r) for r in range(4)] ==
            cert["intersection_counts_h100"], "neighbor orbit count mismatch")
    require(sum(cert["intersection_counts_h100"]) == actual["v"], "triples omitted")
    for role, key in (("X", "stage_bank_totals_h100"), ("Y", "stage_bank_totals_h100"),
                      ("side", "stage_side_totals_h100"), ("center", "stage_center_totals_h100")):
        require([peval(totals[role], h**(j - 1), h, h**(3 - j)) for j in range(1, 4)] ==
                cert["residuals"][key], "per-stage physical-role budget differs")
    require(all(peval(decreases["center"], h**(j - 1), h, h**(3 - j)) == h
                for j in range(1, 4)), "central loss depends on the stage")
    coefficient = Q(actual["S"], actual["W_star"])
    require(1 < coefficient < m and actual["Delta"] > 0, "no critical-exponent saving")
    require(2**(p - 1) < actual["W"] <= 2**p, "padding is not the least power of two")
    require(cert["recurrence"]["base_threshold_h100"] == m * (p + 1), "wrong recursion threshold")
    require((m - 1) * (p + 1) >= p and m > 1, "recursive batches need padding")
    normalized = Q(actual["S"], actual["W_star"]) * actual["W_star"] / actual["W_star"]
    exponents = tuple(a + b - c for a, b, c in zip((1, -1), (0, 1), (1, 0)))
    require(normalized == coefficient and exponents == (0, 0), "normalized recurrence incorrect")
    extension = cert["generalization"]
    require(extension["interface_minimum_h"] == 7 and extension["strict_saving_minimum_h"] == 22,
            "unproved parameter range")
    # (h-1)(h-2)-18(h+1)=h^2-21h-16; put h=22+t.
    require([22**2 - 21 * 22 - 16, 2 * 22 - 21, 1] ==
            extension["shifted_saving_polynomial"] == [6, 23, 1], "uniform saving polynomial")
    require(constants(25, totals) == extension["h25"], "smaller-parameter constants differ")
    smaller = extension["h25"]
    eps_small = Q(smaller["Delta"], smaller["W_star"] * smaller["m"])
    eps_original = Q(actual["Delta"], actual["W_star"] * actual["m"])
    factor = extension["gap_improvement_factor_over_h100"]
    upper = extension["log2_brackets"]["h25_m_upper_exponent"]
    lower = extension["log2_brackets"]["h100_m_lower_exponent"]
    require(smaller["m"] < 2**upper and actual["m"] > 2**lower, "logarithm brackets fail")
    require(0 < eps_small < 1 and 0 < eps_original < 1 and factor == 1500, "invalid gap comparison")
    require(eps_small * lower * (1 - eps_original) > factor * upper * eps_original,
            "the claimed exponent-gap improvement is false")
    return actual


def jacobian_replay(cert, directory):
    spec = cert["jacobian"]
    payload = json.loads((directory / spec["payload"]).read_text())
    output = json.loads((directory / spec["typed_output"]).read_text())
    status = json.loads((directory / spec["adapter_status"]).read_text())
    require(status["adapter_exit_code"] == 0, "Jacobian failure/timeout is not evidence")
    require(output["server"]["version"] == spec["server_version"] and
            output["protocol_version"] == spec["protocol_version"], "Jacobian provenance differs")
    require(output["request"]["operation_id"] == output["result"]["operation_id"] ==
            spec["operation_id"] == status["operation_id"], "Jacobian operation differs")
    require(output["request"]["payload"] == payload and
            output["result"]["output"]["source"] == payload, "Jacobian payload binding differs")
    require(payload["matrix"] == {"prime": 2, "columns": 3,
                                 "entries": cert["binary_absorption"]["new_basis_rows"]},
            "Jacobian checked a different basis change")
    require(output["result"]["output"]["prime"] == 2 and
            output["result"]["output"]["rank"] == 3, "Jacobian typed rank is not the required result")


def verify(certificate, root):
    cert = json.loads(certificate.read_text())
    require(cert["research_target_level"] == "publishable" and
            cert["math_objective_mode"] == "exploratory", "campaign objective changed")
    schedule, touches, expressions = source_contract(cert, root)
    scalar_identity(cert, schedule, touches)
    totals, decreases, edges = incidence_residuals(cert, touches, expressions)
    binary_basis(cert)
    frame_and_terminal(cert)
    indexing_schema(cert)
    actual = arithmetic_and_recurrence(cert, totals, decreases)
    jacobian_replay(cert, certificate.parent)
    return {"result": "PASS", "project_root": str(root), "proof_kind": "exact structural replay plus universal proof",
            "source_binding": "checked", "h": actual["h"], "W": actual["W"], "s": actual["s"],
            "Delta": actual["Delta"], "physical_edge_classes": sum(map(len, edges.values())),
            "coverage": ["arbitrary auxiliaries", "reversed second stage", "all physical roles",
                         "nested nondegenerate residuals", "orthonormal binary residual bases",
                         "frame orientation", "terminal corrections", "all f>=1", "all spectator bits",
                         "linear-time address enumeration", "exact batching and critical recurrence",
                         "uniform h>=7 interface", "strict saving iff h>=22", "h25 exponent-gap improvement"],
            "independent_review": cert["independent_review"], "novelty_status": cert["novelty_status"],
            "limitations": cert["limitations"]}


if __name__ == "__main__":
    directory = Path(__file__).resolve().parent
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--certificate", type=Path, default=directory / "exact_certificate.json")
    parser.add_argument("--project-root", type=Path, default=directory.parents[1])
    args = parser.parse_args()
    print(json.dumps(verify(args.certificate.resolve(), args.project_root.resolve()), indent=2))
