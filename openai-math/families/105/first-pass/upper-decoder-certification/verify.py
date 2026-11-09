#!/usr/bin/env python3
"""Replay exact certificates; finite experiments are not universal proofs."""

import ast
from fractions import Fraction
import hashlib
import json
from pathlib import Path


HERE = Path(__file__).resolve().parent
ROOT = HERE.parent.parent


def require(condition, message):
    if not condition:
        raise AssertionError(message)


def poly_add(left, right, scale=1):
    result = dict(left)
    for monomial, coefficient in right.items():
        result[monomial] = result.get(monomial, Fraction(0)) + scale * coefficient
        if result[monomial] == 0:
            del result[monomial]
    return result


def poly_mul(left, right):
    result = {}
    for lm, lc in left.items():
        for rm, rc in right.items():
            monomial = tuple(sorted(lm + rm))
            result[monomial] = result.get(monomial, Fraction(0)) + lc * rc
    return {m: c for m, c in result.items() if c}


def polynomial(text):
    def visit(node):
        if isinstance(node, ast.Constant) and type(node.value) is int:
            return {(): Fraction(node.value)} if node.value else {}
        if isinstance(node, ast.Name):
            return {(node.id,): Fraction(1)}
        if isinstance(node, ast.UnaryOp) and isinstance(node.op, ast.USub):
            return {m: -c for m, c in visit(node.operand).items()}
        require(isinstance(node, ast.BinOp), "Unsupported polynomial syntax")
        left, right = visit(node.left), visit(node.right)
        if isinstance(node.op, ast.Add):
            return poly_add(left, right)
        if isinstance(node.op, ast.Sub):
            return poly_add(left, right, -1)
        if isinstance(node.op, ast.Mult):
            return poly_mul(left, right)
        require(isinstance(node.op, ast.Div), "Unsupported polynomial operation")
        require(set(right) == {()} and right[()] != 0, "Nonconstant divisor")
        return {m: c / right[()] for m, c in left.items()}

    return visit(ast.parse(text, mode="eval").body)


def check_identities(certificate):
    names = []
    for identity in certificate["polynomial_identities"]:
        require(
            polynomial(identity["lhs"]) == polynomial(identity["rhs"]),
            f"False exact polynomial identity: {identity['name']}",
        )
        names.append(identity["name"])
    require(len(names) == len(set(names)) == 6, "Missing or duplicate identity")
    require(Fraction(7, 8) ** 6 < Fraction(1, 2), "Balance minimum")
    return names


def rational(value):
    return Fraction(int(value["num"]), int(value["den"]))


def check_jacobian(certificate):
    spec = certificate["jacobian"]
    output = json.loads((HERE / spec["output"]).read_text())
    contract = json.loads((HERE / spec["contract"]).read_text())
    payload = json.loads((HERE / spec["payload"]).read_text())
    require(spec["adapter_exit_code"] == 0, "Adapter did not exit successfully")
    require(spec["adapter_error"] is None and not spec["timeout"], "Adapter failure")
    require(output["server"]["version"] == spec["server_version"], "Server version")
    require(output["protocol_version"] == spec["protocol_version"], "Protocol")
    require(output["request"]["operation_id"] == spec["operation_id"], "Operation")
    require(output["request"]["payload"] == payload, "Different Jacobian payload")
    require(
        contract["result"]["operation"]["operation_id"] == spec["operation_id"],
        "Different inspected operation",
    )
    require("output" in output["result"] and "error" not in output["result"], "No typed result")
    actual = output["result"]["output"]
    expected = {}
    mapping = {rational(e["source"]): rational(e["target"]) for e in payload["mapping"]}
    contributions = []
    for atom in payload["distribution"]["atoms"]:
        source, mass = rational(atom["value"]), rational(atom["probability"])
        target = mapping[source]
        expected[target] = expected.get(target, Fraction(0)) + mass
        contributions.append((source, target, mass))
    require(
        {rational(a["value"]): rational(a["probability"]) for a in actual["distribution"]["atoms"]}
        == expected == {Fraction(0): Fraction(1, 2), Fraction(1): Fraction(1, 2)},
        "Incorrect exact pushforward",
    )
    require(
        [(rational(c["source"]), rational(c["target"]), rational(c["probability"]))
         for c in actual["contributions"]] == contributions,
        "Incorrect contribution certificate",
    )
    return spec["operation_id"]


