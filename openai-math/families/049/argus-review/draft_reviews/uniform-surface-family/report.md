# Uniform surface family — engineering assessment

**Claim:** `C_DANIELEWSKI_RESTRICTION`, version 1, ledger content hash
`c0982a33a213c248653608dece36e9c5a33dcbedf29510b4d28abf08ed2b9ce3`.
**Engineering verdict:** the strongest stated mathematical claim is supported
by the checked prose deduction below. **Formal coverage:** partial; the
arbitrary-polynomial family is not a theorem asserted by the eight printed
Lean declarations. **Independent review required:** yes; no acceptance is granted.

## Contract, sources, version, and attribution

This assesses old `report.md` Theorem 3, with **every**
\(\psi\in\mathbb C[T]\), including zero and repeated-root polynomials.
The current `OBJECTIVE.md` and `research/DRAFT_REVIEW_INDEX.json` govern.
Old ledger verdicts and its graph's current-route label are not proof.

- `SC = families/049/first-pass/stable_core_certificate`
- `FS = SC/formal_sources/OAI/AlgebraicGeometry/StableCoordinate`

The preserved draft `SC/report.md`, uniform-family subsection starting at line 273, has SHA-256
`68b969f393762d6b834c6b0e03ce5a1eb82a2e8944c97af14313184acecbd875`.
Its authorial role is an old Argus engineering extension/corollary, reusing
the OAI determinant-ring implementation. It is not a printed theorem
of the cited October manuscript.

The source comparison is OpenAI, *A stable coordinate that is not a coordinate
in four variables*, October 5, 2026, revision
`4eaee87548250b2682affda7d05d947c05554bae`, especially
`sections/04-bundle.tex` and `sections/05-rigidity.tex`. Those sections
treat the fixed ideal \(I=J_T\) and fixed polynomial
\(v=a^3b+a^2u^2-d^2\). Their respective SHA-256 values
`332df2ac44774e20ab0c4b4d988c1274c7579b9ae0f4d1112199b4f50b217414`
and
`a27d1e5381626ace7c75640598312beb6a44b8f8f5bc183f5b7f2f114c444819`
were matched against the existing campaign 9100049 `MANUSCRIPTS.json`.
The arbitrary-\(\psi\) quantifier and resulting surface-family formulation
are a genuine extension relative to those inspected statements. Their global
novelty, priority, or significance is **not asserted**.

## Exact strongest claim and hypotheses

Work over \(\mathbb C\), and set
\[
 B=\mathbb C[x,y,z,u]/(xy-z(z+1)),\quad Y=\operatorname{Spec}B.
\]
For any polynomial \(\psi\), including \(\psi=0\), put
\[
 t_\psi=u^2+\psi(x),\qquad s_\psi=y-xt_\psi,\qquad
 J_\psi=(t_\psi-s_\psi^2,\ z-s_\psi x).
\]
The claim has three distinct parts:

1. For every **nonzero** locally nilpotent \(\mathbb C\)-derivation \(E\)
   of \(B\), \(J_\psi\cap\ker E=\{0\}\); equivalently the restriction
   \(\ker E\to B/J_\psi\) is injective.
2. There is a quotient-algebra isomorphism
   \[
   B/J_\psi\simeq
   \mathbb C[X,S,U]/(S^2-U^2-\psi(X))
   \simeq\mathbb C[X,R,V]/(RV-\psi(X)).
   \]
3. There is no nonzero LND \(E\) with \(E(J_\psi)\subseteq J_\psi\).
   Consequently no nontrivial algebraic additive-group action on \(Y\)
   preserves this **whole closed subscheme**.

There is no smoothness, squarefreeness, nonzero-parameter, or irreducibility
hypothesis. No positive-characteristic or arbitrary-base-ring version of
these geometric conclusions is being claimed. The fact that Theorem 1
allows arbitrary rings does not remove the field and characteristic
hypotheses from its LND applications.

## Checked quotient, including \(\psi=0\)

