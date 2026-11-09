# Uniform anchored return patterns

This work concerns only `count:local` and its use in the longer-period
branch of `dichotomy:main`, in the September 23, 2026 staged manuscript.
It does not certify the final van der Waerden bound.

## Scope and known ingredients

The source directory is
`research/openai_manuscript/Quantitative-Superexponential-Bounds-for-van-der-Waerden-Numbers-September-23-2026/build/sections/`.
The exact objects are the literal half-open interval labels in
`02-setup.tex`, not interval indices up to translation. A point at
`rho = eta` retains its interval label. Stationarity refers to the
rational step, not to vanishing drift.

The classical ingredient is the region bound for affine hyperplane
arrangements. The manuscript cites Stanley, *An introduction to hyperplane
arrangements* (2007), Lemma 2.1 and Proposition 2.4, for strict regions.
Those results do not by themselves count equality faces. The proof below
will count all planar faces directly, without using that citation as an
undischarged assumption. The primary-source chapter has been obtained as
`stanley2007.pdf`; `stanley2007.txt` is its text extraction.

The remaining ingredients will be proved from the displayed definitions:
the adaptive mesh width inequalities, neighborhood comparability, truncated
breakpoint count, closest-return affinity, residue separation, and drift
relative to every heavy interval. No prime-distribution result is needed
for this core, beyond taking an integer `q >= 2` when defining the mesh.

The inherited project Wiki has no matching result on this core. No claim
of literature novelty is made by this source lookup.

## Verification theorem

Let `D,h >= 1`, let `0 < H <= 1/8`, and let `U` be a uniform
circle partition of width `Hx <= H`. Let `V` be any finite half-open
circle partition satisfying, at **every point of every interval closure**,

```
H (rho(Y)+alpha)/4 <= |I| <= 2H (rho(Y)+alpha) <= 2H.       (W)
```

Here `alpha > 0`, `rho` is distance to one fixed cut, and
`eta = 1/(1000D)`. In particular `rho` is globally 1-Lipschitz,
including across the representative cut. Take any integer dilation lambda.
Use the paths, rational stationary/rotating classification, and recorded
regular/dummy word of `count:eligible`.

**A. Anchored entropy.** For every literal full label beta, the number
of pairs `(t, word)` containing beta, with the following restrictions
at some regular occurrence of beta, is at most

```
h^(D+1) [2(16004 D h)^2+1]^(2D) <= (801 D h)^(6D):          (A)
```

the first drifts satisfy `|u_i| <= Hx`, the rotating second drifts
satisfy `|v_i| <= H`, and each stationary second drift is at most the
width of its **anchor** interval. No minimum number of regular positions,
pairwise distinctness condition, or stationary bound at other positions
is needed for this stronger anchored-word count. Therefore (A) proves
`count:local` with the explicit absolute constant **C = 801**.
There is no restriction on q or lambda and no positive lower bound on
the anchor width. In fact (A) holds for every positive h, not just
`D^2 < h <= 2M`.

**B. Heavy-block applicability.** In the staged setup, the longer-period
branch has the following explicit sufficient threshold:
**every integer k >= 2^20**. For a closest-return period
`D^2 < h <= 2M`, every full length-h block meeting any heavy label
is eligible. This includes a heavy position which is not regular, a
stationary coordinate with nonzero drift, exact cut hits, and crossings
of either orientation. This threshold certifies this core only; it is
not a threshold for the outer coloring or the manuscript's main theorem.

The applicability proof works more generally for arbitrary linked torus
progressions `y = lambda*x` and meshes satisfying (W), under the explicit
parameter conditions

```
H = k^(-2), Hx = H/lambda, lambda a positive integer,
k >= 64M, D >= 3, 4000 D M < k^3,
```

and the dilation gap `s_i = 1 or s_i > D^2` for `h <= 2M`.
It does not use a prime-power cyclic ambient group, a lower bound for q,
or a prime-distribution theorem.

**C. Stronger stationary transfer.** In any metric space, suppose
`r` is 1-Lipschitz, the widths at x and y satisfy
`w(x) <= 2H r(x)` and `w(y) >= H r(y)/4`, and `H >= 0`.
Then

```
w(y) >= w(x)/8 - H dist(x,y)/4.                            (T)
```

