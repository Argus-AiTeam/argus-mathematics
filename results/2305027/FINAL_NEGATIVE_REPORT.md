# Final exploratory negative report for campaign 2305027

**Current through independently reviewed claim C40.**

## Result class and exact conclusion

This is an **exploratory exhausted-boundary report**, not a counterexample
and not a proof of the planar Corona conjecture.

The campaign objective was to construct a planar domain \(D\), a finite tuple
\(F=(f_1,\ldots,f_m)\in H^\infty(D)^m\), and an exact \(\delta>0\) such that

\[
  \max_j |f_j(z)|\geq\delta\quad(z\in D),
\]

while no \(G=(g_1,\ldots,g_m)\in H^\infty(D)^m\) satisfies
\(\sum_j f_jg_j=1\). **No such negative witness was found.**
Claim C1 in `research/MATH_STATE.json` and the `campaign-goal` node in
`research/PROOF_GRAPH.json` therefore remain open.

What was obtained is exact and narrower. Claim C13 is the independently
reviewed aggregate of the campaign's first four exhausted families. The
subsequent route claims C14--C40 have also each received independent Reviewer
support, but they do not retroactively enlarge C13. This report now brings
those separately reviewed results into one current account. The remaining
step is an independent **report-level** verdict that this synthesis is faithful
to the objective, the reviewed scopes, and the unresolved mechanisms.

## Reviewed basis and source discipline

The report uses the following existing route artifacts and the judgements
already attached to their current claim versions in
`research/MATH_STATE.json`. No route computation or source lookup was repeated
for this report revision.

| Current claims | Reviewed route artifact | Exact role in this report |
|---|---|---|
| C2--C4, C6 | `research/routes/behrens-normal-form/EXHAUSTED_BOUNDARY.md` | Conditional localization, contractive-restriction obstruction, and the inner-exhaustion norm identity; C5 remains open |
| C7--C12 | `research/routes/nonextendable-inner-exhaustion/EXHAUSTED_BOUNDARY.md` | Explicit nonextendable complementary tuple and two impossible exact collar/product constructions |
| C14--C17 | `research/routes/proper-compatible-discrete/EXHAUSTED_BOUNDARY.md` | One proper compatible discrete algebra and the precise reason its sampled separator is not a Corona separator |
| C18--C20 | `research/routes/principal-boundary-fiber-quotient/EXHAUSTED_BOUNDARY.md` | Hyperbolic-rarity nonapplicability and exact solvability of the principal-fiber pair |
| C21--C22 | `research/routes/compatible-collar-tail-gluing/EXHAUSTED_BOUNDARY.md` | Unit-ideal theorem in the fixed-collar compatible closure |
| C23--C27 | `research/routes/order-two-blaschke-descent/EXHAUSTED_BOUNDARY.md` | Positive theorem on the C7 domain and exhaustion of the order-two parity template |
| C28 | `research/routes/oh-equivariant-scalarization/EXHAUSTED_BOUNDARY.md` | Quantified fixed-gap loss in the frozen Oh scalarization |
| C29 | `research/routes/nonradial-cech-chain/EXHAUSTED_BOUNDARY.md` | Uniform splitting on the buffered nonradial chain |
| C30 | `research/routes/critical-whitney-tail/EXHAUSTED_BOUNDARY.md` | Uniform splitting on the finite-template critical Whitney tail |
| C31--C32 | `research/routes/growing-rank-invariant-cousin/EXHAUSTED_BOUNDARY.md` | Uniform splitting and Bezout bounds for the summably localized growing-rank star family |
| C33 | `research/routes/branching-residue-current/EXHAUSTED_BOUNDARY.md` | Geometric impossibility of the nested raw-current one-point family |
| C34 | `research/routes/nonnested-weighted-period-dual/EXHAUSTED_BOUNDARY.md` | Uniform splitting and adjoint leakage for the frozen nonnested principal-part class |
| C35--C37 | `research/routes/robust-approximate-planar-assembly/SCOPE_RESULT.md` | Exact whole-domain perturbation transfer, nonplanarity of Oh's explicit hard surfaces, and equivalence of planar hard-block supply with C1 |
| C38--C39 | `research/routes/critical-diamond-planar-corona/EXHAUSTED_BOUNDARY.md` | Uniform Jones--Marshall control and complete-cocycle splitting for the frozen radial binary-radius diamond ladders |
| C40 | `research/routes/infinite-rank-automorphic-obstruction/EXHAUSTED_BOUNDARY.md` | Uniform Bezout rows and connecting-cocycle triviality for one all-hole principal-part template on the C34 domain |

The source-backed inputs are also scope-limited. Their versioned identifiers,
locators, archived excerpts, and independent attributions are recorded in
`research/MATH_STATE.json` and `research/literature/`. The principal source
extracts used by the route proofs are:

