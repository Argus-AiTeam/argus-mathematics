#!/usr/bin/env python3
"""Replay exact algebra and the source-bound real Lean certificate."""

import argparse
import hashlib
import itertools
import json
from pathlib import Path
import re
import subprocess

import sympy as sp


HERE = Path(__file__).resolve().parent
ROOT = HERE.parent.parent
PYTHON = "$WORKSPACE/argus-live-update/.venv/bin/python"
SOURCE = ROOT / (
    "research/openai_manuscript/"
    "A-Complete-Local-Domain-Without-a-Small-Cohen-Macaulay-Module-"
    "September-23-2026/build/paper.tex"
)


def require(condition, message):
    if not condition:
        raise AssertionError(message)


def algebra():
    identities = []

    def identity(name, left, right, interpretation):
        require(sp.cancel(left - right) == 0, f"identity failed: {name}")
        identities.append({"name": name, "residual": "0", "interpretation": interpretation})

    N, S, T, j, n = sp.symbols("N S T j n")
    old = N * T - S**2
    new = N * (T + (2 * j + 1) * n) - (S + n)**2
    identity(
        "all_length_layer_induction",
        new - old,
        n * ((2 * j + 1) * N - 2 * S - n),
        "Any next index j; S<=j*N and 0<=n<=N make the increment nonnegative.",
    )
    a, b = sp.symbols("a b")
    identity(
        "layer_increment_nonnegative_decomposition",
        (2 * j + 1) * N - 2 * S - n,
        (N - n) + 2 * (j * N - S),
        "The bracket is a sum of the two known nonnegative deficits.",
    )
    d, z, t = sp.symbols("d z t")
    character = n + d * t + z * t**2
    twisted_difference = sp.Poly(
        sp.expand(character * (t + t**2 / 2)), t
    )
    truncated = sum(twisted_difference.nth(i) * t**i for i in range(3))
    identity(
        "cartier_conormal_character",
        truncated,
        n * t + (d + n / 2) * t**2,
        "Q_j(1)-Q_j has character (0,n_j,d_j+n_j/2); arbitrary ch2 cancels.",
    )
    c, e = sp.symbols("c e")
    identity(
        "twist_invariance",
        2 * (e + b * c + N * b**2 / 2) / N - ((c + N * b) / N)**2,
        2 * e / N - (c / N)**2,
        "For N!=0, v(F(b))=v(F), including coherent sheaves with torsion.",
    )
    x, m, w = sp.symbols("x m w")
    identity(
        "midpoint_deficit",
        (b - a)**2 / 4 - (x - (a + b) / 2)**2,
        (x - a) * (b - x),
        "The deficit is nonnegative whenever a<=x<=b.",
    )
    identity(
        "centering_atom",
        w * (x - a)**2 - w * (x - m)**2,
        w * (m - a)**2 + 2 * w * (x - m) * (m - a),
        "On summing, sum w=1 and sum w*x=m eliminate the cross term.",
    )
    q, M = sp.symbols("q M")
    identity(
        "mixture_atom",
        w * (2 * q - x**2) + w * (x - M)**2,
        2 * w * q - 2 * M * w * x + M**2 * w,
        "The finite-sum identity is independently proved for all finite types in Lean.",
    )
    chi, h, u, mu, k, ch, gk = sp.symbols("chi h u mu k ch gk")
    rr_m = mu - k / (2 * h) - sp.Rational(3, 2)
    rr_q = chi / h + ch / (u * h) - gk / (2 * u * h) - 1 - 3 * rr_m / 2
    rr_rhs = (
        sp.Rational(1, 4) + 2 * chi / h
        + (2 * ch / u - gk / u) / h - (mu - k / (2 * h))**2
    )
    identity(
        "surface_rr_variance",
        2 * rr_q - rr_m**2,
        rr_rhs,
        "Formal rational identity for nonzero h,u, not a geometric RR proof.",
    )
    g2, gH, K2, c2 = sp.symbols("g2 gH K2 c2")
    identity(
        "hodge_completion",
        (g2 - gk) / h - (gH / h - k / (2 * h))**2,
        (g2 - gk + K2 / 4) / h - (gH - k / 2)**2 / h**2 - K2 / (4 * h),
        "g2=(c1/u)^2, gk=(c1/u).K and gH=(c1/u).H; Hodge bounds the first two terms.",
    )
    identity(
        "noether_substitution",
        sp.Rational(1, 4) + 2 * (K2 + c2) / (12 * h) - K2 / (4 * h),
        sp.Rational(1, 4) - (K2 - 2 * c2) / (12 * h),
        "Uses the separately cited geometric identity 12*chi=K2+c2.",
    )
    variance = sp.symbols("variance")
    identity(
        "positive_denominator_assembly",
        c - (3 + 12 * variance) * h,
        12 * h * (c / (12 * h) - sp.Rational(1, 4) - variance),
        "h>0 preserves the inequality; variance<1/4 gives c<6h.",
    )
    r, sB, sG = sp.symbols("r sB sG")
    identity(
        "slope_potential_increment",
        ((r - b) * sB + b * (sG + 1)) / r - ((r - b) * sB + b * sG) / r,
        b / r,
        "Rank b of the last factor is positive; total rank r is fixed.",
    )
    identity(
        "restriction_negative_control_syzygy",
        (-x) * t + t * x,
        0,
        "The ideal (t,x) is torsion-free, but its t=0 presentation has relation (-x,0).",
    )
    return identities


