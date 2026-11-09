#!/usr/bin/env python3
"""Replay exact algebra supporting the parameterized proof in report.md."""

import hashlib
import json
from fractions import Fraction
from itertools import combinations, product
from math import comb
from pathlib import Path


HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]


def require(condition, message):
    if not condition:
        raise AssertionError(message)


def poly_add(*polynomials):
    size = max(map(len, polynomials))
    return [
        sum(p[i] if i < len(p) else 0 for p in polynomials)
        for i in range(size)
    ]


def poly_scale(c, p):
    return [c * value for value in p]


def poly_mul(p, q):
    out = [0] * (len(p) + len(q) - 1)
    for i, a in enumerate(p):
        for j, b in enumerate(q):
            out[i + j] += a * b
    return out


def poly_at(p, x):
    out = 0
    for c in reversed(p):
        out = out * x + c
    return out


def shift_by_one(p):
    return [
        sum(comb(k, j) * p[k] for k in range(j, len(p)))
        for j in range(len(p))
    ]


def verify_budgets(certificate):
    r = [0, 1]
    axes = poly_add(r, r)
    grid = poly_mul(r, r)
    collision = poly_add(axes, grid)
    translated_centers = poly_mul(r, poly_add(r, [1]))
    completion = poly_add(collision, translated_centers)
    budgets = certificate["budget_polynomials"]
    require(collision == budgets["collision_gamma"], "collision count")
    require(completion == budgets["completion_gamma"], "completion count")
    require(budgets["collision_rho"] == 2, "two grid-direction failures")
    require(budgets["completion_rho"] == 2 + 1, "one shared direction failure")
    require(poly_at(collision, 3) == budgets["quadratic_collision_gamma"] == 15,
            "quadratic collision count")
    require(poly_at(completion, 3) == budgets["quadratic_completion_gamma"] == 27,
            "quadratic completion count")
    source = certificate["source"]["specialization"]
    require(source["degree"] + 1 == source["r"] == 3, "degree specialization")
    require(source["original_completion_rho_coefficient"] == 5,
            "literal manuscript completion coefficient")
    require(source["verified_completion_rho_coefficient"] == 3,
            "improved completion coefficient")
    require(5 - 3 > 0, "source completion implies improved bound for delta>=0")

    corollary = certificate["all_degree_nonvacuity"]
    propagation = poly_add(poly_scale(96, completion), [-22, -17])
    filling = poly_add(poly_scale(112, completion), [-3])
    require(propagation == corollary["propagation_numerator"],
            "general propagation margin numerator")
    require(filling == corollary["completion_numerator"],
            "general completion margin numerator")
    for p, key in (
        (propagation, "propagation_after_r_equals_s_plus_one"),
        (filling, "completion_after_r_equals_s_plus_one"),
    ):
        shifted = shift_by_one(p)
        require(shifted == corollary[key], "positive shifted coefficients")
        require(shifted[0] > 0 and all(c >= 0 for c in shifted),
                "positivity for every real s>=0")
    require(Fraction(1, 2) - 2 * Fraction(1, 16) - Fraction(1, 4)
            == Fraction(1, 8), "general cleanup margin")


def verify_source_and_margins(certificate):
    source_spec = certificate["source"]
    text = (ROOT / source_spec["path"]).read_text()
    start = r"\begin{lemma}\label{" + source_spec["label"] + "}"
    require(text.count(start) == 1, "unique target source lemma")
    lemma = text.split(start, 1)[1].split(r"\end{lemma}", 1)[0]
    normalized = "".join(lemma.split())
    for fragment in source_spec["required_fragments"]:
        require("".join(fragment.split()) in normalized,
                f"manuscript assertion changed: {fragment}")
    line_law = (
        r"The line law samples uniform $A$ and $h\sim\mathsf D$, queries",
        r"$P(A+th)$ for all $t\in\F$, and checks degree at most two.",
    )
    for fragment in line_law:
        require("".join(fragment.split()) in "".join(text.split()),
                "actual all-points line law")

    box = certificate["source_parameter_box"]
    gamma = Fraction(box["gamma"])
    delta = Fraction(box["delta_upper"])
    lam = Fraction(box["lambda_upper"])
    inverse_q = Fraction(box["inverse_q_minus_one_upper"])
    margins = {
        "cleanup_margin_lower": gamma / 2 - 2 * delta - lam,
        "propagation_margin_lower": 1 - 4 * gamma - 5 * delta - 2 * inverse_q - lam,
        "source_completion_margin_lower": 1 - 27 * gamma - 5 * delta,
        "improved_completion_margin_lower": 1 - 27 * gamma - 3 * delta,
    }
    for key, value in margins.items():
        require(value == Fraction(box[key]) and value > 0, key)
    return {key: str(value) for key, value in margins.items()}


