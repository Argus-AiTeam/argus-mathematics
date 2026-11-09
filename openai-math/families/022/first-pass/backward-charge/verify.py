#!/usr/bin/env python3
"""Replay exact stress cases and check the recorded universal Lean certificate."""

import argparse
from fractions import Fraction as Q
from itertools import product
import json
from pathlib import Path
import subprocess
import sys


HERE = Path(__file__).resolve().parent
ROOT = HERE.parent.parent
ARGUS_PYTHON = "$WORKSPACE/argus-live-update/.venv/bin/python"
SOURCE = ROOT / "research/openai_manuscript/The-weak-inhomogeneous-Duffin-Schaeffer-conjecture-September-25-2026/build/sections"


def require(condition, message):
    if not condition:
        raise AssertionError(message)


def prime_law(p, exponent):
    return {
        j: Q(1, p**j) * (1 - Q(1, p)) if j < exponent else Q(1, p**exponent)
        for j in range(exponent + 1)
    }


def check_mask_transitions():
    cases = 0
    for p, exponent in product((2, 3, 5, 7, 11), range(1, 5)):
        law = prime_law(p, exponent)
        q = Q(1, p)
        residual = 1 - q if exponent >= 2 else Q(1)
        require(sum(law.values()) == 1, "mask law is not normalized")
        for j in range(exponent + 1):
            require(sum(law[k] for k in range(j, exponent + 1)) == Q(1, p**j),
                    "mask tail probability mismatch")
        require(law[0] == 1 - q, "minus-mask transition mismatch")
        require(law[1] == residual * q, "residual-scaled plus-mask transition mismatch")
        for success in (Q(0), Q(1)):
            m = Q(3, 7)
            before = m * q + m * (1 - q)
            after = m * success + m * (1 - success)
            require(before == after, "matched mask-currency conservation failed")
        cases += 1
    return {"prime_power_cases": cases, "arithmetic": "fractions.Fraction"}


def product_coupling(rows, columns):
    row_total, column_total = sum(rows), sum(columns)
    require(row_total > 0 and column_total > 0, "empty matching fixture")
    total = min(row_total, column_total)
    matrix = [
        [total * row * column / (row_total * column_total) for column in columns]
        for row in rows
    ]
    require(sum(map(sum, matrix)) == total, "matching is not maximal")
    for x, row in enumerate(rows):
        require(sum(matrix[x]) <= row, "row capacity exceeded")
    for a, column in enumerate(columns):
        require(sum(matrix[x][a] for x in range(len(rows))) <= column,
                "column capacity exceeded")
    return matrix


def check_correlated_updates():
    cases = 0
    nonzero_covariances = 0
    for p, exponent, history in product((2, 3, 5, 7), (1, 2), range(3)):
        q, size = Q(1, p), p**exponent
        wx, wy = Q(4 + history, 9), Q(7 - history, 10)
        mx = (wx / 3, wx / 4)
        my = (wy / 5, wy / 3)
        # Both endpoints share the same orbit color; there is no product law on successes.
        ix = [[Q(int((g + offset) % p == 0)) for g in range(size)] for offset in (0, 1)]
        iy = [[Q(int((g + offset) % p == 0)) for g in range(size)]
              for offset in (history % p, 1)]
        dx = [sum(m * indicators[g] for m, indicators in zip(mx, ix)) for g in range(size)]
        dy = [sum(m * indicators[g] for m, indicators in zip(my, iy)) for g in range(size)]
        require(sum(dx) == size * q * sum(mx), "unbalanced linked success")
        require(sum(dy) == size * q * sum(my), "unbalanced linked success")
        actual = Q(0)
        for g in range(size):
            post_x = (wx - sum(mx)) * (1 - q) + sum(
                m * (1 - indicators[g]) for m, indicators in zip(mx, ix))
            post_y = (wy - sum(my)) * (1 - q) + sum(
                m * (1 - indicators[g]) for m, indicators in zip(my, iy))
            require(0 <= post_x <= wx and 0 <= post_y <= wy,
                    "raw matching update violates monotonicity")
            require(post_x == (1 - q) * wx - (dx[g] - q * sum(mx)),
                    "centered raw-update identity failed")
            actual += post_x * post_y
        joint = sum(x * y for x, y in zip(dx, dy))
        main = size * (1 - q)**2 * wx * wy
        covariance = joint - size * q**2 * sum(mx) * sum(my)
        require(actual == main + covariance, "correlated covariance identity failed")
        require(actual <= main + joint, "one-prime stopped-loss bound failed")
        nonzero_covariances += covariance != 0
        cases += 1
    require(nonzero_covariances > 0, "fixtures accidentally tested only independence")
    return {"orbit_cases": cases, "nonzero_covariances": nonzero_covariances}


