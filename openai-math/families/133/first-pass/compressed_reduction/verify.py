#!/usr/bin/env python3
"""Replay the source-bound universal certificate and new exact finite tests."""

import argparse
from collections import defaultdict
from functools import reduce
import hashlib
import importlib.util
from itertools import product
import json
from operator import xor
from pathlib import Path
import sys


HERE = Path(__file__).resolve().parent
ROOT = HERE.parent.parent
EP = ROOT / "research/exact_projection"
OPERATION = "prime_field.matrix.rank.compute"
sys.dont_write_bytecode = True


def require(condition, message):
    if not condition:
        raise AssertionError(message)


def digest(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def load_ep():
    spec = importlib.util.spec_from_file_location("reviewed_projection", EP / "verify.py")
    module = importlib.util.module_from_spec(spec)
    sys.modules[spec.name] = module
    spec.loader.exec_module(module)
    return module


def write_json(path, value):
    path.write_text(json.dumps(value, indent=2, sort_keys=True) + "\n")


def wire_matrix(n=16):
    rows = [[int(j == 0) for j in range(n)] + [0]]
    rows += [[int(j in (k - 1, k)) for j in range(n)] + [0] for k in range(1, n)]
    rows += [[int(j == n - 1) for j in range(n)] + [1]]
    return {"matrix": {"prime": 2, "columns": n + 1, "entries": rows}}


def gf2_rank(rows):
    basis = {}
    for row in rows:
        value = sum(bit << i for i, bit in enumerate(row))
        while value:
            pivot = value.bit_length() - 1
            if pivot in basis:
                value ^= basis[pivot]
            else:
                basis[pivot] = value
                break
    return len(basis)


def jacobian_replay():
    payload = json.loads((HERE / "jacobian_payload.json").read_text())
    output = json.loads((HERE / "jacobian_output.json").read_text())
    receipt = json.loads((HERE / "jacobian_receipt.json").read_text())
    require(payload == wire_matrix(), "Unexpected exact rank payload")
    require(receipt["operation_id"] == OPERATION, "Wrong Jacobian operation")
    require(receipt["adapter_exit_code"] == 0 and not receipt["timed_out"],
            "The Jacobian adapter did not complete successfully")
    require(output["server"]["version"] == receipt["server_version"], "Server receipt mismatch")
    require(output["protocol_version"] == receipt["protocol_version"], "Protocol receipt mismatch")
    require(output["request"]["operation_id"] == OPERATION, "Typed operation mismatch")
    result = output["result"]
    if "output" in result:
        result = result["output"]
    require(result["source"] == payload and result["prime"] == 2,
            "Jacobian did not retain this exact GF(2) input")
    rows = payload["matrix"]["entries"]
    augmented = gf2_rank(rows)
    coefficients = gf2_rank([row[:-1] for row in rows])
    dual = [reduce(xor, column, 0) for column in zip(*rows)]
    require((coefficients, augmented) == (16, 17), "Wire rank obstruction changed")
    require(result["rank"] == augmented, "Independent rank replay disagrees")
    require(dual == [0] * 16 + [1], "All-ones dual inconsistency certificate failed")
    return {
        "operation_id": OPERATION,
        "server_version": receipt["server_version"],
        "protocol_version": receipt["protocol_version"],
        "adapter_exit_code": 0,
        "timed_out": False,
        "coefficient_rank": coefficients,
        "augmented_rank": augmented,
        "dual_row_sum": dual,
        "interpretation": "Rejection of an inconsistent input, not a manuscript refutation.",
        "payload_sha256": digest(HERE / "jacobian_payload.json"),
        "output_sha256": digest(HERE / "jacobian_output.json"),
    }


def loop_model(ep):
    class LoopModel(ep.Model):
        def __init__(self):
            self.m, self.r, self.n = 2, 3, 16
            self.dimensions = (1, 1)
            full = tuple(range(self.m))
            identity = (full,) * self.r
            self.schemas = (ep.Schema(0, 0, 1, 1, 0, 1, identity, identity),)
            self.permutations = {(0, i): full for i in range(self.r)}

        def q(self, p, address):
            return frozenset(range(1 << self.dimensions[p]))

    return LoopModel()


class Families:
    def __init__(self, model):
        self.model, self.cache = model, {}
        self.extensions = 0

    def family(self, blocks):
        blocks = frozenset(blocks)
        if blocks not in self.cache:
            self.cache[blocks] = self.model.family(blocks)
        return self.cache[blocks]

    @staticmethod
    def decode(positions, value):
        return {name: (value >> start) & ((1 << width) - 1)
                for name, (start, width) in positions.items()}

    def extend(self, blocks, values, block):
        larger = frozenset(blocks) | {block}
        require(len(larger) <= self.model.r + 1, "Transfer exceeded the pair budget")
        positions, family, _ = self.family(larger)
        for encoded in sorted(family):
            candidate = self.decode(positions, encoded)
            if all(candidate[name] == value for name, value in values.items()):
                self.extensions += 1
                return larger, candidate
        raise AssertionError("A prescribed retained list had no extension")

    def restrict(self, blocks, values):
        positions, family, _ = self.family(blocks)
        result = {name: values[name] for name in positions}
        encoded = sum(result[name] << start for name, (start, _) in positions.items())
        require(encoded in family, "A discarded query left the legal family")
        return result


def history_test(ep, model):
    families = Families(model)
    address = (0,) * model.r

    def ring(t):
        return [ep.site(t, i, address[i], address[(i + 1) % model.r])
                for i in range(model.r)]

    def total(blocks, values):
        return reduce(xor, (values[model.readouts(b)[0]] for b in blocks), 0)

    results = []
    for start in (0, 1):
        sites = ring(ep.real(0))
        blocks = frozenset(sites)
        positions, candidates, _ = families.family(blocks)
        values = next(families.decode(positions, value) for value in sorted(candidates)
                      if total(sites, families.decode(positions, value)) == start)
        sums = [start]
        for k in range(model.n + 1):
            old_sites = sites
            squares = [ep.square(0, k, i, 0, 0) for i in range(model.r)]
            for old, new in zip(old_sites, squares):
                larger, extended = families.extend(blocks, values, new)
                blocks = larger - {old}
                values = families.restrict(blocks, extended)
            left_sum = reduce(xor, (values[model.readouts(b)[0]] for b in squares), 0)
            right_sum = reduce(xor, (values[model.readouts(b)[1]] for b in squares), 0)
            require(left_sum == sums[-1], "Site-to-square replacement changed an old sum")
            delta = int(k == model.n)
            require(left_sum ^ right_sum == delta, "Ring cancellation has the wrong seam")
            sites = ring(model.endpoints((0, k))[1])
            for old, new in zip(squares, sites):
                larger, extended = families.extend(blocks, values, new)
                blocks = larger - {old}
                values = families.restrict(blocks, extended)
            require(total(sites, values) == right_sum, "Square-to-site transport changed the sum")
            sums.append(right_sum)
        require(blocks == frozenset(ring(ep.real(0))), "The self-loop did not return to its ring")
        require(sums[-1] == start ^ 1, "All-history endpoint flip was lost")
        results.append({"initial_sum": start, "successive_ring_sums": sums, "final_sum": sums[-1]})
    return {
        "r": model.r, "private_internal_types": model.n, "wire_links": model.n + 1,
        "max_pairs": model.r + 1, "insert_discard_extensions": families.extensions,
        "histories": results,
        "single_global_assignment_exists": False,
        "image_consistency_witness": "Full F2 at both real types and all addresses.",
    }


def all_blocks(ep, model):
    types = [ep.real(p) for p in range(len(model.dimensions))]
    types += [ep.internal(e, j) for e in range(len(model.schemas)) for j in range(model.n)]
    blocks = []
    for t, i in product(types, range(model.r)):
        blocks += [ep.site(t, i, a, b) for a, b in
                   product(model.labels(t, i), model.labels(t, (i + 1) % model.r))]
    for e, k, i in product(range(len(model.schemas)), range(model.n + 1), range(model.r)):
        domains = model.schemas[e].domains
        blocks += [ep.square(e, k, i, a, b) for a, b in
                   product(domains[i], domains[(i + 1) % model.r])]
    return sorted(blocks)


def legal_valuations(model, block, epsilon):
    if block[0] == "site":
        return tuple((v,) for v in range(1 << model.dimension(block[2])))
    e, k = block[2]
    t, u = model.endpoints((e, k))
    schema = model.schemas[e]
    delta = (schema.c_left if k == 0 else 0) ^ (schema.c_right if k == model.n else 0)
    result = []
    for x, z, y, w in product(range(1 << model.dimension(t)),
                              range(1 << model.dimension(u)), range(2), range(2)):
        boundary = model.linear((e, k), t, x) ^ model.linear((e, k), u, z) ^ y ^ w
        if boundary == epsilon * int(block[1] == model.r - 1) * delta:
            result.append((x, z, y, w))
    return tuple(result)


def graph_test(ep, model):
    blocks = all_blocks(ep, model)
    fibers = [{b: legal_valuations(model, b, e) for b in blocks} for e in (0, 1)]
    vertices = [tuple((b, v) for b in blocks for v in fibers[e][b]) for e in (0, 1)]
    require(len(vertices[0]) == len(vertices[1]), "Affine sides have unequal base orders")
    number = {b: i + 1 for i, b in enumerate(blocks)}
    N, B = len(vertices[0]), len(blocks)
    require(2 <= N and B <= N, "Base normalization or nonempty fiber count failed")
    readouts = {x: dict(zip(model.readouts(x[0]), x[1])) for side in vertices for x in side}

    def base_adj(x, y):
        if x[0] == y[0]:
            return False
        shared = readouts[x].keys() & readouts[y].keys()
        return bool(shared) and all(readouts[x][a] == readouts[y][a] for a in shared)

    degree = []
    for side in vertices:
        index = defaultdict(set)
        for x in side:
            for a, v in readouts[x].items():
                index[a, v].add(x)
        degrees = {}
        for x in side:
            candidates = set().union(*(index[a, v] for a, v in readouts[x].items()))
            degrees[x] = sum(base_adj(x, y) for y in candidates)
        degree.append(degrees)

    families = Families(model)
    retained = frozenset(ep.site(ep.real(0), i, 0, 0) for i in range(model.r))
    old = {a: 0 for b in retained for a in model.readouts(b)}
    families.restrict(retained, old)
    offsets = {}
    for b in blocks:
        _, values = families.extend(retained, old, b)
        offsets[b] = tuple(values[a] for a in model.readouts(b))
        require(offsets[b] in fibers[1][b], "A proposed translation is not affine legal")

    def translate(x):
        b, values = x
        return b, tuple(a ^ c for a, c in zip(values, offsets[b]))

    require({translate(x) for x in vertices[0]} == set(vertices[1]),
            "The one preannounced blockwise translation is not a bijection")

    def weight(x):
        return number[x[0]] * (N + 1)

    def virtual_adj(x, y):
        if x[0] == "hub" or y[0] == "hub":
            return x != y
        if x[0] == y[0] == "base":
            return base_adj(x[1], y[1])
        if x[0] == "base" and y[0] == "mark":
            return x[1] == y[1]
        if x[0] == "mark" and y[0] == "base":
            return x[1] == y[1]
        return False

    def announce(x):
        if x[0] == "base":
            return "base", translate(x[1])
        if x[0] == "mark":
            require(0 <= x[2] < weight(x[1]), "Invalid private mark index")
            require(weight(translate(x[1])) == weight(x[1]), "Owner mark counts changed")
            return "mark", translate(x[1]), x[2]
        return x

    old_sites = sorted(retained)
    owners = [(b, fibers[0][b][0]) for b in old_sites]
    pebbles = [("mark", owners[0], 0), ("mark", owners[1], weight(owners[1]) - 1),
               ("base", owners[2])]
    require(all(("base", owner) not in pebbles for owner in owners[:2]),
            "The owner-only mark test accidentally pebbles its owners")
    choices = [("base", x) for x in vertices[0]] + [("hub",)]
    for x in vertices[0]:
        choices += [("mark", x, i) for i in sorted({0, weight(x) // 2, weight(x) - 1})]
    comparisons = 0
    for x in choices:
        fx = announce(x)
        for y in pebbles + [x]:
            fy = announce(y)
            require((x == y) == (fx == fy), "Announced move violates equality")
            require(virtual_adj(x, y) == virtual_adj(fx, fy),
                    "Announced move violates adjacency or nonadjacency")
            comparisons += 1
    require(len({announce(x) for x in choices}) == len(choices),
            "Virtual announced map is not injective")
    marks = sum(weight(x) for x in vertices[0])
    require(marks == sum(weight(x) for x in vertices[1]), "The two mark totals differ")
    intervals = [(j * (N + 1) + 1, j * (N + 1) + N) for j in range(1, B + 1)]
    require(all(a[1] < b[0] for a, b in zip(intervals, intervals[1:])),
            "Two block degree intervals overlap")
    for e in (0, 1):
        for x in vertices[e]:
            lo, hi = intervals[number[x[0]] - 1]
            require(2 < lo <= degree[e][x] + weight(x) + 1 <= hi,
                    "A base degree escaped its block interval")
            require(hi < N + marks, "The hub is not distinguished from every base vertex")
    A = 2 ** 4 * (model.r * (len(model.dimensions) + model.n + model.n + 1))
    require(N <= A * model.m ** 2, "Pair-indexed base count bound failed")
    unpadded = N + marks + 1
    require(unpadded <= N ** 3 + N ** 2 + N + 1 <= (A ** 3 + A ** 2 + A + 1) * model.m ** 6,
            "The exact sixth-power order bound failed")
    padding = []
    for q in (0, 1, 7, 100000000):
        for i in sorted({0, q - 1}) if q else ():
            x = ("pad", i)
            require(announce(x) == x and virtual_adj(x, ("hub",)), "Padding-hub edge failed")
            require(all(not virtual_adj(x, y) for y in pebbles), "Padding acquired an extra edge")
        padding.append({"q": q, "order_each_side": unpadded + q, "hub_degree": unpadded + q - 1})
    translation_bytes = json.dumps([[repr(b), list(offsets[b])] for b in blocks],
                                   separators=(",", ":")).encode()
    return {
        "alphabet_size": model.m, "r": model.r, "internal_types": model.n,
        "real_dimensions_including_unused_dummy": list(model.dimensions),
        "blocks": B, "base_vertices_each_side": N, "private_marks_each_side": marks,
        "unpadded_order_each_side": unpadded,
        "prospective_block_extensions": families.extensions,
        "announced_virtual_choices_checked": len(choices), "pair_comparisons_checked": comparisons,
        "base_degree_checks": 2 * N, "owner_only_retained_marks": 2,
        "translation_sha256": hashlib.sha256(translation_bytes).hexdigest(),
        "explicit_order_constant_A": A, "padding": padding,
        "scope": "Exact bounded graph and move tests; universal strategy is the Lean theorem.",
    }


def boundary_tests(ep):
    results = []

    def check(label, dims, schemas, m, expected, nonaffine=False):
        addresses = tuple(product(range(m), repeat=3))
        values = {(p, a): set(range(1 << d)) for p, d in enumerate(dims) for a in addresses}
        if nonaffine:
            values = {(p, a): {v ^ (sum(a) % 4) for v in (0, 1, 2)}
                      for p in range(len(dims)) for a in addresses}
        comparisons, valid = 0, True
        for s in schemas:
            for a in addresses:
                if not all(x in s.domains[i] for i, x in enumerate(a)):
                    continue
                target = tuple(s.maps[i][x] for i, x in enumerate(a))
                left = {ep.parity(s.left & v) ^ s.c_left for v in values[s.source, a]}
                right = {ep.parity(s.right & v) ^ s.c_right for v in values[s.target, target]}
                valid &= left == right
                comparisons += 1
        require(valid == expected, f"Boundary image test failed: {label}")
        if nonaffine:
            q = values[0, (0, 0, 0)]
            require(any(x ^ y ^ z not in q for x, y, z in product(q, repeat=3)),
                    "The non-affine boundary witness became affine")
        results.append({"case": label, "dimensions": dims, "alphabet_size": m,
                        "individual_comparisons": comparisons, "given_witness_images_equal": valid})

    full = ((0, 1),) * 3
    identity = full
    check("zero_dimension_equal_zero_forms", [0], [ep.Schema(0, 0, 0, 0, 1, 1, full, identity)], 2, True)
    check("zero_dimension_opposite_constants", [0], [ep.Schema(0, 0, 0, 0, 0, 1, full, identity)], 2, False)
    check("empty_domain_vacuous_comparison", [0],
          [ep.Schema(0, 0, 0, 0, 0, 1, ((), (0, 1), (0, 1)), identity)], 2, True)
    parallel = [ep.Schema(0, 1, 1, 1, 0, c, full, identity) for c in (0, 1)]
    check("parallel_images_not_a_combined_relation", [1, 1], parallel, 2, True)
    require(not any(all(x == y ^ s.c_right for s in parallel) for x, y in product(range(2), repeat=2)),
            "The parallel example accidentally has a global pair assignment")
    maps = ((1, 2, 0),) * 3
    check("partial_injections_and_nonaffine_witnesses", [2, 2],
          [ep.Schema(0, 1, 1, 2, 0, 1, ((0, 2), (1,), (0, 1)), maps)], 3, True, True)
    return results


def kernel_replay(path):
    certificate = json.loads(path.read_text())
    check = certificate["lean_check"]
    require(check["exit_code"] == 0 and check["proof_holes"] == [],
            "The universal source has no successful hole-free compiler result")
    require(check["audit_exit_code"] == 0 and check["status"] == "success",
            "The universal source has no successful axiom audit")
    require("version 4.31.0" in check["tools"]["lean"]["version"], "Wrong Lean version")
    source, fidelity = HERE / "Main.lean", HERE / "statement_fidelity.md"
    require(check["source_sha256"] == digest(source), "The source changed after compilation")
    require(check["statement_fidelity_sha256"] == digest(fidelity), "The fidelity document changed")
    require(source.read_bytes().startswith((EP / "Main.lean").read_bytes()),
            "The reused approved EP proof closure was changed")
    require(certificate["lean_source"]["text"] == source.read_text(), "Archived source mismatch")
    require("sorryAx" not in check["stdout"], "An axiom printout exposes a proof hole")
    return {
        "certificate": str(path.relative_to(ROOT)),
        "certificate_sha256": digest(path),
        "evidence_id": certificate["evidence_id"],
        "lean_version": "4.31.0", "exit_code": 0, "proof_holes": [], "axiom_audit_exit_code": 0,
        "source_sha256": digest(source), "statement_fidelity_sha256": digest(fidelity),
        "reviewed_EP_source_sha256": digest(EP / "Main.lean"),
        "declarations": [
            "CompressedReduction.Construction.game_iff_consistency",
            "CompressedReduction.Augment.compressed_reduction",
            "CompressedReduction.Augment.equal_orders",
            "CompressedReduction.Augment.padding_order",
            "CompressedReduction.Augment.connected",
            "CompressedReduction.Augment.diameter_two",
            "CompressedReduction.Augment.order_bound",
        ],
    }


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--prepare-jacobian", action="store_true")
    parser.add_argument("--write-certificate", action="store_true")
    parser.add_argument("--kernel-certificate", type=Path)
    args = parser.parse_args()
    if args.prepare_jacobian:
        write_json(HERE / "jacobian_payload.json", wire_matrix())
        print(json.dumps({"operation_id": OPERATION, "payload": "jacobian_payload.json", "shape": [17, 17]}))
        return
    target = HERE / "exact_certificate.json"
    path = args.kernel_certificate
    if path is None:
        if target.exists():
            path = ROOT / json.loads(target.read_text())["kernel"]["certificate"]
        else:
            matches = sorted((HERE / "certificates").glob("CR-*.json"))
            require(len(matches) == 1, "Select the exact CR certificate with --kernel-certificate")
            path = matches[0]
    path = path.resolve()
    kernel = kernel_replay(path)
    ep = load_ep()
    model = loop_model(ep)
    result = {
        "schema_version": 1, "claim": "CR",
        "result_class": "new_theorem",
        "interpretation": "Independent universal formal certification of the compressed reduction.",
        "kernel": kernel, "wire_history_replay": history_test(ep, model),
        "actual_graph_replay": graph_test(ep, model), "boundary_replay": boundary_tests(ep),
        "jacobian": jacobian_replay(), "verifier_sha256": digest(Path(__file__)),
        "reviewed_EP_helper_sha256": digest(EP / "verify.py"),
        "manuscript_refutations": [],
        "independent_review": "Pending Host Reviewer replay; no independent approval is asserted.",
        "WL_scope": "The refinement correspondence is proved in report.md, not encoded in Lean.",
    }
    if args.write_certificate:
        write_json(target, result)
    require(json.loads(target.read_text()) == result, "The exact certificate does not replay")
    graph = result["actual_graph_replay"]
    print(json.dumps({"ok": True, "claim": "CR", "kernel_exit_code": 0, "proof_holes": [],
                      "blocks": graph["blocks"], "base_vertices": graph["base_vertices_each_side"],
                      "wire_transfer_extensions": result["wire_history_replay"]["insert_discard_extensions"],
                      "announced_virtual_choices": graph["announced_virtual_choices_checked"],
                      "certificate": str(target.relative_to(ROOT))}, sort_keys=True))


if __name__ == "__main__":
    main()