| Claims | Source proposition | Archived extract |
|---|---|---|
| C2 | Behrens's conditional disk-with-holes localization, DOI `10.1090/S0002-9947-1971-0435420-9`, Introduction, p. 359 | `research/routes/behrens-normal-form/evidence/commands/028-reconstruct-behrens-1971-introduction.output` |
| C14 | Hoffman--Narita three-condition interpolation criterion, DOI `10.2996/kmj/1138039276`, pp. 313--314 | `research/routes/proper-compatible-discrete/evidence/sources/narita-hull-criterion-excerpt.txt` |
| C17, C32 | Carleson's disk Corona theorem as stated in arXiv `2512.23733v2`, p. 1 | `research/routes/proper-compatible-discrete/evidence/sources/disk-corona-excerpt.txt` |
| C18 | Hyperbolically rare deletion theorem as reported in arXiv `1905.01532v1`, Section 1.2 | `research/routes/principal-boundary-fiber-quotient/evidence/sources/brudnyi-hyperbolically-rare-excerpt.txt` |
| C21, C22, C24, C30 | Brudnyi's finite-type covering Corona and bounded \(\bar\partial\) theorems, arXiv `math/0702801v1`, Theorems 1.1 and 1.6 | `research/routes/compatible-collar-tail-gluing/evidence/sources/brudnyi-annulus-corona-excerpt.txt`; `research/routes/compatible-collar-tail-gluing/evidence/sources/brudnyi-covering-dbar-excerpt.txt` |
| C22 | Runge approximation, arXiv `2412.04608v5`, Theorem 1.1 | `research/routes/compatible-collar-tail-gluing/evidence/sources/forstneric-runge-excerpt.txt` |
| C23, C39 | Jones--Marshall's radial deleted-disk Corona result, DOI `10.1007/BF02384430`, Theorem 2.7 and the following bounded-connectivity extension and radial example, pp. 290--291 | `research/routes/order-two-blaschke-descent/evidence/sources/jones-marshall-corona-excerpt.txt` |
| C25 | Oh's varying-surface large-bound theorem, arXiv `1307.8028v1`, Theorem 1 | `research/routes/order-two-blaschke-descent/evidence/sources/oh-finite-bordered-excerpt.txt` |
| C36 | Oh's explicit \(n\)-sheeted cover and cyclic cut-and-paste construction, arXiv `1307.8028v1`, Equation (2.3) and Remark 3, pp. 2 and 5 | `research/literature/6ffe9d0549d8b3069b07e1942876e170.json` |
| C37 | Gamelin's planar hard-block assembly, DOI `10.2140/pjm.1970.34.73`, definition of \(C_m\) and Theorem 3.4 with proof, p. 79 | `research/routes/robust-approximate-planar-assembly/evidence/sources/gamelin-hard-block-excerpt.txt` |
| C31 | Finite circle-domain rigidity as recorded in arXiv `1511.07348v1`, Section 1 | `research/routes/growing-rank-invariant-cousin/evidence/sources/finite-circle-rigidity-excerpt.txt` |

Behrens localization says where a hypothetical failure may be sought; it does
not provide a failure, a gluing theorem, or norm preservation. Likewise,
nonapplicability of a positive theorem is not negative evidence. The read-only
2026 source audit at `../../../status-evidence/2305027/README.md` labels the
general problem open, but no theorem below depends on that status label.

## Exhausted family 1: exact outer-stage restrictions

Let

\[
  \Delta_k=\overline{B(a_k,r_k)}
      \Subset\mathbb D\setminus\{0\}
\]

be pairwise disjoint, locally finite in
\(\mathbb D\setminus\{0\}\), accumulating only at \(0\), with

\[
  \Omega_N
   =\mathbb D\setminus\left(\{0\}\cup\bigcup_{k=1}^N\Delta_k\right),
  \qquad
  \Omega_\infty
   =\mathbb D\setminus\left(\{0\}\cup\bigcup_{k=1}^\infty\Delta_k\right)
\]

connected. For a domain \(U\), define

\[
  \beta_U(F)=\inf\left\{
      \max_j\|G_j\|_{\infty,U}:
      G\in H^\infty(U)^m,\ \sum_jF_jG_j=1
    \right\},
\]

with value \(+\infty\) if no solution exists.

The exhausted family consists exactly of tuples obtained from one solved
outer stage:

\[
  F^{(N)}=F^{(1)}|_{\Omega_N},\qquad
  F^{(\infty)}=F^{(1)}|_{\Omega_\infty},\qquad
  \beta_{\Omega_1}(F^{(1)})<\infty.
\]

Every near-minimal solution on \(\Omega_1\) restricts to every later domain,
and restriction is contractive. Hence

\[
  \beta_{\Omega_N}(F^{(N)})
      \leq\beta_{\Omega_1}(F^{(1)}),\qquad
  \beta_{\Omega_\infty}(F^{(\infty)})
      \leq\beta_{\Omega_1}(F^{(1)}).
\]

Thus this exact-compatibility family cannot have divergent finite-stage
Bezout norms and cannot yield a limiting negative witness. The obstruction
is **contractive restriction from an already solved outer stage**. It does
not cover data defined only on the limiting domain.

