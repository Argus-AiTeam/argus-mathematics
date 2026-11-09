#!/usr/bin/env python3
"""Replay exact nilpotent models; check the separately compiled general theorem."""

import argparse
import hashlib
import itertools
import json
from pathlib import Path


HERE = Path(__file__).resolve().parent


def mul(a, b):
    return ((a & 1) & (b & 1)) | (
        (((a & 1) & (b >> 1)) ^ ((a >> 1) & (b & 1))) << 1
    )


class Group:
    def __init__(self, name, elements, product, residual):
        self.name = name
        self.elements = tuple(elements)
        index = {x: i for i, x in enumerate(self.elements)}
        self.table = [[index[product(x, y)] for y in self.elements] for x in self.elements]
        self.n = len(self.elements)
        self.e = next(i for i in range(self.n) if all(
            self.table[i][j] == j == self.table[j][i] for j in range(self.n)))
        self.inv = [next(j for j in range(self.n)
                         if self.table[i][j] == self.e == self.table[j][i])
                    for i in range(self.n)]
        self.res = [residual(x) for x in self.elements]
        for a, b, c in itertools.product(range(self.n), repeat=3):
            assert self.table[self.table[a][b]][c] == self.table[a][self.table[b][c]]
        for a, b in itertools.product(range(self.n), repeat=2):
            assert self.res[self.table[a][b]] == d3mul(self.res[a], self.res[b])

    def product(self, *args):
        out = self.e
        for x in args:
            out = self.table[out][x]
        return out

    def power(self, x, n):
        return self.product(*([x] * n))

    def conjugate(self, a, b):
        return self.product(a, b, self.inv[a])

    def classes(self):
        remaining = set(range(self.n))
        out = []
        while remaining:
            a = min(remaining)
            cls = sorted({self.conjugate(g, a) for g in range(self.n)})
            remaining.difference_update(cls)
            out.append(cls)
        return out


def d3mul(a, b):
    j, i = a
    l, k = b
    return (j ^ l, (k + i if not l else k - i) % 3)


def compose(p, q):
    return tuple(p[q[i]] for i in range(len(p)))


def perm_residual(p):
    lookup = {
        tuple((x + i) % 3 for x in range(3)): (0, i) for i in range(3)
    }
    lookup.update({
        tuple((-x - i) % 3 for x in range(3)): (1, i) for i in range(3)
    })
    assert len(lookup) == 6
    return lookup[p]


PARTITIONS = (
    frozenset((frozenset((0, 1)), frozenset((2, 3)))),
    frozenset((frozenset((0, 2)), frozenset((1, 3)))),
    frozenset((frozenset((0, 3)), frozenset((1, 2)))),
)


def s4_residual(p):
    return perm_residual(tuple(PARTITIONS.index(frozenset(
        frozenset(p[x] for x in pair) for pair in partition))
        for partition in PARTITIONS))


