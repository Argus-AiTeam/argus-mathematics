#!/usr/bin/env python3
"""Replay exact local algebra and finite controls; validate the Lean core binding.

The all-orders analytic proof is report.md, not the finite Taylor controls below.
Only the Python standard library is needed. No thermal certificates are rebuilt.
"""

import argparse
from dataclasses import dataclass
from fractions import Fraction
from functools import lru_cache
import hashlib
from itertools import permutations, product
import json
from math import factorial, prod
from pathlib import Path


HERE = Path(__file__).resolve().parent
ROOT = HERE.parent.parent
PERIODIC = ROOT / "research/openai_manuscript/The-periodic-spin-one-Haldane-gap-September-24-2026/build"
BOUNDARY = ROOT / "research/openai_manuscript/A-boundary-field-gap-for-the-spin-one-Heisenberg-chain-September-24-2026/build"

Gaussian = tuple[int, int]
Matrix3 = tuple[tuple[int, ...], ...]
Sparse = list[dict[int, Gaussian]]
Rotation = tuple[tuple[int, ...], tuple[int, ...]]
History = tuple[tuple[int, int], ...]

ZERO = (0, 0)
ONE = (1, 0)
IDENTITY: Matrix3 = ((1, 0, 0), (0, 1, 0), (0, 0, 1))
G: tuple[Matrix3, ...] = (
    ((0, 0, 0), (0, 0, 1), (0, -1, 0)),
    ((0, 0, -1), (0, 0, 0), (1, 0, 0)),
    ((0, 1, 0), (-1, 0, 0), (0, 0, 0)),
)
UNIT: Rotation = ((0, 1, 2), (1, 1, 1))
P: Rotation = ((0, 1, 2), (1, -1, -1))
C: Rotation = ((1, 2, 0), (1, 1, 1))
C_INVERSE: Rotation = ((2, 0, 1), (1, 1, 1))


def require(condition: bool, message: str) -> None:
    if not condition:
        raise AssertionError(message)


def gmul(a: Gaussian, b: Gaussian) -> Gaussian:
    return (a[0] * b[0] - a[1] * b[1], a[0] * b[1] + a[1] * b[0])


def gpow(a: Gaussian, n: int) -> Gaussian:
    result = ONE
    for _ in range(n):
        result = gmul(result, a)
    return result


def mmul(a: Matrix3, b: Matrix3) -> Matrix3:
    return tuple(tuple(sum(a[i][k] * b[k][j] for k in range(3)) for j in range(3))
                 for i in range(3))


def transpose(a: Matrix3) -> Matrix3:
    return tuple(zip(*a))


@lru_cache(maxsize=None)
def word_trace(labels: tuple[int, ...]) -> int:
    a = IDENTITY
    for label in labels:
        a = mmul(a, G[label])
    return sum(a[i][i] for i in range(3))


def kernel(x: History, y: History) -> int:
    events = sorted(x + y)
    if len({time for time, _ in events}) != len(events):
        return 0
    return word_trace(tuple(label for _, label in events))


def rotate_history(g: Rotation, x: History) -> History:
    return tuple((time, g[0][label]) for time, label in x)


def history_sign(g: Rotation, x: History) -> int:
    return prod(g[1][label] for _, label in x)


def rotation_matrix(g: Rotation) -> Matrix3:
    return tuple(tuple(g[1][j] if i == g[0][j] else 0 for j in range(3))
                 for i in range(3))


def compose(g: Rotation, h: Rotation) -> Rotation:
    return (tuple(g[0][h[0][a]] for a in range(3)),
            tuple(h[1][a] * g[1][h[0][a]] for a in range(3)))


def rotations() -> list[Rotation]:
    result = []
    for permutation in permutations(range(3)):
        parity = (-1) ** sum(permutation[i] > permutation[j]
                            for i in range(3) for j in range(i + 1, 3))
        for signs in product((-1, 1), repeat=3):
            if parity * prod(signs) == 1:
                result.append((permutation, signs))
    return result


def sparse_identity(dimension: int) -> Sparse:
    return [{i: ONE} for i in range(dimension)]


def sparse_mul(a: Sparse, b: Sparse) -> Sparse:
    result = []
    for row in a:
        accumulated: dict[int, Gaussian] = {}
        for k, x in row.items():
            for j, y in b[k].items():
                z = gmul(x, y)
                previous = accumulated.get(j, ZERO)
                accumulated[j] = (previous[0] + z[0], previous[1] + z[1])
        result.append({j: z for j, z in accumulated.items() if z != ZERO})
    return result


