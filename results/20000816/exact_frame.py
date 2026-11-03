#!/home/argustest/zimo/argus-latest/.venv/bin/python
"""Exact, data-only input normalization and finite fake-plane frame certificate."""

from __future__ import annotations

import argparse
from collections import Counter
from fractions import Fraction
import json
import os
from pathlib import Path
import re
import subprocess
import sys
import time
from datetime import datetime, timezone


HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[3]
SOURCE = ROOT / "research/sources/c6_followup/explicit_input/Magma84FinalFPPexact"
ZERO = (0,) * 10
TOKEN = re.compile(r"\s*(?:(\d+)|([A-Za-z_][A-Za-z_0-9]*)|([+\-*/^(),\[\]]))")
ONE = (1, 0)


def dump(path, obj):
    Path(path).write_text(json.dumps(obj, indent=2) + "\n")


def status(phase, action, state="in_progress", artifact=None, **extra):
    now = datetime.now(timezone.utc).isoformat()
    entry = {
        "ts": now,
        "role": "engineer",
        "agent": "exact-frame-certificate",
        "kind": phase,
        "action": action,
        "status": state,
        "artifact": str(Path(artifact).relative_to(ROOT)) if artifact else str(HERE.relative_to(ROOT)),
    }
    print(json.dumps({**entry, **extra}), file=sys.stderr, flush=True)


def require(condition, message):
    if not condition:
        raise ValueError(message)


def qmul(a, b):
    if a == ONE:
        return b
    if b == ONE:
        return a
    return (a[0] * b[0] - 7 * a[1] * b[1], a[0] * b[1] + a[1] * b[0])


def qinverse(a):
    denominator = a[0] ** 2 + 7 * a[1] ** 2
    require(denominator != 0, "Division by zero")
    return Fraction(a[0], denominator), Fraction(-a[1], denominator)


def scaled_accumulate(target, source, scalar):
    if scalar == (0, 0):
        return
    for row, coefficient in source.items():
        value = qmul(scalar, coefficient)
        old = target.get(row, (0, 0))
        value = (old[0] + value[0], old[1] + value[1])
        if value == (0, 0):
            target.pop(row, None)
        else:
            target[row] = value


def add(a, b, sign=1):
    result = a.copy()
    for monomial, coefficient in b.items():
        old = result.get(monomial, (0, 0))
        new = (old[0] + sign * coefficient[0], old[1] + sign * coefficient[1])
        if new == (0, 0):
            result.pop(monomial, None)
        else:
            result[monomial] = new
    return result


def mul(a, b):
    result = {}
    for x, (a0, a1) in a.items():
        for y, (b0, b1) in b.items():
            monomial = tuple(u + v for u, v in zip(x, y))
            if sum(monomial) > 6:
                raise ValueError("Input exceeds the permitted polynomial degree")
            result = add(result, {monomial: (a0 * b0 - 7 * a1 * b1, a0 * b1 + a1 * b0)})
    return result


