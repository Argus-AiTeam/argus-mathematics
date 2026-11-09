"""Read-only checks of historical holds and repaired citation readiness."""

import inspect
import json
import sys
import unittest
from dataclasses import replace
from pathlib import Path
from types import SimpleNamespace
from unittest.mock import patch

from argus_skill.apps._runtime_execute import SkillLoopExecuteMixin
from argus_skill.apps._runtime_helpers import _ExecuteState
from argus_skill.life.memory import BacklogItem, EventJournal
from argus_skill.life.supervisor._planning_context import PlanningContextMixin
from argus_skill.life.supervisor._planning_cycle import PlanningCycleMixin
from argus_skill.life.supervisor._planning_cycle_helpers import (
    _research_project_done_issue,
)
from argus_skill.proof_ledger import EvidenceTier, load_state
from argus_skill.skills.stage_machine import (
    StageCompletionError,
    _ensure_stage_completion,
)
from argus_skill.verticals.math.citation_check import citation_status


PROJECT_ROOT = Path(__file__).resolve().parents[1]
STATE_ROOT = Path("$WORKSPACE/.argus-campaign-9200019/projects/208768877618")
MISSION_ID = "439076a23380"
MISSION_PATH = STATE_ROOT / "handoffs" / MISSION_ID / "mission.json"
REVIEW_PATH = MISSION_PATH.parent / "round-0001.json"
CITED_ASSUMPTIONS = {
    "ABBR-TAME-LIFT",
    "ABBR-TUBES-REDUCTION",
    "BPR-ANNULAR-FACTORIZATION",
    "MILNE-DIVISIBILITY-TORSION",
    "MT-RNS-DOMINATION",
    "TEMKIN-COMPACT-TYPE2",
}


class ReadOnlyRecovery(PlanningCycleMixin):
    _item_skips_stage_transition = staticmethod(
        PlanningContextMixin._item_skips_stage_transition
    )

    def __init__(self, item):
        self.config = SimpleNamespace(continuous=True)
        self.memory = SimpleNamespace(
            project_root=STATE_ROOT,
            backlog=SimpleNamespace(history=lambda: [item]),
        )

    def _artifact_root(self):
        return PROJECT_ROOT

    def _bound_manager(self):
        raise AssertionError("The isolated replay must not invoke a live Manager")


class ReadOnlyExtraction(SkillLoopExecuteMixin):
    manager = None
    last_thread_id = None
    _next_seed_thread_id = None

    def _consume_auth_failure(self):
        return None


class NativeReceiptRecoveryTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        status = json.loads((STATE_ROOT / "daemon.status.json").read_text())
        deployed_root = Path(status["runtime"]["source_root"]).resolve()
        operations = {
            "stage_preflight": _ensure_stage_completion,
            "citation_status": citation_status,
            "review_recovery": PlanningCycleMixin._latest_unassessed_review_for_current_stage,
            "research_completion": _research_project_done_issue,
            "outcome_extraction": SkillLoopExecuteMixin._extract_execute_outcome_fields,
            "journal_projection": EventJournal,
        }
        sources = {
            name: str(Path(inspect.getfile(operation)).resolve())
            for name, operation in operations.items()
        }
        if any(not Path(source).is_relative_to(deployed_root) for source in sources.values()):
            raise RuntimeError("Replay imported a source outside the deployed Argus root")
        cls.measurements = {
            "project_root": str(PROJECT_ROOT),
            "interpreter": sys.executable,
            "deployed_source_root": str(deployed_root),
            "loaded_sources": sources,
            "repair_applied": False,
        }
        cls.mission = json.loads(MISSION_PATH.read_text())
        cls.handoff = json.loads(REVIEW_PATH.read_text())
        with (STATE_ROOT / "events.jsonl").open() as stream:
            cls.events = {
                number: json.loads(line)
                for number, line in enumerate(stream, 1)
                if number in {471, 480}
            }
        with (STATE_ROOT / "backlog.archive.jsonl").open() as stream:
            archived = next(
                item
                for line in stream
                if (item := json.loads(line)).get("id") == MISSION_ID
            )
        cls.item = BacklogItem.from_jsonable(archived)

    @classmethod
    def tearDownClass(cls):
        print(json.dumps(cls.measurements, indent=2, sort_keys=True), flush=True)

    def test_original_acceptance_still_fails_the_research_gate(self):
        event = self.events[480]
        pipeline = json.loads((PROJECT_ROOT / ".argus/PIPELINE_STATE.json").read_text())
        self.assertEqual(self.mission["scope"], "final_submission")
        self.assertEqual(self.mission["objective"], event["objective"])
        self.assertEqual(self.item.original_objective, pipeline["math_goal"])
        self.assertEqual(self.handoff["mission_id"], MISSION_ID)
        self.assertEqual(self.handoff["mission_context"], str(MISSION_PATH))
        self.assertEqual(self.handoff["producer_role"], "reviewer")
        self.assertEqual(self.handoff["review"]["status"], "done")
        self.assertTrue(self.handoff["review"]["reason"].strip())
        self.assertFalse(event["final_submission_certified"])
        entry = EventJournal._entry_from_event(event)
        self.assertIsNotNone(entry)
        issue = _research_project_done_issue(PROJECT_ROOT, [entry])
        self.assertEqual(issue, "missing_exploratory_reviewer_certification")
        self.measurements["original_research_gate"] = issue

    def test_original_manager_hold_is_preserved_as_history(self):
        state = load_state(PROJECT_ROOT)
        historical_state = replace(
            state,
            evidence=[
                item
                for item in state.evidence
                if not (
                    item.tier == EvidenceTier.LITERATURE
                    and item.subject.subject_id in CITED_ASSUMPTIONS
                )
            ],
        )
        with patch(
            "argus_skill.proof_ledger.load_state", return_value=historical_state
        ), self.assertRaises(StageCompletionError) as raised:
            _ensure_stage_completion(PROJECT_ROOT, "review", evidence_root=PROJECT_ROOT)
        error = raised.exception
        self.assertEqual(str(error), self.events[471]["reason"])
        self.assertEqual(len(error.issues), 6)
        self.assertTrue(all("whose citation is unchecked" in issue for issue in error.issues))
        for assumption_id in CITED_ASSUMPTIONS:
            self.assertTrue(
                any(f"stands on {assumption_id} (" in issue for issue in error.issues)
            )
        self.measurements["historical_stage_preflight"] = {
            "status": "held",
            "source": "original_manager_event_471",
            "replay": "in_memory_without_citation_attributions",
            "matches_original_manager_receipt": True,
            "unchecked_citations": 6,
        }

    def test_live_citation_evidence_clears_review_preflight(self):
        status = citation_status(PROJECT_ROOT)
        self.assertTrue(status["ok"], status["blocking"])
        citations = {
            item["assumption_id"]: item for item in status["claims"]["DR019-COLLAR"]
        }
        state = json.loads((PROJECT_ROOT / "research/MATH_STATE.json").read_text())
        claim = max(
            (item for item in state["claims"] if item["claim_id"] == "DR019-COLLAR"),
            key=lambda item: item["version"],
        )
        assumptions = {
            item["assumption_id"]: item
            for item in claim["external_assumptions"]
            if item["source_id"]
        }
        self.assertEqual(set(assumptions), CITED_ASSUMPTIONS)
        for assumption_id, assumption in assumptions.items():
            with self.subTest(assumption=assumption_id):
                citation = citations[assumption_id]
                self.assertEqual(citation["status"], "confirmed")
                self.assertTrue(citation["checked_by"])
                self.assertNotIn(assumption["filed_by"], citation["checked_by"])
                self.assertTrue(citation["artifacts"])
                for artifact in citation["artifacts"]:
                    archive = json.loads((PROJECT_ROOT / artifact).read_text())
                    self.assertEqual(archive["kind"], "excerpt")
                    self.assertEqual(archive["source_id"], assumption["source_id"])
                    self.assertEqual(archive["locator"], assumption["locator"])
                    self.assertTrue(archive["text"].strip())
        self.assertEqual(citations["FOUNDATIONAL-BRIDGES"]["status"], "uncited")
        _ensure_stage_completion(PROJECT_ROOT, "review", evidence_root=PROJECT_ROOT)
        self.measurements["repair_applied"] = True
        self.measurements["repair_kind"] = "citation_attribution_only"
        self.measurements["stage_preflight"] = {
            "status": "ready",
            "issues": [],
            "citation_statuses": {
                key: value["status"] for key, value in sorted(citations.items())
            },
            "certification_scope": "preflight_only",
        }

    def test_original_terminal_hold_is_not_a_recovery_candidate(self):
        self.assertEqual(self.item.outcome["stage_certification"], "not_certified")
        action = ReadOnlyRecovery(self.item)._reconcile_reviewed_stage_empty_plan(None)
        self.assertEqual(action, "")
        self.measurements["original_recovery"] = "no_action"

    def test_counterfactual_recovery_is_not_a_safe_binding_repair(self):
        # These variants exist only in memory; no receipt or live flag is changed.
        unassessed = replace(
            self.item,
            outcome={**self.item.outcome, "stage_certification": "not_assessed"},
        )
        real_read_text = Path.read_text
        variants = (
            ("original_unassessed", {}, {}, True),
            ("bounded_only", {"scope": "bounded"}, {}, True),
            ("engineer_only", {}, {"producer_role": "engineer"}, False),
            ("mismatched_mission_id", {}, {"mission_id": "different-mission"}, False),
            (
                "mismatched_objective",
                {"objective": "Review a different operator objective."},
                {},
                True,
            ),
        )
        findings = {}
        for name, mission_changes, handoff_changes, expected_recovery in variants:
            with self.subTest(name=name):
                mission = {**self.mission, **mission_changes}
                handoff = {**self.handoff, **handoff_changes}

                def read_text(path, *args, **kwargs):
                    if path == MISSION_PATH:
                        return json.dumps(mission)
                    if path == REVIEW_PATH:
                        return json.dumps(handoff)
                    return real_read_text(path, *args, **kwargs)

                with patch.object(Path, "read_text", read_text):
                    recovered = ReadOnlyRecovery(
                        unassessed
                    )._latest_unassessed_review_for_current_stage()
                self.assertEqual(recovered is not None, expected_recovery)
                finding = {"recovered": recovered is not None}
                if recovered is not None:
                    _, review, scope = recovered
                    state = _ExecuteState()
                    state.mission_scope = scope
                    state.outcome = SimpleNamespace(
                        status="success",
                        rounds=[SimpleNamespace(review=review)],
                    )
                    ReadOnlyExtraction()._extract_execute_outcome_fields(state)
                    self.assertFalse(state.final_submission_certified)
                    finding.update(
                        scope=scope,
                        extracted_final_submission_certified=state.final_submission_certified,
                    )
                findings[name] = finding
        self.measurements["counterfactual_in_memory_only"] = findings
        self.measurements["terminal_receipt_recovery"] = (
            "unsupported: original terminal hold is excluded; recovered reviews are "
            "uncertified and the recovery loader does not reject a changed objective"
        )


if __name__ == "__main__":
    unittest.main(verbosity=2)
