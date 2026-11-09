# Universal reconstruction of the manuscript's lower disk diagram

## Result and scope

**Theorem.** Fix any rank pattern used in the disk replacement of
`reduction.tex`. Every solution of that lower diagram reconstructs a solution
on the original punctured disk, preserving the specified child-quotient
identifications. The construction closes around the boundary. Its choice
space is a finite tower of locally affine bundles. For an integral lower
solution the successive fibers are torsors under finite free matrix modules
over the **full** ring of integers, and each has an integral point.

The proof below works in arbitrary ranks, including zero local blocks, in
both directions through every event. It does not impose any additional
condition on a lower solution. In particular it does not assume the existence
of the coarse swap sequence: Section 4 derives that sequence from the actual
lower gadget before using it.

This resolves the disk-reconstruction assertion used in Proposition
`nonclosed-reduction`, not that proposition's smaller-rank density hypothesis,
the closed-surface argument, exact-Jordan descent, or the main density theorem.
It is a constructive verification, not a counterexample, a finite search
result, or a claim of mathematical novelty. Independent review is still
required. No false manuscript assertion is established here.

The strongest prior result in this campaign was the source statement alone:
the initial ledger had no evidence. The improvement is a universal
normalization and restriction calculation, together with a separately
machine-checked contraction/closure core; it is not just another check of
the displayed sequence in already-chosen coordinates.

## 1. Sources, hypotheses, and the precise meaning of a lift

All source references below are to the locally staged September 25, 2026
version of *Integral points on character varieties of curves*, under
`research/openai_manuscript/Integral-points-on-character-varieties-of-curves-September-25-2026/build/`.
No external theorem is needed for this proof.

| Source | Specification actually used |
|---|---|
| `sections/diagrams.tex`, definitions before Theorem `diagram-density` | Finite free facet fibers and named graded modules; distinct side occurrences; opposite parent/child orientations; split compatibility; complementary interchanges with **natural identified projections**. |
| `sections/diagrams.tex`, Lemma `two-flags` and its proof | The precise reduced row-to-column gallery whose properties are verified in Section 2 below. This lemma is not assumed without proof. |
| `sections/diagrams.tex`, Lemma `filtered-lift` | The lift and stabilizer assertions verified in Section 3 below. |
| `sections/reduction.tex`, replacing-a-disk subsection, lines 141-198 | The proper prefix, the zero-rank conditions on the anchor, identical scalar monodromies on `U,Q`, and the regular-interval exact data. |
| `sections/reduction.tex`, split/merge subsection, lines 210-254 | The retained coarse seam and internal `W` flag, transverse refinements, and the two-flag interleaving. |
| `sections/reduction.tex`, negative-scalar subsection, lines 256-375; `figures/diagram-swap.tex` | The before/after lists, the four contacts in cyclic order `U,B,Q,A`, and the scalar `-I`. |
| `sections/reduction.tex`, final subsection, lines 377 onward | The literal assertion being verified: arbitrary lower solutions have successive affine lifts and boundary closure. |

Let `R` initially be any commutative ring, with all named blocks finite free.
The manuscript case is its specified `R = O_F`. In a regular interval write
`u_i = U_i/U_(i-1)` and `q_i = Q_i/Q_(i-1)`. The lower seams and strips give
specified maps

```
0 -> u_i --alpha_i--> W_i --beta_i--> q_i -> 0.
```

These are split exact sequences: lift a basis of `q_i` to `W_i`. A lift means
both a flag `V_i` in `V=U direct-sum Q` and isomorphisms
`f_i : V_i/V_(i-1) -> W_i` commuting with `alpha_i,beta_i`.
It does not mean only a collection of submodules.

Every use of an intersection below is either over the original complex
solution, when selecting a rank pattern, or is proved equal to a direct sum
of named free blocks. There is no assumption that arbitrary intersections
of integral lattices are free.

## 2. What the two-flag gadget supplies over R

Consider its fully refined first flag, with labeled free pieces `V_ij` in
row-first order. Split that flag, respecting the specified graded
identifications. During the sorting, an adjacent interchange of labels
`a,b` replaces the lift of the `b` summand, in the two-block quotient, by
its graph over the old `b` summand. Lift this graph by a map from the free
`b` block into the `a` block and change only that summand.

