"""Run the literal strict entry point, retaining its output and measured outcome."""

import argparse
import json
from pathlib import Path
import resource
import subprocess
import sys
import time


HERE = Path(__file__).resolve().parent
ROOT = next(p for p in HERE.parents if (p / "scripts/verify_rainbow_certificate.py").is_file())
PYTHON = "/home/argustest/zimo/argus-latest/.venv/bin/python"
sys.path.insert(0, str(ROOT / "scripts"))

from campaign_status import publish
from reduce_copies import write_json


def replay(certificate, report=None):
    certificate = certificate.resolve()
    if not certificate.is_relative_to(HERE):
        raise ValueError("Replay the full certificate from the owned admission directory")
    command = [
        PYTHON, "scripts/verify_rainbow_certificate.py",
        str(certificate.relative_to(ROOT)), "--require-counterexample",
    ]
    record_path = report.resolve() if report else certificate.with_suffix(".verification.json")
    if not record_path.is_relative_to(HERE) or record_path.suffix != ".json":
        raise ValueError("Write the replay report as JSON within the owned admission directory")
    output_path = record_path.with_suffix(".output.json")
    error_path = record_path.with_suffix(".stderr.log")
    record = {
        "command": command, "project_root": str(ROOT),
        "certificate": str(certificate.relative_to(ROOT)),
        "stdout": str(output_path.relative_to(ROOT)),
        "stderr": str(error_path.relative_to(ROOT)),
        "status": "RUNNING", "independent_review_complete": False,
        "campaign_complete": False,
    }
    wall = time.monotonic()
    before = resource.getrusage(resource.RUSAGE_CHILDREN)
    write_json(record_path, record)
    with output_path.open("w") as output, error_path.open("w") as error:
        process = subprocess.Popen(command, cwd=ROOT, stdout=output, stderr=error)
        record["pid"] = process.pid
        write_json(record_path, record)
        while True:
            try:
                returncode = process.wait(timeout=30)
                break
            except subprocess.TimeoutExpired:
                record["elapsed_seconds"] = time.monotonic() - wall
                process_status = Path(f"/proc/{process.pid}/status")
                try:
                    status_text = process_status.read_text()
                except FileNotFoundError:
                    if process.poll() is None:
                        raise
                    record["memory_sample_status"] = "process_exited_before_sample"
                else:
                    record["process_memory"] = {
                        line.split(":", 1)[0]: line.split(":", 1)[1].strip()
                        for line in status_text.splitlines()
                        if line.startswith(("VmRSS:", "VmPeak:"))
                    }
                write_json(record_path, record)
                publish(
                    "The full all-vertex strict verifier is running; no final witness acceptance is claimed before successful termination and independent review.",
                    status="strict_entrypoint_running", artifact=str(record_path.relative_to(ROOT)),
                    search="region-19157-full-admission", candidate_found=True,
                    full_certificate_complete=True, independent_review_complete=False,
                    verifier_elapsed_seconds=record["elapsed_seconds"],
                )
    after = resource.getrusage(resource.RUSAGE_CHILDREN)
    record.update(
        exit_status=returncode, wall_seconds=time.monotonic() - wall,
        process_cpu_seconds=(after.ru_utime + after.ru_stime - before.ru_utime - before.ru_stime),
        max_rss_kib=after.ru_maxrss, status="FAILED" if returncode else "RETURNED",
    )
    write_json(record_path, record)
    if returncode:
        publish(
            f"The full strict entry point exited with status {returncode}; this is an admission failure, not a mathematical refutation.",
            status="strict_entrypoint_failed", artifact=str(record_path.relative_to(ROOT)),
            candidate_found=True, independent_review_complete=False,
        )
        raise RuntimeError(f"Strict entry point failed; inspect {error_path}")
    checked = json.loads(output_path.read_text())
    if checked["status"] != "VERIFIED_COUNTEREXAMPLE" or not checked["qualifies"]:
        raise ValueError("A zero process exit did not produce the required strict verdict")
    if not checked["no_rainbow_cycle"] or min(checked["deficits"]) < 1:
        raise ValueError("The returned mathematical data are not a strict counterexample")
    construction = json.loads(certificate.with_suffix(".construction.json").read_text())
    n = construction["size"]["vertices"]
    if any(len(checked[key]) != n for key in ("D", "R", "deficits")):
        raise ValueError("The verifier did not return data for every actual vertex")
    for u, expected_deficit in enumerate(construction["deficits_by_type"]):
        for v in range(construction["offsets"][u], construction["offsets"][u + 1]):
            if checked["D"][v] - len(checked["R"][v]) != expected_deficit:
                raise ValueError("An actual-vertex result disagrees with its fixed-copy deficit")
    record.update(
        status=checked["status"], vertices=n,
        minimum_deficit=min(checked["deficits"]),
        maximum_deficit=max(checked["deficits"]),
        no_rainbow_cycle=checked["no_rainbow_cycle"],
        positive_endpoint_entries=sum(map(len, checked["R"])),
        actual_vertex_rows_checked=n,
        strict_entrypoint_passed=True, independent_review_complete=False,
    )
    write_json(record_path, record)
    publish(
        "The fully materialized graph passed the strict entry point with VERIFIED_COUNTEREXAMPLE and minimum actual deficit 1. Independent Reviewer replay and acceptance, including the verifier equivalence review, remain outstanding.",
        status="strict_counterexample_pending_independent_review",
        artifact=str(record_path.relative_to(ROOT)),
        search="region-19157-full-admission", candidate_found=True,
        full_certificate_complete=True, strict_entrypoint_passed=True,
        independent_review_complete=False, minimum_deficit=record["minimum_deficit"],
        vertices=n, actual_vertex_rows_checked=n,
    )
    print(json.dumps(record), flush=True)
    return record


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("certificate", type=Path, nargs="?", default=HERE / "full-certificate.json")
    parser.add_argument("--report", type=Path)
    args = parser.parse_args()
    replay(args.certificate, args.report)