def check_projection_transport():
    checked = 0
    exact_averagings = 0
    strict_capacity_cases = 0
    outer_law = prime_law(11, 2)
    omission_configs = (
        ((5, 1, 1),),
        ((5, 2, 1),),
        ((5, 2, 1), (7, 1, 2)),
        ((5, 2, 1), (7, 2, 2)),
    )
    for omissions, history in product(omission_configs, range(2)):
        p = 3
        period = p
        divisor = 1
        for l, exponent, side in omissions:
            require(side in (1, 2), "invalid mapped side")
            period *= l**exponent
            divisor *= l
        require(len({l for l, _, _ in omissions}) == len(omissions),
                "a first-bad-omission branch cannot have a shared later prime")
        rows_x = (Q(2 + history, 7), Q(2, 9))
        rows_y = (Q(3, 8), Q(1 + history, 9))
        plus_x = (Q(1, 3), Q(1, 4))
        plus_y = (Q(2, 7), Q(1, 3))
        m = product_coupling(rows_x, plus_x)
        n = product_coupling(rows_y, plus_y)
        incoming_x = [sum(m[x][a] for x in range(2)) for a in range(2)]
        incoming_y = [sum(n[y][b] for y in range(2)) for b in range(2)]
        for delta in (0, 1, 3):
            # Translation by 1/l^nu on the real circle is this integer shift.
            for l, exponent, side in omissions:
                increment = period // l**exponent
                require(increment % l != 0 and increment % p == 0,
                        "the designated digit move is not a p-preserving unit")
                for other, _, _ in omissions:
                    if other != l:
                        require(increment % other == 0, "a different omission digit moved")
            expanded, projected, arbitrary_restriction, capacity = (Q(0) for _ in range(4))
            for g in range(period):
                for a, b in product(range(2), repeat=2):
                    success = int((g + a) % p == 0) * int((g + delta + b) % p == 0)
                    if not success:
                        continue
                    # The raw plus arrival on success is its entire residual-scaled capacity.
                    capacity += plus_x[a] * plus_y[b]
                    expanded += incoming_x[a] * incoming_y[b]
                    for x, y in product(range(2), repeat=2):
                        mass = m[x][a] * n[y][b]
                        colors = [
                            ((g + x) if side == 1 else (g + delta + y)) % l
                            for l, _, side in omissions
                        ]
                        if all(color == 0 for color in colors):
                            projected += mass
                            # A later survival test need not be invariant. It is dropped, not averaged.
                            if (g + 2*x + y + history) % 4:
                                arbitrary_restriction += mass
            require(projected * divisor == expanded,
                    "origin projection did not average to the exact reciprocal product")
            require(arbitrary_restriction <= projected <= capacity / divisor,
                    "averaging followed by capacity transport failed")
            exact_averagings += 1
            strict_capacity_cases += expanded < capacity
            for outer_x, outer_y in product(outer_law, repeat=2):
                broad = outer_law[outer_x] * outer_law[outer_y]
                clipping = outer_law[outer_x] if outer_x == outer_y else Q(0)
                for coefficient in (broad, clipping):
                    require(coefficient * projected == coefficient * expanded / divisor,
                            "mask currency changed during averaging")
                    require(coefficient * arbitrary_restriction <= coefficient * capacity / divisor,
                            "mask currency changed during capacity transport")
                    checked += 1
    require(strict_capacity_cases > 0, "capacity fixtures did not test nonsaturation")
    pi = outer_law[1]
    require(pi != pi*pi, "clipping fixture cannot distinguish one law from two")
    return {
        "mask_weighted_bounds": checked,
        "exact_prime_power_averagings": exact_averagings,
        "strict_capacity_cases": strict_capacity_cases,
        "maximum_translation_period": 3 * 5**2 * 7**2,
        "later_omissions_applied_to": "original minus numerators, not image numerators",
        "scope": "finite stress cases, not an embedding of a complete retained-centre block",
    }


def partitions(n):
    def extend(prefix):
        if len(prefix) == n:
            yield tuple(prefix)
            return
        for label in range(max(prefix, default=-1) + 2):
            yield from extend(prefix + [label])
    return tuple(extend([]))


def refines(a, b):
    return all(a[x] != a[y] or b[x] == b[y] for x, y in product(range(len(a)), repeat=2))


def first_epoch(chain, x, y):
    return next(t for t, partition in enumerate(chain) if partition[x] == partition[y])


