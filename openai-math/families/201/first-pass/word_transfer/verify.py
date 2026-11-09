#!/usr/bin/env python3
"""Replay exact, explicitly bounded diagnostics for the universal report."""

import argparse
import itertools
import json
from pathlib import Path

import sympy as sp


ROOT = Path(__file__).resolve().parent
XI, EPS = sp.symbols("xi epsilon")
Z = sp.diag(1, -1)
X = sp.Matrix([[0, 1], [1, 0]])
I2 = sp.eye(2)
PI_PLUS = sp.Matrix([[4, 2], [2, 1]]) / 5
H_LETTERS = {
    "1": sp.Matrix([[0, 1], [1, 0]]),
    "2": sp.Matrix([[1, 1], [0, -1]]),
}


def require(condition, message):
    if not condition:
        raise AssertionError(message)


def reduced(matrix):
    return matrix.applyfunc(sp.cancel)


def equal(actual, expected, message):
    if isinstance(actual, sp.MatrixBase):
        require(actual.shape == expected.shape, message + ": shape")
        require(all(sp.cancel(x) == 0 for x in actual - expected), message)
    else:
        require(sp.cancel(actual - expected) == 0, message)


def encoded(matrix):
    return [[str(sp.cancel(x)) for x in row] for row in matrix.tolist()]


def words(length):
    return ["".join(w) for w in itertools.product("12", repeat=length)]


def zero(rows, cols=None):
    return sp.zeros(rows, rows if cols is None else cols)


def rational_function(node, variables):
    require(node["variables"] == [str(x) for x in variables], "typed variables")
    require(node.get("domain", "QQ") == "QQ", "typed rational domain")

    def polynomial(part):
        value = 0
        for term in part["terms"]:
            coefficient = term["coefficient"]
            monomial = sp.Rational(coefficient["num"], coefficient["den"])
            require(len(term["exponents"]) == len(variables), "typed exponent arity")
            for variable, exponent in zip(variables, term["exponents"]):
                require(exponent >= 0, "typed polynomial exponent")
                monomial *= variable**exponent
            value += monomial
        return value

    denominator = polynomial(node["denominator"])
    require(denominator != 0, "typed denominator")
    return sp.cancel(polynomial(node["numerator"]) / denominator)


def jacobian_check():
    payload = json.loads((ROOT / "jacobian_payload.json").read_text())
    response = json.loads((ROOT / "jacobian_output.json").read_text())
    require("error" not in response, "adapter returned an error")
    require(response["request"]["payload"] == payload, "payload/response binding")
    operation = "matrix.symbolic.determinant.compute"
    require(response["request"]["operation_id"] == operation, "requested operation")
    require(response["result"]["operation_id"] == operation, "returned operation")
    require(response["server"]["version"] == "0.14.0", "inspected server version")
    require(response["protocol_version"] == "2025-11-25", "protocol version")
    require(response["transport"] == "mcp-stdio", "isolated sidecar transport")
    matrix = sp.Matrix([
        [rational_function(entry, [XI]) for entry in row]
        for row in payload["matrix"]["entries"]
    ])
    m0 = sp.Matrix([[0, 0, 0, 3], [0, 2, 5, 7],
                    [0, 0, 0, 0], [0, 0, 0, 2]])
    m1 = sp.Matrix([[1, 0, 5, 11], [0, 3, 13, 17],
                    [0, 0, 1, 0], [0, 0, 0, 3]])
    equal(matrix, m0 + XI * m1, "recorded regularized matrix")
    output = response["result"]["output"]
    require(output["method"] == "SYMPY_BAREISS", "typed determinant method")
    determinant = rational_function(output["determinant"], [XI])
    equal(determinant, matrix.det(), "independent determinant replay")
    equal(determinant, XI**2 * (2 + 3 * XI)**2, "expected determinant")
    return m0, m1, {
        "operation_id": operation,
        "server_version": response["server"]["version"],
        "protocol_version": response["protocol_version"],
        "payload_file": "jacobian_payload.json",
        "typed_output_file": "jacobian_output.json",
        "adapter_status": "completed_typed_output",
        "structured_error": None,
        "timeout": False,
        "determinant": str(sp.factor(determinant)),
    }


