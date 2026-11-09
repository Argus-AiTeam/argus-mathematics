#!/usr/bin/env python3
"""Replay exact certificates. This does not certify the universal K=2 conjecture."""

import argparse
import itertools
import json
from fractions import Fraction
from pathlib import Path

import sympy as sp


ROOT = Path(__file__).resolve().parent


def segments(parents):
    result = set()
    for end in range(len(parents)):
        path = []
        vertex = end
        while vertex >= 0:
            path.insert(0, vertex)
            result.add(tuple(path))
            vertex = parents[vertex]
    return sorted(result)


def partitions(parents):
    assert all(parent == -1 or 0 <= parent < vertex
               for vertex, parent in enumerate(parents))
    children = [[v for v, parent in enumerate(parents) if parent == u]
                for u in range(len(parents))]
    result = set()
    for selected in itertools.product(*[[-1] + group for group in children]):
        roots = list(range(len(parents)))
        for u, v in enumerate(selected):
            if v >= 0:
                roots[v] = roots[u]
        result.add(tuple(tuple(v for v, root in enumerate(roots) if root == r)
                         for r in sorted(set(roots))))
    return sorted(result)


def energy(vector, families):
    values = [sum(sum(vector[v] for v in segment) ** 2 for segment in family)
              for family in families]
    maximum = max(values)
    return maximum, families[values.index(maximum)]


def atom_vector(atom, size, allowed):
    vector = [Fraction(0)] * size
    used = set()
    for coefficient, segment in atom:
        assert tuple(segment) in allowed
        assert not used.intersection(segment)
        used.update(segment)
        for vertex in segment:
            vector[vertex] += coefficient
    return vector


def norm_certificate(vector, squared_norm, witness, representation, families, allowed):
    total = [Fraction(0)] * len(vector)
    assert sum(weight for weight, _ in representation) == 1
    serialized_atoms = []
    for weight, atom in representation:
        assert weight >= 0
        coefficient_energy = sum(coefficient ** 2 for coefficient, _ in atom)
        assert coefficient_energy <= squared_norm
        value = atom_vector(atom, len(vector), allowed)
        total = [a + weight * b for a, b in zip(total, value)]
        serialized_atoms.append({
            "weight": str(weight),
            "terms": [{"coefficient": str(c), "segment": list(s)} for c, s in atom],
            "coefficient_energy": str(coefficient_energy),
        })
    assert total == vector
    test_energy, maximizing_family = energy(witness, families)
    pairing = sum(a * b for a, b in zip(vector, witness))
    assert test_energy > 0
    assert pairing ** 2 == squared_norm * test_energy
    return {
        "vector": [str(a) for a in vector],
        "squared_norm": str(squared_norm),
        "convex_atomic_upper_certificate": serialized_atoms,
        "primal_lower_certificate": {
            "test": [str(a) for a in witness],
            "energy": str(test_energy),
            "pairing": str(pairing),
            "maximizing_partition": maximizing_family,
        },
    }


def star_certificate():
    parents = [-1, 0, 0]
    allowed = segments(parents)
    families = partitions(parents)
    assert families == [((0,), (1,), (2,)), ((0, 1), (2,)), ((0, 2), (1,))]
    for mask in itertools.product([False, True], repeat=len(allowed)):
        family = [s for include, s in zip(mask, allowed) if include]
        flattened = [v for segment in family for v in segment]
        if len(set(flattened)) != len(flattened):
            continue
        extension = family + [(v,) for v in range(3) if v not in flattened]
        assert tuple(sorted(extension)) in families
    f = Fraction
    data = {
        "center": ([f(4), f(0), f(0)], f(16), [f(1), f(0), f(0)],
                   [(f(1), [(f(4), (0,))])]),
        "tail": ([f(0), f(3), f(-3)], f(18), [f(0), f(3), f(-3)],
                 [(f(1), [(f(3), (1,)), (f(-3), (2,))])]),
        "plus": ([f(4), f(3), f(-3)], f(25), [f(4), f(0), f(-3)],
                 [(f(3, 4), [(f(4), (0, 1)), (f(-3), (2,))]),
                  (f(1, 4), [(f(4), (0,)), (f(-3), (2,))])]),
        "minus": ([f(4), f(-3), f(3)], f(25), [f(4), f(-3), f(0)],
                  [(f(3, 4), [(f(4), (0, 2)), (f(-3), (1,))]),
                   (f(1, 4), [(f(4), (0,)), (f(-3), (1,))])]),
    }
    results = {
        name: norm_certificate(*entry, families, allowed)
        for name, entry in data.items()
    }
    assert data["plus"][0] == [a + b for a, b in zip(data["center"][0], data["tail"][0])]
    assert data["minus"][0] == [a - b for a, b in zip(data["center"][0], data["tail"][0])]
    assert data["center"][0][1:] == [0, 0]
    assert data["tail"][0][0] == 0
    ratio = data["tail"][1] / (data["plus"][1] - data["center"][1])
    assert ratio == 2
    return {
        "parents": parents, "head": [0], "segments": allowed,
        "all_full_segment_partitions": families,
        "norm_certificates": results, "radius": "5", "lens_ratio": str(ratio),
        "ambient_transfer": "Proved for arbitrary segments in report.md; not a finite simulation.",
    }


