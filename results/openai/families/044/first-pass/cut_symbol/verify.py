#!/usr/bin/env python3
"""Replay exact orbit products and the fresh Lean core certificate."""

import argparse
from collections import Counter
from functools import lru_cache
from itertools import combinations, permutations, product
import json
from math import comb
from pathlib import Path

import sympy as sp


HERE = Path(__file__).resolve().parent
ROOT = HERE.parent.parent
SOURCE = (
    ROOT
    / "research/openai_manuscript"
    / "The-equivariant-cohomological-Hikita-conjecture-for-arbitrary-quivers-September-24-2026"
    / "build/sections/laurent.tex"
)
CONFIGURATIONS = (
    ((), (), ()),
    ((1,), ((0,),), (2,)),
    ((2,), ((0,),), (0,)),
    ((2,), ((1,),), (1,)),
    ((3,), ((1,),), (2,)),
    ((4,), ((1,),), (1,)),
    ((2, 2), ((0, 2), (1, 1)), (1, 2)),
    ((3, 1), ((1, 0), (2, 0)), (1, 1)),
    ((2, 1), ((0, 1), (0, 0)), (0, 0)),
)


def require(condition, message):
    if not condition:
        raise AssertionError(message)


def equal(left, right, message):
    require(sp.expand(left - right) == 0, message)


def partitions(total, maximum=None):
    if total == 0:
        yield ()
        return
    maximum = min(total, total if maximum is None else maximum)
    for first in range(maximum, 0, -1):
        for tail in partitions(total - first, first):
            yield (first,) + tail


def size_arrays(dimensions):
    choices = [
        [part + (0,) * (rank - len(part)) for part in partitions(rank)]
        for rank in dimensions
    ]
    for blocks in product(*choices):
        yield tuple(value for block in blocks for value in block)


def color_permutations(colors):
    blocks = [[d for d, c in enumerate(colors) if c == i] for i in sorted(set(colors))]
    for images in product(*(permutations(block) for block in blocks)):
        permutation = list(range(len(colors)))
        for block, image in zip(blocks, images):
            for d, e in zip(block, image):
                permutation[d] = e
        yield tuple(permutation)


def move_vector(vector, permutation):
    result = [0] * len(vector)
    for d, e in enumerate(permutation):
        result[e] = vector[d]
    return tuple(result)


def move_polynomial(polynomial, permutation, variables):
    return sp.sympify(polynomial).xreplace(
        {variables[d]: variables[e] for d, e in enumerate(permutation)}
    )


def orbit(vector, dressing, group, variables):
    result = {}
    for permutation in group:
        key = move_vector(vector, permutation)
        polynomial = move_polynomial(dressing, permutation, variables)
        if key in result:
            equal(result[key], polynomial, "Dressing is not stabilizer invariant")
        else:
            result[key] = polynomial
    return result


def dressing(sizes, colors, variables, positive_only):
    blocks = {}
    for d, size in enumerate(sizes):
        if not positive_only or size > 0:
            blocks.setdefault((colors[d], size), []).append(d)
    return 1 + sum(
        (1 + color + size) * sum(variables[d] ** 2 for d in block)
        + sp.prod(variables[d] for d in block)
        for (color, size), block in blocks.items()
    )


def weight_data(colors, arrows, framing, variables):
    result = []
    for d, i in enumerate(colors):
        if framing[i]:
            result.append((-variables[d], lambda vector, d=d: vector[d], framing[i]))
        for e, j in enumerate(colors):
            if d != e and arrows[i][j]:
                result.append(
                    (
                        variables[e] - variables[d],
                        lambda vector, d=d, e=e: vector[d] - vector[e],
                        arrows[i][j],
                    )
                )
    return result


def excesses(alpha, beta, weights):
    target = tuple(a + b for a, b in zip(alpha, beta))
    result = []
    for form, pairing, multiplicity in weights:
        exponent = (
            max(pairing(alpha), 0)
            + max(pairing(beta), 0)
            - max(pairing(target), 0)
        ) * multiplicity
        require(exponent >= 0, "A Laurent product would need a denominator")
        result.append((form, exponent))
    return result


