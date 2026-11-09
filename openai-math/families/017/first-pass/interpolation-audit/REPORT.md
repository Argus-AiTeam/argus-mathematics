# Coordinate-flat obstructions to logarithmic interpolation

## Result and scope

This is an independent written verification of the implication
`geom:multiplicity -> geom:curve-inequality -> geom:interpolation` in
`../openai_manuscript/The-irrationality-exponent-of-pi-is-2-September-24-2026/build/sections/interpolation.tex`.
It also proves a coordinate-flat density extension, stated below. The staged
sources are unchanged. **No false assertion of this interpolation section has
been established.** In particular, the examples below are not refutations of
the manuscript or of its conclusion about pi.

The universal normal-basis algebraic core has a real Lean 4.31.0 compiler and
axiom-audit result: exit code zero and no proof holes. The geometric theorem is
a written proof using the explicitly listed standard results, not a fully
formalized theorem. `verify.py` checks exact hypotheses, symbolic identities,
all branches and poles of the supplied curve examples, and the binding of the
compiler result to the current source and statement-fidelity document.
Its finite regression checks are identified as such.

Independent Reviewer reproduction, statement-fidelity approval, and citation
attribution are still required. Novelty is **not established** by the bounded
literature lookup. This is not a declaration that the campaign has met its
publishable stopping condition, and it does not certify the determinant
estimates or the final irrationality theorem.

## 1. Statements, including every relevant quantifier

Write

\[
 W=(w_0,w_1,\ldots,w_m),\qquad
 V=(v_0,w_1/\theta,\ldots,w_m/\theta),
 \quad 0<\theta<1.
\]

All weights are positive rational numbers. Polynomial degrees use W and
coefficient packets use the **strict** inequality `V.alpha < H`.
For a center \(a_j=(b_j,c_{j1},\ldots,c_{jm})\), with \(b_j\ne0\), the map is

\[
 P\longmapsto
 \left[P\bigl(b_j(1+t),c_{j1}+u_1+\log(1+t),\ldots,
 c_{jm}+u_m+\log(1+t)\bigr)\right]_j.
\tag{1}
\]

The manuscript has \(b_j=1\), pairwise distinct \(c_{ji}\) as j varies for
each i, and

\[
 K\theta^m<1,\qquad K(w_0/v_0)\theta^m<1.                 \tag{2}
\]

Its weights are chosen successively **before** the center locations. After
the weights and centers are fixed, (1) is surjective for every sufficiently
large H divisible by a fixed integer depending only on the weights.
The lower threshold for H may depend on the centers. No finite-degree
rank computation decides this assertion.

Here is the extension proved in this report.

**Coordinate-flat density theorem (`C_K1_FLAT_DENSITY`).** Fix \(m,K,w_0,v_0,
\theta\) with \(K(w_0/v_0)\theta^m<1\). For each nonempty
\(T\subseteq\{1,\ldots,m\}\), fix an integer \(n_T\ge1\) satisfying

\[
 n_T\theta^{|T|}<1.                                     \tag{3}
\]

There are successive weight thresholds depending only on these fixed data,
not on the centers, for which (1) is eventually surjective at every set of K
distinct centers with \(b_j\ne0\) satisfying this condition:
each coordinate flat

\[
 F=\{Y=b,\ X_i=d_i\ (i\notin T)\},\qquad b\ne0,
\]

contains at most \(n_T\) centers. Conversely, if one such d-dimensional flat
contains n centers and \(n\theta^d>1\), (1) is not surjective for any
sufficiently large H, for any choice of positive coordinate weights.
No conclusion is asserted at equality or at equality of the total volume
ratio.

The thresholds can even be chosen without knowing the array \(n_T\):
use the universal integer
\(\lceil\theta^{-|T|}\rceil-1\) in (3). Thus this is a genuinely
center-independent assertion, not a choice of weights after inspecting the
actual center locations.

