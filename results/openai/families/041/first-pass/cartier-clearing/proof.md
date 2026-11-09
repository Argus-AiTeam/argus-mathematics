# Explicit Cartier-adjoint clearing

## Result and scope

The scalar-to-unit implication in Lemma `bc:clearing-test` is valid.
In fact its scalar identity supplies an explicit multiplier whose Cartier
image is exactly the original splitting scalar. The implication needs
neither completion nor a bound on the normalization degree, and permits
the relative Frobenius scalar to have poles.

This is a proof and structural strengthening of the specified implication,
not a counterexample, a verification of the full ordinary-base-change
proposition, or a proof of either manuscript's main theorem. Independent
review and the novelty/significance determination are outstanding.

## Parameter-uniform theorem

Let \(K\) be a field of characteristic \(p>0\), with finite \(p\)-basis
\(u_1,\ldots,u_n\). Write
\[
 x=\sum_{\alpha\in\{0,\ldots,p-1\}^n}u^\alpha x_\alpha^p,\qquad
 C_u(x)=x_{(p-1,\ldots,p-1)} .
\]
Thus \(C_u(x)\,du=\operatorname{Car}(x\,du)\). Let
\(\partial_i\) be the coordinate derivations; their extension to a finite
separable field extension is understood when that is how \(K\) is obtained.

Let \(A\subset R\subset K\) be subrings, with \(A\) stable under the
\(\partial_i\). No normality or regularity of \(R\) is required. Fix
\(s\in K\) and an additive map \(\psi:R\longrightarrow R\) satisfying
\[
                    \psi(r)=C_u(sr)\quad(r\in R).
\]
In particular, \(s\) need not lie in \(R\). Suppose a finite identity holds
in \(K\):
\[
 s=\sum_j c_j\,\partial_{i_{j,1}}\cdots
       \partial_{i_{j,r_j}}(g t_j s),
 \qquad c_j\in A,\quad g,t_j\in R.                 \tag{1}
\]
An empty derivative word is allowed. Define
\[
 a_j=(-1)^{r_j}\partial_{i_{j,r_j}}\cdots
                   \partial_{i_{j,1}}(c_j),\qquad
                      t=\sum_j t_j a_j.          \tag{2}
\]
Then \(a_j\in A\), \(t\in R\), and
\[
                         \boxed{\psi(gt)=\psi(1).} \tag{3}
\]
In particular, for any ideal \(I\) of \(R\) not containing \(\psi(1)\),
the image \(\psi(gR)\) is not contained in \(I\).
The result holds for arbitrary finite derivative words. For the manuscript's
commuting coordinate partials, (2) is precisely
\[
                  t=\sum_{j,\alpha}t_j
                       (-1)^{|\alpha|}\partial^\alpha c_{j,\alpha}.
                                                               \tag{4}
\]

## Proof

The \(p\)-basis expansion gives, for every \(x\in K\),
\[
 \partial_i x
   =\sum_{\alpha:\alpha_i>0}
       \alpha_i u^{\alpha-e_i}x_\alpha^p .
\]
In every nonzero summand the \(i\)-th exponent is at most \(p-2\).
The scalar \(\alpha_i\) belongs to the prime field and is its own
\(p\)-th power. Consequently
\[
                         C_u(\partial_i x)=0.                  \tag{5}
\]
This argument applies to rational elements as well as regular ones.
Additivity and the product rule now imply
\[
 C_u(c\,\partial_i x)
       =-C_u((\partial_i c)x)
       =C_u(-(\partial_i c)x).                                \tag{6}
\]
Induct on the length of a derivative word, moving its leftmost derivative
onto the coefficient with (6). The order is reversed, and each move
contributes a minus sign. Thus
\[
 C_u\bigl(c_j\partial_{i_{j,1}}\cdots
                   \partial_{i_{j,r_j}}x\bigr)=C_u(a_jx).      \tag{7}
\]
Apply \(C_u\) to (1), use (7), additivity, and commutativity:
\[
 \psi(1)=C_u(s)
   =\sum_j C_u(a_jgt_js)
   =C_u\left(sg\sum_jt_ja_j\right)=\psi(gt).
\]
Derivative-stability of \(A\) proves the asserted regularity of (2).
This proves the theorem.

