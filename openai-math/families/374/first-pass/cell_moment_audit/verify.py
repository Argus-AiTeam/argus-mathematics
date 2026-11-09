#!/usr/bin/env python3
"""Replay exact algebra, rational cell geometry, and the Lean evidence binding."""

import argparse
import hashlib
import itertools
import json
from dataclasses import dataclass
from fractions import Fraction as Q
from pathlib import Path

import sympy as sp


ROOT = Path(__file__).resolve().parent
Point = tuple[Q, Q]
Polygon = list[Point]


def dot(x: Point, y: Point) -> Q:
    return x[0] * y[0] + x[1] * y[1]


def sub(x: Point, y: Point) -> Point:
    return x[0] - y[0], x[1] - y[1]


def add(x: Point, y: Point) -> Point:
    return x[0] + y[0], x[1] + y[1]


def scale(a: Q, x: Point) -> Point:
    return a * x[0], a * x[1]


def qtext(x) -> str:
    if isinstance(x, sp.Rational):
        x = Q(int(x.p), int(x.q))
    return str(x)


def point_text(x: Point) -> list[str]:
    return [qtext(t) for t in x]


def clip(poly: Polygon, normal: Point, offset: Q) -> Polygon:
    """Intersect a counterclockwise polygon with normal dot x + offset >= 0."""
    assert normal != (0, 0), "An affine-cell boundary must have a nonzero normal."
    if not poly:
        return []
    out = []
    previous = poly[-1]
    fp = dot(normal, previous) + offset
    for current in poly:
        fc = dot(normal, current) + offset
        if (fp >= 0) != (fc >= 0):
            crossing = add(previous, scale(fp / (fp - fc), sub(current, previous)))
            if not out or crossing != out[-1]:
                out.append(crossing)
        if fc >= 0 and (not out or current != out[-1]):
            out.append(current)
        previous, fp = current, fc
    if len(out) > 1 and out[0] == out[-1]:
        out.pop()
    return out


def polygon_integrals(poly: Polygon) -> tuple[Q, Point]:
    if len(poly) < 3:
        return Q(0), (Q(0), Q(0))
    twice_area = Q(0)
    moment6 = [Q(0), Q(0)]
    for a, b in zip(poly, poly[1:] + poly[:1]):
        cross = a[0] * b[1] - b[0] * a[1]
        twice_area += cross
        for k in range(2):
            moment6[k] += (a[k] + b[k]) * cross
    assert twice_area >= 0, "Clipping reversed polygon orientation."
    return twice_area / 2, (moment6[0] / 6, moment6[1] / 6)


@dataclass(frozen=True)
class Configuration:
    name: str
    epsilon: Q
    halfheight: Q
    sites: tuple[Point, ...]
    intercepts: tuple[Q, ...]

    def body(self) -> Polygon:
        e = self.halfheight
        return [(Q(-1), -e), (Q(1), -e), (Q(1), e), (Q(-1), e)]


def cells(config: Configuration, intercepts: tuple[Q, ...]):
    body = config.body()
    volume, source_moment = polygon_integrals(body)
    assert volume > 0
    polygons, masses, moments = [], [], []
    for i, yi in enumerate(config.sites):
        poly = body
        for j, yj in enumerate(config.sites):
            if j != i:
                poly = clip(poly, sub(yi, yj), intercepts[i] - intercepts[j])
        area, moment = polygon_integrals(poly)
        polygons.append(poly)
        masses.append(area / volume)
        moments.append(scale(1 / volume, moment))
    assert sum(masses) == 1, "The cells do not partition the source."
    assert tuple(sum(b[k] for b in moments) for k in range(2)) == scale(
        1 / volume, source_moment
    )
    return polygons, masses, moments


def face_operators(config: Configuration, polygons):
    n = len(config.sites)
    volume, _ = polygon_integrals(config.body())
    g = [[Q(0) for _ in range(n)] for _ in range(n)]
    b = [[(Q(0), Q(0)) for _ in range(n)] for _ in range(n)]
    for i in range(n):
        for j in range(i + 1, n):
            normal = sub(config.sites[i], config.sites[j])
            offset = config.intercepts[i] - config.intercepts[j]
            hi = sorted(set(x for x in polygons[i] if dot(normal, x) + offset == 0))
            hj = sorted(set(x for x in polygons[j] if dot(normal, x) + offset == 0))
            assert hi == hj, "The two exact face descriptions disagree."
            if len(hi) < 2:
                continue
            a, z = hi[0], hi[-1]
            edge = sub(z, a)
            coarea = abs(edge[1] / normal[0]) if normal[0] else abs(edge[0] / normal[1])
            assert coarea > 0
            coefficient = coarea / volume
            centroid = scale(Q(1, 2), add(a, z))
            g[i][j] = g[j][i] = coefficient
            b[i][j] = b[j][i] = scale(coefficient, centroid)
    reached = {0}
    frontier = [0]
    while frontier:
        i = frontier.pop()
        for j in range(n):
            if g[i][j] > 0 and j not in reached:
                reached.add(j)
                frontier.append(j)
    assert len(reached) == n, "The exact positive-face graph is disconnected."
    return g, b


