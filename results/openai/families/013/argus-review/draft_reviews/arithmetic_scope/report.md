# Arithmetic source scope and the retired counts-only route

## Assessment and boundary

This is the bounded `arithmetic_scope` unit of old-draft review family 013.
It assesses the attribution, statement fidelity, dependencies, and evidentiary
scope of `C_OSTMANN`, `C_FINITE`, `C_TWO_INFINITE`, `C_COLLISION`,
`C_QUADRATIC`, `C_CHARACTERS`, `C_FLAT`, `C_SUPPLY`, `C_ARITH`,
`C_TRANSFER`, `C_FINAL`, and retired route `R_COUNTS_ONLY`.
It is **not** a new search for a manuscript error or an independent proof of
the arithmetic inputs. Section 06's tree proof, Lean, and Jacobian are outside
this unit. Hashing Section 06 below is only a version check.

The old draft correctly distinguishes its local finite-field work from the
manuscript's arithmetic assertions. Its arithmetic map is substantially
faithful, with the dependency and locator qualifications identified below.
The counts-only route is correctly retired for the stated asymptotic bounds.
Neither conclusion verifies or refutes Ostmann's conjecture. The arithmetic
theorems remain unaudited as theorems by this old local draft; that is an
evidence boundary, **not** evidence that the source assertions are false.

“Supported” below can mean that an attribution or conditional implication is
supported; it must not be read as certification of its unproved antecedents.
This unit's completion is not family acceptance. Only the native,
Host-invoked independent Reviewer can decide that.

## Sources, versions, and read-only comparison

The contract and inventory are `OBJECTIVE.md`, `PRIOR_DRAFTS.json`, and the
already-created `research/DRAFT_REVIEW_INDEX.json`. The historical arithmetic
entries are in the old workspace's `research/MATH_STATE.json:53-206`, under
`CTX_PRIME`, which explicitly says that none is adopted as a proved input to
the independent finite-field theorem. The relevant historical exposition is
`research/tree_comparison/report.md:15-28,56-83,548-555`; the retired route is
also recorded at `research/MATH_STATE.json:555-564` and
`research/PROOF_GRAPH.json:15-19`. These are read-only research data, not the
current task contract.

The source manifest is
`campaigns/9100013/MANUSCRIPTS.json`.
It fixes revision `4eaee87548250b2682affda7d05d947c05554bae` of
`the-additive-indecomposability-of-the-primes-September-24-2026`.
The manuscript identifies its author as **OpenAI** and its date as
**September 24, 2026** (`build/paper.tex:47-57`).

For locators below, `01`, ..., `09` abbreviate the corresponding files
`build/sections/01-introduction.tex`, ..., `09-conclusion.tex` under:

```
openai-math/preprints/
the-additive-indecomposability-of-the-primes-September-24-2026/
```

The staged reference-input path is:

```
families/013/first-pass/
openai_manuscript/the-additive-indecomposability-of-the-primes-September-24-2026
```

That manuscript entry is a **symlink to the manifest's source directory**.
It is not a second, independently preserved copy. Every one of the eleven
manifest-listed TeX files was read through both paths and compared with its
supplied SHA-256. All eleven match at both paths:

| Manifest-relative file | Supplied and observed SHA-256 |
|---|---|
| `build/glyph-mappings.tex` | `90d559026990cc6958b4eac3c94789b603f904506b29aa56ef572d1569d57b89` |
| `build/paper.tex` | `cc064fd5a9ffd3c703de3f2636662302fe4622e50456780529ba4be9aca40650` |
| `build/sections/01-introduction.tex` | `58d391e18a6bbb89b7b7e448ec6feecafc9693b3d7a335fc37b29892c8a85242` |
| `build/sections/02-preliminaries.tex` | `36bc43557d1017f518e173d05e1d816bcdad33a573cde9d17efeaf01176498aa` |
| `build/sections/03-quadratic.tex` | `0dc53c61fdca1a0683093b27bc1f2f8fe7fa10df1c1a70525e01533edfac6e29` |
| `build/sections/04-characters.tex` | `f0b3313005aa97f316740f458e76b354d3956f59a1a9e3755acb93e39572d72c` |
| `build/sections/05-supply.tex` | `e506464427f27d8aae2f8c98e37aaa9df65eb806a76165be83e830a471e46313` |
| `build/sections/06-tree.tex` | `290c22fc61a7787fdf8d7074e5df48c0c98a65531f7399caa0a0fe7d626b9d00` |
| `build/sections/07-construction.tex` | `9e5c28cada90a8925aaba785d98bd05f7df0ae5a5f36830b30fc2135fd25a130` |
| `build/sections/08-arithmetic.tex` | `7a6ef909e6a8a22327c2a110b138fa347ee3eaf48eab2411af2bae9625ed734e` |
| `build/sections/09-conclusion.tex` | `978728b1fd71a523f01481731c6a474390b1b385b27869416de9999718cdda82` |

