# An all-degree verification of the invariant-intertwiner lemma

## Statement and scope

Let \(D\) be exactly as in the source: a complex \({\rm II}_1\) factor,
with normalized faithful normal trace \(\tau\), generated as a von Neumann
algebra by increasing unital full matrix algebras
\(D_j\simeq M_{m_j}(\mathbb C)\), where \(m_j\longrightarrow\infty\).
Put \(E=L^2(D,\tau)\), \(E_0=E\ominus\mathbb C1\), and
\(C_u\xi=u\xi u^*\). Empty tensor powers mean \(\mathbb C\).
Inner products are linear in the first variable.

**Verification theorem.** For every pair of finite nonnegative integers
\(k,l\), a bounded complex-linear map
\[
 Y:E\otimes E_0^{\otimes k}\longrightarrow E\otimes E_0^{\otimes l}
\]
which is left-\(D\)-linear and intertwines the simultaneous \(C_u\) actions
for every \(u\in\bigcup_j\mathcal U(D_j)\) is zero if \(k\ne l\).
If \(k=l\), it has the form
\[
 Y=I_E\otimes\sum_{\sigma\in S_k}a_\sigma U_\sigma,\qquad
 U_\sigma(\otimes_i x_i)=\otimes_j x_{\sigma^{-1}(j)}.
\]
Conversely, all these maps have the stated properties. The coefficients
are unique, including the empty-permutation coefficient when \(k=0\).
The word-structure assertion in the source follows, with full outputs
and arbitrary complex centered \(L^2\) letters, as proved below.

This is an ordinary all-degree proof, not an extrapolation from finite
experiments. Its algebraic support-elimination core is separately proved
in Lean 4.31.0 in `Main.lean`. The operator-algebra and tensor-continuity
arguments in this document are not Lean formalizations.

## 1. Two elementary analytic preparations

The union \(\mathcal A=\bigcup_jD_j\) is \(L^2\)-dense in \(E\).
Indeed, if \(\eta\in E\) is perpendicular to \(\mathcal A\), the functional
\(d\mapsto\langle d,\eta\rangle\) on \(D\) is normal. To see the normality
without assuming a bounded representative for \(\eta\), approximate it in
\(L^2\) by bounded \(b_n\in D\). The normal functionals
\(d\mapsto\tau(b_n^*d)\) converge in predual norm, since for \(\|d\|\le1\)
their errors are at most \(\|\eta-b_n\|_2\). The predual is norm closed.
Ultraweak density of \(\mathcal A\) now makes this functional zero on \(D\);
density of \(D\) in its \(L^2\) completion implies \(\eta=0\).
Centering is an orthogonal projection, so \(\mathcal A\cap E_0\) is dense
in \(E_0\).

