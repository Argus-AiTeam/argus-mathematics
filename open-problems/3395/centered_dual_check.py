#!/usr/bin/env python3
"""Exact centered-error and sparse-coupling checks; the dual charge is open."""

import argparse
import itertools
import json
import math
import sys
import time
from fractions import Fraction as F
from pathlib import Path

sys.dont_write_bytecode = True
from joint_spectral_band_check import (
    Circuit, booleanize, compulsory_sets, decompose, encode, evaluate_dag,
    expand, full_product, project_polynomial, rref,
)
from spectral_cut_check import gram, multiply

ROOT = Path(__file__).resolve().parent
OPERATION = "matrix.symmetric.rational_spectrum_claim.check"
Q = 3
ORDER = 1 << Q
SIDE = set(range(6))
DISTINGUISHED = (0, 6, 8)


def inner(a, b):
    return sum((x*y for ar, br in zip(a, b) for x, y in zip(ar, br)), F(0))


def centered(matrix):
    size = len(matrix)
    rows = [sum(row)/size for row in matrix]
    columns = [sum(column)/size for column in zip(*matrix)]
    mean = sum(rows)/size
    return [[matrix[i][j]-rows[i]-columns[j]+mean for j in range(size)]
            for i in range(size)]


def delta(matrix, u, v, up, vp):
    return matrix[u][v]-matrix[up][v]-matrix[u][vp]+matrix[up][vp]


def example():
    c = Circuit()
    variables = [c.variable(i) for i in range(24)]
    groups = tuple((2*i, 2*i+1) for i in range(12))
    sums = [c.add(variables[2*i], variables[2*i+1]) for i in range(12)]
    two = c.constant(2)
    wc = variables[17]
    weighted_c = c.add(variables[16], c.multiply(two, c.multiply(wc, wc)))
    v_other = full_product(c, [sums[g] if g != 8 else weighted_c
                              for g in range(7, 12)])
    v = c.multiply(sums[6], v_other)
    wa = variables[1]
    cube = c.multiply(c.multiply(wa, wa), wa)
    weighted_a = c.add(variables[0], c.multiply(two, cube))
    fs = full_product(c, [weighted_a, *sums[1:6]])
    half = c.constant(F(1, 2))
    scaled_fs = c.multiply(half, fs)
    optional = c.multiply(half, variables[13])
    a = c.multiply(scaled_fs, c.add(c.constant(1), optional))
    root = c.multiply(a, v)
    return c, root, groups, a, v, fs, v_other, optional


def point(u, v):
    mask = 0
    for bit in range(Q):
        for partner in (0, 1):
            mask |= 1 << (2*(2*bit+partner)+((u >> bit) & 1))
            mask |= 1 << (2*(6+2*bit+partner)+((v >> bit) & 1))
    return mask


def full_value(mask, groups):
    return math.prod(sum((mask >> i) & 1 for i in group) for group in groups)


def defect_value(values, mask, fs, v_other):
    return F(1, 4)*values[fs]*values[v_other]*((mask >> 12) & 1)*((mask >> 13) & 1)


def matrices(c, root, a, v):
    all_on = (1 << 24)-1
    smask = (1 << 12)-1
    bmask = all_on ^ smask
    matrix, upper, error, heavy = [], [], [], []
    for u in range(ORDER):
        mr, rr, er, wr = [], [], [], []
        for col in range(ORDER):
            mask = point(u, col)
            actual = evaluate_dag(c, mask)[root]
            completed = (evaluate_dag(c, (mask & smask) | bmask)[a]
                         * evaluate_dag(c, smask | (mask & bmask))[v])
            expected = F(1, 2)*(1+(u & 1))*(1+F(col & 1, 2))*(1+((col >> 1) & 1))
            expected_upper = F(3, 4)*(1+(u & 1))*(1+((col >> 1) & 1))
            assert actual == expected and completed == expected_upper <= 3
            mr.append(actual)
            rr.append(completed)
            er.append(completed-actual)
            wr.append(F(1, 4)*(1+(u & 1))*(col & 1)*(1+((col >> 1) & 1)))
        matrix.append(mr)
        upper.append(rr)
        error.append(er)
        heavy.append(wr)
    return matrix, upper, error, heavy


