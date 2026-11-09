#!/usr/bin/env python3
"""Replay the exact core and labelled diagnostics; see report.md for the proof."""

import argparse
import hashlib
import itertools
import json
import math
from fractions import Fraction
from pathlib import Path


ROOT = Path(__file__).resolve().parent


def require(condition, message):
    if not condition:
        raise AssertionError(message)


def polynomial_add(*polynomials):
    size = max(map(len, polynomials))
    return tuple(
        sum(p[i] if i < len(p) else 0 for p in polynomials)
        for i in range(size)
    )


def polynomial_multiply(left, right):
    result = [0] * (len(left) + len(right) - 1)
    for i, a in enumerate(left):
        for j, b in enumerate(right):
            result[i + j] += a * b
    return tuple(result)


def check_parameters(certificate):
    p = certificate["parameters"]
    eps = Fraction(p["epsilon"])
    require(eps > 0 and p["L"] >= 1 and p["B"] >= 1, "positive scale parameters")
    require(p["a"] >= 1 and p["K"] >= 1, "embedding and product envelopes")
    p_power = -Fraction(1, 2) + eps
    d_power = 2 * eps
    require(p_power == Fraction(p["p_exponent"]), "density exponent")
    require(d_power == Fraction(p["D_exponent"]), "triangle degree exponent")
    require(
        p_power + p["L"] * d_power
        == Fraction(p["terminal_scaling_exponent"]) < 0,
        "terminal suffix scaling must be below one asymptotically",
    )
    require(
        p_power + p["B"] * d_power
        == Fraction(p["short_gain_exponent"]) < 0,
        "short-template gain",
    )
    require(
        (p["L"] - p["B"]) * d_power
        == Fraction(p["long_gain_exponent"]) > 0,
        "long-template gain must dominate a fixed polylogarithm",
    )
    require(p["H0"] >= 3 * p["L"] + 1, "template order cap")
    power = 2 + 2 * p["a"] * p["K"]
    require(power == p["coarse_power"], "ordered-sum power")
    require(power - p["B"] == p["coarse_D_exponent"] == -40, "coarse gain")
    require(4 - p["L"] == p["refined_D_exponent_before_polylog"], "refined gain")
    require((power - p["B"] + 1) * d_power < 0, "relative error D times gain")
    require(d_power - 1 < 0, "root-overlap error is o(D^-1)")
    require(certificate["finite_parameter_bound"]["depth_cutoff"] is None, "depth")
    require(
        certificate["finite_parameter_bound"]["conditional_independence_assumed"]
        is False,
        "conditional independence must be proved, not assumed",
    )


def check_symbolic_identities():
    minus_square = polynomial_multiply((1, -1), (1, -1))
    plus_square = polynomial_multiply((1, 1), (1, 1))
    slack = polynomial_add(
        tuple(2 * x for x in minus_square), tuple(-x for x in plus_square)
    )
    require(slack == (1, -6, 1), "off-pattern factor-two slack identity")
    r = Fraction(1, 100)
    decomposition = polynomial_add((1 - 6 * r,), (6 * r, -6), (0, 0, 1))
    require(decomposition == slack, "nonnegative decomposition on [0,1/100]")
    require(1 - 6 * r == Fraction(47, 50) > 0, "strict positive slack")

    # X denotes 2^(n+1); these are polynomial identities, not sampled n.
    candidate_n = (-1, 1)
    next_by_recurrence = polynomial_add(candidate_n, (0, 1))
    candidate_next = (-1, 2)
    require(next_by_recurrence == candidate_next, "fork induction step")
    require(1 == 2 ** (0 + 1) - 1, "fork induction base")
    require(
        polynomial_add((1, 1, 2), (0, -1, -1)) == (1, 0, 1),
        "edges minus non-root internal vertices equals root steps plus forks",
    )


def canonical_rational(value):
    result = Fraction(int(value["num"]), int(value["den"]))
    require(
        str(result.numerator) == value["num"]
        and str(result.denominator) == value["den"],
        "noncanonical typed rational",
    )
    return result


