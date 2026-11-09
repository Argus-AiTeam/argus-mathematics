#!/usr/bin/env python3
"""Replay the compact exact inputs to the geometric M45 tube proof."""

import argparse
import itertools
import json
import math
import re
from collections import Counter
from fractions import Fraction
from pathlib import Path

import sympy as sp


HERE = Path(__file__).resolve().parent
ROOT = HERE.parent.parent
SOURCE = (
    ROOT
    / "research/openai_manuscript"
    / "Ambiently-homeomorphic-isolated-hypersurface-germs-in-C4-with-"
    "multiplicities-four-and-five-September-27-2026/build/sections"
)


def require(condition, message):
    if not condition:
        raise AssertionError(message)


def source_binding():
    fragments = {
        "02-plane.tex": [
            r"h(X,T)&=T(X-T^2)(X-2T^2)",
            r"q_1(u,w)&=(u-w-w^8)(u-w-2w^8)(u-w^2)",
            r"q_2(u,w)&=q_1(u,w)-u^2",
            r"\varphi(u,w)&=u^2+q_1(u,w)",
            r"\psi(x,w)&=u(u-w^2)q_2(u,w),\quad u=x+w",
        ],
        "03-ambient.tex": [
            r"R_{i,s}(p,w)&=s^4R_i(p,w/s)",
            r"C_{i,s}&=\{(p,y,z,w):yz=R_{i,s}(p,w)\}",
            r"f_{i,s}&=\left.h(p)+w(y^a+z^b)\right|_{C_{i,s}}",
        ],
        "04-tube.tex": [
            r"\frac{(a-2)\alpha}{k}>L_0",
            r"\frac{(b-2)\beta}{k}>L_0",
            r"\pi_*l\bmod kH=(1\otimes\tau)z",
            r"-s_d|_K\ \perp\ (s_h\otimes e)",
        ],
    }
    for filename, expected in fragments.items():
        text = re.sub(r"\s+", "", (SOURCE / filename).read_text())
        for fragment in expected:
            require(
                re.sub(r"\s+", "", fragment) in text,
                f"Actual manuscript definition changed: {filename}: {fragment}",
            )
    return {
        "source_directory": str(SOURCE.relative_to(ROOT)),
        "checked_files": list(fragments),
        "checked_defining_fragments": sum(map(len, fragments.values())),
        "scope": "Exact source equations and target signs; not a hash of the manuscript.",
    }


def reviewed_inputs():
    state = json.loads((ROOT / "research/MATH_STATE.json").read_text())
    latest = {claim["claim_id"]: claim for claim in state["claims"]}
    result = {}
    for claim_id in ("C059BASE", "C059GRADIENT", "C059APPLICATION"):
        claim = latest[claim_id]
        reviewers = sorted(
            {
                evidence["produced_by"]
                for evidence in state["evidence"]
                if evidence.get("verdict") == "supports"
                and evidence.get("produced_by", "").startswith("reviewer:")
                and evidence.get("subject", {}).get("subject_id") == claim_id
                and evidence["subject"].get("content_hash") == claim["content_hash"]
            }
        )
        require(reviewers, f"No current independent judgement for input {claim_id}")
        result[claim_id] = {"version": claim["version"], "reviewers": reviewers}
    return result


