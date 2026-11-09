# Reading of the formal Fourier-field core

The source is `Main.lean`, namespace `FourierAudit`, compiled with Lean
4.31.0 and Mathlib. The claim attached to its compiler result is
`C_FOURIER_CORE`, not the complete unitary-synthesis theorem and not an
end-to-end formalization of the analytic Fourier-field theorem.

## Objects and hypotheses

`star` denotes an involutive ring star; for complex matrices it is conjugate
transpose, not entrywise conjugation. Products are ordered products:
in particular the forward iterate is `D * Z` and the backward iterate is
`star Z * star D`. No commutativity, normality, diagonalizability, or real-entry
assumption is made about `D`.

All truncation lengths, finite alphabets, matrix sizes, coefficients, paths,
and bounded multisets in the declarations below are universally quantified.
The finite alphabet `Fin s` is numbered in the code by `i.val + 1`, exactly
the manuscript's indices 1 through s. Repetition in a multiset is retained.
The prime-field extension is separate from the manuscript specialization.

## Feedback and both ordered Grams

`defect_telescope` proves, in any star ring and for every natural L, the
finite identity

    sum_{j<L} W^j (1-W W*) (W*)^j = 1-W^L (W*)^L.

`forward_defect`, `backward_defect`, `forward_gram_defect`, and
`backward_gram_defect` specialize this to the actual forward and backward
products. The backward defect is Z*(1-D*D)Z, not 1-DD*.
The star-unitarity hypotheses on Z are explicit.

`orthogonal_gram` proves the universal complex coefficient Gram expansion
when the finite sampling weights u obey

    sum_z u(z,i) conjugate(u(z,j)) = delta(i,j).

It does not assume the resulting Gram identity. It assumes the scalar
orthogonality of u; the root-of-unity proof of that hypothesis for the
manuscript is in `report.md`, not in Lean.

`feedback_from_conservation` proves both equations F*F=I and FF*=I and the
exact intertwining identity from VE=O, V*V=I, and the two displayed
conservation Gram expressions. Its use of a finite square F is essential.

`block_feedback_algebra` removes those abstract conservation hypotheses:
for arbitrary finite complex blocks A,B,C,D,Z,X it assumes only
V*V=I for V=[A B; C D], Z*Z=I, and C+DZ X=X. It defines

    F=A+BZ X, E=[I; ZX], R=[I; X F*]

and proves F*F=FF*=I, F E*=R*V, and
B*+D*(X F*)=Z(X F*).

`backward_resolvent_algebra` proves Y=T Z* B* from that last equation,
Z*Z=I and T(1-Z*D*)=I. Existence of X and T from ||D||<1 is
an analytic obligation proved in the report, not a Lean hypothesis silently
asserting their existence.

## Multiset reconstruction and the exact binary modulus

`multiset_newton` evaluates Mathlib's proved Newton identities on an
arbitrary multiset over a commutative ring.
`power_sums_determine_multiset` proves equality of two multisets over an
arbitrary field from equal cardinality at most L, equality of moments
1 through L, and the explicit hypothesis that each integer 1 through L
is nonzero in the field. Thus no characteristic-p inversion is hidden.
It proves equality of the products of linear polynomials using the
recovered elementary symmetric functions and then takes their root
multisets.

`bounded_frequency_injective` uses the rational field instance, the degree
zero moment, and explicit strict integer bounds to lift equal modular
moments back to integers. `power_sum_bound` and `manuscript_no_wrap` prove
those bounds for all internal indices at most 2^n, every degree at most L,
and every multiset of cardinality at most L.

`manuscript_code_injective` proves the actual code's injectivity at

    N = 2^(n*L + Nat.clog 2 (L+1)).

For positive L, `Nat.clog 2 (L+1)` is the integer ceiling of log_2(L+1).
The formal definition uses Nat.clog; its translation to the real-log
notation in the manuscript is not a separate formal theorem in this file.
The formal bound s<=2^n is weaker than the source's k+s<=2^n, so every
source instance is covered without an extra hypothesis.

## Full row support, including signs, cancellation, and ports

`pathBag` is the multiset of all visits of a nonempty finite path.
`pathRow` sums arbitrary complex amplitudes over all paths of lengths
1 through L whose endpoint is the input column and whose bag has the
specified code. It does not presume distinct paths or noncancellation.
`pathRow_support` proves that a nonzero coefficient has at least one such
path. `unique_multiset_row_bound` and `pathRow_card_bound` then prove the
support bound, counting distinct input indices rather than paths.

`fullRow` adds the identity port column at zero frequency.
`fullRow_card_bound` proves that the total row support, ports included,
is at most L for L>=1. `manuscript_fullRow_bound` proves this simultaneously
for the positive code and its negative. Negation acts on the entire
frequency tuple, modulo N. These are respectively the R and E field signs
under the manuscript's positive-phase Fourier basis.

The identification of the manuscript's matrix coefficients with these path
sums is a finite matrix-product expansion given explicitly in `report.md`;
Lean does not encode the exponential characters or prove that bridge.
The arbitrary-amplitude quantifier means the combinatorial result does not
rely on a favorable choice of block entries.

## Compact prime-field extension

`prime_code_injective` proves the same moment-code injectivity in ZMod p
for every prime p with p>L and p>s. `compact_code_exists` uses Mathlib's
kernel-proved Bertrand theorem
`Nat.exists_prime_lt_and_le_two_mul` to obtain such a prime with

    max(s,L) < p <= 2*max(s,L),   L>=1.

`prime_fullRow_bound` proves both signed full-row bounds for that code.
The code is a standard finite-field power-sum construction; no novelty
claim is made about Newton identities, Bertrand's theorem, or power-sum
sets themselves.

## Not compiled here

The following are proved in prose in `report.md` and are not represented as
Lean-checked analytic conclusions: stable resolvent existence and its norm
bound; exponential-character orthogonality; the identification of path
sums with the field Fourier matrices; Loewner bounds from contraction;
Neumann-tail estimates; and the averaged operator-norm intertwining error.
The finite rational/complex probes in `verify.py` are diagnostics only,
not proofs of these universal assertions.

The compiler checks all declarations in this source. The printed axiom
lists are restricted to Lean's standard `propext`, `Classical.choice`,
and `Quot.sound`; there are no project axioms, admitted statements, or
proof holes. Independent review must still check this reading and the
prose-to-formal bridges.
