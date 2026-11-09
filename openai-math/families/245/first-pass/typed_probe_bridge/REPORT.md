# Typed parameter-preserving probe bridge

## Scope and inherited knowledge

This node concerns `chan-access`, the uniform term `z_i`, raw lift
cancellation, and `rel-probe-rounded`, `rel-lift-congruence`, and
`rel-lift-valid` in the staged September 25, 2026 manuscript.
The sealed Reviewer verdict in
`handoffs/8e184e6af0d9/round-0001.json` accepts the earlier conditional
guarded core. That result is reused, not recompiled or rechecked here.

The inherited source facts are that the diagonal is presented as an
adaptation of Hurkens (1995), with Geuvers (2007), Section 2, cited for
its provenance, and that the accepted core is conditional on its named
upstream inputs. These are provenance facts, not independently checked
external theorems or a novelty claim. The earlier scope lookup found no
relevant entry in the inherited Wiki. No new literature search is being
run in this node, and no external source passage has been obtained or
attributed here. No external literature theorem is used below.

A known inadmissible route is substitution of logically equivalent data
inside a callback. The wrapper lemmas supply proof biconditionals, not
data equalities. In particular, access must keep the original parameter
`m`, and validity cannot silently add `Ext(i)` or `Ext(i')`.
This restriction is not a refutation of the manuscript, which states it
explicitly.

## Current mathematical boundary

Primitive labelled wrapper formation, exact cancellation, fixed positive
retractions, read/send, marker/decoder/point facts, and the typed logical
constructors may remain upstream inputs. Their exact judgments and source
labels must be exposed. The four output laws being discharged may not
be assumed. Generic admissibility is exactly `not D(m)` plus congruence
of the seven structural queries under pointwise predicate equivalence.

Specialized tagged pairing, the observation interpretation, graph
exclusion, full normalization, and publication-level novelty remain outside
this bounded node.

## Result

The expanded channel construction has an unbounded relative
typed-macro certificate. `Main.lean` proves `chan-access` and derives
the four reviewed-core fields `lift_cancel`, `probe_rounded`,
`lift_congr`, and `lift_valid`. These four output laws are not fields
of the primitive hypothesis record. The local predicate-code carriers
remain separate from semantic function spaces.

`Syntax.type_preservation` and `formula_preservation` cover arbitrary
finite typed contexts and syntax trees in every interpretation of the
exposed primitive typing rules. The actual `probeTemplate` contains
the outer data lambda, even pack, inner data lambda, read/send
callback, and expanded Access/lift construction. Its two native
products are exactly `(p,n,g)` and `(I,J,k)`. Logical binders use only
the chosen direct vertices `j,h`; no directness of `p,k` is added.
The typed template's only free input is `i:PX`. A check of all its
annotations proves it has no external `A`, and `V,X,PX` have no
family parameter index. Thus the construction precedes, and cannot
capture, the later `A_0,m_0` specialization.

This is not a new deep embedding of the entire labelled PTS.
`TypingInterpretation` must be instantiated by the primitive
formation/substitution, wrapper, logical, and marker judgments
listed in `STATEMENT_FIDELITY.md`. Their actual realization in the
manuscript's PTS remains an upstream input. Native beta conversion,
positive retraction, exact wrapper cancellation, and point laws are
also explicit primitive inputs. The result is therefore
`conditional_kernel`, not an unconditional normalization certificate.

## Exact Access calculation

Write `w` for the actual expression `Bundle(m,y)`. Cancellation gives

```
<w,f> iff if(<f,dummy>; <f,m>, <f,point(y)>).
```

For `f_e(w)`, evaluation at `dummy` is true because `D(dummy)` holds.
Evaluation at the original `m`, using `not D(m)`, is equivalent to
`<w,f_i(m)>`. The first bundle selection therefore yields
`Access(w,Psi) iff <w,f_i(m)>`.

Evaluation of `f_i(m)` at `dummy` is false. At `point(y)`, the
negative point flag selects the point query; the point-query law
and predicate evaluation give `Psi(m,Round(y))`. The second bundle
selection proves the exact Access law. The first parameter of the
callback is always the original `m`. Its only rounded argument is
the final `y`; no datum is replaced using a logical equivalence.

