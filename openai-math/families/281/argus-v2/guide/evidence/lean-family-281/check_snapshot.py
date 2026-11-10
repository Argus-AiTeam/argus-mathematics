#!/usr/bin/env python3
"""Recheck source integrity and statement fidelity; this does not run Lean.

python3 guide/evidence/lean-family-281/check_snapshot.py [--fresh]
--fresh compares with newly fetched pinned GitHub directory/tree metadata.
"""
import argparse
import hashlib
import json
import re
import runpy
import urllib.request
from pathlib import Path

ROOT = Path(__file__).resolve().parent
REPO = "openai/math"
COMMIT = "4eaee87548250b2682affda7d05d947c05554bae"
LIBRARY = ROOT / "upstream/lean/OAI/Probability"
HELPERS = runpy.run_path(str(ROOT / "math-source-closure"))


def blob_hash(data):
    return hashlib.sha1(f"blob {len(data)}\0".encode() + data).hexdigest()


def metadata(path, url, fresh):
    if not fresh:
        return json.loads((ROOT / path).read_text())
    request = urllib.request.Request(url, headers={"User-Agent": "family-281-source-check"})
    with urllib.request.urlopen(request, timeout=90) as response:
        return json.load(response)


def signature(text, name):
    match = re.search(r"\btheorem\s+" + re.escape(name) + r"\b.*?(?=\s*:=\s*by)", text, re.S)
    if not match:
        raise ValueError(f"theorem signature not found: {name}")
    return " ".join(match.group().split())


