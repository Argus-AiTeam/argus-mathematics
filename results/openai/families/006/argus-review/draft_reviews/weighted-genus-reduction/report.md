# Engineer assessment: weighted genus reduction

## Finding and authority

The old draft contains an honest **general conditional proof**, not merely an extrapolation from its finite fixtures. Subject to the oriented CM reduction input and the stated parametrization covariance, its Picard-orbit, orientation-sign, and integral stabilizer-mass argument gives the claimed factor \(c_0 2^{\omega(N)}\). I find no missing implication in that conditional argument under the precise hypotheses below. This is not a proof of the surrounding odd-coefficient proposition or of either manuscript's main theorem.

The archived checker was replayed once, successfully, and its reconstructed object equals the entire old `exact_certificate.json`. There is nevertheless a concrete **finite-fixture fidelity gap**: at \(2^5\), its alleged \(-319\) integral generator does not satisfy its minimal polynomial. The generic two-eigensummand computation still passes; it must not be advertised as that specific quadratic-order computation. This does not invalidate the draft's separate general dyadic proof.

Author role: **Engineer evidence analyst**. This is my independent Engineer reading of the old argument and archived source excerpts, not a native independent Reviewer decision. Native independent acceptance remains **pending**. No old ledger, draft, reference manuscript, or current coverage index was modified.

## 1. Exact statement and hypotheses

The assessed claim is `V_WEIGHTED_GENUS_IDENTITY`, statement hash

`c24cad0812644458b590104c4307caa4070a869ab675233f672f28d141810b9c`.

For source-admissible data, write
\[
 h=\sigma D,\qquad d=|h_*|,\qquad k=hh_*=-dD<-4,\qquad
 K=\mathbf Q(\sqrt{k}).
\]
The assertion is
\[
 a_M(D)=c_0\,2^{\omega(N)}\zeta_M(D)\,
 \lambda_M\!\left(\operatorname{red}_{\ell}(L P_D)\right)
 \pmod {2^M}.                                                   \tag{1}
\]
Here \(P_D=P_1(h_*)\) is the **unnormalized conductor-one Heegner character sum**, not a class-group average; \(a_M(D)\) is the admitted, projected coefficient \(H_M(dD)\). Every orientation fiber is a \(\operatorname{Pic}(\mathcal O_K)\)-torsor, there are exactly \(2^{\omega(N)+1}\) such fibers, all give the same weighted contribution, and the embedding stabilizer is \(\mathcal O_K^\times=\{1,-1\}\). The integers \(c_0,L\) do not depend on \(D,\ell,M\). The phase is a two-power root of unity and may depend on the admitted index, prime, precision, and orientation/basis choices. No extra nonunit index-, prime-, or precision-dependent multiplier is allowed.

The quantification is for each fixed source curve, level \(N\), parametrization, and filter/companion data, and then all admitted \(D,\ell,M\). Uniformity in \(D,\ell,M\) is not an assertion that the same parametrization multiplier works for every elliptic curve.

The operative hypotheses, not just the abbreviated word “inert,” are:

1. \(h,h_*\) are coprime odd fundamental discriminants of opposite infinite sign; \(k<-4\). Thus \(k\) is the field discriminant and the maximal quadratic order has only the two stated units.
2. All primes dividing \(2N\) split in \(K\). In the source this is imposed by equal unit squareclasses of \(h,h_*\) there. In particular these primes divide neither discriminant.
3. The odd good prime \(\ell\) is prime to \(2Nhh_*\), is inert in \(K\), and satisfies
   \[
   \ell\equiv3\pmod4,\qquad \chi_{h_*}(\ell)=-\sigma.
   \]
   The detecting filter also specifies \(\chi_h(\ell)=\sigma\). Inertness alone only specifies their product and does **not** imply the individual sign needed below.
