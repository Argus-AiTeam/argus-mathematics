#!/usr/bin/env python3
"""Rebuild and certify the full theorem; finite fixtures are calibration only."""

from __future__ import annotations

import hashlib
import json
import math
import os
from pathlib import Path
import re
import shutil
import subprocess
from dataclasses import dataclass
from datetime import datetime, timezone
from fractions import Fraction as Q


HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[2]
ARGUS = Path("$WORKSPACE/argus-live-update/.venv/bin/python")
WORKSPACE = Path("$WORKSPACE/.local/share/argus-skill/mathlib-v4.31.0")
CLAIM = "C_SHARED_MIXED_TRACE"
THEOREM = "SharedTrace.mixed_trace_estimate"
MODULES = (
    "cubic/SpectralCubic.lean",
    "hessian/Hessian.lean",
    "assembly/General.lean",
    "assembly/Blocks.lean",
    "assembly/Trace.lean",
    "assembly/Phase.lean",
    "assembly/Projections.lean",
)


@dataclass(frozen=True)
class G:
    re: Q = Q(0)
    im: Q = Q(0)

    def __add__(self, other: G) -> G:
        return G(self.re + other.re, self.im + other.im)

    def __neg__(self) -> G:
        return G(-self.re, -self.im)

    def __sub__(self, other: G) -> G:
        return self + -other

    def __mul__(self, other: G) -> G:
        return G(
            self.re * other.re - self.im * other.im,
            self.re * other.im + self.im * other.re,
        )

    def conj(self) -> G:
        return G(self.re, -self.im)

    def scale(self, value: Q) -> G:
        return G(self.re * value, self.im * value)

    def normsq(self) -> Q:
        return self.re**2 + self.im**2

    def json(self) -> dict[str, str]:
        return {"real": str(self.re), "imag": str(self.im)}


ZERO = G()
ONE = G(Q(1))
I = G(Q(0), Q(1))
Matrix = list[list[G]]


def total(values) -> G:
    result = ZERO
    for value in values:
        result = result + value
    return result


def adjoint(a: Matrix) -> Matrix:
    return [[a[i][j].conj() for i in range(len(a))] for j in range(len(a[0]))]


def mul(a: Matrix, b: Matrix) -> Matrix:
    assert len(a[0]) == len(b), "incompatible fixture matrix dimensions"
    return [
        [total(a[i][k] * b[k][j] for k in range(len(b))) for j in range(len(b[0]))]
        for i in range(len(a))
    ]


def scale(a: Matrix, value: G) -> Matrix:
    return [[value * entry for entry in row] for row in a]


def trace(a: Matrix) -> G:
    assert len(a) == len(a[0]), "fixture trace is not square"
    return total(a[i][i] for i in range(len(a)))


def identity(n: int) -> Matrix:
    return [[ONE if i == j else ZERO for j in range(n)] for i in range(n)]


def outer(u: list[G], v: list[G], coefficient: G = ONE) -> Matrix:
    return [[coefficient * x * y.conj() for y in v] for x in u]


def diagonal(entries: list[G]) -> Matrix:
    return [
        [entries[i] if i == j else ZERO for j in range(len(entries))]
        for i in range(len(entries))
    ]


def product(*matrices: Matrix) -> Matrix:
    result = matrices[0]
    for matrix in matrices[1:]:
        result = mul(result, matrix)
    return result


def triangle(edges: list[Matrix]) -> Matrix:
    dimensions = [len(w) for w in edges]
    offsets = [0, dimensions[0], dimensions[0] + dimensions[1]]
    n = sum(dimensions)
    result = [[ZERO for _ in range(n)] for _ in range(n)]
    for v, edge in enumerate(edges):
        w = (v + 1) % 3
        for i, row in enumerate(edge):
            for j, entry in enumerate(row):
                result[offsets[v] + i][offsets[w] + j] = entry
                result[offsets[w] + j][offsets[v] + i] = entry.conj()
    return result


