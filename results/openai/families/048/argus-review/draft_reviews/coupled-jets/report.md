# Coupled jets: Engineer assessment of the preserved draft

## Assessment and authority

**Supported in its conditional finite-jet and stable formal scope. No concrete
gap was found in the coupled induction. Current native independent review
remains pending.** This is an Engineer assessment, not acceptance by the
Host-invoked independent Reviewer.

The conclusion is an implication for **every supplied admissible curve/residue
data set**. It does not construct those data, realize a Hausdorff surface,
produce actual global holomorphic fields, prove convergence of infinitely many
flows, or establish an affine counterexample. These boundaries are essential,
not missing steps in the conditional theorem.

### Sources, attribution, and identity scope

All paths beginning `research/jet_audit/`, `research/literature/`, or
`research/openai_manuscript/` below refer to the read-only old root
`campaigns/9000048`.

* Original mathematical source: **OpenAI**, *A singular normal affine surface
  with free tangent sheaf*, September 23, 2026; `build/paper.tex` supplies that
  author/date. The assessed section is `build/04-jets.tex`, in the directory
  `research/openai_manuscript/A-singular-normal-affine-surface-with-free-tangent-sheaf-September-23-2026`.
  The current coverage index records reference commit
  `4eaee87548250b2682affda7d05d947c05554bae`; no Git operation was performed.
* Old assessment: `research/jet_audit/report.md`, its exact certificate and
  `verify.py`; ledger judgements attribute the work to
  `engineer:gpt-6-astra`, with subsequent `reviewer:gpt-6-astra` judgements.
  The manuscript lemmas/proposition are reproduced and explicated, not newly
  attributed to this Engineer. The stable formal limit strengthens the
  explicitly stated finite proposition. No novelty assessment is made.
* The supplied identity audit and `DRAFT_REVIEW_INDEX.json` establish that
  **14 core artifacts** match the November 6 snapshot. The three jet-core
  identities listed in that snapshot are:

  | Old artifact | SHA-256 recorded in the preserved manifest |
  |---|---|
  | `research/jet_audit/report.md` | `454b702a0a16182c765e518f8d0b4e999eb2863822c79cd47a144bad35a534d9` |
  | `research/jet_audit/verify.py` | `66ae42b983791225abf504ba7248354d981a81c7f4a4602927129587b8af2466` |
  | `research/jet_audit/exact_certificate.json` | `fd0eca20105dcff175e38924e34a66d1e649d76de632eda8fb8c1188e1c8e0fd` |

  The two old ledgers also belong to the 14. The other **97 manifest inputs
  have expected-size provenance only**, not snapshot-hash verification.
  In particular, that weaker identity scope applies to the historical run
  outputs, typed Jacobian files, literature excerpts, and page image. The
  manuscript is a separately indexed reference input, not an additional
  snapshot-hash-verified core artifact.
* No old computation was rerun: there is no changed mathematical dependency or
  conflicting result warranting a replay. The existing proof, source passages,
  checker code, certificate, controls, and receipt were read. No old checker or
  Jacobian module was imported or executed, and no Lean/kernel closure is claimed.

## 1. Exact ledger context, claims, and historical versions

### Context and supplied hypotheses

The following is the statement of old `CTX_JET_048`, version 1, hash
`00ea69199b6d9644cb5fb7987d4d66730c986ec0afb54cdd7ed14c3c09ee5c17`:

