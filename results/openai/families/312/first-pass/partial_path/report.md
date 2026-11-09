# Fixed-cutoff descent and mixed-dimensional operation extension

## Statement and scope

The object of this audit is `prop:partial-path`, not an arbitrary globular
countermodel or a finite-dimensional approximation to that proposition.
Source paths below are relative to
`research/openai_manuscript/The-Grothendieck-homotopy-hypothesis-via-elementary-expansions-September-24-2026/build/`.

**Verification theorem.** Let C be any coherator as defined in
`sections/01-preliminaries.tex:34-58`. For every integer q >= 1 and
0 <= n < q, assume E(q,j) for n < j <= q, with arbitrary cellular starting
objects and arbitrary attaching cells. Then the partial cylinders in
`sections/03-partial-cylinders.tex:41-130` support interpretations of every
operation of C in the given free-stage order. They give a functor on A_q,
both endpoints are model morphisms lifting every I_j, and the joint endpoint
lifts J_n. Consequently descending induction proves every E(q,n), including
q=n=0 at the base, and cutoff removal proves `thm:main`.

There is a strictly weaker fixed-cutoff hypothesis. For a *fixed* q, the same
conclusion in A_q holds for a contractible globular theory with a given free
filler presentation whose generating fillers of output j <= q have arity of
height <= j, even if generating fillers of output > q have arbitrary finite
globular-sum arities. The presentation consists of free filler adjunction and
globular completion, with no equations beyond prescribed faces. With the extra
nonadmissible generators, this is not called a "free globular extension" in
Ara's more restrictive admissible-tower terminology. This is the **local
triangularity extension**. It is not an all-dimensional theorem for theories
violating the arity bound below the dimensions being tested.

The proof below discharges the geometric contractibility and operation-extension
obligations; neither is an additional hypothesis. The higher-index expansion
assertions are hypotheses only of the induction step and are discharged in the
fixed-cutoff theorem. There is no established refutation of a literal manuscript
assertion in this report. Independent review is still required. Novelty or
publishable significance is not inferred from agreement with the manuscript.

## Previously established input

1. Ara, *On the homotopy theory of Grothendieck infinity-groupoids*,
   arXiv:1206.2941v2, Sections 2.3, 2.9--2.11: admissible pairs
   d_m => S have dim(S) <= m+1; free towers adjoin fillers and take globular
   completion. Thus the bound for a generating output-j filler is <= j,
   not <= j-1, and it does not bound the arity of every composite.
2. The same source, Theorem 4.18, in the standing setting of a contractible
   globular extension: weak equivalence can be tested using prescribed
   parallel boundaries. In the exact-disk version, a disk over an image
   boundary lifts with that exact boundary up to one higher joining cell.
   The dimension-one fullness/essential-surjectivity condition and the
   higher fixed-boundary surjectivity condition give this version. Applying
   it one dimension higher also gives reflection of homotopy.
3. Henry, arXiv:1609.04622v1, Conjecture 5.3.3, Theorem 5.3.5,
   Corollary 5.3.13: the comparison with spaces is conditional on the
   elementary expansion assertion. The last statement reads:
   "Conjecture 5.3.3 implies Grothendieck homotopy hypothesis."
   It is not evidence that an expansion is already a weak equivalence.
4. Lanari, arXiv:1805.00156v1, Proposition 3.8, Definitions 5.2 and 6.1:
   free globular sums are contractible and a cylinder-represented
   globular-set path functor is available. The introduction, pages 2--3,
   does not claim compatible interpretation of every higher operation.
   That unresolved extension cannot be imported as a theorem here.

The versioned primary PDFs were retrieved by the source-scope research worker
(HTTP 200 for all three), which reported the statements and their hypotheses.
No claim of a completed independent citation-ledger attribution is made.
The host Reviewer must independently check the cited propositions.