The same reviewed artifact proves the lossless criterion for one fixed
global tuple and an increasing inner exhaustion
\(U_1\Subset U_2\Subset\cdots\), \(\bigcup_NU_N=\Omega\):

\[
  \beta_\Omega(F)=\sup_N\beta_{U_N}(F|_{U_N}).
\]

The reverse inequality follows by Montel compactness and a diagonal
subsequence. This identifies the right target but does not construct a tuple
for which the supremum is infinite.

## Exhausted family 2: weighted-pole complementary tuples

Set

\[
  a_n=1-2^{-n},\qquad r_n=2^{-n-3},\qquad
  \Omega=\mathbb D\setminus
      \bigcup_{n\geq1}\overline{B(a_n,r_n)}.
\]

The reviewed geometric argument proves that these closed disks are contained
in \(\mathbb D\), are pairwise disjoint, accumulate only at
\(1\in\partial\mathbb D\), and have connected complement \(\Omega\).
For \(N\geq3\), let \(U_N\) be the component containing \(0\) of

\[
  E_N=\left\{z\in\Omega:
      |z|<1-\frac1N,\ 
      \operatorname{dist}(z,\mathbb C\setminus\Omega)>\frac1N
    \right\}.
\]

Then \(U_N\Subset U_{N+1}\) and \(\bigcup_{N\geq3}U_N=\Omega\).

For \(c=(c_n)\in\ell^\infty\), define

\[
  q_c(z)=\sum_{n\geq1}2^{-n}c_n\frac{r_n}{z-a_n},
  \qquad
  \mathcal F_{\mathrm{wpc}}
    =\{(q_c,1-q_c):c\in\ell^\infty\}.
\]

The Weierstrass bound gives
\(\|q_c\|_{\infty,\Omega}\leq\|c\|_{\ell^\infty}\). If the support of
\(c\) is unbounded in \(\mathbb N\), nonzero residues at arbitrarily late
centers prove that \(q_c\) extends to no finite outer stage. In particular,
\(c_n=1\) gives the campaign's explicit globally nonextendable tuple.

Every member of the entire family nevertheless satisfies

\[
  \max\{|q_c(z)|,|1-q_c(z)|\}\geq\frac12,
  \qquad
  q_c\cdot1+(1-q_c)\cdot1=1.
\]

Consequently

\[
  \beta_\Omega(q_c,1-q_c)\leq1,\qquad
  \beta_{U_N}((q_c,1-q_c)|_{U_N})\leq1.
\]

The explicit object therefore satisfies the domain, boundedness,
nonextension, and lower-bound checks but fails the required no-Bezout-solution
check. The obstruction is the **built-in constant solution \((1,1)\)**.
Nonextension alone is not a negative witness.

## Exhausted family 3: full exact open-collar interpolation

For

\[
  V_n=\{z:r_n<|z-a_n|<2r_n\}\subset\Omega,\qquad
  A=\ell^\infty\text{-}\prod_{n\geq1}H^\infty(V_n),
\]

consider the restriction homomorphism

\[
  R:H^\infty(\Omega)\longrightarrow A,\qquad
  Rf=(f|_{V_n})_n.
\]

The exhausted assembly family consists of every map
\(S:A\to H^\infty(\Omega)\), with no linearity, continuity, or
multiplicativity assumption, satisfying \(R\circ S=\operatorname{id}_A\).

Let \(e\in A\) have constant value \(1\) in its first coordinate and
constant value \(0\) in every other coordinate. If \(Rf=e\), then \(f=1\)
on the nonempty open set \(V_1\); the identity theorem on connected
\(\Omega\) forces \(f\equiv1\), contradicting its value on \(V_2\).
Thus \(R\) is not surjective and has no set-theoretic right inverse. The
obstruction is **analytic uniqueness on open collars**.

## Exhausted family 4: split common collar-product quotients

The exhausted quotient family consists of a surjective unital algebra
homomorphism

\[
  Q:H^\infty(\Omega)\to A
\]

and a unital algebra homomorphism
\(\sigma:A\to H^\infty(\Omega)\) satisfying
\(Q\circ\sigma=\operatorname{id}_A\). No continuity is assumed.

Such an equation makes \(\sigma\) injective. The coordinate element \(e\)
above is a nontrivial idempotent of \(A\), so \(\sigma(e)\) would be a
nontrivial idempotent of \(H^\infty(\Omega)\). But a holomorphic
\(u\) satisfying \(u^2=u\) has values in \(\{0,1\}\), and connectedness of
\(\Omega\) makes \(u\) constant. The obstruction is therefore
**incompatibility of product idempotents with a connected-domain
\(H^\infty\) algebra**.

## Exhausted family 5: one proper compatible discrete algebra

On the punctured disk, C15 uses the two-ray sequence

\[
 s_{2n-1}=\frac1{n+2},\qquad s_{2n}=\frac{i}{n+2}
\]

