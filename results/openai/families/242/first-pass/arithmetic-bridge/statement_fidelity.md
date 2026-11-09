# Statement fidelity: ArithmeticBridge

This document describes `Main.lean`, namespace `ArithmeticBridge`,
and its principal declaration `elliptic_pell_complete`. It accompanies
claim `AB_KERNEL`, not a claim that the entire staged manuscript or
its literal polynomial has been formalized.

## Objects and hypotheses

`RationalCode` has exactly the six natural coordinates
`p,n,d,t,s,q`. `Valid` is the manuscript's three equations, and
`value` is their rational value. `rational_code_exists_unique`
quantifies over every rational number. `PointCode` has one natural
flag and two complete rational codes. `Represents` distinguishes
`none` (infinity) from `some (0,0)` and fixes both dummy coordinates
at infinity. It does not assert that every rational coordinate pair
is on the curve; the separate `OnCurve` predicate carries that
condition.

`OnCurve` is precisely \(y^2=x^3-25x\), or infinity.
`AdditionGuard` has all seven source guards, indexed from 0 to 6.
`AdditionLocal` implements the four slope and chord--tangent cases
and the three direct-output cases. `AddAux` has a six-coordinate
slope code and one strict-comparison slack only in cases 2,3,5,6.
Its `PUnit` values in the other cases encode no natural coordinate.
`addZero` is the all-zero local tuple, including a zero denominator.
It is not a valid active rational code.

`CaseWitness` carries one shared output, all natural Boolean selectors,
and every dependent local tuple. `CaseOK` asserts exactly one active
selector, guarded active equations, and zero inactive coordinates.
Thus `addition_complete` proves unique complete witnesses, including
all four local slopes and slacks and all seven selectors, on valid
curve inputs. It does not prove that the coordinate formulas define
the elliptic-curve group structure; that algebraic identification
is part of the mathematical source instantiation.

`maximum_complete` includes ties in its first case, counts both
selectors and both local slacks, and zeroes the inactive slack.
`comparison_slack`, `unique_expansion`, and `fixed_chain_complete`
prove weak-comparison uniqueness, dependent composition, and the
whole trace of a fixed number of operations respectively. A
`Chain`'s natural length is a fixed parameter, not a variable in
the manuscript's polynomial witness.

`HeightSequence` is an arbitrary function \(w:\mathbb N\to\mathbb N\)
with positive values, \(w(0)=1\), real \(a,c\), natural \(\kappa\),
and the hypotheses
\[
 c\ge0,\quad a>2c,\quad
 6c<\log\kappa<2a-6c,\quad
 |\log w(j)-aj^2|\le c\ (j\ge1).
\]
These are bounded-error quadratic height hypotheses, not a
postulated growth graph. No monotonicity of \(w\) is assumed.

`T` is any finite additive commutative group. `OrbitGeometry T`
has rational coordinate functions on \(\mathbb Z\times T\).
Its fields assert \(x(-p)=x(p)\), \(y(-p)=-y(p)\), equality of
nonzero-index \(x\)-fibres only at \(p=\pm q\), and nonzero
\(y\) at nonzero index. These are explicit geometric hypotheses.
It does not assume maximal-point or representative uniqueness.

`GrowthWitness T` records the natural output and the two semantic
pairs of signed integer index and torsion tag. `GrowthOK` imposes
the two representative predicates, bracket, square window, and
output equality. The source polynomial does not quantify these
integer indices. `GrowthCall.project` removes the semantic pairs
from the final growth-call witness, after proving uniqueness.

The root additionally quantifies over any type `B` and any
input-dependent relation
`E : ℕ → GrowthWitness T → B → Prop`, with the explicit premise
\[
 \forall u,z,\quad \mathrm{GrowthOK}(S,G,u,z)
                 \ \Longrightarrow\ \exists! a,\ E(u,z,a).
\]
This is uniqueness of the local arithmetic expansion after both
semantic points are fixed, not uniqueness of those points or of
the growth graph. The input is retained because bracket slacks
depend on it. For the manuscript, `B` is its entire natural
growth auxiliary tuple. Section 5 of `theorem.md` discharges
this premise using the proved primitive kernels and the source's
fixed finite composition. That particular finite expansion is
not instantiated as a closed Lean term in this file.