This change preserves every earlier flag **and its graded identification**.
Indeed `a` was before `b` in every earlier order: that pair has not crossed
previously and cannot change order without crossing. An earlier prefix
containing `b` therefore contains `a`; on an earlier graded quotient the
added `a` component is zero. At the present interchange the prescribed
natural projections say exactly that the quotient identification of the
graph is the old identification of `b`. Thus induction gives one splitting
of the entire gallery, including all its labeled quotient maps. No inverse
of a nonunit is used.

Every intermediate order extends the coordinatewise partial order on
`(i,j)`: only incomparable pairs are swapped. Consequently the endpoint
flags in the common splitting are

```
F_i = direct-sum_(k<=i,j) V_kj,
H_j = direct-sum_(i,l<=j) V_il.
```

This proves their intersections and induced refinements are the intended
named direct sums, even over `R`. It does not infer this from dimension
counts over a field.

For completeness, simultaneous matching of two such galleries is also
explicit. In common splittings a block from `(i,j)` to `(i',j')` can be
nonzero only if `i'<=i` and `j'<=j`. Equal-row blocks are fixed by the
`F`-graded maps, equal-column blocks by the `H`-graded maps. Their only
overlap is a diagonal block, and equality there is precisely agreement on
the double grades. All blocks strictly lowering both indices are free.
The diagonal blocks are isomorphisms, so this matrix is invertible over
`R`; its strict triangular part is nilpotent. It respects every gallery
flag and labeled quotient. This also verifies the band-matching assertion
used before disk replacement.

Zero labels may be kept as zero summands throughout this argument.
Deleting them afterwards changes none of the statements.

## 3. Lift spaces and the exact stabilizer

Choose splittings `U=direct-sum u_i`, `Q=direct-sum q_i`, and the given
sequences for `W_i`. They give a standard lift. For any other lift, lift
the chosen `q_i` generators into `V_i` with their prescribed image in
`W_i`; subtract elements of `V_(i-1)` to obtain their chosen projections
in `Q`. This is possible because `V_(i-1) -> Q_(i-1)` is surjective.
Together with the fixed vectors in `U` these generators give an
automorphism fixing `U` pointwise and inducing the identity on `Q`.
It is uniquely a shear

```
T_h(u,q) = (u+h(q),q),       h in H=Hom_R(Q,U).
```

Thus `H` acts transitively on the lift space. Such a shear fixes the flag
and every identified quotient if and only if

```
h(Q_i) is contained in U_(i-1), for every i.                 (1)
```

Necessity follows because the difference between a vector and its shear
must vanish in `V_i/V_(i-1)`; its component lies in
`U intersect V_(i-1)=U_(i-1)`. The same condition proves sufficiency.
After the chosen splittings,

```
K = direct-sum_(k<j) Hom_R(q_j,u_k).                         (2)
```

In particular `H/K` is an affine space with free parameters, not merely a
set-theoretic homogeneous space.

Suppose a coarse quotient is fully identified with a module `W` carrying
an internal flag or decomposition. Restoring that structure through the
identification, then forgetting the coarse identification, is
`H`-equivariant. If the fine exact data are the induced data, both source
and target are the transitive spaces just described. Therefore the map

```
H/K_coarse -> H/K_interval
```

is surjective. A fiber is a torsor under `K_interval/K_coarse`.
One must prove that the *lower gadget* supplies those induced data;
Sections 4 and 5 do that. Mere exactness or a comparison of dimensions
would not be sufficient.

## 4. The complementary swap: arbitrary lower data, not just normal forms

Use the manuscript's notation `a,b,h,x,y`. Keep occurrences of the same
facet distinct. In the affected coarse block, the lower seams give
four actual maps `p_A,p_B,i_A,i_B`. The table and refinements have the
following consequences:

1. In `U_*`, `a,b` are disjoint named direct summands, and
   `U_* / (a direct-sum b)` is the named free `h_U` block.
   The kernels of `p_A,p_B` are respectively `b,a`.
2. The images of `p_A,p_B` are the split named submodules
   `tilde a` and `tilde b`. Their quotients by `a,b` are `h_A,h_B`.
   The kernels of `i_A,i_B` are the named copies of `a,b`.
3. In `Q_*` the common named `h_Q` is a direct summand, and the
   induced `x,y` pieces in `Q_*/h_Q` are complementary, with their
   natural identified maps. This is the interchange of `x,y` on `Q`.