def cut(sizes, selected, colors, arrows, framing, variables):
    positive = {d for d, size in enumerate(sizes) if size > 0}
    polynomial = sp.Integer(1)
    parity = 0
    for d in sorted(selected):
        i = colors[d]
        polynomial *= variables[d] ** framing[i]
        parity += framing[i]
        for e in sorted(positive - selected):
            j = colors[e]
            minimum = min(sizes[d], sizes[e])
            polynomial *= (variables[d] - variables[e]) ** (
                (arrows[i][j] + arrows[j][i]) * minimum
            )
            parity += arrows[i][j] * minimum
    return polynomial, parity


def leading_choices(sizes, selected, colors):
    blocks = {}
    for d, size in enumerate(sizes):
        if size > 0:
            blocks.setdefault((colors[d], size), []).append(d)
    options = [
        tuple(combinations(block, len(set(block) & selected)))
        for block in blocks.values()
    ]
    for choices in product(*options):
        permutation = list(range(len(sizes)))
        for block, choice in zip(blocks.values(), choices):
            chosen = set(choice)
            for before, after in (
                (sorted(set(block) & selected), sorted(chosen)),
                (sorted(set(block) - selected), sorted(set(block) - chosen)),
            ):
                for d, e in zip(before, after):
                    permutation[d] = e
        yield tuple(permutation)


def elementary(variables, degree):
    return sp.expand(
        sum(sp.prod(variables[d] for d in subset) for subset in combinations(range(len(variables)), degree))
    )


def check_zero_elimination(sizes, colors, variables):
    count = 0
    for color in sorted(set(colors)):
        zeros = [variables[d] for d, size in enumerate(sizes) if colors[d] == color and size == 0]
        if not zeros:
            continue
        virtual = [
            variables[d]
            for d, size in enumerate(sizes)
            if colors[d] == color and size > 0
            for _ in range(size - 1)
        ]
        require(len(virtual) == len(zeros), "Incorrect zero-slot replacement multiplicity")
        replaced = [sp.Integer(1)]
        for degree in range(1, len(zeros) + 1):
            newton = sum(
                (-1) ** (k - 1)
                * replaced[degree - k]
                * sum(variable ** k for variable in virtual)
                for k in range(1, degree + 1)
            ) / degree
            replaced.append(sp.expand(newton))
            equal(
                replaced[degree],
                elementary(virtual, degree),
                "Newton elimination differs from the repeated positive multiset",
            )
            raw_newton = sum(
                (-1) ** (k - 1)
                * elementary(zeros, degree - k)
                * sum(variable ** k for variable in zeros)
                for k in range(1, degree + 1)
            ) / degree
            equal(raw_newton, elementary(zeros, degree), "Zero-block Newton identity failed")
            count += 1
    return count


def check_shift(dimensions, sizes, colors, arrows, framing, weights):
    target = tuple(size - 1 for size in sizes)
    direct = sum(multiplicity * max(pairing(target), 0) for _, pairing, multiplicity in weights)
    length = Counter(colors[d] for d, size in enumerate(sizes) if size > 0)
    constant = sum(
        arrows[i][j] * dimensions[i] * dimensions[j]
        for i in range(len(dimensions))
        for j in range(len(dimensions))
    )
    minimum_sum = sum(
        arrows[colors[d]][colors[e]] * min(sd, se)
        for d, sd in enumerate(sizes)
        for e, se in enumerate(sizes)
    )
    formula = constant - minimum_sum + sum(
        framing[i] * (rank - length[i]) for i, rank in enumerate(dimensions)
    )
    require(direct == formula >= 0, "Wrong, negative, or nonintegral multipartition degree")


