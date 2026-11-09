# Comparison with a tilting origin fibre

## Statement and scope

The target is `lem:formal-comparison`, `restricted.tex:234-376` in the
staged manuscript. For every algebraically closed field \(k\) of positive
characteristic and every \(\mathrm{SL}_2\)-equivariant vector bundle
\(\mathcal N\) on the standard plane with tilting origin fibre \(T\),
the required conclusion is
\(\mathcal N_{e_1}\simeq T|_U\) as rational \(U\)-modules **over \(k\),
with the unchanged parameter** \(u(t)\).

The finite BEO existence theorem and the restricted-Steinberg assertion
are already externally known: Coulembier--Flake,
*The Benson--Etingof--Ostrik conjecture for finite tensor categories*,
arXiv:2610.04096v2, abstract and Introduction, Conjecture 1.2 and its
subsequent resolution. This fact is recorded separately as
`C_SCOPE_KNOWN` / `A_CF_FINITE`. It is not an input proving the comparison
lemma and confers no novelty on re-establishing the main theorem.

The project Wiki index has no matching entry for the comparison,
good-filtration argument, tilting modules, or this campaign.
The source-specific audit below is independent of the externally known
main conclusion. A formal proof of the matrix cancellation alone would
not establish the existence of its formal gauge.

## Result

**Ext-rigid comparison theorem.** Let \(k\) be an infinite field, let
\(G=\mathrm{SL}_{2,k}\) act on \(V=k^2\), and let \(\mathcal N\) be a
\(G\)-equivariant vector bundle with origin fibre \(T\). If
\[
 \operatorname{Ext}^1_G
 \bigl(T,\operatorname{Sym}^j(V^*)\otimes T\bigr)=0
 \quad\text{for all }j\geq1
 \tag{E}
\]
in rational representations, then
\(\mathcal N_{e_1}\simeq T|_U\) as rational \(U\)-modules over \(k\).

Over an algebraically closed field of positive characteristic, a tilting
\(T\) satisfies (E). Thus this theorem proves the manuscript's literal
comparison lemma. Neither algebraization of the formal trivialization
nor a change of the original unipotent parameter is needed. The
generalization is the explicit Ext-rigidity criterion; novelty or
publishability is not inferred from its verification.

## 1. The Ext input really applies

We use the standard--costandard theorem in exactly this form:
\[
 \operatorname{Ext}^1_{\operatorname{Rep}^{\infty}(G)}
       (\Delta(a),\nabla(b))=0,\qquad a,b\geq0.
 \tag{1}
\]
For the algebraically closed positive-characteristic setting this is
Riche, *Lectures on modular representation theory of reductive algebraic
groups*, Chapter 1, Proposition 2.6. Chapter 4, Proposition 1.1 states
the corresponding filtration criteria. The actual passages, including
the connected-reductive, algebraically closed, positive-characteristic
hypotheses, are in `riche_excerpt.txt`. The author-hosted PDF is
unversioned; the ledger cites its URL and exact locators, not an
unread DOI or a fabricated publication version. The cited
\(\operatorname{Rep}^{\infty}(G)\) is the category of rational modules;
finite-dimensional extensions form an extension-closed subcategory.

Here is the remaining argument, not an extra tensor-filtration
assumption. For \(a,b\geq1\), let
\[
 d=x_1y_2-y_1x_2.
\]
Multiplication by \(d\) embeds the bidegree \((a-1,b-1)\) part of
\(k[x_1,y_1,x_2,y_2]\) into its bidegree \((a,b)\) part. This is
injective because the polynomial ring is a domain and \(d\neq0\),
including in characteristic two. Multiplication of binary forms
surjects onto \(\operatorname{Sym}^{a+b}(V^*)\): every degree
\(a+b\) monomial factors into monomials of degrees \(a,b\).
Its kernel contains the image of \(d\), and
\[
 (a+1)(b+1)-(a+b+1)=ab
   =\dim(\operatorname{Sym}^{a-1}(V^*)\otimes
                    \operatorname{Sym}^{b-1}(V^*)).
\]
This proves the exact sequence in the manuscript. The determinant is
\(\mathrm{SL}_2\)-invariant, so the sequence is equivariant.
Induction on \(\min(a,b)\) gives a good filtration, with factors
\(\nabla(a+b-2i)\), \(0\leq i\leq\min(a,b)\).
Refining finite filtrations and exactness of tensoring over a field
then prove that the tensor product of two good-filtered modules has a
good filtration.