For comparison with the strongest relevant prior statement, the manuscript
allows only one Y fiber and coordinatewise-distinct centers. The extension
allows different nonzero Y fibers and controlled coordinate collisions, and
identifies an asymptotic obstruction when a coordinate flat is overcrowded.
It does not introduce a new derivative-persistence mechanism.

## 2. Uniform local multiplicity: an independent derivation

Use the full hypotheses of `geom:multiplicity`: polynomials \(f_\ell\) of
positive-rational weighted degree at most N, an irreducible component Z of
codimension k of their common zero set, a commuting analytic frame D with
positive costs, and

\[
 D^\gamma f_\ell|_Z=0\quad\hbox{if }\kappa\gamma<\varepsilon N.
\]

Choose a smooth point of Z away from the other components where the proposed
coordinate normal basis A and frame normal basis B both have rank k.
The map obtained by flowing the k commuting fields in B from a local
parametrization of Z is a local analytic isomorphism: its differential is
invertible by transversality. In these coordinates the selected fields are
the transverse partial derivatives. Thus every transverse monomial of cost
less than \(\varepsilon N\) has identically zero coefficient.

The coordinate A-slice through the point is transverse to Z. The transverse
flow parameters restrict to local coordinates on it; the remaining
parameters become convergent series in them. Substitution cannot decrease
the weight of a surviving transverse monomial. Therefore its restricted
ideal lies in the monomial ideal of cost at least \(\varepsilon N\), giving

\[
 \operatorname{length}(\mathcal O_S/(f_\ell))
 \ \ge\ \#\{\alpha\ge0:\kappa_B\alpha<\varepsilon N\}
 \ \ge\ \frac{(\varepsilon N)^k}{k!\prod_B\kappa_b}.       \tag{4}
\]

For the second inequality, each point of the open positive simplex lies
in the half-open unit cube indexed by its coordinatewise floor; that
index still satisfies the **strict** cutoff. The finitely many admissible,
disjoint unit cubes cover the simplex. Their total volume is their number.
This proves (4) for every \(N>0\), not merely asymptotically.

The restricted ideal is primary to the local maximal ideal. Pick k generic
constant linear combinations of its given generators which still cut an
isolated zero: at each step avoid the finitely many positive-dimensional
components left by the preceding steps. Their smaller ideal has quotient
length at least that in (4), and the combinations still have weighted
degree at most N.

Clear the denominators of the coordinate weights by M and substitute
\(x_a=\lambda_a+z_a^{M\rho_a}\). Choose \(\lambda_a\ne x_a\) at the point.
There are \(\prod_A M\rho_a\) preimages, each unramified, each with the
same local length, and each an isolated zero. Each substituted equation
has ordinary degree at most MN. The isolated-zero Bezout bound gives

\[
 \operatorname{length}\le N^k/\prod_A\rho_a.
\]

Consequently

\[
 \prod_A\rho_a\le k!\varepsilon^{-k}\prod_B\kappa_b,       \tag{5}
\]

which implies the manuscript's weaker factor \(2k!\) bound. This sharpening
is already anticipated by its cube-volume observation and is **not** claimed
as a new result. The proof uses no bound on coefficients, analytic radii,
the component, or N. The use of isolated-zero, rather than proper global
intersection, Bezout is essential.

## 3. What the normal-basis inequalities actually force

Set \(L_0=m+2\) and
\(C_*=\max_{1\le k\le m}2k!(L_0/\sigma)^k\).
Choose successive weights so that

\[
 \prod_A w_a>C_*\prod_B v_b                              \tag{6}
\]

for equal-cardinality sets of size 1 through m whenever the largest positive
differing index belongs to A. This is possible uniformly in the centers:
if that index is i, the ratio is \(w_i\) times an expression involving
only earlier weights and fixed powers of theta. Common higher indices
contribute \(w_j/v_j=\theta\). There are finitely many requirements.