def inverse_diagnostics(m0, m1):
    e = sp.diag(1, 0, 1, 0)
    f = sp.eye(4) - e
    pi = (m0 - 2 * sp.eye(4))**2 / 4
    j = (m0 + pi).inv() * (sp.eye(4) - pi)
    fixed = f * (f * m0 * f + e).inv() * f
    left = sp.Matrix([[0, 11, sp.Rational(55, 2), 13]])
    right = sp.Matrix([sp.Rational(57, 2), 17, 0, 19])
    equal(pi**2, pi, "spectral idempotent")
    equal(m0 * pi, zero(4), "zero spectral subspace")
    equal(m0 * j, sp.eye(4) - pi, "group inverse, left")
    equal(j * m0, sp.eye(4) - pi, "group inverse, right")
    complement = m0.extract([1, 3], [1, 3])
    require(complement != 2 * I2, "nontrivial complementary Jordan block")
    equal((complement - 2 * I2)**2, zero(2), "complementary Jordan index two")
    equal(left * pi, zero(1, 4), "left coupling killed")
    equal(pi * right, zero(4, 1), "right coupling killed")
    require(pi != e, "fixed and spectral complements must differ in this test")
    target_basis = sp.eye(4).extract(range(4), [0, 2])
    gamma = target_basis - fixed * m0 * target_basis
    equal(m0 * gamma, zero(4, 2), "kernel graph")
    g = reduced(target_basis.T * pi * m1 * gamma)
    equal(g.det(), 1, "invertible compressed regularizing derivative")
    inverse = (m0 + XI * m1).inv()
    residue = (XI * inverse).applyfunc(lambda x: sp.limit(x, XI, 0))
    require(residue.rank() == 2, "simple-pole residue rank")
    equal((XI**2 * inverse).applyfunc(lambda x: sp.limit(x, XI, 0)),
          zero(4), "no higher pole")
    varying_left = left + XI * sp.Matrix([[2, 3, 5, 7]])
    varying_right = right + XI * sp.Matrix([11, 13, 17, 19])
    limit = sp.limit(sp.cancel((varying_left * inverse * varying_right)[0]), XI, 0)
    equal(limit, sp.Rational(-595, 4), "two-sided killed-pole limit")
    equal((left * j * right)[0], limit, "spectral inverse sandwich")
    equal((left * fixed * right)[0], limit, "original fixed-complement sandwich")
    tensor_checks = []
    for t in (1, 2, 3):
        lt = sp.kronecker_product(left, sp.eye(t))
        bt = sp.kronecker_product(right, sp.eye(t))
        jt = sp.kronecker_product(j, sp.eye(t))
        ft = sp.kronecker_product(fixed, sp.eye(t))
        equal(lt * jt * bt, limit * sp.eye(t), "multiplicity-t spectral sandwich")
        equal(lt * ft * bt, limit * sp.eye(t), "multiplicity-t fixed sandwich")
        tensor_checks.append(t)
    models = []
    for k in (1, 2, 3):
        upper = sp.Matrix(k, k, lambda r, c: (r + 2 * c + 1) if r < c else 0)
        d = 2 * sp.eye(k) + upper
        b, c = 2 * upper, 3 * upper
        a = b * d.inv() * c
        m = a.row_join(b).col_join(c.row_join(d))
        u = b.col_join(d)
        v = (d.inv() * c).row_join(sp.eye(k))
        h = v * u
        projector = sp.eye(2 * k) - u * h.inv() * v
        group = u * h.inv()**2 * v
        ef = sp.diag(*([1] * k + [0] * k))
        ff = sp.eye(2 * k) - ef
        complement = ff * (ff * m * ff + ef).inv() * ff
        lf = sp.Matrix([[2 * i + 1 for i in range(k)]])
        bf = sp.Matrix([3 * i + 2 for i in range(k)])
        l = (lf * d.inv() * c).row_join(lf)
        r = (b * d.inv() * bf).col_join(bf)
        regularizer = (sp.eye(k) + upper).row_join(upper).col_join(
            upper.row_join(3 * sp.eye(k) + upper)
        )
        equal(l * projector, zero(1, 2 * k), "model left annihilation")
        equal(projector * r, zero(2 * k, 1), "model right annihilation")
        require(m.rank() == k and projector.rank() == k, "model kernel size")
        lam = sp.Symbol("lambda")
        equal(m.charpoly(lam).as_expr(), lam**k * (lam - 2)**k,
              "state-triangular algebraic multiplicity")
        direct = sp.cancel(((l + XI * sp.ones(1, 2 * k))
                            * (m + XI * regularizer).inv()
                            * (r + XI * sp.ones(2 * k, 1)))[0])
        answer = sp.limit(direct, XI, 0)
        equal(answer, (lf * d.inv() * bf)[0], "model regularized limit")
        equal((l * group * r)[0], answer, "model group sandwich")
        equal((l * complement * r)[0], answer, "model fixed sandwich")
        models.append({"internal_target_copies": k, "limit": str(answer)})

    diagonal = sp.diag(XI, 2)
    lone_left, lone_right = sp.Matrix([[XI, 1]]), sp.Matrix([1, 2])
    negative_pi = sp.diag(1, 0)
    equal(lone_left.subs(XI, 0) * negative_pi, zero(1, 2), "one-sided control kills left")
    require(negative_pi * lone_right != zero(2, 1), "one-sided control does not kill right")
    one_sided = (lone_left * diagonal.inv() * lone_right)[0]
    one_sided_fixed = (lone_left.subs(XI, 0) * sp.diag(0, sp.Rational(1, 2))
                       * lone_right)[0]
    equal(one_sided, 2, "one-sided negative control")
    equal(one_sided_fixed, 1, "one-sided negative fixed value")
    nilpotent = sp.Matrix([[XI, 1], [0, XI]])
    require(nilpotent.subs(XI, 0).rank() == 1, "nonzero nilpotent control")
    equal(nilpotent.subs(XI, 0)**2, zero(2), "nilpotent control square zero")
    nil_left, nil_right = sp.Matrix([[XI, 0]]), sp.Matrix([0, XI])
    equal(nil_left.subs(XI, 0), zero(1, 2), "nilpotent control kills left")
    equal(nil_right.subs(XI, 0), zero(2, 1), "nilpotent control kills right")
    double_residue = (XI**2 * nilpotent.inv()).applyfunc(lambda x: sp.limit(x, XI, 0))
    require(double_residue != zero(2), "nilpotent control has a double pole")
    bad = (nil_left * nilpotent.inv() * nil_right)[0]
    equal(bad, -1, "nonsemisimple negative control")
    return {
        "fixed_projector_differs_from_spectral_projector": True,
        "complement_has_nontrivial_Jordan_block": True,
        "compressed_derivative": encoded(g),
        "simple_pole_residue_rank": residue.rank(),
        "fixed_complement_limit": str(limit),
        "root_multiplicities_checked": tensor_checks,
        "additional_algebraic_models": models,
        "negative_controls": {
            "only_one_coupling_killed_limit": str(one_sided),
            "only_one_coupling_killed_fixed_value": str(one_sided_fixed),
            "nonsemisimple_zero_limit": str(bad),
            "nonsemisimple_zero_expected_if_false_extension": "0",
            "nonsemisimple_inverse_double_pole": True,
            "scope": "Weakened-lemma counterexamples, not manuscript counterexamples",
        },
    }


