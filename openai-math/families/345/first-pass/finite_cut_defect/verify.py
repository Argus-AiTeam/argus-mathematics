#!/usr/bin/env python3
"""Replay exact diagnostics and the universal Lean finite-cut certificate."""

import argparse
from dataclasses import dataclass
import hashlib
import json
from pathlib import Path
import re
import subprocess
import sys


HERE = Path(__file__).resolve().parent
ROOT = HERE.parent.parent
MANUSCRIPT = (
    ROOT
    / "research/openai_manuscript"
    / "Infinitely-many-closed-geodesic-images-on-every-Riemannian-sphere-September-24-2026"
)


def require(condition, message):
    if not condition:
        raise ValueError(message)


def read_json(path):
    return json.loads(path.read_text(encoding="utf-8"))


@dataclass(frozen=True)
class F2Matrix:
    columns: int
    rows: tuple[int, ...]

    def __post_init__(self):
        require(self.columns >= 0, "Negative matrix dimension")
        require(
            all(0 <= row < (1 << self.columns) for row in self.rows),
            "Matrix row outside its declared shape",
        )

    @property
    def target(self):
        return len(self.rows)

    def apply(self, vector):
        require(0 <= vector < (1 << self.columns), "Vector outside source")
        return sum(
            ((row & vector).bit_count() & 1) << index
            for index, row in enumerate(self.rows)
        )

    def image(self):
        return {self.apply(v) for v in range(1 << self.columns)}

    def kernel(self):
        return {v for v in range(1 << self.columns) if self.apply(v) == 0}

    def then(self, other):
        require(self.target == other.columns, "Composition dimension mismatch")
        return from_columns(
            other.target,
            [other.apply(self.apply(1 << j)) for j in range(self.columns)],
        )

    def as_json(self):
        return {
            "rows": self.target,
            "columns": self.columns,
            "entries": [
                [(row >> j) & 1 for j in range(self.columns)] for row in self.rows
            ],
        }


def from_columns(target, columns):
    require(all(0 <= v < (1 << target) for v in columns), "Invalid column")
    return F2Matrix(
        len(columns),
        tuple(
            sum(((column >> i) & 1) << j for j, column in enumerate(columns))
            for i in range(target)
        ),
    )


def dimension(subspace):
    size = len(subspace)
    require(size > 0 and size & (size - 1) == 0, "Invalid F2 subspace size")
    return size.bit_length() - 1


def projection(labels, cutoff):
    return from_columns(
        len(labels),
        [1 << i if label <= cutoff else 0 for i, label in enumerate(labels)],
    )


def mapped(matrix, subspace):
    return {matrix.apply(v) for v in subspace}


def exact(first, second, name):
    require(first.target == second.columns, f"{name}: incompatible spaces")
    require(first.image() == second.kernel(), f"{name}: row is not exact")


def graded(matrix, source, target, shift, name):
    require(matrix.columns == len(source), f"{name}: source grading shape")
    require(matrix.target == len(target), f"{name}: target grading shape")
    for i, row in enumerate(matrix.rows):
        for j in range(matrix.columns):
            if (row >> j) & 1:
                require(target[i] == source[j] + shift, f"{name}: wrong degree")


def supported(matrix, labels, degree, name):
    for i, row in enumerate(matrix.rows):
        require(not row or labels[i] <= degree, f"{name}: label above actual degree")


def potential(p, previous, current):
    low = dimension(p.image())
    eprev = dimension(previous.then(p).image())
    ecur = dimension(current.then(p).image())
    high = dimension(current.image() & p.kernel())
    invisible = dimension(current.kernel())
    terms = [low - ecur, low - eprev, high, invisible]
    require(min(terms) >= 0, "Negative original potential term")
    require(high + invisible == current.columns - ecur, "H+t formula")
    value = sum(terms)
    require(
        value == 2 * low - 2 * ecur - eprev + current.columns,
        "Original and derived potential formulas differ",
    )
    return value, terms


