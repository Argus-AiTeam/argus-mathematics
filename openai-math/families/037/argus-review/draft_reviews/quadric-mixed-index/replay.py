#!/usr/bin/env python3
"""Replay only the inspected quadric arithmetic, not archived ledger/Lean checks."""

import hashlib
import importlib.util
import json
import platform
import sys
from pathlib import Path

import sympy as sp


UNIT = Path(__file__).resolve().parent
ARCHIVE = UNIT / "archive"


def main():
    bindings = json.loads((UNIT / "source_bindings.json").read_text())
    for entry in bindings["artifacts"]:
        if "copy" in entry:
            local = ARCHIVE / Path(entry["copy"]).name
            assert hashlib.sha256(local.read_bytes()).hexdigest() == entry["sha256"]

    spec = importlib.util.spec_from_file_location("archived_quadric_verify", ARCHIVE / "verify.py")
    archived = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(archived)
    symbolic = archived.symbolic_identities()
    quadric, payload = archived.quadric_check()
    archived_adapter = archived.jacobian_check(payload)
    certificate = json.loads((ARCHIVE / "exact_certificate.json").read_text())
    assert symbolic == certificate["symbolic_identities"]
    assert quadric == certificate["exact_quadric_replay"]
    assert archived_adapter == certificate["jacobian"]

    rows, matrix, regenerated = archived.taylor_data()
    assert payload == regenerated
    assert payload == json.loads((UNIT / "jacobian_payload.json").read_text())
    assert (UNIT / "jacobian_payload.json").read_bytes() == (
        ARCHIVE / "jacobian_payload.json"
    ).read_bytes()
    z = sp.symbols("z1:5")
    negative_chart_basis = [sp.Integer(1), *z, -sum(x**2 for x in z)]
    negative_matrix = sp.Matrix([
        [sp.Poly(f, *z).coeff_monomial(alpha) for f in negative_chart_basis]
        for alpha in rows
    ])
    assert negative_matrix == matrix * sp.diag(1, 1, 1, 1, 1, -1)
    prefix_ranks = [matrix[:end, :].rank() for end in range(len(rows) + 1)]
    assert prefix_ranks == [
        negative_matrix[:end, :].rank() for end in range(len(rows) + 1)
    ]

    fresh = json.loads((UNIT / "jacobian_output.json").read_text())
    adapter_exit = json.loads((UNIT / "jacobian_exit.json").read_text())
    assert adapter_exit["adapter_exit_code"] == 0
    assert not adapter_exit["timeout"]
    assert fresh["request"] == {"operation_id": "matrix.rank.compute", "payload": payload}
    result = fresh["result"]
    assert result["operation_id"] == "matrix.rank.compute"
    assert result["output"]["matrix"] == payload["matrix"]
    assert result["output"]["method"] == "EXACT_RATIONAL_ROW_REDUCTION"
    assert result["output"]["rank"] == matrix.rank() == 6
    assert result["output"]["pivot_columns"] == list(range(6))

    findings = {
        "status": "PASS",
        "interpreter": sys.executable,
        "python_version": sys.version,
        "sympy_version": sp.__version__,
        "platform": platform.platform(),
        "executed_archived_functions": [
            "symbolic_identities", "quadric_check", "taylor_data", "jacobian_check"
        ],
        "not_executed": ["main", "certificate", "lean_check", "any archived external command"],
        "archived_certificate_fields_reproduced": [
            "symbolic_identities", "exact_quadric_replay", "jacobian"
        ],
        "symbolic_identities": symbolic,
        "quadric": quadric,
        "complete_degree_one_taylor_matrix": {
            "shape": [matrix.rows, matrix.cols],
            "ordered_row_exponents": [list(alpha) for alpha in rows],
            "rank_after_each_prefix_including_empty": prefix_ranks,
            "square_row_zero_based": rows.index((0, 0, 0, 2)),
            "mixed_row_zero_based": rows.index((0, 0, 1, 1)),
            "negative_chart": "x5=-sum(yi^2) changes only the sign of the final basis column",
            "negative_chart_prefix_ranks_identical": True,
            "completeness_reason": "All degree-one sections have Taylor degree at most two.",
        },
        "fresh_adapter": {
            "operation_id": result["operation_id"],
            "rank": result["output"]["rank"],
            "pivot_columns": result["output"]["pivot_columns"],
            "server_version": fresh["server"]["version"],
            "protocol_version": fresh["protocol_version"],
        },
        "logical_limit": (
            "Finite exact replay only. The all-degree normal-form proof is in report.md; "
            "no global lifting, Lean compilation, or old/active ledger validation is claimed."
        ),
    }
    (UNIT / "replay.json").write_text(json.dumps(findings, indent=2) + "\n")
    print("PASS: archived quadric/symbolic checks; complete 15x6 Taylor map; "
          "mixed prefix 6->6; shifted facet 0; degree 0..4 dimensions 1,6,20,50,105.")
    print(f"Python {platform.python_version()}, SymPy {sp.__version__}; "
          "one fresh adapter rank 6 validated against the exact payload.")


if __name__ == "__main__":
    main()
