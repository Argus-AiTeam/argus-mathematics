"""Write every arc and every actual-vertex state row of the fixed blow-up."""

import argparse
import itertools
import json
from pathlib import Path
import resource
import sys
import time


HERE = Path(__file__).resolve().parent
ROOT = next(p for p in HERE.parents if (p / "scripts/rainbow.py").is_file())
sys.path[:0] = [str(ROOT / "scripts"), str(ROOT / "research/global-palette-compression")]

from campaign_status import publish
from capacity import palette_graph
from rainbow import analyze
from reduce_copies import fixed_data, replay, size, write_json


def materialize(copies_path, output, public=True):
    saved, coefficients = fixed_data()
    copies_record = json.loads(copies_path.read_text())
    if copies_record["C"] != saved["C"] or copies_record["k"] != saved["k"]:
        raise ValueError("Materialization must retain the reviewed C and k=6")
    copies = copies_record["weights"]
    if any(type(m) is not int for m in copies):
        raise ValueError("Materialization requires actual positive integer copies")
    deficits = replay(coefficients, copies)
    prototype = analyze(palette_graph(saved["C"], saved["k"]))
    masks = [sum(1 << v for v in row["R"]) for row in prototype["vertices"]]
    if not prototype["no_rainbow_cycle"] or masks != saved["R_masks"]:
        raise ValueError("The producer disagrees with the reviewed endpoint and no-return data")
    if not output.resolve().is_relative_to(HERE):
        raise ValueError("Write the full certificate within the owned admission directory")
    offsets = [0, *itertools.accumulate(copies)]
    dimensions = size(saved["C"], copies)
    counts = {
        "arcs": 0, "vertex_rows": 0, "states": 0, "positive_endpoints": 0,
    }
    started, cpu_started, last_public = time.monotonic(), time.process_time(), 0.0

    def progress(action, force=False):
        nonlocal last_public
        now = time.monotonic()
        if public and (force or now - last_public >= 30):
            publish(
                action, status="materializing_strict_certificate",
                artifact=str(output.relative_to(ROOT)), search="region-19157-full-admission",
                source_scope_version=6, objective_mode="targeted",
                research_target_level="exploratory", candidate_found=True,
                full_certificate_complete=False, independent_review_complete=False,
                **counts,
            )
            last_public = now

    progress(
        f"Writing every actual arc and state row of the fixed {offsets[-1]}-vertex strict candidate.",
        True,
    )
    with output.open("w", buffering=1024 * 1024) as stream:
        stream.write(f'{{"graph":{{"n":{offsets[-1]},"k":{saved["k"]},"arcs":[')
        first = True
        for u, row in enumerate(saved["C"]):
            for v, capacity in enumerate(row):
                if not capacity:
                    continue
                suffix = ',"labels":' + json.dumps(list(range(1, capacity + 1))) + "}"
                for tail in range(offsets[u], offsets[u + 1]):
                    prefix = '{"tail":' + str(tail) + ',"head":'
                    if not first:
                        stream.write(",")
                    stream.write(",".join(
                        prefix + str(head) + suffix
                        for head in range(offsets[v], offsets[v + 1])
                    ))
                    first = False
                    counts["arcs"] += copies[v]
                progress("Materializing explicit cross-fibre arcs; no quotient replaces the full graph.")
        stream.write(']},"positive_length":true,"rainbow_closed_walk":null,')
        stream.write('"no_rainbow_cycle":true,"qualifies":true,')
        stream.write(f'"minimum_deficit":{min(deficits)},"vertices":[')
        first = True
        for u, row in enumerate(prototype["vertices"]):
            states = [
                [vertex, mask]
                for v, mask in row["states"] if mask
                for vertex in range(offsets[v], offsets[v + 1])
            ]
            endpoints = [
                vertex for v in row["R"]
                for vertex in range(offsets[v], offsets[v + 1])
            ]
            degree = sum(c * copies[v] for v, c in enumerate(saved["C"][u]))
            if degree - len(endpoints) != deficits[u]:
                raise ValueError("The expanded endpoint count changes an exact source deficit")
            positive_states = json.dumps(states, separators=(",", ":"))[1:-1]
            row_data = json.dumps({
                "D": degree, "R": endpoints, "deficit": deficits[u],
            }, separators=(",", ":"))[1:-1]
            for start in range(offsets[u], offsets[u + 1]):
                if not first:
                    stream.write(",")
                stream.write(f'{{"vertex":{start},' + row_data + f',"states":[[{start},0]')
                if positive_states:
                    stream.write("," + positive_states)
                stream.write("]}")
                first = False
                counts["vertex_rows"] += 1
                counts["states"] += len(states) + 1
                counts["positive_endpoints"] += len(endpoints)
                progress("Writing a separate explicit, positive-length state certificate for every actual vertex.")
        stream.write("]}\n")
    if counts["arcs"] != dimensions["arcs"] or counts["vertex_rows"] != dimensions["vertices"]:
        raise ValueError("The full materialization has an incorrect number of arcs or vertices")
    record = {
        "certificate": str(output.relative_to(ROOT)),
        "copies": str(copies_path.relative_to(ROOT)),
        "C": saved["C"], "k": saved["k"], "weights": copies, "offsets": offsets,
        "deficits_by_type": deficits, "minimum_deficit": min(deficits),
        "size": dimensions, "written": counts, "certificate_bytes": output.stat().st_size,
        "wall_seconds": time.monotonic() - started,
        "process_cpu_seconds": time.process_time() - cpu_started,
        "max_rss_kib": resource.getrusage(resource.RUSAGE_SELF).ru_maxrss,
        "source_scope_version": 6, "fixed_capacity_matrix": True,
        "full_certificate_complete": True, "strict_entrypoint_passed": False,
        "independent_review_complete": False, "campaign_complete": False,
    }
    write_json(output.with_suffix(".construction.json"), record)
    if public:
        publish(
            "The explicit full graph and every actual-vertex certificate row are written; strict independent admission remains pending.",
            status="full_certificate_written", artifact=str(output.relative_to(ROOT)),
            search="region-19157-full-admission", candidate_found=True,
            full_certificate_complete=True, independent_review_complete=False,
            **counts,
        )
    print(json.dumps({key: record[key] for key in (
        "certificate", "size", "written", "certificate_bytes", "minimum_deficit",
        "wall_seconds", "process_cpu_seconds", "max_rss_kib"
    )}), flush=True)
    return record


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("--copies", type=Path, default=HERE / "copies-6000.json")
    parser.add_argument("--output", type=Path, default=HERE / "full-certificate.json")
    args = parser.parse_args()
    materialize(args.copies.resolve(), args.output.resolve())