def fixture(name, cutoff, birth_degree, death_present, extra, invisible_current):
    require(not invisible_current or extra, "Invisible target direction needed")
    high_degree = cutoff + 1
    local_dim = 2 + extra
    new_dim = 3 + extra
    old_columns = [6] + ([1] if death_present else []) + (
        [0] if invisible_current else []
    )
    old_dim = len(old_columns)
    delta = from_columns(2, [2, 0, 0])
    f = from_columns(3, [1, 0])
    i = from_columns(3, [0, 2, 4])
    local = from_columns(2, [1, 2] + [0] * extra)
    left = from_columns(new_dim, [1, 2] + [1 << (3 + t) for t in range(extra)])
    e_new = from_columns(3, [1, 0, 6] + [0] * extra)
    e_prev = from_columns(3, [6])
    e = from_columns(3, old_columns)
    middle_prev = from_columns(1, [0, 0, 1] + [0] * extra)
    middle = from_columns(old_dim, [0, 0, 1] + [0] * extra)
    right_prev = from_columns(local_dim, [0])
    right = from_columns(
        local_dim,
        [0] + ([2] if death_present else []) + ([4] if invisible_current else []),
    )
    incoming = from_columns(local_dim, [])
    vl = [1, 1, high_degree]
    wl = [birth_degree, 2]
    vpl = [birth_degree, 1, high_degree]
    p, pw, pp = [projection(labels, cutoff) for labels in [vl, wl, vpl]]

    for a, b, label in [
        (delta, f, "fixed W"),
        (f, i, "fixed V'"),
        (i, delta, "fixed V"),
        (incoming, left, "previous local C"),
        (left, middle_prev, "previous A'"),
        (middle_prev, right_prev, "previous A"),
        (right_prev, left, "current local C"),
        (left, middle, "current A'"),
        (middle, right, "current A"),
    ]:
        exact(a, b, label)
    graded(delta, vl, wl, 1, "delta")
    graded(f, wl, vpl, 0, "f")
    graded(i, vpl, vl, 0, "i")
    require(p.then(p) == p and pp.then(pp) == pp and pw.then(pw) == pw, "Cuts")
    require(f.then(pp) == pw.then(f), "f does not preserve the cut")
    require(i.then(p) == pp.then(i), "i does not preserve the cut")
    require(left.then(e_new) == local.then(f), "Left square")
    require(middle_prev.then(e_prev) == e_new.then(i), "Previous middle square")
    require(middle.then(e) == e_new.then(i), "Current middle square")
    require(right_prev.then(local) == e_prev.then(delta), "Previous right square")
    require(right.then(local) == e.then(delta), "Current right square")

    J = 2 * cutoff
    for matrix, labels, degree, label in [
        (e_prev, vl, J - 1, "previous restriction"),
        (e_new, vpl, J - 1, "previous new restriction"),
        (e, vl, J, "current restriction"),
        (e_new, vpl, J, "current new restriction"),
        (local, wl, J - 1, "previous local restriction"),
        (local, wl, J, "current local restriction"),
        (local, wl, J + 1, "next local restriction"),
    ]:
        supported(matrix, labels, degree, label)

    ambient_index, root_index, A, n, C0 = 2, 1, 3, 3, 13
    require(abs(ambient_index - 2 * root_index) <= n, "Index comparison")
    require(all(abs(l - root_index) <= A for l in wl), "Local root support")
    for q in [J - 1, J, J + 1]:
        if q < ambient_index - A:
            require(local.columns == 0, "Local source below index window")
        if q > ambient_index + A:
            require(local.kernel() == {0}, "Local restriction not stable above window")
            require(local.image() == set(range(1 << len(wl))), "Stable target mismatch")

    is_far = abs(ambient_index - J) > C0
    old_phi, old_terms = potential(p, e_prev, e)
    new_phi, new_terms = potential(pp, e_new, e_new)
    M = max(len(wl), local_dim)
    require(abs(new_phi - old_phi) <= 6 * M, "Exceptional bound")
    PEprev, PE = e_prev.then(p).image(), e.then(p).image()
    PEnew = e_new.then(pp).image()
    require(6 in e_prev.image() and 2 not in e_prev.image(), "Mixed witness changed")
    require(p.apply(6) == 2, "Mixed witness has wrong projection")
    r = dimension(mapped(delta, p.image()))
    rprev, rcur = [dimension(mapped(delta, s)) for s in [PEprev, PE]]
    if is_far:
        require(not any(l in [cutoff, cutoff + 1] for l in wl), "Far boundary support")
        require(local.kernel() == {0} and local.image() == pw.image(), "Far local data")
        require(delta.then(pw) == p.then(delta), "Far connecting map crosses the cut")
        A0 = mapped(f, pw.image())
        require(dimension(pw.image()) == dimension(A0) + r, "Low local dimension")
        require(
            dimension(pp.image()) - dimension(p.image()) == dimension(A0) - r,
            "Low-space dimension change",
        )
        for e_old, g_old, d_old in [
            (e_prev, middle_prev, right_prev),
            (e, middle, right),
        ]:
            E = e_old.then(p).image()
            require(mapped(i, PEnew) == E & delta.kernel(), "Mixed-image lifting")
            require(PEnew & i.kernel() == A0, "Mixed-image kernel")
            rq = dimension(mapped(delta, E))
            require(dimension(d_old.image()) == rq, "Actual connecting rank")
            deficit_change = (
                dimension(pp.image()) - dimension(PEnew)
                - dimension(p.image()) + dimension(E)
            )
            require(deficit_change == -(r - rq), "Deficit-change identity")
        require(
            new_dim - old_dim == dimension(pw.image()) - rprev - rcur,
            "Actual dimension change",
        )
        require(new_phi - old_phi == -(r - rcur) <= 0, "Exact far-event change")
    else:
        require(extra > 0 and local.kernel() != {0}, "Near diagnostic must test noninjectivity")
        require(new_phi > old_phi, "Near diagnostic must test a positive increment")

    return {
        "name": name,
        "field": 2,
        "j": cutoff,
        "J": J,
        "classification": "far" if is_far else "exceptional",
        "indices": {"ambient": ambient_index, "root": root_index, "A": A, "n": n, "C0": C0},
        "root_labels": {"V": vl, "W": wl, "V_new": vpl},
        "fixed_maps": {key: value.as_json() for key, value in [
            ("delta", delta), ("f", f), ("i", i), ("P_V", p), ("P_W", pw), ("P_V_new", pp)
        ]},
        "actual_maps": {key: value.as_json() for key, value in [
            ("incoming_zero", incoming), ("left_previous_and_current", left),
            ("middle_previous", middle_prev), ("middle_current", middle),
            ("right_previous", right_prev), ("right_current", right)
        ]},
        "restrictions": {key: value.as_json() for key, value in [
            ("old_previous", e_prev), ("old_current", e),
            ("new_previous_and_current", e_new), ("all_three_local", local)
        ]},
        "measurements": {
            "old_terms_DJ_Dprev_H_t": old_terms,
            "new_terms_DJ_Dprev_H_t": new_terms,
            "old_potential": old_phi,
            "new_potential": new_phi,
            "change": new_phi - old_phi,
            "r_rprev_rJ": [r, rprev, rcur],
            "M": M,
            "exceptional_bound": 6 * M,
            "actual_image_is_not_graded": True,
            "mixed_vector": [0, 1, 1],
            "low_projection_not_in_actual_image": [0, 1, 0],
        },
    }


