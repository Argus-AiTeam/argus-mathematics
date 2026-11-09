# Exact scope of the Lean declarations

This document describes `Main.lean`, namespace `FiniteLevelHomology`.
The ledger claim is `C9000177_FORMAL_BRIDGE`, not the complete
manuscript, not `C9000177_STABILIZATION`, and not `C9000177_ACTION`.

`AddTower` is an inverse sequence of arbitrary abelian groups indexed by
natural numbers. `down n m hmn` is the group homomorphism from index `n`
to index `m`, where `hmn` proves `m <= n`. Identity and composition are
required. `TowerMap` is a level map commuting with these transitions.
For the application, index `r` means congruence level `r+1`; no level
zero congruence group is introduced.

`EventuallyInImage f` means: for every target index `m`, there is an
index `n >= m` such that every element of the target at `n`, after
transition to `m`, is in the image of `f` at `m`. For abelian groups
this is precisely the pro-zero-cokernel condition. It does NOT assert
levelwise surjectivity.

`twoLayerEventuallyInImage` takes two three-term sequences of inverse
sequences and their vertical maps `f,g,h`. The horizontal maps are
`i,p` and `i',p'`. Both squares must commute at every index. The map
`p` must be surjective at every index, and every element in the kernel
of `p'` must be in the image of `i'`, at every index. The end vertical
maps `f,h` have pro-zero cokernels. The conclusion is that the middle
vertical map `g` has pro-zero cokernel. No splitting of the sequences
and no levelwise surjectivity of `f,g,h` is assumed. The proof uses
two successively later indices; it does not interchange quantifiers.
The application is the natural universal-coefficient diagram, with
left terms integral homology tensored with F_2 and right terms integral
homology Tor F_2. The construction of group homology, that universal
coefficient theorem, and preservation of pro-isomorphisms by these
functors are NOT formalized here.

`levelwiseSurjective` assumes `EventuallyInImage f` and surjectivity
of all transitions of the TARGET tower only. It concludes surjectivity
of `f` at every index. It does not assume surjectivity of `f` or
surjectivity of the source transitions.

`surjectiveOfTransfer` proves that a function with a right inverse is
surjective. In the application, transfer is the right inverse of the
homology map induced by inclusion, since the finite index is odd and
the coefficient field is F_2. The existence and identity of group
homology transfer are mathematical inputs proved/explained in
`proof.md`; they are not Lean hypotheses disguised as a computation.

`trivialActionOfSurjectiveFixedImages` quantifies over any group `G`,
any set `H`, and an action encoded as a homomorphism to permutations
of `H`. A specified set generates `G` as a subgroup. For each of its
elements there is a possibly different set mapping surjectively to
`H`, and that group element fixes every point in that image. The
conclusion is triviality of the entire action on `H`. In the concrete
application, the generators are elementary matrices, and the sets
are the homology groups on their complementary coordinates. The
surjectivity of these particular maps and elementary generation
over k[t] are established in `proof.md`, not assumed as the target
trivial-action conclusion.

`relativeIdentityReflection` is an identity-reflection lemma for two
ring maps. An element with both images equal to one is one, provided
the intersection of the two kernels is zero. It does NOT assume that
the integer unitization maps injectively to k[t]. Its application is
to products of lifted inverse matrices: augmentation and polynomial
evaluation together detect equality.

`relativeWitnessIdentity` is the ring identity underlying the
relative unimodularity witness correction when the original dot
product is one. `complementarySupportsCommute` proves that
`1+x` and `1+y` commute in any ring when both cross products vanish.
The verification that the relevant matrix supports have those zero
products is given for arbitrary sizes in `proof.md` and checked
independently as an integer polynomial identity by `verify.py`.

Thus a successful compiler run certifies the universal promotion,
two-layer coefficient diagram chase, and action logic, plus the
specified ring identities. It does not certify Morrow's or Iwasa's
theorems, the polynomial CRT existence argument, elementary generation,
or the unexamined geometric input. The mathematical verification of
the two manuscript lemmas uses these explicitly separated inputs.