and the restriction map \(Qf=(f(s_k))_k\). Its range \(B\), with the
transported \(H^\infty\) norm, is a proper nonselfadjoint compatible
discrete-data algebra. The coordinate characters accumulate only at
evaluation at the removable puncture, while the hull is all of \(M(B)\).

The pair

\[
 b_1=Q(z-\tfrac12),\qquad b_2=Q((z-\tfrac12)^2)
\]

has sampled lower bound \(1/6\) and is annihilated by evaluation at
\(1/2\). This is an exact non-Bezout tuple in \(B\), but its pullback has a
common zero at \(1/2\), so it is not a Corona datum on the domain. C17 proves
the class-wide obstruction: every finite tuple with a genuine domain-wide
positive lower bound maps to a tuple generating the unit ideal of this
specific \(B\). The separator detects an omitted sample, not a planar Corona
failure. Other compatible discrete algebras are not covered.

## Exhausted family 6: the principal accumulation-fiber quotient

For the C7 radial disk-with-holes domain, the ratio condition in the cited
hyperbolically rare deletion theorem fails for every admissible centered
enlargement:

\[
 R_n<2^{-n},\qquad \frac{r_n}{R_n}>\frac18.
\]

This is only theorem nonapplicability. It is not evidence against Corona.

The proposed quotient obstruction uses

\[
 A=H^\infty(\Omega),\qquad
 J=\overline{(1-z)A},\qquad B=A/J.
\]

C20 proves the opposite of the desired obstruction. Whenever

\[
 \max\{|1-z|,|h(z)|\}\geq\delta>0\quad(z\in\Omega),
\]

a compactly supported \(\bar\partial\) correction gives bounded
\(G,H\in H^\infty(\Omega)\) with

\[
 (1-z)G+hH=1.
\]

Thus \(Qh\) is invertible in \(B\), and no character of this principal
fiber quotient can annihilate an admissible pair. The conclusion concerns
this principal ideal mechanism; C23 below separately settles the whole C7
domain positively.

## Exhausted family 7: the fixed-collar compatible tail algebra

Let \(A_0=\{1<|w|<2\}\),

\[
 E=\ell^\infty(H^\infty(A_0))/c_0(H^\infty(A_0)),
\]

and let \(Qf\) be represented by
\(w\mapsto f(a_n+r_nw)\). Uniform annulus Corona solutions first give an
exact Bezout identity in \(E\). For the compatible range

\[
 C=\overline{Q(H^\infty(\Omega))}^{\,E},
\]

the enlarged-annulus construction, Runge approximation, and a finite
Neumann correction put exact Bezout coefficients in \(C\) itself. Hence
every admissible finite tuple generates the unit ideal of \(C\):

\[
 \operatorname{dist}_C\!\left(1,\sum_jQ(F_j)C\right)=0.
\]

No positive ideal-distance or Hahn--Banach separator exists in this frozen
fixed-collar algebra. Variable collars, different compatible ranges, and
nonsplit targets are outside C21--C22.

## Exhausted family 8: the C7 radial domain and order-two descent

C23 is stronger than the earlier failures on the same geometry:
Jones--Marshall's theorem applies to the exact C7 radial deleted-disk
domain. Every normalized finite Corona tuple on that domain has bounded
analytic Bezout coefficients, with a bound depending only on its length
and lower bound. Therefore **no data on the C7 domain can be a planar
Corona counterexample**.

C24 records that Brudnyi's finite-type covering theorem cannot instead be
applied using the C7 domain or its parity double cover as the base, because
their fundamental groups are not finitely generated. That nonapplicability
does not weaken the Jones--Marshall conclusion and is not negative evidence.

The explicit order-two Blaschke template of C26 has

\[
 \max\{|B_+(z)|,|B_-(z)|\}\geq e^{-580861}
\]

while neither coordinate is invertible. C27 nevertheless supplies uniformly
bounded base Bezout rows for the whole reviewed template; lifting them also
solves the anti-invariant parity equation on the connected double cover.
Thus odd-parity descent does not restore an obstruction.

C25 records the useful positive input from Oh: at each prescribed fixed
gap, finite bordered Riemann surfaces can require arbitrarily large finite
Corona-solution norms. The surface and data vary with the requested norm,
and the theorem gives neither one planar domain nor a tuple with no bounded
solution.

## Exhausted family 9: reciprocal-character scalarization of Oh's blocks

For the frozen cyclic-cover scalarization in C28, let \(M_n\) be Oh's exact
finite lower bound, \(\eta_n\) the scalar descended gap, and \(L_n\) the
norm of the canonical section-synthesis operator. Evaluation on the zero
fiber gives

\[
 L_n\geq \eta_n M_n.
\]

Therefore a uniform positive scalar gap forces transfer loss of order
\(M_n\); a fixed-length reciprocal-character family cannot both preserve
the gap and transfer the hard block with \(o(M_n)\) loss. For
\(\delta=1/4\) and \(\eta_n\geq1/2\), the explicit estimate is
\(L_n\geq4^n/12\). This rules out the declared scalarization, not every
possible conversion of finite bordered hard blocks into planar ones.