def manuscript_bindings():
    text = (MANUSCRIPT / "build/sections/budget.tex").read_text(encoding="utf-8")
    statements = [
        ("bud:potential", r"\Phi_j(a)&=D_{j,2j}+D_{j,2j-1}+H_{j,2j}+t_{2j},"),
        ("bud:crossing-diagram", r'\begin{equation}\label{bud:crossing-diagram}'),
        ("mixed-image lifting before bud:deficit-change", r"i(PE'_q)=PE_q\cap\ker\delta."),
        ("bud:deficit-change", r"D'_{j,q}-D_{j,q}=-(r-r_q)"),
        ("bud:far-change", r"\Phi'_j-\Phi_j=-(r-r_J)\le0."),
        ("exceptional bound", r"|\Phi'_j-\Phi_j|\le6M_0"),
        ("bud:linear-budget", r"\sum_{j\ge1}\Phi_j(a)\le C(1+a)."),
    ]
    result = []
    for locator, literal in statements:
        offset = text.find(literal)
        require(offset >= 0, f"Literal manuscript assertion changed: {locator}")
        result.append({
            "source": str((MANUSCRIPT / "build/sections/budget.tex").relative_to(ROOT)),
            "locator": locator,
            "line": text[:offset].count("\n") + 1,
            "literal": literal,
        })
    return result


