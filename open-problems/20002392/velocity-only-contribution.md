# The original contribution of the velocity-only boundary exclusion

The complete theorem below is `CWP_ALIGN_VELOCITY`, version 2. Its analytic
correctness, including automatic finiteness of both weighted norms, was
independently accepted on **2026-11-04T01:16:29Z**. The proof is
[`velocity-only-profile-exclusion.md`](velocity-only-profile-exclusion.md);
that file and its certificates are unchanged.

This note submits a different assertion, `CWP_VELOCITY_CONTRIBUTION`: the
complete velocity-only theorem is an original publishable strengthening of
the boundary application of the radial-pressure theorem. This is the
Engineer's contribution assessment, **not an independent novelty verdict**.
The retained independent verdict on `CWP_NOVELTY` already certifies the
originality and publishable significance of the pressure theorem and its
earlier conditional application. It does not automatically certify this
extension. Both verdicts and their different scopes are recorded in
[`roles/reviewer/progress.json`](../roles/reviewer/progress.json) and
[`MATH_STATE.json`](MATH_STATE.json).

## 1. Complete theorem

Let `H={y in R^3:y3>0}`, `r=|y|`, `nu>0`, and `a>0`. Let `(U,P)` be a
smooth up-to-the-wall solution of

    -nu Delta U+a(U+y dot grad U)+(U dot grad)U+grad P=0,
    div U=0 in H,                   U|_(y3=0)=0.

Suppose that, for some finite `C`,

    |U(y)| <= C/(1+|y|).

Define

    D = (integral_H r|Delta U|^2 dy)^(1/2),
    L = (integral_H r|U cross curl U|^2 dy)^(1/2).

Then **both `D` and `L` are finite**. Every nonzero profile has `D>0` and

    L/D >= nu sqrt(2/3)(1-sqrt(999/1000)) > nu/2500.

Consequently

    L <= (nu/2500)D

forces `U=0` and `grad P=0`. When `D=0`, the conclusion follows without
division: the components of `U` are harmonic, have zero wall trace, and
tend uniformly to zero at infinity; the maximum principle on expanding
half-balls gives `U=0`, and the equation gives `grad P=0`.

There is no independently imposed derivative bound, pressure normalization,
mildness, strong spatial `L3`, small velocity amplitude, or finite total
kinetic energy. Norm finiteness is a conclusion before alignment is used;
an inequality between infinite extended integrals is not the criterion.
The alignment condition, positive `nu` and `a`, smoothness, no slip, and
inverse-distance decay are retained. The theorem concerns the half-space,
not an exterior domain or arbitrary ancient solutions.

## 2. The improvement over the strongest preceding theorem

All three results in this comparison use the same threshold and conclude
`U=0`, `grad P=0` under the same weighted alignment inequality.

| Accepted result | Independently imposed profile hypotheses beyond the equation and no slip |
|---|---|
| `CWP_ALIGN` | `nu>0`, `a>0`; `|grad^j U|<=C_j(1+r)^(-1-j)` for `j=0,1,2` (H1); canonical pressure (H2) |
| `CWP_ALIGN_H1` | The same H1 bounds; H2 is proved from the equation, not assumed |
| `CWP_ALIGN_VELOCITY` | `nu>0`, `a>0`; only the `j=0` velocity bound; the weighted energy class and canonical pressure are proved |

Thus the new gain over the strongest preceding exclusion,
[`CWP_ALIGN_H1`](automatic-profile-pressure.md), is removal of the two
independently assumed pointwise derivative-decay bounds. Removing a
separate pressure assumption was already achieved in H1. The extension
preserves that improvement by recovering pressure in the larger
energy-based formulation, where the old H1 argument is not simply invoked.

This is a proved implication from velocity decay to sufficient weighted
energy and pressure control. It is not a proof of
`|grad^j U|=O(r^(-1-j))`, `j=1,2`: that assertion remains unresolved and
is not a dependency. Nor does weaker displayed input prove strict
containment of the sets of actual profile solutions. No nonzero profile
outside H1 is constructed, and no new constant or optimality is claimed.
The substantive issue is whether the accepted new implication and its
boundary application merit publication, not whether the theorem was
rephrased or a kinematic field was found outside strong L3.

## 3. Why the accepted mechanism supplies the missing implication

### Integrated boundary energy replaces an unavailable pointwise bootstrap

