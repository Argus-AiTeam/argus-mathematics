# Projectivization transfer: completed downstream evidence disposition

## Result and remit

**Unit:** `projectivization-transfer`. **Research target:** exploratory.
**Review-result novelty:** not applicable. **Acceptance:**
`pending_native_independent_review`.

The five old downstream claims have identifiable manuscript statements but
**no old certification**. Their disposition is complete for this bounded
old-draft assessment: they are outside the old localization result. This is
not an identified mathematical gap in the manuscript, a refutation, or an
assertion that its proofs are correct. The mathematical validity and novelty
of these downstream results remain **unassessed**. The obligations below
describe what certification of those results would require; undertaking
that certification is not a prerequisite for completing this disposition.
This Engineer assessment is not independent Reviewer acceptance.

## Exact sources, version, and attribution

All paths below are read-only inputs. The actual manuscript root read was

`families/065/first-pass/openai_manuscript/Virasoro-Constraints-under-Projectivization-October-5-2026/`.

The reference manifest is
`campaigns/9100065/MANUSCRIPTS.json`,
as selected by current `PRIOR_DRAFTS.json`. Its expected `source_revision`
is `4eaee87548250b2682affda7d05d947c05554bae`. This assessment read the
actual old-path files, not a title-derived reconstruction or another
revision. Global content/version comparison belongs to the parent
assessment; no manifest was rebuilt and no Git operation was performed.

| File relative to the manuscript root | Lines read | Theorem/lemma/proposition labels read |
|---|---:|---|
| `build/sections/01-introduction.tex` | 1–217 | `thm:main` |
| `build/sections/02-conventions.tex` | 1–243 | `conv:covariance`, `conv:finite-support`; definition `conv:projective` |
| `build/sections/05-shift.tex` | 1–455 | `shift:grading-lemma`, `shift:operator`, `shift:polynomiality`, `shift:commutation-lemma`, `shift:fiber-operator`, `shift:spectrum-proposition` |
| `build/sections/06-spectral.tex` | 1–495 | `spec:calculus`, `spec:gauge`, `spec:commutators`, `spec:modes`, `spec:zero` |
| `build/sections/07-fixed-block.tex` | 1–457 | `fixed:equivalence`, `fixed:classical`, `fixed:qrr-normalized`, `fixed:rank-scaling` |
| `build/sections/08-continuation.tex` | 1–370 | `cont:polynomiality`, `cont:finite-tests`, `cont:monodromy`, `cont:projective-transfer`, `cont:commutators`, corollary `cont:exact` |

These are **manuscript** assertions. The ledger entries are abbreviated
dependency claims pointing to them, not additional Argus proofs.
Equation labels are distinguished below from statement labels; in
particular `shift:spectrum` is an equation, while
`shift:spectrum-proposition` labels its proposition.

The other old evidence read was:

* `families/065/first-pass/MATH_STATE.json`:
  the five claim records, `CTX_FAMILY_LOC`, their evidence bindings, and
  route `R_PROJ_MANUSCRIPT`.
* `families/065/first-pass/PROOF_GRAPH.json`:
  the downstream nodes and their recorded dependencies.
* `families/065/first-pass/family_orbit_localization/report.md`,
  lines 615–656, especially 648–656.
* `families/065/first-pass/family_orbit_localization/statement_fidelity.md`:
  the explicit boundary of `C_LOC_JET`.

The current coverage index and `PRIOR_DRAFTS.json` were also read. The
26-artifact inventory is a localization proof cluster, not five transfer
proofs. `C9000065` is its historical umbrella audit objective, not current
instructions, a standalone theorem, or evidence of certification.

## Shared hypotheses and normalization

The ordinary theory of a smooth connected projective complex variety
\(Y\), of complex dimension \(d\), uses all \(H^*(Y;\mathbb C)\), with
cohomological parity, the Poincaré pairing, categorical coevaluation, and
Koszul signs. Its potential is ordinary and unreduced:
\[
 Z_Y=\exp\!\left(\sum_{g\geq0}\hbar^{g-1}F_g^Y(t)\right).
\]
The cotangent classes are ordinary marked stable-map descendants, not
ancestors. Novikov variables retain actual effective integral classes in
\(H_2(Y;\mathbb Z)\), including degree zero, in an ample-degree
completion; numerically indistinguishable labels are not merged.

