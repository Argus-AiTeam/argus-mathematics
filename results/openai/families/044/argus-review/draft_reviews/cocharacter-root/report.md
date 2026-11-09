# ENGINEER source-fidelity assessment: cocharacter-root

Assessment: the source supplies substantive root-support, moment-block,
and complementary-monopole arguments. The fixed-ideal comparison is
conditionally supported, in particular on the polynomial Hall-map
interface. The moment lemma guarantees a scalar subgroup of the
stabilizer, not that the whole stabilizer is exactly scalar.

## Exact claims and hypotheses

The assigned source-only versions are:

- C_ROOT_CHARGE@1: the stated dressed minuscule charges decompose into
  root-supported charges;
- C_ROOT_MOMENT@1: a root charge of character weight zero admits the
  stated moment-level block;
- C_COCHAR@1: regularity makes the stability-cocharacter and
  full-topological-torus fixed-scheme ideals equal.

The precise root-support set for any finite unframed quiver \(\Gamma\) is
\[
\Delta_\Gamma=\{0\ne\gamma\in\mathbb N^{\Gamma_0}:
                     A_{\Gamma,\gamma}(q)\ne0\},
\]
the support of the Kac polynomials counting absolutely indecomposable
representations. With loops it is **not** being identified with a
loopless Kac--Moody root system.

For \(0<\mathbf b\leq\mathbf d\), either sign \(\epsilon\), and any
stabilizer-invariant dressing \(p\), root-charge generation asserts a
finite identity
\[
M^\epsilon_{\mathbf b,p}
 =\sum_r c_r a_{r1}\cdots a_{rk_r},\qquad
c_r\in R_{\Gamma,\mathbf d,F},\quad
\deg_{\mathrm{top}}a_{rh}=\epsilon\gamma_{rh},\quad
\gamma_{rh}\in\Delta_\Gamma,\quad
\sum_h\gamma_{rh}=\mathbf b.
\]
The factors need not be minuscule. Arrow flavors are characters, and
polynomial parameter identities are specialized only after their
construction.

The moment assertion is: for \(\gamma\in\Delta_\Gamma\) and a real
central parameter \(\theta\) with \(\theta\cdot\gamma=0\),
\[
\mu_{\mathbb C}^{-1}(0)\cap
 \mu_{\mathbb R}^{-1}(\tau_\theta)\ne\varnothing,\qquad
\tau_\theta(\xi)=\sum_i\theta_i\operatorname{tr}\xi_i.
\]
The simultaneous scalar circle fixes every point of this unframed
representation. Neither stability nor an exactly one-dimensional
stabilizer is asserted for each block.

For the framed quiver and commuting flavor torus of the main theorem,
let
\[
J_\nu=\langle(A_F)_m:m\ne0\rangle,\qquad
J_{\mathrm{top}}=\langle A_F^{(d)}:d\ne0\rangle.
\]
Under stable-equals-semistable and free gauge action on
\(\mu^{-1}(0)\), C_COCHAR asserts \(J_\nu=J_{\mathrm{top}}\), hence
\(A_F/J_\nu\simeq B_F\), preserving coefficients and both gradings.
Regular characters may satisfy \(\nu\cdot\mathbf b=0\) for some
bounded nonzero dimension vector. Empty semistable loci are included.

## Source attribution and old disposition

OpenAI, *The equivariant cohomological Hikita conjecture for arbitrary
quivers*, September 24, 2026, revision
`4eaee87548250b2682affda7d05d947c05554bae`.
Source root:
`openai-math/preprints/The-equivariant-cohomological-Hikita-conjecture-for-arbitrary-quivers-September-24-2026`.
All three claims are in `build/sections/cocharacters.tex`:
`lem:root-charge-generation`, `eq:root-charge-words`,
`lem:root-moment`, `prop:cocharacter-fixed`,
`eq:central-splitting`, and `eq:complementary-monopoles`.
The map input is `lem:polynomial-monopole-maps`; minuscule generation
and removal of gauge-trivial flavor summands are in
`build/sections/preliminaries.tex`, `prop:minuscule` and
`lem:trivial-summands`.

The cocharacters source matches SHA-256
`ce58a31d9dae7a3f30fae450a816d82042b57362f37e0ef253b886eb87822f3a`
in
`campaigns/9100044/MANUSCRIPTS.json`.
All ten source hashes and nine existing snapshot hashes match read-only.
The old manuscript reference is a symlink to this source, not a separate
historical source snapshot. No Git operation was used.