Write W for the weak equivalences in input 2. Its exact-boundary formulation
implies retract closure and filtered-colimit closure, since the data and the
matching equations of a test are finite. The groupoid homotopy calculus gives
two-out-of-three. If f is in W and lifts J_j, first lift a j-disk up to a
(j+1)-cell and then lift that cell against J_j to correct the disk exactly.
Thus f lifts I_j. Units show that every object lifts every J_j against 1.
These are not assumptions of any model structure.

The free constructions used below are finitary essentially algebraic
constructions: operations take finite matching tuples and have prescribed faces.
Filtered colimits are computed on cells; finite free globular sets and boundaries
are finitely presentable by adjunction. Adjoining all solutions of a set of
lifting problems, iterating, and taking the sequential colimit therefore gives
the ordinary small-object factorizations used here. No weak-equivalence claim
is obtained from that construction alone.

## 1. Cutoff and low-cell invariance

For k <= q retain X through k and place exactly one cell above each parallel
boundary in every subsequent dimension. Call this globular set Z.
Interpret the generators in their original free order, maintaining that
eta:X -> Z preserves the preceding theory.

For a generator of output j <= k, its entire arity has height <= j <= k,
so its tuple set is unchanged. Use its interpretation in X. Its face equations
hold because eta already preserves the *whole preceding theory*. For output
j > k, its already interpreted parallel boundary has a unique filler in Z.
The image under eta of the old value is that filler. At a limit stage take the
compatible union. The universal property of a free stage, including globular
completion, supplies the model. A map X -> Y with Y k-coskeletal factors
uniquely as a globular map through Z; the same low-generator/unique-high-filler
argument makes the factor a model map. This proves the reflector R_k, not merely
an underlying-set construction.

Notice that a high-output generator is never required to have small arity in
this argument. Composite face operations are already interpreted, including
any higher-dimensional operations occurring internally in them.

R_k(I_j) is an isomorphism for j>k, as can be tested by maps into any
k-coskeletal model. Reflecting pushouts and transfinite composites then proves
that higher I-attachments preserve cells through k. The same holds for J_j,
which attaches one j-cell and one (j+1)-cell. Further reflection from A_q
has the same property. This proves `lem:cutoff` and `lem:high-cells`
(`sections/02-cutoffs-trees.tex:29-114`) in precisely the required order.

## 2. Spines and the upper-cell lemma

Describe a nonempty globular sum recursively as a vertex or a string of
suspended nonempty globular sums. T_0 keeps the outer vertex string, using
the first vertex of each inner summand for its edge. T_(m+1) applies T_m in
every inner summand. It has height <= m+1 and retains all cells through m.
Building each inner summand from its first vertex and then suspending its
source attachments proves that T_m(S) -> S uses only J_j with j>m.
These are actual source attachments, not merely a comparison of cell counts.

For m<q, parallel m-cells of F_q(S) lift uniquely to F(T_m(S)): higher
attachments preserve the required cells and R_q preserves them too. Their
lower faces agree by injectivity. They are parallel theory arrows on an
arity of height <= m+1, hence admit an admissible (m+1)-filler. Its reflected
image joins the original pair. For m>=q the joining cell is unique by
coskeletality. A vertex supplies nonemptiness. Thus F_q(S) is contractible.
This proof does not need contractibility of F(S) above q for the local
triangularity extension.

Assume now E(q,j) for j>n. Every upper J-cellular extension with cellular
source belongs to W; indices >q are isomorphisms. Suppose i:U -> V is
upper I-cellular and in W with U cellular. Factor it as U -a-> Z -p-> V
using upper J. Then a and p are in W. The preceding correction argument
makes p lift every upper I_j. Consequently i is a retract of a under U.
Every J-attachment has its unit retraction; composing these compatibly
through limit stages gives Z -> U. Hence i splits. Pushing the retract
diagram out along U -> U' shows that i remains in W whenever U' is
cellular. This proves `lem:upper-cell` without assuming E(q,n).

## 3. Tree contractibility is not assumed

