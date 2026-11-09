# Admissibility of the retained-path progression tests

## Result and scope

The frequency tests in `counting.tex`, Proposition `prop:thin-count`, satisfy
all five hypotheses of `lem:finite-sparse-count`, in both the three-core and
four-core cases. In particular, the hypothesis involving two different scales
is valid for the actual inherited labels, not just for labels at one cell.

Here and below the source is the staged October 5, 2026 manuscript in
`research/openai_manuscript/An-L3-bound-for-the-trilinear-Hilbert-transform-October-5-2026/build/sections/`.
The interface starts with its retained first-match mode construction and its
actual full-box tests (31)--(33). It does not assert the validity of the
preceding analytic reduction of the operator to those modes.

Write \(D=D_*\), \(d=\dim\theta_z\), and
\[
 H=B'_h=D^5E_{h-10},\quad U=D^{250},\quad
 \xi=\vartheta/L_{h-10},\quad \Xi=D^{1000}.
\]
One permitted choice of the free budget is \(D\geq\max(2,d_{\max}+1)\).
Make this enlargement **before** choosing the other parameters and constructing
the graphs. It preserves every polynomial-log budget in the source.
The source's sufficiently large fixed-power choice of \(A_0\) can, for example,
be taken at least \((C_*6^{R_*^{\rm ht}}B_*D)^4\). In particular
\(A_0\geq C_*\geq D^{100}\).
No restriction on the actual real frequencies, path length, group, or functions
is added by specifying these freely chosen reserves.

Use the usual fixed dyadic endpoint conventions
\[
 \mu\leq \min(1,\min_j|t'-jq'|/R_s)<2\mu,\qquad
 \max(1,|q'|/R_s,|t'|/R_s)\leq\nu
       <2\max(1,|q'|/R_s,|t'|/R_s)
 \tag{A}
\]
for four cores, and the same conventions with the single residual
\(\beta\) for three cores. Other fixed comparable conventions only change
absolute factors in the free reserves. A non-discarded test has
\[
 (2U)^{-1}\leq\mu\leq1,\qquad 1\leq\nu\leq2U,\qquad
 1\leq\Lambda\leq U .
 \tag{B}
\]
For the finite lemma take
\[
 \bar\mu=\mu/2,\quad \bar\nu=8\nu,\quad B=4H,\quad
 \zeta=\xi/36,\quad Q=\lfloor E_h/6^8\rfloor,\quad
 \Sigma=\Xi/2,\quad M=M'.
 \tag{C}
\]
Thus \(\bar\mu\geq(4U)^{-1}\) and \(\bar\nu\leq16U\).
An explicit scale-multiplicity bound is
\[
 L_0=16(d+2)^3
  \left(1+\lceil\log_2(8H)\rceil
           +\lceil\log_2(2\bar\nu/\bar\mu)\rceil\right).
 \tag{D}
\]
The same value works for every fixed pair of core labels.

