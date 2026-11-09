# All-split adjoint divergence: mathematical audit

## Scope settled before the proof

The target is `thm:tensor-divergence` in the staged September 26, 2026
manuscript, including `eq:network-degree-count`,
`eq:divergence-single-trace`, and the material-derivative consequence
`cor:path-derivatives`. The sampling theorem and numerical compiler are not
certified by this bounded mission.

The actual primitive hypotheses are important. Here \(d\geq2\),
\(F\in C^2(\mathbb R^d)\), \(\operatorname{Lip}(\nabla F)\leq\lambda\),
\(0<r\leq1\), \(L=\lambda r>0\), \(l=rL\leq1/2\), and the center
\(x\) is arbitrary. Convexity of \(F\) and a bound on \(\nabla F(x)\)
are not assumed. With
\[
 \nu(dz)\propto e^{-|z|^2/2-F(x+rz)}\,dz,\quad
 Y=\rho Z+\sqrt a\,N,\quad a=1-\rho^2,\quad 0\leq\rho<1,
\]
the density of \(Y\) is \(e^{-H_\rho}\), and
\(M_\rho(y)=\mathbb E[\nabla F(x+rZ)\mid Y=y]\).
The tensor \(U_q=\rho^{-q}\nabla^qM_\rho\) is extended at zero by
its conditional-cumulant formula. A split always partitions *all*
coordinate slots into two nonempty groups, with Euclidean norms on
the corresponding tensor powers.

An expression starts with \(U_q/L\) of weight \(q-1\), allows slot
permutations and one-index contractions between distinct factors, and
allows an adjoint divergence only when at least two output slots remain.
The asserted bound, for each fixed expression \(E\) of weight \(k\), is
\[
 \big\||\nabla^jE|_{\rm split}\big\|_{L^p(\xi_\rho)}
 \leq C_E^{j+1}(p+j+\log(d+1))^{C_E(j+1)}
                 (\sqrt a)^{-k-j}.
\]
Its quantifiers include every \(j\geq0\), every real \(p\geq2\), and
uniformity in \(d,\rho,F,x,r,\lambda\) subject to the stated hypotheses.
Finite tests, a Gaussian calculation, or an orientation lemma on its own
would not establish this assertion.

The needed input propositions are the all-split conditional jet and score
estimates in `prop:gaussian-jets`, the conditional Poincare inequality in
`lem:convex-preliminaries`, and the three identities in
`lem:material-identities`. These are recorded explicitly in the claim
ledger rather than silently treated as formalized results.

The existing claim ledger contained only the campaign objective, with no
earlier mathematical certificate. No pertinent log-concave/tensor
divergence result was found in the inherited Wiki index. The staged
manuscript, not a reconstruction from an abstract, fixes the target.

### Literature boundary

