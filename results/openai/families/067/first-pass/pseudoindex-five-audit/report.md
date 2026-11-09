# Pseudoindex-five characteristic-number audit

## Scope and source findings

The target is the implication from the actual universal-family hypotheses in
the staged September 25, 2026 manuscript to
`3 S^2 - 20 S D + 32 D^2 = 0`, not the complete Campana--Peternell
conjecture. Here `F=e^{-1}(x)`, `L` is the tangent-map polarization,
`S=integral_F c1(T_F)c1(L)^2`, and `D=integral_F c1(L)^3>0`.
Independent Reviewer certification is pending.

The sources below are in
`research/openai_manuscript/The-Campana-Peternell-conjecture-in-dimension-six-September-25-2026/build/`.

| Source and locator | Actual assertion and audit boundary |
|---|---|
| `sections/01-introduction.tex`, `thm:main` | The full sixfold classification is stronger than the present numerical implication. |
| Introduction, Kanemitsu 2016, Theorem 0.2 | The manuscript uses classification for `rho(X)>n-5`; its sixfold application is `rho(X)>=2`. This is an external assumption, not a result of the finite calculation. |
| Introduction, Watanabe 2021, Theorem 2.4 | The manuscript attributes the pseudoindex-four sixfold case to prior work. This is outside the present numerical audit. |
| `sections/02-minimal-curves.tex`, `prop:minimal-family` | Smooth proper evaluation, connected evaluation fibres, a smooth projective-line fibration, and **every-member** splitting `T_e|C=O(-1)^3` are needed. A statement only for general members would not justify descent. |
| `sections/02-p1-cohomology.tex`, `lem:p1-involution` | Rational Leray--Hirsch and relative GRR give the involution and the product rule without a vector-bundle presentation of the fibration. |
| `sections/04-characteristic-classes.tex`, `lem:shifted-descent` | The actual degree-one bundle `A=e^*(-K_X) tensor (T_pi^dual)^2` has `c1(A)=h+2 ell`. Thus base change, not a fictional line bundle of class `h`, is used. |
| Same section, `lem:constant-hodge` | Triviality of the Hodge bundles uses smooth projectivity, completeness, simple connectedness, and the global invariant-cycle/fixed-part theorem. Constant monodromy alone, over an arbitrary noncomplete base, would not be a sufficient substitute for that argument. |
| Same section, `eq:grr-vanishings` | The two positive-degree direct-image vanishings are additional geometric input, not consequences of the tangent-sequence polynomial identities alone. |
| Same section, `eq:product-factorization` | The nonlinear step requires `H^2(X,Q)=Q h_X`, the projection formula, and the nonzero common normalization `D integral_X h_X^6`. |
| `sections/05-arithmetic.tex`, `lem:finite-ratio` | This is an exact rational assertion about explicitly defined matrices. A finite-field rank or a passing supplied script alone is not an independent proof of the geometric implication. |

The project Wiki index contains no entry for Campana--Peternell,
pseudoindex, Kanemitsu, or Watanabe. No earlier mathematical result for this
campaign is present in the starting ledger: its only claim is the original
audit objective `C9000067`. Existing identities will be preserved.

## Independent derivation, before reading the supplied implementation

This section was written from the geometric definitions and generating
functions, before opening `verification/verify.py`.

Give divisor classes weight one. On `U`, set
`h=e^*c1(T_X)/5`, `c=c1(T_pi)`, `ell=2h-c`, and `E=T_e`.
Let the roots of `E` be `a_1,a_2,a_3` and put `b_k=a_k+h`.
The elementary symmetric polynomials of the `b_k` are `r,s,t`.

### Projective-line integration and descent

Over rational cohomology every class has the unique form `a+c b`, with
`a,b` pulled back from `V`, and `pi_*c=2`. Relative GRR for `O_U`
gives `pi_*c^2=0`, so `c^2` is pulled back. Consequently the map
`c -> -c` is a ring involution, fixes pulled-back classes, and sends
`h` to `ell-h`. Writing `delta=pi^*pi_*` gives

```
delta(alpha) = (alpha - bar(alpha))/c
delta(alpha beta) = delta(alpha) beta + bar(alpha) delta(beta).
```

