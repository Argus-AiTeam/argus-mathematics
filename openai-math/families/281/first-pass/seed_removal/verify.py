#!/usr/bin/env python3
"""Replay exact algebra and root-shift energies, without Fock truncation."""

import argparse
import json
from pathlib import Path

import sympy as sp


HERE = Path(__file__).resolve().parent
I = sp.I
X = sp.Matrix([[0, 1], [1, 0]])
Y = sp.Matrix([[0, -I], [I, 0]])
Z = sp.diag(1, -1)
PLUS = sp.Matrix([1, 1]) / sp.sqrt(2)


def zero_matrix(matrix):
    assert all(sp.simplify(entry) == 0 for entry in matrix), matrix


def dagger(matrix, variables):
    substitutions = {sp.conjugate(z): 1 / z for z in variables}
    return matrix.conjugate().T.subs(substitutions)


def gaussian_mean(expression, variables):
    """z_j=exp(i s_j/2), with the s_j independent standard Gaussians."""
    expression = sp.expand(expression)
    result = 0
    for term in sp.Add.make_args(expression):
        powers = term.as_powers_dict()
        exponents = [powers.get(z, 0) for z in variables]
        assert all(sp.sympify(k).is_Integer for k in exponents)
        coefficient = sp.cancel(term / sp.prod(z**k for z, k in zip(variables, exponents)))
        assert not coefficient.has(*variables), coefficient
        result += coefficient * sp.exp(-sum(k**2 for k in exponents) / 8)
    return sp.simplify(result)


def local_inner(left, right, variables):
    return gaussian_mean((dagger(left, variables) * right)[0], variables)


def energy_test(reused):
    variables = sp.symbols("z") if reused else sp.symbols("z1 z2")
    variables = (variables,) if reused else variables
    z1, z2 = (variables[0], variables[0]) if reused else variables
    seed1 = sp.diag(1 / z1, z1)
    seed2 = sp.diag(1 / z2, z2)
    mixer = (sp.eye(2) - I * X) / sp.sqrt(2)
    preword = seed2 * mixer * seed1
    adjoint = dagger(preword, variables)
    zero_matrix(adjoint * preword - sp.eye(2))
    v = sp.simplify(adjoint * Z * preword * PLUS)
    assert local_inner(v, v, variables) == 1
    assert local_inner(PLUS, v, variables) == 0
    x_mean = local_inner(preword * PLUS, X * preword * PLUS, variables)

    # gamma=1/2, eta=pi/8. Each pair is (root coefficient, Weyl center / v).
    packets = [(v / sp.sqrt(2), sp.Integer(0))]
    for z in (1, -1):
        projector = (sp.eye(2) + z * Z) / 2
        coefficient = adjoint * Y * projector * preword * PLUS / sp.sqrt(2)
        packets.append((sp.simplify(coefficient), sp.Integer(-z)))

    h_mean = sum(
        local_inner(PLUS, coefficient, variables) * sp.exp(-center**2 / 2)
        for coefficient, center in packets
    )
    h_norm_squared = sum(
        local_inner(left, right, variables) * sp.exp(-(b - a)**2 / 2)
        for left, a in packets for right, b in packets
    )
    assert sp.simplify(h_mean) == 0
    assert sp.simplify(h_norm_squared) == 1
    v_h = sp.simplify(sum(
        local_inner(v, coefficient, variables) * sp.exp(-center**2 / 2)
        for coefficient, center in packets
    ))
    h_lh = sp.simplify(-I * sum(
        local_inner(coefficient, PLUS, variables)
        * sp.exp(-center**2 / 2) * center * v_h
        for coefficient, center in packets
    ))
    energy = sp.simplify(sp.re(sp.expand_complex(h_lh)))
    assert sp.simplify(energy - x_mean * sp.exp(-sp.Rational(1, 2)) / 2) == 0
    return energy, x_mean


