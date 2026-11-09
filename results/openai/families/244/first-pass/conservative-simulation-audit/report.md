# Conservative simulation of the two presentations

## Theorem and scope

Let `f:B -> M` be a conservative monoid embedding in the sense of
`build/sections/monoid.tex`: comparisons have their original right factors,
existing conditional right joins remain joins, and disjoint principal
right cones remain disjoint. Both bases are left cancellative and conical
and have conditional right joins. All the parameters of an operation lie
in `B`.

**Theorem.** A finite overlap prescription is valid over `B` if and only
if it is valid over `M`. For either actual presentation in
`lem:mono-simulation`, the homomorphism extending `f` and sending each new
generator to its namesake is a conservative embedding. In particular,
every right factor between its image elements belongs to its image,
every conditional right join is preserved, and a pair without a common
right multiple acquires none.

The proof below is universal, not an inference from the finite checks.
It needs no right cancellation, injectivity of the probe transition
maps, heights, or costs. Thus it applies under the manuscript's stronger
margin hypotheses. It resolves this dependency only, not the
countable-base rearrangement or the manuscript's set-theoretic theorem.

## Scoped source knowledge

The literal source is the staged September 24, 2026 manuscript,
`build/sections/monoid.tex`, specifically the definitions of
conservativity and validity, the two extension presentations, and
`lem:mono-simulation`. The independently accepted claim `C_PROBE_CORE` v2
supplies the actual probe normal-form monoid, its presentation universal
property, conservation of its base, and its exact exit cones with old
right factors. Its source, statement-fidelity note, compiler certificate,
and Reviewer judgement are reused unchanged. The relevant Reviewer is
`reviewer:copilot-74aa4471aa14`; no renewed review of that claim is sought.

No external literature theorem is assumed in the argument below.
In particular, it does not appeal again to Newman's lemma. The local
Wiki index and project Skill descriptions supplied no result about this
simulation question. The earlier failed objection that a noninjective
transition destroys the direct-limit action is already excluded by the
accepted core: cancellation takes place on the left at a common stage.
The stronger support question needed here is proved next, rather than
inferred from injectivity.

## 1. Probe letters: the support-lifting fact

The probe datum remains legal over `M`: the path equations are preserved
by the homomorphism, and injectivity preserves `b != 1` and `e != 1`.
In particular no additional hypothesis is hidden in the larger
presentation.

Write `D(i,j)=d_i ... d_(j-1)`, and use subscripts for the base in
`S_B` and `S_M`. Define

    J([x,i]_B) = [f(x),i]_M.

The finite products satisfy `f(D_B(i,j))=D_M(i,j)`. Therefore `J` is
well-defined. If two image letters are equal, at a common finite stage
their coordinates are `f(x D_B(i,k))=f(y D_B(j,k))`. Injectivity of `f`
gives equality in `B` and hence equality in `S_B`. This proves
injectivity without cancelling any right factor.

Here is the stronger assertion. For `a in B`, if

    f(a) * t = J(s)                         (t in S_M),

then there is a unique `t0 in S_B` with `t=J(t0)` and `a*t0=s`.
Represent `s=[x,i]`, `t=[y,j]`. At a common stage `k`,

    f(a) * (y D_M(j,k)) = f(x D_B(i,k)).

Both endpoints of this old comparison are in `f[B]`. Conservativity
puts the entire right factor `y D_M(j,k)` in `f[B]`, say it is `f(z)`.
Thus `t=[f(z),k]=J([z,k])`. Injectivity of `f` gives
`a z=x D_B(i,k)`, which proves the desired letter equation.
Uniqueness uses the injective old left action on `S_B`.
There is no assertion that the earlier representative `y` itself is
in `f[B]`: that would be unjustified when a transition is noninjective.
The assertion is about its direct-limit class.

The maps also intertwine old left actions and satisfy

    k_M(J(s))=f(k_B(s)),    h_M(J(s))=f(h_B(s)).

These are identities on representatives, using `h(s)=k(s)e`.

## 2. Probe normal forms and paired gates

Map an old terminal value by `f` and every direct-limit letter by `J`.
A raw word is reduced exactly when each later letter or terminal value
is not a left `b`-multiple. The preceding lifting fact, and old
right-factor conservation for terminal values, show that a smaller
word is reduced if and only if its image is reduced.
The unique quotients in every reduction `s(bT) -> h(s)T` correspond.
Consequently normalization commutes with the map. This constructs an
injective homomorphism of the two normal-form monoids. By the accepted
presentation universal property it is precisely the homomorphism of
the actual presentations with the same new generators.

