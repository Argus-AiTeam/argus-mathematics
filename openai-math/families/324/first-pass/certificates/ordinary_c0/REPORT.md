# Ordinary-c0 obstruction: exact-construction audit

## Scope and primary sources

The target is the real completed molecule space `Z` in the September 26,
2026 manuscript, not its Lipschitz-free analogue and not the September 24
Hilbert-block graph space. The target assertions are
`prop:compatible-detectors` and `prop:no-c0` in `build/sections/07-no-c0.tex`.

The September 26 construction uses the concrete correction coordinates of
`03-weights.tex`, generated tests with nonincreasing dyadic operation scales
and strict total scale less than `ell_j/2` in `05-tests.tex`, and the exact completed
square-sum norm in `06-molecules.tex`. Repeated tests and repeated labels are
expressly permitted in admissible lists. The scalar exponents are
`1 + 1/k`, for positive integers `k`; these are not just quadratic tests.
The proof of compatible selection must retain all these conditions.

The September 24 theorem instead excludes `c0(l2)` from a weighted graph
space. Its dependency chain is the Hilbert-map construction, localized
complete continuity, and the graph obstruction. It explicitly does not
exclude ordinary `c0`. Its compact-reduction and weak-sequential-completeness
inputs are external propositions, not consequences of the September 26
detector argument.

The upstream `lean/docs/324.md` describes both theorem scopes. The actual
`lean/OAI/Analysis/C0Absorption/Core.lean` defines `NoLinearC0` using bounded
real-linear maps from `C_0(N, R)` that are bounded below. Its `Main.lean`
invokes `concrete_noLinearC0` for `ConcreteSpace`. Source inspection, these
names, and comparator challenge statements are not kernel evidence. The
identification of `ConcreteSpace` with the manuscript's exact completion,
and the transitive hypotheses of the invoked theorem, require separate
checking.

All source paths above are relative to the corresponding dated directory
in `research/openai_manuscript/`. Upstream implementation paths are under
`openai-math/`.

## Current mathematical status

The three compatible-selection cases to be checked are distinct labels
with bounded bands, distinct labels with unbounded bands, and a repeated
label. In the repeated-label case, expansion freezes parameters before
distributing operators, and keeps tail multiplication separate from
cylindrical operations. Fixed terms vanish only after pairing with the
weakly null sequence; they are not identically zero.

No manuscript refutation was established. The following analytic argument
now has a zero-hole Lean 4.31.0 certification of both the full weakly-null
selection proposition and the infinite-dimensional ordinary-c0 obstruction.
The final native compiler and axiom-audit exits are both zero.
This is not a finite-exhaustion argument. Independent statement-fidelity,
citation, significance, and novelty review remain outstanding.

## Proof of compatible selection

Throughout, supports are relative closed supports of the actual generated
functions, never supports after subtracting a constant. Write `Lip` for
the Lipschitz seminorm in the manuscript's supremum metric on `B`.

First, fixed-class pointwise convergence may be used on each *fixed*
completed vector. Indeed, if the class has common dual bound `A`, then
for every finite molecule `v`,

    |(f_n - f)(z)| <= |(f_n - f)(v)| + 2 A ||z-v||.

The first term tends to zero and the second can be made arbitrarily
small by density. Each class used below has a fixed index independent
of the sequence index. No uniform convergence on moving vectors is used.
Every fixed generated test is a continuous linear functional, so its
pairing with a weakly null sequence tends to zero.

Choose concrete representations for the original detectors in one class,
with at most `h` operations and, when present, at most `h` tail factors.
Subsequences reduce the labels to the following exhaustive alternatives.

### Distinct labels, bounded bands

Pass to a fixed band `j`. Each level has finitely many labels and
there are finitely many levels with `J_lambda <= j`. Thus eventually
`j < J_lambda`. Each input coordinate participates in at most two
level radii. Distinct labels at a fixed band therefore have, after a
subsequence, radii using only coordinates beyond `M_i`, with `M_i -> infinity`.
The support inequality gives

    supp(F_i) subset {tau_(M_i) >= ell_j/2}.