def laplacian(coefficients):
    n = len(coefficients)
    return sp.Matrix(
        n, n,
        lambda i, j: sum(coefficients[i]) if i == j else -coefficients[i][j],
    )


def directions(n):
    values = [tuple(Q(i == j) for i in range(n)) for j in range(n)]
    values += [
        tuple(Q(1) for _ in range(n)),
        tuple(Q((-1) ** i * (i + 1)) for i in range(n)),
    ]
    if n == 2:
        values.append((Q(1), Q(-1)))
    return values


def geometry_certificate(config: Configuration):
    polygons, masses, _ = cells(config, config.intercepts)
    assert all(m > 0 for m in masses), "The configuration is not admissible."
    n = len(masses)
    g, b = face_operators(config, polygons)
    G = laplacian(g)
    B = [laplacian([[b[i][j][k] for j in range(n)] for i in range(n)]) for k in range(2)]
    M = sp.diag(*(1 / m for m in masses))
    R2 = Q(1) + config.halfheight ** 2
    defect = R2 * G.T * M * G - sum((A.T * M * A for A in B), sp.zeros(n))
    assert defect == defect.T
    minors = []
    for size in range(1, n + 1):
        for indices in itertools.combinations(range(n), size):
            determinant = defect.extract(indices, indices).det()
            assert determinant >= 0, "The all-direction derivative bound failed."
            minors.append({"indices": list(indices), "determinant": qtext(determinant)})

    records = []
    step = config.epsilon ** 4 / 10**6
    for q in directions(n):
        dm = [sum(g[i][j] * (q[i] - q[j]) for j in range(n)) for i in range(n)]
        db = [
            tuple(sum(b[i][j][k] * (q[i] - q[j]) for j in range(n)) for k in range(2))
            for i in range(n)
        ]
        assert sum(dm) == 0 and tuple(sum(x[k] for x in db) for k in range(2)) == (0, 0)
        mass_energy = sum(dm[i] ** 2 / masses[i] for i in range(n))
        moment_energy = sum(dot(db[i], db[i]) / masses[i] for i in range(n))
        assert moment_energy <= R2 * mass_energy
        mass_slopes, moment_slopes = [], []
        secant_gap = None
        for s in (step, step / 2, step / 4):
            minus = tuple(config.intercepts[i] - s * q[i] for i in range(n))
            plus = tuple(config.intercepts[i] + s * q[i] for i in range(n))
            _, a, bm = cells(config, minus)
            _, c, bp = cells(config, plus)
            assert all(t > 0 for t in a + c), "A finite perturbation lost positive mass."
            h = [(a[i] + c[i]) / 2 for i in range(n)]
            lhs = sum(dot(sub(bm[i], bp[i]), sub(bm[i], bp[i])) / h[i] for i in range(n))
            rhs = R2 * sum((a[i] - c[i]) ** 2 / h[i] for i in range(n))
            assert lhs <= rhs, "The finite secant bound failed."
            if s == step:
                secant_gap = rhs - lhs
            mass_slopes.append([(c[i] - a[i]) / (2 * s) for i in range(n)])
            moment_slopes.append([scale(1 / (2 * s), sub(bp[i], bm[i])) for i in range(n)])
        for i in range(n):
            replay_mass = (mass_slopes[0][i] - 6 * mass_slopes[1][i] + 8 * mass_slopes[2][i]) / 3
            replay_moment = tuple(
                (moment_slopes[0][i][k] - 6 * moment_slopes[1][i][k] + 8 * moment_slopes[2][i][k]) / 3
                for k in range(2)
            )
            assert replay_mass == dm[i] and replay_moment == db[i], (
                "Exact piecewise-cubic differentiation disagrees with the face formula."
            )
        records.append({
            "q": [qtext(t) for t in q],
            "mass_derivatives": [qtext(t) for t in dm],
            "moment_derivatives": [point_text(t) for t in db],
            "mass_energy": qtext(mass_energy),
            "moment_energy": qtext(moment_energy),
            "derivative_gap": qtext(R2 * mass_energy - moment_energy),
            "finite_secant_gap": qtext(secant_gap),
            "exact_polynomial_derivative_replay": True,
        })
    separations = [
        dot(sub(config.sites[i], config.sites[j]), sub(config.sites[i], config.sites[j]))
        for i in range(n) for j in range(i)
    ]
    assert min(separations) > 0
    return {
        "name": config.name,
        "source_halfheight": qtext(config.halfheight),
        "sites": [point_text(x) for x in config.sites],
        "intercepts": [qtext(x) for x in config.intercepts],
        "radius_squared": qtext(R2),
        "masses": [qtext(x) for x in masses],
        "minimum_mass": qtext(min(masses)),
        "minimum_site_separation_squared": qtext(min(separations)),
        "all_direction_psd_principal_minors": minors,
        "step": qtext(step),
        "directions": records,
    }


