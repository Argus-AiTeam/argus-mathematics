# Protected-channel realization

## Statement under audit

The target is `thm:gradient-realization` in both staged counterexample
manuscripts, not either manuscript's final graph-theoretic conclusion.
The Hadwiger source is
`research/openai_manuscript/A-counterexample-to-Hadwigers-conjecture-September-23-2026/build/sections/05-realization.tex`;
the Colin de Verdiere source has the same basename under
`A-counterexample-to-the-Colin-de-Verdiere-chromatic-conjecture-September-23-2026`,
at the same theorem label. The executable certificate extracts line anchors
from the literal labels rather than assuming matching line numbers.

The assertion freezes every cross pairing with a nominal pin or selected
key, including pins mixing primal directions, channels, and both endpoints.
It asks for simultaneous realization for both endpoints and both unit roles.
Other entries of the small table are explicitly allowed to change.

## Dependencies and mathematical scope

The ground field in the manuscripts is F_2. The nominal spaces are direct
sums over the two endpoints, not their possibly dependent ambient images.
The spaces S are primal **projections** of pins; they must not be replaced
by intersections. Protected channel spaces H_0 are channel projections of
pins, with arbitrary chosen complements H_1.

The following are distinct obligations, not conclusions of a finite test.

1. `04-moments.tex`, `lem:label-support`: bounded-rank Boolean moment
   matrices split into independent label blocks. Its displayed proof is
   self-contained; Laurent--Mourrain is background, not an invoked
   characteristic-zero or positivity theorem.
2. `04-moments.tex`, `lem:sparse-pin-labels`: excluded labels cannot occur
   in any sufficiently sparse expansion of a projected pin.
3. `05-realization.tex`, `lem:small-tables`: selected key rays are
   independent modulo the table spaces, and the prescribed gradients agree
   on all selected atoms. Raw frame identities and matched keys give the
   same values for the baseline contraction.
4. The response-annihilator argument must cover a **pair** of profiles.
   Pure quotient forms are shared between the two endpoints; treating two
   individual response systems as independent would not prove this.
5. Compression must preserve the cut-profile domain, every mixed pin and
   key, and the residual functional. A rank calculation for an arbitrary
   matrix alone would not prove this.
6. Factorization must preserve the frozen entries as bilinear forms on the
   full nominal direct sums. Checking only pure primal pins would not
   cover the theorem.

No external theorem is needed for finite-dimensional image/annihilator
duality, projection compression, or the rank loss under restriction of a
nondegenerate pairing: these can be proved by elementary linear algebra.
The imported moment and key assertions remain explicit dependencies until
their use has been justified.

The parameter hierarchy matters. With B = 3K+28, the final pure task has
rank at most 30r_0+28J|E|+D_quo. Its available channel pairing has rank at
least h-2K-4B. The manuscript assumes h=1000r_0 and
970r_0 > 28J|E|+D_quo+2K+4B. A counterexample using a smaller channel
budget would not refute the literal assertion.

No flaw has been established at this scope checkpoint. In particular,
reciprocal channel changes can overlap on channel--channel blocks without
affecting the other role's primal contractions; overlap alone is not a
counterexample. This observation does not yet certify solvability.

## Uniform linear-algebra argument

The following argument is over F_2 when it uses Boolean moments; the
compression and protected-pairing results themselves work over any field.
Every dimension bound below is independent of the ambient dimension n.
All direct sums and all kernels here are nominal.

### Response annihilator

Fix a target endpoint z and combine the two source endpoints. Write q_+
and q_- for the quotients by D + A + H_1, where A is the span of selected
keys. The permitted derivative values lie respectively in ann(H_z,0^-)
and ann(H_z,0^+). These are annihilators in channel coordinates, not
chosen complements to H_z,0.

If a pair (x_1,x_2) annihilates the unrestricted pure response, then
sum_i (q_+ tensor q_-)(x_i,e)=0 for every component e. Projecting onto
one individual primal coordinate block modulo S_i,e^+ + A_i,e^+ and
S_i,e^- + A_i,e^- shows that x_i,e is killed in that product quotient.
For a matrix killed in the product of quotients by subspaces of
dimensions d_+,d_-, its rank is at most d_+ + d_-: in adapted bases its
bottom-right block is zero. Thus rank(x_i,e) <= 2K+28 <= R_*.

