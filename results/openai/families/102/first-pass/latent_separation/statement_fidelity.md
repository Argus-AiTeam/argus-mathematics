# Statement fidelity: C_LATENT_COMPOSITION_CORE

`Main.lean` proves parameter-uniform finite-process and algebraic composition
theorems corresponding to the harmonic rank argument, common lift extension,
and shift-kernel quotients in Section 2 of the staged Unique Games manuscript.
This document describes this file, not the separate genericity and radical
formalizations.

## Exact finite probability model

`expectation w f` is the finite sum `sum w(omega) * f(omega)` in the rational
numbers. `indicator P` takes values zero and one; `probability w P` is its
expectation. Normalization and nonnegative weights are explicit where needed.
The finite sample type is arbitrary. It can index entire paths with their
joint probabilities, so there is no Markov, nonadaptivity, or independence
hypothesis.

`harmonic r` is the actual rational sum `sum_{j=0}^{r-1} 1/(j+1)`.
The file proves its zero value, successor identity, nonnegativity,
monotonicity, and positivity at positive ranks.

`generic_harmonic_drop` quantifies over every finite probability-weighted
set of outgoing ranks. The current rank `r` is positive, the outgoing rank
is at most `r` and at least `r-1`, and the probability of a loss is at most
`3*r*theta`. It concludes expected harmonic loss at most `3*theta`.
This is the manuscript's actual harmonic calculation, not an arbitrary
potential identity substituted for it.

`arbitrary_harmonic_drop` permits any loss of rank, assumes an upper rank
`r0` and probability of loss at most `2^r0*theta`, and concludes expected
harmonic loss at most `H_r0*2^r0*theta`.

## Adaptive survival theorem

`adaptive_rank_survival` quantifies over every finite sample type, every
rational probability vector, every rank process, and every bad-space process.
Its explicit hypotheses are:

1. Nonnegative weights summing to one.
2. A monotone potential `H : Nat -> Rat`, with `H(0)=0` and `H(r0)>0`.
3. Root rank exactly `r0` and terminal rank at most `r0`.
4. Nonnegative `theta` and `K`, with `K*epsilon <= 1`.
5. At every step before depth `s`, bad-space probability at most `epsilon`.
6. At every such step, expected potential loss at most
   `3*theta + K*theta*Pr[bad]`.
7. `8*s*theta <= H(r0)`.
8. A terminal detection probability that is nonnegative at extinction and
   at least one half whenever the terminal rank is positive.

The conclusions are extinction probability at most one half and mean
terminal detection at least one quarter. The theorem does not assume these
conclusions or independent bad events. Intermediate ranks need not be
independent of orientations, lifts, or one another.

For the manuscript, instantiate `H=harmonic`, `K=H(r0)*2^r0`, and the full
sample type with paths. The two local harmonic theorems justify the expected
drop hypotheses once the geometric rank-loss estimates are supplied. Uniform
genericity and fresh incoming orientation justify the bad-space hypothesis.
The manuscript starts at a generic space, so its root bad probability is zero.
Its floor depth satisfies the stated rational budget.

The formal theorem does not itself construct the quadratic block, prove
finite-field genericity, or build the recursive path distribution. Those
connections require the other algebraic results and the mathematical proof.

## Injection enlargement

`probability_union_bound` proves the union bound for arbitrary finite families
of events. `injection_failure_bound` assumes at most `2^b` events, each of
probability at most `1/(4*2^b)`, and concludes failure probability at most
one quarter. For the manuscript these are the events `L(b') in S_perp`,
indexed by nonzero `b'`; the rank condition `r >= b+2` supplies the marginal
bound. The theorem does not assert or assume that a union of events is
independent.

`copy_average_detection` assumes failure probability at most one quarter,
nonnegative detection on failed copies, and detection at least one quarter
on each successful copy. Its conclusion is mean detection at least `3/16`.
This is stronger than the required `1/8`. The formal source does not prove
the particular counting formula for uniform linear injections.

## Actual linear and quotient algebra

`common_extension_map` works over every field and arbitrary vector spaces.
It takes a surjective linear aggregate `aX : T -> X`, a second linear
aggregate `aB : T -> B`, a linear family of output characters, and a linear
family of forms on `T`. On `ker(aX)` the two families agree after `aB`.
It constructs one **linear family** `gamma : S -> X*` satisfying

    forms(z)(t) = gamma(z)(aX(t)) + characters(z)(aB(t))

for every `z` and every `t`. The common extension map is the conclusion,
not an assumption; there is no separate map for each outgoing child. The
proof uses a linear section of the surjective aggregate, whose existence
is proved by Mathlib. The theorem is not restricted to characteristic two.

`shift_kernel_descent` works over arbitrary abelian groups. It assumes
surjective quotient and translation maps, an injective inclusion of the
shift group, the exact equality of the quotient kernel with the included
zero-translation shifts, and compatibility of the shift diagrams.
Given a nonlinear equivariant function on the input group, it proves that
the output-translation embedding is injective and constructs a descended
function on the quotient with the same equivariance. It does not merely
assume a descended function exists.

Uniform-input pushforward and character detection through this quotient
are explained in the mathematical proof; their finite counting statements
are not encoded in this declaration.

## Evidence boundary

The official Lean run is attached only to `C_LATENT_COMPOSITION_CORE`.
All listed theorems quantify over arbitrary dimensions, ranks, depths,
weights, maps, and sample types satisfying their stated hypotheses.
No finite diagnostic is used in their proofs. No custom axiom, proof hole,
or `native_decide` is used. Printed axiom dependencies are the standard Lean
logical axioms.

This is a formal core certification, not a claim that the whole latent
existence theorem, all its finite-field instantiations, the Unique Games
Theorem, originality, or publishability has been checked by the Lean kernel
or an independent Reviewer.