Let \(F=S^2-U^2-\psi(X)\). Define the forward map by
\[
 (x,y,z,u)\longmapsto
 \bigl(X,\ S+X(U^2+\psi(X)),\ XS,\ U\bigr).
\]
Substituting in the quadric relation gives
\[
 X\{S+X(U^2+\psi(X))\}-(XS)(XS+1)=-X^2F.
\]
The image of \(s_\psi\) is \(S\), and the two ideal generators have
images \(-F\) and 0. Thus the map descends to \(B/J_\psi\).

Conversely send \(X,U,S\) to \(x,u,s_\psi\) in \(B/J_\psi\).
The image of \(F\) is \(-(t_\psi-s_\psi^2)=0\).
The composites fix \(x,u\), recover \(s_\psi\), and recover
\[
 y=s_\psi+xt_\psi,\qquad z=xs_\psi\pmod{J_\psi}.
\]
They fix \(X,U,S\) in the other direction as well. This proves an isomorphism
of the actual quotient algebras. In particular it never cancels \(X^2\)
from the substituted quadric relation: that alone would have lost
information at \(X=0\).

The second isomorphism uses \(R=S-U,\ V=S+U\), with polynomial inverse
\(S=(R+V)/2,\ U=(V-R)/2\). Division by 2 is legitimate over
\(\mathbb C\). Every identity remains valid when \(\psi=0\); no chart or
component has been removed.

### Reducedness and singular/reducible members

Neither the isomorphism nor the LND argument below requires
\(B/J_\psi\) to be a domain, smooth, or even known reduced. Factorial
closure will be applied in a different, fixed domain \(C\).

For clarity, these particular quotients are in fact reduced for all \(\psi\).
If \(\psi\ne0\), \(RV-\psi(X)\), viewed as a polynomial in \(V\) over
\(\mathbb C[X,R]\), is primitive and linear, with relatively prime
coefficients \(R,-\psi(X)\). It is irreducible, hence prime in the
polynomial UFD. Repeated roots of \(\psi\) do not change this argument:
they can cause singularities, not nilpotents in this quotient.
If \(\psi=0\), then
\[
 (RV)=(R)\cap(V)
\]
in \(\mathbb C[X,R,V]\), an intersection of distinct prime ideals.
The surface is the reduced union of two affine planes meeting along a
line; it is not a domain. Thus \(J_\psi\) is radical in \(B\) for every
parameter. This optional verification supports a reduced-variety reading,
but radicalness is not being used to replace scheme-theoretic preservation
by a weaker assertion in the proof.

## Checked invariant restriction for all polynomial parameters

Let
\[
 C=\mathbb C[a,d,b,c,u]/(ac-bd-1),\qquad
 \iota:B\longrightarrow C,\quad (x,y,z,u)\mapsto(ab,dc,db,u).
\]
This map is injective. The actual \(D(z+1)\) and \(D(z)\) bundle charts
cover the base, with Laurent fiber coordinates \(a,d\), respectively.
The source proves injectivity; formally `BundleCharts.baseMap_injective`
even does so by two explicit local sections without needing a domain
hypothesis on the coefficient ring.

Apply the **arbitrary-\(t\)** Theorem 1 inside \(C\), at
\(t=u^2+\psi(ab)\). It gives the equality of extended ideals
\[
 J_\psi C=(v_\psi),\qquad
 v_\psi=a^2u^2-d^2+W_\psi,\qquad
 W_\psi=a^2\psi(ab).
\]
The first generator and the second generator of \(J_\psi\) map to
\(t-(dc-abt)^2\) and \(bd-(dc-abt)ab\), exactly as required; this is
not just equality of their zero sets.

Write \(\psi(T)=\sum_{n\ge0}\lambda_nT^n\), a finite sum. For the actual
auxiliary grading \(\deg(a,d,b,c,u)=(0,1,-1,0,1)\),
\[
 W_\psi=\sum_n\lambda_n a^{n+2}b^n,\qquad
 \deg_{\rm aux}(a^{n+2}b^n)=-n\le0.
\]
Thus its components above degree 0 vanish, which is stronger than
Theorem 2's bound of 1. This covers arbitrarily large degrees of \(\psi\),
its constant term, repeated roots, and the zero polynomial \(W_\psi=0\).
No enumeration of polynomials or derivations is involved.
The degree-2 component of \(v_\psi\) is the nonzero \(a^2u^2-d^2\);
hence \(v_\psi\ne0\) uniformly. A fixed numerical evaluation of \(v_\psi\)
would not establish this for all constant terms, so that shortcut is not used.

