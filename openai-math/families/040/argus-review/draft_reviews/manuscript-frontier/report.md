# manuscript-frontier

**Assessment: partial support at the correspondence interface; nine
manuscript obligations are unattempted in the listed Argus drafts.**
They are accounted for, not accepted or declared false.

## Scope and provenance

This unit covers every remaining old claim: `C9000040` and the nine
version-1 manuscript obligations listed below. The sources are OpenAI's
*Bloch's conjecture for surfaces with \(p_g=0\)*, September 24, 2026,
manifest revision `4eaee87548250b2682affda7d05d947c05554bae`, the old graph,
and old `REPORT.md`, Section 10. All twelve manifest-listed TeX inputs in
both the old reference directory and upstream directory match their
existing manifest digests.

The old umbrella `C9000040` is an adversarial audit mission, not a
mathematical assertion. Its graph points to the bridge, but that edge
cannot mean the full integral theorem was proved. It is explicitly
excluded as a current instruction or theorem result. `OBJECTIVE.md`
requires retrospective coverage, not a new error search or proof of
every theorem in the paper.

No old Engineer/Reviewer supports judgement is attached to these nine
bundles. The graph references the original manuscript, not an independent
Argus proof. The old report explicitly excludes their substantive
geometry and positivity. "Unattempted" here is a statement about this
evidence set; it is not a claim that a classical theorem is unknown.

## Every obligation and the precise missing support

### C40_BLOCH@1

Exact manuscript theorem, `introduction.tex`, `thm:bloch`: for every smooth
connected projective complex surface with \(p_g=q=0\), the **integral**
degree map \(CH_0(S)\to\mathbb Z\) is an isomorphism. No minimality or
construction hypothesis is present.

**Unresolved in the old Argus evidence.** The bridge gives a form for an
individual literal expression, not a vanishing weighted sum with a
nonzero coefficient. The missing chain includes virtual geometry,
positivity in both numerical branches, reductions, and the torsion
interface. Neither the nine finite cases nor legacy bridge support
certifies this theorem.

### C40_REDUCTIONS@1

`reductions.tex`, `lem:birational` and `prop:reduction`: point blowups
preserve \(p_g,q\) and integral degree-preserving \(CH_0\); the rational
problem reduces to minimal general-type \(p_g=q=0\) surfaces with
\(1\leq K^2\leq9\). It may be tested on chosen point blowups.

**Unattempted bundle.** The numerical deductions are transparent under the
named standard inputs: Noether gives \(c_2=12-K^2\), Hodge theory gives
\(b_2=10-K^2\), and an ample class gives \(b_2\geq1\). But the listed Argus
proof does not independently establish the blowup formula, factorization
of birational maps, or the cited non-general-type Bloch--Kas--Lieberman
input. Those are the exact source/application obligations, not an open
conjecture about the displayed arithmetic.

### C40_LOCALIZATION@1

