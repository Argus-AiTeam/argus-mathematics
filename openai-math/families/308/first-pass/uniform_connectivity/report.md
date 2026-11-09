# Uniform signed invariants and multiplication cofibers

## Scope and result

The target is `05-connectivity.tex`, especially `conn:stable-elements`,
`conn:symmetric`, `conn:restriction`, and `conn:estimate`, in the staged
September 23, 2026 manuscript *Finite Smith--Toda Complexes at Varying
Primes*. The multiplication map is the map induced by
`Sigma_(k-1) -> Sigma_k`, not a transfer and not multiplication by `k`
on the bottom cell. Degrees below are ordinary cohomological degrees
relative to the virtual Thom rank `kd`.

The following parameter-uniform calculation verifies the invariant and
restriction mechanism in prose. Its implementation and formal coverage
are specified separately below; finite computations are not its proof.
No error in the literal targeted assertions has been established.

The whole-module equivalence `universal:whole-module` is an input, not a
consequence of this calculation. Consequently the application to
`K_p^a(p lambda + delta)` is conditional on that equivalence and on its
stated finite positive-mass filtration. Neither manuscript's main
existence theorem is certified here.

The strongest prior result relevant to the fixed-height companion is
Angeltveit, arXiv:2610.23215v1, Theorem 1.1: `V(4)` exists at every
prime at least 11, and the sphere class `v_4` survives for primes at
least 7. The primary-source statement was read at
<https://arxiv.org/html/2610.23215v1#S1.Thmtheorem1>.
It is a stronger independent existence result than the companion's
prime-1009 conclusion. It does not verify the companion proof, imply
arbitrary-height existence, or supply a growing-arity estimate.
The inherited Wiki has no Smith--Toda or connectivity-specific result
that can replace this input.

A targeted literature search also located Mann's *The Cohomology of
the Symmetric Groups* (1978), but the publisher PDF returned HTTP 403.
No proposition in that unavailable paper has been attributed or used
in this proof. A search summary is not a source verification.
Classical symmetric-group calculations make an unqualified novelty
claim especially inappropriate; novelty of the endpoint calculation
has not been established.

## Theorem: the complete invariant and restriction calculation

Let `p` be an odd prime, `0 <= k < p^2`, and `k = lp+b`, where
`0 <= l,b < p`. Put `D=2(p-1)` and

```
U = F_p[x] tensor exterior(y),  |x|=D, |y|=D-1,
V = ker(U -> F_p).
```

In the displayed presentation `x=xi^(p-1)` and `y=eta xi^(p-2)`.
All permutation actions on tensor products include Koszul signs.

1. For trivial coefficients,
   `H*(Sigma_k; F_p) = (U^tensor l)^Sigma_l`.
2. For sign coefficients the cohomology is zero if `b>=2`.
   If `b=0,1`, it is the sign-isotypical subspace of
   `W^tensor l`, where a homogeneous basis of `W` consists of
   ```
   a_j = eta xi^((p-3)/2 + j(p-1)), degree p-2+jD;
   c_j = xi^((p-1)/2 + j(p-1)),     degree p-1+jD,  j>=0.
   ```
   The sign is the sign of permutations of the `l` blocks, in addition
   to their Koszul action.
3. If `b>0`, restriction to `Sigma_(k-1)` is an isomorphism for
   trivial coefficients. If `b=0` and `l>=1`, restriction is
   `id^tensor(l-1) tensor epsilon`. There is a natural decomposition
   ```
   (U^tensor l)^Sigma_l
       = direct_sum_(r=0)^l (V^tensor r)^Sigma_r
   ```
   under which restriction is the identity on the summands `r<l`
   and zero on `r=l`. In particular it is surjective; its kernel
   is `(V^tensor l)^Sigma_l`, with no factor `l` or `k`.

This last split restriction theorem holds for any split graded module
`U=R.1 direct_sum V` over any commutative ring, with an even unit
and the Koszul action, for every `l`. It does not require division by
`l!`. The restriction `l<p` is needed for the symmetric-group
Sylow calculation, not for the split restriction theorem.

### Proof: stable elements, including twisted coefficients

The translation subgroup `H=(C_p)^l` is Sylow because
`v_p(k!)=l`. Its normalizer quotient is
`((F_p^*)^l semidirect Sigma_l) times Sigma_b`, of order prime to
`p`. Restriction is injective by transfer, since the Sylow index is
a unit. Every proper subgroup `L<H` is a vector subspace and has a
linear retraction. Its cohomology, with the restricted one-dimensional
coefficient line, is therefore a restriction of a class over `H`.
The projection formula makes `tr_L^H` zero: its value on such a
restriction is `[H:L]` times the original class. In the double-coset
formula all proper intersections consequently contribute zero.
The other terms sum the normalizer action, including its action on
the coefficient line. On normalizer invariants this is multiplication
by `|N/H|`, a unit. Thus every normalizer invariant lifts.
This proves `conn:stable-elements` without assuming that arbitrary
group intersections are coordinate subspaces.