Now suppose \(0\ne h\in J_\psi\cap\ker E\) for a nonzero LND \(E\) of
\(B\). The unconditional lift
`LiftObstruction.exists_weight_preserving_lnd_lift` supplies an LND
\(\widetilde E\) of \(C\) preserving every fiber-weight space, with
\[
 \widetilde E(\iota(b))=\iota(E(b))\quad(b\in B).
\]
**The unconditional lemma matters:** `lift_invariant` and the printed
`unrestricted_invariant_exclusion` only mention the fixed ideal \(I=J_T\);
one cannot apply those specialized conclusions directly to arbitrary \(J_\psi\).

Because \(\iota\) is injective, \(\widetilde E\ne0\): if it were zero,
the extension equation would give \(\iota(E(b))=0\) for every \(b\),
forcing \(E=0\). Also \(\iota(h)\ne0\). The actual ideal equality gives
\[
 \iota(h)=v_\psi q\ne0
\]
for some \(q\in C\). Both factors are nonzero. The fixed determinant
ring \(C\) is a characteristic-zero domain, so factorial closure of the
LND kernel yields \(\widetilde E(v_\psi)=0\).
It is not factorial closure in the possibly reducible surface quotient.
Theorem 2 applied to \(W_\psi\) now forces \(\widetilde E=0\), a
contradiction. This proves the invariant-intersection assertion uniformly.

The kernel of the restriction homomorphism
\(\ker E\to B/J_\psi\) is exactly \(J_\psi\cap\ker E\), so its
injectivity is genuinely equivalent. The induced morphism to
\(\operatorname{Spec}(\ker E)\) is dominant; no finite-generation claim
about this invariant algebra or existence of a finite-type quotient is
required.

### Scope of the action-lift dependency

The lift is a separately proved ingredient shared with the
`october-unrestricted-obstruction` unit, not a consequence of a symbolic
identity. The inspected October proof realizes \(\operatorname{Spec}C\)
as a punctured line bundle on \(Y\). The two base chart rings are
polynomial localizations
\(\mathbb C[x,t,u,(xt+1)^{-1}]\) and
\(\mathbb C[x,t,u,(xt-1)^{-1}]\).
These rings and their polynomial extensions are noetherian UFDs, so their
line bundles are trivial. Transitions in a polynomial ring over a domain
are units independent of the action parameter. This proves that pullback
along the action preserves the line bundle's isomorphism class.
A lift normalized at parameter zero has a group-law discrepancy which is
a unit of \(B[S,T]\); it is parameter-independent and equals 1 at \((0,0)\).
This establishes an action, not merely unrelated fiber isomorphisms.
Differentiation in characteristic zero gives the stated LND.

The formal implementation uses another actual construction:
`NormalizedDeterminantLift.liftHom` constructs a normalized polynomial
determinant frame; `FrameLiftCoassoc.actionOfNormalizedExtension` proves
its group law; `DeterminantLiftWeights` and `DeterminantActionWeights`
prove weight preservation. `LiftObstruction` then constructs the LND
and its extension identity. The unconditional lift has no \(I\) or
\(J_\psi\) premise and therefore applies here.

## Concrete stable-ideal proof of nonstabilization

The ideal is not the zero ideal. For every \(\psi\), the actual quadric
point \((x,y,z,u)=(0,0,-1,0)\) satisfies \(xy=z(z+1)=0\), while
\[
 g_\psi=z-s_\psi x=-1.
\]
Thus \(g_\psi\ne0\) in \(B\) and \(g_\psi\in J_\psi\).