def block_diagonal(blocks: list[Matrix]) -> Matrix:
    n = sum(len(block) for block in blocks)
    result = [[ZERO for _ in range(n)] for _ in range(n)]
    offset = 0
    for block in blocks:
        for i, row in enumerate(block):
            for j, entry in enumerate(row):
                result[offset + i][offset + j] = entry
        offset += len(block)
    return result


def stars(edges: list[Matrix]) -> list[Matrix]:
    return [
        [left + right for left, right in zip(edges[v], adjoint(edges[(v - 1) % 3]))]
        for v in range(3)
    ]


def rational_sqrt(value: Q) -> Q:
    a, b = math.isqrt(value.numerator), math.isqrt(value.denominator)
    assert a * a == value.numerator and b * b == value.denominator
    return Q(a, b)


def fixture(name: str, vectors: list[list[G]], coefficients: list[G],
            insertions: list[Matrix]) -> dict:
    assert all(total(x.conj() * x for x in u) == ONE for u in vectors)
    for d in insertions:
        assert adjoint(d) == d
        assert mul(d, d) == identity(len(d)), "fixture D_star must equal one"
    edges = [outer(vectors[v], vectors[(v + 1) % 3], coefficients[v]) for v in range(3)]
    rows = stars(edges)
    grams = [mul(adjoint(r), r) for r in rows]
    directions = [product(adjoint(r), d, r) for r, d in zip(rows, insertions)]
    expectations = [
        total(u[i].conj() * total(d[i][j] * u[j] for j in range(len(u)))
              for i in range(len(u))).re
        for u, d in zip(vectors, insertions)
    ]
    eigenvalues = [
        coefficients[v].normsq() + coefficients[(v - 1) % 3].normsq()
        for v in range(3)
    ]
    lower_energy = Q(0)
    spectral_costs = []
    for t, k, eigenvalue, d in zip(grams, directions, eigenvalues, expectations):
        assert k == scale(t, G(d)), "supported insertion identity"
        assert mul(t, t) == scale(t, G(eigenvalue)), "rank-one Gram polynomial"
        assert trace(t) == G(eigenvalue)
        assert eigenvalue.denominator == 1
        lower = math.isqrt(eigenvalue.numerator)
        assert lower * lower <= eigenvalue < (lower + 1) ** 2
        lower_energy += Q(3, 4) * d * d * eigenvalue * lower
        spectral_costs.append({
            "positive_eigenvalue": str(eigenvalue),
            "coefficient_of_sqrt_eigenvalue": str(Q(3, 4) * d * d * eigenvalue),
            "gram_dimension": len(t),
            "gram_rank": 0 if eigenvalue == 0 else 1,
        })
    tau = trace(product(insertions[0], edges[0], insertions[1], edges[1],
                        insertions[2], edges[2]))
    tau_abs = rational_sqrt(tau.normsq())
    assert tau_abs <= Q(5, 3) * lower_energy
    dblock = block_diagonal(insertions)
    dm = mul(dblock, triangle(edges))
    assert trace(product(dm, dm, dm)) == G(6 * tau.re)
    phase = tau.conj().scale(1 / tau_abs) if tau_abs else ONE
    assert phase.normsq() == 1 and phase * tau == G(tau_abs)
    changed = [scale(edges[0], phase), edges[1], edges[2]]
    changed_rows = stars(changed)
    multipliers = [
        diagonal([phase] * len(vectors[1]) + [ONE] * len(vectors[2])),
        diagonal([ONE] * len(vectors[2]) + [phase.conj()] * len(vectors[0])),
        identity(len(vectors[0]) + len(vectors[1])),
    ]
    for r, rp, v, t, k, d in zip(rows, changed_rows, multipliers, grams,
                                 directions, insertions):
        assert rp == mul(r, v)
        assert mul(adjoint(rp), rp) == product(adjoint(v), t, v)
        assert product(adjoint(rp), d, rp) == product(adjoint(v), k, v)
    aligned = trace(product(insertions[0], changed[0], insertions[1], changed[1],
                            insertions[2], changed[2]))
    assert aligned == G(tau_abs)
    dm_aligned = mul(dblock, triangle(changed))
    assert trace(product(dm_aligned, dm_aligned, dm_aligned)) == G(6 * tau_abs)
    return {
        "name": name, "dimensions": [len(u) for u in vectors],
        "tau": tau.json(), "tau_abs": str(tau_abs),
        "aligning_phase": phase.json(), "D_star": "1",
        "supported_spectral_costs": spectral_costs,
        "rhs_exact_rational_lower_bound": str(Q(5, 3) * lower_energy),
    }