Suppose a persistent proper algebraic component Z satisfies, for every
coordinate and frame normal basis,

\[
 \prod_A w_a\le C_*\prod_B v_b.                           \tag{7}
\]

On \(Y\ne0\), use \(D_0=Y\partial_Y+\sum_i\partial_{X_i}\) and
\(D_i=\partial_{X_i}\). If some positive coordinate direction is
nontangent, take the largest such i and a coordinate normal basis containing
i. Higher positive directions are zero in the normal quotient in both
frames, so occur in no normal basis. A frame normal basis omitting i would
contradict (6)--(7). Hence every frame normal basis contains i.

Equivalently, the remaining frame vectors do not span the normal quotient:
if they spanned it, elementary basis extraction would give a basis omitting i.
Their ambient span is

\[
 Q_i=\{v:v_i=v_Y/Y\}=\ker(dX_i-dY/Y).                     \tag{8}
\]

For completeness, write \(a_0=v_Y/Y\). If v satisfies (8), then

\[
 v=a_0D_0+\sum_{j\ne i}(v_j-a_0)D_j.
\]

Conversely every displayed generator satisfies (8). This verifies the
hyperplane identification in every dimension, not just for the symbolic
three-dimensional example in the certificate. If \(Q_i+T_Z\) is proper,
then \(T_Z\subseteq Q_i\): otherwise one tangent vector outside the
hyperplane, together with the hyperplane, spans the ambient space.
Thus \(dX_i=dY/Y\) on Z.

This forces Y to be constant. Otherwise, through a smooth point with
\(dY\ne0\), cut by algebraic hyperplanes whose tangent intersection is a
line on which dY is nonzero. The component through the point is a smooth
local algebraic curve with nonconstant Y. On its smooth complete model,
the differential identity extends meromorphically. At a zero or pole write
\(Y=s^r u(s)\), \(r\ne0\), with u a unit. The residue of dY/Y is r.
For \(X_i=\sum a_ns^n\), the residue of dX_i is zero: its possible
\(s^{-1}\) coefficient is \(0a_0\). This contradicts the identity.
It also follows that \(X_i\) is constant. These are characteristic-zero
arguments, not a purely matroidal conclusion.

If every positive coordinate direction is tangent, properness makes the
tangent space their span, so dY is zero and Y is constant as well.

In a constant-Y fiber the coordinate and derivative frames coincide.
Two different positive-coordinate basis sets are ordered by their largest
differing index, so (6)--(7) force a **unique** normal basis set S.
For each \(i\in S\), all other coordinate vectors fail to span the normal
quotient. The same hyperplane argument gives \(dX_i=0\).
Thus the component lies in a proper coordinate flat.

`lean/Main.lean` formally proves the hyperplane implication, the invertible
logarithmic shear and its exact inverse, the maximal-index contradiction,
and uniqueness for arbitrary finite positive-index families. Its separate
statement-fidelity document identifies the remaining, nonformalized
geometric steps explicitly.

## 4. The complete original curve inequality

Use exactly the manuscript's hypotheses on sigma:

\[
 (1+3\sigma)^{m+1}K(w_0/v_0)\theta^m<1,\quad
 (1+3\sigma)^mK\theta^m<1,\quad(1+\sigma)\theta<1.          \tag{9}
\]

Let D be the weighted pole degree of an irreducible curve and S its total
weighted branch contact, both on its complete smooth model, as defined in
the manuscript. Assume \(D<(1+\sigma)S\). Necessarily \(S>0\).
Coefficient counting gives, for every sufficiently large N, a nonzero
polynomial \(F_N\) of W-degree at most N and local V-order at least
\((1+3\sigma)N\) at all centers. The ratio of condition count to coefficient
count tends to the first left side of (9), so independence of conditions is
not being assumed.

