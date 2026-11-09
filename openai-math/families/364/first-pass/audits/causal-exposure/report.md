# Concrete causal exposure: mathematical audit

## Assertion and scope

The target is Proposition `exp:exposure` in the staged stable-radial-potential
manuscript, not the hard-sphere manuscript and not either main limit theorem.
Paths below are relative to
`research/openai_manuscript/The-Boltzmann-Grad-limit-for-stable-radial-potentials-on-regular-kinetic-intervals-September-23-2026/build/sections/`.

The literal assertion in `05-exposure.tex`, under
`\label{exp:exposure}`, is:

> Fix an admissible mixed whole-cell prescription with
> \(p\le P^a\) labels and a total energy budget \(\mathcal K\le Rp\).
> Fix a collection of \(k\) disjoint regular terminal trees as in
> Lemma `exp:terminal`. Sum the absolute activity-normalized chart
> integrals over the event that every selected tree has a first defect.
> The result is bounded by
> \[
> \mathcal A_p(pJ)^{Cp}(p^C\varepsilon^c)^{k/2}.
> \]

Here \(P=1+|\log\varepsilon|\), the potential and layer count are fixed,
and \(\mathcal A_p=\prod_i\|u_i\|_{\mathrm{Bol},\beta_0}\).
The constants may depend on the compact cutoffs, tree-size bound \(M\),
energy constant \(R\), and fixed layer count. They must not depend on
\(p,\varepsilon\), the individual history, source boxes, or a revealed bath.

The selected-tree qualification is essential. It includes a globally
singleton launch cell, compact nonzero relative/output increments, a
completed isolated-scattering duration at most \(\varepsilon^{96/100}\),
birth spacing \(2\varepsilon^{9/10}\), and distance
\(\varepsilon^{95/100}\) from cell/layer boundaries. The launch parent is
separated from the other already displayed paths by
\(\rho=\varepsilon^{85/100}\). No outside primary global pin attaches to
a selected tree; the original and global genealogies agree on it. A
genuine launch owns both outgoing branches; a passage owns only its new
branch. These are hypotheses of the selected assertion, not conclusions
of an independence argument.

An absolute integral is not the conditional probability of an admissible
history sector. No conditional normalization is permitted. No bounded
number of bath collisions, global scattering-angle inverse, or
independence of the two outputs of one scattering may be assumed.

## Scoped source findings

| Source | Content actually used | Audit obligation |
|---|---|---|
| `01-preliminaries.tex`, `pre:potential`, `pre:flow` | Fixed finite-range stable radial \(C^2\) potential, possibly singular repulsively at zero; unique finite-energy Hamiltonian flows | Exhaust singular compact domains; do not extend a singular flow through a collision diagonal |
| `02-cell-expansion.tex`, `cell:histories` | Fixed lifetimes and force groups; extra labels exist for the whole cell; contact times are coordinates, not physical creation times | Omission before a pin must be justified by zero cross force |
| `04-history-estimates.tex`, `hist:gaussian` | Augmented source-to-mixed-coordinate volume preservation and once-counted energy | Retain departed Hamiltonians and every original intact-polymer cut |
| `04-history-estimates.tex`, `hist:pinning` | First-contact translations and activity cancellation | Verify the actual translation Jacobian, not a scattering-map determinant |
| `04-history-estimates.tex`, `hist:irregular`, `hist:separated` | The regularity, spacing, and separated-parent gates | Do not enlarge these gates into assertions about all histories |
| `05-exposure.tex`, `exp:terminal` | Bounded disjoint selected trees and exclusion of outside primary targets | Fix labels combinatorially, never condition their reference laws on selection |
| `05-exposure.tex`, `exp:product-domination` | Joint product majorization before conditioning | Establish a common product domain with absolute, not future-relative, velocities for other dormant components |
| `05-exposure.tex`, `exp:dormant-install` and agreement paragraphs | Dormant relative flow followed by rooted installation | Show both translation recovery and independence of every still-hidden block |
| `05-exposure.tex`, `exp:tube`, `exp:affine` | A spherical ray against an independent Lipschitz comparison curve | Verify independence, short-time exclusions, and arc error for each actual test |
| `06-closure.tex`, `close:summability` | The extensive exposure gain is used in the many-crossing case | Settling exposure alone does not certify summability or the main theorem |

The seed ledger and graph contained only the campaign objective, with no
previous mathematical result. The initial source map is therefore not a
comparison against an earlier proof or counterexample.

## Literature boundary

The primary abstracts of arXiv:1301.2514v2 (Pulvirenti--Saffirio--Simonella)
and arXiv:2408.07818v3 (Deng--Hani--Ma) were obtained. The former explicitly
claims a short-time result for stable smooth potentials; the latter a
regular-lifespan result for hard spheres. These observations identify the
scope of known results, not an external proof of this proposition.
The relevant precise references in the staged bibliography are
arXiv:1301.2514v2, Section 8, Hypothesis 1' and Theorem 1', and
arXiv:2408.07818v3, Section 1.4.2.

