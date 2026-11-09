# Two tails suffice for the highest-Hodge-space comparison

## Result and scope

This note gives a classical proof of a strengthening of Proposition
`prop:tail-rank` in the staged reverse-logarithmic manuscript. The strengthening
uses only the first two tails: they determine the common null distribution
of every positively weighted full tail sum, and control the highest-space
and compact-mark curvature. It does **not** refute that proposition or its degree-one-root
lemma. It does not certify the other ingredients of the manuscript's
logarithmic Kodaira theorem.

The proposed result is a **verification theorem and structural reduction**,
not a finite search. Its independent review, citation attribution, and
publication-level novelty assessment are still pending. A bounded literature
lookup found no exact prior statement of the two-tail comparison; absence of a
match is not proof of novelty.

The executable certificate checks dimension-independent noncommutative
polynomial proofs of the two-tail implications and an exact obstruction to a
weaker, diagonal-only test. It does not purport to execute Hodge theory or to
replace independent reading of the geometric proof below.

## Statement fidelity

Use the marked data specified at the beginning of `boundary-rank.tex`.
In particular:

1. The underlying rational Lie variation is polarized, pure, integral, and
   algebraic over a smooth connected quasi-projective base. Its connected
   monodromy is the semisimple adjoint rational group \(G\).
2. The complex coefficient variation \(V\) is irreducible as a representation
   of \(G_{\mathbb C}\). Its Hodge grading and positive metric come from the
   adjoint tensor construction, up to a constant scalar grading shift.
   Representation adjoints are the actions of Lie adjoints. Write \(E\) for
   its **whole** highest Hodge piece, not an arbitrary top vector.
3. There are algebraic compact marks \(j_{\rm u}\), with flat positive compact
   metrics and positive flag lines. They are pointwise equivariant functions
   of the chosen projective line on the dense open under consideration.
   Write \(H=\det E+H_{\rm u}\) at unipotent level.
4. Let \(h:W\to S\) be **any** dominant morphism of smooth connected projective
   varieties with connected generic fiber. Let \(\ell\subset h^*E\) be
   **any** algebraic line subbundle on a dense algebraic open whose
   pointwise instability construction gives \(h^*j_{\rm u}\).
   No condition says that it is the vector originally defining \(S\).
5. Pass to any smooth connected unipotent level dominating the one defining
   \(H\), and resolve the boundary and the generated Grassmann maps.
   All lines below are on this resolved projective variety \(B\). Extensions
   are the tautological subbundles of the pulled-back canonical Hodge grades.
   They are not arbitrary extensions of the same bundles on the open set.

Let \(G_i\) be the span of **all** contractions of \(\theta^i\ell\), put
\(G_0=\ell\), and set \(U_j=\bigoplus_{i\geq j}G_i\). A zero tail has
trivial determinant. There are only finitely many nonzero tails.

**Two-tail theorem.** Each \(L_j=-\det U_j\) is nef. For rational numbers
\[
 c_0>0,\qquad c_1>0,\qquad c_j\geq0\ (j\geq2),\qquad t\geq0,
\]
put \(P_c=\sum_j c_jL_j\). Then
\[
                         \nu(P_c+tH)=\nu(P_c)=\nu(L_0+L_1).
\]
Here \(H\) includes all level and \(h\) pullbacks, and \(\nu\) is the
numerical dimension of a nef rational line. This is **not** an assertion
about Iitaka dimension. In particular
\[
 N=L_0+L_1,\qquad \nu(N+H)=\nu(N),
\]
and choosing every \(c_j=1\) proves the manuscript's
\(P=-\sum_j\det U_j\) comparison with its full stated quantifiers.

In fact, on the variation locus the curvature kernels of \(P_c\) and
\(L_0+L_1\) agree at **every** point, not just at the orbit-filling points.
This local assertion requires neither algebraicity nor irreducibility;
those hypotheses enter only when comparing with the whole \(E\).

