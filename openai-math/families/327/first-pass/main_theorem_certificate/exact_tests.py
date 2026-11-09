"""Exact adversarial tests of the new reductions, not of the reviewed walk."""

from collections import defaultdict
from fractions import Fraction as Q
from itertools import product
import json
from pathlib import Path
import subprocess


HERE = Path(__file__).resolve().parent
ARGUS = "$WORKSPACE/argus-live-update/.venv/bin/python"
OPERATION = "probability.markov_chain.stationary_distribution.compute"


def prefix_norm(a):
    total = Q(0)
    value = Q(0)
    for x in a:
        total += x
        value = max(value, abs(total))
    return value


def l1(a):
    return sum(map(abs, a), Q(0))


def subdivision(a, multiplicities):
    return tuple(x / j for x, j in zip(a, multiplicities) for _ in range(j))


def ordered_checks():
    counts = defaultdict(int)
    values = tuple(map(Q, range(-2, 3)))
    for m in range(5):
        for a in product(values, repeat=m):
            for norm in (prefix_norm, l1):
                value = norm(a)
                assert (value == 0) == all(x == 0 for x in a)
                assert all(abs(x) <= 2 * value for x in a)
                counts["definiteness_and_coordinate_bound"] += 1
                spread = tuple(x for coefficient in a for x in (Q(0), coefficient, Q(0)))
                assert norm(spread) == value
                counts["zero_insertion_spreading"] += 1
                for i in range(m - 1):
                    merged = a[:i] + (a[i] + a[i + 1],) + a[i + 2:]
                    assert norm(merged) <= value
                    if a[i] * a[i + 1] >= 0:
                        assert norm(merged) == value
                    counts["arbitrary_sign_merge"] += 1
                    if a[i] + a[i + 1] == 0:
                        counts["zero_sum_merge"] += 1
                for multiplicities in product((1, 3), repeat=m):
                    assert norm(subdivision(a, multiplicities)) == value
                    counts["varying_subdivision"] += 1
    for eta in (Q(1, 1000000), Q(1, 100), Q(1, 2), Q(1), Q(3), Q(7), Q(8), Q(100)):
        delta = min(eta / 7, Q(1))
        assert 0 < delta and (1 + delta) ** 3 <= 1 + eta
        counts["three_embedding_distortion_budget"] += 1
    return dict(counts)


def plus(a, b):
    return tuple(x + y for x, y in zip(a, b))


def minus(a, b):
    return tuple(x - y for x, y in zip(a, b))


def chain_data():
    return (
        {
            "name": "nonfixed_loop_and_fixed_zero",
            "pi": (Q(1),),
            "src": (0, 0, 0), "tgt": (0, 0, 0), "rev": (1, 0, 2),
            "q": (Q(3, 8), Q(3, 8), Q(1, 4)),
            "g": ((Q(1), Q(-2)), (Q(-1), Q(2)), (Q(0), Q(0))),
            "times_and_radii": ((1, 2), (2, 3), (3, 4)),
        },
        {
            "name": "parallel_edges_nonuniform_pi_and_zero_mass_state",
            "pi": (Q(2, 3), Q(1, 3), Q(0)),
            "src": (0, 1, 0, 1, 0, 0, 0, 1, 2),
            "tgt": (1, 0, 1, 0, 0, 0, 0, 1, 2),
            "rev": (1, 0, 3, 2, 5, 4, 6, 7, 8),
            "q": (Q(1, 4), Q(1, 2), Q(1, 8), Q(1, 4),
                  Q(1, 16), Q(1, 16), Q(1, 2), Q(1, 4), Q(1)),
            "g": ((Q(2), Q(-1)), (Q(-2), Q(1)),
                  (Q(-3), Q(4)), (Q(3), Q(-4)),
                  (Q(5), Q(2)), (Q(-5), Q(-2)),
                  (Q(0), Q(0)), (Q(0), Q(0)), (Q(0), Q(0))),
            "times_and_radii": ((1, 2), (2, 3), (3, 4)),
        },
        {
            "name": "no_two_element_orbits",
            "pi": (Q(1), Q(0)),
            "src": (0, 1), "tgt": (0, 1), "rev": (0, 1),
            "q": (Q(1), Q(1)),
            "g": ((Q(0), Q(0)), (Q(0), Q(0))),
            "times_and_radii": ((1, 2), (2, 3), (3, 4)),
        },
    )


def valid_paths(C, n):
    paths = [(s, s, (), C["pi"][s]) for s in range(len(C["pi"]))]
    for _ in range(n):
        paths = [
            (s0, C["tgt"][e], word + (e,), mass * C["q"][e])
            for s0, s, word, mass in paths
            for e in range(len(C["q"])) if C["src"][e] == s
        ]
    return paths


