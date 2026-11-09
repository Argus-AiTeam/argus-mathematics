# Conditional disjointness and the isolated-sharpness reduction

## Result and scope

The frame-functional and parallel-sum steps in
`lem:transfer-disjointness` admit the proof below without assuming that any
candidate is sharp, that two candidates commute, or that angular multiples of
the embedded input have regular group support. The finite normality required
for the frame is not normality of the entire Stinespring group representation.

This is a **conditional mathematical verification**, not a lattice-factor
counterexample, a verification of the analytic transverse estimates, or a
proof of either manuscript's main theorem. The exact computations certify the
finite-dimensional identities explicitly described below; they do not prove
the infinite-dimensional theorem. The Lean claim is the closed-quotient core
only. Independent review, including statement fidelity, remains necessary.
No false literal manuscript assertion has been established by this work.

Compared with the manuscript's stronger claimed theorem, this is a narrower
verification, not an improvement of arithmetic exhaustion. Its additions to
the proof sketch are the canonical opposite-algebra frame identity, the full
closed-quotient argument, and a compiler-checked nonvanishing/invariance core.

The supplied scope findings were hypotheses, not prior certified results.
The relevant prior mathematical results are Stinespring dilation, the CP
Radon--Nikodym correspondence, and measurable uniformization. The first two
are reconstructed below rather than assumed. The actual statement of
Arveson's Theorem 1.4.2 was read in the primary paper: it is an affine order
isomorphism, not a claim that noncommuting positive operators form a lattice.
The publisher and author-site attempts did not yield the Kechris text, so its
uniformization theorem is retained as an explicit unverified external input.
No failed mathematical route is being silently reused.

## A precise abstract theorem

Let `R` be a countable group with multiplier `alpha`, acting continuously on a
compact metrizable space `Z`. Let `A0` be a unital, conjugation-stable,
uniformly dense subalgebra of `C(Z)`, preserved by this action. In the
manuscript, `A0 = C-infinity(Z)`; finite-place locally constant tests are not
needed at the isolated types.

Let `W` be an `alpha`-projective representation on a separable Hilbert space
`H`. Suppose it is a finite **normal** module over `L_alpha(R)`, written

    H = e L2(B)^k,   B = L_alpha(R)^op,
    W_r xi = xi w_r*,   d = (Tr_k tensor tau_B)(e) > 0.

Let a countable source group `Gamma` act nonsingularly on a standard
probability space `X`, with ergodic diagonal action on `X x X`. Let
`pi(Gamma)` be a projective representation commuting with `W`. Suppose there
is a normal subgroup `R0 <= R` acting trivially on `Z` such that

    N = {pi(Gamma), W(R0)}'

has a faithful finite trace invariant under `Ad W_r`. Suppose `R` has no
invariant Borel probability on `Z`.

For `a = 1,2`, let `x |-> F[a,x] : C(Z) -> B(H)` be weakly measurable UCP
families such that

    F[a,x](r.f) = W_r F[a,x](f) W_r*,
    F[a,gamma.x](f) = pi_gamma F[a,x](f) pi_gamma*.

Covariance holds simultaneously on countable determining sets, hence after
the usual common null-set removal wherever an almost-everywhere version is
intended. Assume the following external descriptive-set-theoretic result:

**Uniformization input.** An analytic relation in a product of Polish spaces
has a universally measurable selector on its projection
(Jankov--von Neumann; Kechris, 1995, Theorem 18.1). This theorem's primary
source has not been independently checked in this mission.

**Theorem.** For almost every independent `(x,y)`, the two maps have no
nonzero common `R`-equivariant CP subordinate. Their angular seminorms on
`A0 tensor H`,

    q_F(sum_i h_i tensor xi_i)
      = sum_ij <xi_i, F(conjugate(h_i) h_j) xi_j>,

admit no common nonzero bounded complex-linear or conjugate-linear scalar
functional. The second assertion remains true after ordinary source
induction, with the hypotheses on measurable induction and decomposability
specified below. If the induced families have everywhere source covariance
and their transverse source pairs form one orbit, it holds on that entire
orbit.

