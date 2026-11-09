#!/usr/bin/env python3
"""Offline exact replay; the scope of each check is in exact_certificate.json."""

from fractions import Fraction as Q
from hashlib import sha256
from math import factorial
from pathlib import Path
import json


ROOT = Path(__file__).resolve().parent


def check(condition, message):
    if not condition:
        raise ValueError(message)


def load(path):
    return json.loads((ROOT / path).read_text(encoding="utf-8"))


def add(*polynomials):
    result = {}
    for polynomial in polynomials:
        for key, coefficient in polynomial.items():
            result[key] = result.get(key, Q(0)) + coefficient
    return {key: value for key, value in result.items() if value}


def scale(polynomial, coefficient):
    coefficient = Q(coefficient)
    return {key: value * coefficient for key, value in polynomial.items()
            if value * coefficient}


def sub(left, right):
    return add(left, scale(right, -1))


def mul(left, right):
    result = {}
    for x, a in left.items():
        for y, b in right.items():
            key = tuple(i + j for i, j in zip(x, y, strict=True))
            result[key] = result.get(key, Q(0)) + a * b
    return {key: value for key, value in result.items() if value}


def constant(variables, value=1):
    return {(0,) * variables: Q(value)} if value else {}


def variable(variables, index):
    return {tuple(int(i == index) for i in range(variables)): Q(1)}


def diff(polynomial, index):
    result = {}
    for exponent, coefficient in polynomial.items():
        if exponent[index]:
            key = list(exponent)
            key[index] -= 1
            result[tuple(key)] = coefficient * exponent[index]
    return result


def typed_polynomial(value, variables):
    result = {}
    previous = None
    for term in value["terms"]:
        exponent = tuple(term["exponents"])
        check(len(exponent) == variables and all(i >= 0 for i in exponent),
              "Invalid polynomial exponent")
        check(previous is None or previous > exponent, "Noncanonical term order")
        previous = exponent
        numerator, denominator = term["coefficient"]["num"], term["coefficient"]["den"]
        coefficient = Q(int(numerator), int(denominator))
        check(coefficient != 0 and str(coefficient.numerator) == numerator
              and str(coefficient.denominator) == denominator,
              "Noncanonical rational coefficient")
        result[exponent] = coefficient
    return result


def typed_entry(value, names):
    check(value["variables"] == names and value.get("domain", "QQ") == "QQ",
          "Changed rational-function field")
    check(typed_polynomial(value["denominator"], len(names)) == constant(len(names)),
          "This pivot certificate requires polynomial entries")
    return typed_polynomial(value["numerator"], len(names))


def verify_jacobian(certificate):
    data = certificate["jacobian"]
    contract, payload, response = (load(data[key]) for key in ("contract", "payload", "result"))
    operation = data["operation_id"]
    check(operation == "matrix.symbolic.determinant.compute"
          and contract["result"]["operation"]["operation_id"] == operation,
          "Operation was not inspected")
    for record in (contract, response):
        check(record["server"]["version"] == data["server_version"]
              and record["protocol_version"] == data["protocol_version"],
              "Unexpected Jacobian server or protocol")
    check(response["request"] == {"operation_id": operation, "payload": payload},
          "Typed output is not bound to the exact retained payload")
    check(response["result"]["operation_id"] == operation
          and "error" not in response and "error" not in response["result"]
          and data["execution_status"] == "success"
          and data["adapter_error"] is None and data["timeout"] is False,
          "A non-conclusion cannot certify a determinant")
    names = ["a", "b", "c", "d", "lam", "x", "y", "w"]
    check(payload["matrix"]["variables"] == names, "Changed pivot variables")
    a, b, c, d, lam, x, y, w = [variable(8, i) for i in range(8)]
    shear = add(x, mul(y, lam))
    expected_matrix = [[a, b], [mul(w, add(c, mul(shear, a))),
                                mul(w, add(d, mul(shear, b)))]]
    matrix = [[typed_entry(entry, names) for entry in row]
              for row in payload["matrix"]["entries"]]
    check(matrix == expected_matrix, "Payload no longer represents the pivot construction")
    determinant = sub(mul(matrix[0][0], matrix[1][1]),
                      mul(matrix[0][1], matrix[1][0]))
    expected = mul(w, sub(mul(a, d), mul(b, c)))
    output = response["result"]["output"]
    check(output["method"] == "SYMPY_BAREISS"
          and determinant == expected == typed_entry(output["determinant"], names),
          "Symbolic pivot determinant mismatch")


