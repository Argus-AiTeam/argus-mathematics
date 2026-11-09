# Four-profile quantitative extension

## Source and mathematical scope

The audited source is OpenAI, *A superquadratic separation between sensitivity
and block sensitivity*, September 25, 2026, staged under
`research/openai_manuscript/`. The public source comparison uses revision
`4eaee87548250b2682affda7d05d947c05554bae` of `openai/math`.
The manuscript's four recurrences concern individual original input bits,
not independent abstract changes of child predicates. This distinction is
essential.

Write \(L=d+2\), \(k=2M^2+1\), \(t=16\), and \(r=\lceil\sqrt M\rceil\).
In the order \((S_0,S_1,J_0,J_1)\), Proposition `prop:recurrences` gives the
nonnegative transfer matrix
\[
 R=\begin{pmatrix}
 16&1&0&3\\ M^2&r&0&0\\16&0&0&3\\0&r&M^2&0
 \end{pmatrix},\qquad
 (S_{0,0},S_{0,1},J_{0,0},J_{0,1})\le (L,LM,0,0).
\]
After division by \(LM^{\ell+b}\), put \(p=16/M\) and \(q=r/M\).
The normalized matrix is
\[
 T=\begin{pmatrix}p&1&0&3\\1&q&0&0\\p&0&0&3\\0&q&1&0\end{pmatrix}.
\]
Its characteristic polynomial is
\[
 X^4-(p+q)X^3+(pq-4)X^2+3.
\]
This identity is to be checked as a polynomial identity, not inferred from a
numerical eigenvalue computation.

The live target is a uniform finite-depth theorem for even \(d\ge2\),
\(M=16\,3^d\), \(r=4\,3^{d/2}\), followed by an actual Boolean-function
family with \(\operatorname{bs}(F_m,0)\ge s(F_m)^{161/80}\).
The proposed finite seed is \(d=20\), with sensitivity bound \(36M^{21}\).
The all-depth argument below proves the uniform profile estimate. The exact
seed computation proves the sharper constant 36; finite propagation by itself
is not being used to prove an assertion for all depths.

## Uniform finite-depth theorem

**Theorem.** For every integer \(h\ge1\), set \(d=2h\),
\(M=16\,3^{2h}\), and \(r=4\,3^h\). At every level \(0\le\ell\le d\),
the actual construction satisfies
\[
 S_{\ell,0}\le2(d+2)M^\ell,\qquad
 S_{\ell,1}\le2(d+2)M^{\ell+1}.
\]
Here \(r^2=M\), so this is precisely the manuscript's choice
\(r=\lceil\sqrt M\rceil\), not a change to the construction.

**Proof of the analytic estimate.** Put \(q=1/(4\,3^h)\), \(p=16q^2\),
and \(x_n=T^n(1,1,0,0)\), writing its components as \(a,b,c,e\).
Nonnegative matrix comparison bounds every normalized actual profile by
\(x_n\). Moreover \(T(1,1,0,0)\ge(1,1,0,0)\), so \(x_n\) is
coordinatewise nondecreasing. It suffices to bound \(a_{2h},b_{2h}\).

The exact two-step matrix is
\[
 T^2=\begin{pmatrix}
 1+p^2&p+4q&3&3p\\
 p+q&1+q^2&0&3\\
 p^2&p+3q&3&3p\\
 p+q&q^2&0&3
 \end{pmatrix}.
\]
Set
\[
 \alpha=p+p^2+4q,\quad\beta=9+3p,\quad
 \gamma=p+q+q^2,\quad\delta=3+p.
\]
Starting from \(u_0=1,v_0=0\), define
\[
 u_{j+1}=(1+\alpha)u_j+\beta v_j,\qquad
 v_{j+1}=\gamma u_j+\delta v_j.
\]
For \(0\le p,q\le1\), induction using the displayed matrix gives
\[
 a_{2j},b_{2j}\le u_j,\quad c_{2j}\le3v_j,\quad e_{2j}\le v_j.
\]
For example, the first row is bounded by
\((1+p^2+p+4q)u_j+(9+3p)v_j\).
The coefficient comparison for the second row is
\(p^2+3q-q^2\ge0\), and that for the third row is
\(2p-p^2+3q^2\ge0\). Both follow from \(p,q\in[0,1]\).