def payload():
    c, root, _, a, v, _, _, _ = example()
    error = matrices(c, root, a, v)[2]
    return {
        "matrix": encode(gram(centered(error))),
        "claimed_profile": [
            {"eigenvalue": {"num": "0", "den": "1"}, "multiplicity": 7},
            {"eigenvalue": {"num": "11", "den": "16"}, "multiplicity": 1},
        ],
    }


def verify_circuit(c, root, groups, a, v, fs, v_other, optional):
    mandatory = compulsory_sets(c, groups)
    assert mandatory[a] == SIDE
    assert mandatory[v] == set(range(12))-SIDE
    original = expand(c, root, 24)
    projection = project_polynomial(original, groups)
    boolean = booleanize(original)
    compatible = booleanize(projection)
    defect = {monomial: coefficient-compatible.get(monomial, F(0))
              for monomial, coefficient in boolean.items()}
    assert all(value >= 0 for value in defect.values())
    defect = {monomial: coefficient for monomial, coefficient in defect.items()
              if coefficient}
    reference = Circuit()
    reference.gates = c.gates.copy()
    wb, zb = reference.variable(13), reference.variable(12)
    expected_defect = full_product(reference, [
        reference.constant(F(1, 4)), fs, v_other, wb, zb,
    ])
    assert defect == booleanize(expand(reference, expected_defect, 24))
    heavy_root = full_product(reference, [
        reference.constant(F(1, 2)), fs, optional, v,
    ])
    heavy_polynomial = expand(reference, heavy_root, 24)
    assert heavy_polynomial == {
        exponent: coefficient for exponent, coefficient in original.items()
        if exponent[12]+exponent[13] == 2
    }
    for exponent in original:
        assert all(any(exponent[i] for i in group) for group in groups)
    transformed, output, residual, cuts, stats = decompose(c, root, groups)
    assert cuts[0]["gate"] == a
    assert expand(transformed, cuts[0]["context"], 24) == expand(c, v, 24)
    assert expand(transformed, cuts[0]["term"], 24) == original
    assert expand(transformed, cuts[0]["after"], 24) == {}
    assert expand(transformed, residual, 24) == {}
    assert expand(transformed, output, 24) == original
    heavy = matrices(c, root, a, v)[3]
    for u, col in itertools.product(range(ORDER), repeat=2):
        assert evaluate_dag(reference, point(u, col))[heavy_root] == heavy[u][col]
    maximum = F(0)
    for local in range(64):
        mask = sum(1 << groups[g][0] for g in range(12) if g not in DISTINGUISHED)
        for pos, group in enumerate(DISTINGUISHED):
            for bit in (0, 1):
                if local & (1 << (2*pos+bit)):
                    mask |= 1 << (2*group+bit)
        values = evaluate_dag(c, mask)
        f = full_value(mask, groups)
        d = defect_value(values, mask, fs, v_other)
        assert 0 <= d <= values[root] <= 3*f
        if f:
            maximum = max(maximum, d/f)
        else:
            assert values[root] == d == 0
    assert maximum == F(1, 2)
    return {
        **stats, "actual_nonzero_cuts": 1, "variables": 24, "groups": 12,
        "formal_monomials": len(original), "formal_degree": max(map(sum, original)),
        "projection_monomials": len(projection), "heavy_monomials": len(heavy_polynomial),
        "coefficientwise_defect_identity": True, "finite_heavy_cutoff": 0,
        "distinguished_group_boolean_inputs": 64, "exact_b_Q": str(maximum),
        "other_group_coverage": "Exact full-group factors cancel; zero faces vanish.",
        "individually_enumerated_full_physical_cube": False,
    }


