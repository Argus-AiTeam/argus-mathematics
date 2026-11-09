"""Exact necessary row-space catalogue for minimum-normal zero profiles."""

import argparse
import json
from collections import Counter
from itertools import combinations_with_replacement
from pathlib import Path

from conic_kernel import CONIC_KERNEL
from paired_kernel import matrix_rank
from zero_profile_three import (accepted_codes, code_invariant, isometry_to,
                                normalize_or_zero, transformed_rows)


ROOT = Path(__file__).parent


def scaled_multiset(values):
    return min(tuple(sorted(a * x % 5 for x in values)) for a in range(1, 5))


def group_types(maximum_multiplicity):
    return tuple(sorted({
        scaled_multiset(values)
        for size in range(1, 5)
        for values in combinations_with_replacement(range(1, 5), size)
        if max(Counter(values).values()) <= maximum_multiplicity
    }))


def ordinary_partitions(total, maximum_groups):
    types = group_types(1)

    def visit(start, groups, used):
        yield total - used, tuple(groups)
        if len(groups) == maximum_groups:
            return
        for index in range(start, len(types)):
            values = types[index]
            if used + len(values) <= total:
                yield from visit(index, groups + [values], used + len(values))

    yield from visit(0, [], 0)


def signatures():
    result = []
    for support in (4, 5):
        for unassigned, ordinary in ordinary_partitions(support, 4):
            result.append((support, unassigned, None, ordinary))
    for special in ((),) + group_types(2):
        for unassigned, ordinary in ordinary_partitions(4 - len(special), 3):
            result.append((4, unassigned, special, ordinary))
    return tuple(sorted(result, key=repr))


def top_code(support):
    if support == 5:
        return [[int(i == j) for j in range(4)] for i in range(4)] + [[4] * 4]
    if support == 4:
        return [[1, 0, 0, 0], [0, 1, 0, 0], [0, 0, 1, 0],
                [4, 4, 4, 0], [0, 0, 0, 1]]
    raise ValueError("normal support must be four or five")


def signature_data(signature):
    support, unassigned, special, ordinary = signature
    T = [[0] * 5 for _ in range(4)]
    position = row = 0
    if special is not None:
        for value in special:
            T[0][position] = value
            position += 1
        T[0][4] = 1
        row = 1
    for values in ordinary:
        for value in values:
            T[row][position] = value
            position += 1
        row += 1
    if position + unassigned != support or row > 4:
        raise ValueError("invalid disjoint-group signature")
    top = top_code(support)
    bottom = [[-sum(a * b for a, b in zip(t, column)) % 5
               for column in zip(*top)] for t in T]
    code = [list(normalize_or_zero(values)) for values in top + bottom]
    if matrix_rank(code) != 4 or not locally_minimal(T, support):
        raise ArithmeticError("catalogue construction lost its necessary conditions")
    return T, code


def locally_minimal(T, support):
    if (len(T) != 4 or any(len(row) != 5 for row in T)
            or any(value not in range(5) for row in T for value in row)
            or any(sum(bool(T[r][i]) for r in range(4)) > 1 for i in range(5))):
        raise ValueError("T must have five singleton-or-zero columns over F5")
    for row in T:
        outside = sum(bool(x) for x in row[support:])
        counts = Counter(x for x in row[:support] if x)
        if any(count > outside + 1 for count in counts.values()):
            return False
    return True


def raw_signature(T, support):
    if not locally_minimal(T, support):
        return None
    special_row = (next((r for r in range(4) if T[r][4]), None)
                   if support == 4 else None)
    special = None if special_row is None else scaled_multiset(
        [x for x in T[special_row][:4] if x])
    ordinary = tuple(sorted(scaled_multiset([x for x in row[:support] if x])
                            for r, row in enumerate(T)
                            if r != special_row and any(row[:support])))
    unassigned = sum(not any(T[r][i] for r in range(4)) for i in range(support))
    return support, unassigned, special, ordinary