## Exhausted families 10--12: three uniform splitting mechanisms

### Buffered nonradial chains

C29 treats every declared buffered-neck chain with

\[
 c_j=p+Rq^je^{i\theta_j},\qquad r_j\leq\varepsilon Rq^{2j}.
\]

The explicit partition of unity and plane Cauchy transform split every
bounded analytic additive cocycle with

\[
 q_N(a)\leq(1+K_0)\|a\|,\qquad
 K_0=18C_0\!\left(1+\frac{4\varepsilon q}{(1-q)^2}\right),
\]

uniformly in the prefix length and cell connectivity. Uniformly bounded
local fixed-gap Bezout rows therefore glue with one prefix-independent
bound. This exhausts the summably buffered chain class.

### Critical finite-template Whitney tails

C30 removes the summable-plane-kernel hypothesis but freezes a quarter-turn
self-similar tail. Its transition thickness is a fixed positive fraction of
scale, so the direct Cauchy-potential scale sum diverges. Nevertheless,
zero extension to the two-sided periodic cover and Brudnyi's bounded
\(\bar\partial\) theorem over its finite-type quotient give a right inverse
to every finite restriction-difference operator with norm independent of
depth. The corresponding fixed-cell Corona rows glue uniformly. This
exhausts the declared finite-template periodic class, not arbitrary
nonperiodic critical tails.

### Summably localized growing-rank stars

C31 constructs explicit finite circle domains of connectivity \(N+1\)
whose uniformizing groups have free rank \(N\) and no nontrivial regular
periodic quotient. On their two-crosscut star covers, every bounded analytic
cocycle has a primitive of norm at most \(613\) times its norm, independently
of \(N\). C32 consequently gives every fixed-gap normalized pair a base
Bezout row bounded independently of rank. For a chosen disk row of norm
\(M_\delta\), its defect has a primitive bounded by

\[
 \frac{B_\delta+M_\delta}{\delta},\qquad
 B_\delta=M_\delta+
 613\min\!\left(2M_\delta^2,\frac{2M_\delta}{\delta}\right).
\]

This is a genuine growing-rank boundary, but it depends on the declared
summably localized star geometry and cover.

## Exhausted family 13: nested branching residue currents (C33)

The raw-current mechanism is algebraically real but geometrically
incompatible with the requested one-point packing. Suppose level \(k\)
contains \(4^k\) pairwise disjoint circular neck disks with

\[
 a4^{-k}\leq r_w\leq b4^{-k}.
\]

The exact parent-equals-sum contour orientation makes each four-child
family the inner boundaries of a five-holed planar cell, hence nests the
children inside the parent. If \(d_k\) is the diameter of the level-\(k\)
centers, nesting gives

\[
 d_k\leq2b4^{-k},
\]

whereas area packing gives

\[
 d_k\geq a2^{-k}-b4^{-k}.
\]

Thus \(a2^k\leq3b\) for every \(k\), an all-depth contradiction. A finite
nested tree still carries the exact norm-one cocycle and conserved-current
pairing \(q_N\geq N/2\); its infinite limit has a Cantor end set rather
than one accumulation point. C33 therefore exhausts only the simultaneous
nested raw-current, radius-comparable four-ary, one-point class. Nonnested
branching and Cantor-end domains remain outside this boundary.

## Exhausted family 14: nonnested weighted periods (C34)

C34 replaces the impossible nested geometry by an explicit all-depth
nonnested one-point packing. Level \(k\) is a
\(2^k\)-by-\(2^k\) rational grid near \(2^{-k}\), with hole radius

\[
 s_k=2^{-2k-8}.
\]

All radius-\(3s_k\) collar disks are pairwise disjoint across all levels,
and

\[
 4^ks_k=\frac1{256}.
\]

Thus the total contour scale is critical. For every cocycle in the frozen
class of controlled holomorphic contour moments with normalized absolutely
summable principal parts, the explicit path primitive

\[
 b_v=-\sum_{w\preceq v}a_w
\]

satisfies

\[
 q_N(a)\leq\frac{355}{348}
\]

at every depth. Rational pole separation also gives, for every declared
weighted contour functional,

\[
 \left|\sum_w\Lambda_w(a_w)\right|
 \leq4\mathcal D_N(\Lambda).
\]

The critical symmetric vector has pairing \(N\), but its total adjoint
defect is at least \(N+1/4\); exact node balance forces every weight
coefficient to vanish. If the complete cocycle is realized by normalized
local two-generator Bezout rows bounded by \(M\), the same primitive glues
them to a global row bounded by

\[
 M+\frac{355}{348}.
\]

This exhausts the frozen weighted Wiener/principal-part class. It does not
cover arbitrary bounded analytic cocycles on the nonnested cover or
non-tree transition systems.

## Reviewed scope result 15: robust assembly and planar hard blocks (C35--C37)

C35 settles the perturbation step only after whole hard domains have already
been embedded. Let \(D_n\) be finite planar domains, let
\(f^{(n)}\in H^\infty(D_n)^m\) satisfy

