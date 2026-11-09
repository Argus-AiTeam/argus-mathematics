# Ordinary-to-irrational deformation: mathematical scope

The question is the implication in `deform:colimit` and its application to
`planch:tested-cones`, not the truth of quantum Langlands inferred from
pointwise local equivalences. The staged source is
`research/openai_manuscript/Global-quantum-geometric-Langlands-at-irrational-level-October-4-2026/build/`.
No assertion in this note is an independent verification of the full
geometric hypotheses or a refutation of the main theorem.

## What is already available

Campbell--Dhillon--Raskin, arXiv:1907.03204v2, Introduction Section 1.3,
state the spherical and affine fundamental local equivalences at good
levels; Section 1.3.3 includes irrational levels among good levels.
These are local category equivalences. Section 1.5 separately discusses
factorization. They are not the global, all-configuration deformation
implication being audited here.

Arakawa--Frenkel, arXiv:1807.01536v3, Theorems 2.1--2.3, give concentration
of twisted Drinfeld--Sokolov reductions of Weyl modules, their
irrational-level duality, and irreducibility. They do not prove the
uniform weight assertion for the tested global cone diagrams.

These are scope assumptions, not inputs to a new proof of quantum
Langlands. Their primary-source HTML was obtainable. Independent
citation attribution remains the Reviewer's responsibility.

## Exact logical frontier

The manuscript explicitly requires all of the following:

1. Finite-stage cohomology and transition ranks are constant away from
   roots of unity (`deform:rank`).
2. A single coefficient input admits compatible mixed logarithm lifts,
   including every transition and the logarithm coefficient sequences
   (`deform:colimit`, `deform:stages`, `planch:two-axes`).
3. Ordinary-level tested-cone cohomology has zero filtered colimit
   (`planch:zero-colimit`).
4. In each fixed stalk degree the ordinary-level weights have a common
   upper bound for every pole, label, configuration, and skeletal index
   (`planch:weight-estimate`).
5. Stalk detection and the finite test turn this into an identity of
   kernels (`deform:stalks`, `planch:finite-test`, `planch:identity`).

Items 2 and 4 are actual geometric obligations, not consequences of the
known pointwise equivalences. The main theorem also depends on the
pseudo-identity, localization, period, collision, and central-data
comparisons; those are not independently certified here.

A route already known not to work is to apply the finite rank test
directly to a zero filtered colimit. A zero colimit means that each
class eventually dies, not that any finite-stage complex vanishes.
The manuscript itself states this distinction immediately before
`deform:colimit`. Any tower using multiplication by `q-1` must in
addition meet the mixed-lift and uniform-weight hypotheses before it
can refute that lemma.

## The scalar tower is not an admissible countermodel

Let \(A=\mathbb Q[q,q^{-1}]\) and take the sequential diagram
\[
 A\xrightarrow{q-1}A\xrightarrow{q-1}A\xrightarrow{q-1}\cdots
 \tag{T}
\]
in cohomological degree zero. Each stage is perfect. Its colimit is
\(A[(q-1)^{-1}]\), via the compatible maps taking \(a\) at stage \(i\)
to \(a/(q-1)^i\). At \(q=1\) every transition is zero, so the specialized
colimit is zero. At \(q=2\) every transition is the identity, so the
specialized colimit is \(\mathbb Q\). The number 2 is not a root of
unity: \(2^m>1\) for every positive integer \(m\). Thus (T) really is
an all-index counterexample to *unrestricted* specialization of
filtered vanishing, not merely a bounded experiment.

It does **not** refute `deform:colimit`. Consider the identity
calculation at the unit of \(\mathbb G_m\), with its usual unit
rigidification. Its length-two logarithm fibre is
\[
 V_2=\mathbb Q(0)e_0\oplus\mathbb Q(1)e_1,\qquad
 h e_0=e_1,\quad h e_1=0.
\]
Substituting \(q=\exp(h)\) makes \(q-1=h\) modulo \(h^2\).
In this basis the transition is
\[
 T_2=\begin{pmatrix}0&0\\1&0\end{pmatrix}.
\]
But \(F^0(V_{2,\mathbb C})=\mathbb C e_0\), and
\(T_2(e_0)=e_1\notin F^0\). It is not a morphism of mixed Hodge
structures. Equivalently, it would induce a nonzero morphism
\(\mathbb Q(0)\to\mathbb Q(1)\), which is impossible. The scalar map
\(q-1\) is not established to be a permitted geometric transition
either. Assigning pure weight zero only after specializing at \(q=1\)
does not repair these failures.