def generation_regressions():
    counts = Counter()
    for dimensions in dict.fromkeys(configuration[0] for configuration in CONFIGURATIONS):
        colors = tuple(i for i, rank in enumerate(dimensions) for _ in range(rank))
        group = tuple(color_permutations(colors))
        for target in product(range(-2, 3), repeat=len(colors)):
            if all(value in (0, 1) for value in target) or all(value in (0, -1) for value in target):
                counts["subset_base_cases"] += 1
                continue
            counts["nonbase_coweights"] += 1
            if any(value > 0 for value in target):
                alpha = tuple(int(value > 0) for value in target)
            else:
                alpha = tuple(-int(value < 0) for value in target)
            gamma = tuple(value - first for value, first in zip(target, alpha))
            norm = sum(value ** 2 for value in target)
            require(sum(value ** 2 for value in alpha) < norm, "The subset factor is not lower norm")
            require(sum(value ** 2 for value in gamma) < norm, "The residual factor is not lower norm")
            require(
                all(alpha[d] * gamma[d] >= 0 for d in range(len(colors)))
                and all(
                    (alpha[d] - alpha[e]) * (gamma[d] - gamma[e]) >= 0
                    for d in range(len(colors)) for e in range(len(colors))
                ),
                "The ordered leading product has a nonzero excess exponent",
            )
            gamma_orbit = {move_vector(gamma, permutation) for permutation in group}
            alpha_orbit = {move_vector(alpha, permutation) for permutation in group}
            for matched in gamma_orbit:
                summed = tuple(first + second for first, second in zip(alpha, matched))
                matched_norm = sum(value ** 2 for value in summed)
                require(matched_norm <= norm, "A relative matching has greater squared norm")
                if matched_norm == norm:
                    require(
                        all(
                            sorted(summed[d] for d, c in enumerate(colors) if c == i)
                            == sorted(target[d] for d, c in enumerate(colors) if c == i)
                            for i in range(len(dimensions))
                        ),
                        "A maximal matching has the wrong orbit type",
                    )
            decompositions = sum(
                tuple(first[d] + second[d] for d in range(len(colors))) == target
                for first in alpha_orbit for second in gamma_orbit
            )
            require(decompositions == 1, "The fixed leading representative has a nonunique decomposition")
            rows = []
            for vector in (alpha, gamma):
                for i in range(len(dimensions)):
                    for value in sorted({vector[d] for d, c in enumerate(colors) if c == i}):
                        rows.append([
                            int(c == i and vector[d] == value)
                            for d, c in enumerate(colors)
                        ])
            rank = sp.Matrix(rows).rank()
            for i in range(len(dimensions)):
                for value in sorted({target[d] for d, c in enumerate(colors) if c == i}):
                    target_block = [
                        int(c == i and target[d] == value) for d, c in enumerate(colors)
                    ]
                    require(sp.Matrix(rows + [target_block]).rank() == rank, "A level-block power sum is not generated")
                    counts["block_span_identities"] += 1
    counts["coordinate_values"] = 5
    return dict(sorted(counts.items()))


