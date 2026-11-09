#!/usr/bin/env python3
"""Exact structural replay of the section 03 finite-network certificate."""

import argparse
from fractions import Fraction as Q
from itertools import product
import json
from math import comb
from pathlib import Path


HERE = Path(__file__).resolve().parent
H = 100


def require(condition, message):
    if not condition:
        raise AssertionError(message)


def add_expr(left, right, scale=1):
    result = dict(left)
    for key, value in right.items():
        result[key] = result.get(key, 0) + scale * value
        if not result[key]:
            del result[key]
    return result


def apply_symbol(symbol, expression):
    return {(symbol + word, source): value
            for (word, source), value in expression.items()}


def transparent_schedule():
    initial = {name: {("", name): 1} for name in ("x", "y", "a", "c")}
    state = {name: dict(value) for name, value in initial.items()}
    operations = [
        ("y", "a", "J", -1), ("y", "c", "R", -1),
        ("a", "x", "V", 1), ("c", "x", "G", 1),
        ("y", "c", "R", 1), ("y", "a", "J", 1),
        ("c", "x", "G", -1), ("a", "x", "V", -1),
    ]
    for target, control, symbol, sign in operations:
        state[target] = add_expr(
            state[target], apply_symbol(symbol, state[control]), sign)
    expected = dict(initial)
    expected["y"] = {("", "y"): 1, ("JV", "x"): 1, ("RG", "x"): 1}
    require(state == expected, "Arbitrary-scratch restoration failed")
    for target, control, symbol, sign in reversed(operations):
        state[target] = add_expr(
            state[target], apply_symbol(symbol, state[control]), -sign)
    require(state == initial, "Literal reversed inverse schedule failed")
    return {
        "coefficient_algebra": "free noncommutative words J,V,R,G over Z",
        "forward": "x=x0; y=y0+JV*x0+RG*x0; a=a0; c=c0",
        "inverse": "reverse the eight rows and negate every update",
        "old_scratch_assumed_zero": False,
    }


def matrix_product(left, right):
    return [[sum(left[i][k] * right[k][j] for k in range(len(right)))
             for j in range(len(right[0]))] for i in range(len(left))]


def scalar_orbits():
    records = []
    for intersection in range(4):
        bit_central = intersection % 2
        bit_side = int(intersection == 1)
        complex_central = Q(intersection - 1, 2)
        complex_side = (-complex_central
                        if intersection in (0, 2) else Q(0))
        target = int(intersection == 3)
        require((bit_central + bit_side) % 2 == target,
                "Bit incidence factorization failed")
        require(complex_central + complex_side == target,
                "Complex incidence factorization failed")
        records.append({
            "intersection": intersection,
            "bit_central": bit_central, "bit_side": bit_side,
            "complex_central": str(complex_central),
            "complex_side": str(complex_side), "net": target,
        })
    forward = [[1, 0], [1, 1]]
    middle = [[1, -1], [0, 1]]
    exchange = matrix_product(forward, matrix_product(middle, forward))
    require(exchange == [[0, -1], [1, 0]], "Signed exchange failed")
    symbols = ("J", "R", "V", "G", "R", "J", "G", "V")
    physical_orders = []
    for inverse in (False, True):
        source, target = ("Y", "X") if inverse else ("X", "Y")
        order = []
        for symbol in reversed(symbols) if inverse else symbols:
            bank = source if symbol in ("V", "G") else target
            kind = "side" if symbol in ("J", "V") else "center"
            order.append(f"{bank}-{kind}")
        physical_orders.append(order)
    require(physical_orders[0] == physical_orders[1],
            "Reversed middle stage has different physical gate incidences")
    return {"intersection_orbits": records, "exchange_matrix": exchange,
            "physical_time_order": physical_orders[0],
            "stage_two": "inverse row 7-r with logical banks exchanged"}


def indicator(indices, size):
    return [int(i in indices) for i in range(size)]


def rational_inner(left, right):
    return (sum(Q(x) * y for x, y in zip(left, right))
            - Q(sum(left) * sum(right), 9))


def binary_inner(left, right):
    return sum(x * y for x, y in zip(left, right)) % 2