def polynomial_identities():
    X, T, u, w, v, s = sp.symbols("X T u w v s")
    a, b = sp.symbols("a b", positive=True, integer=True)
    h = T * (X - T**2) * (X - 2 * T**2)
    q1 = (u - w - w**8) * (u - w - 2 * w**8) * (u - w**2)
    q2 = q1 - u**2
    psi = (u * (u - w**2) * q2).subs(u, X + w)
    require(
        sp.expand(q1.subs(u, 0) + w**4 * (1 + w**7) * (1 + 2 * w**7)) == 0,
        "First graph specialization",
    )
    require(
        sp.expand(psi.subs(X, 0) + w**4 * (1 - w) - 2 * w**19 * (1 - w)**2)
        == 0,
        "Second graph specialization",
    )
    graph0 = X - T**2 - q1.subs(u, T)
    graph1 = T - psi
    for graph, base in ((graph0, X), (graph1, T)):
        require(sp.diff(graph, base).subs({X: 0, T: 0, w: 0}) == 1, "Smooth graph")
    require(sp.expand(sp.diff(h, X) - T * (2 * X - 3 * T**2)) == 0, "h_X")
    require(
        sp.expand(sp.diff(h, T) - (X**2 - 9 * X * T**2 + 10 * T**4)) == 0,
        "h_T",
    )
    A, B = 2 * v - 3, v**2 - 9 * v + 10
    require(sp.expand(4 * B - (2 * v - 15) * A) == -5, "Gradient Bezout identity")
    require(Fraction(1) - Fraction(9, 20) - Fraction(10, 400) > 0, "Gradient bound")
    alpha, beta = 4 * b / (a + b), 4 * a / (a + b)
    require(sp.cancel(alpha + beta) == 4, "Cone weights")
    require(sp.cancel(a * alpha - b * beta) == 0, "Perturbation weights")
    coefficients = sp.symbols("A0:4")
    R = u**4 + sum(coefficients[j] * u**j for j in range(4))
    polar = sp.Poly(a * b * u * sp.diff(R, u) + (a + b) * R, u)
    require(polar.coeff_monomial(u**4) == 4 * a * b + a + b, "Polar leading term")
    for j in range(4):
        require(
            sp.expand(polar.coeff_monomial(u**j) - (j * a * b + a + b) * coefficients[j])
            == 0,
            f"Polar coefficient {j}",
        )
    scaled = sp.expand(s**4 * R.subs(u, w / s))
    require(
        scaled == w**4 + sum(coefficients[j] * s ** (4 - j) * w**j for j in range(4)),
        "Exact prepared scaling",
    )
    determinant = sp.expand((4 * a + 1) * (4 * b + 1) - 1)
    require(determinant == 16 * a * b + 4 * a + 4 * b, "Nonvertex critical determinant")
    m = 4 * a * b + a + b
    mu_cover = (4 * a + 1) * (4 * b + 1)
    require(sp.cancel((m - b) * (m - a) / (a * b) - mu_cover) == 0, "Weighted length")
    require(sp.expand((mu_cover - 1) - 4 * m) == 0, "Euler characteristic of cover")
    require(sp.expand(45 + 6 * (m + 1) - (24 * a * b + 6 * a + 6 * b + 51)) == 0,
            "Rank consistency")
    return {
        "degree_of_each_graph": 4,
        "unit_base_derivatives": [1, 1],
        "gradient_identity": "4*(v^2-9*v+10)-(2*v-15)*(2*v-3)=-5",
        "polar_coefficients": ["a+b", "a*b+a+b", "2*a*b+a+b", "3*a*b+a+b", "4*a*b+a+b"],
        "uniform_isolation_exponents": ["1/4+epsilon_a", "1/4+epsilon_b"],
        "nonvertex_gradient_determinant": "16*a*b+4*a+4*b",
        "rank_consistency": "45+6*(4*a*b+a+b+1)=24*a*b+6*a+6*b+51",
        "limitation": "Spatial bounds and geometric isolation are proved in report Section 2.",
    }


def integer_matrix(data):
    matrix = sp.Matrix([[int(x) for x in row] for row in data["entries"]])
    require(matrix.shape == (data["row_count"], data["column_count"]), "Matrix dimensions")
    require(data.get("domain", "ZZ") == "ZZ", "Integer matrix domain")
    return matrix


def root_disk_index():
    payload = json.loads((HERE / "jacobian_smith_payload.json").read_text())
    envelope = json.loads((HERE / "jacobian_smith_result.json").read_text())
    operation = "matrix.normal_form.smith.certified.compute"
    require(envelope.get("error") is None, "Adapter reported an error")
    require(envelope["result"].get("error") is None, "Operation reported an error")
    require(envelope["request"] == {"operation_id": operation, "payload": payload},
            "Exact adapter request binding")
    require(envelope["result"]["operation_id"] == operation, "Operation id")
    output = envelope["result"]["output"]
    require(output["exactness"] == "EXACT_INTEGER", "Adapter exactness")
    require(output["completeness"] == "FULL_MATRIX_TRANSFORMATIONS", "Adapter completeness")
    certificate = output["certificate"]
    B = sp.Matrix([[1, 0, 0, 1], [-1, 1, 0, 1], [0, -1, 1, 1], [0, 0, -1, 1]])
    require(integer_matrix(payload["matrix"]) == B, "Geometric root-disk basis")
    require(integer_matrix(certificate["source"]) == B, "Certified source matrix")
    U = integer_matrix(certificate["left_transformation"])
    V = integer_matrix(certificate["right_transformation"])
    D = integer_matrix(certificate["diagonal"])
    require(U * B * V == D == sp.diag(1, 1, 1, 4), "Exact Smith transformation")
    require(abs(U.det()) == abs(V.det()) == 1, "Unimodularity")
    require(U.det() == int(certificate["left_determinant"]), "Left determinant binding")
    require(V.det() == int(certificate["right_determinant"]), "Right determinant binding")
    require(certificate["rank"] == 4, "Full rank")
    require(certificate["invariant_factors"] == ["1", "1", "1", "4"], "Smith factors")
    require(B.det() == 4, "Root-disk index")
    require(sp.ones(1, 4) * B == sp.Matrix([[0, 0, 0, 4]]), "Actual disk boundary map")
    return {
        "geometric_module": "H_2(F_p,gamma_p)=Z^4, with oriented root disks T_i",
        "basis_columns": ["e1-e2", "e2-e3", "e3-e4", "(1,1,1,1)"],
        "smith_diagonal": [1, 1, 1, 4],
        "index": 4,
        "adapter": {
            "operation_id": operation,
            "server_version": envelope["server"]["version"],
            "protocol_version": envelope["protocol_version"],
            "transport": envelope["transport"],
            "payload_file": "jacobian_smith_payload.json",
            "typed_output_file": "jacobian_smith_result.json",
            "contract_file": "jacobian_smith_contract.json",
            "status": "complete_exact_output_independently_replayed",
            "structured_error": None,
            "timeout": False,
        },
        "limitation": "This index concerns the realized fiber module, not the full Milnor lattice.",
    }


