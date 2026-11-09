# Signed averaging and a quantified annular-transfer reduction

## Scope and source

The target is Proposition `tr:block` in
`research/openai_manuscript/A-Pivotal-Amplitude-for-Voronoi-Percolation-from-Cardys-Formula-October-5-2026/build/sections/05-transfer.tex`,
especially equations `tr:flip-integral`, `tr:signed-sum`, and
`tr:unused`. The source uses zero-mass signed measures, evenness under
global color reversal, isotropy under physical rotations, and an
essential supremum over successful output seams including their colors.
Screen successes are indicators, not normalized conditioning.

The following theorem verifies the averaging and summation implication.
Its analytic hypotheses are not proved here. Consequently it neither
refutes nor completely verifies `tr:block`. The strongest previous
campaign state contained only the audit objective; this establishes a
universal conditional reduction, not a publishable resolution.

## Theorem (unnormalized signed end averaging)

Let `(H, rho)` be a finite measure space. Suppose `F` preserves `rho`,
and `R_phi`, for `phi` in the circle with normalized Haar measure,
is a jointly measurable measure-preserving action. Let `alpha` be an
integrable real coefficient with

    alpha(FH) = -alpha(H),    alpha(R_phi H) = alpha(H).

Let `T(H,O)` be a bounded measurable real kernel, where the outer
history `O` is fixed. Then

    integral alpha(H) T(H,O) d rho(H)
      = (1/2) integral alpha(H)
          average_phi [T(R_phi H,O) - T(F R_phi H,O)] d rho(H).

No division by the mass of `rho` occurs. In particular this remains
valid for first-reduction subprobability laws. It does not assert that
the fixed outer seam has a typical law.

**Proof.** Changing variables by `F` in the original integral changes
`alpha` to `-alpha`. Subtract the resulting equality from the original
one and divide by two. For each `phi`, change variables by `R_phi` in
the resulting signed integral; `alpha` and `rho` are invariant.
Integrate this identity in `phi`. Fubini applies because the kernel is
bounded and `alpha` is integrable. This gives the displayed formula.
For noninvertible notation one must assume the stated transformations
really are measure-preserving bijections modulo null sets; color
reversal and a circle action have this property. No unsigned bound
has been substituted for the signed difference. QED.

The finite version, for arbitrary history sets and arbitrary kernel
values, is formalized in `colour_flip_identity`,
`invariant_reindex`, and `colour_rotation_identity` in `Main.lean`.
The finite statement does not replace the physical circle action.

## Theorem (quantitative conditional transfer bound)

Write `L=2^n`. Assume the actual even-isotropic transfer, in its actual
output-seam essential-supremum norm, has the first-reduction decomposition
described below. All constants are independent of `n`, the output seam,
and `r`; errors tend to zero as `r` tends to infinity for each fixed `n`.

1. A used pair `(j,k)` has independently integrated finite end laws.
   The inner law and scalar coefficient satisfy the preceding theorem.
   The product of end-law masses is at most
   `B 2^{-a(j+k)}`. The scalar coefficient has absolute value at most
   the input norm, and the outer signed-state factor has total
   variation at most `Q`. These are unnormalized mass bounds.
2. The physical radii satisfy
   `a_j/b_k <= D 2^{j+k}/L`, and the rotation-averaged signed kernel
   difference is at most `K (a_j/b_k)^b`, with `2 < b < a`.
3. The unused contribution is bounded by
   `U (n+1)^2 L^{-a}`. The total additional error, already in the
   same operator norm and uniform over the output seams and inputs,
   is `epsilon_n(r)`, with `epsilon_n(r) -> 0` for fixed `n`.

Then

    ||M restricted to even,isotropic||
      <= [B Q K D^b / (2 (1-2^{-(a-b)})^2)] L^{-b}
           + U (n+1)^2 L^{-a} + epsilon_n(r).

Consequently, with

    C0 = B Q K D^b / [2 (1-2^{-(a-b)})^2]
           + U / (1-2^{-(a-b)/2})^2,