The manuscript supplies the hypotheses through `lem:setup-normal-tensors`,
`prop:setup-induced-algebras`, `prop:links-link`, the stated boundary-pair
mixing argument, and target contraction. **Their validity as lattice
statements is not proved here.** In particular neither finite computations
nor the quotient formalization establish those hypotheses.

## 1. Dilation and equivariant domination

For a UCP map `F`, equip `C(Z) tensor H` with the positive form `q_F`, quotient
its null space, and complete to `K_F`. Left multiplication gives a
representation `rho_F` of `C(Z)`, because
`||rho_F(f)|| <= ||f||_infinity`. The map `V_F xi = [1 tensor xi]` is an
isometry and

    F(f) = V_F* rho_F(f) V_F,
    closure(span(rho_F(C(Z)) V_F H)) = K_F.

The formula

    U_r [f tensor xi] = [(r.f) tensor W_r xi]

is isometric by covariance. Its inverse exists, with the same projective
phase as `W`; hence it defines a covariant projective unitary representation
and `U_r V_F = V_F W_r`. There is no assertion that `U` is normal over
`L_alpha(R)`.

If `0 <=cp G <=cp F`, its form on the same algebraic domain satisfies
`0 <= q_G <= q_F`. It therefore gives a unique positive contraction `T` on
`K_F`. Polarization of

    q_G(rho_F(f) b, c) = q_G(b, rho_F(conjugate(f)) c)

shows that `T` commutes with `rho_F(C(Z))`. Covariance of `G` shows
`U_r* T U_r = T`. Conversely every such contraction gives

    G(f) = V_F* T rho_F(f) V_F.

The positive square roots of `T` and `1-T` show that `G` and `F-G` are CP.
Minimality proves uniqueness. This proves the equivariant CP
Radon--Nikodym statement used here, including its covariance; it does not
claim that the CP order has infima.

The identical form argument for a cyclic vector representation proves that
positive functionals dominated by a vector functional correspond to
positive contractions in the cyclic representation's commutant.

## 2. A canonical regular frame corner, not a regular dilation

Put `b_i = e epsilon_i`, and let

    C = M_k(C(Z) crossed-full-twisted_alpha R),
    eta_F = sum_i V_F b_i tensor epsilon_i,
    phi_F(a) = <eta_F, a eta_F>.

The full crossed product permits the representation `(rho_F,U)`, even when
`U` has singular group parts. It is separable. The frame norm is

    ||eta_F||^2 = sum_i ||e epsilon_i||^2 = (Tr tensor tau)(e) = d.

Its group-and-matrix translates span `(V_F H)^k`, because right translates
of the finite frame span the tracial columns. Angular multiplication then
spans `K_F^k`. Thus `eta_F` is cyclic.

Here is the regular-support issue explicitly. In the bidual of the full
twisted group algebra let `z_reg` be the central support of its regular
representation, so that its `z_reg` summand is `L_alpha(R)`. The group
homomorphism into the full crossed product extends normally to biduals.
Its image `p` of `z_reg` is a projection; it need NOT be central in the
crossed product. On `p` it supplies the normal right action of `B`.
The relation `U_r V_F = V_F W_r`, and normality of `W`, put `V_F H` in
this regular part. No conclusion about `rho_F(f) V_F H` is needed.

Matrix transposition combined with this right action defines a canonical
normal star-antihomomorphism

    theta : M_k(B) -> p M_k(C**) p

whose action on the frame is, for every `A in M_k(B)`,

    theta(A) eta_F
       = sum_i V_F((e A) epsilon_i) tensor epsilon_i.

Indeed component `i` is the sum of right multiplications of `b_j` by
`A[j,i]`. This also checks the opposite-algebra orientation:
`theta(A B) = theta(B) theta(A)`.

Let `q = theta(e)`. Then `q eta_F = eta_F` for every candidate. If
`u in e M_k(B) e` is unitary, use `V_F u*` as a dilation input for
`u F u*`. Since `u* e = e u*`, its matrix-frame vector is
`theta(u*) eta_F`. Consequently

    phi_(u F u*)(a) = phi_F(theta(u) a theta(u*)).