\[
 \beta_{D_n}(f^{(n)})\geq M_n>0,
\]

and let \(\phi_n:D_n\to V_n\subset\Omega\) be biholomorphisms onto open
subdomains of one planar domain. If a global tuple
\(F\in H^\infty(\Omega)^m\) satisfies

\[
 \max_j\|F_j\circ\phi_n-f_j^{(n)}\|_{\infty,D_n}
 \leq\varepsilon_n
\]

and has a global Bezout row of max norm \(C\), then

\[
 \boxed{\displaystyle
 C\geq\frac{M_n}{1+m\varepsilon_nM_n}
   =\frac1{M_n^{-1}+m\varepsilon_n}.}
 \tag{26}
\]

Indeed, pulling the row back to \(D_n\) leaves a residual of norm at most
\(m\varepsilon_nC\). If that number is below one, an exact Neumann
correction gives

\[
 M_n\leq\frac{C}{1-m\varepsilon_nC};
\]

if it is at least one, then \(C\geq1/(m\varepsilon_n)\), which already
implies (26). Thus \(M_n\to\infty\) and \(\varepsilon_n\to0\) rule out a
bounded global row; no rate \(\varepsilon_n=o(M_n^{-1})\) is needed.
This requires approximation on copies of the **whole** domains supporting
the lower bounds. Approximation on proper compact cores does not transfer
those bounds. Likewise, a gap certified on the \(V_n\) says nothing about
connectors or the rest of \(\Omega\).

C37 identifies why this valid lemma does not reduce the campaign to an
easier preliminary problem. For fixed tuple length \(q>1\) and fixed
positive gap, Gamelin's Theorem 3.4 turns unbounded Bezout constants on
finitely connected planar domains into a connected planar Corona failure.
Conversely, restricting any planar negative witness to a finitely connected
inner exhaustion and applying C4 gives such unbounded finite-domain
constants. The sum-gap convention in Gamelin and the max-gap convention
here differ by at most the fixed factor \(q\). Therefore

\[
 \boxed{\begin{aligned}
 &\text{fixed-length, fixed-gap finite planar tuples with}\\
 &\text{unbounded exact minimal Bezout norms}
 \end{aligned}}
 \quad\Longleftrightarrow\quad
 \boxed{\text{C1 has a negative witness}.}
 \tag{27}
\]

C36 also closes the proposed use of Oh's existing hard blocks as planar
inputs. For Oh's explicit \(n\)-sheeted cover \(R_n\to D_{2,n}\), the base
is a disk with \(n^2\) holes. The cyclic cut-and-paste construction gives
\(n^2\) inner and \(n\) outer boundary components, while multiplicativity
of Euler characteristic gives

\[
 b(R_n)=n^2+n,\qquad
 \chi(R_n)=n(1-n^2),\qquad
 g(R_n)=\frac{(n-1)(n^2-2)}2.
 \tag{28}
\]

Every hard case has \(n\geq2\), hence positive genus. Oh's actual hard
surfaces are not planar, and cutting or descending them does not preserve
their Bezout lower bound without a new proof.

No planar hard-block family, global tuple, connector-gap certificate, or
one-point-accumulating domain was produced. This retires only the staged
reduction that assumes an independently supplied planar hard-block family,
because that premise is already equivalent to C1. It is not a universal
obstruction to approximate gluing.

## Exhausted family 16: critical radial binary-radius diamonds (C38--C39)

Fix \(q=1/4\) and

\[
 D_N^\tau=B(1,1)\setminus
 \bigcup_{k=1}^N\overline{B(q^k,r_k)},\qquad
 r_k\in\left\{\frac{q^k}{64},\frac{q^k}{32}\right\}.
 \tag{29}
\]

Every such domain is connected, genus zero, and has connectivity \(N+1\).
Choosing the larger radius exactly at perfect-square indices gives a
non-eventually-periodic member. The reviewed critical spine has \(N\)
diamonds, transition ratio sum \(N/4096\), and a constant forward graph
cocycle with exact abstract primitive norm and flow-dual ratio \(N\).
That finite graph calculation is not an analytic Corona lower bound.

After the affine change \(w=1-z\), the hole centers are \(1-q^k\).
Jones--Marshall's radial deleted-disk argument places the Green critical
points in two uniformly interpolating subsequences. For this fixed \(q\),
the separation product gives one superlevel threshold independent of
depth and of the binary radius word. Consequently, for every
\(\delta>0\) there is an existential constant \(B_\delta<\infty\) such
that every normalized analytic pair with gap at least \(\delta\) satisfies

\[
 \boxed{\beta_{D_N^\tau}(F)\leq B_\delta}
 \tag{30}
\]

uniformly in \(N\), \(\tau\), and \(F\).

The same global row disposes of every complete local-row cocycle in this
class. If local rows \(R_i\) have max norm at most \(M\), then