We need gates in the larger extension, not merely gates tested on
smaller right factors. The following simultaneous recursion supplies
them. For a reduced word `W=sY`, its exits from its first-head block
are found by intersecting the suffix cone with the old `b`-cone.

If `Y=y` is old, use `y vee b`, or the absence of that old join.
If `Y=tZ` is new, normality gives `t notin bS`. Its whole fixed-head
block is disjoint from the `b`-cone, in either extension, by Section 1.
Its exits are either absent or precisely `g(Y)` times the entire
extension. Inductively these alternatives agree in the two bases.
In the nonempty case the suffix intersection is therefore calculated
by the old join `g(Y) vee b`.

Every old join, its nonexistence, and its right quotients agree in `B`
and `M`. If the suffix intersection is `zN`, write `z=b u`, with
`u` old and in `B`. The new gate is

    g(W)=h(s)u.

If `Y=y` is old, its old gate factor is the quotient `c` in `y c=z`.
If `Y` is new, it is `c(Y)v`, where `g(Y)v=z`.
These formulas construct the same old gate and the same old factor in
both extensions. If the required old intersection is empty, the word
has no exit in either extension. This proves equality of the full
exit alternatives, including all larger right factors. It uses the
accepted exit-cone theorem, not an assumption of simulation.

## 3. Probe right factors, joins and nonjoins

Suppose `image(U) Q=image(V)` in the larger probe extension.
If both words are old, conservation of the old base in its probe
extension first makes `Q` old, and conservation of `B` in `M` makes
it smaller. If `U` is old and `V` is new, multiplication acts on
the first letter of `Q`, leaving its suffix unchanged. Section 1
lifts its first-letter quotient; the unchanged suffix and terminal
value are those of `V`. Thus `Q` is smaller.

If both words have the same head, left cancellation of that letter
reduces the equation to the suffixes. If `U` is new and `V` is old
or has a different head, the equation exits `U`'s block. The paired
gate gives `U c(U)=g(U)` with `c(U) in B`. Divide the old `g(U)`
into `V` by the already settled old-divisor cases. If that smaller
quotient is `R`, then `U(c(U)R)=V`; left cancellation in the larger
extension forces `Q=image(c(U)R)`. Induction on the sum of word
lengths proves conservation of every right factor.

For completeness, the following synchronized intersection algorithm
proves more than reflection of comparisons:

* Two old words use the old join or old nonjoin.
* For old `x` and new `W` with head `s`, membership `s in xS`
  makes `W` their join. Otherwise every common multiple exits `W`,
  and their intersection is calculated by `x vee g(W)`; a missing
  gate or old join gives an empty intersection.
* For equal new heads, cancel the head and intersect the suffix
  cones. A suffix intersection rooted at `K` gives a full-word
  intersection rooted at the product of that head and `K`.
  This is valid even if that product reduces, since multiplication
  by the head is injective.
* For different heads `s,t`, a common multiple inside the `s`-block
  must be an exit of the other word. Its old gate divides one
  member of that block, hence every member, by the old-cone formula.
  Thus the other word divides the first; the first is their join.
  The symmetric case is identical. If neither such membership
  holds, every common multiple exits both blocks, and the answer
  is the old join of their gates, or an empty intersection.

Every test in this algorithm is either a smaller equality, an old
join/nonjoin, or division of a smaller letter by an old smaller
element. Every constructed root belongs to the smaller extension.
Sections 1 and 2 synchronize all of these tests and constructions.
The algorithm calculates the *entire* larger intersection, so the
image of a smaller join is still its root, and a smaller nonjoin
remains a nonjoin. Together with right-factor conservation and
injectivity this proves conservative probe simulation.

## 4. Finite-overlap validity, in both directions

Let `R_B` and `R_M` denote exactly the stated pair identifications
together with equality, not their transitive closures. They commute
with right multiplication. On pairs of smaller points, `R_M`
restricts to `R_B`: a witness to an overlap has
`f(a_ij) q=f(x)`, so its parameter `q` is in `f[B]` by
right-factor conservation. This also reflects same-copy equality.
Consequently validity over `M` implies validity over `B`.

Conversely suppose the prescription is valid over `B`. Consider a
transitivity test from copy `i` through copy `j` to copy `k`.
Equality steps cause no difficulty. For two overlap steps the middle
coordinate satisfies

    f(a_ji) r=f(a_jk) s.