The SAME `q` and `theta(u)` work for every map. The corner unitary
`theta(u) + (1-q)` is a unitary of the full bidual. Inner conjugation by
it preserves every central projection, although `p` and `q` themselves
need not commute with the angular representation. This is precisely why
regular support for angular multiples is unnecessary.

For completeness, the functional encoding is faithful across different
parent maps, not just within one dilation. A dominated functional's
commutant contraction commutes with the full matrix algebra and hence has
the form `T tensor I_k`. It commutes with the angular and group
representations, so Section 1 produces an equivariant CP subordinate.
Conversely such a subordinate produces a dominated frame functional.
The coefficients

    <W_s b_i, G(f) W_t b_j>

are values of that functional on the crossed-product matrix polynomials
`u_s* f u_t tensor E_ij`. These vectors are dense in `H`, so the coefficients
recover `G` uniquely, independently of its chosen dominating map. In
particular a common nonzero subordinate is equivalent to a common nonzero
positive subfunctional. Nonzero cannot be lost on the frame: group
translates of that frame are total.

## 3. Central-component separation

Fix one frame functional of the second family, and let `z` be the central
support of its cyclic representation. The von Neumann algebra `z C**`
is normally isomorphic to that representation's double commutant. The
representation is on a separable Hilbert space, so its predual is
separable.

Write `phi_x^z(a) = phi_x(z a)`. Its norm measurability is not automatic
from weak measurability of `phi_x` and must be justified. The positive
normal ball of `z C**` of radius `d` is Polish in predual norm. The relation

    theta is in this ball,   0 <= theta <= phi_x

is Borel: order is tested on a countable norm-dense subset of `C_+`.
Its norm supremum `n(x)` is upper semianalytic. Uniformization on
`{n > r}`, for each rational `r`, gives universally measurable selections
of norm greater than `r`. Every such selection is at most the maximal
central component `phi_x^z`; conversely that component belongs to the
relation, so `n(x) = ||phi_x^z||`. Choose rational
`r_m(x) < n(x)` with `n(x)-r_m(x) < 1/m`, treating `n=0` separately.
The selections then converge in predual norm to `phi_x^z`, since for
positive differences norm is evaluation at the identity. Thus the
component family is norm measurable on the completed source space.

The fixed source corner unitaries conjugate both components and preserve
`z`. Therefore `||phi_x^z - phi_y^z||` is diagonally source invariant.
Pair ergodicity makes it essentially constant. A measurable map to a
separable metric space cannot have a positive constant distance almost
everywhere on pairs: a countable cover by balls of smaller diameter
contains a ball with positive preimage measure. The components are thus
almost everywhere one fixed functional `theta`.

If `theta != 0`, Section 2 recovers ONE nonzero equivariant CP map `G`
independently of `x`. The source covariance and coefficient uniqueness
make `G` source invariant. Target covariance makes its values commute
with `W(R0)`, so its range is in the finite algebra `N`. Its trace gives

    f |-> tau_N(G(f)) / tau_N(G(1)),

an `R`-invariant probability on `Z`. The denominator is positive by
faithfulness and `G != 0`. This is the required contradiction. Taking
an infinite trace on all of `B(H)` would not justify this step.

Thus `phi_x^z = 0` for almost every `x`, for each fixed second label.
Central orthogonality implies

    ||phi_x - phi_y|| = ||phi_x|| + ||phi_y||.

This norm equality is a Borel relation on pairs, tested on a countable
dense subset of the separable algebra. Fubini therefore gives it for
almost every independent pair. It rules out a nonzero common positive
subfunctional `omega`: otherwise the triangle inequality gives an upper
bound smaller by `2 ||omega||`.

Importantly, norm equality is NOT being identified with disjointness of
the GNS central supports. For example, orthogonal vector states on `M_2`
have that norm equality and the same central support. Only the implication
to absence of a common subordinate is used after Fubini.

## 4. The closed parallel-sum construction with full domains