the norm is at most `C0 L^{-b} + epsilon_n(r)`.
For every fixed `n`, choose `r0(2^n)` so that the last error is at
most `L^{-b}` for **all** `r >= r0(2^n)`. Thus the desired bound holds
with exponent `b > 2` and constant `C0+1`, independent of `L,r`.
This keeps the exact order of quantifiers; no convergence rate uniform
in `n` is used.

**Proof.** Apply the averaging identity before taking absolute values.
For an input of norm one, the used pair's output total variation is at
most

    (B Q K D^b / 2) L^{-b} 2^{-(a-b)(j+k)}.

Set `q=2^{-(a-b)}`. All summands are nonnegative, so extending the
used-pair set to all pairs of nonnegative indices only increases the
bound. The double geometric sum is at most `(1-q)^{-2}`. This gives
the first displayed inequality, including the separately assumed
remainder and error.

For completeness the polynomial absorption has a uniform elementary
bound. Put `t=2^{-(a-b)/2}`. Since `0<t<1`,

    (n+1)t^n <= sum_{i=0}^n t^i <= 1/(1-t).

Squaring yields
`(n+1)^2 L^{-(a-b)} <= (1-t)^{-2}`. This gives `C0`.
Both finite geometric estimates hold for every cutoff and are proved
in `double_geometric_bound` and `polynomial_absorption`. Finally use
the definition of convergence of `epsilon_n(r)` separately for each
fixed `n`. QED.

## What this does and does not settle

Taking `a=2+tau` and `b=2+sigma_2`, with
`0<sigma_2<tau`, recovers precisely the signed summation implication
used by the manuscript. Rotation and color reversal are both
indispensable in this argument: the first averaging identity alone
supplies no power greater than two.

The remaining mathematical obligations are to establish hypotheses
1--3 for the actual Poisson transfer, rather than a model matrix.
In particular `tr:admissible` must justify admissible convergence of
the random four-tip frontiers, `sh:separated-ends` must supply the
physical rotation-averaged bound, and `tr:domination` must justify
the output-seam-uniform error. These are retained as open nodes in
`research/PROOF_GRAPH.json`. There is no certified admissible
counterexample, and no manuscript assertion is declared false here.

The circular-cotangent ground-state calculation was also checked in
its rational half-angle chart, including each individual active-switch
equation rather than only their average. The residues were zero.
This is an internal algebra check, not evidence that the annular PDE
has been derived for the percolation probability.

The annulus-locality suspicion is not supported by the primary source:
Zhan, *Stochastic Loewner evolution in doubly connected domains*,
PTRF 129 (2004), 340--380, DOI `10.1007/s00440-004-0343-1`,
defines the Brownian driving normalization on printed page 343 and
states the stopped radial/annulus SLE6 equivalence in Theorem 1.1(i),
printed page 344. The locally retained PDF and text are in
`literature/`. This source does not establish the manuscript's
random-frontier admissibility. A search-generated attribution to
"Theorem 4.1" was not used.

## Replay

Run the internal exact checks from the campaign root:

```sh
$WORKSPACE/argus-live-update/.venv/bin/python research/annular_transfer/verify.py
```

The script checks the retained Jacobian source and output, exact symbolic
residues, a signed reindexing calculation, and the binding of the recorded
compiler result to the current source and fidelity text. It explicitly
returns `qualifies_as_campaign_completion: false`.

A fresh independent formal replay uses:

```sh
$WORKSPACE/argus-live-update/.venv/bin/python -m argus_skill.verticals.math.lean_evidence verify research/annular_transfer/Main.lean --statement-fidelity research/annular_transfer/statement_fidelity.md --claim C_AT_FINITE_CORE --project-root .
```

The primary-source assumption `AT_ZHAN_LOCALITY` on
`C_AT_KERNEL_OBLIGATION` still needs an independent citation attribution.
The Engineer's reading of the source does not close that review gate.