def regressions():
    count = 0
    for N in range(1, 5):
        for length in range(6):
            for ranks in itertools.product(range(N + 1), repeat=length):
                direct = N * sum((2 * j + 1) * n for j, n in enumerate(ranks)) - sum(ranks)**2
                factors = sum(n * (N - n) for n in ranks) + 2 * sum(
                    ranks[j] * (N - ranks[l])
                    for j in range(length) for l in range(j)
                )
                require(direct == factors and direct >= 0, "layer regression failed")
                count += 1
    require(sp.Rational(1, 2) * (0 - sp.Rational(1, 2))**2
            + sp.Rational(1, 2) * (1 - sp.Rational(1, 2))**2
            == sp.Rational(1, 4), "width-one endpoint is not sharp")
    require(sp.Rational(99, 100)**2 / 4 < sp.Rational(1, 4),
            "strict-width endpoint regression failed")
    ranks, degrees = [2, 1, 0], [0, 4, 5]
    twice_ch2 = sum(2 * d + n for d, n in zip(degrees, ranks))
    torsion_defect = 2 * twice_ch2 - sum(ranks)**2
    require(torsion_defect == 33, "torsion-bearing layer regression failed")
    return {
        "classification": "finite regressions only, not the universal proof",
        "layer_cases": count,
        "max_layers": 5,
        "ranks_include_zero_and_nonmonotone": True,
        "width_one_variance": "1/4",
        "strict_width_99_over_100_variance": "9801/40000",
        "torsion_layer_defect": torsion_defect,
        "negative_control": {
            "module": "(t,x) in C[t,x,y], which is torsion-free but not reflexive",
            "restriction_presentation": "C[x,y]^2 / C[x,y]*(-x,0)",
            "nonzero_torsion_class": "first basis vector, killed by x; nonzero by specializing x=0",
            "manuscript_refutation": False,
        },
    }


def source_bindings():
    text = SOURCE.read_text()
    anchors = [
        "thm:obstruction", "sec:cone", "sec:balancing", "lem:balance",
        "sec:lattice", "lem:lattice", "eq:Tor", "eq:layers",
        "lem:factor", "eq:RR-variance", "eq:mixture",
    ]
    bindings = []
    for label in anchors:
        token = "\\label{" + label + "}"
        require(text.count(token) == 1, f"missing or ambiguous source anchor {label}")
        bindings.append({"label": label, "line": text[:text.index(token)].count("\n") + 1})
    compact = "".join(text.split())
    require(r"K_X^2-2c_2(X)\leq6H^2" in compact, "the target inequality changed")
    require(r"[Q_j(1)]-[Q_j]" in compact, "the source conormal sign changed")
    require(r"0\longrightarrowG(H)\longrightarrow\cE'|_X" in compact,
            "the source elementary-transform sign changed")
    return {"path": str(SOURCE.relative_to(ROOT)), "anchors": bindings}


def lean_evidence():
    state = json.loads((ROOT / "research/MATH_STATE.json").read_text())
    claims = [c for c in state["claims"] if c["claim_id"] == "C_NG_ALG"]
    require(bool(claims), "formal claim missing")
    claim = max(claims, key=lambda c: c["version"])
    records = [
        e for e in state["evidence"]
        if e["subject"]["subject_id"] == "C_NG_ALG"
        and e["subject"]["content_hash"] == claim["content_hash"]
        and e["tier"] == "mechanical" and e["verdict"] == "supports"
    ]
    require(bool(records), "no current mechanically supported formal claim")
    record = records[-1]
    certificate_path = ROOT / record["artifact"]
    certificate = json.loads(certificate_path.read_text())
    check = certificate["lean_check"]
    require(check["status"] == "success", "Lean did not succeed")
    require(check["exit_code"] == 0 and check["audit_exit_code"] == 0,
            "compiler or axiom audit was not successful")
    require(check["proof_holes"] == [], "Lean proof has holes")
    require("4.31.0" in check["tools"]["lean"]["version"], "wrong Lean version")
    for local_name, archived_key, digest_key in [
        ("Main.lean", "lean_source", "source_sha256"),
        ("statement_fidelity.md", "statement_fidelity", "statement_fidelity_sha256"),
    ]:
        content = (HERE / local_name).read_bytes()
        archived = certificate[archived_key]
        require(content.decode() == archived["text"], f"{local_name} differs from the certified text")
        require(content == (ROOT / archived["path"]).read_bytes(), f"archived {local_name} changed")
        require(hashlib.sha256(content).hexdigest() == check[digest_key],
                f"stale compiler digest for {local_name}")
    require(claim["formal_statement"] == (HERE / "Main.lean").read_text(),
            "the ledger formal statement differs from this source")
    declarations = re.findall(r"^theorem\s+([A-Za-z0-9_]+)", (HERE / "Main.lean").read_text(), re.M)
    require({
        "layer_quadratic_nonneg", "layer_chern_nonneg",
        "weighted_variance_strict", "no_infinite_modifications",
        "factor_upper_bound", "full_numeric_obstruction",
    }.issubset(declarations), "a load-bearing formal declaration is missing")
    return {
        "claim": "C_NG_ALG",
        "certificate": record["artifact"],
        "evidence_id": record["evidence_id"],
        "compiler_exit_code": check["exit_code"],
        "axiom_audit_exit_code": check["audit_exit_code"],
        "proof_holes": check["proof_holes"],
        "source_and_fidelity_match": True,
        "version": "4.31.0",
        "declarations": ["NongradedObstruction." + name for name in declarations],
        "geometric_theorem_kernel_formalized": False,
    }


