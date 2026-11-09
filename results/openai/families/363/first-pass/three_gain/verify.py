#!/usr/bin/env python3
"""Replay the three-gain Jacobian identity from the collision recursion."""

import argparse
import json
from pathlib import Path

import sympy as s


ROOT = Path(__file__).resolve().parent
R, Z = s.symbols("R Z", real=True)
T0, T1, T2, T3 = s.symbols("T0 T1 T2 T3", real=True)
E3 = s.Matrix([0, 0, 1])


def reduced(matrix):
    return matrix.applyfunc(s.factor)


def zero(matrix):
    assert reduced(matrix) == s.zeros(*matrix.shape), matrix


def recursive_derivative(gains=3):
    """Differentiate the actual map with completely arbitrary profile 1-jets."""
    assert gains in (3, 5)
    h = s.symbols("h0:7", real=True)
    a = s.symbols(f"a1:{gains + 1}", real=True)
    at = s.symbols(f"at1:{gains + 1}", real=True)
    az = s.symbols(f"az1:{gains + 1}", real=True)
    x0 = s.Matrix(s.symbols("x0 y0 z0", real=True))
    x, v, previous_time = x0, s.Matrix([R, 0, Z]), T0
    times = (T1, T2, T3) if gains == 3 else (T1, T2, T3, *s.symbols("T4:6", real=True))
    planes = (
        s.Matrix([0, h[3], -1 / R]),
        s.Matrix([0, 0, 1 + h[4]]),
        s.Matrix([0, h[5], h[6]]),
    ) + (s.zeros(3, 1),) * (gains - 3)
    for i, (base_time, plane) in enumerate(zip(times, planes)):
        time = base_time + (h[i] if i < 2 else h[2] if i == gains - 1 else 0)
        x = x - (previous_time - time) * v
        base_z = x0[2] - (T0 - base_time) * Z
        profile = a[i] + at[i] * (time - base_time) + az[i] * (x[2] - base_z)
        normal = v - profile * E3
        v = v + normal.cross(plane)
        previous_time = time
    output = s.Matrix([previous_time, *x, *v])
    origin = dict.fromkeys(h, 0)
    jacobian = s.Matrix(
        7, 7, lambda row, col: s.factor(s.diff(output[row], h[col]).subs(origin))
    )
    expected = s.Matrix(
        [
            [0, 0, 1, 0, 0, 0, 0],
            [0, -1, R + 1, (Z - a[0]) * (T1 - T3), T3 - T2, 0, 0],
            [-1, R, 1 - R, -(Z - a[0]) * (T2 - T3), R * (T2 - T3), 0, 0],
            [0, 0, Z, -R * (T1 - T3), 0, 0, 0],
            [0, 0, 0, -(Z - a[0]), 1, -(Z - a[2]), 1 - R],
            [0, 0, 0, Z - a[0], -R, 0, -R - 1],
            [0, 0, 0, R, 0, R + 1, 0],
        ]
    )
    normalized = jacobian.copy()
    normalized[1:4, :] += (T3 - times[-1]) * jacobian[4:7, :]
    zero(normalized - expected)
    for derivative in (*at, *az):
        zero(jacobian.diff(derivative))
    determinant = s.factor(jacobian.det(method="domain-ge"))
    assert s.factor(determinant - R * (T1 - T3) * (R + 1) * (R**2 + 1)) == 0
    return jacobian, determinant, (Z - a[0], Z - a[2])


def tangent_map(gains):
    """Full first variation, without freezing profile arguments or time flights."""
    times = s.symbols(f"t1:{gains + 1}", real=True)
    values = s.symbols(f"a1:{gains + 1}", real=True)
    at = s.symbols(f"at1:{gains + 1}", real=True)
    az = s.symbols(f"az1:{gains + 1}", real=True)
    planes = [s.Matrix(s.symbols(f"l{i}x l{i}y l{i}z")) for i in range(gains)]
    width = 4 * gains
    x = s.Matrix(s.symbols("x y z"))
    v = s.Matrix(s.symbols("vx vy vz"))
    dx, dv = s.zeros(3, width), s.zeros(3, width)
    previous_time, dprevious_time = T0, s.zeros(1, width)
    normals = []
    for i in range(gains):
        dt = s.zeros(1, width)
        dt[i] = 1
        dl = s.zeros(3, width)
        for j in range(3):
            dl[j, gains + 3 * i + j] = 1
        dx = dx - (previous_time - times[i]) * dv - v * (dprevious_time - dt)
        x = x - (previous_time - times[i]) * v
        da = at[i] * dt + az[i] * dx[2, :]
        normal = v - values[i] * E3
        dn = dv - E3 * da
        dk = s.Matrix.hstack(
            *(dn[:, j].cross(planes[i]) + normal.cross(dl[:, j]) for j in range(width))
        )
        dv = dv + dk
        v = v + normal.cross(planes[i])
        normals.append(normal)
        previous_time, dprevious_time = times[i], dt
    return s.Matrix.vstack(dprevious_time, dx, dv), normals


def two_gain_obstruction():
    jacobian, normals = tangent_map(2)
    for i, normal in enumerate(normals):
        direction = s.zeros(8, 1)
        direction[2 + 3 * i : 5 + 3 * i, 0] = normal
        zero(jacobian * direction)
    # At zero normal the entire local plane derivative, not just one vector, vanishes.
    for j in range(3):
        zero(s.zeros(3, 1).cross(s.eye(3)[:, j]))
    return {
        "input_dimension": 8,
        "independent_kernel_blocks": 2,
        "rank_upper_bound": 6,
        "zero_normal_case": "all three plane directions are in the kernel",
    }