class FiniteField:
    def __init__(self, order, binary_modulus):
        self.q = order
        self.modulus = binary_modulus

    def add(self, a, b):
        return (a ^ b) if self.modulus is not None else (a + b) % self.q

    def neg(self, a):
        return a if self.modulus is not None else (-a) % self.q

    def sub(self, a, b):
        return self.add(a, self.neg(b))

    def mul(self, a, b):
        if self.modulus is None:
            return a * b % self.q
        value = 0
        while b:
            if b & 1:
                value ^= a
            b >>= 1
            a <<= 1
            if a & self.q:
                a ^= self.modulus
        return value

    def power(self, a, n):
        result = 1
        while n:
            if n & 1:
                result = self.mul(result, a)
            a = self.mul(a, a)
            n >>= 1
        return result

    def inverse(self, a):
        require(a != 0, "zero interpolation denominator")
        result = self.power(a, self.q - 2)
        require(self.mul(a, result) == 1, "field inverse")
        return result

    def total(self, values):
        result = 0
        for value in values:
            result = self.add(result, value)
        return result

    def evaluate(self, coefficients, x):
        result = 0
        for coefficient in reversed(coefficients):
            result = self.add(self.mul(result, x), coefficient)
        return result


def verify_finite_algebra(spec):
    field = FiniteField(spec["order"], spec["binary_modulus"])
    q, maximum = field.q, spec["max_degree"]
    require(0 <= maximum < q - 1, "interpolation degree range")
    for a in range(q):
        require(field.add(a, field.neg(a)) == 0, "additive inverse")
        if a:
            field.inverse(a)
    for a, b, c in product(range(q), repeat=3):
        require(field.mul(a, field.add(b, c)) ==
                field.add(field.mul(a, b), field.mul(a, c)), "distributivity")
        require(field.mul(field.mul(a, b), c) ==
                field.mul(a, field.mul(b, c)), "multiplication associativity")

    interpolation_tuples = relation_tuples = 0
    for degree in range(maximum + 1):
        r = degree + 1
        for nodes in combinations(range(1, q), r):
            weights = []
            for i, a in enumerate(nodes):
                numerator = denominator = 1
                for j, b in enumerate(nodes):
                    if i != j:
                        numerator = field.mul(numerator, field.neg(b))
                        denominator = field.mul(denominator, field.sub(a, b))
                weights.append(field.mul(numerator, field.inverse(denominator)))
            for power in range(r):
                value = field.total(
                    field.mul(w, field.power(a, power))
                    for w, a in zip(weights, nodes)
                )
                require(value == (1 if power == 0 else 0),
                        "Lagrange evaluation-at-zero identity")
            interpolation_tuples += 1

        for nodes in combinations(range(q), r + 1):
            weights = []
            for i, a in enumerate(nodes):
                denominator = 1
                for j, b in enumerate(nodes):
                    if i != j:
                        denominator = field.mul(denominator, field.sub(a, b))
                weights.append(field.inverse(denominator))
            for power in range(r + 1):
                value = field.total(
                    field.mul(w, field.power(a, power))
                    for w, a in zip(weights, nodes)
                )
                require(value == (1 if power == r else 0),
                        "annihilating-relation coefficient and orientation")
            relation_tuples += 1

    require(interpolation_tuples ==
            sum(comb(q - 1, d + 1) for d in range(maximum + 1)),
            "complete interpolation tuple enumeration")
    require(relation_tuples ==
            sum(comb(q, d + 2) for d in range(maximum + 1)),
            "complete relation tuple enumeration")
    polynomials = 0
    for coefficients in product(range(q), repeat=maximum + 1):
        if not any(coefficients):
            continue
        degree = max(i for i, c in enumerate(coefficients) if c)
        roots = sum(field.evaluate(coefficients, x) == 0 for x in range(q))
        require(roots <= degree, "univariate root bound")
        polynomials += 1
    require(polynomials == q ** (maximum + 1) - 1,
            "complete polynomial enumeration")
    return {
        "field_order": q,
        "interpolation_node_sets": interpolation_tuples,
        "relation_node_sets": relation_tuples,
        "nonzero_polynomials_root_checked": polynomials,
    }


def canonical_rational(value):
    numerator, denominator = int(value["num"]), int(value["den"])
    require(denominator > 0, "positive typed rational denominator")
    result = Fraction(numerator, denominator)
    require(result.numerator == numerator and result.denominator == denominator,
            "canonical typed rational")
    return result


