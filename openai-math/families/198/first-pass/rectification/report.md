# Universal verification of three-layer rectification

The rectification assertion admits explicit right-linear homotopy
retractions, including arbitrary nonzero relation homotopies.
`Main.lean` supplies a universal formal verification of its complete
conclusion in graded-module and quiver-presentation coordinates.
The independent statement-fidelity review is still required. This
does not certify the surrounding manuscript or establish a
counterexample to finitistic-dimension finiteness.

## Scope and source

The target is `lem:rectification` in the staged September 23, 2026
edition of *An algebra of infinite little finitistic dimension*,
`build/sections/04-tensor-realization.tex`. Its input is the chain data
of `prop:lifted-diagram` in `03-localization-and-lifting.tex`, not an
arbitrary homotopy action of an arbitrary algebra.

The hypotheses include a field, finite arrow sets from 0 to 1 and
from 1 to 2, and a **linearly independent basis** of homogeneous
quadratic relations from 0 to 2. There are no other arrows. The three
input complexes are bounded and consist of finitely generated
projective right modules. Arrow maps and relation homotopies must be
right-linear; the latter have degree -1 and satisfy
`d h + h d = sum rho[b,a] f[b] f[a]`.

The complete output being investigated is a bounded, finite-dimensional
bimodule complex with right-projective terms, vertex homotopy
equivalences, and homotopies intertwining every arrow. Checking only
the square of its differential does not establish that output.

## Grounded scope findings

1. The input relations are zero in the **homotopy category**, not
   necessarily as chain maps. The final two paragraphs of
   `prop:lifted-diagram` explicitly choose null-homotopies, before any
   test module is chosen. A verification restricted to zero homotopies
   would not check this interface.
2. The relation basis matters. The source-(0,2) horizontal sequence in
   the rectification proof is exact because it uses the relation
   **space**, not a redundant list of defining equations.
3. There are no positive-length paths entering 0 or leaving 2.
   Consequently no relation can overlap another relation. This is
   the relevant distinction from unrestricted homotopy actions.
4. Keller, *Bimodule complexes via strong homotopy actions*,
   arXiv:math/9910178v1, Theorem 2.1, imposes vanishing
   `Hom(T,T[-n]) = 0` for every positive `n`, in addition to
   projectivity and boundedness hypotheses. That vanishing is not an
   input of the manuscript's lemma. Keller's theorem is methodological
   context, not a theorem that can simply be applied here.
   The primary source was read at
   <https://arxiv.org/html/math/9910178v1>, Sections 1--3.
5. The last paragraph of Section 3 expressly avoids identifying the
   Verdier quotient with a derived category of R and avoids a
   stable-flatness assertion. Neither will be silently added to the
   rectification hypotheses.
6. The installed Jacobian discovery returned finite based
   chain-complex operations. The inspected contract
   `chain_complex.construct.compute` accepts rational or prime-field
   matrices and checks adjacent products. It has no quantifiers over
   modules, no right action, and no homotopy-equivalence conclusion.
   Its bounded execution is a sign sanity check only, not a replacement
   for universal rectification.

No mathematical flaw has been established by these scope findings.
The manuscript's main theorem, selection input, localization/lifting
argument, ordinary simulation, and projective-dimension transfer remain
separate obligations; this mission does not certify them.

## Explicit contraction, beyond the manuscript's acyclicity argument

Choose a linear splitting of the relation sequence
`T --J--> U --pi--> W`, with maps `s:W->U`, `l:U->T` satisfying
`pi s=1`, `l J=1`, `s pi+J l=1`, `pi J=0`, and `l s=0`.
Here `U=k^(A12 x A01) tensor D0`,
`T=k^(relations) tensor D0`, and
`W=(length-two path quotient) tensor D0`. Such a splitting exists
over every field and introduces no hypothesis on the input complexes.
Let `V=k^(A12) tensor D1`, `A:U->V` apply the first-arrow maps,
`G:V->D2` apply the second-arrow maps, and `H:T->D2` apply the
given relation homotopies. Thus `d H+H d=G A J`, even when both
sides are nonzero.

At vertex 2 write the total complex in coordinates
`(y,v,w,u,z,t)` in `D2,V,W,U[1],V[1],T[2]`. Its differential is

```text
(d y-G z+H t, d v-A u+z, d w+pi u,
 -d u+J t, -d z+A J t, d t).
```

In addition to the manuscript's inclusion `i(y)=(y,0,0,0,0,0)`,
there are explicit right-linear maps

```text
r(y,v,w,u,z,t) = y+G v+G A s w-H l u,
K(y,v,w,u,z,t) = (0,0,0,s w,v+A s w,l u).
```

