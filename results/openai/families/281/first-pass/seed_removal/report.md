# Reusable-seed audit: scope and mathematical findings

The target is the shared seed-removal construction, not a proof or disproof
of the final SK optimum theorem. No false manuscript assertion has yet been
established. In particular, unsuccessful counterexample searches are not
verification.

Throughout, Q denotes the staged QAOA manuscript dated September 25, 2026,
and S the staged full-support companion dated September 27, 2026.
All references are to these staged versions, not a changing upstream branch.

## Source scope

Q `02-foundations.tex:138-153,185-214,710-781` fixes creation linear in its
direction, inner products linear in the second argument, the actual update
`u -> exp(-it Z q(u*Zu vacuum)) u`, and energy
`E(v)=Re <v,Lv>`. The direction inside a field is at the child height.
These are the conventions used below. A root spin conjugation rotates
both the Pauli and its insertion direction.

Q `05-seed-simulation.tex:8-22` explicitly uses the same Gaussian family at
every seed gate. Its proof chain is initialization and high directions;
finite ensemble control with exact zero clocks; selective accuracy;
transport and the singular echo; joint Gram induction plus a separate
root-shift calculation; generic visibility; seed removal.

The main QAOA dependency chain, in `06-assembly.tex:7-32`, is classical
near-optimality -> seeded synthesis -> seed removal -> fixed-word transfer.
The zero-temperature classical input in `03-classical-optimization.tex:15-121`
imports S's full support, diffusion identities, value identity and shifted
coefficient limit. The positive-temperature alternative in section 7
does not use S, but still uses the same synthesis and seed-removal steps.
Neither classical route is certified by this mission.

The companion dependency extraction is:
compact-strip regularity/diffusion/constant transfer -> backward and
forward signs plus integration by parts -> polynomial certificate and
integrated coercivity -> positive curvature on a positive constant
interval -> variational contact plus no terminal plateau -> full support
-> scalar value/coefficient identities. Relevant locators are
`regularity.tex:16-30,189-223,240-294`,
`signs.tex:72-113,195-439`, `certificate.tex:117-198`,
`curvature.tex:9-52`, `variation.tex:81-119,137-143,215-249`,
and `main.tex:119-140,197-204`.
The curvature assertion is unconditional *within* a constant interval;
the comparison literature's crossing statements have additional
second-derivative sign conditions. This observation alone is not a
refutation of either statement.

Q cites Basso et al., arXiv:2110.14206v3, Theorem 1 and equations
(2.3), (2.6), (3.11), (6.1)-(6.3), for transfer. Its ensemble-control
discussion cites Li--Khaneja, arXiv:quant-ph/0510012v1, section II,
Examples 1-2, but supplies its own finite-family zero-clock argument.
Q cites Chen, arXiv:2607.18032v1, Theorem 1.3, for an independent
zero-temperature support result; that input is not used to certify
seed removal here. These are source-scoping records, not independent
attribution approvals.

The inherited Wiki index has no relevant QAOA/seed-removal page.
A focused literature lookup located Q's section 5 and related
spin-boson work (arXiv:2505.07929), but no verified independent
quantitative reusable-seed theorem. This is not a novelty certificate
or an exhaustive literature search.

## Exact tool result

The authorized Jacobian adapter discovered and inspected
`matrix.symbolic.multiply.compute`, then computed `X (Z X) = -Z`.
`jacobian_payload.json` and `jacobian_output.json` retain its full
request and typed response, server version 0.14.0, protocol
2025-11-25 and successful adapter result. This checks only the Pauli
conjugation sign; it does not certify the singular limit or persistence.

## 1. Quantitative reusable-seed verification theorem

Put \(D_1=\operatorname{Dom}(1+N)\) and
\(\|\eta\|_1=\|(1+N)\eta\|\). Here \(N\) counts children at the
current root, not excitations *inside* a child direction. This
distinction is essential.

