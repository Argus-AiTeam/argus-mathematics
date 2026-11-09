# Fixed-relation determinacy: old-draft unit assessment

## Status, attribution and inputs

**Engineer assessment: supported under the stated hypotheses, by a general
prose argument with freshly replayed exact support. Native independent review
remains pending.** This is neither a family acceptance nor a Lean/kernel claim.
No mathematical defect was found in the quantified determinacy argument.

The unit is `fixed-relation-determinacy` in `research/DRAFT_REVIEW_INDEX.json`.
Its manuscript source is OpenAI, *A singular normal affine surface with free
tangent sheaf*, September 23, 2026, staged at upstream revision
`4eaee87548250b2682affda7d05d947c05554bae` according to the index. The author/date
are also explicit in the staged manuscript's README. Below, `OLD` denotes
`campaigns/9000048`, and `SRC`
denotes `OLD/research/openai_manuscript/`
`A-singular-normal-affine-surface-with-free-tangent-sheaf-September-23-2026`.

Read inputs:

* `SRC/build/06-algebraization.tex`, in full, especially
  `algebra:ideal-presentation`, `algebra:conormal-dual`,
  `algebra:finite-determinacy`, and the subsequent clarification about `B`.
* `OLD/research/algebraization_audit/report.md`, **in full**, including the
  affine descent argument, not only its conclusions.
* The complete `verify.py`, certificate, positive output, separate invalid-CLI
  control, and four historical typed-Jacobian contract/payload/output/run files
  in that audit directory.
* Every version of the five indexed ledger claims, their evidence and routes
  in old `MATH_STATE.json`, relevant old `PROOF_GRAPH.json` nodes, and the
  primary passages identified below.

The old audit's mathematical proof and checker are attributed by the ledger
to `engineer:gpt-6-astra`. Its later `reviewer:gpt-6-astra` judgment labels
point to the **same report**; the citation JSONs are excerpt notes, not
completed native review receipts. The graph still marks
`M_finite_determinacy`, `M_algebraization`, `AG_independent_review` and `M_main`
open, with `reviewer_confirmed=false`. Those labels therefore do not establish
independent acceptance of this argument.

The coverage index/parent provenance check establishes that all **14 core
source/certificate artifacts** match their preserved snapshot identities.
The other **97 manifest artifacts have size matches only**. Reading a
supporting source here does not upgrade it to snapshot-authenticated evidence.
All old inputs were treated read-only.

## 1. Exact claim and latest versions

Let \(P=\mathbb C[[x_1,\ldots,x_e]]\), \(\mathfrak n=(x)\),
\(f\in\mathfrak nP^s\), \(I=(f)\), \(R=P/I\), and
\(\mathfrak m=\mathfrak nR\). Require a **full original presentation**
\[
P^t\xrightarrow D P^s\xrightarrow f I\longrightarrow0.
\]
For row vectors set
\[
\psi(v)=v\bar D,\quad K=\ker\psi,\quad
J=\sum_j R\,\overline{\partial_jf}.
\]
Assume \(K/J\) has finite length. Then there are **fixed** \(N,n_0\),
depending only on \(f,D\), such that every pair satisfying
\[
gB=0,\qquad g-f\in\mathfrak n^{n_0}P^s,\qquad
B-D\in\mathfrak n^NP^{s\times t}
\]
has \(f=\Phi(g)U\), with \(\Phi\) a continuous \(\mathbb C\)-algebra
automorphism, \(\Phi(x)-x\in\mathfrak n^2\), and
\(U\in GL_s(P)\), \(U-1\in\mathfrak nP^{s\times s}\).
No completeness of the **approximating** relations \(B\), reducedness,
complete-intersection condition, or analytic convergence is assumed.

| Indexed claim | Latest | Assessment |
|---|---:|---|
| `M_finite_determinacy` | v3 | Supported with these exact quantifiers; §2 checks the step and the two limits. |
| `AG_fixed_step` | v2 | Supported; three independent Artin--Rees losses are genuinely included. |
| `AG_formal_limit` | v1 | Supported; the generator matrix must be substituted at each update. |
| `AG_equations_only_obstruction` | v1 | Supported failed-route example, not a manuscript counterexample. |
| `AG_prior_art` | v3 | Supported historical attribution, not a novelty claim or replacement proof. |

These are not five independent algebraization results. The fixed step and
limit prove the one determinacy lemma; the example excludes a different
route; the last claim identifies existing methods.

## 2. Checking the decisive argument

### Original syzygies and the three losses