4. \(B\) is ramified exactly at \(\ell,\infty\), \(R\) is an Eichler order of level \(N\), and the Schwartz weights are precisely the declared source weights, including the full-order condition at two, the nilpotent sign at \(q\mid h_*\), and the trace-zero-residue-line sign at \(\ell\).
5. The integral multiplier \(L\) is incorporated in
   \[
   P(z)=\lambda_M(\operatorname{red}_\ell(L\varphi(s_z))).
   \]
   This is a linear functional of the reduced parametrization. Its right-normalizer laws are
   \[
   P(zt_p)=w_{p^e}P(z)\quad(p^e\Vert N),\qquad
   P(z\pi_\ell)=\sigma P(z),
   \]
   in the coefficient module being used. The first is after killing the fixed cuspidal constants. The second uses the detecting-prime Tate congruence and Kummer/Frobenius equivariance.
6. Oriented, ideal-action-equivariant conductor-one CM reduction identifies the selected initial Picard orbit with the reductions of the Heegner orbit, with multiplicity one, preserving the selected level orientations.

Items 5 and 6 are inputs to this comparison, not disguised assumptions of (1). Source-admissibility additionally includes the upstream curve/filter/companion choices. This review does not prove their existence or analytic properties. The conditional module argument does not require analytic rank or a nonvanishing theorem.

## 2. Inputs, versions, and attribution

Let `OLD` denote

`families/006/first-pass/weighted-genus-reduction`.

I read in full the old `report.md`, `statement-fidelity.md`, `verify.py`, `exact_certificate.json`, all three excerpt files (`cornut-jetchev-excerpt.txt`, `reviewer-cm-excerpt.txt`, `reviewer-parametrization-excerpt.txt`), `jacobian_contract.json`, `jacobian_payload.json`, `jacobian_result.json`, and `verification-output.json`. I also read the full historical literature record

`families/006/first-pass/literature/8b41f4a57b320a13d14d987f649e84dc.json`.

The current contract and index were read. As instructed, I relied on the parent's completed snapshot/manifest/evidence-binding checks and did not reread any old ledger or redo those inventory checks.

Versions v1–v5 have the same mathematical statement hash above. The supplied version history matters: v2 exposes `A_ORIENTED_CM_REDUCTION`; v3 exposes `A_SOURCE_PARAMETRIZATION`; v4 retires the incorrect `01-preliminaries.tex` genus locator; v5 introduces the corrected `A_PARAMETRIZATION_DATA`, referring to `01-arithmetic-transfer.tex`. These are assumption/provenance changes, not five distinct proofs. The original genus locator is not reusable; the corrected locator is.

The historical independent citation record
`citation-A_ORIENTED_CM_REDUCTION-489687b00424` binds assumption hash

`aded6821c48038b948fe43ed5cf04f4e3e8fcf52c549fc727f63754e4b80a4d3`,

retained through v2–v5, according to the parent's verified binding. It supports the **cited CM input only**. The historical general-identity judgment is Engineer opinion, not independent proof approval.

### Reference-source version actually read

`OLD/../openai_manuscript` is a directory, not an archived manuscript file. Its density-manuscript child is a symbolic link to the active reference tree. I read only the needed definition/covariance/weight/comparison passages: `01-arithmetic-transfer.tex` lines 90–165 and `05-coefficients.tex` lines 240–665, especially the weights and `cs:weighted-trace-identity`.

The reference manifest in campaign `9100006` names revision
`4eaee87548250b2682affda7d05d947c05554bae`. The two files actually read match that manifest's digests:

| File in `build/sections` | SHA-256 |
|---|---|
| `01-arithmetic-transfer.tex` | `55d0c4870170b66bd0626778a877e6785c3dfab1eed1ecc81506812757570d6e` |
| `05-coefficients.tex` | `c2d2e0ef37252b0064b864d61aeaf9391a817e6f3c15f1a4e1d109f209329713` |