def orbit_regressions():
    counts = Counter()
    seen_zero_cases = set()
    for dimensions, arrows, framing in CONFIGURATIONS:
        colors = tuple(i for i, rank in enumerate(dimensions) for _ in range(rank))
        variables = sp.symbols(f"x0:{len(colors)}")
        group = tuple(color_permutations(colors))
        weights = weight_data(colors, arrows, framing, variables)

        @lru_cache(maxsize=None)
        def coefficient(alpha, beta):
            return sp.prod(form ** exponent for form, exponent in excesses(alpha, beta, weights))

        for sizes in size_arrays(dimensions):
            counts["multipartition_instances"] += 1
            check_shift(dimensions, sizes, colors, arrows, framing, weights)
            zero_key = (colors, sizes)
            if zero_key not in seen_zero_cases:
                counts["zero_block_generator_identities"] += check_zero_elimination(sizes, colors, variables)
                seen_zero_cases.add(zero_key)
            positive = tuple(d for d, size in enumerate(sizes) if size > 0)
            target = tuple(size - 1 for size in sizes)
            for cardinality in range(1, len(positive) + 1):
                for selected_tuple in combinations(positive, cardinality):
                    counts["cuts"] += 1
                    selected = set(selected_tuple)
                    a = tuple(0 if d in selected else size for d, size in enumerate(sizes))
                    b = tuple(size if d in selected else 0 for d, size in enumerate(sizes))
                    alpha = tuple(value - 1 for value in a)
                    beta = b
                    q, parity = cut(sizes, selected, colors, arrows, framing, variables)
                    equal(coefficient(alpha, beta), (-1) ** parity * q, "Incorrect oriented cut coefficient")
                    alpha_orbit = orbit(alpha, 1, group, variables)
                    beta_orbit = orbit(beta, 1, group, variables)
                    leading_pairs = []
                    for first in alpha_orbit:
                        for second in beta_orbit:
                            counts["orbit_pairs"] += 1
                            size_sum = tuple(x + y + 1 for x, y in zip(first, second))
                            require(all(size >= 0 for size in size_sum), "A product left the allowed size cone")
                            require(
                                all(sum(size_sum[d] for d, c in enumerate(colors) if c == i) == rank
                                    for i, rank in enumerate(dimensions)),
                                "A product changed the neutral color size sum",
                            )
                            support_a = {d for d, value in enumerate(first) if value + 1 > 0}
                            support_b = {d for d, value in enumerate(second) if value > 0}
                            overlap = len(support_a & support_b)
                            length = sum(size > 0 for size in size_sum)
                            require(length == len(positive) - overlap, "Incorrect support-length drop")
                            excesses(first, second, weights)
                            if overlap:
                                counts["lower_length_pairs"] += 1
                                require(length < len(positive), "An overlap survived at top length")
                            else:
                                for i in range(len(dimensions)):
                                    require(
                                        sorted(size_sum[d] for d, c in enumerate(colors) if c == i)
                                        == sorted(sizes[d] for d, c in enumerate(colors) if c == i),
                                        "A disjoint matching changed multipartition type",
                                    )
                            if tuple(x + y for x, y in zip(first, second)) == target:
                                require(overlap == 0, "The target has an overlapping decomposition")
                                leading_pairs.append((first, second))
                    choices = tuple(leading_choices(sizes, selected, colors))
                    type_blocks = Counter((colors[d], sizes[d]) for d in positive)
                    selected_blocks = Counter((colors[d], sizes[d]) for d in selected)
                    expected_count = sp.prod(
                        comb(number, selected_blocks[type_key]) for type_key, number in type_blocks.items()
                    )
                    require(len(leading_pairs) == len(choices) == expected_count, "Extra or missing trace multiplicity")
                    counts["leading_decompositions"] += len(leading_pairs)
                    dressings = (
                        (1, 1),
                        (dressing(a, colors, variables, False), 1),
                        (1, dressing(b, colors, variables, False)),
                        (dressing(a, colors, variables, False), dressing(b, colors, variables, False)),
                        (dressing(a, colors, variables, True), dressing(b, colors, variables, True)),
                    )
                    for pa, pb in dressings:
                        first_terms = orbit(alpha, pa, group, variables)
                        second_terms = orbit(beta, pb, group, variables)
                        actual = sum(
                            coefficient(first, second) * first_terms[first] * second_terms[second]
                            for first, second in leading_pairs
                        )
                        trace = sum(
                            move_polynomial(q * pa * pb, permutation, variables)
                            for permutation in choices
                        )
                        equal(actual, (-1) ** parity * trace, "Signed leading stabilizer trace failed")
                        counts["dressed_trace_identities"] += 1
        counts["quiver_configurations"] += 1
    require(counts["lower_length_pairs"] > 0, "No overlap case was exercised")
    return dict(sorted(counts.items()))


def sparse_polynomial(record, variables):
    require(record["domain"] == "QQ", "Jacobian returned the wrong coefficient domain")
    require(record["variables"] == [str(variable) for variable in variables], "Jacobian variable order changed")
    return sum(
        sp.Rational(term["coefficient"]["num"], term["coefficient"]["den"])
        * sp.prod(variable ** exponent for variable, exponent in zip(variables, term["exponents"]))
        for term in record["polynomial"]["terms"]
    )