**Theorem 1 (weighted quantitative compiler).** Fix a finite target
cost--mixer--seed word, \(b>0\), and its formal initialization
\[
 A^{\rm f}_0=R_{\pi/4}\exp(2ibZq(\ell)).
\]
Assume the finitely many formal visibility projections specified in
Q's equation `seed-formal-visibility` are nonzero. Fix, at every
probe start, any finite perpendicular-axis pulse list that satisfies
the exact finite ensemble equations
\[
 \sum_{k:a_k=a}\tau_k=0,\qquad
 \prod_k e^{-i\tau_k c_{j,a_k}P_{a_k}}=R_\theta
 \quad\text{for every designated special center }j.                 \tag{1}
\]
The coefficients in (1) are the *formal limiting* projection
coefficients, not the varying coefficients during the actual probes.
At huge-stage starts they are \((a_j,0)\), rotated into the chosen axes.
Use actual, changing child insertion directions in all implemented
costs and probes.

There are \(r_0,C>0\), depending on this fixed finite data but not on
the input, such that for \(0<r<r_0\):

1. At every completed target gate, the exact ordinary component has
   a low unitary \(A_r\) and a scalar \(|\zeta_r|=1\) satisfying
   \[
   \|(\Psi_{O,r}-\zeta_r A_r)(1+N)^{-1}\|\le Cr^2.                 \tag{2}
   \]
   The normalized special component has its designated packet
   approximation with error at most \(Cr\|\eta\|_1\) on every
   \(\eta\in D_1\). Its exact norm remains \(r\|\eta\|\).
2. With the *initial* vector
   \(w_r=u_{0,r}^*Z\psi_{S,0,r}/r\), every completed gate satisfies
   \[
   \|u_r^*Z\psi_{S,r}/r-w_r\|\le Cr.                             \tag{3}
   \]
   The sign is negative between a selective flip and its restoration.
   The same \(w_r\) occurs throughout, including after noncommuting
   bulk mixers.