The quotient notation here denotes the identity obtained from the unique
decomposition; no inverse of a cohomology class is used. In particular

```
delta(h^m) = sum_{k=0}^{m-1} h^k (ell-h)^(m-1-k),
delta(c^m) = (1-(-1)^m)c^(m-1).
```

The all-member splitting makes `E tensor A` trivial on **every** fibre,
where `c1(A)=5h-2c=h+2ell`. Base change and fibrewise evaluation give
`E tensor A = pi^*B`. The roots `b_k` are the roots of `pi^*B` minus
`2ell`, proving that `r,s,t` descend.

### Power sums and tangent sequences

Define `p_m=sum_k b_k^m`, including `p_0=3`. Newton's identities give

```
p_1=r, p_2=r^2-2s, p_3=r^3-3rs+3t,
p_4=r^4-4r^2s+2s^2+4rt,
p_m=r p_(m-1)-s p_(m-2)+t p_(m-3)  (m>3).
```

The unshifted power sums are independently obtained by the binomial theorem:

```
q_m = sum_{j=0}^m binomial(m,j) p_j (-h)^(m-j).
```

If `x_m=e^*(m! ch_m(T_X))`, additivity of the Chern character in
the two tangent sequences gives
`q_m+x_m=c^m+pi^*(m! ch_m(T_V))`. Applying `delta` yields

```
D_m = (1-(-1)^m)(2h-ell)^(m-1)
      - sum_{j=0}^{m-1} binomial(m,j) p_j (-1)^(m-j)
          sum_{k=0}^{m-j-1} h^k(ell-h)^(m-j-1-k).
```

Thus `D_1=5`, `D_2=2r-3ell`, and `delta x_m=D_m`.
For `m>=7`, `x_m=0` by `dim X=6`, so `D_m=0` as an
evaluated class. The fixed-order product recursion for base monomials
follows from the preceding product rule.

### Todd and dual-character formulas

For one root write `T(z)=z/(1-exp(-z))`. Formal differentiation gives

```
z (log T)'(z) = z/2-z^2/12+z^4/720-z^6/30240+z^8/1209600+O(z^10).
```

For `Theta(z)=product_k T(z a_k)=sum theta_i z^i`, comparison
of coefficients in `z Theta'=Theta sum beta_j q_j z^j` proves

```
theta_0=1,
theta_i=(1/i) sum_{j=1}^i beta_j q_j theta_(i-j),
psi_i=sum_{j=0}^i (-1)^j q_j theta_(i-j)/j!.
```

Here `psi` represents `td(E) ch(E^dual)`. This independently fixes
the signs, factorials, and the rank-three constant term.
For example `theta_1=c1(E)/2`,
`theta_2=(c1(E)^2+c2(E))/12`, and
`theta_3=c1(E)c2(E)/24`.

### Why the row families integrate to zero

The five cohomological row families have, respectively, these sources:

1. `w(m-h delta m)` descends to the eightfold `V` and has weight nine.
2. `w delta m` likewise descends and has weight nine.
3. Base monomials of weight greater than six vanish on `X`.
4. Their `delta` images vanish, including all polynomial multiples.
5. `D_i=delta x_i=0` for `i>=7`.

For the sixth family, global invariant cycles and relative Hodge--de Rham
degeneration trivialize `R^j e_*O_U` and `R^j e_*Omega^1_(U/X)` over
the simply connected projective base. Relative GRR then gives
`e_*theta_i=e_*psi_i=0` for `i>3`; multiplying by a base class and
integrating is legitimate by the projection formula. Unlike the first
five families, these are integral relations and need not be zero classes.

Finally `e_*G` for an invariant monomial of weight three or four lies
in `H^0(X,Q)` or `H^2(X,Q)=Q h_X`. This yields exactly the manuscript's
selected bilinear products. Amplitude of `L` gives `D>0`, and amplitude
of `h_X` gives `integral_X h_X^6>0`; division by their product is justified.

## Geometric bridges and their hypotheses

The source audit by the separate research agent `cp6-sources` found no
substantive mismatch in the six geometric references it checked. Its
statements, locators, and qualifications are archived in `literature/`.
This was a citation audit, not the required independent mathematical review.