def check_jacobian(certificate):
    meta = certificate["jacobian"]
    payload = json.loads((ROOT / meta["payload"]).read_text())
    response = json.loads((ROOT / meta["typed_result"]).read_text())
    require(meta["adapter_exit_code"] == 0, "adapter failure is not evidence")
    require(meta["error"] is None and meta["timeout"] is False, "adapter status")
    require(response["request"]["operation_id"] == meta["operation_id"], "operation")
    require(response["request"]["payload"] == payload, "exact payload binding")
    require(response["result"]["operation_id"] == meta["operation_id"], "result type")
    require(response["server"]["version"] == "0.14.0", "preserved server version")
    require(response["protocol_version"] == "2025-11-25", "preserved protocol")
    output = response["result"]["output"]
    require(output["polynomial"] == payload["polynomial"], "polynomial binding")
    require(output["box"] == payload["box"], "box binding")
    terms = payload["polynomial"]["polynomial"]["terms"]
    require(
        [(t["exponents"], canonical_rational(t["coefficient"])) for t in terms]
        == [([2], 1), ([1], -6), ([0], 1)],
        "the submitted polynomial must be the off-pattern slack",
    )
    interval = payload["box"]["intervals"][0]
    require(canonical_rational(interval["lower"]) == 0, "box lower endpoint")
    require(canonical_rational(interval["upper"]) == Fraction(1, 100), "box upper")
    lo = canonical_rational(output["enclosure"]["lower"])
    hi = canonical_rational(output["enclosure"]["upper"])
    require([lo, hi] == [Fraction(x) for x in meta["enclosure"]], "exact enclosure")
    require(lo == Fraction(47, 50) > 0 and hi == Fraction(10001, 10000), "slack")
    return {"operation": meta["operation_id"], "enclosure": [str(lo), str(hi)]}


def check_lean(certificate):
    core = certificate["formal_core"]
    source = ROOT / core["source"]
    fidelity = ROOT / core["fidelity"]
    result = json.loads((ROOT / core["compiler_record"]).read_text())
    require(result["status"] == "success", "no successful Lean compilation")
    require(result["exit_code"] == 0, "nonzero compiler exit")
    require(result["proof_holes"] == [], "Lean proof holes")
    require(result["audit_exit_code"] == 0, "axiom audit failed")
    require(not result["environment_failure"], "unverified Lean environment")
    require(core["required_lean_version"] in result["tools"]["lean"]["version"], "Lean")
    require(Path(result["source"]).resolve() == source, "compiled source path")
    require(
        hashlib.sha256(source.read_bytes()).hexdigest() == result["source_sha256"],
        "source changed after its real compiler run",
    )
    require(
        hashlib.sha256(fidelity.read_text().encode()).hexdigest()
        == result["statement_fidelity_sha256"],
        "statement-fidelity document changed after its compiler run",
    )
    text = source.read_text()
    for declaration in core["declarations"]:
        require("theorem " + declaration.rsplit(".", 1)[1] in text, declaration)
    return {
        "version": core["required_lean_version"],
        "exit_code": result["exit_code"],
        "proof_holes": result["proof_holes"],
        "scope": core["scope"],
    }


def edge(a, b):
    require(a != b, "formal loop")
    return tuple(sorted((a, b)))


def pattern(r, h, first, second, choices, endpoint_bits):
    edges = {edge(2 * i, 2 * i + 1) for i in range(r)}
    focus = {i: ((2 * i, 2 * i + 1),) for i in range(r)}
    born = {}
    parent = {}
    backwards = {}
    triangles = set()
    choice = iter(choices)

    def extend(call):
        pick = next(choice)
        ends = focus[call][pick if len(focus[call]) == 2 else 0]
        v = 2 * r + len(born)
        new_call = r + len(born)
        born[new_call] = v
        parent[new_call] = call
        backwards[v] = ends
        edges.update((edge(v, ends[0]), edge(v, ends[1])))
        triangles.add(tuple(sorted((*ends, v))))
        focus[new_call] = ((ends[0], v), (ends[1], v))
        return new_call

    common = 0
    for _ in range(h):
        common = extend(common)
    left = common
    for _ in range(first):
        left = extend(left)
    right = common if r == 1 else 1
    for _ in range(second):
        right = extend(right)
    marks = (
        born[left] if left in born else 2 * left + endpoint_bits[0],
        born[right] if right in born else 2 * right + endpoint_bits[1],
    )
    return edges, born, parent, backwards, triangles, marks


def subsets(vertices):
    items = tuple(sorted(vertices))
    for mask in range(1 << len(items)):
        yield {v for i, v in enumerate(items) if mask & (1 << i)}