def sign(value):
    return 1 if value.bit_count() % 2 == 0 else -1


def walsh(values):
    values = list(values)
    stride = 1
    while stride < len(values):
        for base in range(0, len(values), 2 * stride):
            for offset in range(stride):
                a, b = values[base + offset], values[base + offset + stride]
                values[base + offset] = a + b
                values[base + offset + stride] = a - b
        stride *= 2
    return values


def evaluate_column(x, argument, w, m):
    value = 0
    for col in range(m):
        if argument >> col & 1:
            value ^= (x >> (w * col)) & ((1 << w) - 1)
    return value


def tensor_character(row_character, column_argument, w, m):
    return sum(row_character << (w * col)
               for col in range(m) if column_argument >> col & 1)


def finite_case(case):
    ell, w, m = case["ell"], case["w"], case["m"]
    r = 1
    rho = Fraction(case["rho"])
    h0 = Fraction(1, 2 ** (r * ell))
    tau = rho * h0 / 4
    lam = Fraction(0) if case["law"] == "uniform" else tau * tau / 2
    require(0 < rho <= 1 and ell - w <= r, "Wrong dimensions")
    require(Fraction(1, 2 ** (ell - r)) < rho / 8, "Row-count hypothesis")
    require(0 <= lam <= min(h0 / 2, tau * tau / 2), "Bias hypothesis")
    n = 1 << (w * m)
    denominator = n * lam.denominator
    weights = [lam.denominator - lam.numerator] * n
    weights[0] += n * lam.numerator
    require(sum(weights) == denominator, "Unnormalized finite law")
    bias = walsh(weights)
    require(all(Fraction(abs(v), denominator) <= lam for v in bias[1:]), "Nonzero bias")

    qarg, target, z = case["q_argument"], case["slice_value"], case["z"]
    offset = case["offset"]
    require(0 <= qarg < (1 << m) and 0 <= z < (1 << m), "Column argument")
    require(0 <= target < (1 << w) and 0 <= offset < (1 << ell), "Target")
    slice_points = [x for x in range(n) if evaluate_column(x, qarg, w, m) == target]
    require(bool(slice_points), "Inconsistent declared slice")
    slice_mass = sum(weights[x] for x in slice_points)
    p = Fraction(slice_mass, denominator)
    require(p >= h0 / 2, "Slice-mass lower bound")
    qbasis = [0] if qarg == 0 else [0, qarg]
    outputs = []
    for x in range(n):
        prediction = evaluate_column(x, z, w, m) ^ offset
        if case["mode"] == "exact":
            output = prediction
        elif case["mode"] == "quarter_error":
            output = prediction ^ (1 if x % 4 == 0 else 0)
        else:
            require(case["mode"] == "unrelated", "Unknown output mode")
            output = ((17 * x + 3 * x * x + 5) ^ (x >> 1)) & ((1 << ell) - 1)
        outputs.append(output)
    q = Fraction(sum(weights[x] for x in slice_points
                     if outputs[x] == (evaluate_column(x, z, w, m) ^ offset)), slice_mass)
    productive = 0
    actual_agreement = Fraction(0)
    signed_equality_sum = Fraction(0)
    max_list = 0
    for sigma in range(1 << ell):
        correlations = walsh([weights[x] * sign(sigma & outputs[x]) for x in range(n)])
        heavy = [phi for phi, value in enumerate(correlations)
                 if Fraction(abs(value), denominator) >= tau]
        max_list = max(max_list, len(heavy))
        require(len(heavy) <= 2 / (tau * tau), "Heavy-list cardinality")
        sigma_w = sigma & ((1 << w) - 1)
        base_phi = tensor_character(sigma_w, z, w, m)
        conditional = Fraction(
            sum(weights[x] * sign((sigma & outputs[x]) ^ (base_phi & x))
                for x in slice_points), slice_mass
        )
        signed_equality_sum += sign(sigma & offset) * conditional
        if sigma_w and abs(conditional) >= rho / 2:
            productive += 1
            coset = {base_phi ^ tensor_character(row, qarg, w, m)
                     for row in range(1 << w)}
            require(bool(coset.intersection(heavy)), "Affine-slice capture failed")
        # Replay the slice expansion for every target character.
        expanded = sum(
            sign(tensor_character(row, qarg, w, m) & slice_points[0]) *
            correlations[base_phi ^ tensor_character(row, qarg, w, m)]
            for row in (range(1 << w) if qarg else [0])
        )
        require(
            Fraction(expanded, (1 << w) if qarg else 1) == conditional * slice_mass,
            "Affine-slice character expansion",
        )
        if not sigma_w or not heavy:
            continue
        h_sigma = sigma_w & -sigma_w
        good_choices = 0
        for phi in heavy:
            z_right = sum(
                ((sign(((phi >> (w * col)) & ((1 << w) - 1)) & h_sigma) == -1) << col)
                for col in range(m)
            )
            if z_right in {z ^ column for column in qbasis}:
                good_choices += 1
        actual_agreement += Fraction(good_choices, (1 << ell) * len(heavy) * len(qbasis))
    require(signed_equality_sum / (1 << ell) == q, "Vector equality Fourier identity")
    fraction_productive = Fraction(productive, 1 << ell)
    require(fraction_productive >= p * (q - rho), "Positive excess was not preserved")
    hit = tau * tau / 2 * Fraction(1, 1 << r)
    require(actual_agreement >= fraction_productive * hit, "Decoder contraction/hit bound")
    require(actual_agreement >= p * (q - rho) * hit, "Improved decoder postcondition")
    return {
        "ell": ell, "hidden_dimension": w * m, "slice_probability": str(p),
        "prediction_probability": str(q), "productive_fraction": str(fraction_productive),
        "actual_functional_agreement": str(actual_agreement), "max_list_size": max_list,
    }


