# Statement fidelity: the complete arbitrary-tolerance affine lemma

`Campaign149.literal_affine_lemma` states the complete `lem:affine`
appearing in both staged manuscripts. It is not a conditional flux lemma,
a fixed-dimension experiment, or a formalization assuming affine existence.

The universally quantified objects are a natural dimension m with m > 0;
arbitrary real endpoints a < b; an arbitrary real-valued function E on
the subtype `{r : Fin m -> Real // Cube a b r}`; and the sole tolerance
hypothesis `forall r, 0 < E r`. No continuity, measurability, uniform
lower bound, or definability of E is assumed. `Cube a b r` means that
every coordinate lies in the closed interval [a,b].

The conclusion chooses a finite nonempty set Lambda of `Label m`,
and a proof that every label's slope lies in the cube. A label contains
one vector `slope : Fin m -> Real`, with no h argument, and a real
function `offset : Real -> Real`. Thus both the family and its slopes
are fixed before h and the exponent sequences are quantified.
Every offset is little-o of `h ^ a` in the right-hand neighborhood of
zero. Real powers are `Real.rpow`. Globally defined offsets are stronger
than the manuscript's permission to define them only for small h.

For each fixed label L in the chosen family, the theorem quantifies over
every sequence of strictly positive h_n tending to zero, every sequence
p_n in the whole space `Fin m -> Real` converging to p_0, and every
p_0 in the cube. There is deliberately no cube condition on p_n.
`powerPoint h p` has coordinates `h ^ (p i)`.
`Active Lambda L h x` means L belongs to Lambda and its affine value
is less than or equal to every label's value. This includes every tied
minimizer, not just a selected minimizer.

Under activity at every point of the sequence, the conclusion is the
strict inequality `norm (p_0 - L.slope) < E L.slope`. On a nonempty
finite real coordinate type, the Pi norm is exactly the maximum of the
absolute coordinate errors, hence the manuscript's sup norm. Evaluation
of E uses the previously supplied cube-membership proof; proof
irrelevance ensures it does not change the function's argument.

The adapter extends a cube-domain E to the whole space by assigning 1
outside the cube. The construction only requires positivity inside the
cube. The adapter then extracts all fields of the proven
`OAI.Problem326.Affine.exists_fullCertificate`. That theorem is included
with its entire recursively fetched non-Mathlib dependency closure in
`Main.lean`, not postulated as an axiom. The dependency-ordered source
concatenation removes internal imports. Two API names are backported
without changing the mathematics: `IsLittleO.fun_sum` becomes
`IsLittleO.sum`, and `dite_eq_left` becomes `dif_pos`. These replacements
are recorded in the source header and acquisition code. The source pin
and Apache-2.0 attribution are in the
file header, `exact_certificate.json`, and `LICENSE.upstream`.

The fresh compiler run must print the axiom dependencies of both
`Campaign149.literal_affine_lemma` and
`OAI.Problem326.Affine.exists_fullCertificate`. The replay rejects
anything beyond the standard Lean foundations `propext`,
`Classical.choice`, and `Quot.sound`; in particular `sorryAx` or an
affine-existence axiom is not acceptable. The prescribed Argus verifier
must separately report exit code 0 and no proof holes.

This is an independently executed replay and statement-fidelity audit of
an existing OpenAI formal proof. It is not a newly discovered
mathematical theorem or an independently authored replacement for that
proof. No result here certifies the downstream boundedness, persistence,
or classwise permanence theorem. The compiler does not verify this
English reading; independent Reviewer assessment is still required.