Let \(\ell=1+\log_2(2+(d+1)^2\bar\nu/\bar\mu)\). Reusing the **already
independently reviewed** claim `C86_SPARSE_EXPLICIT`, without re-proving it,
gives
\[
 \sum_{s:N_s^G\leq\delta M^2}N_s^G
 \leq 2^{160}\ell L_0^{29}\delta^{1/810}M^2.
 \tag{E}
\]
Consequently, with \(p_0=1619/1620=1-1/1620\),
\[
 \sum_sN_s^G\leq L_0\min_{i\ne j}M_i^GM_j^G,\qquad
 \sum_s(N_s^G)^{p_0}
       \leq2^{173}\ell L_0^{29}M^{2p_0}.
 \tag{F}
\]
These imply (34), with its stated polynomial budgets. This is the improvement
over the relevant prior application: the manuscript used \(c'=1/2080\)
and, for example, \(p_0=1-1/4160\); the reviewed \(1/810\) theorem permits
the smaller power in (F). No new proof of the sparse-count theorem or global
literature novelty is claimed.

The proof below is mathematical, not a Lean formalization.
`verify.py` and `exact_certificate.json` certify the finite role algebra,
the exact reserve reductions, and the power-summation constants described
at the end. They do not turn the entire analytic/combinatorial argument
into a kernel proof. Independent review of this application remains required.

## 1. Why the actual labels are separated across scales

The relevant construction is in `linearization.tex`: first-match modes
(20)--(21), graphs (22), nonexceptionality (23), good predicates, and
`lem:hereditary-labels`.

The group center \(z\), clearing denominator \(Q_0\), and horizontal vector
\(\vartheta\) are fixed for the group, not re-chosen at a new depth.
First-match lists are inherited. A primary's modes have a common quadratic
coefficient, and their linear-coefficient differences are rational combinations
of \((\theta_v,\vartheta)\) of height at most \(D\).
If a mode was admitted on \(I_0\) before \(u_b=b-4K\), its curvature bound gives
\[
 r_{v_b}\operatorname{osc}_{J}\omega_m
 \leq 2D\,r_{v_b}^2/|I_0|^2
 \leq 2D2^{-4K}.
 \tag{1}
\]
The same bound holds when an older mode is viewed on a later pre-cell.
These are the explicit first-match bounds; estimates about the physical
approximation of the form are not used in this interface.

Here is the algebra behind the height-good implication used by inheritance.
For a nonexceptional primary, the rational span \(K_{\rm rat}\) of the tiny
height-\(\mathcal H\) vectors has the property that every vector in that span
of height at most \(\mathcal H\) is tiny. Indeed Cramer's rule expresses it
in a basis of tiny vectors with coefficient sum at most
\((d_{\max}\mathcal H)^{C d_{\max}^3}\). Its evaluation is below the huge
threshold by the prescribed choice of \(\mathcal T\), so (23) forces the
tiny alternative.

If two modes of this primary are connected in CURRENT at height \(h\),
summing a simple path gives
\[
 a+(0,m_h/L_h)\in K_{\rm rat},\qquad \|m_h\|_\infty\leq DE_h.
 \tag{2}
\]
The common quadratic coefficient cancels at the endpoints. All vectors
in this argument have height below \(\mathcal H\), by its defining reserve.
Let \(R'=R_*^{\rm ht}\). The spaces \(V_i\) and \(U_i\) defined in
`lem:height-stabilization` increase with \(i\). At a height retained by
its rank-stability rule, both are unchanged from \(h-R'\) to \(h\).
Writing \(a=\sum b_ja_j\) in a height-\(D\) basis from \(V_{h-R'}\)
uses coefficients and a common denominator bounded by \(C_*\). With the
corresponding witnesses \(m_j\), (2) gives
\[
 m_h-6^{R'}\sum b_jm_j\in U:=U_{h-R'}.
 \tag{3}
\]
To see this last membership, clear the common denominator. The resulting
integer vector belongs to \(K_B\), has size at most \(C_*^3DE_h\),
and hence belongs to \(U_h=U_{h-R'}\).

The subgroup \(U\cap\mathbb Z^d\) is saturated, since \(U\) is a rational
vector space; its quotient is free. In this quotient (3), after multiplying
by the common denominator \(q\leq C_*\), says that
\(q[m_h]\) is divisible by \(6^{R'}\). Because
\(R'>\log_2C_*+2\Delta\), the valuations at both 2 and 3 of every
coordinate of \([m_h]\) are at least \(\Delta\).
Other prime factors of \(q\) do not obstruct this conclusion.
Thus \([m_h]/6^\Delta\) has an integer lift \(m'\).
Subtracting integer multiples of an integer spanning set for \(U\)
of size at most \(C_*^3DE_{h-R'}\), by rounding its real coefficients,
gives an integer lift with
\[
 \|m'\|_\infty
 \leq6^{R'-\Delta}\sum|b_j|\,\|m_j\|_\infty
                  +d_{\max}C_*^3DE_{h-R'}
 \leq E_{h-\Delta}.
 \tag{4}
\]
For example the fixed-power choice of \(A_0\) specified above suffices:
divide (4) by \(E_{h-R'}\) and use
\(E_{h-\Delta}/E_{h-R'}=A_0^{R'-\Delta}\).
No small lattice basis or covolume bound has been assumed.
Now \(a+(0,m'/L_{h-\Delta})\in K_{\rm rat}\), and (23) makes its
evaluation tiny. It gives the direct PRE edge at \(h-\Delta\).
This proves exactly the height-good implication used below.

If two good modes lie in the same CURRENT component \(F\), each good
predecessor contains more than \(10/11\) of its primaries.
Their intersection contains more than \(9/11\) of those primaries.
Since at most a tenth are excluded by nonexceptionality/height-goodness,
one primary in the intersection connects its two witnessing modes by the
preceding implication. Hence the two PRE predecessors agree.

For completeness, consider an earlier and a later successful component
of the **same two-coordinate type**, with a link in the later CURRENT graph.
Persistence of CURRENT edges implies \(F_{\rm early}\subseteq F_{\rm late}\).
If \(F=\pi(F_{\rm late})\), the two predecessor primary sets have sizes
greater than \(|F|/1.1^2\) and \(|F|/1.1\), respectively.
Their intersection has size greater than
\[
 (10/11+100/121-1)|F|=(89/121)|F|>|F|/10.
 \tag{5}
\]
A later height-good nonexceptional primary in the intersection again
connects the predecessors in later PRE. Earlier PRE edges persist, so
\(E_{\rm early}\subseteq E_{\rm late}\).

The second type coordinate makes inheritance unambiguous. Any two earlier
predecessors contained in one current predecessor each contain more than
half its mode labels, because all three mode counts lie in the same
base-1.1 bin. They intersect. On their common path this is a link, so they
are nested by the preceding argument and already carry the same representative.
Induction therefore defines the source's hereditary representatives.
Different representatives cannot have equal or adjacent component modes
in the later CURRENT graph: such a link would force inheritance.

For comparable actual uses, nonadjacency means that the supremum of every
allowed shifted slope difference on the later pre-cell is
greater than \(\Xi/r_{t_b}\). By (1), its value at the fixed point \(x_*\)
is greater than \(\Xi/(2r_{t_b})\). The later actual interval has length
at least \(r_{t_b}\); therefore
\[
 |\omega_a(x_*)-\omega_{a'}(x_*)+
                       n\cdot\vartheta/L_h|
 >(\Xi/2)\max(R_s,R_t),\qquad \|n\|_\infty\leq E_h.
 \tag{6}
\]
This also applies to different components at the same cell.
In particular zero shift gives injective real label values within each
fixed role/type on the whole path. This verifies `C86_FREQ_HEREDITARY`
from the graph construction, rather than assuming H3.

## 2. Simultaneous triple annuli and reserves

For four cores the chosen full-box reference is
\[
 q'=\sum_i a_i+n_q\cdot\xi,\qquad
 t'=\sum_i i a_i+n_t\cdot\xi,\qquad
 \|n_q\|_\infty,\|n_t\|_\infty\leq H.
\]
For the triple excluding \(l'\),
\[
 t'-l'q'=\sum_{i\ne l'}(i-l')a_i+
                       (n_t-l'n_q)\cdot\xi.
 \tag{7}
\]
The **same** reference pair works for all four excluded roles:
(A) gives lower bound \(\mu R_s\), upper bound \(4\nu R_s\), and
\(\|n_t-l'n_q\|_\infty\leq4H\). There is no separate choice that could
destroy simultaneity. For three cores there is only one triple;
its residual is exactly \(T_l+m\cdot\xi\), with \(\|m\|_\infty\leq H\).
Both cases give H4 with (C), since \(36n\cdot\zeta=n\cdot\xi\).

The relation \(\zeta=6^8\vartheta/L_h\) sends every height-\(Q\) shift
in the finite lemma to an **integer** height-\(E_h\) shift in (6).
Thus (6) proves H3 with precisely the larger reciprocal scale.

Here are explicit checks of the reviewed, not unspecified, reserves.
For every occupied height \(h\geq10\),
\[
 \frac QH\geq\frac{A_0^{10}}{2\,6^8D^5}
       \geq\frac{D^{995}}{2\,6^8}
       \geq2^{42}(d+1)^2 .
 \tag{8}
\]
The floor costs at most a factor two because \(E_h/6^8\geq2\).
The last inequality follows from \(d+1\leq D\), \(D\geq2\), and
\(2^{993}>2^{43}6^8\). Likewise
\[
 \frac{D^{1000}}2
 \geq2^{40}(d+1)^2\bar\nu,
 \tag{9}
\]
because \(\bar\nu\leq16D^{250}\) and \(2^{748}>2^{45}\).
Equations (8)--(9) are exactly the reserves for \(C_{\rm res}=2^{40}\)
and \(B=4H\).

At an occupied cell, any successful component contains a nonexceptional
primary, even if its representative is exceptional. For every
\(\|n\|_\infty\leq Q\), the pure-horizontal rational vector
\((0,6^8n/L_h)\) has numerator bounded by \(E_h\) and denominator
bounded by \(L_h\), hence height below \(\mathcal H\).
That one primary's nonexceptionality applies to **all** these vectors.
Since \(R_{v_b}\leq R_s\leq R_{t_b}\), (23) gives either
\[
 |n\cdot\zeta|\leq\mathcal T^{-1}R_s
                <\bar\mu R_s/1000
 \quad\hbox{or}\quad
 |n\cdot\zeta|\geq\mathcal T R_s>1000\bar\nu R_s.
 \tag{10}
\]
Indeed \(\mathcal T>\Xi\) and
\(D^{750}>16000\); (B)--(C) also give
\(\bar\mu^{-1}\leq4U\). This excludes the **closed** forbidden interval
and proves H5, including \(d=0\) and the zero shift.
This proves `C86_FREQ_RESERVES`.

## 3. Pair determination across different scales

Put \(R=\max(R_s,R_t)\). Suppose four-core tuples share two labels;
let \(j,k\) be the remaining roles and \(x,y\) their frequency differences.
Subtracting their full-box tests gives
\[
 x+y+p\cdot\xi=e_0,\qquad jx+ky+q\cdot\xi=e_1,
 \quad \|p\|_\infty,\|q\|_\infty\leq2H,\quad
 |e_0|,|e_1|\leq2\nu R .
 \tag{11}
\]
The inverse of \(\begin{pmatrix}1&1\\j&k\end{pmatrix}\) has rows
\((k,-1)/(k-j)\) and \((-j,1)/(k-j)\).
Every denominator is \(1,2,\) or \(3\), and therefore divides 36.
Each coordinate of (11) has the form
\[
 x+N\cdot\zeta=e,\qquad
 \|N\|_\infty\leq288H,\qquad |e|\leq8\nu R ,
 \tag{12}
\]
or the same statement for \(y\).
By (8), \(288H<Q\); by (9), \(8\nu<\Sigma\).
If either coordinate represented two distinct labels, (12) would
contradict (6). Both remaining labels therefore agree.

For three cores, after fixing a pair only one role \(j\) remains.
Subtracting its \(T_l\) tests gives the same conclusion with
\(\|N\|_\infty\leq72H\) and \(|e|\leq2\nu R\), because the
coefficient \(j-l\) belongs to \(\{\pm1,\pm2,\pm3\}\).
This proves the uniqueness portion of H1 at arbitrary two scales.
It is not a same-scale argument.

We also give a proof of the required height-bin bound, so no external
height-bin proposition is left as an assumption. If
\(\Theta\in\mathbb R^m\) and \(c\in\mathbb Z^m\), \(\|c\|_\infty\leq K\),
put \(\mathcal V=\{|c\cdot\Theta|:c\cdot\Theta\ne0\}\).
In a minimally dependent collection of these coefficient vectors,
signed maximal minors on independent coordinate rows give an integer
dependence in which every coefficient is nonzero and has magnitude
at most \(m!K^m\). The latter bound follows directly from the
Leibniz determinant expansion. Thus vectors with successive evaluation
magnitudes separated by more than
\[
 G=4m\,m!K^m
 \tag{13}
\]
must be independent: in a minimal dependence the largest term has
magnitude at least its evaluation, and all smaller terms together
have magnitude at most a quarter of it. Consequently a greedy cover
of \(\mathcal V\) by intervals \([v,Gv]\) has at most \(m\) members.

For a fixed core tuple choose any one of its required triples, and put
\(\Theta=(\sum\alpha_i a_i,\xi)\), \(m=d+1\), and \(K=4H\).
At every occupied scale its annulus (7) uses the integer coefficient
vector \((1,n)\) in this family. Each interval \([v,Gv]\) allows at most
\[
 2+\log_2G+\log_2(\bar\nu/\bar\mu)
\]
integer dyadic scale indices. Since \(m!\leq m^m\) and
\(\log_2m\leq m\), multiplying this expression by \(m\) is at most (D).
For example it is bounded by
\(m^3+m^2a+mb+3m\), where
\(a=\lceil\log_2(8H)\rceil\) and
\(b=\lceil\log_2(2\bar\nu/\bar\mu)\rceil\).
This is at most \(4(m+1)^3(1+a+b)\), already smaller than (D).
If all evaluations vanish there are no occurrences.
Thus a fixed tuple, and hence a fixed pair, has at most \(L_0\)
scale occurrences. This completes H1 and `C86_FREQ_PAIR`.

## 4. The side budget uses one shared offset

There are now three core roles and side role \(l\).
Fix a core label and a scale. For a core triple \(E\), let
\(\mathcal W_E\) be the **whole** set of integers in its windows (32);
the union is over all \(\|n\|_\infty\leq H\), not over a mask-dependent
subset of Fourier frequencies.

If windows of two triples \(E,E'\) containing that label shared an
integer, their two remaining label differences \(x,y\), in roles \(j,k\),
would satisfy
\[
 x+y+p\cdot\xi=e_0,\qquad
 (j-l)x+(k-l)y+q\cdot\xi=e_1,
 \quad |e_0|\leq4\Lambda R_s,\quad |e_1|\leq2\nu R_s,
 \tag{14}
\]
with \(\|p\|_\infty,\|q\|_\infty\leq2H\).
The first inequality includes both closed window boundaries.
The determinant is still \(k-j\), of magnitude at most three.
For every choice of side and fixed core role, inversion gives
\[
 \|N\|_\infty\leq288H,\qquad
 |x+N\cdot\zeta|
 \leq14\max(\nu,\Lambda)R_s
 \leq28U R_s<\Sigma R_s ,
 \tag{15}
\]
and the same for \(y\).
The last strict inequality follows from \(D^{750}>56\).
As in (12), (6) forces both labels to agree. Thus distinct incident
triples have disjoint \(\mathcal W_E\). This is simultaneous
disjointness of unions of all windows, including exact endpoint contacts.

The side function
\(S'_\rho=\zeta^\rho e(-c_lp^\rho)S_{\rm phys}\) is the same for every
incident triple at this cell. Also
\(\|S'_\rho\|_{2,I_s}\leq\|S_{l,G,s}\|_{2,I_s}\).
The normalized integer exponentials on \(I_s\) are orthonormal:
their pairwise integrals are zero unless their integers agree.
Pythagoras applied to their finite orthogonal projection therefore gives,
for each offset \(\rho\),
\[
 \sum_E\sum_{k\in\mathcal W_E}
            |\widehat{S'_\rho}_{I_s}(k)|^2
       \leq\|S'_\rho\|_{2,I_s}^2 .
 \tag{16}
\]
This only uses finite Bessel orthogonality, not completeness of a Fourier
expansion. Taking expectation and using exactly the definition (32) gives
\(\sum_E b_\Lambda(E)^2\leq\|S_{l,G,s}\|_{2,I_s}^2\).
Every incident triple in the fixed nonzero side bin has
\(b_\Lambda(E)\geq\sigma_l\). Hence its incidence is at most
\[
 w_s=\sigma_l^{-2}\|S_{l,G,s}\|_{2,I_s}^2,\qquad
 \sum_s w_s=M_l^G\leq M'.
 \tag{17}
\]
No independence between masks, triples, or offsets is asserted or needed.
Changing to a subset of scales only decreases this budget.
This proves H2 and `C86_FREQ_SIDE`.

## 5. Completing the application

There are finitely many labels and scales. A nonempty group has \(M'\geq1\);
in the side case this also follows from (16) and one nonzero side-bin use.
Every core cardinality is at most \(M'\) by definition.
Sections 1--4 have proved H1--H5 with (C)--(D), so the reviewed claim
`C86_SPARSE_EXPLICIT` applies and gives (E).
Its support is the existing independent Reviewer judgements in
`research/MATH_STATE.json`; its unchanged proof and Lean core are not
re-certified by this mission.

For each pair of core roles, H1 gives total count at most
\(L_0M_i^GM_j^G\). For a core/side pair, (17), summed over the
fixed core labels, gives at most \(M_i^GM_l^G\).
These are every possible distinct pair in the three-core case and
give the first assertion of (F) in both cases.
Pair determination also gives \(N_s^G\leq M^2\).

Put \(c=1/810\), \(\varepsilon=c/2=1/1620\), and \(p_0=1-\varepsilon\).
On scales with \(2^{-j-1}M^2<N_s^G\leq2^{-j}M^2\),
\[
 (N_s^G)^{p_0}\leq
       (2^{j+1}/M^2)^\varepsilon N_s^G.
 \tag{18}
\]
After (E), the sum over \(j\geq0\) is bounded by
\[
 2^{160}\ell L_0^{29}M^{2p_0}
            \frac{2^\varepsilon}{1-2^{-\varepsilon}} .
 \tag{19}
\]
For the integer \(n=1620\), Bernoulli's inequality gives
\((1-1/(2n))^n\geq1/2\), so
\(1-2^{-1/n}\geq1/(2n)\). Therefore the last factor in (19)
is at most \(4n=6480<2^{13}\). This proves the second assertion of (F).

Finally \(d\leq d_{\max}\), \(\log H\), and all fixed parameter logarithms
are polynomial in \(P,k\). The source has
\(\eta=e^{-k^\theta}\) and \(P=\lceil\eta^{-\alpha}\rceil\) for fixed
positive absolute \(\alpha,\theta\); thus fixed powers of \(k\) are
absorbed by \(P^C\). Equations (D), (B), and the definition of \(\ell\)
put \(2^{173}\ell L_0^{29}\) inside the polynomial budget in (34).
All exponents are absolute and independent of the number of depths,
the frequencies, and the dimension. This proves `C86_THIN_INPUTS`
and `C86_THIN` at the stated interface.

## Exact replay and its limits

Run `python3 research/frequency_tests/verify.py --self-test` from the campaign
root. The standard-library-only verifier checks:

- Every four-core inverse, every three-core coefficient, all twelve side
  systems, all four simultaneous triple identities, and integrality after
  division by 1, 2, or 3. The sharp maxima are \(288H\) for the shift
  budget, \(8\nu R\) for pair determination, and \(14\max(\nu,\Lambda)R\)
  for overlapping windows.
- The exact overlap fractions (5), the reductions of the **universal**
  reserve inequalities to monotone powers at \(D=2\), and the exact
  rational power and geometric-series constants. The monotonicity and
  height-bin arguments themselves are given above, not inferred from a
  bounded sample of dimensions or scales.
- Binding to the relevant live staged source fragments and independent
  replay of the Jacobian primal/dual certificate.

The already inspected contract is reused from
`research/sparse_count/jacobian_contract.json`.
The first, equivalent source-coordinate LP was rejected by the adapter's
simplex admission bound: `jacobian_payload.json`, `jacobian_output.json`,
and `jacobian_status.json` preserve that **non-conclusion**.
The invertible change of variables
\(u=x+y,\ v=2x+3y\) reduces it to
\(|u|\leq4,\ |v|\leq2,\ \max x=\max(3u-v)\).
The successful `jacobian_residual_*` files preserve the exact payload,
typed `OPTIMAL` output, server/protocol identifiers, and adapter status.
Their optimum is 14, attained at \(u=4,v=-2\), hence \(x=14,y=-10\).
The verifier checks both primal feasibility and a matching dual bound
in the original problem as well. This LP certifies only the sharp local
constant in (15), not admissibility by itself.

No false literal manuscript assertion was found in this bounded application
audit, so there is no new `F_` refutation claim. The main operator theorem,
the preceding analytic reduction, publishability, and global novelty are
not certified here.
