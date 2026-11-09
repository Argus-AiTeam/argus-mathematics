# An explicit binary-rank Fourier coefficient

## Result and scope

Under **every literal hypothesis** of Lemma `lem:coefficient` in the staged
`coefficient.tex`, put

\[
 N=m^2,\quad D=d(d+1),\quad L=d(d+1)^2,\quad
 W_N=\frac{(3/2)^N-(1/2)^N}{2},\qquad
 \epsilon=\max_{\operatorname{rank}_{\mathbb F_2}P\ge2}
                    |\widehat\Psi(P)|.
\]

Then

\[
 \boxed{\quad
 \epsilon W_N\ \ge\
 \frac{AB/2-4D(A+B)}{5DL}-8
 \ \ge\ 640d+504 .\quad}                                      \tag{1}
\]

In particular there is an index of binary rank at least two with

\[
 |\widehat\Psi(P)|\ge
 \frac{2^{N+1}(640d+504)}{3^N-1}
 > (2/3)^N > 2^{-N}.                                         \tag{2}
\]

This is a universal quantitative strengthening of the manuscript's
existential, compactness-based \(c_*(m,a,b)>0\). The rightmost explicit bound
depends on \(m\) alone; the first bound in (1) retains the dependence on
\(a,b\). We do not pick a small, infeasible parameter set or assume
nonemptiness to obtain the conclusion. The argument applies to every
admissible triple, without a compactness step.

This is a proof of the scalar theorem, with exact algebraic replay and a
formalized finite core. It is not a counterexample, a verification of the full
Banach-space theorem, or a claim that finite experiments prove the universal
statement. Independent Reviewer acceptance and an assessment of publishable
novelty/significance remain outstanding. No literal false assertion in the
staged scalar proof has been identified.

## 1. Fourier projections survive rank truncation exactly

For a binary matrix \(P\), write \(r(P)\) and \(c(P)\) for its row and column
parity vectors. Row sign multiplication gives

\[
 (\sigma S)^P=\sigma^{r(P)}S^P .
\]

Uniform character orthogonality therefore gives, coefficient by coefficient,

\[
 \widehat{\mathbb E_\sigma \sigma_i\Psi(\sigma S)}(P)
  =\mathbf 1_{\{r(P)=e_i\}}\widehat\Psi(P).                    \tag{3}
\]

The right side of the prescribed projection identity,
\(a g(S_{i,:})\), is supported only on indices lying in row \(i\).
Every such matrix has rank at most one. Hence a rank-at-least-two \(P\)
with \(r(P)=e_i\) has \(\widehat\Psi(P)=0\). The identical argument for
columns proves the analogous assertion with \(c(P)=e_j\).
This does **not** assert that high-rank matrices cannot have a unit parity
vector; they can. Their coefficients are forced to vanish by the hypotheses.

Let \(Q\) retain precisely the Fourier coefficients of \(\Psi\) of rank at
most one, and let \(R=\Psi-Q\). Equation (3) shows that both prescribed
projections of \(R\) vanish identically. Thus \(Q\) satisfies exactly the
original projections with the original \(f,g,a,b\). This is an exact
statement, not an approximation or an assumption of the desired conclusion.
No sup-norm contraction of this rank projection is asserted.

Oddness under simultaneous negation of all entries says
\(\widehat\Psi(P)=0\) when \(|P|\) is even. A nonzero binary rank-one matrix
has the unique form \(p h^t\) with \(p,h\ne0\): choose a nonzero column \(p\);
every column is its binary scalar multiple. Uniqueness follows by evaluating
at a pivot with \(p_i=h_j=1\). Its weight is \(|p||h|\). Thus the retained
indices are exactly odd-by-odd rectangles, and their row and column parities
are \(p,h\), respectively.

Define, for odd \(k,l\),

\[
 C_{kl}=\sum_{|p|=k,\ |h|=l}\widehat\Psi(ph^t).
\]

Comparing the surviving projection coefficients gives