Right-exact tensoring of the original presentation gives
\(R^t\to R^s\to I/I^2\to0\); taking its dual identifies
\(K=\operatorname{Hom}_R(I/I^2,R)\). This does **not** assert left exactness
after tensoring. Differentiating \(fD=0\) gives \(J\subset K\).
Full original syzygies justify precisely this conormal interpretation.

Artin--Rees (the exact statement is recorded in §5) supplies, independently,
\[
\begin{aligned}
\operatorname{im}\psi\cap\mathfrak m^rR^t
 &\subset\psi(\mathfrak m^{r-\alpha}R^s),\\
K\cap\mathfrak m^rR^s&\subset\mathfrak m^{r-\beta}K,\\
I^{\oplus s}\cap\mathfrak n^rP^s
 &\subset\{fC:C\in\mathfrak n^{r-\delta}P^{s\times s}\}.
\end{aligned}
\]
The first is an image-filtration estimate, the second is a kernel-filtration
estimate, and the third lifts ideal-valued errors with controlled
**coefficient** order. The third cannot be inferred merely from membership
in \(I^{\oplus s}\). Each applies for \(r\) at least its own loss.

Choose \(\ell\) with \(\mathfrak m^\ell K\subset J\), and put
\[
c_0=\beta+\ell,\qquad c=c_0+\delta,\qquad N\ge\alpha+1,\qquad
n_0\ge\max(c+N,c+2,2c+1).
\]
Here \(\delta\) is the manuscript's filtration loss \(d\), not the geometric
dimension. All constants are for the fixed original \(f,D\).

### Correcting an error at order \(n\)

For \(h=g-f\in\mathfrak n^n\), reduce modulo the **fixed** ideal \(I\).
The exact equation \(gB=0\) gives
\[
\bar h\bar D=-\bar h(\bar B-\bar D)\in\mathfrak m^{n+N}R^t.
\]
The factor is \(\bar h\), not an uncontrolled vector. This is where the
improving order \(n+N\) originates. A merely approximate zero product would
add an uncontrolled term and would not prove the claim as stated.

The first loss produces \(\bar\epsilon\) of order \(n+N-\alpha\ge n+1\)
with \(\psi(\bar\epsilon)=\psi(\bar h)\). Consequently
\[
\bar h-\bar\epsilon
\in K\cap\mathfrak m^nR^s
\subset\mathfrak m^{n-\beta}K
\subset\mathfrak m^{n-c_0}J.
\]
Lift the derivative coefficients \(a_j\) in order \(n-c_0\) and
\(\epsilon\) in order \(n+1\). The remainder
\[
w=h-\sum_j a_j\partial_jf-\epsilon
\]
belongs to \(I^{\oplus s}\cap\mathfrak n^{n-c_0}P^s\), **not necessarily
to order \(n\)**: a derivative of an original equation can be a unit.
The third loss gives \(w=fC\) with \(C\) of order \(n-c_0-\delta=n-c\).
Thus, for \(q=n-c\),
\[
h=\sum_j a_j\partial_jf+fC+\epsilon,\quad
a_j,C\in\mathfrak n^q,\quad\epsilon\in\mathfrak n^{n+1}.
\]
The selected \(n_0\) ensures \(n+N\ge\alpha\), \(n\ge\beta\), and
\(n-c_0\ge\delta+2\), so no Artin--Rees estimate is used outside its range.

### Simultaneously improving equations and preserving relations

Use the ordered transformations
\[
\phi(x_j)=x_j-a_j,\quad M=(1+C)^{-1},\quad
g_{\rm new}=\phi(g)M,\quad B_{\rm new}=(1+C)\phi(B).
\]
The bounds give \(q\ge N\), \(q\ge2\), \(2q\ge n+1\), and
\(n+q-1\ge n+1\). The identity-linear-part substitution has a recursive
formal inverse, and \(1+C\) is invertible in the complete local matrix ring.

A monomial of degree \(r\) with \(k\) replacements has order at least
\(r-k+kq\). With \(k\ge2\) it has order at least \(2q\); in \(h\), a
nontrivial replacement has order at least \(n+q-1\). Completeness justifies
these estimates coefficientwise for power series. Hence
\[
\phi(f)=f-\sum_j a_j\partial_jf+O(\mathfrak n^{2q}),\quad
\phi(h)=h+O(\mathfrak n^{n+q-1}),
\]
and \(g_{\rm new}-f\in\mathfrak n^{n+1}\).

