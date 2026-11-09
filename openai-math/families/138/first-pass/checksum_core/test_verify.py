import copy
import itertools
import json
import unittest
from pathlib import Path

import verify


class CertificateTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.path = Path(__file__).with_name("exact_certificate.json")
        cls.original = cls.path.read_bytes()
        cls.certificate = json.loads(cls.original)
        cls.node_data = verify.verify_nodes(cls.certificate)

    @classmethod
    def tearDownClass(cls):
        if cls.path.read_bytes() != cls.original:
            raise AssertionError("verification regenerated or changed the evidence")

    def test_false_node_enclosure_is_rejected(self):
        changed = copy.deepcopy(self.certificate)
        changed["nodes"][0][0] = "0"
        with self.assertRaisesRegex(verify.CertificateError, "claimed enclosure fails"):
            verify.verify_nodes(changed)

    def test_zero_outer_error_is_rejected(self):
        changed = copy.deepcopy(self.certificate)
        changed["analytic_bounds"]["outer_quadrature_error"] = "0"
        with self.assertRaisesRegex(verify.CertificateError, "outer trapezoid error"):
            verify.verify_analysis(changed, self.node_data)

    def test_unjustified_node_multiplier_is_rejected(self):
        changed = copy.deepcopy(self.certificate)
        changed["analytic_bounds"]["node_multiplier"] = "1"
        with self.assertRaisesRegex(verify.CertificateError, "node multiplier"):
            verify.verify_analysis(changed, self.node_data)

    def test_failed_finite_inequality_is_rejected(self):
        with self.assertRaisesRegex(verify.CertificateError, "finite circles"):
            verify.verify_transfer(self.certificate, verify.Q("1.5"))

    def test_changed_source_parameters_are_rejected(self):
        changed = copy.deepcopy(self.certificate)
        changed["parameters"]["r"][0] = "0.850"
        with self.assertRaisesRegex(verify.CertificateError, "staged theorem"):
            verify.verify_nodes(changed)

    def test_missing_coverage_is_rejected(self):
        changed = copy.deepcopy(self.certificate)
        changed["kernel_fixtures"][0]["multiplicities"][0] = 0
        with self.assertRaisesRegex(verify.CertificateError, "lacks coverage"):
            verify.verify_kernel_fixtures(changed)

    def test_small_exact_match_configurations(self):
        values = list(itertools.product(("-1", "0", "1"), repeat=2))
        for multiplicities in itertools.product((1, 2, 3), repeat=2):
            for pair in itertools.product(values, repeat=2):
                for rejected in range(3):
                    fixture = {
                        "multiplicities": multiplicities,
                        "values": pair,
                        "rejected_matches": rejected,
                        "normalizer": 7,
                    }
                    verify.verify_kernel_fixtures({"kernel_fixtures": [fixture]})


if __name__ == "__main__":
    unittest.main()