The arbitrary-dimensional setup of Kanemitsu's Proposition 1.6 really does
give the two smooth fibrations and connected evaluation fibres. It does
**not** supply the every-member splitting. Here is that extra argument,
with its dimensions made explicit. For any fibre `C=P^1` and its map
`phi:C->X`, nefness makes `phi^*T_X` globally generated, so the component
of the birational map space is smooth at `phi`. The principal `PGL_2`
quotient and compatible marked universal family give a surjection
`H^0(C,T_U|C)->H^0(C,phi^*T_X)`: any map-space tangent vector is
differentiated in its constant parameter direction along `C`.
The tangent sequence of `pi` is an extension of `O^8` by `O(2)`,
so its middle term has `h^0=11` and `h^1=0`. Also
`h^0(phi^*T_X)=6+5=11` and `h^1=0`. The surjection is an
isomorphism. The evaluation tangent sequence gives
`H^0(C,E|C)=H^1(C,E|C)=0`. A line bundle on `P^1` with both groups
zero has degree `-1`, so splitting into line bundles gives
`E|C=O(-1)^3`. This works for **every** member and does not assume
immersion. Brion--Kannan's verified preprint makes explicit the
normalization of the map space; on this all-free smooth component it
does not change the argument.

Cohomology and base change applied to `E tensor A` now prove descent
globally, not just over a generic open subset. No integral class `h`
and no projective-bundle presentation of `pi` has been assumed.

For the Hodge step, Deligne's invariant-cycle statement uses a nonsingular
compactification of the total space. Here `U` is already smooth projective.
The base is simply connected: the directly retrieved Campana--Peternell
1999 source states both Fano rational connectedness (Theorem 2.11) and
its simple-connectedness consequence (Theorem 5.3.2). Restriction from
`H^k(U,Q)` surjects onto all fibre cohomology. Compatibility with pure
Hodge structures makes each Hodge component spanned by restrictions of
global classes of that type, hence constant in the flat trivialization.
Griffiths's graded-bundle identification, with its filtration convention
reindexed, makes each `R^j e_*Omega^p` holomorphically trivial. The
relative GRR formula is obtained from the Borel--Serre theorem by the
tangent sequence, Todd multiplicativity, the projection formula, and
cancellation of the invertible rational class `td(T_X)`.

The polarization bridge also uses the hypotheses actually present.
For general `x`, smoothness and connectedness of `e` give a smooth
irreducible projective threefold `F`. The proper finite map `F->V_x`
is generically one-to-one, because only finitely many family members
are singular **at** `x`. Thus `F` is the normalization used by
Kebekus. The relevant members are immersed at the marking; the tangent
map is finite, not necessarily an embedding. Its tautological subline
is `T_pi|F`, so
`L=(T_pi|F)^dual` and `c1(L)=-c|F=ell|F`.
Finiteness makes `L` ample and `D>0`. The verified Kebekus and
Brion--Kannan sources are versioned primary preprints; final published
wording was not independently obtained.

Finally Kodaira vanishing and the Lefschetz `(1,1)` theorem, used here
as named standard external results, give
`H^2(X,Q)=Q h_X` from `rho(X)=1`. Thus all scalar pushforwards used
in the product argument really are determined by one number. In particular
`eta_0=1`, `eta_1=S/D`, and `xi_0=1`. None of these geometric statements
is inferred from a modular computation.

No vanishing of the individual higher direct images `R^j e_*O_U` is
assumed. Their alternating Chern character is constant because the Hodge
bundles are trivial. In particular the proof does not silently assume that
the evaluation fibre is Fano, rationally connected, or of Picard number one.

## Exact verification theorem and rational proof format

The verification theorem being certified is the following precise algebraic
implication, with `A`, its monomial order, and its selected coordinates as
defined in Section 4 of the manuscript:

> For any rational vector `v` annihilated by all six row families of `A`,
> if its selected entries are `a xi_i eta_j` with `a!=0` and
> `xi_0=eta_0=1`, then `32-20eta_1+3eta_1^2=0`.

It implies the manuscript's finite-ratio lemma as well. By its definition,
`ker N` is the selected-coordinate image of `ker A` (finite-dimensional
duality over `Q`). Hence any bilinear vector in `ker N` has a lift to
`ker A`; the theorem applies with `a=1`. No particular basis of either
kernel needs to be trusted.

