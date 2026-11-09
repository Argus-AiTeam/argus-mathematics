"""Check the saved, single Jacobian balance calculation without contacting it."""

import json
from fractions import Fraction
from pathlib import Path


HERE = Path(__file__).resolve().parent


def rational(entry):
    value = Fraction(int(entry["num"]), int(entry["den"]))
    assert entry == {"num": str(value.numerator), "den": str(value.denominator)}
    return value


def main():
    payload = json.loads((HERE / "payload.json").read_text())
    contract = json.loads((HERE / "contract.json").read_text())
    reply = json.loads((HERE / "output.json").read_text())
    status = json.loads((HERE / "run.status.json").read_text())
    assert status["exit_code"] == 0 and not status["timeout"]
    operation = "matrix.nullspace.compute"
    assert contract["result"]["operation"]["operation_id"] == operation
    assert reply["request"] == {"operation_id": operation, "payload": payload}
    assert reply["result"]["operation_id"] == operation
    assert reply["server"] == contract["server"]
    assert reply["protocol_version"] == contract["protocol_version"]
    output = reply["result"]["output"]
    assert output["matrix"] == payload["matrix"]
    matrix = [[rational(x) for x in row] for row in payload["matrix"]["entries"]]
    assert matrix == [[-2, 0, 2], [2, -2, 0], [0, 2, -2]]
    basis = [[rational(x) for x in row] for row in output["basis_vectors"]]
    assert basis == [[1, 1, 1]]
    assert all(sum(x * y for x, y in zip(row, basis[0])) == 0 for row in matrix)
    minor = matrix[0][0] * matrix[1][1] - matrix[0][1] * matrix[1][0]
    assert minor == 4
    assert all(sum(matrix[i][j] for i in range(3)) == 0 for j in range(3))
    assert output["rank"] == 2 and output["nullity"] == 1
    assert output["ambient_dimension"] == 3 and output["free_columns"] == [2]
    assert output["convention"] == "RREF_FUNDAMENTAL_BASIS"
    result = {
        "operation_id": operation,
        "server_version": reply["server"]["version"],
        "protocol_version": reply["protocol_version"],
        "status": "exact_typed_output_consistent_with_independent_rank_certificate",
        "matrix": [[int(x) for x in row] for row in matrix],
        "nonzero_two_by_two_minor": int(minor),
        "row_relation": [1, 1, 1],
        "rank": 2,
        "rational_kernel_basis": [[1, 1, 1]],
        "integer_kernel": "Z*(1,1,1)",
        "integer_kernel_reason": "An integral kernel vector is t*(1,1,1); its first coordinate forces t to be integral.",
        "scope": "DS equation (15), not geometric realizability or any Hodge-conjecture assertion.",
    }
    (HERE / "checked_result.json").write_text(json.dumps(result, indent=2) + "\n")
    print(json.dumps(result, sort_keys=True))


if __name__ == "__main__":
    main()