The three historical files actually used for this unit also match the
supplied preserved-snapshot manifest:

| Old-workspace file | Supplied and observed SHA-256 |
|---|---|
| `research/MATH_STATE.json` | `f8bd9465d776012da7b3f20a3fa8182ce11b8b1eb9df6d639e36c3933c3d607e` |
| `research/PROOF_GRAPH.json` | `a5eb64b3646aa256f35777f0664a882ec14e5e0e0e90a373fd36ff21b1e3a0c6` |
| `research/tree_comparison/report.md` | `de8826a28a8b03d8890cd99f7243b8a8420896e6e535e51d35a6c2a519ca8ef4` |

The snapshot reference is
`$WORKSPACE/.copilot/session-state/<id>/files/openai-audit-drafts-20261106T1020Z-manifest.json`.
This verifies the bytes against the supplied manifests, not the independent
provenance of the claimed Git revision. No Git operation, manifest rebuild,
source modification, or snapshot modification was performed.

## Common arithmetic hypothesis and conventions

For all claims after the finite-factor reduction the source supposes, for
contradiction, that **fixed infinite** sets \(A,B\subseteq\mathbb N_0\)
satisfy \((A+B)\triangle\mathcal P\) finite. Equivalently, a fixed threshold
\(N\) satisfies both

\[
 \mathcal P\cap(N,\infty)\subseteq A+B,\qquad
 (A+B)\cap(N,\infty)\subseteq\mathcal P.
\]

These are different hypotheses: full eventual prime coverage and eventual
absence of composite sums. Neither is merely a density assertion.
Choose \(N_*>|N|+10\) and put \(D=-B\) (`02:124-138`).
For every prime \(p\), the residues of
\(A\cap(p+N_*,\infty)\) and \(D\cap(-\infty,-p-N_*)\) are disjoint.
Choose any partition \(S_p,S_p^c\) containing those respective supports;
\(\sigma_p=|S_p|/p\) lies strictly between zero and one (`02:140-153`).
Unoccupied classes may be assigned to either side. The statements concern
the partitions so chosen, not arbitrary unrelated residue sets.

Finite-field norms and expectations use probability measure. The collision
lemma instead uses the **counting** squared norm of probability mass
functions. The additive Fourier transform is
\(\widehat f(a)=p^{-1}\sum_x f(x)e_p(-ax)\); multiplicative characters,
including the principal one, are zero at zero (`02:3-19`).
In particular, the later functions are exactly

\[
 F_p(x)=\frac{1_{S_p}(x)-\sigma_p}{\sqrt{\sigma_p(1-\sigma_p)}},
 \qquad
 g_p(v)=\sqrt p\,\mathbb E_x F_p(x)e_p(-vx).
\]

Thus \(g_p(0)=0\), \(\mathbb E_v|g_p(v)|^2=1\), and
\(g_p(-v)=\overline{g_p(v)}\); there is no assertion
\(|g_p|\le1\) (`04:1117-1124`; `05:3-10`).

## Claim-by-claim assessment

### C_OSTMANN — source theorem, not an Argus theorem

**Exact claim.** For every \(A,B\subseteq\mathbb N_0\) with
\(|A|,|B|\ge2\), the symmetric difference \((A+B)\triangle\mathcal P\)
is infinite. Equivalently, no finite modification of the primes is such
a sumset (`01:3-20`, `cor:ostmann`).

**Dependencies and attribution.** The source derives this from
`C_FINITE` and `C_TWO_INFINITE` (`01:22-26`; `02:119-123`).
It attributes the conjecture to Ostmann and the earlier finite-summand
reduction to Laffer and Mann (`01:7-13,22-25`). The present theorem is
asserted by the OpenAI manuscript; the old Argus draft records it.