## Conclusions and quantifiers

`HeightSequence.strictMono`, `bracket`, `neighbor_max`,
`doubled_index`, and `square_window` prove strict increase,
a unique positive bracket index for every natural \(u\), the
literal neighbor and doubling reductions, and the equivalence
of the multiplicative window with \(r=k^2\) for every \(k,r\ge1\).
The six-error bound is proved, not assumed.

`OrbitGeometry.representatives` proves existence and uniqueness
for every positive absolute index. `growth_core_unique` proves
existence and uniqueness of both semantic points and their output
for every \(u\ge0\), including \(u=0\). Neither is an input
hypothesis of the formalization.

`HeightSequence.growth_bounds` proves existence of a positive
real \(\delta=1/(128a)\) and a natural cutoff at least 4 such that
\(\delta(\log u)^2<\log w(k^2)<u\log u\) for every larger input
and its bracket index. This is universal, not a sampled estimate.

`GrowthCall A` records a relation on input, output, and a whole
auxiliary of type `A`, unique jointly in output and auxiliary for
each input. Its bounds, positive constant, and cutoff are fields.
`growth_call_exists` constructs it from the previously proved
growth core and the explicit expansion premise; the root does
not simply assume this desired growth call.

`PellTransfer.size_bounds`, `paired_lower`, `paired_ratio`,
`power_gap`, `quotient_window`, and `index_cutoff` prove the
universal Pell comparisons and exact numerical estimates. The
paired-ratio upper bound is expressed after multiplication by
the positive integer denominators, so is equivalent to the
manuscript's rational inequality.

`PellTransfer.PowerWitness A` has precisely
`c,u,v,X,Y,F,H,q,q',r,sigmaB,sigmaF,sigmaFv,sigmaH,sigmaHv,sigmaR,aux`.
The first sixteen fields are natural numbers; `aux : A` is the
whole nested growth witness. `PowerOK` imposes the fixed scale,
growth call, both Pell equations, both residue equations,
Euclidean division, and all six slack equalities.
The differences in its Pell coefficients are natural subtraction;
the proved conditions \(u\ge4,b\ge2\) make them the usual positive
integer coefficients. No indices, negative square roots, free
scale, or suppressed auxiliary are quantified.

`power_indices`, `power_output`, `power_exists`, and
`power_witness_unique` prove soundness, existence, and joint
uniqueness. The case \(n=0\) is included in these declarations.
The case \(j=u-1\) is excluded by its zero residue rather than
an unjustified strict-modulus assumption.

`elliptic_pell_complete` concludes existence of one
`C : GrowthCall B` and one fixed natural exponent `ℓ` such that:

1. `C.rel u v a` holds exactly when some semantic `z` satisfies
   `GrowthOK S G u z`, `E u z a`, and `v = z.value`.
2. For every natural `b,n`, there exists exactly one entire
   `PowerWitness B` satisfying `PowerOK C ℓ b n` if and only if
   \(b\ge2\). Thus \(b=0,1\) have no witnesses.
3. Every such witness has `c = b ^ n`.

These are joint output-and-auxiliary conclusions, not merely
uniqueness of `c`.

## What this compiler run does not establish

It does not prove rank one or the torsion subgroup of the
specific rational elliptic curve, construct the isomorphism
with \(\mathbb Z\times\mathcal T\), prove the canonical-height
theorems, choose a numerical generator or numerical height
constants, or prove that the source-specific finite polynomial
expansion is the particular `E` satisfying the premise.
Those are distinguished in `theorem.md` and the ledger.
The assumption source reading and literal-book-locator limitations
are recorded in `primary_sources.md`.

It does not prove the downstream binary-containment or computation
constructions, promise-undecidability corollaries, novelty, or
publishability. Exact finite diagnostics in `verify.py` are
not promoted to universal proofs.

No `sorry`, `admit`, custom axiom, or proof-hole declaration is
used in the source. Imported Mathlib lemmas, including specialized
Pell completeness and residues, are used through their Lean
proofs. Kernel success certifies these encoded declarations;
fidelity of this document and the prose source instantiation
still require independent human review.
