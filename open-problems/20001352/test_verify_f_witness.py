import copy
from fractions import Fraction
import json
import unittest

from verify_f_witness import ROOT, certify, verify_jacobian, verify_membership


class ExactCertificateTests(unittest.TestCase):
    def setUp(self):
        self.witness = json.loads((ROOT / "evidence/f_witness.json").read_text())

    def test_both_routes_and_complete_inverse(self):
        for route in ("involutions", "commutators"):
            with self.subTest(route=route):
                pieces, report = certify(self.witness, route)
                self.assertEqual(len(pieces), 3)
                self.assertEqual(report["endpoint_character"], [-1, 1])
                self.assertEqual(report["nonidentity"], {"point": "1/2", "image": "1/4"})
                self.assertEqual(
                    report["inverse_intervals"],
                    [
                        {"left": "0", "right": "1/4", "slope": "2", "intercept": "0"},
                        {"left": "1/4", "right": "1/2", "slope": "1", "intercept": "1/4"},
                        {"left": "1/2", "right": "1", "slope": "1/2", "intercept": "1/2"},
                    ],
                )

    def test_invalid_complete_subdivisions_are_rejected(self):
        mutations = [
            (0, "left", "1/8"),
            (1, "left", "5/8"),
            (1, "left", "3/8"),
            (1, "right", "1/2"),
            (1, "intercept", "0"),
            (0, "slope", "-1/2"),
            (1, "slope", "3"),
            (1, "left", "1/3"),
            (2, "intercept", "-3/4"),
            (0, "slope", 0.5),
            (0, "slope", "2/4"),
        ]
        for index, field, value in mutations:
            with self.subTest(index=index, field=field, value=value):
                witness = copy.deepcopy(self.witness)
                witness["segments"][index][field] = value
                with self.assertRaises(ValueError):
                    verify_membership(witness)

    def test_nonidentity_point_is_not_assumed(self):
        for point in ("0", "1", "2"):
            with self.subTest(point=point):
                witness = copy.deepcopy(self.witness)
                witness["nonidentity_at"] = point
                with self.assertRaises(ValueError):
                    verify_membership(witness)

    def test_zero_character_does_not_become_a_commutator_obstruction(self):
        witness = {
            "name": "interior_supported_nonidentity",
            "nonidentity_at": "1/2",
            "segments": [
                {"left": "0", "right": "1/4", "slope": "1", "intercept": "0"},
                {"left": "1/4", "right": "1/2", "slope": "1/2", "intercept": "1/8"},
                {"left": "1/2", "right": "5/8", "slope": "1", "intercept": "-1/8"},
                {"left": "5/8", "right": "3/4", "slope": "2", "intercept": "-3/4"},
                {"left": "3/4", "right": "1", "slope": "1", "intercept": "0"},
            ],
        }
        _, report = certify(witness, "involutions")
        self.assertEqual(report["endpoint_character"], [0, 0])
        self.assertEqual(report["nonidentity"]["image"], "3/8")
        with self.assertRaisesRegex(ValueError, "Zero character"):
            certify(witness, "commutators")

    def test_jacobian_is_bound_to_actual_equations_and_coefficients(self):
        folder = ROOT / "evidence/jacobian"
        payload = json.loads((folder / "affine-system.payload.json").read_text())
        result = json.loads((folder / "affine-system.result.json").read_text())
        pieces, _ = verify_membership(self.witness)
        report = verify_jacobian(pieces, payload, result)
        self.assertEqual(Fraction(report["block_diagonal_determinant"]), Fraction(-1, 32))
        self.assertEqual(report["exact_residuals"], ["0"] * 6)
        for field, value in (
            ("outcome", "NON_UNIQUE"),
            ("solution", [{"num": "0", "den": "1"}] * 6),
            ("rhs", [{"num": "0", "den": "1"}] * 6),
        ):
            with self.subTest(field=field):
                wrong = copy.deepcopy(result)
                wrong["output"][field] = value
                with self.assertRaises(ValueError):
                    verify_jacobian(pieces, payload, wrong)
        wrong_payload = copy.deepcopy(payload)
        wrong_payload["rhs"][0] = {"num": "1", "den": "1"}
        with self.assertRaises(ValueError):
            verify_jacobian(pieces, wrong_payload, result)


if __name__ == "__main__":
    unittest.main()