**Conclusion.** The transcription and the reduction are supported.
The whole theorem is **unresolved by the old local draft**, because the
two-infinite-set contradiction requires the unaudited arithmetic chain
below. Nothing in a finite-field certificate establishes the universal
quantifier over integer sets.

### C_FINITE — short conditional reduction

**Exact claim.** If \(A,B\subseteq\mathbb N_0\) each have at least two
elements and their sumset agrees eventually with \(\mathcal P\), then both
sets are infinite (`02:90-108`, `lem:finite-factor`).

**Decisive implication.** If \(A\) is finite, choose two distinct shifts
from it. The source's fixed-shift sieve gives
\(B(Y)\ll Y/(\log Y)^2\); prime coverage and the prime number theorem give
\(A(Y)B(Y)\gg Y/\log Y\), whereas \(A(Y)\le |A|\).
The two logarithmic rates contradict each other. Interchange the summands
for the other case.

**Dependencies and boundary.** The fixed-shift lemma allows any fixed
distinct nonnegative shifts, with a threshold depending on the finite
exceptional range (`02:38-88`). Its proof uses the additive large sieve
(`02:23-36`) and Mertens' estimates. This implication does not use tree
comparison or character decorrelation. Its elementary final contradiction
is supported, conditional on those sieve and prime estimates; it is not
a new independently certified arithmetic result of the old draft.

### C_TWO_INFINITE — the remaining global theorem

**Exact claim.** No two infinite \(A,B\subseteq\mathbb N_0\) have
\((A+B)\triangle\mathcal P\) finite (`02:111-117`, `thm:main`).

**Dependencies.** This is the contradiction concluded at `09:379-386`,
not a preliminary counting lemma. The source uses its complete
construction, comparisons, transfers, and final symmetrization, summarized
by `C_FINAL` and its antecedents.

**Conclusion.** Statement fidelity is supported; its proof is
**unresolved within the old local work**. A route establishing only
`C_TREE`, or ruling out `R_COUNTS_ONLY`, does not establish this theorem.

### C_COLLISION — weighted stability with a maximal-atom hypothesis

**Exact claim.** Fix \(b\ge1\). Let \(\mu,\nu\) be probability measures
supported respectively on
\[
 A\cap(\sqrt X+N_*,X],\qquad D\cap[-X,-\sqrt X-N_*),
\]
each with maximal atom at most \((\log X)^b/\sqrt X\), and put
\(Q=\sqrt X/(\log X)^{b+1}\). Then
\[
 \sum_{p\le Q}\log p\left(
 \|\mu_p-U_{S_p}\|_2^2+\|\nu_p-U_{S_p^c}\|_2^2+
 \frac{\sigma_p^{-1}+(1-\sigma_p)^{-1}-4}{p}
 \right)\ll_b\log\log X .
\]
All summands are nonnegative (`02:232-249`, `lem:collision`, `eq:src2`).
This is uniform over the allowed measures; it is not a statement about
all measures on arbitrary sets or all primes without the cutoff.

**Decisive source reduction.** On their respective supports,
\(\|\mu_p-U_{S_p}\|_2^2=\|\mu_p\|_2^2-1/|S_p|\), and likewise for
\(\nu\). The left side becomes the sum of two congruent-pair energies
minus \(4\sum_{p\le Q}\log p/p\). Unequal pairs cost at most \(\log X\)
per measure, equal pairs cost \(O(Q\max\mu)\), and Mertens' estimate
leaves \(O_b(\log\log X)\) (`02:251-274`).

**Dependencies and conclusion.** This short reduction is internally
consistent with the stated norms and atom bound. The source locates its
method in the larger-sieve congruent-pair count (`02:220-225`), and
`lem:size` supplies appropriate long-tail measures in applications
(`02:275-292`). The attribution is supported; the old draft supplies no
separate certificate for this arithmetic input. In particular, transferring
the result to a given application still requires checking its tail sizes,
atom bound, cutoff, and norm normalization.

### C_QUADRATIC — independent translating centers at every prime

**Exact claim.** For the quadratic character \(\chi_p\), extended by zero,
\[
 \sum_{T\le\log p\le2T}\frac{\log p}{p}
       \max_{t\in\mathbb F_p}
       \left|\mathbb E_{x\in S_p}\chi_p(x-t)\right|=o(T)
       \quad(T\to\infty)
\]
under the common decomposition hypothesis (`03:4-19`, `prop:quadratic`).
The maximizing \(t\) is allowed to vary independently with \(p\).
The harmonic-band consequence holds for every fixed
\(0<\alpha<\beta\), with weight \(1/p\) and
\(\alpha L_*\le\log\log p\le\beta L_*\), giving \(o(L_*)\)
(`03:1060-1076`, `cor:quad-harmonic`).