def transport_checks():
    p0, p1 = sp.diag(1, 0), sp.diag(0, 1)
    ordinary = sp.kronecker_product(sp.eye(2), p0)
    special = sp.kronecker_product(sp.eye(2), p1)
    z = sp.kronecker_product(Z, sp.eye(2))
    flip = ordinary + sp.kronecker_product(-I * X, p1)
    rotation = (sp.eye(2) - I * X) / sp.sqrt(2)
    global_mixer = sp.kronecker_product(rotation, sp.eye(2))
    selective_inverse = ordinary + sp.kronecker_product(rotation.conjugate().T, p1)
    compensated = global_mixer * selective_inverse
    zero_matrix(flip.conjugate().T * z * flip - z * (ordinary - special))
    zero_matrix(compensated.conjugate().T * z * compensated * special - z * special)
    zero_matrix(compensated * special - special)
    assert any(sp.simplify(e) != 0 for e in compensated * z - z * compensated)
    prefix = sp.eye(4)
    sign = 1
    # Two completed echoes, with genuinely noncommuting bulk mixers between them.
    for gate, toggles in [
        (flip, True), (flip.conjugate().T, True),
        (compensated, False),
        (flip, True), (flip.conjugate().T, True),
        (compensated, False),
    ]:
        prefix = gate * prefix
        sign = -sign if toggles else sign
        zero_matrix(prefix.conjugate().T * z * prefix * special - sign * z * special)
    assert sign == 1


def weyl_initialization_check():
    gamma, h, c, r = sp.symbols("gamma h c r", real=True)
    theta = -gamma * h
    origin = (sp.Integer(0), sp.Integer(0))

    def multiply(left, right):
        result = {}
        for f, a in left.items():
            for g, b in right.items():
                center = tuple(sp.expand(x + y) for x, y in zip(f, g))
                phase = sp.exp(-I * h * (f[0] * g[1] - f[1] * g[0]))
                result[center] = result.get(center, sp.zeros(2)) + phase * a * b
        return {f: a.applyfunc(sp.simplify) for f, a in result.items()}

    def adjoint(terms):
        return {tuple(-x for x in f): a.conjugate().T for f, a in terms.items()}

    def controlled(center):
        return {
            center: (sp.eye(2) + Z) / 2,
            tuple(-x for x in center): (sp.eye(2) - Z) / 2,
        }

    def scale(scalar, terms):
        return {f: scalar * a for f, a in terms.items()}

    def add(left, right):
        return {
            f: left.get(f, sp.zeros(2)) + right.get(f, sp.zeros(2))
            for f in left.keys() | right.keys()
        }

    def equal(left, right):
        for f in left.keys() | right.keys():
            zero_matrix(left.get(f, sp.zeros(2)) - right.get(f, sp.zeros(2)))

    rotation = {origin: (sp.eye(2) - I * X) / sp.sqrt(2)}
    uo = multiply(rotation, controlled((0, 1)))
    us = multiply(multiply(rotation, {origin: X}), controlled((-2 * gamma, -1)))
    exact = multiply(multiply(multiply(
        rotation, controlled((gamma, 1))),
        {origin: c * sp.eye(2) - I * r * X}), controlled((-gamma, 0)))
    equal(exact, add(scale(c * sp.exp(I * theta), uo),
                     scale(-I * r * sp.exp(-I * theta), us)))

    mixed = multiply(multiply(adjoint(uo), {origin: Z}), us)
    special = multiply(multiply(adjoint(us), {origin: Z}), us)
    w = add(scale(-I * c * sp.exp(-2 * I * theta), mixed), scale(r, special))
    expected = add(
        scale(-c * sp.exp(-4 * I * theta),
              multiply({origin: Z}, controlled((-2 * gamma, -2)))),
        scale(-r, multiply({origin: Y}, controlled((-4 * gamma, -2)))),
    )
    equal(w, expected)


def jacobian_check():
    payload = json.loads((HERE / "jacobian_payload.json").read_text())
    response = json.loads((HERE / "jacobian_output.json").read_text())
    assert response["request"]["payload"] == payload
    operation = "matrix.symbolic.multiply.compute"
    assert response["request"]["operation_id"] == operation
    assert response["result"]["operation_id"] == operation

    def rational(entry):
        assert entry["variables"] == []
        assert entry["denominator"]["terms"] == [
            {"coefficient": {"den": "1", "num": "1"}, "exponents": []}
        ]
        return sum(
            sp.Rational(t["coefficient"]["num"], t["coefficient"]["den"])
            for t in entry["numerator"]["terms"]
        )

    result = sp.Matrix([
        [rational(entry) for entry in row]
        for row in response["result"]["output"]["entries"]
    ])
    zero_matrix(result + Z)
    return {
        "operation_id": operation,
        "server_version": response["server"]["version"],
        "protocol_version": response["protocol_version"],
        "adapter_exit_code": 0,
        "structured_error": None,
        "timeout": False,
        "typed_output_checked": True,
    }