class DataParser:
    """Recursive-descent whitelist: integers, rr, U0..U9, + - * ^ and parentheses."""

    def __init__(self, text, rational_output=False):
        self.tokens = []
        self.rational_output = rational_output
        cursor = 0
        while cursor < len(text):
            if not text[cursor:].strip():
                break
            match = TOKEN.match(text, cursor)
            if not match:
                raise ValueError(f"Forbidden input at offset {cursor}: {text[cursor:cursor+30]!r}")
            token = next(group for group in match.groups() if group is not None)
            if token == "/" and not rational_output:
                raise ValueError("Division is forbidden in the original integer-pair input")
            if token[0].isalpha() and token not in {"rr", *(f"U{i}" for i in range(10))}:
                raise ValueError(f"Forbidden variable {token}")
            self.tokens.append(token)
            cursor = match.end()
        self.position = 0

    def peek(self):
        return self.tokens[self.position] if self.position < len(self.tokens) else None

    def take(self, expected=None):
        token = self.peek()
        if token is None or (expected is not None and token != expected):
            raise ValueError(f"Expected {expected!r}, found {token!r}")
        self.position += 1
        return token

    def expression(self):
        result = self.product()
        while self.peek() in ("+", "-"):
            sign = 1 if self.take() == "+" else -1
            result = add(result, self.product(), sign)
        return result

    def product(self):
        result = self.unary()
        while self.peek() in ("*", "/"):
            operation = self.take()
            other = self.unary()
            if operation == "/":
                require(set(other) <= {ZERO}, "Only field constants may be denominators")
                other = {ZERO: qinverse(other.get(ZERO, (0, 0)))}
            result = mul(result, other)
        return result

    def unary(self):
        if self.peek() in ("+", "-"):
            sign = 1 if self.take() == "+" else -1
            return {m: (sign * c[0], sign * c[1]) for m, c in self.unary().items()}
        return self.power()

    def power(self):
        result = self.atom()
        if self.peek() == "^":
            self.take("^")
            exponent = self.take()
            if not exponent.isdecimal() or not 0 <= int(exponent) <= 6:
                raise ValueError("Power must be an integer from zero to six")
            base = result
            result = {ZERO: (1, 0)}
            for _ in range(int(exponent)):
                result = mul(result, base)
        return result

    def atom(self):
        token = self.take()
        if token.isdecimal():
            return {ZERO: (int(token), 0)}
        if token == "rr":
            return {ZERO: (0, 1)}
        if re.fullmatch(r"U[0-9]", token):
            monomial = [0] * 10
            monomial[int(token[1])] = 1
            return {tuple(monomial): (1, 0)}
        if token == "(":
            result = self.expression()
            self.take(")")
            return result
        raise ValueError(f"Forbidden atom {token!r}")

    def relations(self):
        self.take("[")
        result = [self.expression()]
        while self.peek() == ",":
            self.take(",")
            result.append(self.expression())
        self.take("]")
        if self.peek() is not None:
            raise ValueError("Unexpected tokens after list")
        if len(result) != 84:
            raise ValueError(f"Expected 84 relations, found {len(result)}")
        for polynomial in result:
            if not polynomial or {sum(monomial) for monomial in polynomial} != {3}:
                raise ValueError("Every relation must be a nonzero homogeneous cubic")
        return result

    def polynomial(self):
        result = self.expression()
        require(self.peek() is None, "Unexpected trailing tokens in polynomial data")
        return {m: c for m, c in result.items() if c != (0, 0)}


def monomial_text(exponents):
    factors = [f"U{i}" + (f"^{e}" if e != 1 else "") for i, e in enumerate(exponents) if e]
    return "*".join(factors) or "1"


def polynomial_text(poly):
    terms = []
    for exponents, (a, b) in sorted(poly.items(), reverse=True):
        terms.append(f"({a}+({b})*rr)*{monomial_text(exponents)}")
    return "+".join(terms) or "0"


def normalize():
    data = SOURCE.read_bytes()
    text = data.decode("ascii")
    matches = list(re.finditer(r"\bRels\s*:=\s*\[", text))
    if len(matches) != 1:
        raise ValueError("Input must contain exactly one Rels assignment")
    start = matches[0].end() - 1
    end = text.find("]", start)
    if end < 0 or not re.match(r"\s*;", text[end + 1:]):
        raise ValueError("Missing list terminator")
    relations = DataParser(text[start:end + 1]).relations()
    normalized = {
        "source": str(SOURCE.relative_to(ROOT)),
        "field": {"base": "QQ", "generator": "rr", "minimal_polynomial": "rr^2+7"},
        "variables": [f"U{i}" for i in range(10)],
        "coefficient_encoding": "[integer rational part, integer rr part]",
        "count": len(relations),
        "homogeneous_degree": 3,
        "relations": [
            [{"exponents": list(m), "coefficient": list(c)} for m, c in sorted(p.items(), reverse=True)]
            for p in relations
        ],
        "source_execution": False,
        "ancillary_commands": "Not parsed or executed",
    }
    dump(HERE / "normalized_input.json", normalized)
    (HERE / "input.sing").write_text(
        "ring r=(0,rr),(U0,U1,U2,U3,U4,U5,U6,U7,U8,U9),dp;\n"
        "minpoly=rr^2+7;\n"
        "ideal I=\n" + ",\n".join(polynomial_text(p) for p in relations) + ";\n"
    )
    return normalized