There must be an old join `z=a_ji u=a_jk v` in `B`: otherwise
conservativity would forbid the displayed common multiple in `M`.
The preserved join and left cancellation give a common `q in M`
with `r=f(u)q` and `s=f(v)q`. The two endpoints at the middle
coordinate `z` are `a_ij u` and `a_kj v`, both in `B`.
Validity in `B` identifies them directly, or equates them when
`i=k`. Right multiplication by `q` gives the required direct
identification of the original endpoints in `M`. This proves
transitivity of the stipulated relation itself.
Symmetry and reflexivity come from the symmetric prescription and
equality. No distinct same-copy points are identified: within a
copy the relation is equality, and transitivity has just been
proved without adding any extra pair. This proves validity in `M`.

The argument actually needs only the indicated three copies at a
time; it does not use a finite search or right cancellation.

## 5. Merger letters and all their cone intersections

Validity makes the quotient right sets `D_B,D_M` exactly the given
relations. The map

    J_D(t_i x)=t_i f(x)

is well-defined and injective by Section 4. It has the following
right-factor property:

    J_D(z) q=J_D(w)  =>  q=f(q0), z q0=w.

Choose smaller representatives `z=t_i x,w=t_j y`. If `i=j`,
injectivity of the copy gives `f(x)q=f(y)` and old conservativity
applies. If `i!=j`, the direct overlap gives a parameter `r` with

    f(x)q=f(a_ij)r,    f(y)=f(a_ji)r.

The second equation puts `r` in `f[B]`; the first then puts `q`
in `f[B]`. Both identifications therefore already hold over `B`.
This proves the assertion even if a point has several copy
representatives.

Here is the full intersection calculation, to exclude new cone
intersections rather than merely new comparisons. Within one copy
use its old join. For `t_i x,t_j y` in different copies there is
no intersection if their prescribed overlap is absent. Otherwise
put `a=a_ij,c=a_ji`. First compute

    x vee a=a u=x r,    y vee c=c v=y s.

A missing preliminary join makes the intersection empty.
Every common point has overlap coordinate `q` satisfying
`u divides q` and `v divides q`, by left cancellation of `a,c`.
If `u vee v=K` exists, the exact intersection root is

    t_i(a K)=t_j(c K).

Indeed `K` is a common multiple of `u,v`, so this point is a
multiple of both original points; every other common point has
coordinate `K h`, and is precisely this point times `h`.
If `u,v` have no common right multiple, the original cones are
disjoint. All three old joins, their right quotients, and their
absence are preserved by the base inclusion. Hence this is
the same calculation in `D_B,D_M`, and its result is the full
larger intersection. It gives preserved joins and nonjoins of
merger letters.

## 6. The actual merger monoid and conservative simulation

For clarity, the following verifies the presentation model rather
than assuming a normal-form interface. Its elements are pairs
`(x,Z)` with `x in M` and `Z` a finite list in `D_M`. Multiplication is

    (x,[])(y,T)             = (xy,T),
    (x,Z0 ++ [z])(y,T)      = (x,Z0 ++ [z*y] ++ T).

The right action law `(z*y)*v=z*(yv)` proves associativity at the
only seam; old associativity treats an empty first list. Identity is
`(1,[])`. The old embedding is `x -> (x,[])`; the new generator
`l_i` is `(1,[t_i 1])`. These obey exactly the displayed merger
relations. For any target monoid, a homomorphism on the old base
and any images of the `l_i` satisfying those relations define
`q(t_i x)=l_i f(x)`. Validity makes this well-defined, and
`q(z*x)=q(z)f(x)`. Evaluation of `(x,[z1,...,zp])` is therefore
the unique extending homomorphism. This proves the universal
property of the actual presentation.

Each map `a -> z*a` is injective: choose `z=t_i x`, use
injectivity of that copy, and cancel `x` on the left in the base.
The multiplication formula now proves left cancellation.
List length is additive, so conicality follows from that of the
base and no new element divides an old one.

The proposed simulation maps the old coefficient by `f` and each
letter by `J_D`; its injectivity and multiplicativity follow from
Section 5 and the multiplication formula. For a right-factor
equation between image words, an old divisor reduces to an old
coefficient comparison and leaves the list unchanged. For a
positive-length divisor, multiplication keeps its old coefficient
and all but its last letter; it advances the last letter by the
old leading coefficient of the factor and appends the factor's
list. Equality with a smaller word therefore fixes that appended
list, and Section 5 puts the advancing coefficient in `B`.
Thus the entire right factor is smaller, including when its
length is zero.