Suppose \(E\ne0\) is an LND and \(E(J_\psi)\subseteq J_\psi\).
All iterates of \(g_\psi\) stay in \(J_\psi\).
Let \(N\ge1\) be the least exponent with \(E^N(g_\psi)=0\), which
exists by local nilpotence. Then
\[
 0\ne E^{N-1}(g_\psi)\in J_\psi\cap\ker E,
\]
contradicting the already proved invariant-intersection assertion.
This includes \(N=1\), where \(g_\psi\) itself is the invariant.
It supplies the precise nonzero-invariant lemma needed for a stable
ideal; stability alone without a nonzero element would not suffice.
It does not require the ideal to be prime or radical.

Over \(\mathbb C\), an algebraic additive action corresponds to an LND.
Ideal preservation under an LND gives preservation under its finite
exponential, and a scheme-preserving action gives ideal preservation on
differentiation. Characteristic zero ensures that a nontrivial action has
a nonzero corresponding LND. This proves the stated action conclusion.

The conclusion is about preservation of the **embedded whole subscheme**.
It does not say that the abstract Danielewski-type surface has no additive
actions, nor that each component of the \(\psi=0\) surface satisfies a
separate restriction/nonstabilization theorem. It does not construct
stable noncoordinate four-variable polynomials for every \(\psi\).

## Evidence/dependency table and kernel boundary

| Component | Inspected source or declaration | Verdict |
|---|---|---|
| Literal definitions and strongest quantifier | `SC/report.md`, Theorem 3; old ledger `C_DANIELEWSKI_RESTRICTION` v1 and graph node | supported by the checked argument, not their status labels |
| Quotient algebra and split coordinates | `SC/verify.py:198–218`; `exact_certificate.json`, `family_quadric_transport`, `family_s_recovery`, `family_first_generator`, `family_second_generator`, `family_split_surface` | supported; symbolic `psiX` may be replaced by any polynomial, but these checks alone do not prove an LND theorem |
| Nonzero ideal element at all parameters | Same sources, `family_boundary_nonvanishing`; explicit evaluation above | supported |
| Arbitrary-\(t\) ideal principalization | `SC/Main.lean:17`, `IndependentStableCore.universal_principalization` | supported core; the \(J_\psi\) substitution is a prose step |
| Uniform auxiliary bound | `FS/ObstructionDefinitions.lean`, `auxiliaryWeight`; `DeterminantGradings.lean`, actual quotient grading; finite monomial calculation above | supported prose deduction, not an arbitrary-\(\psi\) Lean lemma |
| Arbitrary-\(W\) rigidity | `SC/Main.lean:70`, `IndependentStableCore.lower_perturbation_rigidity` | supported core; see the dedicated unit assessment |
| Nonzero transport under the base map | `FS/BundleCharts.lean:230`, `baseMap_injective`; `ObstructionPrincipalization.lean`, `baseMap_injective`, `extension_ne_zero` | supported; only injectivity and the extension equation are needed |
| Unconditional LND lift | `FS/LiftObstruction.lean:74`, `exists_weight_preserving_lnd_lift`; normalized-frame constructors just described | supported dependency, independent of \(I\) or \(\psi\) |
| Factorial closure in the correct domain | `FS/DeterminantDomain.lean`, `determinantRing_isDomain`; `FactorialClosure.lean:88`, `lnd_factorial_closure` | supported; not applied in \(B/J_\psi\) |
| Fixed October ideal only | `SC/Main.lean:120`, `unrestricted_invariant_exclusion`; `LiftObstruction.lean`, `lift_invariant` | does not directly assert the arbitrary family |
| Stable ideal has a nonzero invariant | Least-nilpotence-exponent argument above; `FactorialClosure.lean:51`, `exists_last_nonzero_iterate`, supplies the underlying iterate fact | supported prose; not one of the printed conclusions |
| Dominance and no preserving additive action | Injection and stable-ideal argument, then characteristic-zero action/LND dictionary | supported geometric deductions with the stated interpretation |

