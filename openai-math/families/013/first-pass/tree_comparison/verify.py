#!/usr/bin/env python3
"""Replay exact algebra, constant budgets, and finite diagnostic checks."""

import argparse
from collections import Counter, defaultdict
from fractions import Fraction
from itertools import combinations, product
import json
from pathlib import Path

import sympy as sp
from sympy.polys.domains import QQ, QQ_I


HERE = Path(__file__).resolve().parent


def rational(value):
    return Fraction(int(value.numerator), int(value.denominator))


def conjugate(value):
    return QQ_I(value.x, -value.y)


def abs2(value):
    norm = value * conjugate(value)
    assert norm.y == 0
    return rational(norm.x)


def universal_algebra():
    D, p, u, H, J, a, b, s = sp.symbols("D p u H J a b s", nonzero=True)
    d = a / (D * p * u * H)
    e = b / (D * p * u * J)
    y = s / (D * H * J)
    reconstructed = (a * J - b * H) / (s * u)
    checks = {
        "reconstruction_difference": (d - e - y).subs(p, reconstructed),
        "held_ratio_square": (d / e) / y - D * a * J**2 / (b * s),
        "reconstructed_square": p**2 - a * b * y / (s * D * u**2 * d * e),
    }
    z, r, r1, t = sp.symbols("z r r1 t")
    checks["affine_composition"] = (
        b - b**2 * (a - t) / a**2
        - ((b / a)**2 * t + b - b**2 / a)
    )
    checks["affine_translation_factor"] = z - z**2 - z * (1 - z)
    checks["affine_injectivity_factor"] = (
        r * (z - z**2) - r1 * (z - z**2) - (r - r1) * (z - z**2)
    )
    b1, b2, b3, b4, x, x1 = sp.symbols("b1 b2 b3 b4 x x1")
    delta = b3 + b4 - b1 - b2
    collision = lambda v: (v - b1) * (v - b2) - (v - b3) * (v - b4)
    checks["off_diagonal_collision_factor"] = (
        collision(x) - collision(x1) - (x - x1) * delta
    )
    checks["quadratic_unordered_pair_factor"] = (
        (b1 - b3) * (b1 - b4)
        - b1 * (b1 + b2 - b3 - b4) + (b1 * b2 - b3 * b4)
    )
    mass, weight = sp.symbols("mass weight", real=True)
    checks["principal_fourth_moment_sum_of_squares"] = (
        (mass - weight)**4 - mass**4 + 4 * mass**3 * weight
        - weight**2 * ((weight - 2 * mass)**2 + 2 * mass**2)
    )
    for name, expression in checks.items():
        numerator = sp.cancel(expression).as_numer_denom()[0]
        assert sp.expand(numerator) == 0, name
    return sorted(checks)


def constant_budgets():
    L = Fraction(3, 2)
    assert 4 * L**3 <= 16 and 3 * L**4 <= 16
    assert 3 * L <= 8 and 3 * (3 * L)**2 <= 8**2
    assert 16 + 2 * L**4 <= 40
    assert 16 + 4 * L**3 + 2 * L**4 <= 40
    assert 32 * L**5 <= 256
    assert 32 * L**4 <= 256
    assert 36 * L**4 <= 256
    assert 18 * 4 * L * 64 <= 8192
    assert 32 * 256 + 64 * 8192 <= 2**20
    assert 96 * 256 <= 2**20
    assert 8 * L**4 <= 2**20
    assert 3**4 * 2**21 <= 16**8
    return {
        "same_pair_small": str(32 * L**5),
        "same_pair_sum": str(32 * L**4),
        "cross_pair_sum": str(36 * L**4),
        "cross_pair_small": str(18 * 4 * L * 64),
        "untouched_mean": str(8 * L**4),
        "combined_small": 32 * 256 + 64 * 8192,
        "K": 2**20,
        "paired_constant": "16^(2^l)",
    }


