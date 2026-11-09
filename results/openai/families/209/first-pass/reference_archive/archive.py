"""Lossless import archiving, strict replay, and isolated refresh diagnostics."""

import argparse
from datetime import datetime, timezone
import hashlib
import json
import os
from pathlib import Path
import stat
import tarfile
import tempfile


ROOT = Path(__file__).resolve().parents[2]
HERE = Path(__file__).resolve().parent
ARCHIVE = HERE / "imported_lean_sources.tar"
MANIFEST = HERE / "manifest.json"
CATALOG = ".autors/9000209/tools/INDEX.md"
IMPORTS = {
    "c1465/Main.lean": (
        "Regular real parameter slices and locally finite closed covers",
        ("RegularEta", "FuRegularSlice"),
    ),
    "c2457/Main.lean": (
        "Affine coprime integer rows and reciprocal endpoint weights",
        ("LiV2AffineDual",),
    ),
    "c2884/Problem48.lean": (
        "Conditional logical composition of stabilized knot-surgery equivalences",
        ("Problem48",),
    ),
    "c7200051/Main.lean": (
        "Equilateral sets in the real l1 metric in dimensions two through six",
        ("KusnerL1",),
    ),
    "c8200002/Main.lean": (
        "Antiunitary-swapped mutually unbiased complex bases",
        ("AntiunitarySwappedQuartet",),
    ),
}
PROTECTED = (
    "research/openai_manuscript",
    "research/degree_three_audit",
    "research/dyadic_audit",
    "research/MATH_STATE.json",
    "research/PROOF_GRAPH.json",
    "OBJECTIVE.md",
    CATALOG,
)
TEXT_SUFFIXES = {".json", ".md", ".py", ".tex", ".txt", ".bib", ".lean"}


def require(condition, message):
    if not condition:
        raise RuntimeError(message)


def digest(data):
    return hashlib.sha256(data).hexdigest()


def protected_files():
    files = []
    for relative in PROTECTED:
        path = ROOT / relative
        if path.is_file():
            files.append(path)
            continue
        require(path.is_dir(), f"Missing protected source tree: {path}")
        for directory, dirs, names in os.walk(path, followlinks=False):
            dirs[:] = sorted(d for d in dirs if d not in {".git", "__pycache__"})
            for name in sorted(names):
                if not name.endswith(".pyc"):
                    files.append(Path(directory) / name)
    return sorted(files)


def snapshot():
    return {
        str(path.relative_to(ROOT)): digest(path.read_bytes())
        for path in protected_files()
    }


def dependencies():
    needles = ["results_tools", ".autors"]
    for relative, (_, symbols) in IMPORTS.items():
        needles.extend((relative, relative.split("/")[0], *symbols))
    searched = []
    hits = []
    for path in protected_files():
        relative = str(path.relative_to(ROOT))
        if relative == CATALOG or path.suffix not in TEXT_SUFFIXES:
            continue
        searched.append(relative)
        text = path.read_text(encoding="utf-8")
        for needle in needles:
            if needle in text:
                hits.append({"path": relative, "reference": needle})
    return {"searched_files": searched, "needles": needles, "hits": hits}


def admission(stage):
    from argus_skill.verticals.math.stages import stage_completion_issues

    issues = list(stage_completion_issues(stage, ROOT))
    return {"stage": stage, "passed": not issues, "issues": issues}