Let K be a depth-n tree diagram. Linearize each of its depth-n tree slots
on the same labeled vertices to obtain a globular sum K^lin. Set
A=F_q(K), L=F_q(K^lin). Paths, with inverses for backward traversals,
define maps f:A -> L and g:L -> A fixing all generators through n.
L is contractible by Section 2.

For every generating (n+1)-edge e, the walk gf(e) has the endpoints of e.
After cancellation of consecutive opposite traversals it is the unique
simple path between those vertices in a tree, namely e. Associativity,
inverse and unit coherence in the hom-set groupoid give one cell
alpha_e:e -> gf(e) of dimension n+2.

This generator calculation alone would not prove the assertion for the free
model's infinitely many operations. To promote it, adjoin e' and
delta_e:e -> e' for every top generator, obtaining a_0:A -> Q.
Only J_(n+1) attachments are used. The map a_1:A -> Q sends each e to e'
and fixes lower generators. A common retraction r satisfies r a_0=r a_1=id.
Also the assignment e' |-> gf(e), delta_e |-> alpha_e defines h:Q -> A
with h a_0=id and h a_1=gf. Freeness, not a homotopy on arbitrary cells,
proves these equalities of full model maps. Two-out-of-three successively
gives r,a_1,h,gf in W. Since gf factors through contractible L, its bijection
on components and isomorphisms on based groups force A to be contractible.
For q=n+1 the joining (q+1)-cells are simply the unique fillers; the
duplicate q-generators are still retained. Thus this limiting case is included.

For any globular sum S, add the chosen independently oriented whiskers first
to T_n(S). The resulting raw globular diagram is a depth-n tree, so its
free reflected model is contractible. Rebuild S using its higher source
attachments. These do not add n-cells and are upper J-attachments, hence
weak equivalences by the induction hypotheses. This proves
contractibility of H_epsilon(S), with no E(q,n).

## 4. Cylinders and the exact skeletal filtration

Use the manuscript's P_j=D_j for j<n and P_n=D_(n+1).
For j>n factor A_j^01 -> 1 with upper I, obtaining P_j.
The two endpoint disks and P(boundary d_j) give the coglobular maps.
They satisfy the identities because they agree on the specified common
boundary before completion. Each P(boundary d_j) is cellular by its
ordinary globular skeletal presentation and the previously constructed
cellular maps P(boundary d_l) -> P_l.

For a finite globular S define
C_l(S)=F_q(S) amalg_(F_q(sk_l S)) P(sk_l S).
A map from this object to any T is exactly a map on the retained S and
cylinders through l agreeing on their shared faces and retained endpoint.
Extending the data at an actual l-cell is precisely extension from
A_l^epsilon to P_l. This proves the claimed coproduct pushout formula
`lem:cylinder-skeletal-gluing` (`sections/03-partial-cylinders.tex:141-202`).
It remains valid when earlier completions added cells below their cylinder
index: the statement concerns colimits of entire representing objects.
In particular, C_n(S)=H_epsilon(S),
C_(j-1)(d_j)=A_j^epsilon, and C_dim(S)(S)=P(S).

Induct on j>n. Filter A_j^epsilon from H_epsilon(d_j) using the maps
A_l^epsilon -> P_l for n<l<j. By the induction on j these are upper
cellular weak equivalences. The upper-cell lemma makes all their cellular
pushouts weak equivalences. The initial whiskered shape is contractible;
so A_j^epsilon is contractible. Its map to P_j attaches the missing endpoint
j-cell and then upper cells. It preserves all cells through n, so P_j
inherits nonemptiness and all fillers of dimensions <=n. Its upper
completion supplies all higher fillers. Thus P_j is contractible, and both
one-sided inclusions are upper cellular weak equivalences. For n=0 the
inherited condition is just nonemptiness. The same finite skeletal filtration
from H_epsilon(S) proves contractibility and cellularity of every P(S)
needed by a generator of output <=q.

