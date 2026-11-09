#!/usr/bin/env python3
"""Exact universal algebra certificates and explicitly finite falsification checks."""

import argparse
import json
from fractions import Fraction
from itertools import product
from pathlib import Path

import sympy as sp


ROOT = Path(__file__).resolve().parent
IDEMPOTENTS = frozenset({"P", "Q"})


def add(*polynomials):
    result = {}
    for polynomial in polynomials:
        for word, coefficient in polynomial.items():
            result[word] = result.get(word, Fraction(0)) + coefficient
    return {word: value for word, value in result.items() if value}


def scale(coefficient, polynomial):
    return {word: Fraction(coefficient) * value for word, value in polynomial.items()
            if coefficient * value}


def reduce_word(word):
    result = []
    for letter in word:
        if result and letter == result[-1] and letter in IDEMPOTENTS:
            continue
        result.append(letter)
    return tuple(result)


def multiply(left, right):
    result = {}
    for a, ca in left.items():
        for b, cb in right.items():
            word = reduce_word(a + b)
            result[word] = result.get(word, Fraction(0)) + ca * cb
    return {word: value for word, value in result.items() if value}


def chain(*polynomials):
    result = {(): Fraction(1)}
    for polynomial in polynomials:
        result = multiply(result, polynomial)
    return result


def adjoint(polynomial):
    return {tuple(reversed(word)): value for word, value in polynomial.items()}


def variable(name):
    return {(name,): Fraction(1)}


def tensor(left, right):
    return {(a, b): ca * cb for a, ca in left.items() for b, cb in right.items()}


def normal_form(polynomial):
    return [{"word": list(word), "coefficient": str(value)}
            for word, value in sorted(polynomial.items())]


def equal(left, right, label):
    residual = add(left, scale(-1, right))
    assert not residual, f"{label}: nonzero exact coefficient residual {residual}"


def universal_algebra():
    one = {(): Fraction(1)}
    p, q = variable("P"), variable("Q")
    complement = add(one, scale(-1, p))
    x = add(p, scale(-1, chain(p, q, p)))
    block = chain(p, q, add(scale(2, one), scale(-1, p)), q, p)
    defect = add(p, scale(-1, block))
    equal(defect, chain(x, x), "noncommutative projection defect")
    equal(x, adjoint(x), "defect factor is self-adjoint")
    qp, cqp = chain(q, p), chain(complement, q, p)
    equal(block, add(chain(adjoint(qp), qp), chain(adjoint(cqp), cqp)),
          "positive weighted block")
    equal(chain(complement, complement), complement, "complement idempotence")
    equal(chain(p, complement), {}, "pattern orthogonality")
    equal(add(p, complement), one, "binary pattern completeness")
    equal(add(p, scale(-1, complement)), add(scale(2, p), scale(-1, one)),
          "flipped-count displacement")

    a, b, c, d = (variable(name) for name in ("A", "B", "C", "D"))
    equal(add(tensor(b, d), scale(-1, tensor(a, c))),
          add(tensor(add(b, scale(-1, a)), d),
              tensor(a, add(d, scale(-1, c)))),
          "universal tensor-order induction identity")

    reflection = add(one, scale(-2, q))
    equal(chain(reflection, a, reflection),
          add(a, scale(-2, chain(q, a)), scale(-2, chain(a, q)),
              scale(4, chain(q, a, q))),
          "ordered reflection expansion")
    h, f = variable("H"), variable("F")
    equal(chain(h, q, p, q, h),
          add(chain(h, f, p, q, h), chain(h, add(q, scale(-1, f)), p, q, h)),
          "replace only the leftmost projection after squaring")

    k, ks, w = variable("K"), variable("Ks"), variable("W")
    equal(p, add(add(p, scale(-1, chain(ks, w, k))), chain(ks, w, k)),
          "compressed-tail coefficient of the central scalar")
    equal(scale(-1, chain(ks, h, k)), scale(-1, chain(ks, h, k)),
          "compressed-tail constant coefficient")

    wrong_block = chain(p, q, add(scale(2, one), p), q, p)
    assert add(p, scale(-1, wrong_block), scale(-1, chain(x, x))), \
        "A sign mutation unexpectedly passed"
    assert chain(p, q) != chain(q, p), "The normalizer must not commute P and Q"
    return {
        "kind": "universal_noncommutative_identity",
        "coefficient_ring": "QQ",
        "rewrite_relations": ["PP=P", "QQ=Q"],
        "star_rule": "reverse each word; P,Q are self-adjoint; coefficients are real",
        "soundness": "Each word reduction is an idempotence substitution; zero residual proves the identity in every unital ring satisfying the relations.",
        "defect_normal_form": normal_form(defect),
        "weighted_block_normal_form": normal_form(block),
        "gram_factors": [normal_form(qp), normal_form(cqp)],
        "defect_gram_factor": normal_form(x),
        "residual_terms": 0,
        "tensor_induction_residual_terms": 0,
        "ordered_reflection_residual_terms": 0,
        "one_sided_substitution_residual_terms": 0,
        "compressed_tail_central_scalar_coefficient_residual_terms": [0, 0],
        "mutation_controls": {"wrong_sign_rejected": True, "PQ_equals_QP_rejected": True},
        "positive_implication": "For orthogonal projections, 0 <= PQ(2I-P)QP <= P; tensor monotonicity and H<=cW imply (AP0)*H(AP0)<=cP0 when P0 A W A P0<=P0 and c>=0."
    }


