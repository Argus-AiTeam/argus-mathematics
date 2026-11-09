# Sharp conductor-valuation comparison

## Result and scope

**Theorem 1 (comparison).** Let \(p\) be an odd prime, let \(A\) be a
characteristic-zero DVR with maximal ideal \(pA\), and let \(1\le r\le e\).
In particular \(A\) may be precisely the unramified cyclotomic localization
in the manuscript's `local.tex`, Lemma `lem:local-ring`. Suppose
\[
 F,K\in A[C_{p^e}],\qquad FK=p^s b,\quad b\in A^\times,\quad
 0\le s\le e-r+1.
\]
For any primitive \(p^r\)-th root \(\zeta\), both
\[
 F(\zeta)/F(1),\qquad K(\zeta)/K(1)
\]
belong to \(A[\zeta]^\times\) and have residue one.

**Theorem 2 (exact optimality mechanism).** Put \(t=e-r+1\) and
\(m=p^{r-1}\). For every integer \(a\) with \(p\nmid a(a-1)\), multiplication
by
\[
 F=p-a\Phi_{p^r}(X)
\]
on \(R=\mathbb Z_{(p)}[C_{p^e}]\) has Smith factors
\[
 \begin{array}{c|c}
 \text{factor}&\text{multiplicity}\\ \hline
 1&p^e-(p-1)m\\
 p^t&(p-2)m\\
 p^{t+1}&m.
 \end{array}
\]
More precisely, its cokernel is
\[
 \left(A/(p^{t+1})\oplus(A/(p^t))^{p-2}\right)^m,
 \qquad A=\mathbb Z_{(p)}.
\]
In the first block, the class of the scalar \(1\) has annihilator
\((p^{t+1})\), not merely an annihilator bounded by this ideal.
Consequently the least \(s\) for which \(FK=p^s b\) with \(K\in R\) and
\(b\in A^\times\) is exactly \(t+1=e-r+2\).
The unique \(K=p^{t+1}F^{-1}\) in \(\mathbb Q[C_{p^e}]\) belongs to \(R\).
Its two comparison ratios are
\[
 F(\zeta)/F(1)=1/(1-a),\qquad K(\zeta)/K(1)=1-a.
\]
Both are units, and neither has residue one.

Thus Theorem 1's universal threshold is sharp **for every conductor and
ambient exponent**, not just for isolated orders. This does not assert that
every factorization above the threshold fails comparison.
The same cokernel proof works over every DVR \(A\) in Theorem 1 whenever
\(a,a-1\in A^\times\).

This is an extension, not a refutation, of the staged manuscript.
No false literal manuscript assertion has been established here, so no
invented `F_<LABEL>` refutation is recorded. The accepted `C_ODD_SQUARE`
certificate and its proof dependencies are unchanged.

## Proof of Theorem 1

Write \(B=A[\zeta]\), with maximal ideal \((\zeta-1)\). The elementary
cyclotomic local-ring facts, also proved in the manuscript and in the
accepted formal dependencies, give that \(B\) is a domain and that
evaluation at \(\zeta\) and augmentation have the same residue.
Every evaluation product is the nonzero scalar \(p^s b\), so every
denominator and numerator in the statement is nonzero.

First prove the assertion at the maximal allowed scalar exponent
\(s=e-r+1\), by induction on \(d=e-r\). For \(d=0\) the scalar is
\(pb\). The two integral augmentation valuations sum to one, so one
augmentation is a unit. Its evaluation is a unit with the same residue;
their ratio is therefore a residue-one unit. The product of the two ratios
is exactly one, giving the other ratio too. This argument works for an
order-\(p^r\) root; its conductor need not be \(p\).