The first-Hodge grading, loop modes, dilaton translation, and scalar are
exactly `conv:grading`, `conv:ordinary-modes`, `conv:dilaton`, and
`conv:normalized-modes`:
\[
 \mu_Y|_{H^{p,q}}=(p-d/2)\mathrm{id},\quad R_Y=c_1(TY)\cup,\quad
 \ell_{-1,Y}=z^{-1},\quad
 \ell_{0,Y}=z\partial_z+\tfrac12+\mu_Y+R_Y/z,
\]
\[
 \ell_{k,Y}=\ell_{0,Y}(z\ell_{0,Y})^k\ (k\geq1),\qquad q=t-z1_Y,
\]
\[
 L_k^Y=\operatorname{op}(\ell_{k,Y})+\delta_{k0}C_Y,\qquad
 C_Y=\frac{\chi(Y)}{16}-\frac14\operatorname{str}(\mu_Y^2).
\]
Normal ordering uses the paper's Hamiltonian sign and left super
derivatives. There is no positive-mode scalar correction.
\(\mathcal V(Y)\) means \(L_k^YZ_Y=0\) for every \(k\geq-1\),
coefficientwise in genus, individual integral curve class, and every
finite descendant list, including primitive and odd insertions.

For the auxiliary construction, \(B\) is smooth connected projective over
\(\mathbb C\), \(E\) has rank \(r\geq2\), and projective bundles parametrize
**lines**. After a sufficiently negative line-bundle twist one works
with \(E^*\) globally generated, without changing
\(X=\mathbb P_B(E)\). Put \(W=\mathbb P_B(E\oplus\mathcal O)\).
The torus has weight zero on \(E\) and one on \(\mathcal O\), with
parameter \(\lambda\). Write \(Q^\beta y^l\) for the actual integral
base/tautological labels. In this normalized construction effective
\(l\geq0\). The shift and quantum product are at primary background
zero, in the polynomial equivariant basis \(\pi^*b\,p^j\),
\(0\leq j\leq r\). This normalization of the auxiliary argument is not
a positivity hypothesis on `thm:main`.

“Projectively satisfied” means that \(Z^{-1}\operatorname{op}(A)Z\)
is independent of insertion variables (`conv:projective`). The scalar
may still depend on Novikov parameters, \(\lambda\), and \(\hbar\).
This is weaker than the final exactly normalized Virasoro equations.

## Decisive old evidence

Each of `C_PROJ_VIR`, `C_PROJ_SHIFT`, `C_PROJ_SPECTRAL`,
`C_PROJ_FIXED`, and `C_PROJ_CONTINUATION` has **only version 1**.
Every record has an empty `formal_statement`, empty
`external_assumptions` and `retired_assumptions`, and **no evidence record
bound to it**, whether mechanical or judgement. Empty assumption arrays
do not establish an assumption-free theorem: the assertions explicitly
use other mathematical inputs.

All five old graph nodes are `open` and
`reviewer_confirmed=false`. Their evidence paths point to manuscript
sections. The graph records:

| Claim | Recorded dependencies |
|---|---|
| `C_PROJ_VIR` | `C_LOC`, `C_PROJ_SHIFT`, `C_PROJ_SPECTRAL`, `C_PROJ_FIXED`, `C_PROJ_CONTINUATION` |
| `C_PROJ_SHIFT` | none |
| `C_PROJ_SPECTRAL` | `C_PROJ_SHIFT` |
| `C_PROJ_FIXED` | `C_PROJ_SPECTRAL` |
| `C_PROJ_CONTINUATION` | `C_LOC`, `C_PROJ_FIXED` |

`R_PROJ_MANUSCRIPT` is unretired but has precisely the five listed
localization/downstream obligations for `C_PROJ_VIR`; a route is not a
certificate. The source also uses common-\(R\) rationality in
`spec:zero` and common-\(R\) covariance in `fixed:equivalence`;
the abbreviated graph is not an exhaustive proof of those source links.
No graph or ledger has been changed here.