These facts follow from specified free seam quotients and the direct-sum
interchanges on `U,Q`; they are not facts about arbitrary lattice
intersections. In particular the images of `i_A,i_B` are
`h_Q+x` and `h_Q+y`, and their intersection is exactly the named `h_Q`.

The composites `i_A p_A` and `i_B p_B` kill both `a,b` and take values in
`h_Q`. On `h_U` they are the two paths around the punctured `h` disk.
The oriented contact order is `U,B,Q,A`: the path through `B` and the
path through `A` have complementary interiors on that boundary circle.
Their ratio is the monodromy `-I`, or its inverse, also `-I`. Hence

```
i_A p_A + i_B p_B = 0.                                    (3)
```

This equation holds for the actual maps, not only their classes modulo
some unspecified submodule: both composites factor through the named
`h_U` and into the named `h_Q`. Thus there is no missing off-diagonal
error term. In characteristic 2 the same equation is still correct.

Here is a simultaneous normalization that proves all the required
coarse identifications exist. Choose a section
`h_U -> U_*` and use `p_A,p_B` of that section for the `h` summands in
`tilde a,tilde b`. Use `i_A p_A` of that section for the `h` summand in
`Q_*`. Choose sections of `x=A/tilde a` and `y=B/tilde b` into `A,B`;
use their `i_A,i_B` images for the remaining summands of `Q_*`.
Those images are complementary modulo `h_Q`, so give a splitting.
All these choices exist over `R`, because the named quotients are free.
The maps now have precisely the forms

```
U_* = a + b + h,       A = a + h + x,
Q_* = h + x + y,       B = b + h + y,

P(a,b,h) = ((a,h,0),(b,h,0)),
I((a,hA,x),(b,hB,y)) = (hA-hB,x,y).                         (4)
```

Here `+` denotes a labeled direct sum. The two `h` summands are the
actual contact identifications, and (3) explains the minus sign.
All `a,b,x,y` identifications are their existing strip/seam
identifications; none has been replaced by an arbitrary new isomorphism.

Define

```
R((a,hA,x),(b,hB,y)) = (a,b,hB),
S(h,x,y) = ((0,h,x),(0,0,y)).
```

Direct calculation gives

```
IP=0,       RP=id,       IS=id,       PR+SI=id.              (5)
```

Thus the coarse sequence is split exact, with the actual middle term
`A direct-sum B` and its actual decomposition. These identities are
universal module identities. The exact script checks them as typed
block identities with arbitrary block ranks; Lean also proves them for
arbitrary additive commutative groups.

It remains to check the restrictions, which (5) alone does not settle.
Ignore unchanged outside coarse blocks temporarily. Locally
`K_coarse=0`: fixing the full identification with `A direct-sum B`
fixes every vector in that coarse quotient. Incoming `A,B` order has

```
U_first=a,       Q_first=h+x,
```

so (1) forces a stabilizing map to kill `h+x`, and to send the remaining
`y` into `a`. Hence

```
K_in/K_coarse  = Hom_R(y,a).                               (6)
```

Outgoing `B,A` order instead has `U_first=b`, `Q_first=h+y`, whence

```
K_out/K_coarse = Hom_R(x,b).                               (7)
```

With outside blocks restored, choose splittings before and after the
affected coarse block. Every outside matrix block occurs identically
in both stabilizers and cancels in the quotient. Equations (6),(7)
therefore hold for the full flag as well.

Both restrictions are individually affine surjections with free
parameters. **There is no assertion that a pair of independently
prescribed incoming and outgoing lifts has a common preimage.** For
reconstruction only the incoming lift is prescribed.

If `h=0`, the punctured disk disappears and (3) says `0=0`; all
formulas remain valid. Reversing the event interchanges the two
restrictions, with parameters (7) instead of (6); reversing the
punctured disk does not change `(-I)^(-1)=-I`.

## 5. The split and merge: recovering the full internal W flag

For a split `W -> (W'_1,...,W'_s)`, the lower diagram retains

```
0 -> w -> W -> q -> 0
```

and the full internal filtration of `W` with identified quotients
`W'_j`. Its transverse seams refine `w` into `w_j` and `q` into
`q_j`. The two-flag gallery interleaves these into