A search-engine synthesis incorrectly associated PSS with arXiv:1405.4676;
the bibliography and primary version page instead identify 1301.2514v2.
The synthesis is not mathematical evidence. No claim of literature novelty,
or of having checked either cited theorem's proof, follows from an abstract.
Neither theorem is being imported to discharge exposure's causal invariants.

The shared Wiki index was searched for Boltzmann, kinetic, scattering,
exposure, replay, and causal; it disclosed no relevant page. This is a
scoped retrieval result, not evidence that no relevant literature exists.

A second, bounded lookup asked specifically for smooth-potential mixed
whole-cell multiplicative exposure estimates with both label and mesh
counts growing as a fixed negative power of epsilon. It returned no
proposition-level primary match. Its unsupported assertion of novelty
is not used. Thus the power-complexity extension below has a precise
comparison with the staged source, but its literature novelty remains
unverified.

## Concrete verification theorem

**Theorem CE (analytic, submitted for independent review).** On precisely
the selected-history class above, Proposition `exp:exposure` holds with
\(c=1/100\), after increasing the fixed polynomial exponent \(C\).
In particular, no conditional independence of the *admissible sector*
is asserted. Independence belongs to a dominating, unconditioned reference
product measure. This theorem concerns the exposure estimate only.

The proof below supplies the semantic argument for actual prescribed
finite-range flows. The separately formalized finite core does not replace
that argument.

**Theorem PCE (power-complexity extension, submitted for review).**
Fix the potential, kinetic budget per source, compact gates, number of
macroscopic layers, and selected-tree size bound. There is a constant
\(B\ge1\), depending only on these data, with the following property.
For each fixed \(0<\alpha\le1\), put
\[
 \eta={\alpha\over800(3B+1)},\qquad d={\alpha\over800}.
\]
Construct exactly the same finite whole-cell prescriptions on a uniform
mesh, but allow
\[
 1\le p,J\le\varepsilon^{-\eta},\qquad k\ge\alpha p.
\]
Supply the same regular selected trees, including all the original
geometric, ownership, energy, and no-outside-primary-target qualifications.
For all sufficiently small epsilon, uniformly over these prescriptions,
their all-first-defect absolute chart integral is at most
\[
                         \mathcal A_p\varepsilon^{d p}.       \tag{PCE}
\]
The constants and epsilon threshold are independent of \(p,J\) and the
individual history. This does not claim that the separate selection or
discard theorem holds in the enlarged range. Theorem CE is proved
first; Section 6 proves that its concrete construction is uniform in
this larger class and accounts for its entire combinatorial cost.

### Analytic foundations used in the proof

Only finite-dimensional flow and measure facts are needed; no external
kinetic theorem is imported. Here are the relevant reductions.

