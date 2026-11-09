import copy
from fractions import Fraction
import unittest
from unittest.mock import patch

import verify


class ExactCertificateTests(unittest.TestCase):
    def test_exact_polynomial_arithmetic(self):
        x = verify.monomial((1,))
        one = verify.monomial((0,))
        product = verify.multiply(verify.add(x, one), verify.add(x, verify.scale(one, -1)))
        self.assertEqual(product, verify.add(verify.monomial((2,)), verify.monomial((0,), -1)))
        self.assertEqual(verify.derivative(product, 0), verify.monomial((1,), 2))
        self.assertEqual(verify.scale(verify.monomial((1,), Fraction(3, 5)), 5),
                         verify.monomial((1,), 3))

    def test_noncanonical_rational_rejected(self):
        data = {"domain": "QQ", "variables": ["x"],
                "polynomial": {"terms": [
                    {"exponents": [1], "coefficient": {"num": "2", "den": "4"}}]}}
        with self.assertRaisesRegex(ValueError, "not canonical"):
            verify.read_polynomial(data, ["x"])

    def test_stale_source_and_fidelity_rejected(self):
        record = verify.load_json(verify.HERE / "lean_check.json")
        source = (verify.HERE / "Main.lean").read_bytes()
        fidelity = (verify.HERE / "statement_fidelity.md").read_bytes()
        with self.assertRaisesRegex(ValueError, "stale for Main.lean"):
            verify.check_native_result(record, source + b"\n", fidelity)
        with self.assertRaisesRegex(ValueError, "stale for statement fidelity"):
            verify.check_native_result(record, source, fidelity + b"\n")
        failed = copy.deepcopy(record)
        failed["status"] = "timeout"
        with self.assertRaisesRegex(ValueError, "did not successfully compile"):
            verify.check_native_result(failed, source, fidelity)

    def test_jacobian_wrong_payload_and_remainder_rejected(self):
        certificate = verify.load_json(verify.HERE / "exact_certificate.json")
        output_path = verify.HERE / certificate["jacobian"]["typed_output"]
        original_loader = verify.load_json
        response = original_loader(output_path)
        changed = copy.deepcopy(response)
        changed["request"]["payload"]["monomial_order"] = "grlex"

        def altered_loader(path):
            return changed if path == output_path else original_loader(path)

        with patch.object(verify, "load_json", altered_loader):
            with self.assertRaisesRegex(ValueError, "not for the preserved exact payload"):
                verify.verify_jacobian(certificate)
        changed = copy.deepcopy(response)
        changed["result"]["output"]["remainder"]["polynomial"]["terms"] = [
            {"coefficient": {"num": "1", "den": "1"}, "exponents": [0, 0, 0, 0]}]
        with patch.object(verify, "load_json", altered_loader):
            with self.assertRaisesRegex(ValueError, "nonzero remainder"):
                verify.verify_jacobian(certificate)


if __name__ == "__main__":
    unittest.main()