def check_lean(certificate):
    result = json.loads((HERE / "lean_check.json").read_text())
    source = (HERE / certificate["formal_source"]).read_bytes()
    fidelity = (HERE / certificate["statement_fidelity"]).read_text()
    require(result["status"] == "success" and result["exit_code"] == 0, "Lean did not compile")
    require(result["proof_holes"] == [], "Lean proof holes")
    require("4.31.0" in result["tools"]["lean"]["version"], "Wrong Lean version")
    require(result["source_sha256"] == hashlib.sha256(source).hexdigest(), "Stale Lean source")
    require(
        result["statement_fidelity_sha256"] == hashlib.sha256(fidelity.encode()).hexdigest(),
        "Stale fidelity document",
    )
    ledger = json.loads((ROOT / "research/MATH_STATE.json").read_text())
    claims = [c for c in ledger["claims"] if c["claim_id"] == certificate["formal_core_claim"]]
    require(bool(claims), "Formal claim missing from ledger")
    claim = max(claims, key=lambda c: c["version"])
    require(claim["formal_statement"] == source.decode(), "Ledger has different formal source")
    evidence = [
        e for e in ledger["evidence"]
        if e["subject"]["subject_id"] == certificate["formal_core_claim"]
        and e["subject"]["content_hash"] == claim["content_hash"]
        and e["tier"] == "mechanical" and e["verdict"] == "supports"
    ]
    require(bool(evidence), "No actual mechanical supporting record")
    for entry in evidence:
        archived = json.loads((ROOT / entry["artifact"]).read_text())
        require(archived["lean_source"]["text"] == source.decode(), "Different archived source")
        require(archived["statement_fidelity"]["text"] == fidelity, "Different archived fidelity")
        require(archived["lean_check"] == result, "Different archived compiler run")
    return {"claim": certificate["formal_core_claim"], "exit_code": 0, "proof_holes": []}


def main():
    certificate = json.loads((HERE / "exact_certificate.json").read_text())
    require(certificate["claim"] == "U105_GAIN", "Wrong target claim")
    require(certificate["new_bound"] == "b * tau^2 / 2 * 2^(-r)", "Wrong postcondition")
    require(certificate["improvement_factor"] == "2^ell", "Wrong improvement")
    results = {
        "universal_polynomial_identities": check_identities(certificate),
        "jacobian_operation": check_jacobian(certificate),
        "finite_experiments_not_a_proof": [finite_case(c) for c in certificate["finite_replay"]["cases"]],
        "lean_core": check_lean(certificate),
        "independent_review": certificate["independent_review"],
    }
    print(json.dumps(results, indent=2))


if __name__ == "__main__":
    main()
