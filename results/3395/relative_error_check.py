#!/usr/bin/env python3
"""Exact capped relative-error obstruction checks; T5 and E4 remain open."""

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
    Circuit, Gate, compulsory_sets, decompose, encode,
    evaluate_dag, expand, full_product, project_polynomial, rref,
)
from spectral_cut_check import multiply, sum_gates

ROOT = Path(__file__).resolve().parent
OPERATION = "matrix.characteristic_polynomial.compute"
SIGMA = F(3)
MARKED = (6, 7, 12, 13)
SIDE = set(range(6)) | set(range(14, 18))
ORDER = 8
D = 2
R = 2


def conditional_matrices(z, sigma=SIGMA):
    amplitude = sigma/6
    counts = [2*z+2*(y & 1) for y in range(ORDER)]
    values = [amplitude if k >= R else F(0) for k in counts]
    upper_values = [amplitude*6/math.comb(k, D) if k >= R else F(0)
                    for k in counts]
    matrix = [values.copy() for _ in range(ORDER)]
    upper = [upper_values.copy() for _ in range(ORDER)]
    error = [[a-b for a, b in zip(ar, br)] for ar, br in zip(upper, matrix)]
    return matrix, upper, error


def gram(matrix):
    return multiply(matrix, list(zip(*matrix)))


def payload():
    return {"matrix": encode(gram(conditional_matrices(0)[2]))}


def example():
    c = Circuit()
    variables = [c.variable(i) for i in range(34)]
    groups = tuple((2*i, 2*i+1) for i in range(14)) + tuple(
        (i,) for i in range(28, 34)
    )
    sums = [sum_gates(c, (variables[i] for i in group)) for group in groups]
    y = [variables[2*g+1] for g in MARKED]
    z = [variables[2*g] for g in MARKED]
    states = [c.constant(1)]
    for yi, zi in zip(y, z):
        nxt = [c.multiply(zi, states[0])]
        for k in range(1, len(states)):
            nxt.append(c.add(c.multiply(zi, states[k]),
                             c.multiply(yi, states[k-1])))
        nxt.append(c.multiply(yi, states[-1]))
        states = nxt
    weighted = sum_gates(c, (
        c.multiply(c.constant(F(1, math.comb(k, D))), states[k])
        for k in range(R, 5)
    ))
    other_b = set(range(20))-SIDE-set(MARKED)
    fb = full_product(c, [sums[g] for g in sorted(other_b)])
    v = c.multiply(fb, weighted)
    fs = full_product(c, [sums[g] for g in sorted(SIDE)])
    elementary = sum_gates(c, (c.multiply(y[i], y[j])
                              for i in range(4) for j in range(i+1, 4)))
    a = c.multiply(c.multiply(c.constant(SIGMA/6), fs), elementary)
    root = c.multiply(a, v)
    return c, root, groups, a, v, fs, fb, states


def point(x, y, z):
    mask = ((1 << 6)-1) << 28
    for i in range(3):
        for source in range(2):
            mask |= 1 << (4*i+2*source+((x >> i) & 1))
            mask |= 1 << (12+4*i+2*source+((y >> i) & 1))
    for source in range(2):
        mask |= 1 << (24+2*source+z)
    return mask