def generic_response_diagnostics():
    r, t, q1, q2 = sp.symbols("r t q1 q2")
    p1, p2 = r * (1 - t**2), 2 * r * t
    jacobian = sp.det(sp.Matrix([[sp.diff(p1, r), sp.diff(p1, t)],
                                [sp.diff(p2, r), sp.diff(p2, t)]]))
    equal(jacobian, 2 * r * (1 + t**2), "dominant generic input coordinates")
    base = p1 * Z + p2 * X
    mu = r * (1 + t**2)
    projectors = [(I2 + base / mu) / 2, (I2 - base / mu) / 2]
    paired = []
    for sign, pi in zip((1, -1), projectors):
        equal(pi**2, pi, "generic projector")
        equal(base * pi, sign * mu * pi, "generic eigenvalue")
        equal(sp.trace(pi), 1, "generic core rank")
        branch_pairs = []
        for u, v in itertools.product((Z, X), repeat=2):
            response = reduced(-pi * u * (q1 * Z + q2 * X - sign * mu * I2).inv()
                               * v * pi)
            scalar = sp.cancel(sp.trace(response))
            equal(response, scalar * pi, "generic paired scalar response")
            branch_pairs.append(scalar)
        paired.append(branch_pairs)
    for plus, minus in zip(*paired):
        equal(plus + minus, 0, "simultaneous active-space relation")
    j = Z * X
    for generator in (Z, X):
        equal(j * generator + generator * j, zero(2), "global anticommutation")
    return {
        "generic_coordinate_jacobian": str(sp.factor(jacobian)),
        "generic_core_roots": [str(mu), str(-mu)],
        "paired_coordinate_responses_checked": 8,
        "active_relation": "c_plus + c_minus = 0",
        "underlying_division_family": "A=(u,v) tensor (r0,s0) over Q(mu_infinity)(u,v,r0,s0)",
        "coefficient_algebra_degree": 4,
        "spectator_multiplicity": 2,
        "normalization": "x=a*Z, y=b*X, inputs z1=b*Z1,z2=a*Z2; divide W by a*b",
        "scope": "Generic symbolic paired checks; finite word tests use p=(3,4), C0=(1,2)",
    }


