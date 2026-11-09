# Statement fidelity: protected-channel reduction

## Claim and boundary

This source formalizes `G157_PROTECTED_REDUCTION`. It does **not** by itself
formalize or close `G157_REALIZATION`, the literal manuscript theorem.
In particular, a successful compiler run must not be reported as a kernel
proof of the manuscripts' Boolean label-support theorem, their selected-atom
extraction, or their paired-profile annihilator containment.

The mathematical manuscript specialization is argued in `realization.md`.
Whether that prose argument establishes all hypotheses below is an independent
Reviewer question. The formal certificate proves the stated reduction for
every instance satisfying those hypotheses, not that every manuscript instance
satisfies them.

## Main universal realization declaration

`ProtectedChannels.protected_realization` is over an arbitrary field K.
L and R are finite-dimensional **quotient coefficient spaces**. V and W are
the full nominal spaces; their frozen subspaces are arbitrary and may mix
primal coordinates, channels, and multiple endpoints. The maps qL,qR kill
these entire frozen subspaces. P,Q are primal-input spaces mapped into V,W by
iL,iR. Injectivity of these input maps is not needed by this reduction.

X is a finite-dimensional profile space. It may encode the pair of endpoints
and all components together. `eval` is a linear map from primal bilinear forms
to X's dual, encoding contractions with profiles. It is not assumed to be
injective or surjective.

H is the finite-dimensional channel space. `pair` is an injective curried
bilinear pairing H -> H^*, hence nondegenerate. A and B are allowed channel
subspaces; their restricted pairing need not be nondegenerate.
F_0,G_0 are the already adjusted observed primal maps, including the bounded
derivative corrections. They are **not** the original pre-derivative baseline.
Elements of A are orthogonal to the primal image of G_0, and the primal image
of F_0 is orthogonal to B.

The pure quotient form M_0 is the fixed, possibly large-rank part removed
before compression. C,D are quotient endomorphisms and CX is a profile
endomorphism. The residual is

    target - eval(pair(F_0,G_0)) - eval(pull(M_0)).

The declaration quantifies over all this data and assumes:

- The residual vanishes on the annihilator of every pure quotient response
  (`hann`). This is **an input**, not the manuscript annihilator theorem proved
  by Lean.
- Compression commutes with response evaluation (`hnatural`), and the residual
  is invariant under CX (`hinvariant`). These are **inputs**, not a hidden
  assertion that arbitrary endomorphisms preserve the cut-profile domain.
- The codimensions of A,B are bounded by cA,cB, expressed without truncated
  subtraction as dim H <= dim A+cA and dim H <= dim B+cB.
- The sufficient budget is
  rank M_0 + rank C + cA + cB <= dim H.

The conclusion produces actual linear maps dF: V -> H and dG: W -> H.
They vanish on the entire source frozen subspaces, have images in A,B, and
satisfy

    eval(pair(F_0 + dF iL, G_0 + dG iR)) = target.

There is no independent pure-response variable left in this conclusion. It is
a parameter-uniform exactification implication, not a list of finite examples.
Opposite frozen projections are handled by A,B's protected annihilator
conditions in the Gram-assembly declarations, not by pretending they are pure
primal directions.

## Annihilator, compression, and factorization declarations

`response_solvable` proves finite-dimensional image/annihilator duality.
`response_solvable_from_isolation` derives solvability when the annihilator is
contained in the sum of an effective and a selected subspace and the target
vanishes on both. That containment is an explicit hypothesis; the declaration
does not identify the annihilator of the manuscript's moment domain.

`compression` proves, for every subspace U and every linear map f on a
finite-dimensional vector space, existence of an endomorphism C fixing U,
preserving f, and having rank at most dim U+rank f. The constructed C need
not be idempotent. `compressed_rank` proves the rank bound for precomposition
of an arbitrary bilinear form with two such maps. Neither declaration assumes
that an arbitrary compressed profile is still a cut profile.

`factor_through_pairing` proves that every bilinear form factors through any
bilinear pairing of at least its rank, even if the latter is degenerate.
`restricted_pairing_rank` proves rank(pair|A x B) >= dim A+dim B-dim H.
`factor_with_codimensions` combines these results with the sufficient channel
budget. These statements quantify over arbitrary finite dimensions and fields,
not only F_2.

`boolean_moment_scalar` proves the universally quantified F_2 scalar identity
by kernel-evaluated decision over its four field elements. `boolean_ray_isolation`
then proves the selected Boolean moment block reduction for an **arbitrary**
coordinate index type, given its first-coordinate and diagonal identities.
It assumes the displayed symmetric rank-two-plus-one representation; it does
not derive that representation from a moment quotient.

`mixed_pin_strip` treats a full nominal product of combined primal and channel
spaces. Given a decomposition into a pin, a selected key, and a private
channel vector, it removes the latter two terms using the explicitly assumed
disjointness of selected keys from unselected support plus projected pins, and
the disjointness of protected and private channels. It allows arbitrary mixed
pins. The sparse-label argument establishing the first disjointness is not
silently formalized by this declaration.

## Simultaneous Gram assembly

`assemble`, `assemble_frozen`, `assemble_primal_channel`, and
`assemble_channel_primal` work for arbitrary finite endpoint sets I,J and
arbitrary full nominal spaces V,W. Channel projections and embeddings have
their usual coordinate Kronecker identities, and projections of primal
inputs to channels are zero.

`gram_completion` constructs a **single** new bilinear form extending a
baseline Gram block. It preserves all rows and columns belonging to the two
arbitrary frozen subspaces, and realizes every forward and reciprocal
primal-channel increment simultaneously. The hypotheses are source vanishing
of the correction maps and annihilation of the opposite frozen channel
projections. Thus channel-channel overlap is permitted but cannot interfere
with primal-input evaluations. Applying the declaration to the other cross
block gives both blocks in the manuscripts; there is no shared mutable entry
between those two blocks.

No declaration asserts the existence of manuscript recipes, validates a
probability estimate, establishes a graph-theoretic counterexample, or claims
mathematical novelty. The exact specimen in `verify.py` exercises mixed pins,
keys, private channels, nonzero derivatives, four-factor pure corrections,
both endpoints, and both roles. It is explicitly not an admissible manuscript
counterexample or a substitute for the unformalized specialization.