The standard two-periodic resolution of `C_p` gives
`exterior(eta) tensor F_p[xi]`, in degrees 1 and 2. A multiplier
acts with the same weight on `eta` and `xi` (inverting both weights
changes none of the conclusions). The sign of `t -> ut` on `F_p`
is `u^((p-1)/2)`: apply the permutation to the nonzero Vandermonde
product and use `u^(p(p-1)/2)=u^((p-1)/2)`.
A block transposition has sign `(-1)^p=-1`.
Multipliers separately on each block now give exactly `U` or `W`.
A transposition among unused letters kills all sign invariants when
`b>=2`. This proves assertions 1 and 2, including both sign actions.

For clarity, the cyclic resolution is exact over
`F_p[C_p]=F_p[t]/(t^p)`, with `t=g-1`: its alternating maps are
`t` and `t^(p-1)`, whose kernels are respectively the images of
the other map. Applying `Hom(-,F_p)` makes both differentials zero.
The periodicity class gives the degree-two generator; the
Bockstein of the degree-one class is its nonzero degree-two
multiple, as seen by lifting this resolution to `Z/p^2`.
Naturality gives the same multiplier weight in both degrees;
graded commutativity kills the degree-one square since `p` is odd.

### Proof: restriction and its normalization

For `b>0`, choose the fixed letter outside all translation blocks.
The two symmetric groups have the same Sylow subgroup and the same
normalizer invariants with trivial coefficients. Further restriction
to that subgroup is the identity, so restriction is an isomorphism.

For `b=0`, fix a letter in the last block and take the first `l-1`
translation blocks as the target Sylow subgroup. Restriction on
Sylow cohomology is augmentation of the last tensor factor. Its
restriction to normalizer invariants is the required map.

Expand `U^tensor l` using `U=R.1 direct_sum V`. For each `r`,
the summands with precisely `r` nonunit slots are indexed by
`r`-element subsets of the slots. An invariant is determined by
its component at the first `r` slots, which is an invariant in
`V^tensor r`; the complement acts trivially. Conversely, move this
component, in its relative order, to every `r`-subset and sum.
Moving past the even units has sign one; the possible different
choices within the occupied slots agree precisely by Koszul
invariance. This proves the claimed decomposition over any ring.

Augmenting the last slot discards just the subsets containing it.
For `r<l` the surviving sum is exactly the corresponding orbit sum
on `l-1` slots, with coefficient one, not a normalized average.
For `r=l` nothing survives. This proves assertion 3.

## Sharp endpoints and the manuscript's bounds

For an ordered homogeneous basis, the invariants of a tensor power
have a basis indexed by multisets of basis letters, with no repeated
odd letter. A repeated odd letter has a stabilizing transposition
acting by `-1`, forcing its coefficient to vanish since `2` is a
unit. Otherwise the signed orbit sum has coefficient one at its
ordered word, is nonzero, and determines every invariant on its
orbit. For sign-isotypical invariants, reverse the rule: no repeated
even letter, while odd repetitions are allowed. These statements
require no averaging or comparison between different characteristics.

It follows that for sign coefficients with `b=0,1` the exact first
degree is `l(p-2)`: the tensor `a_0^tensor l` survives, because
the Koszul and block signs cancel.

For `l>=1`, the exact first degree of the kernel of even restriction
is

```
l D - 1 = 2l(p-1)-1.
```

Indeed an orbit basis word in `V^tensor l` with `s` odd letters
has degree at least
`l D + D s(s-1)/2 - s`: the odd letters have distinct indices,
and every even nonunit letter has degree at least `D`.
This expression has its unique minimum at `s=1`, namely `lD-1`,
because `D>=4`. The orbit sum with one `y` and `l-1` copies of
`x` realizes it. This sharpens the manuscript's safe lower bound
`l(2p-3)` by `l-1`. It is an exact algebraic endpoint, not a
claim that a previously unknown symmetric-group cohomology result
has been discovered.

The complete Hilbert series are equivalently the coefficients of
`t^l` in the following formal products (only finitely many letters
contribute in each degree):