def sparse_trace(a: Sparse) -> Gaussian:
    diagonal = [row.get(i, ZERO) for i, row in enumerate(a)]
    return (sum(z[0] for z in diagonal), sum(z[1] for z in diagonal))


def tensor_matrix(local: list[Matrix3]) -> Sparse:
    result = sparse_identity(1)
    for matrix in local:
        expanded: Sparse = [{} for _ in range(3 * len(result))]
        for i, row in enumerate(result):
            for j, coefficient in row.items():
                for r in range(3):
                    for s in range(3):
                        if matrix[r][s]:
                            expanded[3 * i + r][3 * j + s] = (
                                coefficient[0] * matrix[r][s],
                                coefficient[1] * matrix[r][s],
                            )
        result = expanded
    return result


@dataclass(frozen=True)
class Event:
    channel: int
    label: int
    placements: tuple[tuple[int, int], ...]
    coefficient: Gaussian


def event_matrix(n: int, event: Event) -> Sparse:
    local = [IDENTITY] * n
    for site, label in event.placements:
        local[site] = G[label]
    return [{j: gmul(value, event.coefficient) for j, value in row.items()}
            for row in tensor_matrix(local)]


def generator(n: int, events: list[Event]) -> Sparse:
    result: Sparse = [{} for _ in range(3 ** n)]
    for event in events:
        for i, row in enumerate(event_matrix(n, event)):
            for j, value in row.items():
                previous = result[i].get(j, ZERO)
                result[i][j] = (previous[0] + value[0], previous[1] + value[1])
    return [{j: value for j, value in row.items() if value != ZERO} for row in result]


def physical_word_trace(n: int, word: tuple[Event, ...]) -> Gaussian:
    matrix = sparse_identity(3 ** n)
    for event in word:
        matrix = sparse_mul(matrix, event_matrix(n, event))
    return sparse_trace(matrix)


def periodic_events(n: int, g: Rotation) -> list[Event]:
    events = [Event(0, a, ((n - 1, a), (0, g[0][a])), (g[1][a], 0))
              for a in range(3)]
    events += [Event(j, a, ((j - 1, a), (j, a)), ONE)
               for j in range(1, n) for a in range(3)]
    return events


def open_events(n: int, g: Rotation) -> list[Event]:
    # This is five times the negative Hamiltonian, so all entries are Gaussian integers.
    return (
        [Event(0, 2, ((0, 2),), (0, -3))]
        + [Event(j, a, ((j - 1, a), (j, a)), (5, 0))
           for j in range(1, n) for a in range(3)]
        + [Event(n, 2, ((n - 1, g[0][2]),), (0, 3 * g[1][2]))]
    )


def histories(word: tuple[Event, ...], count: int) -> list[History]:
    return [tuple((time, event.label) for time, event in enumerate(word, start=1)
                  if event.channel == channel) for channel in range(count)]


def periodic_integrand(n: int, g: Rotation, word: tuple[Event, ...]) -> Gaussian:
    e = histories(word, n)
    x = [e[0]] + list(reversed(e[1:]))
    value = prod(kernel(x[j], x[j + 1]) for j in range(n - 1))
    value *= kernel(x[-1], rotate_history(g, x[0])) * history_sign(g, x[0])
    return (value, 0)


def open_integrand(n: int, g: Rotation, word: tuple[Event, ...]) -> Gaussian:
    e = histories(word, n + 1)
    right_sign = history_sign(g, e[-1])
    e[-1] = rotate_history(g, e[-1])
    value = prod(kernel(e[j], e[j + 1]) for j in range(n))
    left_count, right_count = len(e[0]), len(e[-1])
    bond_count = len(word) - left_count - right_count
    coefficient = gmul(gpow((0, -3), left_count), gpow((0, 3), right_count))
    scalar = value * right_sign * 5 ** bond_count
    return (scalar * coefficient[0], scalar * coefficient[1])


def exact_taylor(n: int, g: Rotation, degree: int, boundary: bool) -> dict:
    events = open_events(n, g) if boundary else periodic_events(n, g)
    matrix = generator(n, events)
    power = sparse_identity(3 ** n)
    coefficients = []
    word_count = 0
    integrand = open_integrand if boundary else periodic_integrand
    for k in range(degree + 1):
        physical = sparse_trace(power)
        history_real = history_imaginary = 0
        for word in product(events, repeat=k):
            real, imaginary = integrand(n, g, word)
            history_real += real
            history_imaginary += imaginary
            word_count += 1
        require(physical == (history_real, history_imaginary),
                f"Taylor mismatch: n={n}, g={g}, boundary={boundary}, k={k}")
        require(physical[1] == 0, "A self-adjoint physical power had nonreal trace")
        denominator = factorial(k) * (5 ** k if boundary else 1)
        coefficients.append(str(Fraction(physical[0], denominator)))
        if k < degree:
            power = sparse_mul(power, matrix)
    return {"n": n, "permutation": g[0], "signs": g[1],
            "degree": degree, "unshifted_taylor_coefficients": coefficients,
            "ordered_words": word_count}


