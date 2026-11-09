# Source readings and their limits

The separate source reader `reader:sources063` returned supporting readings
for the nine assumptions below, with the qualifications recorded here. That
reader did not write files or ledger entries. The Engineer archived the cited
passages and transcribed the reader's verdicts; this is not a second independent
reading or the Host's final review. The cached Behrend, Behrend--Fantechi and
Kresch texts were inspected at the listed passages; the official Stacks and
versioned Mustata--Mustata sources were opened. Excerpts normalize mathematical
notation to ASCII and separate quotations from applications.

| Current assumption | Source/version and decisive locator | Reading | Excerpt |
|---|---|---|---|
| A_STABLE_MAPS | alg-geom/9601011v1, Props. 4-5, intervening construction, Thm. 6 | supports | behrend.txt |
| A_AMBIENT_STACK | same, Prop. 4 and convex-forest case of Thm. 6 | supports; projective-space tree vanishing is an application | behrend.txt |
| A_VIRTUAL_OPEN | alg-geom/9601010v1, Props. 7.2, 7.3(1), with section 7 hypotheses | supports on the stated unobstructed open | behrend_fantechi.txt |
| A_BASE_CHANGE | Stacks 0B91, Lemma 36.30.4(1) | supports on scheme charts; proper, flat, finite presentation, perfect complex | base_change.txt |
| A_LOCALIZATION | math/9810166v1, Thm. 2.1.12(ii),(iv),(v), Prop. 2.4.1, section 4.3 | supports; integral pushforward has the narrower covariance | kresch.txt |
| A_RATIONAL_PROPER | Stacks 04UY, Vistoli paragraph | supports the cited rational formalism, not a quotation from Vistoli's original PDF | rational_chow.txt |
| A_RATIONAL_DEGREE | same | supports the formalism; stabilizer ratio remains a deduction in proof sections 5-6 | rational_chow.txt |
| A_INTERMEDIATE_ATTRIBUTION | math/0409569v4, Def. 1.2, Prop. 1.3, proof of Lemma 3.3 | supports; pointed k=1, no marked basepoints, known cotangent/weight construction | intermediate_spaces.txt |
| A_WEIGHTED_ATTRIBUTION | math/0507464v5, setup and Prop. 1.7 | supports only the specified projective-space weighted moduli, characteristic 0 or p>d | weighted_moduli.txt |

These are lookups of propositions, not validations of every application in the
geometric proof. In particular, the Stacks Vistoli summary does not explicitly
state the generic stabilizer ratio. The old proof supplies that derivation;
neither the source reader nor the algebra verifier certified that geometry.
The original Vistoli PDF remains unread. No new novelty survey was undertaken.
The current supplied Wiki index had no matching entry for the scoped
Mukai/descendant/stable-map/weighted-projective or foundational-source terms.
This limited index lookup is not an exhaustive literature search.

The old proof's statement that it adds a virtual-Chow argument relative to the
retrieved intermediate-space literature must not erase the supplied manuscript:
the exact referenced `descendants.tex` already contains the evaluation-fiber,
boundary-image, localization and weighted-degree proof. The review therefore
treats that part as a manuscript reconstruction, not established original Argus
mathematics. The arbitrary-embedding/non-Fano and delta formulations are a
separately identified proposed extension whose novelty remains unestablished.

The current campaign root is
`campaigns/9200063`.
All nine supporting readings were attached with `citation_check attribute`;
each command exited 0. `citation_check status` then reported nine `confirmed`
assumptions, no blocking entries, and exit 0. The source-reader identity and
transcription qualification are included in each ledger note.

After that ledger change, both official checks used
`$WORKSPACE/argus-latest/.venv/bin/python` against the exact root above:
`math_state check` exited **0** with no issues; `proof_graph_check check`
exited **0** with four valid nodes. These certify current structure, not the
mathematics or native review acceptance. Old records are untouched.