Thus no revision difference was found for these two relevant staged files. This is not a claim about the revision of the entire active tree, nor an identification of all historical source versions with that commit. The old excerpts are dated 2026-11-05 and do not themselves pin a repository revision. Their relevant mathematical content agrees with these read passages. No Git operation or `.git` access was used.

## 3. Decisive general argument

### 3.1 Norm-character/Schwartz descent and the genus character

At \(q\mid h_*\), determinant valuation one prevents the integral trace-zero matrix from reducing to zero. Its reduction is nonzero nilpotent. For
\(X_0=\left(\begin{smallmatrix}0&1\\0&0\end{smallmatrix}\right)\), the centralizer in \(\mathrm{GL}_2(\mathbf F_q)\) consists of
\(\left(\begin{smallmatrix}a&b\\0&a\end{smallmatrix}\right)\), with determinant \(a^2\). Consequently the sign
\[
 \epsilon(gX_0g^{-1})=(\det g/q)
\]
is well defined. Conjugation by a unit multiplies it by its determinant character, and \(\operatorname{diag}(u,1)\) proves the stated unit-scaling rule.

At a level prime, order units preserve the selected cyclic level summand. At two this is a summand for the **integral** operator \((1+x)/2\), not for \(x\bmod2\). Division-order units at \(\ell\) act trivially by conjugation on the residue field. At the other places the weight is invariant. Thus
\[
 f(u^{-1}yu)=\chi_{h_*}(\operatorname{Nrd}u)^{-1}f(y)
 \quad(u\in\widehat R^\times).
\]
This cancels the change of \(\chi_{h_*}(\operatorname{Nrd}z)\) under \(z\mapsto zu\). Under \(z\mapsto bz\), \(b\in B^\times\), reindex \(x\mapsto bxb^{-1}\); the finite quadratic idele character is trivial on the positive rational number \(\operatorname{Nrd}b\). The whole summand descends. Dropping the noninvariant nilpotent sign would break this argument.

The character \(a\mapsto\chi_{h_*}(N_{K/\mathbf Q}a)\) is trivial on \(K^\times\) since imaginary-quadratic principal norms are positive. It is trivial on \(\widehat{\mathcal O}_K^\times\): away from \(h_*\) the local character is unramified, while at \(q\mid h_*\) the norm of a ramified quadratic local unit has square residue. It therefore descends to \(\operatorname{Pic}(\mathcal O_K)\).

Its identification with the source genus character is substantive, not a count. The extension \(K(\sqrt{h_*})/K\) is unramified: at a prime dividing one discriminant use the square root of the other, unit discriminant; at two the odd-discriminant local extensions are unramified or split. At primes away from the discriminants its Artin value is \((h_*/N\mathfrak p)\). Standard quadratic reciprocity/class-field norm functoriality therefore identifies it with \(\chi_{h_*}|_{G_K}\). Reciprocal Artin conventions do not alter a quadratic character.

### 3.2 Exactly two split-level types, including prime powers at two

For \(p^e\Vert N\), split maximality gives
\(\mathcal O_{K,p}=\mathbf Z_p\oplus\mathbf Z_p\). Its two idempotents decompose every stable lattice and stable sublattice. A quotient of order \(p^e\) has form
\(\mathbf Z/p^a\oplus\mathbf Z/p^b\); cyclicity forces
\(\{a,b\}=\{e,0\}\). Multiplication by \(K_p^\times\) is transitive within each of the two types. The number is two, not \(e+1\), for every exponent \(e\ge1\).

At two use an actual odd root \(r\in\mathbf Z_2^\times\) of \(k\). The eigenvalues \((1+r)/2,(1-r)/2\) of the integral generator differ by the unit \(r\). For odd \(u\),
\[
 (1+ux)/2=u(1+x)/2+(1-u)/2.
\]
The summands persist, even if eigenvalue parities interchange, and the selected root of \(x\) scales by \(u\). This establishes the dyadic assertion for all exponents; it is not dependent on the imperfect fixture discussed below.