In particular \(Q_j=\operatorname{Sym}^j(V^*)\otimes T\) is
good-filtered. Induction on its filtration in the long exact Ext
sequence gives \(\operatorname{Ext}^1_G(\Delta(a),Q_j)=0\) from
(1). Induction on a Weyl filtration of the *first* argument \(T\)
then gives (E). These inductions need only the adjacent
\(\operatorname{Ext}^1\) groups to vanish, not an unstated
\(\operatorname{Ext}^2\) assumption. This checks both the ordering
of standard and costandard arguments and the characteristic-two case.

## 2. Compatible splittings construct the gauge

Put \(A=k[x,y]\), \(\mathfrak m=(x,y)\), and
\(N=\Gamma(V,\mathcal N)\). This is a finite projective \(A\)-module
with rational \(G\)-equivariance. Flatness of \(N\) identifies the
jet kernel, naturally and equivariantly, as
\[
 \mathfrak m^jN/\mathfrak m^{j+1}N
   \simeq(\mathfrak m^j/\mathfrak m^{j+1})\otimes T
   \simeq\operatorname{Sym}^j(V^*)\otimes T.
 \tag{2}
\]
There is no arbitrary identification of the fibre in (2): the
map is induced by multiplication and reduction modulo \(\mathfrak m\).

Start with \(s_1=\mathrm{id}_T:T\to N/\mathfrak mN\).
Given \(s_j\), pull back the short exact jet sequence along \(s_j\).
Its class lies in exactly the group (E), so it splits as a rational
\(G\)-module extension. Composing a splitting with the pullback
projection produces \(s_{j+1}\) reducing to \(s_j\).
Thus we choose a compatible sequence inductively, rather than
choosing unrelated isomorphisms at each order.

Multiplication extends \(s_j\) to an equivariant \(A/\mathfrak m^j\)-map
\[
 \Phi_j:(A/\mathfrak m^j)\otimes T\longrightarrow
                   N/\mathfrak m^jN.
\]
The target is finite projective over the local Artinian ring
\(A/\mathfrak m^j\), hence free of rank \(\dim T\). The source has
the same rank. Modulo the maximal ideal \(\Phi_j\) is the identity;
its determinant is therefore a unit, so \(\Phi_j\) is an isomorphism.
The maps and their inverses are compatible. Taking the inverse limit
gives
\[
 \widehat\Phi:k[[x,y]]\otimes T\xrightarrow{\sim}\widehat N.
 \tag{3}
\]
We assert equivariance at every finite order, not rationality of the
entire completed \(G\)-module.

On the line \(\ell=\{y=0\}\), the bundle is free: a finite projective
module over the PID \(k[x]\) is a direct summand of a finite free
module, hence a free submodule. Choose a polynomial frame and the
matching basis of \(T\) at zero. Restricting (3) gives an actual
matrix \(H(x)\in\mathrm{GL}_n(k[[x]])\), with \(H(0)=1\).
This establishes, rather than assumes, the formal gauge needed below.

## 3. Formal equivariance is a rational group-scheme identity