def verify_centering(error, heavy):
    x = centered(error)
    assert all(sum(row) == 0 for row in x)
    assert all(sum(column) == 0 for column in zip(*x))
    assert len(rref(error)[1]) == len(rref(x)[1]) == 1
    eigenvalue = inner(x, x)
    assert eigenvalue == F(11, 16)
    gx = gram(x)
    assert multiply(gx, gx) == [[eigenvalue*v for v in row] for row in gx]
    a = sum(map(sum, heavy))/ORDER**2
    assert a == F(9, 32) >= F(1, 4)
    assert Q >= F(5, 4)*2
    energy = eigenvalue/(ORDER**3*a)
    raw_energy = inner(error, error)/(ORDER**3*a)
    assert energy == F(11, 2304) and raw_energy == F(25, 288)
    assert energy <= raw_energy <= 2*energy+F(36, ORDER)/a
    t = 1/(a*ORDER)
    objective = eigenvalue*(2*t/ORDER**2-a*t*t/ORDER)
    assert objective == energy
    for trial in (F(-3), F(0), F(2, 7), t, F(5)):
        value = eigenvalue*(2*trial/ORDER**2-a*trial*trial/ORDER)
        assert energy-value == a*eigenvalue/ORDER*(trial-t)**2
    return x, {
        "matrix_order": ORDER, "centered_rank": 1,
        "gram_nonzero_eigenvalue": str(eigenvalue), "heavy_mean": str(a),
        "centered_energy": str(energy), "uncentered_error_energy": str(raw_energy),
        "finite_k0": 2, "finite_strong_good_and_thick": True,
        "dual_equality": "Exact rational quadratic with Y=t*X/sqrt(m), t=1/(a*m).",
        "scope": "Abstract finite parameters, not the asymptotic admissible N recipe.",
    }


def walsh_operators(cutoff):
    p = F(1, 2*Q)
    rho = 1-2*p
    transition = [
        [p**((u ^ v).bit_count())*(1-p)**(Q-(u ^ v).bit_count())
         for v in range(ORDER)] for u in range(ORDER)
    ]
    identity_minus_t = [[F(int(u == v))-transition[u][v]
                         for v in range(ORDER)] for u in range(ORDER)]
    h = [[F(0) for _ in range(ORDER)] for _ in range(ORDER)]
    inverse = [[F(0) for _ in range(ORDER)] for _ in range(ORDER)]
    for subset in range(ORDER):
        degree = subset.bit_count()
        if degree < cutoff:
            continue
        character = [(-1)**((u & subset).bit_count()) for u in range(ORDER)]
        for u, v in itertools.product(range(ORDER), repeat=2):
            atom = F(character[u]*character[v], ORDER)
            h[u][v] += atom
            inverse[u][v] += atom/(1-rho**degree)
    assert multiply(h, h) == h
    assert multiply(inverse, identity_minus_t) == h
    assert multiply(identity_minus_t, inverse) == h
    return h, inverse


