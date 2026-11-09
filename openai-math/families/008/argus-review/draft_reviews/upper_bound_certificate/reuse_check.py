"""Check eligibility to reuse the preserved Lean receipt without rebuilding it."""

import hashlib
import json
from pathlib import Path
import subprocess


OLD = Path("campaigns/9000008")
HERE = OLD / "research/upper_bound_certificate"


def digest(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def main():
    certificate = json.loads((HERE / "exact_certificate.json").read_text())
    build = json.loads((HERE / "build_receipt.json").read_text())
    files = []
    for name, key in (
        ("Main.lean", "source_sha256"),
        ("statement_fidelity.md", "statement_fidelity_sha256"),
    ):
        path = HERE / name
        files.append({
            "path": str(path),
            "expected_sha256": certificate[key],
            "matches": digest(path) == certificate[key],
        })
    modules = []
    for module in build["modules"]:
        source = Path(module["source"])
        olean = OLD / module["olean"]
        modules.append({
            "module": module["module"],
            "source": str(source),
            "source_matches": digest(source) == module["source_sha256"],
            "olean": str(olean),
            "olean_matches": digest(olean) == module["olean_sha256"],
            "historical_compiler_exit_code": module["exit_code"],
        })
    lean = Path("$WORKSPACE/.elan/toolchains/leanprover--lean4---v4.34.1/bin/lean")
    version = subprocess.run(
        [str(lean), "--version"], text=True, capture_output=True, check=True
    )
    workspace = HERE / ".lake/packages/mathlib"
    passed = (
        build["completed"]
        and all(file["matches"] for file in files)
        and all(
            module["source_matches"]
            and module["olean_matches"]
            and module["historical_compiler_exit_code"] == 0
            for module in modules
        )
    )
    result = {
        "kind": "Read-only receipt reuse check; not a new compiler run",
        "passed": passed,
        "files": files,
        "modules": modules,
        "historical_build_completed": build["completed"],
        "live_compiler_version": version.stdout.strip(),
        "live_compiler_exit_code": version.returncode,
        "historical_mathlib_revision": certificate["mathlib_revision"],
        "matching_workspace_exists": workspace.is_dir(),
        "matching_workspace_toolchain": (
            (workspace / "lean-toolchain").read_text().strip()
            if (workspace / "lean-toolchain").is_file()
            else None
        ),
        "old_jacobian_status": json.loads((HERE / "jacobian_status.json").read_text()),
        "scope_limit": (
            "Checks two wrapper bindings and six OAI source/binary pairs; "
            "does not rebuild or rehash the full Mathlib cache."
        ),
    }
    print(json.dumps(result, indent=2))
    return 0 if passed else 1


if __name__ == "__main__":
    raise SystemExit(main())