def check(fresh):
    manifest = json.loads((ROOT / "source-manifest.json").read_text())
    if manifest["repository"] != REPO or manifest["commit"] != COMMIT:
        raise ValueError("unexpected source pin")
    api = f"https://api.github.com/repos/{REPO}"
    expected = {}
    for family in ("SKSupport", "SKValue"):
        stem = "metadata/OAI.Probability." + family
        parent = metadata(stem + ".parent.json",
                          f"{api}/contents/lean/OAI/Probability?ref={COMMIT}", fresh)
        tree_sha = next(item["sha"] for item in parent if item["name"] == family)
        tree = metadata(stem + ".tree.json",
                        f"{api}/git/trees/{tree_sha}?recursive=1", fresh)
        if tree["sha"] != tree_sha or tree["truncated"]:
            raise ValueError("wrong or truncated subtree")
        for item in tree["tree"]:
            if item["type"] == "blob":
                expected[f"upstream/lean/OAI/Probability/{family}/{item['path']}"] = item["sha"]
    resources = (
        ("upstream-lean-directory.json", "lean",
         {"lean-toolchain", "lakefile.lean", "lake-manifest.json", "LICENSE"}),
        ("metadata/comparators.directory.json", "lean/ComparatorChallenges",
         {"SKValue.lean", "SKValue.json", "SKFullSupport.lean", "SKFullSupport.json"}),
    )
    for saved, directory, names in resources:
        listing = metadata(saved, f"{api}/contents/{directory}?ref={COMMIT}", fresh)
        selected = {item["name"]: item for item in listing if item["name"] in names}
        if set(selected) != names:
            raise ValueError(f"missing resource metadata: {directory}")
        for name, item in selected.items():
            expected[f"upstream/{directory}/{name}"] = item["sha"]
    for path, sha in expected.items():
        actual = blob_hash((ROOT / path).read_bytes())
        if actual != sha:
            raise ValueError(f"Git blob mismatch: {path}: {actual} != {sha}")

    modules = manifest["modules"]
    external, hazards, instances, attributes = set(), [], [], []
    hazard = re.compile(r"\b(?:axiom|opaque|sorry|admit|unsafe|partial|native_decide|"
                        r"implemented_by|extern|elab|macro|initialize|run_tac|run_elab)\b"
                        r"|debug\.skipKernelTC")
    for module, item in modules.items():
        path = item["path"]
        if expected[path] != item["git_blob"]:
            raise ValueError(f"manifest hash mismatch: {module}")
        text = (ROOT / path).read_text()
        dependencies = HELPERS["imports"](text)
        if dependencies != item["imports"]:
            raise ValueError(f"import list mismatch: {module}")
        for dependency in dependencies:
            if dependency.startswith("OAI."):
                if dependency not in modules:
                    raise ValueError(f"missing local import: {module} -> {dependency}")
            else:
                external.add(dependency)
        code = HELPERS["lean_code"](text)
        for number, line in enumerate(code.splitlines(), 1):
            entry = {"path": path, "line": number, "source": text.splitlines()[number - 1]}
            if hazard.search(line):
                hazards.append(entry)
            if re.match(r"\s*(?:(?:private|noncomputable|local|scoped)\s+)*instance\b", line):
                instances.append(entry)
            if re.match(r"\s*attribute\s+\[instance\]", line):
                attributes.append(entry)
    if sorted(external) != manifest["external_imports"]:
        raise ValueError("external import boundary mismatch")
    reachable = set()

    def visit(module):
        if module not in reachable:
            reachable.add(module)
            for dependency in modules[module]["imports"]:
                if dependency in modules:
                    visit(dependency)

    for module in manifest["entry_modules"]:
        visit(module)
    if reachable != set(modules):
        raise ValueError("snapshot includes unreachable or missing modules")
    position = {module: i for i, module in enumerate(manifest["dependency_order"])}
    if set(position) != set(modules) or len(position) != len(manifest["dependency_order"]):
        raise ValueError("invalid dependency order")
    for module, item in modules.items():
        for dependency in item["imports"]:
            if dependency in modules and position[dependency] >= position[module]:
                raise ValueError(f"invalid import order: {module} -> {dependency}")

    fidelity = []
    for family, comparator, theorem, namespace in (
        ("SKValue", "SKValue", "value_consequences", "SKValue"),
        ("SKSupport", "SKFullSupport", "full_support", "ZeroTemperatureSK"),
    ):
        model = (LIBRARY / family / "Model.lean").read_text()
        challenge = (ROOT / f"upstream/lean/ComparatorChallenges/{comparator}.lean").read_text()
        main = (LIBRARY / family / "Main.lean").read_text()
        model_prefix = model.split(f"end {namespace}")[0].strip()
        challenge_prefix = challenge.split(f"theorem {theorem}")[0].strip()
        if model_prefix != challenge_prefix:
            raise ValueError(f"comparator/model definitions differ: {family}")
        if signature(main, theorem) != signature(challenge, theorem):
            raise ValueError(f"comparator/solution theorem statements differ: {family}")
        adjacent = json.loads((ROOT / f"upstream/lean/ComparatorChallenges/{comparator}.json").read_text())
        if adjacent["solution_module"] != f"OAI.Probability.{family}.Main":
            raise ValueError(f"wrong solution module: {family}")
        fidelity.append({"family": family, "definitions_text_identical": True,
                         "theorem_signature_whitespace_identical": True,
                         "signature": signature(main, theorem),
                         "solution_module": adjacent["solution_module"],
                         "selected_theorems": adjacent["theorem_names"],
                         "permitted_axioms_policy_only": adjacent["permitted_axioms"]})
    result = {
        "commit": COMMIT, "fresh_upstream_metadata": fresh,
        "verified_git_blobs": len(expected), "oai_modules": len(modules),
        "oai_bytes": sum(item["bytes"] for item in modules.values()),
        "family_module_counts": {family: sum(f".{family}." in m for m in modules)
                                 for family in ("SKSupport", "SKValue")},
        "external_imports_not_traversed": sorted(external),
        "source_keyword_hits_comments_and_strings_excluded": hazards,
        "instance_declarations": instances, "instance_attributes": attributes,
        "comparator_fidelity": fidelity,
        "kernel_compilation": "not performed; see original-entry-verifier.log",
        "measured_axioms": None,
    }
    return result


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--fresh", action="store_true")
    args = parser.parse_args()
    print(json.dumps(check(args.fresh), indent=2, ensure_ascii=False))