\[
 C_{1l}=A\sum_{|h|=l}\widehat g(h),\qquad
 C_{k1}=B\sum_{|p|=k}\widehat f(p),\qquad C_{11}=AB.           \tag{4}
\]

## 2. Damping controls the discarded part quantitatively

Fix \(s,u\in[-1,1]\). Choose all signs \(D_i,E_j,Z_{ij}\) independently,
with means \(s,u,1/2\), respectively, and set \(S_{ij}=D_iE_jZ_{ij}\).
For an arbitrary binary matrix, independence gives

\[
 \mathbb E S^P=s^{|r(P)|}u^{|c(P)|}2^{-|P|}.                 \tag{5}
\]

For an odd rectangle this is \(s^{|p|}u^{|h|}2^{-|p||h|}\), so

\[
 H(s,u):=\mathbb E Q(S)=
       \sum_{k,l\ {\rm odd}}C_{kl}s^ku^l2^{-kl}.
\]

Since \(R\) is odd and all its coefficients have magnitude at most
\(\epsilon\), (5) gives

\[
 |\mathbb E R(S)|\le
 \epsilon\sum_{\substack{P:\ |P|\ {\rm odd}\\ \operatorname{rank}P\ge2}}
               2^{-|P|}
 \le\epsilon W_N.                                          \tag{6}
\]

Here the binomial theorem gives

\[
 \sum_{|P|\ {\rm odd}}t^{|P|}
   =\frac{(1+t)^N-(1-t)^N}{2};
\]

put \(t=1/2\). Equivalently, on adding one binary coordinate the even and odd
weighted masses obey \(E_{n+1}=E_n+tO_n\) and
\(O_{n+1}=O_n+tE_n\), starting with \((E_0,O_0)=(1,0)\).
The closed formula follows by adding and subtracting these recurrences.
Consequently

\[
 \|H\|_{[-1,1]^2}\le4+\epsilon W_N.                          \tag{7}
\]

The much larger undamped estimate
\(\|R\|_\infty\le2^N\epsilon\) would also yield the proposed
\(2^{-N}\) scale. Damping is what improves the exponential base to \(2/3\).
We do not replace the required binary rank by rational matrix rank.

## 3. Rectangle tail and exact derivatives

Parseval for the **original** function, not an unjustified sup-norm bound on
\(Q\), gives
\(\sum_P|\widehat\Psi(P)|^2=\mathbb E|\Psi|^2\le16\).
Uniqueness of rectangles and Cauchy--Schwarz imply

\[
 |C_{kl}|\le4\sqrt{\binom mk\binom ml}\le4m^{(k+l)/2}.        \tag{8}
\]

Let \(H_0\) delete from \(H\) the terms with \(k>d\) and \(l>d\).
Since \(d\ge2\log_2m\), these terms satisfy
\((k+l)\log_2m\le kl\). Also \(d\ge4\) gives \(k,l\ge5\), and hence
\(kl/2\ge k+l\). Thus the removed polynomial has norm at most

\[
 4\sum_{k,l>d}m^{(k+l)/2}2^{-kl}
 \le4\sum_{k,l>d}2^{-kl/2}
 \le4\sum_{k,l>d}2^{-k-l}\le4.                              \tag{9}
\]

The sums may be enlarged to all positive integers beyond \(d\); the last
double geometric sum is \(2^{-2d}\le1\).
Together with (7), this gives

\[
 K:=\|H_0\|_{[-1,1]^2}\le8+\epsilon W_N.                    \tag{10}
\]

The deletion does not change any \(k=1\) or \(l=1\) term. Equation (4)
therefore gives the exact identities

\[
 \partial_sH_0(0,u)=A\sum_h\widehat g(h)(u/2)^{|h|},\quad
 \partial_uH_0(s,0)=B\sum_p\widehat f(p)(s/2)^{|p|},\quad
 \partial_s\partial_uH_0(0,0)=AB/2.                         \tag{11}
\]

Evaluation on independent signs of common mean \(u/2\) or \(s/2\) bounds
the first two displayed functions by \(4A,4B\), respectively.