def primitive_subspaces():
    source = set(range(3))
    tx = indicator(source, H)
    records = []
    for intersection in range(4):
        target = set(range(intersection)) | set(range(3, 6 - intersection))
        ty = indicator(target, H)
        rational_gram = [[rational_inner(tx, tx), rational_inner(tx, ty)],
                         [rational_inner(ty, tx), rational_inner(ty, ty)]]
        binary_gram = [[binary_inner(tx, tx), binary_inner(tx, ty)],
                       [binary_inner(ty, tx), binary_inner(ty, ty)]]
        require(rational_gram[0][0] == 2, "Rational triple norm failed")
        require(binary_gram[0][0] == 1, "Binary triple norm failed")
        require(rational_gram[0][1] == intersection - 1,
                "Rational triple pairing failed")
        require(binary_gram[0][1] == intersection % 2,
                "Binary triple pairing failed")
        # A rank-one projection is t * phi, and phi(t)=1.
        phi_q = [(Q(value) - Q(1, 3)) / 2 for value in tx]
        phi_b = tx
        require(sum(x * y for x, y in zip(phi_q, tx)) == 1,
                "Actual rational triple projector is not idempotent")
        require(binary_inner(phi_b, tx) == 1,
                "Actual binary triple projector is not idempotent")
        witness_index = min(set(range(H)) - source - target)
        witness = indicator({witness_index}, H)
        require(binary_inner(witness, tx) == binary_inner(witness, ty) == 0,
                "Residual coordinate witness not orthogonal")
        require(binary_inner(witness, witness) == 1,
                "Residual coordinate witness not a unit")
        if intersection == 1:
            require(sum(x * y for x, y in zip(phi_q, ty)) == 0,
                    "Rational neighboring projections not orthogonal")
        if intersection in (0, 2):
            require(binary_inner(phi_b, ty) == 0,
                    "Binary neighboring projections not orthogonal")
        records.append({
            "intersection": intersection,
            "rational_gram": [[str(v) for v in row] for row in rational_gram],
            "binary_gram": binary_gram,
            "unit_outside_union": witness_index,
        })
    require(Q(1) - Q(H, 9) != 0, "Degenerate rational ambient form")
    require(-Q(1, 9) + Q(1, 9-H) - Q(H, 9*(9-H)) == 0,
            "Rank-one formula for the ambient inverse failed")
    require(H > 6 and all(H**d > 3**d for d in (1, 2)),
            "A required binary coordinate-unit witness is unavailable")
    return {
        "ambient_rational_inverse": "I+J/(9-h)",
        "triple_projector_rational": "t*(t^T-(1/3)*1^T)/2",
        "triple_projector_binary": "t*t^T",
        "orbit_representatives": records,
        "coverage": "S_h is transitive on ordered triple pairs of each intersection size",
    }


# A polynomial records exact dimensions in the variables a,h,f.
def poly_add(left, right, scale=1):
    result = dict(left)
    for powers, value in right.items():
        result[powers] = result.get(powers, 0) + scale * value
        if not result[powers]:
            del result[powers]
    return result


def poly_mul(left, right):
    result = {}
    for x, cx in left.items():
        for y, cy in right.items():
            powers = tuple(i+j for i, j in zip(x, y))
            result[powers] = result.get(powers, 0) + cx*cy
    return {key: value for key, value in result.items() if value}


ONE = {(0, 0, 0): 1}
A = {(1, 0, 0): 1}
D = {(0, 1, 0): 1}
FUTURE = {(0, 0, 1): 1}
M = {(1, 1, 1): 1}


def poly_value(polynomial, a, h, f):
    return sum(c * a**i * h**j * f**k
               for (i, j, k), c in polynomial.items())


def serialized_poly(polynomial):
    return [{"powers_a_h_f": list(powers), "coefficient": value}
            for powers, value in sorted(polynomial.items())]


ATOMS = frozenset(product(("P", "B"), ("x", "y", "K"), ("Q", "R")))


def atom_dimension(atom):
    before, current, after = atom
    prefix = ONE if before == "P" else poly_add(A, ONE, -1)
    middle = ONE if current != "K" else poly_add(D, ONE, -2)
    suffix = ONE if after == "Q" else poly_add(FUTURE, ONE, -1)
    return poly_mul(poly_mul(prefix, middle), suffix)


def select(predicate):
    return frozenset(atom for atom in ATOMS if predicate(*atom))


def dimension(atoms):
    result = {}
    for atom in sorted(atoms):
        result = poly_add(result, atom_dimension(atom))
    return result


def construct_labels():
    zero = frozenset()
    full_stage = select(lambda p, t, q: q == "Q")
    common = select(lambda p, t, q: p == "B" and q == "Q")
    x_line = select(lambda p, t, q: t == "x" and q == "Q")
    y_in = select(lambda p, t, q: p == "B" and t == "y" and q == "Q")
    x_side = common | select(lambda p, t, q: p == "P" and t == "x" and q == "Q")
    y_side = common | select(lambda p, t, q: p == "P" and t != "y" and q == "Q")
    return {
        "X": [("in", x_line), ("2", x_side), ("3", full_stage),
              ("6", full_stage), ("7", full_stage)],
        "Y": [("in", y_in), ("0", y_in), ("1", common),
              ("4", common), ("5", y_side)],
        "center": [("source", zero), ("1", common), ("3", full_stage),
                   ("4", common), ("6", full_stage), ("sink", ATOMS)],
        "side": [("source", zero), ("0", y_in), ("2", x_side),
                 ("5", y_side), ("7", full_stage), ("sink", ATOMS)],
    }