def similarity_input_series(length):
    inverse_h = {"": I2}
    for degree in range(1, length + 1):
        for word in words(degree):
            inverse_h[word] = -H_LETTERS[word[0]] * inverse_h[word[1:]]
    inputs = []
    for base, perturbation in (
        (sp.diag(3, 1), sp.Matrix([[2, 3], [5, 7]])),
        (sp.diag(4, 2), sp.Matrix([[11, 13], [17, 19]])),
    ):
        series = {"": EPS * base}
        for degree in range(1, length + 1):
            for word in words(degree):
                coefficient = EPS * (
                    base * inverse_h[word]
                    + H_LETTERS[word[0]] * base * inverse_h[word[1:]]
                )
                if degree == length:
                    weight = 1 + int(word.translate(str.maketrans("12", "01")), 2)
                    coefficient += weight * perturbation
                series[word] = coefficient
        inputs.append(series)
    return inputs


def schur_series(output, pi, eigenvalue, length):
    f = sp.eye(4) - pi
    inverse = {"": (f * (output[""] - eigenvalue * sp.eye(4)) * f + pi).inv()}
    for degree in range(1, length + 1):
        for word in words(degree):
            value = zero(4)
            for split in range(1, degree + 1):
                value += f * output[word[:split]] * f * inverse[word[split:]]
            inverse[word] = reduced(-inverse[""] * value)
    result = {}
    for degree in range(1, length + 1):
        for word in words(degree):
            value = pi * output[word] * pi
            for left_end in range(1, degree):
                for right_start in range(left_end, degree):
                    value -= (pi * output[word[:left_end]] * f
                              * inverse[word[left_end:right_start]]
                              * f * output[word[right_start:]] * pi)
            result[word] = reduced(value)
    return result