**Dependencies and concrete unaudited obligations.** The proof uses
size and collision stability (`03:40-69`), an amplified moment and
Poisson argument uniform over coefficient arrays (`03:113-444`), a common
rational-center extraction from initially arbitrary centers
(`03:637-765`), a quadratic-large-sieve kernel bound
(`03:766-841`), and the exceptional-character/split-prime estimate before
the final collision contradiction (`03:894-1058`). In particular, the
source invokes Heath-Brown's quadratic large sieve for arbitrary complex
coefficients on odd squarefree indices and explains its signed extension
(`03:771-793`). These are real extra obligations beyond `C_COLLISION`.

**Conclusion.** The old statement is faithful, including the independent
maximum. The lengthy arithmetic proof is **unresolved by this local
draft**, not disproved. Replacing the independently varying centers with
a common center as an assumption would weaken the source claim.

### C_CHARACTERS — all orders greater than two, uniformly in the choice

**Exact claim.** For every fixed \(0<\alpha<\beta\),
\[
 \sum_{\alpha L\le\log\log p\le\beta L}\frac1p
 \max_{\substack{t\in\mathbb F_p,\ \lambda\ {\rm multiplicative}\\
                         \operatorname{ord}(\lambda)>2}}
 \left|\mathbb E_{x\in S_p}\lambda(x-t)\right|=o(L)
 \quad(L\to\infty)
\]
(`04:17-26`, `prop:characters`). The character and center can both vary
with \(p\); the character order is not fixed or bounded in advance.
The common decomposition context is inherited from the preceding section.

**Dependencies and discrepancy.** The proof uses the size and collision
inputs (`04:108-136`), scale selection, anchor-coded transfers, frequency
weights, and cancellation of a one-sided interaction. The selected
character's square is nonprincipal because its order exceeds two
(`04:8-15`; the cancellation argument is `04:676-865`).
Its cell-realization step uses Kneser's sumset theorem (`04:233-263`).
The anchor and final comparison obligations are at `04:866-1115`.

The old report's dependency row at **line 64** says “Collision stability
and the quadratic input”; the initial coverage index mirrored this edge.
The final index distinguishes the corrected dependency. This is an overinclusive
dependency description: the source combines quadratic decorrelation with
this higher-order proposition in the **subsequent corollary**, not in
`prop:characters` itself (`04:15,1163-1169`). The higher-order proof
(`04:28-1115`) does not use the quadratic-decorrelation proposition.
The correction is a scope/dependency clarification, not a counterexample.
No historical file or index was changed.

**Conclusion.** The theorem statement is supported as an attribution;
the old map has the stated dependency overstatement. Uniform higher-order
decorrelation remains an **unaudited arithmetic obligation**.

### C_FLAT — harmonic-probability flatness, not a bound at every prime

**Exact claim.** For every fixed \(0<\alpha<\beta\), outside a prime set
of harmonic mass \(o(L)\) in
\(\alpha L\le\log\log p\le\beta L\), uniformly on the retained primes,
\[
 \sigma_p=\tfrac12+o(1),\qquad
 \max_{\substack{a\in\mathbb F_p\\\lambda\ {\rm multiplicative}}}
 \left|\mathbb E_v g_p(v)\lambda(v)e_p(av)\right|=o(1).
\]
Here \(F_p,g_p\) are exactly the centered/normalized transforms defined
above (`04:1117-1133`, `cor:mixed-flatness`). The maximum includes the
principal character.

**Dependencies and bounded check.** Collision stability gives balance;
the Gauss identity reduces nonprincipal correlations to translated
character biases. The quadratic proposition and its harmonic corollary
handle order two, and `C_CHARACTERS` handles all higher orders.
For the principal character the source instead uses the exact identity
\(\mathbb E_vg_p(v)\lambda(v)e_p(av)=p^{-1/2}F_p(a)\)
(`04:1135-1182`). A sufficiently slowly vanishing threshold produces the
single exceptional set with the stated uniform conclusion.

