# Primary-source alignment: AIMPL 1.35 / AIM Problem 15

The source-research worker retrieved the original AIM PDF and compared the
AIMPL page, including its raw HTML, on 2026-09-05. This note records its
source-level findings; it is not a mathematical negative witness.

## Original assertion

Both sources ask:

> Is the Groebner fan a discrete invariant that distinguishes the components
> of Hilb^d(A^n)?

- Original AIM workshop problem list, *Components of Hilbert Schemes*,
  printed page 2, Problem 15:
  <https://aimath.org/WWN/hilbertschemes/hilbertschemes.pdf>.
- AIMPL, section 1, Problem 1.35:
  <http://aimpl.org/hilbertschemes/1/>.

The original PDF's page 1 notation and the AIMPL introduction specify that
components are irreducible components. Neither question specifies the field,
characteristic, weight domain, geometric versus labelled fan equality, or
fixed versus generic coordinates. Neither explicitly says that the fan must
be constant at every point of a component. Neither explicitly quantifies
pointwise or generic separation. The separate preceding Problem 14 in the
PDF mentions generic points; those words are not part of Problem 15.

A same-component fan jump therefore does not, on the strength of these
sources, certify failure to distinguish components. Exceptional points in
component intersections also do not certify pointwise separation failure
under the campaign's no-common-component criterion.

## Misattributed dissertation lead

The tentative remark about Richard Liebling's thesis occurs under the
original Problem 16 and AIMPL Problem 1.7, not Problem 15 / 1.35. That
question concerns whether the set of monomial ideals in a component
determines the component. The remark concerns the analogous question for
curves and does not assert a counterexample to the Groebner-fan question.

The dissertation is Richard Lyle Liebling, *Classification of Space Curves
using Initial Ideals*, UC Berkeley, 1996. Berkeley's institutional metadata
has the title variant "Initial Ideas":
<https://math.berkeley.edu/publications/classification-space-curves-using-initial-ideas>.

Scott Nollet, *The Hilbert schemes of degree three curves*, printed page 384,
reference [8], identifies the thesis with "Initial Ideals":
<https://www.numdam.org/item/10.1016/s0012-9593(97)89925-9.pdf>.
Nollet's Remark 3.12 on page 383 cites Liebling's Corollary 4.1.5 about a
deformation of curves with a line-annihilated Rao module. That is not the
counterexample proposition sought here. It is not used as a mathematical
assumption in this campaign.

## Explicit limitations

The thesis itself was not obtained. The alleged curve counterexample has
not been verified, and no polynomial data for a negative witness to
Problem 1.35 were located by this source lookup. The initial AIMPL HTTPS
fetch failed at transport level; the research worker obtained the HTTP
page. Its original-PDF retrieval succeeded after a default-client 403.

The retrieved question does not resolve the formulation ambiguity. No
stronger componentwise-constancy claim is adopted by default, and no
generic conclusion will be inferred from isolated ideals. Any subsequent
candidate must explicitly state which formulation it meets. This source
correction is a prerequisite, not completion of the campaign.

## Subsequent construction and conventional definition

The later candidate `../candidates/binomial_collision.md` supplies a
pointwise geometric-fan collision using a standard convention independently
documented in Fukuda, Jensen, and Thomas, *Computing Groebner fans*,
arXiv:math/0509544v1, Section 2, relation (1) and Definition 2.8. The retained
PDF is `computing_groebner_fans.pdf`. Its definition treats the fan as a
collection of polyhedral cones; the candidate has the same full collection
under that definition, not just the same sampled term orders.

This additional source settles what the chosen standard definition means.
It does not settle whether the terse AIM question intended only generic
separation. No claim that the question is still open in the literature,
or that the new pairing is original, follows from the bounded lookup.

## Stronger generic-component route

The subsequent length-4803 construction in
`../candidates/generic_collision/fake_plane_generic_witness.md`
satisfies `ctx-generic-components`: distinct entire components of
Hilb^4803(A^20_C), simultaneous nonempty dense opens excluding
every other component, and one complete fixed-coordinate unlabelled
FJT fan throughout both opens. Taking any point of each open also
gives pointwise separation failure. Thus the generic-versus-pointwise
distinction is not an additional premise for this route.

The fan convention is fixed explicitly, not inferred from the
authors' unstated intention. Definition 2.8 and the full-cone
criterion are included in the independently read passage
`../literature/b614539191392da4e0cfad04c6f44f8b.json`.
The retained independent final certification
`roles/reviewer/progress.json:current_mission_certification_review`
accepts this exact formulation as the campaign's requested negative
witness. Historical C6 remains unresolved, and no equality of
initial-ideal labels or novelty is asserted.

The proof graph's `goal` transcribes the unchanged Manager-owned
`math_goal` from `.argus/PIPELINE_STATE.json`; its goal node links
that request to this C8 witness and the retained statement-fidelity
disposition. Neither the persisted objective nor C6 is rewritten
to obtain that connection.
