# Fourfold ledger obligations: no established old Argus fourfold result

**Assessment:** the eight `F_*` claims are a mapped, unfinished route in the
old ledger and proof graph, not a third completed Argus proof draft. The
reference manuscript is available and its claimed reduction is intelligible.
The cyclic embedding and its arithmetic/path-model prerequisites remain
unverified in the inventoried Argus work. This is not a refutation of the
original manuscript.

This unit is deliberately retained: accepting either surface argument does
not justify silently dropping the fourfold placeholders or turning them into
invented Argus theorems. The complete old-work assessment can report concrete
unresolved obligations without starting a new fourfold error search.

## Exact source, hypothesis and theorem

OpenAI, *A projective fourfold with large fundamental group and non-Stein
universal cover*, October 5, 2026, source revision
`4eaee87548250b2682affda7d05d947c05554bae`. Its source directory is
`openai-math/preprints/A-projective-fourfold-with-large-fundamental-group-and-non-Stein-universal-cover-October-5-2026`.
All twelve TeX files declared in `MANUSCRIPTS.json` match that revision and
their old `research/openai_manuscript` copies. They are reference inputs,
not new Argus drafts or independent validation.

The introduction, lines 11-25, defines largeness using the fundamental group
of the **normalization** of every positive-dimensional closed irreducible
subvariety. Its `thm:main` claims a smooth connected projective complex
fourfold `X` containing a **simple abelian surface** `A`, with large
fundamental group and image
`im(pi1(A)->pi1(X))=Z`. The universal cover is asserted to contain no
positive-dimensional compact analytic subvariety and nevertheless be non-Stein.
The infinite cyclic image, smooth projectivity and simplicity are genuine
hypotheses of the reduction; a merely cyclic image or a local translation
label is not enough.

Neither accepted surface receipt names this fourfold theorem. Both old
`F_MAIN` routes remain separate, and all eight fourfold graph nodes are open
with no old supporting proof/checker artifacts in `PRIOR_DRAFTS.json`.
The old campaign goal's later choice of a surface route is not evidence about
the truth of the other manuscript.

## Per-claim assessment and concrete obligations

All eight old claims are version 1.

| Claim | Source proposition and assessed scope | Concrete unresolved obligation in old Argus work |
|---|---|---|
| `F_GEOMETRY` | Section 04, `prop:arrangement-local` and `prop:orbifold-surface`: sufficiently deep arithmetic level realizes prescribed local arrangements, global sign covers and a map from an iterated blowup of `A=Jac(C)` into the ordinary locus of a proper effective orbifold with projective coarse space. | Establish simultaneous exact arrangement/intersection data, required radius separation, simplicity of `Jac(C)`, global parity covers, and the actual morphism with trivial stabilizers along its image. A drawing or a finite model alone supplies none of these global assertions. |
| `F_MODELS` | Section 05, `prop:kernel-compatibility` and `prop:model-hyperbolicity`: buffered local descriptions have matching integer kernels and a uniform hyperbolicity bound for projected-diameter graphs, including the central sum-cover quotient and allowed analytic omissions. | Prove individual-kernel agreement up to sign with the chosen normal matches; away from the center prove `ker(l_z+l_w)=ker(l_z) intersect ker(l_w)` on the prescribed small-ball loops; prove one bound for all model graphs and omissions. This is not the surface crossing lemma or a Smith computation. |
| `F_PATH` | Section 03, `thm:path-lemma`: for `N>=N0`, local readings satisfying P1 prefix/reverse/edge-bijection conditions, P2 change-root equality and P3 common hyperbolicity distinguish a single-edge loop from the short-reading relators. | Establish the local-to-global representative invariant under all length-at-most-three defining relations with uniform constants. In application, verify P1 and P2 on actual chart paths, not just on model labels. No such Argus proof or test is supplied. |
| `F_IMAGE` | Section 06, `thm:orbifold-cyclic`: the image of the blown-up abelian surface in the actual orbifold group is infinite cyclic at sufficiently deep level. | Combine the cyclic upper bound with chart-axiom verification and `app:true-relations`: all true orbifold meridian relations must map to allowed path relations. Then show every positive power of the selected translation survives. Local integer labels need not define a global homomorphism; the manuscript explicitly warns of this. |
| `F_CYCLIC` | Section 07, `lem:ambient-realization`, `lem:ambient-blowdown`, `thm:cyclic-embedding`: realize the ordinary-locus map as a closed projective embedding, preserve the ambient group map, and remove all point blowups to embed the original simple `A`. | Prove the free-locus construction preserves the specified surface and fundamental group; for every ambient blowdown construct a global polarization giving a projective contraction and the compatible inclusion-induced group isomorphism. A local normal bundle with two `O(-1)` summands and its two-ruling model alone is not a projective global contraction. |
| `F_LARGE` | Section 02, `prop:large-reduction`: from a closed embedding of simple `A` with infinite cyclic image, an interpolation/Bertini/Lefschetz construction yields a large-group projective fourfold; the lifted rank-three-kernel cover obstructs Steinness. | The conditional reduction is supported as explained below, with its named classical inputs explicit. It does not provide the missing `F_CYCLIC` embedding. Old Argus has no independent citation/whole-construction certificate for this route. |
| `F_COMPACT` | Section 02, `red:compact-criterion`: largeness is equivalent to absence of positive-dimensional compact analytic subvarieties in the universal cover of a smooth connected projective complex variety. | The classical bridge is supported in prose under proper mapping and Chow, not a novel Argus result. The original reduction uses normalizations and finite-index image of finite surjective maps; dropping those qualifications would change the assertion. No old formal or independent source certificate is supplied. |
| `F_MAIN` | Introduction `thm:main`, completed in section 07: the stated large-group non-Stein fourfold. | Its chain still needs `F_GEOMETRY`, `F_MODELS`, `F_PATH`, `F_IMAGE` and `F_CYCLIC`. Supporting the terminal conditional reduction or the compactness criterion cannot supply that chain. Status: unresolved in the old Argus work, not disproved. |