def probe_refresh(manifest):
    from argus_skill.skills.builtins import _copy_missing_tree

    require(digest(ARCHIVE.read_bytes()) == manifest["archive_sha256"],
            "Archive bytes changed")
    prefix = Path(".autors/9000209/tools/results_tools")
    with tempfile.TemporaryDirectory(prefix="refresh-probe-", dir=HERE) as temporary:
        fixture = Path(temporary)
        source = fixture / "source"
        destination = fixture / "destination"
        payloads = {}
        with tarfile.open(ARCHIVE, "r:") as archive:
            for entry in manifest["sources"]:
                relative = Path(entry["original_path"]).relative_to(prefix)
                require(".." not in relative.parts, "Unsafe fixture path")
                with archive.extractfile(entry["original_path"]) as stream:
                    data = stream.read()
                require(digest(data) == entry["sha256"], "Archived source changed")
                path = source / relative
                path.parent.mkdir(parents=True, exist_ok=True)
                path.write_bytes(data)
                payloads[relative] = data
        initial = _copy_missing_tree(source, destination)
        require(initial == 5, "Initial fixture staging did not copy five sources")
        for relative, data in payloads.items():
            path = destination / relative
            require(path.read_bytes() == data, "Initial fixture bytes differ")
            path.unlink()
        refreshed = _copy_missing_tree(source, destination)
        require(refreshed == 5, "Refresh did not recreate all five fixture sources")
        for relative, data in payloads.items():
            require((destination / relative).read_bytes() == data,
                    "Refreshed fixture bytes differ")
        existing = _copy_missing_tree(source, destination)
        require(existing == 0, "Refresh unexpectedly rewrote existing fixture sources")
    return {
        "observed_at": datetime.now(timezone.utc).isoformat(),
        "project_root": str(ROOT),
        "operation": "argus_skill.skills.builtins._copy_missing_tree",
        "fixture_scope": "Temporary directories inside research/reference_archive only",
        "initial_copy_count": initial,
        "copy_count_after_fixture_removal": refreshed,
        "copy_count_with_existing_fixture_files": existing,
        "all_recreated_payloads_equal_archive": True,
        "live_imports_modified": False,
        "shared_targets_modified": False,
        "temporary_fixture_removed": not fixture.exists(),
        "interpretation": (
            "The installed copy primitive recreates the five removed fixture files. "
            "This is a deterministic reproduction of the mechanism, not a live "
            "refresh, identification of the prior writer, or successful quarantine."
        ),
    }


def verify(manifest, originals_present=False):
    require(digest(ARCHIVE.read_bytes()) == manifest["archive_sha256"],
            "Archive bytes changed")
    entries = manifest["sources"]
    expected_names = {f".autors/9000209/tools/results_tools/{name}" for name in IMPORTS}
    require(len(entries) == 5 and {e["original_path"] for e in entries} == expected_names,
            "The manifest does not describe exactly the five assigned imports")
    with tarfile.open(ARCHIVE, "r:") as archive:
        members = archive.getmembers()
        require(sorted(m.name for m in members) ==
                sorted(e["original_path"] for e in entries),
                "Archive member set differs from the original five sources")
        for entry in entries:
            name = entry["original_path"]
            require(not Path(name).is_absolute() and ".." not in Path(name).parts,
                    f"Unsafe archive member path: {name}")
            member = archive.getmember(name)
            require(member.isfile(), f"Archive member is not a regular file: {name}")
            with archive.extractfile(member) as stream:
                data = stream.read()
            require(len(data) == entry["bytes"] and digest(data) == entry["sha256"],
                    f"Source bytes cannot be recovered: {name}")
            require(member.mode == entry["mode"] and
                    member.uid == entry["uid"] and member.gid == entry["gid"],
                    f"Original file metadata differs: {name}")
            original = ROOT / name
            if originals_present:
                require(original.read_bytes() == data,
                        f"Pre-removal byte comparison failed: {name}")
            else:
                require(not os.path.lexists(original),
                        f"Imported Lean exposure remains active: {name}")
    require(snapshot() == manifest["protected_file_sha256"],
            "A protected manuscript, proof, certificate, ledger, or catalog changed")
    current_dependencies = dependencies()
    require(not current_dependencies["hits"],
            f"Active dependency on quarantined material: {current_dependencies['hits']}")
    require(current_dependencies == manifest["dependency_scan"],
            "The reviewed dependency inventory changed")
    return {
        "project_root": str(ROOT),
        "recoverable_sources": len(entries),
        "protected_files_unchanged": len(manifest["protected_file_sha256"]),
        "active_dependency_hits": 0,
        "original_exposures_absent": not originals_present,
    }