def verify_circuit():
    c, root, groups, a, v, fs, fb, states = example()
    mandatory = compulsory_sets(c, groups)
    assert mandatory[a] == SIDE
    assert mandatory[v] == set(range(20))-SIDE
    original = expand(c, root, 34)
    projection = project_polynomial(original, groups)
    reference = Circuit()
    reference.gates = c.gates.copy()
    expected = reference.multiply(
        reference.constant(SIGMA/6),
        reference.multiply(reference.multiply(fs, fb),
                           sum_gates(reference, states[R:])),
    )
    assert projection == expand(reference, expected, 34)
    for exponent in original:
        assert all(any(exponent[i] for i in group) for group in groups)
    a_poly, v_poly = expand(c, a, 34), expand(c, v, 34)
    optional = {
        len({g for g in MARKED if exponent[2*g+1]})
        for exponent in a_poly
    }
    assert optional == {D}
    assert all(not any(exponent[i] for g in SIDE for i in groups[g])
               for exponent in v_poly)
    transformed, output, residual, cuts, stats = decompose(c, root, groups)
    assert cuts[0]["gate"] == a
    assert expand(transformed, cuts[0]["context"], 34) == v_poly
    assert expand(transformed, cuts[0]["term"], 34) == original
    assert expand(transformed, cuts[0]["after"], 34) == {}
    assert expand(transformed, residual, 34) == {}
    assert expand(transformed, output, 34) == original
    zeroed = Circuit()
    zeroed.gates = c.gates.copy()
    zeroed.gates[a] = Gate("constant", value=F(0))
    assert expand(zeroed, root, 34) == {}
    all_on = (1 << 34)-1
    smask = sum(1 << i for g in SIDE for i in groups[g])
    bmask = all_on ^ smask
    checks = 0
    for z in (0, 1):
        matrix, upper, _ = conditional_matrices(z)
        for x, y in itertools.product(range(ORDER), repeat=2):
            mask = point(x, y, z)
            assert evaluate_dag(c, mask)[root] == matrix[x][y]
            actual_upper = (evaluate_dag(c, (mask & smask) | bmask)[a]
                            * evaluate_dag(c, smask | (mask & bmask))[v])
            assert actual_upper == upper[x][y]
            checks += 1
    return {
        **stats, "groups": len(groups), "variables": 34,
        "actual_nonzero_cuts": 1, "formal_source_monomials": len(original),
        "projection_monomials": len(projection),
        "formal_degree": max(map(sum, original)),
        "optional_nonroot_count": D, "finite_heavy_cutoff": 1,
        "entire_actual_cut_heavy": True,
        "coefficientwise_projection": True,
        "exact_first_divided_context": True,
        "conditional_matrix_and_completion_entries_bound": checks,
        "scope": "Abstract finite restrictions; not an admissible physical graph.",
    }, c, root, groups


def verify_cube(circuit, root, groups):
    maximum, maximizer = F(0), None
    count = 0
    for local in range(256):
        mask = sum(1 << group[0] for g, group in enumerate(groups) if g not in MARKED)
        for pos, g in enumerate(MARKED):
            for b in (0, 1):
                if local & (1 << (2*pos+b)):
                    mask |= 1 << (2*g+b)
        available_y = sum((local >> (2*i+1)) & 1 for i in range(4))
        elementary = math.comb(available_y, D) if available_y >= D else 0
        counts = [0]*5
        for choices in itertools.product((0, 1), repeat=4):
            if all(local & (1 << (2*i+b)) for i, b in enumerate(choices)):
                counts[sum(choices)] += 1
        f = sum(counts)
        v = sum((F(counts[k], math.comb(k, D)) for k in range(R, 5)), F(0))
        actual = evaluate_dag(circuit, mask)[root]
        assert actual == SIGMA/6*elementary*v
        projected = SIGMA/6*sum(counts[R:])
        assert 0 <= projected <= actual <= SIGMA*f
        if f:
            relative = (actual-projected)/f
            if relative > maximum:
                maximum, maximizer = relative, local
        else:
            assert actual == 0
        count += 1
    return {
        "marked_group_boolean_inputs": count,
        "exact_b_Q": str(maximum), "maximizing_local_mask": maximizer,
        "all_other_groups": "Exact full-group factors cancel from Q/F and defect/F.",
        "group_zero_faces": "Proved by formal full-group coverage.",
        "individually_enumerated_full_physical_cube": False,
    }