For `lambda(t)=sqrt(-2at)`, set
`u(x,t)=lambda(t)^(-1)U(x/lambda(t))`. The velocity bound gives

    |u(x,t)| <= C/(sqrt(-2at)+|x|).

Section 4 of the accepted proof constructs the full-kernel mild solution
and applies the Jia--Seregin--Sverak classification to its **linear Stokes
difference** from `u`. Tangential decay eliminates the shear. Thus
mildness is recovered, not stipulated. Barker--Seregin regularity applies
on each truncated interval `t<T<0`; the available global velocity bound
diverges as `T` approaches zero, so this application does not supply a
uniform terminal-time annular derivative bound.

Sections 6--8 then establish uniform local dissipation through zero. The
velocity envelope supplies uniformly local L2 control and vanishing
spatial tails; recovered bounded-mild regularity first verifies local-energy
membership on truncated intervals. Albritton--Barker--Prange's lifespan
depends on this uniform L2 control, not on the diverging global supremum.
Its additional local initial Lm condition is met with `m=4` on a smooth
slice, without smallness. The estimate used is

    sup_eta integral_A^0 integral_cube(eta) |grad u|^2 < infinity,

with the spatial supremum outside the time integral.

The boundary step cannot be replaced by "bounded velocity implies bounded
derivatives." On patches whose enlarged cutoff support avoids the
similarity centre, all seven components of the Maekawa--Miura--Prange
pressure decomposition are treated. The two local nonlinear components
are the pressure of an auxiliary zero-initial half-space Stokes problem,
whose forcing is L2 by the local dissipation and velocity bounds.
Section 7 proves its Hilbert-space L2 estimate using the all-vector-field
Liu--Liu--Pego commutator bound and a self-adjoint Stokes realization.
The other five terms are controlled, with initial-pressure singularities
avoided by starting the observation interval later. The resulting bound is
for the **actual pressure modulo a time gauge**, not an arbitrarily chosen
canonical replacement.

Only then does Seregin's boundary Stokes estimate apply with `m=n=s=2`.
It yields, including the wall, for some `epsilon>0`,

    integral_(-epsilon)^0 integral_(1<|x|<2, x3>0)
        (|grad u|^2+|grad^2 u|^2) dx dt < infinity.

The exact similarity conversion has the factor `1/a` and radial moments

    integral_(1/r)^(2/r) 1 d lambda = 1/r,
    integral_(1/r)^(2/r) lambda^(-2) d lambda = r/2.

Together with local smoothness, these give
`grad U in L2(H,r^(-1)dy)` and `grad^2 U in L2(H,r dy)`.
In particular `D<infinity`. Also

    L^2 <= 2 C^2 integral_H r^(-1)|grad U|^2 dy < infinity.

The estimate uses `|curl U|<=sqrt(2)|grad U|` and
`r/(1+r)^2<=1/r`. These conclusions hold before alignment is imposed.
The exact moments and cutoff exponents have already passed independent
symbolic replay in section 12 of the accepted proof.

### The energy class still retains the canonical wall pressure and drift

Sections 9--10 prove the prerequisites that an H1-only application would
otherwise leave missing. A radial vector-potential cutoff is solenoidal
and no-slip and converges in both weighted and unweighted Laplacian norms.
It extends the accepted compact-field pressure contraction to this
energy class:

    ||sqrt(r)(I-Pi_H)Delta U||_2 <= sqrt(999/1000)D,

where `Pi_H` is the **unweighted** L2 Helmholtz projection.

Write `G=nu Delta U-(U dot grad)U` and `W=U+y dot grad U`.
The weak Neumann identity uses tests with unrestricted wall trace.
After even reflection of the pressure discrepancy, its harmonic gradient
has the form

    K=f2-a div B+2a V,
    f2 in L2(R^3),  B_ij=x_j V_i bounded,
    |V(x)| <= C/(1+|x|).

Here `V` is the appropriate parity reflection of `U`, not an asserted
whole-space Navier--Stokes solution. Ball averages of these three terms
vanish as the radius increases. This replaces the earlier H1-based
`L2+L4` harmonic-gradient argument and proves

    grad P=(I-Pi_H)G,                 aW=Pi_H G.

The proof never applies `Pi_H` to an unproved L2 field `W`. Its weighted
integrability follows after this identity. The logarithmic-shell drift
calculation then gives `integral_H r W dot Delta U<=0`, retaining the
nonpositive outer angular term rather than assuming it vanishes.