def quaternion_product(a, b):
    axis = ((0, 1, 2, 3), (1, 0, 3, 2), (2, 3, 0, 1), (3, 2, 1, 0))
    negative = ((0, 0, 0, 0), (0, 1, 0, 1), (0, 1, 1, 0), (0, 0, 1, 1))
    i, j = a % 4, b % 4
    sign = (a // 4) ^ (b // 4) ^ negative[i][j]
    return axis[i][j] + 4 * sign


def quaternion_action(q, i):
    axis = q % 4
    return (0 if axis == 0 else (axis - 1 + i) % 3 + 1) + 4 * (q // 4)


def models():
    yield Group("C3_x_C4", itertools.product(range(3), range(4)),
                lambda a, b: ((a[0] + b[0]) % 3, (a[1] + b[1]) % 4),
                lambda a: (0, a[0]))
    yield Group("C3_semidirect_C4", itertools.product(range(3), range(4)),
                lambda a, b: ((a[0] + (-1) ** a[1] * b[0]) % 3,
                              (a[1] + b[1]) % 4),
                lambda a: (a[1] % 2, ((-1) ** a[1] * a[0]) % 3))
    for degree, name, even in [(3, "S3_x_C2", False), (4, "A4_x_C2", True),
                                (4, "S4_x_C2", False)]:
        perms = list(itertools.permutations(range(degree)))
        if even:
            perms = [p for p in perms if sum(p[i] > p[j] for i in range(degree)
                                            for j in range(i + 1, degree)) % 2 == 0]
        residual = perm_residual if degree == 3 else s4_residual
        yield Group(name, itertools.product(perms, range(2)),
                    lambda a, b: (compose(a[0], b[0]), a[1] ^ b[1]),
                    lambda a: residual(a[0]))
    yield Group("SL2_F3_x_C2", itertools.product(range(8), range(3), range(2)),
                lambda a, b: (quaternion_product(a[0], quaternion_action(b[0], a[1])),
                              (a[1] + b[1]) % 3, a[2] ^ b[2]),
                lambda a: (0, a[1]))


def square_quotient(group):
    kernel = [g for g in range(group.n) if group.res[g] == (0, 0)]
    generators = {group.power(g, 2) for g in kernel}
    squares = {group.e}
    todo = [group.e]
    while todo:
        a = todo.pop()
        for b in generators:
            c = group.table[a][b]
            if c not in squares:
                squares.add(c)
                todo.append(c)
    assert squares.issubset(kernel)
    assert all(group.conjugate(g, a) in squares for g in range(group.n) for a in squares)
    qmap = {}
    reps = []
    for g in range(group.n):
        if g in qmap:
            continue
        i = len(reps)
        reps.append(g)
        for a in squares:
            qmap[group.table[g][a]] = i
    quotient = Group(group.name + "/kernel-squares", range(len(reps)),
                     lambda a, b: qmap[group.table[reps[a]][reps[b]]],
                     lambda a: group.res[reps[a]])
    assert all(quotient.power(g, 2) == quotient.e for g in range(quotient.n)
               if quotient.res[g] == (0, 0))
    h = [g for g in range(quotient.n) if quotient.res[g] == (0, 0)]
    assert all(quotient.table[a][b] == quotient.table[b][a] for a in h for b in h)
    return squares, reps, qmap, quotient


def replay_character(group, trace, quotient_data):
    squares, reps, qmap, q = quotient_data
    assert all(trace[group.table[g][a]] == trace[g]
               for g in range(group.n) for a in squares)
    v = [trace[g] for g in reps]
    g = next(g for g in range(q.n) if q.res[g] == (0, 1))
    R = q.power(g, 4)
    assert q.res[R] == (0, 1) and q.power(R, 3) == q.e
    assert v[R] == v[q.power(R, 2)] == 1
    simple = [g for g in range(q.n) if q.res[g] == (1, 0)]
    s = q.e
    if simple:
        x = simple[0]
        a = q.product(x, R, q.inv[x], R)
        b = q.product(q.inv[R], a, R)
        s = q.product(b, x)
        assert q.res[s] == (1, 0)
        assert q.conjugate(s, R) == q.inv[R]
        assert v[q.product(q.power(s, 2), R)] == 1
    else:
        assert all(j == 0 for j, _ in q.res)
    alpha = []
    for g in range(q.n):
        j, i = q.res[g]
        section = q.power(R, i)
        if j:
            section = q.product(s, section)
        assert q.res[section] == q.res[g]
        a = q.product(g, q.inv[section])
        assert q.res[a] == (0, 0)
        alpha.append(v[q.product(a, R)])
    assert all(mul(a, a) == 1 for a in alpha)
    assert all(alpha[q.table[a][b]] == mul(alpha[a], alpha[b])
               for a, b in itertools.product(range(q.n), repeat=2))
    assert all(alpha[qmap[g]] == trace[g] for g in range(group.n)
               if group.res[g][0] == 0 and group.res[g][1] != 0)


def audit_model(group):
    classes = group.classes()
    domains = []
    for cls in classes:
        j, i = group.res[cls[0]]
        domains.append((0,) if (j, i) == (0, 0) else (0, 2) if j else (1, 3))
    pairs = [(a, b, group.table[a][b], group.table[a][group.inv[b]])
             for a, b in itertools.product(range(group.n), repeat=2)]
    quotient_data = square_quotient(group)
    roots = [g for g in range(group.n) if group.res[g][0] == 0 and group.res[g][1] != 0]
    simples = [g for g in range(group.n) if group.res[g][0] == 1]
    kernel = [g for g in range(group.n) if group.res[g] == (0, 0)]
    count = matching = nontrivial = nonzero_simple = 0
    profiles = set()
    for values in itertools.product(*domains):
        trace = [0] * group.n
        for cls, value in zip(classes, values):
            for g in cls:
                trace[g] = value
        if not all(mul(trace[a], trace[b]) == (trace[c] ^ trace[d])
                   for a, b, c, d in pairs):
            continue
        assert trace[group.e] == 0
        assert all(trace[g] == 0 for g in kernel)
        assert all(mul(trace[g], trace[g]) == 1 for g in roots)
        assert all(mul(trace[a], trace[b]) == 0 for a in simples for b in simples)
        replay_character(group, trace, quotient_data)
        count += 1
        matching += all(trace[g] == 0 for g in simples)
        nontrivial += any(trace[g] == 3 for g in roots)
        nonzero_simple += any(trace[g] == 2 for g in simples)
        profiles.add(tuple(trace[g] for g in roots))
    return {
        "group": group.name,
        "order": group.n,
        "conjugacy_classes": len(classes),
        "candidate_class_functions": 2 ** sum(len(d) == 2 for d in domains),
        "valid_opposite_traces": count,
        "valid_matching_traces": matching,
        "traces_with_nontrivial_root_units": nontrivial,
        "traces_with_nonzero_simple_values": nonzero_simple,
        "distinct_root_profiles": len(profiles),
        "kernel_square_subgroup_order": len(quotient_data[0]),
        "kernel_nonabelian": any(group.table[a][b] != group.table[b][a]
                                 for a in kernel for b in kernel),
        "kernel_rotation_action_nontrivial": any(group.conjugate(g, h) != h
                                                 for g in roots for h in kernel),
        "simple_order_four_exists": any(group.power(g, 4) == group.e
                                         and group.power(g, 2) != group.e for g in simples),
    }


def replay_jacobian():
    payload = json.loads((HERE / "jacobian-payload.json").read_text())
    output = json.loads((HERE / "jacobian-output.json").read_text())
    assert output["request"]["payload"] == payload
    assert output["protocol_version"] == "2025-11-25"
    assert output["server"]["version"] == "0.14.0"
    result = output["result"]
    assert result["operation_id"] == "crossed_product.multiply.compute"
    assert result["output"]["left"] == payload["left"]
    assert result["output"]["right"] == payload["right"]
    presentation = payload["left"]["presentation"]
    assert presentation == payload["right"]["presentation"]
    assert presentation["characteristic"] == 2
    assert presentation["lattice_basis"] == []
    table = presentation["quotient_multiplication"]
    labels = presentation["cosets"]
    coefficients = {x: 0 for x in labels}
    for a in payload["left"]["terms"]:
        for b in payload["right"]["terms"]:
            c = table[labels.index(a["coset"])][labels.index(b["coset"])]
            coefficients[c] ^= (a["coefficient"] * b["coefficient"]) % 2
    assert all(c == 0 for c in coefficients.values())
    assert result["output"]["product"]["terms"] == []
    return {"operation_id": result["operation_id"], "adapter_exit_code": 0,
            "server_version": output["server"]["version"],
            "protocol_version": output["protocol_version"],
            "structured_error": None, "timeout": False,
            "conclusion": "(1+s)^2=0 in F2[C2]; diagnostic, not the general proof"}


def check_formal_record():
    result = json.loads((HERE / "lean_check.json").read_text())
    assert result["status"] == "success"
    assert result["exit_code"] == 0
    assert result["proof_holes"] == []
    assert result["audit_exit_code"] == 0
    assert result["source_sha256"] == hashlib.sha256((HERE / "Main.lean").read_bytes()).hexdigest()
    note = (HERE / "statement-fidelity.md").read_text()
    assert result["statement_fidelity_sha256"] == hashlib.sha256(note.encode()).hexdigest()
    assert Path(result["statement_fidelity"]).read_text() == note


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--emit", action="store_true", help="emit freshly computed replay data")
    args = parser.parse_args()
    for a, b, c in itertools.product(range(4), repeat=3):
        assert mul(mul(a, b), c) == mul(a, mul(b, c))
        assert mul(a, b ^ c) == (mul(a, b) ^ mul(a, c))
        assert mul(a, b) == mul(b, a)
    assert 2 != 0 and mul(2, 2) == 0 and 3 != 1 and mul(3, 3) == 1
    data = {
        "claim_id": "V_TRACE_CHARACTER",
        "result_class": "new_theorem",
        "result_kind": "general_formal_verification",
        "novelty_status": "not_assessed",
        "independent_review": "pending",
        "theorem": "RootCharacter.root_character_of_class",
        "formal_source": "Main.lean",
        "statement_fidelity": "statement-fidelity.md",
        "generality": "Arbitrary groups mapping to D3 with a rotation in the image; any commutative characteristic-two ring, without a reducedness hypothesis.",
        "finite_replay_scope": "All class functions with the prescribed trace domains into F2[epsilon]/(epsilon^2) on the six explicit groups below. These finite checks are not a proof of the general assertion.",
        "arithmetic_scope": "The finite unramified Galois quotient and the modular trace identities are inputs, not verified arithmetic conclusions.",
        "models": [audit_model(group) for group in models()],
        "jacobian": replay_jacobian(),
    }
    if args.emit:
        print(json.dumps(data, indent=2))
        return
    expected = json.loads((HERE / "exact_certificate.json").read_text())
    assert data == expected, "Exact replay differs from the certificate."
    check_formal_record()
    print(json.dumps({"status": "pass", "models": len(data["models"]),
                      "valid_traces_replayed": sum(m["valid_opposite_traces"] for m in data["models"]),
                      "general_proof": data["theorem"], "proof_holes": []}))


if __name__ == "__main__":
    main()