def execute_singular(script, prefix, timeout):
    started = time.monotonic()
    env = {**os.environ, "TMPDIR": str(HERE)}
    with (HERE / f"{prefix}.stdout").open("w") as out, (HERE / f"{prefix}.stderr").open("w") as err:
        try:
            result = subprocess.run(
                ["/usr/bin/Singular", "-q", str(script)], cwd=HERE, env=env,
                stdout=out, stderr=err, timeout=timeout, check=False,
            )
            state, code = "finished", result.returncode
        except subprocess.TimeoutExpired:
            state, code = "timeout", None
    metadata = {
        "state": state, "exit_status": code, "seconds": time.monotonic() - started,
        "command": ["/usr/bin/Singular", "-q", str(script)],
        "arithmetic": "exact QQ(rr), rr^2=-7",
        "Singular_version": subprocess.check_output(["/usr/bin/Singular", "--version"], text=True, timeout=10).splitlines()[0],
    }
    dump(HERE / f"{prefix}.execution.json", metadata)
    return metadata


def parser_tests():
    require(DataParser("(1-rr)*(1+rr)").polynomial() == {ZERO: (8, 0)}, "Quadratic field test")
    require(DataParser("rr^2+7").polynomial() == {}, "Minimal polynomial test")
    require(
        DataParser("(1+rr)/2", rational_output=True).polynomial()
        == {ZERO: (Fraction(1, 2), Fraction(1, 2))}, "Rational output parser test",
    )
    forbidden = ("U10", "system(1)", "__import__(1)", "U0;quit", "U0/2", "U0^99", "U0**2", "1.5*U0")
    for text in forbidden:
        try:
            DataParser(text).polynomial()
        except ValueError:
            continue
        raise ValueError(f"Unsafe parser input accepted: {text}")
    for text in ("[U0^3]", "[" + ",".join(["U0^2"] * 84) + "]"):
        try:
            DataParser(text).relations()
        except ValueError:
            continue
        raise ValueError("Invalid relation list accepted")
    return {"field_identity_tests": 3, "forbidden_expression_tests": len(forbidden), "invalid_list_tests": 2}


def decode_polynomial(text):
    return DataParser(text, rational_output=True).polynomial()


def dp_key(monomial):
    return sum(monomial), tuple(-e for e in reversed(monomial))


def compositions(total, count):
    if count == 1:
        yield (total,)
    else:
        for head in range(total + 1):
            for tail in compositions(total - head, count - 1):
                yield (head,) + tail


def bump(monomial, variable, amount=1):
    result = list(monomial)
    result[variable] += amount
    return tuple(result)


def read_algebra():
    groebner, lifts, old_basis, raw_columns, checks, hilbert = {}, {}, {}, {}, {}, {}
    complete = False
    for line in (HERE / "algebra.tsv").read_text().splitlines():
        fields = line.split("|")
        tag = fields[0]
        if tag == "G":
            groebner[int(fields[1]) - 1] = decode_polynomial(fields[2])
        elif tag == "W":
            coefficient = decode_polynomial(fields[3])
            require(set(coefficient) == {ZERO}, "Nonconstant generator-lift coefficient")
            lifts[int(fields[1]) - 1, int(fields[2]) - 1] = coefficient[ZERO]
        elif tag == "B":
            old_basis[int(fields[1]) - 1] = tuple(map(int, fields[2].split(",")))
        elif tag == "N":
            raw_columns[int(fields[2]) - 1, int(fields[1]) - 1] = decode_polynomial(fields[3])
        elif tag == "CHECK":
            checks[fields[1]] = int(fields[2])
        elif tag.startswith("HILBERT_"):
            hilbert[tag] = list(map(int, fields[1].split(",")))
        elif tag == "COMPLETE":
            require(fields == ["COMPLETE", "1"], "Malformed completion marker")
            complete = True
        else:
            raise ValueError(f"Unexpected algebra data tag {tag!r}")
    require(complete, "Singular did not complete its explicit checks")
    require(set(groebner) == set(range(84)), "Incomplete Groebner export")
    require(set(old_basis) == set(range(455)), "Incomplete finite basis export")
    require(len(raw_columns) == 4550, "Incomplete finite multiplication export")
    basis = sorted(old_basis.values(), key=dp_key)
    index = {m: i for i, m in enumerate(basis)}
    require(len(index) == len(basis), "Duplicate finite basis element")
    matrices = [{} for _ in range(10)]
    for (variable, old_column), polynomial in raw_columns.items():
        column = index[old_basis[old_column]]
        require(all(m in index for m in polynomial), "Nonstandard exported multiplication term")
        matrices[variable][column] = {index[m]: c for m, c in polynomial.items()}
    return [groebner[i] for i in range(84)], lifts, basis, matrices, checks, hilbert