def field_fibers(q):
    assert sp.isprime(q) and q % 2 == 1
    units = range(1, q)
    squares = Counter(z * z % q for z in units)
    assert set(squares.values()) == {2}
    affine = Counter(
        ((s * pow(r, -1, q))**2 % q, (s - s * s * pow(r, -1, q)) % q)
        for r, s in product(units, repeat=2)
    )
    assert affine[(1, 0)] == q - 1
    nonidentity = [v for k, v in affine.items() if k != (1, 0)]
    assert max(nonidentity) <= 2
    pair_fibers = defaultdict(set)
    for b1, b2 in product(range(q), repeat=2):
        pair_fibers[((b1 + b2) % q, b1 * b2 % q)].add(tuple(sorted((b1, b2))))
    assert all(len(v) == 1 for v in pair_fibers.values())
    return {"q": q, "affine_nonidentity_max": max(nonidentity)}


def parameters(q, depth, variant):
    if variant >= 2:
        nodes = ["".join(p) for level in range(depth)
                 for p in product("01", repeat=level)]
        currents = (1, 1 if variant == 2 else q - 1)
        frequencies = {"": 1 if variant == 2 else q - 1}

        def choose(n, current):
            if len(n) == depth:
                return
            frequencies[n + "0"] = 1
            frequencies[n + "1"] = q - 1 if current[0] == current[1] else 1
            numerator = current[1] - frequencies[n + "1"] * current[0]
            p = numerator * pow(frequencies[n], -1, q) % q
            assert p != 0
            choose(n + "0", (p, current[0]))
            choose(n + "1", (p, current[1]))

        choose("", currents)
        return {
            "D": 1, "currents": currents, "s": frequencies,
            "C": {n: (1, 1) for n in nodes}, "u": {n: 1 for n in nodes}, "c": 1,
        }
    unit = lambda n: 1 + (n + variant * (n + 2)) % (q - 1)
    nodes = ["".join(p) for level in range(depth + 1)
             for p in product("01", repeat=level)]
    number = lambda n: int("1" + n, 2)
    frequencies = {n: unit(3 * number(n) + 1) for n in nodes}
    internal = [n for n in nodes if len(n) < depth]
    constants = {}
    u = {n: unit(5 * number(n) + 2) for n in internal}
    if depth:
        constants[""] = (unit(1), unit(2))
    for n in internal:
        for side in range(2):
            child = n + str(side)
            if len(child) < depth:
                first = unit(7 * number(child))
                second = u[n] * constants[n][side] * pow(first, -1, q) % q
                constants[child] = (first, second)
                assert first * second % q == u[n] * constants[n][side] % q
    return {
        "D": unit(9), "currents": (unit(11), unit(13)),
        "s": frequencies, "C": constants, "u": u, "c": unit(17),
    }


def diagram_arguments(q, depth, par, leaves, stop=None):
    stop = depth if stop is None else stop
    assert 0 <= stop <= depth
    products = {
        "".join(p): leaves[i]
        for i, p in enumerate(product("01", repeat=depth))
    }
    for level in range(depth - 1, -1, -1):
        for path in product("01", repeat=level):
            n = "".join(path)
            products[n] = products[n + "0"] * products[n + "1"] % q
    if depth == 0:
        return (par["c"] * pow(leaves[0], -1, q) % q,)

    def visit(n, currents, expected=None):
        if len(n) == depth:
            assert expected is not None and expected != 0
            return (expected,)
        H = tuple(
            currents[j] * par["C"][n][j] * products[n + str(j)] % q
            for j in range(2)
        )
        assert all(H)
        y = par["s"][n] * pow(par["D"] * H[0] * H[1] % q, -1, q) % q
        assert expected is None or y == expected
        if len(n) == stop:
            return (y,)
        p = (
            (par["s"][n + "0"] * H[1] - par["s"][n + "1"] * H[0])
            * pow(par["s"][n] * par["u"][n] % q, -1, q)
        ) % q
        if p == 0:
            return None
        children = tuple(
            par["s"][n + str(j)]
            * pow(par["D"] * p * par["u"][n] * H[j] % q, -1, q) % q
            for j in range(2)
        )
        assert (children[0] - children[1]) % q == y
        assert p * p % q == (
            par["s"][n + "0"] * par["s"][n + "1"] * y
            * pow(par["s"][n] * par["D"] * par["u"][n]**2
                  * children[0] * children[1] % q, -1, q)
        ) % q
        for free in range(2):
            held = 1 - free
            lhs = children[free] * pow(children[held] * y % q, -1, q) % q
            rhs = (
                par["D"] * par["s"][n + str(free)] * H[held]**2
                * pow(par["s"][n + str(held)] * par["s"][n] % q, -1, q)
            ) % q
            assert lhs == rhs
        left = visit(n + "0", (p, currents[0]), children[0])
        right = visit(n + "1", (p, currents[1]), children[1])
        return None if left is None or right is None else left + right

    return visit("", par["currents"])