def boundary_check():
    velocity = s.Matrix([0, 0, Z])
    normal = velocity - Z * E3
    zero(normal)
    for i in range(3):
        plane = s.Matrix(s.symbols(f"c{i}x c{i}y c{i}z"))
        velocity = velocity + normal.cross(plane)
        zero(velocity - Z * E3)
    return "An axial endpoint and constant partners equal to it give rank one, for any gain count."


def polynomial_entry(expr, variables):
    poly = s.Poly(s.expand(expr), *variables, domain=s.QQ)
    return {
        "domain": "QQ",
        "variables": [str(v) for v in variables],
        "numerator": {
            "terms": [
                {
                    "coefficient": {"num": str(c.p), "den": str(c.q)},
                    "exponents": list(powers),
                }
                for powers, c in poly.terms()
                if c
            ]
        },
        "denominator": {
            "terms": [
                {"coefficient": {"num": "1", "den": "1"}, "exponents": [0] * len(variables)}
            ]
        },
    }


def certificate():
    jacobian, determinant, b = recursive_derivative()
    _, five_determinant, _ = recursive_derivative(5)
    b1, b3, D, E = s.symbols("b1 b3 D E")
    compact = jacobian.subs({b[0]: b1, b[1]: b3, T1: D + T3, T2: E + T3})
    compact = reduced(compact)
    variables = [R, Z, b1, b3, D, E]
    assert not (set().union(*(entry.free_symbols for entry in compact)) - set(variables))
    payload = {
        "matrix": {
            "variables": [str(v) for v in variables],
            "entries": [
                [polynomial_entry(compact[i, j], variables) for j in range(7)]
                for i in range(7)
            ],
        }
    }
    result = {
        "claim": "C3_ALG",
        "result_class": "exact_symbolic_identity",
        "method": "Differentiate the recursive map with arbitrary affine profile 1-jets.",
        "rows": ["t3", "x3_x", "x3_y", "x3_z", "v3_x", "v3_y", "v3_z"],
        "columns": ["t1", "t2", "t3", "L1_y", "L2_z", "L3_y", "L3_z"],
        "witness": {
            "endpoint_velocity": ["R", "0", "Z"],
            "L1": ["0", "0", "-1/R"],
            "L2": ["0", "0", "1"],
            "L3": ["0", "0", "0"],
            "time_hypotheses": "0 < T3 < T2 < T1 < T0",
            "endpoint_hypothesis": "R > 0",
        },
        "minor": [[str(compact[i, j]) for j in range(7)] for i in range(7)],
        "abbreviations": {"b1": "Z-a1", "b3": "Z-a3", "D": "T1-T3", "E": "T2-T3"},
        "determinant": str(determinant),
        "positive_factorization": "R * (T1-T3) * (R+1) * (R^2+1)",
        "profile_first_derivatives_cancel": True,
        "two_gain": two_gain_obstruction(),
        "five_gain_extension": {
            "L4": ["0", "0", "0"],
            "L5": ["0", "0", "0"],
            "columns": ["t1", "t2", "t5", "L1_y", "L2_z", "L3_y", "L3_z"],
            "determinant": str(five_determinant),
            "profile_first_derivatives_cancel": True,
            "row_reduction": "dx5 + (T3-T5) dv5 has the original three-gain position rows",
        },
        "boundary": boundary_check(),
        "coverage": "Universal first-jet algebra, not finite sampling.",
        "not_certified_here": [
            "The analytic-null-set and uniform-pullback proofs are in theorem.md.",
            "Lean certifies the algebra described in statement_fidelity.md.",
            "Independent review, novelty, significance, and the full PDE theorem remain separate.",
        ],
    }
    return result, payload


def check_jacobian(payload):
    status = json.loads((ROOT / "jacobian_status.json").read_text())
    response = json.loads((ROOT / "jacobian_output.json").read_text())
    operation = "matrix.symbolic.determinant.compute"
    assert status == {"operation_id": operation, "adapter_exit_code": 0}
    assert response["request"] == {"operation_id": operation, "payload": payload}
    assert response["tool"] == "math.run"
    assert response["server"]["name"] == "jacobian"
    assert response["server"]["version"]
    assert response["protocol_version"]
    assert response["result"]["operation_id"] == operation
    output = response["result"]["output"]
    assert output["method"] == "SYMPY_BAREISS"
    value = output["determinant"]
    assert value["domain"] == "QQ"
    assert value["variables"] == payload["matrix"]["variables"]
    variables = s.symbols(" ".join(value["variables"]))

    def polynomial(terms):
        return sum(
            s.Rational(term["coefficient"]["num"], term["coefficient"]["den"])
            * s.prod(v**e for v, e in zip(variables, term["exponents"], strict=True))
            for term in terms
        )

    actual = polynomial(value["numerator"]["terms"]) / polynomial(value["denominator"]["terms"])
    r, _, _, _, d, _ = variables
    assert s.factor(actual - r * d * (r + 1) * (r**2 + 1)) == 0


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--check", action="store_true", help="compare existing certificate; write nothing")
    args = parser.parse_args()
    result, payload = certificate()
    artifacts = (
        (ROOT / "exact_certificate.json", result),
        (ROOT / "jacobian_payload.json", payload),
    )
    for path, content in artifacts:
        if args.check:
            assert json.loads(path.read_text()) == content, f"certificate mismatch: {path}"
        else:
            path.write_text(json.dumps(content, indent=2) + "\n")
    check_jacobian(payload)
    print("Exact recursive Jacobian: det = R*(T1-T3)*(R+1)*(R^2+1).")
    print("All six profile partial derivatives cancel; two-gain kernel and axial boundary verified.")
    print("The actual five-gain extension has the same determinant.")
    print("Archived typed Jacobian request, successful status, and exact response agree.")


if __name__ == "__main__":
    main()
