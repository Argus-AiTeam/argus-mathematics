#!/usr/bin/env python3
"""Verify the exact Q4 principal ideals and the finite-fiber transversal candidate."""

from __future__ import annotations

import argparse
import gzip
import hashlib
import json
from pathlib import Path

from sage.all import GF, PolynomialRing, QQ, matrix, vector


HERE = Path(__file__).resolve().parent
CAMPAIGN = HERE.parents[1]
Q4_ACTIONS = CAMPAIGN / "research/q4_orbit_scc/exact-left-right-actions.json.gz"
FINITE_FIBER = (
    CAMPAIGN
    / "research/infinite_countermodel/parabolic_induction/radical_first_return"
)
Q5_ACTION = FINITE_FIBER / "q5-quotient-q2-p101.pa"
Q6_ACTION = FINITE_FIBER / "q6-quotient-q2-p101.pa"
PRIME = 101
Q_VALUE = 2


def sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as stream:
        for chunk in iter(lambda: stream.read(1 << 20), b""):
            digest.update(chunk)
    return digest.hexdigest()


def decode_polynomial(encoded, ring, q):
    return sum(
        ring(QQ(int(numerator)) / QQ(int(denominator)))
        * q ** int(exponent)
        for exponent, numerator, denominator in encoded
    )


def decode_matrix(entries, field, ring, q):
    values = {}
    for row, column, numerator, denominator in entries:
        numerator_value = decode_polynomial(numerator, ring, q)
        denominator_value = decode_polynomial(denominator, ring, q)
        if not denominator_value:
            raise AssertionError("exact action has a zero denominator")
        values[(int(row), int(column))] = field(
            numerator_value / denominator_value
        )
    return matrix(field, 169, 169, values, sparse=True)


def parse_plain_action(path: Path):
    values = [int(value) for value in path.read_text(encoding="ascii").split()]
    dimension, generator_count, module_generator_count, has_preimages = values[:4]
    if has_preimages:
        raise AssertionError("unexpected preimages in plain action output")
    field = GF(PRIME)
    position = 4
    image_count = module_generator_count * dimension
    images = matrix(
        field,
        module_generator_count,
        dimension,
        values[position : position + image_count],
    )
    position += image_count
    actions = []
    action_count = dimension * dimension
    for _ in range(generator_count):
        actions.append(
            matrix(
                field,
                dimension,
                dimension,
                values[position : position + action_count],
                sparse=True,
            )
        )
        position += action_count
    if position + 1 != len(values):
        raise AssertionError("plain action output has an unexpected length")
    return {
        "dimension": dimension,
        "images": images,
        "actions": actions,
    }


class RowIndependence:
    def __init__(self, field):
        self.field = field
        self.pivots = {}

    def insert(self, value):
        reduced = vector(self.field, value)
        for pivot in sorted(self.pivots):
            if reduced[pivot]:
                reduced -= reduced[pivot] * self.pivots[pivot]
        if not reduced:
            return False
        pivot = next(index for index, entry in enumerate(reduced) if entry)
        reduced /= reduced[pivot]
        for old_pivot, old_row in list(self.pivots.items()):
            if old_row[pivot]:
                self.pivots[old_pivot] = old_row - old_row[pivot] * reduced
        self.pivots[pivot] = reduced
        return True

    @property
    def rank(self):
        return len(self.pivots)


def close_rows(seed, named_actions):
    reducer = RowIndependence(seed.base_ring())
    selected = []
    frontier = []
    if reducer.insert(seed):
        selected.append((seed, ()))
        frontier.append((seed, ()))
    history = [len(selected)]
    while frontier:
        next_frontier = []
        for current, word in frontier:
            for name, action in named_actions:
                candidate = current * action
                candidate_word = (name,) + word
                if reducer.insert(candidate):
                    selected.append((candidate, candidate_word))
                    next_frontier.append((candidate, candidate_word))
        if not next_frontier:
            break
        frontier = next_frontier
        history.append(len(selected))
    return {
        "rank": reducer.rank,
        "history": history,
        "vectors": [item[0] for item in selected],
        "words": [item[1] for item in selected],
    }