\[
 b_i=\det(R_i,G),\qquad
 a_{ij}=b_i-b_j,\qquad
 \|b_i\|_\infty\leq2MB_\delta,
 \tag{31}
\]

so \(q_N(a)\leq2MB_\delta\). The abstract diamond flow cannot be realized
as a complete analytic Bezout cocycle with uniformly bounded local rows
and bounded adjoint defect.

This exhausts every depth and binary radius word in (29), including the
square-marker aperiodic member. It does not cover angularly turning center
sequences, unbounded-width radial stacks, or critical ladders lacking a
depth-uniform Green-superlevel connectivity bound.

## Exhausted family 17: the frozen all-hole automorphic template (C40)

On the limiting C34 packing, with level-\(k\) hole centers \(c_w\) and
radii \(s_k=2^{-2k-8}\), use

\[
 \Omega=B(0,2)\setminus\left(
 \{0\}\cup\bigcup_{k\geq1}\bigcup_{|w|=k}
 \overline{B(c_w,s_k)}\right).
\]

For \(|\tau_w|\leq1\), define

\[
 P_\tau(z)=\sum_{k\geq1}4^{-k}\sum_{|w|=k}
 \tau_w\frac{s_k}{z-c_w},\qquad
 F_\tau=(z,z-1+P_\tau/100).
 \tag{32}
\]

The exact lattice-shell estimate

\[
 \sum_{|w|=k}\frac{s_k}{|z-c_w|}\leq25\cdot2^k
\]

makes the weighted level bounds \(25\cdot2^{-k}\). Hence (32) converges
normally on the limiting domain and

\[
 \|P_\tau\|_\infty\leq25,\qquad
 \max(|F_{1,\tau}|,|F_{2,\tau}|)\geq\frac14.
 \tag{33}
\]

For \(\tau_w=1\), the normalized principal-part mass is one at every
level, and the nonzero residue at each deleted center is a genuine simple
pole. This distinguished pair therefore extends across none of the holes.
Nevertheless, an exact compact-support \(\bar\partial\) correction gives,
on every finite truncation and on the limit,

\[
 F_{1,\tau}G_\tau+F_{2,\tau}H_\tau=1,\qquad
 \|G_\tau\|_\infty\leq216,\quad
 \|H_\tau\|_\infty\leq130.
 \tag{34}
\]

On a universal cover, use the convention

\[
 R\circ\gamma-R=a_\gamma(-F_2,F_1).
\]

Then

\[
 a_{\gamma\eta}=a_\gamma\circ\eta+a_\eta.
\]

The invariant pullback of (34) shows for every bounded disk Bezout row
that

\[
 a_\gamma=b\circ\gamma-b
\]

for a bounded analytic \(b\). Thus the row-independent connecting class
vanishes for every member of the frozen template.

This is an all-depth boundary only for (32). It does not cover arbitrary
pairs on the C34 domain, nonprincipal accumulation-fiber ideals, or
arbitrary bounded analytic deck-group cocycles.

## What remains untested

The central missing object is still an exact planar negative witness.
Equivalently by C37, one may seek a fixed-length, fixed-gap family of
finite planar domains with unbounded exact minimal Bezout norms, but that
is not a weaker preliminary input. C35 settles perturbation transfer only
after copies of the whole hard domains and one global approximating tuple
are already available. None of C6--C40 constructs either form of the
missing object.

In particular, the reviewed boundaries do not cover:

- a genuinely different one-point disk-with-holes geometry outside the
  Jones--Marshall-controlled C7 and C38--C39 radial classes, carrying one
  global tuple with divergent exact inner-exhaustion Bezout norms;
- a conversion of Oh's finite bordered hard blocks other than the direct
  power descent and frozen reciprocal-character scalarization already ruled
  out, with a new proof transferring the lower bound from the positive-genus
  surfaces identified in C36;
- a proper compatible collar or discrete-data algebra other than the
  specific C15 algebra and C22 fixed-collar closure;
- a noncircular approximate-gluing construction that creates rather than
  assumes the required hard planar data, controls the gap on connectors,
  and uses whole-domain rather than proper-core approximation;
- a nonsplit quotient, an idempotent-free quotient target, a nonprincipal
  boundary fiber, or a construction needing only a bounded linear section;
- invariant-algebra or universal-cover descent beyond the reviewed
  order-two template, scalarization, and frozen C40 principal-part family;
- angularly turning, unbounded-width, or otherwise
  non-Jones--Marshall-controlled critical geometries outside the uniform
  splitting theorems C29--C32 and C38--C39;
- a branching functional that avoids the nested parent-equals-sum raw
  contour geometry of C33; or
- arbitrary pairs, nonprincipal accumulation-fiber classes, bounded analytic
  deck-group cocycles, and non-tree transition systems on the nonnested
  critical packing of C34, beyond the frozen C40 template.

These mechanisms are outside the proved boundaries, not failed cases. A
finite computation, timeout, numerical near-solution, theorem
nonapplicability, or abstract cocycle without a fixed-gap Corona realization
has not been promoted to a counterexample.

## Reproducibility and exact evidence