In the relation calculation the matrix order matters:
\[
g_{\rm new}B_{\rm new}
=\phi(g)(1+C)^{-1}(1+C)\phi(B)=\phi(gB)=0.
\]
For every \(F\in P\), \(\phi(F)-F\in\mathfrak n^q\); therefore
\[
B_{\rm new}-D=C\phi(B)+(\phi(B)-B)+(B-D)\in\mathfrak n^N.
\]
The same original \(D\) and the same \(N\) persist. **At no step is
\(\operatorname{im}B=\ker g\) required.** Exact zero product plus closeness
is what is used. This establishes `AG_fixed_step` v2.

### Both cumulative changes converge

The correct recurrences are
\[
\Phi_{n+1}=\phi_n\circ\Phi_n,\qquad
U_{n+1}=\phi_n(U_n)M_n,\qquad
\Phi_{n_0}=\mathrm{id},\ U_{n_0}=1.
\]
Inductively \(g_n=\Phi_n(g)U_n\). Both
\(\Phi_{n+1}(x_j)-\Phi_n(x_j)\) and every entry of
\(U_{n+1}-U_n\) have order at least \(n-c\), which tends to infinity.
The omitted substitution in an update such as \(U_{n+1}=U_nM_n\) would
not express the actual composite transformations.

The limits have identity linear part and identity residue, respectively,
so are invertible. On every \(P/\mathfrak n^r\) the substitutions and
matrices eventually stabilize; substitution of the original **formal
series** is therefore compatible with taking the limits. Since
\(g_n-f\in\mathfrak n^n\) and \(P\) is separated, the limit identity is
\(f=\Phi(g)U\). This proves `AG_formal_limit` and the latest
`M_finite_determinacy`. It proves formal, not holomorphic, convergence.
Empty equation/relation modules cause no difficulty; the empty-equation
case is immediate.

## 3. The equations-only perturbation and its proper interpretation

For
\[
f=(xz-y^2,xw-yz,yw-z^2),\qquad
D=\begin{pmatrix}z&w\\-y&-z\\x&y\end{pmatrix},
\]
the indicated zero product is exact. The quotient is
\(\mathbb C[[u,v]]^{\mu_3}\), via
\((x,y,z,w)=(u^3,u^2v,uv^2,v^3)\).
The three relations reduce monomials to
\(x^aw^b,x^ayw^b,x^azw^b\); their images have distinct exponent residue
classes and exhaust the invariant monomials. Degreewise reduction proves
the formal-ring assertion. This ring is finite free of rank three over
\(\mathbb C[[x,w]]\), a normal domain of dimension two. Normality follows
by viewing an integral invariant fraction inside the integrally closed
\(\mathbb C[[u,v]]\).

The algebraic/analytic cone is smooth away from the origin: the \(x\ne0\)
and \(w\ne0\) charts eliminate to two smooth coordinates and cover the
punctured cone. This is **not** an unrestricted elimination isomorphism
of localized formal power-series rings. The origin has embedding
dimension four and dimension two.

For every \(k\ge3\), replacing the third equation by \(yw-z^2+x^k\)
gives \(g_k-f\in\mathfrak n^k\), but
\[
g_kD=(x^{k+1},yx^k),\qquad\sqrt{(g_k)}=(x,y,z).
\]
Indeed \(z(g_k)_1-y(g_k)_2+x(g_k)_3=x^{k+1}\); successively the radical
contains \(x,y,z\), and the reverse inclusion follows by setting them
zero. The quotient dimension is one. This exact all-\(k\) example
disproves **arbitrary equation-only** approximation, the retired route
`R_AG_equations_only`. The displayed pair does not satisfy the required
zero product. It is not a refutation of relation-preserving determinacy,
of the manuscript, or of algebraization. No novelty is claimed for it.

## 4. Every historical version and route

All versions of each claim below have the same natural-statement hash
within that claim; their `formal_statement` fields are empty. Assumption
metadata changes still matter even when that hash is unchanged.

| Claim/version | Historical change and assessment |
|---|---|
| `M_finite_determinacy` v1 | Original assertion without explicit imported assumptions. The argument checked above supports its mathematical statement retrospectively; this was not independent evidence. |
| v2 | Same statement; adds omnibus `Artin_Rees_input`. That placeholder alone did not check the three losses or the two limits. The present direct check supports the statement, not reliance on an omnibus citation. |
| v3, latest | Retires the omnibus placeholder in favor of `AG_fixed_step`/`AG_formal_limit` and proposition-level `AG_Artin_Rees`. Supported. Retirement does not eliminate the Artin--Rees assumption. |
| `AG_fixed_step` v1 | Explicit constants and simultaneous improvement already stated. Supported by §2; no recorded source-specific assumption yet. |
| v2, latest | Adds `AG_Artin_Rees` with exact Tag 00IN locator. Same supported mathematical statement. |
| `AG_formal_limit` v1, latest | Only recorded version. Supported with both recurrences, not merely convergence of the coordinates. |
| `AG_equations_only_obstruction` v1, latest | Only recorded version. Supported in the failed-route scope of §3. |
| `AG_prior_art` v1 | Correct historical comparison asserted without source-specific assumptions; supported retrospectively by the actual passages. |
| v2 | Adds the exact Hironaka 3.3 assumption. Supports that attribution, but does not itself document the Artin half. |
| v3, latest | Adds Artin 3.8--3.9 and their proof. Both historical attributions are supported after passage comparison; no new method is established. |