def spin_and_group_checks(group: list[Rotation]) -> dict:
    require(len(group) == len(set(group)) == 24, "Proper signed permutation enumeration")
    for a in range(3):
        projection = mmul(transpose(G[a]), G[a])
        expected = tuple(tuple(int(i == j and i != a) for j in range(3)) for i in range(3))
        require(projection == expected, "The claimed exact norm-one spin identity failed")
    bond = generator(2, periodic_events(2, UNIT)[3:])
    for i, row in enumerate(bond):
        r, s = divmod(i, 3)
        expected_row = {}
        for j in range(9):
            t, u = divmod(j, 3)
            value = int(r == s and t == u) - int(r == u and s == t)
            if value:
                expected_row[j] = (value, 0)
        require(row == expected_row, "-S dot S = sum G tensor G = Omega Omega^* - F")
    group_set = set(group)
    for g in group:
        matrix = rotation_matrix(g)
        for a in range(3):
            rotated = mmul(mmul(matrix, G[a]), transpose(matrix))
            expected = tuple(tuple(g[1][a] * value for value in row) for row in G[g[0][a]])
            require(rotated == expected, "Proper-rotation covariance failed")
        for h in group:
            gh = compose(g, h)
            require(gh in group_set, "Signed rotation multiplication left the group")
            for labels in product(range(3), repeat=3):
                x = tuple(enumerate(labels, start=1))
                require(history_sign(gh, x) ==
                        history_sign(g, rotate_history(h, x)) * history_sign(h, x),
                        "The history-sign cocycle failed")
    return {"proper_signed_permutations": 24, "covariance_identities": 72,
            "group_products": 576, "length_three_cocycle_checks": 576 * 27,
            "norm_squared_identities": 3, "cartesian_bond_entries": 81}


def interleavings(counts: tuple[int, ...]):
    if not any(counts):
        yield ()
        return
    for channel, count in enumerate(counts):
        if count:
            remaining = list(counts)
            remaining[channel] -= 1
            for suffix in interleavings(tuple(remaining)):
                yield (channel,) + suffix


def shuffle_checks() -> list[dict]:
    records = []
    for counts in ((), (0,), (0, 0), (2, 1), (2, 1, 2), (1, 1, 1, 1)):
        shuffles = list(interleavings(counts))
        expected = factorial(sum(counts)) // prod(factorial(k) for k in counts)
        require(len(shuffles) == len(set(shuffles)) == expected, "Interleaving multiplicity")
        records.append({"counts": counts, "interleavings": expected})
    return records


def orientation_controls() -> dict:
    x, y = ((1, 0), (3, 2)), ((2, 1),)
    require((kernel(x, y), kernel(y, x), word_trace((2, 1, 0))) == (1, 1, -1),
            "The order-sensitive negative control failed")
    require(kernel((), ()) == 3 and kernel(((1, 0),), ((1, 1),)) == 0,
            "Empty-history or collision convention failed")
    forward_events = periodic_events(4, C)
    inverse_events = periodic_events(4, C_INVERSE)
    seam_word = tuple(forward_events[i] for i in (0, 0, 5, 5))
    inverse_word = tuple(inverse_events[i] for i in (0, 0, 5, 5))
    forward = periodic_integrand(4, C, seam_word)[0]
    backward = periodic_integrand(4, C_INVERSE, inverse_word)[0]
    require((forward, backward) == (12, 24), "The pointwise seam-orientation control failed")
    require(physical_word_trace(4, seam_word) == (forward, 0)
            and physical_word_trace(4, inverse_word) == (backward, 0),
            "The pointwise seam control disagrees with direct physical word traces")
    opposite = (open_events(2, UNIT)[0], open_events(2, UNIT)[3],
                open_events(2, UNIT)[-1])
    same = (open_events(2, P)[0], open_events(2, P)[3], open_events(2, P)[-1])
    left_right = open_integrand(2, UNIT, opposite)
    same_right = open_integrand(2, P, same)
    require((left_right, same_right) == ((180, 0), (-180, 0)),
            "The endpoint conjugation/sign control failed")
    require(physical_word_trace(2, opposite) == left_right
            and physical_word_trace(2, same) == same_right,
            "The endpoint control disagrees with direct physical word traces")
    return {"merged_trace": 1, "exchanged_histories_trace": 1, "reversed_word_trace": -1,
            "pointwise_C_seam": forward, "pointwise_C_inverse_seam": backward,
            "opposite_endpoint_word": str(Fraction(left_right[0], 5 ** 3)),
            "same_endpoint_word": str(Fraction(same_right[0], 5 ** 3)),
            "empty_site_trace": 3, "collision_kernel": 0}