The line is fixed scheme-theoretically by \(U\), since
\(u(t)(x,0)=(x,0)\) over every \(k\)-algebra. In its polynomial frame
write its rational action as \(C(x,t)\), and write the action on \(T\)
as \(B(t)\). These are polynomial matrices over \(k[x,t]\) and
\(k[t]\); their inverses are obtained by replacing \(t\) by \(-t\).
Equivariance of \(\Phi_j\), followed by reduction to the line, is
\[
 C(x,t)H(x)=H(x)B(t)\pmod{x^j}
 \quad\text{as polynomial matrices, for every }j.
 \tag{4}
\]
The degrees in \(t\) on both sides are bounded by the fixed action
matrices, independently of \(j\); \(H\) has no \(t\)-dependence.
For each entry and each coefficient of \(t\), its difference lies
in every \(x^jk[[x]]\). All its power-series coefficients vanish.
Hence (4) is an equality in \(k[[x]][t]\), and then in \(K[t]\)
for \(K=k((x))\).
This is the entrywise application of
`FibreComparison.formal_polynomial_separation`.
It yields a rational \(U_K\)-isomorphism
\(\varphi:T_K\to\mathcal N_{xe_1}\).

This reasoning does not check just points of a finite field, or just
the differential of the action. The bounded Jacobian diagnostic
`modular.polynomial_identity.compute`, with its exact payload and
typed output in the accompanying JSON files, confirms that
\(t^2-t\) is not the zero polynomial over \(\mathbb F_2\), although
it vanishes on all its rational points. It is a warning against a
different shortcut, not a counterexample to the manuscript.
The inspected operation is coefficientwise, commutative, and
bounded; it cannot certify arbitrary matrix size, formal gauges, or
noncommutative transport. Those tasks are not delegated to it.

## 4. Both transports cancel the same conjugation

Let \(A(t)=C(1,t)\), let \(h=\operatorname{diag}(x,x^{-1})\), and
let \(P=b_h:\mathcal N_{e_1,K}\to\mathcal N_{xe_1}\) be the bundle
transport. Let \(D=\rho_T(h)\). Since
\[
 h u(t)h^{-1}=u(x^2t),
\]
bundle and representation equivariance respectively give the
identities in \(K[t]\)
\[
 PA(t)=C(x,x^2t)P,\qquad DB(t)=B(x^2t)D.
 \tag{5}
\]
Substituting \(x^2t\) into the already established gauge identity gives
\[
 C(x,x^2t)H=HB(x^2t).
 \tag{6}
\]
Consequently \(F=P^{-1}HD\) is invertible and
\[
 \begin{aligned}
 A(t)F
 &=P^{-1}C(x,x^2t)HD\\
 &=P^{-1}HB(x^2t)D
 &=P^{-1}HDB(t)=FB(t).
 \end{aligned}
 \tag{7}
\]
These are identities over the *same* polynomial parameter \(t\).
The rightmost factor \(D\) is essential: \(P^{-1}H\) alone
generally intertwines with \(B(x^2t)\), not with \(B(t)\).
The manuscript includes \(D\), so this is not an identified error.
The existence of \(D\) uses that \(T\) is a full \(G\)-module,
not an arbitrary \(U\)-module.

`transport_identity` proves the multiplication in (7) for any
monoid with three specified units; `parameter_cancellation` proves
it for an arbitrary common reparametrization. Thus the proof does
not use an accidental sign, commutativity, matrix-size restriction,
characteristic assumption, or surjectivity of the reparametrization.

## 5. Descent, with no concealed kernel-base-change assumption

Here is a slightly stronger linear-algebra argument than is needed
for the manuscript's finite coefficient system.
Let \(k\) be any infinite field, \(K/k\) any field extension, and
\((A_i,B_i)_{i\in I}\) any family of pairs of \(n\)-by-\(n\)
matrices over \(k\). The set \(I\) may even be infinite.
Suppose \(F\in\mathrm{GL}_n(K)\) satisfies
\((A_i)_KF=F(B_i)_K\) for every \(i\).

Choose a \(k\)-vector-space basis \((b_\gamma)\) of \(K\).
The finitely many entries of \(F\) have a common finite union \(S\)
of coordinate supports. Therefore
\[
 F=\sum_{\gamma\in S} b_\gamma(M_\gamma)_K,
 \quad M_\gamma\in\operatorname{Mat}_n(k).
 \tag{8}
\]
Apply each \(k\)-linear coordinate functional to each entry of each
intertwiner equation. The coefficients of \(A_i,B_i\) lie in \(k\),
so the functional commutes with their left and right multiplication.
It follows that \(A_iM_\gamma=M_\gamma B_i\) for every \(i,\gamma\).
No scalar-extension theorem for a Hom space is assumed.

