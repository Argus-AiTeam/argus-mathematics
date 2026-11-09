#!/usr/bin/env python3
"""Replay the universal Lean proof and supplementary exact field calculations."""

import argparse
import hashlib
import json
from pathlib import Path
import re
import subprocess

from sympy.polys.domains import GF


HERE = Path(__file__).resolve().parent


def require(condition, message):
    if not condition:
        raise AssertionError(message)


class ExponentOneField:
    """Coordinates in GF(p)(a,b)[x,y]/(x^p-a,y^p-b)."""

    def __init__(self, p):
        self.p = p
        self.k = GF(p).frac_field("a", "b")
        self.a, self.b = self.k.gens
        self.zero = (self.k.zero,) * (p * p)
        self.one = self.scalar(self.k.one)
        self.x = self.monomial(1, 0)
        self.y = self.monomial(0, 1)

    def scalar(self, c):
        return (self.k.convert(c),) + self.zero[1:]

    def monomial(self, i, j):
        result = list(self.zero)
        result[(i % self.p) * self.p + j % self.p] = (
            self.a ** (i // self.p) * self.b ** (j // self.p)
        )
        return tuple(result)

    def add(self, u, v):
        return tuple(a + b for a, b in zip(u, v))

    def scale(self, u, c):
        return tuple(c * a for a in u)

    def sub(self, u, v):
        return self.add(u, self.scale(v, -self.k.one))

    def mul(self, u, v):
        p = self.p
        result = list(self.zero)
        left = [(i // p, i % p, c) for i, c in enumerate(u) if c]
        right = [(i // p, i % p, c) for i, c in enumerate(v) if c]
        for i, j, c in left:
            for r, s, d in right:
                index = ((i + r) % p) * p + (j + s) % p
                result[index] += (
                    c * d * self.a ** ((i + r) // p) * self.b ** ((j + s) // p)
                )
        return tuple(result)

    def power(self, u, n):
        require(n >= 0, "negative power")
        result = self.one
        while n:
            if n % 2:
                result = self.mul(result, u)
            u = self.mul(u, u)
            n //= 2
        return result

    def inv(self, u):
        require(u != self.zero, "division by zero")
        p = self.p
        up = sum(
            (c ** p * self.a ** (i // p) * self.b ** (i % p)
             for i, c in enumerate(u) if c),
            self.k.zero,
        )
        require(up != 0, "nonzero element has zero p-th power")
        result = self.scale(self.power(u, p - 1), self.k.one / up)
        require(self.mul(u, result) == self.one, "inverse replay")
        return result

    def div(self, u, v):
        return self.mul(u, self.inv(v))

    def deriv(self, u, axis):
        p = self.p
        return tuple(self.k.convert(i // p if axis == 0 else i % p) * c
                     for i, c in enumerate(u))

    def affine_exponents(self, u, axis):
        result = []
        for r in range(1, self.p):
            v = self.power(u, r)
            index = r * self.p if axis == 0 else r
            if all(c == 0 for i, c in enumerate(v) if i not in (0, index)):
                require(v[0] != 0 and v[index] != 0, "affine coefficient vanished")
                result.append(r)
        return result

    def rank(self, columns):
        matrix = [list(row) for row in zip(*columns)]
        pivot_row = 0
        for col in range(len(columns)):
            pivot = next((r for r in range(pivot_row, len(matrix))
                          if matrix[r][col] != 0), None)
            if pivot is None:
                continue
            matrix[pivot_row], matrix[pivot] = matrix[pivot], matrix[pivot_row]
            scale = self.k.one / matrix[pivot_row][col]
            matrix[pivot_row] = [c * scale for c in matrix[pivot_row]]
            for r in range(pivot_row + 1, len(matrix)):
                factor = matrix[r][col]
                if factor:
                    matrix[r] = [a - factor * b
                                 for a, b in zip(matrix[r], matrix[pivot_row])]
            pivot_row += 1
        return pivot_row


def exact_field_checks():
    cases = []
    product_checks = 0
    for p in (2, 3, 5, 7):
        f = ExponentOneField(p)
        basis = [f.monomial(i, j) for i in range(p) for j in range(p)]
        require(f.power(f.x, p) == f.scalar(f.a), "x^p=a")
        require(f.power(f.y, p) == f.scalar(f.b), "y^p=b")
        for u in basis:
            require(f.deriv(f.deriv(u, 0), 1) == f.deriv(f.deriv(u, 1), 0),
                    "commuting Euler operators")
            for v in basis:
                for axis in (0, 1):
                    require(
                        f.deriv(f.mul(u, v), axis)
                        == f.add(f.mul(f.deriv(u, axis), v),
                                 f.mul(u, f.deriv(v, axis))),
                        "Euler product rule",
                    )
                    product_checks += 1
        for n in range(1, p):
            e = pow(n, -1, p)
            k = (n * e - 1) // p
            u = f.power(f.add(f.one, f.power(f.x, n)), e)
            v = f.power(f.add(f.one, f.power(f.y, n)), e)
            z = f.power(f.sub(f.power(f.x, n), f.power(f.y, n)), e)
            require(u != f.zero and v != f.zero and z != f.zero, "nonzero inputs")
            require(sum(c != 0 for c in u) > 1, "U is nonmonomial")
            require(sum(c != 0 for c in v) > 1, "V is nonmonomial")
            require(all(c == 0 for i, c in enumerate(u) if i % p), "U in C(X)")
            require(all(c == 0 for i, c in enumerate(v) if i // p), "V in C(Y)")
            ratio_xy = f.div(f.y, f.x)
            ratio_uv = f.div(v, u)
            ku = (f.k.one + f.a ** n) ** k
            kv = (f.k.one + f.b ** n) ** k
            s = f.scale(f.power(f.sub(f.one, f.power(ratio_xy, n)), e), f.a ** k)
            up = f.power(u, p)
            require(all(c == 0 for c in up[1:]), "U^p in C")
            t = f.scale(
                f.power(f.sub(f.scalar(f.k.one / ku),
                              f.scale(f.power(ratio_uv, n), f.k.one / kv)), e),
                up[0] ** k,
            )
            require(s != f.zero and t != f.zero, "nonzero witness factors")
            require(z == f.mul(f.x, s) == f.mul(u, t), "both exact witness equations")
            du, dv = f.deriv(u, 0), f.deriv(v, 1)
            ax = f.sub(f.div(u, du), f.one)
            ay = f.sub(f.div(v, dv), f.one)
            m = p - n
            require(f.deriv(ax, 0) == f.scale(ax, f.k.convert(m)), "X weight")
            require(f.deriv(ay, 1) == f.scale(ay, f.k.convert(m)), "Y weight")
            require(f.affine_exponents(u, 0) == [n], "uniqueness from U")
            require(f.affine_exponents(v, 1) == [n], "uniqueness from V")
            cases.append({"p": p, "n": n, "forced_weight": m,
                          "witness": "(x^n-y^n)^inverse_mod_p(n)"})
    f = ExponentOneField(3)
    u = f.add(f.add(f.one, f.x), f.power(f.x, 2))
    v = f.add(f.one, f.y)
    require(f.affine_exponents(u, 0) == [], "non-affine adversarial U")
    xy = f.div(f.y, f.x)
    vu = f.div(v, u)
    left = [f.mul(f.x, f.power(xy, i)) for i in range(3)]
    right = [f.scale(f.mul(u, f.power(vu, i)), -f.k.one) for i in range(3)]
    require(f.rank(left + right) == 6, "exact no-witness negative control")
    return {
        "classification": "supplementary_exact_experiments_not_a_universal_proof",
        "coefficient_field": "GF(p)(a,b), with a,b algebraically independent",
        "ambient_field": "C[x,y]/(x^p-a,y^p-b)",
        "primes": [2, 3, 5, 7],
        "basis_product_rule_checks": product_checks,
        "witness_cases": cases,
        "negative_control": {
            "p": 3, "U": "1+x+x^2", "V": "1+y",
            "intersection_matrix_rank": 6, "intersection_dimension": 0,
            "scope": "one exact pair, not a universal exclusion",
        },
    }


def jacobian_check():
    payload = json.loads((HERE / "jacobian-input.json").read_text())
    response = json.loads((HERE / "jacobian-output.json").read_text())
    op = "prime_field.matrix.nullspace.compute"
    require(response["request"]["operation_id"] == op, "Jacobian operation id")
    require(response["request"]["payload"] == payload, "Jacobian exact payload")
    output = response["result"]["output"]
    require(output["source"] == payload, "Jacobian typed source")
    require(output["nullity"] == 2, "characteristic-two Euler kernel dimension")
    require(output["nullspace_matrix"]["entries"] == [[1, 0, 0, 0], [0, 0, 0, 1]],
            "characteristic-two Euler kernel basis")
    return {
        "operation_id": op,
        "server_version": response["server"]["version"],
        "protocol_version": response["protocol_version"],
        "adapter_exit_code": 0,
        "adapter_error": None,
        "timeout": False,
        "interpretation": "bounded supplementary check of D_X+D_Y, not a proof",
        "payload_file": "jacobian-input.json",
        "typed_output_file": "jacobian-output.json",
    }


def lean_check():
    official = json.loads((HERE / "lean_check.json").read_text())
    source = HERE / "Main.lean"
    fidelity = Path(official["statement_fidelity"])
    require(official["status"] == "success" and official["exit_code"] == 0,
            "official compiler verdict")
    require(official["proof_holes"] == [], "official proof holes")
    require(hashlib.sha256(source.read_bytes()).hexdigest() == official["source_sha256"],
            "official result is stale for Main.lean")
    require(hashlib.sha256(fidelity.read_text().encode()).hexdigest()
            == official["statement_fidelity_sha256"], "official fidelity is stale")
    require(fidelity.read_text() == (HERE / "statement-fidelity.md").read_text(),
            "source-facing and canonical fidelity differ")
    workspace = Path(official["lake_workspace"])
    version = subprocess.run(["lake", "env", "lean", "--version"], cwd=workspace,
                             text=True, capture_output=True, check=True, timeout=30)
    require("version 4.31.0," in version.stdout, "Lean 4.31.0 is required")
    replay = subprocess.run(["lake", "env", "lean", str(source)], cwd=workspace,
                            text=True, capture_output=True, check=True, timeout=110)
    match = re.search(
        r"'CharPIntersection\.prop_intersection' depends on axioms: \[([^\]]*)\]",
        replay.stdout,
    )
    require(match is not None, "source-facing theorem axiom report missing")
    axioms = sorted(a.strip() for a in match.group(1).split(","))
    require(axioms == ["Classical.choice", "Quot.sound", "propext"],
            "unexpected theorem axiom dependency")
    return {
        "theorem": "CharPIntersection.prop_intersection",
        "generalization": "CharPIntersection.intersection_exponent",
        "lean_version": "4.31.0",
        "compiler_exit_code": replay.returncode,
        "proof_holes": official["proof_holes"],
        "axioms": axioms,
        "source_sha256": official["source_sha256"],
        "statement_fidelity_sha256": official["statement_fidelity_sha256"],
        "official_result": "lean_check.json",
    }


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--write-certificate", action="store_true")
    args = parser.parse_args()
    result = {
        "claim_id": "V_CHARP_INTERSECTION",
        "result_class": "formal_verification",
        "scope": "complete universal Proposition prop:intersection",
        "independent_review": "pending_host_reviewer",
        "novelty_status": "not_claimed",
        "campaign_complete": False,
        "lean": lean_check(),
        "exact_experiments": exact_field_checks(),
        "jacobian": jacobian_check(),
    }
    certificate = HERE / "exact_certificate.json"
    if args.write_certificate:
        certificate.write_text(json.dumps(result, indent=2, sort_keys=True) + "\n")
    else:
        require(json.loads(certificate.read_text()) == result, "certificate replay mismatch")
    print(json.dumps({"ok": True, "claim": result["claim_id"],
                      "universal_lean_theorem": result["lean"]["theorem"],
                      "witness_cases": len(result["exact_experiments"]["witness_cases"]),
                      "independent_review": result["independent_review"]}, sort_keys=True))


if __name__ == "__main__":
    main()