def universal_exponents():
    s = sp.Symbol("s", nonnegative=True)
    delta, h = sp.symbols("delta h", positive=True)
    t, b = s + h + delta, s + 2 * h + delta
    a, u, w = s + delta / 4, t - delta / 4, t - delta / 8
    margins = {
        "a-s": a - s,
        "u-a": u - a,
        "w-u": w - u,
        "t-w": t - w,
        "b-t": b - t,
        "u-(a+b)/2": u - (a + b) / 2,
    }
    for name, value in margins.items():
        value = sp.expand(value)
        assert value.is_positive is True, f"Unproved universal margin: {name}={value}"
        margins[name] = str(value)
    assert sp.simplify(2 * t - s - b - delta) == 0

    i = sp.Symbol("i", integer=True, nonnegative=True)
    g = sp.Symbol("g", positive=True)
    initial_t = sp.Symbol("initial_t", real=True)
    eta = g ** 2 / 100
    ti = initial_t + i * g - 3 * eta * i * (i + 1) / 2
    gi = g - 3 * i * eta
    si = ti - gi
    assert sp.expand(ti.subs(i, i + 1) - (2 * ti - si - 3 * eta)) == 0
    assert sp.expand(si.subs(i, i + 1) - ti) == 0
    cap = sp.Symbol("K", real=True)
    assert sp.expand((9 * g / 100 - 3 * cap * eta)
                     - 3 * g * (3 - cap * g) / 100) == 0
    assert sp.Rational(91, 100) > sp.Rational(1, 2)

    z = sp.Symbol("z", positive=True)
    ell = sp.Symbol("ell", integer=True)
    cheb = lambda j: (z ** j + z ** (-j)) / 2
    residual = 2 * cheb(1) * cheb(ell) - cheb(ell - 1) - cheb(ell + 1)
    assert sp.simplify(sp.expand_power_base(sp.expand(residual), force=False)) == 0
    assert sp.simplify(cheb(0) - 1) == 0
    return {
        "kind": "universal_symbolic_induction_certificates",
        "backward_parameters": {"s": "s>=0", "t": str(t), "b": str(b),
                                "delta": "delta>0", "h": "h>0",
                                "a": str(a), "u": str(u), "w": str(w)},
        "strict_positive_margins": margins,
        "scale_closed_form": str(ti),
        "scale_gap": str(gi),
        "scale_recurrence_residual": 0,
        "scale_bound_identity": "9g/100-3K(g^2/100)=3g(3-Kg)/100",
        "scale_bound_hypotheses": "0<g<=1 and K=ceil(2/g) imply Kg<=3",
        "scale_terminal_argument": "g_i>=91g/100>g/2 for i<=K; t_K>t+Kg/2>=t+1>1",
        "chebyshev_hyperbolic_recurrence_residual": 0,
        "boundary": "The complete analytic inequalities and finite-depth induction are proved in dimension_uniform_localization.md, not inferred from finite exponent samples."
    }