Most decisively, the old report ends:
“The final Virasoro-transfer theorem and complete-intersection sewing
remain outside this result.” The exclusion agrees with the absence of
bound evidence. Open graph labels alone would not refute a proof, but
here neither the report nor the ledger claims that downstream proof.

## Per-claim statements and certification boundaries

### `C_PROJ_VIR@1`: the ordinary transfer theorem

**Exact assertion.** `01-introduction.tex`, Theorem `thm:main`:
for every smooth connected projective complex \(B\) and every algebraic
rank-\(r\geq2\) bundle \(E\), with \(X=\mathbb P_B(E)\) parametrizing
lines,
\[
                         \mathcal V(B)\Longrightarrow\mathcal V(X).
\]
There is no splitting, filtration, positivity, semisimplicity, or
Hodge-type restriction. The conclusion is the full **ordinary**
descendant theory with the normalization above, not merely an
equivariant auxiliary or inverse-Euler-twisted theory.

**Attribution and support.** This is the manuscript's theorem. Its old
natural statement explicitly says it is outside the present
certification. Its open dependency node and source pointer supply
statement localization, not a proof or independent review.

**Obligations for theorem certification.** Establish the simultaneous
geometric/common-\(R\) input in its exact needed scope; verify all four
downstream stages below and their compatibility; preserve full
cohomology, super signs, ordinary descendants and integral labels through
twisting, paired-space changes, and return from \(W\); and obtain the
specified \(L_0\) constant rather than only projective equations.
Checking only localization cannot discharge this implication.
The theorem's truth and novelty are unassessed by this disposition.

### `C_PROJ_SHIFT@1`: polynomial normalized shift and residual spectrum

**Exact assertions.** Section `shift:section` uses
\(c=c_1^T(TW)\), \(\kappa=c_1(TB)+c_1(E)\), and
\[
 G_d=z\partial_z+\lambda\partial_\lambda+\tfrac12+\mu+c\cup/z,\quad
 G_a=z\partial_z+\lambda\partial_\lambda+\tfrac12+\mu+c\star/z.
\]
The small quantum product is at zero primary background. Novikov
variables are held fixed in these derivatives.

`shift:operator` asserts an operator
\[
 T_a=A(z,\lambda,Q,y)e^{z\partial_\lambda}=S_WT_dS_W^{-1}.
\]
The section class is normalized by the minimum section from \(X\);
\(\sigma_B-\sigma_{\min}\) is the fiber-line class. Iritani's loop
variable is sign-reversed, and the calibration convention is
\(S_Y(z)=M(-z)^{-1}\). With \(x\) the ordinary normal Chern roots,
\[
 T_d|_X=\prod_x(x+\lambda)e^{z\partial_\lambda},\qquad
 T_d|_B=y\prod_x(x-\lambda-z)^{-1}e^{z\partial_\lambda}.
\]
The assertions apply to full equivariant super cohomology.

Lemma `shift:polynomiality` says that at **each fixed actual base class**
\(\beta\), the entries of \(A\) and \(c\star\) are polynomial in
\(y,z,\lambda\), with no \(z\)-dependence in \(c\star\), before
localizing \(\lambda\). `shift:grading-lemma` and
`shift:commutation-lemma` assert
\(G_a=S_WG_dS_W^{-1}\) and \([G_a,T_a]=0\).
Lemma `shift:fiber-operator` gives
\[
 T_a\bmod(z,Q^{>0})=(p+\lambda)\star.
\]
After also reducing positive-degree base cohomology, the fiber relation
is \(p^r(p+\lambda)=y\) (`shift:fiber-relation`).
Proposition `shift:spectrum-proposition`, equation `shift:spectrum`,
therefore asserts the distinct generic eigenvalue branches
\[
                   a_i=\lambda+h_i,\qquad h_i^r(h_i+\lambda)=y.
\]
Multiplicity and nilpotent parts are permitted. For \(\lambda\ne0\)
one branch tends to zero at \(y=0\) and \(r\) branches tend to
\(\lambda\). This is not a claim that the base quantum theory is
semisimple.