There is an infinite orthonormal family of **bounded self-adjoint centered**
vectors in \(\mathcal A\). Construct it recursively in the real Hilbert
space of self-adjoint centered matrices. The real dimensions
\(m_j^2-1\) are unbounded, and
\(\tau(hh')\) is real for self-adjoint \(h,h'\). At each step select a
new vector perpendicular to the previous finite family and normalize it.
Thus no unproved assertion about infinite tensor contractions or about
a common infinite-dimensional matrix stage is involved.

Only the elementary foundations of tracial \(L^2\), normal functionals,
polar decomposition in \(D\), and Hilbert tensor products are used here.
In particular, no infinite-dimensional Schur--Weyl theorem is assumed.

## 2. The endpoint bound from left-linearity alone

Write \(n=k+l\), \(p=n+1\), \(v_0=a\), and use \(x_1,\ldots,x_k\)
and \(z_1,\ldots,z_l\) for the other slots. For unrestricted elements
of \(D\), let
\[
 F(a,x,z)=
 \left\langle Y(1\otimes\otimes_i x_i^\circ),
       a^*\otimes\otimes_j(z_j^*)^\circ\right\rangle,\qquad
 b^\circ=b-\tau(b)1.
\]
The two conjugations in each test variable make this a complex multilinear
form, not a sesquilinear invariant polynomial.

Fix the tails and let \(T:E\to E\) be the corresponding scalar slice.
It commutes with every left multiplier and
\[
 \|T\|\le\|Y\|\prod_i\|x_i^\circ\|_2
                    \prod_j\|(z_j^*)^\circ\|_2.
\]
For \(c,d\in D\),
\[
 \langle Td,c\rangle
 =\langle T1,d^*c\rangle=F(c^*d,x,z).                 \tag{1}
\]
For the polar decomposition \(a=u|a|\), choose
\(d=|a|^{1/2}\), \(c=|a|^{1/2}u^*\).
Then \(c^*d=a\) and
\(\|c\|_2\|d\|_2=\tau(|a|)=\|a\|_1\).
Cauchy--Schwarz in (1), and contractivity of centering, give
\[
 |F(a,x,z)|\le \|Y\|\|a\|_1
           \prod_i\|x_i\|_2\prod_j\|z_j\|_2.        \tag{2}
\]
This also verifies the source's endpoint substitution. It avoids needing
the tracial commutation theorem \(L_D'=R_D\), although that theorem would
give the same estimate.

## 3. Finite invariant forms, with an independent proof

For \(m\ge p\), a simultaneous-conjugation-invariant complex multilinear
form on \(M_m(\mathbb C)^p\) has a unique expansion in the forms
\[
 \Phi_\pi(v)=\prod_{(i_1\,\cdots\,i_r)\ {\rm cycle\ of}\ \pi}
        \tau_m(v_{i_1}\cdots v_{i_r}),\qquad \pi\in S_p.       \tag{3}
\]
Here is a proof of the required finite-dimensional input.
By the nondegenerate ordinary trace pairing on matrices, such a form is
\(\operatorname{Tr}(A(v_0\otimes\cdots\otimes v_{p-1}))\)
for a unique operator \(A\) on \((\mathbb C^m)^{\otimes p}\).
Invariance says that \(A\) commutes with \(u^{\otimes p}\) for all
unitaries \(u\).

For Hermitian \(H\), differentiating
\(e^{itH}\otimes\cdots\otimes e^{itH}\) at zero shows that \(A\)
commutes with \(\sum_s H_s\). Exponentiating gives commutation with
\((e^H)^{\otimes p}\). Polar decomposition of an invertible matrix then
gives commutation with \(g^{\otimes p}\) for every \(g\in GL_m(\mathbb C)\).

Apply \(A\) to \(w=e_1\otimes\cdots\otimes e_p\).
Commutation with all diagonal unitaries forces \(Aw\) into the weight
space whose basis is exactly the \(p!\) permutations of \(w\):
independently varying the \(m\) diagonal phases forces each of the
indices \(1,\ldots,p\) to occur once and every other index zero times.
There is therefore a unique linear combination \(B\) of tensor
permutations with \(Bw=Aw\). For any linearly independent ordered tuple
\((y_1,\ldots,y_p)\), choose \(g\in GL_m\) with \(ge_i=y_i\).
Both \(A\) and \(B\) commute with \(g^{\otimes p}\), so they agree on
\(y_1\otimes\cdots\otimes y_p\).
Independent tuples are dense: for any \(m\)-by-\(p\) column matrix \(X\),
adding \(\epsilon e_i\) to its \(i\)-th column makes its top \(p\)-by-\(p\)
minor a polynomial in \(\epsilon\) with leading coefficient one.
It is nonzero outside finitely many values of \(\epsilon\), which can
be avoided while \(\epsilon\to0\).
Continuity and spanning by elementary tensors give \(A=B\).
The same vector \(w\) proves independence of the permutations.

Their trace pairings are the products of ordinary cycle traces, up to
inverting the permutation convention. Replacing each ordinary trace by
the normalized trace multiplies the form indexed by \(\pi\) by the
nonzero factor \(m^{-c(\pi)}\), where \(c(\pi)\) counts its cycles.
This proves (3), including \(m=p\).

For completeness, the span assertion also holds for \(m<p\), although
such stages are not used in the infinite-dimensional argument. Let
\(V=\mathbb C^m\) and let \(\mathcal B\) be the permutation algebra on
\(V^{\otimes p}\). Under
\(\operatorname{End}(V^{\otimes p})=\operatorname{End}(V)^{\otimes p}\),
\(\mathcal B'\) is the space of tensors fixed by permuting the factors.
Symmetrized elementary tensors span this space, and the polarization identity
\[
 \sum_{\sigma\in S_p}T_{\sigma(1)}\otimes\cdots\otimes T_{\sigma(p)}
 =\sum_{S\subseteq\{1,\ldots,p\}}(-1)^{p-|S|}
                    \left(\sum_{i\in S}T_i\right)^{\otimes p}
\]
shows that it is spanned by \(T^{\otimes p}\).
Invertible \(T\)'s suffice by density and finite dimensionality.
The preceding differentiation argument then makes a unitary commutant
element belong to \(\mathcal B''=\mathcal B\).
Here the finite-dimensional double-commutant fact has an elementary proof:
for a unital star algebra \(\mathcal B\subseteq\operatorname{End}(W)\),
take a basis \(w_1,\ldots,w_d\) and the subspace
\(K=\{(Bw_1,\ldots,Bw_d):B\in\mathcal B\}\subset W^{\oplus d}\).
It reduces the diagonal \(\mathcal B\) action. Its orthogonal projection
therefore has block entries in \(\mathcal B'\). If \(A\in\mathcal B''\),
the diagonal \(A\) action commutes with that projection and carries
\((w_1,\ldots,w_d)\in K\) into \(K\). Thus one \(B\in\mathcal B\)
satisfies \(Aw_i=Bw_i\) for every \(i\), giving \(A=B\).
This proves the asserted span statement without an external duality premise.

Grinko--Ozols, Theorem 3.1, equation (22), is an independently inspected
standard source for the commutant statement. Its faithfulness sentence
uses the sufficient condition \(m>p\). The elementary argument above
proves the boundary \(m=p\) too; the audit does not infer a stronger
boundary solely from that citation.

## 4. Stability and coefficient isolation before centering

The form \(F\) is invariant under simultaneous conjugation by every
matrix-stage unitary: \(1\) is fixed, centering commutes with conjugation,
and the intertwining identity can be moved through the inner product.
For every sufficiently large stage it consequently has a unique
expansion
\[
 F|_{D_j^p}=\sum_{\pi\in S_p}\lambda_{\pi,j}\Phi_\pi.          \tag{4}
\]
This is on **unrestricted variables**. One must not replace its variables
by their centered parts before isolating the coefficients.

A unital inclusion \(M_m\hookrightarrow M_{mq}\) is conjugate to
\(a\mapsto a\otimes I_q\). The ordinary trace multiplies by \(q\),
but the normalized trace does not change. Equivalently, restriction of a
normalized trace to the unital smaller full matrix algebra is its unique
normalized trace. Thus every \(\Phi_\pi\) restricts to the same form.
For two nested stages with the smaller size at least \(p\), uniqueness
in (4) makes their coefficients identical. There is one fixed
\(\lambda_\pi\) for all stages beyond a single \(j_0\), not a
size-dependent coefficient being compared with its own limit.

Fix \(\pi\) and inject the \(p\) slots into \(m\) distinct matrix indices.
Writing the indices as the slot numbers, set
\(v_i=e_{i,\pi(i)}\). Multiplication of matrix units says
\[
 e_{ab}e_{cd}=\delta_{bc}e_{ad}.
\]
For a trace product in \(\Phi_\rho\) to be nonzero, every next slot
after \(i\) must start at \(\pi(i)\). Injectivity forces
\(\rho(i)=\pi(i)\) at every slot, including singleton cycles.
Conversely, following the \(\pi\) cycles closes each product into a
diagonal matrix unit. Hence
\[
 \Phi_\rho((e_{i,\pi(i)})_i)
       ={\bf1}_{\rho=\pi}\,m^{-c(\pi)}.                     \tag{5}
\]
All the units, including diagonal units, have
\(\|e_{ab}\|_1=m^{-1}\), \(\|e_{ab}\|_2=m^{-1/2}\).
Although a diagonal tail unit is not centered, this is legitimate:
centering occurs **inside** \(F\), and (2) bounds the unrestricted
tail norms from above. Equations (2) and (5) imply
\[
 |\lambda_\pi|\,m^{-c(\pi)}
       \le \|Y\|m^{-(p+1)/2}.                             \tag{6}
\]
If \(r=p+1-2c(\pi)>0\), squaring and multiplying by \(m^{p+1}\) gives
\[
 |\lambda_\pi|^2m^r\le\|Y\|^2.                           \tag{7}
\]
The sizes of the cofinal matrix stages are unbounded. Thus (7) forces
\(\lambda_\pi=0\). This only uses an unbounded sequence of sizes;
it does not assume that every integer occurs as a stage size.
`unbounded_power_zero` and `complex_coefficient_zero` formalize
precisely this positive-exponent inference.

## 5. Centering leaves only pairings and a scalar endpoint

Now, and only now, restrict every tail variable to trace zero.
Every term with a singleton tail cycle vanishes. For any remaining
permutation let its distinguished cycle have length \(r\ge1\) and its
other \(t=c(\pi)-1\) cycles have lengths \(b_1,\ldots,b_t\ge2\).
Then
\[
 r+\sum_{i=1}^t b_i=n+1.
\]
An uneliminated coefficient has \(2(t+1)\ge n+2\).
Together with \(r\ge1\), \(b_i\ge2\), this forces
\(r=1\) and every \(b_i=2\). This is
`cycle_lengths_forced`, with arbitrary \(n,t,r\), not a finite list
of degrees. In particular there are no terms for odd \(n\).

On centered tails the coefficient form is consequently
\[
 F(a,x,z)=\tau(a)\sum_{P}\lambda_P
                   \prod_{\{i,j\}\in P}\tau(v_i v_j),       \tag{8}
\]
where \(P\) ranges over perfect matchings of the tail slots.
Every sum here is finite. No individual same-side pairing has yet
been asserted to be a bounded operator on a Hilbert tensor product.

## 6. The infinite-dimensional support-elimination step

Fix a matching \(P\). Give each of its two-slot blocks its own disjoint
infinite pool \((h_{P,b})_{b\ge0}\) from the self-adjoint orthonormal
family in Section 1. Thus
\(\tau(h_{P,b}h_{Q,c})=\delta_{P,Q}\delta_{b,c}\).
Let \(s\) be the number of source--source blocks and \(t\) the number
of test--test blocks. Use a single fixed label in every cross block.
For each source--source block choose independently one of \(M\)
labels and sum the resulting source elementary tensors.
Call this vector \(\xi_M\). Independently do the same on the test
side, obtaining \(\eta_M\). Both first endpoints are \(1\).

In any summand of (8), every label occurs in exactly the two slots
of its prescribed block. A competing matching with nonzero contractions
must preserve this block label. A fixed-point-free partner of a slot
in a two-element block can only be the other slot of that block.
Therefore that competing matching is exactly \(P\).
This argument works for arbitrary many blocks, including none:
`pool_label_forces_partner`, `pool_assignment_injective`, and
`pairing_support_product` are its formal support certificate.

All \(M^s\) source summands are orthonormal, since changing a
source-block choice changes at least one tensor coordinate to an
orthogonal label. The corresponding \(M^t\) test summands are also
orthonormal. Every one of the \(M^{s+t}\) paired summands has contraction
value one for \(P\) and zero for every other matching. Thus the exact
identities are
\[
 \langle Y(1\otimes\xi_M),1\otimes\eta_M\rangle
       =\lambda_PM^{s+t},\qquad
 \|\xi_M\|^2=M^s,\quad \|\eta_M\|^2=M^t.                    \tag{9}
\]
Here the notation for \(\xi_M,\eta_M\) denotes the tail sums only.
Every finite collection of these bounded vectors lies in some common
matrix stage. That stage can be enlarged beyond \(j_0\); the stable
coefficients in (8) therefore apply to every \(M\).
There is no requirement that an entire infinite pool lie in one stage.

Boundedness of the original \(Y\), not boundedness of an individual
diagram, gives
\[
 |\lambda_P|M^{s+t}
       \le\|Y\|M^{(s+t)/2},\qquad
 |\lambda_P|^2 M^{s+t}\le\|Y\|^2\quad(M\ge1).               \tag{10}
\]
The second inequality is obtained by squaring and dividing by the
positive integer power \(M^{s+t}\). For \(s+t>0\),
`same_side_coefficient_zero` proves \(\lambda_P=0\).
No cancellation between several unbounded diagrams can evade this
argument, because the support construction isolated their coefficients
**before** the bound was applied.

Only cross matchings remain. Their partner involution is a bijection
between the source and test slots, so \(k=l\). This is the finite-set
equivalence explicitly encoded by `crossSideEquiv` and
`cross_pairing_cardinality`. It also handles an empty side: a nonempty
other side cannot be matched entirely across.

## 7. Identifying the bounded operator, in all degrees

If \(k\ne l\), equations (1) and (8)--(10) give zero against all
elementary source and test tensors with bounded matrix-stage entries.
They are dense, and \(Y\) is bounded, so \(Y=0\).

If \(k=l\), a cross matching pairs source slot \(i\) with test slot
\(\sigma(i)\) for a unique \(\sigma\in S_k\). Its coefficient, with
first endpoints \(d,c\), is
\[
 \tau(c^*d)\prod_i\tau(x_i z_{\sigma(i)})
 =\langle d,c\rangle\prod_i\langle x_i,z_{\sigma(i)}^*\rangle.
                                                               \tag{11}
\]
This is exactly the coefficient of \(I_E\otimes U_\sigma\), with
the inverse-permutation convention in the statement. In particular the
complex bilinear trace is not mistakenly identified with
\(\langle x_i,z_j\rangle\).

The finite sum of these permutation operators is bounded. Equality of
its coefficients with those of \(Y\) on dense elementary tensors
therefore proves equality of the completed Hilbert-space operators.
This density argument never extends a same-side trace contraction as
a bounded functional on a completed tensor product. For \(k=l=0\)
there is just one scalar coefficient and (11) gives a scalar identity.

Conversely, a tail permutation is unitary, commutes with simultaneous
conjugation, and does not affect the left endpoint. Finite linear
combinations have every required property. To see uniqueness, apply a
linear combination to a tensor of \(k\) distinct orthonormal vectors in
\(E_0\); its \(k!\) permuted outputs are orthonormal. The case \(k=0\)
is immediate. This completes the verification theorem.

## 8. The full word-structure consequence

The free-product word isometry in the source is
\[
 L^2(D*A_0)=\bigoplus_{k\ge0}H_k,\quad
 H_k=E\otimes E_0^{\otimes k}\otimes J_k,\quad
 J_k=(L^2(A_0)\ominus\mathbb C1)^{\otimes k}\otimes L^2(A_0).
\]
It follows directly by expanding the two unrestricted endpoints of
\(d_0a_1d_1\cdots a_kd_kz\): every reduced alternating word appears
exactly once, including words with zero or scalar endpoints. Scalar
tracial freeness makes the distinct reduced-word spaces orthogonal
and gives the tensor-product inner products. Their algebraic span is
dense in the tracial free product. These are the defining reduced-word
Hilbert-space properties, not a similarity-theorem input.

Let \(G\) be the bounded symmetrized operator, so it commutes with
\(L_D\) and all \(W_u\) from the stage groups. The projections \(P_k\)
onto \(H_k\) have the same commutations. For \(\alpha\in J_k\),
\(\beta\in J_l\), scalar-slice \(P_lGP_k\) against these vectors.
The resulting bounded \(Y_{\alpha,\beta}\) satisfies all hypotheses
of the verification theorem. For \(k\ne l\) every slice is zero.
Dense elementary tests give \(P_lGP_k=0\). Thus every level **reduces**
\(G\), not merely its compression to selected repeated tensors.

Choose any unit \(h\in E_0\) and define the isometry
\[
 V_k\alpha=1\otimes h^{\otimes k}\otimes\alpha,\qquad
 B_k=V_k^*GV_k.
\]
This works also for \(k=0\) and for \(J_k=\{0\}\).
It gives \(\|B_k\|\le\|G\|\).
On an equal-degree scalar slice write
\(Y_{\alpha,\beta}=I_E\otimes\sum_\sigma
a_\sigma(\alpha,\beta)U_\sigma\).
Since all permutations fix \(h^{\otimes k}\),
\[
 \langle B_k\alpha,\beta\rangle
       =\sum_\sigma a_\sigma(\alpha,\beta).                  \tag{12}
\]
They fix \(x^{\otimes k}\) for **every** \(x\in E_0\), with no reality,
self-adjointness, boundedness, or unit-norm restriction.
Testing against arbitrary endpoint vectors, arbitrary tail vectors,
and arbitrary \(\beta\) gives from (12)
\[
 G(d\otimes x^{\otimes k}\otimes\alpha)
       =d\otimes x^{\otimes k}\otimes B_k\alpha.
\]
All off-level outputs were already excluded, so this is a full-space
identity. It also shows independence of the chosen unit \(h\).
For \(x=0\) and \(k>0\) both sides are zero; for \(k=0\) the empty
tensor is \(1\), irrespective of \(x\).

The adjoint commutes with the same left algebra and group unitaries;
alternatively, the level reductions already pass to the adjoint.
Repeating the slice argument gives the same identity for \(G^*\), with
\(V_k^*G^*V_k=B_k^*\). This proves exactly `lem:word-structure`,
not merely an identity after compressing its output.

## Prior result and what this does not establish

The prior campaign ledger contained no proof of either lemma.
This result supplies the complete infinite-dimensional argument and
a real all-degree Lean certificate for its decisive support and growth
steps; the finite computations in `verify.py` are additional diagnostics.

Related fixed-degree conjugation duality is already in
Nessonov--Sinel'shchikov (2024), doi:10.5802/jolt.1352, Theorem 1.2.
Consequently this report claims an independently certified verification,
not a newly discovered classification or verified mathematical novelty.
It finds no false literal assertion in the two target lemmas.
No `F_` refutation claim is warranted by these results.

The propagation estimates, Fourier/Hankel bound, free-position transfer,
universal commutator estimate, and similarity conclusion remain separate
open audit obligations in the ledger and proof graph. Neither this proof
nor the formal core establishes Kadison's similarity conjecture.
Independent Reviewer reading, replay, and significance assessment are
still required. The publishable campaign is not declared complete.

## Replaying the evidence

From the campaign root, run

```bash
$WORKSPACE/argus-live-update/.venv/bin/python research/invariant-intertwiners/verify.py
```

This independently recomputes the exact finite diagnostics, compares
`exact_certificate.json`, and checks that the current Lean source and
statement-fidelity document still match the genuine stored compiler
and claim-linked archive. It does **not** rerun the compiler.
For independent kernel replay, use

```bash
$WORKSPACE/argus-live-update/.venv/bin/python -m argus_skill.verticals.math.lean_evidence verify research/invariant-intertwiners/Main.lean --statement-fidelity research/invariant-intertwiners/statement_fidelity.md --claim C_CORE --project-root .
```

The official campaign-local `math_state check` and `proof_graph_check check`
must both be run after ledger or graph changes. Their success is a structural
consistency result, not an independent mathematical or novelty judgement.