def residuals_from_labels():
    labels = construct_labels()
    records = []
    totals = {}
    negative = []
    for role, vertices in labels.items():
        totals[role] = {}
        for (tail, u), (head, v) in zip(vertices, vertices[1:]):
            require(u <= v or v <= u, f"Incomparable {role} {tail}->{head}")
            decreasing = v < u
            residual = u - v if decreasing else v - u
            rank = dimension(residual)
            totals[role] = poly_add(totals[role], rank)
            if decreasing:
                negative.append((role, tail, head, rank))
            records.append({
                "role": role, "edge": f"{tail}->{head}",
                "direction": -1 if decreasing else 1,
                "residual_atoms": [list(atom) for atom in sorted(residual)],
                "dimension_polynomial": serialized_poly(rank),
                "dimensions_h100_by_stage": [
                    poly_value(rank, H**j, H, H**(2-j)) for j in range(3)],
            })
    require(negative == [("center", "3", "4", D)],
            "An unexpected decrease exists")
    require(totals["X"] == totals["Y"] == poly_mul(A, poly_add(D, ONE, -1)),
            "Data residual totals were not derived correctly")
    require(totals["side"] == M, "A side scratch edge was omitted")
    require(totals["center"] == poly_add(M, D, 2),
            "A central scratch edge was omitted")
    return {"atom_decomposition": "A=(P orthogonal B); F=(x orthogonal y orthogonal K); future=(Q orthogonal R)",
            "edges": records,
            "per_invocation_rank_by_role": {
                key: serialized_poly(value) for key, value in totals.items()},
            "all_nonzero_atoms_binary_nonalternating": True}


def boundaries():
    # Boolean spectral atoms of three commuting tensor-factor projectors.
    atoms = frozenset(product((0, 1), repeat=3))
    u = frozenset({(1, 1, 1)})
    x_previous = u
    y_previous = frozenset()
    for stage in range(3):
        x_in = frozenset(t for t in atoms if all(t[stage:]))
        prefix = frozenset(t for t in atoms if all(t[:stage]))
        y_in = x_in - prefix
        require(x_in == x_previous and y_in == y_previous,
                "A genuine interstage boundary does not match")
        x_previous = frozenset(t for t in atoms if all(t[stage+1:]))
        y_previous = x_previous - u
    require(x_previous == atoms and y_previous == atoms-u,
            "Final data endpoints do not match")
    return {
        "tensor_factors": 3, "spectral_atoms_checked": len(atoms),
        "X_source": "U", "X_sink": "full",
        "Y_source": "0", "Y_sink": "U_perp",
        "scratch_source": "0", "scratch_sink": "full",
        "negative_rational_source": "-P_U; first edge is 2P_U of rank one",
        "routed_rational_difference": {
            "X_to_Y": "(I-P_U)-(-P_U)=I",
            "Y_to_X": "I-0=I", "scratch_to_self": "I-0=I"},
    }


def binary_absorption():
    gram = [[1, 0, 0], [0, 0, 1], [0, 1, 0]]
    columns = [[1, 1, 1], [1, 0, 1], [0, 1, 1]]
    transpose = list(map(list, zip(*columns)))
    result = matrix_product(transpose, matrix_product(gram, columns))
    result = [[x % 2 for x in row] for row in result]
    require(result == [[1, 0, 0], [0, 1, 0], [0, 0, 1]],
            "Unit-line/hyperbolic-plane absorption failed")
    for x in product((0, 1), repeat=3):
        if any(x):
            require(any(sum(columns[i][j]*x[j] for j in range(3)) % 2
                        for i in range(3)), "Absorption change of basis singular")
    return {"basis_columns_in_w_a_b": columns, "new_gram": result,
            "induction": "split unit lines, split remaining alternating planes, absorb each plane using one retained unit line"}


def gaussian(real=0, imag=0):
    return (Q(real), Q(imag))


def gadd(left, right):
    return (left[0]+right[0], left[1]+right[1])


def gmul(left, right):
    return (left[0]*right[0]-left[1]*right[1],
            left[0]*right[1]+left[1]*right[0])