def unfold(word, inputs):
    length = len(word)
    sizes = [1] + [2] * (length - 1) + [1]
    offsets = [sum(sizes[:i]) for i in range(len(sizes))]
    result = []
    for series in inputs:
        matrix = zero(sum(sizes))
        for i in range(length + 1):
            for j in range(i, length + 1):
                block = series["" if i == j else word[i:j]]
                rows = [0] if i in (0, length) else [0, 1]
                cols = [0] if j in (0, length) else [0, 1]
                matrix[offsets[i]:offsets[i] + sizes[i],
                       offsets[j]:offsets[j] + sizes[j]] = block.extract(rows, cols)
        result.append(matrix)
    return result


def unfolded_check(word, inputs, sign, pi, expected):
    length = len(word)
    scalar_inputs = unfold(word, inputs)
    n = scalar_inputs[0].rows
    output = sp.kronecker_product(Z, scalar_inputs[0]) + sp.kronecker_product(X, scalar_inputs[1])
    first, last = [0, n], [n - 1, 2 * n - 1]
    direct = output.extract(first, last)
    if length == 1:
        equal(pi * direct * pi, expected * pi, "length-one cropped coefficient")
        return {"nonfixed": False, "direct_limit": False}
    internal = [a * n + i for a in range(2) for i in range(1, n - 1)]
    m = reduced(output.extract(internal, internal) / EPS - sign * 5 * sp.eye(len(internal)))
    left = reduced(pi * output.extract(first, internal) / EPS)
    right = reduced(output.extract(internal, last) * pi / EPS)
    k = length - 1
    input_targets = sp.diag(*([1, 0] * k))
    e = sp.kronecker_product(pi, input_targets)
    f = sp.eye(4 * k) - e
    fixed = f * (f * m * f + e).inv() * f

    hu = sp.eye(2 * k)
    for i in range(k - 1):
        hu[2 * i:2 * i + 2, 2 * i + 2:2 * i + 4] = H_LETTERS[word[i + 1]]
    h = sp.kronecker_product(I2, hu)
    base = (sp.kronecker_product(Z, sp.diag(*([3, 1] * k)))
            + sp.kronecker_product(X, sp.diag(*([4, 2] * k)))
            - sign * 5 * sp.eye(4 * k))
    equal(m, h * base * h.inv(), "internal conjugacy from proper substrings")
    projector = h * e * h.inv()
    group = h * (base + e).inv() * (sp.eye(4 * k) - e) * h.inv()
    equal(m * projector, zero(4 * k), "unfolded kernel")
    require(projector.rank() == k and m.rank() == 3 * k, "full target kernel dimension")
    equal(m * group, sp.eye(4 * k) - projector, "unfolded group inverse")
    equal(group * m, sp.eye(4 * k) - projector, "unfolded group inverse right")
    equal(left * projector, zero(2, 4 * k), "prefix coupling annihilation")
    equal(projector * right, zero(4 * k, 2), "suffix coupling annihilation")
    equal(e * (m - m * fixed * m) * e, zero(4 * k), "proper-subword Schur zero")
    q = sp.Matrix([2, 1]) if sign == 1 else sp.Matrix([1, -2])
    select = sp.zeros(2 * k, k)
    for i in range(k):
        select[2 * i, i] = 1
    basis = sp.kronecker_product(q, select)
    coordinate = sp.kronecker_product(q.T / 5, select.T)
    gamma = basis - fixed * m * basis
    equal(m * gamma, zero(4 * k, k), "unfolded fixed-complement graph")
    regularizer = sp.kronecker_product(Z, input_targets)
    g = coordinate * projector * regularizer * gamma
    equal(g.det(), (sp.Rational(sign * 3, 5))**k, "regularizing derivative determinant")
    for i in range(k):
        equal(g[i, i], sp.Rational(sign * 3, 5), "regularizing derivative diagonal")
        for j in range(i):
            equal(g[i, j], 0, "regularizing derivative triangularity")
    equal(left * group * right, left * fixed * right, "unchanged complement")
    coefficient = reduced(pi * direct * pi - EPS * left * fixed * right)
    equal(coefficient, expected * pi, "unfolded original coefficient")
    direct_limit = word in ("11", "121")
    if direct_limit:
        regularized = reduced(left * (m + XI * regularizer).inv() * right)
        limit = regularized.applyfunc(lambda x: sp.limit(x, XI, 0))
        equal(limit, left * fixed * right, "actual input-loop regularized limit")
    if word == "121":
        equal(sp.kronecker_product(coefficient, I2),
              expected * sp.kronecker_product(pi, I2), "old spectator multiplicity two")
        require(sp.kronecker_product(pi, I2).rank() == 2, "rank-t target projector")
    return {"nonfixed": projector != e, "direct_limit": direct_limit}


