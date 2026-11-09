# Monodromy density and tensor compatibility

**Assessment: supported conditional argument.** This is
`L_ABG_DENSITY@1`, old `theorem.md` Section 6, after its component fact.
It requires the compatible lifted tower; it does not establish that
the prescribed arithmetic tower has been constructed over \(\bar D\).

## Exact claim and hypotheses

Use the common compact group \(J\), cofinal open normal subgroups \(J_r\),
and compatible right \(J/J_r\)-torsors on the proper twisted smoothing
models. A section and compatible frames identify the finite fibers.
Assume the first punctured component parameter has dense geometric image
\(H_1\) and that these are the restrictions of the supplied tower.
The generic monodromy \(H_\tau\) should contain \(H_1\) in the **same**
framed \(J\), and hence be Zariski dense. The reductions of all associated
tensor local systems should have the stated special restrictions and
supplied arithmetic action.

## Decisive argument

At finite level the first-component orbit of the frame lies inside its
connected component in the whole special torsor. The supported
[component-partition lemma](../component_partitions/report.md) identifies
that fiber subset with the corresponding geometric generic component.
For a right torsor, these frame orbits are the monodromy images, so
\[
 \operatorname{im}(H_1\to J/J_r)
 \subset \operatorname{im}(H_\tau\to J/J_r)
 \quad\hbox{for every }r .
\]
Both images in \(J\) are compact, thus closed. If an element of \(H_1\)
were outside \(H_\tau\), some cofinal finite quotient would separate it
from the closed subgroup, contradicting the inclusions. Therefore
\(H_1\subset H_\tau\), and its dense Zariski closure forces density of
the latter. This argument correctly allows disconnected enlarged-group
torsors: surjectivity onto every \(J/J_r\) is not assumed.

For any algebraic representation choose a \(J\)-stable lattice, after a
coefficient extension for that representation if necessary. Its finite
reductions factor through some \(J/J_r\); the same lifted torsors compare
their sheaves, tensor products, and morphisms. Clearing denominators
handles maps between lattices. This gives parameter/tensor compatibility,
not a Weil structure on an eigensheaf. The parameter itself is not claimed
to need a coefficient extension.

## Evidence, dependencies, and limitation

The inherited independent support is
`judgement-L_ABG_DENSITY-d0d25add71f5`; `...-a1476a8b3f27` is the author
opinion. The proof depends on the conditional gluing and component lemma,
whose external inputs and source readings are recorded in their reports.
The old route `R_ABG_COMPONENT_DENSITY` records this use of the component
lemma; it is not another independent result.

The reference several-point `con:parameter` already uses finite torsor
connectedness and compact inverse limits in a geometric setting. Here
the contained first-component image, rather than connectedness of the
whole enlarged-group torsor, is the useful scope distinction. Priority
is not independently established.

No matrix fixture proves the cohomological component assertion or this
infinite inverse-limit argument. There is no Lean source or mechanical
certificate for them. The successful [finite replay](../computation/replay.json)
therefore does not close an arithmetic dependency.

No separate gap is identified after the exact tower and first-component
image are supplied. Obtaining that image and the prescribed arithmetic
action over the asserted generic base remains
[F1](../arithmetic_tower_lift/report.md), so this conditional support
does not establish the combined theorem. Native review is pending.