def apply_left_label(row, word, action_by_name):
    value = row
    for letter in reversed(word):
        value = value * action_by_name[letter]
    return value


def candidate_rank(base_vectors, representatives, action_by_name):
    reducer = RowIndependence(base_vectors[0].base_ring())
    block_ranks = []
    vectors = []
    for representative in representatives:
        for base in base_vectors:
            candidate = apply_left_label(base, representative, action_by_name)
            vectors.append(candidate)
            reducer.insert(candidate)
        block_ranks.append(reducer.rank)
    return {
        "rank": reducer.rank,
        "block_ranks": block_ranks,
        "vectors": vectors,
    }


def polynomial_payload(value):
    numerator = value.numerator()
    denominator = value.denominator()
    leading = denominator.leading_coefficient()
    numerator /= leading
    denominator /= leading

    def encode(poly):
        terms = []
        for exponent, coefficient in sorted(
            poly.dict().items(), reverse=True
        ):
            if not coefficient:
                continue
            terms.append(
                {
                    "coefficient": {
                        "num": str(coefficient.numerator()),
                        "den": str(coefficient.denominator()),
                    },
                    "exponents": [int(exponent)],
                }
            )
        return {"terms": terms}

    return {
        "variables": ["q"],
        "domain": "QQ",
        "numerator": encode(numerator),
        "denominator": encode(denominator),
    }


def specialize(value, target, q_value):
    numerator = value.numerator()(QQ(q_value))
    denominator = value.denominator()(QQ(q_value))
    denominator_residue = target(int(numerator.denominator())) * target(
        int(denominator.numerator())
    )
    numerator_residue = target(int(numerator.numerator())) * target(
        int(denominator.denominator())
    )
    if not denominator_residue:
        raise AssertionError("specialization denominator vanished")
    return numerator_residue / denominator_residue


def exact_principal_record(prefix, generators, q, field, *, opposite=False):
    identity = matrix.identity(field, 169, sparse=True)
    inverses = [
        q**-4
        * (
            generator**2
            + (q + q**3 - 1) * generator
            + (q**4 - q - q**3) * identity
        )
        for generator in generators
    ]
    x2 = q * inverses[0] + (1 - q) * identity - generators[0]
    if opposite:
        factor = (
            q**2 * inverses[1] * inverses[0]
            - generators[1] * generators[0]
        )
        x3 = x2 * factor
    else:
        factor = (
            q**2 * inverses[0] * inverses[1]
            - generators[0] * generators[1]
        )
        x3 = factor * x2
    scalar = (q - 1) ** 2 * (q + 1)
    if x3 * x3 != scalar * x3:
        raise AssertionError(f"{prefix}: X3 is not quasi-idempotent")
    idempotent = x3 / scalar
    if idempotent * idempotent != idempotent:
        raise AssertionError(f"{prefix}: normalized X3 is not idempotent")
    trace = idempotent.trace()
    if trace != 8:
        raise AssertionError(f"{prefix}: expected idempotent trace 8, got {trace}")

    target = GF(1009)
    specialized = matrix(
        target,
        169,
        169,
        {
            index: specialize(value, target, 2)
            for index, value in idempotent.dict().items()
        },
        sparse=True,
    )
    if specialized.rank() != 8:
        raise AssertionError(f"{prefix}: witness specialization lost rank 8")
    columns = list(specialized.pivots())
    if len(columns) != 8:
        raise AssertionError(f"{prefix}: unexpected pivot-column count")
    column_matrix = specialized.matrix_from_columns(columns)
    rows = list(column_matrix.transpose().pivots())
    if len(rows) != 8:
        raise AssertionError(f"{prefix}: unexpected pivot-row count")
    minor = idempotent.matrix_from_rows_and_columns(rows, columns)
    determinant = minor.det()
    if not determinant:
        raise AssertionError(f"{prefix}: selected exact minor vanished")
    determinant_residue = specialize(determinant, target, 2)
    if not determinant_residue:
        raise AssertionError(f"{prefix}: selected witness minor vanished")
    return {
        "matrix": idempotent,
        "trace": str(trace),
        "rank": 8,
        "rank_reason": (
            "e is an idempotent over Q(q), hence diagonalizable with eigenvalues "
            "0 and 1; its exact trace is 8"
        ),
        "minor_rows_zero_based": rows,
        "minor_columns_zero_based": columns,
        "minor_determinant": str(determinant.factor()),
        "minor_determinant_mod_1009_at_q_2": int(determinant_residue),
        "minor": minor,
    }