Finally the complete cone calculation is as follows. Two old
words use their old join/nonjoin. An old `x` and a new word
with old coefficient `y` have a common multiple exactly when
`x divides y`; the new word is then their join. For two new
words of lengths `p,q`, their old coefficients and the letters
before position `min(p,q)` must agree. If `p=q`, intersect
their final-letter cones using Section 5 and retain their common
prefix. If `p<q`, the shorter final letter must divide the
longer word's letter at position `p`; if so the longer word is
their join, otherwise the cones are disjoint. The case `q<p`
is symmetric. Right multiplication never changes an earlier
letter, so these conditions are necessary and sufficient for
arbitrary larger common multiples.

Every equality, division, and letter-cone calculation in these
tests is preserved and reflected by Sections 4 and 5. Every
intersection root is smaller. This proves preserved joins and
nonjoins and finishes conservative simulation of the second
actual presentation.

## Exact infinite test model

The executable model is the direct product of ordinal addition below
`omega^3` with a free monoid. The larger base has ordinal coordinates
`(A,B,C)` and alphabet `{0,1,2}`. The smaller base has `C=0` and
alphabet `{0,1}`. Ordinal right divisibility here is lexicographic
comparison, with the explicit unique quotient implemented by `divide`;
free-monoid right divisibility is the prefix order. Thus the product
is left cancellative and conical, and its conditional join is the
coordinatewise ordinal maximum together with the longer compatible
free word. Incompatible free prefixes have no common right multiple.
The quotient between smaller endpoints is smaller, and these exact
intersection formulas prove this is a conservative inclusion.

The probe parameters are `n_i=omega*i`, `d_i=omega`, `c_i=a=omega^2`,
`b=(omega^2,[0])`, and `e=(omega,[1])`. Free components not displayed
are empty. All the path equations hold. Right multiplication by
`omega` is noninjective: the finite ordinal `1` and the identity
ordinal `0` both give `omega`. The first is not in the smaller base,
but their direct-limit letters agree. A letter's exact coordinate is
`(A,B-i,word)`; the finite ordinal coefficient disappears after
one transition. The executable normal forms therefore represent
infinite monoids, not finite tables or truncated presentations.

For the merger experiment, every pair of three copies shares the
cone of a chosen smaller start in each copy, with equal overlap
parameters. This prescription is universally valid. Canonical
quotient-letter coordinates distinguish a local point from a point
in the shared cone; the code implements the full three-join
intersection formula, not a search for a bounded common multiple.
Additional deliberately invalid prescriptions exercise the exact
three-copy criterion; they are test data, not manuscript flaws.

Both countable bases can also be given margins if desired. Assign
positive summable weights to the larger base with total below `1/4`,
put `rho(x)=1/4+2*sum_{d divides x} weight(d)`, and
`epsilon_x=weight(x)`. In a strict comparison the missed set is
nonempty, so twice its positive weight sum strictly exceeds its
largest weight or its supremum. Restricting these functions to the
smaller base still gives its margin. The simulation proof itself
does not require this additional structure.

## Evidence boundary and replay

The official Lean 4.31.0 compiler and axiom audit exited `0` with
`proof_holes=[]` on `C_SIM_SUPPORT_KERNEL`. This universally certifies
two-way validity transfer, exact restriction of the overlap relation,
merger-letter right-factor closure, and probe direct-limit support
lifting. The paired-gate and full word-cone arguments above are
complete prose proofs, not wholly encoded Lean theorems. Their
independent review is still required.

Run the standalone exact replay from the campaign root:

```sh
$WORKSPACE/argus-live-update/.venv/bin/python research/conservative-simulation-audit/verify.py
```

It checks the source-bound official certificate without recompiling
unchanged sources, checks that the independently accepted probe
evidence is unchanged, and exercises both exact infinite normal-form
models. `--formal` additionally runs the official compiler and the two
campaign-local ledger checks. The archived Jacobian payload and typed
answer check two finite first-order associativity/right-action
critical pairs. This is only a seam calculation for the merger model,
not evidence of universal conservative simulation by itself.

The theorem above is a complete mathematical verification of the
bounded simulation lemma. Formal and executable artifacts state
their precise coverage separately; finite experiments are not
used to establish the universal conclusion. No false manuscript
assertion has been established in this audit.

Compared with the accepted probe core, the new assertion controls
*relative* normal forms and arbitrary factors in a larger base,
and adds the merger operation and two-way validity transfer.
It does not establish rearrangement, countable stabilizers,
the forcing construction, novelty, or publishability. The campaign
goal remains open, and independent Reviewer acceptance of this
new theorem is required.