## Application to the literal manuscript hypotheses

Work on the selected principal smooth-base open containing \(\mu(b)\).
Take \(K=K_0=\operatorname{Frac}(R)\), with the manuscript's \(u_i\)
as \(p\)-basis, \(A=k[u_1,\ldots,u_n]_{\mu(b)}\), and \(R=R_b\).
The finite generically etale normalization ensures that \(K_0\) is
separable over \(k(u_1,\ldots,u_n)\), so this is indeed a \(p\)-basis.
The coefficients \(c_{j,\alpha}\) are in \(A\), the \(t_j\) are in
\(R_b\), and \(A\) is stable under every ordinary partial derivative.
The identities `bc:scalar-differential` and `bc:relative-cartier` are exactly
(1) and the displayed formula defining \(\psi\).

Formula (4) therefore defines a function regular near \(b\) and proves
\[
                         \psi_h(gt)=\delta .
\]
Because \(\delta\in k^*\), its value at \(b\) is nonzero. This also covers
singular \(R_b\), ramification of \(\mu\), and rational \(s\).
The manuscript additionally assumes \(p>e_\mu,o_g\); the direct implication
does not need these inequalities once its displayed ordinary-derivative
identity has been retained. This does not assert that every other part of
the manuscript can dispense with them. It does not replace ordinary
derivatives by divided-power/Hasse derivatives.

## Differential identity: primary-source check

The source is the staged `05-base-change.tex`, Lemma
`bc:differential-identity`, and the following subsection on finite
preparations and selection of reductions. These checks concern the justification used
there, not all of Saito's theory.

Saito, arXiv:1605.00435v3, Theorem 1.4, explicitly assumes a projective
morphism of smooth complex algebraic varieties and a polarizable pure
Hodge module, and gives strict filtered direct image and pure cohomology
objects. These hypotheses hold for \(a=\mu h\) in the stated setup:
the source \(Z\) and target affine space are smooth, \(a\) is projective,
and the module is the constant polarizable one. Section 1.2 defines
strict support for both the rational object and the underlying
complex D-module, not just for filtered subobjects.

Appendix B.2 places the right-module top forms in filtration degree
\(-\dim Z=-2n\); B.3 supplies the transfer/direct-image conventions.
In the right transfer Spencer complex, the term of degree \(-i\)
has filtration \(F_{p-i}\) before tensoring with the nonnegative-order
target operators. At \(p=-2n\), only \(i=0\) and target order zero remain.
Thus this filtered piece is \(\mathbf R a_*\omega_Z\). Strictness
identifies its degree-zero cohomology with
\(F_{-2n}\mathcal H^0(a_+\omega_Z)=a_*\omega_Z\).
In particular the argument does not assume \(a\) smooth across the
discriminant. Changing to left modules introduces the base top-form
inverse and gives \(R\eta\), as claimed.

The sheaf \(a_*\omega_Z\) is torsion-free because \(Z\) is integral and
dominates the base. Its summands supported on proper subvarieties
therefore vanish. For semisimplicity the relevant variation is
*geometric on an algebraic smooth open*, not an arbitrarily restricted
analytic local system. Deligne, *Theorie de Hodge II*,
doi:10.1007/BF02684692, Proposition 4.2.5(iii), places smooth proper
algebraic direct images in the category satisfying 4.2.2, and Theorem
4.2.6 gives semisimple underlying monodromy. Minimal regular-holonomic
extension preserves this decomposition. This is the use needed here;
polarizability alone on an arbitrary analytic open would not justify
that step.

Inside that semisimple full-support module, \(U_g\subset U\) have the
same generic restriction, so the semisimple quotient \(U/U_g\) would
have proper support. No such constituent occurs. Hence \(U=U_g\).
Membership of \(\eta\) in \(D(gR\eta)\) gives the finite local operator
identity, with localized denominators absorbed into the coefficients,
as in the manuscript. This verifies the stated source justification
conditional on the retained geometric setup. It does not independently
verify that every earlier chart construction supplies that setup.