```
trivial:  product_(j>=0) (1+t z^((j+1)D-1))/(1-t z^(jD))
kernel:   product_(j>=0) (1+t z^((j+1)D-1))/(1-t z^((j+1)D))
sign:     product_(j>=0) (1+t z^(p-1+jD))/(1-t z^(p-2+jD))
```

The `sign` product applies only to `b=0,1`. These series also record
the restriction decomposition: the trivial series is the kernel
series divided by `1-t`.

For the specified Thom multiplication map, both source and target
have rank `kd`. Its cohomology map is the restriction just computed.
The cofiber long exact sequence therefore identifies cofiber
cohomology with the same-degree kernel, not its suspension.
An odd Thom power is zero if `b>=2`; otherwise its exact first
degree is `kd+l(p-2)`. For even `d`, a positive-arity cofiber is
zero if `b>0`; if `b=0` its exact first degree is
`kd+2l(p-1)-1`. The case `k=0` is `T_(p,0)=S^0`.

Here the passage from cohomology to spectra uses standard topological
inputs: the virtual Thom cellular filtration has cells in degrees
`kd+j` for `j>=0`; these spectra are bounded below and have
degreewise finitely generated `Z_(p)` homology; and the first
nonzero stable homotopy group maps isomorphically to integral
homology. These inputs are not proved by the algebraic programs.
Over a field, homology and cohomology vanish in the same range.
The universal coefficient sequence and finite generation then
give integral homology vanishing by Nakayama's lemma. First
nonzero stable Hurewicz gives the homotopy claim, and detects the
nonzero endpoint as well. This argument works for negative `d`;
it never asserts that a virtual bundle is globally trivialized
by one ordinary suspension.

The primary topological references read for these inputs are
May, *A Concise Course in Algebraic Topology* (1999),
ISBN 9780226511832, Chapter 23 section 5, p. 195 (the oriented
Thom isomorphism), and Chapter 15 section 1, p. 118 (Hurewicz
for spaces). The author PDF and short proposition-specific
excerpts are in `literature/`. Neither source proposition is
misquoted as a theorem about unoriented virtual bundles or spectra.
The extension here can be seen directly: over a base cell the
virtual permutation sphere is an ordinary sphere of rank `kd`;
the relative cellular chains glue by its determinant character
`sgn^d`, so they are exactly the rank-translated bar chains with
that local system. This works over each finite skeleton and
stabilizes as a bounded-below cellular spectrum, even for
negative rank. A finite group has a bar model with finitely many
cells in each degree.
For stable Hurewicz, the fiber of `S -> HZ` is 1-connective.
Smashing this fiber with an `m`-connective spectrum is
`(m+1)`-connective, so `pi_m X -> H_m X` is an isomorphism.
These are prose arguments in stable topology, not Lean declarations.

For `k<=Cp` and `p>C`, `l<=C` and `k<p^2`. In the odd
nonzero cases, `l(p-2)=k-(2l+b)>=k-(2C+1)`.
For even positive arity and `b=0`,
`l(2p-3)=2k-3l>=2k-3C`.
Together with the vanishing cases and `k=0`, these are precisely
the bounds in `conn:symmetric`, for every integer `d`.

## Conditional application to the universal module

Assume the whole graded-module equivalence `eq:whole-module`,
the generator spheres and weights specified in `04-universal.tex`,
and its bounded positive-mass filtration. Fix `a`, `lambda`, and
`delta`; write `gamma=p lambda+delta`,
`C=max(0,sigma(lambda))+abs(sigma(delta))+1`, and
`N=2^(a+1)-1`. A summand at weight `gamma` has multiplicities
`k_(j,S)` with

```
sum k_(j,S) gamma_(j,S)=gamma,
0 <= k_(j,S) <= sigma(gamma) <= Cp.
```

Positive integral mass proves this bound and finiteness of the
summand set, including when some ordinary sphere degrees are
negative. An unsupported weight contributes zero.
For `r=|S|>0` the factor is the extended power of a sphere of
degree `d(gamma_(j,S))-r`; for `r=0` it is the specified
multiplication cofiber. Additivity of `d`, connectivity under
tensor products, and the preceding estimates give the relative
bound

```
sum [-r + (r odd ? 1 : 0) + (r=0 ? 2 : 0)] k_(j,S) - E,
E=N(5C+1).
```

This includes zero multiplicities. There are exactly `N` variable
types, not a prime-dependent number of types. The individual losses
are at most `2C+1` or `3C`; `E` bounds their total independently
of all multiplicities. For every integer `r>=0`,

```
-r + (r odd ? 1 : 0) + (r=0 ? 2 : 0) >= 2(1-r).
```