def verify_algebra(normalized, groebner, lifts, basis, matrices, checks, hilbert):
    input_polys = [
        {tuple(term["exponents"]): tuple(term["coefficient"]) for term in polynomial}
        for polynomial in normalized["relations"]
    ]
    reconstructed = [{} for _ in groebner]
    for (i, j), coefficient in lifts.items():
        scaled_accumulate(reconstructed[j], input_polys[i], coefficient)
    require(reconstructed == groebner, "Exact generator-lift identity fails")
    rules = {}
    for polynomial in groebner:
        leader = max(polynomial, key=dp_key)
        require(polynomial[leader] == ONE, "Nonmonic Groebner generator")
        require({sum(m) for m in polynomial} == {3}, "Inhomogeneous Groebner generator")
        require(leader not in rules, "Repeated leading monomial")
        rules[leader] = {m: (-c[0], -c[1]) for m, c in polynomial.items() if m != leader}
    expected_leaders = {m + (0, 0, 0) for m in compositions(3, 7)}
    require(set(rules) == expected_leaders, "Unexpected full leading ideal")
    require(all(sum(m[:7]) <= 2 for p in rules.values() for m in p), "Nonstandard cubic tail")
    for polynomial in input_polys:
        residual = {}
        for m, c in polynomial.items():
            scaled_accumulate(residual, rules.get(m, {m: ONE}), c)
        require(not residual, "Exact original cubic reduction fails")
    expected_basis = {
        m for d in range(5) for m in compositions(d, 10) if sum(m[:7]) <= 2
    }
    require(set(basis) == expected_basis, "Finite basis does not match the leading ideal")
    index = {m: i for i, m in enumerate(basis)}
    for variable, columns in enumerate(matrices):
        for column, m in enumerate(basis):
            target = bump(m, variable)
            if sum(target) >= 5:
                expected = {}
            elif sum(target[:7]) <= 2:
                expected = {index[target]: ONE}
            else:
                inner = target[:7] + (0, 0, 0)
                outer = (0,) * 7 + target[7:]
                expected = {
                    index[tuple(a + b for a, b in zip(t, outer))]: c for t, c in rules[inner].items()
                }
            require(columns[column] == expected, "Finite multiplication does not match exact cubic reduction")
    require(checks["input_membership"] == checks["lift_membership"] == 1, "CAS ideal equality failure")
    require(checks["spairs_reduced"] + checks["spairs_product_criterion"] == 3486, "Missing Buchberger pairs")
    require(checks["dimension"] == 3, "Unexpected full quotient dimension")
    require(checks["finite_length"] == len(basis), "Finite length mismatch")
    require(hilbert["HILBERT_SECOND"] == [1, 7, 28, 0], "Unexpected reduced Hilbert numerator")
    numerator = [1, 7, 28]
    for _ in range(7):
        expanded = [0] * (len(numerator) + 1)
        for i, c in enumerate(numerator):
            expanded[i] += c
            expanded[i + 1] -= c
        numerator = expanded
    require(hilbert["HILBERT_FIRST"] == numerator + [0], "Hilbert numerator consistency failure")
    return rules


def apply_matrix(columns, vector):
    result = {}
    for column, coefficient in vector.items():
        scaled_accumulate(result, columns.get(column, {}), coefficient)
    return result