There is a useful necessary condition even if one tries to change
Tate weights. Suppose that the quotient by \(h\) at stage \(i\) is
one-dimensional pure Tate of weight \(w_i\), and that the first-order
transition has the nonzero \(h\)-coefficient above. Compatibility with
the logarithm sequence makes its induced map go from weight \(w_i\)
to weight \(w_{i+1}-2\). Hence
\[
                 w_{i+1}=w_i+2,\qquad w_i=w_0+2i. \tag{1}
\]
No uniform upper bound is possible. This is a necessary first-order
condition, **not** a construction of compatible higher logarithm
lifts after Tate twists. In particular it must not be used to claim
that changing weights makes (T) admissible.

This excludes more than the displayed split-fibre choice. Every
ordinary fibre of (T) is one-dimensional over \(\mathbb Q\), so any
rational mixed Hodge structure on it is pure Tate. At length two,
the coefficient sequence is a short exact sequence: the complexes
here are free and concentrated in degree zero. The transition kills
the source \(h\)-ideal and lands nontrivially in the target \(h\)-ideal.
It therefore factors as a nonzero mixed morphism from the source
quotient to the target ideal, forcing (1) even for nonsplit
length-two extensions. Thus no compatible mixed enhancement of
this same rank-one tower can have the required uniform upper
ordinary-fibre weights.

The Jacobian operation `matrix.symbolic.rank.compute`, inspected
before execution, is used only for the finite algebraic move
\(\operatorname{rank}_{\mathbb Q(q)}[q-1]=1\). Its exact typed payload
and complete adapter result are separate JSON files. The all-index
localization and mixed-Hodge nonadmissibility arguments above are
proofs, not conclusions supplied by that rank operation.

## The configuration arithmetic does not produce a weight obstruction