There is a geometric formulation that does not require nefness itself:
the same conclusion holds for smooth surjective morphisms
`pi:U^9 -> V^8` and `e:U^9 -> X^6` between smooth connected complex
projective varieties, with every `pi`-fibre `P^1`, connected `e`-fibres,
and `X` simply connected in the complex topology. Require
`H^2(X,Q)=Q h_X`, `c1(T_X)=5h_X`, degree-one `h=e^*h_X` on every
`pi`-fibre, every-fibre `T_e|C=O(-1)^3`, and nonzero normalizations
`I=int_X h_X^6` and `D=int_F c1(L)^3`, where
`L=(T_pi|F)^dual`. No positivity of these two numbers is needed for the
algebraic implication. The Fano/nef minimal family supplies their positivity
in the audited application. This is a structural criterion, not a
classification of all such pairs of fibrations.

The delivered certificate uses an **exact rational rank sandwich**. It
shares that abstract strategy with the manuscript, but reconstructs the
characteristic formulas independently and uses a separate field-elimination
and slice-intersection implementation. It does not claim that a direct
rational cofactor identity was found.

First, the checker reconstructs `A` and checks over `Q` the two identities
`AK=0` and `NP=0`, where `K` is `581 x 65` and `P` consists of its
129 selected rows. It checks all reduced denominators are units modulo
the prime 10007 and computes the exact modular ranks

| Matrix | A | K | P | N |
|---|---:|---:|---:|---:|
| Rank modulo 10007 | 516 | 65 | 60 | 69 |

A nonzero modular minor is a nonzero rational minor, so modular rank is
a **lower** bound on rational rank. Thus `AK=0` and these bounds force
`rank_Q A=516` and make `K` a full rational kernel basis. Similarly,
`NP=0` forces `rank_Q P=60` and `rank_Q N=69`. Consequently
`ker_Q N=im_Q P`. This identifies the selected image exactly; it does not
assume that an arbitrary modular kernel basis lifts to characteristic zero.

For the cubic step, let `H3` be the rational matrix imposing all 120
double-slice conditions `N v_(i,j,a,b)=0`. It has 8,280 rows and 6,820
columns. The checker computes its modular kernel by successively imposing
slice compatibility. At each step, the kernel of the overlap equation
`A_old u=B_slice w` parametrizes exactly the intersection of the old
solution space with the new slice condition. A full Gaussian kernel basis
is used, not a sample of solutions. The successive solution spaces have
dimensions 60, 163, and 6 inside ambient coordinate spaces of sizes
129, 1,140, and 6,820. All 120 final double slices are also checked.
The slice order puts the six weight-three generators first and reverses
the remaining nine, unlike the supplied implementation.

Reduction therefore gives `rank_Q H3>=6814` and
`dim ker_Q H3<=6`. The other inequality is supplied by **six exact
rational columns**, three product columns
`v_(i,j,a,b)=B_i H_j H_a H_b` and three sparse columns. Their complete
entries are in `exact_certificate.json`, using the manuscript's convenient
candidate witnesses. The checker verifies every rational slice condition,
not the manuscript's claimed rank. It checks that their minor on rows

```
(0,000), (0,001), (1,000),
(5,15 15 15), (7,10 10 15), (7,10 10 10)
```

has determinant exactly `-16/5`. They are therefore a full rational basis
of `ker H3`. These are formal linear-algebra witnesses; no claim is made
that they are realized by varieties.

Finally the checker evaluates

```
Phi = 32 v_(0,000) - 20 v_(0,001) + 3 v_(0,011)
```

on all six basis columns and obtains zero exactly. For any admissible
bilinear vector, multiplication by every `eta_a eta_b` supplies a cubic
kernel vector. On it,
`Phi=xi_0 eta_0(32 eta_0^2-20 eta_0 eta_1+3 eta_1^2)`.
The normalization gives the asserted quadratic. In the actual family,
`eta_1=S/D`, `a=DI!=0`, so multiplying by `D^2` proves
`3S^2-20SD+32D^2=0`.

