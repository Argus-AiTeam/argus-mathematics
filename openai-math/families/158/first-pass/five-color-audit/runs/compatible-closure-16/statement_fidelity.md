# Statement fidelity: unrestricted five-color obstruction

`Audit9000158.no_unrestricted_five_coloring` states that there is no function
`c : Complex -> Fin 5` satisfying

```
forall z w : Complex, norm(z - w) = 1 -> c z != c w.
```

The object `Complex` is the ordinary Mathlib complex plane. Its norm is the
Euclidean norm, so `norm(z - w) = 1` means Euclidean distance exactly one.
`Fin 5` has precisely five labels; using only a subset of them is allowed.
Both endpoints range over the entire plane. The function has no regularity,
measurability, continuity, definability, density, or surjectivity hypothesis.
There are no extra parameters or premises on the theorem.

This is the literal lower-bound assertion of the staged manuscript,
`sections/introduction.tex`, `thm:main`, lines 60-68, with the proper-coloring
definition at lines 3-7. Identifying the real plane with the complex plane
does not alter that assertion. This declaration does not certify the
separate seven-color upper bound.

The proof unfolds only `OAI.EuclideanFiveColor.ProperColoring` and applies
`OAI.EuclideanFiveColor.no_proper_five_coloring`, imported from the actual
published `OAI.Geometry.PlaneColoring.Five` module, not from its comparator
challenge. The manuscript's measurable intermediate statements are not
added as hypotheses to this declaration. The proof is a faithful
certification wrapper around the published implementation, not a separately
discovered geometric proof and not a claim of new mathematical originality.

A compiler run must check the imported theorem's transitive axiom closure,
not merely the wrapper text. Only `propext`, `Classical.choice`, and
`Quot.sound` are permitted as ordinary Lean logical foundations. Any
`sorryAx`, additional theorem-specific axiom, unchecked implementation, or
missing environment audit disqualifies positive certification. The
`#print axioms` command exposes the wrapper's transitive axioms for the
certificate reader.

Compilation establishes the encoded theorem under those foundations.
The compiler does not itself establish this document's correspondence with
the staged prose, originality, or the truth of every separately stated
manuscript lemma. Those are distinct independent Reviewer questions.