Since `nu(gamma_(j,S))=1-r`, the bound is at least
`2nu(gamma)-E`. The filtration at this one prime and this weight
has finite length at most `sigma(gamma)`. Extension closure
therefore gives the same bound on the unfiltered module.
Uniform filtration length in `p` is not used.
This establishes `conn:estimate` conditional on its explicitly
separate model input; it is not a deduction from fixed-weight
equivalences alone.

For any fixed suspension `s` and `m> -nu(lambda)`, subtracting
the requested degree gives

```
2p(nu(lambda)+m) + 2nu(delta)-2m-E-s,
```

which is positive for all sufficiently large `p`.
Thus the degree-gap argument is uniform at each fixed lattice
index and each fixed `s`, without intersecting infinitely many
large sets. The further module pairing in `conn:k-test` also
requires the arbitrary-coefficient `layer:comparison` and its
finite-module action compatibility; these are left open.

## Evidence boundary

| Claim | What is established here | What is not established |
| --- | --- | --- |
| `C_UC_SPLIT_FORMAL` | Universal coefficient-model theorem, checked by Lean | Its interpretation as tensor products is a separate prose bridge |
| `C_UC_SYMMETRIC`, `C_UC_SHARP` | All-parameter invariant/restriction and virtual-degree proofs in prose | Group cohomology and spectra are not formalized |
| `C_UC_WEIGHT_IMPLICATION` | The implication from the exact model hypotheses to the uniform bound | Existence of those models |
| `C_UC_ESTIMATE` | Its combinatorial and connectivity inference is verified conditionally | `universal:whole-module` remains an open dependency |
| `C_MAIN_VARYING`, `C_MAIN_FIXED` | Main dependency chains extracted and recorded | Either manuscript's complete proof |

`formal/Main.lean` proves the occupied-slot equivalence for every
natural arity, every homogeneous alphabet (possibly infinite), and
every commutative coefficient ring. It constructs finite support,
signed permutation transport, a direct-sum equivalence, the exact
augmentation conjugacy, a linear section, and the full-occupation
kernel equivalence. There is no factorial or characteristic
restriction. The compiler and axiom audit both exited zero using
Lean 4.31.0, with `proof_holes=[]`; the immutable certificate is
`formal/evidence/certificates/C_UC_SPLIT_FORMAL-391717346b7e61fd.json`.
Its separate fidelity document specifies every declaration and
the remaining tensor-product bridge.

The bridge needed for this application is elementary but not hidden:
for the free homogeneous basis of `U`, sending a word
`(a_1,...,a_l)` to the elementary tensor of those basis vectors
identifies fixed-length finite-support words with `U^tensor l`.
These elementary tensors form a basis, also for an infinite alphabet,
because each algebraic tensor has finite support. Adjacent swaps
have exactly the source's Koszul signs. Last-factor augmentation
keeps just the words whose last letter is the even unit, with
coefficient one. Thus the compiled coefficient model is the free
graded tensor model used by the normalizer calculation. This
equivariance and tensor-basis identification are proved here in
prose, not as Mathlib tensor-product equivalences.

`verify.py` uses only the Python standard library. It independently
enumerates signed adjacent-swap orbits, checks the odd stabilizer
obstructions and all coefficient-one restriction images, tests
virtual degrees of both signs, and constructs explicit examples with
every multiplicity growing as `p` or `p+1`. The 35 finite invariant
models include `l>=p` cases as tests of the abstract splitting only,
explicitly not as symmetric-group cohomology calculations.
`exact_certificate.json` records these finite experiments separately
from the universal theorem.
The default script checks the existing real compiler record against
the unchanged source and fidelity hashes; it does not pretend to run
a fresh compiler. A fresh universal proof replay uses the official
command in `formal/statement_fidelity.md`.

The Jacobian sidecar performed one bounded operation,
`matrix.nullspace.compute`, on the two-slot signed and sign-twisted
constraint matrix. Its request, typed output, server version,
protocol and adapter status are preserved in dedicated JSON files.
The exact rank and nullity are both nine; the returned basis is
independently checked over the rationals and its constraint rank
over the seven tested odd prime fields. This is an auxiliary exact
sign check, never evidence for a universal quantifier by itself.
Independent Reviewer assessment, literature attribution, and
campaign-level novelty/significance remain outstanding.

Replay the standalone certificate from the campaign root:

```sh
python3 research/uniform_connectivity/verify.py
```

The moving-weight theorem is strictly an improvement in verified
coverage over a finite experiment: the signed coefficient mechanism
is proved for all arities and characteristics by Lean, and the
source-specific topological proof is parameter-uniform in prose.
It is not a claim of a newly discovered all-height construction.