### The strict gap supplies the quantitative exclusion

The retained pressure result is

    13/25 < beta_star <= 999/1000 < 1.

Here `beta_star` is the supremum of
`||sqrt(r)(I-Pi_H)Delta V||_2^2 / ||sqrt(r)Delta V||_2^2`
over nonzero compact smooth solenoidal fields on `closure H` with zero
wall trace.

Its independently reviewed original mechanism is the no-slip solenoidal
normal-component moment in the Laplacian range, which strengthens the
three-dimensional Mellin-fibre variational denominator. The strict gap
below **one**, not an asserted optimal coefficient, makes the prescribed
radial viscous form positive. Weighted projection boundedness alone would
not do this.

Combining that gap, the weighted Helmholtz norm bound `sqrt(3/2)`, and
the drift sign gives the accepted identity estimate

    nu(1-sqrt(999/1000))D^2 <= sqrt(3/2)L D.

Section 11 handles `D=0` separately and uses the already certified
comparisons `1-sqrt(999/1000)>1/2000` and `sqrt(2/3)>4/5`.
Thus the velocity-only extension makes the original coercive mechanism
applicable without independently prescribing derivatives or pressure.
It is not a new proof of the pressure constant or the invention of
geometric depletion, maximal L2 regularity, or similarity scaling.

## 4. Precise comparison with the confirmed primary results

The following comparisons reuse the independently confirmed propositions
in the existing ledger, not search summaries or new unverified citations.
Their source excerpts remain in `research/literature/`. Source attribution
and applicability to this proof are different questions; both were checked
for the accepted energy argument.

### Existing exclusions and geometric conditions

