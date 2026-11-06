# Algebraization with a fixed relation precision

## 1. Result and scope

**The finite-determinacy lemma and `prop:algebraization` in
`06-algebraization.tex` are valid.** The proof below supplies the quantified
estimates, exact descent, differential comparison, and one affine
neighborhood required for their application to `thm:main`. In particular,
fixed relation precision suffices; the approximating relation matrix need
not be assumed to generate all syzygies. No complete-intersection
hypothesis is inserted.

The analytic input is `AN_analytic_endpoint`, accepted by the normal
independent Reviewer in
`handoffs/8ba02f2780af/round-0001.json` (in the assigned project-state
directory). That receipt explicitly accepts the existence of the genuinely
singular normal analytic surface germ and generation of its full
holomorphic derivation sheaf. It is reused, not re-audited. The strongest
previous result was an actual analytic germ, not just finite jets. The
improvement here is a finite-type normal integral affine model with the
same completed local ring and a global algebraic tangent frame.

This is a **general prose proof with executable exact algebraic support**.
The script does not prove Artin approximation, Artin-Rees, convergence in
all complete rings, or descent in a proof assistant. No Lean file or
kernel closure is claimed. The exact support certificate is not an
explicit list of equations for the final surface. Independent review of
this mission, originality, and campaign-level publishable acceptance
remain separate.

The approximation strategy is established prior work: Hironaka's
Theorem 3.3 already fixes relation precision while allowing increasing
equation precision, and Artin's Theorems 3.8-3.9 already algebraize isolated
singularities by approximating two presentation maps with zero composite.
The present argument verifies the manuscript's implementation and its
tangent descent; it does not claim a new algebraization method.

## 2. Source-specific inputs

The original passages, including their hypotheses, are archived in
`research/literature/algebraization_sources/`. The source researcher
identified the precise passages; the actual PDFs were then archived and
the relevant extracted text read. The new attributions still belong to
the normal independent Reviewer, not to an alias of the Engineer.