## 5. All operations, both endpoints, and original stage order

Set (PY)_j=Hom(P_j,Y) through q and complete uniquely above q.
For dim(S)<=q the *entire* tuple set on S is represented by P(S).
Suppose the preceding free theory acts naturally on PY and both endpoint
maps preserve it. This is the induction invariant, not an induction on
output dimension.

For a new output-j generator theta on S:

* If j>q, interpret its already interpreted parallel boundary by the unique
  j-filler. Both endpoints preserve it by uniqueness in Y. Neither an arity
  bound nor representation of this possibly taller S is needed.
* If j<n, dim(S)<=j<n makes its tuple stationary. Use the original operation
  in Y; preservation of the preceding theory gives its face equations.
* If n<=j<=q, dim(S)<=j permits representation. The two already interpreted
  face operations, natural on full models Y, give by Yoneda maps
  P_(j-1) -> P(S). Their parallelism gives b:P(boundary d_j) -> P(S).
  The endpoint prescriptions are e_epsilon(S) theta:D_j -> P(S).
  Preservation of the preceding theory says exactly that these prescriptions
  agree on the two endpoint boundaries. They therefore give
  A_j^01 -> P(S). Its extension across the cellular A_j^01 -> P_j exists
  because Section 4 proved that P(S) fills every boundary.
  Choose it once on the representing objects. Precomposition interprets
  theta naturally on every full Y, with both face and endpoint equations.

A composite face may have output j-1 and arity S of height j. Nothing here
requires representation only on height j-1. Naturality and endpoint
preservation are inherited by *all* previous composites and substitutions
by their functorial interpretation and the free globular-completion
universal property. At a free limit stage take the compatible union.
Thus the construction interprets the entire fixed theory; it is not merely
a choice of operations that fails substitution.

## 6. Lifting properties with their actual representing domains

An I_j lifting problem against endpoint epsilon is a map
A_j^epsilon -> Y. For j<n the inclusion into P_j is the identity;
for j=n it is a face D_n -> D_(n+1) with a unit retraction.
For j>n it retracts by the upper-cell lemma and Section 4. All these
retractions extend the data into *every* Y, not only contractible or
cellular Y. For j>q, I_j is an isomorphism in A_q.
Therefore both endpoints lift all I_j and belong to W.

A joint J_n lifting problem has prescribed data represented by the free
depth-n tree
B=P_n amalg_(D_n + D_n) (D_(n+1) + D_(n+1)),
with edges h:x_0 -> x_1, a_0:x_0 -> y_0, a_1:x_1 -> y_1.
These are four actual n-generators sharing their lower boundary (four
ordinary vertices at n=0). To obtain A_(n+1)^01 attach the missing
comparison y_0 -> y_1, one I_(n+1). The subsequent map to P_(n+1)
is its upper completion. Thus B -> P_(n+1) is upper I-cellular
between cellular contractible objects. It is in W and retracts by the
upper-cell lemma. Following this retraction by the prescribed B -> Y
solves the joint lifting problem. This includes q=n+1.

## 7. Descending induction and removal of the cutoff

At n=q, a J_q expansion has its unit retraction and preserves cells
below q. For tests below q use the unchanged disk and its unit; at q use
the retraction's disk and the unique (q+1)-cell; above q use the unique
filler. The q=0 case uses the same middle argument. Thus E(q,q).

For n<q, let i:X -> Y be the expansion and r its unit retraction.
Lift cellular X against p_0 to obtain h:X -> PX with p_0 h=id.
Set u=p_1 h; both h and u are in W. The joint lifting property over the
actual pushout extends P(i)h to f:Y -> PY with
p_0 f=id and p_1 f=iur. Thus v=iur is in W.
In the arrow category iu is a retract of v, with domain maps i and r
and identity codomain maps: vi=iu, (iu)r=v, ri=id.
So iu is in W and then i is in W. No assumption on the attaching
cell beyond D_n -> X was used. This proves E(q,n), closing the descent.