At \(\ell\), \(K_\ell\) is the unramified quadratic subfield of the division algebra. Its valuation subgroup is \(2\mathbf Z\) inside the division-algebra valuation group \(\mathbf Z\), so
\[
 K_\ell^\times\backslash B_\ell^\times/R_\ell^\times
 \simeq\mathbf Z/2\mathbf Z.
\]
These are the two residue embeddings. A uniformizer interchanges them; an order unit cannot. Elsewhere, including the ramified primes of \(h\) and \(h_*\), maximal-order stable lattices are fractional ideals of a DVR or a product of DVRs, giving one local orbit. At two there is no additional factor unless two divides the level. The total is exactly \(2^{\omega(N)+1}\).

### 3.3 Global Picard torsors, not cardinality matching

Fix \(i:K\hookrightarrow B\), \(x_0=i(\sqrt{k})\), and an orientation tuple \(\varepsilon\). The local classification gives
\[
 Z_\varepsilon=\widehat K^\times z_\varepsilon\widehat R^\times.
\]
Starting from the CM representative, independent right level normalizers and the right uniformizer at \(\ell\) produce a representative for every tuple. Since the coefficient ranges over all order classes \([z]\), no assertion about embeddings into one preselected global order, and no selectivity shortcut, is required.

Maximality of the embedded quadratic order gives
\[
 \widehat K^\times\cap z_\varepsilon\widehat R^\times z_\varepsilon^{-1}
 =\widehat{\mathcal O}_K^\times,
 \qquad
 K^\times\backslash Z_\varepsilon/\widehat R^\times
 =\operatorname{Pic}(\mathcal O_K).
\]
All rational embeddings are conjugate: \(x+y\) intertwines \(x,y\) unless \(y=-x\); in that case use a nonzero anticommuting quaternion. The definite quaternion algebra is a division algebra, so these nonzero intertwiners are invertible. This accounts for all counted embedding pairs.

For \(z_a=a z_\varepsilon\), commutation with \(x_0\) gives the **termwise** identities
\[
 f(z_a^{-1}x_0z_a)=f(z_\varepsilon^{-1}x_0z_\varepsilon),\quad
 \chi_{h_*}(\operatorname{Nrd}z_a)
 =\chi_{h_*}(\operatorname{Nrd}z_\varepsilon)\chi_{h_*}(Na).
\]
This is the actual genus-weight transport. The CM theorem identifies the selected initial torsor with the Heegner orbit equivariantly and without multiplicity. Applying the linear reduction functional to its unnormalized sum then gives the right-hand sum in (1). An unweighted embedding count alone would not give these identities.

### 3.4 Exact stabilizers and integral clearing

For an optimal embedding in \(R_z\),
\[
 R_z^\times\cap i(K)^\times=i(\mathcal O_K^\times)=\{1,-1\}.
\]
Thus its orbit contains \(|R_z^\times|/2\) generators. These are oriented embeddings, not conjugate pairs. In particular \(x,-x\) have different residue orientations at \(\ell\) and are not conjugate by an order unit. The source denominator is the order of the **full** unit group, not its projectivization.

Choose the integer \(c\) divisible by all these full unit-group orders. Regrouping an orbit gives
\[
 \frac{c}{|R_z^\times|}\frac{|R_z^\times|}{2}=\frac c2
\]
as an equality of integers. Both the original coefficient \(c/|R_z^\times|\) and the regrouped coefficient \(c/2\) are integral. No inverse of two is used in the coefficient module. Changing a lift of \(P(z)\) modulo \(2^M\) consequently changes the original sum by a multiple of \(2^M\).

### 3.5 Matching orientation signs, with no class translation

Choose the right normalizer \(t_p\) at \(p^e\Vert N\), supported at that place, interchanging the summands; its norm has valuation \(e\). Set \(s_p=w_{p^e}\chi_{h_*}(p)^e\). The three changes are:

| Right translation | Schwartz factor | \(P\) | Norm character | Product |
|---|---:|---:|---:|---:|
| \(t_p\) | \(s_p\) | \(w_{p^e}\) | \(\chi_{h_*}(p)^e\) | \(1\) |
| \(\pi_\ell\) | \(-1\) | \(\sigma\) | \(-\sigma\) | \(1\) |

The first entry is precisely \(\eta_p(-1)=s_p\), including the dyadic integral-summand convention. The second row uses \((-1/\ell)=-1\) and the individual condition \(\chi_{h_*}(\ell)=-\sigma\). Without those conditions the product need not be one.

The representatives can be chosen as \(z_\varepsilon=z_0\prod t_p\,\pi_\ell^{\,b}\). Right translation commutes with the left action of each ideal idele \(a\). Hence these comparisons align each **same ideal class** across tuples; they introduce no unexplained class translation or genus-character factor.

Putting
\(\zeta=\chi_{h_*}(\operatorname{Nrd}z_0)f(z_0^{-1}x_0z_0)\),
all its factors are two-power roots of unity and
\[
 A(D)=\frac c2\,2^{\omega(N)+1}\zeta
       \sum_{[a]\in\operatorname{Pic}(\mathcal O_K)}
                 \chi_{h_*}(Na)P(a z_0)
     =c\,2^{\omega(N)}\zeta
       \lambda_M(\operatorname{red}_\ell(LP_D)).
\]
Filter projections leave an admitted index unchanged, so this is (1). In particular there is no class-number denominator and no extra inert-prime multiplier.

This reasoning is valid in any coefficient module in which the stated covariance holds. In the source those laws hold modulo \(2^M\). Arbitrary integer lifts of \(P_M\) are **not** asserted to satisfy characteristic-zero covariance. The integral calculation legitimizes reduction; it does not manufacture such a lift.

### 3.6 Uniformity of \(c_0\) and \(L\)

The old universal unit bound is valid. A definite quaternion order is a rank-four integral lattice; its unit group has norm one and is finite. Reduction into \((R/3R)^\times\) is injective: a nontrivial torsion element in \(1+3R\) has a nontrivial prime-order power \(1+3^a v\), \(v\notin3R\). For prime order \(q\ne3\), the linear term in the binomial expansion has strictly smallest 3-adic valuation. For \(q=3\), division by \(3^{a+1}\) leaves
\(v+3^a v^2+3^{2a-1}v^3\not\equiv0\bmod3R\).
Both contradict finite order. Therefore \(|R^\times|\le |R/3R|=81\), and
\[
 c=\operatorname{lcm}(1,\ldots,81)
 =97301577764381948734868316916891200
\]
works uniformly even as the definite algebra and level vary. A sharper customary bound is unnecessary.

For the identity, \(L\) only needs to kill the fixed parametrization's cuspidal constants in the finitely many level Atkin–Lehner relations. Killing each constant **before** summation prevents the class number from enlarging \(L\). The source also kills bounded-degree torsion for a later analytic application; that is not needed for this comparison.

The asserted Frobenius law has the stated degree convention: the finite-field Kummer cocycle is evaluated at \(\operatorname{Fr}_\ell^2\), and this evaluation is equivariant for \(\operatorname{Fr}_\ell\). Since \(\operatorname{Fr}_\ell=C\) on \(E[2^M]\) and \(bC=\sigma b\), \(\lambda_M(\operatorname{Fr}_\ell Q)=\sigma\lambda_M(Q)\). There is no new Kummer-degree multiplier. This checks the implication from the declared detecting congruence, not the existence of detecting primes.

## 4. Citation reading: what is reusable

The archived actual excerpts, including the complete text stored in the historical literature record, are sufficient for this application; I did not send private source material to a third party or fetch a substitute web summary.