def accepted_row_spaces():
    known = list(accepted_codes())
    known.append(("CC3059", "conic_pair", [row + [0] for row in CONIC_KERNEL]
                  + [[0, 0, 0, 1], [0, 0, 0, 1], [0] * 4]))
    for name, path in (("conic_single", "residual_kernel_single_result.json"),
                       ("conic_hook", "conic_hook_result.json")):
        code = json.loads((ROOT / path).read_text())["kernel_basis"]
        code = code + [[0] * 4 for _ in range(9 - len(code))]
        known.append(("LC3059", name, code))
    previous = json.loads((ROOT / "zero_profile_three_codes.json").read_text())
    if not previous["complete"]:
        raise ValueError("the prior accepted catalogue must be complete")
    for record in previous["code_certificates"]:
        if record["needs_new_domain"]:
            known.append(("ZP3K3059", "zero_three_" + record["label"],
                          record["kernel_basis"]))
    return [(claim, name, code, code_invariant(code)) for claim, name, code in known]


def catalogue():
    known = accepted_row_spaces()
    classes = []
    by_invariant = {}
    for index, signature in enumerate(signatures()):
        T, code = signature_data(signature)
        invariant = code_invariant(code)
        match = None
        for previous in by_invariant.get(invariant, []):
            H = isometry_to(code, previous["kernel_basis"])
            if H is not None:
                match = previous
                match["signatures"].append({
                    "signature": signature, "T": T, "coordinate_isometry": H})
                break
        if match is not None:
            continue
        record = {
            "label": f"z45_{index:03d}",
            "kernel_basis": code,
            "signatures": [{"signature": signature, "T": T,
                            "coordinate_isometry": [[int(i == j) for j in range(4)]
                                                     for i in range(4)]}],
            "physical_zero_rows": sum(not any(row) for row in code),
            "dense_projective_points": sum(count for weight, count in invariant[0]
                                            if weight >= 4),
            "already_accepted": None,
        }
        for claim, name, target, target_invariant in known:
            if invariant != target_invariant:
                continue
            H = isometry_to(code, target)
            if H is not None:
                record["already_accepted"] = {
                    "claim": claim, "name": name, "kernel_basis": target,
                    "coordinate_isometry": H}
                break
        record["needs_new_domain"] = record["already_accepted"] is None
        classes.append(record)
        by_invariant.setdefault(invariant, []).append(record)
    return {
        "prime": 5,
        "ordinary_group_types": group_types(1),
        "exceptional_group_types": ((),) + group_types(2),
        "raw_signature_count": len(signatures()),
        "actual_row_isometry_classes": len(classes),
        "already_accepted_classes": sum(not r["needs_new_domain"] for r in classes),
        "new_classes": sum(r["needs_new_domain"] for r in classes),
        "new_zero_row_histogram": dict(Counter(
            r["physical_zero_rows"] for r in classes if r["needs_new_domain"])),
        "code_certificates": classes,
        "complete_necessary_code_coverage": True,
        "full_matrix_extensions_certified": False,
        "scope": "All singleton-or-zero T columns satisfying the necessary "
                 "single-pivot minimum-normal inequalities for support four/five. "
                 "Actual row-space isometries preserve supports. This catalogue "
                 "alone does not prove ZF3059.",
    }


def write_bases(source, directory):
    if not directory.is_dir():
        raise ValueError("the campaign-local basis directory must already exist")
    for record in source["code_certificates"]:
        if not record["needs_new_domain"]:
            continue
        code = record["kernel_basis"]
        if record["physical_zero_rows"] >= 3:
            code = [row for row in code if any(row)]
            code += [[0] * 4 for _ in range(7 - len(code))]
        (directory / f"{record['label']}_basis.txt").write_text(
            "\n".join(" ".join(map(str, row)) for row in code) + "\n")


def verify_isometry(source, target, H):
    if matrix_rank(H) != 4:
        return False
    return Counter(normalize_or_zero(row) for row in transformed_rows(source, H)) == Counter(
        normalize_or_zero(row) for row in target)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--output", type=Path, required=True)
    parser.add_argument("--basis-directory", type=Path)
    args = parser.parse_args()
    result = catalogue()
    if args.basis_directory:
        write_bases(result, args.basis_directory)
    args.output.write_text(json.dumps(result, indent=2) + "\n")
    print(json.dumps({key: value for key, value in result.items()
                      if key not in ("code_certificates", "exceptional_group_types")}))


if __name__ == "__main__":
    main()