def exact_fixtures() -> list[dict]:
    unequal = [[G(Q(3, 5)), G(Q(0), Q(4, 5))], [ZERO, ZERO, ONE], [ONE]]
    d0 = [[ZERO, I], [-I, ZERO]]
    ds = [d0, diagonal([ONE, -ONE, ONE]), [[ONE]]]
    cases = [
        fixture("purely_imaginary_triangle", [[ONE]] * 3, [I, ONE, ONE], [[[ONE]]] * 3),
        fixture("unequal_singular_complex_insertions", unequal,
                [G(Q(3, 5), Q(4, 5)), G(Q(2)), I], ds),
        fixture("zero_grams", unequal, [ZERO, ZERO, ZERO], ds),
    ]
    for j, phase in enumerate([ONE, -ONE, I, -I, G(Q(3, 5), Q(4, 5))]):
        cases.append(fixture(f"unit_phase_{j}", unequal, [phase, ONE, ONE], ds))
    return cases


def source_digests() -> dict[str, str]:
    return {
        str((HERE / name).relative_to(ROOT)): hashlib.sha256((HERE / name).read_bytes()).hexdigest()
        for name in (*MODULES, "Main.lean")
    }


def main() -> None:
    assert (ROOT / "research/MATH_STATE.json").is_file(), "not the campaign root"
    fixtures = exact_fixtures()
    payload = json.loads((HERE / "jacobian_determinant_payload.json").read_text())
    jacobian = json.loads((HERE / "jacobian_determinant_output.json").read_text())
    assert jacobian["request"]["payload"] == payload
    assert jacobian["result"]["operation_id"] == "matrix.determinant.compute"
    assert jacobian["result"]["output"]["determinant"] == {"num": "0", "den": "1"}
    lean, lake = shutil.which("lean"), shutil.which("lake")
    assert lean and lake and ARGUS.is_file() and WORKSPACE.is_dir(), "required toolchain missing"
    environment = os.environ.copy()
    library_path = subprocess.check_output(
        [lake, "env", "printenv", "LEAN_PATH"], cwd=WORKSPACE, text=True,
    ).strip()
    environment["LEAN_PATH"] = os.pathsep.join(
        [str(HERE / directory) for directory in ("cubic", "hessian", "assembly")]
        + [library_path]
    )
    version = subprocess.check_output(
        [lake, "env", "lean", "--version"], cwd=WORKSPACE, env=environment, text=True,
    ).strip()
    assert "version 4.31.0," in version, version
    before = source_digests()
    with (HERE / "rebuild.log").open("w") as log:
        for name in MODULES:
            source = HERE / name
            command = [lean, "-o", str(source.with_suffix(".olean")), str(source)]
            print(" ".join(command), file=log, flush=True)
            subprocess.run(command, cwd=ROOT, env=environment, stdout=log,
                           stderr=subprocess.STDOUT, check=True)
    command = [
        str(ARGUS), "-m", "argus_skill.verticals.math.lean_evidence", "verify",
        str(HERE / "Main.lean"), "--statement-fidelity", str(HERE / "statement_fidelity.md"),
        "--artifact-dir", str(HERE), "--project-root", str(ROOT), "--claim", CLAIM,
    ]
    completed = subprocess.run(command, cwd=ROOT, env=environment, capture_output=True, text=True)
    (HERE / "native_verification_stdout.json").write_text(completed.stdout)
    (HERE / "native_verification_stderr.txt").write_text(completed.stderr)
    completed.check_returncode()
    native = json.loads(completed.stdout)
    assert native["status"] == "success" and native["exit_code"] == 0
    assert native["proof_holes"] == [] and native["audit_exit_code"] == 0
    assert native["kernel"]["recorded"] is not None, "official claim recording refused"
    match = re.search(
        rf"'{re.escape(THEOREM)}' depends on axioms: \[([^\]]*)\]", native["stdout"],
    )
    assert match, "final theorem's transitive axiom report is missing"
    axioms = {item.strip() for item in match.group(1).split(",") if item.strip()}
    assert axioms <= {"propext", "Classical.choice", "Quot.sound"}, axioms
    assert source_digests() == before, "a local proof dependency changed during replay"
    checks = {}
    for module in ("math_state", "proof_graph_check"):
        result = subprocess.run(
            [str(ARGUS), "-m", f"argus_skill.verticals.math.{module}", "check",
             "--project-root", str(ROOT)], cwd=ROOT, capture_output=True, text=True,
        )
        checks[module] = {"exit_code": result.returncode, "stdout": result.stdout,
                          "stderr": result.stderr}
        result.check_returncode()
    certificate = {
        "claim_id": CLAIM,
        "result_class": "formal_verification",
        "theorem": THEOREM,
        "statement": "|tr(D0 W0 D1 W1 D2 W2)| <= (5/3) D_star sum_v b_(R_v^* R_v)(R_v^* D_v R_v)",
        "field": "complex",
        "dimensions": "arbitrary independent finite index types, including empty types",
        "hypotheses": ["D0 Hermitian", "D1 Hermitian", "D2 Hermitian"],
        "singular_grams_allowed": True,
        "supported_hessian": "exact positive-spectrum definition; see b_spectral_positive",
        "literal_sources": [
            {"directory": "The-maximal-triangular-Hilbert-transform-at-the-symmetric-point-September-24-2026",
             "file": "build/sections/trace.tex", "label": "lem:mixed-trace", "domain": "complex"},
            {"directory": "Annular-variation-of-the-triangular-Hilbert-transform-at-the-symmetric-point-October-5-2026",
             "file": "build/sections/matrix.tex", "label": "lem:mixed-trace", "domain": "complex"},
            {"directory": "An-L3-bound-for-the-dyadic-triangular-Hilbert-form-October-5-2026",
             "file": "build/sections/03-trace.tex", "label": "prop:trace", "domain": "real contractions"},
        ],
        "completed_at": datetime.now(timezone.utc).isoformat(),
        "compiler_version": version,
        "source_sha256": before,
        "axioms": sorted(axioms),
        "official_lean_evidence": native,
        "campaign_checks": {"project_root": str(ROOT), **checks},
        "finite_calibration_only": fixtures,
        "archived_jacobian_calibration": jacobian,
        "independent_review_required": True,
        "not_claimed": [
            "independent Reviewer acceptance or verified mathematical novelty",
            "a counterexample to any manuscript assertion",
            "an optimal coefficient or a new inequality statement",
            "any downstream maximal, variation, or dyadic analytic theorem",
        ],
    }
    (HERE / "exact_certificate.json").write_text(json.dumps(certificate, indent=2) + "\n")
    print(f"{THEOREM}: Lean 4.31.0 exit_code=0, proof_holes=[], {len(fixtures)} exact calibration cases")
    print(f"Campaign checks: {ROOT}; math_state=0, proof_graph_check=0")


if __name__ == "__main__":
    main()