def nonzero_head_family():
    q = sp.Symbol("q", positive=True)
    radius = 1 + q ** 2 / 4
    negative_endpoint_head = 1 - q ** 2 / 4
    assert sp.expand(negative_endpoint_head ** 2 + q ** 2 - radius ** 2) == 0
    assert sp.expand(radius - q - (q - 2) ** 2 / 4) == 0
    assert sp.expand(negative_endpoint_head - sp.Rational(3, 4) - (1 - q ** 2) / 4) == 0
    ratio = sp.cancel(q ** 2 / (radius ** 2 - 1))
    assert sp.cancel(ratio - 16 / (8 + q ** 2)) == 0
    assert sp.limit(ratio, q, 0, dir="+") == 2
    return {
        "domain": "0 < q <= 1",
        "center": ["1", "0"],
        "displacement": ["q^2/4", "q"],
        "radius": "1+q^2/4",
        "squared_lens_ratio": "16/(8+q^2)",
        "right_limit_at_zero": "2",
        "norm_identification": "The two-coordinate polar norm formula is proved in report.md.",
    }


def lattice_route_counterexample():
    parents = [-1, 0, 0, 1, 1, 2, 2]
    families = partitions(parents)
    assert len(families) == 27
    potentials = {
        "f": [-2, 4, -1, 3, 1, -4, 4],
        "g": [-2, -3, -2, 2, -2, -3, -1],
    }
    potentials["maximum"] = [max(a, b) for a, b in zip(potentials["f"], potentials["g"])]
    potentials["minimum"] = [min(a, b) for a, b in zip(potentials["f"], potentials["g"])]
    data = {}
    for name, potential in potentials.items():
        increments = [potential[v] - (potential[p] if p >= 0 else 0)
                      for v, p in enumerate(parents)]
        value, family = energy(increments, families)
        data[name] = {
            "potential": potential, "increments": increments,
            "squared_segment_energy": value, "maximizing_partition": family,
        }
    left = data["maximum"]["squared_segment_energy"] + data["minimum"]["squared_segment_energy"]
    right = data["f"]["squared_segment_energy"] + data["g"]["squared_segment_energy"]
    assert (left, right) == (134, 132)
    return {
        "assertion_origin": "Our attempted shortcut, not a staged manuscript assertion.",
        "parents": parents, "partition_count": len(families), "data": data,
        "left": left, "right": right, "refutes_K2": False, "refutes_manuscript": False,
    }


def jacobian_certificate():
    record = json.loads((ROOT / "jacobian_result.json").read_text())
    payload = json.loads((ROOT / "jacobian_payload.json").read_text())
    assert record["adapter_exit_code"] == 0 and record["timeout"] is False
    response = record["typed_response"]
    assert record["payload"] == payload == response["request"]["payload"]
    operation = "polynomial.multivariate.factor.compute"
    assert response["request"]["operation_id"] == operation
    output = response["result"]["output"]
    assert output["status"] == "FACTORIZED"
    assert output["product_reconstruction"] == "EXACT"
    symbols = sp.symbols("r q s t")

    def polynomial(obj):
        assert obj["domain"] == "QQ" and obj["variables"] == ["r", "q", "s", "t"]
        return sum(
            sp.Rational(term["coefficient"]["num"], term["coefficient"]["den"]) *
            sp.prod(x ** exponent for x, exponent in zip(symbols, term["exponents"]))
            for term in obj["polynomial"]["terms"]
        )

    original = polynomial(payload["polynomial"])
    content = output["coefficient"]
    product = sp.Rational(content["num"], content["den"])
    for factor in output["factors"]:
        product *= polynomial(factor["factor"]) ** factor["multiplicity"]
    assert sp.expand(product - original) == 0
    r, q, s, t = symbols
    assert sp.expand(original - (q * s + r * t) ** 2) == 0
    assert sp.expand((r ** 2 + q ** 2) * (s ** 2 + t ** 2) -
                     (r * s - q * t) ** 2 - original) == 0
    return {
        "operation_id": operation, "server": response["server"]["version"],
        "protocol": response["protocol_version"], "adapter_exit_code": 0,
        "timeout": False, "status": output["status"],
        "identity": "(r^2+q^2)(s^2+t^2)-(r*s-q*t)^2=(q*s+r*t)^2",
    }


def build_certificate():
    return {
        "certificate_type": "exact_lower_bound_and_failed_route_certificates",
        "result_class": "partial_result",
        "research_target_level": "publishable",
        "math_objective_mode": "exploratory",
        "goal_status": "unresolved; this certificate is not mission completion",
        "universal_constant": {
            "exact_lower_bound": "2", "manuscript_baseline_upper_bound": "4",
            "universal_upper_bound_proved_by_this_script": False,
            "optimal_constant_determined": False,
        },
        "star": star_certificate(),
        "nonzero_head_family": nonzero_head_family(),
        "scalar_route": {
            "eta": "1", "theta": "0", "squared_triangle_bound": "4",
            "proposed_K2_budget": "2",
            "assertion_origin": "Our attempted shortcut, not a manuscript assertion.",
        },
        "lattice_route": lattice_route_counterexample(),
        "jacobian": jacobian_certificate(),
    }


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--write", action="store_true", help="Write the initial exact certificate.")
    args = parser.parse_args()
    certificate = build_certificate()
    serialized = json.loads(json.dumps(certificate))
    path = ROOT / "exact_certificate.json"
    if args.write:
        path.write_text(json.dumps(serialized, indent=2) + "\n")
    else:
        assert json.loads(path.read_text()) == serialized, "Certificate does not match exact replay."
    print("Exact rooted-star norm certificates and failed-route witnesses verified.")
    print("Universal sharp constant remains unresolved: 2 <= K_star <= 4.")


if __name__ == "__main__":
    main()