def functions(q):
    phases = [QQ_I(1), QQ_I(0, 1), QQ_I(-1), QQ_I(0, -1)]
    phase = [QQ_I(0)] + [phases[x % 4] for x in range(1, q)]
    sparse = [QQ_I(0) for _ in range(q)]
    support = (1, 2, 4) if q >= 7 else (1, 2)
    amplitude = QQ_I(QQ(3, 2)) if q >= 5 else QQ_I(1)
    for i, x in enumerate(support):
        sparse[x] = amplitude * phases[i]
    spike = [QQ_I(0) for _ in range(q)]
    spike[1] = QQ_I(sp.integer_nthroot(q, 2)[0])
    return {"phase": phase, "sparse": sparse, "single_spike": spike}


def weights(records, g, mask):
    result = {}
    for leaves, arguments in records.items():
        value = QQ_I(0) if arguments is None else QQ_I(1)
        if arguments is not None:
            for i, x in enumerate(arguments):
                factor = g[x]
                if (i % 2) ^ ((mask >> (i // 2)) & 1):
                    factor = conjugate(factor)
                value *= factor
        result[leaves] = value
    return result


def R_values(q, g):
    result = {}
    for d in range(1, q):
        total = Fraction(0)
        for t in range(2, q):
            z = d * pow(t - 1, -1, q) % q
            x = t * z % q
            total += abs2(g[x]) * abs2(g[z])
        result[d] = total / (q - 1)
    return result


def stress_diagram(q, depth, variant):
    par = parameters(q, depth, variant)
    leaves = list(product(range(1, q), repeat=2**depth))
    records = {v: diagram_arguments(q, depth, par, v) for v in leaves}
    max_density_ratio = Fraction(0)
    for level in range(depth + 1):
        counts = Counter(
            result for v in leaves
            if (result := diagram_arguments(q, depth, par, v, stop=level)) is not None
        )
        k = 2**level
        for count in counts.values():
            ratio = Fraction(count * (q - 1)**k, len(leaves))
            max_density_ratio = max(max_density_ratio, ratio / 2**(k - 1))
            assert ratio <= 2**(k - 1)
    tests = 0
    for g in functions(q).values():
        assert g[0] == QQ_I.zero and sum(map(abs2, g), Fraction(0)) <= q
        R = R_values(q, g)
        for mask in range(2**(2**depth // 2)):
            W = weights(records, g, mask)
            moment = sum(map(abs2, W.values()), Fraction(0)) / len(leaves)
            assert moment <= 3**(2**depth)
            if depth == 2:
                conditional = defaultdict(Fraction)
                for v, value in W.items():
                    conditional[int(sp.prod(v)) % q] += abs2(value)
                for total, moment_sum in conditional.items():
                    y = diagram_arguments(
                        q, depth, par, (1, 1, 1, total), stop=0
                    )[0]
                    majorant = 8 * sum(
                        (R[d] * R[e] for d, e in product(range(1, q), repeat=2)
                         if (d - e) % q == y), Fraction(0)
                    ) / (q - 1)
                    assert moment_sum / (q - 1)**3 <= majorant
            tests += 1
        if sum(x != QQ_I.zero for x in g) == 1 and depth >= 1:
            assert all(value == QQ_I.zero for value in weights(records, g, 0).values())
    sign_checks = 0
    if depth == 2:
        for i, j in combinations(range(4), 2):
            for v, arguments in records.items():
                changed = list(v)
                changed[i], changed[j] = -v[i] % q, -v[j] % q
                assert records[tuple(changed)] == arguments
                sign_checks += 1
    return records, {
        "q": q, "depth": depth, "variant": variant,
        "leaf_tuples": len(leaves),
        "valid_tuples": sum(v is not None for v in records.values()),
        "invalid_zero_reconstruction": sum(v is None for v in records.values()),
        "density_ratio_to_bound": str(max_density_ratio),
        "function_conjugation_cases": tests,
        "quartet_sign_lift_checks": sign_checks,
    }


def partitions(n):
    if n == 0:
        yield ()
        return
    for previous in partitions(n - 1):
        yield previous + ((n - 1,),)
        for i in range(len(previous)):
            yield previous[:i] + (previous[i] + (n - 1,),) + previous[i + 1:]


def totals(v, blocks, q):
    return tuple(int(sp.prod(v[i] for i in block)) % q for block in blocks)


def conditional_means(W, blocks, q):
    sums = defaultdict(lambda: QQ_I(0))
    counts = Counter()
    for v, value in W.items():
        key = totals(v, blocks, q)
        sums[key] += value
        counts[key] += 1
    expected = (q - 1)**(len(next(iter(W))) - len(blocks))
    assert len(counts) == (q - 1)**len(blocks)
    assert set(counts.values()) == {expected}
    return {key: value / expected for key, value in sums.items()}


def projected_norm(W, cycle, blocks, q):
    r = len(next(iter(W)))
    assert all(sum(sign for i, sign in cycle if i in block) == 0 for block in blocks)
    assert all(sum(sign for i, sign in cycle if i // 4 == j) == 0
               for j in range(r // 4))
    norm = Fraction(0)
    for v in W:
        averaged = QQ_I(0)
        for z in range(1, q):
            changed = list(v)
            for i, sign in cycle:
                changed[i] = v[i] * pow(z, sign, q) % q
            assert totals(v, blocks, q) == totals(changed, blocks, q)
            averaged += W[tuple(changed)]
        norm += abs2(averaged / (q - 1))
    return norm / len(W)


def paired_stress(q, depth, first, second):
    g = [QQ_I.zero] + [QQ_I(QQ(1, 2), QQ((-1)**x, 100)) for x in range(1, q)]
    assert sum(map(abs2, g), Fraction(0)) <= q
    W1, W2 = weights(first, g, 0), weights(second, g, 1)
    nonzero_first = sum(v != QQ_I.zero for v in W1.values())
    nonzero_second = sum(v != QQ_I.zero for v in W2.values())
    assert nonzero_first and nonzero_second
    if depth == 2:
        choices = [p for p in partitions(4) if len(p) <= 3]
        assert len(choices) == 14
        configurations = []
        for blocks in choices:
            moved = next(block for block in blocks if len(block) >= 2)
            cycle = ((moved[0], 1), (moved[1], -1))
            configurations.append((blocks, cycle))
        pairs = [(b1, b2, cycle) for b1, cycle in configurations for b2 in choices
                 if len(b1) == len(b2)]
    else:
        b1 = ((0, 4), (1, 5), (2,), (3,), (6,), (7,))
        b2 = ((0, 5), (1, 4), (2,), (3,), (6,), (7,))
        pairs = [(b1, b2, ((0, 1), (4, -1), (5, 1), (1, -1)))]
    means1, means2, norms = {}, {}, {}
    for b1, b2, cycle in pairs:
        if b1 not in means1:
            means1[b1] = conditional_means(W1, b1, q)
        if b2 not in means2:
            means2[b2] = conditional_means(W2, b2, q)
        if cycle not in norms:
            norms[cycle] = projected_norm(W1, cycle, b1, q)
        assert norms[cycle] > 0
        m1, m2 = means1[b1], means2[b2]
        correlation = sum(
            (value * conjugate(m2[key]) for key, value in m1.items()), QQ_I(0)
        ) / len(m1)
        assert abs2(correlation) <= 3**(2**depth) * norms[cycle]
    return {
        "q": q, "depth": depth, "paired_partition_cases": len(pairs),
        "cycle_type": "parallel_edges" if depth == 2 else "two_quartet_cycle",
        "different_parameters": True, "different_conjugations": True,
        "function_on_units": "1/2 + (-1)^x i/100",
        "nonzero_first_weights": nonzero_first,
        "nonzero_second_weights": nonzero_second,
        "positive_projection_norms": True,
    }


def verify():
    cases = []
    records = {}
    specifications = [(3, d) for d in range(4)] + [(5, d) for d in range(3)] + [(7, 2)]
    for q, depth in specifications:
        variants = (0, 1, 2, 3) if q == 3 and depth >= 2 else (0, 1)
        for variant in variants:
            data, summary = stress_diagram(q, depth, variant)
            records[(q, depth, variant)] = data
            cases.append(summary)
    paired = [
        paired_stress(
            q, depth,
            records[(q, depth, 2 if q == 3 else 0)],
            records[(q, depth, 3 if q == 3 else 1)],
        )
        for q, depth in ((3, 2), (5, 2), (7, 2), (3, 3))
    ]
    lean = json.loads((HERE / "lean_verify_output.json").read_text())
    assert lean["exit_code"] == 0 and lean["proof_holes"] == []
    assert "4.31.0" in lean["tools"]["lean"]["version"]
    assert lean["kernel"]["recorded"]["subject"]["subject_id"] == "C_TREE_ALGEBRA"
    adapter = json.loads((HERE / "jacobian_result.json").read_text())
    assert adapter["ok"] is False
    assert adapter["error"]["data"]["code"] == "INVALID_REQUEST"
    return {
        "claim": "C_TREE",
        "result_class": "explicit_constant_verification_theorem",
        "mathematical_statement": {
            "field_quantifier": "every odd prime",
            "single_diagram": "E|W|^2 <= 3^r",
            "paired_diagrams": "|E W1 conjugate(W2)| <= 16^r(epsilon+q^(-1/4))",
            "paired_hypotheses": "l>=2, b<=3r/4, all literal unit/consistency/zero conventions",
            "extension": "the numerical b condition can be replaced by a component-quartet cycle",
        },
        "universal_polynomial_identities": universal_algebra(),
        "universal_rational_budgets": constant_budgets(),
        "finite_fiber_diagnostics": [field_fibers(q) for q in (3, 5, 7, 11, 17, 31)],
        "finite_diagram_diagnostics": cases,
        "finite_paired_diagnostics": paired,
        "lean_algebra": {
            "claim": "C_TREE_ALGEBRA", "version": "4.31.0",
            "exit_code": 0, "proof_holes": [],
            "certificate": lean["kernel"]["recorded"]["artifact"],
            "coverage": "universal algebra only; not the full analytic theorem",
        },
        "jacobian": {
            "operation_id": "finite_field.polynomial_map.table.compute",
            "server_version": "0.14.0", "protocol": "2025-11-25",
            "adapter_exit_code": 2, "status": "INVALID_REQUEST",
            "timed_out": False, "mathematical_conclusion": "none",
        },
        "full_proof": "research/tree_comparison/report.md",
        "independent_review": "pending",
        "novelty_status": "not_claimed",
        "limitations": [
            "The complete all-field estimate is a prose proof requiring independent review.",
            "Finite diagnostics are not a proof of an asymptotic or universal estimate.",
            "Lean certifies only C_TREE_ALGEBRA and does not check the fidelity document.",
            "This does not certify Ostmann's conjecture or the arithmetic comparison inputs.",
        ],
    }


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--write-certificate", action="store_true")
    args = parser.parse_args()
    certificate = verify()
    path = HERE / "exact_certificate.json"
    if args.write_certificate:
        path.write_text(json.dumps(certificate, indent=2, sort_keys=True) + "\n")
    else:
        assert json.loads(path.read_text()) == certificate, "certificate replay mismatch"
    print(json.dumps({
        "ok": True, "universal_identities": len(certificate["universal_polynomial_identities"]),
        "diagram_cases": len(certificate["finite_diagram_diagnostics"]),
        "paired_cases": sum(p["paired_partition_cases"] for p in certificate["finite_paired_diagnostics"]),
        "full_analytic_proof_review": "pending",
    }, sort_keys=True))


if __name__ == "__main__":
    main()