The commuting frame preserves W-degree at most N. In local coordinates it
is \((1+t)\partial_t,\partial_{u_i}\). A derivative of cost at most
\(\sigma N\) retains order at least \((1+2\sigma)N\). On a branch P this
is at least \((1+2\sigma)Nh_P\), including branches with identically
constant coordinates. Each monomial proves this bound separately.

A nonzero restriction has total pole degree at most ND. The last zero
bound exceeds ND. The zero--pole degree comparison therefore forces every
one of these derivatives to vanish identically on the curve.

Put \(\delta=\sigma N/L_0\). For the zero sets of derivatives of cost at
most \(r\delta\), \(0\le r\le L_0\), choose nested irreducible components
containing the curve, backwards from the last level. Each dimension is
between 1 and m. There are \(m+3\) levels, so some adjacent components
coincide. For the equations at the earlier level, every further derivative
of cost less than delta vanishes on that component. Section 2, with
\(\varepsilon=\sigma/L_0\), proves (7) for **all** its normal bases,
even though the equations and component can vary with N. Section 3 now
forces Y constant. Since the curve meets a center, Y=1 on the curve.

Repeat the argument in that fiber with a polynomial in the m X variables.
The coefficient comparison is now the second inequality in (9).
If m=1, a nonzero polynomial cannot vanish on a curve in the affine line.
For m>1, the persistent component has dimension between 1 and m-1 and
lies in a proper coordinate flat by Section 3. Some coordinate is constant,
so coordinatewise distinctness puts **at most one** prescribed center on
the component and hence on the curve.

Let that center be j. A nonconstant coordinate \(X_l\) on the curve gives
the nonzero rational function \(X_l-c_{jl}\), whose pole degree is at most
\(w_lD\) and whose zero order at the branches of j is at least
\((w_l/\theta)S\). Thus \(D\ge S/\theta>(1+\sigma)S\), a contradiction.
This proves the literal original curve inequality under (9), without
silently strengthening its sigma hypotheses.

## 5. Proof of the coordinate-flat extension

Choose a positive rational sigma small enough that

\[
 (1+3\sigma)^{m+1}K(w_0/v_0)\theta^m<1,\qquad
 (1+3\sigma)^{|T|}n_T\theta^{|T|}<1\quad(T\ne\varnothing).
\tag{10}
\]

Choose weights using the same \(L_0,C_*\), and (6). A hypothetical violating
curve first lies in a constant-Y fiber by the ambient argument of Section 4.
For general centers use \(t=Y/b_j-1\); the frame is still
\((1+t)\partial_t,\partial_{u_i}\), and the residue argument is unchanged.

Suppose the curve lies in a coordinate flat F with free coordinate set T.
Constants have no poles and infinite branch order after subtracting their
center values, so both D and S computed in F equal the original ones.
Prescribe vanishing only at the centers in F. There are at most \(n_T\)
of them. The coefficient comparison in \(|T|\) variables follows from
(10). The derivative-persistence argument uses the same \(L_0\) and \(C_*\);
all of its basis sets are subsets of T, so (6) is inherited without any
new choice of weights.

If \(|T|>1\), a persistent proper component gives a constant coordinate,
putting the curve in a flat with strictly fewer free coordinates. Repeat.
If \(|T|=1\), the constructed nonzero univariate polynomial would vanish
identically on an algebraic curve in the affine line, which is impossible.
Dimension decreases at every repetition, so this is a terminating argument,
not an unverified uniform induction over numerical examples.
The curve inequality with the strict factor \(1+\sigma\) follows.

For necessity, restrict a putatively surjective map to any such
d-dimensional flat and to the target coefficients with t and the fixed
coordinate displacements zero. This is a genuine quotient of the original
target. The image factors through polynomials in the d free coordinates
of weighted degree at most H, of dimension

\[
 \frac{H^d}{d!\prod_{i\in T}w_i}+O(H^{d-1}).
\]

The n target packets have dimension

\[
 n\theta^d\frac{H^d}{d!\prod_{i\in T}w_i}+O(H^{d-1}).
\]

