#!/usr/bin/env python3
"""Compare all retained paper build files with pinned upstream Git blob metadata."""

import hashlib
import json
from pathlib import Path


HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[2]
SLUG = "Full-support-of-the-zero-temperature-Sherrington-Kirkpatrick-order-parameter-September-27-2026"
COMMIT = "4eaee87548250b2682affda7d05d947c05554bae"


def main():
    entries = json.loads((HERE / "pinned-build-directory.json").read_text())
    directory = ROOT / "paper" / SLUG / "build"
    expected_names = {entry["name"] for entry in entries}
    actual_names = {path.name for path in directory.iterdir() if path.is_file()}
    if expected_names != actual_names:
        raise ValueError(f"file set mismatch: {expected_names ^ actual_names}")
    checked = {}
    for entry in entries:
        name = entry["name"]
        expected_path = f"preprints/{SLUG}/build/{name}"
        if (
            entry["type"] != "file"
            or entry["path"] != expected_path
            or entry["url"]
            != f"https://api.github.com/repos/openai/math/contents/{expected_path}?ref={COMMIT}"
        ):
            raise ValueError(f"unexpected metadata scope: {name}")
        payload = (directory / name).read_bytes()
        blob = hashlib.sha1(f"blob {len(payload)}\0".encode() + payload).hexdigest()
        if len(payload) != entry["size"] or blob != entry["sha"]:
            raise ValueError(f"source differs from pinned upstream: {name}")
        checked[name] = blob
    print(json.dumps({"commit": COMMIT, "verified_build_blobs": checked}, indent=2))


if __name__ == "__main__":
    main()