def lift_check(C, n, R):
    pi, src, tgt, rev, q, g = (C[key] for key in ("pi", "src", "tgt", "rev", "q", "g"))
    assert R > n and sum(pi) == 1
    assert all(x >= 0 for x in pi + q)
    for s in range(len(pi)):
        assert sum(q[e] for e in range(len(q)) if src[e] == s) == 1
    for e in range(len(q)):
        assert rev[rev[e]] == e and src[rev[e]] == tgt[e] and tgt[rev[e]] == src[e]
        assert pi[src[e]] * q[e] == pi[tgt[e]] * q[rev[e]]
        assert g[rev[e]] == tuple(-x for x in g[e])
    reps = tuple(e for e in range(len(q)) if e < rev[e])
    displacement = {
        e: tuple(int(e == j) - int(rev[e] == j) for j in reps)
        for e in range(len(q))
    }
    cube = tuple(product(range(-R, R + 1), repeat=len(reps)))
    states = tuple((s, a) for s in range(len(pi)) for a in cube)
    mass = {x: pi[x[0]] / len(cube) for x in states}
    zero = (Q(0), Q(0))

    def potential(a):
        return tuple(sum((a[k] * g[e][i] for k, e in enumerate(reps)), Q(0)) for i in range(2))

    potentials = {a: potential(a) for a in cube}

    def move(s, a, e):
        b = plus(a, displacement[e])
        accepted = all(-R <= x <= R for x in b)
        return ((tgt[e], b) if accepted else (s, a)), accepted

    P = {}
    incoming = defaultdict(Q)
    accepted_count = rejected_count = 0
    for s, a in states:
        row = defaultdict(Q)
        for e in range(len(q)):
            if src[e] != s:
                continue
            y, accepted = move(s, a, e)
            row[y] += q[e]
            increment = minus(potentials[y[1]], potentials[a])
            assert increment == (g[e] if accepted else zero)
            if accepted:
                back, reverse_accepted = move(y[0], y[1], rev[e])
                assert reverse_accepted and back == (s, a)
                assert mass[(s, a)] * q[e] == mass[y] * q[rev[e]]
                accepted_count += 1
            else:
                assert y == (s, a)
                rejected_count += 1
        assert sum(row.values()) == 1
        P[(s, a)] = dict(row)
        for y, probability in row.items():
            incoming[y] += mass[(s, a)] * probability
    assert all(incoming[x] == mass[x] for x in states)
    assert sum(mass.values()) == 1
    paths = valid_paths(C, n)
    assert sum(row[3] for row in paths) == 1
    inner = tuple(product(range(-(R - n), R - n + 1), repeat=len(reps)))
    alpha = Q(len(inner), len(cube))
    assert alpha == Q(2 * (R - n) + 1, 2 * R + 1) ** len(reps)
    central_paths = 0
    for a in inner:
        for s0, _, word, _ in paths:
            s, b = s0, a
            label_sum = zero
            for e in word:
                (s, b), accepted = move(s, b, e)
                assert accepted
                label_sum = plus(label_sum, g[e])
            assert minus(potentials[b], potentials[a]) == label_sum
            central_paths += 1
    powers = (1, 2)
    norms = (prefix_norm, l1)
    base_costs = {}
    for ni, norm in enumerate(norms):
        for p in powers:
            base_costs[(ni, p)] = sum(
                weight * norm(tuple(sum((g[e][i] for e in word), Q(0)) for i in range(2))) ** p
                for _, _, word, weight in paths
            )
    lifted_costs = defaultdict(Q)
    one_step_costs = defaultdict(Q)
    for x in states:
        if mass[x] == 0:
            continue
        law = {x: Q(1)}
        for t in range(n):
            next_law = defaultdict(Q)
            for y, probability in law.items():
                for z, transition in P[y].items():
                    next_law[z] += probability * transition
            law = dict(next_law)
            if t == 0:
                for y, probability in law.items():
                    difference = minus(potentials[y[1]], potentials[x[1]])
                    for ni, norm in enumerate(norms):
                        value = norm(difference)
                        for p in powers:
                            one_step_costs[(ni, p)] += mass[x] * probability * value ** p
        assert sum(law.values()) == 1
        for y, probability in law.items():
            difference = minus(potentials[y[1]], potentials[x[1]])
            for ni, norm in enumerate(norms):
                value = norm(difference)
                for p in powers:
                    lifted_costs[(ni, p)] += mass[x] * probability * value ** p
    comparisons = []
    for ni, norm in enumerate(norms):
        for p in powers:
            edge_cost = sum(pi[src[e]] * q[e] * norm(g[e]) ** p for e in range(len(q)))
            base_cost = base_costs[(ni, p)]
            lifted = lifted_costs[(ni, p)]
            one = one_step_costs[(ni, p)]
            assert alpha * base_cost <= lifted and one <= edge_cost
            comparisons.append({
                "norm": norm.__name__, "p": p, "base_n_cost": str(base_cost),
                "lifted_n_cost": str(lifted), "base_one_step_cost": str(edge_cost),
                "lifted_one_step_cost": str(one),
            })
    return {
        "chain": C["name"], "n": n, "R": R, "orbits": len(reps),
        "lifted_states": len(states), "alpha": str(alpha),
        "accepted_mark_checks": accepted_count, "rejected_mark_checks": rejected_count,
        "central_path_checks": central_paths, "comparisons": comparisons,
    }