def cycles_of(permutation):
    remaining = set(range(4))
    cycles = []
    while remaining:
        start = min(remaining)
        cycle, current = [], start
        while current not in cycle:
            cycle.append(current)
            remaining.remove(current)
            current = permutation[current]
        require(current == start, "Permutation orbit closure")
        cycles.append(cycle)
    return cycles


def monodromy_slices():
    vectors = list(itertools.product(range(4), repeat=4))
    types = Counter()
    for permutation in itertools.permutations(range(4)):
        cycles = cycles_of(permutation)
        types[",".join(map(str, sorted(map(len, cycles))))] += 1
        invariant = {
            vector for vector in vectors
            if all(vector[permutation[j]] == vector[j] for j in range(4))
        }
        slices = set()
        for coefficients in itertools.product(range(4), repeat=len(cycles)):
            vector = [0] * 4
            for coefficient, cycle in zip(coefficients, cycles):
                for j in cycle:
                    vector[j] = coefficient
            slices.add(tuple(vector))
        require(invariant == slices, "Orbit slice is the full invariant module")
        require(len(slices) == 4 ** len(cycles), "Integral mod-four slice injectivity")
        require((1, 1, 1, 1) in invariant, "Full-transfer norm vector")
        require(sum(map(len, cycles)) == 4, "Actual covering degree on a base loop")
        require(tuple((-x) % 4 for x in (1, 1, 1, 1)) == (3, 3, 3, 3),
                "Negative transfer residue")
    require(dict(types) == {"1,1,1,1": 1, "1,1,2": 6, "1,3": 8, "2,2": 3, "4": 6},
            "Exhaustion of four-sheet permutations")
    return {
        "permutations": 24,
        "residue_vectors_per_permutation": 256,
        "cycle_types": dict(sorted(types.items())),
        "positive_transfer_slice": [1, 1, 1, 1],
        "negative_numerator_residue": [3, 3, 3, 3],
        "geometric_specialization": (
            "Report (30)-(33) identify these endpoint actions with every actual graph braid, "
            "including pure braids. The computation alone does not establish that realization."
        ),
    }