| Input | Proposition actually read | Use |
|---|---|---|
| Artin-Rees | Stacks [00IN](https://stacks.math.columbia.edu/tag/00IN) | Three independent filtration losses |
| Exact completion | Stacks [00MA](https://stacks.math.columbia.edu/tag/00MA) | Presentations, kernels and cokernels of finite modules |
| Faithful flatness | Stacks [00MC](https://stacks.math.columbia.edu/tag/00MC) | Module and ideal descent |
| Dimension and regularity | Stacks [07NV](https://stacks.math.columbia.edu/tag/07NV), [07NY](https://stacks.math.columbia.edu/tag/07NY) | Marked local invariants |
| Analytic excellence | Cutkosky, [arXiv:1206.4255v3](https://arxiv.org/pdf/1206.4255v3), Proposition 2.1(1), p.4 | Excellence of the analytic local ring |
| Normal completion | Stacks [0C23](https://stacks.math.columbia.edu/tag/0C23) | Completion of the excellent normal local ring |
| Exact approximation | Artin, [doi:10.1007/BF02684596](https://doi.org/10.1007/BF02684596), Theorem 1.10, printed p.26 | A solution in the henselization, not an approximate zero |
| Pointed henselization | Stacks [04GN](https://stacks.math.columbia.edu/tag/04GN), [06LJ](https://stacks.math.columbia.edu/tag/06LJ) | Finite data and identities at one stage; unchanged completion |
| Etale presentations and spreading | Stacks [00U9](https://stacks.math.columbia.edu/tag/00U9), [00U2](https://stacks.math.columbia.edu/tag/00U2), [00U4](https://stacks.math.columbia.edu/tag/00U4) | Invertible ambient Jacobian, localization and pointed maximal ideal |
| Finite normalization | Stacks [07QW](https://stacks.math.columbia.edu/tag/07QW), [07QV](https://stacks.math.columbia.edu/tag/07QV) | Excellent finite-type domains are Nagata |
| Finite-type dimensions | Stacks [00OS](https://stacks.math.columbia.edu/tag/00OS), [00OT](https://stacks.math.columbia.edu/tag/00OT) | Dimension at closed points and pure-dimensional neighborhoods |
| Smoothness criterion | Stacks [00TT](https://stacks.math.columbia.edu/tag/00TT) | Minimal number of differential generators and the Fitting locus |

The already independently attributed analytic-coherence input
`AN_analytic_local_algebra` is reused verbatim. It supplies coherence and
nilpotence for complex spaces, including nonreduced ones. No new
algebraicity assumption is hidden in this reuse.

Artin's Theorem 1.10 applies with base field `C`, the henselization of
`C[x]_(x)`, and its maximal ideal. It permits a finite polynomial system
with coefficients in that henselization and any prescribed approximation
order. The Stacks formulations [07QY](https://stacks.math.columbia.edu/tag/07QY)
and [07QZ](https://stacks.math.columbia.edu/tag/07QZ) corroborate this, but
do not replace reading the original statement.

The versioned Cutkosky preprint was obtained; the journal copy was not
accessible to the source researcher. Accordingly the ledger cites
**v3, Proposition 2.1(1)**, not uninspected journal pagination.
The characterization of algebraic elements in Stacks
[0A1W](https://stacks.math.columbia.edu/tag/0A1W) was read but is unnecessary:
finite tuples and their equations descend by the filtered-colimit
property itself.

For historical comparison, the archived Hironaka volume has several
pagination systems. Example I and Theorem 3.3 are at original page
markers 210-211, re-typeset pp.220-221, PDF pp.229-230. Its original
presentation is exact; its approximating pair need only be a complex
with the stated congruences. Its geometric hypothesis is formal
smoothness off the exceptional locus. We do not silently identify that
hypothesis with finite-length `T1` in every setting: the latter version
is proved directly below. Artin's Theorems 3.8-3.9 and proof are at
printed pp.32-34, PDF pp.11-13.

## 3. Precisely quantified finite determinacy

Let

\[
 P=\mathbb C[[x_1,\ldots,x_e]],\quad \mathfrak n=(x_1,\ldots,x_e),
 \quad I=(f_1,\ldots,f_s),\quad R=P/I,\quad \mathfrak m=\mathfrak nR.
\]

Write `f` as a row. Its entries lie in `n`. Let `D` be a finite
`s` by `t` matrix with

\[
 P^t\xrightarrow D P^s\xrightarrow f I\longrightarrow0
 \quad\text{exact}.
\]

Define `psi(v)=v Dbar`, `K=ker(psi)`, and
`J=sum_j R partial_j(f)bar`. Right-exact tensor product gives
`R^t -> R^s -> I/I^2 -> 0`, and left-exact duality gives

\[
 K=\operatorname{Hom}_R(I/I^2,R).
\]

Differentiating `fD=0` and reducing modulo `I` gives `J subset K`.
Neither assertion assumes left exactness of tensor product.
Assume `K/J` has finite length.

Use the following three independent Artin-Rees constants:

\[
\begin{aligned}
 \operatorname{im}\psi\cap\mathfrak m^rR^t
   &\subset\psi(\mathfrak m^{r-\alpha}R^s),\\
 K\cap\mathfrak m^rR^s&\subset\mathfrak m^{r-\beta}K,\\
 I^{\oplus s}\cap\mathfrak n^rP^s
   &\subset\{fC:C\in\mathfrak n^{r-\delta}P^{s\times s}\}.
\end{aligned}                                                    \tag{1}
\]

Here the corresponding `r` is at least the loss. For a finite map
`u:M->M'`, Artin-Rees on `im(u) subset M'` puts a high-order image
element in `m^(r-a) im(u)=u(m^(r-a)M)`, proving the first and third
forms. The third uses the filtration induced from `P^s`, not a guessed
coefficient order in a generating expression.

Choose `ell>=0` with `m^ell K subset J`. Put

\[
 c_0=\beta+\ell,\quad c=c_0+\delta,\quad
 N\ge\alpha+1,\quad
 n_0\ge\max\{c+N,c+2,2c+1\}.                                    \tag{2}
\]

All constants depend only on the original `f,D`. The symbol `delta`
is the manuscript's Artin-Rees loss `d`, renamed to avoid confusion
with the geometric dimension.

**Claim.** For every row `g` and matrix `B` with

\[
 gB=0,\qquad g-f\in\mathfrak n^{n_0}P^s,\qquad
 B-D\in\mathfrak n^NP^{s\times t},
\]

there exist a continuous `C`-algebra automorphism `Phi` and
`U in GL_s(P)` with

\[
 f=\Phi(g)U,\qquad
 \Phi(x_j)-x_j\in\mathfrak n^2,\qquad U-1\in\mathfrak n.
                                                                    \tag{3}
\]

There is **one fixed `N`**, not a sequence of increasingly accurate
relation hypotheses. If `s=0` the statement is immediate; zero or
redundant equations and the case `t=0` otherwise cause no change.

### 3.1. Correcting into the conormal dual

Suppose `n>=n0`, `h=g-f in n^n`, `B-D in n^N`, and `gB=0`.
Always reduce modulo the **fixed original** ideal `I`. Then

\[
 \bar h\bar D=-\bar h(\bar B-\bar D)\in\mathfrak m^{n+N}R^t.       \tag{4}
\]

The factor is `hbar`, because `gbar=hbar`. Replacing it by a merely
bounded row would lose the decisive improving order.
The first estimate in (1) gives

\[
 \bar\epsilon\in\mathfrak m^{n+N-\alpha}R^s
       \subset\mathfrak m^{n+1}R^s,\qquad
 \psi(\bar\epsilon)=\psi(\bar h).
\]

Thus

\[
\begin{aligned}
 \kappa=\bar h-\bar\epsilon
 &\in K\cap\mathfrak m^nR^s\\
 &\subset\mathfrak m^{n-\beta}K\\
 &\subset\mathfrak m^{n-\beta-\ell}J
   =\mathfrak m^{n-c_0}J.                                      \tag{5}
\end{aligned}
\]

The last inclusion factors off `m^ell`; its exponent is nonnegative
by (2). Lift the derivative coefficients to
`a_j in n^(n-c0)` and lift `epsilonbar` to `epsilon in n^(n+1)`.
The resulting remainder satisfies

\[
 w=h-\sum_j a_j\partial_jf-\epsilon
   \in I^{\oplus s}\cap\mathfrak n^{n-c_0}P^s.
\]

It need not have order `n`: an original equation may have a unit
derivative. The third estimate in (1) gives `w=fC` with
`C in n^(n-c0-delta)`. In particular, with `q=n-c`,

\[
 h=\sum_j a_j\partial_j f+fC+\epsilon,\quad
 a_j,C\in\mathfrak n^q,\quad\epsilon\in\mathfrak n^{n+1}.         \tag{6}
\]

This explicitly pays the loss `delta`. All three Artin-Rees
applications are within their allowed ranges: `n+N>=alpha`,
`n>=beta`, and `n-c0>=delta`, in fact the last is at least `delta+2`.

### 3.2. One simultaneous improvement

Set

\[
 \phi(x_j)=x_j-a_j,\quad M=(1+C)^{-1},\quad
 g_{\rm new}=\phi(g)M,\quad B_{\rm new}=(1+C)\phi(B).             \tag{7}
\]

The choices in (2) give exactly

\[
 q\ge N,\quad q\ge2,\quad 2q\ge n+1,\quad
 n+q-1\ge n+1.                                                 \tag{8}
\]

The substitution has identity linear part, hence has a formal inverse,
constructed recursively by degree. The inverse of `1+C` is the
convergent matrix series `sum_{k>=0}(-C)^k`.

For clarity, the Taylor estimates used here are formal coefficient
estimates, not analytic convergence assertions. In a monomial of degree
`r`, a term with `k` replacements of variables by an `a_j` has order
at least `r-k+kq`. With `k>=2` this is at least `2q`.
For a monomial of `h`, `r>=n`; with `k>=1` it is at least `n+q-1`.
Coefficientwise completeness therefore gives

\[
 \phi(f)=f-\sum_j a_j\partial_j f+O(\mathfrak n^{2q}),\qquad
 \phi(h)=h+O(\mathfrak n^{n+q-1}).
\]

Combining with (6),
`phi(g)=f(1+C)+O(n^(n+1))`, so `g_new-f in n^(n+1)`.
The relations transform **exactly**, in the indicated order:

\[
 g_{\rm new}B_{\rm new}
 =\phi(g)(1+C)^{-1}(1+C)\phi(B)=\phi(gB)=0.                     \tag{9}
\]

Every `F in P` satisfies `phi(F)-F in n^q`: its constant term is
unchanged and each nonconstant monomial has at least one replaced
variable. Consequently

\[
 B_{\rm new}-D
 =C\phi(B)+(\phi(B)-B)+(B-D)\in\mathfrak n^N.                   \tag{10}
\]

The original `D` remains fixed. No assertion concerning the generation
of `ker(g)` by `B` was used in (4)-(10).

### 3.3. Convergence, including the generator change

Repeat (7) for `n=n0,n0+1,...`. Set

\[
\begin{aligned}
 &\Phi_{n_0}=\mathrm{id},\quad U_{n_0}=1,\\
 &\Phi_{n+1}=\phi_n\circ\Phi_n,\qquad
 U_{n+1}=\phi_n(U_n)M_n .
\end{aligned}                                                  \tag{11}
\]

Induction gives `g_n=Phi_n(g)U_n`. Since
`(phi_n-id)(P) subset n^(n-c)` and `M_n-1 in n^(n-c)`,
both the consecutive images of each variable and the consecutive
entries of `U_n` differ in `n^(n-c)`. They are Cauchy. Their limits
define a continuous substitution `Phi` with identity linear part and
a matrix `U` with identity residue. These are invertible, by recursive
formal inversion and the local-ring matrix criterion, respectively.

For each fixed quotient `P/n^r`, the substitutions and matrices
eventually stabilize. Substitution of any original power series is
therefore compatible with these limits, not just substitution of
polynomials. Taking limits in (11) gives (3), because
`g_n-f in n^n` tends to zero and `P` is separated.
This proves `algebra:finite-determinacy` with its exact quantifiers.

## 4. Why equations alone are insufficient

This is a guardrail for the proof, **not a counterexample to the
manuscript**. In `C[[x,y,z,w]]`, put

\[
 f=(xz-y^2,\ xw-yz,\ yw-z^2),\qquad
 D=\begin{pmatrix}z&w\\-y&-z\\x&y\end{pmatrix}.
\]

Then `fD=0`. The original quotient is the completed third Veronese
subring `C[[u,v]]^(mu_3)`, with
`(x,y,z,w)=(u^3,u^2v,uv^2,v^3)`.
Here is a direct justification: the three relations reduce any monomial
to a combination of `x^a w^b`, `x^a y w^b`, and `x^a z w^b`, strictly
reducing the combined `y,z` degree. Their images have distinct exponent
residues modulo three, so are linearly independent. Reduction works
degree by degree for formal series. These images are exactly the
`mu_3`-invariant monomials. The ring is finite free of rank three over
`C[[x,w]]`, is a domain of dimension two, and is normal: an invariant
fraction integral over it lies in the integrally closed `C[[u,v]]`
and is still invariant.

The corresponding algebraic cone is smooth off its origin. On `D(x)`
it has coordinates `x,x^(-1),y`, since `z=y^2/x` and `w=y^3/x^2`;
on `D(w)` the analogous coordinates are `w,w^(-1),z`.
These opens cover the punctured cone. This statement concerns the
algebraic/analytic charts, not a false unrestricted elimination
isomorphism for localized power-series rings. The origin is singular
because all defining equations are quadratic and its embedding
dimension is four.

For **every** integer `k>=3`, perturb only the last equation:

\[
 g_k=(xz-y^2,\ xw-yz,\ yw-z^2+x^k).
\]

It is arbitrarily close to `f` as `k` grows, but

\[
 g_kD=(x^{k+1},yx^k),\qquad
 \sqrt{(g_k)}=(x,y,z).                                         \tag{12}
\]

Indeed `x^{k+1}` belongs to `(g_k)`, so `x` belongs to its radical;
the first equation then gives `y`, and the third gives `z`.
The reverse inclusion follows by setting `x=y=z=0`.
Thus the perturbed completed quotient has dimension one, not two.
The equation-only route is retired for this explicit reason.
This familiar presentation issue is not claimed as a new obstruction
to algebraization.

## 5. The analytic input gives the required finite modules

Let `S=O_(X,x)` be any normal complex analytic local ring of dimension
`d>=1`, with smooth complement of the marked point and free
holomorphic tangent module of rank `d`. Write

\[
 S=\mathbb C\{x_1,\ldots,x_e\}/(f)
\]

and choose all relations on `f` over the Noetherian convergent
power-series ring. They are finitely generated. Coherence makes the
conormal-dual Jacobian cokernel a coherent sheaf near `x`.

At a smooth point of `X`, its embedding in the smooth ambient space
is locally a regular embedding. Analytic coordinates give normal
coordinate functions generating its ideal and show that the
ambient-tangent-to-normal map is onto. Consequently this cokernel
is supported at `x`. Its annihilator has radical the maximal ideal
(equivalently apply the analytic local zero-set theorem to its
support), so a power of that ideal annihilates it. A finite module
over an Artinian quotient of the Noetherian local ring has finite
length.

Exact completion of finite presentations, kernels and images identifies
this completed cokernel with `K/J` of section 3. Thus the finite-length
hypothesis used there is justified without a complete-intersection
assumption at the singular point. Smoothness is used only away from it.

The **holomorphic** differential module has its finite Jacobian
presentation. Dualizing it and completing gives

\[
 \ker\bigl(R^e\longrightarrow R^s,\quad
        v\longmapsto\sum_jv_j\overline{\partial_jf}\bigr)
       \simeq R^d,\qquad R=\widehat S.                         \tag{13}
\]

Continuous derivations of a formal power-series quotient are precisely
this kernel. A continuous derivation is determined by the variables;
the chain rule follows first for polynomials and then by passage to the
maximal-ideal limit. A tuple satisfying the Jacobian equations defines
a derivation on the quotient because it annihilates its finitely
generated defining ideal.

Cutkosky's Proposition 2.1(1) and Tag 0C23 make `R` normal. A normal
local ring is a domain. Tags 07NV and 07NY give
`dim R=d` and identical regularity status for `R` and `S`.
These statements hold for the actual analytic germ; they do not
presuppose its algebraization.

## 6. Exact approximation and one pointed etale model

Let `Q0=C[x_1,...,x_e]_(x)` and `H=Q0^h`. Its completion is `P`;
it embeds in `P` by faithful flatness and separatedness. Apply the
original Artin Theorem 1.10 to the finite polynomial system

\[
 \sum_iG_iB_{i\nu}=0\quad(1\le\nu\le t)                         \tag{14}
\]

in the `s+st` entries of `G,B`, with formal solution `f,D`.
For any `m>=max(n0,N)` the theorem gives `g,B` in `H`, satisfying
(14) exactly and congruent to `f,D` modulo `n^mP`. In particular
`g` vanishes at the marked point. Section 3 gives

\[
 P/(g)\simeq P/(f)=R.                                         \tag{15}
\]

**All exact identities descend.** By Tag 04GN the henselization is
the filtered colimit of pointed etale `Q0`-algebras `(E_lambda,q_lambda)`
with residue `C`. The finitely many entries of `g,B` are represented
at one stage. Each of the finitely many zero expressions (14) becomes
zero at a later stage, by the defining equality relation in a filtered
colimit. Filteredness supplies a common later pointed stage for all
of them. This does not assume that a stage maps injectively to `H`.

The etale algebra over `Q0` spreads to one over a polynomial
neighborhood by Tag 00U2(10). The finitely many coefficients and
represented entries require only finitely many denominators nonzero
at the origin. If an equality holds after localization, a further
such denominator kills its numerator; do this for the finite list.
Inverting their product retains the point and makes all equalities
hold in a single finite-type affine etale algebra `E` over
`C[x_1,...,x_e]`. Any required localization on the etale source is
itself etale and is included in this finite presentation.

Let `q` be the marked point of `E`. Its residue field is `C`, and

\[
 \widehat{E_q}=P.                                             \tag{16}
\]

One can see (16) directly, rather than confusing henselization with
completion. An etale presentation has an invertible square Jacobian
in its auxiliary variables (00U9), so the marked residue solution
lifts uniquely through every successive nilpotent thickening.
Induction gives the unique lifts to `Q0/m^r`, and inverse limits
give the formal solution in `P`. Conversely the same unique lifting
inside `E_q/q^r` identifies these Artinian quotients with `Q0/m^r`;
here `mE_q=qE_q` by 00U4 and the residue fields coincide.
The resulting completion isomorphism is compatible with the
chosen map `E_q -> H -> P`, so the images of `g,B` are the original
approximated formal series.

Set

\[
 A'=E/(g),\qquad p'=q/(g),\qquad T=A'_{p'}.
\]

Exactness of completion on finite modules, (15) and (16) give

\[
 \widehat T=P/(g)\simeq R                                    \tag{17}
\]

as continuous local `C`-algebras, with residue `C`. This is a
completed-local-ring equivalence, not a claim that the original
analytic local ring equals the algebraic one.

## 7. The finite Jacobian comparison and tangent descent

For an etale algebra over `C[x]`, its ordinary algebraic differentials
have basis `dx_1,...,dx_e`. For example, differentiate an etale
presentation `h(x,z)=0`: the invertible `z`-Jacobian solves uniquely
for `dz` in terms of `dx`. This also proves independence, by assigning
arbitrary values to the `dx_j` and solving for the `dz_i`.
Quotient and localization therefore give a **finite presentation**
of `Omega_(T/C)` by the `dg_i`.

Completing that presentation yields the finite continuous Jacobian
presentation for `R'=P/(g)`. The differential coefficients really
complete to the formal partial derivatives: a derivation on `E_q`
sends `q^r` into `q^(r-1)` by Leibniz, hence extends continuously
to its completion; its values on `x_j` determine it there.

For a finite presentation `T^a -> T^b -> M -> 0`, its dual is the
kernel of `T^b -> T^a`. Flat base change preserves this kernel.
Consequently

\[
 \operatorname{Der}_{\mathbb C}(T)\otimes_T R'
   \simeq\operatorname{Der}^{\rm cont}_{\mathbb C}(R',R').       \tag{18}
\]

This uses the ordinary differential module of the **essentially
finite-type ring `T`**, not an assertion that the ordinary Kahler
module of `P` is finite or equals its continuous quotient.

The formal equivalence also transports these finite Jacobian kernels.
Here is the precise chain rule, including the otherwise missing term.
Use row equations, let `J_f` be the `e` by `s` matrix
`(partial_k f_i)`, and put
`A_(kj)=partial_k Phi(x_j)`. Since `f=Phi(g)U`,

\[
 J_f=A\,\Phi(J_g)U+Q,\qquad
 Q_{ki}=\sum_l\Phi(g_l)\partial_kU_{li}.                        \tag{19}
\]

Modulo `(f)=Phi((g))`, `Q=0`. The matrix `A` has identity residue
and is invertible, as is `U`. Thus the row kernels transform by
`v -> vA`, with coefficients transported by `Phi`. Alternatively,
conjugating continuous derivations by the continuous algebra
isomorphism gives the same identification. Equations (13), (17)
and (18) imply

\[
 M\otimes_T\widehat T\simeq\widehat T^d,\qquad
 M=\operatorname{Der}_{\mathbb C}(T).                          \tag{20}
\]

The finite module `M` has residue-vector-space dimension `d`.
Lift a residue basis. Nakayama gives `T^d -> M` surjectively.
After completion this is a surjection between free rank-`d` modules
over a local ring. Its square matrix is invertible modulo the
maximal ideal and hence has unit determinant, so it is an
isomorphism. Flatness completes its kernel to zero, and faithful
flatness implies that the kernel was zero. Therefore

\[
 \operatorname{Der}_{\mathbb C}(T)\simeq T^d.                   \tag{21}
\]

No chosen analytic vector-field coefficients need themselves descend
algebraically. It is the finite algebraic module, not an arbitrarily
chosen formal basis, whose freeness descends.

## 8. Normality, dimension and the singular point descend

The faithfully flat map `T -> That` is injective. Since `That=R`
is a domain, `T` is a domain. For normality, let `a/b in Frac(T)`
be integral over `T`, with `b!=0`. It is integral over the normal
domain `That`, hence lies in `That`. Ideal contraction under
faithful flatness gives

\[
 a\in b\widehat T\cap T=bT,
\]

so `a/b in T`. This proves normality without assuming that normal
completion implies excellence of an arbitrary input ring.

Dimension is preserved by completion. The residue field and
`m/m^2` are also unchanged, so the regularity criterion
`embedding dimension = Krull dimension` gives regularity
equivalence. In particular `dim T=d`, and `T` remains nonregular
if the original analytic `S` was nonregular.

## 9. One principal affine shrinking, with the whole frame

All changes in this section are localizations away from `p'`; none
changes `T`.

First `Der_C(A')` is finite and localizes to `Der_C(T)`: this follows
by taking the kernel of a dual finite presentation of
`Omega_(A'/C)`. Represent the `d` basis elements of (21) after
inverting the product of their denominators. They define a map
from a free rank-`d` module to the localized derivation module.
Its finite kernel and cokernel vanish at `p'`. For each of their
finite sets of generators, choose an element outside `p'` that
kills it, and invert their product. The map is now an isomorphism
on this entire principal open, not merely pointwise free.

The nilradical is a finite module and vanishes at `p'`, since `T`
is a domain; remove its support in the same manner. Exactly one
minimal prime is contained in `p'`, because such primes correspond
bijectively to the minimal primes of `T`. There are finitely many
other irreducible components. For each, choose an element in its
minimal prime but outside `p'` and invert their product. The
remaining ring `B0` is reduced with one minimal prime, hence a
domain. By Tag 00OS its dimension is the dimension `d` of its
local ring at the closed marked point.

For completeness, the required normal open can be obtained without
an unproved global normality assertion. A finite-type `C`-domain
is excellent and Nagata, so its normalization `B0bar` is finite.
Normalization commutes with localization, and `T` is already
normal. Hence the finite quotient `B0bar/B0` vanishes at `p'`.
Kill its generators by another product outside `p'`. On that
principal open the ring equals its normalization and is normal.
This only localizes `B0`; it does not silently replace the marked
local ring by a different normalization.

It remains to retain an isolated singular point. The analytic
Jacobian criterion and the isolated analytic singularity give

\[
 \mathfrak m_S^b\subset
 \operatorname{Fitt}_d(\Omega^{\rm hol}_{S/\mathbb C})
 \quad\text{for some }b\ge0.                                  \tag{22}
\]

In the smooth case the Fitting ideal is the unit ideal. In the
singular case its analytic zero-set germ is just the marked point;
the local zero-set theorem and Noetherianity give (22).
Fitting ideals commute with base change, directly from their
minor definition. The finite continuous differential comparison,
the formal isomorphism, and faithful-flat ideal contraction give

\[
 \mathfrak m_T^b\subset
 \operatorname{Fitt}_d(\Omega^1_{T/\mathbb C}).                  \tag{23}
\]

On the current integral `d`-dimensional finite-type neighborhood,
the topological local dimension is `d` everywhere (00OT).
The elementary rank-of-minors criterion says that `Fitt_d(Omega)`
is a unit at a prime exactly when the differential module there
needs at most `d` generators. Tag 00TT identifies this with
smoothness. Thus the nonsmooth locus is the closed set defined by
this Fitting ideal.

Any irreducible component of that closed set through `p'` must
be the singleton `{p'}`: its generic prime would localize to a
prime of `T` containing `m_T^b`, so must localize to `m_T` and
hence equal `p'`. Remove the finitely many components not through
`p'`, again by elements outside `p'`. In the smooth case remove
all of them.

Finally take the product `s` of the finitely many elements inverted
in this section, interpreted as numerators in `A'`. Denominators
already inverted also remain in this product. Since none belongs
to `p'`, `s` does not belong to `p'`. The **single principal affine
open**

\[
 A=A'_s,\qquad p=p'A
\]

has all the properties simultaneously:

\[
\begin{gathered}
 A\text{ is a finite-type normal integral }\mathbb C\text{-algebra},
 \qquad \dim A=d,\qquad A/p=\mathbb C,\\
 A_p=T,\qquad \widehat{A_p}\simeq\widehat S,\qquad
 \operatorname{Der}_{\mathbb C}(A)\simeq A^d,\\
 \operatorname{Spec}A-\{p\}\text{ is smooth}.
\end{gathered}                                                  \tag{24}
\]

All later localizations preserve the already chosen global frame,
because derivations commute with localization via their finite
presentation. If `S` was singular, (24) still contains its marked
nonregular local ring. This proves every assertion of
`prop:algebraization`, including its smooth case and the single-open
requirement.

## 10. Application to the main theorem

The accepted analytic receipt supplies a normal two-dimensional
complex analytic germ, smooth off a genuinely singular marked point,
with free full holomorphic tangent module of rank two. Apply (24)
with `d=2`. It supplies the normal integral finite-type algebra `A`
and maximal ideal `p` with

\[
 \operatorname{Der}_{\mathbb C}(A)=A^2,\qquad
 A_p\text{ nonregular}.
\]

Thus the manuscript's main **existence implication** follows from
the accepted analytic theorem. This logical application does not
create a new approval of the upstream geometry, an explicit affine
equation list, a kernel proof, or a novelty/significance judgment.
The corollaries about logarithmic Kodaira dimension and derivation
blowups are not needed for this implication and are outside this
bounded mission.

## 11. What the executable certificate does and does not establish

Run from the campaign root:

```bash
PYTHONDONTWRITEBYTECODE=1 python3 research/algebraization_audit/verify.py --negative-controls
```

`verify.py` derives its algebraic results rather than accepting a table
of claimed successes. The support includes symbolic nonnegative
linear-combination certificates for all order inequalities in
(2)-(8); general monomial replacement bounds; exact matrix inverse,
relation and cumulative-change identities; the chain-rule
generator-derivative term; a Cauchy-Binet identity supporting Fitting
invariance; and the exact twisted-cubic relations in (12).
The order certificates are identities in arbitrary parameters subject
to the listed inequalities, not tests of a bounded integer box.
The matrix/first-jet identities have the explicit finite arities in
the script; the arbitrary-rank statements are proved by the indexed
arguments above.

The installed Jacobian contract was discovered and inspected before
execution. One bounded `matrix.symbolic.multiply.compute` operation
multiplied a generic two-by-two `1+C` by its adjugate. The dedicated
JSON files preserve its exact typed payload, typed response, operation,
server/protocol and adapter status. The checker independently
reconstructs the multiplication from the saved payload and compares
the returned matrix. A transport failure, timeout, malformed result
or unsupported result would fail this check, not count as evidence
for a theorem.

Negative controls corrupt actual supported assertions, including
order losses, matrix transformations, the chain rule, and the
equations-only obstruction. They must be rejected. A separate
invalid-certificate CLI invocation also tests the nonzero failure
exit without editing the valid certificate.

The recorded run passes **107 derived exact assertions and 13 universal
inequality certificates**, and rejects all **18** corrupted assertions.
The separate CLI control changes the relation-error order from `N+n`
to `N`; it exits **1** at `derived.orders.relation_error`. The live
Jacobian call returned the expected diagonal determinant product in
26 ms, with adapter exit **0**, no structured error and no timeout.
These outputs are retained as `verification_output.json`,
`negative_control_cli_output.json`, and the dedicated Jacobian JSON
files beside this report.

The executable checks do **not** make the universal algebraization
theorem a finite experiment. Its quantifiers, convergence, exact
approximation, analytic finite-length assertion, faithful-flat
descent, and single principal shrinking are the prose proof in
sections 3 and 5-9 and the cited foundational propositions.
The ledger therefore records Engineer support, not mechanical
kernel closure. The normal independent Reviewer must judge that
proof and the newly cited propositions before this mission is
accepted.
