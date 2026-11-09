# The characteristic-p intersection proposition

## Statement and scope

Let \(p\) be prime, let \(F\) have characteristic \(p\), and set \(C=F^p\).
Assume \([F:C]<\infty\), and let \(X,Y\ne0\) satisfy
\([C(X,Y):C]=p^2\). Let \(U\in C(X)^\times\) and
\(V\in C(Y)^\times\). Neither is a \(C^\times\)-multiple of a power
of its respective variable. Suppose there is a nonzero
\[
 Z\in X C(Y/X)^\times\cap U C(V/U)^\times .
\]
Then a single integer \(n\), \(1\le n<p\), satisfies
\[
 U^n=a+bX^n,\qquad V^n=c+dY^n
\]
with \(a,b,c,d\in C^\times\). For each of \(U\) and \(V\)
separately, any inclusion of this shape with exponent in \([1,p-1]\)
forces that same exponent.

This is the literal content of Proposition `prop:intersection` in
`03-intersection.tex`. It does not assert the reconstruction theorem,
the propagation of exponents between different pairs, or novelty of the
underlying differential method.

## Elementary universal proof

Work in \(E=C(X,Y)\). Its \(p^2\) elements \(X^iY^j\),
\(0\le i,j<p\), form a \(C\)-basis: they span since \(X^p,Y^p\in C\),
and the degree assumption gives independence. Define \(C\)-linear maps
\[
 D_X(X^iY^j)=iX^iY^j,\qquad D_Y(X^iY^j)=jX^iY^j.
\]
Reducing an exponent modulo \(p\) changes a monomial by a factor
in \(C^\times\) and changes its weight by zero in characteristic \(p\).
Consequently these maps obey the product rule and commute.
Their kernels on \(C(X)\) and \(C(Y)\), respectively, are \(C\).
Their nonzero eigenvectors on those subfields are scalar monomials,
because the \(p\) diagonal weights are distinct. The same two-variable
basis gives \(C(X)\cap C(Y)=C\).

Write \(d_X=D_XU\) and \(d_Y=D_YV\). Neither vanishes, since a
zero derivative would make \(U\) or \(V\) constant. Put
\[
 B_X=U/d_X,\quad B_Y=V/d_Y,\quad A_X=B_X-1,\quad A_Y=B_Y-1.
\]
In fact \(A_X\in C(X)\setminus C\) and
\(A_Y\in C(Y)\setminus C\): a constant \(B_X\), necessarily nonzero,
would make \(U\) an eigenvector and hence a scalar monomial.
Thus all four displayed \(A\)'s and \(B\)'s are nonzero.