def quarantine():
    require(not ARCHIVE.exists() and not MANIFEST.exists(),
            "Archive already exists; use verify, not quarantine")
    catalog = (ROOT / CATALOG).read_text(encoding="utf-8")
    source_bytes = {}
    entries = []
    for relative, (subject, _) in IMPORTS.items():
        name = f".autors/9000209/tools/results_tools/{relative}"
        path = ROOT / name
        for parent in (path, *path.parents):
            if parent == ROOT:
                break
            require(not parent.is_symlink(), f"Symlink ownership needs review: {parent}")
        metadata = path.lstat()
        require(stat.S_ISREG(metadata.st_mode), f"Not a local regular file: {path}")
        require(path.resolve() == path, f"Source resolves outside its local path: {path}")
        source_bytes[name] = path.read_bytes()
        catalog_lines = [
            line for line in catalog.splitlines()
            if f"[`results_tools/{relative}`]" in line
        ]
        require(len(catalog_lines) == 1, f"Import provenance is ambiguous: {relative}")
        entries.append({
            "original_path": name,
            "resolved_path": str(path.resolve()),
            "source_campaign": relative.split("/")[0][1:],
            "catalog_entry": catalog_lines[0],
            "subject": subject,
            "exclusion_reason": (
                "Cross-campaign reference import, not a Gersten proof or dependency "
                "of any submitted claim. Retained as archive data, not active formal evidence."
            ),
            "bytes": len(source_bytes[name]),
            "sha256": digest(source_bytes[name]),
            "mode": stat.S_IMODE(metadata.st_mode),
            "uid": metadata.st_uid,
            "gid": metadata.st_gid,
            "link_count": metadata.st_nlink,
            "symlink": False,
        })
    scan = dependencies()
    require(not scan["hits"], f"Isolation would remove an active dependency: {scan['hits']}")
    manifest = {
        "project_root": str(ROOT),
        "created_at": datetime.now(timezone.utc).isoformat(),
        "archive": str(ARCHIVE.relative_to(ROOT)),
        "provenance_catalog": CATALOG,
        "provenance_scope": (
            "Campaign attribution comes from the existing local import catalog. "
            "Each exposed source and its campaign-local ancestors were inspected "
            "as nonsymlinks. No shared target was opened for writing or modified; "
            "no claim is made about an uninspected upstream revision."
        ),
        "sources": entries,
        "dependency_scan": scan,
        "protected_file_sha256": snapshot(),
        "native_admission_before": admission("solve"),
        "restore_from_project_root": (
            "tar --extract --file research/reference_archive/imported_lean_sources.tar "
            "--keep-old-files --same-permissions --no-same-owner"
        ),
        "restoration_note": (
            "Restoration re-exposes these unrelated Lean imports to native discovery. "
            "The archive and manifest remain available; no original is overwritten."
        ),
    }
    with tarfile.open(ARCHIVE, "x", format=tarfile.PAX_FORMAT) as archive:
        for entry in entries:
            archive.add(ROOT / entry["original_path"],
                        arcname=entry["original_path"], recursive=False)
    manifest["archive_sha256"] = digest(ARCHIVE.read_bytes())
    verify(manifest, originals_present=True)
    manifest["pre_removal_byte_comparison"] = "All five recovered payloads equal the original bytes."
    with MANIFEST.open("x", encoding="utf-8") as stream:
        json.dump(manifest, stream, indent=2)
        stream.write("\n")
    for entry in entries:
        path = ROOT / entry["original_path"]
        require(not path.is_symlink() and path.read_bytes() == source_bytes[entry["original_path"]],
                f"Source changed before local exposure removal: {path}")
        path.unlink()
    result = verify(manifest)
    manifest["native_admission_after"] = {
        stage: admission(stage) for stage in ("solve", "review")
    }
    manifest["isolation_verification"] = result
    MANIFEST.write_text(json.dumps(manifest, indent=2) + "\n", encoding="utf-8")
    result["native_stage_issue_counts"] = {
        stage: len(report["issues"])
        for stage, report in manifest["native_admission_after"].items()
    }
    return result


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("operation", choices=("quarantine", "verify", "probe-refresh"))
    args = parser.parse_args()
    if args.operation == "quarantine":
        result = quarantine()
    elif args.operation == "verify":
        result = verify(json.loads(MANIFEST.read_text(encoding="utf-8")))
    else:
        manifest = json.loads(MANIFEST.read_text(encoding="utf-8"))
        result = probe_refresh(manifest)
        manifest["isolated_refresh_probe"] = result
        MANIFEST.write_text(json.dumps(manifest, indent=2) + "\n", encoding="utf-8")
    print(json.dumps(result, indent=2))


if __name__ == "__main__":
    main()