Choose a fixed dyadic `c` with `2c < ell_j/2`. For each fixed vector
`m_i`, multiplication by `b_(c,N)` preserves its pairing in the limit
`N -> infinity`, by the preceding fixed-class argument. It uses just
one extra tail factor in one enlarged `V_H`. Choose `N_i` large enough
to retain detection at least `delta/2`, and choose the next index so
that `M_k > N_i` for every earlier selected `i`.

The earlier modified support requires `tau_(N_i) <= 2c`; the later
support requires `tau_(M_k) >= ell_j/2`. As
`tau_(N_i) >= tau_(M_k)`, these supports are disjoint. Their common
fixed-class Lipschitz bound is also a bound for all finite signed sums:
locally at most one summand has nonzero support, and a segment in the
convex ball propagates the local bound globally.

### Distinct labels, bands tending to infinity

Here the original class is `T_h`, since `V_h` restricts the band.
Coordinatewise compactness yields a limit tag `v` in `[-1,1]^N`.
No membership of `v` in `c0` is claimed or needed. For every fixed
finite coordinate set `I`, the support inequality gives

    sup_(s in supp(F_i)) ||s|I - v|I|| -> 0,

since `2 d_(j_i) + ell_(j_i)/2 -> 0`.

For each fixed `i`, append one `G_(q,theta)` operation with center
within `theta/8` of `v|I_gamma`. Take `theta` below the last old
scale and the unused strict budget. These choices exist for
arbitrarily small positive dyadic `theta`; the modified tests all
belong to `T_(h+1)` and their difference from `F_i` has supremum
norm at most `theta Lip(F_i)`. Choose `theta_i` after fixing `m_i`
so that detection is at least `delta/2`.

The modified test is constant on the open cylinder of radius
`3 theta_i/8` around `v|I_gamma`. Its representation still obeys
the original label's strict budget, so its support still has the
same coarse tag concentration. Hence all sufficiently late modified
supports lie in each fixed earlier cylinder. A recursive subsequence
makes this true for every earlier selected index. Locally, a finite
signed sum has only one nonconstant term; convexity again gives the
common Lipschitz bound globally.

### One repeated label

All cylindrical factors now depend on one fixed finite set `I`.
There are finitely many ingredient positions. Pass to a subsequence
with fixed numbers and types of ingredients. A dyadic scale is
constant on a subsequence or tends to zero; at a constant scale the
finite grid also makes the center constant. Tail scales range over
a finite set; their indices are constant or tend to infinity.

Freeze these parameters before expanding every varying `G` as
`Id + R` and every varying basic tail factor as `1 + (b-1)`.
Linearity distributes through later cylindrical operators; it does
not apply cylindrical operators to the full tail-dependent product.
Each term retains a chronological sublist of the old operations,
possibly changing `G` to `R` at the same scale. The scales remain
nonincreasing, and deleting scales only decreases their sum. Counts
of tail factors and their allowed scales do not increase. Thus all
terms lie in one `V_H`, with `H >= max(h,j)`.

There are at most `K = 2^(2h)` term positions. The sum of pairings
of fixed positions tends to zero. Consequently, on a subsequence,
one varying position detects at least `delta/(2K) =: delta_0`.
If it contains a varying tail remainder, its support is in
`{tau_(N_i) >= c}` with fixed `c > 0` and `N_i -> infinity`.
The preceding tail-separation argument applies.

Otherwise its tail product is fixed and its cylindrical variation
contains a first retained `R` of scale `epsilon_i -> 0`.
All earlier retained operations are fixed and define a single
prefix function `p`. Put `L_pre = Lip(p)`, not the original
base bound. The first remainder satisfies

    ||R_(q_i,epsilon_i) p||_infinity <= L_pre epsilon_i,
    K_I(R_(q_i,epsilon_i) p) subset closedBall(q_i,epsilon_i).

Every later retained scale is at most `epsilon_i`. Each operation
enlarges projected support by at most its scale and increases the
supremum bound by at most a factor two. With at most `h` later
operations, the final cylindrical factor `u_i` satisfies

    ||u_i||_infinity <= 2^h L_pre epsilon_i,
    K_I(u_i) subset closedBall(q_i,(h+1) epsilon_i).

