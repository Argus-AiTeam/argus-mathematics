#!/usr/bin/env python3
"""Verify source provenance and audit bookkeeping, NOT Lean theorem validity."""

import functools
import hashlib
import json
import re
from pathlib import Path

from fetch_closure import ROOT, inspect


def main():
    manifest = json.loads((ROOT / "dependency_manifest.json").read_text())
    graph, missing, external = inspect()
    assert manifest["complete"] is True
    assert graph == manifest["modules"]
    assert not missing
    assert external == ["Mathlib"]
    assert len(graph) == 85
    assert sum(item["bytes"] for item in graph.values()) == 2875278
    assert sum(item["lines"] for item in graph.values()) == 65284
    assert sum(sum(dependency in graph for dependency in item["imports"])
               for item in graph.values()) == 100
    assert all("Mathlib" in item["imports"] for item in graph.values())

    @functools.lru_cache(None)
    def depth(module):
        return 1 + max(
            [depth(dependency) for dependency in graph[module]["imports"]
             if dependency in graph] or [0]
        )

    assert depth("OAI.CategoryTheory.Thomason.RankedFaithfulness") == 76
    assert depth("OAI.CategoryTheory.Thomason.CoreCouniversality") == 72

    base = ROOT / "vendor/lean/OAI/CategoryTheory/Thomason"
    anchors = {
        "Definitions.lean": [
            "structure OmegaCategory where",
            "noncomputable def IsTruncated (n : ℕ) : Prop := ∀ x : C.Cell, C.source n x = x",
            "noncomputable def NCategory (n : ℕ) :=",
            "obj m := OAI.Thomason.OmegaCategory.Functor (OAI.Thomason.orientals.obj m.unop) C",
            "OAI.Thomason.WeakHomotopy.Equivalence (SSet.toTop.map f).hom",
        ],
        "AttachmentComparison.lean": [
            "theorem poset_couniversal",
            "theorem omega_poset_couniversal",
            "(sq : IsPushout a (AttachmentComparison.inc n A) j v)",
        ],
        "RankedFaithfulness.lean": [
            "theorem standardSimplexComparison_isIso (m : ℕ)",
            "theorem chainComparison_finiteSimplex_onCells_bijective",
        ],
        "StandardComparison.lean": [
            "def intervalExtensionOfSimplexIsIso",
            "lemma simplexComparison_isIso_of_standard",
        ],
    }
    for filename, snippets in anchors.items():
        text = (base / (filename + ".txt")).read_text()
        for snippet in snippets:
            assert snippet in text, (filename, snippet)

    mathlib = ROOT / "vendor/mathlib_metadata"
    umbrella = (mathlib / "Mathlib.lean.txt").read_text()
    imports = re.findall(
        r"^\s*(?:public\s+)?import\s+([A-Za-z0-9_.]+)", umbrella, re.MULTILINE
    )
    assert len(imports) == len(set(imports)) == 8531
    assert sum(module.startswith("Mathlib.") for module in imports) == 8529
    assert len(json.loads((mathlib / "lake-manifest.json").read_text())["packages"]) == 8
    pushout = (mathlib / "Mathlib/CategoryTheory/Limits/Shapes/Pullback/"
               "IsPullback/Defs.lean.txt").read_text()
    assert "structure IsPushout" in pushout
    assert "isColimit' : Nonempty (IsColimit (PushoutCocone.mk _ _ w))" in pushout

    assert (ROOT / "vendor/lean/lean-toolchain").read_text().strip() == (
        "leanprover/lean4:v4.34.1"
    )
    for license_path in [ROOT / "vendor/lean/LICENSE", mathlib / "LICENSE"]:
        assert "Apache License" in license_path.read_text()

    vendor_status = json.loads((ROOT / "VENDOR_STATUS.json").read_text())
    assert vendor_status["certified"] is False
    for relative, expected in vendor_status["file_sha256"].items():
        actual = hashlib.sha256((ROOT / relative).read_bytes()).hexdigest()
        assert actual == expected, relative

    failure = json.loads((ROOT / "toolchain_compatibility_probe.json").read_text())
    assert failure["exit_code"] == 1
    assert "incompatible header" in failure["stdout"]
    assert failure["command"] == ["lean", "+leanprover/lean4:v4.34.1", "--stdin"]
    assert not list(ROOT.glob("*.lean"))
    assert not list((ROOT / "vendor").rglob("*.lean"))
    assert (ROOT / "CouniversalityWrapper.lean.txt").is_file()

    print(json.dumps({
        "source_snapshot_integrity": "pass",
        "oai_module_count": 85,
        "oai_lines": 65284,
        "oai_bytes": 2875278,
        "mathlib_umbrella_direct_imports": 8531,
        "recorded_native_toolchain_probe_exit_code": 1,
        "lean_couniversality_compiled": False,
        "lean_couniversality_certified": False,
        "validation_scope": "source snapshot and recorded environment obstruction only",
    }, indent=2))


if __name__ == "__main__":
    main()