Apply the recorded label-support assertion. At a selected label s,
sparse-pin exclusion removes S from the direct sum of the label blocks
under consideration. The component matrix is therefore killed modulo
the selected ray v in both factors (or is zero if that component has
no such ray). A symmetric matrix with this property has the form

    Z = c v v^t + v d^t + d v^t,       v_0 = 1.

Because the ground field is F_2, its diagonal is c v, while its
zeroth row is c v + d + d_0 v. The Boolean moment identity equates
these, so d = d_0 v and Z = c v v^t. This step would be false with
unconstrained symmetric matrices in place of Boolean moments.

On each triangle of tags, the three component supports have at most
3R_* labels, so selector interpolation separates their label blocks.
The selected block is supported on one tag star. The triangle equations
force its coefficients along that star to agree. Subtract the
corresponding selected atom. Such atoms themselves annihilate every
response, since both factors are keys. Directness of the remaining label
blocks ensures that this subtraction increases neither rank nor support.

Now every remaining component has only unselected label support. Contract
its minus factor by a functional phi vanishing on S_i,e^- + A_i,e^- and
on all other endpoint/channel blocks. Pure-response annihilation puts
the resulting plus vector d in D + A + H_1. Project to each endpoint's
primal block. Sparse-pin exclusion forces every selected-key coefficient
in this representation to vanish: d uses at most R_* unselected labels,
and at most fourteen selected rays were added. The channel part of D
lies in H_0, whereas the added channel term lies in its complementary
H_1. Since d is purely primal, both channel parts vanish. Consequently
d lies in D intersect B_i, not merely in S_i.

Test the derivative response phi tensor c for every
c in ann(H_z,0^+). It gives F_z^0(d) dot c = 0. Thus F_z^0(d) is in
H_z,0^+, and the injecting-table hypothesis forces d=0. The reciprocal
argument eliminates the other contractions. The remaining matrix is in
(S_i,e^+ + A_i,e^+) tensor (S_i,e^- + A_i,e^-).
Sparse-label separation removes A again, leaving
S_i,e^+ tensor S_i,e^- at every component. Hence the remaining profile
is in C_i.

The response annihilator is therefore contained in the span of the
effective profiles and selected atoms. The target difference vanishes
there by the scalar recipes and matched-key identities. Finite-dimensional
image/annihilator duality gives a relaxed solution for the **paired**
source endpoint problem. This is not a conclusion of a finite search.

### Compression without an idempotence requirement

A useful field-general variant of the manuscript's compression is:
for a subspace U of V and a linear map f: V -> W, there is C: V -> V
such that C fixes U, f C = f, and

    rank C <= dim U + rank f.

Indeed choose a retraction r: V -> U of U's inclusion i, and a section
s: im f -> V of f with its codomain restricted to im f. Set

    C = i r + s f (1 - i r).

Then C i = i and f C = f. The map factors through U direct-sum im f,
which proves the rank bound. No claim that this particular C is
idempotent is needed.

Apply this construction to each ordinary base block, using for U the
expanded projected pin/key vectors, and for f all expanded row and
column forms of a residual target matrix. The same block map is used
at every component and in both modes of an endpoint; the constant
coordinate and selector factor are fixed. Every allowed point remains
an allowed point, including every tag-dependent zero O-block. Therefore
the tensor-square map preserves W_l and the cut domain.

On the full nominal space take the identity on the channels. Fixing
every projected primal pin vector and keeping channels fixed fixes
each original mixed pin, not just its individual primal projections.
Keys are fixed too, and H_1 is preserved. Thus the maps descend to the
quotients q_+,q_-. Their ranks there are bounded by D_quo.

For any pure solution B, replace it by B(C_+ ., C_- .).
On a cut profile x its value is the old residual evaluated at the
compressed cut profile. Because all target row/column forms were
preserved, this equals the old residual at x. This proves response
preservation, while rank of the new form is at most D_quo.