This section does not require finite modules, pair ergodicity, sharpness,
or commutation between the two maps. Let `F_1,F_2` be any two covariant CP
maps with the same input Hilbert space and covariance operators. On
`D = A0 tensor H` let `j_i : D -> K_i` be the form-completion maps.
Angular multiplication `M_i(f)` is bounded by `||f||_infinity`;
its adjoint is `M_i(conjugate(f))`.

In the Hilbert direct sum form the closed subspace

    L = closure { (j_1 b, -j_2 b) : b in D },
    Q : K_1 direct-sum K_2 -> K = (K_1 direct-sum K_2)/L.

The set before closure is already linear. Its closure is essential.
Each common angular multiplier, each base multiplier, and each target
covariance preserves this subspace AND its adjoint preserves it:
on the dense generating set it is just the corresponding domain
operation. The actions are bounded, so invariance extends through
closure. The subspace is reducing, and all these actions descend.
Let `rho` denote the descended angular representation, extended from
`A0` to `C(Z)` by the uniform bound.

The maps `Q_1 v = Q(v,0)` and `Q_2 v = Q(0,v)` are contractions and

    J b = Q_1 j_1 b = Q_2 j_2 b.

For a common bounded linear functional `ell` on `D`, its two continuous
extensions `ell_i` give the continuous functional
`(v_1,v_2) |-> ell_1(v_1)+ell_2(v_2)`. It vanishes on `L`, and its
value on `J b` is `ell(b)`. Thus nonzero `ell` implies `J != 0`, even
after taking the CLOSED quotient. Conjugate-linear `ell` is handled
by complex conjugation. This is the nonvanishing claim checked in Lean.

Set `T xi = J(1 tensor xi)`. It is bounded, because each `F_i(1)` is
bounded. Moreover

    J(sum h_i tensor xi_i) = sum rho(h_i) T xi_i.

If `T` were zero, `J` would be zero, so `T != 0`. Define

    Psi(f) = T* rho(f) T.

This is a nonzero CP map. The intertwining relations
`Q_i rho_i(f) = rho(f) Q_i` imply that `Q_i* Q_i` is a positive
contraction commuting with `rho_i(C(Z))`. Since `T = Q_i V_i`,

    Psi(f) = V_i* (Q_i* Q_i) rho_i(f) V_i.

Consequently `0 <=cp Psi <=cp F_i` for BOTH maps. Target covariance
descends through the same quotient and intertwines `T`, so `Psi` is
equivariant. This construction needs a common subordinate, not a greatest
lower bound.

If the original maps commute with the common base `L-infinity(Y)`, those
base multipliers and their adjoints preserve the algebraic domain and
the closed subspace. The quotient and `T` intertwine them, so all
`Psi(f)` are decomposable. On separable Hilbert spaces, disintegrate using
countable determining sets of functions, matrix-positive tests, and the
countable group. Off one null set, the fibre maps are CP, covariant, and
dominated by both fibre candidates. Since `T* T != 0`, the nonzero fibre
set has positive measure.

There is no unstated normality assumption on `C(Z)`: it is a C-star
algebra, not a specified von Neumann algebra. Its representations have
their ordinary spectral extensions. If the original CP maps are normal
on a specified larger von Neumann algebra, positivity and domination
also make `Psi` normal: for bounded increasing positive nets the missing
mass of `Psi` is bounded by that of either normal dominating map.

For source induction, the section `s(y)` changes labels simultaneously to
`s(y)^(-1) x, s(y)^(-1) x'`, up to the common source conjugacy. The
homogeneous boundary probability class must be nonsingular under these
translations. The bad uninduced pair set is null; nonsingularity and
Fubini in `(x,x',y)` make its pullback null. A positive-measure set of
nonzero fibre subordinates would contradict Section 3. This proves the
induced form assertion.

Finally the no-common-functional property is invariant under honest
simultaneous source covariance: act on every Hilbert coefficient by the
same source unitary. If the transverse pair set is a single orbit, its
conull subset contains a pair and covariance transports the property to
the entire orbit. Without everywhere-covariant representatives only the
almost-everywhere assertion follows. The manuscript's constructed
candidate continuity is the stated input for this promotion.

## 5. What follows, and what does not, for isolated sharpness