**Attribution and support.** These are manuscript genus-zero
assertions, using the cited equivariant shift input
(`shift:iritani-input`). The old claim is an open source pointer with
no assumptions registered, certificate, or judgement. Its empty graph
dependency list is not a proof of these assertions.

**Obligations.** Verify applicability and signs of the shift theorem;
the section normalization, polynomial equivariant pairing and actual
homology labels; the fiber-degree lower bound and virtual-dimension
argument giving polynomiality for every base class; the two grading
identities; and the residual fiber multiplication, coefficient of \(y\),
and nilpotent-base filtration determining the spectrum.
Common-\(R\) factorization and finite-moment Lean do not imply any of
these shift polynomiality or spectrum statements.

### `C_PROJ_SPECTRAL@1`: projectors, logarithms, and block modes

**Exact assertions and setting.** Section `spec:section` works locally
with holomorphic parameter germs, completed in nonnegative loop degree
and ample base degree. Each coefficient is a finite-order
\(\lambda\)-differential operator; multiplication is noncommutative
composition. There is no required convergence of a total Novikov or
\(z\)-series. On the generic locus take \(\lambda\ne0\), \(y\ne0\),
distinct roots \(h_i\), and locally chosen logarithms of
\(a_i=\lambda+h_i\).

Lemma `spec:calculus` constructs coefficientwise contour functional
calculus and orthogonal supported projectors \(P_i\) and logarithms
\(\mathscr L_i\) (`spec:projectors`). Proposition `spec:commutators`
asserts
\[
 [P_i,\lambda]=0,\quad [\mathscr L_i,\lambda]=zP_i,\quad
 [G_a,P_i]=[G_a,\mathscr L_i]=0,
\]
and hence that \(P_i\) and
\(\mathscr L_i-zP_i\partial_\lambda\) are matrices, without coefficient
differentiation. The supported grading
\[
 D_i=P_iG_a-\frac{\lambda}{z}\mathscr L_i,\qquad
 P_iD_i=D_iP_i=D_i
\]
differentiates only \(z\). Proposition `spec:modes` asserts that
\[
 A_{-1,i}=z^{-1}P_i,\qquad
 A_{k,i}=z^{-1}(zD_i)^{k+1}\quad(k\geq0)
\]
has loop powers at least \(-1\), Euler differential order at most
\(k+1\), no \(y,\lambda,Q\) derivatives, and coefficientwise
continuation with the branch and logarithm. Scalar changes
\(D_i\mapsto D_i+bz^{-1}P_i\) give its stated invertible triangular
binomial change of modes. Modes of a group are sums of branch modes.

Near \(y=0\), Proposition `spec:zero` asserts holomorphic germs for
\(P_B,P_X,\mathscr L_X\), with Taylor identities
\[
 P_F=S_W\Pi_FS_W^{-1},\qquad
 \mathscr L_X=S_W\mathscr L_{d,X}S_W^{-1}.
\]
It asserts divisibility of \(T_aP_B\) by \(y\), and that the nonzero
block of \(y^{-1}T_aP_B\) has eigenvalue \((-\lambda)^{-r}\) at
\(y=z=Q^{>0}=0\). Its supported logarithm \(\mathscr K_B\) is
holomorphic through zero and
\[
                 \mathscr L_B=(\log y)P_B+\mathscr K_B
\]
on a punctured sector. Thus \(B\)-mode coefficients are finite
polynomials in \(\log y\) (degree at most \(k+1\)); \(X\)-cluster
mode coefficients are holomorphic through zero.

**Scope correction, attribution, and evidence.** Section 6 expressly
makes **classical operator** assertions. Infinitesimal symplecticity and
legitimate quantized equations use the later fixed-block comparison
and continuation; Section 6 alone does not assert ordinary constraints.
The old graph records only `C_PROJ_SHIFT` as this node's dependency,
and supplies no bound evidence. In the actual source, `spec:zero`
also invokes `loc:factorization` for rational Laurent changes of
frame. This additional source dependency has not been silently
discharged or added to the old graph.