For `z_i`, the outer beta contraction, fixed positive retraction,
even pack/use cancellation, inner beta contraction, and read/send
cancellation leave precisely this Access calculation with callback
`i @ lift_o(x)`. This proves rounded probe evaluation using only
`not D(m)`, hence in particular under generic admissibility.
Raw lift cancellation is the primitive `mk_X` cancellation at its
literal `sb` callback and the exact arbitrary observation input `v`.

## Generic congruence and validity

The formalization proves the generic class/union evaluations,
their pointwise congruence, structural tagged-form congruence, and
Pair congruence directly. It does not import the later specialized
pair-left/pair-right laws. The only query congruence hypotheses are
the seven structural clauses of the manuscript's `Adm`; there is
no congruence hypothesis for the `pt` query.

For related `a,a'`, Pair congruence at the unchanged
`Part(z_i)`, the `R` query clause, and two raw cancellations prove
lift congruence.

For pointwise-equivalent codes `i,i'`, rounded evaluation gives

```
Part(z_i) @ y
  iff z_i diamond_m Round(y)
  iff i @ lift_m(Round(Round(y))).
```

Use the given pointwise equivalence at exactly that double-rounded
lift. Reverse the same calculation for `i'`, obtaining equivalence
of the two Part codes. Pair congruence with `a` unchanged, the `R`
query clause, and raw cancellation then prove lift validity.
No extensionality assumption on either code is present.

## Adversarial computation and its limits

The standalone script evaluates the actual two-stage functional
Access construction on 65,536 finite local inputs, including 40,960
guarded inputs. All guarded evaluations agree with the exact target.
Removing `not D(m)` produces a failure at the dummy parameter.
Replacing `m` in the callback by `point(y)` also produces a failure
even in a guarded instance. These are sensitivity diagnostics, not
manuscript refutations or full PTS models.

The selected-branch Boolean counterexample query has eight variables
and fifteen clauses. Its source-to-CNF equivalence and absence of
satisfying assignments are replayed on all 256 assignments.
After discovery and contract inspection, Jacobian 0.14.0
`sat.cnf.canonicalize` and `sat.solve` returned exact typed results;
the latter returned `UNSAT` in 466 ms. Dedicated JSON files preserve
the exact requests, outputs, server/protocol metadata and zero
adapter exit statuses. The exhaustive local replay, not an
unqualified solver answer, establishes this finite exclusion.

The finite checks are not the unbounded theorem. That theorem is
the Lean proof over arbitrary carriers, contexts, codes and
parameters. No false manuscript assertion was established, so no
`F_...` refutation claim is warranted for these guarded diagnostics.

## Reproduction and handoff

From the campaign root:

```
$WORKSPACE/argus-live-update/.venv/bin/python research/typed_probe_bridge/verify.py
```

The script replays the archived Jacobian bindings locally, performs
the finite checks, invokes the official Lean evidence command with
the positional source and claim, and runs both official
campaign-local checks. It does not rerun or import the guarded-core
certificate. No Mathlib project or dependency installation is needed.

The fresh official run used Lean 4.31.0 and returned
`exit_code=0`, `proof_holes=[]`. Its source/fidelity-bound artifact is
`certificates/C_TYPED_PROBE_BRIDGE-60eacc19faf63765.json`.
The realization and typing theorems use no axioms; the separate
closed-template normalization check uses only Lean's standard
`propext`, as recorded by the axiom audit.

Both `math_state check` and `proof_graph_check check` returned zero
against the exact project root
`campaigns/9000245`.
Attaching the formal source advanced the bridge to claim version 5;
the checker-identified stale route references were refreshed without
changing their mathematics or the retired route's reason.

Compared with the sealed guarded-core result, four output laws are
now consequences of the actual macro schemata and lower-level
primitive interfaces, rather than assumed guarded-core fields.
The old core's evidence and its broader upstream assumption groups
are preserved; the tag law and other ten fields are not discharged
here. This is a bounded engineering advance, not a novelty or
publication-level result. Independent statement-fidelity and
mathematical review must be supplied by the Host-invoked Reviewer.