def gscale(matrix, value):
    return [[gmul(value, entry) for entry in row] for row in matrix]


def gmatmul(left, right):
    result = []
    for row in left:
        out = []
        for col in zip(*right):
            value = gaussian()
            for x, y in zip(row, col):
                value = gadd(value, gmul(x, y))
            out.append(value)
        result.append(out)
    return result


def phase_identities():
    for x, y in product((0, 1), repeat=2):
        require((x ^ y) == x+y-2*x*y, "Hamming XOR identity failed")
    for q, u, bit in product(range(4), (1, 3), (0, 1)):
        require((q - 2*u*bit) % 4 == (q + 2*bit) % 4,
                "Odd-line endpoint phase identity failed")
    a, b = gaussian(Q(1, 2), Q(1, 2)), gaussian(Q(1, 2), -Q(1, 2))
    c, ci = [[a, b], [b, a]], [[b, a], [a, b]]
    zero, one = gaussian(), gaussian(1)
    identity = [[one, zero], [zero, one]]
    z = [[one, zero], [zero, gaussian(-1)]]
    require(gmatmul(c, ci) == identity, "C inverse failed")
    require(gscale(gmatmul(z, gmatmul(ci, z)), gaussian(0, 1)) == c,
            "C=i Z C^-1 Z failed")
    require(gscale(gmatmul(z, gmatmul(c, z)), gaussian(0, -1)) == ci,
            "C^-1=-i Z C Z failed")
    walsh = [[one, one], [one, gaussian(-1)]]
    for sign, expected in ((1, c), (-1, ci)):
        diagonal = [[one, zero], [zero, gaussian(0, sign)]]
        actual = gscale(gmatmul(walsh, gmatmul(diagonal, walsh)),
                        gaussian(Q(1, 2)))
        require(actual == expected, "Character-to-translation kernel failed")
    for k_mod_4 in range(4):
        require((27*k_mod_4) % 4 == (3*k_mod_4) % 4,
                "Global endpoint scalar exponent failed")
    return {
        "weight_pair_identity": "wt(z xor w)=wt(z)+wt(w)-2*overlap(z,w)",
        "orthogonal_weight_additivity": "even overlap implies equality modulo 4; induct over an orthogonal basis",
        "residual_kernel": "coefficient sign is edge direction times odd basis weight modulo 4",
        "C_inverse_and_Z_identities": True,
        "X_to_Y_correction": "input Z_(a,k); output i^(27k) Z_(a,k)",
        "Y_to_X_correction": "negate physical X output once, not once per column",
        "scratch_correction": "none",
        "all_roles": "undo rho after output correction",
        "column_quantifier": "every integer k>=1, by tensoring operator identities",
    }


def parameters(h):
    v, m = comb(h, 3), h**3
    n, invocations = v**3, 3*v*v
    result = {"h": h, "v": v, "N": n, "m": m, "I": invocations}
    for name, degree, centers in (
            ("bit", 3*comb(h-3, 2), h),
            ("complex", comb(h-3, 3)+3*(h-3), h+1)):
        wires = 2*n + invocations*(v*degree+centers)
        loss = invocations*centers*h
        direct = 0
        multiplicities = {"X": v, "Y": v, "side": v*degree, "center": centers}
        for stage in range(3):
            per_invocation = 0
            for role, vertices in construct_labels().items():
                for (_, tail), (_, head) in zip(vertices, vertices[1:]):
                    residual = tail-head if head <= tail else head-tail
                    rank = poly_value(dimension(residual), h**stage, h, h**(2-stage))
                    per_invocation += multiplicities[role] * rank
            direct += v*v * per_invocation
        require(direct == wires*m-2*n+2*loss, "Direct rank budget failed")
        ranks = direct + (n if name == "bit" else 0)
        require(ranks < wires*m, "Strict saving failed")
        eta = Q(wires*m-ranks, wires*m)
        result[name] = {
            "neighbors": degree, "central_wires": centers,
            "W": wires, "L": loss, "L_over_N": str(Q(loss, n)),
            "absolute_dimension_budget": direct,
            "negative_source_rank_correction": n if name == "bit" else 0,
            "s": ranks, "deficit": wires*m-ranks, "eta": str(eta),
        }
    return result


def uniform_thresholds():
    # For h=40+t, these are the exact numerators of v-6ch.
    for centers_offset, constant in ((0, 42), (1, 6)):
        h_at_zero = 40
        coefficients = (
            h_at_zero*h_at_zero-39*h_at_zero+2-36*centers_offset,
            2*h_at_zero-39, 1)
        require(coefficients == (constant, 41, 1),
                "Uniform loss-ratio polynomial failed")
    return {
        "theorem_range": "all integers h>=40",
        "reason": "for h=40+t, t>=0: (h-1)(h-2)-36(h+e)=t^2+41t+42-36e>0 for e=0,1",
        "binary_unit_witness_condition": "h>6 and h^d>3^d for d=1,2",
        "rational_ambient_condition": "h!=9",
        "consequence": "L<N/2 in both constructions, hence both interface deficits are positive",
    }