def check_jacobian():
    payload = json.loads((HERE / "jacobian_payload.json").read_text())
    envelope = json.loads((HERE / "jacobian_output.json").read_text())
    contract = json.loads((HERE / "jacobian_contract.json").read_text())
    operation = "polynomial.ideal.normal_form.compute"
    require(contract["result"]["operation"]["operation_id"] == operation, "Wrong inspected operation")
    require(envelope["request"]["operation_id"] == operation, "Wrong executed operation")
    require(envelope["request"]["payload"] == payload, "Adapter did not execute the archived payload")
    require(envelope["result"]["operation_id"] == operation, "Output operation differs from request")
    output = envelope["result"]["output"]
    require(output["outcome"] == "COMPUTED", f"Non-conclusion from Jacobian: {output['outcome']}")
    require(output["in_ideal"] is False, "The nilpotent square was incorrectly killed")
    require(output["request"] == payload, "Typed output is not bound to this payload")
    x, y = sp.symbols("x y")
    generators = [sparse_polynomial(g, (x, y)) for g in payload["ideal"]["generators"]]
    expected = [x * (x - y) ** 2, y * (y - x) ** 2, x * y]
    for actual, wanted in zip(generators, expected):
        equal(actual, wanted, "Jacobian ideal is not the selected cut ideal")
    basis = sp.groebner(generators, x, y, order="grevlex", domain=sp.QQ)
    cubic_basis = sp.groebner([x ** 3, y ** 3, x * y], x, y, order="grevlex", domain=sp.QQ)
    for polynomial in generators:
        equal(cubic_basis.reduce(sp.expand(polynomial))[1], 0, "First ideal inclusion failed")
    for polynomial in (x ** 3, y ** 3, x * y):
        equal(basis.reduce(polynomial)[1], 0, "Reverse ideal inclusion failed")
    adapter_remainder = sparse_polynomial(output["remainder"], (x, y))
    local_remainder = basis.reduce((x + y) ** 2)[1]
    equal(adapter_remainder, local_remainder, "Independent exact remainder disagrees with Jacobian")
    equal(local_remainder, x ** 2 + y ** 2, "Wrong nonzero nilpotent square")
    require(local_remainder != 0, "A reduced-point computation replaced the scheme quotient")
    equal(basis.reduce((x + y) ** 3)[1], 0, "The asserted nilpotence order is wrong")
    equal(expected[0] + expected[1], (x + y) ** 3 - 4 * (x + y) * x * y, "Invariant cut relation failed")
    standard = {(0, 0), (1, 0), (0, 1), (2, 0), (0, 2)}
    for exponents in standard:
        monomial = x ** exponents[0] * y ** exponents[1]
        equal(basis.reduce(monomial)[1], monomial, "The asserted quotient basis is not standard")
    invariant_orbits = {frozenset((exponents, exponents[::-1])) for exponents in standard}
    invariant_degrees = Counter(sum(next(iter(orbit))) for orbit in invariant_orbits)
    hilbert = [invariant_degrees[degree] for degree in range(3)]
    require(len(standard) == 5 and hilbert == [1, 1, 1], "Wrong invariant quotient dimensions")
    return {
        "operation_id": operation,
        "protocol_version": envelope["protocol_version"],
        "server_version": envelope["server"]["version"],
        "transport": envelope["transport"],
        "adapter_outcome": output["outcome"],
        "adapter_error": output["detail"],
        "payload_file": "research/cut_symbol/jacobian_payload.json",
        "output_file": "research/cut_symbol/jacobian_output.json",
        "independent_remainder": "x^2 + y^2",
        "invariant_quotient": "QQ[t]/(t^3)",
        "invariant_hilbert_coefficients": hilbert,
        "scope": "One bounded exact scheme-level regression, not a universal proof",
    }