def matrix_word_left(vector_value, word, generators):
    value = vector_value
    for letter in reversed(word):
        value = generators[letter - 1] * value
    return value


def matrix_word_right(vector_value, word, generators):
    value = vector_value
    for letter in word:
        value = generators[letter - 1] * value
    return value


def column_span_rank(vectors):
    if not vectors:
        return 0
    return matrix(
        vectors[0].base_ring(),
        [list(value) for value in vectors],
    ).transpose().rank()


def close_columns(seed, named_actions):
    reducer = RowIndependence(seed.base_ring())
    selected = []
    frontier = []
    if reducer.insert(seed):
        selected.append((seed, ()))
        frontier.append((seed, ()))
    history = [len(selected)]
    while frontier:
        next_frontier = []
        for current, word in frontier:
            for name, action in named_actions:
                candidate = action * current
                candidate_word = word + (name,)
                if reducer.insert(candidate):
                    selected.append((candidate, candidate_word))
                    next_frontier.append((candidate, candidate_word))
        if not next_frontier:
            break
        frontier = next_frontier
        history.append(len(selected))
    return {
        "rank": reducer.rank,
        "history": history,
        "vectors": [item[0] for item in selected],
        "words": [item[1] for item in selected],
    }


def q4_schreier_record(left_generators, right_generators, left_e, right_e):
    unit = vector(left_e.base_ring(), [1] + [0] * 168)
    e_vector = left_e * unit
    if e_vector != right_e * unit:
        raise AssertionError("left and right regular actions disagree on e")

    left_core = close_columns(
        e_vector,
        [("sigma1", left_generators[0]), ("sigma2", left_generators[1])],
    )
    if left_core["rank"] != 2:
        raise AssertionError("Q3 e did not have the expected two-vector basis")

    right_core = close_columns(
        e_vector,
        [("sigma1", right_generators[0]), ("sigma2", right_generators[1])],
    )
    if right_core["rank"] != 2:
        raise AssertionError("e Q3 did not have the expected two-vector basis")

    left_representatives = [(), (3,), (2, 3), (1, 2, 3)]
    right_representatives = [(), (3,), (3, 2), (3, 2, 1)]
    left_vectors = [
        matrix_word_left(base, representative, left_generators)
        for representative in left_representatives
        for base in left_core["vectors"]
    ]
    right_vectors = [
        matrix_word_right(base, representative, right_generators)
        for representative in right_representatives
        for base in right_core["vectors"]
    ]
    left_rank = column_span_rank(left_vectors)
    right_rank = column_span_rank(right_vectors)
    if left_rank != 8 or right_rank != 8:
        raise AssertionError("the exact Q4 Schreier families did not have rank 8")
    return {
        "Q3_e_rank": left_core["rank"],
        "Q3_e_history": left_core["history"],
        "Q3_e_basis_words": [
            "*".join(word) or "1" for word in left_core["words"]
        ],
        "e_Q3_rank": right_core["rank"],
        "e_Q3_history": right_core["history"],
        "e_Q3_basis_words": [
            "*".join(word) or "1" for word in right_core["words"]
        ],
        "left_representatives": [
            [int(letter) for letter in word] for word in left_representatives
        ],
        "right_representatives": [
            [int(letter) for letter in word] for word in right_representatives
        ],
        "left_candidate_count": len(left_vectors),
        "left_candidate_rank": left_rank,
        "right_candidate_count": len(right_vectors),
        "right_candidate_rank": right_rank,
    }