def verify_coupling(c, root, groups, fs, v_other, error, x):
    count = ORDER**2
    mask_count = 1 << (2*Q)
    base_total = (2*Q)**(2*Q)
    tilted_total = (2*Q+3)**(2*Q)
    marginals = [[[[0]*count for _ in range(4)] for _ in range(ORDER)]
                 for _ in range(2)]
    normalization = 0
    total_defect = F(0)
    cases = []
    generic = [[F(((u+3)*(v+5)+u.bit_count()+v.bit_count()) % 13, 4)
                for v in range(ORDER)] for u in range(ORDER)]
    for cutoff, source, test in ((1, error, x), (2, generic, generic)):
        h, inverse = walsh_operators(cutoff)
        y = multiply(multiply(h, test), h)
        transformed = multiply(multiply(inverse, y), inverse)
        target = 4*inner(y, multiply(multiply(h, source), h))/ORDER**2
        cases.append({
            "cutoff": cutoff, "source": source, "y": y,
            "transformed": transformed, "target": target, "sum": F(0),
        })
    witness = None
    for base in range(count):
        u, v = base & (ORDER-1), base >> Q
        for flips in range(mask_count):
            changed = flips.bit_count()
            weight = (2*Q-1)**(2*Q-changed)
            tilted_weight = weight*4**changed
            up = u ^ (flips & (ORDER-1))
            vp = v ^ (flips >> Q)
            union = point(u, v) | point(up, vp)
            f = full_value(union, groups)
            assert f == 4**changed
            normalization += weight*f
            values = evaluate_dag(c, union)
            d = defect_value(values, union, fs, v_other)
            assert 0 <= d <= F(1, 2)*f
            total_defect += weight*d
            for honored in range(ORDER):
                er = flips & honored
                ec = flips & (honored << Q)
                corners = (base, base ^ er, base ^ ec, base ^ er ^ ec)
                for pos, corner in enumerate(corners):
                    marginals[0][honored][pos][corner] += weight
                    marginals[1][honored][pos][corner] += tilted_weight
                    cu, cv = corner & (ORDER-1), corner >> Q
                    assert point(cu, cv) & union == point(cu, cv)
            for case in cases:
                case["sum"] += weight*delta(case["transformed"], u, v, up, vp)*delta(
                    case["source"], u, v, up, vp)
            if (u, v, up, vp) == (0, 0, 1, 2):
                ordinary = delta(x, u, v, up, vp)*delta(error, u, v, up, vp)
                polarized = delta(cases[0]["transformed"], u, v, up, vp)*delta(
                    error, u, v, up, vp)
                assert d == 0 and f == 16
                assert ordinary == F(1, 16) and polarized == F(9, 20)
                witness = {
                    "row": u, "column": v, "row_copy": up, "column_copy": vp,
                    "common_union_F": f, "common_union_defect": str(d),
                    "centered_signed_product": str(ordinary),
                    "noise_inverse_signed_product": str(polarized),
                }
    assert normalization == count*tilted_total
    for law, expected in ((0, base_total), (1, tilted_total)):
        assert all(value == expected for honored in marginals[law]
                   for corner in honored for value in corner)
    normalization /= F(count*base_total)
    total_defect /= count*base_total
    assert normalization == F(729, 64)
    assert total_defect <= normalization/2
    polarization = []
    for case in cases:
        expectation = case["sum"]/(count*base_total)
        assert expectation == case["target"]
        polarization.append({"cutoff": case["cutoff"], "exact_pairing": str(expectation)})
    assert polarization[0]["exact_pairing"] == "11/256"
    assert witness is not None
    return {
        "base_string_flip_mask_outcomes": count*mask_count, "q": Q,
        "flip_probability": "1/6", "tilted_flip_probability": "4/9",
        "normalization": str(normalization), "raw_expected_defect": str(total_defect),
        "whole_output_defect_upper_bound": str(normalization/2),
        "honored_subsets_checked": ORDER, "corner_marginals_per_law": ORDER*4,
        "original_and_tilted_marginals_uniform": True,
        "cutoff_polarization": polarization, "pointwise_localization_obstruction": witness,
        "scope": "The one common defect budget is verified, not the missing signed charge.",
    }


def verify_adapter():
    source = json.loads((ROOT / "centered-spectrum-payload.json").read_text())
    record = json.loads((ROOT / "centered-spectrum-output.json").read_text())
    assert source == payload()
    assert record["request"] == {"operation_id": OPERATION, "payload": source}
    assert record["result"]["operation_id"] == OPERATION
    assert record.get("error") is None and record["result"].get("error") is None
    output = record["result"]["output"]
    assert output["matrix"] == source["matrix"]
    assert output["claimed_profile"] == source["claimed_profile"]
    assert output["outcome"] == "VALID" and output["valid_complete_rational_spectrum"]
    assert output["matrix_order"] == output["claimed_multiplicity_sum"] == ORDER
    assert output["established_multiplicity_sum"] == ORDER
    assert output.get("first_failed_claim_index") is None
    assert output.get("first_failed_condition") is None
    matrix = [[F(int(value["num"]), int(value["den"])) for value in row]
              for row in source["matrix"]["entries"]]
    expected_ledger = []
    for claim in source["claimed_profile"]:
        eigenvalue = F(int(claim["eigenvalue"]["num"]), int(claim["eigenvalue"]["den"]))
        shifted = [[matrix[u][v]-eigenvalue*int(u == v) for v in range(ORDER)]
                   for u in range(ORDER)]
        nullity = ORDER-len(rref(shifted)[1])
        assert nullity == claim["multiplicity"]
        expected_ledger.append({
            "eigenvalue": claim["eigenvalue"],
            "claimed_multiplicity": claim["multiplicity"],
            "exact_nullity": nullity, "multiplicity_matches": True,
        })
    assert output["nullity_ledger"] == expected_ledger
    assert output["method"] == "PYTHON_FLINT_EXACT_RANK_AFTER_ROW_DENOMINATOR_CLEARING"
    return {
        "operation_id": OPERATION, "outcome": output["outcome"],
        "nullity_ledger": expected_ledger, "server_version": record["server"]["version"],
        "protocol_version": record["protocol_version"], "transport": record["transport"],
        "runtime_ms": record["result"]["runtime_ms"], "structured_error": None,
        "adapter_exit": 0, "timeout": False, "complete_source_bound_result": True,
    }