def jacobian_evidence():
    payload = read_json(HERE / "jacobian_payload.json")
    output = read_json(HERE / "jacobian_output.json")
    status = read_json(HERE / "jacobian_status.json")
    contract = read_json(HERE / "jacobian_contract.json")
    require(status["exit_code"] == 0 and not status["timed_out"], "Jacobian did not complete")
    require(status["adapter_error"] is None and status["output_complete"], "Jacobian non-conclusion")
    require(output["server"]["version"] == contract["server_version"], "Jacobian version mismatch")
    require(output["protocol_version"] == contract["protocol_version"], "Jacobian protocol mismatch")
    require(output["result"]["operation_id"] == contract["operation_id"], "Wrong Jacobian operation")
    require(output["request"]["payload"] == payload, "Jacobian payload mismatch")
    typed = output["result"]["output"]
    require(typed["prime"] == 2 and typed["source"] == payload, "Wrong typed rank source")
    rows = payload["matrix"]["entries"]
    matrix = F2Matrix(
        payload["matrix"]["columns"],
        tuple(sum(entry << j for j, entry in enumerate(row)) for row in rows),
    )
    require(typed["rank"] == dimension(matrix.image()) == 2, "Jacobian rank mismatch")
    return {
        "operation_id": contract["operation_id"],
        "server_version": output["server"]["version"],
        "protocol_version": output["protocol_version"],
        "payload_file": "jacobian_payload.json",
        "typed_output_file": "jacobian_output.json",
        "status_file": "jacobian_status.json",
        "exit_code": 0,
        "adapter_error": None,
        "diagnostic_rank": 2,
        "role": "finite mixed-image diagnostic, not support by itself for the universal theorem",
    }


def lean_evidence(use_recorded):
    recorded = read_json(HERE / "lean_check.json")
    official = read_json(HERE / "lean_official.json")
    require(recorded["status"] == "success", "Lean result is not successful")
    require(recorded["exit_code"] == recorded["audit_exit_code"] == 0, "Lean or axiom audit failed")
    require(recorded["proof_holes"] == [], "Lean proof has holes")
    require(not recorded["environment_failure"], "Lean environment failure")
    version = recorded["tools"]["lean"]["version"]
    require(version.startswith("Lean (version 4.31.0,"), "Wrong Lean version")
    for name, key in [
        ("Main.lean", "source_sha256"),
        ("statement_fidelity.md", "statement_fidelity_sha256"),
    ]:
        digest = hashlib.sha256((HERE / name).read_bytes()).hexdigest()
        require(digest == recorded[key] == official[key], f"Stale Lean binding: {name}")
    source = (HERE / "Main.lean").read_text(encoding="utf-8")
    require(not re.search(r"\b(sorry|admit|axiom)\b", source), "Unproved Lean declaration")
    kernel = official["kernel"]
    require(not kernel["refusals"], "Official evidence recording refused")
    evidence = kernel["recorded"]
    require(evidence["subject"]["subject_id"] == "C_FCD_EXACT", "Wrong certified claim")
    require(evidence["tier"] == "mechanical" and evidence["verdict"] == "supports", "Wrong evidence")
    archive_path = ROOT / evidence["artifact"]
    require(archive_path.is_file(), "Missing official archived certificate")
    ledger = read_json(ROOT / "research/MATH_STATE.json")
    claims = [c for c in ledger["claims"] if c["claim_id"] == "C_FCD_EXACT"]
    require(len(claims) == 1, "Certified claim is not unique")
    require(claims[0]["formal_statement"] == source, "Ledger formalization differs")
    require(
        claims[0]["content_hash"] == evidence["subject"]["content_hash"],
        "Mechanical evidence is attached to a different claim version",
    )
    require(any(e == evidence for e in ledger["evidence"]), "Mechanical evidence missing from ledger")
    if not use_recorded:
        workspace = Path(recorded["lake_workspace"])
        require(workspace.is_dir(), "Recorded Mathlib workspace is unavailable")
        command = ["lake", "-d", str(workspace), "env", "lean", str(HERE / "Main.lean")]
        replay = subprocess.run(command, cwd=ROOT, capture_output=True, text=True, timeout=120)
        (HERE / "lean_replay.log").write_text(replay.stdout + replay.stderr, encoding="utf-8")
        require(replay.returncode == 0, "Fresh Lean replay failed; see lean_replay.log")
    return {
        "claim": "C_FCD_EXACT",
        "version": version,
        "source": "Main.lean",
        "statement_fidelity": "statement_fidelity.md",
        "source_sha256": recorded["source_sha256"],
        "statement_fidelity_sha256": recorded["statement_fidelity_sha256"],
        "archived_certificate": evidence["artifact"],
        "exit_code": 0,
        "audit_exit_code": 0,
        "proof_holes": [],
        "declarations": [
            "FiniteCut.Comparison.mixed_image_exact",
            "FiniteCut.Comparison.mixed_image_kernel",
            "FiniteCut.Comparison.deficit_change",
            "FiniteCut.Comparison.connecting_rank",
            "FiniteCut.potential_formula",
            "FiniteCut.potential_nonneg",
            "FiniteCut.far_event",
            "FiniteCut.exceptional_event",
            "FiniteCut.degree_zero_cut",
            "FiniteCut.degree_one_cut",
            "FiniteCut.event_sum",
            "FiniteCut.window_union_card",
        ],
    }