def source_checks() -> list[dict]:
    bindings = [
        (PERIODIC / "model.tex",
         [r"(S^\alpha)_{ij}=-i\varepsilon_{\alphaij}", r"G_\alpha=iS^\alpha",
          r"a=\frac{700741}{500000}",
          r"h_{n-1,0}(g)=\sum_\alpha S_{n-1}^\alpha(gS^\alpha g^{-1})_0"]),
        (PERIODIC / "transfer.tex",
         [r"\label{prop:transfer}", r"Z_n(b,g)=\Tr(X_b^nU_g)",
          r"k_b(x,y)=k_b(y,x)", r"k_b(x,\sigma_gy)s_g(y)"]),
        (BOUNDARY / "sections/transfer.tex",
         [r"h=\frac35", r"(ih)^d", r"(-ih)G_z=+hS^z", r"(ih)G_z=-hS^z",
          r"\label{tr:boundary}", r"Y_n(b)=\langle v_b,X_b^nv_b\rangle",
          r"Y_n^{\rm s}(b)=\langle v_b,X_b^nU_Pv_b\rangle"]),
    ]
    records = []
    for path, fragments in bindings:
        text = "".join(path.read_text().split())
        for fragment in fragments:
            require("".join(fragment.split()) in text, f"Literal source binding failed: {path}: {fragment}")
        records.append({"path": str(path.relative_to(ROOT)), "literal_fragments_checked": len(fragments)})
    return records


def jacobian_check() -> dict:
    contract = json.loads((HERE / "jacobian_contract.json").read_text())
    payload = json.loads((HERE / "jacobian_payload.json").read_text())
    run = json.loads((HERE / "jacobian_result.json").read_text())
    execution = json.loads((HERE / "jacobian_execution.json").read_text())
    require(execution["adapter_exit_code"] == 0 and execution["timeout"] is False
            and execution["error"] is None, "Jacobian did not conclude successfully")
    require(run["server"]["version"] == contract["server"]["version"] == "0.14.0",
            "Unexpected Jacobian server version")
    require(run["protocol_version"] == contract["protocol_version"] == "2025-11-25",
            "Unexpected Jacobian protocol")
    require(run["request"]["operation_id"] == contract["operation_id"] ==
            run["result"]["operation_id"] == "matrix.partial_trace.compute", "Operation binding")
    require(run["request"]["payload"] == payload, "Jacobian payload was not the preserved payload")
    a, b = IDENTITY, IDENTITY
    for label in (0, 1, 2):
        a = mmul(a, G[label])
    for label in (2, 1, 0):
        b = mmul(b, G[label])
    expected_input = tensor_matrix([a, b])
    entries = payload["matrix"]["entries"]
    require(payload["traced_dimension"] == payload["kept_dimension"] == 3, "Subsystem dimensions")
    for i in range(9):
        for j in range(9):
            value = Fraction(int(entries[i][j]["num"]), int(entries[i][j]["den"]))
            require(value == expected_input[i].get(j, ZERO)[0], "Jacobian word-product input")
    output = run["result"]["output"]
    require(output["convention"] == "BLOCK_TRACE_OVER_QQ"
            and output["traced_dimension"] == output["kept_dimension"] == 3, "Typed output convention")
    reduced = output["reduced_matrix"]["entries"]
    for i in range(3):
        for j in range(3):
            value = Fraction(int(reduced[i][j]["num"]), int(reduced[i][j]["den"]))
            direct = sum(Fraction(int(entries[3 * k + i][3 * k + j]["num"]),
                                  int(entries[3 * k + i][3 * k + j]["den"])) for k in range(3))
            require(value == direct == word_trace((0, 1, 2)) * b[i][j],
                    "Independent exact partial-trace replay")
    return {"operation_id": contract["operation_id"], "server_version": "0.14.0",
            "protocol_version": "2025-11-25", "adapter_exit_code": 0, "timeout": False,
            "input": "(G_x G_y G_z) tensor (G_z G_y G_x)",
            "reduced_matrix": [[0, 0, 0], [0, -1, 0], [0, 0, 0]],
            "scope": "One bounded contraction, not an all-orders proof."}


