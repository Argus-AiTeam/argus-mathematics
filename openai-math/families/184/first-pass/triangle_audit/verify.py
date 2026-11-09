#!/usr/bin/env python3
"""Replay exact supplementary checks and authenticate the universal Lean core."""

import argparse
from fractions import Fraction as F
import hashlib
import itertools
import json
import math
from pathlib import Path


HERE = Path(__file__).resolve().parent
ROOT = HERE.parent.parent
BASE_WEIGHTS = (F(1, 2), F(1, 3), F(1, 6), F(1, 6), F(1, 6))
BASE_EDGES = {(0, 1), (0, 2), (0, 3), (1, 2), (1, 3), (1, 4), (2, 4)}
OPERATION = "graph.induced_vertex_subset_pattern.count"


def require(condition, message):
    if not condition:
        raise AssertionError(message)


def stats(weights, edges):
    n = len(weights)
    require(all(w > 0 for w in weights), "nonpositive vertex weight")
    require(all(0 <= u < v < n for u, v in edges), "noncanonical simple edge")
    adj = [set() for _ in weights]
    for u, v in edges:
        adj[u].add(v)
        adj[v].add(u)
    common = {}
    for u, v in edges:
        common[u, v] = common[v, u] = sum(
            (weights[z] for z in adj[u] & adj[v]), F(0)
        )
    s = [sum((weights[v] for v in ns), F(0)) for ns in adj]
    h = [
        sum((weights[v] * common[u, v] for v in adj[u]), F(0))
        for u in range(n)
    ]
    M = sum((weights[u] * weights[v] for u, v in edges), F(0))
    T = sum(
        (
            weights[u] * weights[v] * weights[z]
            for u, v, z in itertools.combinations(range(n), 3)
            if (u, v) in edges and (u, z) in edges and (v, z) in edges
        ),
        F(0),
    )
    return M, T, adj, common, s, h


def normalizations(weights, edges):
    M, T, adj, common, s, h = stats(weights, edges)
    require(
        sum((weights[u] * weights[v] * common[u, v] for u, v in edges), F(0))
        == 3 * T,
        "three-edge triangle normalization",
    )
    require(sum((weights[u] * h[u] for u in range(len(weights))), F(0)) == 6 * T,
            "six-directed-edge triangle normalization")
    return M, T, adj, common, s, h


def cross(weights, adj, A, B):
    return sum(
        (weights[u] * weights[v] for u in A for v in adj[u] & B), F(0)
    )


def subsets(n):
    return [
        {i for i in range(n) if mask & (1 << i)}
        for mask in range(1 << n)
    ]


def peeling(weights, edges, tau):
    original_M, original_T, *_ = stats(weights, edges)
    remaining = set(edges)
    loss = F(0)
    removed_mass = F(0)
    steps = []
    while remaining:
        _, _, _, common, _, _ = stats(weights, remaining)
        candidates = [e for e in sorted(remaining) if common[e] < tau]
        if not candidates:
            break
        u, v = candidates[0]
        charge = weights[u] * weights[v] * common[u, v]
        steps.append({"edge": [u, v], "common_mass": str(common[u, v]),
                      "triangle_charge": str(charge)})
        loss += charge
        removed_mass += weights[u] * weights[v]
        remaining.remove((u, v))
    _, final_T, _, common, s, h = stats(weights, remaining)
    require(loss == original_T - final_T, "peeling did not charge first destruction")
    require(loss <= tau * removed_mass <= tau * original_M, "peeling loss bound")
    require(all(c >= tau for c in common.values()), "peeling stopping condition")
    for u in {v for e in remaining for v in e}:
        require(s[u] >= tau and h[u] >= tau * s[u], "peeled walk hypotheses")
    return {"tau": str(tau), "loss": str(loss), "steps": steps}


def matmul(A, B):
    return [
        [sum((a * b for a, b in zip(row, col)), F(0)) for col in zip(*B)]
        for row in A
    ]


def log_term(vector, argument, coefficient):
    if coefficient == 0:
        return
    require(argument > 0, "positive-mass logarithm has nonpositive argument")
    if argument == 1:
        return
    vector[argument] = vector.get(argument, F(0)) + coefficient
    if vector[argument] == 0:
        del vector[argument]


def add_vector(target, source, multiplier=F(1)):
    for argument, coefficient in source.items():
        log_term(target, argument, multiplier * coefficient)


def entropy_vector(row, weights):
    result = {}
    for prob, weight in zip(row, weights):
        if prob:
            log_term(result, weight, prob)
            log_term(result, prob, -prob)
    return result