class WordAlgebra:
    def __init__(self, degree):
        self.degree = degree
        self.weights = {}
        self.derivatives = {}
        self.one = {(): Q(1)}

    def atom(self, name, weight=1, differentiable=False):
        self.weights[name] = weight
        if differentiable:
            self.weights["D" + name] = weight
            self.derivatives[name] = "D" + name
        return {(name,): Q(1)}

    def mul(self, left, right):
        result = {}
        for x, a in left.items():
            for y, b in right.items():
                key = x + y
                if sum(self.weights[letter] for letter in key) <= self.degree:
                    result[key] = result.get(key, Q(0)) + a * b
        return {key: value for key, value in result.items() if value}

    def exp(self, value):
        result, power = self.one, self.one
        for i in range(1, self.degree + 1):
            power = self.mul(power, value)
            result = add(result, scale(power, Q(1, factorial(i))))
        return result

    def deriv(self, value):
        result = {}
        for word, coefficient in value.items():
            for i, letter in enumerate(word):
                key = word[:i] + (self.derivatives[letter],) + word[i + 1:]
                result[key] = result.get(key, Q(0)) + coefficient
        return {key: value for key, value in result.items() if value}

    def group(self, logarithm):
        return self.exp(logarithm), self.exp(scale(logarithm, -1))

    def product(self, left, right):
        return self.mul(left[0], right[0]), self.mul(right[1], left[1])

    def adjoint(self, group, value):
        return self.mul(self.mul(group[0], value), group[1])

    def derivative(self, group):
        return self.mul(self.deriv(group[0]), group[1])


def verify_words(certificate):
    degree = certificate["free_algebra"]["maximum_weight"]
    check(degree == 4, "The retained free-word certificate is through weight four")
    algebra = WordAlgebra(degree)
    logs = [add(*(algebra.atom(f"{name}{j}", j, True)
                  for j in range(1, degree + 1))) for name in ("A", "B", "D")]
    a, b, d = [algebra.group(value) for value in logs]
    ab = algebra.product(a, b)
    full = algebra.product(ab, d)
    adj, derivative = algebra.adjoint, algebra.derivative
    identities = 0
    for group in (a, b, d, full):
        check(algebra.mul(group[0], group[1]) == algebra.one
              and algebra.mul(group[1], group[0]) == algebra.one,
              "Finite exponential inverse identity failed")
        identities += 1
    for logarithm, group in zip(logs, (a, b, d), strict=True):
        term = algebra.deriv(logarithm)
        expected = {}
        for j in range(degree):
            expected = add(expected, scale(term, Q(1, factorial(j + 1))))
            term = sub(algebra.mul(logarithm, term), algebra.mul(term, logarithm))
        check(derivative(group) == expected, "Right exponential derivative sign failed")
        identities += 1
    check(derivative(ab) == add(derivative(a), adj(a, derivative(b))),
          "Right derivative is not the stated cocycle")
    identities += 1
    e, m, z, v, r = [algebra.atom(name) for name in ("e", "m", "z", "v", "r")]
    raw = sub(sub(derivative(full), e), adj(full, m))
    u = sub(sub(raw, adj(a, z)), adj(ab, v))
    common = add(adj((a[1], a[0]), sub(add(e, u), derivative(a))),
                 adj(b, sub(add(v, adj(d, m)), derivative(d))), z)
    check(common == derivative(b), "Common derivative action, order or sign failed")
    identities += 1
    s = sub(sub(derivative(full), adj(full, r)), z)
    transformed = add(adj((a[1], a[0]), sub(s, derivative(a))),
                      adj(b, sub(adj(d, r), derivative(d))),
                      adj((a[1], a[0]), z))
    check(transformed == derivative(b), "Derivative-system transformation failed")
    check(adj((a[1], a[0]), adj(full, r)) == adj(b, adj(d, r)),
          "Lift transformation failed")
    identities += 2
    rk, rks, rkr = [algebra.atom(name) for name in ("rk", "rks", "rkr")]
    sk, sks, skr = [adj(full, value) for value in (rk, rks, rkr)]
    before = add(s, adj(full, r), sk)
    after = add(sub(s, sks), adj(full, sub(r, rkr)), sk, sks, skr)
    check(before == after, "Absorption identity failed")
    return identities + 1