The target routing and bounded-rank removal in the manuscript give
rank <= 15r_0+14J|E| for each individual unprojected target. Projection
away from pins and keys changes its matrix by rank <= 2K+28.
The baseline maps on the combined primal inputs have rank at most
B=3K+28. Projecting derivative outputs through sections of their
observed-pairing maps reduces their ranks to at most B without changing
their derivative responses. Subtract their extra product from the pure
task. A residual target rank bound is consequently

    R_res = (2K+28) + 4B = 14K+140.

The block compression just proved applies to that residual. Restoring
the two earlier projected pure targets costs at most
30r_0+28J|E|, so the final pure task has rank at most
30r_0+28J|E|+D_quo. Its factors still descend through q_+,q_-.

### Protected pairing and exactification

After the small derivative corrections, denote the observed primal maps
by F_1,G_1. Inside ann(H_z,0^-) and ann(H_z,0^+) impose respectively
orthogonality to the primal images of G_1 and F_1. Call the resulting
channel subspaces A_z,B_z. Each has codimension at most K+2B.

For any nondegenerate pairing on an h-dimensional space and subspaces
A,B, its restriction has rank at least dim A + dim B - h. The kernel
on A injects into the annihilator of B, of dimension h-dim B; apply
rank-nullity on A. This argument covers degenerate restrictions,
isotropic protected subspaces, and unrelated plus/minus protected spaces.
It does not assume that H_0 and its orthogonal complement are complementary.

More generally, any bilinear form M factors through any pairing of rank
at least rank M. To see this without an implicit nondegeneracy assumption
on the restricted pairing, let E=im M and S be the image of that pairing
in the dual of its second space. Embed E in S, retract S onto E, and
lift S to the first channel space. Evaluation from the second channel
space onto S^* is surjective, so lift the transpose of the retraction
through it. The two lifted maps have product M. These are all linear
maps over the original field.

Apply this to the final pure quotient form and A_z x B_z. The budget
inequality gives more than its required rank. Adding these two factors
to F_1,G_1 realizes the pure form exactly, since both mixed terms
vanish by their defining orthogonality. Source frozen directions are
killed by q_+,q_-, and opposite frozen directions are killed by the
protected-channel annihilators.

### Simultaneous Gram assembly

The final compatibility question can be stated independently of moments.
In one cross block, let c_i^+(l) and c_z^-(r) be the channel projections
of full nominal arguments l,r. Let dF_z and dG_i be all the constructed
primal-to-opposite-channel corrections, extended to the full nominal
spaces as above. Define the single bilinear correction

    Delta(l,r) =
        sum_z dF_z(l) dot c_z^-(r)
      + sum_i c_i^+(l) dot dG_i(r).

If l is any frozen mixed pin or key, each first summand is zero because
dF_z(l)=0; each second summand is zero because c_i^+(l) is in its
protected projection (and is zero for keys). If r is frozen, the two
arguments give the reciprocal proof. Thus this is a simultaneous
extension of **every** frozen row and column.

If l is purely primal, all c_i^+(l)=0. Evaluating r on one channel
column of endpoint z leaves exactly the prescribed coordinate of
dF_z(l). The reciprocal dG changes contribute zero. If r is purely
primal the same argument isolates dG_i. Repeating this construction
in the other cross block realizes all reciprocal roles. There is no
division by two and no need to identify or separately prescribe their
overlapping channel--channel entries.

This proves the algebraic passage from a bounded-rank relaxed solution
to a simultaneous Gram completion. The manuscript specialization uses
the response-annihilator and cut-preserving compression arguments above;
a formal certificate must disclose explicitly which of those structural
facts it encodes as hypotheses rather than silently calling them proved.

## Certification boundary

`Main.lean` proves the field-general protected-channel reduction, including
finite-dimensional response duality, a constructive compression lemma,
rank-sensitive factorization through a possibly degenerate restricted
pairing, and simultaneous full Gram assembly. Its main exactification
declaration **assumes** residual annihilator containment, compression
naturality, and residual invariance. The Boolean ray-isolation and mixed-pin
stripping steps are also proved uniformly, but the complete moment-domain
argument is not part of that source. The separate annihilator development
below now discharges the paired moment-domain implication from the stated
moment, sparse-label, interpolation, and injecting-table hypotheses.