## 4. Chebyshev separation, with all constants

For a polynomial \(q\) on \([-1,1]\), writing
\(q(x)=\sum_j\alpha_j T_j(x)\) gives

\[
 \alpha_0=\frac1\pi\int_0^\pi q(\cos\theta)\,d\theta,\quad
 \alpha_j=\frac2\pi\int_0^\pi q(\cos\theta)\cos(j\theta)\,d\theta
 \quad(j\ge1).
\]

These formulas follow by finite cosine orthogonality, and show
\(|\alpha_j|\le2\|q\|_\infty\) for every \(j\).
Since \(T_j(\cos\theta)=\cos(j\theta)\),
\(T'_j(0)=j\sin(j\pi/2)\), so \(|T'_j(0)|\le j\).
In particular every \(q\) of degree at most \(d\) satisfies

\[
 |q'(0)|\le2\|q\|_\infty\sum_{j=1}^d j
          =D\|q\|_\infty.                                 \tag{12}
\]

Apply the \(s\)-Chebyshev projection retaining \(j\le d\) to \(H_0\);
call the result \(H_1\) and put \(H_2=H_0-H_1\).
It follows from the coefficient bound and \(|T_j|\le1\) that

\[
 \|H_1\|\le2K(d+1),\qquad \|H_2\|\le3K(d+1).
\]

Moreover \(\deg_sH_1\le d\) and \(\deg_uH_2\le d\).
Indeed a monomial of \(H_0\) with \(s\)-degree greater than \(d\) has
\(u\)-degree at most \(d\); projection in \(s\) cannot increase its
\(u\)-degree. A monomial with \(s\)-degree at most \(d\) is annihilated
by \(I-\Pi_{\le d}\), because the Chebyshev polynomials through degree
\(d\) are a basis of that polynomial space. This supplies both degree
claims without estimating a monomial projection operator.

Using (12) first in the low-degree directions and (11) gives

\[
 \|\partial_sH_2(0,\cdot)\|\le4A+2KL,\qquad
 \|\partial_uH_1(\cdot,0)\|\le4B+3KL.
\]

The displayed polynomials have degree at most \(d\) in \(u\) and \(s\),
respectively. Apply (12) to each, and add their mixed derivatives.
Equation (11) now gives

\[
             AB/2\le4D(A+B)+5KDL.                          \tag{13}
\]

This argument proves the needed estimates directly; no uninspected
Markov/Bernstein/Chebyshev literature theorem is an external assumption.

## 5. A universal positive margin

Since \(d\ge4\), \(D,L>0\). Combining (10) and (13) proves the first
inequality in (1). To prove the second without an asymptotic or numerical
argument, put \(x=A-80L\ge0\), \(y=B-80L\ge0\). The exact identity

\[
 \begin{split}
 AB/2-4D(A+B)-5DL(640d+512)
     &=(40L-4D)(x+y)+xy/2\\
     &\ge0
 \end{split}                                               \tag{14}
\]

uses only \(L=D(d+1)\); the last inequality holds because
\(40L-4D=4D(10d+9)>0\).
Divide by \(5DL\), subtract \(8\), and obtain (1).
Finally \(W_N=(3^N-1)/2^{N+1}>0\), since \(N=m^2>0\).
This proves (2), and completes the contradiction to every putative
admissible triple with all high-rank coefficients below the claimed bound.

## Exact and formal evidence

`verify.py` replays exact finite sign/Fourier, rectangle, noise, and
Chebyshev-basis identities, checks the universal polynomial identities and
positive-coefficient margins, verifies the source/reading freshness of the
recorded Lean result and its current claim attachment, and compares its
deterministic output with `exact_certificate.json`. The finite checks are
deliberately labelled finite. The universal proof is the argument above,
not an extrapolation from them.