def check_commutators(matrices, basis, phase):
    counts = Counter()
    for left in range(len(matrices)):
        for right in range(left + 1, len(matrices)):
            for column in range(len(basis)):
                a = matrices[left].get(column, {})
                b = matrices[right].get(column, {})
                if not a and not b:
                    counts["both_first_products_zero"] += 1
                    continue
                ab = apply_matrix(matrices[left], b)
                ba = apply_matrix(matrices[right], a)
                require(ab == ba, f"{phase}: noncommuting matrices {left},{right}, column {column}")
                counts["sparse_compositions_compared"] += 1
            if right == len(matrices) - 1:
                status(phase, f"Exact commutator checks completed through variable index {left}.",
                       artifact=HERE / "algebra.tsv")
    counts["total_generator_pairs_times_basis_columns"] = sum(counts.values())
    return dict(counts)


def check_input_actions(normalized, matrices, basis):
    index = {m: i for i, m in enumerate(basis)}
    checked = 0
    for source, m in enumerate(basis):
        if sum(m) > 1:
            continue
        for relation in normalized["relations"]:
            residual = {}
            for term in relation:
                vector = {source: ONE}
                for variable, exponent in enumerate(term["exponents"]):
                    for _ in range(exponent):
                        vector = apply_matrix(matrices[variable], vector)
                scaled_accumulate(residual, vector, tuple(term["coefficient"]))
            require(not residual, "An input cubic does not annihilate B")
            checked += 1
    require(basis[index[ZERO]] == ZERO, "Missing constant")
    return {"nontrivial_cubic_source_checks": checked, "higher_sources": "Zero by verified degree-5 truncation"}


def build_frame(basis, b_matrices):
    b_index = {m: i for i, m in enumerate(basis)}
    labels = [(m, -1) for m in basis]
    labels.extend((m, y) for y in range(10) for m in basis if y != 9 or m[9] == 0)
    labels.sort(key=lambda item: (sum(item[0]) + (item[1] >= 0), item[1], dp_key(item[0])))
    index = {label: i for i, label in enumerate(labels)}
    require(len(index) == len(labels), "Repeated frame basis element")
    module_cache = {}

    def project(b_vector, y):
        result = {}
        for row, coefficient in b_vector.items():
            cache_key = row, y
            if cache_key not in module_cache:
                m = basis[row]
                if y != 9 or m[9] == 0:
                    projected = {index[m, y]: ONE}
                else:
                    predecessor = b_index[bump(m, 9, -1)]
                    projected = {}
                    for variable in range(9):
                        for target, c in b_matrices[variable][predecessor].items():
                            projected[index[basis[target], variable]] = (-c[0], -c[1])
                module_cache[cache_key] = projected
            scaled_accumulate(result, module_cache[cache_key], coefficient)
        return result

    matrices = [{} for _ in range(20)]
    for column, (m, y) in enumerate(labels):
        source = b_index[m]
        for variable in range(10):
            product = b_matrices[variable][source]
            target = {index[basis[row], -1]: c for row, c in product.items()} if y == -1 else project(product, y)
            if target:
                matrices[variable][column] = target
        if y == -1:
            for variable in range(10):
                target = project({source: ONE}, variable)
                if target:
                    matrices[10 + variable][column] = target
    full_basis = [m + tuple(int(y == i) for i in range(10)) for m, y in labels]
    return labels, full_basis, matrices