Consequently this is not a kernel certificate of
`thm:gradient-realization`, and no admissible counterexample has been found.
The new source-specific compression development below derives cut closure,
quotient naturality, residual preservation, and the quotient rank bound.
Its explicit residual representation and the fixed pure target rank still
have to be connected to the literal recipes; it must not be relabelled as
an unconditional full-realization theorem.

Compared with the manuscript's strongest assertion, the protected-channel result
has a more general algebraic ambient field and arbitrary finite endpoint
sets, but a weaker certification boundary: the source-specific moment and
recipe-to-response hypotheses are not discharged in that source. Compared
with the initial unchecked realization route, it eliminates the proposed channel-overlap
obstruction by a uniform theorem rather than a larger finite search.
No claim of mathematical novelty or publishable mission completion is made
before independent review.

The standalone exact replay is:

```sh
python3 research/gradient-realization/verify.py
```

It checks the source anchors, the four contractions, all frozen basis
rows/columns in both Gram blocks, the derivative-product compensation,
the restricted-pairing example independently of Jacobian, and the current
source/fidelity binding of the actual Lean certificate. Its small specimen
is not a manuscript recipe. The uniform reduction is the Lean theorem,
not an inference from the specimen's 800 frozen-entry and 1,600
primal-channel checks.

The native formal command used was:

```sh
$WORKSPACE/argus-live-update/.venv/bin/python -m argus_skill.verticals.math.lean_evidence verify research/gradient-realization/Main.lean --statement-fidelity research/gradient-realization/statement_fidelity.md --claim G157_PROTECTED_REDUCTION --project-root .
```

The recorded result is Lean 4.31.0, exit code 0, and `proof_holes=[]`.
The original assertion remains open at the required end-to-end formal
certification bar. The paired annihilator result below replaces the former
prose-only obligation. The subsequent compression delta now proves compatible
cut compression from explicit residual data, rather than assuming it.

## Paired Boolean annihilator certification

`annihilator/Main.lean` now proves
`PairedBooleanData.paired_boolean_annihilator` and
`PairedBooleanData.target_in_response` over `F_2`. Its domain is the actual
cut-map image of tag-dependent affine point-moment spans. The manuscript's
zero-coordinate restrictions are one specialization of the allowed-point
predicate. The nominal pin spaces may mix both endpoints and channel
coordinates; their primal projections are not treated as pin intersections.

The proof derives the rank bound from shared pure quotient annihilation.
It extracts individual selected Boolean blocks using sparse-pin exclusion,
proves that each is a scalar point square, and uses three-edge interpolation
and cut triangle identities to prove global star consistency. The selected
atoms themselves are shown to annihilate the response. After subtraction,
key separation is derived from the same sparse-label hypothesis, private
channels are removed without splitting the original mixed pins, and the
literal pin-intersection injection condition kills the remaining
contractions. Both factor supports are then in the projected pin spaces.
No annihilator-containment or endpoint-isolation hypothesis is assumed.

The source also defines the span of the actual shared rank-one pure and
derivative responses and proves its kernel equivalence. Target vanishing on
effective profiles and selected atoms therefore gives a relaxed solution
on the entire paired cut domain. The manuscript moment, interpolation,
sparse-pin, and table hypotheses remain explicit, cited inputs; their full
upstream proofs and the recipe-to-target-vanishing calculation are not
silently certified by this implication.

The official Lean 4.31.0 run returned `exit_code=0`,
`audit_exit_code=0`, and `proof_holes=[]`, archived in
`annihilator/certificates/G157_ANNIHILATOR-32430f09a98fc3e9.json`.
Its separate `annihilator/statement_fidelity.md` gives the complete
manuscript-to-formal-statement mapping and remaining scope boundary.

The new standalone replay is:

```sh
python3 research/gradient-realization/annihilator/verify.py
```

It binds the source anchors and fresh Lean certificate and exhaustively
checks a small paired cut domain with tag-dependent allowed points,
projected pin dimensions strictly larger than actual primal pin
intersections, and mixed pins across endpoints and channels. The check is
containment, not equality: effective profiles need not themselves
annihilate the response when pins are mixed. This specimen is separate
from, and not a substitute for, the universal Lean proof.

Independent Host-invoked Reviewer confirmation of the annihilator was
subsequently recorded in the ledger. The following development leaves that
reviewed source and its statement-fidelity document unchanged.

