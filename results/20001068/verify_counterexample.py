#!/usr/bin/env python3

from collections import Counter, defaultdict
import json
from math import gcd


SCALE = 20


def rational(units):
    divisor = gcd(units, SCALE)
    return {"num": str(units // divisor), "den": str(SCALE // divisor)}


base_labels = ["r", "a0", "a1"] + [
    f"b{i}{j}" for i in range(2) for j in range(1, 6)
]
base_index = {label: index for index, label in enumerate(base_labels)}
base_order = len(base_labels)
labels = [f"{label}-" for label in base_labels] + [
    f"{label}+" for label in base_labels
]
order = len(labels)

weights = [[None for _ in range(order)] for _ in range(order)]
edge_kinds = {}


def add_arc(source, target, weight_units, kind):
    assert source != target
    assert weights[source][target] is None
    assert 0 <= weight_units <= SCALE
    weights[source][target] = weight_units
    edge_kinds[source, target] = kind


base_arcs = []
for branch in range(2):
    branch_label = f"a{branch}"
    base_arcs.append(("r", branch_label, 10, "root_to_branch"))
    for leaf_number in range(1, 6):
        leaf_label = f"b{branch}{leaf_number}"
        base_arcs.extend(
            [
                (branch_label, leaf_label, 4, "branch_to_leaf"),
                (leaf_label, "r", 5, "leaf_to_root"),
                (leaf_label, branch_label, 15, "leaf_to_branch"),
            ]
        )

for source_label, target_label, weight_units, kind in base_arcs:
    source = base_index[source_label]
    target = base_index[target_label]
    add_arc(target, source, weight_units, f"negative_reversed_{kind}")
    add_arc(
        base_order + source,
        base_order + target,
        weight_units,
        f"positive_{kind}",
    )

for branch in range(2):
    for leaf_number in range(1, 6):
        leaf = base_index[f"b{branch}{leaf_number}"]
        add_arc(
            leaf,
            base_order + leaf,
            16,
            "negative_to_positive_completion",
        )

arcs = [
    (source, target, weights[source][target], edge_kinds[source, target])
    for source in range(order)
    for target in range(order)
    if weights[source][target] is not None
]

inweight_units = [
    sum(weights[source][target] or 0 for source in range(order))
    for target in range(order)
]
outweight_units = [
    sum(weights[source][target] or 0 for target in range(order))
    for source in range(order)
]

# Compute mutual-reachability classes directly from the adjacency matrix.
reachable = [[source == target for target in range(order)] for source in range(order)]
for source, target, _, _ in arcs:
    reachable[source][target] = True
for middle in range(order):
    for source in range(order):
        if reachable[source][middle]:
            for target in range(order):
                reachable[source][target] = (
                    reachable[source][target] or reachable[middle][target]
                )

unassigned = set(range(order))
components = []
while unassigned:
    first = min(unassigned)
    component = sorted(
        vertex
        for vertex in unassigned
        if reachable[first][vertex] and reachable[vertex][first]
    )
    components.append(component)
    unassigned.difference_update(component)


def enumerate_component_cycles(component):
    """Enumerate cycles once, anchored at their least local vertex."""
    component_cycles = []
    size = len(component)
    for start in range(size):
        states_by_size = [defaultdict(list) for _ in range(size + 1)]
        states_by_size[1][(1 << start, start)].append((start,))
        for path_size in range(1, size + 1):
            for (mask, end), paths in states_by_size[path_size].items():
                for path in paths:
                    if (
                        path_size >= 2
                        and weights[component[end]][component[start]] is not None
                    ):
                        component_cycles.append(tuple(component[index] for index in path))
                    if path_size == size:
                        continue
                    for next_vertex in range(start + 1, size):
                        if mask & (1 << next_vertex):
                            continue
                        if weights[component[end]][component[next_vertex]] is None:
                            continue
                        states_by_size[path_size + 1][
                            (mask | (1 << next_vertex), next_vertex)
                        ].append(path + (next_vertex,))
    return component_cycles


cycles = []
for component in components:
    cycles.extend(enumerate_component_cycles(component))

cycle_records = []
cycle_weight_units = []
for cycle in sorted(cycles):
    cycle_arcs = []
    total_units = 0
    for position, source in enumerate(cycle):
        target = cycle[(position + 1) % len(cycle)]
        weight_units = weights[source][target]
        assert weight_units is not None
        total_units += weight_units
        cycle_arcs.append(
            {
                "source": labels[source],
                "target": labels[target],
                "weight": rational(weight_units),
            }
        )
    cycle_weight_units.append(total_units)
    cycle_records.append(
        {
            "vertices": [labels[vertex] for vertex in cycle],
            "length": len(cycle),
            "arcs": cycle_arcs,
            "total_weight": rational(total_units),
        }
    )

histogram = Counter((len(cycle), weight) for cycle, weight in zip(cycles, cycle_weight_units))
inter_component_arcs = [
    (source, target)
    for source, target, _, _ in arcs
    if not any(source in component and target in component for component in components)
]

assert order == 26
assert len(arcs) == 74
assert sorted(len(component) for component in components) == [13, 13]
assert len(inter_component_arcs) == 10
assert min(inweight_units) == SCALE
assert min(outweight_units) == SCALE
assert len(cycles) == 40
assert histogram == Counter({(2, 19): 20, (3, 19): 20})
assert max(cycle_weight_units) == 19 < SCALE

certificate = {
    "claim": (
        "The displayed finite loopless simple weighted digraph has every "
        "edge weight in [0,1], every vertex inweight and outweight at least "
        "1, and every simple directed cycle of total weight below 1."
    ),
    "arithmetic": {
        "method": "integer arithmetic in units of 1/20",
        "scale": SCALE,
    },
    "construction": {
        "vertex_count": order,
        "arc_count": len(arcs),
        "vertices": [
            {"index": index, "label": label} for index, label in enumerate(labels)
        ],
        "arcs": [
            {
                "source_index": source,
                "source": labels[source],
                "target_index": target,
                "target": labels[target],
                "weight": rational(weight_units),
                "weight_units": weight_units,
                "kind": kind,
            }
            for source, target, weight_units, kind in arcs
        ],
    },
    "local_weight_checks": [
        {
            "vertex_index": vertex,
            "vertex": labels[vertex],
            "inweight": rational(inweight_units[vertex]),
            "inweight_units": inweight_units[vertex],
            "outweight": rational(outweight_units[vertex]),
            "outweight_units": outweight_units[vertex],
            "inweight_at_least_one": inweight_units[vertex] >= SCALE,
            "outweight_at_least_one": outweight_units[vertex] >= SCALE,
        }
        for vertex in range(order)
    ],
    "cycle_enumeration": {
        "method": (
            "Floyd-Warshall mutual reachability partitions the graph into "
            "strongly connected components. Within each component, subset "
            "dynamic programming stores every simple path by bitmask and "
            "endpoint; a cycle is emitted only when its least local vertex "
            "is the path start. Thus rotations are excluded by construction."
        ),
        "strongly_connected_components": [
            [labels[vertex] for vertex in component] for component in components
        ],
        "inter_component_arc_count": len(inter_component_arcs),
        "simple_directed_cycle_count": len(cycles),
        "histogram": [
            {
                "length": length,
                "total_weight": rational(weight_units),
                "count": count,
            }
            for (length, weight_units), count in sorted(histogram.items())
        ],
        "maximum_total_weight": rational(max(cycle_weight_units)),
        "all_cycles": cycle_records,
    },
    "verified": {
        "finite": True,
        "loopless": all(source != target for source, target, _, _ in arcs),
        "no_parallel_arcs": len(arcs)
        == sum(
            weights[source][target] is not None
            for source in range(order)
            for target in range(order)
        ),
        "all_edge_weights_in_closed_unit_interval": all(
            0 <= weight_units <= SCALE for _, _, weight_units, _ in arcs
        ),
        "all_vertex_inweights_at_least_one": all(
            weight_units >= SCALE for weight_units in inweight_units
        ),
        "all_vertex_outweights_at_least_one": all(
            weight_units >= SCALE for weight_units in outweight_units
        ),
        "all_simple_directed_cycle_weights_below_one": all(
            weight_units < SCALE for weight_units in cycle_weight_units
        ),
    },
}

print(json.dumps(certificate, indent=2, sort_keys=True))