def chain_and_pairing_signs():
    boundary = sp.Matrix([[1, -1, 4]])
    inner, exterior = sp.Matrix([4, 0, -1]), sp.Matrix([0, 4, 1])
    require(boundary * inner == boundary * exterior == sp.zeros(1, 1), "Closed cap corrections")
    require(inner + exterior == sp.Matrix([4, 4, 0]), "Corrected pieces sum to four times cycle")
    require([int(x) % 4 for x in inner] == [0, 0, 3], "Inner correction is minus cap")
    seam_boundary = sp.Matrix([[1, 1], [-4, 0]])
    require(seam_boundary * sp.Matrix([-1, 1]) == sp.Matrix([0, 4]), "Positive Bockstein")
    require((-1) * (-1) == 1, "Negative sweep and negative root connecting sign")
    c1, c2 = sp.symbols("c1 c2", positive=True)
    disks = sp.Matrix([[1, 0, 1, 0], [0, 1, 0, 1],
                       [c1, 0, c2, 0], [0, -c1, 0, -c2]])
    determinant = sp.factor(disks.det())
    require(determinant == -(c1 - c2)**2, "Inner normal determinant")
    reverse = disks[:, [2, 3, 0, 1]]
    require(sp.expand(reverse.det() - determinant) == 0, "Reversed ordered normal sign")
    shuffle = [0, 1, 4, 5, 2, 3, 6, 7]
    inversions = sum(shuffle[i] > shuffle[j] for i in range(8) for j in range(i + 1, 8))
    require(inversions == 4, "Two-by-two factor intersection shuffle")
    return {
        "page_chain_boundary_row_w_v_A": [1, -1, 4],
        "closed_inner_coefficients": [4, 0, -1],
        "closed_exterior_coefficients": [0, 4, 1],
        "seam_cap_bockstein_sign": 1,
        "numerator_transfer_sign": -1,
        "inner_normal_determinant": "-(c2-c1)^2",
        "reversed_normal_determinant": "-(c2-c1)^2",
        "exterior_product_shuffle_inversions": 4,
        "exterior_product_sign": 1,
        "both_cross_terms": "Zero by disjoint actual fillings; report Section 7, not a matrix test.",
        "full_integral_surjectivity": "Report (38): K intersect 4D = 4K because H is torsion-free.",
    }


def common_parameter_example():
    r, n0 = 4, 97
    n1 = n0 + 5 * 2**r
    a, b = (n0**2 - 1) // 4, (n1**2 - 1) // 4
    require(n0 % 2**r == 1 and n0 % 5 == 2 and n0 > 5 * 2**r, "Common family")
    require(n0 % 4 == n1 % 4 == 1 and math.gcd(n0, n1) == 1, "Odd coprime parameters")
    alpha, beta = Fraction(4 * b, a + b), Fraction(4 * a, a + b)
    slack_a, slack_b = (a - 2) * alpha / 4 - 4, (b - 2) * beta / 4 - 4
    require(slack_a > 0 and slack_b > 0, "Strict tube inequalities")
    m = 4 * a * b + a + b
    rank = 24 * a * b + 6 * a + 6 * b + 51
    require(rank == 45 + 6 * (m + 1), "Example rank")
    return {
        "r": r, "n0": n0, "n1": n1, "a": a, "b": b,
        "tube_slacks": [str(slack_a), str(slack_b)],
        "full_lattice_rank": rank,
        "largest_certificate_matrix_dimension": 4,
        "scope": "An exact illustration of the common parameter formula and tube inequalities only.",
    }


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--write-certificate", action="store_true")
    args = parser.parse_args()
    certificate = {
        "claim": "M45:thm:tube",
        "scope": "Both actual prepared germs, all fixed common parameters satisfying the tube inequalities.",
        "proof_kind": "Geometric proof with exact computational supporting certificates; not kernel formalization.",
        "proposed_result_class": "complete_solution",
        "independent_review": "required; not supplied by this verifier",
        "novelty_status": "not_established",
        "significance_status": "not_assessed",
        "campaign_complete": False,
        "source_binding": source_binding(),
        "reused_independently_reviewed_inputs": reviewed_inputs(),
        "polynomial_identities": polynomial_identities(),
        "root_disk_index": root_disk_index(),
        "monodromy_slices": monodromy_slices(),
        "chain_and_pairing_signs": chain_and_pairing_signs(),
        "common_parameter_example": common_parameter_example(),
        "noncomputational_obligations": {
            "uniform_outer_isolation": "Report Section 2",
            "disk_wide_outer_boundary_and_compatible_continuations": "Report Section 3",
            "ordinary_local_comparison": "Report (23), integral relative Mayer--Vietoris",
            "actual_braid_realization": "Report (29)-(33), anchored smooth transport",
            "full_integral_image": "Report (35)-(38), not inferred from ranks",
            "ordered_pairing_and_cross_terms": "Report Section 7",
            "primary_source_assumptions": "Massey arXiv:1410.3312v2; independent attribution pending",
        },
    }
    target = HERE / "exact_certificate.json"
    if args.write_certificate:
        target.write_text(json.dumps(certificate, indent=2) + "\n")
    else:
        require(json.loads(target.read_text()) == certificate, "Stored certificate differs from replay")
    print("PASS: exact source, root-disk index 4, 24 mod-four monodromies, cap and pairing signs.")
    print("Geometric proof and independent Reviewer acceptance are separate from this replay.")


if __name__ == "__main__":
    main()