def q4_quadratic_restrictions(
    left_generators, right_generators, left_e, right_e, q
):
    identity = matrix.identity(left_e.base_ring(), 169, sparse=True)

    def rank_and_witness(value):
        rank = value.rank()
        witness = None
        if rank:
            (row, column), coefficient = next(iter(sorted(value.dict().items())))
            witness = {
                "row_zero_based": int(row),
                "column_zero_based": int(column),
                "coefficient": str(coefficient.factor()),
            }
        return {"rank": rank, "first_nonzero_entry": witness}

    q4_e = {}
    e_q4 = {}
    for index, (left, right) in enumerate(
        zip(left_generators, right_generators), start=1
    ):
        left_polynomial = (left - identity) * (left + q * identity)
        right_polynomial = (right - identity) * (right + q * identity)
        q4_e[f"sigma{index}"] = rank_and_witness(
            left_polynomial * right_e
        )
        e_q4[f"sigma{index}"] = rank_and_witness(
            right_polynomial * left_e
        )
    return {
        "polynomial": "P(T)=(T-1)*(T+q)",
        "Q4_e_left_action": q4_e,
        "e_Q4_right_action": e_q4,
        "interpretation": (
            "A zero rank means the indicated whole principal module factors "
            "through that quadratic generator action; a nonzero rank is an "
            "exact obstruction, not merely P(sigma_i)e or eP(sigma_i)."
        ),
    }


def finite_fiber_record():
    q5 = parse_plain_action(Q5_ACTION)
    q6 = parse_plain_action(Q6_ACTION)
    q5_names = dict(zip("abcd", q5["actions"][:4]))
    q6_names = dict(zip("abcde", q6["actions"][:5]))
    q5_seed = q5["images"].row(0) * q5["actions"][5]
    q6_seed = q6["images"].row(0) * q6["actions"][6]
    q5_core = close_rows(
        q5_seed,
        [(name, q5_names[name]) for name in "abc"],
    )
    q6_base = close_rows(
        q6_seed,
        [(name, q6_names[name]) for name in "abcd"],
    )
    if q5_core["rank"] != 8 or q6_base["rank"] != 40:
        raise AssertionError("finite-fiber predecessor ranks changed")

    q5_forward_reps = [
        (),
        ("d",),
        ("c", "d"),
        ("b", "c", "d"),
        ("a", "b", "c", "d"),
    ]
    q5_reverse_reps = [
        (),
        ("d",),
        ("d", "c"),
        ("d", "c", "b"),
        ("d", "c", "b", "a"),
    ]
    q6_forward_reps = [
        (),
        ("e",),
        ("d", "e"),
        ("c", "d", "e"),
        ("b", "c", "d", "e"),
        ("a", "b", "c", "d", "e"),
    ]
    q6_reverse_reps = [
        (),
        ("e",),
        ("e", "d"),
        ("e", "d", "c"),
        ("e", "d", "c", "b"),
        ("e", "d", "c", "b", "a"),
    ]
    q5_forward = candidate_rank(
        q5_core["vectors"], q5_forward_reps, q5_names
    )
    q5_reverse = candidate_rank(
        q5_core["vectors"], q5_reverse_reps, q5_names
    )
    q6_forward = candidate_rank(
        q6_base["vectors"], q6_forward_reps, q6_names
    )
    q6_reverse = candidate_rank(
        q6_base["vectors"], q6_reverse_reps, q6_names
    )
    q5_identity = matrix.identity(GF(PRIME), q5["dimension"], sparse=True)
    q6_identity = matrix.identity(GF(PRIME), q6["dimension"], sparse=True)
    q5_quadratic_ranks = {
        name: (
            (action - q5_identity)
            * (action + GF(PRIME)(Q_VALUE) * q5_identity)
        ).rank()
        for name, action in q5_names.items()
    }
    q6_quadratic_ranks = {
        name: (
            (action - q6_identity)
            * (action + GF(PRIME)(Q_VALUE) * q6_identity)
        ).rank()
        for name, action in q6_names.items()
    }

    def encode_reps(representatives):
        return ["".join(word) or "1" for word in representatives]

    q5_basis = matrix(
        GF(PRIME),
        [list(value) for value in q5_forward["vectors"]],
        sparse=False,
    )
    if q5_basis.rank() != q5["dimension"]:
        raise AssertionError("Q5 forward candidates are not a basis")
    q5_v = q5_seed * q5_names["c"] - q5_seed
    q5_p_d = (
        (q5_names["d"] - q5_identity)
        * (q5_names["d"] + GF(PRIME)(Q_VALUE) * q5_identity)
    )
    q5_target = q5_v * q5_p_d
    q5_coordinates = q5_basis.transpose().solve_right(
        vector(GF(PRIME), q5_target)
    )
    q5_labels = [
        "*".join((*representative, *base_word, "X3*e0"))
        if (*representative, *base_word)
        else "X3*e0"
        for representative in q5_forward_reps
        for base_word in q5_core["words"]
    ]
    q5_target_coordinates = [
        {
            "basis_word": label,
            "coefficient_mod_101": int(coefficient),
            "centered_coefficient": (
                int(coefficient)
                if int(coefficient) <= PRIME // 2
                else int(coefficient) - PRIME
            ),
        }
        for label, coefficient in zip(q5_labels, q5_coordinates)
        if coefficient
    ]

    return {
        "field": "F_101",
        "q": 2,
        "orientation": (
            "VE right actions are transposed balancing actions; labels are "
            "prepended, so these are candidate left-principal families only"
        ),
        "Q5": {
            "predecessor_rank": q5_core["rank"],
            "module_dimension": q5["dimension"],
            "forward_representatives": encode_reps(q5_forward_reps),
            "forward_block_ranks": q5_forward["block_ranks"],
            "forward_rank": q5_forward["rank"],
            "reverse_representatives": encode_reps(q5_reverse_reps),
            "reverse_block_ranks": q5_reverse["block_ranks"],
            "reverse_rank": q5_reverse["rank"],
            "quadratic_action_ranks": q5_quadratic_ranks,
            "first_unresolved_transition_fiber": {
                "target": "P(d)*(c*X3*e0-X3*e0)",
                "target_nonzero": bool(q5_target),
                "coordinate_support": len(q5_target_coordinates),
                "coordinates_in_forward_basis": q5_target_coordinates,
                "scope": (
                    "These are unique coordinates in the q=2, F_101 fiber; "
                    "they are discovery data, not a Q(q) identity."
                ),
            },
        },
        "Q6": {
            "predecessor_rank": q6_base["rank"],
            "module_dimension": q6["dimension"],
            "forward_representatives": encode_reps(q6_forward_reps),
            "forward_block_ranks": q6_forward["block_ranks"],
            "forward_rank": q6_forward["rank"],
            "reverse_representatives": encode_reps(q6_reverse_reps),
            "reverse_block_ranks": q6_reverse["block_ranks"],
            "reverse_rank": q6_reverse["rank"],
            "quadratic_action_ranks": q6_quadratic_ranks,
        },
        "limitation": (
            "These ranks are exact only in the q=2, F_101 induced fiber. "
            "They neither lift spanning nor independence to Q(q), and the "
            "module tests only one principal orientation."
        ),
    }


