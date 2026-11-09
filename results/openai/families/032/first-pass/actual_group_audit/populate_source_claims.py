#!/usr/bin/env python3
"""Import source assertions, not proof evidence, through the official ledger CLI."""

import argparse
import contextlib
import io
import json
import re
from pathlib import Path

from argus_skill.verticals.math import math_state, proof_graph_check


ROOT = Path(__file__).resolve().parents[2]
HERE = Path(__file__).resolve().parent
WEIL = (
    "research/openai_manuscript/"
    "Weil-classes-and-Hodge-classes-on-abelian-powers-October-6-2026/build/paper.tex"
)
HEAD_DEPENDENCIES = {
    "p3ab:split-sixfolds": [
        "p3:tensor-criterion", "p3ab:small-columns", "p3ab:independence",
        "p3ab:determinant-supply",
    ],
    "p3ab:quadratic-five": [
        "p3:tensor-criterion", "p3ab:small-columns", "p3ab:independence",
        "p3ab:determinant-supply",
    ],
    "p3:cm-operations": [],
    "p3:admissible-operations": [],
    "p3:tensor-stabilizer": [],
    "p3:toric-cm-factor": ["p3:admissible-operations"],
    "p3:tensor-criterion": [
        "p3:cm-operations", "p3:admissible-operations", "p3:toric-cm-factor",
    ],
    "p3:correspondence-transfer": ["p3:cm-operations"],
    "p3sw:weil-plane": [],
    "p3ab:hyperbolic": [],
    "p3ab:determinant-supply": [
        "p3sw:weil-plane", "p3ab:hyperbolic",
        "p3:admissible-operations", "p3:cm-operations",
    ],
    "p3ab:albert-columns": ["p3:admissible-operations"],
    "p3ab:minuscule": ["p3ab:albert-columns"],
    "p3ab:small-projections": ["p3ab:albert-columns", "p3ab:minuscule"],
    "p3ab:small-columns": [
        "p3ab:albert-columns", "p3ab:minuscule", "p3ab:small-projections",
    ],
    "p3ab:independence": ["p3ab:small-columns", "p3:admissible-operations"],
}
CONTEXT_REFERENCES = {
    "ks10:main:generic", "ks10:main:specialization", "ks10:main:all-degrees",
    "ks30:main:theorem", "milne:thm:main",
}
INPUT_CLASSIFICATIONS = {
    "assumption", "conjecture", "established_import_as_cited",
    "additional_manuscript_input",
}


def statement_text(value):
    return value if isinstance(value, str) else json.dumps(value, ensure_ascii=True)


def inventory():
    other = json.loads((HERE / "other_manuscript_claims.json").read_text())
    tail = json.loads((HERE / "weil_tail_claims.json").read_text())
    contexts = {}
    claims = {}
    for manuscript in other["manuscripts"]:
        namespace = manuscript["namespace"]
        definitions = manuscript["contexts_and_definitions"]
        contexts[namespace] = {
            "statement": manuscript["title"],
            "definitions": {
                d["id"]: d["statement"] for d in definitions
            },
        }
        for claim in manuscript["claims"]:
            claims[claim["id"]] = {
                **claim,
                "namespace": namespace,
                "source_path": str(Path(manuscript["source_path_base"]) / claim["source_path"]),
                "dependencies": [] if claim["classification"] in INPUT_CLASSIFICATIONS else [
                    r for r in claim.get("references", [])
                    if r not in CONTEXT_REFERENCES and r != claim["id"]
                ],
            }
    contexts["weil"] = {
        "statement": "Actual-period assertions in Weil classes and Hodge classes on abelian powers (October 6, 2026).",
        "definitions": {
            "coefficients": "Q is the rational field; k is the algebraic closure of Q inside C. Scalar Galois conjugation changes coefficients, not the complex variety.",
            "Hodge_group": "J is the smallest rational algebraic subgroup containing the Hodge circle of H^1(A,Q); R=J^der.",
            "admissible": "A summand is cut out by a k-idempotent all of whose scalar conjugates are Hodge endomorphisms; admissible maps preserve Hodge types in every scalar conjugate.",
            "pair_tensor": "A nondegenerate tensor of type (1,1) in every scalar conjugate, with ordinary tensor symmetry before cohomological Koszul signs.",
            "quadratic_action": "A unital embedding of an imaginary quadratic E into End^0(A), not necessarily central or the full endomorphism algebra.",
            "columns": "For a simple non-CM factor B, D=End_Hdg(H^1(B,Q)) is the actual full division commutant. Primitive matrix idempotents of D_k select columns W_tau; repeated copies are identified only by admissible matrix units.",
            "mixed_pure": "A mixed column has both Hodge-circle weights +1,-1. A pure column has one; scalar conjugation may change this property.",
            "polarization": "A compatible rational Riemann form e satisfies e(ax,y)=e(x,bar(a)y); for u^2=-d, h_E(x,y)=e(x,uy)+u e(x,y), conjugate-linear first.",
            "CM_supply": "Images of full rational cohomology of CM abelian varieties under rational algebraic correspondences, with the appropriate Tate shifts; not just images of their Hodge classes.",
            "tail_definitions": json.dumps(tail["definitions"], ensure_ascii=True),
        },
    }
    text = (ROOT / WEIL).read_text()
    pattern = re.compile(r"\\begin\{(theorem|lemma|proposition|corollary)\}(?:\[[^\]]*\])?")
    for match in pattern.finditer(text):
        start = text.count("\n", 0, match.start()) + 1
        if start > 1610:
            break
        stop = text.index("\\end{" + match.group(1) + "}", match.end())
        body = text[match.end():stop]
        label = re.search(r"\\label\{([^}]+)\}", body).group(1)
        claim_id = "weil:" + label
        claims[claim_id] = {
            "id": claim_id, "namespace": "weil", "label": label,
            "environment": match.group(1), "source_path": WEIL,
            "start_line": start, "end_line": text.count("\n", 0, stop) + 1,
            "statement": body.strip(),
            "audit_status": "asserted_unverified",
            "dependencies": ["weil:" + x for x in HEAD_DEPENDENCIES[label]],
        }
    for claim in tail["claims"]:
        claims[claim["id"]] = {
            **claim, "namespace": "weil",
            "dependencies": ["weil:" + x for x in claim["proof_dependencies"]["claim_labels"]],
        }
    for item in tail["earlier_claims_with_tail_proofs"]:
        claims[item["id"]]["dependencies"].extend(
            "weil:" + x for x in item["proof_dependencies"]["claim_labels"]
        )
    for edge in other["dependency_map"]:
        if edge["relationship"] not in (
            "source_declared_internal_dependency", "additional_external_manuscript_input"
        ):
            continue
        for target in edge["outputs"]:
            if target == "ks30:ext:conditional":
                # This proposition supplies, rather than uses, the later HC/GHC criterion.
                claims[target]["dependencies"].append("ks30:input:one-exact-tensor")
            else:
                claims[target]["dependencies"].extend(edge["inputs"])
    for claim in claims.values():
        claim["dependencies"] = sorted({
            d for d in claim["dependencies"] if d in claims and d != claim["id"]
        })
    return contexts, claims


