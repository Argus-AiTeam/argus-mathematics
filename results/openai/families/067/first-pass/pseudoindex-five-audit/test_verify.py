#!/usr/bin/env python3
"""Adversarial checks on the delivered certificate checker."""

import json
import subprocess
import sys
import traceback
import unittest
from fractions import Fraction

import verify


class CertificateChecks(unittest.TestCase):
    def test_corrupted_rational_annihilator_is_rejected(self):
        certificate = json.loads(
            (verify.ROOT / "exact_certificate.json").read_text(encoding="ascii")
        )
        entry = certificate["N"][0][0]
        entry[1] = str(Fraction(entry[1]) + 1)
        try:
            verify.verify(certificate)
        except AssertionError as error:
            location = traceback.extract_tb(error.__traceback__)[-1]
            self.assertEqual(location.name, "verify_rank_certificate")
            self.assertIn("N*P", location.line)
        else:
            self.fail("A corrupted rational annihilator was accepted.")

    def test_disabled_assertions_are_rejected(self):
        result = subprocess.run(
            [sys.executable, "-O", str(verify.ROOT / "verify.py")],
            capture_output=True, text=True, check=False,
        )
        self.assertNotEqual(result.returncode, 0)
        self.assertIn("Assertions must be enabled", result.stderr)


if __name__ == "__main__":
    unittest.main()