The case of zero-dimensional bases or zero \(G_1\) is included. There is
no assertion here for arbitrary nonalgebraic local lines, reducible
coefficient representations, or missing compact-mark compatibility.

## 1. The graded-Lie assertion, with its precise kernel

Let \(\mathfrak g\) be an integrally graded complex semisimple Lie algebra
with compact-form adjoint, let \(\mathfrak h\) be a graded adjoint-stable
ideal, and let \(V\) be an irreducible compatibly graded representation.
Let \(E\) be its highest graded piece. The following proves, and slightly
sharpens, the manuscript lemma.

**Root-kernel theorem.** The subspace
\[
 K_s=\{x\in\mathfrak h_1:[x,\mathfrak h_{-1}]s=0\}
 \quad(0\ne s\in E)
\]
is independent of \(s\), and equals
\[
                         \{x\in\mathfrak h_1:x^*E=0\}.
\]
More explicitly, choose a Cartan and positive roots with nonnegative
simple-root degrees, let \(\Delta_0\) be the degree-zero simple roots,
and let \(\lambda\) be the highest weight of \(V\). For each degree-one
simple root \(\alpha\), let \(C_\alpha\) be its component in the
subdiagram \(\Delta_0\cup\{\alpha\}\). Let \(B_\alpha^+\) be the span
of positive root spaces of degree one containing \(\alpha\). Then \(K_s\)
is the direct sum of those \(B_\alpha^+\subset\mathfrak h_1\) for which
\[
       \langle\lambda,\delta^\vee\rangle=0
                       \quad\text{for every }\delta\in C_\alpha.
\]

**Proof.** An integral grading of a semisimple algebra is inner; put its
grading element in a closed dominant chamber. Thus the chosen simple
degrees are nonnegative integers. Highest-weight theory gives
\(E=U(\mathfrak g_0^-)v_\lambda\), an irreducible module for the
degree-zero reductive algebra. A positive root of degree one has exactly
one degree-one simple root, with coefficient one; all its other nodes
have degree zero. Hence the spaces \(B_\alpha^\pm\) are
\(\mathfrak g_0\)-modules. For distinct \(\alpha,\beta\),
\([B_\alpha^+,B_\beta^-]=0\): the difference of the indexing roots has
simple-root coefficients of both signs, and so is neither a root nor zero.
An ideal consists of full simple factors, so these blocks also decompose
\(\mathfrak h_1\).

Write \(x=\sum x_\alpha\). If \(x\in K_s\) and \(x_\alpha\ne0\), the
cross-bracket observation gives \([x_\alpha,B_\alpha^-]s=0\).
The closed projective incidence
\[
 \{([z],[u])\in{\mathbb P}(B_\alpha^+)\times{\mathbb P}(E):
                         [z,B_\alpha^-]u=0\}
\]
is therefore nonempty and stable under the connected degree-zero group.
Apply Borel's fixed-point theorem to a Borel containing the full Cartan.
The second coordinate of a fixed pair is \([v_\lambda]\), because \(E\)
is irreducible for the degree-zero group; the first is a root line
\([e_\rho]\), because its full-Cartan weight spaces are one-dimensional.
This does not assume irreducibility of \(B_\alpha^+\).

The support of \(\rho\) lies in \(C_\alpha\). If it were smaller, choose
a zero-degree node \(\delta\) outside that support and adjacent to it.
Its coefficient is zero and an adjacent coefficient is positive, so
\(\langle\rho,\delta^\vee\rangle<0\). The root string then contains
\(\rho+\delta\). Consequently the positive root vector \(e_\delta\)
does not preserve \(\mathbb Ce_\rho\), contradicting the Borel-fixed
condition. Thus \(\operatorname{Supp}\rho=C_\alpha\).