```
w_1,q_1,...,w_s,q_s.
```

Section 2, applied to this actual gallery, supplies a common splitting
respecting all its labeled quotient maps. In that splitting

```
W = direct-sum_j (w_j + q_j),
w = direct-sum_j w_j,       q = direct-sum_j q_j,
W_internal,j = direct-sum_(l<=j) (w_l + q_l).
```

The merge into `W'_j` preserves the identification with
`W_internal,j/W_internal,j-1` by the split/merge vertex rule. Therefore
the fine exact data are **exactly** the restrictions of the retained
coarse exact sequence and its given internal flag. This proves the
needed assertion for every lower solution; it has not assumed that
the fine sequences alone reconstruct `W`.

The restriction to the coarse interval is the identity on its lift
space. Forgetting the full coarse identification on the fine interval
changes the stabilizer by

```
K_fine/K_coarse = direct-sum_(k<j) Hom_R(q_j,w_k).            (8)
```

Indeed (1) becomes `h(q_j) in direct-sum_(k<j) w_k`.
This is valid for every number of pieces and every block rank.
It is not a pattern extrapolated from small matrices: if `q_j` first
appears at prefix `j`, the strongest condition is precisely prefix
`j`; for every later prefix `t>=j`, `k<j` implies `k<t`.
The checker verifies the corresponding integer inequality identity.

Thus the fine restriction is an affine surjection and the coarse
restriction is an isomorphism. The very same two maps handle a
reverse merge. Traversing coarse-to-fine makes the incoming extension
unique; traversing fine-to-coarse has the free parameters (8).

## 6. The anchor, propagation, and cyclic closure

At the chosen prefix index `k`, the lower rank pattern imposes
`Q_i=0` for `i<=k` and `U_i=U` for `i>=k`. A lift is forced to be

```
V_i = U_i                         (i<=k),
V_i = preimage of Q_i in U+Q       (i>=k).
```

For `i<=k`, the exact identification `W_i=u_i` determines its quotient
map; for `i>k`, `W_i=q_i` does the same. Thus the anchor is a singleton
**including all quotient identifications**. In formula (1), every
condition is vacuous and `K_anchor=H`. This applies to every lower
solution because the zero-rank conditions belong to its diagram.

Both lower disks have the same scalar monodromy at each puncture.
Their direct sum is therefore an allowed disk system, and the
monodromy action on `Hom(Q,U)` is `h -> lambda h lambda^(-1)=h`.
It supplies well-defined parallel transport between interval lift
spaces and, after the last interval, back to the same anchor data.

Starting with the unique anchor, parallel-transport to the next
vertex. Sections 4 and 5 give a surjective restriction from its
coarse lift space to this one specified incoming lift. Choose a
preimage and restrict it to the outgoing interval. Iterate over
the finite ordered list of boundary events. The fibers are exactly
the free modules (6), (7), (8), or zero, according to the incoming
side. Every choice is over `R` if the lower solution is integral.

On returning, transport sends the final state to the anchor lift
space, which has only one element. It must equal the initial state.
All its quotient identifications agree for the same reason.
This is the finite dependent-chain theorem `anchored_closure` in
the Lean source after the geometric hypotheses just proved are
supplied. It does not amount to asserting that arbitrary two-sided
vertex data can be matched.

With no events the same argument applies to the whole seam circle:
the anchor flag and quotient identifications are parallel and
unique. In particular no hidden monodromy equation is left over.

Repeated occurrences of a lower facet do not impose new choices:
they are tagged copies of its already-given fiber and transports.
No reconstruction step changes those transports or any other seam
of that facet. All new choices change only the reconstructed parent
flags and their quotient identifications. Thus coincident facet
names cannot silently identify two summands of a coarse direct sum.

The orientation conventions also survive the construction: original
parent and child boundaries are opposite, the inserted strips join
opposite boundary germs, and the exceptional `h` contact ratio is
unchanged when read in reverse. These statements use occurrences,
so apply to repeated incidences and to cyclic lists.

## 7. Families, coverage, and the integral conclusion