**Conclusion.** This dependency statement, including the quadratic
input here, is supported. The implication is conditional on the previous
decorrelation assertions; the old local theorem does not prove them.
“Harmonic mass \(o(L)\)” must not be replaced by “finitely many exceptions,”
“all primes,” a natural-density assertion, or a numerical uniform rate.

### C_SUPPLY — a separate coverage-dependent arithmetic input

**Exact claim.** Define
\(\gamma_p=\mathbb E_v|g_p(v)|\).
There is an **absolute** \(\delta_0>0\) such that for every sufficiently
large \(L\),
\[
 \sum_{\substack{.05L\le\log\log p\le.9L\\
                  1/3\le\sigma_p\le2/3,\ \gamma_p\ge\delta_0}}
       \frac1p\ge .15L
\]
(`05:3-28`, `prop:supply`). The eventual threshold may depend on the
fixed decomposition data. This does not assert an \(L^1\) lower bound at
every prime or assume pointwise bounded \(g_p\).

**Dependencies and obligations.** The source expressly says that this
is independent of the decorrelation assertion `eq:src27`
(`05:11-13`). Using \(F_p,g_p\)'s definitions from the flatness corollary
is not using that corollary's conclusion. Its proof requires a centered
tensor budget (`05:39-180`), a sparse-spectrum contracting kernel
(`05:181-353`), truncation (`05:354-436`), and an unweighted total
primitive-character prime-error estimate with the exceptional character
removed (`05:437-694`). This last estimate uses classical zero density,
zero-free regions, and the explicit formula, not the tree theorem.

The final step chooses one representation of each retained sufficiently
large prime by a summand pair and uses a nonnegative weight
(`05:695-749`). That step uses **coverage of the full prime set**, not
only \(A(X)B(X)\gg X/\log X\).
The optional `OpenAIQRH2026` refinement at `05:751-772` is explicitly
not used in the proof. It must not be promoted to an assumption of
`C_SUPPLY`, nor does the old draft certify it.

**Conclusion.** The old summary of this separate input is supported.
The tensor/prime comparison and its exceptional-character deletion are
concrete **unresolved obligations**, not consequences of mixed flatness.

### C_ARITH — comparison in two precisely specified environments

**Parameters and hypotheses.** The constants and a sufficiently large
depth \(k\) are fixed before \(L\to\infty\). Put
\[
 z=k^4,\quad m=2\lfloor zL/2\rfloor,\quad r_j=2^{j-1},\quad
 \Delta_0=(B_s+8\log z)m,
\]
\[
 \Delta_j=r_j(B_D+B_z\log z+.4\log r_j)m,\quad
 E_l=\Delta_0+\sum_{j=1}^l\Delta_j+2^l\sqrt m,\quad V_l=e^{E_l}.
\]
These are `07:22-48`. The functions \(A_l(s)\), the recursive integer
pivot, and their zero conventions are exactly `07:369-507`.
All frequencies are nonzero signed integers with \(|s|\le V_l\).
Current slots and the outside spectator list must be pairwise coprime;
current giants must be units against every frequency at or below their
node. An invalid or nonpositive reconstructed pivot contributes zero.
These are **hypotheses of the comparison**, not its consequences.

The final environment has \(l=k\), actual-prime top priors,
\(\mathcal G=K_{\rm ar}=1\), and arbitrary bulk permutations. The
step-\(j\) diagonal environment has \(l=j-1\), its positive giant under
the bounded-mass external **integer** measure
\[
 d\mu_{\rm ext}(p)=e^{-G}\varphi(\log p-G)
 \quad\text{on positive integers }p,
\]
the remaining actual-prime priors, the exact nonnegative
\(\mathcal G\) of `eq:src54`, and same-band counterpart matchings.
The paired estimate retains the specified \(K_{\rm ar}\) and role
indicators; a single-assignment norm omits that factor
(`07:689-702,704-745`). The expectation in the diagonal environment is
not necessarily a probability expectation.