Now \([e_\rho,e_{-\rho}]v_\lambda=0\) gives
\(\langle\lambda,\rho^\vee\rangle=0\). The coroot \(\rho^\vee\) has
strictly positive simple-coroot coefficients on its support. Since
\(\lambda\) is dominant, it vanishes on every simple coroot of
\(C_\alpha\). Each root in \(B_\alpha^+\) has support in \(C_\alpha\).
Its negative root vector kills \(v_\lambda\) by finite-dimensional
\(\mathfrak{sl}_2\) theory. The whole \(B_\alpha^-\) is
\(\mathfrak g_0\)-stable, so commuting it past degree-zero lowerings
shows \(B_\alpha^-E=0\). This proves \(x^*E=0\), and also the stated
block classification.

For completeness the converse needs the metric, not another incidence
argument. If \(x^*E=0\), then \(xE=0\) by highest degree. For
\(y\in\mathfrak h_{-1}\), \(e,f\in E\), the vector \(xye\) lies in \(E\)
and
\[
                       \langle xye,f\rangle
                          =\langle ye,x^*f\rangle=0.
\]
It is therefore zero. Thus \([x,y]E=0\), proving the equality of kernels.
\(\square\)

This proof requires the universal quantifier over \(y\in\mathfrak h_{-1}\).
It cannot be replaced by \(y=x^*\), or by \(x^*s=0\).
For example in the adjoint representation of \(\mathfrak{sl}_4\) with
block grading \(2+2\), take
\[
 E=\langle e_{13},e_{14},e_{23},e_{24}\rangle,\quad
 x=e_{13},\quad s=e_{24}.
\]
One has \(x^*s=0\) and \([[x,x^*],s]=0\), but
\[
 [[x,e_{32}],s]=e_{14}\ne0,\qquad
 [x^*,e_{13}]=e_{33}-e_{11}\ne0.
\]
The exact script checks these statements and the rank-three action
\(\operatorname{ad}(x^*)|_E\). This is an obstruction to a tempting
**audit shortcut**, not a counterexample to any manuscript assertion.

## 2. What the first two curvature terms actually imply