def check_patterns(bounds):
    count = {"valid_pattern_instances": 0, "suffixes": 0, "proper_subsets": 0}
    maximum = bounds["maximum_nonroot_calls"]
    for r in (1, 2):
        for ell in range(maximum + 1):
            for h in range(ell + 1) if r == 1 else (0,):
                for first in range(ell - h + 1):
                    second = ell - h - first
                    for choices in itertools.product((0, 1), repeat=ell):
                        for endpoint_bits in itertools.product((0, 1), repeat=2):
                            data = pattern(r, h, first, second, choices, endpoint_bits)
                            edges, born, parent, back, triangles, marks = data
                            if marks[0] == marks[1] or edge(*marks) in edges:
                                continue
                            count["valid_pattern_instances"] += 1
                            vertices = set(range(2 * r + ell))
                            actual_triangles = {
                                vs for vs in itertools.combinations(sorted(vertices), 3)
                                if all(edge(*e) in edges for e in itertools.combinations(vs, 2))
                            }
                            require(actual_triangles == triangles, "non-birth triangle")
                            outdegree = {c: 0 for c in range(r + ell)}
                            for c in born:
                                outdegree[parent[c]] += 1
                            root_steps = sum(outdegree[c] for c in range(r))
                            forks = sum(outdegree[c] == 2 for c in born)
                            leaves = sum(outdegree[c] == 0 for c in born)
                            require(root_steps + forks == leaves <= 2, "root/fork loss")
                            for order in itertools.permutations(born):
                                position = {c: i for i, c in enumerate(order)}
                                if any(
                                    parent[c] in born and position[parent[c]] > position[c]
                                    for c in born
                                ):
                                    continue
                                for length in range(1, min(ell, bounds["maximum_suffix_size"]) + 1):
                                    free = {born[c] for c in order[-length:]}
                                    boundary = {
                                        v for z in free for v in back[z] if v not in free
                                    } | (set(marks) - free)
                                    retained = {
                                        edge(z, v) for z in free for v in back[z]
                                    } | {edge(*marks)}
                                    require(bool(set(marks) & free), "no free mark")
                                    require(len(retained) == 2 * length + 1, "suffix edge count")
                                    require(len(boundary) <= 2 * length + 1, "boundary size")
                                    require(
                                        all(set(e) & free for e in retained),
                                        "an edge is internal to the distinguished set",
                                    )
                                    count["suffixes"] += 1
                                    for u in subsets(free):
                                        if u == free:
                                            continue
                                        count["proper_subsets"] += 1
                                        e_count = sum(set(e) <= boundary | u for e in retained)
                                        require(e_count <= 2 * len(u), "suffix counterexample")
    return count


def is_prefix(left, right):
    return len(left) <= len(right) and right[:len(left)] == left


def check_occurrence_boundaries(depth):
    words = [
        word for length in range(depth + 1)
        for word in itertools.product((0, 1), repeat=length)
    ]
    checked = 0
    for first, second in itertools.product(words, repeat=2):
        selected = {
            word[:length] for word in (first, second)
            for length in range(len(word) + 1)
        }
        boundary = {
            word + (child,) for word in selected for child in (0, 1)
            if word + (child,) not in selected
        }
        for b in boundary:
            require(not any(is_prefix(b, s) for s in selected), "selected coordinate in O")
        for b, c in itertools.combinations(boundary, 2):
            require(not is_prefix(b, c) and not is_prefix(c, b), "overlapping O supports")
        checked += 1
    return checked


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--certificate", type=Path, default=ROOT / "exact_certificate.json")
    args = parser.parse_args()
    certificate = json.loads(args.certificate.read_text())
    check_parameters(certificate)
    check_symbolic_identities()
    jacobian = check_jacobian(certificate)
    lean = check_lean(certificate)
    diagnostics = check_patterns(certificate["diagnostics"])
    diagnostics["occurrence_boundary_instances"] = check_occurrence_boundaries(
        certificate["diagnostics"]["binary_occurrence_depth"]
    )
    for n in range(20):
        require(
            sum(math.comb(s, a) for s in range(n + 1) for a in range(s + 1))
            == 2 ** (n + 1) - 1,
            "finite coefficient diagnostic",
        )
    print(json.dumps({
        "ok": True,
        "exact_algebra": "passed",
        "lean": lean,
        "jacobian": jacobian,
        "bounded_diagnostics_not_universal_proof": diagnostics,
        "probability_proof": "report.md, Sections 1-7; independent review required",
        "independently_certified": False,
    }, indent=2))


if __name__ == "__main__":
    main()