**Exact claims.** With \(r=2^l\), for one permitted assignment,
\[
 \mathbb E\sum_{0<|s|\le V_l}\mathcal G|A_l(s)|^2
 \le \exp\{r(\Delta_0+Cm)+o_k(m)\}.
\]
Here \(C\) is independent of sufficiently large \(k\) and the fixed gap
budgets. For a permitted pair with \(l\ge2\) and at most \(3r/4\)
components in its bipartite bulk-overlap multigraph,
\[
 \left|\mathbb E\sum_{0<|s|\le V_l}
 \mathcal G K_{\rm ar} A_l^{(1)}(s)\overline{A_l^{(2)}(s)}\right|
 \le \exp\{-\omega_k(m)\},\qquad \omega_k(m)/m\to\infty .
\]
These are `07:747-775`, `prop:comparisons`, `eq:src55` and `eq:src56`.
Uniformity is over the allowed matchings/permutations and histories,
with all other parameters fixed. It is not a joint \(k,L\to\infty\)
claim. Outside spectators are common, not resampled; the coefficients'
internal samples are independent between coefficients, but a node's
sample is shared by its children. Allowed repeated internal prime values
are explicitly included (`07:777-784`).

**Dependencies and unresolved bridge.** Supply and collision establish
the actual construction; flatness supplies the retained spectator set
(`07:3-16,82-175,177-222`). For the comparison in that environment the
source additionally needs:

* exhaustive integer-support descent, including frequency precision and
  the modulo-\(b^2\) exclusions (`08:20-157`);
* prime-progression idealization retaining Page exceptional terms, with
  at most two nongiant prime deletions so surviving corrections use only
  the frequency modulus (`08:158-300`);
* uniform joint giant idealization, equality-pattern treatment of repeated
  internal samples, and representative-prior domination
  (`08:301-451`);
* removal of accidental rank/coefficient coincidences without leaving
  bulk conditions at internal primes, followed by joint bulk idealization
  (`08:452-603`);
* the resulting exact Haar-unit product law on overlap components,
  before applying the **separately assessed** per-prime tree comparison
  at every common spectator (`08:604-650`);
* for the norm, retention of frequency divisibility and the simultaneous
  square-root/lcm frequency-sum bound, with depth-independent leading
  constants (`08:651-756`).

The signed estimate's source mechanism is a product
\(\epsilon_k(L)^m\exp(O_k(m))\), where
\(\epsilon_k(L)\to0\) uniformly over spectators, plus negligible
idealization errors (`08:631-649`). A finite-field tree theorem alone
does not establish any of these arithmetic idealizations or their
uniformity. No audit of that tree proof is made here.

**Conclusion.** The old claim's statement is supported with these
environment qualifications. The arithmetic bridge is **unresolved by
the local draft**. Its old proof locator `08:604-640`
(`old report:68`) covers only part of the signed argument and omits the
norm proof `08:651-756`; it is not a complete locator for both estimates.

### C_TRANSFER — a conditional lower-bound recurrence with a reserve

**Exact scope.** The amplitudes are the construction's \(\eta_j\), not
arbitrary functions. The source first obtains
\(|\eta_0|\ge e^{-B_*m}\), with \(B_*\) independent of later gap
constants and sufficiently large \(k\), from the positive statistic,
repeated-prime removal, and Poisson summation (`07:263-368`).
The exact integer extension gives
\[
 e^{-c_g}|\eta_{j-1}|^2\le\mathcal D_j+\eta_j,\qquad
 \mathcal D_j\ge0,
\]
where \(c_g=\log Z_G^{-1}\le .91L\)
(`07:165-175,563-665`). The \(\eta_j\) on this display is real.

After the stated hierarchy, the source proves
\[
 \mathcal D_j\le e^{-(2B+3)r_jm},\quad
 |\eta_j|\ge\tfrac12 e^{-c_g}|\eta_{j-1}|^2,\quad
 -\log|\eta_j|
 \le2^jB_*m+(2^j-1)(c_g+\log2)<B2^jm .
\]
The middle inequality is justified inductively using
\(|\eta_{j-1}|\ge e^{-Br_jm}\); it is not asserted independently
of a diagonal bound. See `09:68-199`.

**Parameter order and bounded check.** First choose the initial-loss
budget \(B_s\); set \(B=B_*+3\); choose \(B_z\ge9\), then
\(B_D\ge B_s+2B+C+6\); only then choose a sufficiently large fixed
\(k\), and finally large \(L\). The reserve
\((c_g+\log2)/m\le2/k^4<1\) is explicit (`09:125-168`).
Solving the displayed scalar recurrence gives exactly the geometric
sum above, and \(r=2^k\) yields
\(|\eta_k|^2\ge e^{-2Brm}\). This algebraic implication is supported.