def word_diagnostics():
    endpoint = sp.diag(1, 0)
    lower_checks = leading_checks = unfolded = commuting = nonfixed = limits = 0
    a1, a2 = sp.symbols("a1 a2")
    for length in (1, 2, 3, 4):
        inputs = similarity_input_series(length)
        output = {
            word: sp.kronecker_product(Z, inputs[0][word])
            + sp.kronecker_product(X, inputs[1][word])
            for word in inputs[0]
        }
        scalars = {}
        for sign, pi in ((1, PI_PLUS), (-1, I2 - PI_PLUS)):
            full_pi = sp.kronecker_product(pi, endpoint)
            schur = schur_series(output, full_pi, sign * 5 * EPS, length)
            for degree in range(1, length):
                for word in words(degree):
                    equal(schur[word], zero(4), "proper free-word coefficient")
                    lower_checks += 1
            by_monomial = {}
            for word in words(length):
                weight = 1 + int(word.translate(str.maketrans("12", "01")), 2)
                expected = sign * 10 * weight
                equal(schur[word], expected * full_pi, "leading free-word coefficient")
                leading_checks += 1
                scalars[sign, word] = expected
                diagnostic = unfolded_check(word, inputs, sign, pi, expected)
                unfolded += 1
                nonfixed += int(diagnostic["nonfixed"])
                limits += int(diagnostic["direct_limit"])
                monomial = (word.count("1"), word.count("2"))
                by_monomial[monomial] = by_monomial.get(monomial, zero(4)) + schur[word]
            line = zero(4)
            for (p, q), coefficient in by_monomial.items():
                scalar = sp.trace(coefficient)
                equal(coefficient, scalar * full_pi, "commuting coefficient scalarity")
                line += coefficient * a1**p * a2**q
                commuting += 1
            equal(line, sp.trace(line) * full_pi, "symbolic line polarization")
        for word in words(length):
            equal(scalars[1, word] + scalars[-1, word], 0, "projected active containment")
    for arrow in H_LETTERS.values():
        operator = sp.kronecker_product(I2, arrow)
        for coefficient in (Z, X):
            old = sp.kronecker_product(coefficient, I2)
            equal(operator * old - old * operator, zero(4), "input/coefficient tensor separation")
    forbidden = sp.kronecker_product(X, endpoint)
    require(forbidden * sp.kronecker_product(Z, I2)
            != sp.kronecker_product(Z, I2) * forbidden, "inadmissible arrow control")
    return {
        "word_lengths": [1, 2, 3, 4],
        "literal_words": 30,
        "proper_coefficient_equalities": lower_checks,
        "leading_scalar_equalities": leading_checks,
        "cropped_fixed_complement_equalities": unfolded,
        "nontrivial_spectral_graph_cases": nonfixed,
        "direct_input_regularized_limits": limits,
        "commuting_monomial_equalities": commuting,
        "target_labels_checked_simultaneously": ["plus", "minus"],
        "input_arrows_commute_with_old_coefficient_factor": True,
        "forbidden_old_factor_arrow_detected": True,
        "scope": "Exact finite tests, not a proof for all word lengths",
    }