Finally a dimension-k exact-boundary test before reflection uses cells
through k+1, including its homotopy witness. Choose
q>=max(n+1,k+1). R_q preserves the cellular presentation and the actual
pushout, while preserving all these cell sets and their faces bijectively.
The fixed-cutoff witnesses lift back with the original exact boundary.
This proves `thm:main`; preservation only through k would not suffice.

## 8. Certification boundaries

The preceding is a universal mathematical proof, submitted for independent
review, not a bounded experiment presented as a proof. In particular it
does not assume contractibility of cylinders, endpoint lifting, or the
current expansion index. The local triangularity extension follows because
all reflectors used have k<=q, shape fillers needed before unique completion
have dimension <=q, and all higher-output operations are interpreted uniquely.

`verify.py` and `exact_certificate.json` separately identify their exact
executable coverage. The successful replay covers 65 recursive shapes,
296 spines with their actual source-attachment schedules, 2,307 independently
oriented whiskered diagrams, 592 critical skeletal pushouts, 9,364 generating-edge
comparisons over all 3,149 labeled oriented tree/linear-order cases with at most
four vertices, and the endpoint-domain schemas at all 15 pairs 0<=n<q<=5.
There are negative controls for replacing a tree by a cycle and for treating
a retraction as an isomorphism. These bounds are not evidence of universal
exhaustion of models.

The Jacobian adapter was discovered and its exact typed contract inspected before
one bounded invocation of `topology.simplicial.edge_path.word.compute`.
The preserved result is successful but returns the *unreduced* labels
`e3,e3^-1,e1`, length 3. It does not certify cancellation. The local stack
reduction independently gives `e1`. Payload, protocol, server version, typed
output, and adapter status are in `jacobian/`.

Lean 4.31.0 successfully compiled `lean/Main.lean` with exit code 0 and
`proof_holes=[]`. The claim is **C_PP_CORE**, not C_PP_ALL or C_PP_PATH.
Its immutable supporting certificate is
`research/partial_path/lean/certificates/C_PP_CORE-a444dbe733826824.json`.
It proves the universal spine cell bijections, their two face compatibilities
and globular identities, absence of cells above m+1, the unique-filler
operation lemma for arbitrary tuple types, the naturality congruences, the
duplicate-generator promotion, and the final domain-retract calculation.
It does not formalize free globular completion, the source-attachment
description of all spines, Yoneda, the small-object argument, or the complete
coherator/path construction. `lean/statement_fidelity.md` states these limits
explicitly and is hashed into the compiler evidence. The script also checks
that the compiled source, fidelity document, current claim, and archive agree.

Replay the persistent exact certificate from the campaign root:

```bash
python3 research/partial_path/verify.py
```

For an independent real compiler run, without editing the source or its
fidelity document while the command is running:

```bash
$WORKSPACE/argus-live-update/.venv/bin/python -m argus_skill.verticals.math.lean_evidence verify research/partial_path/lean/Main.lean --statement-fidelity research/partial_path/lean/statement_fidelity.md --claim C_PP_CORE --project-root .
```

Both official structural checks have returned zero against
`campaigns/9000312`, not the batch
root. Structural validity is not independent mathematical acceptance.

The three versioned source propositions are recorded as assumptions in the
ledger. Their formal citation attributions remain open: the available
`citation_check attribute` archives under `research/literature/`, outside
this mission's writable paths. No out-of-scope archive or fabricated reader
verdict has been substituted. The Host must route that attribution under
an authorized write scope before review delivery can clear the citation gate.

The strongest prior result relevant here is Lanari's globular path candidate,
not Henry's conditional comparison. The substantive difference in this
verification is the two-sided cellular interpolation in Section 5, with its
target contractibility derived in Sections 2--4. No assertion that this
difference is new to the literature has been established. The campaign therefore
remains open pending Host-invoked independent review, source attribution,
statement-fidelity review, and a justified significance/novelty determination.