def verify_matrix():
    output = []
    for z in (0, 1):
        matrix, upper, error = conditional_matrices(z)
        assert all(0 <= e <= r <= SIGMA for er, rr in zip(error, upper)
                   for e, r in zip(er, rr))
        assert len(rref(matrix)[1]) == len(rref(upper)[1]) == len(rref(error)[1]) == 1
        a = sum(map(sum, matrix))/ORDER**2
        assert a >= F(1, 4)
        heavy_frob_squared = sum(value*value for row in matrix for value in row)
        error_frob_squared = sum(value*value for row in error for value in row)
        error_gram = gram(error)
        assert error_gram == [[F(25) for _ in range(ORDER)] for _ in range(ORDER)]
        assert sum(error_gram[i][i] for i in range(ORDER)) == error_frob_squared == 200
        assert multiply(error_gram, error_gram) == [
            [200*x for x in row] for row in error_gram
        ]
        heavy_energy = heavy_frob_squared/(ORDER**3*a)
        error_energy = error_frob_squared/(ORDER**3*a)
        relative_mass = sum(map(sum, error))/(ORDER**2*a)
        assert heavy_energy == F(1, 16)
        assert relative_mass == (5 if z == 0 else F(5, 2))
        assert error_energy == (F(25, 16) if z == 0 else F(25, 32))
        output.append({
            "unhonored_bit": z, "a": str(a), "heavy_energy": str(heavy_energy),
            "nuclear_error_energy": str(error_energy),
            "relative_capped_mass": str(relative_mass),
        })
    scaling = []
    for sigma in (SIGMA, SIGMA/2, SIGMA/16):
        relatives, energies = [], []
        for z in (0, 1):
            matrix, _, error = conditional_matrices(z, sigma)
            a = sum(map(sum, matrix))/ORDER**2
            relatives.append(sum(map(sum, error))/(ORDER**2*a))
            energies.append(sum(e*e for row in error for e in row)/(ORDER**3*a))
        assert sum(relatives)/2 == F(15, 4)
        assert sum(energies)/2/sigma == F(25, 64)
        scaling.append({
            "sigma": str(sigma),
            "mean_relative_mass": str(sum(relatives)/2),
            "mean_nuclear_error_energy": str(sum(energies)/2),
        })
    return {
        "order": ORDER, "heavy_and_error_ranks": 1,
        "clipping_at_three_inactive": True,
        "gram_nonzero_eigenvalue": "200",
        "gram_zero_eigenvalue_multiplicity": 7,
        "nuclear_error_norm_squared": "200",
        "conditional_values": output,
        "finite_k0": 2, "finite_stronger_good_threshold": "5/2",
        "finite_thick_threshold": "1/4",
        "primary_sigma_satisfies_finite_good_and_thick_conditions": True,
        "scaling_controls": scaling,
        "scaling_scope": "Untruncated algebraic homogeneity; smaller scales are not claimed thick at the finite threshold.",
    }


def verify_ordered_tuple_kernel():
    size = 8
    edges = {(0, 1), (2, 3)}
    positive = negative = triggers = total = 0
    distribution = {}
    for a1, a2, b1, b2 in itertools.permutations(range(size), 4):
        trigger = (a1, b1) in edges
        available = int((a1, b1) in edges) + int((a2, b2) in edges)
        for bit in (0, 1):
            total += 1
            selected = available*bit
            missing = available-selected
            if trigger:
                triggers += 1
                if bit:
                    assert selected >= 1
                    positive += 1
                else:
                    assert missing >= 1
                    negative += 1
            key = (available, selected, missing)
            distribution[key] = distribution.get(key, 0)+1
    assert total == 2*math.perm(size, 4)
    assert F(triggers, total) == F(len(edges), size*(size-1)) == F(1, 28)
    assert F(positive, total) == F(negative, total) == F(1, 56)
    return {
        "block_size": size, "ordered_tuple_and_bit_outcomes": total,
        "fixed_oriented_edges": sorted(edges), "trigger_probability": "1/28",
        "selected_trigger_probability": "1/56",
        "available_but_absent_trigger_probability": "1/56",
        "exact_count_distribution": [
            {"available": a, "selected": k, "absent": j, "count": n}
            for (a, k, j), n in sorted(distribution.items())
        ],
        "scope": "One original conditional four-tuple kernel, not the complete asymptotic sampler.",
    }