def identity(size):
    return [[Q(int(i == j)) for j in range(size)] for i in range(size)]


def matmul(left, right):
    return [[sum((a * b for a, b in zip(row, column, strict=True)), Q(0))
             for column in zip(*right, strict=True)] for row in left]


def verify_rank_family(certificate):
    data = certificate["heisenberg_rank_family"]
    rank, q = data["replayed_rank"], data["common_q"]
    check(rank >= 1 and q >= 1 and data["density"] == 1, "Invalid family parameters")
    n = 2 * rank
    m = n + rank * n
    l, radius = 2 * q, n + 1
    bound = ((n + m + 2) * radius) ** (n + m) * l ** (m + 1)
    base = bound + 1
    sides = [base ** (i + 1) for i in range(n)]
    numerators = [(j + 1) * base ** (n + 2) + 1 for j in range(rank)]
    matrix, derivatives = identity(m), [[Q(0) for _ in range(n)] for _ in range(m)]
    for block, numerator in enumerate(numerators):
        x, y = 2 * block, 2 * block + 1
        zx, zy = n + block * n + x, n + block * n + y
        central = Q(numerator * numerator, q)
        matrix[zx][y] = Q(numerator)
        matrix[zy][x] = -Q(1, q)
        derivatives[x][x] = Q(numerator)
        derivatives[y][y] = Q(1, q)
        derivatives[zy][x] = central - Q(numerator, 2 * q)
        derivatives[zx][y] = central + Q(numerator, 2 * q)
    inverse = [[2 * Q(int(i == j)) - matrix[i][j] for j in range(m)]
               for i in range(m)]
    check(matmul(matrix, inverse) == identity(m)
          and matmul(inverse, matrix) == identity(m), "Adjoint inverse failed")
    inclusion = [[Q(int(i == j)) for j in range(n)] for i in range(m)]
    lift = matmul(inverse, inclusion)
    rational_derivatives = matmul(inverse, derivatives)
    check(matmul(matrix, lift) == inclusion, "Horizontal lift is not shear-independent")
    check(matmul(matrix, rational_derivatives) == derivatives,
          "Dense-family coordinate equation failed")
    check(all((l * value).denominator == 1
              for table in (lift, rational_derivatives) for row in table for value in row),
          "Common rational denominator was lost")
    check(min(sides) > bound and len(set(sides)) == n
          and all(value > max(sides) for value in numerators),
          "Anisotropy, minimum side or unrestricted-numerator test failed")
    check(any(abs(value) >= numerators[0] for row in lift for value in row),
          "The lift did not retain the intended unbounded numerator")
    return {"rank": rank, "parameters": n, "coefficient_dimension": m,
            "minimum_side_bits": base.bit_length(),
            "maximum_lift_numerator_bits": max(abs(x.numerator).bit_length()
                                               for row in lift for x in row)}


def vadd(*vectors):
    return tuple(add(*(vector[i] for vector in vectors)) for i in range(3))


def vscale(vector, polynomial):
    return tuple(mul(value, polynomial) for value in vector)


def vneg(vector):
    return tuple(scale(value, -1) for value in vector)


def hproduct(left, right):
    x, y, z = left
    a, b, c = right
    return add(x, a), add(y, b), add(z, c, scale(sub(mul(x, b), mul(y, a)), Q(1, 2)))


def hadjoint(group, value):
    x, y, _ = group
    a, b, c = value
    return a, b, add(c, sub(mul(x, b), mul(y, a)))


def hderivative(group, index):
    x, y, z = group
    dx, dy, dz = (diff(value, index) for value in group)
    return dx, dy, add(dz, scale(sub(mul(x, dy), mul(y, dx)), Q(1, 2)))