This proves an implication for **all rational inputs**, not an exhaustive
search through finitely many candidate ratios. Its modular-to-rational
inference uses both the modular upper bound on nullity and the six
independent rational witnesses. A modular no-witness search by itself
would prove none of this. All modular arithmetic is signed 64-bit integer
arithmetic after reduction; the checker enforces
`6820*(10007-1)^2=682818645520<2^63-1` and the corresponding inner-dimension
bound before matrix products. Elimination products have still smaller
bounds. No floating-point ranks or tolerances are used.

Two alternative explicit-identity implementations were explored and then
stopped without a certificate: cubic row-operation elimination suffered
coefficient/fill growth even after lattice reduction, and extended
polynomial-module normal forms had not produced cofactors. Their logs and
candidate generators are retained for reproducibility. The last native
elimination and module processes were deliberately terminated after the
rank-sandwich proof passed (exit 143, not a mathematical failure or a
proof that cofactors do not exist). These implementations are superseded
routes, not counterexamples or exact route exclusions.

The normalization is essential. For example `xi=0` and
`eta=(1,0,...,0)` satisfy every unnormalized bilinear relation while the
quadratic in `eta_1` equals 32. This is a boundary check on a hypothesis,
not a counterexample to the manuscript, which assumes `xi_0=1`.

The independently constructed `q`, `theta`, `psi`, `D`, all 1,785 rows,
all 581 column monomials, and all 129 selected coordinates were compared
coefficient-for-coefficient with the supplied implementation. The current
standalone comparison, `compare_source.py`, passed with exit status zero;
its output is `source_comparison.json`. An earlier reporting-only symlink-path
error is retained in the activity log. The supplied full verifier was not
used as the new certificate's proof.

Jacobian discovery and inspection preceded custom algebra. The executed
`polynomial.ideal.normal_form.compute` check used the exact payload
`jacobian_payload.json`, adapter timeout 45 seconds, and returned
`COMPUTED`, zero remainder, `in_ideal=true`, adapter exit zero, and no
error or timeout. The complete typed output records server 0.14.0 and
protocol 2025-11-25 in `jacobian_output.json`. The subsequently inspected
`lattice.saturation.compute` contract permits ambient dimension at most
32, so it was **not** forced onto a 129-dimensional relation lattice.
Optional local `python-flint` is used only for candidate discovery;
the standalone checker needs SymPy and NumPy but neither Jacobian nor
FLINT. Its tested versions are pinned in `requirements.txt`; the temporary
local FLINT installation was removed after all discovery workers stopped.

## Certification status

The standalone exact verifier passed with assertions enabled, exit status
zero, in 9.6 seconds on 2026-11-05. The invocation was

```bash
env -u PYTHONOPTIMIZE PYTHONDONTWRITEBYTECODE=1 \
  $WORKSPACE/argus-live-update/.venv/bin/python -u \
  research/pseudoindex-five-audit/verify.py
```

Its unmodified JSON output is retained in `verification.log`, and the
durable execution receipt is `verification_receipt.json`. Packaging with
`rank_certificate.py` alone is not validation. Two additional adversarial
software checks passed: changing an annihilator coefficient is rejected
at the exact rational `NP=0` identity, and running with `-O` is rejected
before verification. Their invocation is
`python research/pseudoindex-five-audit/test_verify.py -q`, using the
same explicit interpreter above; the output is `software_checks.log`.

The improvement over the supplied computation is an independently
constructed, rerunnable implication proof connected to every geometric
row family and a source-grounded audit of the all-member splitting,
descent, Hodge, and polarization bridges. The numerical conclusion itself
is the manuscript's, not a stronger classification or an assertion of
novelty. The double-fibration criterion above separates the necessary
geometric inputs from nefness as one way of obtaining them.

External theorems remain explicitly recorded assumptions. The source
reader's primary-source excerpts and judgements are in `literature/`
and the ledger; they are not an independent mathematical Reviewer verdict.
Canonical citation attribution and the compound standard Fano background
assumption remain open for review, as do the explicitly named standard
bundle-splitting, cohomology/base-change, and projective-bundle formulas.
In particular no citation queue,
Lean-kernel closure, novelty, publishable significance, or full sixfold
classification is claimed here. The completed Engineer certificate is
ready for Host-invoked independent Reviewer replay.