def verify_frame(b_basis, b_matrices, labels, basis, matrices):
    index = {m: i for i, m in enumerate(basis)}
    require(len(basis) == 4803, "Unexpected frame length")
    divisor_checks = 0
    for column, m in enumerate(basis):
        for variable, exponent in enumerate(m):
            if exponent:
                require(bump(m, variable, -1) in index, "Frame basis is not divisor-closed")
                divisor_checks += 1
            target = bump(m, variable)
            actual = matrices[variable].get(column, {})
            if target in index:
                require(actual == {index[target]: ONE}, "Frame multiplication fails inside its monomial basis")
            for row, coefficient in actual.items():
                require(coefficient != (0, 0), "Explicit zero in sparse matrix")
                require(sum(basis[row][:10]) == sum(m[:10]) + (variable < 10), "Incorrect x degree")
                require(sum(basis[row][10:]) == sum(m[10:]) + (variable >= 10), "Incorrect y degree")
    b_index = {m: i for i, m in enumerate(b_basis)}
    ranks = []
    for degree in range(4):
        sources = [i for i, m in enumerate(b_basis) if sum(m) == degree]
        pivots = [b_index[bump(b_basis[i], 9)] for i in sources]
        require(len(set(pivots)) == len(sources), "Repeated U9 rank pivot")
        for source, pivot in zip(sources, pivots):
            require(b_matrices[9][source] == {pivot: ONE}, "U9 injection minor is not the identity")
        ranks.append({
            "source_degree": degree, "rank": len(sources), "minor_determinant": "1",
            "source_columns": sources, "U9_block_rows": pivots,
        })
    for source, m in enumerate(b_basis):
        if sum(m) == 4:
            require(all(not mat[source] for mat in b_matrices), "Nonzero degree-4 socle multiplication")
    q_checks = 0
    for column in range(len(basis)):
        residual = {}
        for variable in range(10):
            scaled_accumulate(residual, apply_matrix(matrices[variable], matrices[10 + variable].get(column, {})), ONE)
        require(not residual, "Frame Q relation does not annihilate a basis element")
        q_checks += 1
    h_b = [sum(sum(m) == d for m in b_basis) for d in range(5)]
    h_m = [sum(y >= 0 and sum(m) == d for m, y in labels) for d in range(5)]
    h_j = [sum(sum(m) == d for m in basis) for d in range(6)]
    require(h_b == [1, 10, 55, 136, 253], "Unexpected B Hilbert function")
    require(h_m == [10 * h_b[d] - (h_b[d - 1] if d else 0) for d in range(5)], "Module rank formula fails")
    require(h_j == [1, 20, 154, 676, 1558, 2394], "Unexpected frame Hilbert function")
    return {
        "B_hilbert_function": h_b, "B_length": sum(h_b),
        "multiplication_injection_minors": ranks,
        "B_socle_hilbert_function": [0, 0, 0, 0, h_b[4]],
        "B_socle_dimension": h_b[4],
        "M_x_degree_hilbert_function": h_m, "M_length": sum(h_m),
        "J_total_degree_hilbert_function": h_j, "J_quotient_length": sum(h_j),
        "frame_basis_divisor_checks": divisor_checks,
        "frame_Q_all_basis_column_checks": q_checks,
        "frame_truncations": "Every matrix entry has the verified bidegree; x-degree >=5 and y-degree >=2 are absent.",
    }


def write_sparse(path, matrices, variables, basis_file, size):
    count = Counter()
    with path.open("w") as stream:
        stream.write(json.dumps({
            "format": "sparse-column-jsonl-v1", "basis": basis_file, "variables": variables,
            "matrix_shape": [size, size], "indices": "zero-based",
            "omitted_columns": "zero",
            "coefficient_encoding": "[row, rational_part_string, rr_part_string], rr^2=-7",
        }) + "\n")
        for variable, columns in enumerate(matrices):
            for column, vector in sorted(columns.items()):
                if vector:
                    entries = [[row, str(c[0]), str(c[1])] for row, c in sorted(vector.items())]
                    stream.write(json.dumps({"variable": variable, "column": column, "entries": entries}, separators=(",", ":")) + "\n")
                    count["nonzero_columns"] += 1
                    count["nonzero_entries"] += len(entries)
    return dict(count)


def write_border(basis, matrices):
    basis_set = set(basis)
    border = {}
    for column, m in enumerate(basis):
        for variable, matrix in enumerate(matrices):
            target = bump(m, variable)
            if target in basis_set:
                continue
            nf = matrix.get(column, {})
            if target in border:
                require(border[target] == nf, "Two border reductions disagree")
            else:
                border[target] = nf
    with (HERE / "frame_border.jsonl").open("w") as stream:
        stream.write(json.dumps({
            "format": "border-normal-forms-jsonl-v1", "basis": "frame_basis.json",
            "meaning": "For every border monomial m, the ideal contains m minus the listed normal form.",
            "indices": "zero-based", "coefficient_encoding": "[row, rational_part_string, rr_part_string], rr^2=-7",
        }) + "\n")
        for monomial, vector in sorted(border.items()):
            stream.write(json.dumps({
                "monomial": monomial,
                "normal_form": [[row, str(c[0]), str(c[1])] for row, c in sorted(vector.items())],
            }, separators=(",", ":")) + "\n")
    return {"distinct_border_monomials": len(border), "nonzero_normal_forms": sum(bool(v) for v in border.values())}