Statement hashes:

* `M_finite_determinacy`: `b5c4357925b05c1979404e3af0d4f9e02c077787d643522c75b0903a0f2f142c`.
* `AG_fixed_step`: `775abb4e757e9afe12fe9f6e52fdbdd2ed99b73bef0ac03f40b98eacbb4b3775`.
* `AG_formal_limit`: `848c0ad7af8377f739c36f6940482adfbe61ecd9fc2cf406c0a13ce8d78ef29a`.
* `AG_equations_only_obstruction`: `6d153375960a78fc8c2773c5f619c61c9cdef4d0cf13bc332de6959a3226cd3c`.
* `AG_prior_art`: `fd864ae85fff2e11e345297fc56598767ff3b0d90aae202656972ca1d95f8feb`.

`R_M_finite_determinacy`, with only the literature-inventory obligation,
was retired as a coarse scaffold, not disproved. `R_AG_fixed_precision`
explicitly requires the step and limit, and `R_AG_convergence` requires
the fixed step. These refinements expose the actual proof obligations.

## 5. Primary-source checks and external assumptions

Paths in this section are under
`OLD/research/literature/algebraization_sources/`.

1. **Artin--Rees**, Stacks Tag **00IN**, Lemma 10.51.2:
   for a Noetherian ring \(A\), ideal \(\mathfrak a\), and finite
   \(N\subset M\), some \(c>0\) satisfies
   \(\mathfrak a^rM\cap N=
   \mathfrak a^{r-c}(\mathfrak a^cM\cap N)\) for every \(r\ge c\).
   Read the exact archived statement in `stacks_inputs.txt` and the
   current primary tag, including the statement in raw HTML.
   Apply separately to the three finite submodules in §2. For a finite
   map \(u\), \(\mathfrak a^{r-c}\operatorname{im}u
   =u(\mathfrak a^{r-c}M)\), which gives the controlled lifts.
   This is the general proof's external theorem, not something certified
   by the polynomial inequalities.