The ledger routes are
`R_F_MODELS`, `R_F_PATH`, `R_F_IMAGE`, `R_F_CYCLIC`, `R_F_LARGE`, and
`R_F_MAIN_CURRENT`; their AND dependencies are recorded in the coverage index.
The earlier `R_F_MAIN` was retired specifically to expose `F_COMPACT`, not
because a fourfold counterexample had been found.

## What the terminal reduction actually establishes

Read section 02, lines 1-183. Given the required embedding in a smooth
projective `S'` of dimension `d`, take an abelian variety `B` of dimension
six and `W=S' x B`, fixing `F=A x {0}`. Cutting by `c=d+2` sufficiently
positive equations gives expected dimension four. The conormal rank along
`F` is `c+2`; rank failure for a general `c`-tuple has codimension three,
strictly greater than `dim F=2`. The same count for prefixes and Bertini
give smooth successive intersections; Lefschetz gives
`pi1(X)=pi1(S') x pi1(B)`.

The elementary interpolation lemma is explicit: multiply an ideal-generating
section nonzero at one point by very-ample sections vanishing at each of the
other selected points. A common degree works for every set of four distinct
points outside `F`. Ordered quadruples in one projection fiber have dimension
at most `4d+6`; requiring all `c` equations to vanish imposes `4d+8`
conditions. The strict dimension inequality excludes four such points
simultaneously. Consequently all positive-dimensional fiber subvarieties lie
in `F`. This is the relevant uniform incidence argument, not an assertion
that general complete intersections always have finite fibers.

For largeness, a nonconstant projection of a compact normalization to `B`
has infinite fundamental-group image: finite image in torsion-free
`pi1(B)` would be trivial, give a lift to `C^6`, and force constancy.
Otherwise the subvariety is in the simple `A`. A curve normalization maps
through its Jacobian onto `A`; simplicity forces surjectivity, and the
induced integral-lattice image has finite index in `Z^4`. Its image in the
assumed cyclic quotient is therefore infinite.

For non-Steinness, the kernel of `Z^4->Z` is rank three. A connected lift of
the **closed embedded** surface is the closed complex submanifold
`A_K=C^2/K`, diffeomorphic to `R x (S1)^3`, with `H3=Z`.
Andreotti-Frankel's Stein Morse bound in complex dimension two rules out
Steinness of `A_K`. A closed complex submanifold of a Stein manifold is Stein,
so the ambient universal cover is non-Stein. An abstract rank-three kernel
without the closed surface embedding would not prove the conclusion.

Thus the reduction is a supported **conditional argument**. Its explicit
external inputs are high-power ideal/conormal generation, Bertini,
Lefschetz, the complex-torus/Jacobian facts, the Stein Morse bound and the
closed-submanifold theorem. The original source cites Hartshorne broadly and
Andreotti-Frankel/Milnor (the latter theorem 7.2); no precise primary
proposition extracts for these appear among the old Argus citation records.
This assessment does not claim those citations were independently checked
or use them to declare the fourfold construction proved.

## The compactness bridge and its limits

The proof of `red:compact-criterion` handles both directions. Finite
`pi1(Z^nu)` image gives a finite compact cover of `Z^nu` lifting to the
universal cover; proper mapping gives a positive-dimensional compact analytic
image. Conversely a compact irreducible analytic subset upstairs has
projective algebraic image downstairs by proper mapping and Chow. Its
restriction is finite because the covering map has discrete fibers.
The induced finite surjective map on normalizations has finite-index
fundamental-group image: remove the branch/singular set, use the finite
covering on the smooth open sets, then use surjectivity of loops onto the
normal spaces. The upstairs normalization maps to the simply connected
ambient cover, so that finite-index subgroup has trivial image in `pi1(X)`.
The downstairs image is finite.

This is a sound classical implication with those external analytic facts,
not a kernel certificate. It neither supplies the cyclic embedding nor
implies non-Steinness from absence of compact analytic subvarieties alone.
The source of this bounded reading is the exact reference proof; independent
primary-source attribution for its named classical inputs is not claimed.
Missing citations are exposed rather than assigned invented identifiers.
The current ledger likewise leaves six named classical inputs of these two
conditional bridges `uncited`. It does not manufacture a completed citation
check or an unconditional fourfold theorem.

## Evidence, exclusions and final scope

No fourfold checker, exact certificate or Lean source is listed in
`PRIOR_DRAFTS.json`; no computation can responsibly be replayed for these
universal obligations. This is not an access failure: the theorem statements,
reduction and specific global/path premises were inspected. The reason for
the unresolved classification is that the inventoried Argus work contains
only these dependency assertions, without the required argument/evidence
for the construction chain. Existing surface group/lattice certificates
have different objects and hypotheses and cannot be substituted.

Reference illustrations, author text and source copies remain reference
support; they are not independent Argus proofs. No new arithmetic, path-graph,
orbifold or manuscript-error campaign was launched. The original fourfold's
overall validity remains unadjudicated here. This unit's assessment is complete
at the requested exploratory old-work bar: six construction/main obligations
remain unresolved, and two terminal classical/conditional bridges have the
precise supported scope just described. Current acceptance of coverage and
dispositions still belongs to the native independent Reviewer.