def verify_real_fast(certificate):
    data = certificate["real_fast_family"]
    check(data["symbolic_variables"] == ["t1", "t2", "u", "h1", "h2", "q_h"],
          "Changed real-fast symbolic variables")
    t1, t2, alpha, h1, h2, qh = [variable(6, i) for i in range(6)]
    one, zero = constant(6), ({}, {}, {})
    side1, side2 = data["T1"], data["T1"] ** data["T2_power"]
    integer = side2 ** data["right_integer_power"] + 17
    epsilon = Q(1, side1)
    a, fast, b = (({}, scale(t1, epsilon), {}),
                  (mul(alpha, t1), {}, {}), ({}, scale(t2, integer), {}))
    full = hproduct(hproduct(a, fast), b)
    S, R = (one, {}, scale(t1, -epsilon)), (one, {}, scale(t2, integer))
    check(hadjoint(full, R) == S, "Real-fast lift equation failed")
    s = [({}, constant(6, epsilon), {}), zero]
    r = [zero, ({}, constant(6, integer), {})]
    k = [alpha, {}]
    for i in range(2):
        rhs = vadd(s[i], hadjoint(full, r[i]), vscale(S, k[i]))
        check(hderivative(full, i) == rhs, "Real-fast coordinate derivative failed")
        si = hadjoint(vneg(a), vadd(s[i], vneg(hderivative(a, i))))
        ri = vadd(hadjoint(b, r[i]), vneg(hderivative(b, i)))
        check(si == zero and ri == zero, "Slow/rational derivative removal failed")
    check(hproduct(hproduct(vneg(a), full), vneg(b)) == fast,
          "Real-fast factorization failed")
    check(hadjoint(vneg(a), S) == (one, {}, {})
          and hadjoint(b, R) == (one, {}, {}), "Lift normalization failed")
    error = sub(mul(h1, alpha), qh)
    slow = vadd(({}, scale(h1, epsilon), {}), vscale(S, error))
    rational = vadd(({}, scale(h2, integer), {}), vscale(R, qh))
    direction = vadd(vscale(hderivative(full, 0), h1),
                     vscale(hderivative(full, 1), h2))
    check(direction == vadd(slow, hadjoint(full, rational)),
          "Full-density rounded common-derivative identity failed")
    check(side2 > side1 > 1 and epsilon * side1 == 1
          and integer > side2, "Real-fast anisotropic scaling failed")


def verify_lean_binding(certificate):
    data = certificate["lean"]
    result, archived = load(data["result"]), load(data["archived_certificate"])
    source = (ROOT / data["source"]).read_bytes()
    fidelity = (ROOT / data["statement_fidelity"]).read_bytes()
    check(result["status"] == "success" and result["exit_code"] == 0
          and result["audit_exit_code"] == 0 and result["proof_holes"] == [],
          "No successful hole-free compiler record")
    check("version 4.31.0" in result["tools"]["lean"]["version"],
          "Wrong Lean toolchain")
    check(sha256(source).hexdigest() == result["source_sha256"]
          and sha256(fidelity).hexdigest() == result["statement_fidelity_sha256"],
          "Lean source or statement fidelity changed after compilation")
    check(archived["lean_check"] == result
          and archived["lean_source"]["text"] == source.decode("utf-8")
          and archived["statement_fidelity"]["text"] == fidelity.decode("utf-8")
          and archived["subject"]["subject_id"] == data["claim"]
          and archived["tier"] == "mechanical" and archived["verdict"] == "supports",
          "Archived mechanical evidence does not match the live compiler record")
    return {"compiler_exit_code": result["exit_code"], "proof_holes": result["proof_holes"],
            "compiler_replayed_by_this_script": False}


def main():
    certificate = load("exact_certificate.json")
    check(certificate["schema_version"] == 1
          and certificate["claim"] == "C_UNIFORM_RECOVERY"
          and certificate["campaign_complete"] is False,
          "Changed certificate scope")
    verify_jacobian(certificate)
    words = verify_words(certificate)
    family = verify_rank_family(certificate)
    verify_real_fast(certificate)
    lean = verify_lean_binding(certificate)
    print(json.dumps({"certificate_replay": "passed", "symbolic_pivot": "w*(a*d-b*c)",
                      "free_word_identities": words, "maximum_free_weight": 4,
                      "rank_family": family, "real_fast_family": "symbolically verified",
                      "lean": lean, "full_reduction_formalized": False,
                      "independent_review": "required"}, indent=2))


if __name__ == "__main__":
    main()