def jacobian_record(path: Path | None):
    if path is None:
        return {
            "status": "not_run",
            "operation_id": "matrix.symbolic.rank.compute",
        }
    path = path.resolve()
    payload = json.loads(path.read_text(encoding="utf-8"))
    if payload.get("result", {}).get("operation_id") != (
        "matrix.symbolic.rank.compute"
    ):
        raise AssertionError("unexpected Jacobian operation")
    output = payload["result"]["output"]
    if output["rank"] != 8 or output["pivot_columns"] != list(range(8)):
        raise AssertionError("Jacobian did not certify full rank 8")
    return {
        "status": "COMPUTED",
        "operation_id": payload["result"]["operation_id"],
        "server_version": payload["server"]["version"],
        "protocol_version": payload["protocol_version"],
        "typed_output": output,
        "runtime_ms": payload["result"]["runtime_ms"],
        "adapter_error": None,
        "adapter_timeout": False,
        "output_path": str(path.relative_to(CAMPAIGN)),
        "output_sha256": sha256(path),
    }


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "--output",
        type=Path,
        default=HERE / "base-and-candidate-transversals-certificate.json",
    )
    parser.add_argument(
        "--jacobian-payload",
        type=Path,
        default=HERE / "jacobian/payload-q4-left-principal-minor.json",
    )
    parser.add_argument("--jacobian-output", type=Path)
    args = parser.parse_args()

    polynomial_ring = PolynomialRing(QQ, "q")
    q = polynomial_ring.gen()
    field = polynomial_ring.fraction_field()
    with gzip.open(Q4_ACTIONS, "rt", encoding="utf-8") as stream:
        encoded_actions = json.load(stream)
    generators = {
        name: decode_matrix(
            encoded_actions["matrices"][name],
            field,
            polynomial_ring,
            q,
        )
        for name in ("L1", "L2", "L3", "R1", "R2", "R3")
    }
    left_record = exact_principal_record(
        "L", [generators[f"L{i}"] for i in range(1, 4)], q, field
    )
    right_record = exact_principal_record(
        "R",
        [generators[f"R{i}"] for i in range(1, 4)],
        q,
        field,
        opposite=True,
    )
    q4_schreier = q4_schreier_record(
        [generators[f"L{i}"] for i in range(1, 4)],
        [generators[f"R{i}"] for i in range(1, 4)],
        left_record["matrix"],
        right_record["matrix"],
    )
    q4_quadratic = q4_quadratic_restrictions(
        [generators[f"L{i}"] for i in range(1, 4)],
        [generators[f"R{i}"] for i in range(1, 4)],
        left_record["matrix"],
        right_record["matrix"],
        q,
    )

    args.jacobian_payload.parent.mkdir(parents=True, exist_ok=True)
    jacobian_payload = {
        "matrix": {
            "variables": ["q"],
            "entries": [
                [polynomial_payload(entry) for entry in row]
                for row in left_record["minor"].rows()
            ],
        }
    }
    args.jacobian_payload.write_text(
        json.dumps(jacobian_payload, indent=2, sort_keys=True) + "\n",
        encoding="utf-8",
    )

    def public_exact(record):
        return {
            key: value
            for key, value in record.items()
            if key not in {"matrix", "minor"}
        }

    certificate = {
        "schema": "principal-ideal-factorial-recursion-diagnostic-v1",
        "status": "passed",
        "coefficient_field": "Q(q)",
        "exact_Q4": {
            "normalized_idempotent": "e=((q-1)^2*(q+1))^-1*X3",
            "Q4_e": public_exact(right_record),
            "e_Q4": public_exact(left_record),
            "schreier_base_case": q4_schreier,
            "quadratic_restrictions": q4_quadratic,
            "conclusion": (
                "dim_Q(q)(Q4 e)=dim_Q(q)(e Q4)=8=4!/3. This is an "
                "exact characteristic-zero theorem, not a fiber inference."
            ),
        },
        "finite_fiber_candidate": finite_fiber_record(),
        "jacobian": jacobian_record(args.jacobian_output),
        "inputs": {
            "exact_Q4_actions": str(Q4_ACTIONS.relative_to(CAMPAIGN)),
            "exact_Q4_actions_sha256": sha256(Q4_ACTIONS),
            "q5_action": str(Q5_ACTION.relative_to(CAMPAIGN)),
            "q5_action_sha256": sha256(Q5_ACTION),
            "q6_action": str(Q6_ACTION.relative_to(CAMPAIGN)),
            "q6_action_sha256": sha256(Q6_ACTION),
            "jacobian_payload": str(
                args.jacobian_payload.relative_to(CAMPAIGN)
            ),
            "jacobian_payload_sha256": sha256(args.jacobian_payload),
        },
        "scope": (
            "The exact Q4 result establishes only the factorial base case. "
            "The Q5 and Q6 transversal ranks are candidate-discovery evidence "
            "in one finite fiber and do not prove a Q(q) recursion."
        ),
    }
    args.output.parent.mkdir(parents=True, exist_ok=True)
    args.output.write_text(
        json.dumps(certificate, indent=2, sort_keys=True) + "\n",
        encoding="utf-8",
    )
    print(
        json.dumps(
            {
                "status": "passed",
                "Q4_e_rank": right_record["rank"],
                "e_Q4_rank": left_record["rank"],
                "Q5_forward_rank": certificate["finite_fiber_candidate"][
                    "Q5"
                ]["forward_rank"],
                "Q6_forward_rank": certificate["finite_fiber_candidate"][
                    "Q6"
                ]["forward_rank"],
                "jacobian_status": certificate["jacobian"]["status"],
            },
            sort_keys=True,
        )
    )


if __name__ == "__main__":
    main()