def jacobian_binding(primitive):
    payload = json.loads((HERE / "jacobian_payload.json").read_text())
    response = json.loads((HERE / "jacobian_result.json").read_text())
    status = json.loads((HERE / "jacobian_status.json").read_text())
    expected = primitive["orbit_representatives"][1]["rational_gram"]
    actual = [[str(Q(entry["num"])/Q(entry["den"])) for entry in row]
              for row in payload["matrix"]["entries"]]
    require(actual == expected, "Jacobian payload is not the actual Gram matrix")
    require(status["adapter_exit_code"] == 0, "Jacobian adapter did not succeed")
    require(response["result"]["operation_id"] == "matrix.rank.compute",
            "Unexpected Jacobian operation")
    require(response["request"]["payload"] == payload,
            "Jacobian typed response not bound to exact payload")
    output = response["result"]["output"]
    require(output["matrix"] == payload["matrix"],
            "Jacobian output names a different source matrix")
    require(output["rank"] == 2 and output["pivot_columns"] == [0, 1],
            "Jacobian did not certify the neighboring Gram rank")
    require(output["method"] == "EXACT_RATIONAL_ROW_REDUCTION",
            "Jacobian result is not exact rational algebra")
    return {"operation_id": response["result"]["operation_id"],
            "protocol_version": response["protocol_version"],
            "server_version": response["server"]["version"],
            "adapter_exit_code": status["adapter_exit_code"],
            "rank": output["rank"]}


def certificate():
    primitive = primitive_subspaces()
    result = {
        "result_class": "exact_verification_theorem",
        "claim": "C_FINITE_CORE",
        "scope": "Section 03 only; no multiplication complexity or novelty certification",
        "quantifiers": {
            "ground_size": "every integer h>=40; exact manuscript specialization h=100",
            "scalar_inputs": "all values in F_2 or Z[i,1/2], including arbitrary scratch",
            "arrays": "all arrays on any common finite address set with common invertible linear frames",
            "phase_columns": "all integers k>=1",
            "roles": "all data and every ordered-neighbor and central scratch role",
        },
        "transparent_restoration": transparent_schedule(),
        "scalar": scalar_orbits(),
        "primitive_subspaces": primitive,
        "derived_residuals": residuals_from_labels(),
        "boundaries_and_shear": boundaries(),
        "binary_basis_structure": binary_absorption(),
        "phase": phase_identities(),
        "uniform_extension": uniform_thresholds(),
        "manuscript_parameters": parameters(H),
        "jacobian": jacobian_binding(primitive),
        "limitations": [
            "The certificate is an exact algebraic replay plus a mathematical proof, not a formalization of all of section 03.",
            "Lean evidence for structural lemmas is recorded separately by the official compiler adapter.",
            "No counterexample or false manuscript assertion was found in the certified scope.",
            "Fixed-tape realization, analytic transforms, precision recovery and the full multiplication theorem remain open.",
            "Independent Reviewer replay and judgement are required; novelty is not asserted.",
        ],
    }
    expected = {
        "bit": (177176569091445000000, 177176569088785861287000000,
                "100/539", "339/22587335000000"),
        "complex": (1873807244643542670000, 1873807244636671267308000000,
                    "101/539", "73/19906842167500"),
    }
    for name, values in expected.items():
        actual = result["manuscript_parameters"][name]
        require((actual["W"], actual["s"], actual["L_over_N"], actual["eta"]) == values,
                f"The exact {name} manuscript numerals do not agree")
        require(Q(actual["eta"]) > Q(20, 2**50),
                f"The exact {name} exponent margin failed")
    return result


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--write", action="store_true",
                        help="Generate the exact certificate before review")
    args = parser.parse_args()
    result = certificate()
    target = HERE / "exact_certificate.json"
    if args.write:
        target.write_text(json.dumps(result, indent=2, sort_keys=True) + "\n")
    else:
        require(json.loads(target.read_text()) == result,
                "Stored certificate differs from exact replay")
    print("PASS: exact all-role finite-network algebra; h=100 and uniform h>=40")
    print("No zero-scratch assumption; signed stage 2, all scratch edges, negative sources and all-k phase corrections included.")


if __name__ == "__main__":
    main()
