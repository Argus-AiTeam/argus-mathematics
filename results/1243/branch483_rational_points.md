# Rational points and the complete branch-483 residual boundary

**Engineer theorem; independent Reviewer replay and novelty assessment
pending.** This is an unbounded rational-point classification, not a
finite-search miss and not a nonexistence theorem for all 3-by-3 magic
squares of distinct squares.

## Explicit curves

Write `[c0,...,cn]` for the polynomial `sum_i ci*x^i`. Set

```text
f = [7,-14,15,-108,-87,2,1],
h22 = [38983,-341142,540575,3476884,-11391467,-11069134,
     65554221,17235568,-189164682,-47044812,304712166,145554552,
     -241510758,-194242092,48847050,81082736,9944499,-9509150,
     -2374421,53780,16865,1914,409],
h8a = [29,72,-124,-584,-66,1048,868,168,13],
h8b = [89,-480,428,832,-306,-224,124,0,1],
h10 = [61,-400,513,1408,-2526,-2208,3138,2048,-15,-80,13],
h14a = [-433,2070,2875,-21932,32167,24698,-129157,-89512,
     75829,78890,11849,-4076,-811,6,1],
h14b = [97,354,-7411,15836,30713,-88658,-53699,161224,
     70139,-99554,-54161,3740,5035,18,71],
G1 = f*h22,
G2 = (x^2+1)*h8a*h8b*h10,
G3 = -h14a*h14b.
```

These are exactly the three degree-28 residuals of the degree-14
power-two C_TYV parameterization in
`research/r2-category3-k3-second-iterate-factor-descent/factor-data.json`.
The source checks all three K3 equations. Its factors are squarefree,
irreducible, and pairwise coprime; in particular no omitted rational
zero-factor stratum exists.

Let H be the smooth projective curve `s^2=G1(x)`, of genus 13. Let X be
the smooth projective normalization of

```text
y1^2=G1(x),    y2^2=G2(x),    y3^2=G3(x).
```

The three independent squareclasses give a connected degree-eight cover
of P^1 with 84 distinct branch points; Riemann--Hurwitz gives genus
`1-8+2*84=161`. At infinity use `t=1/x` and `Yi=t^14*yi`.

## Theorem

```text
H(Q) = {(-1,896),(-1,-896)}.

X(Q) = {(-1,e1*896,e2*1664,e3*2176) :
         e1,e2,e3 independently in {1,-1}}.
```

In particular there are exactly eight rational points on X, all affine.
Every one maps to the collision divisor of the magic-square
parameterization.

The genus-two input is the following complete classification, on smooth
projective models of `C_d: y^2=d*f(x)`:

| d | C_d(Q) |
|---:|:---|
| -14 | `(-17/3,+/-22148/27)` |
| -7 | `(5/16,+/-1841/4096)` |
| -2,-1,2 | empty |
| 1 | the two points at infinity |
| 7 | `(0,+/-7)` |
| 14 | `(-1,+/-28)` |

## Proof

For a primitive integer pair (p,q), the homogeneous resultant lemma shows
that a rational square G1 forces the squareclass of the first factor f
to be supported on `{-1,2,3,7}`. The complete primitive-projective test
modulo 2^8 leaves exactly

```text
D = {-14,-7,-2,-1,1,2,7,14}.
```

The exact sixteen-assignment enumeration and both projective charts are
recorded in `twist-local-filter.json`, first group. There are no rational
zeros of either f or h22, so this reduction loses no zero-value case.
For affine x, `f(x)=d*a^2` is equivalent to a point `(x,+/-d*a)` on
C_d, since d is squarefree.

The previously constructed complete local images exclude d=-2,-1,2.
For the four nonunit surviving twists, the complete height enumerations,
finite saturation witnesses, Mordell--Weil sieves, and unit Coleman
annihilators prove exactly the four affine pairs in the table; their
sources and exact records are in the parent directory's
`rank_one_saturation_*.json` and `rank_one_chabauty_*.json`.

For d=1 the formerly missing global input is now unconditional.
`global_squareclass_completeness.md` and its GP sources prove the complete
twelve-dimensional norm-square kernel, with exact archived-basis and norm
bindings. The reviewed local images give Selmer dimension three, and the
reviewed nonzero Cassels--Tate pairing leaves rank one. The new exact
finite-field witnesses and `p23_closure_lemma.md` put all global points
in the p=23 closure covered by the complete analytic disk proof.
The only rational-base elliptic points are 0 and P, and their projective
inverse lifts are exactly the two infinities of C_1. This uses all four
completions, including the cubic one, and does not assume E(k)=ZQ.

Consequently every affine rational square G1 occurs among the four affine
x-values in the table. The prior exact residual identities give:

| x | G1 square? | G2 square? | G3 square? |
|:---|:---:|:---:|:---:|
| -17/3 | no | no | no |
| 5/16 | no | no | no |
| 0 | no | no | no |
| -1 | yes | yes | yes |

At x=-1 the exact residual values are

```text
(G1,G2,G3) = (802816,2768896,4734976)
            = (896^2,1664^2,2176^2).
```

At projective infinity they are `(409,169,-71)`; already 409 is not a
rational square, and -71 is negative. Thus neither H nor X has a rational
point there. Since the affine factors have no rational roots, no rational
point of the smooth normalization above a branch or singular fiber has
been omitted. The fiber at x=-1 is unramified and all eight independent
sign choices are distinct. This proves both asserted complete point sets.

For completeness, x=-1 gives the source's ordered K3 coordinate tuple

```text
(0,1664,-1536,640,-640,-1536).
```

Its Lucas entries, irrespective of the auxiliary residual-root signs, are

```text
2768896  4734976   802816
 802816  2768896  4734976
4734976   802816  2768896
```

There are only three distinct entries, and the collision factor a
vanishes. Infinity is additionally on the collision factor a+b.
Thus every affine and projective inverse lift, and all three residual
square conditions and all signs, have been accounted for. No qualifying
candidate survives, so the authoritative strict witness checker is not
invoked and no nine-distinct-square certificate is claimed.

## What changed, and what is not claimed

Previously the strongest result supplied an exact degree-eighteen field
isomorphism and conditional global completeness and d=1 point bounds.
The new contribution removes that global condition through relative
class parity and independently complete squareclasses, binds the original
generators exactly, and discharges the necessary p=23 saturation
conditions by finite good-reduction witnesses. The rank, rational-point
classification, and the entire residual boundary above are therefore
unconditional mathematical consequences of the displayed certificates.

The optional direct all-prime saturation attempt reached no height bound
within its configured 1200 seconds. That is a runtime non-conclusion,
not evidence that Q fails to generate. The successful closure proof
avoids that unneeded stronger statement; it certifies no primes outside
`{2,3,7,19,23,37,41}`. No full integral degree-eighteen class/unit group or
degree-thirty-six v6 certificate is asserted.

All new theorems remain subject to Host-invoked independent Reviewer
replay, primary-source citation attribution, and an independent novelty
and significance assessment. The negative exact-polynomial web lookup
does not verify novelty. The classification is for this explicitly
displayed branch, not for other K3 pencils or the general magic-square
problem.
