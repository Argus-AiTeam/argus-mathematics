"""Replay only the old checker's pure algebra routines, without its write paths."""

import json
from pathlib import Path
import runpy


OLD = Path("campaigns/9000008")
CHECKER = OLD / "research/upper_bound_certificate/verify.py"


def main():
    namespace = runpy.run_path(str(CHECKER), run_name="old_draft_read_only")
    boundary = namespace["exact_boundary_checks"]()
    actions = namespace["source_action_checks"]()
    matrix = boundary["jacobian_payload"]["matrix"]["entries"]
    minor = (matrix[0][0] * matrix[1][1] - matrix[0][1] * matrix[1][0]) % 2
    if minor != 1:
        raise AssertionError("The boundary vectors are not independent over F2")
    print(json.dumps({
        "checker": str(CHECKER),
        "entry_points": ["exact_boundary_checks", "source_action_checks"],
        "historical_write_entry_points_called": [],
        "low_weights_and_boundary": boundary,
        "source_actions": actions,
        "boundary_minor_mod_2": minor,
        "scope": "Exact algebraic replay, not a Lean run or proof of the surrounding manuscript lemmas.",
    }, indent=2))


if __name__ == "__main__":
    main()