def run():
    started = time.monotonic()
    try:
        tests = parser_tests()
        normalized = normalize()
        status("exact_algebra", "Recomputing the exact Groebner, generator-lift, S-pair, and finite multiplication data.")
        execution = execute_singular(HERE / "check_algebra.sing", "algebra", 900)
        require(execution["state"] == "finished" and execution["exit_status"] == 0, "Singular execution failed")
        logs = (HERE / "algebra.stdout").read_text() + (HERE / "algebra.stderr").read_text()
        require("EXACT_ALGEBRA_CHECKS_COMPLETE" in logs and "CERTIFICATE_FAILURE" not in logs, "Incomplete Singular run")
        require(not re.search(r"^\s*\?", logs, re.MULTILINE), "Singular reported an interpreter error")
        groebner, lifts, b_basis, b_matrices, checks, hilbert = read_algebra()
        verify_algebra(normalized, groebner, lifts, b_basis, b_matrices, checks, hilbert)
        status("finite_algebra_verified", "Independently checked exact cubic-lift identities and all 4550 finite multiplication columns.",
               artifact=HERE / "algebra.tsv")
        b_commutators = check_commutators(b_matrices, b_basis, "B_commutators")
        input_actions = check_input_actions(normalized, b_matrices, b_basis)
        labels, frame_basis, frame_matrices = build_frame(b_basis, b_matrices)
        result = verify_frame(b_basis, b_matrices, labels, frame_basis, frame_matrices)
        status("frame_basis_verified", "Computed the divisor-closed 4803-monomial frame basis and exact multiplication data; checking commutativity.")
        frame_commutators = check_commutators(
            frame_matrices, frame_basis, "frame_commutators",
        )
        dump(HERE / "B_basis.json", {"variables": normalized["variables"], "monomials": b_basis})
        dump(HERE / "frame_basis.json", {
            "variables": normalized["variables"] + [f"Y{i}" for i in range(10)],
            "description": "B, together with B*Yi for i<9 and the U9-free standard monomials times Y9",
            "monomials": frame_basis,
        })
        b_sparse = write_sparse(HERE / "B_multiplication.jsonl", b_matrices, normalized["variables"], "B_basis.json", len(b_basis))
        frame_sparse = write_sparse(
            HERE / "frame_multiplication.jsonl", frame_matrices,
            normalized["variables"] + [f"Y{i}" for i in range(10)], "frame_basis.json", len(frame_basis),
        )
        border = write_border(frame_basis, frame_matrices)
        dump(HERE / "groebner_basis.json", {
            "order": "degree reverse lexicographic, U0 > ... > U9",
            "leading_ideal": "(U0,...,U6)^3", "field": normalized["field"],
            "polynomials": [
                [{"exponents": m, "coefficient": [str(c[0]), str(c[1])]} for m, c in sorted(p.items(), key=lambda t: dp_key(t[0]), reverse=True)]
                for p in groebner
            ],
        })
        result.update({
            "status": "exact_finite_certificate_passed",
            "field": normalized["field"],
            "parser_tests": tests, "arithmetic": "Exact integers and fractions only; no floating-point or finite-field substitution",
            "full_ideal": {
                "Groebner_basis_size": len(groebner), "leading_ideal": "(U0,...,U6)^3",
                "Krull_dimension": checks["dimension"], "Hilbert_series": "(1+7*t+28*t^2)/(1-t)^3",
                "quotient_degree_ranks_0_through_4": result["B_hilbert_function"],
                "Singular_checks": checks, "Hilbert_vectors": hilbert,
                "independent_python_lift_and_reduction_checks": True,
            },
            "B_commutators": b_commutators, "B_input_cubic_actions": input_actions,
            "frame_commutators": frame_commutators,
            "B_sparse_data": b_sparse, "frame_sparse_data": frame_sparse, "frame_border_data": border,
            "frame_definition": "J=I*K[U0..U9,Y0..Y9]+(U0,..,U9)^5+(Y0,..,Y9)^2+(sum_i U_i*Y_i)",
            "module_pivot_explanation": "The U9 component of b -> (U_i*b)_i has an identity minor in degrees 0..3. Eliminate U9*b*Y9 using -sum_{i<9} U_i*b*Yi.",
            "computed_scope": "Exact quotient, full Groebner/Hilbert data, socle/injection ranks, and a concrete border-basis chart point only",
            "not_computed_or_assumed": [
                "No arithmetic computation proves the source surface is smooth or a fake projective plane.",
                "No surface conjugacy, generic component-prime separation, or common ambient-open map is certified here.",
                "No generic counterexample conclusion or independent reviewer acceptance is asserted.",
            ],
            "external_geometry_used_in_arithmetic": False,
            "exact_backend": execution,
            "Jacobian_not_used": "Its inspected Groebner contract supports QQ and at most eight variables, not this ten-variable quadratic-field input.",
            "replay_command": f"/home/argustest/zimo/argus-latest/.venv/bin/python -B {HERE.relative_to(ROOT)}/exact_frame.py run",
            "execution_seconds": time.monotonic() - started,
        })
        dump(HERE / "results.json", result)
        status("exact_frame_complete", "Exact frame certificate passed: B length 455, socle dimension 253, frame length 4803, and all 20 multiplication matrices commute.",
               state="completed", artifact=HERE / "results.json", result=result["status"], elapsed_seconds=result["execution_seconds"])
        print(json.dumps({
            "status": result["status"], "B": result["B_hilbert_function"], "M": result["M_x_degree_hilbert_function"],
            "J": result["J_total_degree_hilbert_function"], "length": result["J_quotient_length"],
            "artifact": str((HERE / "results.json").relative_to(ROOT)), "seconds": result["execution_seconds"],
        }))
    except (ValueError, OSError, subprocess.SubprocessError) as exc:
        dump(HERE / "failure.json", {"error_type": type(exc).__name__, "message": str(exc), "elapsed_seconds": time.monotonic() - started})
        status("exact_frame_failed", f"Exact certificate execution failed: {type(exc).__name__}: {exc}",
               state="failed", artifact=HERE / "failure.json")
        raise


