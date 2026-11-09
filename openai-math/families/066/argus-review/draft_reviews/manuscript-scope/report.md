# Main-theorem obligations and the administrative audit goal

**Assessment:** the old work does not prove or refute either
manuscript main theorem. It develops a local rational lc-slice
bridge and explicitly leaves the remaining geometric chains
unaudited. “Open” below means open in that audit, not a claim
that a proposition is an open problem in the literature.

## Exact main-theorem statements and source versions

All four mathematical records here have one historical version in
`CTX9000066` v1. The source introductions and the two local sections
match revision `4eaee87548250b2682affda7d05d947c05554bae`, as
measured against `MANUSCRIPTS.json`; their hashes are in the index.

`C_COMP_MAIN` refers to complements `thm:main`. For every positive
integer `d` and positive **rational** `epsilon`, one positive
integer `N(d,epsilon)` is asserted to work for every projective
surjective morphism of normal integral varieties over an
algebraically closed characteristic-zero field with

```
f_*O_X=O_Z, dim X=d, K_X Q-Cartier,
X epsilon-lc, and -K_X ample over Z.
```

For each closed `z in Z`, an effective rational `B` and open
neighbourhood `U` are asserted with `(X,B)` klt over `U` and
`N*(K_X+B)` integral Cartier and **linearly trivial** over `U`.
Numerical triviality or an index depending on the individual
germ would not suffice.

`C_CART_MAIN` refers to Cartier `thm:main`. For each integer `d>0`
and **real** `epsilon>0`, one `tau(d,epsilon)>0` is asserted for
every epsilon-lc effective rational pair `(X,B)` of dimension `d`
with `K_X+B` Q-Cartier, and every Fano type contraction of normal
integral quasi-projective varieties, with `dim Z>0` and
`-(K_X+B)` nef over `Z`. Here Fano type has its own effective
rational klt witness, not necessarily `B`. For each closed base
point there should be an open `U` and a nonzero effective
Cartier divisor `D` through that point such that

```
(f^(-1)(U), B|_(f^(-1)(U)) + tau*f^*D) is lc.
```

The conclusion controls the whole inverse image of a
neighbourhood, not just a generic point of one base divisor.
These are manuscript assertions attributed to their authors,
not original claims established by the Argus draft.

## What the old draft actually supplies

`C_COMP_EXACT` verifies one fixed-germ constrained-minimizer
proposition; `C_CART_EXACT` verifies the rational realization
part of one local theorem. Their thresholds and constants may
depend on the germ, resolution, ideals and equations. The
strongest old evidence also includes prior independent
human support for the geometric bridge and its component
claims, not merely a scalar compilation.

That is meaningful local evidence, but it does not produce
`N(d,epsilon)` or `tau(d,epsilon)` over arbitrary contractions.
The archived scalar certificate expressly limits itself to
universal algebra and an abstract conditional minimizer
reduction. `exact_certificate.json` says
`final_geometric_theorems=remain_open`. No proof of the missing
global implications is contained in the 16-artifact inventory.

## Concrete outstanding obligations

`L_COMP_OTHER_GEOMETRY` v1 records that the remaining
complements dependencies must be established independently.
In particular, the audit does not verify the reduction and
field-descent chain, simultaneous specialization and
degeneration compatibility, or the rank-growth and trace
survival/lifting arguments that convert fixed local
finite-generation data into a uniform complement index.
The logical gap is the passage from a minimizer on one
germ to a dimension/discrepancy-uniform Cartier trivialization;
the local bridge does not imply it.

`L_CART_OTHER_GEOMETRY` v1 similarly records unverified
central-slice transfer, discrepancy-chart, character and
pinning arguments. Exact realization on the original germ
does not alone prove lc of the central `h`-boundary, positivity
and minimization for its central height, or the later
character/pinning contradiction needed to construct a
uniform-threshold base equation for the entire fibre.
The subsequent reduction from that birational/local statement
to the final Cartier assertion is also outside the old proof.

These are specific missing chains in the **audit**. They are
not allegations that the manuscripts omit them, nor results
disproved by a failed Argus route. This task does not expand
into independently proving or searching for errors in them.

## Evidence reconciliation, exclusions and novelty

The old graph labels all 15 nodes `open` and
`reviewer_confirmed:false`. For the local bridge and
applications there are applicable version-bound supporting
judgments, so those graph flags must not be used to call
all local work unresolved. For the main theorems and their
remaining-geometry nodes there is no corresponding
supporting proof/judgment in the old ledger; their audit-open
scope is consistent with the proof note.

`C9000066` v1 is explicitly mapped here but excluded as a
mathematical draft theorem: its text is the old administrative
mission to audit/refute/verify the family and obtain a
certificate. It is not a proof, hypothesis or current
instruction. The two empty lock files are likewise excluded
as mathematical content, while still counted in artifact
coverage. The manuscript source tree is reference input,
not an additional Argus-authored draft to certify.

The original main claims' novelty is not checked by this
review, and their literature-open status is not decided.
The “other geometry remains unaudited” statements are
supported scope descriptions, not new mathematical results.
No new error search, whole-manuscript validation or
publication-level theorem is substituted for the requested
old-draft review. Native independent review of the full
coverage and all substantive assessments is still required.