When \(n\theta^d>1\), the target is strictly larger for every sufficiently
large H. This is an eventual obstruction, not a defect at one finite degree.

## 6. Curve positivity really does supply the coefficient packets

Here are the scheme-theoretic details needed for either version of the
curve inequality. Choose an integer R with all \(R/w_a,R/v_a\) positive
integers. Embed affine space by the monomials of W-degree at most R and
take its integral projective closure X, with \(L=\mathcal O_X(1)\).
The chart of the constant monomial is the original affine space: it is
the closed graph of the other monomials, and each coordinate occurs.
At each point of a complete curve model a pure coordinate power or the
constant monomial attains the largest pole. Clearing these local poles
therefore gives
\(\deg(L|_C)=R\deg_W C\), with no cancellation assumption.

At center j put \(t_j=Y/b_j-1\). Replace each logarithm by a Taylor
polynomial G_i with first omitted t-weight greater than \(v_i\), and set
\(u_i'=X_i-c_{ji}-G_i(t_j)\).
The change and its inverse preserve every weighted filtration: every
substituted tail monomial has weight greater than that of the variable it
replaces. Branch contact is preserved because the tail's order divided
by \(v_i\) exceeds \(\operatorname{ord}(t_j)/v_0\); when t is zero
identically the tail is zero identically.

Use the finite-colength ideals
\(I_j=(t_j^{R/v_0},(u_1')^{R/v_1},\ldots,(u_m')^{R/v_m})\),
and the unit ideal off the distinct centers. Their coherent ideal I on X
has an ordinary blowup \(p:X'\to X\), with
\(I\mathcal O_{X'}=\mathcal O_{X'}(-E)\). Put \(A=p^*L\).
The stated standard blowup results apply because X is integral Noetherian
and I is coherent and nonzero.

For a noncontracted curve whose image meets the affine chart, the complete
normalizations identify its degrees with \(R D\) and \(R S\);
the ideal valuation is exactly \(\min_a(R/v_a)\operatorname{ord}z_a\).
A curve over infinity misses E. On a contracted curve A has degree zero
and -E has positive degree by relative ampleness. Thus
\(A-(1+\sigma)E\) is nef on **every** integral curve upstairs.

For some integer a>1, \(aA-E\) is ample: choose b with \(I L^b\)
globally generated and embed the Rees Proj into \(X\times\mathbb P^r\);
the two hyperplane classes restrict to A and \(bA-E\).
Then \((b+1)A-E\) is ample. The exact identity

\[
 A-E=\frac{a-1}{a(1+\sigma)-1}(A-(1+\sigma)E)
       +\frac{\sigma}{a(1+\sigma)-1}(aA-E)               \tag{11}
\]

has two strictly positive coefficients. Ample plus nef is ample for
projective schemes; no smoothness or normality is required.

On a finite affine cover, apply the graded-piece and higher-cohomology
statements to the ordinary Rees algebra, which is Noetherian and generated
in degree one. For all sufficiently large n they give

\[
 p_*\mathcal O(-nE)=I^n,\qquad R^qp_*\mathcal O(-nE)=0
 \quad(q>0).
\]

These are **ordinary powers**, not integral closures, and no small-n
equality is needed. Projection formula, Leray, and Serre vanishing for
the ample \(A-E\) now yield \(H^1(X,I^nL^n)=0\).
Sections of \(L^n\) consequently supply all local classes modulo \(I^n\).
Every generator of I has local weight R, so every element of \(I^n\)
has weight at least nR. Hence these classes surject onto the desired
packets with strict weight less than nR. The direction of this ideal
inclusion is important; equality is neither used nor generally true.

Finally, high-degree sections of \(L^n\) come from degree-n homogeneous
polynomials in the embedding coordinates, by Serre vanishing on the
homogeneous ideal sheaf. They restrict to W-degree at most nR.
Undo the filtered coordinate changes and set H=nR. R depends only on
the weights; every later threshold may depend on the fixed centers.
This proves exactly the eventual divisibility and quantifier statements.

## 7. Exact examples and the excluded false counterexample route

The certificate uses \(m=2,w_0=1,v_0=2,\sigma=1/100\),
\(w_1=4000000,w_2=100000000000000\). Here \(L_0=4\) and
\(C_*=640000\). It exhausts all six required oriented subset pairs,
not just singleton separations.

* With theta \(3/5\), the centers \((1,0,0),(1,3,6)\) satisfy every
  original hypothesis. The nodal curve
  \(Y=1,X_1=s^2-1,X_2=s(s^2-1)\) has **two** branches at the first
  center, \(s=1,-1\), and one at the second, \(s=2\).
  Its only pole is infinity, of coordinate orders \(0,-2,-3\).
  A polynomial gcd certifies that these are all center preimages, and
  the rational inverse \(s=X_2/X_1\) certifies the normalization parameter.
* The curve \(Y=1+s,X_1=s,X_2=s-s^2/2\) has logarithmic contact orders
  \(1,2,3\) at the first center and misses the second.
  Its pole orders at infinity are \(-1,-1,-2\).
  The script checks the first nonzero tail coefficients, rather than
  mistaking a truncated zero series for infinite order.
* The four-point grid \((1,i,j)\), \(i,j\in\{0,1\}\), with theta \(2/5\),
  has flat occupancies \(n_{\{1\}}=n_{\{2\}}=2\), \(n_{\{1,2\}}=4\).
  It satisfies the extension but not coordinatewise distinctness.
* With theta \(3/5\), the centers \((1,0,0),(1,1,1),(2,0,0)\)
  have occupancies 1,1,2. They satisfy the extension even though
  \(K\theta^2=27/25>1\), because the fiberwise condition replaces that
  original total-in-one-fiber restriction.

For the deliberately inadmissible pair \((1,0,0),(1,1,0)\) at theta \(3/5\),
restriction to \(Y=1,X_2=0\), at \(H=5l w_1\), has source dimension
\(5l+1\) and target dimension \(6l\). Their difference is \(l-1>0\)
for every integer \(l\ge2\), including arbitrarily divisible degrees.
**This is not a manuscript counterexample:** its X_2 coordinates coincide.
The script explicitly verifies that this hypothesis fails. It demonstrates
why ignoring the complete hypotheses would produce a false refutation.
The separate Carella sign objection is already acknowledged in `main.tex`
and concerns an unused external proof; that route is retired in the ledger.

## 8. Sources, limitations, and the exact certification boundary

The following are external inputs, not secretly kernel-proved consequences.
Their canonical identifiers and proposition locators are in `MATH_STATE.json`.
Primary copies used here are retained in `literature/`.

| Input | Proposition actually read and application |
|---|---|
| Isolated Bezout and local multiplicity | Mondal, **arXiv:1806.05346v5**, Corollary VIII.3, printed p.144, and Section IV.4.2, equations (38)--(39), printed p.70. Isolated solutions are counted with local quotient lengths; other components are allowed. The v5 PDF and extracted text were obtained. |
| Complete smooth curve model | Stacks Theorem 53.2.6, tag **0BY1**, and Lemma 53.2.8, tag **0BY3**, in section **0BXX**. The smoothness conclusion uses perfection; the field here is C. |
| Curve degrees and zero--pole comparison | Stacks Lemmas 33.44.4 (**0AYU**), 33.44.9 (**0AYY**), and 33.44.12 (**0B40**). Effective divisors have their local lengths as degree; nonzero sections have nonnegative degree; apply to the zero/pole divisor line bundle. |
| Ordinary blowup | Stacks tags **02OS**, **02ND**, **02NS**: effective Cartier exceptional divisor, integrality for a nonzero ideal, projectivity and relative ampleness for a finite-type ideal. |
| Eventual ordinary Rees powers | Stacks Lemma 30.14.3 (**0AG7**) and Lemma 30.14.2 (**0AG6**). The precise hypotheses are Noetherian degree-zero ring, finite degree-one generation, and a finite graded module/coherent sheaf. |
| Serre vanishing | Stacks Lemma 30.17.1 (**0B5U**), implication (1) -> (2), for proper schemes over a Noetherian affine base and an ample invertible sheaf. |
| Ample plus nef | Lazarsfeld, *Positivity I* (2004), DOI **10.1007/978-3-642-18808-4**, Corollary **1.4.10**, printed p.53. The author's authorized Chapter 1 PDF was obtained after the publisher download returned HTML. The statement says "projective variety or scheme" and gives ampleness of \(D+\varepsilon H\) for nef D, ample H, every \(\varepsilon>0\). |

For the curve-degree input, write the principal divisor as \(D_0-D_\infty\).
Its associated line bundle is trivial. Additivity of degrees and the
effective-divisor length formula give \(\deg D_0=\deg D_\infty\).
Equivalently a rational function with specified poles and zeros gives a
nonzero section of \(\mathcal O(D_\infty-D_0)\), whose degree cannot be
negative. These facts also apply after passing to the complete normalization.

The bounded prior-art reading located Philippon, DOI **10.24033/bsmf.2060**,
Theorem 2.1 and Lemma 5.1 (1986 journal version), and Farhi,
**arXiv:math/0603257v1**, Section 5.2, Theorem 5.3 and Corollary 5.4.
The former uses derivatives, translations, sumsets, and algebraic subgroup
obstructions; the latter explicitly makes separated degrees force product
components. Neither consulted passage supplied the exact theorem in Section 1.
This is a bounded negative lookup, **not** verification of novelty.
Demailly's 1992 Section 6 could not be obtained in that lookup and is not
used in the proof. No relevant inherited Wiki-index entry was found.

The Jacobian adapter was discovered and its exact typed rank contract
inspected before custom finite algebra was written. Server version **0.14.0**,
protocol **2025-11-25**, operation `matrix.symbolic.rank.compute`, its exact
payload, and its typed output are preserved in `jacobian/`.
The bounded operation returned rank 2 with pivot columns [0,1] over
QQ(y,b,c) for columns

\[
 (y,1,1),\quad(0,1,0),\quad(yc,b,c).
\]

The third is \(c\) times the first plus \((b-c)\) times the second;
a constant minor -1 proves rank at least two even at specializations.
The script independently checks these polynomial identities. The contract
permits at most eight rows/columns and provides no curve-valuation or
eventual-surjectivity theorem. This capability mismatch is recorded; its
rank result is not used as a substitute for the geometric proof.
There was no adapter timeout, transport failure, or UNKNOWN result.

All citation assumptions remain subject to independent attribution. The
Engineer does not self-file that attribution under another identity.
The installed `citation_check attribute` always archives to
`research/literature/`, outside this mission's writable paths, so it was
not invoked to write there; the primary copies inside the owned directory
are available to the host's Reviewer. This output-path limitation must be
resolved by an authorized role before any citation-delivery gate is declared
clear. Structural ledger checks alone do not clear it.

To replay the exact certificate, run

```bash
$WORKSPACE/argus-live-update/.venv/bin/python research/interpolation-audit/verify.py
```

To obtain a fresh formal result, use the prescribed `lean_evidence verify`
command with claim `C_K1_NORMAL_HYPERPLANE_CORE`, the source and fidelity
document in `lean/`, and the campaign directory as `--project-root`.
The successful source has not been edited after its compiler run.
The independent Reviewer, not the Engineer, must decide whether to support
the geometric theorem, approve the statement fidelity and citations, and
assess significance and novelty. Any later discovered false manuscript
assertion must be filed literally as its own `F_<LABEL>` claim and receive
matching `refutes` judgements; no such assertion is manufactured here.