Work on the smooth variation locus. All \(U_j\) are Higgs invariant:
integrability makes contraction of \(\theta^{i+1}\ell\) contain every
contraction obtained by applying \(\theta\) to \(G_i\). The Hodge grades
are orthogonal. Write \(A=\theta(v)\), \(Q_j\) for orthogonal projection
to \(U_j\), and \(B_j=(1-Q_j)\mathcal D'_v|_{U_j}\). Subbundle curvature
and the Hodge curvature equation give
\[
 \Theta_{L_j}(v,\bar v)=
       \|(1-Q_j)A^*|_{U_j}\|_{\rm HS}^2+\|B_j\|_{\rm HS}^2.
 \tag{1}
\]
The Hodge equation here is the \((1,1)\)-part of
\((\mathcal D+\theta+\theta^\dagger)^2=0\).
Indeed, for \(U_j\oplus U_j^\perp\), write
\(A=\left(\begin{smallmatrix}a&b\\0&c\end{smallmatrix}\right)\).
The trace on \(U_j\) of \(A^*A-AA^*\) is \(-\|b\|^2\);
the Chern subbundle correction is \(-\|B_j\|^2\).
Negating the determinant proves (1), with a common positive normalization.

Suppose \(\Theta_{L_0+L_1}(v,\bar v)=0\). Each norm in (1) vanishes.
For \(g\in G_1\), \(A^*g\) is in the highest Hodge grade, orthogonal
to \(U_1\); the \(j=1\) term therefore gives
\[
                             A^*G_1=0.                 \tag{2}
\]
Since \(A\ell\subset G_1\), positivity gives \(A\ell=0\).
Also \(B_0=0\) means \(\mathcal D'_v\ell\subset U_0\).
The Chern connection preserves Hodge grades, and the highest-grade
part of \(U_0\) is exactly \(\ell\); hence
\(\mathcal D'_v\ell\subset\ell\). Since
\(\nabla^{1,0}=\mathcal D'+\theta\), the projective flat derivative of
\(\ell\) in direction \(v\) is zero. Pointwise dependence of the compact
marks on \(\ell\) also gives
\[
                           d\ell(v)=dj_{\rm u}(v)=0.    \tag{3}
\]

Only (2), \(B_0=0\), and \(A\ell\subset G_1\) were used. No assertion
that \(A^*G_i=0\) for all \(i\) is needed. This is the two-tail reduction.
For \(G_1=0\), (2) is vacuous and \(A\ell=0\) already holds.

There is a stronger local conclusion.

**Common-kernel theorem.** For a polarized complex pure variation on any
complex manifold, any holomorphic line in its highest Hodge bundle,
and the constant-rank generated subbundles on the open set in question,
\[
 \ker(\Theta_{L_0}+\Theta_{L_1})
   =\bigcap_{j\geq0}\ker\Theta_{L_j}
   =\ker\left(\sum_jc_j\Theta_{L_j}\right)
 \tag{2a}
\]
whenever \(c_0,c_1>0\) and all remaining coefficients are nonnegative.
There is no bound on the number, ranks, or lengths of the tails.

**Proof.** From \(A\ell=0\) and Higgs integrability,
\(A\theta(w_1)\cdots\theta(w_i)\ell=0\) for every \(i\) and every
choice of contractions. Consequently \(AU_0=0\). The first term
of (1) for \(j=0\) says \(A^*U_0\subseteq U_0\). But \(AU_0=0\)
says \(A^*U_0\) is orthogonal to \(U_0\); hence \(A^*U_0=0\).
In addition, \(B_0=0\) and preservation of the grading by
\(\mathcal D'\) imply \(\mathcal D'_vG_i\subseteq G_i\) for every
\(i\), because \(U_0\) meets its \(i\)-th Hodge grade exactly in
\(G_i\). It follows that \(B_j=0\) for every tail. Thus all terms
of (1) vanish. The reverse implication, and the weighted version,
follow from semipositivity and \(c_0,c_1>0\). \(\square\)

This improves the initial first-two-tail observation: the shorter
line does not merely suffice to bound the marked curvature; it has
exactly the same pointwise curvature rank as every such weighted
full tail sum.

The certificate proves (2), \(A\ell=0\), the flat-line conclusion,
the orbit-to-commutator step, and the additional operator implications
in (2a), including the **induction step for arbitrary-length Higgs
words**, in a free associative algebra. These are universal
polynomial proofs for operators on vector spaces of **arbitrary
dimension**, not tests on a fixed matrix size. Semipositivity,
orthogonality, and the geometric interpretation of the relations are
stated explicitly here; the script does not check the external
Hodge-theoretic inputs.

## 3. Why algebraicity supplies the missing directions

Here is the complete geometric input; it is not an assumption that
the single-vector calculation already controls \(E\).

First, a flat algebraic principal connection with connected semisimple
Zariski-dense monodromy satisfies the following dimension estimate.
If an irreducible analytic germ \(T\) in its base is Zariski dense,
and \(\widetilde T\) is a horizontal lift in the frame torsor
\(\mathcal P\), then
\[
                 \dim\overline{\widetilde T}^{\,\rm Zar}
                                      \geq\dim T+\dim H.       \tag{4}
\]
The closure is taken over the Zariski closure of \(T\), after restricting
to its smooth locus.

For clarity, (4) has a direct connection-form proof. Let \(R\) be that
closure, and \(\xi\) the principal connection form. On its constant-rank
smooth locus the Grassmann map \(r\mapsto\xi(T_rR)\) is constant along
the kernel of \(\xi|_{TR}\): Cartan's formula and
\(d\xi+\frac12[\xi,\xi]=0\) give \(\mathcal L_X\xi=0\) for a tangent
field with \(\xi(X)=0\). It is constant along \(\widetilde T\), hence
constant on \(R\) by algebraicity and density. Call its value
\(\mathfrak b\). Lifting constant elements of \(\mathfrak b\) to
tangent fields and using the same equation shows that it is a
Lie subalgebra.

The analytic subgroup with Lie algebra \(\mathfrak b\) has proper
algebraic closure \(B<H\) if \(\mathfrak b\ne\mathfrak h\).
Otherwise its adjoint stabilizer would make \(\mathfrak b\) an ideal
of \(\mathfrak h\). An ideal of a semisimple algebra integrates to
a closed normal subgroup, contradicting density of that proper
analytic subgroup. Saturate \(R\) by \(B\). The resulting algebraic
subset \(R_B\) dominates the base, is \(B\)-invariant, and has connection
values in \(\operatorname{Lie}B\) at general smooth points.
Its dimension is at least \(\dim Z+\dim B\) by its fiber orbits and
at most that number by rank-nullity for \(\xi\). Thus the entire
horizontal distribution is tangent to \(R_B\).

Tangency is algebraic, so its ideal is preserved by local horizontal
flows, not just at a chosen generic point. Over a smooth dense open of
the base, transport preserves a nonempty closed fiber of \(R_B\) of
dimension \(\dim B\). The original monodromy remains dense on that
open: removing a complex algebraic subset does not prevent perturbing
loops off it. A nonempty closed subset of an \(H\)-torsor invariant
under dense translations is the whole torsor. This contradicts
\(\dim B<\dim H\). Hence \(\mathfrak b=\mathfrak h\), and rank-nullity
on \(R\), whose horizontal kernel contains \(T\widetilde T\), proves
(4). Regular singularity is used below to make the frame reduction
algebraic, not as an extra hypothesis in this connection argument.

Now take a local constant-rank fiber \(T\) of the projective flat map
\(\ell\), through a Hodge-generic point of \(B\), and let \(Z\) be its
irreducible algebraic closure. Such a point can be chosen in any
prescribed nonempty ordinary open maximum-rank locus: the extra
rational Hodge-tensor loci are a countable union of proper closed
analytic loci. The generic Mumford--Tate group on \(Z\) is the ambient
one, since any generic tensor condition on \(Z\) holds at that point.
André's connected monodromy normality theorem makes the connected
restricted monodromy \(H\) a normal rational factor of \(G\). At
connected level write \(G=H\times Q\).

Here the ambient connected monodromy really is the original \(G\).
For the given \(h\), shrink the target to a smooth proper
connected-fiber locus. Its topological fibration gives surjectivity
onto the target fundamental group. Shrinking algebraic smooth opens
does not decrease the original monodromy image. A connected finite
level has finite-index image, whose Zariski closure still contains
the connected group \(G\). Thus the hypotheses hold for every \(h\)
and every connected level allowed in the proposition, not just the
original base.

The \(Q\) monodromy on a finite cover of a smooth open of \(Z\) is
trivial. The fixed-part theorem, applied to the rational Lie variation,
makes its whole \(Q\) period constant there. Its trivial regular-singular
connection has algebraic flat frames. The flat \(H_{\mathbb C}\)-frame
reduction is algebraic as well: a semisimple group is the stabilizer
of a tensor vector, and its monodromy-invariant tensor section is
algebraic for a regular-singular connection.

Let \(a_0=\ell(T)\) in flat coordinates and
\(d=\dim H_{\mathbb C}a_0\). Frames carrying \(\ell\) to \(a_0\)
form an algebraic incidence. Its image contains \(T\), so its
constructible image contains a dense open in \(Z\); its nonempty
fibers have dimension \(\dim H-d\). It contains a horizontal lift of
\(T\). Estimate (4) consequently implies
\(\dim Z-\dim T\geq d\). Conversely, on that open \(\ell|_Z\) takes
values in \(H_{\mathbb C}a_0\) in flat coordinates, and its differential
has kernel \(T_zT\), because \(T\) was an ambient constant-rank fiber.
Thus \(\dim Z-\dim T\leq d\), and equality gives
\[
            d\ell(T_zZ)=T_{\ell(z)}(H_{\mathbb C}\ell(z)).       \tag{5}
\]
These are suitable smooth points of \(T\). Any nonempty subgerm of
\(T\) remains Zariski dense in \(Z\), including after the finite level:
its finite image is dense and therefore its closure has full dimension.
The orbit need only be locally closed, not projective.

## 4. From two-tail nullity to whole-highest-space nullity

At a point where (5) holds, let \(v\) be any null direction for
\(L_0+L_1\). Equation (3) puts **all** such directions in \(T_zT\),
so the same \(T,Z,H\) can be used for all of them. Constancy of the
whole \(Q\) period on \(Z\) gives
\[
                           t(v)\in\mathfrak h^{-1,1}.
\]
Write \(\ell_z=\mathbb Cs\). Projection of the flat derivative of
\(\ell\) to the next Hodge grade is Higgs evaluation on \(s\):
the Chern derivative is in the top grade. Equation (5) therefore yields
\[
                        \mathfrak h^{-1,1}s\subseteq G_1.      \tag{6}
\]
Set \(x=t(v)^*\), so its representation action is \(A^*\).
Equations (2) and (6), and \(xs=0\) by highest degree, imply
\([x,\mathfrak h^{-1,1}]s=0\).
The root-kernel theorem proves \(t(v)E=0\).
The flat differential of the whole highest Hodge space is exactly
this Higgs evaluation on \(E\). Combining it with (3) gives
\[
          \ker\Theta_{L_0+L_1,z}\subseteq\ker\Theta_{H,z}.       \tag{7}
\]

For any coefficients in the theorem, nonnegativity in (1) and
\(c_0,c_1>0\) put \(\ker\Theta_{P_c,z}\) in the left side of (7).
Equation (2a) actually identifies these two kernels. This yields the
same comparison for \(P_c\).

The suitable points suffice for **global** curvature ranks. Start at
a Hodge-generic point in the simultaneous maximum-rank opens for
\(\Theta_{P_c}\), \(\Theta_{P_c}+t\Theta_H\), and \(d\ell\).
The metrics and subspace maps are real analytic. Move only within a
small subgerm of its \(\ell\)-fiber, keeping these rank opens, until
it meets the smooth algebraic open of its closure used in (5).
This is possible by density of every subgerm in that closure.
At the resulting point the two forms attain their global maximal
ranks, and (7) makes those ranks equal, since both forms are
semipositive. No assertion that every point satisfies orbit filling
is being used.

## 5. Extensions, nefness, and numerical dimension

All subbundles in the statement have two-sided power-log Hodge norm
bounds in canonical extension frames:
\[
 C^{-1}\Lambda^{-m}h_0\leq h\leq C\Lambda^m h_0,\qquad
                \Lambda=\prod_i(-\log|z_i|).
 \tag{8}
\]
Here \(h_0\) is smooth and positive. The several-variable Hodge norm
estimate supplies (8) on its finitely many order sectors, and its
dual supplies the lower bound. After resolving the Grassmann maps,
the tautological inclusions have full rank in locally free extended
Hodge grades. Restriction therefore preserves both inequalities.
Their determinants, duals, and tensor products have two-sided
log-log weights. Boundary resolution does not allow an arbitrary
divisorial twist: it is essential that these are the indicated
tautological subbundles in the pulled-back unipotent Hodge extensions.
Unipotent extensions commute with the resolved pullback; in monomial
boundary coordinates the residues are sums of the old commuting
nilpotent residues.

For reference the analytic-to-numerical fact needed here is:
if a rational line \(L\) on a smooth projective \(n\)-fold has a
smooth semipositive curvature form \(\Theta\) off an SNC divisor and
two-sided log-log weights, then it is nef and
\[
 \int_{B^\circ}\Theta^k\eta^{n-k}
                      =c_1(L)^k[\eta]^{n-k}\quad(0\leq k\leq n).
 \tag{9}
\]
Consequently \(\nu(L)=\max\operatorname{rank}\Theta\).
Here is why a boundary mass has not been silently discarded.
Adding \(\epsilon\sum\log|z_i|\) to a local weight extends it as
a plurisubharmonic function. The maximum principle on coordinate
polydiscs bounds those extensions uniformly above as
\(\epsilon\downarrow0\); their increasing limit extends the weight.
The log-log lower bound along radial approaches gives zero Lelong
numbers. The zero-Lelong regularization consequence gives nefness.

For a Kähler representative \(\omega_\epsilon\) of
\(c_1(L)+\epsilon[\eta]\), the resulting global potential \(\phi\)
is less singular than
\(\psi=-\delta\sum_i u_i^b\), where \(u_i=-\log\|s_i\|^2\geq1\)
and \(0<b<1\). Choose \(\delta>0\) so small that \(\psi\) is
\(\omega_\epsilon\)-plurisubharmonic.
Concave smooth truncations \(f_R(u_i)\) of \(u_i^b\), constant for
\(u_i\geq2R\), have uniformly bounded derivatives
\(0\leq f'_R(u)\leq C u^{b-1}\) and
\(0\leq-f''_R(u)\leq C u^{b-2}\).
The smooth truncated curvature forms are dominated in boundary
coordinates by a constant times
\[
 \eta_0+\sum_i
       \frac{\sqrt{-1}\,dz_i\wedge d\bar z_i}
                  {|z_i|^2(-\log|z_i|)^{2-b}} .
\]
Its top power is integrable: each singular summand has rank one,
and its normal integral is
\(\int^\infty u^{b-2}du<\infty\).
Dominated convergence and Stokes show that \(\psi\) has full
Monge--Ampere mass. The full-mass class is closed under passing
to less singular potentials, so \(\phi\) has full mass too.
Thus
\(\int(\Theta+\epsilon\eta)^n=(c_1(L)+\epsilon[\eta])^n\).
Nonnegativity makes every mixed integral finite; comparison of
coefficients for all \(\epsilon>0\) proves (9).
For a smooth semipositive form, a mixed integrand in (9) is positive
somewhere exactly when the curvature rank is at least \(k\)
somewhere, which proves the numerical-dimension assertion.

Apply (9) to each \(L_j\), using (1) and (8), and to \(P_c+tH\).
This proves nefness and converts the maximal-curvature-rank equality
from Section 4 into \(\nu(P_c+tH)=\nu(P_c)\).
The pointwise common-kernel theorem (2a), followed by (9), gives the
additional equality \(\nu(P_c)=\nu(L_0+L_1)\).
The zero-dimensional case uses the empty-product convention.
All conclusions concern the level specified in the proposition;
ordinary pullback of a nef rational line and the projection formula
give the usual descent under a generically finite level map.
This completes the classical proof. \(\square\)

## 6. External inputs and their delivery status

These are mathematical dependencies, not conclusions of the Python checker.
They must be read with their hypotheses before independent acceptance.

| Input | Source and locator | Current scope |
|---|---|---|
| Connected monodromy normality for a good polarized variation on a smooth algebraic base | Andre, *Mumford--Tate groups of mixed Hodge structures and the theorem of the fixed part*, Compositio 82 (1992), Section 5, Theorem 1; Numdam `CM_1992__82_1_1_0` | A research reader obtained the primary statement. Pure polarized integral variations are in its setting. |
| Fixed part on a compactifiable base | Schmid, *Variation of Hodge Structure*, DOI `10.1007/BF01389674`, Theorem 7.22 | A research reader obtained the primary statement. Apply it to the rational Lie variation, not to an arbitrary nonrational local subsystem. |
| Borel fixed point | Borel, *Groupes algebriques*, Bourbaki expose 121 (1955), published 1956, Lemma 4.3; Numdam `SB_1954-1956__3__229_0` | A research reader obtained the primary statement: connected solvable algebraic group acting on a nonempty complete variety. |
| Highest-weight and primitive-line theorem | Milne, *Algebraic Groups* (2017), ISBN `9781107167483`, Theorems 22.2 and 22.18 | Primary text read; the unique Borel-fixed line has dominant highest weight, and all other weights are obtained by nonnegative simple-root lowerings. |
| Algebraic tensor realization of a monodromy reduction | Milne, same 2017 source, Theorems 4.14 and 4.27 | Primary text read: a subgroup is the stabilizer of a line in a finite-dimensional representation, and every representation of a linear group is built from a faithful one by tensors, duals, sums, and subquotients. Semisimplicity removes the line character; reductivity of the ambient general linear group realizes the needed subquotient as a summand. |
| Root strings, coroot supports, and finite-dimensional root-sl2 theory | Standard semisimple representation theory; Humphreys, Sections 9--10 and 20--21 | The exact Humphreys text was not obtained. The coroot-support fact also follows directly from \(\rho^\vee=2\rho/(\rho,\rho)\): its simple-coroot coefficient is \(c_\delta(\delta,\delta)/(\rho,\rho)\), with the same positive support. |
| Several-variable canonical Hodge norm bounds | Cattani--Kaplan, *Degenerating variations of Hodge structure*, Asterisque 179--180 (1989), Theorem 5.1, pp. 86--87 | Primary text and formula read. It gives the sector metric comparison; (8) follows by bounding the finitely many ratio powers and the finite canonical untwisting polynomial, and applying the same bounds to the dual. |
| Zero-Lelong regularization consequence | Demailly, *Regularization of closed positive currents and intersection theory* (1992), Corollary 6.4 | The author-hosted URLs timed out and the author-posted mirror returned HTTP 403. The quoted corollary from web-search output was not treated as a verified primary reading. This standard regularization consequence remains an explicitly uncited dependency. |
| Full-mass stability under a less singular potential | Guedj--Zeriahi, arXiv `math/0612630v2`, Proposition 1.6, p. 7 | Primary proposition read: if \(\varphi\in\mathcal E(X,\omega)\), \(\psi\) is \(\omega\)-psh and \(\varphi\leq\psi\), then \(\psi\in\mathcal E(X,\omega)\). Adding a constant handles the comparison used above. |
| Algebraicity of flat invariant tensors for regular-singular connections | Deligne, *Equations differentielles a points singuliers reguliers*, Chapter II, Section 6 | Used only for the algebraic monodromy reduction. The source endpoint returned HTTP 403; the dependency remains explicitly uncited, not independently attributed. |

Primary excerpts obtained by the separate research reader are transcribed
with their provenance in `literature/primary-excerpts.md`; the additional
norm, highest-weight, and full-mass excerpts were read by the engineer.
Independent citation attribution is not inherited from the author of an
assumption and is still owed at review. In this mission the writable
literature directory is `research/higgs-tail-audit/literature/`; the default
`citation_check attribute` archive is outside the assigned write boundary,
so no out-of-scope archive was created.

## 7. Exact replay

Run from any working directory:

```bash
python3 families/033/first-pass/higgs-tail-audit/verify.py
```

Only the Python standard library is needed. The script re-expands every
free-algebra derivation and checks its **mathematical target**, checks both
inverses and the reduction in the arbitrary-size block rank certificate,
and reconstructs the explicit adjoint action from the original \(4\times4\)
matrix units. It then independently replays the saved typed Jacobian
rank answer against that reconstructed map. No network service is needed
for this replay. Sign-mutated proofs and a sign-mutated rank eliminator
are required to fail, as is an induction rule over the wrong generated
span. The induction hypothesis is scoped to the step, and the adjoint
annihilation of \(U_0\) is derived after that step and its base have
been checked, rather than admitted as a free hypothesis.
The exact adapter request, server version, protocol,
typed answer, and exit status are retained in the dedicated JSON files.

`exact_certificate.json` identifies `C_TAIL_KERNEL` as its local
common-kernel assertion and `C_COMMON_TAIL_DIMENSION` as the associated
geometric theorem. It does not label the full geometric theorem
kernel-checked, does not certify external references, and does not
silently promote an engineer's proof to an independent review.

No staged literal assertion has been established false in this audit.
Accordingly there is no refutation claim to relabel as a refutation of
the main logarithmic theorem. The failed diagonal-only route is recorded
as such, separately from the verified full-quantifier root argument.
