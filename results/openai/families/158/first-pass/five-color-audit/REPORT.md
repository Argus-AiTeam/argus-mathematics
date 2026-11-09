# Literal five-color obstruction: scope and certification

## Statement being audited

The staged `sections/introduction.tex`, `thm:main` (lines 60-68), asserts
that the Euclidean plane has no proper five-coloring with arbitrary color
classes. A proper coloring has different labels at every pair at distance
exactly one. It need not be measurable, continuous, or surjective. The
statement to certify is therefore

```
not exists c : Complex -> Fin 5,
  forall z w : Complex, norm(z - w) = 1 -> c z != c w
```

All staged paths in this report are relative to
`research/openai_manuscript/The-Euclidean-plane-is-not-five-colorable-September-23-2026/build/`.
The source is unchanged.

## Source-qualified scope findings

The manuscript proves its lower bound through two different substantive
obligations, not by assuming regularity:

1. `thm:transfer` (`introduction.tex:104-113`) equates unrestricted proper
   colorability and weak measurable colorability for each positive integer
   number of labels. Only its forward direction is needed here. Weak
   colorability means zero same-label correlation in the completed product
   measure of bounded spatial roots and unit-circle directions, not the
   exclusion of every individual unit-distance pair.
2. `thm:weak-five` (`introduction.tex:115-117`) excludes a weak measurable
   five-coloring. Its graph-valued approximation is conditional on the
   weak-coloring constraints, the transition graph, and the missing-edge
   estimates. It is not an approximation theorem for arbitrary Borel
   partitions.

The first branch uses `thm:rigidity` (`spectral.tex:64-70`): a Borel
probability on the dual of the discrete additive algebraic plane, invariant
under algebraic unit rotations and giving zero mass to all ordinary
continuous characters, is Haar. Conditional singularity
(`spectral.tex:327-337`), the relatively compact factor tower
(`rigidity.tex:35-46`), every-Folner multiple averages
(`rigidity.tex:168-185`), and invariant-mean line cancellation
(`spectral.tex:174-180`) are separate unverified obligations. The cancellation
functional is not ordinary integration of a nonmeasurable coefficient.

The second branch uses fixed-center, almost-everywhere palette transport;
uniform separation of binary centers; local finiteness of the cyclic
transition locus; the universal disk-average unit inequality; missing-edge
`o(epsilon)` overlap; extensions through forest-valued holes; the planar
small-mesh cover obstruction; and a common-center interface cycle. The
three possible cycle lengths are then excluded by the angular arguments.
The graph and ledger retain these assertions separately. No simultaneous
conull angular set for all centers is silently substituted.

The cover proof cites Hatcher, *Algebraic Topology* (2002), Theorem 1.9
(Brouwer), ISBN 9780521795401. The continuous-factor and amenability arguments
cite the February 23, 2007 author manuscript of Bekka, de la Harpe, and
Valette: Theorem D.3.1, Proposition G.2.2(ii), and Theorem G.5.1. These are
recorded as external assumptions of the relevant prose branches, not as
independently checked facts. The primary author-hosted Hatcher chapter has
now been opened: Theorem 1.9 says every continuous map of the closed disk to
itself has a fixed point. Independent attribution is still pending. The
Bekka author-manuscript passages have not been obtained: the old author URL
failed at transport level, the updated author PDF URL and the proposed
institutional attachment returned HTTP 404. The institutional catalog page
does identify the 2008 monograph and DOI `10.1017/cbo9780511542749`, but a
catalog record is not a reading of its numbered propositions. These
uncited prose dependencies remain exposed in the ledger; none is a premise
of the intended compiled main declaration.

The staged introduction already rejects an attributed strict angular
independence bound using the half-open arc `[0, pi/3)`. That known failed
shortcut is recorded as retired. It is not a false assertion made by this
manuscript.

## Published implementation and version boundary

The inspected public `openai/math` revision is
`4eaee87548250b2682affda7d05d947c05554bae`.
`lean/docs/158.md` says that the lower bound covers arbitrary colorings without
measurability or continuity. The implementation is
`lean/OAI/Geometry/PlaneColoring/Five.lean`,
`OAI.EuclideanFiveColor.no_proper_five_coloring`.

The comparator at
`lean/ComparatorChallenges/EuclideanFiveColor.lean` ends with `sorry`.
That comparator is a challenge statement and cannot certify the theorem.
This route is retired; this observation is not a mathematical refutation.

The actual `Coloring.lean` module imports only Mathlib and defines
`ProperColoring k c` literally by `forall x y, norm(x-y)=1 -> c x != c y`.
Its definition therefore fixes the ordinary Mathlib complex norm, rather
than inheriting an alternative norm from other audit modules. The audit
wrapper's `simpa only [ProperColoring]` must match that exact predicate;
it cannot discard a measurability premise, change the label count, or
silently change the metric.