| Primary proposition | Actual implication and the comparison |
|---|---|
| Seregin, [arXiv:math/0410056v1](https://arxiv.org/pdf/math/0410056v1), Theorem 1.1, p.2, (1.1)--(1.4); mixed norm p.3 (`CWP_NOVELTY:SEREGIN11`) | For the stated no-slip Navier--Stokes class `v in L_(2,infinity) intersect W_2^(1,0) intersect W_(9/8,3/2)^(2,1)`, `p in W_(9/8,3/2)^(1,0)`, a uniform-in-time **strong spatial L3** norm gives boundary Holder regularity. This does exclude a backward profile when the hypotheses hold. The velocity envelope and finite weighted derivative norms do not supply that endpoint norm by an integrability embedding; a nonzero `1/r` tail is allowed. |
| Bradshaw--Tsai, [arXiv:1610.05680v1](https://arxiv.org/pdf/1610.05680v1), Appendix 5, p.22, paragraph before Open Problem 5.3 (`CWP_NOVELTY:BT_HALFSPACE`) | Explicitly records the strong-L3 half-space backward exclusion and separately poses inverse-distance decay. This confirms the historical distinction, not the current absence of any later result and not originality by itself. |
| Barker--Prange, [arXiv:1906.08225v1](https://arxiv.org/pdf/1906.08225v1), Theorem 4, p.30, (133)--(134); Definition 6, (38)--(41) (`CWP_NOVELTY:BP_T4`) | A suitable no-slip solution, including its local energy and pressure class, is bounded near the terminal boundary point under a Type-I velocity bound and a single time-independent spatial modulus for vorticity direction on the high-vorticity set, including the wall. The present velocity bound supplies Type I; even granting the suitable class, the separate directional modulus is not a consequence established by our Lamb-vector inequality. Their conclusion would exclude a self-similar profile if that modulus were supplied. |
| Tsai, [doi:10.1007/s002050050099](https://doi.org/10.1007/s002050050099), Theorems 1--2, p.31 (`C20002392:TSAI1`); Pineau--Vicol, [arXiv:2607.09619v1](https://arxiv.org/pdf/2607.09619v1), Theorem 1.4 and Proposition 5.1 (`CWP_NOVELTY:PV_T14`, `PV_P51`) | These are whole-space results: Tsai uses Lq profiles with `q>3` or full-ball local energy; Pineau--Vicol treats inverse-distance rotated profiles in its specified rotation ranges, including zero, and constructs a Gaussian-comparable adjoint weight. At zero rotation the latter needs no present alignment condition. Neither supplies a no-slip continuation across the wall or the radial canonical Stokes-pressure estimate. Our harmonic reflection is not such a continuation. |
| Giga--Hsu--Maekawa, [arXiv:1310.6471v1](https://arxiv.org/pdf/1310.6471v1), Theorem 1.1, p.3, (C1)--(C4) (`CWP_NOVELTY:GHM_T11`) | Vanishing in the **two-dimensional** half-plane requires uniform classical regularity, a specified nonlinear/harmonic pressure decomposition, a Type-I bound, and nonnegative scalar vorticity. This is not a 3D inverse-distance or Lamb-vector theorem. |
| Seregin, [arXiv:1901.08842v1](https://arxiv.org/pdf/1901.08842v1), Theorems 1.4 and 1.7, Definition 1.6 (`CWP_NOVELTY:SEREGIN_TYPEI`) | Connects boundary Type-I singularities and nontrivial ancient solutions under its global scaled velocity, dissipation and pressure bounds and mild-pressure class. These are connection/existence implications, not a Liouville exclusion obtained by proving mildness. |

The two applicable regularity criteria deserve more than a domain label.
For strong L3, similarity gives exactly

    integral_(B_R^+) |u(x,t)|^3 dx
      = integral_(B_(R/lambda(t))^+) |U(y)|^3 dy.

The accepted kinematic tail in
[`critical-tail-comparison.md`](critical-tail-comparison.md) makes this
grow logarithmically despite satisfying the weighted alignment inequality.
Its large-core variants also exclude a small-weak-L3 interpretation.
These fields are **not profile solutions**: they refute a proposed
function-space embedding, not an implication using the full profile PDE.
They support the comparison but do not establish novelty or a strict
ordering of actual solution classes.

For Barker--Prange, fixed profile points with nonzero vorticity eventually
lie in its high-vorticity set after rescaling. Its time-independent modulus
would force

    |Omega(y)/|Omega(y)|-Omega(z)/|Omega(z)||
      <= eta(lambda(t)|y-z|) -> 0.

Thus it imposes a common profile vorticity direction. The present criterion
measures the weighted integral of the **pointwise velocity-vorticity cross
product**, not differences of vorticity directions at distinct points.
No such common-direction implication is used or proved here. Local
boundedness from either applicable theorem would indeed force `U=0` by
self-similarity; it is the additional hypothesis, not a supposed inability
of regularity to imply exclusion, that distinguishes the applications.

### Mildness and boundary regularity are inputs, not the missing exclusion

| Primary proposition already attributed | What it supplies, and what the extension must still prove |
|---|---|
| Barker--Seregin, [arXiv:1503.07428v1](https://arxiv.org/pdf/1503.07428v1), Definition 1.2 and Theorems 1.3--1.4, pp.5--6; Jia--Seregin--Sverak, [arXiv:1201.1664v2](https://arxiv.org/pdf/1201.1664v2), Definition 1.1 and Theorem 4.1 (`CWP_VELOCITY_MILD:BS_KERNEL`, `BS13_GLOBAL`, `JSS_STOKES_DECAY`; `C20002392:BS14`) | Bounded-mild regularity/pressure characterization and classification of a bounded **linear** ancient Stokes solution as a tangential shear. The proof constructs a Stokes difference and eliminates it using spatial decay. Neither the classification nor bounded-mild regularity states nonlinear vanishing or uniform terminal annular derivative bounds. |
| Albritton--Barker--Prange, [arXiv:2112.10705v1](https://arxiv.org/pdf/2112.10705v1), Theorem 1.1, (1.2)--(1.3), Lemma 2.1, p.8, (2.3)--(2.4) (`CWP_VELOCITY_ANNULAR_ENERGY:ABP_LOCAL_ENERGY`) | Uniform local dissipation for its local-energy class with bounded initial L2_uloc norm, vanishing spatial tails, and the stated local Lm condition. Local-energy membership must first be established. Its separate weak-L^(4/3) pressure bound is not an L2 bound. |
| Maekawa--Miura--Prange, [arXiv:1711.04486v3](https://arxiv.org/pdf/1711.04486v3), Definition 1.1, Lemma A.4, Propositions 2.1, 2.3 and 3.1, (2.2), (2.18), (2.20)--(2.25) (`CWP_VELOCITY_ANNULAR_ENERGY:MMP_PRESSURE_SPLIT`) | Identifies the actual seven-term local/nonlocal pressure and controls its nonlocal terms in the needed finite-horizon norms. The local nonlinear pressure still requires the separate L2 auxiliary Stokes argument; merely citing the decomposition does not supply the annular Hessian bound. |
| Seregin, [Math-Net znsl3536](https://www.mathnet.ru/eng/znsl3536), original POMI 370 (2009), Theorem 1.2, p.153, (1.1)--(1.8), pp.151--152 (`CWP_VELOCITY_ANNULAR_ENERGY:SEREGIN_LOCAL_L2`) | At `m=n=s=2`, local L2 norms of velocity, gradient, pressure and forcing give local L2 Hessian/time-derivative/pressure-gradient bounds. The energy proof supplies these hypotheses before applying it. Condition (1.6) belongs to the discussion of an earlier result, not a Theorem 1.1 of this note; the preceding result here is Lemma 1.1. |

The last naming clarification is the retained Reviewer's advisory; it
does not alter the accepted application of Theorem 1.2. The failed
local-boundedness and absolute differentiated-kernel shortcuts remain
retired in the ledger. They are not revived as implicit premises.

### Why the pressure input is not an old estimate in different notation

The following distinctions and the moment mechanism were already accepted
in the pressure-theorem originality review; they are reused, not presented
as newly certified discoveries.

| Closest pressure proposition | Precise difference from the retained input |
|---|---|
| Liu--Liu--Pego, [doi:10.1002/cpa.20178](https://doi.org/10.1002/cpa.20178), Theorem A.1, pp.1478--1479, (1.17), p.1447 (`C20002392:LLP_A1`; `CWP_VELOCITY_ANNULAR_ENERGY:LLP_HILBERT_COMMUTATOR`) | The unweighted half-space commutator bound has squared coefficient `1/2` on all H2 zero-trace fields. Its all-vector-field form legitimately constructs the auxiliary Stokes realization. It does **not** transfer to the radial pressure norm: the accepted solenoidal lower bound `beta_star>13/25>1/2` rules out that transfer. |
| Cozzi--Pego, [arXiv:0912.3958v2](https://arxiv.org/pdf/0912.3958v2), Theorem 1.4, p.3, (1.8)--(1.9), zero trace (3.1) (`CWP_PLANAR_COMPARE:CP14_SYMBOL`) | Optimal power-weighted commutator bounds in planar cones impose no divergence constraint. At half-plane weight `r`, the unrestricted coefficient is at least `pi(pi+2)/8>15/8>1`. Weighting itself is not new; this does not yield the three-dimensional solenoidal contraction and is not a solenoidal counterexample. |
| Alhomsi--Wu--Zheng, [arXiv:2606.28800v1](https://arxiv.org/pdf/2606.28800v1), Appendix A, Theorem A.1, p.27, (160)--(161) (`CWP_NOVELTY:AWZ_A1`) | Unweighted bounded-C3-domain coefficient `1/2+epsilon` plus `C_epsilon||grad U||_2^2`. The lower-order remainder cannot be absorbed uniformly by scale-free half-space dilation; neither the prescribed radial norm nor a remainder-free gap follows. |
| Iyer--Pego--Zarnescu, [arXiv:1202.5671v1](https://arxiv.org/pdf/1202.5671v1), Proposition 2.2, p.5; Theorem 3.1, p.11 (`CWP_NOVELTY:IPZ_P22`) | Coercivity for the extended Stokes operator in a constructed H1-equivalent inner product in the bounded-domain setting. Changing the norm does not prove a pressure-to-Laplacian contraction in the specified `L2(r dy)` form. |

The retained same-fibre diagnostic also holds dimension, weight, and fibre
fixed: dropping the no-slip moment permits the relaxed ratio `2log(2)>1`,
whereas retaining its nonzero moment yields a bound below one. This is
evidence for the pressure mechanism, not an admissible velocity example or
a replacement for its all-frequency proof. See
[`radial-pressure-upper-bound.md`, section 7](radial-pressure-upper-bound.md).
The earlier inability to obtain Huang--Shen's Lemma 4 remains a disclosed
source-access limit; no assertion about that unavailable lemma is a premise.

## 5. Contribution submitted for independent publication assessment

The proposed contribution is the **complete velocity-only quantitative
boundary exclusion**, as the strengthened application of the independently
original radial-pressure theorem. Its positive content is the proved chain

    velocity decay + profile equation + no slip
      => mildness and uniform local dissipation
      => actual annular L2 pressure and Hessian energy
      => finite critical weighted norms and canonical profile pressure
      => strict radial viscous coercivity
      => the nu/2500 alignment exclusion.

The pressure contraction is the original quantitative engine; the
integrated boundary-energy and pressure-recovery argument makes it operate
under a natural velocity-only assumption with a possible critical tail.
This removes unverified regularity and pressure prerequisites from the
application, rather than merely replacing their names. The proof uses
standard lemmas where appropriate; publication significance is asserted
for this combined theorem and its genuine hypothesis-removal implication,
not for every intermediate estimate or a second stand-alone breakthrough.

Relative to the inspected primary statements, this chain is not supplied
by the strong-L3 or directional-coherence exclusions, by mildness alone,
or by the cited local Stokes estimate without its pressure hypothesis.
Nor do their displayed conclusions provide the new radial contraction.
This is a source-specific case for the advance, not a theorem that no
possible combination of all literature could prove it. In particular,
neither a search miss, the 2016 open-problem citation, nor kinematic
noncontainment substitutes for assessment of the accepted mechanism.

The Host-invoked Reviewer must decide whether this complete contribution
has original publishable significance, using the prior pressure verdict
as an accepted input, not as an automatic verdict on the extension.
If a prior result or combination subsumes it, the needed response is the
exact proposition and implication under the theorem's actual hypotheses.
If significance remains unsupported, that is the remaining obligation:
neither outcome withdraws the accepted mathematics or reopens the unused
pointwise-derivative route. `CWP_VELOCITY_CONTRIBUTION` remains separate
from mathematical correctness and final campaign certification.

## 6. Retained exact support and its scope

| Accepted evidence | What it certifies |
|---|---|
| [Section 12 of the velocity-only proof](velocity-only-profile-exclusion.md#12-exact-algebra-replay-and-certification-scope) | Exact Laurent similarity moments, potential-dilation exponents, and cutoff weight balances; independently replayed in the 2026-11-04 correctness review |
| [`certify_pressure_constants.py`](certify_pressure_constants.py), [`pressure-constants-certificate.json`](pressure-constants-certificate.json) | Symbolic pressure/projection/drift algebra, infinite-range comparison, and rational constant comparisons |
| [`certify_axisymmetric_pressure.py`](certify_axisymmetric_pressure.py), [`axisymmetric-pressure-certificate.json`](axisymmetric-pressure-certificate.json) | Complete remaining frequency-band cover with exact rational intervals and uniform analytic series tails, not frequency sampling |
| [`certify_pressure_obstruction.py`](certify_pressure_obstruction.py), [`pressure-obstruction-certificate.json`](pressure-obstruction-certificate.json) | Exact lower-bound calculation obstructing the unweighted coefficient transfer |
| [`certify_critical_tail.py`](certify_critical_tail.py), [`critical-tail-certificate.json`](critical-tail-certificate.json) | Exact kinematic norms and all controlled core-tail comparisons, not profile solutions |
| [`certify_planar_comparison.py`](certify_planar_comparison.py) | The known planar-symbol specialization and weight/dilation algebra, not a new planar theorem |

The recorded Jacobian operation `polynomial.box.enclosure.compute`
(server `0.14.0`, protocol `2025-11-25`) is retained with exact dedicated
payload/output pairs for
[`pressure-gap`](jacobian/pressure-gap-payload.json)
([typed output](jacobian/pressure-gap-output.json)),
[`critical-tail-gap`](jacobian/critical-tail-gap-payload.json)
([typed output](jacobian/critical-tail-gap-output.json)), and
[`planar-weight`](jacobian/planar-weight-payload.json)
([typed output](jacobian/planar-weight-output.json)).
Their recorded adapter exits are zero, with no error or timeout, and
their enclosures are respectively `[1/108,4/27]`, `[1315,21315]`,
and `[7,16]`. They certify only their specified polynomial comparisons,
not PDE validity or originality.

All twenty-two source assumptions already have independent attribution.
They are reused through the existing claim dependencies, not re-filed
under a new name. No new analytic lemma, computational assertion, or
external proposition is introduced here, so no unchanged proof,
certificate, source lookup, or Jacobian operation is replayed. Structural
ledger checks for the new contribution claim are not mathematical
certification. The result remains an independently reviewed analytic
theorem with exact symbolic/interval support, not a Lean/kernel proof,
an unrestricted Liouville theorem, a Millennium solution, journal
acceptance, or final campaign certification.