def cycles(claims):
    active, visited, found = [], set(), []

    def visit(node):
        if node in active:
            found.append(active[active.index(node):] + [node])
            return
        if node in visited:
            return
        active.append(node)
        for dep in claims[node]["dependencies"]:
            visit(dep)
        active.pop()
        visited.add(node)

    for node in claims:
        visit(node)
    return found


def invoke(module, args):
    output = io.StringIO()
    with contextlib.redirect_stdout(output):
        result = module.main(args)
    if result not in (0, None):
        raise RuntimeError(f"{module.__name__} returned {result}: {output.getvalue()}")


def check():
    invoke(math_state, ["check", "--project-root", str(ROOT)])
    invoke(proof_graph_check, ["check", "--project-root", str(ROOT)])


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--write", action="store_true")
    args = parser.parse_args()
    contexts, claims = inventory()
    problems = cycles(claims)
    print(json.dumps({"claims": len(claims), "contexts": len(contexts), "cycles": problems}))
    if problems:
        return 1
    if not args.write:
        return 0
    graph_path = ROOT / "research/PROOF_GRAPH.json"
    graph = json.loads(graph_path.read_text())
    for claim_id, claim in claims.items():
        if claim_id in graph["nodes"]:
            raise ValueError(f"Refusing to overwrite an existing node: {claim_id}")
        graph["nodes"][claim_id] = {
            "statement": statement_text(claim["statement"]),
            "status": "open", "reviewer_confirmed": False,
            "depends_on": claim["dependencies"],
            "evidence": [claim["source_path"]],
            "source_lines": [claim["start_line"], claim["end_line"]],
            "source_environment": claim.get("environment", claim.get("kind")),
            "assertion_origin": "staged_manuscript_not_verified_evidence",
        }
    graph_path.write_text(json.dumps(graph, indent=2, ensure_ascii=True) + "\n")
    check()
    mutations = 1
    for namespace, context in contexts.items():
        command = [
            "context", "--project-root", str(ROOT), "--id", "SRC-" + namespace,
            "--statement", context["statement"],
            "--define", "audit_status=Source assertions are audit targets, not accepted inputs or verified evidence.",
        ]
        for key, value in context["definitions"].items():
            command.extend(["--define", key + "=" + value])
        invoke(math_state, command)
        check()
        mutations += 1
    for claim_id, claim in claims.items():
        invoke(math_state, [
            "claim", "--project-root", str(ROOT), "--id", claim_id,
            "--context", "SRC-" + claim["namespace"],
            "--statement", statement_text(claim["statement"]),
        ])
        check()
        mutations += 1
    progress_path = ROOT / "roles/engineer/progress.json"
    progress = json.loads(progress_path.read_text())
    progress["source_decomposition"] = {
        "staged_tex_files_read": 21,
        "source_claims_recorded": len(claims),
        "source_contexts_recorded": len(contexts),
        "mathematical_status": "asserted_unverified",
    }
    progress["campaign_local_validation"] = {
        "project_root": str(ROOT),
        "math_state_exit_code": 0,
        "proof_graph_exit_code": 0,
        "checked_mutations": mutations,
        "method": "Official module main entrypoints under the approved absolute Python interpreter; both checks after every mutation.",
    }
    progress_path.write_text(json.dumps(progress, indent=2) + "\n")
    print(json.dumps(progress["campaign_local_validation"]))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