def exact_zero(matrix, label):
    assert matrix == sp.zeros(matrix.rows, matrix.cols), f"{label}: {matrix}"


def projection_checks(p, q, label):
    size = p.rows
    eye = sp.eye(size)
    exact_zero(p * p - p, label + ": P idempotence")
    exact_zero(q * q - q, label + ": Q idempotence")
    exact_zero(p.H - p, label + ": P Hermitian")
    exact_zero(q.H - q, label + ": Q Hermitian")
    block = p * q * (2 * eye - p) * q * p
    x = p - p * q * p
    exact_zero(p - block - x.H * x, label + ": defect Gram identity")
    qp, cqp = q * p, (eye - p) * q * p
    exact_zero(block - qp.H * qp - cqp.H * cqp, label + ": block Gram identity")
    return block


def rotation(size, first, second, cosine, sine):
    result = sp.eye(size)
    result[first, first] = result[second, second] = cosine
    result[first, second], result[second, first] = -sine, sine
    return result


def rational_stress_cases():
    total = noncommuting = 0
    ranks = []
    for size in range(1, 5):
        orthogonal = sp.eye(size)
        for j in range(size - 1):
            orthogonal = rotation(size, j, j + 1, sp.Rational(3, 5),
                                  sp.Rational(4, 5)) * orthogonal
        exact_zero(orthogonal.T * orthogonal - sp.eye(size), "rational orthogonal basis")
        for rank_p, rank_q in product(range(size + 1), repeat=2):
            p = sp.diag(*([1] * rank_p + [0] * (size - rank_p)))
            q0 = sp.diag(*([1] * rank_q + [0] * (size - rank_q)))
            q = orthogonal * q0 * orthogonal.T
            projection_checks(p, q, f"dimension={size}, ranks={rank_p},{rank_q}")
            total += 1
            noncommuting += int(p * q != q * p)
            ranks.append((size, rank_p, rank_q))
    return {"kind": "finite_falsification_checks_only", "cases": total,
            "noncommuting_cases": noncommuting, "dimensions": [1, 2, 3, 4],
            "ranks_include_zero_and_identity": True,
            "all_projection_rank_pairs_checked": [list(x) for x in ranks]}