def divergence_vector(row, mixture):
    result = {}
    for prob, reference in zip(row, mixture):
        if prob:
            require(reference > 0, "mixture excludes a positive-mass component")
            log_term(result, prob, prob)
            log_term(result, reference, -prob)
    return result


def walks():
    M, T, adj, common, s, h = normalizations(BASE_WEIGHTS, BASE_EDGES)
    Z = 6 * T
    x = F(32)
    require(Z > 0, "test walk graph has no triangle")
    require(max(s) <= 1, "uniform C=1 cross certificate failed")
    require(min(common.values()) >= 1 / x, "walk peeling threshold failed")
    mu = {
        (u, v): BASE_WEIGHTS[u] * BASE_WEIGHTS[v] * common[u, v] / Z
        for u in range(5) for v in adj[u]
    }
    require(sum(mu.values(), F(0)) == 1, "directed edge law normalization")
    kernels = 0
    entropy_identities = 0
    for u in range(5):
        ns = sorted(adj[u])
        weights = [BASE_WEIGHTS[v] for v in ns]
        pi = [BASE_WEIGHTS[v] * common[u, v] / h[u] for v in ns]
        P = [
            [BASE_WEIGHTS[y] / common[u, v] if y in adj[v] else F(0) for y in ns]
            for v in ns
        ]
        Q = [
            [(P[i][j] + int(i == j)) / 2 for j in range(len(ns))]
            for i in range(len(ns))
        ]
        require(matmul(P, Q) == matmul(Q, P), "P and Q fail to commute")
        for i, v in enumerate(ns):
            for j, y in enumerate(ns):
                expected = BASE_WEIGHTS[u] * BASE_WEIGHTS[v] * BASE_WEIGHTS[y] / Z
                require(mu[u, v] * P[i][j] == (expected if y in adj[v] else 0),
                        "ordered-triangle law orientation")
        K = P
        for time in range(33):
            kernels += 1
            for i, v in enumerate(ns):
                require(sum(K[i], F(0)) == 1, "nonstochastic walk row")
                for j, y in enumerate(ns):
                    require(0 <= K[i][j] <= x * BASE_WEIGHTS[y], "walk density")
                    require(pi[i] * K[i][j] == pi[j] * K[j][i], "reversibility")
                    require(mu[u, v] * K[i][j] == mu[u, y] * K[j][i],
                            "reverse triple-law exchange")
            next_K = matmul(K, Q)
            require(next_K == matmul(Q, K), "time/row mixture orientation")
            if time < 4:
                lhs = {}
                rhs = {}
                for i in range(len(ns)):
                    add_vector(rhs, entropy_vector(next_K[i], weights), pi[i])
                    add_vector(rhs, entropy_vector(K[i], weights), -pi[i])
                    for j in range(len(ns)):
                        if Q[i][j]:
                            add_vector(
                                lhs, divergence_vector(K[j], next_K[i]),
                                pi[i] * Q[i][j],
                            )
                require(lhs == rhs, "averaged entropy increment log coefficients")
                entropy_identities += 1
            K = next_K
    return {"M": str(M), "T": str(T), "cross_constant": 1,
            "cross_all_real_x_reason": "max neighborhood mass <=1, so e(A,B)<=w(A)<=g_x(w(A))",
            "minimum_common_mass": str(min(common.values())),
            "reversible_kernels": kernels,
            "exact_entropy_increment_identities": entropy_identities}


def splitting():
    projection = (0, 0, 1, 2, 3, 4)
    weights = tuple(BASE_WEIGHTS[u] for u in projection)
    edges = {(0, 2), (0, 3), (1, 4), (2, 3), (2, 4), (2, 5), (3, 5)}
    images = [tuple(sorted((projection[u], projection[v]))) for u, v in edges]
    require(len(set(images)) == len(edges), "projection is not edge injective")
    require(set(images) == BASE_EDGES, "split does not retain exactly the old edges")
    M, T, adj, *_ = normalizations(weights, edges)
    old_M, old_T, old_adj, *_ = normalizations(BASE_WEIGHTS, BASE_EDGES)
    require(M == old_M and T <= old_T, "edge/triangle mass under splitting")
    require(sum(weights, F(0)) > sum(BASE_WEIGHTS, F(0)), "test did not duplicate weight")
    sets = subsets(len(weights))
    for A in sets:
        image_A = {projection[u] for u in A}
        require(sum((BASE_WEIGHTS[u] for u in image_A), F(0))
                <= sum((weights[u] for u in A), F(0)), "image set-weight bound")
        for B in sets:
            image_B = {projection[u] for u in B}
            require(cross(weights, adj, A, B)
                    <= cross(BASE_WEIGHTS, old_adj, image_A, image_B),
                    "directed cross mass under splitting, including overlap")
    return {"M": str(M), "T": str(T), "overlapping_set_pairs": len(sets) ** 2}