def check_lean():
    ledger = json.loads((ROOT / "research/MATH_STATE.json").read_text())
    core = max(
        (claim for claim in ledger["claims"] if claim["claim_id"] == "C_CUT_CORE"),
        key=lambda claim: claim["version"],
    )
    records = [
        record for record in ledger["evidence"]
        if record["subject"]["subject_id"] == "C_CUT_CORE"
        and record["subject"]["content_hash"] == core["content_hash"]
        and record["tier"] == "mechanical" and record["verdict"] == "supports"
    ]
    require(records, "No real supporting Lean certificate is recorded for C_CUT_CORE")
    source = (HERE / "lean/Main.lean").read_text()
    fidelity = (HERE / "lean/statement_fidelity.md").read_text()
    require(core["formal_statement"] == source, "The current claim encodes a different formal source")
    current = []
    for record in records:
        certificate = json.loads((ROOT / record["artifact"]).read_text())
        if certificate["lean_source"]["text"] == source and certificate["statement_fidelity"]["text"] == fidelity:
            current.append((record, certificate))
    require(len(current) == 1, "The current Lean source and fidelity do not have one fresh certificate")
    record, certificate = current[0]
    require(certificate["subject"] == record["subject"], "The archived proof certifies a different claim")
    require(certificate["tier"] == "mechanical" and certificate["verdict"] == "supports", "Wrong certificate tier or verdict")
    result = certificate["lean_check"]
    require(result["status"] == "success" and result["exit_code"] == 0, "The real Lean compiler did not succeed")
    require(result["proof_holes"] == [], "Lean proof holes remain")
    require(result["audit_exit_code"] == 0, "The real Lean axiom audit did not succeed")
    version = result["tools"]["lean"]["version"]
    require(version.startswith("Lean (version 4.31.0,"), "The recorded Lean toolchain is not 4.31.0")
    return {
        "claim_id": "C_CUT_CORE",
        "source": "research/cut_symbol/lean/Main.lean",
        "statement_fidelity": "research/cut_symbol/lean/statement_fidelity.md",
        "certificate": record["artifact"],
        "exit_code": result["exit_code"],
        "proof_holes": result["proof_holes"],
        "lean_version": version,
        "axiom_audit_exit_code": result["audit_exit_code"],
        "scope": "Universal exponent, orientation-sign, finite-product and support-cardinality core only",
    }


def certificate():
    text = SOURCE.read_text()
    for label in ("prop:filtration-bound", "eq:cut-leading-trace", "eq:filtration-symbol-surjection"):
        require("\\label{" + label + "}" in text, f"Missing manuscript anchor: {label}")
    return {
        "schema_version": 1,
        "claim_id": "C_CUT_SYMBOL",
        "result_class": "new_theorem",
        "classification": "All-data abstract verification and Q-algebra base-ring extension; BFN application conditional",
        "proof": "research/cut_symbol/proof.md",
        "universal_scope": {
            "base": "Every commutative Q-algebra",
            "sizes": "All finite color sets, all nonnegative ranks, and every allowed multipartition",
            "multiplicities": "All nonnegative integer arrow and framing multiplicities",
            "scheme_quotient": "Ideal generated by all nonzero topological charges, without reduction",
            "localization": "None; only rational integer constants occur",
            "established_by": "Universal derivation in proof.md, with the stated core kernel checked",
        },
        "application_assumptions": [
            {
                "claim": "C_LAURENT",
                "source": "laurent.tex, prop:laurent-model",
                "statement": "The BFN algebra identifies with the explicit invariant Laurent model, preserving coefficients, charges, and neutral grading",
                "status": "Input, not independently certified by this mission",
            }
        ],
        "finite_regressions": orbit_regressions(),
        "generation_regressions": generation_regressions(),
        "finite_regression_scope": {
            "dimensions": [list(configuration[0]) for configuration in CONFIGURATIONS],
            "all_partitions_at_these_dimensions": True,
            "all_nonempty_cuts": True,
            "dressings_per_cut": 5,
            "universal_proof": False,
        },
        "jacobian": check_jacobian(),
        "formal_core": check_lean(),
        "independent_review": {
            "status": "pending",
            "novelty_status": "unverified",
            "significance_status": "unassessed",
            "manuscript_main_theorem_certified": False,
        },
    }


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--write-certificate", action="store_true")
    args = parser.parse_args()
    result = certificate()
    path = HERE / "exact_certificate.json"
    if args.write_certificate:
        path.write_text(json.dumps(result, indent=2, sort_keys=True) + "\n")
    require(json.loads(path.read_text()) == result, "The serialized exact certificate is stale")
    print(json.dumps({
        "status": "verified",
        "claim": result["claim_id"],
        "finite_regressions": result["finite_regressions"],
        "generation_regressions": result["generation_regressions"],
        "lean_exit_code": result["formal_core"]["exit_code"],
        "lean_proof_holes": result["formal_core"]["proof_holes"],
        "independent_review": "pending",
        "scope": "Exact finite replay and fresh formal-core evidence; the universal proof still requires independent human review",
    }, sort_keys=True))


if __name__ == "__main__":
    main()