def rational_wire(x):
    return {"num": str(x.numerator), "den": str(x.denominator)}


def jacobian_payload():
    matrix = [[Q(0) for _ in range(5)] for _ in range(5)]
    for i in range(5):
        matrix[i][i] += Q(1, 4)
        for delta in (-1, 1):
            j = i + delta
            matrix[i][j if 0 <= j < 5 else i] += Q(3, 8)
    return {"matrix": [[rational_wire(x) for x in row] for row in matrix]}


def run_jacobian():
    payload = jacobian_payload()
    payload_path = HERE / "jacobian_payload.json"
    payload_path.write_text(json.dumps(payload, indent=2) + "\n")
    command = [ARGUS, "-m", "argus_skill.tools.jacobian", "run",
               "--operation", OPERATION, "--payload-file", str(payload_path)]
    result = subprocess.run(command, cwd=HERE.parent.parent, capture_output=True, text=True)
    (HERE / "jacobian_result.json").write_text(result.stdout)
    status = {
        "operation_id": OPERATION, "command": command,
        "exit_code": result.returncode, "stderr": result.stderr,
        "scope": "five-state reflecting lattice lift of one odd self-loop pair and a fixed zero loop",
        "conclusion": "not yet replayed" if result.returncode == 0 else "adapter error; no mathematical conclusion",
    }
    (HERE / "jacobian_status.json").write_text(json.dumps(status, indent=2) + "\n")
    if result.returncode:
        raise RuntimeError(f"Jacobian adapter failed: {status}")
    return replay_jacobian()


def replay_jacobian():
    payload = json.loads((HERE / "jacobian_payload.json").read_text())
    assert payload == jacobian_payload()
    status = json.loads((HERE / "jacobian_status.json").read_text())
    if status["exit_code"] != 0:
        raise RuntimeError("The adapter did not complete successfully; no mathematical conclusion")
    result = json.loads((HERE / "jacobian_result.json").read_text())
    typed = result["result"]
    if typed.get("operation_id") != OPERATION or "output" not in typed:
        raise RuntimeError(f"Jacobian returned a non-result: {typed}")
    value = typed["output"]
    if not value["unique"] or len(value["extreme_distributions"]) != 1:
        raise RuntimeError("Expected the unique stationary distribution of this reflecting chain")
    pi = tuple(Q(int(x["num"]), int(x["den"]))
               for x in value["extreme_distributions"][0]["distribution"])
    matrix = tuple(tuple(Q(int(x["num"]), int(x["den"])) for x in row) for row in payload["matrix"])
    assert pi == (Q(1, 5),) * 5
    assert all(sum(pi[i] * matrix[i][j] for i in range(5)) == pi[j] for j in range(5))
    assert all(pi[i] * matrix[i][j] == pi[j] * matrix[j][i] for i in range(5) for j in range(5))
    status["conclusion"] = "exact output independently replayed for the five-state example only"
    (HERE / "jacobian_status.json").write_text(json.dumps(status, indent=2) + "\n")
    return {
        "operation_id": OPERATION, "server": result["server"],
        "protocol_version": result["protocol_version"], "adapter_exit_code": status["exit_code"],
        "stationary_distribution": [str(x) for x in pi],
        "scope": status["scope"],
    }


def exact_checks():
    return {
        "classification": "bounded exact adversarial experiments; not a universal proof",
        "ordered_norm": ordered_checks(),
        "lattice_lift": [lift_check(C, n, R) for C in chain_data() for n, R in C["times_and_radii"]],
        "jacobian": replay_jacobian(),
    }