Consider the genuine polynomial
\[
 q((z_\gamma))=\det\left(\sum_{\gamma\in S}z_\gamma M_\gamma\right)
                    \in k[z_\gamma:\gamma\in S].
 \tag{9}
\]
Its evaluation at \(z_\gamma=b_\gamma\) over \(K\) is \(\det F\neq0\),
so \(q\neq0\). A nonzero polynomial over an infinite field does not
vanish on every \(k\)-point: induct on the number of variables and
use the finite root bound for a nonzero univariate polynomial.
Choose \(c_\gamma\in k\) with \(q((c_\gamma))\neq0\).
Then \(F_0=\sum c_\gamma M_\gamma\) is invertible over \(k\) and
intertwines every original equation.

The full argument (8)--(9), including the finite-support extraction,
coordinatewise preservation of equations, determinant specialization,
and nonzero specialization, is proved in Lean by
`finite_coordinate_expansion`, `coordinates_intertwine`,
`exists_nonsingular_combination`, and `descend_intertwiner`.
It assumes neither algebraicity nor separability of \(K/k\), and
includes the zero-rank case, where the empty determinant is \(1\).

Apply this with \(I\) all coefficients in \(t\) of (7).
The descended matrix satisfies \(A(t)F_0=F_0B(t)\) in \(k[t]\).
It is therefore an isomorphism of rational group-scheme
representations, valid after evaluation in every commutative
\(k\)-algebra. In particular any fixed embedding
\(E_r\hookrightarrow U(k)\) is literally unchanged.
`comparison_over_extension` combines this descent with the three
coefficientwise transport identities, for arbitrary size and
arbitrary index set. This completes the Ext-rigid theorem and its
tilting corollary.

## Exact replay

Run from the campaign root:

```sh
$WORKSPACE/argus-live-update/.venv/bin/python research/geometric_fibre_comparison/verify.py
```

The script checks the literal staged lemma, replays the native
Jacobian payload independently, checks exact transport identities
over \(\mathbb Z[x,x^{-1},s,t]\) in ranks \(0,1,2,4\), and checks
integral unit minors in nine binary-form multiplication complexes.
It also checks an extension-field example in which **both**
coordinate matrices are singular but a base-field combination is
invertible; selecting a single coordinate matrix would be invalid.
These are deterministic diagnostics, not the proof of the universal
statement. The script then runs the real Lean verifier against
`C_COMPARE_ALGEBRA` and both official campaign-local checks. It fails
on a compiler failure, proof hole, missing mechanical recording, or
changed literal target.

The noncommutative word diagnostic introduces inverses only for
\(P,H,D\), not for the arbitrary action coefficient \(B\).
The formal source is unrestricted in matrix size, coefficient
index set, and field characteristic. `exact_certificate.json`
distinguishes this universal result from its bounded examples and
from the geometric and literature steps that require human review.

The recorded Lean 4.31.0 run has `exit_code=0`, `proof_holes=[]`,
and axiom-audit exit code \(0\). Its immutable archive is
`certificates/C_COMPARE_ALGEBRA-3cffcdd3f7dbb041.json`.
The derived ledger status of `C_COMPARE_ALGEBRA` is `closed_kernel`,
with no external assumptions or stale evidence. This status belongs
to the algebraic claim, not to the full geometric claim.
Both official checks against
`campaigns/9000208`
returned exit code \(0\) during the replay.

## Audit boundary

No false literal manuscript assertion has been established in this
comparison proof, so there is no invented `F_` refutation claim.
The manuscript's other main-theorem inputs are decomposed in
`PROOF_GRAPH.json` but are not certified by this bounded comparison
mission. The independent Reviewer must inspect the geometric proof,
statement fidelity, and the cited primary-source passages and replay
the exact verifier. A compiler run is not an independent review of
those prose steps or a novelty assessment.