def counting_diagnostics():
    windows = 0
    for c in range(5):
        for index in range(-10, 11):
            hits = [j for j in range(-20, 21) if abs(index - 2 * j) <= c]
            require(len(hits) <= 2 * c + 1, "Window-count diagnostic")
            windows += 1
    M, K, N = 3, 2, 7
    values = [0] * 5
    totals = [0]
    for event in range(N):
        exceptional = {event % 5, (event + 1) % 5}
        before = values[:]
        for j in range(5):
            values[j] += 6 * M if j in exceptional else -min(1, values[j])
            require(values[j] - before[j] <= (6 * M if j in exceptional else 0), "Event step")
        require(len(exceptional) <= K, "Exceptional-cardinality diagnostic")
        totals.append(sum(values))
        require(totals[-1] <= 6 * M * K * (event + 1), "Event-sum diagnostic")
    return {
        "classification": "finite diagnostics; universal proofs are the Lean declarations",
        "window_cases": windows,
        "event_example": {"M": M, "K": K, "N": N, "totals": totals, "bound": 6 * M * K * N},
        "zero_event_bound": 0,
    }


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--write-certificate", action="store_true")
    parser.add_argument(
        "--use-recorded-lean", action="store_true",
        help="Check the official source-bound compiler record instead of recompiling unchanged Lean.",
    )
    args = parser.parse_args()
    certificate = {
        "schema_version": 1,
        "result": "exact universal verification theorem, conditional on the stated comparison hypotheses",
        "not_a_refutation": True,
        "whole_geometric_theorem_certified": False,
        "independent_review": "requires a separate host Reviewer verdict; none is asserted here",
        "novelty_and_publishability": "not established by this certificate",
        "manuscript_bindings": manuscript_bindings(),
        "universal_lean_proof": lean_evidence(args.use_recorded_lean),
        "jacobian_diagnostic": jacobian_evidence(),
        "F2_diagnostics": [
            fixture("far_strict_decrease_with_mixed_image", 10, 1, False, 0, False),
            fixture("far_cancellation_of_previous_deficit", 10, 1, True, 0, False),
            fixture("exceptional_positive_change_noninjective_locals", 2, 3, True, 1, True),
        ],
        "counting_diagnostics": counting_diagnostics(),
    }
    path = HERE / "exact_certificate.json"
    if args.write_certificate:
        path.write_text(json.dumps(certificate, indent=2) + "\n", encoding="utf-8")
    else:
        require(read_json(path) == certificate, "Certificate does not replay exactly")
    print(json.dumps({
        "ok": True,
        "universal_proof": "Lean 4.31.0, zero proof holes",
        "compiler_replay": "source-bound official record" if args.use_recorded_lean else "fresh",
        "F2_diagrams": len(certificate["F2_diagnostics"]),
        "window_diagnostics": certificate["counting_diagnostics"]["window_cases"],
        "independent_review": "not asserted",
    }))
    return 0


if __name__ == "__main__":
    try:
        sys.exit(main())
    except (ValueError, OSError, subprocess.TimeoutExpired) as error:
        print(json.dumps({"ok": False, "error": str(error)}), file=sys.stderr)
        sys.exit(1)