Suppose \(h\ge3\). The elementary induction
\(9(n+3)\le3^{n+3}\) gives
\[
 q\le1/108,\qquad hq\le1/36,\qquad q3^h=1/4.
\]
In particular \(p\le q/6\), and direct rational inequalities give
\[
 \alpha\le17q/4,\quad\beta\le10,\quad
 \gamma\le6q/5,\quad\delta\le3+q/6.
\]
Let \(\lambda=3+7q\) and \(w_j=v_j+(\gamma/2)u_j\).
The coefficients of \(u_j,v_j\) in \(w_{j+1}\) are respectively
\((\gamma/2)(3+\alpha)\) and \(\delta+\beta\gamma/2\).
They are at most \((\gamma/2)\lambda\) and \(\lambda\).
Consequently
\[
 w_j\le(\gamma/2)\lambda^j.
\]
Since \(v_j\le w_j\) and \(1+\alpha+2\le\lambda\), another induction gives
\[
 u_j\le(1+\alpha)^j+(\beta\gamma/4)\lambda^j
 \le(1+17q/4)^j+3q(3+7q)^j.
\]
The induction's last step is the exact identity
\[
 (1+\alpha)\frac{\beta\gamma}{4}\lambda^j+
 \frac{\beta\gamma}{2}\lambda^j
 =\frac{\beta\gamma}{4}(3+\alpha)\lambda^j.
\]

For \(x\ge0\), induction proves
\((1+x)^n(1-nx)\le1\).
Using \(hq\le1/36\), it follows that
\[
 (1+17q/4)^h\le144/127,\qquad
 (1+7q/3)^h\le108/101.
\]
Therefore
\[
 u_h\le\frac{144}{127}
       +3q3^h\frac{108}{101}
 =\frac{144}{127}+\frac{81}{101}
 =\frac{24831}{12827}<2.
\]
For \(h=1,2\), the same four-state matrix is evaluated exactly over the
rationals, giving terminal ordinary maxima below two. These two base
cases, monotonicity of \(x_n\), and the all-\(h\ge3\) induction prove
the theorem. No asymptotic approximation or bounded search substitutes
for this induction.

## Source-level dependency audit

1. A cyclic tournament on \(2M^2+1\) vertices has outdegree \(M^2\).
   Independent uniform labels in \([r]\) avoid every destination-constant
   labelled 16-vertex subtournament: the union-bound upper estimate is
   \(k^{16}/r^{104}\le 3^{16}M^{-20}<1\) for \(M\ge3\).
   This is an existence argument, not an explicit list of all labels.
2. The level-zero predicates are unions of balls of distinct integer radii
   at most \(d\), around disjoint \(L\)-bit centres. Centres are \(2L\)
   apart. A rejecting input has at most one centre within \(d+1\);
   hence \(S_{0,0}\le L\), while \(S_{0,1}\le LM\). The minimum distance
   to a centre is 1-Lipschitz along cube edges, so both joint profiles
   vanish.
3. Each condition in a fixed recursive clause uses a different child.
   One original input bit can therefore repair at most one failed
   condition of that clause. The target-repair list has fewer than 16
   clauses by the label condition. The gate-repair list induces a tournament
   of maximum outdegree one and therefore has at most three vertices,
   with at most one sink. All nonsink repairs change both the gate predicate
   and the strongest child predicate. For a joint parent repair, two distinct
   gate thresholds must change even at that possible sink. This yields
   precisely the four rows of \(R\).
4. At zero, the initial \(M\) disjoint \(L\)-bit centre supports switch
   every predicate to one. At level \(\ell\), union a preceding block across
   all \(r\) children of one row. Other rows remain zero, so every gate of
   that row passes. This gives \(Mk^\ell\) disjoint nonempty common blocks,
   each of size \(Lr^\ell\); all predicates remain zero at zero.
5. The OR of \(M\) disjoint top-level copies has
   \(s(f)\le\max(MS_{d,0},S_{d,1})\), \(f(0)=0\), and
   \(\operatorname{bs}(f,0)\ge M^2k^d\). At an accepting OR input, either
   exactly one copy accepts or no bit is sensitive. At a rejecting input,
   sum the sensitivities of the rejecting copies.
6. Disjoint composition satisfies \(s(f\circ g)\le s(f)s(g)\).
   If \(g(0)=0\), the Cartesian products of disjoint zero-sensitive block
   families give
   \(\operatorname{bs}(f\circ g,0)\ge
     \operatorname{bs}(f,0)\operatorname{bs}(g,0)\).
   Thus an integer inequality \(B^{80}\ge A^{161}\), together with an
   actual seed satisfying \(s(f)\le A\) and \(\operatorname{bs}(f,0)\ge B>1\),
   implies the required unbounded composed family.