2. **H. Hironaka**, *Formal line bundles along exceptional loci*,
   TIFR Studies 4 (1969), §3, Example I and **Theorem 3.3**.
   Read `hironaka_section3.txt` (including preceding equivalence criteria)
   and `historical_equivalence_excerpt.txt`.
   Locators: original page markers **210--211**, re-typeset **220--221**,
   PDF **229--230**; Remark 3.7 on re-typeset p.222.
   Source: `https://mathweb.tifr.res.in/Documents/Publications/Studies/SM_04-Algebraic-Geometry.pdf`.
   The setup is a completion of a localization of \(k[x]\), \(k\)
   Noetherian, with ideal of definition \(H\), an exact original finite
   free presentation, and hypothesis **(3.1)** that \(X-Y\) is formally
   \(k\)-smooth, expressed by the codimension-sized Jacobian minors.
   Its conclusion fixes \(s,t,r\) and allows every \(j\ge t\), assuming
   \(f'g'=0\), \(g'\equiv g\bmod H^s\), and
   \(f'\equiv f\bmod H^j\). It gives a near-identity automorphism inducing
   the equivalent quotient. It does **not** require the approximating
   pair to remain exact at the middle term.
   This verifies the fixed-relation prior-art attribution. It is not
   silently imported as a theorem with the different, abstract
   finite-length \(K/J\) hypothesis; §2 proves that formulation directly.

3. **M. Artin**, *Algebraic approximation of structures over complete
   local rings*, Publ. Math. IHÉS 36 (1969), 23--58,
   **doi:10.1007/BF02684596**, **Theorems 3.8--3.9 and proof**,
   printed **32--34**, PDF **11--13**.
   Read the primary extraction `artin_1969.txt`, lines 443--522, against
   `historical_equivalence_excerpt.txt`. Theorem 3.8 starts with a
   quotient of \(k[[X]]\), \(k\) a field, formally smooth off its closed
   point. Theorem 3.9 uses the henselization of \(k[X]\) at a prime, a
   proper ideal \(\mathfrak a\), and a quotient of its
   \(\mathfrak a\)-adic completion formally smooth outside \(V(\mathfrak a)\).
   They give algebraizations preserving the completed quotient. The
   proof explicitly approximates two presentation maps with zero
   composite, using Theorem 1.10 and Hironaka.
   These exact hypotheses, including their Jacobian/formal-smoothness
   terminology, are historical attribution, not a replacement for the
   finite-length proof or for tangent descent.

Artin's **Theorem 1.10**, printed p.26/PDF p.5, was also read in the
primary extraction and `artin_approximation_excerpt.txt`. It supplies an
**exact** solution in a henselization, with prescribed finite agreement
with a formal solution, in the field/excellent-DVR setting stated there.
Its use belongs to the companion `affine-algebraization` assessment;
it is not needed to prove the conditional determinacy lemma.

## 6. Evidence types and fresh replay

The old certificate checks universal **polynomial identities and linear
inequality witnesses**, not instances in a bounded integer box. Its 13
nonnegative-combination witnesses imply all the required order slacks
under the listed parameter inequalities. The monomial bounds are
symbolic. Matrix checks have stated finite arities (not arbitrary rank);
the arbitrary-rank identities and convergence are established in prose.
The certificate does not construct an explicit affine counterexample.

The historical typed computation is one
`matrix.symbolic.multiply.compute` product of a generic two-by-two
\(1+C\) and its adjugate over \(\mathbb Q(a,b,c,d)\).
The saved canonical sparse payload and response give
\(((1+a)(1+d)-bc)I_2\). The contract/run identify server **0.14.0**,
protocol **2025-11-25**, adapter exit **0**, no timeout or structured error,
and response runtime **26 ms**. This only supports that bounded identity;
the historical `offline_exact_replay` flag is not a current live call.
No Jacobian module or adapter was imported or executed by this assessment.

Because there is no applicable native determinacy/algebraization review
receipt, a fresh **Engineer** execution was warranted. Persistent evidence:

* `evidence/replay.py`: reads the preserved checker into memory, disables its
  saved-Jacobian check, and calls only `derive`, `verify_assertions` and
  `negative_controls`. The extra real invalid-certificate CLI invocation
  fails **before** any Jacobian-check code is reached.
* `evidence/replay.json`: **passed 107 derived assertions and 13 universal
  inequality certificates; rejected all 18 corrupted assertions**.
  The separate CLI changes `N+n` to `N`, exits **1**, and identifies
  `derived.orders.relation_error`, with empty stderr.
* Actual successful toolchain:
  `$WORKSPACE/miniconda3/bin/python3`, **Python 3.13.5**,
  **SymPy 1.14.0**, `-B`, `PYTHONDONTWRITEBYTECODE=1`.
  The requested Argus interpreter was tried first but lacks SymPy;
  using the already installed checker dependency avoided installing or
  changing anything. No Argus module was invoked in this replay.
* Runtime **3.184403 s**; no durable runner or background shell was needed.
  All generated evidence/cache destinations were within this owned unit.
  Selected old inputs' before/after SHA-256 values match.

For the same finite-support replay, from the active campaign root:

```sh
PYTHONDONTWRITEBYTECODE=1 \
TMPDIR="$PWD/research/draft_reviews/fixed-relation-determinacy/evidence" \
XDG_CACHE_HOME="$PWD/research/draft_reviews/fixed-relation-determinacy/evidence" \
PYTHONPYCACHEPREFIX="$PWD/research/draft_reviews/fixed-relation-determinacy/evidence" \
$WORKSPACE/miniconda3/bin/python3 -B \
  research/draft_reviews/fixed-relation-determinacy/evidence/replay.py
```

The rejecting controls test actual asserted fields, including the missing
third loss, the lost factor \(n\), wrong matrix transformations, the
generator-derivative term, and an overbroad kernel-certification scope.
Rejecting them is useful sensitivity evidence, not a proof of Artin--Rees,
completeness, the conormal interpretation, or the general theorem.

## 7. Conclusion and remaining obligations

The latest and superseded mathematical statements are justified in their
stated scopes after the checks above. No unresolved mathematical gap was
identified **under the full original-presentation, finite-length and exact
zero-product hypotheses**. Removing any of these hypotheses is not a
result of this review.

The concrete outstanding evidentiary obligation is native independent
review of this unit and its source applications. Nominal reviewer labels
and arithmetic replay do not discharge `AG_independent_review`.
The historical analytic receipt `8ba02f2780af/round-0001.json` is confined
to the analytic input; its mission explicitly leaves algebraization open.
Neither it nor this Engineer assessment accepts `M_main`, any other unit,
the whole family, originality, or a Lean theorem.