The prose proofs are the reviewed route artifacts listed above. Exact
arithmetic replays for the later routes are retained as ordinary scientific
artifacts:

| Claims | Exact replay |
|---|---|
| C28 | `research/routes/oh-equivariant-scalarization/verify_constants.py` |
| C29 | `research/routes/nonradial-cech-chain/verify_chain_certificate.py` |
| C30 | `research/routes/critical-whitney-tail/verify_critical_certificate.py` |
| C31--C32 | `research/routes/growing-rank-invariant-cousin/verify_star_certificate.py` |
| C33 | `research/routes/branching-residue-current/verify_branching_certificate.py` |
| C34 | `research/routes/nonnested-weighted-period-dual/verify_nonnested_certificate.py` |
| C35--C37 | `research/routes/robust-approximate-planar-assembly/verify_scope_certificate.py` |
| C38--C39 | `research/routes/critical-diamond-planar-corona/verify_diamond_certificate.py` |
| C40 | `research/routes/infinite-rank-automorphic-obstruction/verify_automorphic_certificate.py` |

The C33 replay checks the finite rational nested comparison, expanded-cover
separation, contour conservation, and pairing. Its bounded Jacobian record is
under
`research/routes/branching-residue-current/evidence/jacobian/`: server
version `0.14.0`, protocol `2025-11-25`, operation
`network.multicommodity_flow.profile.compute`, exact payload
`flow-payload.json`, and typed output `run.json`. The output has zero
divergence at every internal vertex, unit source-to-sink flow, exact
capacity feasibility, congestion \(1\), runtime 4 ms, and no adapter error
or timeout. This checks finite conservation only; it does not overcome the
all-depth geometric contradiction.

The C34 replay checks the exact rational packing, collar separation, norm
and primitive estimates, and the factor-four leakage inequalities. Its
bounded Jacobian record is under
`research/routes/nonnested-weighted-period-dual/evidence/jacobian/`: server
version `0.14.0`, protocol `2025-11-25`, operation
`linear.rational_solution.compute`, exact payload `balance-payload.json`,
and typed output `run.json`. The output is the unique zero five-coordinate
weight vector, status `SOLUTION`, runtime 1 ms, exit status 0, with no
timeout, transport error, incomplete output, or `UNKNOWN`. This checks only
the isolated finite balance system.

The C35--C37 replay checks exact rational instances of the perturbation
inequality and covering arithmetic. Its Jacobian call factors
\(n^3-n^2-2n+2=(n-1)(n^2-2)\) exactly; it does not check the covering
topology, Gamelin's theorem, or the all-\(n\) arguments.

The C38--C39 replay checks the rational circle geometry, critical spine,
and finite abstract diamond flow. Its Jacobian flow profile verifies only
the supplied depth-four incidence flow, not an analytic Corona lower bound
or the Jones--Marshall theorem.

The C40 replay checks the rational packing inequalities, geometric sums,
cutoff constants, and cocycle sign convention. Its Jacobian rational-linear
solve verifies only the finite primitive
\((0,1,-2,3)\), not normal convergence, pole nonextension, the
\(\bar\partial\) row, or a general deck-group cohomology statement.

Every earlier route similarly keeps its exact inputs, outputs, and source
extracts in its own `evidence/` directory. The bounded Jacobian calls are
sanity checks, not analytic Corona proofs. The claim ledger and proof graph
are structural records, not mathematical verdicts; route-level validity
comes from the recorded proofs and independent Reviewer judgements.

After this material report revision, the mandated pinned math-state check
returned `{"ok": true, "issues": []}`, the proof-graph check reported
`proof graph valid: 58 node(s)`, and a bounded aggregate consistency check
confirmed current independent Reviewer support for every claim C14--C40,
confirmed independent attribution of the new C36, C37, and C39 source
propositions, resolved all 42 report-local paths, and parsed every public
JSON/JSONL artifact. These checks establish structural consistency only.

## Certification still required

The route-level results through C40 are already independently reviewed.
Release of this **current aggregate report** at the exploratory target still
requires a fresh independent Reviewer to:

1. confirm fidelity to the original negative-witness objective;
2. confirm that C13 remains the already reviewed early snapshot rather than
   being silently widened to cover later claims;
3. compare every current summary with the independently reviewed scope of
   C14--C40, including the C35 whole-domain hypothesis, C36 topology,
   C37 equivalence, the abstract-only part of C38, the exact radial scope of
   C39, and the frozen-template scope of C40;
4. confirm the explicit statement that no planar Corona counterexample was
   found and that C1 and the global-hard-datum gap remain open;
5. check that the cited source extracts and exact certificates are reusable
   and are not being interpreted beyond their typed or proved conclusions;
6. confirm that every important untested mechanism above remains explicit;
   and
7. issue the activity-level terminal verdict: `done` only if all preceding
   checks pass, otherwise `replan_requested` with the concrete gap.

Until that report-level verdict is recorded, this file is ready for
independent review but is not an independently certified campaign-level
result.