The eight declarations with printed axiom lists in `SC/Main.lean` are:
`universal_principalization`, `signed_quadric_identity`,
`lower_perturbation_rigidity`, `unrestricted_invariant_exclusion`,
`literal_coordinate_to_invariant`, `literal_noncoordinate`,
`literal_one_stable`, and `stable_core_verify`, all in
`IndependentStableCore`.
The fourth and the fixed literal-polynomial package use \(I=J_T\).
The signed identity does not assert a quotient isomorphism.
**None of these eight declarations quantifies over \(\psi\), defines
\(J_\psi\), asserts its quotient isomorphism, or rules out preservation of
that ideal.**

Consequently the following formal-encoding obligations remain absent from
this certificate, although their mathematical proofs have been checked above:

1. Definitions of \(J_\psi,W_\psi,v_\psi\) and the all-\(\psi\) quotient
   equivalences.
2. The all-\(\psi\) auxiliary-degree bound and substitution in universal
   principalization.
3. Generalized nonzero-invariant transport using the unconditional lift,
   instead of the specialized `lift_invariant` for \(I\).
4. The restriction-injectivity statement and nonzero stable-ideal/last-iterate
   corollary, including their geometric action interpretation.

These are concrete gaps in **kernel encoding**, not missing mathematical
steps being silently assumed. The old draft itself labels Theorem 3 a prose
corollary; treating its compilation certificate as a direct theorem of the
whole family would overstate what was encoded.

### Source-bound mechanical record

Read-only checks verified that `SC/Main.lean` has SHA-256
`fea7d30d06349b4e15bc63852970443a958b8e4f99e38ac09a8897f7a27bb916`
and `SC/statement_fidelity.md` has
`683a28a67564cb14f2809d0e8844ff0ce781a563c205df47eb2ec7e0d84df0ed`.
Both match `SC/lean_verification_result.json`; the embedded texts in
`SC/certificates/C_STABLE_CORE_VERIFY-1f2393b585c126fe.json` also match.
The certificate SHA-256 is
`f93ec4e9eb00260bdfef04b169e6274fbcc6a60a2025f8813e4f100dc82e979c`.
The exact algebra certificate has SHA-256
`104d3503ab1d34038b0d5a9a2dc633a6a223769866f4107570a3aa51815799c9`.

The historical Lean record reports version 4.31.0, commit
`68218e876d2a38b1985b8590fff244a83c321783`, Lake
`5.0.0-src+68218e8`, Mathlib v4.31.0 workspace, compiler and audit exit 0,
and no proof holes. The printed axioms are limited to `propext`,
`Classical.choice` where used, and `Quot.sound`.
This assessor did not duplicate the common 81-check driver or the full
Main compilation, which are assigned elsewhere. No fresh compile is
claimed here, and even a fresh successful run would not fill the missing
family-specific statements automatically.

## Component verdicts, assumptions, and concrete remaining gaps

| Component | Engineering verdict |
|---|---|
| Global quotient isomorphism for all \(\psi\), including zero | supported |
| Repeated-root/singular cases and reduced reducible zero member | supported; no domain hypothesis on the surface is used |
| Nonzero invariant transport and auxiliary bound for every polynomial | supported |
| Injective restriction for every nonzero LND of \(B\) | supported by the checked prose proof from the stated cores and unconditional lift |
| No nonzero LND preserving \(J_\psi\), hence no preserving nontrivial additive action | supported by the explicit stable-ideal argument |
| Direct kernel theorem for the arbitrary family among the eight printed declarations | partial: the four groups of formal obligations above are not encoded |
| Global novelty | unresolved; **`not_asserted`** |

No unfilled mathematical step was found in the strongest prose theorem.
The required external mathematical inputs are the characteristic-zero
action/LND dictionary, the separately proved unconditional lift and base-map
injectivity, and Theorems 1–2. Their hypotheses are verified here, rather
than treating a generic line-bundle lift as automatic from reducedness.
The optional radicalness check is elementary and not an extra assumption.
The archived formal evidence trusts Lean and its imported proofs; it does
not make the prose family a kernel assertion or certify global novelty.
Final independent assessment remains required.