The publication declares Lean `v4.34.1` and Mathlib revision
`d13f23b723b8a846827a245b89c10fc7d3f11612`. The required host compiler reports
Lean `4.31.0`. Importing a comparator, accepting unexamined axioms, or changing
the main statement would not resolve this discrepancy. The audit must compile
the actual dependency closure from source against the assigned 4.31.0
workspace, recording any necessary source-level compatibility changes.
The publication's Lake configuration is not run: it would fetch unrelated
packages and does not describe the assigned built workspace.

## Certified formal result and remaining scope

The actual declaration `Audit9000158.no_unrestricted_five_coloring` now
compiles on Lean 4.31.0 with compiler exit zero and `proof_holes=[]`.
The separate native axiom audit also exits zero. Its printed transitive
axiom closure is exactly `propext`, `Classical.choice`, and `Quot.sound`.
There is no measurability premise or other extra hypothesis. The native
recorder attaches mechanical evidence to version 2 of `C9000158_MAIN`,
whose derived status is `closed_kernel` with no undischarged assumptions.
Version 2 binds the completed source; the natural mathematical statement
is unchanged.

All 70 published OAI dependencies were compiled locally against the assigned
4.31.0 workspace. Fifty-two isolated copies supply the older proof APIs,
as documented in `API_COMPATIBILITY.md`; the pinned originals remain
unchanged and their Git-blob identifiers are checked. The selected sources,
recursive dependency fingerprints, objects, compiler options, and digests
are recorded in `build_results.json`. The actual final `Five` proof has
only the older local path-connectedness names and an explicit derived disk
instance substituted; its unrestricted conclusion is unchanged.

`exact_certificate.json` records the successful native run and points to
`certificates/C9000158_MAIN-581b4b579474fe8e.json`. The final wrapper source
hash is `6d19f917051bf1a8dd34694fd96db9d5062e146acd024f0264ce6f52ef1ca851`;
the fidelity hash is
`609bc2c933cf630346bed018622cffc57a390d787c127b03912e6a15f57b8b7b`.
Both official checks returned zero at the campaign root
`campaigns/9000158`.

This improves the earlier exact polynomial and finite-placement results
to a machine-checked statement about every coloring of the entire ordinary
plane by five labels. The finite computations alone did not establish
that conclusion. This is a formal verification of the published theorem,
not an independently discovered geometric proof, an exact counterexample,
or a claim of verified-new mathematical originality.

Independent Reviewer replay and statement-fidelity adjudication remain
pending. The proof graph now exposes that formal route while retaining
the separately unreviewed prose branches and their citation debt. Its
nodes are not marked reviewer-confirmed. This certificate does not certify
every prose lemma, the seven-color upper bound, or publishability/novelty.
No false load-bearing manuscript assertion has been established here;
compiler-version failures and the comparator placeholder are not
mathematical refutations. The broader campaign is not declared complete.

## Exact supporting computations

`verify.py algebra` reduces both displayed radial squared-modulus
differences in the rational ideal
`(x^2+y^2-1, r^2-A*B)`. Both remainders are exactly zero, including the
degenerate cases `A=0` or `B=0`. The separately inspected Jacobian operation
`polynomial.ideal.normal_form.compute` returned `COMPUTED`, `in_ideal=true`,
and an empty zero remainder for the exact retained payload. Its server
version is 0.14.0, protocol 2025-11-25, adapter exit zero. The request and
typed output are retained as dedicated JSON files in `jacobian/`.

The same script checks all pairwise squared distances of the seven
manuscript vertices, recovering exactly eleven unit edges. It exhausts
all 2187 assignments of three labels, finds a proper four-label assignment,
and proves every placed vertex lies strictly in the manuscript's
three-label region using rational intervals whose radical endpoints are
checked by squaring. These finite calculations certify the explicit
placement, not the five-color theorem.

The native full-theorem command is `verify.py certify` (the default).
For an independent fresh dependency replay, run the following from the
campaign root through the durable runner:

```bash
$WORKSPACE/argus-live-update/.venv/bin/python research/five-color-audit/verify.py certify --replay
```

It recompiles all 70 dependencies, repeats the supporting exact checks,
obtains fresh native Lean evidence about `C9000158_MAIN`, checks the named
theorem's transitive axioms and both campaign-local official checks, and
only then writes `exact_certificate.json`. The current certificate was
earned by `certify` after the incrementally checked 70-module build and the
earlier exact supporting computations. A fresh all-module `--replay` and
independent Reviewer acceptance remain separate.
