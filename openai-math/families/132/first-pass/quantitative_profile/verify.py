#!/usr/bin/env python3
"""Exact arithmetic for the four-profile transfer and its Boolean seed."""

import argparse
import hashlib
import json
import re
from fractions import Fraction
from itertools import combinations
from pathlib import Path
from random import Random

import sympy as sp


ROOT = Path(__file__).resolve().parent


def transfer(vector, m, r):
    s0, s1, j0, j1 = vector
    return (
        16 * s0 + s1 + 3 * j1,
        m * m * s0 + r * s1,
        16 * s0 + 3 * j1,
        m * m * j0 + r * s1,
    )


def profiles(d):
    assert d >= 2 and d % 2 == 0
    m = 16 * 3**d
    r = 4 * 3 ** (d // 2)
    assert r * r == m
    rows = [(d + 2, (d + 2) * m, 0, 0)]
    for _ in range(d):
        rows.append(transfer(rows[-1], m, r))
    return m, r, rows


def rational(value):
    value = Fraction(value)
    return {"num": str(value.numerator), "den": str(value.denominator)}


def seed_certificate():
    d = 20
    m, r, rows = profiles(d)
    a = 36 * m**21
    b = m * m * (2 * m * m + 1) ** d
    assert m * rows[-1][0] <= a
    assert rows[-1][1] <= a
    assert b > 1 and b**80 >= a**161
    assert 3**16 < m**20
    return {
        "d": d,
        "L": d + 2,
        "M": m,
        "r": r,
        "k": 2 * m * m + 1,
        "A": str(a),
        "B": str(b),
        "transfer_order": ["S0", "S1", "J0", "J1"],
        "exact_transfer_rows": [[str(v) for v in row] for row in rows],
        "balanced_transfer_over_M21": rational(
            Fraction(max(m * rows[-1][0], rows[-1][1]), m**21)
        ),
        "sensitivity_seed_bound": "max(M*S_{20,0},S_{20,1}) <= 36*M^21",
        "integer_exponent_inequality": "B^80 >= A^161",
        "label_existence_inequality": "3^16 < M^20",
        "interpretation": (
            "Exact recurrence majorants, not an enumeration of all Boolean inputs. "
            "The report proves why they bound the actual raw-bit profiles."
        ),
    }


def previous_family_comparison():
    assert 2 + Fraction(1, 81**2) < Fraction(17, 8)
    checked = []
    for d in range(1, 38):
        assert 17 ** (80 * d) < (
            8 ** (80 * d) * (2 * (d + 2)) ** 161 * 9 ** ((d + 1) ** 2)
        )
        checked.append(d)
    assert 2 * 39**2 >= 80 * 38
    assert 4 * 38 - 74 > 0
    return {
        "finite_depths": checked,
        "finite_inequality": "(17/8)^(80d) < (2(d+2))^161 * 9^((d+1)^2)",
        "tail": (
            "For d>=38, 2(d+1)^2>=80d; its increment is 4d-74>0. "
            "Use 2+M^-2<3 and M>=9^(d+1)."
        ),
        "conclusion": (
            "For every d>=1 and M>=9^(d+1), the manuscript's explicit B^80<A^161."
        ),
    }


def jacobian_payload():
    m, r, rows = profiles(20)
    coefficients = [16 + r, 4 * m * m - 16 * r, 0, -3 * m**4]
    return {
        "coefficient_convention": "A_N_EQUALS_SUM_C_J_TIMES_A_N_MINUS_J_FOR_J_FROM_1",
        "coefficients": [rational(v) for v in coefficients],
        "initial_values": [rational(row[1]) for row in rows[:4]],
        "scope": "PREFIX",
        "term_count": 21,
        "indices": [],
    }


def symbolic_uniform_certificate():
    p, q, m, r, x, n, y = sp.symbols("p q M r X n y")
    matrix = sp.Matrix([[p, 1, 0, 3], [1, q, 0, 0], [p, 0, 0, 3], [0, q, 1, 0]])
    expected_square = sp.Matrix(
        [
            [1 + p**2, p + 4 * q, 3, 3 * p],
            [p + q, 1 + q**2, 0, 3],
            [p**2, p + 3 * q, 3, 3 * p],
            [p + q, q**2, 0, 3],
        ]
    )
    assert matrix**2 == expected_square
    polynomial = x**4 - (p + q) * x**3 + (p * q - 4) * x**2 + 3
    assert sp.expand(matrix.charpoly(x).as_expr() - polynomial) == 0
    assert (
        matrix**4 - (p + q) * matrix**3 + (p * q - 4) * matrix**2 + 3 * sp.eye(4)
    ).applyfunc(sp.expand) == sp.zeros(4)
    raw_matrix = sp.Matrix(
        [[16, 1, 0, 3], [m**2, r, 0, 0], [16, 0, 0, 3], [0, r, m**2, 0]]
    )
    raw_polynomial = x**4 - (16 + r) * x**3 + (16 * r - 4 * m**2) * x**2 + 3 * m**4
    assert sp.expand(raw_matrix.charpoly(x).as_expr() - raw_polynomial) == 0
    diagonal = sp.diag(1, m, 1, m)
    normalized_raw = m * diagonal * matrix.subs({p: 16 / m, q: r / m}) * diagonal.inv()
    assert (normalized_raw - raw_matrix).applyfunc(sp.simplify) == sp.zeros(4)
    cover_residues = {
        "ordinary_second_row": (p**2 + 3 * q - q**2, p**2 + q * (1 - q) + 2 * q),
        "joint_zero_row": (2 * p - p**2 + 3 * q**2, p * (1 - p) + p + 3 * q**2),
    }
    for lhs, rhs in cover_residues.values():
        assert sp.expand(lhs - rhs) == 0
    gap_identity = (
        y * (1 + x) * (1 - (n + 1) * x)
        - (y * (1 - n * x) - y * (n + 1) * x**2)
    )
    assert sp.expand(gap_identity) == 0
    assert sp.expand(3 * 9 * (n + 3) - 9 * (n + 4)) == 18 * n + 45
    assert Fraction(16, 108) <= Fraction(1, 6)
    assert Fraction(1, 6) + Fraction(1, 30) == Fraction(1, 5)
    assert Fraction(1, 6) + 6 <= 7
    assert Fraction(17, 4) <= 7
    assert Fraction(144, 127) + Fraction(81, 101) == Fraction(24831, 12827) < 2
    base_cases = {}
    for h in (1, 2):
        d = 2 * h
        parameter, _, rows = profiles(d)
        terminal = max(
            Fraction(rows[-1][b], (d + 2) * parameter ** (d + b)) for b in (0, 1)
        )
        assert terminal <= 2
        base_cases[str(h)] = rational(terminal)
    return {
        "normalized_matrix": [[str(v) for v in matrix.row(i)] for i in range(4)],
        "two_step_matrix": [[str(v) for v in expected_square.row(i)] for i in range(4)],
        "characteristic_polynomial": str(polynomial),
        "raw_characteristic_polynomial": str(raw_polynomial),
        "envelope": {
            "alpha": "p+p^2+4q",
            "beta": "9+3p",
            "gamma": "p+q+q^2",
            "delta": "3+p",
            "weighted_quantity": "v_j+(gamma/2)*u_j",
            "growth_bound": "(gamma/2)*(3+7q)^j",
            "ordinary_bound": "(1+17q/4)^j+3q*(3+7q)^j",
        },
        "induction_domain": "h>=3, q=1/(4*3^h), p=16q^2",
        "depth_budget": "9h<=3^h, hq<=1/36, q*3^h=1/4",
        "terminal_upper_bound": rational(Fraction(24831, 12827)),
        "small_depths": base_cases,
        "proof_kind": "symbolic induction identities, with universal quantifiers checked by Lean",
    }


def jacobian_certificate():
    payload = json.loads((ROOT / "jacobian_payload.json").read_text())
    record = json.loads((ROOT / "jacobian_output.json").read_text())
    invocation = json.loads((ROOT / "jacobian_invocation.json").read_text())
    assert payload == jacobian_payload()
    assert invocation["adapter_exit_code"] == 0
    assert invocation["timeout"] is False
    assert record.get("error") is None
    assert record["request"]["payload"] == payload
    assert record["server"]["version"] == "0.14.0"
    assert record["protocol_version"] == "2025-11-25"
    result = record["result"]
    assert result["operation_id"] == "combinatorics.recurrence.linear.evaluate"
    output = result["output"]
    assert output["exactness"] == "EXACT_RATIONAL"
    assert output["determinism"] == "DETERMINISTIC"
    assert output["replay_scope_end"] == 20
    _, _, rows = profiles(20)
    expected = [rational(row[1]) for row in rows]
    assert output["replay_prefix"] == expected
    assert output["values"] == [{"index": i, "value": v} for i, v in enumerate(expected)]
    return {
        "operation_id": result["operation_id"],
        "server_version": record["server"]["version"],
        "protocol_version": record["protocol_version"],
        "adapter_exit_code": invocation["adapter_exit_code"],
        "timeout": invocation["timeout"],
        "exact_prefix_replayed": 21,
        "result": "matches all 21 direct integer-transfer S1 values",
    }


def seed_trace():
    _, _, rows = profiles(20)
    lines = [
        "namespace QuantitativeProfile",
        "",
        "theorem seed_raw_exact : raw 22 seedM seedR 20 =",
        "    ⟨" + ", ".join(str(v) for v in rows[-1]) + "⟩ := by",
    ]
    for i, row in enumerate(rows):
        values = ", ".join(str(v) for v in row)
        lines.append(f"  have h{i} : raw 22 seedM seedR {i} = ⟨{values}⟩ := by")
        if i:
            lines.append(f"    rw [raw, h{i-1}]")
        lines.append("    norm_num [raw, seedM, seedR, mDepth, rDepth]")
    lines.extend(
        [
            "  exact h20",
            "",
            "theorem seed_raw_bound :",
            "    seedM * (raw 22 seedM seedR 20).s0 ≤ seedA ∧",
            "      (raw 22 seedM seedR 20).s1 ≤ seedA := by",
            "  rw [seed_raw_exact]",
            "  norm_num [seedA, seedM, mDepth]",
            "",
            "end QuantitativeProfile",
            "",
        ]
    )
    return "\n".join(lines)


def adversarial_small_case():
    m, r, d, length, k = 3, 2, 2, 4, 19
    outgoing = [
        [j for j in range(k) if 0 < (j - i) % k <= m * m] for i in range(k)
    ]
    assert all(len(row) == m * m for row in outgoing)
    forbidden_sets = 0
    for vertices in combinations(range(k), 16):
        assert any(
            len({i % r for i in vertices if j in outgoing[i]}) > 1 for j in vertices
        )
        forbidden_sets += 1
    centres = [((1 << length) - 1) << (j * length) for j in range(m)]
    bits = m * length
    distances = [
        min((value ^ centre).bit_count() for centre in centres)
        for value in range(1 << bits)
    ]
    masks = [
        sum(1 << (q - 1) for q in range(1, d + 2) if distance <= d + 1 - q)
        for distance in distances
    ]
    base_side = [0, 0]
    base_joint = [0, 0]
    for value, before in enumerate(masks):
        side = [0] * (d + 1)
        joint = {(q, qp): 0 for q in range(d + 1) for qp in range(q + 1, d + 1)}
        for bit in range(bits):
            after = masks[value ^ (1 << bit)]
            changed = before ^ after
            for q in range(d + 1):
                side[q] += bool(changed & (1 << q))
            for q, qp in joint:
                if bool(before & (1 << q)) == bool(before & (1 << qp)):
                    joint[q, qp] += bool(changed & (1 << q)) and bool(changed & (1 << qp))
        for q, count in enumerate(side):
            b = int(bool(before & (1 << q)))
            base_side[b] = max(base_side[b], count)
        for (q, _), count in joint.items():
            b = int(bool(before & (1 << q)))
            base_joint[b] = max(base_joint[b], count)
    assert base_side[0] <= length and base_side[1] <= bits
    assert base_joint == [0, 0]
    for centre in centres:
        assert masks[centre] == 7 and masks[0] == 0

    def parent(child_masks, q):
        gate = 1 << (2 - q)
        return any(
            child_masks[r * i] & 4
            and child_masks[r * i + 1] & 4
            and all(not child_masks[r * j + i % r] & gate for j in outgoing[i])
            for i in range(k)
        )

    cases = [[0] * (k * r)]
    for i in range(k):
        accepted = [0] * (k * r)
        accepted[r * i : r * i + r] = [centres[0]] * r
        cases.append(accepted)
        near_target = accepted.copy()
        near_target[r * i] ^= 1
        cases.append(near_target)
        if i < 6:
            for distance in (1, 2):
                failed_gate = accepted.copy()
                j = outgoing[i][0]
                failed_gate[r * j + i % r] = centres[0] ^ ((1 << distance) - 1)
                cases.append(failed_gate)
    generator = Random(132)
    choices = [0, centres[0], centres[0] ^ 1, centres[0] ^ 3, centres[0] ^ 7, centres[1]]
    for _ in range(12):
        cases.append([generator.choice(choices) for _ in range(k * r)])
    observed_side = [0, 0]
    observed_joint = [0, 0]
    for values in cases:
        child_masks = [masks[value] for value in values]
        before = [parent(child_masks, q) for q in (1, 2)]
        side = [0, 0]
        joint = 0
        for child, value in enumerate(values):
            original = child_masks[child]
            for bit in range(bits):
                child_masks[child] = masks[value ^ (1 << bit)]
                after = [parent(child_masks, q) for q in (1, 2)]
                changed = [after[q] != before[q] for q in (0, 1)]
                for q in (0, 1):
                    side[q] += changed[q]
                if before[0] == before[1] and all(changed):
                    joint += 1
            child_masks[child] = original
        for q in (0, 1):
            b = int(bool(before[q]))
            observed_side[b] = max(observed_side[b], side[q])
        if before[0] == before[1]:
            b = int(bool(before[0]))
            observed_joint[b] = max(observed_joint[b], joint)
    majorants = transfer((base_side[0], base_side[1], 0, 0), m, r)
    assert observed_side[0] <= majorants[0]
    assert observed_side[1] <= majorants[1]
    assert observed_joint[0] <= majorants[2]
    assert observed_joint[1] <= majorants[3]
    return {
        "result_class": "finite_adversarial_replay_not_the_uniform_proof",
        "parameters": {"d": d, "M": m, "r": r, "L": length, "k": k},
        "labels": "a(i,j)=i mod 2, on the cyclic outdegree-nine tournament",
        "sixteen_sets_exhausted": forbidden_sets,
        "base_inputs_exhausted": 1 << bits,
        "base_raw_bit_transitions": (1 << bits) * bits,
        "base_maxima": base_side + base_joint,
        "parent_inputs_replayed": len(cases),
        "parent_bits_per_input": k * r * bits,
        "parent_observed_maxima": observed_side + observed_joint,
        "parent_transfer_majorants": list(majorants),
    }


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--write-certificate", action="store_true")
    parser.add_argument("--write-jacobian-payload", action="store_true")
    parser.add_argument("--write-seed-trace", action="store_true")
    parser.add_argument("--require-lean", action="store_true")
    args = parser.parse_args()
    certificate = {
        "result_class": "quantitative_extension_theorem",
        "novelty_status": "not_established_by_arithmetic",
        "uniform_theorem": symbolic_uniform_certificate(),
        "seed": seed_certificate(),
        "previous_family": previous_family_comparison(),
        "jacobian": jacobian_certificate(),
        "adversarial_replay": adversarial_small_case(),
    }
    if args.write_certificate:
        (ROOT / "exact_certificate.json").write_text(
            json.dumps(certificate, indent=2) + "\n", encoding="ascii"
        )
    if args.write_jacobian_payload:
        (ROOT / "jacobian_payload.json").write_text(
            json.dumps(jacobian_payload(), indent=2) + "\n", encoding="ascii"
        )
    if args.write_seed_trace:
        (ROOT / "SeedTrace.lean").write_text(seed_trace(), encoding="utf-8")
    if not args.write_certificate:
        assert json.loads((ROOT / "exact_certificate.json").read_text()) == certificate
    if (ROOT / "SeedTrace.lean").exists():
        assert (ROOT / "SeedTrace.lean").read_text() == seed_trace()
    if args.require_lean:
        from assemble import assembled_source

        assert (ROOT / "Main.lean").read_text() == assembled_source()
        evidence = json.loads((ROOT / "lean" / "lean_check.json").read_text())
        assert evidence["status"] == "success"
        assert evidence["exit_code"] == 0 and evidence["proof_holes"] == []
        assert evidence["audit_exit_code"] == 0
        assert evidence["source_sha256"] == hashlib.sha256((ROOT / "Main.lean").read_bytes()).hexdigest()
        assert evidence["statement_fidelity_sha256"] == hashlib.sha256(
            (ROOT / "STATEMENT_FIDELITY.md").read_text().encode("utf-8")
        ).hexdigest()
        assert (ROOT / "lean" / "Main.lean").read_text() == (ROOT / "Main.lean").read_text()
        assert (ROOT / "lean" / "statement_fidelity.md").read_text() == (
            ROOT / "STATEMENT_FIDELITY.md"
        ).read_text()
        assert "sorryAx" not in evidence["stdout"]
        axiom_lists = re.findall(
            r"^'QuantitativeProfile\.[^']+' depends on axioms: \[([^]]*)\]$",
            evidence["stdout"],
            flags=re.M,
        )
        assert len(axiom_lists) == 4
        allowed = {"propext", "Classical.choice", "Quot.sound"}
        assert all({name.strip() for name in names.split(",")} <= allowed for names in axiom_lists)
        project = ROOT.parent.parent
        state = json.loads((project / "research" / "MATH_STATE.json").read_text())
        claim = [c for c in state["claims"] if c["claim_id"] == "C_PROFILE_EXTENSION"][-1]
        assert claim["formal_statement"].strip() == (ROOT / "Main.lean").read_text().strip()
        assert claim["external_assumptions"] == []
        records = [
            item
            for item in state["evidence"]
            if item["subject"]["subject_id"] == "C_PROFILE_EXTENSION"
            and item["subject"]["content_hash"] == claim["content_hash"]
            and item["tier"] == "mechanical"
            and item["verdict"] == "supports"
        ]
        assert records
        for item in records:
            archived = json.loads((project / item["artifact"]).read_text())
            assert archived["lean_source"]["text"].strip() == (
                ROOT / "Main.lean"
            ).read_text().strip()
            assert archived["lean_check"]["exit_code"] == 0
    print(
        "PASS: exact four-profile identities, universal-induction obligations, "
        "d=20 seed, 161/80 integer inequality, full prior-family comparison, "
        "and all 21 Jacobian replay terms."
    )


if __name__ == "__main__":
    main()