**Obligations.** Justify the completed noncommutative resolvent calculus,
its coefficient finiteness, contour/composition/commutator rules,
and allowable Laurent gauge changes (`spec:gauge`); cancellation of
coefficient derivatives and mode bounds; continuation of individual
coefficients; and the zero-fiber comparison, divided \(B\) shift, and
logarithm prescription. Then separately justify symplecticity and
coefficientwise quantization in the later stages. Finite even
commutative-ring resolvent/moment lemmas are not a certification of
these parameter-differential, projector, or logarithm manipulations.

### `C_PROJ_FIXED@1`: fixed-block versus ordinary equations

**Exact assertion.** Proposition `fixed:equivalence` fixes a
\(\lambda\ne0\) germ and works near \(Q=y=0\) in the full Novikov
completion, with polynomial dependence on an adjoined formal
\(\log y\) at each coefficient. Let \(F=B\) be the branch near zero,
or \(F=X\) the **whole cluster** near \(\lambda\), with
`spec:zero`'s logarithms and modes. For the ancestor potential of
\(W\) at background zero it asserts the simultaneous equivalence
\[
 \mathcal A_W\text{ satisfies all }A_{k,F}\text{ projectively}
 \iff
 Z_F\text{ satisfies all ordinary }\ell_{k,F}\text{ projectively},
 \qquad k\geq-1.
\]
The left modes are infinitesimal symplectic for \(W\)'s equivariant
pairing; the right potential is ordinary, with full cohomology and
actual integral curve labels. This does not identify a single generic
\(X\)-branch with the whole theory of \(X\).

For precision, put \(n=\operatorname{rk}N_F\), normal weight \(w\),
\(a=w\lambda\), \(j_B=1,j_X=0\), and \(c_N=c_1(N_F)_{\rm ord}\);
\((n_B,w_B)=(r,-1)\), \((n_X,w_X)=(1,1)\). After passage to the
descendant fixed frame and the paired-space multiplier
\(\Delta_F\) of `fixed:Delta`, `fixed:classical` gives the grading
\[
 \ell_{0,F}+b_F/z,\qquad
 b_F=\lambda\bigl(nw-j\log y-nw\log(w\lambda)\bigr),
\]
up to the scalar shift from the logarithm branch. The corresponding
translated modes satisfy the unit-diagonal triangular identity
`fixed:binomial`, so simultaneous projective equations are equivalent
to the unshifted ones.

The quantized comparison uses the **normalized** characteristic class
\(c_0(N_F)=\prod_x(1+x/a)^{-1}\), not a direct analytic quantization
of the entire logarithmic multiplier. Lemma `fixed:qrr-normalized`
asserts
\[
 Z_{F,\mathrm{ntw}}=(\text{invertible scalar})\,
 U_{\Delta_{F,0}}Z_F
\]
formally in \(\lambda^{-1}\), with the stipulated pairings and dilaton
translations. `fixed:Delta-normalization` is
\(\Delta_F=a^{n/2}e^{-\log(a)c_N/z}\Delta_{F,0}\).
Lemma `fixed:rank-scaling` restores the actual inverse-Euler theory by
\[
 m_F=a^{-n},\qquad
 \hbar\mapsto\hbar/m_F,\quad
 Q^\beta y^l\mapsto Q^\beta y^l a^{-\int_d c_N},\quad
 \eta_F^t=m_F\eta_F^{\mathrm{ntw}}.
\]
The proof then uses rational finite coefficient tests to pass from
formal \(\lambda^{-1}\) identities to nonzero-\(\lambda\) germs,
fixed-theory ancestor–descendant covariance, and **both** common-\(R\)
factorizations. It does not evaluate an infinite quantized
transformation analytically.

**Attribution and evidence.** The manuscript supplies the comparison
and invokes quantum Riemann–Roch. The old open node depends on
`C_PROJ_SPECTRAL` and has no certification or judgement. Supporting
the common-\(R\) input would still not prove this ordinary
Virasoro identification.

**Obligations.** Verify the Bernoulli/difference and functional-logarithm
identities, paired-space square-root direction, ordinary grading and
binomial comparison; the exact full-super-cohomology quantum
Riemann–Roch specialization and dilaton coordinates; rank, genus,
Novikov and pairing rescalings; rational finite-support passage to
germs; and invertible ancestor/common-\(R\) quantized covariance with
the required filtrations. None is supplied by the finite-moment
certificate.