For \(d>0\), \(s=d+1\ge2\). Evaluate at a primitive \(p^e\)-th root
\(\xi\), in the corresponding ramified DVR, with valuation normalized by
\(v(p)=1\). The two nonnegative valuations sum to \(s\), so one is at
least one. Suppose it is \(F\)'s; the other case is symmetric.
Divide a polynomial representative by the monic \(\Phi_{p^e}\).
Its remainder has degree less than \((p-1)p^{e-1}\).
Because the standard power basis is free over \(A\), the fact that its
value at \(\xi\) lies in \(pA[\xi]\) says that **each** remainder
coefficient lies in \(pA\). The projection
\[
 q:A[C_{p^e}]\longrightarrow A[C_{p^{e-1}}]
\]
sends \(\Phi_{p^e}\) to \(p\). Hence \(q(F)=pF'\) for an integral
\(F'\), and \(F'q(K)=p^{s-1}b\). Scalar cancellation is coefficientwise
in a free \(A\)-module; it does not presume that a group ring is a domain.
Since \(e-1\ge r\), evaluation at \(\zeta\) and at one factor through
\(q\). Dividing one factor by \(p\) changes neither ratio. The induction
applies, and the factor chosen at the next step may be different.

For any smaller \(s\), multiply \(K\) by \(p^{e-r+1-s}\) and apply the
maximal-exponent result. The comparison for this scalar multiple descends
to \(K\) by cancellation of a nonzero scalar in \(B\). This includes
\(s=0\); no unit or zero-valuation endpoint is omitted.

The proof uses only primality, so its Lean theorem also covers \(p=2\).
The stated odd-prime scope is the requested one.

## Proof of Theorem 2

All the following calculations take place over \(A=\mathbb Z_{(p)}\).
They remain valid over the general coefficient DVR when \(a,a-1\)
are units. Set
\[
 N=p^t,\quad d_0=p-1,\quad Y=X^m,\quad
 f(Y)=1+Y+\cdots+Y^{p-1},\quad \lambda=a^{-1}.
\]
The monomials \(X^iY^j\), \(0\le i<m,\ 0\le j<N\), are exactly the
standard basis of \(R\). Multiplication by \(F\), which is a polynomial
in \(Y\), is thus a direct sum of \(m\) identical \(N\)-dimensional
blocks. This is a genuine permutation of an integral basis, not a
Chinese-remainder decomposition over a fraction field.

### A small free quotient

For one block, quotienting by \(F\) gives
\[
 A[Y]/(Y^N-1,p-af(Y))
   \simeq T/(Y^N-1),\qquad
 T=A[Z]/(h(Z)),\quad Y=1+Z,
\]
where
\[
 h(Z)=f(1+Z)-p\lambda
     =Z^{d_0}+p c_0+p\sum_{i=1}^{d_0-1}c_iZ^i,
 \quad c_0=1-\lambda\in A^\times,\quad
 c_i=\binom p{i+1}/p.
\]
These coefficients are integral: for \(1\le j<p\),
\(p\mid\binom pj\), since \(p\) divides \(p!\) and does not divide
\(j!(p-j)!\). The identity
\(f(1+Z)=\sum_{i=0}^{p-1}\binom p{i+1}Z^i\) follows by multiplying
by \(Z\) and expanding \((1+Z)^p-1\).

As \(h\) is monic, \(T\) is free over \(A\) on
\(1,Z,\ldots,Z^{d_0-1}\). Its reduction is \(k[Z]/(Z^{d_0})\),
where \(k=A/pA\). Every maximal ideal of the finite integral
\(A\)-algebra \(T\) contracts to the maximal ideal of \(A\):
indeed, a field integral over a subdomain forces that subdomain to
be a field, by applying an integral equation to inverses. Thus \(T\)
is local with maximal ideal \((p,Z)\).
The element
\[
 H=c_0+\sum_{i=1}^{d_0-1}c_i Z^i
\]
has nonzero residue and is a unit. The relation \(Z^{d_0}=-pH\)
therefore gives \(p=-Z^{d_0}H^{-1}\) and the maximal ideal is \((Z)\).
Eisenstein also proves that \(T\) is a DVR, but **irreducibility and
the DVR assertion are not needed** for the quotient calculation below.

### The all-parameter power identity

The elementary identity \((Y-1)f(Y)=Y^p-1\) gives in \(T\)
\[
 Y^p=1+p\lambda Z.
\]
For every \(t\ge1\) there is a unit \(V_t\in T^\times\), of residue
one, with the **exact** identity
\[
 Y^{p^t}-1=p^t\lambda ZV_t. \tag{1}
\]
Here \(V_1=1\). If (1) holds at \(t\), put \(W=\lambda ZV_t\).
The binomial expansion proves (1) at \(t+1\) with
\[
 V_{t+1}=V_t\left[
 1+\sum_{j=2}^{p-1}
       \frac{\binom pj}{p}\,p^{t(j-1)}W^{j-1}
       +p^{t(p-1)-1}W^{p-1}
 \right]. \tag{2}
\]
The exponent \(t(p-1)-1\) is nonnegative. Every nonconstant term in
the bracket belongs to \((Z)\), so the bracket has residue one and is
a unit. This proves the assertion for **all** \(t\); no limiting,
approximate, analytic, or bounded-computation inference is used.
As \(\lambda V_t\) is a unit, (1) identifies the ideals
\[
 (Y^N-1)T=p^tZT. \tag{3}
\]

### Exact cokernel, not just determinant or largest exponent

The \(A\)-module \(p^tZT\) is generated by
\[
 p^tZ,\ p^tZ^2,\ldots,p^tZ^{d_0}.
\]
Use \(Z^{d_0}=-p c_0-p\sum_{i=1}^{d_0-1}c_iZ^i\) for its last
generator. The other generators absorb every term in the sum.
Since \(c_0\) is a unit, this is **exactly** the coordinate submodule
\[
 A p^{t+1}\cdot1\ \oplus\
 \bigoplus_{i=1}^{d_0-1} A p^t Z^i. \tag{4}
\]
Both inclusions follow from the displayed relation; the reverse inclusion
uses the inverse of \(c_0\), which is why the hypothesis
\(p\nmid a-1\) cannot be discarded.
Independence of the monic power basis now gives
\[
 T/(p^t ZT)\simeq A/(p^{t+1})\oplus(A/(p^t))^{p-2}.
\]
There are \(m\) blocks. The cokernel has \((p-1)m\) nontrivial
invariant factors; the \(p^e\)-square multiplication matrix therefore
has the asserted remaining unit factors. Its determinant valuation is
\[
 m\big((p-1)t+1\big),
\]
consistent with, but stronger than, a resultant calculation.

In the \(i=0\) block the scalar \(1\) maps to the first power-basis
vector. Formula (4) makes its annihilator exactly \(p^{t+1}A\).
Thus no smaller scalar exponent can clear \(F^{-1}\), even after
allowing a unit \(b\). Conversely \(p^{t+1}\) belongs to the ideal
\((F)\) in the cyclic group ring, so an integral local \(K\) exists.
The finite cokernel makes multiplication by \(F\) injective over the
fraction field and hence \(K=p^{t+1}F^{-1}\) is unique there.

At a primitive \(p^r\)-th root, \(Y=\zeta^m\) is a primitive \(p\)-th
root, so \(f(Y)=0\), while \(f(1)=p\). Therefore
\[
 F(\zeta)=p,\quad F(1)=p(1-a).
\]
The scalar product identity gives the reciprocal ratio for \(K\).
In the residue field \((1-\bar a)^{-1}=1\) would force
\(\bar a=0\), excluded by hypothesis; the same argument applies to
\(1-\bar a\). This completes the uniform optimality proof.

For \(e=r=1,a=2\), \(f=J\) and \(J^2=pJ\), giving
\((p-2J)^2=p^2\). Thus the family includes the manuscript's precise
excluded example without mislabelling it as a refutation.
For \(r=1,s=e\), Theorem 1 is exactly its comparison lemma.

## Prior results and precise proposed advance

The strongest prior result in this campaign is not merely an unformalized
claim. OpenAI's released proof at commit
`adc7f1241b42e322a6451854ab7e4b4c146bf78a` includes
[`LocalComparison.local_character_comparison`](https://github.com/openai/math/blob/adc7f1241b42e322a6451854ab7e4b4c146bf78a/lean/OAI/LinearAlgebra/CirculantHadamard/LocalComparison.lean#L68-L85).
It treats order-\(p\) characters and scalar exponent equal to the cyclic
exponent. Its `products.tex`, `rem:exponent`, gives only the
\(e=r=1,a=2\) excluded family. The already accepted odd-square
certification is a replay of that released mathematics.
Even the weaker range \(r=1,s\le e\) follows by scalar padding, so
that part alone is not claimed as an advance.

A bounded primary-source literature search also found:

1. Noferini and Williams, *Smith forms of matrices in Companion Rings,
   with group theoretic and topological applications*,
   [arXiv:2408.08662v1](https://arxiv.org/html/2408.08662v1).
   Section 3.3, Theorem 3.11 (swap theorem) states, for monic
   polynomials \(f,g\) over an elementary divisor domain with
   \(\deg f\le\deg g\), that \(f(C_g)\) is equivalent to
   \(I_{\deg g-\deg f}\oplus g(C_f)\).
   Section 3.4, Theorem 3.13 (composition theorem), for monic
   \(g,h\), gives similarity of
   \((f\circ h)(C_{g\circ h})\) and
   \(f(C_g)\otimes I_{\deg h}\).
   These already subsume the block repetition and unit-factor reduction
   above. Those reductions alone are **not** claimed as original.
2. Noferini and Williams, *Matrices in companion rings, Smith forms,
   and the homology of 3-dimensional Brieskorn manifolds*,
   [arXiv:1908.07331v2](https://arxiv.org/html/1908.07331v2),
   Section 7, Theorem 7.4. For \(m\ge n\ge1\),
   \(\Phi_m(C_{\Phi_n})\) has Smith form zero when \(m=n\),
   \(pI_{\varphi(n)}\) when \(m=np^k,\ k\ge1\), and identity otherwise.
   This is an unshifted cyclotomic-pair theorem, not a statement of the
   deformed family \(p-a\Phi_{p^r}\). Its Section 6, Theorem 6.3
   requires coprime resultants for its direct-sum factorization;
   splitting all cyclotomic characters integrally without that
   condition is not used here.

These are scope comparisons, **not unproved dependencies** of the
proofs above. The proof gives the permutation, quotient and power
calculations directly. No external theorem is silently used as a
ledger assumption. The search inspected three primary texts with at
most five queries; one search failed. The inherited Wiki index did
not identify a relevant comparison or deformed-cyclotomic Smith page.

The precise proposed mathematical advance is the higher-character
range \(s+r\le e+1\), together with the two **exact exponents** and
the scalar-class annihilator for its uniform first-excluded family.
No exact match for that combined result was found in the bounded
retrieved corpus. This is not a proof of novelty. Independent Reviewer
must determine significance and novelty against these stronger
general Smith-form methods before marking `verified_new` or ending
the campaign.

## Evidence boundary and replay

`Main.lean` formalizes the actual all-parameter comparison theorem, not
an assumption that a comparison unit already exists. Its scalar
valuation and cyclic exponent are separate parameters. It constructs
the ramified cyclotomic quotients and discharges projection
divisibility using their DVRs. `comparison_denominators` certifies
the nonzero augmentation denominators.
The statement-fidelity document spells out the shifted natural-number
indexing. All previously accepted dependency files are imported
read-only, without changing their source or compiled artifacts.

The official comparison compiler and environment axiom audit both exited
zero, in **11,684 ms**, with `proof_holes=[]`. Its claim-bound archive is
`certificates/C_SHARP_COMPARISON-3b065712b1907f9f.json`.
Both printed transitive axiom closures are exactly
`{propext, Classical.choice, Quot.sound}`.

`CokernelCore.lean` independently formalizes the **all-dimension,
all-exponent** coordinate-image equality (4), including both inclusions
and the exact scalar-class annihilator. The hypotheses carry the actual
scaled companion-coordinate equations, not the desired divisibility
conclusion. Its source reading is `cokernel_fidelity.md`. Its official
compiler and axiom audit both exited zero, in **6,942 ms**, again with
no proof holes and only the three standard axioms:
`lattice/certificates/C_SHARP_LATTICE_CORE-175235729223f4a4.json`.
The evidence tool copies this source and fidelity text to the
standardized `lattice/Main.lean` and `lattice/statement_fidelity.md`
paths; the verifier checks both original and compiled snapshot texts.

The reduction of the original cyclic-ring cokernel to this companion
image, including recurrence (2), remains an ordinary all-parameter proof.
It must be read independently; finite Smith computations are not a
substitute for it. The exact script additionally replays
the binomial recurrence, companion-coordinate lattice, rational
factorization witnesses and the full Jacobian transformation
certificate on explicitly listed finite parameters.
It distinguishes those experiments from a compiler verdict.

The first exact run completed **27 base cases**, with base orders up to
**81**, and **81 actual cyclic-group-ring lifts**, up to order **2401**.
Every rational `K` is checked coefficientwise to lie in
\(\mathbb Z_{(p)}\), and \(F^{-1}\) has minimum coefficient
valuation exactly `-(t+1)`, so these instances verify the least exponent,
not merely a multiple that happens to work. All reported Smith factors
are checked, not just determinant valuations.

From the campaign root, the compiler command is

```bash
LEAN_PATH="$PWD/research/odd_square_audit/formal" \
  $WORKSPACE/argus-live-update/.venv/bin/python \
  -m argus_skill.verticals.math.lean_evidence verify \
  research/sharp_character_comparison/Main.lean \
  --statement-fidelity research/sharp_character_comparison/statement_fidelity.md \
  --artifact-dir research/sharp_character_comparison \
  --claim C_SHARP_COMPARISON --project-root .

$WORKSPACE/argus-live-update/.venv/bin/python \
  -m argus_skill.verticals.math.lean_evidence verify \
  research/sharp_character_comparison/CokernelCore.lean \
  --statement-fidelity research/sharp_character_comparison/cokernel_fidelity.md \
  --artifact-dir research/sharp_character_comparison/lattice \
  --claim C_SHARP_LATTICE_CORE --project-root .

$WORKSPACE/argus-live-update/.venv/bin/python \
  research/sharp_character_comparison/verify.py
```

`verify.py` replays the persisted exact certificate and checks the
claim-bound compiler archive. `--write-certificate` generates the
arithmetic certificate from fresh computations; it does not run Lean
or invent a compiler result. Independent review, including the
unformalized quotient reduction and novelty comparison, is the remaining
acceptance gate.
