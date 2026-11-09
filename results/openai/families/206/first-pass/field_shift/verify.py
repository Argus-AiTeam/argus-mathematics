#!/usr/bin/env python3
"""Replay exact constructions; universal claims are proved in report.md and Lean."""

import argparse
import hashlib
import json
from pathlib import Path


HERE = Path(__file__).resolve().parent
ROOT = HERE.parent.parent
Matrix = list[dict[int, int]]


class BinaryField:
    def __init__(self, degree: int, polynomial: int):
        self.degree = degree
        self.polynomial = polynomial
        self.size = 1 << degree
        assert polynomial.bit_length() == degree + 1
        for divisor_degree in range(1, degree // 2 + 1):
            for divisor in range(1 << divisor_degree, 1 << (divisor_degree + 1)):
                remainder = polynomial
                while remainder.bit_length() >= divisor.bit_length():
                    remainder ^= divisor << (remainder.bit_length() - divisor.bit_length())
                assert remainder != 0, (polynomial, divisor)

    def mul(self, a: int, b: int) -> int:
        result = 0
        while b:
            if b & 1:
                result ^= a
            a <<= 1
            if a & self.size:
                a ^= self.polynomial
            b >>= 1
        return result

    def power(self, a: int, exponent: int) -> int:
        assert exponent >= 0
        result = 1
        while exponent:
            if exponent & 1:
                result = self.mul(result, a)
            a = self.mul(a, a)
            exponent >>= 1
        return result

    def inverse(self, a: int) -> int:
        assert a != 0
        result = self.power(a, self.size - 2)
        assert self.mul(a, result) == 1
        return result


def identity(n: int) -> Matrix:
    return [{i: 1} for i in range(n)]


def transpose(a: Matrix) -> Matrix:
    result: Matrix = [{} for _ in a]
    for i, row in enumerate(a):
        for j, value in row.items():
            result[j][i] = value
    return result


def multiply(a: Matrix, b: Matrix, field: BinaryField) -> Matrix:
    assert len(a) == len(b)
    result: Matrix = []
    for row in a:
        output: dict[int, int] = {}
        for k, x in row.items():
            for j, y in b[k].items():
                value = output.get(j, 0) ^ field.mul(x, y)
                if value:
                    output[j] = value
                else:
                    output.pop(j, None)
        result.append(output)
    return result


def frobenius(a: Matrix, exponent: int, field: BinaryField) -> Matrix:
    return [{j: field.power(x, 1 << exponent) for j, x in row.items()} for row in a]


def tensor(a: Matrix, b: Matrix, field: BinaryField) -> Matrix:
    n = len(b)
    return [
        {j * n + l: field.mul(x, y) for j, x in row_a.items() for l, y in row_b.items()}
        for row_a in a
        for row_b in b
    ]


def inverse(a: Matrix, field: BinaryField) -> Matrix:
    n = len(a)
    rows = [dict(row) | {n + i: 1} for i, row in enumerate(a)]
    for column in range(n):
        pivot = next((i for i in range(column, n) if rows[i].get(column, 0)), None)
        assert pivot is not None, "Singular matrix in an invertibility obligation"
        rows[column], rows[pivot] = rows[pivot], rows[column]
        scale = field.inverse(rows[column][column])
        rows[column] = {j: field.mul(x, scale) for j, x in rows[column].items()}
        for i in range(n):
            if i == column:
                continue
            coefficient = rows[i].get(column, 0)
            if coefficient:
                for j, x in rows[column].items():
                    value = rows[i].get(j, 0) ^ field.mul(coefficient, x)
                    if value:
                        rows[i][j] = value
                    else:
                        rows[i].pop(j, None)
    assert [{j: x for j, x in row.items() if j < n} for row in rows] == identity(n)
    return [{j - n: x for j, x in row.items() if j >= n} for row in rows]


def determinant(a: Matrix, field: BinaryField) -> int:
    rows = [dict(row) for row in a]
    result = 1
    for column in range(len(a)):
        pivot = next((i for i in range(column, len(a)) if rows[i].get(column, 0)), None)
        if pivot is None:
            return 0
        rows[column], rows[pivot] = rows[pivot], rows[column]
        value = rows[column][column]
        result = field.mul(result, value)
        scale = field.inverse(value)
        for i in range(column + 1, len(a)):
            coefficient = field.mul(rows[i].get(column, 0), scale)
            if coefficient:
                for j, x in rows[column].items():
                    value = rows[i].get(j, 0) ^ field.mul(coefficient, x)
                    if value:
                        rows[i][j] = value
                    else:
                        rows[i].pop(j, None)
    return result


def tensor_rotation(m: int, b: int) -> list[int]:
    result = []
    for column in range(m**b):
        indices = []
        number = column
        for _ in range(b):
            number, index = divmod(number, m)
            indices.append(index)
        indices.reverse()
        rotated = indices[-1:] + indices[:-1]
        image = 0
        for index in rotated:
            image = image * m + index
        result.append(image)
    assert sorted(result) == list(range(m**b))
    return result


def permutation_matrix(permutation: list[int]) -> Matrix:
    result: Matrix = [{} for _ in permutation]
    for column, row in enumerate(permutation):
        result[row][column] = 1
    return result


def descent_basis(permutation: list[int], t: int, field: BinaryField) -> tuple[Matrix, Matrix]:
    n = len(permutation)
    basis: Matrix = [{} for _ in range(n)]
    basis_inverse: Matrix = [{} for _ in range(n)]
    seen = set()
    for start in range(n):
        if start in seen:
            continue
        orbit = []
        point = start
        while point not in seen:
            seen.add(point)
            orbit.append(point)
            point = permutation[point]
        assert point == start
        e = len(orbit)
        assert field.degree % (2 * t * e) == 0
        betas = [1 << j for j in range(e)]
        assert all(field.power(beta, 1 << (2 * t * e)) == beta for beta in betas)
        block = [
            {j: field.power(beta, 1 << (2 * t * i)) for j, beta in enumerate(betas)}
            for i in range(e)
        ]
        block_inverse = inverse(block, field)
        for i, row in enumerate(orbit):
            basis[row] = {orbit[j]: value for j, value in block[i].items() if value}
            basis_inverse[row] = {orbit[j]: value for j, value in block_inverse[i].items() if value}
    assert multiply(basis, basis_inverse, field) == identity(n)
    return basis, basis_inverse


def unitary_tensor_setup(m: int, b: int, t: int, field: BinaryField):
    p = tensor_rotation(m, b)
    p_squared = [p[p[i]] for i in range(len(p))]
    rotation = permutation_matrix(p)
    descent = permutation_matrix(p_squared)
    basis, basis_inverse = descent_basis(p_squared, t, field)
    assert multiply(descent, frobenius(basis, 2 * t, field), field) == basis
    form = multiply(multiply(transpose(basis), rotation, field), frobenius(basis, t, field), field)
    form_inverse = multiply(
        multiply(frobenius(basis_inverse, t, field), transpose(rotation), field),
        transpose(basis_inverse), field,
    )
    assert multiply(form, form_inverse, field) == identity(m**b)
    assert frobenius(form, 2 * t, field) == form
    assert transpose(frobenius(form, t, field)) == form
    return rotation, descent, basis, basis_inverse, form


def check_unitary_tensor(g: Matrix, b: int, t: int, field: BinaryField, setup) -> None:
    rotation, descent, basis, basis_inverse, form = setup
    assert determinant(g, field) == 1
    dual = transpose(inverse(g, field))
    raw = [{0: 1}]
    for j in range(b):
        raw = tensor(raw, frobenius(g if j % 2 == 0 else dual, j * t, field), field)
    assert multiply(descent, frobenius(raw, 2 * t, field), field) == multiply(raw, descent, field)
    assert multiply(multiply(transpose(raw), rotation, field), frobenius(raw, t, field), field) == rotation
    descended = multiply(multiply(basis_inverse, raw, field), basis, field)
    assert frobenius(descended, 2 * t, field) == descended
    assert multiply(
        multiply(transpose(descended), form, field),
        frobenius(descended, t, field), field,
    ) == form


def even_unitary_construction() -> dict:
    m, b, t = 10, 2, 2
    field = BinaryField(4, 0b10011)
    setup = unitary_tensor_setup(m, b, t, field)
    count = 0
    for i in range(m):
        for j in range(m):
            if i == j:
                continue
            for coefficient in [1, 2, 4, 8]:
                g = identity(m)
                g[i][j] = coefficient
                check_unitary_tensor(g, b, t, field, setup)
                count += 1
    return {
        "source": "SL_10(16)",
        "source_rank": 9,
        "target": "SU_100(4)",
        "scalar_field_polynomial": "x^4+x+1",
        "source_exponent": 4,
        "target_exponent": 2,
        "support": [0, 2],
        "elementary_generators_checked": count,
        "scope": "Exact matrix construction on a complete elementary generating set.",
    }


def odd_unitary_construction() -> dict:
    m, b, t = 10, 3, 1
    field = BinaryField(6, 0b1000011)
    setup = unitary_tensor_setup(m, b, t, field)
    q_source = 8
    subfield = [x for x in range(1, field.size) if field.power(x, q_source) == x]
    assert len(subfield) == 7
    z = field.power(2, 7)
    assert field.power(z, 9) == 1 and field.power(z, 3) != 1
    matrices = []
    for index, (i, j) in enumerate([(0, 1), (1, 2), (2, 9)]):
        coefficient = subfield[index + 1]
        z_i = field.power(z, index + 1)
        vector = {i: 1, j: z_i}
        g = identity(m)
        for row, x in vector.items():
            for column, y in vector.items():
                value = g[row].get(column, 0) ^ field.mul(
                    coefficient, field.mul(x, field.power(y, q_source))
                )
                if value:
                    g[row][column] = value
                else:
                    g[row].pop(column, None)
        assert multiply(transpose(g), frobenius(g, 3, field), field) == identity(m)
        assert transpose(inverse(g, field)) == frobenius(g, 3, field)
        assert g != identity(m)
        matrices.append(g)
    matrices.append(multiply(matrices[0], matrices[1], field))
    for g in matrices:
        check_unitary_tensor(g, b, t, field, setup)
    return {
        "source": "SU_10(8)",
        "source_rank": 9,
        "target": "SU_1000(2)",
        "source_scalar_field_polynomial": "x^6+x+1",
        "descended_scalar_field_degree": 2,
        "source_exponent": 3,
        "target_exponent": 1,
        "ordinary_support": [0, 1, 2],
        "unreduced_natural_twists": [0, 2, 4],
        "nontrivial_source_matrices_checked": len(matrices),
        "scope": "Exact finite-field descent, nonsingular Hermitian form, and explicit source elements; not exhaustive source-group verification.",
    }


def reject_inadmissible_unitary_pattern() -> dict:
    field = BinaryField(4, 0b10011)
    m, t = 10, 2
    g = identity(m)
    g[0][1] = 2
    rotation = permutation_matrix(tensor_rotation(m, 2))
    bad = tensor(g, frobenius(g, t, field), field)
    assert multiply(
        multiply(transpose(bad), rotation, field), frobenius(bad, t, field), field
    ) != rotation
    return {
        "incorrect_pattern": "W tensor W^[t] in the even unitary cycle, omitting the dual",
        "distinct_support": [0, 2],
        "source_rank": 9,
        "fails_actual_Hermitian_equation": True,
        "interpretation": "An abstract admissible-looking digit pattern is not an admissible unitary representation.",
    }


def bc_checks() -> dict:
    field = BinaryField(4, 0b10011)
    checks = 0
    for root_exponent in [0, 1]:
        dual_root_exponent = 1 - root_exponent
        for z in range(field.size):
            assert field.power(field.power(z, 1 << root_exponent), 1 << dual_root_exponent) == field.power(z, 2)
            for a in range(field.degree):
                assert field.power(field.power(z, 1 << a), 1 << root_exponent) == field.power(
                    field.power(z, 1 << root_exponent), 1 << a
                )
                inverse_exponent = field.degree - 1 + dual_root_exponent
                assert field.power(field.power(z, 1 << root_exponent), 1 << inverse_exponent) == z
                checks += 1
    rank = 9
    c_weight = [1] + [0] * (rank - 2) + [1]
    b_weight = c_weight[:-1] + [2 * c_weight[-1]]
    digits = [
        [value % 2 for value in b_weight],
        [value // 2 for value in b_weight],
    ]
    assert [i for i, digit in enumerate(digits) if any(digit)] == [0, 1]
    assert b_weight == [digits[0][i] + 2 * digits[1][i] for i in range(rank)]
    return {
        "root_parameter_commutation_checks": checks,
        "rank": rank,
        "C_highest_weight": c_weight,
        "pulled_back_B_highest_weight": b_weight,
        "C_support": [0],
        "B_support": [0, 1],
        "interpretation": "Refutes only the retired auxiliary identical-digit route, NOT a manuscript assertion.",
    }


def replay_jacobian() -> dict:
    payload = json.loads((HERE / "jacobian_payload.json").read_text())
    response = json.loads((HERE / "jacobian_output.json").read_text())
    status = json.loads((HERE / "jacobian_status.json").read_text())
    assert status["adapter_exit_code"] == 0
    assert response["request"]["payload"] == payload
    assert response["server"]["version"] == "0.14.0"
    assert response["protocol_version"] == "2025-11-25"
    assert response["result"]["operation_id"] == "group_action.subset.canonicalize"
    result = response["result"]["output"]
    subset = tuple(payload["subset"]["positions"])
    n = len(payload["subset"]["action"]["domain"])
    assert payload["subset"]["action"]["generators"] == [list(range(1, n)) + [0]]
    images = [tuple(sorted((x + k) % n for x in subset)) for k in range(n)]
    assert result["canonical_subset"]["positions"] == list(min(images))
    assert result["orbit_size"] == len(set(images)) == 5
    assert result["stabilizer_size"] == sum(image == subset for image in images) == 3
    transporters = [list(range(k, n)) + list(range(k)) for k in range(n) if images[k] == min(images)]
    assert result["transporter"] == min(transporters)
    return {
        "operation_id": response["result"]["operation_id"],
        "server_version": response["server"]["version"],
        "protocol_version": response["protocol_version"],
        "adapter_exit_code": status["adapter_exit_code"],
        "error": None,
        "timeout": False,
        "orbit_size": 5,
        "stabilizer_size": 3,
        "scope": "One bounded exact support-set orbit, not a representation theorem.",
    }


def check_lean_binding() -> dict:
    summary = json.loads((HERE / "lean/verification_summary.json").read_text())
    certificate_path = ROOT / summary["certificate"]
    certificate = json.loads(certificate_path.read_text())
    check = certificate["lean_check"]
    source = (HERE / "lean/Main.lean").read_bytes()
    fidelity = (HERE / "lean/statement_fidelity.md").read_bytes()
    assert hashlib.sha256(source).hexdigest() == check["source_sha256"]
    assert hashlib.sha256(fidelity).hexdigest() == check["statement_fidelity_sha256"]
    assert source.decode() == certificate["lean_source"]["text"]
    assert fidelity.decode() == certificate["statement_fidelity"]["text"]
    assert check["exit_code"] == check["audit_exit_code"] == 0
    assert check["proof_holes"] == [] and check["status"] == "success"
    assert "Lean (version 4.31.0," in check["tools"]["lean"]["version"]
    state = json.loads((ROOT / "research/MATH_STATE.json").read_text())
    claim = max(
        (c for c in state["claims"] if c["claim_id"] == "C_FIELD_COMBINATORIAL"),
        key=lambda c: c["version"],
    )
    assert certificate["subject"]["content_hash"] == claim["content_hash"]
    assert any(e.get("evidence_id") == certificate["evidence_id"] for e in state["evidence"])
    return {
        "claim_id": claim["claim_id"],
        "claim_version": claim["version"],
        "certificate": summary["certificate"],
        "compiler_exit_code": 0,
        "axiom_audit_exit_code": 0,
        "proof_holes": [],
        "current_source_and_fidelity_match": True,
        "scope": "Replay checks an existing real compiler certificate; it does not rerun Lean.",
    }


def run() -> dict:
    source_path = Path(
        "research/openai_manuscript/"
        "A-Negative-Solution-to-the-Finite-Lattice-Representation-Problem-September-24-2026/"
        "build/sections/packets.tex"
    )
    source = (ROOT / source_path).read_text()
    assert "\\label{pkt:field-shifts}" in source
    assert "s-a\\equiv0\\pmod h" in source
    assert "constituent types has size at most $2v$." in source
    progression_cases = [(2, 2), (3, 2), (5, 3), (9, 2), (6, 3)]
    for b, t in progression_cases:
        positions = [(j * t) % (b * t) for j in range(b)]
        assert len(set(positions)) == b and all(x % t == 0 for x in positions)
        if b % 2:
            doubled = [(2 * j * t) % (b * t) for j in range(b)]
            assert len(set(doubled)) == b and all(x % t == 0 for x in doubled)
    return {
        "schema_version": 1,
        "claim": "C_FIELD_SHIFT",
        "result": "Uniform verification theorem with a kernel-certified combinatorial core.",
        "manuscript_source": str(source_path),
        "manuscript_label": "pkt:field-shifts",
        "universal_proof": "research/field_shift/report.md, Sections 1-6",
        "all_retained_edge_types": [
            "single-digit nonlinear", "block", "form", "ordinary tensor with one active component",
            "subfield", "restriction of scalars", "natural twisted tensor",
            "characteristic-two nonsingular line", "characteristic-two B/C convention changes",
        ],
        "scope_limits": [
            "The edge catalogue, component nesting, and retained-path reduction remain manuscript inputs under audit.",
            "Representation-theoretic and matrix-descent proofs are prose, not Lean kernel claims.",
            "Finite construction replays do not establish the universal parameter quantifier.",
            "No false manuscript assertion, main-theorem refutation, novelty, or independent acceptance is claimed.",
        ],
        "independent_review": "pending_host",
        "lean": check_lean_binding(),
        "jacobian": replay_jacobian(),
        "BC": bc_checks(),
        "unitary_even": even_unitary_construction(),
        "unitary_odd": odd_unitary_construction(),
        "inadmissible_unitary_pattern": reject_inadmissible_unitary_pattern(),
        "integer_regression_cases": [list(case) for case in progression_cases],
    }


def main() -> None:
    if not __debug__:
        raise RuntimeError("Run without -O: exact obligations are checked with assertions")
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--write-certificate", action="store_true")
    args = parser.parse_args()
    result = run()
    path = HERE / "exact_certificate.json"
    if args.write_certificate:
        path.write_text(json.dumps(result, indent=2) + "\n")
    else:
        assert json.loads(path.read_text()) == result, "The exact certificate does not match replay"
    print(json.dumps({
        "status": "pass",
        "source_rank": 9,
        "even_generators": result["unitary_even"]["elementary_generators_checked"],
        "odd_matrices": result["unitary_odd"]["nontrivial_source_matrices_checked"],
        "lean_proof_holes": result["lean"]["proof_holes"],
        "independent_review": "pending_host",
    }, sort_keys=True))


if __name__ == "__main__":
    main()