def verify_constants():
    assert F(60, 2**15) < F(1, 512)
    assert F(1, 2**17)-F(1, 2**23)-F(1, 2**24) >= F(1, 2**18)
    assert F(11, 2**8) < F(1, 2)
    assert 27*(2048+1)+6 < 2**16
    cases = []
    for n in (1 << 154, (1 << 154)+17, 1 << 156):
        k0 = F(n, 1 << 134)
        v, r, d = n//512, n//(1 << 67), n//(1 << 150)+1
        assert 2*d <= r < v and d <= F(n, 1 << 149)
        assert F(r-d+1, v) >= F(1, 2**60)
        assert F(r, v) <= F(1, 2**57)
        assert math.ceil(k0/4)+k0/512 <= k0/2
        assert F(n, 1 << 66)/v >= F(1, 1 << 57)
        assert F(5, 32)*k0 >= 8
        cases.append({
            "N": n, "packed_edges": v, "count_cutoff": r,
            "optional_nonroot_degree": d, "k0": str(k0),
        })
    return {
        "parameter_cases": cases,
        "relative_mass_lower_bound": "(exp(N/2^208)-1)/2",
        "actual_heavy_energy_upper_bound": "a_star*2^(-k0)",
        "actual_nuclear_error_upper_bound": "2^(-3*k0/4)",
        "scope": "Exact arithmetic checks supplement, not replace, uniform proofs.",
    }


def verify_adapter():
    source = json.loads((ROOT/"relative-payload.json").read_text())
    record = json.loads((ROOT/"relative-output.json").read_text())
    assert source == payload()
    assert record["request"] == {"operation_id": OPERATION, "payload": source}
    assert record.get("error") is None and record["result"].get("error") is None
    assert record["result"]["operation_id"] == OPERATION
    output = record["result"]["output"]
    expected = [F(1), F(-200)] + [F(0)]*7
    coefficients = [F(int(c["num"]), int(c["den"]))
                    for c in output["coefficients_descending"]]
    assert coefficients == expected and output["degree"] == ORDER
    assert output["convention"] == "DET_LAMBDA_I_MINUS_A"
    assert output["monic"] is True and output["variable"] == "lambda"
    return {
        "operation_id": OPERATION, "characteristic_polynomial": "lambda^7*(lambda-200)",
        "all_coefficients_verified": True, "complete_request_payload_binding": True,
        "server_version": record["server"]["version"],
        "protocol_version": record["protocol_version"], "transport": record["transport"],
        "runtime_ms": record["result"]["runtime_ms"], "structured_error": None,
        "timeout": False,
    }


def verify():
    start = time.perf_counter()
    circuit_data, circuit, root, groups = verify_circuit()
    result = {
        "circuit": circuit_data, "cube": verify_cube(circuit, root, groups),
        "matrix": verify_matrix(), "kernel": verify_ordered_tuple_kernel(),
        "constants": verify_constants(), "jacobian": verify_adapter(),
        "refuted_route": "Direct dimension-independent charge of capped relative entrywise error only.",
        "dimension_independent_T5_proved": False,
        "dimension_independent_T5_refuted": False,
        "dimension_independent_E4_proved": False,
        "dimension_independent_E4_refuted": False,
        "fixed_factor_lower_bound_proved": False,
        "independent_review": "pending_host",
    }
    result["elapsed_seconds"] = round(time.perf_counter()-start, 3)
    return result


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("command", choices=("payload", "verify"))
    command = parser.parse_args().command
    print(json.dumps(payload(), separators=(",", ":")) if command == "payload"
          else json.dumps(verify(), indent=2))