The analytic argument in `prop:transfer-isolated-sharpness` must still
establish this implication: a nonzero ordered product on disjoint target
patches yields ONE nonzero scalar functional which, unchanged by the
independent reverse-radical moves, is bounded by the angular forms at
two generic moved labels. Merely producing different functionals for
different labels would not suffice. The transverse estimate, defect
transfer, window exhaustion, and nonmixed bounded-input extension used
to prove that implication have not been independently established here.

Conditional on that analytic implication, Section 4 excludes every such
ordered product. Regular approximation of the positive operator
measures extends the vanishing to `E(S) F(T) = 0` for disjoint Borel
sets. This extension follows by compact approximation of scalarized
measures and disjoint smooth buffered neighborhoods, then strong
monotone approximation.

For every Borel `S`, unitality now gives

    E(S) = E(S)(F(S)+F(S-complement)) = E(S) F(S),
    F(S) = (E(S)+E(S-complement))F(S) = E(S) F(S).

Thus `E(S) = F(S)` and `E(S)^2 = E(S)`. Both candidates are equal PVMs.
No commutation was assumed before it was obtained. This proves the
conditional sharpness reduction, not its outstanding analytic premise.

## Exact executable evidence

Run `python3 research/boundary_sharpness/verify.py`. Only the Python
standard library is required. The stored certificate is compared with
fresh exact rational computations.

The tests use `R = C_2`, its two-dimensional regular representation in
the diagonal basis, and four target points swapped in two pairs.
They check every local UCP, covariance, singular-support, and CP-order
condition used in the finite examples. They deliberately do NOT have
the lattice, no-invariant-probability, or source-pair-ergodicity
hypotheses, and are not counterexamples or finite verifications of the
lattice theorem.

For noncommuting positive effects `A,B`, the checked formula is

    A:B = A - A(A+B)^+ A.

The script checks its equality to the reversed formula, both domination
inequalities, and the exact completing-the-square matrix identity,
including singular sums. The noiseless example has nonzero products
`E_j F_j` but zero parallel sums; the noisy example has noncommuting
effects and a nonzero equivariant common CP subordinate. Thus neither
``product zero`` nor mutual commutation has been substituted for CP
disjointness. A bounded rational family tests the same identities.

The retained Jacobian request and typed reply certify only the exact
spectra of the two concrete sum blocks used here. Adapter version,
protocol, operation, payload, output, and exit status are retained
separately. The replay checks the reply against rational characteristic
polynomials, not just its `VALID` field.

The Lean source and statement-fidelity document specify exactly the
closed quotient's nonvanishing and invariance claims. A fresh successful
compiler record is required before that source counts as evidence.

## Source locators and external reading

Arithmeticity manuscript, staged September 23, 2026 version:

- `01-setup.tex`, lines 281-440: finite normal model, source transports,
  and finite complementary fixed algebra.
- `02-links.tex`, `prop:links-link`, especially clauses (i), (iv), (v):
  candidate covariances, frame exhaustion, normal ampliations.
- `03-transfer.tex`, lines 503-637: literal disjointness lemma and proof.
- `03-transfer.tex`, lines 650-734: isolated sharpness and the outstanding
  analytic common-functional extraction.

W. B. Arveson, *Subalgebras of C-star-algebras*, Acta Math. 123 (1969),
141-224, DOI `10.1007/BF02392388`, Theorem 1.4.2, p. 159, and the
Stinespring construction, Theorem 1.1.1, pp. 144-145. Primary scan read:
`https://www.isibang.ac.in/~soumyashant/misc/collected-works-of-arveson/1960s/1969_Subalgebras_of_Cstar_algebras.pdf`.
The short exact theorem excerpt is retained in `arveson_excerpt.txt`.
The search service's contrary summary about a lattice was rejected after
reading the paper.

Kechris, *Classical Descriptive Set Theory* (1995), DOI
`10.1007/978-1-4612-4190-4`, Theorem 18.1: publisher access returned 406,
and the author's Caltech page could not be fetched. Its statement above
is an explicit external assumption, not a source-verified citation.