The full sources and proposition-level excerpts, including hypotheses,
are archived under `sources/`. Their ledger assumptions are
`C_DIFF/SAITO_STRICT` and `C_DIFF/DELIGNE_SEMISIMPLE`. Independent
source attribution is reserved for the host Reviewer.

## Relative trace and horizontal lift

The two lines \(V_0\) and \(W_0\) in the manuscript are Serre dual, as
are their field-Frobenius base changes. The relative finite dual trace
is the transpose of relative Frobenius pullback. With the displayed dual
bases its scalar is therefore \(s\), not \(s^{1/p}\) or \(s^p\).

A Cech cocycle representing \(v\), raised to p-th powers, is closed
both for the Cech differential and for absolute differentials over k.
It defines the indicated relative de Rham class \(\lambda\), is
horizontal for the connecting-map definition of the Gauss--Manin
connection, and projects to \(sv\). In the stated order of the cup
pairing, evaluation against \(\eta\) is consequently \(s\).
Connection compatibility then gives
\(\langle\lambda,D_j(gt_j\eta)\rangle=D_j(gt_js)\).
No differentiation of s was discarded; horizontality concerns
\(\lambda\), not the frame \(\eta\) or the scalar s.

Absolute Frobenius factors as relative Frobenius followed by the
base change of field Frobenius, exactly as defined in Stacks Tag
`0CC6`, Definition 33.36.4. The field Frobenius is finite and flat.
The duality trace base-change compatibility in Tag `0E5L`,
with the Tor-independence hypothesis from Tag `0E5A`, is therefore
applicable. Its trace is the duality counit, not the ordinary
field trace of a purely inseparable extension (which would be zero).
After the relative trace sends \(m\eta\) to \(sm\eta^{(p)}\),
projection formula for the remaining base-change trace applies
\(C_u\) to \(sm\,du\). This proves the claimed formula
\(\psi_h(m)=C_u(sm)\), with s inside the Cartier operator.
All these calculations take place on the generic smooth family;
none extends its relative frame across a singular point.

## Independent check of the manuscript's completion argument

There is no obstruction in the alternative trace proof under its stated
hypotheses. The details below explain why rational s is harmless; they
are a prose verification separate from the Lean adjoint theorem.