On a compact set avoiding singular diagonals, the finite vector field
is \(C^1\) and Lipschitz. On a sufficiently short interval its integral
equation is a contraction on a closed sup-norm ball: iteration differences
are bounded by a geometric series, whose limit solves the equation.
The same Lipschitz estimate gives uniqueness, and iteration extends the
solution as long as it stays in a compact part of its domain. Energy
conservation follows by differentiating the finite Hamiltonian.
Stability bounds kinetic energy. In the singular case all other pair
potentials are bounded below by \(-2B\), so finite total energy also
bounds each one pair potential above, excluding approach to its
repulsive singularity. Bounded speed excludes finite-time spatial
escape. Thus all required finite-energy restricted group flows exist
globally. Differentiating the flow with respect to its phase coordinates
gives the variational equation; the determinant solves
\(J'=(\operatorname{div}F)J=0\) with \(J(0)=1\).
This proves the volume fact used here rather than assuming a
many-particle scattering Jacobian.

The spatial change-of-variables step needs only the equal-dimensional
\(C^1\) area inequality. On the nonzero-determinant part the inverse
function theorem gives countably many diffeomorphism patches; partition
their domains disjointly and apply the ordinary Lebesgue substitution
formula on each. Multiple images only increase the resulting integral.
The image of the critical part is null: on a bounded compact domain
where \(Df\) is uniformly continuous, a cube of side \(h\) meeting that
part maps into an \(o(h)\)-thickening of a rank-at-most-\(d-1\)
linear image of diameter \(O(h)\). Its volume is \(o(h^d)\), uniformly
as \(h\) tends to zero. At most \(O(h^{-d})\) cubes cover the domain,
so their image volume tends to zero. Exhausting compact domains proves
the asserted null-image statement. No higher-regularity version of
Sard's theorem is being applied to the many-body flow.

The orientation measure is the explicit uniform incoming direction
times uniform impact azimuth, of total area \(8\pi^2\); equivalently
it is normalized Haar measure multiplied by this constant. Rotational
equivariance makes each nonzero body vector's directional pushforward
rotation invariant, hence the normalized spherical measure. Tonelli
is applied only to nonnegative finite reference integrals.

Finally every smallness comparison below is uniform over the polynomial
logarithmic label cap. For fixed \(N,\lambda>0\),
\((1+x)^N e^{-\lambda x}\to0\): choose an integer \(m>N\) and use
the exponential-series bound
\(e^{\lambda x/2}\ge(\lambda x/2)^m/m!\).
Set \(x=|\log\varepsilon|\). Thus a strictly positive rational gap
between the epsilon powers dominates every fixed polynomial in
\(p\le(1+x)^a\). This is an asymptotic argument, not a finite numerical
threshold experiment.
Section 6 replaces this polylogarithmic comparison by explicit positive
power gaps; it does not change any replay or event-containment hypothesis.

### 1. Concrete charts and their joint majorant

Work in backward time, retaining physical velocities. Fix the force
groups, lifetimes, original contact indicators, and global merger forest.
At each cell's late endpoint anchor all old labels at their actual end
coordinates. Temporarily evolve every floating component by the original
force partition restricted to that component. A common spatial translation
of a component commutes with this restricted flow.

Until two components' first geometric contact, the omitted cross forces
are identically zero: the potential and its gradient vanish outside the
interaction ball. This assertion remains true when the two components
are parts of the same original force group. Consequently their separately
computed motions agree with the union motion up to that contact.
Upon merging, use the restricted original force partition on their union.
Do not introduce a force at a merely virtual contact.

Let \(q_i^A,q_j^B\) be the relative paths of two components and \(a_A,a_B\)
their remaining common translations. With a consistently oriented normal,
their contact equation is
\[
 a_B-a_A=\varepsilon n+q_i^A(t)-q_j^B(t).                 \tag{1}
\]
Holding all internal coordinates fixed gives the absolute spatial
Jacobian
\[
 \varepsilon^2|n\cdot(v_i^A(t)-v_j^B(t))|\,dt\,d\sigma(n).
                                                               \tag{2}
\]
For example, write \(D=1+u^2+v^2\) and
\(n=(2u,2v,1-u^2-v^2)/D\). If \(w=(x,y,z)\), the exact polynomial
determinant checked by both Jacobian and Lean is
\[
 \det\begin{pmatrix}
 x&2\varepsilon(1-u^2+v^2)&-4\varepsilon uv\\
 y&-4\varepsilon uv&2\varepsilon(1+u^2-v^2)\\
 z&-4\varepsilon u&-4\varepsilon v
 \end{pmatrix}
 =4\varepsilon^2D\{2ux+2vy+(1-u^2-v^2)z\}.              \tag{3}
\]
The two latter columns are \(D^2\varepsilon n_u,D^2\varepsilon n_v\).
Dividing by \(D^4\), and using
\(d\sigma=4\,du\,dv/D^2\), proves (2) on this patch. A second patch
covers the omitted pole. The sign of a convention for \(w\) disappears
in the absolute Jacobian.

Each merger eliminates one free translation. The next change of
variables leaves previous internal pin variables fixed; derivatives
with respect to them therefore occur only off the diagonal. The full
Jacobian is the product of (2). An endpoint overlap instead uses its
relative displacement in the ball of radius \(\varepsilon\), with
Jacobian one. There is one pin per extra label. Contact pins cancel
their factors \(\mu=\varepsilon^{-2}\); an endpoint pin leaves the
nonnegative volume factor \(O(\varepsilon)\).

Every extra component is eventually rooted because its prescribed
contact graph is rooted. Ties may be retained and resolved in the
fixed pair order; no assertion that all simultaneous contacts are
null is needed. On compact regular flow domains the contact maps are
\(C^1\). Their zero-Jacobian images have zero translation volume by
the equal-dimensional area formula. The singular-potential case is
the countable exhaustion of the finite-energy flow domain by compact
sets away from the collision diagonals. Thus neither tangencies nor
undefined singular initial data contribute missing positive-volume
pieces. This proves an absolute chart covering, not a probability
statement about the original process.

For a selected singleton vertex the free added velocity \(w\) is
replaced by \(g=w-v_{\rm parent}(t)\). The parent trajectory before
this first pin does not use this new label. Ordering the substitutions
by their backward pin times makes their velocity Jacobian triangular
with identity diagonal. Grouping the resulting variables by selected
tree does not change this fact. All other floating components keep
their absolute terminal velocities. No relative velocity anchored to
an as yet hidden tree is put in the known variables.

At a regular vertex write its relative data as \(s,\rho,R\), with
normalized Haar rotation \(R\). The unnormalized flux measure is exactly
\(8\pi^2s^3\rho\,ds\,d\rho\,dR\). All prescribed radial domains are
rotation invariant; restrictions coupling other variables remain
indicators, not changes of law.

For completeness, the energy bound used here follows directly from
the prescription. On an open cell every fixed force group is
Hamiltonian. At a permitted split its cross potentials vanish; store
each departed group's full Hamiltonian. At a source insertion the
restored singleton pattern gives zero new cross potential within the
new prescribed force groups. Initially independent sources likewise
introduce no potential in those groups; geometric overlap of distinct
force systems introduces no Hamiltonian term. Stability bounds the sum of all
current and stored potential energies below by \(-Bp\), once, not once
per layer. Hence, if \(\mathcal K\le Rp\), every original current,
departed, or not-yet-injected speed is at most
\[
 V_*= \sqrt{2(R+B)p}.
 \]
The augmented source-to-mixed-coordinate map is a composition of
Hamiltonian maps and identity injections/departures, so preserves
volume. Terminal witnesses keep all final components intact and obey
the same argument.

Partition source positions into disjoint unit cubes contained in their
unit-radius summability balls. On source-box choice \(\boldsymbol k\),
the input product is at most \(\prod_i a_{i,k_i}\); dropping its remaining
Gaussian factors only increases this bound. Each top position lies in
a polynomial enlargement of its own source cube, since its lifetime
displacement is at most \(TV_*\). Every other spatial coordinate has
already been removed by a pin. Speeds, fluxes, radial densities, top
volumes, time intervals, and remaining internal volumes have at most
a fixed polynomial mass per label on the original energy shell.
Enlarge these ranges, leaving their original compatibility tests as
indicators. Normalize each finite reference factor and absorb all
masses into \((pJ)^{Cp}\). The entire ordered global time vector belongs
to the known variables \(\xi\).

There are at most \(p\) pins, \(O(p)\) nontrivial component choices,
and polynomially many cell/lifetime segment choices per pin. Their
discrete cost is \((pJ)^{Cp}\). All factorial coefficients are either
bounded by the same cost or retained as positive factors. We obtain
the actual joint domination
\[
 d|\mathfrak I_{\boldsymbol k}|
 \le\Big(\prod_i a_{i,k_i}\Big)(pJ)^{Cp}
       d\nu_0(\xi)\prod_{\ell=1}^k d\nu_\ell(\theta_\ell),       \tag{4}
\]
where the measures are probability product factors and selected-block
rotations are unconditioned Haar variables. This establishes concrete
chart domination without a derivative estimate for a many-body
scattering map and without dividing by the mass of a retained sector.

### 2. A constructive known-data invariant

Fix a possible list of first exposures, their one or two new tree
owners, and the participating lifetime/ray segments. First-exposure
*times* are not part of this discrete guess. Let \(S\) be the owners
already revealed. The invariant is:

1. The visible phase configuration, every installed visible trajectory,
   and every saved past of a revealed life are functions of
   \((\xi,\theta_S)\) only.
2. A dormant component not privately owned by a selected tree has
   relative paths depending on those same variables, with one
   unplaced common translation. Its absolute terminal velocities
   are known coordinates.
3. An unexposed selected tree is absent from the visible configuration.
   Its launch anchor is recorded from the visible state before its
   launch. Its scheduled private continuation uses just that anchor
   and its own block.

This invariant is derived from the allowed updates, not assumed for
the original constrained law. Here is the full case analysis.

At initialization the root coordinates and the nonselected terminal
data belong to \(\xi\). A nonselected dormant component is evolved
with its restricted original force system. Its internal pin normals
and times are known. Relative translation (1) merges two dormant
components using only their known relative paths; a common translation
remains unplaced. A dormant component cannot mix known labels with
unknown selected additions in a launch cell: a selected regular
addition is globally singleton in that cell. An internal addition of
an already hidden selected tree is a private addition in that owner's
block, not a dormant bath component.

When a known dormant component first roots through visible \(j\) and
its own \(i\), install it using
\[
 a_C=x_j(t)+\varepsilon n-q_i^C(t),\qquad
 x_\ell(t)=x_j(t)+\varepsilon n+q_\ell^C(t)-q_i^C(t).       \tag{5}
\]
Every quantity on the right is known. A common change
\(q_\ell^C\mapsto q_\ell^C+c\) cancels exactly, including for all
noncontacting members. The algebra is formalized by
`install_gauge_invariant`, `install_recovers`, and
`relative_merge_recovers`. Restricted union flow after installation
therefore remains known. Endpoint rooting uses its known overlap
displacement in place of \(\varepsilon n\).

No outside primary global pin has a hidden selected target. A pin
along an unchanged selected descendant is instead a private event of
that same tree. Thus a different tree's launch parent is visible.
At a genuine launch remove the continuing parent from the visible
state at the known time, without reading either output velocity.
Both outputs become private. At a passage leave the parent visible
and hide just the child. These updates do not inspect the fresh block
to continue any other visible line. The selected tree's own offset,
output velocities, and internal later relative data remain private.

An exposure supplies only its one or two named new blocks, evaluates
their current private phase points, installs those points, and
continues the restricted prescribed visible system. Future additions
of a now revealed tree are still not installed before their scheduled
pins. The saved private past and the resumed trajectory join at the
same phase point; revelation is not a new random placement.
Subsequent use of that saved past, including at another tree's launch,
therefore reads only previously revealed blocks.

At a mesh or layer boundary, remove terminating lines at the known
lifetime times, keep continuing hidden lines private, retain continuing
visible states, and initialize new dormant components with their known
data. The same cases apply again. An intact interacting polymer is
never split into unknown and known force-bearing pieces by a permitted
cut. In addition, a regular selected isolated arc cannot straddle a
cell boundary: its duration is less than the retained boundary margin
for sufficiently small \(\varepsilon\).

On the enlarged product domain use restricted known-data flows only.
Stop such a flow at its first excessive speed or invalid known initial
state, keep its positions fixed after stopping, and use zero velocity
for a later launch from a stopped anchor. An unavailable anchor makes
the list empty. This rule never tests a hidden path or a no-prior-hit
condition involving an unknown block. All known curves are uniformly
polynomially Lipschitz. Private scheduled binary paths have polynomial
speed as well: their launch drift is known and they add at most \(M\)
compact relative increments. These are Borel operations on finite
flow charts. First contacts of continuous paths on closed lifetime
segments and deterministic finite tie choices are measurable.

This exhausts every update: a restricted flow, internal dormant merge,
rooted installation, selected launch, reveal, or fixed cut. Therefore
the invariant holds after arbitrarily many such updates. The finite
support theorem `run_supported` formalizes its inductive propagation;
the concrete cases above discharge its local support specifications.
In particular, an absolute prelaunch bath path anchored to an unknown
future selected output is never used.

### 3. Agreement and event containment

First account for all types of marks in `cent:ownership` and the
following paragraph of `03-centering.tex`. Multiple-addition,
endpoint-overlap, and bad-parameter marks are among the irregularities
removed from a selected regular tree. A prescribed passage cannot
cross a required cut or be interrupted by a scheduled birth: its
duration is less than the boundary margin and the birth spacing.
A nonsingleton cut involving a selected line outside a prescribed
arc requires a preceding unprescribed entry contact. The remaining
cross-family, extra-pair, cluster, and detached/reference trajectory
marks are themselves geometric contacts. Consequently a first
uncharged defect of a regular selected tree is witnessed by a first
unprescribed contact of the types tested below. No separate
noncontact defect is discarded by this reduction.

Fix now an actual point of the retained original chart domain and its
actual exposure list. Induct simultaneously over global merger times,
launches, cuts, and listed first defects in backward order, with the
fixed tie rule. Internal bath collisions are not induction events:
their complete restricted Hamiltonian flow is used.

Before a dormant component's first rooted merger it has no contact
with any rooted path. Otherwise that earlier contact would be its
rooted merger. A primary merger into a hidden selected tree is
excluded by the selected-tree hypothesis. If a simultaneous root
merger is first tied to a visible target, install the component by
that visible pin first; its simultaneous secondary hidden contact is
an exposure at the same time. Nothing requires discarding such a tie.
Consequently dormant omission changes no rooted force before the
scheduled installation. Its internal merges recover its true relative
state, and the true contact equation makes (5) its true translation.
Uniqueness gives the true union motion afterward.

Before an unexposed selected tree's first defect it has no
unprescribed contact with a visible life, another hidden tree, or
itself. Its prescribed isolated binary arcs and free passages are
therefore exactly its private paths. A prelaunch contact of a regular
selected addition is impossible: in the global chart that would be
an earlier primary pin or a reroute, contrary to its unchanged
genealogy. Any later secondary contact is a defect, not a primary
attachment that can be silently absorbed. Removing a genuine
parent from the bath hence removes no actual bath force before
that tree's first defect.

Supply the block or blocks named in the next actual list entry.
Find the first eligible contact of the named type on its named
segments, after the preceding replayed exposure. Do not compare it
with a contact of some other still-hidden tree. Do not test that
another hidden tree has had no earlier contact. On this actual
stratum, the invariant and the preceding no-defect statements make
the replay's participating curves equal to the true curves. An
earlier eligible listed-type hit would contradict the actual
first-defect list. Thus the replay finds the actual contact time
and the actual phase points. Resume the known visible flow from
these points and use uniqueness.

At cuts, the original polymer and isolation restrictions prevent a
nonzero cross force from being transferred through a deleted hidden
line. A cross hidden/visible contact there is either an exposure
under the tie convention or one of the excluded cut irregularities.
The speed stop cannot occur on this stratum, by the original energy
budget. Induction therefore crosses every permitted cell and macro cut.

For a fixed guessed list the actual event is contained in the
intersection of its enlarged replay test events. Dropping comparisons
with other hidden hits only enlarges these events; it does not change
their reference law. This proves concrete agreement and containment,
not just the abstract support invariant.

### 4. Every concrete next test has a uniform gain

Put \(\tau=\varepsilon^{95/100}/4\) and
\(\delta=C_M\varepsilon^{96/100}\). In a private tree, a later
relative velocity is fixed in laboratory axes, not in a frame
rotated with an earlier output. Translation and Galilean covariance
therefore give, for every descendant of output \(i\) of a launch
at \(t_0\),
\[
 x(t)=x_0+(t-t_0)v_0+(t-t_0)Ra_i+G(t)+e(t),\quad
 |e(t)|\le C_M\varepsilon^{96/100}.                       \tag{6}
\]
Here \(G\) is independent of that launch rotation after all other
relative data are fixed. To verify (6), add each later fixed
relative increment to the current parent velocity and integrate.
The original drift passes unchanged down either branch. During a
two-body arc, subtract the common Galilean drift before replacing
the arc by its instantaneous outgoing broken rays; the error is
bounded by its duration times a compact relative speed. At most
\(M\) arcs and the \(O(\varepsilon)\) insertion offsets give the
stated error, without a polynomial launch drift in its constant.
For time reversed branches replace the spherical direction by
its negative.

For two descendants at their last common divergence, subtract the
two formulas. The coefficient is the nonzero outgoing relative
velocity (or the incoming relative velocity at a passage). The
common parent drift cancels. Its direction is spherical under
the divergence rotation. Thus internal contacts also retain an
available rotation, even though the two individual output
directions are correlated.

Here is the tube calculation, independently of any dynamics.
On \([a,2a]\), mesh at spacing
\(\delta/(2(V+r_1))\). A hit of \(tr\omega\) against an independent
\(V\)-Lipschitz curve implies a \(2\delta\)-hit at a mesh point.
There are \(O(1+a(V+r_1)/\delta)\) points, and each point permits
a spherical cap of measure \(O(\delta^2/(r_0^2a^2))\).
The assumption \(\delta\le\tau r_0/10\) absorbs the first mesh term.
Summing the dyadic intervals from \(\tau\) yields
\[
 {\mathbb P}_{\omega}(\hbox{hit after }\tau)
 \le {C(V+r_1)\delta\over r_0^2\tau}.                    \tag{7}
\]
For (6), \(r_0>0,r_1<\infty\) are the fixed compact increment
bounds and \(V\) is polynomial in \(p\). Hence (7), with the
interaction radius absorbed into \(\delta\), is at most
\[
 C p^b\varepsilon^{1/100}                              \tag{8}
\]
for fixed \(b,C\). The condition \(\delta\le\tau r_0/10\)
holds uniformly below \(p\le P^a\) for sufficiently small epsilon.

It remains to justify the initial interval in each actual next test.
This is not obtained by conditioning.

For a single-tree exterior test, fix \(\xi\) and the earlier
revealed blocks. By Section 2 all comparison curves, including
saved private pasts, are independent of the tested block. For a
life already displayed at the launch, retain the gate that its
extension to that launch is separated from the launch parent by
\(\rho\). This gate reads only known data and holds on the actual
selected stratum by Section 3 and the original separated-parent
condition. Since
\[
 O(\varepsilon)+Cp^b\tau=o(\rho),
 \]
it prevents contact before \(\tau\). If the gate fails on the
enlarged product domain, declare that early test empty.
A life not yet displayed at launch cannot be installed in this
initial interval: the launch cell has exactly one addition and
the launch lies at least \(4\tau\) from a cell cut. Such a target
is tested only after \(\tau\), when (7) needs no separation.

The exception is the unchanged parent of a passage. On the actual
stratum it has no third-path force in the first \(2\tau\):
old paths are separated by \(\rho\), speeds are polynomial,
and no birth or cut occurs there. Its prescribed relative
straight passage cannot return to that parent in this interval.
On the enlarged product domain test that parent only after
\(\tau\). This retains every actual first defect without
claiming that an artificial stopped parent is free.

For a two-tree contact, first fix the earlier-launched tree \(A\)
and integrate the later-launched tree \(B\)'s rotation. Its launch
anchor is independent of its own block by Section 2. Any \(A\)
life already displayed at \(B\)'s launch is separated from that
anchor by the original parent gate. Retain this gate, which reads
\(A\)'s fixed block but not \(B\)'s rotation. It prevents an
early hit by the same speed calculation. An \(A\) descendant
not yet displayed at that launch is tested only after \(\tau\);
the globally singleton cell and boundary margin exclude its
installation earlier. Apply (7) to \(B\) against the fixed
private paths of \(A\). The result (8) is uniform in \(A\), so
integrating \(A\) costs no additional factor.

For an internal defect use the last common divergence in (6).
The prescribed pair encounter is exempt. It completes before
\(\tau\), and its free outgoing relative ray cannot return
without another velocity change. The retained birth spacing
excludes that change before \(2\tau\). For later ray pairs
apply (7) to the relative formula at the divergence. A union
over the at most \(M^2\) pairs is harmless. The union over
exterior lifetime/cell segments costs only a polynomial in
\(p,J\); segment choices are already part of the list factor.

All three tests therefore have reference measure at most
\(\rho_p=Cp^b\varepsilon^{1/100}\), uniformly in earlier
revealed coordinates. In particular \(\rho_p\le1\) uniformly
for \(p\le P^a\) after reducing epsilon once.

### 5. Multiplication and the claimed exponent

For a fixed exposure list let \(B_m\) be the set of tree owners
newly exposed at entry \(m\). A contact has at most two hidden
owners. Revealing an internal defect or a hidden/visible contact
exposes one. These sets are nonempty, disjoint, and cover the
\(k\) selected trees. Thus there are at least \(k/2\) entries,
as also certified by the universal finite counting theorem.

Let \(A_m\) be its enlarged successful contact test, including
the gates of Section 4. Sections 2--3 give
\[
 A_m=A_m(\xi,\theta_{B_1},\ldots,\theta_{B_m}),\qquad
 E_{\rm actual,list}\subseteq\bigcap_m A_m ,
 \quad
 \int{\bf1}_{A_m}\,d\nu_{B_m}\le\rho_p .                 \tag{9}
\]
The bounds hold for every fixed earlier value; they are not
conditional bounds obtained by fixing all the other original
history variables. Integrate (4) in reverse list order. All
earlier indicators omit the last new block, so (9) removes the
last indicator at cost \(\rho_p\); repeat. The result is at
most \(\rho_p^{\#\{m\}}\le\rho_p^{k/2}\).

The finite list and forest guesses cost \((pJ)^{Cp}\) once
more, which is absorbed by enlarging \(C\). Finally
\(\sum_{\boldsymbol k}\prod_i a_{i,k_i}=\mathcal A_p\).
This proves Theorem CE with the explicit positive exponent
\(1/100\).

### 6. Uniformity at power-growing complexity

We now check rather than assume that the preceding proof has no hidden
polylogarithmic restriction. The prescribed force systems and cuts are
fixed. The actual speed bound is \(V_*=\sqrt{2(R+B_{\rm stab})p}\),
independent of the mesh count. A private tree adds at most \(M\)
compact increments and has at most \(M\) scattering-arc errors. Its
speed, its error constant, and the known-data stopping speed therefore
have fixed polynomial bounds in \(p\), independent of \(J\).
The same is true of a single tube test against one fixed target
segment. A comparison curve may have many bath collisions; only its
Lipschitz bound enters (7). Extend a finite target segment constantly
beyond its endpoints when applying that estimate, which can only
enlarge its hit event and preserves that bound and its coordinate support.

There are at most \(p\) pins, regardless of the number of empty cells.
The force partition at a cut is specified, not a new random branch.
Each pin chooses at most polynomially many labels, merger orders and
cell/lifetime segments. There are at most \(k\le p\) first-exposure
entries; each chooses at most two owners and two target segments among
\(O(pJ)\) possibilities. Thus all forest and exposure-list choices cost
\((CpJ)^{Cp}\), not \(\exp(CpJ)\). Deterministic cuts may entail \(O(pJ)\)
updates, but the support induction and exact agreement impose no bound
on their number and incur no multiplicative probability cost per update.

All continuous reference masses have a fixed polynomial cost per label:
the source-to-root displacement is at most \(TV_*\); source unit-cube
volumes are one; remaining velocities and fluxes have polynomial ranges;
and time coordinates may be dominated by a full interval of length \(T\).
Neither normalization nor the contact area formula introduces a power
of \(J\) per empty cell. The selected-tree block has fixed size, so its
radial and arc constants do not grow with \(p,J\).

Choose one \(B\ge1\) large enough to dominate the finitely many constants
and polynomial degrees just listed, including every coefficient in a
smallness comparison. The joint reference and discrete-list cost is
at most \((BpJ)^{Bp}\), the one-test gain is at most
\[
                         \rho_p=Bp^B\varepsilon^{1/100},       \tag{10}
\]
and every early-motion coefficient is at most \(Bp^B\).
This choice of \(B\) precedes the choice of \(\alpha\).
The construction and the agreement proof are otherwise unchanged.
In particular, no regular-tree selection statement from the larger
range is used.

For \(p\le\varepsilon^{-\eta}\), the proposed value of \(\eta\) obeys
\[
 B\eta\le{1\over2400},\quad
 {1\over100}-B\eta\ge{23\over2400}>0,\quad
 {1\over10}-B\eta\ge{239\over2400}>0.                    \tag{11}
\]
Consequently (10) tends uniformly to zero. The displacement comparison
in the initial interval is bounded by
\(C\varepsilon^{1/10-B\eta}\) relative to the parent-separation scale.
All the other fixed rational gaps are at least \(1/100\), so they
remain positive even after the same deliberately excessive polynomial
loss. This also covers the arc-to-time comparison. Every cut and
birth-spacing exclusion used in Sections 2--4 therefore remains valid
uniformly. Freshness and actual-event containment do not require a
smallness assumption beyond these explicitly listed comparisons.

Reverse integration now gives, on this larger range,
\[
 {\mathfrak I\over\mathcal A_p}
 \le (BpJ)^{Bp}
             (Bp^B\varepsilon^{1/100})^{k/2}.            \tag{12}
\]
Write \(L=|\log\varepsilon|\). After reducing epsilon so that
\(\rho_p\le1\), use \(k\ge\alpha p\) and
\(\log p,\log J\le\eta L\). The logarithm of (12), divided by \(p\),
is at most
\[
 (B+\alpha/2)\log B+
 \left\{(2B+\alpha B/2)\eta-{\alpha\over200}\right\}L.
\]
The exact scalar inequality
\[
 (2B+\alpha B/2)\eta-{\alpha\over200}
                       \le-{3\alpha\over800}           \tag{13}
\]
follows from
\((3B+1)\eta=\alpha/800\), \(B\ge1\), and \(\alpha\le1\).
Choose \(L\) large enough that
\((B+\alpha/2)\log B\le\alpha L/800\).
The last display is then at most \(-\alpha L/400\), which is
stronger than (PCE). Cases with \(\mathcal A_p=0\) follow directly
from the source-weighted majorant and need no division.

This improves the *conditional exposure range* from the staged
polylogarithmic \(p,J\) to a fixed power range and retains an extensive
epsilon exponent after paying the full list and chart cost. It is not
an extension of the main kinetic theorem: terminal-tree existence,
exceptional-set estimates and the remaining closure dependencies
are separate, presently open obligations.

The Jacobian adapter was queried before adding the scalar certificate.
Its first five discovery candidates did not name the required universal
multivariate implication. The nearest inspected contract,
`polynomial.real.strict_sublevel_measure.compute`, computes a univariate
strict sublevel measure on a rational interval; its typed contract is
archived in `jacobian_power_contract.json`. It does not certify (11)--(13)
and was not run or treated as evidence. The successful contact-chart
operation remains the Jacobian evidence. The multivariate parameter
inequalities are instead checked by the Lean declarations described
in the fidelity document and by exact nonnegative decompositions in
the standalone replay.

## Evidence classification and remaining review

Theorems CE and PCE are analytic proofs submitted for review, not finite
numerical experiments. `Main.lean` formalizes only the universal
translation/support/counting, polynomial, and scalar-parameter core
described in `statement_fidelity.md`.
`verify.py` and `exact_certificate.json` independently replay exact
identities and rational exponent conditions, and inspect the real
Lean record. They do not mechanically verify the continuous ODE,
area-formula, tube, or semantic-agreement arguments of Sections 1--4.
Those arguments and the fidelity of their selected-history hypotheses
require the normal independent Reviewer.

No false literal manuscript assertion has been established by this
route, so no `F_` refutation judgement is justified. Neither the two
main limit theorems nor the terminal-tree selection/discard bounds
are being declared independently verified. Publication significance
and novelty are not established by the algebraic checks or by the
source map and must not be inferred from them.

In particular, Theorem CE takes the specified selected trees as
input, exactly as Proposition `exp:exposure` does. It does not import
the truth of the separate selection/exponential-discard theorem as
an assumption of its causal argument. Establishing that enough such
trees can be selected remains a separate dependency of `exp:defects`
and the final kinetic-limit theorem.

The standalone exact replay is:

```sh
$WORKSPACE/argus-live-update/.venv/bin/python research/audits/causal-exposure/verify.py
```

It uses the already installed SymPy and standard Python, needs no
network or Jacobian service, and writes nothing. It checks the original
typed payload against the archived Jacobian response, recomputes the
determinant independently, verifies the sphere normal and area-vector
orientation and dormant translation algebra, checks the rational
scale gaps, and verifies freshness and claim attachment of the real
Lean compiler certificate. It also checks universal nonnegative
decompositions for the power-complexity scalar bounds, not a sampled
parameter grid. The hashes it reads are the required
official Lean source/fidelity bindings, not additional audit hashes.

An independent compiler replay uses:

```sh
$WORKSPACE/argus-live-update/.venv/bin/python -m argus_skill.verticals.math.lean_evidence verify research/audits/causal-exposure/Main.lean --statement-fidelity research/audits/causal-exposure/statement_fidelity.md --artifact-dir research/audits/causal-exposure/lean --claim L_CAUSAL_CORE --project-root .
```

The host's prebuilt Mathlib workspace is used; this project has no new
Lake configuration. The earlier support/gauge elaboration errors and
the extended real definition's missing `noncomputable` annotation were
recorded as inconclusive, not mathematical refutations. The current
source compiled with Lean 4.31.0:
compiler exit 0, axiom-audit exit 0, and no proof holes. The successful
archive, rather than either failed record, is cited by the exact certificate.