## Actual cut-compression delta

`composition/Main.lean` now implements the blockwise construction on the
literal selector tensor base coordinates over `F_2`. Its affine constant is
fixed, selectors are untouched, and each ordinary block has its own linear
map. Whole-block zero restrictions therefore remain zero. Pushforward of
point squares preserves each tag moment span, and use of the same endpoint
map at every component and in both modes preserves cuts.

The new `pin_key_generators` theorem derives the source's
`2|E|(K+14)` vector count from the projected-pin and key dimension bounds.
The compression fixes the resulting vectors, hence every original full
mixed pin and key when extended identically on channels. The actual
private-channel quotient map is constructed, its naturality is proved,
and its rank is bounded by

    Dquo = 2 p_* (1+(g^2+3) Dblk) + 2K.

The `2K` term is derived after quotienting private channels out; the identity
on all channel coordinates is not incorrectly assigned bounded nominal
rank. The bound is linear in the compressed primal dimension, not its
square.

`residual_invariant` preserves the explicit post-derivative residual
row/column representation. `actual_response_natural` proves the shared,
combined-endpoint response diagram by trace contraction, including both
different quotient spaces. `bounded_pure_solution` composes these facts:
any unrestricted quotient-form solution of that represented residual on
the whole paired cut domain has a solution of rank at most `Dquo`.
It does not assume cut closure, response naturality, or residual invariance.

The same source proves derivative observation/rank reduction, derives
protected-channel codimension `K+2Blin`, verifies the exact numerical
`970r0` implication, and factors a restored pure task under its explicit
fixed-pure rank bound. `nominal_gram_completion` instantiates the reviewed
assembly theorem on the actual nominal endpoint products. It produces a
single Gram block preserving every full mixed frozen row and column while
realizing all forward and reciprocal primal-channel increments. Applying
it to the other cross block requires no channel-channel compatibility
assumption.

This is stronger than the previously reviewed protected-channel reduction
in the specific respect still missing there: the actual Boolean cut
compression and response diagram are now derived. It is not a replacement
proof of the reviewed annihilator, and it does not yet settle the literal
realization theorem.

The authoritative Lean 4.31.0 run returned `exit_code=0`,
`audit_exit_code=0`, and `proof_holes=[]`. Its source/fidelity-bound archive
is `composition/certificates/G157_CUT_COMPRESSION-d67fff75f02b9184.json`.
Independent Host-invoked review of this new statement mapping is pending.

Two unresolved source-to-formal obligations are separately recorded:

- `G157_TARGET_ROUTING`: construct the matrices of rank at most
  `15r0+14J|E|` from the actual gradient formula and identify the projected
  fixed part and the residual of rank `14K+140`. The rank bound on the
  fixed pure part remains an input to numerical exactification, not a
  conclusion of compression.
- `G157_RESPONSE_PARAMETERS`: turn the reviewed response-span element
  into one tuple of shared quotient pure forms and allowed derivative
  maps, and identify the post-reduction residual with that routed
  representation. The new recipe-agreement theorem proves the target
  is in the reviewed response span from explicit recipe/table/key
  equalities; it does not perform this parameter extraction.

Neither obligation is assumed silently in `G157_REALIZATION`. That claim,
the original `G157_COMPRESSION`, and campaign completion remain open.
No false manuscript assertion, admissible counterexample, or novelty
claim is established by this delta. The independent Reviewer should assess
the new specialization without reopening the unchanged annihilator proof.

The rerunnable exact replay is

```sh
python3 research/gradient-realization/composition/verify.py
```

Its finite active-subspace specimen checks the new cut, quotient, residual,
full bilinear-factor, and simultaneous Gram constructions. The universal
proof is the Lean source, not an extrapolation from that specimen.
`composition/statement_fidelity.md` states every primitive input and the
precise remaining certification boundary.

The new formal command, with the reviewed dependency modules already built, is:

```sh
LEAN_PATH="$PWD" $WORKSPACE/argus-live-update/.venv/bin/python -m argus_skill.verticals.math.lean_evidence verify research/gradient-realization/composition/Main.lean --statement-fidelity research/gradient-realization/composition/statement_fidelity.md --claim G157_CUT_COMPRESSION --project-root .
```