def valuation(expression):
    if expression == 0:
        return None
    numerator, denominator = sp.fraction(sp.cancel(expression))
    n = min(m[0] for m in sp.Poly(numerator, EPS).monoms())
    d = min(m[0] for m in sp.Poly(denominator, EPS).monoms())
    return n - d


def convergence_diagnostics():
    r = sp.Matrix([[EPS, EPS**-2, 2 * EPS**-2],
                   [0, 2 * EPS, 3 * EPS**-2], [0, 0, 3 * EPS]])
    y = sp.zeros(3)
    y[2, 0] = 1
    resolvent = (sp.eye(3) - r).inv()
    exact = [resolvent * (y * resolvent)**j for j in range(3)]
    power = [sp.eye(3), zero(3), zero(3)]
    partial = [sp.eye(3), zero(3), zero(3)]
    samples = []
    for length in range(1, 33):
        old = power
        power = [(r * old[j] + (y * old[j - 1] if j else zero(3))).applyfunc(sp.expand)
                 for j in range(3)]
        partial = [(partial[j] + power[j]).applyfunc(sp.expand) for j in range(3)]
        if length in (8, 16, 24, 32):
            for degree in range(3):
                valuations = [valuation(x) for x in exact[degree] - partial[degree]]
                finite = [v for v in valuations if v is not None]
                measured = min(finite) if finite else None
                bound = length + 1 - degree - 6 * (degree + 1)
                require(measured is None or measured >= bound, "admissible valuation lower bound")
                samples.append({"truncation": length, "Taylor_degree": degree,
                                "tail_valuation": measured, "proved_lower_bound": bound})
    return {
        "blocks": 3,
        "diagonal_valuation": 1,
        "strict_upper_valuation": -2,
        "return_direction": "E_31",
        "series": "sum_m z1^m",
        "samples": samples,
        "scope": "Finite tail checks; the unbounded convergence proof is report Section 2",
    }


def compute():
    m0, m1, jacobian = jacobian_check()
    return {
        "claim": "TRANSFER9000201",
        "result_class": "universal_verification_with_bounded_exact_diagnostics",
        "universal_proof": "report.md Sections 2-8",
        "formal_core_claim": "WT-FIXED-COMPLEMENT9000201",
        "formal_core_scope": "Kernel graph and fixed-complement solution/sandwich only",
        "independent_review": "required_not_asserted_by_this_script",
        "main_division_ring_theorem_verified": False,
        "jacobian": jacobian,
        "inverse": inverse_diagnostics(m0, m1),
        "generic_responses": generic_response_diagnostics(),
        "free_word_transfer": word_diagnostics(),
        "admissible_convergence": convergence_diagnostics(),
    }


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--write-certificate", action="store_true")
    args = parser.parse_args()
    result = compute()
    certificate = ROOT / "exact_certificate.json"
    if args.write_certificate:
        certificate.write_text(json.dumps(result, indent=2, sort_keys=True) + "\n")
        require(json.loads(certificate.read_text()) == result, "certificate persistence")
    else:
        expected = json.loads(certificate.read_text())
        require(result == expected, "recomputed result differs from exact_certificate.json")
    print(json.dumps({
        "ok": True,
        "mode": "generate" if args.write_certificate else "replay",
        "literal_words": result["free_word_transfer"]["literal_words"],
        "leading_scalar_equalities": result["free_word_transfer"]["leading_scalar_equalities"],
        "fixed_complement_equalities": result["free_word_transfer"]["cropped_fixed_complement_equalities"],
        "universal_scope": "Mathematical proof in report; kernel certificate covers only the named core",
    }, sort_keys=True))


if __name__ == "__main__":
    main()