Their identities are `r i=1`, `r d=d r`, and
`d K+K d=1-i r`. At vertex 1 the coordinates are `(y,x,u)` in
`D1, k^(A01) tensor D0, (k^(A01) tensor D0)[1]`, with
`r1(y,x,u)=y+F x` and `K1(y,x,u)=(0,0,x)`. Vertex 0 is unchanged.
These formulas avoid an appeal to splitting an acyclic complex and
are uniform in the complexes, arrow maps, and nonzero relation
homotopies.

## Exact nonzero-homotopy regression

`verify.py` constructs the manuscript's algebra encoding
`R=QQ[x]/(x^2)`. Its nine-dimensional path algebra has relations
`b s-t a=0` and `b a=0`. Each input complex is `B --id--> B`
in degrees 0 and 1; the maps for `s,t,b` are identities and the
map for `a` is zero. The first relation composite is therefore
the identity, and its homotopy is the nonzero identity from
degree 1 to degree 0. The total terms have dimensions
`18,90,153,81` in degrees `-2,-1,0,1` and are right-free of ranks
`2,10,17,9`.

The exact integer replay checks associativity, both complete module
actions and their commutation, the full differential, all three
right-linear homotopy retractions, and every right-linear arrow homotopy.
Erasing or negating the required relation homotopy is a negative
control: the resulting deliberately invalid input makes the
differential square nonzero.
This fixture is not itself a universal verification.

## Universal theorem and formal coverage

More generally, let C be any k-algebra. For the finite three-layer
quadratic algebra B, take complexes of right C-modules, arrow chain
maps, and the stated right-C-linear relation homotopies. The same
construction gives a strict B-C bimodule complex and the displayed
vertex homotopy retractions. Projectivity and boundedness are not
needed for these explicit identities. If the input terms are
right-projective and finite-dimensional, and the inputs have common
support `[a,b]`, the output is right-projective and finite-dimensional
and has support in `[a-2,b]`. The manuscript lemma is the case C=B.

The principal declaration `ThreeLayer.complete_rectification` builds
`RectificationCertificate`, containing the differential, degreewise
projectivity and finite-dimensionality, boundedness, both action laws,
vertex equivalences, and arrow homotopies with their correct degrees.
It quantifies over arbitrary fields, finite arrow and relation sets,
and module operators. Scalar extension of an injective relation map
is proved to split; that splitting is not silently postulated.
Right projectivity of the quotient-path terms is proved by a
right-module retraction, not by an unjustified quotient-flatness
inference.

The proof uses presentation coordinates rather than Mathlib's
`PathAlgebra` and `CochainComplex` wrappers. The exact interpretation,
including the opposite algebra on the right, is documented in
`statement_fidelity.md`. Generator equations give the left B-action
by the universal property of the specified path presentation; all
generators are right-linear, so both actions commute.

This improves the previous state from an unverified acyclicity
argument to explicit universal homotopy-inverse formulas and a
source-faithful formal constructor. The construction is related to
standard bar/strong-homotopy methods; originality or publication
significance has not been independently assessed.

## Reproduction and limits

Run `python3 research/rectification/verify.py` for the exact regression
and freshness checks on the compiler certificate. To replay the
universal proof on the assigned host, run:

```sh
$WORKSPACE/argus-live-update/.venv/bin/python \
  -m argus_skill.verticals.math.lean_evidence verify \
  research/rectification/Main.lean \
  --statement-fidelity research/rectification/statement_fidelity.md \
  --claim C_RECTIFICATION --project-root . --timeout 110
```

The authoritative compiler output is `lean_check.json`; the ledger
cites the immutable certificate in `certificates/`. The official
verifier binds both the source and statement-fidelity text to its
real compiler run. `exact_certificate.json` distinguishes that
universal evidence from the finite regression.

The recorded Lean 4.31.0 run returned compiler exit 0, axiom-audit
exit 0, and `proof_holes=[]`. Its immutable claim certificate is
`certificates/C_RECTIFICATION-59d000b1f12038ec.json`. The Python
replay checks this archived evidence against the current source,
fidelity text, and claim version; it is not another compiler run
and does not substitute for independent statement-fidelity review.

The installed Jacobian 0.14.0 adapter, MCP protocol 2025-11-25,
successfully executed `chain_complex.construct.compute` with the
exact `jacobian_payload.json`. Its typed response is preserved in
`jacobian_output.json`; adapter exit status was 0 and no structured
error or timeout occurred. This finite operation cannot certify the
module or universal conclusions; it was not used for that purpose.

No false literal manuscript assertion has been established, so no
refutation judgement or F_ claim is appropriate. The proof of
`prop:lifted-diagram` itself, selection, the realization theorem,
ordinary simulation, and projective-dimension transfer remain open
in the campaign graph. Keller's background citation awaits the
independent reader's attribution: `citation_check status` still
reports `C_RECT_SCOPE/KELLER_TODA` as inconclusive. That scope claim
is not a premise of `C_RECTIFICATION`. Independent Reviewer approval,
statement-fidelity confirmation, and novelty assessment are not
claimed.