Consequently, a stationary displacement bounded by a nonnegative drift
delta is eligible at y whenever

```
dist(x,y) <= delta,       (8+2H) delta <= w(x).              (S)
```

For `H <= 1/8`, it suffices that `delta <= (4/33) w(x)`.
This improves the manuscript's sufficient relative-drift constant
`1/16` without any assumption that x is regular. It is an implication
proved from width and Lipschitz inequalities, not an assumption of
neighbor comparability or of the desired eligibility.

The factor `1/(8+2H)` is sharp for these pointwise inequalities:
normalize `w(x)=1`, take `r(x)=1/(2H)`,
`dist(x,y)=delta`, `r(y)=r(x)-delta`, and
`w(y)=H r(y)/4`. Then `w(y) >= delta` holds exactly when
`(8+2H)delta <= 1`. These data can be taken with positive radii.
This is **not** an optimality claim for full interval meshes, whose
closure-wise conditions contain additional information.

These are verification and structural-generalization theorems, not a
refutation. No false staged assertion has been established.

## 1. Mesh facts, including boundary values

For the staged exponential mesh, put `theta = R/m` and
`b = alpha exp(ell*theta)`. Because `alpha <= 1/4`,
`R = log(1+1/(2alpha)) >= log 3 > 1`. For `H=k^(-2)`,

```
R/H <= m <= R/H+1 <= 2R/H,       H/2 <= theta <= H.
```

On either interval with index ell, including its closure,
`rho+alpha` ranges from b to `b exp(theta)`, and its width is
`b(exp(theta)-1)`. Thus the width divided by `rho+alpha` lies
between `1-exp(-theta)` and `exp(theta)-1`. For
`0 <= theta <= 1/8`, these lie between `theta/2` and `2theta`.
For example, `exp(theta) >= 1+theta` gives the lower bound,
and comparison of the exponential series with the geometric series
gives `exp(theta) <= 1/(1-theta)` and the upper bound.
This proves (W); also `rho+alpha <= 3/4`, so the last bound in
(W) follows. No assertion about which half-open side owns an endpoint
is used in these inequalities.

To prove (T), multiply `r(x)-r(y) <= dist(x,y)` by `H/4`,
then use the upper bound at x and the lower bound at y.
If `w=|I|` and y lies in the closed circular w-neighborhood of I,
its distance from any fixed x in the closure of I is at most `2w`.
Hence

```
|J| >= (1-4H)w/8 >= w/16
```

for every J whose closure meets that neighborhood, by applying (T)
at a point of the intersection. The neighborhood is an arc of length
`3w <= 6H < 1`. Consecutive endpoints in that arc enclose a
whole interval of width at least `w/16`. If there are b endpoints,
`(b-1)w/16 <= 3w`, so `b <= 49`. Closures make the argument valid
at both ends of the arc, at the representative cut, and for coincident
neighborhood and mesh endpoints.

On an arc of length at most `4H < 1`, the portion with
`rho >= eta` has at most two connected components. Consecutive
mesh endpoints within either component are separated by at least
`H eta/4`, by (W) at an endpoint of their intervening interval.
The total number of these endpoints is at most

```
4H/(H eta/4)+2 = 16/eta+2.
```

Adding the two possible threshold points gives
`16/eta+4 = 16000D+4 <= 16004D` breakpoints. Inside
`rho < eta` the output is constant. At a threshold use the
actual half-open interval label, since the definition uses `>=`.
If a threshold coincides with a mesh endpoint, it is only one
breakpoint, with its explicitly prescribed value. A value at a
breakpoint need not equal either adjacent open-arc value.

## 2. Equality-aware planar counting

For s affine functions on the plane, discard constant functions and
coincident underlying zero lines; their signs are fixed or determined
by the remaining signs, so this cannot increase the number of cells.
There are now at most s distinct proper lines.

There are at most `s(s-1)/2` intersection vertices. Each line is
cut by the others into at most s open one-dimensional pieces, giving
at most `s^2` one-dimensional faces. Adding the j-th line creates
at most j new two-dimensional regions: its intersections with previous
lines cut it into at most j pieces, and each piece can split at most
one old convex region. Thus the number of two-dimensional regions is
at most `1+s(s+1)/2`. Summing the three bounds gives

