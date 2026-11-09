import copy
import unittest
from unittest.mock import patch

import verify


class ExactIdentityTests(unittest.TestCase):
    def test_noncommutativity_is_preserved(self):
        self.assertNotEqual(verify.polynomial("c*s"), verify.polynomial("s*c"))
        self.assertEqual(verify.polynomial("c*x*X*s"), verify.polynomial("c*s"))

    def test_all_universal_identities(self):
        certificate = verify.read_json(verify.ROOT / "exact_certificate.json")
        self.assertEqual(verify.check_identities(certificate), 10)

    def test_wrong_root_frame_order_is_rejected(self):
        correct = verify.polynomial("(-c*x)*X*s+c*s+e")
        wrong = verify.polynomial("(-c*x)*s*X+c*s+e")
        self.assertEqual(correct, verify.polynomial("e"))
        self.assertNotEqual(wrong, verify.polynomial("e"))

    def test_tampered_identity_is_rejected(self):
        certificate = copy.deepcopy(
            verify.read_json(verify.ROOT / "exact_certificate.json")
        )
        certificate["symbolic_identities"][1]["lhs"] = "0"
        with self.assertRaisesRegex(ValueError, "required Fox identities"):
            verify.check_identities(certificate)

    def test_non_algebra_input_is_rejected(self):
        with self.assertRaises(ValueError):
            verify.polynomial("f(c)")

    def test_invalid_kernel_records_are_rejected(self):
        certificate = verify.read_json(verify.ROOT / "exact_certificate.json")
        archive_path = verify.ROOT / certificate["lean_archive"]
        original_read = verify.read_json
        original_archive = original_read(archive_path)
        for field, value, message in [
            ("status", "type_error", "did not succeed"),
            ("proof_holes", ["sorry"], "contains holes"),
            ("source_sha256", "stale", "source changed"),
        ]:
            archive = copy.deepcopy(original_archive)
            archive["lean_check"][field] = value
            with self.subTest(field=field):
                with patch.object(
                    verify, "read_json",
                    side_effect=lambda path: archive if path == archive_path else original_read(path),
                ):
                    with self.assertRaisesRegex(ValueError, message):
                        verify.check_lean(certificate, False)

    def test_substituted_target_is_rejected(self):
        certificate_path = verify.ROOT / "exact_certificate.json"
        original_read = verify.read_json
        certificate = copy.deepcopy(original_read(certificate_path))
        certificate["statement"] = "Only a finite collection of example rows is injective."
        with patch.object(
            verify, "read_json",
            side_effect=lambda path: certificate if path == certificate_path else original_read(path),
        ):
            with self.assertRaisesRegex(ValueError, "different mathematical statement"):
                verify.verify()


if __name__ == "__main__":
    unittest.main()