**Conclusion.** The old statement is faithful under the hierarchy.
Its antecedents are **unresolved arithmetic obligations**: the initial
positive lower bound and repeated-prime error, exact support-preserving
integer extension and nonnegative diagonal, and uniform diagonal estimates
using both comparisons. The scalar recurrence is not a proof of these.

### C_FINAL — conditional closure needs the regular-factor norm as well

**Exact scope.** At \(r=2^k\), symmetrize all \(rm\) bulk positions
under their identical priors. For \(l\ge2\), “bad” means more than
\(3r/4\) overlap components; the source's bad fraction is at most
\[
 \exp\{(-\tfrac34\log r+C)rm+O_k(1)\}
\]
(`09:10-66`). The common \(G_R(s/d)\) is invariant under these
permutations, whereas bins and history restrictions remain inside each
permuted coefficient (`09:308-329`).

In addition to `eq:src55` and `eq:src56`, Cauchy--Schwarz requires
\[
 \mathbb E_{\mathbf d,\mathcal I_k}
   \sum_{0<|s|\le V_k}|G_R(s/d)|^2\ll V_k
 \tag{regular-factor norm}
\]
(`09:205-306`, `eq:conclusion-regular-norm`). This is **not** the norm
estimate for \(A_l\) in `C_ARITH`. Its source proof uses exact local
\(L^2\) normalization, CRT, and actual-giant prime averaging, retaining
a possible exceptional factor between zero and two. It does not assume
pointwise bounds on all small-prime transforms.

The resulting upper bound is
\[
 |\eta_k|^2\ll e^{E_k}\left[
 \exp\{r[\Delta_0+(-\tfrac34\log r+C)m]+o_k(m)\}
 +e^{-\omega_k(m)}\right]
\]
(`09:331-352`). Combining the frequency budget with this exponent
gives the rate
\[
 -\tfrac7{20}\log r+B_D+2B_s+(B_z+16)\log z+C+o_k(1).
\]
Because \(\log r=k\log2\) and \(\log z=4\log k\), choosing \(k\)
large after the constants makes the rate sufficiently negative;
then sufficiently large \(L\) gives
\[
 |\eta_k|^2\le e^{-(2B+1)rm},
\]
contradicting `C_TRANSFER` (`09:354-386`).

**Conclusion.** The final scalar rate and the order of quantifiers are
supported conditionally on the preceding estimates. The whole contradiction
is **unresolved by the local draft**. The regular-factor norm is a concrete
extra obligation omitted by the old report's abbreviated source ranges
`09:170-199,308-386` (`old report:69`); it must not be silently supplied
by the unrelated local tree or formal-algebra certificates.

## R_COUNTS_ONLY: why the formal growth model retires this shortcut

The old route concerns only the necessary **growth inequalities**, not
residue supports, representations, or real sets. For \(x\to\infty\), put
\[
 a(x)=b(x)=\sqrt{x/\log x}.
\]
Then \(a(x)b(x)=x/\log x\), simultaneously satisfying
\(A(x)B(x)\gg x/\log x\) and \(A(x)B(x)\ll x\).
It also satisfies the source's square-root bounds
(`02:156-162`, `eq:src1`), since
\[
 \frac{a(x)}{\sqrt x/(\log x)^3}=(\log x)^{5/2}\to\infty,
 \qquad
 \frac{a(x)}{\sqrt x(\log x)^2}=(\log x)^{-5/2}\to0 .
\]
Even the fixed-shift consequences listed in `02:168-172` do not
contradict it: for every fixed positive integer \(j\),
\[
 \frac{a(x)}{x/(\log x)^j}
     =\frac{(\log x)^{j-1/2}}{\sqrt x}\to0,\qquad
 \frac{a(x)}{(\log x)^{j-1}}
     =\frac{\sqrt x}{(\log x)^{j-1/2}}\to\infty .
\]
The sharper previously published necessary bounds quoted in
`01:55-61` also leave this scale possible:
\[
 \frac{a(x)}{\sqrt x/(\log x\log\log x)}
      =\sqrt{\log x}\log\log x\to\infty,\qquad
 \frac{a(x)}{\sqrt x\log\log x}\to0.
\]