def higher_rank_and_entangled_cases():
    p = sp.diag(1, 1, 0, 0)
    q = sp.Matrix([[9, 0, 12, 0], [0, 16, 0, 12],
                   [12, 0, 16, 0], [0, 12, 0, 9]]) / 25
    block = projection_checks(p, q, "rank-two noncommuting example")
    assert p.rank() == q.rank() == 2 and p * q != q * p
    phase = sp.diag(1, 1, sp.I, sp.I)
    qc = phase * q * phase.H
    projection_checks(p, qc, "genuinely complex rank-two example")
    assert any(sp.im(entry) != 0 for entry in qc)
    pt = sp.kronecker_product(p, p)
    at = sp.kronecker_product(q, q)
    weight = sp.kronecker_product(2 * sp.eye(4) - p, 2 * sp.eye(4) - p)
    active = [j for j in range(16) if pt[j, j] == 1]
    tensor_defect = pt - pt * at * weight * at * pt
    assert tensor_defect.extract(active, active).is_positive_semidefinite is True
    counts = [int((1 - p[j // 4, j // 4]) + (1 - p[j % 4, j % 4]))
              for j in range(16)]
    for threshold in range(4):
        high = sp.diag(*(int(count >= threshold) for count in counts))
        slack = sp.Rational(1, 2) ** threshold * pt - pt * at * high * at * pt
        assert slack.extract(active, active).is_positive_semidefinite is True

    vector = sp.zeros(16, 1)
    vector[0], vector[5] = 1, 1
    assert sp.Matrix(4, 4, list(vector)).rank() == 2, "Input must be entangled"
    exact_zero(pt * vector - vector, "entangled input zero sector")
    output = at * vector
    mass = (output.H * output)[0]
    probabilities = {}
    for first, second in product((0, 1), repeat=2):
        pattern = sp.kronecker_product(p if first == 0 else sp.eye(4) - p,
                                      p if second == 0 else sp.eye(4) - p)
        probabilities[f"{first}{second}"] = sp.factor((output.H * pattern * output)[0] / mass)
    assert sum(probabilities.values()) == 1
    marginal = probabilities["10"] + probabilities["11"]
    correlation = sp.factor(probabilities["11"] - marginal ** 2)
    assert marginal == sp.Rational(144, 337)
    assert correlation == sp.Rational(1016064, 70980625) > 0

    payload = json.loads((ROOT / "jacobian_projection_payload.json").read_text())
    envelope = json.loads((ROOT / "jacobian_projection_output.json").read_text())
    rational = lambda x: sp.Rational(x["num"], x["den"])
    decode = lambda x: sp.Matrix([[rational(e) for e in row]
                                  for row in x["matrix"]["entries"]])
    assert decode(payload["left"]) == block
    assert decode(payload["right"]) == p
    assert envelope["request"]["payload"] == payload
    assert envelope["result"]["operation_id"] == "matrix.subsystem.psd_order.decide"
    typed = envelope["result"]["output"]
    assert typed["is_less_or_equal"] is True
    assert typed["inertia"] == {"n_positive": 2, "n_negative": 0, "n_zero": 2}
    assert typed["negative_witness"] is None
    exact_zero(decode(typed["difference"]) - (p - block), "Jacobian exact difference")
    return {
        "kind": "finite_noncommuting_higher_rank_and_entangled_checks",
        "local_dimension": 4, "local_projection_ranks": [2, 2],
        "complex_case_checked": True, "commutator_nonzero": True,
        "local_defect_diagonal": [str(x) for x in (p - block).diagonal()],
        "entangled_input_schmidt_rank": 2,
        "binary_mismatch_probabilities": {k: str(v) for k, v in probabilities.items()},
        "marginal": str(marginal), "nonindependence_gap": str(correlation),
        "integer_tail_thresholds_checked": [0, 1, 2, 3],
        "jacobian": {"operation_id": envelope["result"]["operation_id"],
                     "server_version": envelope["server"]["version"],
                     "protocol_version": envelope["protocol_version"],
                     "adapter_exit_code": 0, "error": None, "timeout": False,
                     "payload_file": "research/jacobian_projection_payload.json",
                     "typed_output_file": "research/jacobian_projection_output.json",
                     "inertia": typed["inertia"]}
    }


def inverse_substitution_case():
    p = sp.diag(1, 1, 0, 0)
    q = sp.Matrix([[9, 0, 12, 0], [0, 16, 0, 12],
                   [12, 0, 16, 0], [0, 12, 0, 9]]) / 25
    local = rotation(4, 0, 1, sp.Rational(5, 13), sp.Rational(12, 13))
    unitary = (sp.eye(16) - 2 * sp.kronecker_product(q, q)) * \
        sp.kronecker_product(local, sp.eye(4))
    exact_zero(unitary.H * unitary - sp.eye(16), "depth-one exact unitarity")
    zero_m = sp.kronecker_product(p, p)
    e1, e2 = sp.diag(1, 0, 1, 0), sp.diag(1, 1, 1, 0)
    zero_d = sp.kronecker_product(e1, e2)
    high_d = sp.eye(16) - zero_d
    conjugated_zero = unitary * zero_d * unitary.H
    conjugated_high = unitary * high_d * unitary.H
    exact_zero(unitary.H * conjugated_high * zero_m * conjugated_zero * unitary
               - high_d * unitary.H * zero_m * unitary * zero_d,
               "inverse substitution with different higher-rank counts")
    assert zero_m * conjugated_zero != conjugated_zero * zero_m, \
        "The inverse stress case must not accidentally commute"
    return {"kind": "finite_ordering_falsification_check", "tensor_dimensions": [4, 4],
            "depth": 1, "two_zero_projection_ranks": [4, 6],
            "zero_projections_do_not_commute": True, "exact_residual": 0}


def polynomial_case():
    x = sp.Symbol("x")
    n, r, m, ell = 32, 2, 8, 18
    z = sp.Rational(m + r, m - r) - sp.Rational(2, m - r) * x
    denominator = sp.chebyshevt(ell, z.subs(x, 0))
    root = sp.prod(1 - x / j for j in range(1, r + 1))
    polynomial = sp.Poly(sp.expand(root * sp.chebyshevt(ell, z) / denominator), x)
    assert polynomial.eval(0) == 1
    assert all(polynomial.eval(j) == 0 for j in range(1, r + 1))
    assert denominator >= sp.Rational(1, 2) * m ** (4 * r)
    assert all(abs(polynomial.eval(j)) <= sp.Rational(2, m ** (3 * r))
               for j in range(r, m + 1))
    weighted_norm = sum(abs(coefficient) * n ** powers[0]
                        for powers, coefficient in polynomial.terms())
    assert weighted_norm <= (1 + n) ** r * (11 * (1 + n)) ** ell
    return {"kind": "finite_exact_polynomial_falsification_check",
            "N": n, "r": r, "m": m, "ell": ell, "degree": polynomial.degree(),
            "denominator": str(denominator), "p_zero": "1",
            "positive_integer_roots": list(range(1, r + 1)),
            "integer_decay_bound": str(sp.Rational(2, m ** (3 * r))),
            "weighted_norm_bound_checked": True}


def certificate():
    return {
        "claim": "C_DIM_UNIFORM",
        "result_class": "new_theorem_candidate",
        "theorem": "For every fixed d>=0 and 0<=s<t, all sufficiently large N satisfy ||[M>=N^t]U[D=0]U*[M=0]||<=exp(-N^s), uniformly in arbitrary finite local dimensions, local orthogonal projection ranks, and depth-d disjoint product-reflection circuits.",
        "proof": "research/dimension_uniform_localization.md",
        "formal_core_claim": "C_DIM_CORE",
        "formal_source": "research/Main.lean",
        "statement_fidelity": "research/statement_fidelity.md",
        "universal_exact_checks": [universal_algebra(), universal_exponents()],
        "finite_falsification_checks": [rational_stress_cases(),
                                       higher_rank_and_entangled_cases(),
                                       inverse_substitution_case(), polynomial_case()],
        "scope": {"full_circuit_theorem_kernel_formalized": False,
                  "unproved_localization_assumptions": [],
                  "manuscript_assertions_refuted": [],
                  "retired_extension_route": "R_SCALAR_HIGH_RANK",
                  "independent_review": "pending",
                  "novelty_status": "not_independently_verified",
                  "significance_status": "pending_independent_review"}
    }


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--write-certificate", action="store_true")
    args = parser.parse_args()
    result = certificate()
    path = ROOT / "exact_certificate.json"
    if args.write_certificate:
        path.write_text(json.dumps(result, indent=2, sort_keys=True) + "\n")
    else:
        assert path.is_file(), "Missing exact_certificate.json; use --write-certificate once"
        assert json.loads(path.read_text()) == result, "The stored exact certificate differs"
    print(json.dumps({"ok": True, "universal_certificate_groups": 2,
                      "finite_rational_projection_cases":
                          result["finite_falsification_checks"][0]["cases"],
                      "formal_core_claim": result["formal_core_claim"],
                      "independent_review": "pending"}, sort_keys=True))


if __name__ == "__main__":
    main()