def finite_sign_checks():
    weights = (F(1, 2048), F(1, 2), F(1, 3), F(1, 7), F(1, 13))
    cases = 0
    for n in range(6):
        possible = list(itertools.combinations(range(n), 2))
        for mask in range(1 << len(possible)):
            edges = {e for i, e in enumerate(possible) if mask & (1 << i)}
            _, _, _, _, s, _ = normalizations(weights[:n], edges)
            require(max(s, default=F(0)) <= 2, "uniform full cross bound C=2")
            peeling(weights[:n], edges, F(1, 3))
            cases += 1
    require(cases == 1100, "finite graph range changed")
    return {"graphs_of_order_zero_through_five": cases,
            "purpose": "supplementary exact sign and peeling checks, not universal certification"}


def jacobian():
    payload = json.loads((HERE / "jacobian_payload.json").read_text())
    response = json.loads((HERE / "jacobian_result.json").read_text())
    status = json.loads((HERE / "jacobian_status.json").read_text())
    require(status["adapter_exit_code"] == 0, "Jacobian adapter did not complete successfully")
    require(status["operation_id"] == OPERATION, "Jacobian status operation mismatch")
    require(response["request"] == {"operation_id": OPERATION, "payload": payload},
            "Jacobian exact request binding")
    result = response["result"]
    require(result["operation_id"] == OPERATION, "Jacobian result operation mismatch")
    output = result["output"]
    require(output["host"] == payload["host"] and output["pattern"] == payload["pattern"],
            "Jacobian output source binding")
    vertices = [f"{letter}{i}" for letter, count in zip("abcde", (3, 2, 1, 1, 1))
                for i in range(count)]
    expected_edges = sorted(
        [u, v] for u, v in itertools.combinations(vertices, 2)
        if tuple(sorted(("abcde".index(u[0]), "abcde".index(v[0])))) in BASE_EDGES
    )
    require(payload["host"] == {"vertices": vertices, "edges": expected_edges},
            "weighted blow-up source binding")
    require(payload["pattern"] == {"vertices": ["x", "y", "z"],
                                  "edges": [["x", "y"], ["x", "z"], ["y", "z"]]},
            "pattern is not the triangle")
    edges = {tuple(e) for e in expected_edges}
    count = sum(all((u, v) in edges for u, v in itertools.combinations(triple, 2))
                for triple in itertools.combinations(vertices, 3))
    M, T, *_ = stats(BASE_WEIGHTS, BASE_EDGES)
    require(count == int(output["occurrence_count"]) == 14 == 6 ** 3 * T,
            "weighted triangle count normalization")
    require(len(edges) == 19 == 6 ** 2 * M, "weighted edge count normalization")
    return {"operation_id": OPERATION, "server_version": response["server"]["version"],
            "protocol_version": response["protocol_version"], "adapter_exit_code": 0,
            "occurrence_count": count, "transport": response["transport"],
            "payload": "jacobian_payload.json", "typed_output": "jacobian_result.json"}