def check_chronology():
    ps = partitions(4)
    discrete, joined = tuple(range(4)), (0, 0, 0, 0)
    chains, charges = 0, 0
    for middle, later in product(ps, repeat=2):
        if not refines(middle, later):
            continue
        chain = (discrete, middle, later, joined)
        chains += 1
        image_epochs = {}
        for x, y in product(range(4), repeat=2):
            epoch = first_epoch(chain, x, y)
            for past in range(epoch):
                partition = chain[past]
                for a, b in product(range(4), repeat=2):
                    if partition[x] != partition[a] or partition[y] != partition[b]:
                        continue
                    require(first_epoch(chain, a, b) == epoch,
                            "transport changed a first-sharing epoch")
                    require(image_epochs.setdefault((a, b), epoch) == epoch,
                            "an image pair was charged at repeated comparison epochs")
                    charges += 1
    return {"growing_partition_chains": chains, "transported_first_joins": charges}


def check_backward_unrolling():
    cases = 0
    for factors in product((Q(1, 2), Q(1), Q(4, 3)), repeat=4):
        losses = (Q(0), Q(2, 7), Q(1, 5), Q(3, 8))
        terminal = Q(5, 9)
        direct = terminal
        for r, loss in reversed(tuple(zip(factors, losses))):
            direct = r * direct + loss
        carried = Q(1)
        terms = []
        for r, loss in zip(factors, losses):
            terms.append(carried * loss)
            carried *= r
        require(len(terms) == len(factors), "a stopped branch was expanded again")
        require(direct == carried * terminal + sum(terms), "backward unrolling failed")
        cases += 1
    return {"four_step_chains": cases, "separately_stopped_terms_per_stage": 1}


def jacobian_payload():
    # Encode (later color in Z/5 x Z/7, common p-success bit) as one rational value.
    atoms = []
    for color in range(35):
        for success, numerator in ((0, 2), (1, 1)):
            atoms.append({
                "value": {"num": str(2 * color + success), "den": "1"},
                "probability": {"num": str(numerator), "den": "105"},
            })
    return {
        "distribution": {"atoms": atoms},
        "event_values": [{"num": "0", "den": "1"}, {"num": "1", "den": "1"}],
    }


def check_jacobian():
    path = HERE / "jacobian-output.json"
    require(path.is_file(), "the bounded Jacobian operation has not been executed")
    output = json.loads(path.read_text())
    require(output.get("server", {}).get("version"), "Jacobian output omits server version")
    require(output.get("protocol_version"), "Jacobian output omits protocol version")
    request = output.get("request", {})
    require(request.get("operation_id") == "probability.finite_distribution.condition.compute",
            "Jacobian output names a different operation")
    require(request.get("payload") == json.loads((HERE / "jacobian-payload.json").read_text())
            == jacobian_payload(), "Jacobian output does not match the exact payload")
    require(not output.get("error"), "Jacobian reported an adapter error")
    status = json.loads((HERE / "jacobian-status.json").read_text())
    require(status["adapter_exit_code"] == 0 and not status["timed_out"] and status["error"] is None,
            "the Jacobian adapter did not complete successfully")
    result = output.get("result", {})
    # Adapter output is preserved verbatim; only typed mathematical success counts.
    typed = result.get("output", result.get("result", result))
    require("event_probability" in typed and "distribution" in typed,
            "Jacobian returned no complete typed conditioning result")
    rational = lambda r: Q(int(r["num"]), int(r["den"]))
    require(rational(typed["event_probability"]) == Q(1, 35),
            "Jacobian conditional event mass disagrees")
    atoms = typed["distribution"]["atoms"]
    distribution = {rational(a["value"]): rational(a["probability"]) for a in atoms}
    require(distribution == {Q(0): Q(2, 3), Q(1): Q(1, 3)},
            "Jacobian conditional success law disagrees")
    return {
        "operation_id": "probability.finite_distribution.condition.compute",
        "status": "complete_exact_output",
        "event_probability": "1/35",
        "scope": "bounded arithmetic corroboration only",
    }


def compile_lean():
    command = [
        ARGUS_PYTHON, "-m", "argus_skill.verticals.math.lean_evidence", "verify",
        str(HERE / "Main.lean"), "--statement-fidelity", str(HERE / "statement_fidelity.md"),
        "--claim", "C_BC", "--project-root", str(ROOT),
    ]
    completed = subprocess.run(command, cwd=ROOT, text=True, capture_output=True)
    (HERE / "lean-verification.json").write_text(completed.stdout)
    if completed.stderr:
        print(completed.stderr, file=sys.stderr)
    require(completed.returncode == 0,
            "official Lean verification failed:\n" + completed.stdout)