def configurations():
    for e in (Q(1, 2), Q(1, 10), Q(1, 100), Q(1, 10**6)):
        for lam in (Q(1), e**3):
            t = 1 - e
            yield Configuration(
                f"sharp_box_e={e}_site_scale={lam}", e, e,
                ((-lam, Q(0)), (lam, Q(0))), (lam * t, -lam * t),
            )
    for e in (Q(1, 4), Q(1, 100), Q(1, 10**6)):
        for lam in (Q(1), e**3):
            yield Configuration(
                f"thin_middle_cell_e={e}_site_scale={lam}", e, Q(1),
                ((-lam, Q(0)), (Q(0), Q(0)), (lam, Q(0))),
                (Q(0), lam * e, Q(0)),
            )
        yield Configuration(
            f"nearly_coincident_pair_e={e}", e, Q(1),
            ((Q(-1), Q(0)), (Q(1), Q(0)), (Q(1), e)),
            (Q(0), Q(0), Q(0)),
        )
    yield Configuration(
        "four_way_tie", Q(1), Q(1),
        ((Q(-1), Q(-1)), (Q(1), Q(-1)), (Q(1), Q(1)), (Q(-1), Q(1))),
        (Q(0), Q(0), Q(0), Q(0)),
    )


def symbolic_certificate():
    a, b, R2, X2, Z2, XZ = sp.symbols("a b R2 X2 Z2 XZ")
    h = (a + b) / 2
    H2 = (X2 + 2 * XZ + Z2) / 4
    difference2 = a*a*X2 + b*b*Z2 - 2*a*b*XZ
    residual = sp.cancel(
        difference2/h + 2*a*(R2-X2) + 2*b*(R2-Z2)
        - 4*a*b/h*(R2-H2) - (a-b)**2/h*R2
    )
    assert residual == 0
    u, v = sp.symbols("u v", positive=True)
    coefficient_gap = sp.factor(u*v - u*u*v*v/((u*u+v*v)/2))
    expected_gap = u*v*(u-v)**2/(u*u+v*v)
    assert sp.cancel(coefficient_gap - expected_gap) == 0
    e = sp.symbols("epsilon", positive=True)
    d = sp.symbols("d", integer=True, positive=True)
    ratio = (1-e)**2/(1+(d-1)*e**2)
    assert sp.limit(ratio, e, 0, dir="+") == 1
    assert sp.cancel(1-ratio-(2*e+(d-2)*e**2)/(1+(d-1)*e**2)) == 0
    return {
        "quadratic_identity_residual": str(residual),
        "identity_variables": ["a", "b", "R2", "E|X|^2", "E|Z|^2", "E<X,Z>"],
        "positive_geometric_mean_parameterization": "a=u^2, b=v^2, gamma=u*v, u>0, v>0",
        "gamma_minus_ab_over_h": str(coefficient_gap),
        "sharpness_ratio": "(1-epsilon)^2/(1+(d-1)*epsilon^2)",
        "one_minus_ratio": "(2*epsilon+(d-2)*epsilon^2)/(1+(d-1)*epsilon^2)",
        "sharpness_limit": "1",
        "sharpness_sequence_d2": [
            {"epsilon": qtext(q), "ratio": qtext((1-q)**2/(1+q*q))}
            for q in (Q(1, 10), Q(1, 100), Q(1, 10**4), Q(1, 10**6))
        ],
    }


def jacobian_certificate():
    payload = json.loads((ROOT / "jacobian_volume_payload.json").read_text())
    result = json.loads((ROOT / "jacobian_volume_result.json").read_text())
    receipt = json.loads((ROOT / "jacobian_execution.json").read_text())
    assert result["tool"] == "math.run"
    assert result["request"]["operation_id"] == "polytope.volume.compute"
    assert result["request"]["payload"] == payload
    assert receipt["adapter_exit_code"] == 0 and not receipt["timeout"]
    assert receipt["error"] is None
    output = result["result"]["output"]
    assert output["dimension"] == 2 and output["representation"] == "halfspaces"
    volume = Q(int(output["volume"]["num"]), int(output["volume"]["den"]))
    assert volume == Q(199, 5000)
    return {
        "operation_id": result["request"]["operation_id"],
        "server_version": result["server"]["version"],
        "protocol_version": result["protocol_version"],
        "transport": result["transport"],
        "adapter_exit_code": receipt["adapter_exit_code"],
        "timeout": receipt["timeout"],
        "error": receipt["error"],
        "exact_volume": qtext(volume),
        "meaning": "One admissible sharpness-cell volume only; not evidence for the universal inequality.",
    }