def lean_check() -> dict:
    result = json.loads((HERE / "lean_verify.json").read_text())
    require(result["status"] == "success" and result["exit_code"] == 0
            and result["proof_holes"] == [] and result["audit_exit_code"] == 0,
            "Lean evidence is not a successful hole-free compile")
    for filename, field in (("Main.lean", "source_sha256"),
                            ("statement_fidelity.md", "statement_fidelity_sha256")):
        require(hashlib.sha256((HERE / filename).read_bytes()).hexdigest() == result[field],
                f"Stale Lean evidence: {filename}")
    version = result["tools"]["lean"]["version"]
    require("version 4.31.0," in version, "The claimed Lean version was not used")
    evidence = result["kernel"]["recorded"]
    require(evidence["subject"]["subject_id"] == "C_TRANSFER_CORE"
            and evidence["tier"] == "mechanical" and evidence["verdict"] == "supports",
            "Compiler outcome is not attached to the algebraic core claim")
    certificate = json.loads((ROOT / evidence["artifact"]).read_text())
    require(certificate["subject"] == evidence["subject"], "Archived Lean claim binding")
    return {"claim": "C_TRANSFER_CORE", "compiler": "Lean 4.31.0", "exit_code": 0,
            "proof_holes": [], "certificate": evidence["artifact"],
            "main_theorem": "TransferAudit.trace_supported_word",
            "quantifiers": "Every finite site and local basis type; every commutative semiring; every finite ordered event word.",
            "not_formalized": ["history measure and time interleavings", "operator convergence and trace-class analysis",
                              "physical partition functions and uniform spectral gaps"],
            "statement_fidelity_independent_review": "pending"}


def verify() -> dict:
    require((HERE / "report.md").is_file(), "The all-orders analytic proof is missing")
    source = source_checks()
    group = rotations()
    boundary_group = [g for g in group if g[0] in (UNIT[0], C[0], C_INVERSE[0])]
    require(len(boundary_group) == 12 and UNIT in boundary_group and P in boundary_group,
            "Boundary group enumeration")
    algebra = spin_and_group_checks(group)
    controls = orientation_controls()
    shuffles = shuffle_checks()
    periodic = [exact_taylor(4, g, 4, False) for g in group]
    boundary = [exact_taylor(n, g, 4, True) for n in (2, 3) for g in boundary_group]
    return {
        "result_class": "partial_result",
        "mathematical_result": "All-orders reconstruction of both manuscript transfer identities with a formally verified arbitrary-word algebraic core.",
        "novelty_status": "not_claimed",
        "significance_status": "not_assessed",
        "independent_review": "pending",
        "campaign_complete": False,
        "proof": "research/transfer_audit/report.md",
        "source_bindings": source,
        "exact_spin_and_group_algebra": algebra,
        "orientation_negative_controls": controls,
        "finite_shuffle_controls": shuffles,
        "periodic_taylor_controls": periodic,
        "boundary_taylor_controls": boundary,
        "finite_controls_are_not_an_all_orders_proof": True,
        "jacobian": jacobian_check(),
        "formal_core": lean_check(),
        "unresolved_campaign_obligations": ["C_PERIODIC_FINITE", "C_PERIODIC_PROPAGATION",
                                           "C_BOUNDARY_FINITE", "C_BOUNDARY_PROPAGATION"],
        "false_manuscript_assertions_identified": [],
    }


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--write-certificate", action="store_true",
                        help="Write exact_certificate.json after successful replay.")
    args = parser.parse_args()
    result = verify()
    canonical = json.dumps(result, indent=2) + "\n"
    certificate = HERE / "exact_certificate.json"
    if args.write_certificate:
        certificate.write_text(canonical)
    else:
        require(json.loads(certificate.read_text()) == json.loads(canonical),
                "The saved exact certificate does not match this replay")
    print(json.dumps({"ok": True, "formal_core": result["formal_core"]["main_theorem"],
                      "periodic_parameter_cases": len(result["periodic_taylor_controls"]),
                      "boundary_parameter_cases": len(result["boundary_taylor_controls"]),
                      "ordered_words": sum(record["ordered_words"] for key in
                                           ("periodic_taylor_controls", "boundary_taylor_controls")
                                           for record in result[key]),
                      "independent_review": "pending", "campaign_complete": False}))


if __name__ == "__main__":
    main()