These elementary arguments discharge the combinatorial dependencies; neither
the desired existence theorem nor its exponent is an assumption. For a stronger
check, the local formal source includes the upstream dependency
proofs themselves, rather than importing an unchecked upstream binary.

## Exact seed and infinite-family consequence

At \(d=20\), exact integer iteration of \(R\) from \((22,22M,0,0)\)
gives
\[
 \max(MS_{20,0},S_{20,1})\le36M^{21}.
\]
The stored rows are majorants and need not equal the true profiles.
Let
\[
 A=36M^{21},\qquad B=M^2(2M^2+1)^{20}.
\]
The preceding construction arguments give an actual total seed \(f\)
on \(n=22M^2((2M^2+1)r)^{20}\) bits with \(f(0)=0\),
\(s(f)\le A\), and \(\operatorname{bs}(f,0)\ge B>1\).
In particular it is nonconstant.

The exact exponent check can be kept small:
\[
 B\ge2^{20}M^{42},\qquad
 36^{161}M^{21}<2^{1600}.
\]
Multiplying the second inequality by \(M^{3360}\) shows
\(A^{161}<(2^{20}M^{42})^{80}\le B^{80}\).
The smaller numerical inequality is equivalently
\(2^{1194}>3^{742}\), since \(M=2^4 3^{20}\).
It also follows from \(3^5<2^8\):
\(3^{742}=9(3^5)^{148}<9\,2^{1184}<2^{1194}\).

For \(F_m=f^{\circ m}\), the Cartesian-product block construction gives
\[
 s(F_m)\le A^m,\qquad \operatorname{bs}(F_m,0)\ge B^m.
\]
Raising to the integer powers 161 and 80 proves
\(s(F_m)^{161}\le\operatorname{bs}(F_m,0)^{80}\).
Nonnegativity and the positive 80th root give
\[
 \operatorname{bs}(F_m,0)\ge s(F_m)^{161/80}.
\]
Because \(B>1\), the zero-input block sensitivity tends to infinity.
Each \(F_m\) is a total nonconstant Boolean function on \(n^m\) bits.

## Comparison with previous guarantees

The manuscript permits every \(d\ge1\) and integer \(M\ge9^{d+1}\), not only
its displayed \(d=9\) seed. Its complete explicit exponent guarantee is
\[
 \alpha_{\rm old}(d,M)=
 2+\frac{d\log(2+M^{-2})-2\log(2(d+2))}
          {(d+1)\log M+\log(2(d+2))}.
\]
Whenever this exceeds two, increasing \(M\) decreases the numerator and
increases the denominator. The strongest candidate therefore uses
\(M=9^{d+1}\). An independent source search found the numerical maximum
near \(d=20\), approximately \(2.00647082823\); this decimal is not an
exact optimization certificate. The following exact argument compares the
target against *every* member of that full explicit parameter family,
without relying on this numerical optimization.

For the old parameters, \(B^{80}<A^{161}\) is equivalent to
\[
 (2+M^{-2})^{80d}<(2(d+2))^{161}M^{d+1}.
\]
For \(1\le d\le37\), \(M\ge9^{d+1}\ge81\) implies
\(2+M^{-2}<17/8\), and the verifier checks the 37 integer inequalities
\[
 17^{80d}<8^{80d}(2(d+2))^{161}9^{(d+1)^2}.
\]
For all \(d\ge38\), use \(2+M^{-2}<3\) and
\(M^{d+1}\ge3^{2(d+1)^2}\).
The inequality \(2(d+1)^2\ge80d\) holds at 38 and its increment is
\(4d-74>0\). This proves the claimed strict comparison for all \(d,M\).
It does not bound the best possible *unpublished* analysis of the old
construction, only the complete quantitative guarantee stated in the source.

The quantitative improvement proved here is sharper analysis and parameter
selection for the same construction. The four recurrences themselves are
already in the manuscript. Meiburg's arXiv:2608.00851v1, Theorem 6.1 and
Corollary 6.2 concern spectral sensitivity, not ordinary sensitivity.
Ambainis--Sun, arXiv:1108.3494v1, Theorem 1 gives the quadratic ordinary
sensitivity family \(\operatorname{bs}=(2s^2-s)/3\).
The bounded primary-source search did not establish an independent ordinary
sensitivity exponent at least \(161/80\). Search silence is not a proof
of novelty; literature-wide originality and independent review remain open.