> A smooth connected projective complex curve C of genus 21 has a line bundle
> L of degree 10, a fixed isomorphism L^4=K_C, a reduced six-point divisor Z,
> and basis r=xi*u of H0(C,L) with simple common divisor Z. Assume every
> hypothesis of prop:curve-data and prop:residue-data in the staged
> September-23-2026 manuscript, including evaluation surjectivity for all
> powers L^k with k>=3. In compatible coordinates at q_j, m_j=c_j/z_j with
> c_j nonzero, R_j=m_j*r and p_j=P-m_j*r' are holomorphic, P is a global
> meromorphic L^2 row with only the stated simple poles, p_j(0) wedge
> R_j(0)=1, and sum_j(R_j(0) wedge R_j'(0)-1)=-90. The rows r'(q_j) span C^2.

Its definitions specify `sigma = t^-5 dt wedge dz`, row index \(k\) as
\(t^{k+1}(A_kE_t+B_k\partial_z)\), and target transport by
`exp(D-div_sigma D)`, **not scalar pullback alone**. The context explicitly
separates input existence and downstream analytic/algebraic claims.

`A_stein` and `A_flows` instead refer to `CTX9000048` v1, hash
`18c7f71895d91c5e552040292654a003dbf59391512d1c0cbacf5dec87fb08ed`.
Its statement is the old campaign title, “OpenAI Math Audit #048: Disproof of
the Lipman-Zariski Conjecture (Singular Normal Affine Surface with Free Tangent
Sheaf)”; that is historical metadata, not this review's objective or a theorem
proved by these jets.

The old report §1 makes explicit the smaller subset actually used:

1. \(C\) is smooth, connected, projective over \(\mathbb C\);
   \(\deg L=10\), \(L^4\simeq K_C\);
   \(r=(r_1,r_2)\) is a basis of \(H^0(L)\) with reduced simple common
   divisor \(Z\) of degree six. Thus \(g(C)=21\).
2. \(h^0(L)=h^0(L(Z))=2\) and
   \(h^0(\mathcal O_C)=h^0(\mathcal O_C(Z))=1\).
   The rows \(r'(q_j)\) span \(\mathbb C^2\).
   A pencil member \(r_1\) has four further reduced zeros disjoint from \(Z\).
3. In compatible fourth-root coordinates \(m_j=c_j/z\), \(c_j\ne0\),
   \(R_j=m_jr\) and \(p_j=P-m_jr'\) are holomorphic, for **one global**
   \(P\in H^0(C,L^2(Z))^2\), with no other poles.
4. \(p_j(0)\wedge R_j(0)=1\) and
   \(\sum_j(W_j-1)=-90=-9\deg L\),
   \(W_j=R_j(0)\wedge R_j'(0)\).

The exact upstream ledger output `M_curve_data` (unchanged statement through
v1–v5, hash `50d8466c2c16de16ec213050678e6b2b0b3dd9e08a64d408d29f939ff275c673`)
includes \(L=H+Z\), \(\deg H=4\), \(h^0(H+2Z)=2\),
\(h^0(\mathcal O_C(Z))=1\), and evaluation of \(L^{k+1}\) at \(Z\) for
every \(k\ge2\). These give the counts and interpolation above.
`M_residue_data` v1, hash
`d3449f68e0502815f6252438c54e792943237f1de4329749c5d1d3f762a7db8f`,
supplies the same global \(P,c_j,p_j,R_j,W_j\), including the pointwise
normalization and total \(-90\). Its additional trace-pairing construction is
not used anew here. These are **supplied geometric outputs**, assigned to the
`curve-trace` unit; their existence is not inferred from certificate booleans
or from Serre duality alone.

### Claim register

The following quoted statements are the old `natural_statement` fields.
All records have empty `formal_statement`; “supported” below means this
Engineer's bounded mathematical assessment, not native independent acceptance.

| Claim/version | Exact old statement | Assessment and attribution |
|---|---|---|
| `M_bracket` v1 | “For D=t^k(b E_t+h d_z) and V=t^(ell+1)(A E_t+B d_z), [D,V] has the coefficients displayed in jets:general-bracket; div_sigma(D)=t^k((k-4)b+h'). The leading action is delta A_k=(1-k)br+hr', delta B_k=-khr.” | Supported identity; reproduction of manuscript `jets:bracket`. |
| `M_second_obstruction` v1 | “Under the exact curve and residue hypotheses, after determinant-normalized horizontal matching by volume-preserving order-one and order-two flows, all four duality tests for the order-two vertical class in H1(C,L^3)^2 vanish.” | Supported conditionally; manuscript `jets:second-obstruction`, expanded by the old audit. |
| `M_jets` v1 | “For the data of prop:curve-data and prop:residue-data, finite compositions of holomorphic overlap flows of orders 1,...,7 fix C and its conormal L and admit rows A_k,B_k for 0<=k<=7 matching through index seven with A wedge B=t^2(1+O(t)). On a realization they give sections of I F/I^9 F with leading determinant t^4 E_t wedge d_z=t^5 d_t wedge d_z.” | Supported conditionally; precisely manuscript `prop:jets`, not actual lifted fields. |
| `J_order2` v1 | “For the fixed volume-preserving first two steps, the four vertical obstruction tests equal epsilon_ij times (sum_j(W_j-1)+9 deg L)/12; the symmetric tests vanish by the global residue theorem for P_i P_j.” | Supported; exact refinement of the low-order proof, not another example. |
| `J_order3` v1 | “After interpolating A_2 and incorporating the old order-one transition, adding lambda_j/z_j to h_3 and 3 lambda_j r/z_j to the disk B_3 preserves all equations through determinant degree three and changes the vertical obstruction by 3 sum_j lambda_j r'(q_j); this map is surjective.” | Supported; compensation is allowed to change the not-yet-imposed degree-four equation. |
| `J_order4` v1 | “After simultaneous field matching at order four, the degree-four determinant-target obstruction is represented by -dh_4. The leading order-four horizontal generator is an intrinsic scalar, and each contour residue of this exact differential is zero.” | Supported; this is a canonical differential, not an arbitrary canonical cocycle. |
| `J_induction` v1 | “With targets compatible two determinant degrees ahead of imposed equations, interpolation of A_(k-1), horizontal matching, vertical splitting and target extension work for every k>=3. For k>=4 the vertical obstruction vanishes, and for k>=5 the target obstruction vanishes by negative-degree Serre duality. Every fixed field coefficient stabilizes after the following step.” | Supported universal induction, not extrapolation from \(N=7\). |
| `J_all_orders` v1–v3 | “For every data set satisfying the stated curve and residue hypotheses of prop:jets, and every integer N>=2, there exist compatible overlap transitions and field rows through index N with A wedge B=t^2(1+O(t)). In fact the coupled construction has a coefficientwise stable formal limit with determinant target G sigma^-1. This is a conditional existence theorem, not an analytic convergence or algebraization theorem.” | Supported in all three versions; finite reproduction plus a stable formal strengthening. |
| `A_stein` v1 | “On each Stein chart and overlap, coherent analytic sheaves have zero positive cohomology (Cartan B); the resulting acyclic cover computes the first cohomology used in the Cousin splittings.” | Supported source application, with the Stein/coherence hypotheses checked below. |
| `A_flows` v1 | “A holomorphic vector field vanishing along a divisor has a time-one holomorphic flow germ, with inverse, after restricting transversely over a compact subannulus; finite compositions realize their Taylor series.” | Supported at the local, finite-composition scope used here; no completeness or infinite analytic convergence. |

These are ten distinct indexed claim IDs and twelve historical claim records.
Every one except `J_all_orders` has only version 1 in the old ledger.
`J_all_orders` has the **same context and statement hash**
`50e5c90990b5d4e08ec2dbac399612272f456a2ed6ec4ecba50b8d32c9c2f555`
in v1, v2, and v3:

| Version | Recorded external assumptions | Historical revision assessment |
|---|---|---|
| v1 | Empty list | The proof still uses duality and Cartan B. Empty metadata is not an assumption-free theorem. |
| v2 | `Serre_duality`, assumption hash `9d5681f68158623c55878aa34a8ca6a3c8511f2be4dfb97d8969486706d0d8bb` | Makes duality explicit; mathematical conclusion unchanged. Cartan B is still needed. |
| v3 | The same `Serre_duality`, plus `Cartan_B`, hash `8548bf2264c5cdc1a4a6c9a03ef6bd152f49fa68b873b13e2d3a2811818081c9` | Completes the substantial source declarations; no new theorem or new computation. |

There are no retired assumptions in these twelve claim records. Missing
external-assumption metadata in earlier versions is a provenance omission,
not a demonstrated failure of the argument or a reason to count three results.
The exact declared `Serre_duality` statement added at v2 is:

> For a compact complex manifold X and holomorphic vector bundle V, Serre
> duality pairs H^q(X,Omega^p(V)) perfectly with
> H^(n-q)(X,Omega^(n-p)(V*)). For a smooth compact curve this gives
> H1(C,B)=H0(C,K_C tensor B^-1)^*.

The exact `Cartan_B` statement added at v3 is:

> If X is a Stein manifold and F a coherent analytic sheaf on X,
> H^q(X,F)=0 for every q>=1.

## 2. External inputs and their actual applications

### Cartan B — source ID `url:https://www.numdam.org/item/SHC_1951-1952__4__A18_0/`

Read `jet_audit/cartan_excerpt.txt`, the primary extracted text
`cartan_1952.txt` §4, and the original page image `cartan_theorem_b.png`.
The image resolves the OCR error: the theorem says **\(q\ge1\)**, not
\(q>1\). Cartan, *Faisceaux analytiques sur les variétés de Stein*,
Séminaire H. Cartan 4 (1951–1952), exposé 18, §4, Théorème B,
original p.18-7 (PDF p.8), states that a coherent analytic sheaf on a
Stein manifold has \(H^q=0\) for every \(q\ge1\).
The compact-holomorphically-convex variant on the same page is not used.
The archived attribution `literature/21e056c64ec77fe0bdda790e8811136c.json`
agrees with the primary page; it is a passage record, not another proof.

The report does not merely declare \(U_0=C\setminus Z\) Stein. For sufficiently
large \(m\), duality gives
\(H^1(\mathcal O_C(mZ-D))=0\) for every length-two divisor \(D\), since
\(\deg(K_C-mZ+D)=42-6m<0\) for \(m\ge8\). The complete linear system of
\(mZ\) is therefore very ample. Its canonical section identifies \(U_0\)
with a closed smooth subvariety of an affine hyperplane complement.
The resulting closed holomorphic embedding into \(\mathbb C^a\) supplies
point separation, local coordinates, and compact holomorphic hulls
(coordinate bounds and closedness suffice). Disks and punctured disks, and
the restricted annuli, are Stein as well.

The sheaves used are line/vector bundles or coherent kernels of wedge maps.
Cartan B thus supplies chartwise vertical lifts, surjectivity of the wedge
map on outside sections, and an acyclic cover computing the displayed
\(H^1(C,\cdot)\). There are no disk–disk or triple overlaps. This is the
right \(q=1\) use of the theorem.

### Serre duality — source ID `doi:10.1007/BF02564268`

Read the primary extracted text `jet_audit/serre_duality_1955.txt`,
§3 no.13, Theorem 4, p.22; no.15, p.23; and §4 no.16,
Theorem 5 and corollary, p.24, alongside `serre_excerpt.txt` and
`literature/reviewer_serre_duality_excerpt.txt`.
The passage records
`literature/7a359ad5d9fe0cb9cf9b6349e1206c05.json`,
`f75a4328c8741b2428b10cb8e4d6e490.json`, and
`d2ed7696813bebb2b08d219ae276e0a5.json` reuse this same primary reading;
they are not three independent sources. The DOI-resolution-only record
`90eddb2ef0ab5e0ce4b55d5b9cfd524d.json` establishes no theorem statement.

Theorem 4 concerns a holomorphic vector bundle on a **compact complex
manifold**. Theorem 5 and its corollary give, in normalized notation,
\[
H^q(X,\mathcal O(D)) \quad\text{dual to}\quad
H^{n-q}(X,\mathcal O(K-D)).
\]
Taking \(n=q=1\) yields
\(H^1(C,B)^*\simeq H^0(C,K_CB^{-1})\) for the line bundles here.
All those hypotheses hold for the supplied smooth projective complex curve.
No initial search-summary page numbers or purported curve-only statement
are needed.

No.15 identifies the pairing with cup product followed by top-cohomology
trace. The explicit expression
\[
\sum_j(2\pi i)^{-1}\int_{\gamma_j}f_js,\qquad
s\in H^0(K_CB^{-1}),
\]
is derived in old report §2 by cutoff representatives and Stokes.
Positive disk orientation and “transported inside minus outside” choose
the sign; reversing the convention changes every test together, not
vanishing. This contour normalization is not quoted verbatim from Serre.
In particular, annular overlap coefficients need not extend meromorphically
across the centers.

### Shared residue input, not supplied curve existence

The exact old `A_duality` v1 statement combines the preceding duality with
these contour tests. `A_residue` v1 states:

> A meromorphic differential on a compact complex curve has total residue
> zero; Stokes' theorem gives the corresponding contour identity on a
> punctured curve and zero contour integral for dh with h single-valued
> holomorphic on an annulus.

This elementary input is justified in old report §2: excise disks and apply
Stokes; for \(dh\), integrate the derivative of the single-valued primitive
around the closed path. It is not a new curve-existence assertion and does
not require meromorphic extension of \(h\). Serre duality, residue/Stokes,
and Cartan B can be shared across units without re-proving
`M_curve_data`, `M_residue_data`, or `CT_joint_inputs`. Conversely, those
geometric existence claims are not consequences of source verification here.
All spaces used by this proof are holomorphic; an additional GAGA import is
not silently used to turn certificate metadata into geometric inputs.

## 3. Coordinate identities and the non-scalar target

For \(\widetilde z=\psi(z)\), \(\widetilde t=g(z)t\), \(g^4=\psi'\),
put \(a=(\log g)'\). Direct pushforward gives
\[
\widetilde A_k=g^{-(k+1)}(A_k+aB_k),\qquad
\widetilde B_k=g^{3-k}B_k.
\]
Thus
\(0\to L^{k+1}\to\mathcal E_k\to L^{k-3}\to0\);
vertical differences, not arbitrary vertical coefficients in isolation,
have type \(L^{k+1}\). The split Jacobian is \(g^5\), preserving
\(\sigma=t^{-5}dt\wedge dz\).

For \(D=t^k(bE_t+h\partial_z)\) and
\(V=t^{\ell+1}(AE_t+B\partial_z)\), ordinary-coordinate differentiation
gives
\[
[D,V]=t^{k+\ell+1}\left(
 ((\ell+1-k)bA+hA'-Bb')E_t+
 ((\ell+1)bB+hB'-khA-Bh')\partial_z\right).
\]
Also \(q=\operatorname{div}_{\sigma}D=t^k((k-4)b+h')\), so the leading
action on the field pair is
\(\delta A_k=(1-k)br+hr'\), \(\delta B_k=-khr\).
The negative time-one flow acts by \(\exp(\operatorname{ad}D)\), consistent
with these signs.

The determinant is
\[
v_1\wedge v_2=t^2(A\wedge B)E_t\wedge\partial_z
             =G\sigma^{-1},\qquad A\wedge B=t^2G.
\]
It is **not transported as a scalar**:
\[
[D,G\sigma^{-1}]=(D(G)-qG)\sigma^{-1},\qquad
G\longmapsto\exp(D-q)G.
\]
In particular, on \(G_j(z)t^j\) the infinitesimal contribution is
\[
t^{k+j}\bigl((j-k+4)bG_j+hG_j'-h'G_j\bigr).
\]
This accounts for old transitions acting on previously chosen targets.
Keeping all targets equal to one, or replacing \(D-q\) by \(D\), would be
incorrect after order four; the assessed proof does neither.

The target line bundle is
\(\mathcal M=\mathcal I^4\det\mathcal F=\mathcal I^5\det\mathcal T_Y\)
on a realization, or its finite/formal counterpart before realization.
Its restriction is \(L^4\otimes T_C\simeq\mathcal O_C\), with degree-\(k\)
graded piece \(L^k\). Hence a leading remaining target discrepancy really
is a class in \(H^1(C,L^k)\).

## 4. All four order-two tests

The first flow has \(h=m\), \(b=m'/3\), with inside
\((A_1,B_1)=(p,mr)\) and outside \((P,0)\).
It matches index one, and preserves \(\sigma\) exactly.
For \(U=B_2\), solve
\[
r\wedge U=1-A_1\wedge B_1.
\]
The right side vanishes at each center by \(p(0)\wedge R(0)=1\);
simple common zeros permit division by \(z\). Outside, the wedge map
is surjective and Cartan B supplies a section. Volume preservation then
makes the horizontal discrepancy parallel to \(r\); an order-two flow
with \(b=h'/2\) removes it.

The remaining class is \(H^1(L^3)^2\), with **four** tests indexed by
the basis \(r_i\) of \(H^0(L)\) and the two vertical entries \(n\).
Use
\[
\Psi_{in}=(r_iA_{2,n}+\tfrac14r_i'U_n+\tfrac34r_n'U_i)\,dz.
\]
After horizontal matching its difference is the required test differential.
On the outside,
\(\widetilde\Psi_{in}-\Psi_{in}
=\tfrac34\epsilon_{in}d\log g\).
Thus \(\Psi_{in}+\tfrac34\epsilon_{in}d\log r_1\) is intrinsic.
Its four outside zero-fiber poles contribute \(3\epsilon_{in}\);
subtracting the six logarithmic residues at \(Z\) yields
\[
\sum_Z\operatorname{Res}\Psi^{\rm out}_{in}
=-\tfrac34\epsilon_{in}\deg L.
\]
This uses contour integrals on the punctured curve, not a meromorphic
outside lift. The order-two flow changes \(\Psi\) by
\(-\tfrac12d(hr_ir_n)\), so contributes zero.

The full order-one exponential, including half the second bracket, gives
\[
\Delta A_2=\tfrac13m'p+mp'+\tfrac23mm'r'
             +\tfrac12m^2r''-\tfrac16mm''r,\qquad
\Delta U=-mp+\tfrac13mm'r.
\]
In particular the two horizontal \(m^2r'\) terms cancel. With \(r=zR/c\),
the residue expressions are
\[
\begin{aligned}
F_{in}&=-\tfrac13R_ip_n-\tfrac23R_iR_n'-R_i'R_n,\\
H_{in}&=-R_ip_n-\tfrac13R_iR_n'-\tfrac23R_i'R_n,\\
T_{in}&=F_{in}+\tfrac14H_{in}+\tfrac34H_{ni}\\
&=-\tfrac7{12}R_ip_n-\tfrac34R_np_i
  -\tfrac54R_iR_n'-\tfrac{17}{12}R_i'R_n.
\end{aligned}
\]
Every quantity on the right is evaluated at zero. The double-pole term
\(-R_iR_n/z^2\) contributes both derivative terms; dropping one would
invalidate the test.

For the full matrix, not just its alternating entry,
\[
T^{\rm sym}_{in}=-\tfrac23\operatorname{Res}(P_iP_n\,dz),\qquad
T^{\rm alt}_{in}=\tfrac1{12}\epsilon_{in}(R\wedge p+R\wedge R').
\]
The first equality uses
\(P=R(0)/z+p(0)+2R'(0)+O(z)\).
Because the **same global \(P\)** makes each \(P_iP_n\) a global
meromorphic canonical differential, its total residue is zero.
This kills both diagonal tests and the symmetric off-diagonal test.
The alternating sum uses \(R\wedge p=-1\), giving
\[
\mathcal O_{in}
=\frac{\epsilon_{in}}{12}
 \left(\sum_j(W_j-1)+9\deg L\right)=0.
\]
Both inside and outside total matrices are
\(\left(\begin{smallmatrix}0&-15/2\\15/2&0\end{smallmatrix}\right)\).
Duality now annihilates the entire class. An arbitrary collection of local
rows satisfying just \(\sum(W_j-1)=-90\) would not justify the symmetric
cancellations; such rows are not the hypotheses reviewed here.

## 5. Simultaneous induction and the exceptional corrections

### The two-degree lag and interpolation for every order

After step \(n\), the maintained assertions are:
field rows through index \(n\) match; equations \(A\wedge B=t^2G\) are
imposed through determinant degree \(n\); targets \(G_0,\ldots,G_n\)
are chosen and compatible through target degree \(n\).
Thus the equations using \(G_{n-1},G_n\) are still **unimposed**.
Step two supplies this with \(G=1\).

At step \(k\ge3\), solve
\[
r\wedge B_k=G_{k-2}-\sum_{a=1}^{k-1}A_a\wedge B_{k-a}.
\]
This has split type \(L^{k-2}\); shear terms cancel because
\(\sum B_a\wedge B_{k-a}=0\).
Adding a global \(a\in H^0(L^k)^2\) to \(A_{k-1}\) preserves lower
matching and first changes the determinant in degree \(k\), through
\(a\wedge B_1\). Values can be prescribed at every point of \(Z\):
\[
\operatorname{coker}(\mathrm{ev}_{L^k})^*
\simeq H^0(L^{4-k}(Z))/H^0(L^{4-k}).
\]
For \(k=3\) and \(4\) this quotient is zero by the supplied section counts;
for every \(k\ge5\) its numerator has degree
\(10(4-k)+6\le-4\). This is an all-order proof, not finitely many
successful evaluations. Since \(B_1(q_j)=R_j(0)\ne0\), arbitrary values of
\(a\wedge B_1\) make the right side vanish at \(Z\).
Only values, not derivative interpolation, are required for reduced \(Z\).
Division by \(z\) and Cartan B give the horizontal rows.

The global addition is **not invisible** to old transitions. Its current
index-\(k\) contribution from the order-one generator is
\[
\delta A_k=\tfrac{k-1}{3}m'a+ma',\qquad
\delta B_k=-ma,\qquad r\wedge(-ma)=a\wedge(mr).
\]
The proof includes these terms. Other old generators and repeated brackets
start later. Target compatibility at degree \(k-2\), together with lower
field matching, makes the remaining horizontal discrepancy wedge to zero
with \(r\). Remove it by \(-khr\), using \(b=h'\) at \(k=3\), \(b=0\)
for \(k\ge4\). The new transition cannot alter any target degree below \(k\).

The remaining vertical class is \(H^1(L^{k+1})^2\), which vanishes for
all \(k\ge4\), since its dual is \(H^0(L^{3-k})^2=0\).
Chartwise vertical corrections do not alter the determinant equation
currently imposed because \(B_0=0\).

| Change at step \(k\) | First determinant degree possibly affected |
|---|---:|
| Global addition to \(A_{k-1}\) | \(k\) |
| Choice/change of \(B_k\) | \(k\) |
| Vertical correction to \(A_k\) | \(k+1\) |
| Order-\(k\) transition acting on \(G_0=1\) | \(k+2\), i.e. target degree \(k\) |
| Choice of \(G_k\) | Its equation is in degree \(k+2\) |

### Order three: compensation does not have to preserve degree four

At \(k=3\), \(H^1(L^4)^2=H^1(K_C)^2\) has two constant tests.
Changing \(h\) by \(\lambda_j/z\), still taking \(b=h'\), and changing
the disk row by
\[
\delta B_3=3\lambda_jr/z
\]
is holomorphic, wedges to zero with \(r\), and cancels the new overlap
horizontal contribution. Keeping the vertical component fixed in that disk
coordinate specifies a legitimate \(\mathcal E_3\) section; a different
split coordinate merely introduces the prescribed vertical shear.
Old positive-order transitions acting on this new index-three input start
at index four, not three.

The exact vertical change at index three is
\[
\lambda_j(r'/z+2r/z^2),\qquad
\operatorname{Res}\bigl(\lambda_j(r'/z+2r/z^2)\,dz\bigr)
=3\lambda_jr'(q_j).
\]
The span hypothesis gives a right inverse. For two independent rows
\((\alpha,\beta),(\gamma,\delta)\), with
\(\Delta=\alpha\delta-\beta\gamma\ne0\), an obstruction \((o_1,o_2)\)
is killed by
\[
\lambda_1=(-\delta o_1+\gamma o_2)/(3\Delta),\qquad
\lambda_2=(\beta o_1-\alpha o_2)/(3\Delta).
\]
This is actual surjectivity, not just a count of parameters.

The disk determinant can change in degree four through
\(A_1\wedge\delta B_3\), and vertical splitting can also change
\(A_3\wedge B_1\). These terms do **not** have to vanish. At step three
the degree-four equation using the already selected \(G_2=0\) has not yet
been imposed. Step four's global \(L^4\)-addition to \(A_3\), whose values
interpolate at \(Z\), handles precisely these new center values without
spoiling index-three matching. The modified order-three transition still
preserves \(\sigma\) exactly. No extra compatibility condition was hidden.

### Order four: intrinsic exactness, not a cohomology dimension argument

All earlier transitions preserve \(\sigma\), and \(G_1=G_2=G_3=0\).
The new degree-four target discrepancy is \(-h'\).
For a generator, split transformation gives
\[
\widetilde h=g^{4-k}h,\qquad
\widetilde b=g^{-k}(b+ah).
\]
At \(k=4\), \(h\) is an intrinsic scalar and \(h'\,dz=dh\) is a
canonical differential. Although \(b=0\) was chosen in one disk coordinate,
it need not remain zero in another; this is harmless because its divergence
coefficient \(k-4\) is zero.
Conjugating by earlier positive-order transitions changes an order-four
generator only from order five onward. The same applies to their action
on the new \(G_4t^4\).

Thus the target class in \(H^1(L^4)=H^1(K_C)\) has representative
\(-dh\); each contour integral is zero separately. Its sole dual test is
against \(1\), so the class splits for **any** horizontal discrepancy
created by the preceding interpolation and compensation. Single-valued
holomorphy on the annulus suffices; no pole expansion at the center is
assumed. This addresses the exceptional nonzero \(H^1(K_C)\), rather
than incorrectly treating it as a negative-degree case.

For every \(k>4\), the new target cocycle includes the old-transition
contributions on the already selected targets. It need not still equal
\(-dh\). Its cohomology nevertheless vanishes:
\(H^1(L^k)^*=H^0(L^{4-k})=0\).
Choosing \(G_k\) does not affect a determinant equation until degree \(k+2\).
This closes the simultaneous induction.

## 6. Finite germs, stabilized formal construction, and analytic boundary

For each fixed generator on a relatively compact annulus,
\(D(t)=O(t^2)\) and \(D(z)=O(t)\). In the scaled variable \(t=\varepsilon T\)
its components and first derivatives are \(O(\varepsilon^k)\) on a slightly
larger compact domain. For sufficiently small \(\varepsilon\), Picard
iteration on complex time \(|s|\le1\) stays in that domain and is contractive.
The holomorphic flow and inverse follow, and a finite number of generators
has a common smaller transverse neighborhood. This proves `A_flows` in the
needed scope without a global completeness assertion. The flows fix \(C\)
and act trivially on its conormal, since \(t\mapsto t+O(t^2)\).
The general local assertion for a field vanishing on the divisor also follows
by finite subdivision of time in the local ODE theorem, followed by shrinking
around the fixed divisor. There is no further triple-overlap condition.

Successive field choices are not literally nested:
\(A_n\) may be changed once more at step \(n+1\).
After that it is fixed; \(B_n\), \(G_n\), and the order-\(n\) generator are
finalized at step \(n\). Hence every coefficient stabilizes in finite time.
Positive-order generators raise the \(\mathcal I\)-adic filtration, so their
infinite composition exists **formally**. Every fixed determinant equation
is preserved after being imposed; in the stable limit
\(A\wedge B=t^2G\), \(G|_C=1\), exactly.
This proves `J_all_orders`, not convergence on one analytic neighborhood.

For the finite proposition, indices \(0,\ldots,7\) give logarithmic-frame
coefficient degrees \(1,\ldots,8\), so discrepancies are in
\(\mathcal I^9\mathcal F\), not \(\mathcal I^8\mathcal F\).
On a realization the sections lie in
\(\mathcal I\mathcal F/\mathcal I^9\mathcal F\).
Their determinant is \(t^4(1+O(t))E_t\wedge\partial_z\), equivalently
\(t^5(1+O(t))\partial_t\wedge\partial_z\).

The downstream graded calculation is consistent:
\[
0\to L^n\to\mathcal I^n\mathcal F/\mathcal I^{n+1}\mathcal F
\to L^{n-4}\to0.
\]
The dual powers \(L^{4-n}\) and \(L^{8-n}\) have negative degree for
\(n\ge9\). At \(n=8\) the horizontal dual is \(\mathcal O_C\), so the
same vanishing argument cannot start there. Graded vanishing alone is not
holomorphic lifting. Hausdorff realization, contraction, formal-functions
arguments, and actual analytic fields remain in the `analytic-realization`
unit and are not supplied by the formal limit.

## 7. Exact evidence: what is reused and what it proves

The old checker was inspected in full, including its negative-control and
CLI exit paths. It derives ordinary-coordinate brackets via differentiation,
does not assume the displayed logarithmic bracket, and uses rational/symbolic
arithmetic. JSON floats are rejected; equality failures raise explicit
exceptions, so Python optimization cannot disable them.

The preserved `verification_output.json` reports 96 checks:
statement 2, bracket 3, transport 7, order two 38, order three 8,
order four 4, induction 23, typed-output consistency 11. These include
metadata/shape and degree bookkeeping checks, not 96 independent geometric
theorems. In particular:

* Metadata flags assert the adopted hypotheses; they do not witness a curve.
* Local Taylor variables check the universal residue identities. This finite
  Taylor reduction is legitimate because the displayed pole bounds imply
  that only \(R(0),R'(0),p(0)\) contribute; higher Taylor coefficients cannot
  generate an omitted residue. It is not testing random examples.
* The rank-two check is a rational-function right inverse conditional on a
  nonzero minor. The existence of such a minor uses the supplied span.
* Scalar/differential covariance, general target transport, and symbolic
  degree formulas support the proof, but surjectivity, Serre duality,
  contour exactness for arbitrary annular functions, and formal stabilization
  still require the prose argument just assessed.

The documented historical environment is Python 3 with SymPy 1.14.0.
The preserved output does not record an exact Python patch version; none
is inferred. There is no Lean artifact or kernel theorem in this unit.

The five historical mutations reject: the sign of \(-7/12\) in \(T\);
the compensation coefficient \(3\to2\); the divergence sign in target
transport; the sign of the order-four differential; and the quotient power
\(9\to8\). `negative_control_cli_output.json` additionally records actual
CLI exit 1 for \(T_{00}\), with residual \(-7R_{01}p_{01}/6\), after
the \(-7/12\to+7/12\) mutation. These are deliberate invalid-certificate
controls, **not admissible geometric counterexamples** or manuscript
refutations.

The historical typed evidence was also read:
`jacobian_discovery.json`, `jacobian_bracket_discovery.json`,
`jacobian_contract.json`, `jacobian_payload.json`, `jacobian_output.json`.
Discovery suggestions marked `NEEDS_MORE_TYPED_REQUIREMENTS` are not
successful computations. The inspected/run operation is
`polynomial_field.vector.divergence.compute`, server `jacobian` 0.14.0,
protocol `2025-11-25`, `mcp-stdio`, exact `QQ` polynomials on ordered
variables `["t","z"]`. The output method is `SYMPY_DIVERGENCE`, runtime 21 ms.
Payload and recorded request agree on
\[
D=(t^5(z^2+1),t^4z^3),\quad
\operatorname{div}D=t^4(8z^2+5),\quad
\operatorname{div}_{\sigma}D=3t^4z^2.
\]
This is a bounded specialization and adapter sanity check, not a proof of
the quantified bracket, induction, or geometry, nor an independent proof
kernel. The old certificate/report record success, null adapter error, and
no timeout; nothing unavailable or `UNKNOWN` is used as evidence.
No current Jacobian operation was performed by this Engineer; the parent's
single current adapter operation is separate.

All these computations are reused as historical reviewed evidence, not
represented as freshly replayed results. No new cache or auxiliary
computation output is needed for this assessment.

## 8. Historical status reconciliation and ledger guidance

The receipt
`$WORKSPACE/.argus-campaign-9000048/projects/46e84e6fea35/handoffs/bf979be90014/round-0001.json`
has `producer_role="reviewer"` and `review.status="done"`. Its reason is:

> The bounded conditional proof of prop:jets is complete. All four residue
> tests cancel, the order-three correction preserves imposed equations, and
> the order-four obstruction is the exact differential -dh. The higher-order
> argument is a universal induction, not an enlarged finite test. This does
> not certify the full manuscript.

This is the historical acceptance actually reused. The Engineer summary in
that same handoff still says review/citation/novelty pending because it is
the submission text; similarly the old report, certificate, and verification
JSON retain their original `pending` labels. They do not cancel the later
bounded Reviewer decision.

Within this unit, the old graph promotes only `J_all_orders` and graph-only
`J_independent_review` to `proved`, `reviewer_confirmed=true`, with
`verification_kind="reviewed_prose_not_kernel"` on the endpoint. It leaves
`M_bracket`, `M_second_obstruction`, `M_jets`, `J_order2/3/4`,
`J_induction`, `A_stein`, and `A_flows` open/unconfirmed, as well as shared
`A_duality` and `A_residue`. Those are real unpropagated supporting-node
statuses, not evidence that the endpoint receipt is absent, and not license
to mark all supporting nodes independently accepted.

The ledger contains version-matched Reviewer judgements for the bracket,
orders two–four, induction, finite proposition, and `J_all_orders`; source
judgements `judgement-Serre_duality-47e424d34779` and
`judgement-Cartan_B-f7f263317810` support the exact assumption hashes above.
`judgement-J_all_orders-edfe6d5d9bbe` targets the unchanged
`50e5c909...` statement hash. Thus reuse matches the context and theorem
versions, including the provenance-only v2/v3 revisions. The receipt itself
does not contain artifact hashes or a command transcript; it must not be
described as a separate hash attestation or as proof of this session's
execution. Its bounded decision does not approve later curve-input or
analytic endpoints.

**For the active ledger:** retain the conditional finite/formal assessment
of all ten indexed IDs, with explicit sources `Serre_duality`
(`doi:10.1007/BF02564268`) and `Cartan_B`
(`url:https://www.numdam.org/item/SHC_1951-1952__4__A18_0/`), plus the
shared derived residue/Stokes input `A_residue` and local finite-flow proof
`A_flows`. Keep input existence attached to `M_curve_data`,
`M_residue_data`/`CT_joint_inputs`, and analytic realization/lifting separate.
There is **no concrete mathematical gap found within the supplied-data
implication**, and no new manuscript-error finding. Current independent
review remains `pending_native_reviewer`; nothing here accepts the family,
the overarching surface claim, or novelty/significance.