A separate bounded source lookup obtained Chen--Chewi--Lu--Zhang,
*Sharp Gaussian Divergence and Bernstein--Markov Inequalities*,
[arXiv:2609.32851v1](https://arxiv.org/abs/2609.32851v1).
Theorem 1.1 and Corollary 1.4 concern standard Gaussian measure and
Hilbert/Hilbert--Schmidt target and derivative norms. In particular,
Corollary 1.4 says, for a finite-dimensional real Hilbert space
\(\mathcal H\), \(p\geq2\), and
\(V_i\in W^{1,p}(\gamma_d;\mathcal H)\),
\[
 \|\delta V\|_{L^p(\gamma_d;\mathcal H)}
 \leq \sqrt p\,\|\mathbb EV\|_{\mathcal H^d}
       +48p\,\|DV\|_{L^p(\gamma_d;\mathcal H^{d\times d})}.
\]
Both product-space norms on the right are Hilbert sums. This is not an
all-split operator-norm bound and does not apply directly to
\(\xi_\rho\). The manuscript itself makes that distinction; no citation
misapplication has been identified here.

The shortcut of citing this Gaussian theorem to close the target is
therefore retired. Two targeted primary-source searches did not locate a
matching non-Gaussian all-split result. That bounded negative lookup does
not establish novelty. The present proof will not assume a result from
either search.

## 1. General theorem, beyond the conditional-jet setting

The following statement concerns arbitrary smooth tensor fields, not just
formulas made from conditional jets. It separates the analytic inputs from
the graph argument and gives an explicit finite-moment inequality.

Let \(d\geq2\), let \(\mu(dy)=e^{-H(y)}dy\) be a probability measure
with Gaussian tails, and let \(H\) and a tensor field \(V\) be smooth.
Assume all derivatives used below have polynomial growth. The field \(V\)
has \(v\geq3\) coordinate slots, one distinguished for the adjoint
\[
 \delta_H V=\sum_i(H_iV_i-\partial_iV_i).
\]
Derivative slots are labeled, and splits include the distinguished slot
before it is removed. Write
\[
 K_{t,n}=\max_{\text{nontrivial splits }S}
                  \big\||\nabla^t V|_S\big\|_{L^n(\mu)},\qquad
 B_h=\max_S\big\||\nabla^h\nabla^2H|_S\big\|_\infty.
\]
The maximum is **outside** the \(L^n\) norm. No estimate for a random
maximum over splits is needed.

**Theorem A (exact finite-moment transfer).** Fix \(j\geq0\), an even
integer \(n\geq2\), and a split of
\(T=\delta_H(\nabla^jV)\). If its smaller side contains \(b\) slots,
then
\[
 \big\||T|_S\big\|_{L^n}
 \leq d^{b/n}(3n)
 \max_{\substack{0\leq w\leq n/2,\ e_i,h_u\geq0\\
                  \sum_{i=1}^{n}e_i+\sum_{u=1}^{w}h_u+2w=n}}
       \left(\prod_{i=1}^{n}K_{j+e_i,n}
                         \prod_{u=1}^{w}B_{h_u}\right)^{1/n}.
 \tag{A}
\]
An empty Hessian product equals one. If a supremum in this statement is
infinite, the inequality is interpreted in the extended nonnegative
reals; the applications below have finite inputs.

**Theorem B (all-order closure).** Put \(D=\log(d+1)\), and let
\(k\geq0\) be an integer and \(0<\tau\leq1\). Suppose, for constants
\(A,B\geq2\), all \(t\geq0\), all real \(q\geq2\), and all \(h\geq0\),
\[
 K_{t,q}\leq A^{t+1}(q+t+D)^{A(t+1)}\tau^{-(k+t)},\qquad
 B_h\leq B^{h+1}(h+1)^{B(h+1)}\tau^{-h}.
 \tag{B}
\]
There is a constant \(C=C(A,B,v)\), independent of \(k,\tau,d,j,p\),
such that, simultaneously for every \(j\geq0\), every real \(p\geq2\),
and every split,
\[
 \big\||\nabla^j\delta_H V|_S\big\|_{L^p(\mu)}
 \leq C^{j+1}(p+j+D)^{C(j+1)}\tau^{-(k+j+1)}.
 \tag{C}
\]
The hypotheses need no Gaussian reference measure and no positivity of
the Hessian. Gaussian tails and growth are used only to justify finite
integrations by parts; the displayed norm estimates supply the uniform
constants. The rank \(v\) is fixed, but \(j\) and \(p\) are not.

## 2. Exact integration-by-parts closure

Unfold \(T\) across the chosen split and take the trace moment on its
smaller side. The singular values give
\[
 |T|_{\rm op}^{n}\leq
       \operatorname{tr}((T^*T)^{n/2}).
 \tag{2.1}
\]
If the smaller side is the other side, interchange \(T\) and \(T^*\).
The coordinate expansion has \(n\) labeled primary factors in an
alternating cycle. Each original bundle is nonempty. Each factor is an
adjoint applied to its inside field \(\nabla^jV\).

Always process the least labeled remaining adjoint, say \(i\). By
adjointness its distinguished index differentiates the product of the
other primary factors and any Hessian factors already present; it never
differentiates its own inside field. There are exactly three kinds of
successors:

1. A derivative on another primary's inside field adds one derivative
   there and joins two distinct primaries by a new index.
2. On another remaining adjoint, the identity
   \[
    \partial_a(\delta_H W)
     =\delta_H(\partial_aW)+(\partial_a\partial_bH)W_b
   \]
   gives the preceding derivative successor and a second successor.
   The latter consumes both adjoints and introduces one Hessian joined
   to their two distinct primary factors.
3. A derivative on an existing Hessian adds one derivative to it and
   joins it to the currently processed primary.

Partial derivatives already present in an inside field do not affect
this classification: the commutator formula applies to that entire
smooth field. In particular, one must not expand the internal formula
of \(V\) at this stage.

If \(a_{\rm act}\) adjoints remain, \(e=\sum e_i\) derivatives have
been added to primaries, \(h=\sum h_u\) to Hessians, and \(w\)
Hessians have been born, the invariant is
\[
 a_{\rm act}+e+h+2w=n. \tag{2.2}
\]
It starts at \((n,0,0,0)\). The three transitions change these resources
by \((-1,1,0,0)\), \((-1,0,1,0)\), and \((-2,0,0,1)\),
respectively. They preserve (2.2) exactly. Termination gives
\[
 \sum e_i+\sum h_u+2w=n, \tag{2.3}
\]
which is the manuscript's `eq:network-degree-count`.

All original trace bundles survive. No newly created edge is a
self-loop, and no Hessian--Hessian edge appears. Every Hessian retains
its two distinct creating primary neighbors even after later
derivatives. These assertions follow inductively from the same three
successors, not from a drawing of a representative graph.

The number of targets at one step is at most
\[
 (n-1)+(a_{\rm act}-1)+w\leq3n.
\]
The middle summand accounts for the second commutator successor at a
remaining adjoint. Every successor consumes at least one active
adjoint. Thus the expansion tree has depth at most \(n\), branching
at most \(3n\), and at most \((3n)^n\) terminal terms. Keeping
labeled terms avoids any unrecorded multiplicity when equal tensors
occur repeatedly.

## 3. Universal contraction bound, with one trace only

Cut a bundle of \(b\) indices on the smaller side of the original
cycle. What remains of that cycle is a chain through all \(n\)
primaries. Order primaries along the chain. For each Hessian, insert
it after its earliest primary neighbor and before the next primary.
It is then strictly before its latest primary neighbor, since those
neighbors are distinct. Order multiple Hessians in one interval
arbitrarily. There are no edges between them.

Orient every uncut index from the earlier endpoint to the later
endpoint. Every interior primary has both an incoming and an outgoing
chain bundle; the cut inputs and outputs give the missing side at the
two endpoints. Every Hessian has an incoming index from its earliest
neighbor and an outgoing index to a later neighbor. Therefore **each
factor is used across a nontrivial split**, including high-order
derivative slots and every newly introduced divergence index.

To see the contraction without assuming the graph is a tree, let the
retained coordinate space consist of all edges whose earlier endpoint
has been processed and whose later endpoint has not. Start with the
\(b\) cut inputs. At each vertex, permute the retained coordinates
to place its incoming indices together, apply its unfolding to these
indices with the identity on the carried indices, and permute the
result. This sums precisely its incoming indices, once each.
Continue through all vertices. Only the \(b\) cut outputs remain.

Every permutation is an isometry. For a finite Euclidean map \(A\),
\(\|A\otimes I\|\leq\|A\|\): write an input as
\(\sum_c x_c\otimes e_c\) in an orthonormal basis for the carried
space and sum \(\|Ax_c\|^2\leq\|A\|^2\|x_c\|^2\).
Submultiplicativity therefore gives
\[
 \|Q\|\leq
  \prod_i|\nabla^{j+e_i}V|_{S_i}
  \prod_u|\nabla^{h_u}\nabla^2H|_{S_u}.
 \tag{3.1}
\]
The original coordinate sum is exactly \(\operatorname{tr}Q\).
For an orthonormal basis of its \(d^b\)-dimensional space,
\[
 |\operatorname{tr}Q|
 \leq\sum_c|\langle e_c,Qe_c\rangle|
 \leq d^b\|Q\|. \tag{3.2}
\]
This proves `eq:divergence-single-trace`. Additional undirected cycles
do not create additional traces: their indices have already been
summed by the displayed sequence of maps. Large intermediate retained
spaces do not incur a dimension penalty because the carried maps are
identities, not partial traces.

Taking absolute values term by term, applying Holder with exponent
\(n\) to **exactly the \(n\) primary factors**, and bounding Hessians
pointwise gives (A), using the terminal term count. A split chosen by
this ordering depends on the finite graph, not on \(y\). Thus the
maximum-outside-\(L^n\) convention for \(K_{t,n}\) is sufficient.

## 4. High-moment bookkeeping without a fixed-order restriction

Let \(G=\max(A,B,3)\), \(X=2n+j+D\), and fix one terminal term.
All \(e_i,h_u\leq n\). Its polynomial bases in (B) are bounded by
\(X\). The total exponent before taking the \(n\)-th root is at
most \(G\) times
\[
 n(j+1)+\sum e_i+\sum(h_u+1)
 =n(j+1)+n-w
 \leq2n(j+1). \tag{4.1}
\]
The scalar constants \(A,B\) can be included in the base \(GX\).
The power of \(\tau^{-1}\) is
\[
 n(k+j)+\sum e_i+\sum h_u
 =n(k+j)+n-2w
 \leq n(k+j+1). \tag{4.2}
\]
Consequently (A) implies, for \(p\leq n\),
\[
 \big\||\delta_H\nabla^jV|_S\big\|_{L^p}
 \leq d^{b/n}[GX]^{(2G+1)(j+1)}
                      \tau^{-(k+j+1)}. \tag{4.3}
\]
The factor \(3n\) in (A) was absorbed using \(3n\leq GX\).
This argument sums the *actual* derivative degrees. Replacing all
\(e_i\) by their separate worst case \(n\) would give a false
quadratic exponent in \(n\); no such replacement is made.

Choose the even integer
\[
 n=2\left\lceil\frac{p+2bD}{2}\right\rceil .
\]
Then \(n\geq p\), \(d^{b/n}\leq e^{1/2}\), and
\(n<p+2bD+2\). Since the output has \(v+j-1\) slots,
\(b\leq(v+j-1)/2\). With \(Z=p+j+D\),
\[
 X\leq(4v+12)Z^2.
\]
For example any
\[
 C\geq\max\{4G+2,\ e^{1/2}[G(4v+12)]^{\,2G+1}\}
\]
absorbs (4.3) into the shape (C) for
\(\delta_H\nabla^jV\). This choice depends on neither \(j,p,d\)
nor the weight \(k\).

It remains to put the derivatives outside the adjoint. Commuting the
\(j\) labeled derivatives gives
\[
 \nabla^j\delta_H V=\delta_H\nabla^jV+
    \sum_{\varnothing\ne S\subseteq\{1,\ldots,j\}}
       (\nabla^{|S|+1}H)*\nabla^{j-|S|}V. \tag{4.4}
\]
Each star is a single-index contraction between two different
factors, each retaining a slot. The two-factor unfolding argument is
elementary: orient their contracted index so a factor with all free
slots on one side puts the contracted slot on the other side.
Conflicting requirements would put every output slot on one side,
which is excluded. Composition with identity maps then bounds each
output split by the product of the two chosen nontrivial input splits.

The term indexed by \(S\), \(|S|=h\geq1\), is bounded by
\(B_{h-1}K_{j-h,p}\). Its \(\tau^{-1}\) degree is only
\(k+j-1\). The sum has at most \(2^j\) terms, and its polynomial
degree is \(O_{A,B}(j+1)\) with base at most \(p+j+D\).
Enlarging \(C(A,B,v)\) proves (C) as stated. This completes the
universal theorems.

## 5. Formal core and its exact boundary

`Main.lean` and `statement_fidelity.md` encode the universal
resource/history and branching model. The real Lean 4.31.0 compiler
and axiom audit returned exit code zero with `proof_holes=[]`.
The source-bound record is `lean/lean_check.json`, with an archived
claim certificate under `lean/certificates/`.

The declarations include
`DivergenceAudit.History.resource_invariant`,
`DivergenceAudit.high_trace_moment_core`, and
`DivergenceAudit.root_leaf_bound`. They establish conservation for
arbitrary legal histories, the terminal degree equation, the two
uniform exponent budgets, the depth bound, and the universal
branching-tree leaf bound. The connection from actual analytic
integration by parts to that resource model is the proof in Section 2.
The count-only tree permits \(n\), rather than \(n-1\), primary
targets, so it conservatively includes a dummy target that the actual
adjoint expansion excludes. It is an over-approximation, not a
formal identification with the tensor graph.

This is **not** a Lean formalization of integration by parts, operator
norms, conditional Poincare, the jet estimates, or sampling. In
particular, successful compilation of this core cannot certify the
reading of the analytic theorem; independent mathematical review is
still required.

## 6. Specialization to every allowed expression

Take \(\tau=\sqrt a\). Section 7 supplies the pointwise jet bound and
Hessian bounds under the actual primitive assumptions. For a leaf of
order \(q\), spatial differentiation gives
\[
 \nabla^j(U_q/L)=\rho^j U_{q+j}/L.
\]
For fixed \(q\), its bound has the required form with weight \(q-1\)
and one constant depending only on \(q\), uniformly for all \(j,p\).

Proceed by induction on the finite expression tree. Permutations
only relabel splits. A contraction of two expressions distributes
the \(j\) labeled derivatives by Leibniz. There are at most \(2^j\)
summands. The two-factor bound in Section 4, Holder at exponents
\(2p,2p\), and the two inductive estimates give weight
\(k_1+k_2\), derivative degree \(j\), and a polynomial exponent
bounded by a constant times \(j+1\). For an adjoint, its inside
field has at least three slots, so Theorem B applies and increases
the weight by one. Its constant depends only on the already fixed
inside formula and its number of slots.

The induction is over expression construction, not over \(j,p\).
It proves exactly the simultaneous quantifiers and uniformity in
`thm:tensor-divergence`. No hidden restriction to fixed moments or
derivative orders is introduced.

## 7. Deriving, rather than assuming, the primitive input estimates

Here is the analytic input independently checked in this audit.
First, a \(C^2\) potential \(J\) with
\(mI\preceq\nabla^2J\preceq MI\), \(m>0\), has Poincare
constant at most \(1/m\). For completeness, run the diffusion with
generator \(\Delta-\nabla J\cdot\nabla\). Strong monotonicity
contracts synchronously coupled solutions by \(e^{-mt}\).
For a smooth compact test \(h\), differentiation of the flow gives
\[
 |\nabla P_t h|^2\leq e^{-2mt}P_t|\nabla h|^2.
\]
Integration by parts makes \(e^{-J}\) invariant. The same
contraction, coupling to an invariant start, gives
\(P_th\to\mu h\) in \(L^2(\mu)\). Differentiating
\(\int(P_th)^2\,d\mu\) and integrating over \(t\) yields
\[
 \operatorname{Var}_\mu h
 =2\int_0^\infty\!\int|\nabla P_th|^2\,d\mu\,dt
 \leq m^{-1}\int|\nabla h|^2\,d\mu.
\]
These steps first apply after smooth mollification, when all drift
derivatives of order at least one are bounded. Mollification
preserves \(m,M\); globally Lipschitz gradients converge uniformly,
the laws converge by quadratic Gaussian domination, and synchronous
solutions converge on compact time intervals by Gronwall. Thus
invariance and Poincare pass to \(C^2\) potentials. Cutoff and
approximation extend the inequality to \(C^1\) tests of polynomial
growth with square-integrable gradients. This supplies the input
needed for the nonsmooth-in-higher-orders \(f\), without assuming
derivatives of \(F\) beyond order two.

For the conditional law of \(Z\) given \(Y=y\), the potential is
\[
 J_y(z)=|z-\rho y|^2/(2a)+F(x+rz).
\]
Its Hessian is between \(a^{-1}-l\) and \(a^{-1}+l\); hence its
Poincare constant is at most \(2a\). The map
\(z\mapsto S(z)=(z,f(z)/L)\) has derivative norm at most
\(\sqrt2\). Pulling back an ambient polynomial proves Poincare
for \(S\) with constant \(\beta\leq4a\), even though this
ambient law may be singular. Its moment generating function is
finite near zero because \(f\) is Lipschitz and the conditional
law has Gaussian tails.

We spell out the dimension-free all-split cumulant step. Define
Appell tensors by
\[
 P_t(s)=\left.\nabla_\theta^t
       \frac{e^{\theta\cdot s}}{\mathbb Ee^{\theta\cdot S}}
                    \right|_{\theta=0}.
\]
For a coefficient tensor \(W\) of order \(t\), the scalar
\(Q_W=W:P_t\) satisfies
\(\mathbb E\nabla^h Q_W(S)=0\) for \(0\leq h<t\) and
\(\nabla^tQ_W=t!\operatorname{Sym}W\).
Repeated scalar Poincare, componentwise in these ambient polynomial
derivatives, gives
\[
 \mathbb E|W:P_t(S)|^2
       \leq\beta^t(t!)^2|W|_F^2. \tag{7.1}
\]
Only the first derivative of the pullback \(S\) is used at each
application; higher derivatives of \(f\) are not taken.

The cross-moment tensor
\(\mathbb E[P_u(S)\otimes P_v(S)]\), as a matrix across its
two groups, consequently has norm at most
\(\beta^{(u+v)/2}u!v!\). Consider
\[
 G(\theta,\omega)=
 \frac{\mathbb Ee^{(\theta+\omega)\cdot S}}
      {\mathbb Ee^{\theta\cdot S}\mathbb Ee^{\omega\cdot S}}.
\]
Every nonzero coefficient of \(G-1\) uses both groups.
In \(\log G=\sum_{m\geq1}(-1)^{m+1}(G-1)^m/m\), a
mixed derivative of total degree \(N\) therefore factors into
cross-moment operators, with only permutations within each side.
For each assignment of labeled derivatives their product factorial
is at most \(N!\); summing over at most \(N^{N+1}\)
assignments bounds the total by \(N^{3N}\beta^{N/2}\).
Mixed derivatives of \(\log G\) equal those of the cumulant
generating function of \(S\). Thus **every** split of
\(\kappa_N(S)\) has this dimension-free bound. If \(\beta=0\),
coordinate tests instead make \(S\) constant and the claim is
immediate.

Differentiation of a conditional expectation in the linear tilt
\(\rho y/a\) gives
\[
 (U_q)_{i,k_1,\ldots,k_q}
 =a^{-q}\operatorname{cum}
       (f_i(Z),Z_{k_1},\ldots,Z_{k_q}\mid Y=y).
 \tag{7.2}
\]
Restrict the cumulant of \(S\) to one \(f/L\) coordinate and
\(q\) ordinary coordinates. Coordinate projections do not increase
any split norm. Since \(\beta\leq4a\), (7.2) gives
\[
 |U_q|_S\leq C^q q^{Cq}L(\sqrt a)^{-(q-1)}. \tag{7.3}
\]
The mean of \(S\), which may be arbitrarily large, does not enter
these bounds.

Conditional integration by parts gives
\(\mathbb E[Z\mid Y=y]=\rho y-arM_\rho(y)\), hence
\[
 \nabla H_\rho=y+r\rho M_\rho,\qquad
 \nabla^2H_\rho=I+r\rho^2U_1.
\]
For \(h\geq1\),
\(\nabla^h\nabla^2H_\rho=r\rho^{h+2}U_{h+1}\).
Equation (7.3) and \(rL=l\leq1/2\) give precisely the bounds
\(B_h\) in (B), with an absolute constant, and a bounded Hessian
at \(h=0\).

All conditional density derivatives in \((\rho,y)\), on a compact
interval with \(\rho<1\), insert only polynomials in \(z\).
They do not differentiate \(F\) repeatedly. The conditional mode
satisfies
\[
 z_0=\rho y-ar\,g(x+rz_0),\qquad
 |z_0|\leq2(\rho|y|+ar|g(x)|).
\]
The two conditional Hessian bounds compare moments about this mode
to Gaussian integrals. Thus all fixed conditional moments and all
the differentiated ratios have polynomial growth in \(y\).
Formula (7.2) also gives the smooth extension at \(\rho=0\).
The law of \(Z\), and hence of \(Y\), has Gaussian tails.
Cutoffs consequently justify every finite integration-by-parts
identity above. Quantitative uniformity for increasing moments
comes from Sections 2--4, not from a claim that the cutoff
constants were uniform in those moments.

## 8. Material identities and the single final dimension loss

The conditional mean velocity of \(Y\) is \(-rM\).
Differentiating \(\mathbb E[f_i(Z)\phi(Y)]\) and subtracting the
mean flux leaves
\(\operatorname{Cov}(f_i(Z),Z_k\mid Y)/a=(U_1)_{i,k}\).
The continuity equation and adjointness give
\[
 \mathcal DM=\delta_{H_\rho}U_1,\qquad
 \mathcal D=\partial_\rho-rM\cdot\nabla. \tag{8.1}
\]
For \(q\) labeled derivative positions,
\[
 \mathcal D\partial_I M_i
 =\partial_I\mathcal DM_i+
 r\sum_{\varnothing\ne S\subseteq I}
          (\partial_S M_k)\partial_k\partial_{I\setminus S}M_i.
\]
On inserting (8.1), derivatives on the linear part of
\(\nabla H=y+r\rho M\) give \(qU_q/\rho\) after scaling.
This cancels \(\partial_\rho(\rho^{-q})\nabla^qM\).
The nonlinear score derivatives and the spatial/material
commutator each give the same coefficient \(r\rho\).
Consequently
\[
 \mathcal DU_q=\delta_H U_{q+1}
  +2r\rho\sum_{\varnothing\ne S\subseteq I}
          (U_{|S|})_{k,S}(U_{q-|S|+1})_{i,k,I\setminus S}.
 \tag{8.2}
\]
This verifies the sign, the factor two, and the labeled-subset
multiplicities, rather than merely testing them on quadratics.

The continuity equation gives
\(\mathcal DH=-r\,\operatorname{div}M\).
Since
\([\mathcal D,\partial_i]=r(\partial_iM_j)\partial_j\),
direct differentiation of \(\delta_H V\) yields
\[
 \mathcal D(\delta_H V)
 =\delta_H(\mathcal DV)
       +r\delta_H((DM)V), \tag{8.3}
\]
where \(DM\) acts on the divergence slot. The zero-time extensions
follow from (7.2), not from substituting into an uncancelled
\(1/\rho\) expression.

Apply (8.1)--(8.3), the product rule, and slot permutations to
normalized leaves. Each material differentiation raises weight by
at most two. Every additional normalized jet leaf comes with a
factor \(rL=l\); coefficients are bounded polynomials in
\(\rho,l\) after any fixed number of differentiations.
All inner adjoints retain at least two slots and all contractions
retain a free slot in each factor. Thus for fixed \(m,q,p\),
\[
 \big\||\mathcal D^mU_q|_S\big\|_p
 \leq C_{m,q,p}(1+\log(d+1))^{C_{m,q,p}}
                  L(\sqrt a)^{-(q-1+2m)}. \tag{8.4}
\]
Here, as in the actual corollary, constants may depend on the
fixed material order \(m\), jet order \(q\), and \(p\).
This is distinct from the simultaneous \(j,p\) quantifiers for a
fixed expression in the tensor theorem.

For the mean, leave the first, vector-producing adjoint outermost.
After \(m-1\) further material differentiations,
\(\mathcal D^mM\) is \(L\) times a finite sum of
\(\delta_HW\)'s with rank-two inside expressions \(W\) of
weight at most \(2(m-1)\) and uniformly bounded coefficients.
For a smooth vector field the exact identity
\[
 \int(\delta_HW)^2\,d\mu
 =\int\sum_{i,j}
   \big[(\partial_iW_j)(\partial_jW_i)+H_{ij}W_iW_j\big]\,d\mu
\]
implies
\(\|\delta_HW\|_2^2\leq\|\nabla W\|_{F,2}^2+
\|\nabla^2H\|_\infty\|W\|_{F,2}^2\).
For tensor output, sum it over the remaining indices. Cutoff and
Fatou give the same inequality for the polynomial-growth fields
here.

A one-slot-versus-rest unfolding has at most \(d\) singular
values, so its Frobenius norm is at most \(\sqrt d\) times its
operator norm. Apply the tensor theorem with \(j=0,1\), \(p=2\).
This gives the slightly sharper intermediate estimate
\[
 \|\mathcal D^mM\|_2
 \leq C_m(1+\log(d+1))^{C_m}
                    L\sqrt d\,a^{-(m-1/2)}
 \leq C_m(1+\log(d+1))^{C_m}L\sqrt d\,a^{-m}.
 \tag{8.5}
\]
The sharper intermediate power is already visible in the
manuscript's proof; it is not claimed as a new improvement.
Equations (8.4)--(8.5) verify the displayed material-derivative
consequence. Conditional mean velocity and its bounded spatial
Lipschitz constant identify the transported marginals, so these
are the required pathwise-in-time \(L^2\) bounds, not bounds on an
expected supremum of a random trajectory.

## 9. Exact replays, interpretation, and reproducibility

Run from the campaign root:

```sh
$WORKSPACE/argus-live-update/.venv/bin/python research/divergence_audit/verify.py
```

The standalone script uses Python and SymPy, not the Argus package.
It enumerates the complete labeled integration-by-parts expansions
at moments two and four; checks every graph invariant and every
nontrivial split in the chosen schedules; and independently
compares direct coordinate summation with carried-coordinate matrix
composition. It also checks the trace bound on rational rank-one
factors whose selected split operator norms are exactly one.
These are finite adversarial tests of the proof's construction,
not the reason its universal quantifiers hold.
The completed replay has two terminal terms at moment two and 165
at moment four, hence 167 schedules and 334 exact coordinate-versus-
composition comparisons. The non-Gaussian expectations are respectively
\[
 \frac{265725755361}{40000000000},\qquad
 \frac{105284665050880538434315649388200650828192383}
      {163840000000000000000000000000000000000}.
\]
The terminal scalar expansions have two and nine distinct degree
profiles. These numbers, the saved typed Jacobian result, and the
source-bound Lean verdict are replayed by `exact_certificate.json`.

The non-Gaussian example is genuinely admissible:
\[
 F(z)=-\sum_i\log(1+z_i^2/8),\quad x=0,\quad r=1,\quad
 \lambda=1/4,\quad d=16,\quad e=1/2.
\]
For \(u=z_i^2/8\geq0\), the inequalities
\((1+u)^2\mp(1-u)\geq0\) prove
\(|\partial_{ii}F|\leq1/4\). Thus the declared Lipschitz and
\(l\leq1/2\) requirements hold, although \(F\) is not convex.
Gaussian convolution gives a product density with one-dimensional
weight
\[
 w_\rho(y)=1+\tfrac18(1-\rho^2)+\tfrac18\rho^2 y^2,
 \qquad M_\rho(y)=-\frac{\rho y}{4w_\rho(y)}.
\]
At \(\rho=3/5\), \(w=27/25+(9/200)y^2\).
Writing \(u=y^2/24\), the identities
\((1+u)^2-(1-u)=u^2+3u\) and
\((1+u)^2+8(1-u)=(u-3)^2\) certify
\[
 11/12\leq H_\rho''\leq97/96.
\]
The script integrates the moment-two and moment-four expansions
exactly against this non-Gaussian law, using polynomial fields
\(w^n(1+y)\) and exact Gaussian moments. Derivatives of \(w^n\)
cancel all Hessian denominators, so these are rational
computations, not numerical quadrature. A rank-three tensor
\(V_{ijk}=w(y_1)^n(1+y_1)B_{ij}\mathbf1_{k=1}\)
embeds the one-dimensional check into the actual tensor setting in
dimension sixteen.

The same family checks the material identities as exact rational
identities in \((\rho,y)\), including jet orders one to three,
the adjoint commutator, and the continuous extensions at zero.
This family check is supplementary to the universal derivation
in Section 8. Rational identities are computed in the exact fraction
field \(\mathbb Q(\rho,y)\), not by floating-point evaluation.

The single bounded Jacobian call was inspected before execution:
`matrix.partial_trace.compute`, server version `0.14.0`,
protocol `2025-11-25`. Its exact input, output, and adapter status
are `jacobian_payload.json`, `jacobian_output.json`, and
`jacobian_status.json`. For the Hessian-birth term at \(y=(0,1)\),
take
\[
 A_1=\begin{pmatrix}1&2\\0&1\end{pmatrix},\quad
 A_2=\begin{pmatrix}0&1\\-1&1\end{pmatrix},\quad
 Q=\tfrac{11}{12}A_1A_1^T+\tfrac{579}{625}A_2A_2^T.
\]
Tracing its two-dimensional cut space gives exactly
\(\operatorname{tr}Q=10349/1250\), as the typed output records.
This operation checks an actual closing contraction. It is not
presented as proof of the divergence theorem.

`verify.py` also checks that the current Lean source and
statement-fidelity document still match the compiler's recorded
digests; it does not manufacture or rerun a compiler verdict.
A fresh compile, when either source changes, is obtained with

```sh
$WORKSPACE/argus-live-update/.venv/bin/python \
  -m argus_skill.verticals.math.lean_evidence verify \
  research/divergence_audit/Main.lean \
  --statement-fidelity research/divergence_audit/statement_fidelity.md \
  --claim C_DIV_LEAN_CORE --project-root . \
  --artifact-dir research/divergence_audit/lean
```

## 10. Outcome and open obligations

The mathematical deliverable is Theorems A--B, a general
non-Gaussian all-split transfer principle, with a complete
specialization proving the audited tensor bound and its
material-derivative consequence. It is stronger in scope than a
fixed-expression verification: the inside field is arbitrary and
the law need not arise from Gaussian interpolation.

No false literal manuscript assertion was found in the audited
steps. Accordingly there is no invented `F_` refutation claim.
Nor is there a claim that finite tests refute or verify the
sampling theorem. The numerical compiler, noise-removal
reduction, and global query-complexity result remain open in the
proof graph.

The universal analytic proof, statement fidelity, significance,
and novelty are submitted to the Host-invoked independent
Reviewer. The bounded literature lookup has **not** established
`novelty_status=verified_new`, and no independent acceptance is
recorded by the Engineer. A compiler-certified resource model is
not being substituted for that review or for campaign completion.