def lean_certificate():
    result = json.loads((ROOT / "lean_check.json").read_text())
    assert result["status"] == "success" and result["exit_code"] == 0
    assert result["proof_holes"] == [] and result["audit_exit_code"] == 0
    version = result["tools"]["lean"]["version"]
    assert "version 4.31.0," in version
    assert hashlib.sha256((ROOT / "Main.lean").read_bytes()).hexdigest() == result["source_sha256"]
    fidelity = (ROOT / "statement_fidelity.md").read_text(encoding="utf-8")
    assert hashlib.sha256(fidelity.encode()).hexdigest() == result["statement_fidelity_sha256"]
    ledger = json.loads((ROOT.parent / "MATH_STATE.json").read_text())
    current = max(
        (claim for claim in ledger["claims"] if claim["claim_id"] == "C374_CORE"),
        key=lambda claim: claim["version"],
    )
    assert current["formal_statement"].strip() == (ROOT / "Main.lean").read_text().strip()
    matching = []
    for path in sorted((ROOT / "certificates").glob("C374_CORE-*.json")):
        archive = json.loads(path.read_text())
        if (
            archive["subject"]["subject_id"] == "C374_CORE"
            and archive["subject"]["content_hash"] == current["content_hash"]
            and archive["tier"] == "mechanical" and archive["verdict"] == "supports"
            and archive["lean_check"]["source_sha256"] == result["source_sha256"]
            and archive["lean_check"]["statement_fidelity_sha256"] == result["statement_fidelity_sha256"]
        ):
            assert archive["lean_source"]["text"] == (ROOT / "Main.lean").read_text()
            assert archive["statement_fidelity"]["text"] == fidelity
            matching.append(path.name)
    assert len(matching) == 1, "No unique current claim-bound Lean certificate."
    return {
        "claim": "C374_CORE",
        "claim_version": current["version"],
        "certificate": f"certificates/{matching[0]}",
        "version": version,
        "exit_code": 0,
        "audit_exit_code": 0,
        "proof_holes": [],
        "source_and_fidelity_match_compiled_text": True,
        "scope": "Finite-dimensional vector energy, probability Jensen, symmetric face duality, and weighted intercept-energy transfer; analytic arguments are in the proof note.",
    }


def verify():
    cases = [geometry_certificate(config) for config in configurations()]
    return {
        "result_class": "improved_bound",
        "universal_result": "Sharp moment constant 1, finite two-intercept contraction, and finite-target potential constant 2R.",
        "claim_ids": ["C374_SECANT", "C374_DERIVATIVE", "C374_SHARPNESS", "C374_POTENTIAL", "C374_CORE"],
        "proof": "sharp_moment_theorem.md",
        "universal_proof_kind": "Analytic proof with separately Lean-verified finite-dimensional core.",
        "independent_review": "Required; this script does not supply or impersonate a Reviewer verdict.",
        "symbolic": symbolic_certificate(),
        "jacobian": jacobian_certificate(),
        "lean": lean_certificate(),
        "finite_geometry_scope": "Exact regression checks, including all-direction PSD per listed configuration; not universal verification by enumeration.",
        "geometry_configuration_count": len(cases),
        "geometry_direction_count": sum(len(case["directions"]) for case in cases),
        "geometry": cases,
    }


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--write-certificate", action="store_true")
    args = parser.parse_args()
    result = verify()
    path = ROOT / "exact_certificate.json"
    if args.write_certificate:
        path.write_text(json.dumps(result, indent=2, sort_keys=True) + "\n")
    else:
        assert json.loads(path.read_text()) == result, "The exact certificate does not replay."
    print(json.dumps({
        "verified": True,
        "result_class": result["result_class"],
        "sharp_moment_constant": 1,
        "potential_constant_multiple_of_R": 2,
        "geometry_configurations": result["geometry_configuration_count"],
        "geometry_directions": result["geometry_direction_count"],
        "lean_exit_code": result["lean"]["exit_code"],
        "proof_holes": result["lean"]["proof_holes"],
    }, sort_keys=True))


if __name__ == "__main__":
    main()