The three historical versions have no independent Argus proofs or
certificates and remain open in the old graph. The old cut-symbol
certificate does not establish root support, moment-level nonemptiness,
or equality of these two ideals.

## Root-charge argument and exact primary support

The source first works over independent
\(S=\mathbb Q[\hbar,u_a]\). On the tripled quiver the weights are
\(-u_a,\ u_a-\hbar,\ \hbar\). Independence verifies the required
generic conditions before specialization: no nontrivial nonnegative
relation among \(u_a,\hbar-u_a\), and loop weights are outside
\(\mathbb Z\hbar\). This does not claim that the final, possibly
nongeneric, flavor specialization itself satisfies those conditions.

The following theorem-level passages were retrieved from Shivang
Jindal and Andrei Negut, *The loop-nilpotent cohomological Hall algebra*,
**arXiv:2607.23544v1**:
<https://arxiv.org/html/2607.23544v1> and
<https://arxiv.org/pdf/2607.23544v1>.

- Proposition 3.7 identifies the loop-nilpotent Hall algebra with its
  shuffle half under the specified generic assumptions.
- Theorem 3.10 and the **PDF's Equation (109)** give the polynomial
  parameter-module PBW/integrality statement for the loop-nilpotent
  BPS descendants.
- Proposition 3.14 identifies the image of the loop-nilpotent BPS
  space with \(\hbar\) times the full BPS space; Corollary 3.15 gives
  generation by its descendants over the rational-coefficient parameter
  ring, without adjoining \(1/\hbar\).
- Section 3.10 gives
  \[
  \operatorname{grdim}\mathfrak g^T_{\tilde Q,\tilde W,\gamma}
       =(1-t)^{-\operatorname{rank}T}A_{Q,\gamma}(t^{-1}),
  \quad
  \operatorname{grdim}=\sum_d(-1)^d\dim H^d\,t^{d/2}.
  \]
  Vanishing of a Kac polynomial forces each cohomological piece to
  vanish: the degree variable has not been forgotten. The injective
  BPS comparison transfers the vanishing to the loop-nilpotent part.

The PDF was read in memory because some HTML equation numbers differ.
Its Section 2.2, (29)-(30), and Remark 2.6 also explain why the universal
equivariant parameter setting, rather than arbitrary field-valued
exponentials, is appropriate.

Keeping dimension-vector degree \(\mathbf b\) expresses each
distinguished shuffle element as a finite polynomial-parameter sum of
words in descendants with support in \(\Delta_\Gamma\).
The separately assessed polynomial maps transfer those identities to
the Coulomb algebra; constant signs are absorbed in coefficients.
For general dressings, complementary power sums equal total power sums
minus selected power sums, so every stabilizer-invariant dressing is a
sum of coefficients times selected-variable dressings.
There is no need to assert that entire Hall components beyond
\(\mathbf d\) vanish, nor to divide a finite identity by a parameter.

## Moment-block argument

A nonzero Kac polynomial gives geometrically indecomposable points in
infinitely many residue characteristics. Decomposability is the
existence of a nontrivial idempotent endomorphism, a constructible
incidence condition over \(\mathbb Z\). Its complement and image in
\(\operatorname{Spec}\mathbb Z\) are constructible. An infinite image
cannot omit the generic point, so there is an indecomposable complex
representation \(x\) of dimension \(\gamma\).

Every endomorphism of \(x\) has a single eigenvalue, since distinct
generalized eigenspaces would split the representation. Thus
\(e=c\,\mathrm{id}+n\) with \(n\) nilpotent, and
\(\tau_\theta(e)=c\,\theta\cdot\gamma=0\).
The image of the linear cotangent moment map with \(x\) fixed is the
annihilator of \(\operatorname{End}_\Gamma(x)\). Hence the complex
moment fiber at \(\tau_\theta\) is nonempty.

A closed orbit in the closure of an orbit in that invariant central
fiber meets real moment level zero by zero-character affine
Kempf--Ness. Quaternionic rotation on the flat representation then
rotates \((0,\tau_\theta,0)\) to
\((\tau_\theta,0,0)\), with a common normalization adjustment.
The simultaneous scalar acts trivially on every arrow and its dual.
This gives precisely the nonempty block and the scalar **subgroup**
needed later. The source cites Crawley--Boevey, Lemma 3.1 and
Theorem 3.3, for the trace-annihilator mechanism, and King/HKLR for
the moment-level comparison. It does not prove that the block's
stabilizer has no additional elements.