def walsh_transform(values):
    result = list(values)
    width = 1
    while width < len(result):
        for start in range(0, len(result), 2*width):
            for offset in range(width):
                left, right = result[start+offset], result[start+offset+width]
                result[start+offset], result[start+offset+width] = left+right, left-right
        width *= 2
    return result


def verify_parity_family():
    reports = []
    for k, d, cutoff in ((6, 1, 2), (9, 2, 3)):
        size = 1 << k
        distinguished = (1 << d)-1
        rho = 1-F(1, k)
        eigenvalue = {degree: 1-rho**degree for degree in range(1, k+1)}
        active = [int(v & distinguished == distinguished) for v in range(size)]
        parity = [(-1)**((v >> d).bit_count()) for v in range(size)]
        h = [(F(3, 2)+F(parity[v], 2))*(1-active[v]) for v in range(size)]
        coefficients = [value/size for value in walsh_transform(h)]
        high_coefficients = [
            value if subset.bit_count() >= cutoff else F(0)
            for subset, value in enumerate(coefficients)
        ]
        high = walsh_transform(high_coefficients)
        assert high == [F(parity[v], 2)*(1-active[v]) for v in range(size)]
        inverse_coefficients = [
            value/eigenvalue[subset.bit_count()] if value else F(0)
            for subset, value in enumerate(high_coefficients)
        ]
        inverse = walsh_transform(inverse_coefficients)
        j = (1/eigenvalue[k-d]
             -F(1, 1 << d)*sum(F((-1)**t*math.comb(d, t))/eigenvalue[k-d+t]
                              for t in range(d+1)))
        assert j >= 1
        assert inverse[0] == j/2 and inverse[1 << d] == -j/2
        norm_squared = F(size, 4)*sum(value*value for value in high)/16
        assert norm_squared == F(size**2, 256)*(1-F(1, 1 << d))
        mean = F(9, 16*(1 << d))
        t = F(1, size**2)
        # Replacing sqrt(m) by one gives a rational lower bound on CD20.
        lower = t*j/(32*eigenvalue[k])-mean*t*t*norm_squared
        assert lower >= F(247, 8192*size**2) > 0
        reports.append({
            "k": k, "optional_count": d, "finite_high_cutoff": cutoff,
            "column_strings": size, "heavy_mean": str(mean),
            "high_rank_one_norm_squared": str(norm_squared),
            "inverse_column_value_J": str(j),
            "regularized_pointwise_lower_bound": str(lower),
            "scope": "Finite Walsh identities, not an admissible large-graph experiment.",
        })
    return reports


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--payload", action="store_true")
    args = parser.parse_args()
    if args.payload:
        print(json.dumps(payload(), sort_keys=True))
        return
    start = time.monotonic()
    example_data = example()
    c, root, groups, a, v, fs, v_other, _ = example_data
    circuit = verify_circuit(*example_data)
    _, _, error, heavy = matrices(c, root, a, v)
    x, matrix = verify_centering(error, heavy)
    coupling = verify_coupling(c, root, groups, fs, v_other, error, x)
    parity_family = verify_parity_family()
    adapter = verify_adapter()
    print(json.dumps({
        "status": "passed", "circuit": circuit, "centered_matrix": matrix,
        "sparse_coupling": coupling, "parity_family": parity_family, "adapter": adapter,
        "elapsed_seconds": round(time.monotonic()-start, 3),
        "dual_charge_proved": False, "fixed_factor_theorem_proved": False,
        "independent_review": "pending_host",
    }, indent=2, sort_keys=True))


if __name__ == "__main__":
    main()