3. Each echo obeys
   \[
   \|v'_r-v_r+2rw_r\|\le Cr^2,\qquad
   \|(t/r)(v'_r-v_r)+2tw_r\|\le |t|Cr.                           \tag{4}
   \]
   All ordinary errors before and after the huge costs are \(O(r^2)\),
   hence \(o(r)\).
4. The finite endogenous/external joint Grams and the actual
   root-shift energy differ from their formal seeded values by
   \(O(r)\):
   \[
       |\mathcal E(v_{Z,r})-\mathcal E(v_Z^{\rm f})|\le Cr.        \tag{5}
   \]
   The formal circuit uses one coordinate \(q(w)\) at every seed
   gate, independent of \(q(\ell)\) and the endogenous child space.

The explicit local inequalities (6)--(16) below give uniform
constants in terms of pulse lengths, center separations, tail graph
norms and finite Weyl coefficient sums. Global constants are their
finite compositions; no bound uniform in word length, no algorithm
for selecting the exact real pulses, and no depth estimate is claimed.
The strengthening over Q's qualitative estimates is (2) as a weighted
operator norm on \(D_1\), the quadratic forward error and a linear
energy rate. Its novelty and publication significance remain for
independent assessment.

**Corollary (growing moving tails).** The same vacuum-chosen probes
also work on normalized inputs satisfying
\(\|\eta_r\|_1\le H r^{-a}\), \(0\le a<1\):
ordinary errors are at most \(CHr^{2-a}=o(r)\) and
normalized-special errors at most \(CHr^{1-a}=o(1)\).
The full forward low-action error is at most
\(r+CHr^{2-a}\). This extends the manuscript's bounded
all-number-moment input class. At \(a=1\) these inequalities
no longer give the required ordinary \(o(r)\); no conclusion
at that boundary is asserted.

### 1.1 Elementary Fock bounds and moving high directions

For \(\eta\in D_1\), creation/annihilation estimates give
\[
 \|q(f)\eta\|\le2\|f\|\|\eta\|_1,\qquad
 \|q(f)q(g)\eta\|\le8\|f\|\|g\|\|\eta\|_1.
\]
Conjugating the number operator by \(W(f)\) gives a number term,
two linear terms and the scalar \(\|f\|^2\). Consequently
\[
 \|W_P(f)\eta\|_1\le(1+\|f\|)^2\|\eta\|_1.                       \tag{6}
\]
Resolve \(P\) spectrally for the controlled version. A root spin
rotation commutes with \(N\). Duhamel's formula and (6) also give
\[
 \|(W_P(f)-W_P(g))\eta\|
 \le2\|f-g\|(1+\|f\|+\|g\|)^2\|\eta\|_1.                       \tag{7}
\]
These statements follow first on finite-particle vectors and extend
to \(D_1\) by its graph norm. They impose no smoothness inside \(f,g\).
The corresponding half-graph estimate is
\(\|(1+N)^{1/2}W_P(f)\eta\|
\le(1+\|f\|)\|(1+N)^{1/2}\eta\|\).
Together with
\(\|(1+N)^{1/2}q(f)\eta\|\le4\|f\|\|\eta\|_1\),
it bounds products with two field derivatives separated by
controlled displacements, as needed in the Taylor argument.

Here is a useful fully quantitative separation estimate. If
\(\|d-e\|\ge\kappa>0\), then, also with a root spin contraction inserted,
\[
 |\langle W(d/r)\eta,W(e/r)\xi\rangle|
 \le {32r^2\over\kappa^2}
       (\|\eta\|_1\|\xi\|+\|\eta\|\|\xi\|_1).                    \tag{8}
\]
To see this, reduce to \(W((e-d)/r)\), set
\(Q=q(i(e-d)/\|e-d\|)\), and truncate each vector to
\(|Q|\le\|e-d\|/(2r)\). The translated central intervals are
disjoint since the translation has magnitude \(2\|e-d\|/r\).
The spectral tail bound is
\((2r/\|e-d\|)^2\|Q^2\eta\|\), and
\(\|Q^2\eta\|\le8\|\eta\|_1\). This proves (8).
Higher powers give arbitrary powers of \(r\) on the corresponding
higher graph domains. Only (8) is needed for the quadratic vacuum
error below.

There is an exact high-direction expansion slightly more informative
than discarding the norm-\(r\) term in Q. Set
\(\gamma=b/r,\ d_0=\gamma(v_2-e),\
\vartheta=\gamma^2\operatorname{Im}\langle v_2,e\rangle\). Direct
Weyl multiplication of the exact initialized split gives
\[
 \begin{split}
 w_r={}&-\sqrt{1-r^2}\,e^{-4i\vartheta}
             ZW_Z(-2\gamma e-2d_0)\mathrm{vac}\\
       &-rYW_Z(-4\gamma e-2d_0)\mathrm{vac}.                     \tag{9}
 \end{split}
\]
Indeed, \(R_{\pi/4}^*ZR_{\pi/4}=Y\), \(YX=-iZ\),
\(\operatorname{Im}\langle d_0,e\rangle=\vartheta/\gamma\),
and \(X Y X=-Y\). The two products
\(U_O^*ZU_S\) and \(U_S^*ZU_S\), with their exact scalar
coefficients, give the two terms in (9).

Both terms in (9) are high packets, not an arbitrary uncontrolled
remainder of norm \(r\). Since \(\|d_0\|\le4b\), their scaled
centers stay a positive distance from zero for all sufficiently
small \(r\). On each fixed output spin, the centers in
\(\ell_r=YW_Z(-2\gamma e)\mathrm{vac}\) differ from those in
(9) by \(4be+O(r)\) or \(2be+O(r)\), up to signs.
Thus (6)--(8) give
\[
 |\langle\ell_r,\eta\rangle|+|\langle w_r,\eta\rangle|
       \le C_b r^2\|\eta\|_1,\qquad
 |\langle\ell_r,w_r\rangle|\le C_b r^2                         \tag{10}
\]
for any moving \(D_1\) input. Also
\(d_0=2b\ell_r+O(r)\). Norms and centering of \(\ell_r,w_r\)
follow exactly from unitarity and joint parity.
The phase in (9) tends to one faster than any power since
\(\langle e,\ell_r\rangle=-i e^{-2b^2/r^2}\).

### 1.2 Quantitative selective estimates with actual directions

For a pulse list let \(\Lambda=\sum_k|\tau_k|\), let \(K\)
be its length, and put
\[
 C_\Lambda=16e^{4\Lambda}(1+\Lambda)^4.
\]
Conjugating a probe through a packet is exact:
\[
 W(d/r)^*e^{-ir\tau Pq(v)}W(d/r)
       =e^{2i\tau\operatorname{Im}\langle v,d\rangle P}
          e^{-ir\tau Pq(v)}.
\]
Let \(\Delta=\max_k\|v_{P_k}^{(k)}-v_{P_k}^{(0)}\|\) and
\(\alpha(d)=\max_k|\operatorname{Im}
                       \langle v_{P_k}^{(k)},d\rangle|\).
Using (7) to replace directions only in the *short* displacement,
and then using the zero clocks, gives
\[
 \|(\mathcal B_r(d)-1)\eta\|
 \le C_\Lambda[r^2+r\Delta+\alpha(d)]\|\eta\|_1.               \tag{11}
\]
The zero-clock product with fixed directions has zero first
derivative in an auxiliary common pulse strength. Its second
derivative has two fields; the field-product bound and (6) bound
the Taylor remainder. Removing the spin phases costs at most
\(2\Lambda\alpha(d)\|\eta\|\). Telescoping replacements and
Taylor's formula are all dominated by the displayed \(C_\Lambda\).
This argument never differentiates a direction with respect to \(r\).

For a normalized special packet, if
\[
 \delta_c=\max_k|-2\operatorname{Im}
             \langle v_{P_k}^{(k)},d\rangle-c_{j,a_k}|,
\]
telescoping the finite spin product against (1) gives
\[
 \|(\mathcal B_r(d)-R_\theta)\eta\|
       \le C_\Lambda(r+\delta_c)\|\eta\|_1.                    \tag{12}
\]
Its unnormalized error is \(r\) times (12).
Both bounds hold on spin-inserted tails as well as the original
tails, and on every moving \(D_1\) input.

For clarity, the potentially singular huge-stage phase has its own
bound. Suppose the discarded *vacuum* norm remainder is
\(\le Er^2\), separated center distances are at least \(\kappa\),
and at each probe prefix the sum of the first graph norms of
ordinary tails and of normalized designated special tails is at
most \(H\). Exact unitarity preserves the discarded remainder.
The identity
\[
 \langle v_P^{(k)},v_r\rangle
       =\langle P V_k\psi,V_k Z\psi\rangle
\]
has real diagonal ordinary terms: for an original \(Z\)-spin
label \(y\), that term is
\(y\langle P V_k\psi_y,V_k\psi_y\rangle\).
Every distinct ordinary/ordinary or ordinary/special term has
separated centers and is bounded by (8). Special/special terms
are bounded by their norm squared. The remainder contributes
at most \(Er^2(2+Er^2)\). In particular
\[
 \max_k|\operatorname{Im}\langle v_P^{(k)},v_r\rangle|
 \le B r^2,\quad
 B=(1+256\kappa^{-2})H^2+E(2+E).                              \tag{13}
\]
The harmless overestimate 256 covers all ordered cross groups.
For an ordinary huge center \(-tyv_r\),
\(\alpha\le |t|Br^2\); at a standard center \(\alpha=0\).
This proof used center preservation and moment bounds first,
not smallness of the phases it is proving.

The forward commutator estimate for a single probe, on the ordinary
tail and its spin insertion, is bounded by the short displacement
and its phase. The exact special component has norm \(r\).
Summing over the \(K\) prefixes yields the useful explicit bound
\[
 \Delta\le(4\Lambda H+2K)r
              +(4\Lambda |t|BH+2KE)r^2.                      \tag{14}
\]
At a standard stage take the terms involving \(tB\) to be zero.
This estimate is for actual insertion directions, not substituted
low insertions.

Suppose the starting special coefficient gap is at most \(Gr\),
and all special scaled centers have norm at most \(D\).
Then \(\delta_c\le Gr+2D\Delta\).
Combining (11)--(14) explicitly gives ordinary \(O(r^2)\)
and normalized-special \(O(r)\) estimates. Constants depend only
on the stated finite pulse and packet data. No \(O(r)\)
ordinary error has been divided by \(r\).

### 1.3 Echo and transport: no orthogonal-split assumption

Write the exact current vacuum as \(o+s\), with
\(\|s\|=r\), and let \(V\) be a selective flip,
\(F=-iX\). If its four forward errors on \(o,Zo,s,Zs\)
are respectively \(\epsilon_o,\epsilon_{Zo},
\epsilon_s,\epsilon_{Zs}\), then
\[
 \|(V^*ZV-Z)(o+s)+2Zs\|
       \le\epsilon_o+\epsilon_{Zo}
                         +\epsilon_s+\epsilon_{Zs}.          \tag{15}
\]
For the ordinary part insert and subtract \(ZVo\);
for the special part use \(ZF=-FZ\).
More explicitly, after applying \(V\), the special defect is
\(Z(V-F)s+(V-F)Zs\). The ordinary defect is
\(Z(V-1)o-(V-1)Zo\). Taking norms proves (15).
No pairing between \(o\) and \(s\) occurs.
These inequalities, their prefix pullbacks, and their finite
accumulation are the `Main.lean` theorems.

The forward cost commutes with \(Z\) and therefore preserves
\(u^*Zs/r\) *exactly*. Apply (15) after that cost. Its four
errors are \(O(r^2)\) by (11)--(14), so, if the current
transport error is \(\|u^*Zs/r-w_r\|\le Tr\),
\[
 \|v'-v+2rw_r\|
   \le(\epsilon_o+\epsilon_{Zo}+\epsilon_s+\epsilon_{Zs})
                                                        +2Tr^2.
\]
Only now multiply by \(t/r\). This proves (4). The exact Weyl
identity is
\[
 e^{itZq(v')/r}e^{-itZq(v)/r}
        =\xi_r W_Z((t/r)(v'-v)),\qquad|\xi_r|=1.               \tag{16}
\]
The phase is scalar because \(Z^2=1\).
Unitarity carries the ordinary \(O(r^2)\) error through the
reverse cost; a large field is never applied to a norm remainder.
The residual direction in (16) is bounded and equals
\(-2tw_r+O(r)\), so (6) preserves the low graph bounds.
For a special packet the centers update *exactly* by
\(D_r\mapsto D_r-t(v_r+v'_r)\); all scalar phases remain in
its tail. The second flip restores its spin.

Transport after a flip has error at most
\((\epsilon_s+\epsilon_{Zs})/r=O(r)\), with its sign reversed.
A compensated bulk mixer \(B=R_\theta V\) has forward errors
\(O(r^2)\) on \(s,Zs\), since \(V\) approximates
\(R_\theta^{-1}\) there. Applying the identity version of
(15) to \(B\) proves transport preservation. It does *not*
assert \(R_\theta Z=ZR_\theta\); that generally fails.
Thus every completed echo and compensated mixer transports the
initial \(w_r\). Finitely many transport errors add. This proves
persistence through arbitrary finite alternating echoes and
noncommuting bulk mixers, not just one initialized pulse.

### 1.4 Closing the quantitative induction and identifying energy

At initialization \(1-\sqrt{1-r^2}\le r^2\), so (2) holds
with constant one and the special packet expansion is exact.
Its scaled centers are independent of the input. Unscaled costs
only add a bounded tail displacement, compensated mixers restore
special spins, and (16) updates centers without an input-dependent
choice. Norm remainders propagate by unitarity.

The low insertion \(h_P=A_r^*P A_r\mathrm{vac}\) satisfies
\[
 \|v_P-h_P\|
 \le2r+E r^2(1+\|h_P\|_1).
\]
This follows by applying \(u_r-\zeta_r A_r\) to
\(\mathrm{vac}\) and \(h_P\), and using the exact special norm
\(r\|\eta\|\). It is a forward estimate on graph-smooth
inputs, not an adjoint estimate on a high packet.
All low insertions have uniformly bounded graph norm by (6).

It remains to justify the starting coefficient bounds \(Gr\)
used in (12), rather than postulate them. Expand each finite
low circuit and insertion into root spin matrices and Weyl
words. Its bounded directions are linear combinations of earlier
actual insertions, \(d_0\), and residual echo directions \(g\).
The replacements \(d_0\mapsto2b\ell_r\) and
\(g\mapsto-2tw_r\) have norm error \(O(r)\), by (4) and
initialization; (7) controls their effect. Every endogenous
insertion pairs with \(\ell_r,w_r\) by \(O(r)\), using
the forward insertion estimate and (10).

For two coherent displacements whose coefficient vectors have
\(\ell^1\) norm at most \(L\), a maximum direction-Gram error
\(\delta\) changes their vacuum pairing by at most
\(3L^2\delta\). Indeed their pairing is
\(\exp(-\|g-f\|^2/2+i\operatorname{Im}\langle f,g\rangle)\).
The exponent difference is at most \(3L^2\delta\), and the
exponential is 1-Lipschitz along the segment between exponents
of nonpositive real part. Sum this estimate over the finite
Weyl expansion, including its finite Weyl multiplication phases.
This proves the \(O(r)\) joint Gram induction. The current
special center is a fixed finite linear combination of earlier
insertions and \(e\), so its projection coefficient has gap
\(O(r)\) as required.

For a huge-stage \(Y\)-insertion and a graph-bounded test input,
the ordinary terms paired through \(Y\) have opposite spin
labels and centers separated by \(2|t|\). Equation (8) bounds
their contribution by \(O(r^2)\); exact special terms contribute
\(O(r)\). Thus its pairing with every special center is
\(O(r)\). The center has a graph-bounded approximant at
distance \(O(r)\), because each center direction is an earlier
actual insertion or an insertion differing from it by \(O(r)\).
This supplies the huge-stage starting coefficient gap.

This is a noncircular finite induction: the next pulse list is
fixed from the already determined formal data, the previous
stage supplies its starting gap, (11)--(16) give its output
errors, then the new bounded residual direction supplies the
next Gram entries. Since there are finitely many starts with
nonzero formal projections, decrease \(r_0\) once so that
all actual separations used in (13) exceed half their formal
positive lower bounds. Constants are obtained by applying
(6), (11)--(14), (15), and the displayed Gram Lipschitz
bound in that order. This proves (2)--(4) uniformly on the
graph-norm unit ball, first on the smooth core and then on
\(D_1\) by density.

**Energy needs one more calculation.** For a low insertion
\[
 h=\sum_j s_j\otimes W(f_j)\Omega
\]
the one-particle coefficient is
\(i e^{-\|f_j\|^2/2}f_j\). Therefore
\[
 \langle h,\mathcal Lh\rangle
       =-i\sum_j\langle s_j,+\rangle
              e^{-\|f_j\|^2/2}\langle f_j,h\rangle.            \tag{17}
\]
In the formal representation \(\mathcal L\) creates \(h\)
only in the endogenous child summand and puts both root seeds
in their vacuum. Thus the external terms of \(f_j\) pair
to zero, exactly as ensured by (10) in the actual limit.
This uses the root-shift definition, not equality of Gaussian
marginals.

For example, if \(\sum_j\|s_j\|\le B_0\), every \(f_j\)
has coefficient \(\ell^1\) norm at most \(L\) in unit
directions, their joint Grams with \(h\) have error \(\delta\),
and the total spin-coefficient error is \(\Delta_s\), (17)
has error at most
\[
       L\Delta_s+B_0 L(1+L^2/2)\delta.                        \tag{18}
\]
Here \(x\mapsto e^{-x/2}\) is \(1/2\)-Lipschitz on
\([0,\infty)\), \(\|f_j\|\le L\), and \(\|h\|=1\).
Weyl multiplication phases contribute a controlled finite
coefficient error \(\Delta_s=O(r)\). Finally
\[
 |\mathcal E(v_P)-\mathcal E(h_P)|
       \le2\|v_P-h_P\|=O(r),
\]
because \(\mathcal L\) is an isometry on centered vectors.
Equations (17)--(18) and the joint Gram estimate prove (5).

### 1.5 Finite control data and visibility are not new seed samples

For completeness, the finite equation (1) is feasible for every
finite nonzero projection list. Choose generic perpendicular axes
so both coordinates are nonzero and the squared coordinate pairs
are distinct except for equal/opposite original pairs.
The clock-zero bracket has \(X\)-coefficient \(c_{j,1}c_{j,2}\).
Double brackets multiply it by either square. Polynomial
interpolation on the finite squared-coordinate set supplies the
common clock-zero \(X\) direction. Equal/opposite pairs have
the same coordinate product, so impose the same target value.
To pass from this Lie algebra statement to finite products, span
the generators' reachable conjugates, choose a finite basis,
and apply the inverse function theorem to their product map at
zero in the connected analytic subgroup. Its differential is
surjective. Its image contains an identity neighborhood; subdivide
the desired one-parameter path and multiply finitely many such
reachable pieces. Each conjugate is itself a finite product of
the two available groups and their inverses. This proves exact
finite reachability, including zero clock values, not just density
in an ambient compact group.

The relevant formal projection functions are real analytic finite
Weyl expressions. At zero target angles their value is
\(4bz e^{-8b^2}\ne0\), with \(D^{\rm f}=0\).
They therefore have a common dense nonzero locus. Pick a target
in this locus before fixing the finite lists and \(r\).
At a huge-stage first flip its transverse limiting coefficient
is zero by the preceding estimate, not by resampling a seed.
At second flips the already applied current seed displacement
is included in the low word and the center accumulator.
These observations preserve the original order of choices.

## 2. Exact noncommuting persistence and energy diagnostic

The following exact theorem also gives a small, sensitive regression
test for the proposed limit. It would fail if either echo secretly
used a fresh seed.

**Theorem 2 (root-shift energy after local seed processing).**
Let \(U\) be any finite local word of \(X\) mixers and
longitudinal seed gates, with symmetric joint seed law. Put
\[
 x_U=\mathbb E\langle U\!+,XU\!+\rangle.
\]
Follow it by one cost of angle \(\gamma\), using its actual
child insertion \(v=U^*ZU\,\mathrm{vac}\), and a mixer of
angle \(\eta\). Its root-shift energy is exactly
\[
       \mathcal E(h)=\gamma e^{-2\gamma^2}
                                  \sin(4\eta)\,x_U.           \tag{19}
\]
In particular, for two occurrences of the same standard Gaussian
\(s\), the local chronological word with angles \(a,\beta,c\)
has
\[
 U(s)=e^{-icZs}e^{-i\beta X}e^{-iaZs},\quad
 x_{\rm reused}=\sin^2\beta\,e^{-2(a-c)^2}
                      +\cos^2\beta\,e^{-2(a+c)^2}.            \tag{20}
\]
Replacing the second occurrence by an independent Gaussian gives
\[
       x_{\rm fresh}=e^{-2(a^2+c^2)}.                         \tag{21}
\]
For \(a=c=1/2,\ \beta=\pi/4,\ \gamma=1/2,\ \eta=\pi/8\),
\[
 \begin{split}
 E_{\rm reused}&=\tfrac14e^{-1/2}(1+e^{-2}),\\
 E_{\rm fresh}&=\tfrac12e^{-3/2},\\
 E_{\rm reused}-E_{\rm fresh}
       &=\tfrac14e^{-1/2}(1-e^{-1})^2>0.                      \tag{22}
 \end{split}
\]
This is not a refutation of Q: Q correctly requires reuse.
It is a strict, energy-level distinction between two different
constructions with identical one-gate Gaussian marginals.

**Proof.** Write \(c_0=\cos(2\eta),s_0=\sin(2\eta)\).
The cost commutes with root \(Z\), and \(YZ=iX,\ ZY=-iX\).
Consequently
\[
 h=c_0v+s_0\sum_{z=\pm1}
       U^*Y\Pi_zU\,\mathrm{vac}\otimes W(-2\gamma z v)\Omega.
\]
The root coefficients in this display may be seed-valued.
Since \(\|v\|=1\),
\[
 \langle v,h\rangle=c_0-i s_0 e^{-2\gamma^2}x_U,\qquad
 \sum_z z\langle s_0U^*Y\Pi_zU\,\mathrm{vac},
                                  \mathrm{vac}\rangle=-i s_0x_U.
\]
Insert these two identities into (17), with the root-seed vacuum
contraction included. Its real part is
\(2\gamma s_0c_0 e^{-2\gamma^2}x_U\), which is (19).
Joint parity centers both \(v\) and \(h\).

The Bloch \(X\)-coordinate after \(U(s)\) is
\(\cos(2as)\cos(2cs)-\cos(2\beta)\sin(2as)\sin(2cs)\).
Product-to-sum and
\(\mathbb E e^{ius}=e^{-u^2/2}\) give (20).
Independence gives (21). The characteristic-function formula
itself follows by Gaussian integration by parts:
\(\phi'(u)=-u\phi(u),\ \phi(0)=1\).
Equation (22) follows by substitution and factoring; its sign
uses \(0<e^{-1}<1\).

`verify.py` independently constructs the three exact
root-coefficient/Weyl-center terms for both versions of this
word. It integrates Laurent monomials by the exact characteristic
function, checks unitarity, insertion centering and norm, and
evaluates (17). It uses no numerical quadrature, cutoff,
finite-degree extrapolation or Fock truncation.

The same script checks two restored flips separated by a
noncommuting compensated mixer in an exact orthogonal-sector
model. That finite model is only a check of the transport
algebra. It is not substituted for the actual nonorthogonal
Fock split, which is covered by (11)--(16).

## 3. Evidence and limits

`exact_certificate.json` records exact energies and their positive
gap, the typed Jacobian result, and the precise boundary of the
replay. `Main.lean` has a real Lean 4.31.0 compiler certificate
with exit code zero and no proof holes. Its general isometric
four-error lemma does not assume the disputed insertion change
or orthogonality. `statement_fidelity.md` says exactly which
norm, transport, rescaling and scalar facts are formalized.
The whole Fock compiler and Gaussian integral are not Lean
formalized; Theorem 1 is an analytic proof, not a compiler result.

Neither the final QAOA theorem, classical synthesis, the
companion curvature theorem, nor the novelty of this weighted
strengthening has independent certification here.
The scoped manuscript-source assumptions in the ledger remain
unapproved until an independent reader attributes them. They
are not axioms of the formal core or of the exact energy replay.
No `F_` claim is appropriate absent an established false
manuscript assertion. Independent Host-invoked Reviewer replay
and mathematical assessment are still required.

Replay from the campaign directory with its existing SymPy environment:

```bash
$WORKSPACE/argus-live-update/.venv/bin/python research/seed_removal/verify.py
$WORKSPACE/argus-live-update/.venv/bin/python -m argus_skill.verticals.math.lean_evidence verify research/seed_removal/Main.lean --project-root . --statement-fidelity research/seed_removal/statement_fidelity.md --claim SR_CORE
```

The completed Engineer run also passed both official structural
checks with exit status zero against the exact project root
`campaigns/9000281`.
Those checks validate ledger/graph structure, not the analytic proof
or publication significance.