def verify_jacobian(certificate):
    spec = certificate["jacobian"]
    request = json.loads((HERE / spec["request_file"]).read_text())
    result = json.loads((HERE / spec["output_file"]).read_text())
    status = json.loads((HERE / spec["status_file"]).read_text())
    require(status["exit_code"] == 0 and status["timeout"] is False
            and status["adapter_error"] is None, "Jacobian adapter status")
    require(result["request"]["operation_id"] == spec["operation_id"]
            == status["operation_id"], "Jacobian operation binding")
    require(result["request"]["payload"] == request, "exact Jacobian payload")
    require(result["server"]["version"] == status["server_version"]
            and result["protocol_version"] == status["protocol_version"],
            "Jacobian server and protocol")
    require("error" not in result and "output" in result["result"],
            "complete typed Jacobian result")
    output = result["result"]["output"]
    require(output["polynomial"] == request["polynomial"]
            and output["box"] == request["box"], "retained Jacobian input")

    bounds = request["box"]["intervals"]
    lower = upper = Fraction(0)
    for term in request["polynomial"]["polynomial"]["terms"]:
        coefficient = canonical_rational(term["coefficient"])
        exponents = term["exponents"]
        require(sum(exponents) <= 1, "this replay is for an affine enclosure")
        if not any(exponents):
            lower += coefficient
            upper += coefficient
        else:
            index = exponents.index(1)
            lo = coefficient * canonical_rational(bounds[index]["lower"])
            hi = coefficient * canonical_rational(bounds[index]["upper"])
            lower += min(lo, hi)
            upper += max(lo, hi)
    require(canonical_rational(output["enclosure"]["lower"]) == lower
            == Fraction(spec["expected_lower"]) > 0, "exact enclosure lower")
    require(canonical_rational(output["enclosure"]["upper"]) == upper
            == Fraction(spec["expected_upper"]), "exact enclosure upper")
    return {"lower": str(lower), "upper": str(upper)}


def verify_formal_core(certificate):
    spec = certificate["formal_core"]
    archive_path = HERE / spec["certificate_file"]
    archive = json.loads(archive_path.read_text())
    check = archive["lean_check"]
    require(archive["tier"] == "mechanical" and archive["verdict"] == "supports",
            "actual mechanical evidence")
    require(archive["subject"]["subject_id"] == spec["claim_id"] == "Q_KERNEL",
            "formal core is not the full correction claim")
    require(check["status"] == "success" and check["exit_code"] == 0
            == spec["exit_code"], "real compiler success")
    require(check["proof_holes"] == spec["proof_holes"] == []
            and check["audit_exit_code"] == 0, "zero proof holes")
    require(check["environment_failure"] == ""
            and "version 4.31.0," in check["tools"]["lean"]["version"],
            "required actual Lean toolchain")
    for key, file_key, archived_key in (
        ("source", "source", "lean_source"),
        ("statement_fidelity", "statement_fidelity", "statement_fidelity"),
    ):
        path = (HERE / spec[file_key]).resolve()
        require(Path(check[key]).resolve() == path, "compiler input path")
        require(hashlib.sha256(path.read_bytes()).hexdigest() ==
                check[key + "_sha256"], "compiler evidence must be fresh")
        require(archive[archived_key]["text"] == path.read_text(),
                "archived compiler input matches current text")
    state = json.loads((ROOT / "research/MATH_STATE.json").read_text())
    versions = [c for c in state["claims"] if c["claim_id"] == spec["claim_id"]]
    require(bool(versions), "recorded formal claim")
    current = max(versions, key=lambda c: c["version"])
    require(current["content_hash"] == archive["subject"]["content_hash"],
            "mechanical evidence binds the current claim version")
    require(current["formal_statement"] == (HERE / spec["source"]).read_text(),
            "ledger statement matches actual formal source")
    artifact = archive_path.relative_to(ROOT).as_posix()
    require(any(
        e["subject"] == archive["subject"] and
        e["tier"] == "mechanical" and e["verdict"] == "supports" and
        e["artifact"] == artifact
        for e in state["evidence"]
    ), "official verifier recorded the archived certificate")
    return {
        "claim_id": spec["claim_id"],
        "compiler": spec["compiler"],
        "exit_code": check["exit_code"],
        "proof_holes": check["proof_holes"],
        "source_and_statement_fidelity_fresh": True,
    }


def main():
    certificate = json.loads((HERE / "exact_certificate.json").read_text())
    require(certificate["format_version"] == 1, "certificate format")
    require(certificate["claim_id"] == "Q_GENERAL", "theorem claim")
    require((HERE / certificate["proof_file"]).is_file(), "parameterized proof")
    verify_budgets(certificate)
    margins = verify_source_and_margins(certificate)
    fields = [verify_finite_algebra(spec)
              for spec in certificate["finite_algebra_checks"]]
    jacobian = verify_jacobian(certificate)
    formal_core = verify_formal_core(certificate)
    print(json.dumps({
        "ok": True,
        "claim_id": certificate["claim_id"],
        "checked": "exact budget identities, all-degree margins, manuscript specialization, finite-field algebra, retained Jacobian enclosure",
        "full_theorem_evidence": "parameterized proof in report.md; independent mathematical review required",
        "formal_core": formal_core,
        "margins": margins,
        "finite_algebra": fields,
        "jacobian_enclosure": jacobian,
    }, indent=2))


if __name__ == "__main__":
    main()