## Complementary monopoles and equality of full ideals

Adjoin one dimension-one vertex \(\infty\), with \(w_i\) arrows
\(i\to\infty\), and let \(\mathbf d=(\mathbf v,1)\).
The group isomorphism
\(((g_i),c)\mapsto((cg_i),c)\) splits off an ineffective scalar:
\[
A_{\widehat Q,\mathbf d,F}
 \simeq A_F\otimes\mathbb C[\xi,z,z^{-1}].
\]
Here \(z\) is an invertible, degree-zero **central monopole**, not the
added-loop mass in the deformation section. Its full charge is
\(\mathbf d\).
Extend the character by
\(\widehat\nu=(\nu,-\nu\cdot\mathbf v)\); both \(\xi\) and \(z\)
have weight zero. The extension of cocharacter quotients is faithfully
flat.

Original coefficient roots are
\(x_{i\alpha}=\widehat x_{i\alpha}-\xi\), with flavor parameters
unchanged. For a positive generator use
\(\mathbf b=(\mathbf b',0)\) and the substituted dressing
\(p^\uparrow\). Central translation gives
\[
M^+_{\mathbf b,p^\uparrow}
      =z\,M^-_{\mathbf d-\mathbf b,p^\uparrow}.
\]
The stabilizer groups agree, so the same dressing is admissible on
both sides even if it is not selected-variable-only.

Suppose that a generator survived in the cocharacter quotient. Its
root-word identity would have a nonzero summand all of whose factor
weights are zero, since every nonzero-weight factor is in the defining
ideal. The complementary generator also survives because \(z\) is a
weight-zero unit. Applying the other half yields decompositions of both
\(\mathbf b\) and \(\mathbf d-\mathbf b\) into weight-zero Kac-supported
vectors. Both sums are nonempty because \(\mathbf b\ne0\) and
\(b_\infty=0<d_\infty=1\).

Take the orthogonal direct sum of the moment blocks for all these
vectors. It has zero complex moment and real moment
\(\tau_{\widehat\nu}\), hence represents a semistable point of the
original framed theory after removing the ineffective scalar.
At least two independent block scalar circles stabilize it. Dividing
by the one ineffective diagonal scalar leaves positive-dimensional
stabilizer, contradicting regular freeness. If the semistable locus
is empty, the construction already contradicts emptiness.
The negative-generator case interchanges the halves.

Thus every nontrivial minuscule generator lies in \(J_\nu\), so
\(J_{\mathrm{top}}\subseteq J_\nu\). The reverse inclusion is automatic
because nonzero cocharacter weight implies nonzero full charge.
This is an equality of actual ideals, without arguments about closed
points or radicals, and therefore retains nilpotents.

## Supported scope and remaining obligations

The root-to-block and complement-to-stabilizer arguments are coherent
under their inputs. Regularity is not silently replaced by the stronger
condition \(\nu\cdot\mathbf b\ne0\) for every bounded \(\mathbf b\).
The source's disconnected two-vertex example with
\(\mathbf v=\mathbf w=(1,1)\), no arrows, and \(\nu=(1,-1)\)
illustrates why zero total character weight alone is not survival.

The decisive unestablished upstream input in the old inventory is
C_POLY_MAPS: its general rational degeneration and sign/regularity
interface must preserve these finite polynomial identities.
Arbitrary-flavor BFN minuscule generation, the ineffective-scalar
splitting, and coefficient substitution must also be independently
verified with the stated conventions. The Kac/constructibility,
closed-orbit Kempf--Ness, and quaternionic rotation inputs have been
examined in the source argument but are not independent old
certificates; the primary Hall theorem statements provide scope
evidence, not a replay of their full proofs.

No contradiction in the assigned historical statements was found.
Strengthening the moment lemma to an **exactly** scalar stabilizer would
be unsupported and unnecessary, not a consequence of this assessment.

Classification: source-only proposed root/cocharacter argument using
known Hall, Kac, and moment-map mechanisms; originality unverified.
The argument does not depend on assuming the full-torus Hikita theorem.
Native Host-invoked independent review is required and pending, without
engineer self-acceptance.