def initial():
    normalized = normalize()
    status("input_normalized", "Safely parsed and checked 84 homogeneous cubics over QQ(sqrt(-7)); ancillary Magma commands excluded.",
           artifact=HERE / "normalized_input.json")
    script = HERE / "full_groebner.sing"
    script.write_text(
        '< "input.sing";\n'
        'option(redSB);\n'
        'timer=1;\n'
        'ideal G=std(I);\n'
        'link exportBasis="ASCII:w full_groebner_basis.txt";\n'
        'open(exportBasis); write(exportBasis,string(G)); close(exportBasis);\n'
        'print("FULL_GROEBNER_FINISHED");\n'
        'print("GB_SIZE"); size(G);\n'
        'print("GB_DEGREES"); deg(G);\n'
        'print("HILBERT_FIRST"); hilb(G,1);\n'
        'print("HILBERT_SECOND"); hilb(G,2);\n'
        'print("DIMENSION"); dim(G);\n'
        'ideal inputNF=reduce(I,G);\n'
        'int i; int inputZero=1;\n'
        'for (i=1;i<=ncols(inputNF);i++) { if (inputNF[i]!=0) { inputZero=0; } }\n'
        'print("INPUT_REDUCES_TO_ZERO"); inputZero;\n'
        'print("SECONDS"); timer;\n'
        'quit;\n'
    )
    execution = execute_singular(script, "full_groebner", 100)
    status("full_groebner_probe", "Finished the bounded exact full Groebner-basis probe.",
           state="in_progress", artifact=HERE / "full_groebner.execution.json", execution=execution)
    print(json.dumps({"input_count": normalized["count"], "full_groebner": execution}))


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("command", choices=["initial", "normalize", "run"])
    args = parser.parse_args()
    if args.command == "initial":
        initial()
    elif args.command == "run":
        run()
    else:
        normalize()


if __name__ == "__main__":
    main()