def lean_core():
    result = json.loads((HERE / "lean_run.json").read_text())
    require(result["status"] == "success" and result["exit_code"] == 0,
            "Lean did not certify the universal core")
    require(result["proof_holes"] == [], "Lean source has proof holes")
    source = (HERE / "Main.lean").read_bytes()
    fidelity = (HERE / "statement_fidelity.md").read_bytes()
    require(result["source_sha256"] == hashlib.sha256(source).hexdigest(),
            "Lean source changed after the compiler run")
    require(result["statement_fidelity_sha256"] == hashlib.sha256(fidelity).hexdigest(),
            "statement fidelity changed after the compiler run")
    require("version 4.31.0," in result["tools"]["lean"]["version"], "wrong Lean version")
    kernel = result["kernel"]
    require(kernel["refusals"] == [] and kernel["recorded"] is not None,
            "compiler result was not recorded in the ledger")
    recorded = kernel["recorded"]
    require(recorded["subject"]["subject_id"] == "C_TRIANGLE_UNIVERSAL_CORE"
            and recorded["tier"] == "mechanical" and recorded["verdict"] == "supports",
            "compiler result attached to the wrong mathematical claim")
    archive_path = ROOT / recorded["artifact"]
    require(archive_path.is_relative_to(HERE), "compiler archive left the owned subtree")
    archive = json.loads(archive_path.read_text())
    require(archive["lean_source"]["text"].encode() == source, "archived source mismatch")
    require(archive["statement_fidelity"]["text"].encode() == fidelity,
            "archived statement-fidelity mismatch")
    require(archive["lean_check"]["status"] == "success"
            and archive["lean_check"]["exit_code"] == 0
            and archive["lean_check"]["proof_holes"] == [],
            "archived compiler verdict mismatch")
    state = json.loads((ROOT / "research/MATH_STATE.json").read_text())
    claims = [c for c in state["claims"] if c["claim_id"] == "C_TRIANGLE_UNIVERSAL_CORE"]
    current = max(claims, key=lambda c: c["version"])
    require(current["content_hash"] == recorded["subject"]["content_hash"],
            "compiler certificate is for a superseded claim")
    require(current["formal_statement"] == source.decode(), "ledger formal text mismatch")
    return {"claim": "C_TRIANGLE_UNIVERSAL_CORE", "lean_version": "4.31.0",
            "exit_code": 0, "proof_holes": [], "archive": recorded["artifact"],
            "scope": "universal algebraic core only; full graph theorem is proved in prose"}


def certificate():
    require(math.factorial(16) < 32 ** 9, "exact x=32 entropy-tail threshold")
    require(tuple(a - b for a, b in zip((1, 3), (5, 3))) == (-4, 0),
            "universal affine bad-pair exponent identity")
    require(tuple(a - b for a, b in zip((2, 1), (6, 1))) == (-4, 0),
            "universal affine exponential-tail exponent identity")
    return {
        "schema_version": 1,
        "result_class": "new_theorem",
        "result_status": "complete_prose_proof_pending_independent_review",
        "novelty_status": "candidate_new_not_independently_verified",
        "research_target_level": "publishable",
        "math_objective_mode": "exploratory",
        "main_claim": "C_POLYLOG_TRIANGLES",
        "universal_statement": {
            "quantifiers": "Every integer p>=1, real C>=1, finite simple graph, and positive vertex-weight vector.",
            "hypothesis": "For every real x>=p and every U,V with w(U),w(V)<=exp(x), e_w(U,V)<=C*w(U)*(x+log^+(1/w(U)))^p, with zero at empty U and overlapping sets allowed.",
            "constants": "E=C^2*42^p+C*2^p; A=3p+7+E; a=18*(A+1); X=(16*a*(p+6))^4.",
            "conclusion": "T<=2*(1+exp(X)/3)*M.",
            "strictness": "For every 1<=q<p, weights 2^(-n),n^p on one edge satisfy exponent p with C=2^p, but require exponent-q constant at least 2^(-q)*n^(p-q) for all integers n>=max(4,p^2).",
            "proof": "proof.md, Sections 1-7; independent review is required.",
        },
        "formal_core": lean_core(),
        "jacobian": jacobian(),
        "exact_checks": {
            "asymmetric_walks": walks(),
            "splitting": splitting(),
            "peeling": [peeling(BASE_WEIGHTS, BASE_EDGES, tau)
                        for tau in (F(1, 6), F(1, 3), F(1, 2), F(1))],
            "finite_sign_checks": finite_sign_checks(),
            "x32_tail_threshold": {"factorial_16": math.factorial(16), "32_power_9": 32 ** 9},
        },
        "limitations": [
            "The complete graph theorem is not fully Lean-formalized.",
            "Finite checks and the bounded Jacobian count are not proofs of universal graph quantifiers.",
            "No literal false manuscript assertion was established; no F_ refutation is warranted.",
            "Neither the optimizer lemma nor the full independence or correspondence-coloring theorem is certified here.",
            "The coloring-specific locality, additive-error, and participation estimates remain open.",
            "Publication significance, novelty, and statement fidelity await the independent Reviewer.",
        ],
    }


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--check", action="store_true",
                        help="also compare the replay to exact_certificate.json")
    args = parser.parse_args()
    result = certificate()
    if args.check:
        recorded = json.loads((HERE / "exact_certificate.json").read_text())
        require(recorded == result, "recorded exact certificate differs from replay")
        print("Exact replay passed; the universal Lean core is current and has no proof holes.")
    else:
        print(json.dumps(result, indent=2, sort_keys=True))


if __name__ == "__main__":
    main()