def campaign_local_checks():
    result = {"project_root": str(ROOT)}
    errors = []
    for module in ("math_state", "proof_graph_check"):
        completed = subprocess.run(
            [ARGUS_PYTHON, "-m", "argus_skill.verticals.math." + module,
             "check", "--project-root", str(ROOT)],
            cwd=ROOT, text=True, capture_output=True,
        )
        result[module + "_exit_code"] = completed.returncode
        if completed.returncode != 0:
            errors.append(module + " failed:\n" + completed.stdout + completed.stderr)
    require(not errors, "\n".join(errors))
    return result


def check_lean_record():
    state = json.loads((ROOT / "research/MATH_STATE.json").read_text())
    current = max((claim for claim in state["claims"] if claim["claim_id"] == "C_BC"),
                  key=lambda claim: claim["version"])
    candidates = []
    for evidence in state["evidence"]:
        artifact = evidence.get("artifact", "")
        subject = evidence.get("subject", {})
        if subject.get("content_hash") != current["content_hash"]:
            continue
        if artifact.startswith("research/backward-charge/certificates/"):
            archive = json.loads((ROOT / artifact).read_text())
            if archive.get("subject") == subject and subject.get("subject_id") == "C_BC":
                candidates.append((artifact, archive))
    require(candidates, "no official Lean certificate for C_BC is recorded")
    source = (HERE / "Main.lean").read_text()
    fidelity = (HERE / "statement_fidelity.md").read_text()
    matching = [
        (artifact, archive) for artifact, archive in candidates
        if archive.get("lean_source", {}).get("text") == source
    ]
    require(matching, "the current Lean source has no matching official certificate")
    artifact, archive = matching[-1]
    require(archive["tier"] == "mechanical" and archive["verdict"] == "supports",
            "the archive is not supporting mechanical evidence")
    check = archive["lean_check"]
    require(check.get("status") == "success", "the Lean certificate is not successful")
    require(check.get("exit_code") == 0, "the Lean compiler did not exit zero")
    require(check.get("proof_holes") == [], "Lean proof holes remain")
    fidelity_record = archive.get("statement_fidelity", {})
    require(fidelity_record.get("text") == fidelity,
            "the current statement-fidelity document is not the certified document")
    return {"artifact": artifact, "status": "success", "exit_code": 0, "proof_holes": []}


def check_source_locators():
    requirements = {
        "joins.tex": ("join:backward-decomposition", "join:raw-covariance",
                      "join:later-omissions", "join:capacity", "join:one-law-capacity"),
        "tables.tex": ("tab:projected-grid", "tab:mask-transition", "tab:product-law", "tab:one-law"),
    }
    for filename, labels in requirements.items():
        text = (SOURCE / filename).read_text()
        for label in labels:
            require("\\label{" + label + "}" in text, f"source locator disappeared: {label}")
    return requirements


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--development", action="store_true",
                        help="run exact stress cases without claiming a Lean/Jacobian certificate")
    parser.add_argument("--write", action="store_true", help="write the exact certificate after replay")
    parser.add_argument("--emit-jacobian-payload", action="store_true")
    parser.add_argument("--recorded-only", action="store_true",
                        help="check the current official certificate without recompiling unchanged Lean")
    args = parser.parse_args()
    require(not (args.development and args.write), "development results cannot be certified")
    if args.emit_jacobian_payload:
        (HERE / "jacobian-payload.json").write_text(json.dumps(jacobian_payload(), indent=2) + "\n")
    checks = {
        "mask_transitions": check_mask_transitions(),
        "correlated_updates": check_correlated_updates(),
        "projection_transport": check_projection_transport(),
        "chronology": check_chronology(),
        "backward_unrolling": check_backward_unrolling(),
    }
    result = {
        "claim_id": "C_BC",
        "result_class": "new_theorem",
        "mathematical_result": "Universal equivariant backward-charge verification and mask-kernel generalization",
        "universal_evidence": "Lean finite-sum theorem plus the manuscript instantiation proved in report.md",
        "finite_checks": checks,
        "source_labels": check_source_locators(),
        "main_conjecture_certified": False,
        "independent_review": "required_pending",
        "significance_status": "pending_independent_review",
        "novelty_status": "not_claimed",
    }
    if not args.development:
        if not args.recorded_only:
            compile_lean()
        result["campaign_local_checks"] = campaign_local_checks()
        result["lean"] = check_lean_record()
        result["jacobian"] = check_jacobian()
    else:
        result["status"] = "development_checks_only"
    if args.write:
        (HERE / "exact_certificate.json").write_text(json.dumps(result, indent=2) + "\n")
    print(json.dumps(result, indent=2))


if __name__ == "__main__":
    main()
