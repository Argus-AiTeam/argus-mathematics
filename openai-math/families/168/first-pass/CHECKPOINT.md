# Transported-edge rigidity checkpoint

The quantified assertion `C_IMAGE_EQUALITY` remains unresolved.
No false manuscript assertion or `F_*` refutation has been established.
The publishable completion bar is unchanged and is not met.

The exact finite results and the conditional Lean theorem are stated,
with their limitations, in `edge_rigidity/exact_certificate.json` and
proved/explained in `edge_rigidity/analysis.md`. The actual BMP
implementation is `edge_rigidity/verify.py`; genuine B3 target intervals
are constructed in `edge_rigidity/type_b_targets.py`.

The uniform real-vector no-hidden-deficit theorem
`C_DEFICIT_RIGIDITY` passed Lean 4.31.0 with no proof holes. Its compiler
certificate is attached in the ledger. It assumes the local numerical
step bounds and endpoint equality, so it is not a formalization of the
unconditional BMP image-equality statement.

The broader durable search `type-a5-full-pattern-orders` timed out at
1,800 seconds with no completed aggregate certificate. The exact receipt
is `edge_rigidity/search_a5_orders_receipt.json`; the terminal structured
status is `edge_rigidity/a5_orders_status.json`. It requested all 32 S5
tops containing a 3412 or 4231 pattern and ten geometric orders.
This is not an all-S5 exclusion or a mathematical refutation. Route
`R_S5_TEN_ORDER_FALSIFICATION` is retired for this explicit runtime
failure; do not resubmit the identical monolithic run. The code now
atomically saves completed mathematical prefixes; controlled-interruption
and normal-completion tests verified that behavior.

Next owner: independent Reviewer. Read the primary Fiebig source at
Section 6.1 and attribute `C_BMP_CONSTRUCTION/BMP_DEFINITION` using the
retained PDF and excerpt. Independently check the Lean statement fidelity
and replay the finite module computation. Review this as a checkpoint,
not as completion of `C_EDGE_RESOLUTION` or the campaign.

The remaining mathematical frontier is the uniform edge bound and its
relative-dihedral transport/localized-splitting inputs. Once all local
bounds and the endpoint identity hold, the certified deficit implication
rules out every nonzero higher-codimension defect. Passing finitely many
examples cannot establish those hypotheses. After checkpoint review,
Planner must open a materially different unresolved route rather than
resubmit the identical finite family.