The case `L_pre = 0` contradicts nonzero detection. Extract
`q_i -> v` in the finite cube. Append a flattening `G` near `v`
of scale `theta_i <= epsilon_i`, also below the last retained
scale and the unused strict budget. Fixed-vector convergence
permits retention of at least `delta_0/2`. All full tests belong
to one `V_(H')`. The modified cylindrical supports lie in
`closedBall(q_i,(h+2) epsilon_i)` and concentrate at `v`.
Their constant plateau values `e_i` satisfy

    |e_i| <= 2^h L_pre epsilon_i -> 0.

Select recursively so that every later cylindrical support lies
inside each earlier plateau cylinder and `sum_i |e_i| < infinity`.
The tail products have uniformly bounded Lipschitz seminorm
`h 2^h`. A finite signed sum is, near any point, its last active
full test plus earlier terms of the form `sign_i e_i b_i`.
Its local Lipschitz bound is at most

    L_(H') + sum_i |e_i| Lip(b_i) < infinity.

Convexity turns this into a common global bound. This completes
compatible selection for the full weakly null hypothesis of the
proposition, not just for images of the `c0` basis.

## From compatible selection to the full no-c0 obstruction

Suppose `T:c0 -> Z` is bounded linear and bounded below. For
`m_i = T e_i`, the norms are bounded below by some `r > 0`,
and every finite signed sum has norm at most `M = ||T||`.
Choosing signs for any fixed functional gives
`sum_i |u(m_i)| <= M ||u||`, so the sequence is weakly null.

If every fixed seminorm tended to zero on this sequence, the exact
completed square-sum formula would give disjoint finite index
intervals `A_i` with

    sum_(d in A_i) alpha_d sigma_d(m_i)^2 >= r^2/4.

Even convexity of the squared seminorm gives, for independent
finite signs, `E sigma_d(sum_k sign_k m_k)^2 >= sigma_d(m_i)^2`.
Summing on the disjoint `A_i` would imply
`M^2 >= n r^2/4` for every `n`, a contradiction.
One fixed seminorm therefore detects a subsequence.

For its exponent `p`, choose a listed `p' < p` in the same class
with the same compatibility constant. That second seminorm is
bounded by the completed norm. For an almost-norming list, write
`x_nu = |u_nu(m_i)|`. Then

    (a/2)^p <= sum x_nu^p
             <= (max x_nu)^(p-p') sum x_nu^p'
             <= (max x_nu)^(p-p') B^p'.

This yields one scalar detector with a positive uniform lower
bound. The compatible-selection proof just given applies.
For its modified detectors, the quadratic triple has positive
weight `alpha`. The exact list formula and finite sign cancellation
give

    M^2 >= E ||sum_i sign_i m_i||^2
         >= alpha sum_k sum_i |F_k(m_i)|^2
         >= alpha n delta_1^2.

Cross-pairings need not vanish. Letting `n` grow contradicts the
fixed `M`. This proves the claimed obstruction in the actual
completion, without assuming compatible selection or no-c0.

## Implementation fidelity and certified scope

The upstream `sourceClasses B n` is `T_(n/2+1)` for even `n`
and `V_(n/2+1)` for odd `n`. In particular, generic definitions
of `T_0,V_0` do not insert extra classes in this norm.
`triple` is a surjective unpairing enumeration, with
`C_n = second(triple n)+1`,
`p_n = 1+1/(third(triple n)+1)`, and
`alpha_n = 2^(-(n+1))/C_n^2`. Taking `d=n+1` is an allowed
enumeration in the manuscript. `TestSpace` completes the seminormed
zero-mass molecules; metric separation supplies the zero-distance
quotient implicit in that completion.

The completed-norm lists use unscaled signed sums with Lipschitz bound
`C`; the factor `C^-2` is in the outer squared-norm weight, not an
extra divisor in the list expression. The compiled representation
field is exactly `sum(scales) < B.ell(B.band gamma)/2`.
`concreteBases.ell` is the raw weight scale. The typed budget probe
confirmed this half-budget directly. Seed tests are the correction
coordinates, not an additional family of scalar coordinate tests;
the underlying domain nevertheless has both scalar and block
coordinates. The class parameter bounds the operation count, not
the representing band's index.

`Tags.lean` supplies the concrete bases and proves, rather than
assumes, the tag and escaping-radius hypotheses through
`concreteTagLocalization` and `concreteRadiusLocalization`.
It defines `ConcreteSpace := SourceSpace concreteBases` and
derives `concrete_noLinearC0` from `source_noLinearC0`.
The upstream generic no-c0 proof uses bounded signed sums internally;
it does not itself package the full weakly-null compatible-selection
proposition. The new `CompatibleSelection.lean` separates weak scalar
vanishing from the temporary denial of compatible extraction, discharges
that denial, and proves the full proposition. Its final averaging argument
gives bounds for every finite index set. The selected tests share one
fixed output class, which need not be the input class.

The original implementation's first tail cutoff also needs attention.
`coordinateTail N` retains Lean coordinates k>N, whereas the positive
manuscript cutoff N corresponds to formal cutoff N-1. The upstream
`TailOperation.factor` starts at `tailIndex+1`, missing cutoff zero in
this direct parameterization. The final model permits `tailIndex` instead.
The support witness and escaping-tail proof are adjusted accordingly.
This distinguishes allowed ingredients; it does not prove the old and
new completed norms inequivalent and does not refute the manuscript.

The host compiler is Lean 4.31.0, while upstream declares Lean 4.34.1.
All 23 modules of the obstruction's dependency closure compiled.
Fourteen proof-only API changes in seven modules preserve their
definitions and theorem statements. The 13 modules affected by the
explicit tail-family correction were then recompiled, followed by the
new full selection proof. `Main.lean` independently derives no-c0 from
that selection proof and the exact completed-norm growth argument;
it does not invoke the existing no-c0 theorem as a shortcut.

The final native evidence is
`lean_evidence/certificates/C_NO_C0_324-ce810cb52a877242.json`.
Its source and statement-fidelity hashes match the current originals.
All four principal declarations depend only on `propext`,
`Classical.choice`, and `Quot.sound`. The claim `C_NO_C0_324` is
compiler-derived `closed_kernel`, not independently reviewed.
`exact_certificate.json` binds the staged source passages, proof sources,
compiled dependencies, and auxiliary exact arithmetic. No detector
selection or no-c0 assumption is used to prove itself.

The separate September 24 external inputs were opened in
arXiv:2004.14250v3: Theorem 2.3 assumes a complete metric space
and a weakly precompact set and concludes tightness; Corollary 2.5
asserts weak sequential completeness over a superreflexive Banach
space. Their independent citation attribution is reserved for Reviewer.

## Replay and limitations

From the campaign root, run

```
$WORKSPACE/argus-live-update/.venv/bin/python research/certificates/ordinary_c0/verify.py
```

This checks the saved real compiler verdict, current source hashes,
exact LP primal/dual equality, ordered-operation identities, and finite
sign-character products. It explicitly reports a recorded-certificate
replay, not a fresh compiler run. For a fresh native run add `--compile`;
for independent recompilation of every dependency and both formal
sources add `--rebuild`. The latter can take several minutes and should
be run through the host's durable command runner. `--check-ledgers`
runs both official checks against this campaign root.

Rebuilding requires the assigned read-only upstream checkout and the
host's existing Lean 4.31.0 Mathlib workspace. No new Lake project is
needed. The auxiliary Jacobian optimization has exact optimum 2 with
matching primal and row-dual witnesses; its original admission-rejected
request is preserved as a non-conclusion.

The improvement over the earlier upstream certificate is precise:
full weakly-null selection is now formalized, including arbitrary finite
signed sets, for the coordinate-faithful full tail family. The generic
selection theorem also applies to any cylinder-base family satisfying
the explicit tag and radius localization hypotheses. This is new formal
coverage and a structural formulation, not a claim of a new Banach-space
counterexample or independently verified mathematical novelty.
The September 24 construction and the September 26 absorption assembly
are not certified by this bounded obstruction mission. The campaign
must remain open until the Host-invoked Reviewer completes independent
replay and assesses the requested publishability and novelty bar.