1. Finite-type normal k-algebras are excellent. Their completed local
   rings are normal; the factor at b is a complete normal local
   domain \(L\). The completed finite algebra splits over the complete
   regular local base \(A=k[[v_1,\ldots,v_n]]\). After passing to
   \(K=\operatorname{Frac}(A)\), the retained nonzero discriminant is
   invertible, so the product has finite etale rank \(e_\mu\).
   Thus \(K'=\operatorname{Frac}(L)\) is separable over K with
   \(d=[K':K]\le e_\mu<p\). Freeness at the closed point is not needed.
2. The finite module \(F_*R_b\) commutes with completion. The explicit
   map sends \((F_*r)\otimes x\) to \(F_*(rx^p)\).
   Ordinary and Frobenius powers of the maximal ideal are cofinal,
   which identifies this with \(F_*L\). A failed containment
   \(\psi_h(gR_b)\subset\mathfrak m_{R_b}\) therefore extends to L.
3. Power series decompose by their exponents modulo p, so the \(v^\alpha\)
   form a p-basis monomial basis of K. Such a p-basis remains a p-basis
   after a finite separable extension: \(K'/(K K'^p)\) is both
   separable and purely inseparable and is trivial; the degree
   calculation gives \([K':K'^p]=[K:K^p]\).
   The same argument applies to \(K_0/k(u)\). Translation by constants
   in the perfect field k preserves coefficient extraction and du.
   The completed Frobenius-linear maps agree on this basis and hence
   on all of \(F_*K'\). It is not necessary to assert that rational s
   has become an element of L.
4. For \(T=\operatorname{Tr}_{K'/K}\), integrality and normality give
   \(T(L)\subset A\). Moreover \(T(\mathfrak m_L)\subset\mathfrak m_A\).
   To see the latter, take the integral closure of the complete
   excellent ring A in a finite normal closure. It is finite and,
   being a domain over a henselian local ring, local. Every conjugate
   of an element of \(\mathfrak m_L\) belongs to its maximal ideal.
   Their sum lies there, and its intersection with A is
   \(\mathfrak m_A\).
5. In the common p-basis write \(x=\sum v^\alpha c_\alpha^p\).
   Separability and characteristic p give
   \(T(c_\alpha^p)=T(c_\alpha)^p\), by summing the field embeddings.
   Consequently \(T C_{K'}(x)=C_K(Tx)\). Derivations commute with T
   by uniqueness of their separable extensions. These statements
   hold for rational x, with no regularity proviso.
6. Put \(z_j=T(gt_js)\). Failed containment gives
   \(C_K(v^\beta z_j)\in\mathfrak m_A\) for every nonnegative base
   monomial. In the p-basis expansion of \(z_j\), multiply by
   \(v^{(p-1)\mathbf1-\alpha}\). Among the exponents
   \(\gamma+(p-1)\mathbf1-\alpha\), each coordinate is between
   0 and \(2p-2\). The Cartier residue is \((p-1)\mathbf1\)
   exactly when \(\gamma=\alpha\). Hence every coefficient
   \(c_{j,\alpha}\) lies in \(\mathfrak m_A\), and
   \(z_j\in\mathfrak m_A^{[p]}\). This *proves* regularity of the
   traced products, instead of assuming it.
7. Ordinary coordinate derivatives preserve
   \(\mathfrak m_A^{[p]}=(v_1^p,\ldots,v_n^p)\), because they
   annihilate its displayed generators. Regular base coefficients
   preserve it as well. Applying T to the scalar identity forces
   \(T(s)\in\mathfrak m_A^{[p]}\) and then
   \(C_K(Ts)\in\mathfrak m_A\). But the Cartier formula gives
   \(C_K(Ts)=T(\delta)=d\delta\), a unit because \(0<d<p\).
   This is the claimed contradiction.

Thus neither a pole of s nor singularity of L invalidates the displayed
proof. The direct theorem above strengthens the implication by removing
this entire trace/completion mechanism.

## Hypothesis controls, not manuscript counterexamples

The regularity and ordinary-derivative qualifications are substantive.
For every prime p take \(K=\mathbb F_p(u)\),
\(R=\mathbb F_p[u]_{(u)}\), \(s=u^{p-1}\), \(g=u^p\), and
\(\psi(r)=C_u(sr)\). Then \(\psi(1)=1\) and
\(\psi(gR)\subset(u)\), by Frobenius-linearity. If a nonregular
coefficient were allowed, the order-zero operator \(u^{-p}\)
would give \(s=u^{-p}gs\). If the p-th Hasse derivative were allowed,
\[
 \partial^{[p]}(gs)
   =\binom{2p-1}{p}u^{p-1}=s.
\]
Indeed
\(\binom{2p-1}{p}=\prod_{i=1}^{p-1}(p+i)/i\equiv1\pmod p\).
Both putative extensions would falsely predict clearing.
The manuscript permits neither: its coefficients are regular and
its retained operators of order below p are ordinary derivatives.
These are parameter-uniform boundary controls, not admissible
refutations of the manuscript, and create no `F_` claim.

## Machine certification and computational scope

`Main.lean` proves the p-basis derivative calculation, integration by
parts for all finite derivative words, regularity of the constructed
coefficient in a derivative-stable subring, the explicit clearing
identity, and noncontainment in every ideal avoiding \(\psi(1)\).
The official Lean 4.31.0 run succeeded with exit code 0,
`proof_holes=[]`, and axiom-audit exit code 0. Its certificate is
`certificates/C_ADJOINT-f51e1ae321822ae4.json`. The only reported
axioms of the two main theorems are `propext`, `Classical.choice`,
and `Quot.sound`.

The proof is uniform in p, n, the rational scalar, all finite operator
words, all coefficients, and the two subrings. It is not inferred from
finite tests. `statement_fidelity.md` separates the exact formal
hypotheses from the unformalized geometric input.

Replay from the campaign root with
`python3 research/cartier-clearing/verify.py`. A different built
Lean 4.31.0 Mathlib workspace can be supplied with `--workspace`.
The replay checks the current source and fidelity against the official
certificate, performs a fresh compiler run, and checks the axioms of
both concluding declarations. It also passed 10 derivative-annihilation,
75 word-adjoint, 208 rational coefficient-extraction, 3158 tame trace,
and 10 excluded-hypothesis diagnostic checks. These finite counts are
not the proof of the universally quantified theorem.

Jacobian 0.14.0, protocol `2025-11-25`, was used through the prescribed
Argus adapter. The inspected finite-algebra center contract accepts only
finite-dimensional prime-field structure constants; it does not represent
rational p-basis fields, completions, or Cartier extraction. The relevant
directional-derivative contract is over QQ, not characteristic p. One
bounded derivative of \(u^3v^2+v\) returned \(3u^2v^2\) in 20 ms.
This only checks a coefficient/sign preparation, not the theorem.
The exact contract, payload, and typed output are in the three
`jacobian_*.json` files; the adapter succeeded with no structured error.

The shared Wiki search found no page about this specific clearing bridge.
A targeted literature lookup found the standard Cartier and formal-adjoint
primitives, also explicitly present in Saito B.2.4; it did not establish
novelty of this strengthened clearing formulation. No claim of
`novelty_status=verified_new` or publishable campaign completion is made.
The bounded mission delivers an assumption-complete verification theorem
for independent review.

The strongest supplied prior finding concerns semiampleness propagation
in Soldatenkov--Verbitsky, arXiv:2409.09142v3, Theorems 3.7(v) and 3.8.
The archived primary text confirms the nonempty-semiample-component
hypothesis and the required semiample deformation.
That finding is separate: it does not construct an initial semiample
deformation. The present theorem instead addresses the rational
Cartier-clearing bridge and gives a direct witness where the manuscript
uses a contradiction through completed field trace.

The external propositions awaiting independent source attribution are:

| Claim / assumption | Exact local excerpt |
|---|---|
| `C_DIFF / SAITO_STRICT` | `sources/saito-excerpt.txt` |
| `C_DIFF / DELIGNE_SEMISIMPLE` | `sources/deligne-excerpt.txt` |
| `C_TRACE / FROBENIUS_FACTOR` | `sources/stacks-frobenius-excerpt.txt` |
| `C_TRACE / TRACE_FLAT_BASE_CHANGE` | `sources/stacks-trace-excerpt.txt` |
| `C_COMPLETION / EXCELLENT_NORMAL_COMPLETION` | `sources/stacks-excellence-excerpt.txt` |
| `C_COMPLETION / HENSELIAN_PRODUCTS` | `sources/stacks-henselian-excerpt.txt` |
| `C_COMPLETION / FINITE_COMPLETION` | `sources/stacks-completion-excerpt.txt` |
| `C_SEMIAMPLENESS / SV_PROPAGATION` | `sources/soldatenkov-verbitsky-excerpt.txt` |

Registry resolution of the Saito version, Deligne DOI, and
Soldatenkov--Verbitsky version succeeded. Those existence records are
correctly `inconclusive`, not proposition-level confirmations. The
engineer who filed these assumptions has not filed a purported
independent supporting attribution under another name.

The downstream gain is the explicit Cartier unit needed for the
Frobenius homotopy retract in Proposition `bc:ordinary`. The finite
regular-algebra comparison, ordinary coefficient complex, arithmetic
selection of reductions, descent, Euler obstruction, and companion SYZ
construction remain outside this certification. Neither whole manuscript
is declared correct.