All chosen free splittings exist fiberwise. Over a complex base
with the fixed rank pattern, the relevant kernel, image, and flag
bundles have constant rank and can be split on Zariski open sets.
On such a set the formulas above express every extension fiber as a
matrix vector space of fixed size. Transition functions are affine
because the lift spaces are torsors under the additive `H` and the
restriction maps are the quotients by the displayed block submodules.
The successive construction is consequently a finite tower of
locally affine bundles, open and surjective over the lower solution
variety. Over each individual integral lower solution the splittings
used in the proof exist over the full ring, and every parameter
module is a direct sum of `Hom_R(R^d,R^e)`, hence finite free.

An original complex solution is covered: its scalar puncture
monodromies preserve a chosen proper prefix and a complement; its
intersections select one of the finite rank patterns; its actual
splittings, strip maps, and vertex lifts are among the choices
above. Scalar puncture generators make the original disk local
system isomorphic to `U direct-sum Q`. Allowing the specified frame
changes gives coverage with frames as well. Finiteness of rank
patterns is a bound by the fixed finite ranks, not an arithmetic
assertion about intersections.

Finally `R` is infinite, so `R^d` is Zariski dense in `C^d`: a
polynomial vanishing on that product is zero by induction on the
number of variables. Apply this successively up the affine tower.
If frames are included, the manuscript's elementary argument also
applies: the unit `1+sqrt(2)` has infinite order, integral elementary
unipotents are dense, and together with the dense unit torus they
give dense integral general-linear frame changes. This proves the
stated integral-fiber density without localizing `R`.

The local algebra also extends to finite projective named blocks:
all the sequences split and the parameter modules are finite
projective. They need not be free or globally affine coordinate
spaces in that extension. This observation is not used to weaken
the manuscript's freeness requirement.

## 8. What the executable and compiler certify

`verify.py` also checks the normalization of generic lower data, not
only (5). In arbitrary initially chosen free splittings write the
two injections with arbitrary `h -> a,b` shears `cA,cB` and
invertible contact maps `PA,PB`; write the projections with
arbitrary `x,y -> h_Q` shears `dA,dB` and contact maps `IA,IB`.
The punctured disk forces `IB=-IA PA PB^(-1)`. These are all the
possible off-diagonal entries allowed by the actual lower flags.
The checker constructs invertible normalizations with

```
N_A = [[1,cA,0],[0,PA,0],[0,0,1]],
N_B = [[1,cB,0],[0,PB,0],[0,0,1]],
N_Q = [[IA PA,dA,dB],[0,1,0],[0,0,1]].
```

It verifies both inverse identities and the commuting injection
and projection squares, using noncommutative polynomial arithmetic
and adjacent inverse cancellation only. In particular `N_A+N_B`
is block diagonal on the actual `A direct-sum B`, and the four
outside graded identifications are unchanged. This certifies the
absence of a hidden off-diagonal error in (3) and the compatibility
of the normalization with the decomposed coarse middle term.

The script further replays typed universal block identities (5), the two
different swap stabilizer masks, the arbitrary-length split
stabilizer formula, and the additive shear identities. It also
replays the exact rational Jacobian output. That one bounded
Jacobian operation solves the coefficient system selecting a
chain contraction of the shared `h` blocks; its answer
`(r_A,r_B,s_A,s_B)=(0,1,1,0)` is integral. It is not being used as
a finite-rank proof or as a test of the geometry.

The Lean source proves the contraction and exactness for arbitrary
additive commutative groups and finite dependent propagation for
every natural length. `statement_fidelity.md` explicitly separates
these encoded statements from the geometric normalization,
restriction formulas, and transport hypotheses proved above.
The compiler evidence must have exit code zero, no proof holes,
and matching source and fidelity digests. Only its corresponding
algebraic-core ledger claim can acquire compiler-earned status.

The actual Lean 4.31.0 run has exit code zero, proof holes `[]`,
and axiom-audit exit code zero. The exact replay passes its four
typed contraction identities, seven generic-normalization identities,
six support checks, three shear/order schemas, one bounded Jacobian
replay, and nine named formal declarations. Four separate in-memory
mutations were rejected: the wrong sign, an identity between
different module types, an incorrect incoming fiber, and a
nonzero coarse stabilizer. These are negative controls, not
counterexamples to assertions made in the manuscript.

The remaining certification step is an independent reader's check
of this report against the literal lower gadgets and a replay of
the executable and official campaign-local checks. An Engineer
opinion is not that review. The evidence does not establish
novelty or authorize termination of the wider publishable campaign.