Set \(\delta=D_X+D_Y\) and
\(\delta'=B_XD_X+B_YD_Y\). Both kill \(C\).
The first kills \(Y/X\) and sends \(X\) to \(X\);
the second kills \(V/U\) and sends \(U\) to \(U\).
Each therefore acts as the identity on the corresponding expression
for \(Z\). In particular
\[
 \delta Z=Z=\delta'Z.
\]
For \(q_X=D_XZ/Z\), \(q_Y=D_YZ/Z\), this says
\[
 q_X+q_Y=1,\qquad A_Xq_X+A_Yq_Y=0.
\]
Neither \(q\) vanishes: if one did, the other would be \(1\),
forcing the corresponding nonzero \(A\) to be zero.
Commutation with \(\delta\) shows \(\delta q_X=\delta q_Y=0\).
It follows from \(A_X/A_Y=-q_Y/q_X\) that
\[
 \frac{D_X A_X}{A_X}=\frac{D_Y A_Y}{A_Y}.
\]
This common element belongs to \(C(X)\cap C(Y)=C\). Diagonalizing
the two one-variable Euler operators gives
\[
 A_X=c_X X^m,\qquad A_Y=c_Y Y^m
\]
for the same integer \(m\), \(1\le m<p\), and
\(c_X,c_Y\in C^\times\). The common weight cannot be zero since
neither \(A\) is constant.

Let \(n=p-m\). In the field, the scalars \(n\) and \(-m\) agree.
Moreover
\[
 X^n+c_XX^p=X^n(1+c_XX^m)=X^nB_X\ne0.
\]
The two logarithmic derivatives are therefore defined and equal:
\[
 \frac{D_X(U^n)}{U^n}
   =\frac{n}{1+c_XX^m}
   =\frac{D_X(X^n+c_XX^p)}{X^n+c_XX^p}.
\]
Thus \(U^n/(X^n+c_XX^p)\) is a nonzero member of the
one-variable kernel, hence a member \(t_X\) of \(C^\times\).
The coefficients of \(U^n=t_Xc_XX^p+t_XX^n\) are nonzero.
The identical calculation for \(Y\) proves the second inclusion with
the same \(n\). This argument includes \(p=2\), where \(m=n=1\);
it never divides by \(2\) or assumes odd characteristic.

For uniqueness, suppose \(U^r=h+jX^r\) with \(1\le r<p\).
If \(h=0\) or \(j=0\), the class \(r[U]\) lies in the
one-dimensional \(\mathbb F_p\)-span of \([X]\).
Multiplication by nonzero \(r\) is invertible on the exponent-\(p\)
group \(F^\times/C^\times\), so this contradicts the hypothesis.
Both coefficients are nonzero. Taking logarithmic derivatives and
cancelling the nonzero scalar \(r\) gives
\[
 A_X=\frac{h}{jX^r}
     =\frac{h}{jX^p}X^{p-r}.
\]
Independence of the one-variable monomials forces \(m=p-r\),
so \(r=n\). The argument for \(V\) is separate and identical.

## Dependency impact and prior work

The proof uses only exponent-one field algebra, finite-dimensional
linear algebra, and the product and quotient rules for derivations.
It does not use Bloch--Gabber--Kato, a reconstruction theorem, or
an uninspected external proposition. The manuscript attributes the
differential method to Cadoret--Pirutka, Sections 3.4--3.5; that
historical citation is not a premise of this proof and no novelty
claim is made here.

The local argument actually needs only a subfield \(C\subseteq F\)
with \(X^p,Y^p\in C\) and \([C(X,Y):C]=p^2\). All witnesses and
coefficients lie in \(C(X,Y)\), so finiteness of the ambient
extension is not used. This observation is a proved strengthening
of the range of applicability, not a claim that the strengthening
is new or independently publishable.

At the start of this mission the ledger contained only the open
family-wide audit claim and no mathematical certificate. No
manuscript assertion has been refuted by the argument above.
All downstream reconstruction obligations remain unverified.

## Universal machine certificate

`Main.lean` proves `CharPIntersection.prop_intersection` under the
literal hypotheses above. Its coefficient field is the range of
Frobenius, its p-independence hypothesis is the degree equality, and
its input is the actual intersection witness. In particular it does
not assume a monomial basis, commuting derivations, a common
eigenvalue, an exponent, or either affine-power conclusion.

The proof constructs the degree-\(p^2\) coordinate field and its basis
from the degree hypothesis. It then proves the Euler product rule
and joint eigenspace classification, derives the common weight, and
proves existence and uniqueness. For the common-weight calculation
the formal proof uses an equivalent denominator-free elimination:
differentiate
\[
 A_X D_X Z+A_Y D_Y Z=0
\]
by \(D_X+D_Y\), use commutation and \((D_X+D_Y)Z=Z\), and eliminate
the two witness derivatives. This yields
\[
 (A_Y D_X A_X-A_X D_Y A_Y)D_X Z=0.
\]
The hypotheses imply \(D_XZ\ne0\), so the logarithmic derivatives
are equal. This avoids treating a sign identity or an eigenvalue as
an assumption.

The official Argus `lean_evidence verify` run records
`exit_code=0`, `proof_holes=[]`, and a successful axiom audit in
`lean_check.json`. The final theorem's only axioms are
`propext`, `Classical.choice`, and `Quot.sound`. The claim-bound,
source-and-reading archive is
`certificates/V_CHARP_INTERSECTION-8ee0aa52ccd7bea2.json`.
`statement-fidelity.md` explains each translation; the tool also
retains its identical canonical copy `statement_fidelity.md`.
No external mathematical assumption is entered in this claim's
ledger, and the citation-check work list is empty.

The source-facing theorem retains finite \([F:F^p]\).
The separately proved `intersection_exponent` drops that ambient
finiteness and allows any embedded coefficient field containing all
ambient p-th powers. The still weaker local condition on just
\(X^p,Y^p\) discussed above is justified by the prose argument;
it is not claimed to be the exact statement of that generalized
Lean declaration.

The first official attempt was rejected before compilation because
its lexical proof-hole scanner interpreted the helper identifier
`Chart.constant` as the Lean command `constant`. Renaming the helper
to `Chart.scalar_of_zero` changed no mathematical statement or proof.
The successful certificate is bound to the renamed source, not to
that inconclusive attempt. The earlier dependent-induction
implementation of subfield membership also exhausted Lean's
heartbeat allowance; the final proof instead uses the existing
`IntermediateField.adjoin_map` law. Neither event is a mathematical
counterexample or a flaw in the manuscript.

## Exact replay and adversarial checks

Run from the campaign root:

```sh
$WORKSPACE/argus-live-update/.venv/bin/python research/char-p-intersection/verify.py
```

The script checks the official source and statement-reading bindings,
recompiles the universal theorem with Lean 4.31.0 in the recorded
Mathlib workspace, checks its axiom dependencies, and replays the
supplementary exact calculations. Its only Python dependency is
SymPy 1.14.0, listed in `requirements.txt`. To regenerate the
deterministic `exact_certificate.json`, use `--write-certificate`.
The original durable generation run finished with exit code zero;
its task and run handles are preserved in `replay-submission.json`,
and its completion is recorded in the public Engineer progress file.

The finite calculations use the genuine exponent-one field
\[
 C=\mathbb F_p(a,b),\qquad
 E=C[x,y]/(x^p-a,y^p-b),
\]
with algebraically independent \(a,b\), not a perfect finite field
in which p-independence would be impossible. They check all basis
products for \(p=2,3,5,7\), giving 6,246 exact Euler product-rule
checks. For every \(1\le n<p\) in those four characteristics, the
script constructs nonmonomial \(U,V\), an exact nonzero witness
and both of its subfield expressions, then checks the common weight,
both nonzero affine coefficients, and uniqueness from either input.
There are 13 such witness cases.

An adversarial negative control at \(p=3\), \(U=1+x+x^2\),
\(V=1+y\), has no affine exponent for \(U\). An exact rank-six
calculation proves that the two three-dimensional candidate
witness spaces have zero intersection for this pair. This is only
a bounded negative control, not a universal proof or a refutation.
The universal proof is the Lean theorem.

`jacobian-input.json` and `jacobian-output.json` preserve one
typed Argus-adapter computation of the \(p=2\) kernel of
\(D_X+D_Y\). They include the operation id, exact payload, server
version 0.14.0, protocol 2025-11-25, and typed output. It returned
normally, with no adapter error or timeout. The kernel is
\(\langle1,xy\rangle\); this is not confused with the joint kernel
of \(D_X,D_Y\), which consists of constants. The script rechecks
the stored result. This computation is supplementary only.

## Review and remaining frontier

The improvement over the initial open ledger is a kernel-checked
universal proof of the complete proposition, rather than a bounded
small-prime search or an assumed integration exponent. This is an
independent formal verification of a proposition already stated and
proved in the manuscript. Novelty and publishability are not
self-certified.

The host-invoked independent Reviewer must still read the statement
translation against the manuscript and replay the certificate.
No independent-review judgement has been filed by the Engineer.
The ledger and proof graph retain symbol detection, global line
recovery and exponent propagation, projective lifting, perfect-core
recovery, and the full reconstruction theorem as open obligations.
This mission does not complete the manuscript-family campaign.