These are analytic compatibility checks, not a finite search or a
construction of \(A,B\). The literal real-valued functions are not being
declared counting functions of a prime decomposition. In particular,
the check concerns the asymptotic \(\gg x/\log x\) coverage restriction,
not the stronger exact numerical inequality
\(A(x)B(x)\ge\pi(x)-O(1)\). A harmless fixed enlargement of the model's
constant would accommodate the latter asymptotically as well; no sets
are obtained that way.

Thus the conjunction of the displayed coarse necessary conditions has
a formal model and cannot by itself imply a contradiction. This does
**not** show that all conceivable information involving counts is
insufficient, that the formal model satisfies collision/character/supply
conditions, or that an actual decomposition exists. The manuscript itself
warns against exactly this shortcut (`01:39-45`).
The supported result is rejection of this old attack route, not rejection
of the manuscript or proof of its theorem.

## External assumptions and attribution boundary

The old arithmetic claim entries' empty `external_assumptions` arrays do
not remove the manuscript's classical analytic inputs. The old report's
“no external analytic theorem” language is expressly about its **local
tree proof** (`old report:77-82,548-555`), not this surrounding arithmetic
chain. The following source dependencies have not been independently
verified against primary publications in this bounded assessment:

| Arithmetic use | External input identified by the manuscript | Source locator |
|---|---|---|
| Fixed-shift reduction and size bounds | Additive large sieve, cited as Montgomery--Vaughan 1973, Theorem 1; PNT and Mertens; size bounds attributed to Elsholtz 2006, Theorem 1.9, with a supplied proof | `02:23-36,71-88,152-216` |
| Quadratic reduction | Gauss formula; moment estimate related to Bonami, with an elementary derivation supplied; Heath-Brown 1995, Theorem 1, quadratic large sieve | `03:224-228,293-376,766-793` |
| Quadratic split primes | Classical zero-free region, Page theorem and explicit-formula/log-derivative inputs cited to Montgomery--Vaughan and Helfgott | `03:894-1020` |
| Higher-order character transfers | Kneser's sumset theorem, with the cited DeVos formulation; the remaining order-uniform transfer/cancellation is a source argument, not an imported quadratic theorem | `04:233-263,348-1115` |
| Fourier supply prime mean | Montgomery zero-density estimate in the stated Inoue formulation; Landau--Page/zero-free regions; smoothed explicit formula, zero counts, and prime-character error summation | `05:447-585` |
| Arithmetic progression idealizations | Classical zero-free region and Page theorem, explicit formula and zero count; a possible exceptional real character is retained, not assumed absent | `08:158-300` |
| Arithmetic coincidence removal | Polynomial root estimate related to Schwartz--Zippel; the nonuniform maximal-atom extension is proved in the source itself | `08:452-505` |

Citation names and theorem numbers in this table are **attributed source
citations**, not newly authenticated bibliography or invented DOI claims.
The optional quasi-RH citation in `05:751-772` is not load-bearing.
The inverse-sieve conjecture discussed in the introduction is likewise
not adopted as a premise (`01:63-69,138-141`).

## Concrete discrepancies and final disposition

1. **Overinclusive dependency:** old report line 64 assigns the quadratic
   input to the higher-order proposition; the final index records the correction.
   The source needs it when combining orders in mixed flatness, not in
   the higher-order proof itself.
2. **Incomplete proof locator:** old report line 68's `08:604-640`
   does not locate the norm-comparison proof at `08:651-756`.
3. **Additional closure obligation:** the regular-factor norm at
   `09:205-306` is needed for final Cauchy--Schwarz but absent from the
   old report line 69's abbreviated ranges. It is not `eq:src55`.

These are scope/mapping qualifications. No failed source hash or false
arithmetic theorem has been established. The supported portions are source
identity, faithful main statements, short conditional reductions and scalar
closure, and the failure of the specific counts-only attack. The unresolved
portions are the explicitly located arithmetic arguments and their
uniformity/external-input obligations; the local tree proof cannot replace
them.

The manuscript's claims belong to the manuscript; the old draft's
arithmetic map is a reproduction/dependency record, and `R_COUNTS_ONLY`
is a failed proposed shortcut. No novelty, priority, publishability,
whole-manuscript correctness, or native acceptance is asserted.

Only this directory's `report.md` and `verdict.json` were written.
Hash comparisons and JSON validation use
`$WORKSPACE/argus-latest/.venv/bin/python`; no mathematical
finite search, Lean run, Jacobian operation, or new arithmetic proof was
undertaken.