```
s(s-1)/2 + s^2 + 1+s(s+1)/2 = 2s^2+1.                     (P)
```

Every realized joint sign vector corresponds to exactly one such face:
its sign set is a convex intersection of strict affine halfspaces
and affine hyperplanes and is relatively open in its affine span.
Parallel lines, repeated intersections, and lower-dimensional zero
sets only reduce the count. The empty arrangement has one sign vector.
Restricting the parameter set can remove sign vectors but cannot
create new ones. In particular (P) counts zero signs and singleton
faces, not just strict chambers.

Equivalently, insertion gives the all-face recurrence
`F(s+1) <= F(s)+2(2s+1)` and `F(0)=1`: only an old
relatively open face crossed by the new line splits into three, and
its intersection with that line has a distinct induced sign vector.
A face contained in the line does not split. The induced one-dimensional
arrangement has at most `2s+1` sign faces. The formal source solves
this recurrence exactly. The preceding direct face proof independently
establishes its geometric interpretation.

This discharges the classical strict-region assumption recorded during
scope. Stanley's Lemma 2.1 is indeed a real-arrangement region recurrence;
Proposition 2.4 is explicitly for general position. Neither is silently
being used as an equality-face formula or with missing hypotheses.

## 3. Anchored word count

Fix t and a regular anchor position `z0` recording beta.
For each coordinate let a lie in the closed interval of beta and
let b be the drift. With `c=(z-z0)/h`, every target has a lift

```
a + tau_z + c*b,        |c| < 1,
```

where tau is fixed, however large lambda is. The formal range lemma
puts this expression in a **fixed** closed real interval of length
at most `width(anchor)+2 radius(drift)`.

For U, that length is at most `3Hx`; at most four points of
the Hx-spaced endpoint lattice lie in it.
For a stationary V coordinate, its rational translations are integers.
The range modulo one lies in the anchor's closed width-neighborhood,
so at most 49 endpoints are relevant, and the real range has length
at most `3|I| < 1`.
For a rotating V coordinate, the range has length at most `4H < 1`,
so at most `16004D` truncated breakpoints are relevant.

A fixed circle endpoint has at most one real lift in each of these
short real intervals. This is precisely where a naive use of all
endpoints between zero and a large tau would lose uniformity.
For each target, compare its affine expression only with the
breakpoint lifts inside its fixed range. The list is chosen before
a and b vary. Zero signs determine the prescribed breakpoint outputs;
other signs determine the open-interval outputs.

Across all h targets there are at most `16004Dh` affine comparisons
per scalar coordinate. By (P) the number of scalar output words is at
most `2(16004Dh)^2+1`.
Take their product over the `2D` scalar coordinates, allowing their
parameters to vary independently; this only enlarges the family.
For each position, the rotating scalar outputs determine whether it
is dummy. If none is dummy, the untruncated scalar outputs determine
its literal full label. There is **no extra regular-mask factor**.
This also applies when no coordinate rotates: every position is regular.

Finally multiply by `h^D` choices of t and at most h anchors.
Since `D,h >= 1`,

```
2*16004^2+1 = 512256033 < 801^3 = 513922401,
h^(D+1) <= (Dh)^(2D).
```

These inequalities give (A), as also proved by the formal source.
The argument did not use any stationary drift restriction away from
the anchor, nor regular-label distinctness. It therefore includes
every eligible word in the manuscript.

## 4. Return certificates from a heavy label

Here `H=k^(-2)`, `Hx=H/lambda`, `k >= 64M`, and `D >= 3`.
Let a heavy label have m visits, so `m > k/M`.
Then `m-1 >= k/(2M)`. Let h be its smallest positive index gap.
The total span of the visits is at most `k-1`, so `h <= 2M`.

All representative coordinates of these visits lie in one half-open
box, with coordinate widths at most `2H`. For three visit indices
`j1 < j2 < j3`, the vector

```
(j3-j2)(Z_j2-Z_j1) - (j2-j1)(Z_j3-Z_j2)
```

is integral, by affinity on the torus. Its coordinate absolute values
are at most `2H(j3-j1) < 2kH < 1`, so it is zero.
Thus the representatives on the entire visit set are affine in the
index, including empty or small sets in the general box lemma.
Comparing a closest gap with the two extreme visits gives