def certificate():
    zero_matrix(X * Z * X + Z)
    zero_matrix(Y * Z - I * X)
    zero_matrix(Z * Y + I * X)
    weyl_initialization_check()
    transport_checks()
    reused, x_reused = energy_test(True)
    fresh, x_fresh = energy_test(False)
    gap = sp.exp(-sp.Rational(1, 2)) * (1 - sp.exp(-1))**2 / 4
    assert sp.simplify(reused - fresh - gap) == 0
    assert sp.simplify(x_reused - (1 + sp.exp(-2)) / 2) == 0
    assert sp.simplify(x_fresh - sp.exp(-1)) == 0

    r, t, k, z, q = sp.symbols("r t k z q", positive=True)
    assert sp.cancel((t / r) * k * r**2 - t * k * r) == 0
    assert sp.expand(q * (1 + z**2) / 4 - q * z / 2 - q * (1 - z)**2 / 4) == 0
    return {
        "schema_version": 1,
        "result_class": "new_theorem",
        "research_target_level": "publishable",
        "math_objective_mode": "exploratory",
        "certification_status": "engineer_replay_only",
        "novelty_status": "not_yet_independently_verified",
        "claims": ["SR_WEIGHTED", "SR_ENERGY_TEST", "SR_CORE"],
        "exact_results": {
            "pauli_conjugation": "X Z X = -Z",
            "weyl_initialization": "exact two-component split with theta=gamma Im<d0,e>",
            "high_direction": "-sqrt(1-r^2) exp(-4i theta) Z W_Z(-2 gamma e-2 d0) vacuum - r Y W_Z(-4 gamma e-2 d0) vacuum",
            "noncommuting_transport": "two restored flips, compensated mixer, two restored flips preserve Z on the special sector",
            "preword": "exp(-i Z s/2) exp(-i pi X/4) exp(-i Z s/2)",
            "readout": "cost gamma=1/2 followed by mixer eta=pi/8",
            "reused_x": str(x_reused),
            "fresh_x": str(x_fresh),
            "reused_root_shift_energy": str(reused),
            "fresh_root_shift_energy": str(fresh),
            "strict_energy_gap": str(gap),
            "gap_positive_because": "exp(-1/2)>0 and 0<exp(-1)<1",
        },
        "quantitative_theorem": {
            "ordinary_defect": "||(Psi_O-zeta A)(1+N)^(-1)|| <= C r^2",
            "normalized_special_defect": "<= C r on the first-number graph norm unit ball",
            "transport": "||u* Z psi_S/r - w_r|| <= C r at every completed gate",
            "echo_displacement": "||(t/r)(v_prime-v)+2t w_r|| <= C r",
            "root_shift_energy": "|E(v_actual)-E(v_formal)| <= C r",
            "proof": "report.md; analytic packet induction, not certified by SymPy alone",
        },
        "jacobian": jacobian_check(),
        "limitations": [
            "The exact sector model checks algebra, not exact orthogonality of actual Fock packets.",
            "The Gaussian characteristic-function and Fock estimates are proved in prose in report.md.",
            "Lean certifies the general norm/transport/rescaling core and scalar gap, not the entire Fock compiler.",
            "This does not certify classical synthesis, the companion, or the final QAOA optimum theorem.",
            "Independent Host-invoked Reviewer certification and novelty assessment remain required.",
        ],
    }


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--write-certificate", action="store_true")
    args = parser.parse_args()
    actual = certificate()
    path = HERE / "exact_certificate.json"
    if args.write_certificate:
        path.write_text(json.dumps(actual, indent=2) + "\n")
    else:
        expected = json.loads(path.read_text())
        assert actual == expected, "The committed certificate differs from exact replay."
    print(json.dumps({
        "status": "PASS",
        "checks": ["exact Pauli algebra", "noncommuting special transport",
                   "exact Weyl initialization and high direction",
                   "reused/fresh root-shift energies", "strict symbolic gap",
                   "singular rescaling", "typed Jacobian replay"],
        "certificate": str(path.relative_to(HERE.parent.parent)),
        "independent_review": "pending",
    }, indent=2))


if __name__ == "__main__":
    main()