`derived.tex`, `prop:quot-pot` and `prop:fixed-pot`, in settings
(i) \(p_g=q=0\), or (ii) \(p_g=q=1\), \(K\) ample, \(D=3K\).
The based-determinant Quot enhancement is claimed to induce an equivariant
perfect obstruction theory, with virtual tangent
\[
\operatorname{fib}\{R\operatorname{Hom}(S',Q)
\to R\Gamma(\mathcal I_o)[1]\}
\]
and dimension \(v=2n+(A-K)D\). Its actual fixed obstruction theory must
identify with the fixed restriction, compatibly with the cotangent maps;
the moving complex is \(\bigoplus_{i\ne j}R\operatorname{Hom}(S'_i,Q_j)\).

**Unattempted.** Required support is the construction and Tor-amplitude
of the enhancement, the obstruction morphisms and fixed-comparison
compatibility, not merely equality of K-classes. The Ext algebra and
finite certificate cannot supply this data or justify virtual localization.

### C40_FIXED@1

`fixed.tex`, `prop:fixed-pg0`: a nonempty \(p_g=q=0\) fixed part is
\(|T|\times|H|\times X^{[n_1]}\times X^{[n_2]}\), with virtual class
\(\prod_i x_i^{h^1(D_i)}e(F_i)\cap[W]\), where
\(F_i=((K-D_i)^{[n_i]})^\vee\otimes\mathcal O(1_i)\).
Negative \(m_i\) give zero; other projective integrations extract
\([x_1^{m_T}x_2^{m_H}]\).

**Unattempted virtual-class identification.** Once that virtual class and
the stated linear-system dimensions are supplied, the extraction follows
algebraically. Deriving those Euler factors from the compatible fixed
obstruction theory is the missing geometric obligation. A check of the
literal extraction does not prove it.

### C40_AUXILIARY@1

`fixed.tex`, `prop:fixed-auxiliary`: for \(p_g=q=1\), \(K\) ample,
\(D=3K\), only empty or canonical low divisors survive, on the actual
fibers with the low variable zero. Their multipliers are respectively
\(1\) and \(-s\), with \(s>0\), and the statement includes operational
insertions with marked outputs.

**Unattempted.** Required support is the vanishing of other low-divisor
virtual contributions, the canonical coefficient and its sign, and
compatibility of high-fiber virtual pullback with retained insertions.
Ordered-Ext signs do not establish these virtual multiplicities.

### C40_CHOW_RELATION@1

`relation.tex`, `thm:chow-relation`: in either setting, for \(p\geq0\) and
\(v>p+2\), sum admissible contributions with multiplier \(1\) in the
\(p_g=q=0\) case; in the auxiliary case use pairs \((3K,0),(0,3K)\)
with multiplier \(1\) and \((2K,K),(K,2K)\) with multiplier \(-s\).
The finite sum is \(0=c[\Delta_X]+\Gamma\) in rational codimension two.
`rel:correspondence` then uses \(c\ne0\) to annihilate degree-zero cycles.

**Partial support, not the full relation.** The degree argument is valid
conditional on a genuine nonlocalized equivariant pushforward: the
ordinary codimension-two component would carry \(t^{p+2-v}\), a forbidden
negative power. Identifying its localization summands and multiplicities
still requires the preceding unattempted geometry.

The correspondence implication itself has a complete short argument.
For \(z\in CH_0(X)^0_{\mathbb Q}\), \(a\boxtimes b\) acts by zero when
\(\operatorname{codim}a>0\), since \(za=0\) by dimension. When
\(a=\lambda[X]\), it acts as \(\lambda\deg(z)b=0\). The diagonal acts as
identity. Thus a **genuine** relation with \(c\ne0\) implies \(cz=0\)
and \(z=0\). This verifies an interface, not existence of the relation
or nonvanishing of its coefficient.

### C40_NONRANK@1

`nonrank.tex`, `prop:nonrank`: for a smooth minimal general-type
\(p_g=q=0\) surface with \(1\leq k_0\leq8\), blow up
\(e=\max\{k_0-5,0\}\) distinct points. Some choices of lines and \(D,n,p\)
must give a Chow relation with \(c>0\).

**Unattempted positivity.** The missing argument constructs the required
orthogonal class of negative square, controls effective-divisor and
length bounds, eliminates unwanted positive-length contributions and
proves that a remaining positive pairing actually occurs. The bridge's
formal coefficient rule and zero-length vanishing do not supply these
inequalities or existence statements.

### C40_RANKONE@1

`rankone.tex`, `prop:rankone`: for a smooth minimal general-type
\(p_g=q=0\) surface with \(K^2=9\), data
\(L_1=L_2=0,D=3K,n=20,p=7\) must yield \(c>0\).
The proposed proof compares common selected coefficients on the
Cartwright--Steger auxiliary surface and uses \(c_{\rm mid}=12\).

**Unattempted.** The bridge supplies transfer of already selected
coefficients when the listed numerical data agree. It does not establish
the auxiliary virtual relation \(c_{\rm out}-s c_{\rm mid}=0\), the
required shifted middle-coefficient calculation, effective-line
multiplicities, or the final strict positivity. The certificate's
zero-line length-two cases and single \(T=\mathcal O(1)\) case are not the
specified \(D=3K,n=20,p=7\) experiment.

### C40_INTEGRAL@1

`conclusion.tex`, the proof of `thm:bloch`: rational degree-zero vanishing
and \(q=0\), together with Roitman's torsion injection into the Albanese,
give integral degree-zero vanishing.

**Unattempted as an independently sourced bundle, with a correct
conditional interface.** Tensoring with \(\mathbb Q\) being zero makes
each element torsion; if Roitman's injection applies, \(q=0\) gives
\(\operatorname{Alb}=0\) and kills that torsion. A complex point gives
degree-one surjectivity. This is not an independent verification of the
Roitman citation or of the missing rational vanishing. No new claim is
made about the truth or novelty of Roitman's known theorem.

## Reasoned exclusions and final boundary

The manuscript's broader \(p_g=0\) Albanese corollary, motivic consequences,
Hilbert-power conclusions, abstract, bibliography, and figure are reference
material, not substantive old Argus drafts in this inventory. The
manuscript manifest's separate `research/papers/...` output paths are
metadata for another campaign, not omitted `9000040` proof drafts.
The empty ledger lock has no mathematical content. The PDF/text pairs,
saved certificate, and repeated report/manuscript arguments are duplicates
or support, not independent results.

All exclusions are explicit in the index and this assessment. Unresolved
items have mathematical or source/application obligations, not blanket
claims that an inaccessible document is correct. The full manuscript has
neither been verified nor refuted by this review. Acceptance of complete
old-draft coverage remains with the native independent Reviewer.