```
|u_i| <= Hx/(m-1) <= 2M Hx/k,
|v_i| <= 2H/(m-1) <= 4M H/k.                               (R)
```

The torus relation `y=lambda*x` makes `v-lambda*u` integral.
Its coordinate absolute values are at most `6MH/k < 1`, so
`v=lambda*u` as a real vector, not just modulo one.

Choose `t_i` in `{0,...,h-1}` by reducing
`h*xhat_i(d)-u_i` modulo h. The entire progression then has the
rational paths displayed in `dichotomy:path-equations`.
If an integer `e>1` divided h and all coordinates of t, the sample
at the fractional gap `h/e` from the chosen return would have
representatives exactly the convex combination with coefficient `1/e`
of the two returning representatives. A product of half-open intervals
is convex. This sample would therefore return to the same full label
at a smaller positive gap, a contradiction. Hence
`gcd(t_1,...,t_D,h)=1`.

For incongruent indices modulo h, primitivity gives a coordinate whose
rational displacement has circle distance at least `1/h` from zero.
By (R) the first-system drift changes that distance by at most
`2M Hx/h`. The remaining distance is at least

```
(1-2MH)/h >= (1-2MH)/(2M) > H >= Hx,
```

because `4MH<1`. Therefore those indices cannot share even their
U-label tuple. In particular all h labels in a full block are distinct.

Now take **any** heavy label, with m' visits and coordinate interval
width L, not necessarily the label used to select h.
All its visits have the same residue modulo h. Write its extreme
index difference as `a*h`, with `a >= m'-1` and `a < k/h`.
Its centered representative difference Delta satisfies `|Delta| <= L`
and is congruent to `a*v_i`. Moreover

```
|Delta-a*v_i| <= 2H+4MH/h < 1.
```

Thus `Delta=a*v_i` exactly. It follows that

```
|v_i| <= L/(m'-1) <= (2M/k)L.                              (HW)
```

This proof unwraps **only the two endpoint representatives**; it does
not assume that the path between them avoids a cut. It also never
assumes that a heavy index is regular.

## 5. All eligibility conditions

For `h <= 2M`, the definition of lambda contains the full prime-power
part of h at every prime at most `D^2`. Those factors divide
`gcd(h,lambda*t_i)`. Every remaining prime factor of
`s_i=h/gcd(h,lambda*t_i)` therefore exceeds `D^2`.
Thus `s_i=1` or `s_i>D^2`, including `t_i=0`.

For a rotating coordinate, the no-drift positions in a full block run
through an s_i-point circle grid, each point repeated `h/s_i` times.
Actual positions are within `|v_i| <= 4MH/k < eta` of their
grid points, by `4000DM<k^3`.
An actual point with `rho<eta` has its grid point in the closed
arc of radius `2eta` about the cut.

For completeness, lift that closed arc, whose length `4eta<1`,
to a real interval. List its distinct grid points in increasing order.
The distance between successive lifts is at least `1/s_i`, since
their differences are nonzero integral multiples of that spacing.
If there are b points, `(b-1)/s_i <= 4eta`, including endpoints.
Thus `b <= 4eta*s_i+1`. The empty list is harmless.
This is the closed-spacing statement certified in Lean; the argument
does not replace a closed arc by an open one to remove an endpoint.

The fraction excluded by coordinate i is at most `4eta+1/s_i`.
A union bound, even if several cuts are hit at the same position, gives

```
nonregular fraction <= D(4eta+1/D^2)
                    = 1/250+1/D < 1/2
```

for `D>=3`. If no coordinate rotates, the excluded set is empty.
This proves the regular-count part of condition (i); residue separation
proves its pairwise-distinctness part.
The bounds (R) and `k>=64M` imply `|u_i|<=Hx` and
`|v_i|<=H`, proving condition (ii).

Suppose the full block meets a heavy position j*. For a stationary
coordinate its rational step is integral, so, at **every** block
position j,

```
dist_T(y_i(n_j),y_i(n_j*)) <= |j-j*| |v_i|/h <= |v_i|.
```