## Formal certification

The public upstream comparator contains a `sorry`, whereas its documentation
describes a full implementation elsewhere. Upstream currently specifies Lean
4.34.1; this campaign uses Lean 4.31.0. The 36 required proof modules are archived under
`upstream/`, with their Apache-2.0 license and pinned source revision.
The combined `Main.lean` includes their proofs in dependency order and
the new quantitative proof. The official fresh compiler run succeeded with
exit code zero, `proof_holes=[]`, and axiom-audit exit code zero.
It checked the actual label, raw-bit, block, OR, and composition dependencies
as well as the new all-depth estimate and the composed Boolean family.
No unchecked upstream implementation is being treated as kernel evidence.

The supporting claim-bound certificate is
`lean/certificates/C_PROFILE_EXTENSION-f1e23f9854f77826.json`.
All four reported theorem axiom sets contain only `propext`,
`Classical.choice`, and `Quot.sound`. The ledger derives `closed_kernel`
for `C_PROFILE_EXTENSION`, with no active external assumptions. The final
`verify.py --require-lean` replay also passed, checking the arithmetic,
source assembly, source/fidelity hashes, the supporting ledger certificate,
and those axiom sets.

Both official checks passed at
`campaigns/9000132`:
`math_state check` exit zero and `proof_graph_check check` exit zero.
Kernel verification does not establish that the formal statement faithfully
encodes every natural-language assertion or that the improvement is novel
in the literature. Host independent Reviewer replay, statement-fidelity
approval, and the publication-level originality assessment remain pending.

## Adversarial finite replay

The verifier also checks a genuinely small instance of the *literal*
construction, independently of the large numerical seed. At
\(d=2,M=3,r=2,L=4,k=19\), use the cyclic regular tournament and the explicit
labels \(a(i,j)=i\bmod2\). All 969 subsets of size 16 are checked against
the forbidden-label condition. All 4096 initial 12-bit inputs and their
49,152 directed single-bit transitions are exhausted; the maximum profiles
are \((3,12,0,0)\).

At the next level, the script tests every one of the 456 original-coordinate
flips at 63 specified inputs, including accepting rows, single target
failures, single gate failures, and deterministic mixed inputs. The observed
profile maxima are \((11,26,1,24)\), below the exact transfer bounds
\((60,51,48,24)\). In particular the joint-one bound is attained in this
test. The parent-input test is finite and nonexhaustive; it is a
counterexample-hunting checkpoint, not a substitute for the universal proof.
No false literal manuscript assertion was found in this work, so there is
no new `F_` refutation claim to register.

## Reproduction

With Python 3 and SymPy installed, run

```bash
$WORKSPACE/argus-live-update/.venv/bin/python \
  research/quantitative_profile/verify.py --require-lean
```

This replays exact integer and rational arithmetic, the symbolic transfer
identities and induction obligations, the small Boolean experiment, the
Jacobian output, the complete previous-family comparison, and the current
formal source/certificate binding. It does not silently regenerate or
overwrite the stored certificate. `--write-certificate` explicitly regenerates
the deterministic arithmetic certificate; `--write-seed-trace` regenerates
the Lean arithmetic trace.

`assemble.py` reconstructs `Main.lean` from the archived dependency sources
and the new proof sources without network access. The original source
archive can be obtained with `assemble.py --fetch`; it is pinned to the
recorded public revision and retains its license. `Compatibility.lean`
proves four renamed conditional-simplification lemmas needed when compiling
the otherwise unchanged upstream proofs on Lean 4.31.0.

The official recording command for an independent fresh compiler replay is

```bash
$WORKSPACE/argus-live-update/.venv/bin/python \
  -m argus_skill.verticals.math.lean_evidence verify \
  research/quantitative_profile/Main.lean \
  --project-root . --claim C_PROFILE_EXTENSION \
  --statement-fidelity research/quantitative_profile/STATEMENT_FIDELITY.md \
  --artifact-dir research/quantitative_profile/lean
```

The installed CLI takes the source as a positional argument, not `--source`.
The explicit artifact directory keeps all generated sources, compiler
records, and archived certificates inside this mission's owned directory.
No project lakefile or unchecked OAI binary is needed.