def jacobian_evidence():
    discovery = json.loads((HERE / "jacobian-discovery.json").read_text())
    contract = json.loads((HERE / "jacobian-contract.json").read_text())
    payload = json.loads((HERE / "jacobian-payload.json").read_text())
    response = json.loads((HERE / "jacobian-output.json").read_text())
    operation = "polynomial.box.enclosure.compute"
    require(any(m["operation_id"] == operation for m in discovery["result"]["matches"]),
            "operation was not discovered")
    require(contract["result"]["operation"]["operation_id"] == operation,
            "wrong inspected contract")
    require(response["request"] == {"operation_id": operation, "payload": payload},
            "Jacobian result is bound to another payload")
    require(response["result"]["operation_id"] == operation, "wrong executed operation")
    require(response["server"] == contract["server"], "Jacobian server versions differ")
    output = response["result"]["output"]
    require(output["polynomial"] == payload["polynomial"] and output["box"] == payload["box"],
            "typed output did not retain the requested source")
    require(output["enclosure"] == {
        "lower": {"num": "0", "den": "1"}, "upper": {"num": "1", "den": "1"}
    }, "unexpected product enclosure")
    return {
        "operation_id": operation,
        "server_version": response["server"]["version"],
        "protocol_version": response["protocol_version"],
        "transport": response["transport"],
        "adapter_status": "success",
        "structured_error": None,
        "timeout": False,
        "enclosure": "[0,1]",
        "scope": "a*b on [0,1]^2, a normalized nonnegative lattice-defect factor only",
    }


def project_checks():
    statuses = {}
    for module in ["math_state", "proof_graph_check"]:
        command = [
            PYTHON, "-m", f"argus_skill.verticals.math.{module}",
            "check", "--project-root", str(ROOT),
        ]
        completed = subprocess.run(command, cwd=ROOT, capture_output=True, text=True, check=False)
        statuses[module] = completed.returncode
        require(completed.returncode == 0,
                f"{module} failed:\n{completed.stdout}\n{completed.stderr}")
    return {"project_root": str(ROOT), "exit_statuses": statuses}


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--write-certificate", action="store_true")
    parser.add_argument("--check-project", action="store_true")
    args = parser.parse_args()
    certificate = {
        "claim": "C_NG",
        "conclusion": "A finite nonzero MCM module implies K_X^2-2*c2(X)<6*H^2.",
        "classification": "geometric proof with kernel-checked universal real algebra",
        "geometric_proof": "research/nongraded-obstruction/REPORT.md",
        "independent_review_required": True,
        "novelty": "strict boundary improvement; global priority not established by this verifier",
        "source": source_bindings(),
        "symbolic_identities": algebra(),
        "finite_regressions": regressions(),
        "lean": lean_evidence(),
        "jacobian": jacobian_evidence(),
        "not_proved_by_this_script": [
            "correctness of the prose sheaf-theoretic proof and the external surface theorems",
            "independent Reviewer acceptance or global novelty",
            "formal verification of the full scheme-theoretic implication in Lean",
            "the explicit Hirzebruch-Kummer surface construction",
        ],
    }
    path = HERE / "exact_certificate.json"
    if args.write_certificate:
        path.write_text(json.dumps(certificate, indent=2, ensure_ascii=True) + "\n")
    else:
        require(json.loads(path.read_text()) == certificate, "exact certificate is not reproducible")
    summary = {
        "status": "pass",
        "symbolic_identities": len(certificate["symbolic_identities"]),
        "finite_regression_cases": certificate["finite_regressions"]["layer_cases"],
        "lean_exit_code": certificate["lean"]["compiler_exit_code"],
        "proof_holes": certificate["lean"]["proof_holes"],
        "geometric_review": "required; not supplied by this executable",
    }
    if args.check_project:
        checks = project_checks()
        (HERE / "campaign-checks.json").write_text(json.dumps(checks, indent=2) + "\n")
        summary["campaign_checks"] = checks
    print(json.dumps(summary, indent=2))


if __name__ == "__main__":
    main()