Put `L=|V(y_i(n_j*))|`. By (HW),
`|v_i| <= mu*L`, where `mu=2M/k <= 1/32`.
In particular `mu <= 4/33`, so (S) proves
`|v_i| <= |V(y_i(n_j))|`. This is condition (iii), at all
positions and hence at every regular one. Alternatively the manuscript's
neighborhood proof uses `mu<=1/16` and `|J|>=L/16`; both follow
from the same established hypotheses. Stationary nonzero drifts,
an irregular j*, and all half-open cut cases have been retained.
No coloring hypothesis was used to establish eligibility.

## 6. Explicit setup threshold

For integer `k >= 2^20`, write `a=k^(1/10)` and `b=sqrt(k)`.
The elementary ceiling bounds give

```
4 <= D <= 2a <= 2b,       b <= M <= 2b.
```

Hence `64M <= 128b <= k` (indeed `b>=1024`), and
`4000DM <= 16000k < k^3`. Also

```
D^2 <= 4k^(1/5) < 2sqrt(k) <= 2M < k,
```

because `k^(3/10)>=64`.
All the small inequalities used above follow already from
`k>=64M`, `k>=64`, and `H=k^(-2)`:
`2kH<1`, `4MH<1`, `6MH/k<1`, and
`2H+4MH<1`. The first mesh is exact since
`Hx^(-1)=k^2 lambda` is an integer.
For any integer `q>=2`, `alpha=q^(-(D+1))<=1/4`, so
Section 1 verifies the staged mesh assumptions. No upper estimate for
the number of mesh intervals or for q is needed.

This proves the asserted explicit threshold for B and completes the
ordinary mathematical proof of A--C.

## 7. What the certificates do and do not establish

`Main.lean` proves the universal range/lift, width-transfer,
stationary-budget, closed-spacing and entropy-arithmetic implications
listed in `statement_fidelity.md`. Its natural-language claim is
`C160_FORMAL_CORE`, deliberately separate from the entire counting or
eligibility theorem. The metric transfer lemma and the arbitrary-shift
range/lift lemmas discharge the two uniformity issues singled out in
the mission; they are not comparator definitions.

`verify.py` independently replays the source-bound rational LP primal
and dual witnesses, checks the exact constants, and exercises rational
boundary configurations, including a full block with an **irregular**
heavy cut hit and stationary cut crossings in both directions. Its finite
experiments are regression checks, not the proof of the parameter-uniform
theorem. The universal claims are established by the proofs above, with
the stated parts additionally certified by the real Lean compiler.
The verifier also checks that the compiler evidence still matches the
Lean source and its fidelity document.

From the campaign root, replay with
`python3 research/verification/verify.py`. This needs only Python's
standard library and the supplied certificates. Add `--compile` to
rerun the recorded real compiler as well. A Reviewer recording a new
mechanical run should instead use the official command:

```
$WORKSPACE/argus-live-update/.venv/bin/python -m argus_skill.verticals.math.lean_evidence verify research/verification/Main.lean --statement-fidelity research/verification/statement_fidelity.md --claim C160_FORMAL_CORE --project-root .
```

Compiler timing metadata may change on replay; the verifier binds the
mathematical result to the unchanged source and fidelity, not to an
identical elapsed time.

Jacobian discovery returned a generic **central strict-chamber** formula,
which does not match affine equality counting; it was not used for (P).
The matching general rational LP operation was inspected and executed.
Its first all-free-variable representation was refused at admission
because its private normalization exceeded the simplex-basis budget.
That is preserved as an adapter error, not a mathematical conclusion.
The second representation adds mathematically implied nonnegative
bounds and returns an exact optimum `1/16` with primal point
`(1/2,1/4,1/16)` and row multipliers `(1/4,1/4,1)`.
Their weighted rows give the objective bound exactly. The operation id,
server version, protocol, payloads, outputs and refusal are retained in
the dedicated `jacobian_*.json` files.

No staged source was changed. No `F_` assertion is registered because
no false manuscript assertion was found in this scoped work. Engineer
support is not independent Reviewer acceptance. The independent Reviewer
must replay the certificate, inspect the geometric interpretation and
statement fidelity, and issue its own verdict. Significance and novelty
are not self-certified here; the full main theorem, the outer local-lemma
argument, the short-period branch, the perturbation, and the digit product
remain unverified by this mission.