`Main.lean` formalizes arbitrary-size binary rectangle parity and uniqueness,
rank bounds for one-row/one-column support, exact preservation of both
coefficient-level projection identities under rank truncation, the odd-mass
recurrence, the tail exponent inequalities, and the final quantitative margin
and inverse-mass inference. `statement_fidelity.md` specifies exactly which
parts are encoded and which Fourier/analytic translations remain prose.
The prescribed evidence command completed with Lean **4.31.0**,
`exit_code=0`, `audit_exit_code=0`, and `proof_holes=[]`. Its archived
claim-bound certificate is
`lean_evidence/certificates/L_COEFF_FORMAL_CORE-87d86818e769ce5a.json`.
Only `L_COEFF_FORMAL_CORE`, not the entire scalar theorem, has earned
`closed_kernel`; statement fidelity still requires independent reading.

From the campaign root, rerun the deterministic certificate with

```bash
$WORKSPACE/argus-live-update/.venv/bin/python research/coefficient_certificate/verify.py
```

An independent actual compiler replay uses

```bash
$WORKSPACE/argus-live-update/.venv/bin/python -m argus_skill.verticals.math.lean_evidence verify research/coefficient_certificate/Main.lean --statement-fidelity research/coefficient_certificate/statement_fidelity.md --claim L_COEFF_FORMAL_CORE --project-root . --artifact-dir research/coefficient_certificate/lean_evidence --timeout 120
```

The script checks the existing compiler record but does not pretend to run
Lean itself. A compiler replay changes the ledger, so the two official
campaign-local structural checks must follow it.

The Jacobian adapter's archived contracts do not supply a theorem about
real-valued matrix-cube Fourier coefficients separated by **binary** rank.
`matrix.rank.compute` is over \(\mathbb Q\), so is inapplicable to that
postcondition. `boolean.fourier.walsh_transform.compute` accepts at most
4096 Boolean truth-table values and returns an unnormalized Boolean-sign
spectrum, not the required universal real-valued theorem. It was used only
for one compatible bounded normalization check: the 2-by-2 character with
index \(P=(1,1;0,1)\) has unnormalized spectrum 16 at index 11 and zero
elsewhere. The payload, contract, server/protocol identifiers, and typed
successful result are retained in `jacobian/`. This check is not an
admissible counterexample and is not support for a universal rank bound.

## Literature boundary and unresolved campaign obligations

The version-pinned primary GMR source and short excerpts are in `sources/`.
In arXiv:2305.13270v2, Theorem 1.3 assumes that \((\mathcal E,F)\) is a
Grothendieck pair and concludes finite Rademacher cotype of \(F,F^*\).
Conjecture 1.5 assumes infinite dimension and **BAP**, not merely AP;
it proposes, rather than proves, K-convexity from the two finite-cotype
conditions. These are scope facts, not hypotheses of the scalar proof.

The public comparator at openai/math revision
`4eaee87548250b2682affda7d05d947c05554bae`,
`lean/ComparatorChallenges/Cotype.lean`, ends
`OAI.Cotype.mainTarget_proved` with `sorry`.
It is not a completed formalization and is not a mathematical refutation.
Pis81 Numdam metadata was accessible and its PDF was downloadable, but its
mathematical statements were not independently inspected. We assume none of
them here.

The two GMR propositions were independently retrieved and read by the
`scope-sources` worker; their source archive and its exact quotations are
preserved. Their formal `citation_check attribute` records are still
outstanding. That command archives into `research/literature/`, outside
this mission's authoritative writable paths, so the Engineer has not
silently written there or substituted a judge opinion for a literature
check. Neither proposition is a dependency of the scalar theorem.

The manuscript also correctly rejects inheriting cotype from \(X^*\) to the
quotient \(E^*\); this already-rejected shortcut is not a false manuscript
assertion. The moment-lift lemma, frame construction, tagged extraction,
uniform-decay iteration, compact-domain lemma, AP transfer, and classical
Banach-space implications remain explicit open obligations in the campaign
graph. Equation (2) makes the scalar input to the growth lemma computable
if those other arguments are subsequently verified; it does not certify
them by implication.