There is an all-index conditional calculation more precise than a
finite search in the number of marks. Let \(c=n-n'\) be a collision
codimension in \(X^n\). A normal slice is a product of essential
central braid arrangements, of total rank \(c\). Its complement has
\[
 H^k=0\ (k>c),\qquad H^k\text{ pure of weight }2k. \tag{2}
\]
This is a known arrangement result, not a novelty claim. For example,
Dupont, arXiv:1505.00717v2, Theorem 3.1 gives the mixed Leray spectral
sequence, and Theorem 3.7(1) states purity for hyperplane complements.
In an essential central arrangement of rank \(c\), the strata are
affine spaces, so the terms of that spectral sequence have \(p=0\)
and \(0\le q\le c\). This also gives the vanishing in (2).
The argument applies to every rank, not a list of tested ranks.

For completeness, purity and the degree bound can also be recovered
by deletion of a hyperplane. If \(U_{\rm old}\) is the old complement
and \(D\) the induced complement on the new hyperplane, the mixed
Gysin sequence has terms
\[
 H^{k-2}(D)(-1)\to H^k(U_{\rm old})\to H^k(U_{\rm new})
 \to H^{k-1}(D)(-1)\to H^{k+1}(U_{\rm old}).
\]
Inductively the two outside maps are between unequal pure weights and
vanish. The middle term is an extension of Tate structures of weight
\(2k\). The same sequence proves vanishing above the ambient rank,
starting with affine space. Products of blocks add the ranks.

After the manuscript's dualizing normalization \([2n](n)\), a
degree-\(k\) link class has ordinary degree \(k-2n\) and weight
\(2k-2n\). Its contribution to the complex-weight bound is therefore
exactly \(k\). Thus the configuration factor has complex weight at
most \(c\), not merely an unspecified function of \(c\).

Here is the conditional consequence. Suppose the actual separated
bar-input Hecke objects, with the parameter factor replaced by the
unshifted constant complex, have a uniform upper complex weight \(W\)
and a uniform fibrewise upper ordinary degree \(E\). Include fixed
test-chart costs in these two constants. Restoring the configuration
factor, integrating its \(n'\)-point stratum by \(!\), and applying
the skeletal shift \([l]\) give
\[
 \begin{split}
 \text{upper ordinary degree}&\le E+c-2n+2n'-l=E-c-l,\\
 \text{upper complex weight}&\le W+c+l.
 \end{split} \tag{3}
\]
Consequently, a nonzero stalk group in degree \(j\) satisfies
\[
 c+l+j\le E,\qquad
 \operatorname{wt}H^j\le W+c+l+j\le W+E. \tag{4}
\]
Finite sums and extensions preserve this bound. This proves an
all-index propagation statement, conditional on the actual \(W,E\)
and mixed separation. It even gives a degree-independent upper bound
for these pieces. An augmentation target has its own fixed bound,
which can be included by taking a maximum.

Equations (2)--(4) do **not** independently supply \(W,E\) for the
Whittaker diagrams. They show why neither many singleton marks nor
unbounded collision codimension alone supplies the sought
counterexample. The delicate remaining issue is the applicability of
`planch:separation`, `planch:vacuum-weight`, and `planch:satake-degree`
to every actual finite diagram, not the last integer inequality in
`planch:weight-estimate`.

## Primary-source limits of the vacuum comparison

A separate read-only source check of Lin, arXiv:2211.05282v1, found
the following exact statements, without independently reviewing this
mission's proof:

* Sections 8.1.1--8.1.2 define
  \(\mathrm{Poinc}_{?}=\mathrm{PsId}_!\mathrm{coeff}_*^\vee
  \mathrm{PsId}_{\mathrm{Whit}}^{-1}\) and
  \(\eta_{G,\mathrm{Ran}}:\mathrm{Poinc}_{\mathrm{Ran},!}
  \to\mathrm{Poinc}_{\mathrm{Ran},?}[2\delta_G]\).
* Theorem 9.0.2 says: "The natural transformation
  \(\eta_{G,\mathrm{Ran}}\) is an isomorphism."

The corresponding coefficient of the shriek-diagonal kernel is
therefore identified with the appropriate \(!\)-Poincare vacuum
by a kernel-evaluation deduction, after matching the sign and
Whittaker duality conventions. Lin does not prove that the manuscript's
auxiliary-axis Fourier specialization has those conventions.
Quasi-compact bundle support additionally uses boundedness of the
fixed-Cartan \(N\)-bundle image; it is not the literal statement of
Lin's theorem. Nothing here demonstrates a false use of that theorem.

## What is and is not certified

The executable certificate checks the scalar-tower obstruction, its
failure of the length-two mixed-lift test, the necessary weight-growth
identity (1), and the universal degree/weight identities (3)--(4).
It also binds its target to literal hypothesis fragments in the
staged manuscript. It does not convert an abstract model into a
geometric counterexample.

No false manuscript assertion has been established, so no `F_` claim
or `refutes` judgement is warranted by these results. In particular,
neither `deform:colimit`, `planch:weight-estimate`, nor `thm:main` is
refuted. No geometric hypothesis has been replaced by a finite test.

The unresolved mathematical obstruction is now precise: one must
either construct an actual finite Whittaker term or transition that
violates the mixed separation or uniform \(W,E\), or independently
prove those properties for all pole bounds, Satake labels, moving
points, collisions, and skeletal indices. The verified scalar
exclusion and configuration propagation are checkpoints, not a
publishable completion of this campaign. Independent Reviewer replay
and independent citation attribution are still required.

## Passages read for the cited propositions

The following short passages are literature inputs, not evidence that
the actual Whittaker diagrams meet their hypotheses.

* Campbell--Dhillon--Raskin, arXiv:1907.03204v2, Section 1.3:
  "Suppose that \(\kappa\) is good in the sense of Section 3.4.4.
  Then Conjectures 1.3.1 and 1.3.2 are true." Section 1.3.3:
  "a level \(\kappa\) is good if and only if after restriction to every
  simple factor of \(\mathfrak g\), \(\kappa\) is either irrational,
  or a rational level whose denominator is coprime to the bad primes
  of the root system."
* Arakawa--Frenkel, arXiv:1807.01536v3, Theorem 2.1: "For any
  \(\kappa\in\mathbb C\) and any \(\lambda\in P_+\),
  \(\check\mu\in\check P\), we have
  \(H^j_{DS,\check\mu}(\mathbb V_{\lambda,\kappa})=0\) for all
  \(j\ne0\)." Theorem 2.2 assumes irrational \(\kappa\),
  \(\lambda\in P_+\), \(\check\mu\in\check P_+\) and gives
  \(T^\kappa_{\lambda,\check\mu}
  \cong\check T^{\check\kappa}_{\check\mu,\lambda}\).
  Theorem 2.3 assumes the same irrational level and dominant labels
  and says \(T^\kappa_{\lambda,\check\mu}\) is irreducible.
* Dupont, arXiv:1505.00717v2, Theorem 3.1, for a hypersurface
  arrangement in a smooth complex variety, gives
  \(E_2^{p,q}=\bigoplus_{S\in\mathscr S_q(\mathcal A)}
  H^p(S)\otimes A_S(\mathcal A)(-q)
  \Longrightarrow H^{p+q}(U(\mathcal A))\), "and is a spectral
  sequence in the category of mixed Hodge structures."
  Theorem 3.7(1): "Let \(\mathcal A\) be a hyperplane arrangement.
  ... for every integer \(k\), \(H^k(U(\mathcal A))\) is pure of
  weight \(2k\)." Theorem 3.7's proof notes that all intersection
  strata are affine spaces and have only \(H^0=\mathbb Q(0)\).
* Lin, arXiv:2211.05282v1, Section 1.1.1 fixes a smooth proper curve
  over an algebraically closed characteristic-zero field and a
  square root of its canonical line. With the definitions in
  Sections 8.1.1--8.1.2 quoted above, Theorem 9.0.2 states exactly
  that \(\eta_{G,\mathrm{Ran}}\) is an isomorphism.