Cornut–Jetchev, *Liftings of Reduction Maps for Quaternion Algebras*, **arXiv:1012.0725v1**, is used at Theorem 3.1, Corollary 3.2, Section 3.6 Remark 1, and Sections 4.6–4.10. The hypothesis match is:

| Cited hypothesis/data | This application |
|---|---|
| Totally real \(F\), imaginary quadratic \(K/F\) embedded in source algebra | \(F=\mathbf Q\), \(K\) imaginary quadratic, source algebra \(M_2(\mathbf Q)\) |
| H.1: source algebra unramified at \(S\) | \(S=\{\ell\}\), source algebra split |
| H.2: \(|S|+|\operatorname{Ram}_f(B_{\rm source})|+[F:\mathbf Q]\) even | \(1+0+1=2\) |
| H.3: primes in \(S\) inert or ramified in \(K\) | \(\ell\) inert |
| Eichler level, prime to \(\ell\) here | Arbitrary \(N\) with \(\ell\nmid N\); no squarefree-level restriction used |
| Fine-conductor parity at inert primes | \(0-0=0=v_\ell(N)\pmod2\) |
| Coarse-conductor replacement in Remark 1 | \(c'=c''=c=1\), prime to \(N\) |

The theorem's target is the **specified sign-invariant fiber**, not both residue orientations. Its multiplicity is
\[
 \kappa=|\operatorname{Gal}(K[c]/K[c_S])|
         \prod_{v\in S}N_v(v(c'),v(c''),v(N)).
\]
Here the field factor is one because the conductor does not drop; Lemma 2.1's unramified case gives \(N_\ell(0,0,0)=1\). Hence \(\kappa=1\), not a hidden class-number factor. Corollary 3.2 restricts this correspondence over each supersingular point. Remark 1 retains a fixed residue-field isomorphism; only after forgetting it does one identify conjugate embeddings. Sections 3.2 and 4.6 supply ideal-action equivariance; Section 4.10 identifies the adelic map with geometric supersingular reduction. Away from \(S\) the local identification preserves the chosen level type.

Consequently the **old attribution is reusable unchanged for `A_ORIENTED_CM_REDUCTION`**, with its existing orientation restriction and conductor-one scope. It must not be upgraded into attribution or approval of the whole weighted identity. The other inert orientation in the theta sum comes from the independently proved right-uniformizer transport, not from doubling the image of the geometric reduction map.

Geometry remaining external to the old proof/checker is precisely the geometric realization and equivariance of this reduction-to-optimal-embedding correspondence, with its fixed residue identification; the supersingular/Eichler interpretation and compatibility of right normalizers with Atkin–Lehner/Frobenius action; and the source parametrization/Heegner-sum data summarized in `A_PARAMETRIZATION_DATA`. The cited reduction theorem does not prove the parametrization covariance or the existence of a detecting sequence. The old Jetchev–Kane reference is supporting provenance, not a newly independently checked weighted-normalization theorem in this assessment.

## 5. Actual replay and its limits

Output: `research/draft_reviews/weighted-genus-reduction/replay.json`.

The executable invocation was

```text
PYTHONDONTWRITEBYTECODE=1 $WORKSPACE/argus-latest/.venv/bin/python -
```

with an inline stdin program. Its exact computational entry points were:

```python
spec = importlib.util.spec_from_file_location(
    "weighted_genus_old_verifier", old / "verify.py")
module = importlib.util.module_from_spec(spec)
spec.loader.exec_module(module)
actual = module.reconstruct()  # called exactly once
expected = json.loads((old / "exact_certificate.json").read_text())
module.require(actual == expected,
               "Replayed certificate differs from archived exact_certificate.json")
```

`old` was the absolute `OLD` path above. The remaining stdin code recorded the summary/counts and the same-fixture polynomial diagnostic below into the current owned output directory. It did not copy or edit the old source, invoke `main`, or request `--write-certificate`. `reconstruct()` has no output-path parameter. Its `jacobian_check()` reads the archived contract/payload/result; it does not call an adapter.

Exit status **0**, Python **3.13.5**, bytecode disabled, reconstruction/comparison elapsed **0.031351275742053986 seconds**. The bounded loop sizes were read before execution; this was not a potentially two-minute run, and no background shell or subagent submission was used. Exact reconstruction agrees with the old certificate and its old verification summary.

| Component | Exact replay result |
|---|---|
| Nilpotent fields \(q=3,5,11\) | \(|\mathrm{GL}_2|=48,480,13200\); orbit sizes \(8,24,120\); centralizer sizes \(6,20,110\) |
| Split-level cases | Ten: \(2^1,\ldots,2^5;\ 3^1,\ldots,3^3;\ 5,5^2\) |
| Projective lines | \(3,6,12,24,48;\ 4,12,36;\ 6,30\), total **181**; two stable lines in each coded case |
| Dyadic \(x\)-only negative control | **9** extra stable lines in total |
| Quaternion fixture | \(B=(-1,-7)\), \(h=29,h_*=-11,k=-319,\ell=7,N=1\); trace-pairing determinant \(-49\); **4** units |
| Embeddings | **40** generators, **20** unit-conjugacy orbits, all stabilizer sizes **2**; **10** orbits in each inert residue orientation |
| Weighted census | At each residue coefficient \(2,5\), five orbits of weight \(+1\) and five of weight \(-1\) |
| Reduced forms | **10**, genus signs \(+,-,-,+,+,+,+,-,-,-\), five of each |
| Symbolic transport | **8** level sign/parity cases plus **2** inert cases; **16** orientations for three prescribed level switches; ten free-module coordinates \(\pm778412622115055589878946535335129600\) |
| Precision checks | \(M=1,6,12,17\); nonzero comparison and all mutant distinctions visible at \(M=12\) |
| Rejected mutants | Missing inert orientation; wrong inert weight; stabilizer mass one |

The low-precision tests at \(M=1,6\) are zero because of the fixed multiplier and are not independently detecting tests. The \(M=12\) controls avoid that vacuity. The local \(3\)-power tests use a generic split diagonal operator, not the local field of the \(-319\) global fixture (which is inert at three); these are separate components, not one globally realized level.

The quaternion and reduced-form censuses do **not** compute an explicit ideal-class action or a bijection matching each embedding to its binary form. Their equal sign counts alone do not prove genus transport. The free-module test prescribes the covariance signs; its nonzero vector is not a calculated elliptic-curve genus point. \(N=1\) is explicitly not a full elliptic-curve instance of the source theorem. No modular parametrization, Heegner point, reduction map, or \(L\)-value was computed.

### Concrete finite-fixture fidelity gap

In `verify.py:level_checks`, the dyadic root is selected using
\[
 r^2+319\equiv0\pmod{2m},\qquad m=2^e.
\]
At \(e=5\), this selects \(r=1\), and the alleged integral-generator eigenvalues are \(1,0\). But the generator \((1+\sqrt{-319})/2\) has minimal polynomial
\[
 F(T)=T^2-T+80.
\]
Both \(F(1)\) and \(F(0)\) are \(16\bmod32\), not zero. Thus this coded operator is not that generator modulo \(32\). The supplemental arithmetic in `replay.json` checks the same five selected roots: residuals are zero for \(e=1,2,3,4\), and \((16,16)\) for \(e=5\).

To represent the claimed generator modulo \(m\), the exact missing condition is \(r^2+319\equiv0\pmod{4m}\), not merely modulo \(2m\). For example \(r=31\) satisfies the stronger condition at \(m=32\). No old fixture was changed and no repaired checker was substituted for the replay. This narrows the old claim about “the full integral quadratic order” in the finite evidence; it does not affect the all-exponent proof using an actual 2-adic root and a unit eigenvalue difference.

### Historical Jacobian evidence and recommended replay

The old typed operation is `number_theory.compute.legendre_symbol`, payload
`{"a": -1, "prime": 7}`, complete expected output
`{"a": -1, "prime": 7, "symbol": -1}`.
The archived server version is **0.14.0**, protocol **2025-11-25**; adapter exit code **0**, error `null`, timeout `false`. Its role is only the inert-negation sign in one fixture. The checker independently recomputes this elementary symbol but reuses the archived adapter output. I made **no new adapter call**.

This exact existing payload is the recommended bounded independent Jacobian replay for the parent. A fresh result would corroborate only \((-1/7)=-1\), not CM reduction, the Picard action, or the universal sign table. Any current server/protocol difference must be recorded rather than silently treated as the historical operation.

### Parent's fresh isolated-adapter replay

The parent subsequently discovered the operation with query `legendre_symbol`,
inspected its exact typed contract, and executed **one** operation through
`$WORKSPACE/argus-live-update/.venv/bin/python -m argus_skill.tools.jacobian`.
The dedicated `jacobian-discovery.json`, `jacobian-contract.json`,
`jacobian-payload.json`, and `jacobian-output.json` in this review directory
preserve the requests and complete typed response.

Operation: `number_theory.compute.legendre_symbol`.
Exact payload: `{"a": -1, "prime": 7}`.
Exact typed output: `{"a": -1, "prime": 7, "symbol": -1}`.
Server **0.14.0**, protocol **2025-11-25**, transport `mcp-stdio`,
server runtime **1 ms**, adapter process exit **0**, structured error **null**,
timeout **false**, complete output. The inspected input bounds are
\(|a|\le9007199254740991\) and odd prime \(3\le p\le10000000\).
This agrees with the historical fixture. It corroborates only its elementary
local negation sign, not the conditional geometric proof.

## 6. Classification and unresolved obligations

* **Conditional proof:** the general weighted correspondence and exact mass calculation are supported by this Engineer reading, under the explicit arithmetic inputs. This is a conditional reconstruction of the existing manuscript identity, not a novelty claim.
* **Finite verification:** the archived finite computations reproduce exactly, with the dyadic fixture-fidelity qualification above. They are component tests, not a certificate of the general geometry or of (1).
* **Failed unweighted attack:** omitting genus signs or forgetting the inert residue orientation cannot establish this weighted comparison. Refuting that shortcut is neither a counterexample to the source nor a proof that the whole source is correct.
* **Proposed strengthening:** the arbitrary-module/integral formulation is valid when the same covariance is assumed in that module. It is not a new unconditional arithmetic theorem, and the script's `result_kind` label cannot confer that status.
* **Formal proof:** none is supplied for this unit. The unrelated trace-character Lean result is neither rerun nor counted as support for these geometric inputs.

Concrete remaining obligations are:

1. Preserve the exact CM hypothesis match, fixed residue orientation, and multiplicity-one specialization when reusing the historical attribution. These are external theorems, not conclusions of the checker.
2. Keep the source Heegner-sum definition, linear reduction functional, and exact right-normalizer covariance as explicit arithmetic inputs. If only inertness were supplied, the additional condition \(\chi_{h_*}(\ell)=-\sigma\), along with \(\ell\equiv3\bmod4\), would be a missing sign hypothesis.
3. If finite evidence is advertised as the \(-319\) full-order computation at \(2^5\), repair the root-depth condition in a separately authorized writable copy and replay it; otherwise relabel that particular check as generic split-eigensummand evidence. This review deliberately leaves the old artifact untouched.
4. Modularity/scalar character, the Hecke recurrence, detecting-prime existence and witness detection, the genus-index bound, analytic-rank detection, and the downstream converse/density/mean-rank claims remain **outside this result**, not unfinished steps secretly discharged by (1). They need their own arguments; no new manuscript-error search or attempted solution was undertaken here.

This assessment completes only this old draft unit. It does not declare family completion or self-accept any claim; the native Host-invoked independent Reviewer retains that decision.