### `C_PROJ_CONTINUATION@1`: coefficient tests, branch transport, scalar

**Exact assertions.** Lemma `cont:polynomiality` fixes genus \(g\),
an actual base class \(\beta\), and insertions
\(b_i\bar\psi_i^{a_i}\). The connected **ancestor** invariant of \(W\),
summed over \(l\) with weight \(y^l\), is polynomial in \(y,\lambda\);
curve-unstable distinguished data are omitted, and it vanishes unless
\[
                         \sum_i a_i\leq3g-3+n.
\]
The ancestor bound is independent of fiber degree. It is not a
uniform bound on ordinary descendants over all curve classes.

Lemma `cont:finite-tests` applies to
\(\mathcal E_{k,i}=\mathcal A_W^{-1}
\operatorname{op}(A_{k,i})\mathcal A_W\), for fixed \(k\geq-1\),
\(\hbar^{G-1}\), \(\beta\), and an insertion monomial. It asserts a
finite sum of holomorphic coefficient germs on the generic spectral
cover with chosen logarithms. Near zero, the \(B\) test is polynomial
in \(\log y\) with holomorphic coefficients and the \(X\)-cluster test
is holomorphic; Taylor expansion gives the corresponding formal
Novikov test. Projective equations concern its positive-insertion
coefficients. The assertion is **coefficientwise continuation**, not
convergence of a total potential or continuation of a full quantized
frame.

For fixed \(\lambda\ne0\), `cont:monodromy` asserts transitivity of
the \(r+1\) branches of \(y=h^r(h+\lambda)\) off the critical values
\[
                  0,\qquad
                  \frac{(-r)^r\lambda^{r+1}}{(r+1)^{r+1}}.
\]
Proposition `cont:projective-transfer` asserts that projective
satisfaction of all ordinary modes on \(B\) passes to \(X\):
continue the \(B\) equations, account for logarithm changes by the
binomial mode change, sum all \(r\) branches of the \(X\) cluster,
return to \(y=0\), and use `fixed:equivalence`.

Lemma `cont:commutators` and corollary `cont:exact` assert
\[
 [L_{-1}^Y,L_1^Y]=-2L_0^Y,\qquad
 [L_0^Y,L_k^Y]=-kL_k^Y\quad(k\geq-1,\ k\ne0),
\]
and that projective satisfaction of every ordinary mode implies
\(\mathcal V(Y)\) with exactly \(C_Y\). The proof of `thm:main` at
the end of Section 8 combines this with projective transfer.

**Attribution and evidence.** These are manuscript continuation and
normalization assertions, not a conclusion of the old localization
report. The open node records dependencies on `C_LOC` and
`C_PROJ_FIXED`; there is no bound certificate or judgement.

**Obligations.** Establish polynomiality and stable ancestor bounds;
finiteness of every quantized coefficient test through genus, loop,
insertion and base-degree decompositions; the passage from formal
Taylor identities to germs; continuation, logarithm changes,
transitive monodromy and return of the entire \(X\) cluster; and the
supertrace/normal-ordering calculation and scalar-removal argument.
Neither all-genus common-\(R\) geometry nor finite-moment Lean implies
analytic/coefficientwise continuation or the exact ordinary scalar
normalization.

## Evidence limits and completion

The old finite-moment fidelity note explicitly limits Lean to finite
nilpotent inverses and linear/multilinear moment naturality in even
algebra. It defines no GW moduli, obstruction theories, ancestors,
\(S\), \(R\), or quantization. It cannot certify any of the four
downstream stages by implication. Even granting common-\(R\) geometry
as a separate unit leaves the shift, differential functional calculus,
ordinary comparison and continuation obligations just named.

No downstream computation or formal proof is attached to these five
claims to replay. Re-running the localization algebra checker or Lean
would not test them, so none was presented as such validation. This
assessment checked source statements and the decisive old evidence
bindings, not every manuscript proof and not theorem novelty. No
mathematical counterexample, repair, new result, or old independent
review is asserted. There was **no access blocker**.

The completed disposition is therefore: **five manuscript-attributed,
open, uncertified downstream claims; final theorem novelty unassessed;
review acceptance pending the native independent Reviewer**.
