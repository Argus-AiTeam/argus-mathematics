# A quantitative fixed-compact-set energy-to-crossing theorem

This is an independent verification and arbitrary-width extension of Sections
3-5 of the staged September 25, 2026 manuscript, not a counterexample and not
a claim to have audited its doubling construction or Banach-space transfer.
The analytic proof below is complete in ordinary real analysis. The separate
Lean theorem certifies its explicitly described moment/line interface; it
does not claim to formalize the construction or the analytic instantiation.
Novelty or publishability has not been independently established.

## The theorem

Fix D>0, a positive integer N, a Euclidean target, and one nonempty compact
K contained in [0,D^2]^2. Put A=max first coordinate of K and
B=max second coordinate on its A fiber. These quantities are fixed,
not recomputed for the rectangles below.

Consider any rectangle Q tiled by finitely many complete N-color blocks
of width NWr and height Nr, where W,r>0. Each block contains one open
horizontal row of each color, of height r, and one open vertical column
of each color, of width Wr. Let F be D-Lipschitz on a neighborhood of Q,
and F_i be D-Lipschitz on the union of the color-i rows and columns in that
neighborhood. The horizontal and vertical restrictions of a given color
must be the same F_i. Require ||F_i-F||<=Dr on that union.

Let u,v be reference vectors with norms at most D. For nonnegative
a,b,e, assume

    0 <= A-||u||^2 <= a,       |B-||v||^2| <= b,
    average_Q (||F_x-u||^2+||F_y-v||^2) <= e^2.

Let H_x be the horizontal-color-selected derivative, and V_x,V_y the
vertical-color-selected derivatives. Assume almost everywhere

    ||H_x||^2 <= A,       (||V_x||^2,||V_y||^2) in K.

All derivatives are measurable and their line restrictions obey the
fundamental theorem on almost every line; this holds for the stated
finite-dimensional Lipschitz maps. Set rho_x=r/L_x, rho_y=r/L_y, and

    X = 2a+4De+8D^2 rho_x+2e^2,
    T = a+2De+4D^2/W,
    Y = 2b+8D^2 rho_y+4De+2e^2.

**Finite-parameter conclusion.** Write

    E_H = average_Q ||H_x-F_x||^2,
    E_V = average_Q ||V_y-F_y||^2.

For each epsilon>0 there is delta=delta_K(epsilon)>0, independent of
Q,F,F_i,u,v,W,r, such that

    E_H <= X,
    E_V <= 2epsilon+(2D^2/delta)T+Y.                 (1)

If additionally the two added source labels at every cross-color
intersection force ||(F_i-F_m)/r||>=c, then for any such Q there are
simultaneous reference offsets z_1,...,z_N with

    ||z_i|| <= D,
    ||z_i-z_m|| >= c-2N sqrt(2N Sigma),  i != m,    (2)
    Sigma = W^2 E_H+E_V.

**Limiting conclusion.** For any sequence of the above data with fixed
K,D,N, if W^2 X -> 0, T -> 0, and Y -> 0, then Sigma -> 0.
For c=sqrt(2), all pairwise distances in (2) are greater than one
for every sufficiently large index. Q, F, the F_i, u, v, r, and W
may all vary. No convergence of reference vectors, quantitative modulus
for K, or uniform rectangle size is required.

## 1. Uniform compactness and expectation control

Fix epsilon>0. If the asserted near-fiber upper bound failed, a sequence
(s_j,t_j) in K would have s_j -> A but t_j>B+epsilon. A convergent
subsequence has limit (A,t) in K with t>=B+epsilon, contradicting
the definition of B. Hence some delta>0 satisfies

    (s,t) in K, A-s<delta  ==>  t<=B+epsilon.

For every point of K there is the stronger useful envelope

    t <= B+epsilon+(D^2/delta)(A-s).                (3)

Indeed A-s>=0. In the near region the added term is nonnegative.
Outside it the added term is at least D^2, which bounds t, and
B+epsilon>=0. Integrating (3) on *any* probability space gives

    E t <= B+epsilon+(D^2/delta) E(A-s).           (4)

This argument is uniform over varying probability spaces and needs
no assertion about a rate of approach to the fiber. Main.lean proves
the compactness assertion via the maximum of the first coordinate on
the compact bad set K intersect {t>=B+epsilon}, and proves (3)-(4).

## 2. Endpoint estimates and energy

All averages in this section use normalized area on Q. The base error
assumption and Cauchy-Schwarz imply
||average F_x-u||<=e and ||average F_y-v||<=e.

On almost every horizontal row, F_i-F is defined along the entire
width of Q and has norm at most Dr. The fundamental theorem bounds its
endpoint difference by 2Dr. Summing the row integrals gives

    ||average H_x-u|| <= 2D rho_x+e.               (5)

Integrating along x separately on each complete vertical strip, of width
Wr, and summing the separate integrals gives

    ||average V_x-u|| <= 2D/W+e.                  (6)

The number of strips cancels against total area. No continuity of the
color-selected field across boundaries is asserted or used. Similarly,
since a vertical strip spans the entire height,

    ||average V_y-v|| <= 2D rho_y+e.              (7)

If an endpoint is outside an open added-sheet domain, use the unique
one-sided Lipschitz limit. Its offset norm is still at most Dr.

For a bounded vector field G and a fixed a0,

    average ||G-a0||^2
      = average ||G||^2-||a0||^2
          -2<a0,average G-a0>.                   (8)

Thus (5), ||u||<=D, and average ||H_x||^2<=A give

    average ||H_x-u||^2 <= a+4D^2 rho_x+2De.

The pointwise inequality
||p-q||^2<=2||p||^2+2||q||^2 gives E_H<=X.

Put eta=A-average ||V_x||^2. K membership makes eta nonnegative.
Discarding the nonnegative variance in (8), and using (6), gives

    0 <= eta <= a+4D^2/W+2De = T.                (9)

The sign in this step is important: nonnegative variance is a *lower*
bound on the selected first moment. Apply (4) to
(s,t)=(||V_x||^2,||V_y||^2), on Q with normalized area:

    average ||V_y||^2 <= B+epsilon+(D^2/delta)T.

Now (7), ||v||<=D, ||v||^2>=B-b, and (8) give

    average ||V_y-v||^2
      <= epsilon+(D^2/delta)T+b+4D^2 rho_y+2De.

The same factor-two comparison gives the second part of (1).
The scalar rearrangements of (8) and the deficit signs are separately
kernel-checked in Main.lean.

To pass to the limit, fix a target tau>0 first and choose epsilon=tau/4.
Then fix the resulting delta_K(epsilon)>0 once. By (1),

    0 <= Sigma <= W^2 X + tau/2 + (2D^2/delta)T+Y.

The three variable terms tend to zero with delta held fixed. This proves
Sigma -> 0. Choosing delta after n, or requiring a rate for delta, is
neither necessary nor legitimate. The theorem `energy_converges` proves
this epsilon-first argument with varying measures and K-valued fields.

## 3. One block, all colors, both directions

By finite averaging, at least one complete block P has combined mean
energy sigma_P<=Sigma. Its color-i row has area |P|/N. Nonnegativity
therefore bounds the mean of W^2||(F_i-F)_x||^2 on that row by N*Sigma.
Fubini disintegrates this into a nonnegative integrable energy g_i(y)
on the row's coordinate interval with normalized length measure.
For each color take any prescribed full-measure set of admissible
y coordinates, including agreement of line and partial derivatives
and membership in the open row.

There exists an admissible y_i with g_i(y_i)<=2N*Sigma.
For Sigma>0, otherwise the integral would be at least 2N*Sigma,
strictly larger than its upper bound N*Sigma. For Sigma=0,
the energy is zero almost everywhere and may be intersected with the
admissible full-measure set. The same argument on color-i columns
produces x_i, with normalized vertical line energy <=2N*Sigma.
These are finitely many independent nonempty choices. There is no
constraint requiring an intersection to be a differentiability point.
Main.lean proves this selection, including the zero-energy case,
for arbitrary probability spaces and full-measure predicates.

Put h_i=(F_i-F)/r. On a selected horizontal line, the fundamental
theorem and Cauchy-Schwarz yield

    ||h_i(x,y_i)-h_i(x',y_i)||^2
      <= (NWr)^2/r^2 * average_line ||(F_i-F)_x||^2
      = N^2 g_i(y_i) <= 2N^3 Sigma.              (10)

The identical bound holds vertically, since vertical length is Nr
and its line energy has no W^2 factor. Notice the precise cancellation
of W. These statements hold at every point of the Lipschitz trace,
not just almost everywhere.

Set z_i=h_i(x_i,y_i). All are in the radius-D ball. At the crossing
c_im=(x_m,y_i), label i is allowed by its row and m by its column;
both h_i and h_m are the original added-sheet offsets. The source
lower Lipschitz bound gives ||h_i(c_im)-h_m(c_im)||>=c. Two transports
using (10) and the triangle inequality give (2), simultaneously for
every pair. This proves the theorem.

For the total real-coordinate functions in the Lean interface, clamp both
coordinates to the closed block and use these offsets on the resulting
permitted rows or columns, taking the unique Lipschitz limits at excluded
endpoints. Define them arbitrarily only outside this clamped permitted
union. Good coordinates lie in the open row/column intervals, so clamping
does not change any crossing or reference point. It also makes (10)
valid for all real arguments, as `LineSystem` requires.

For the rational kernel certificate it is enough to weaken
sqrt(2)>7/5 and require

    128 N^3 Sigma < 1.                           (11)

Then each transport is <1/8, and every selected pair is separated by
more than 7/5-1/4=23/20>1. The proof does not divide by Sigma or
discard the case Sigma=0. `select_crossings` proves this result from
the explicitly exposed `LineSystem` hypotheses; `energy_to_crossing`
derives its eventually simultaneous conclusion from the raw envelopes,
not from an assumed energy limit.

## 4. Exact specialization to the manuscript

For n>=1 use W=n, a=b=n^-4, e=2n^-4, and
rho_x,rho_y<n^-9/(50N). These are exactly (nearmax), (Qerror),
and (ratio), with a harmless weakening of strict inequalities.
The three raw envelopes are

    n^2 X <= 2(1+4D)n^-2 + (4D^2/(25N))n^-7 + 8n^-6,
    T = (1+4D)n^-4 + 4D^2/n,
    Y <= 2(1+4D)n^-4 + (4D^2/(25N))n^-9 + 8n^-8.

Each tends to zero; Main.lean proves all three limits for arbitrary
fixed D,N and proves their limits after the shift n=m+1 used by the
natural-indexed formal interface. This reproduces the manuscript's horizontal rate exactly
and supplies a finite-epsilon bound for its vertical conclusion.
Crucially K,D,k,N are fixed while n and every local geometric datum vary.

Here is why the analytic hypotheses really are available, rather than
new hidden restrictions. Every sheet is D-Lipschitz on its open domain.
Rademacher and Lebesgue differentiation applied locally, componentwise,
give a full-measure set of differentiability and derivative Lebesgue
points. The derivative columns are bounded, so L1 Lebesgue-point
convergence upgrades to L2. Finite-dimensional componentwise
differentiation and a ball/square area comparison justify the exact
square averages used. Taking the closure of the squared-column pairs
over all sheets gives one compact K. The definition of closure supplies,
for each n, actual good-point pairs within n^-4 of (A,B), without any
claim that the same sheet or point works for all n.

Choose a sufficiently small square with closure in that sheet's domain
and average base error <n^-8. Recurrence of (N,n) gives an unused
level with Nnr<l*n^-8/100. Trimming at most two complete periods
per coordinate gives L_x,L_y>=l/2, quadruples the base mean error
at most, and gives r/L_x,r/L_y<n^-9/(50N). Adding a color at
the unused level gives exactly the union-domain sheet F_i, not two
independently chosen row/column maps. Finitely many such sheets
have good derivatives simultaneously almost everywhere, so the selected
K memberships hold. The original upper and lower Lipschitz bounds give
all offset and cross-color inequalities. These facts establish every
hypothesis used above for the manuscript's choices.

Finally Sigma_n -> 0 makes (11) hold for all sufficiently large n;
N is fixed, so the same n works for all colors and pairs. Euclidean
volume comparison for disjoint open radius-1/2 balls gives
N<=(1+2D)^k, contradicting the stipulated N>(1+2D)^k.
This last elementary packing step is prose, not part of the Lean claim.

## Sources, prior result, and scope

The manuscript itself already asserts the limiting energy-to-crossing
result. The mathematical improvement here is the explicit finite-epsilon
vertical bound (1), the arbitrary-width/raw-error criterion, and a
zero-energy-safe probability-space selection theorem linked to the
eventual crossing conclusion. These are an independent verification
and structural extension, not evidence that a false manuscript claim
was found and not a verified-new publishability judgement.

The following standard analytic inputs are used openly for the
instantiation, not asserted to be established by the Python certificate:
Rademacher on open subsets, the fundamental theorem for Lipschitz
interval restrictions, Fubini, and integral Cauchy-Schwarz.
The manuscript's Heinonen Report 100 (2005), Theorems 3.1 and 3.3,
was located through its publisher's record and ISBN 951-39-2318-5,
but direct report and JYX retrieval failed on this host. A search
summary is not treated as reading the theorem. This source attribution
therefore remains explicitly unavailable for independent source review.
These well-known statements can alternatively be taken as the explicit
analytic hypotheses of the theorem, which does not depend on their
attribution to that report.

Tao's October 16, 2010 notes were actually retrieved: Theorem 32
states almost-everywhere Lebesgue differentiation for absolutely
integrable complex functions on R^d, and Exercise 33 explicitly asks
for the locally integrable extension. Localization by cutoff on
relatively compact squares supplies the extension here; no unbounded
globally integrable derivative is presumed. The source URL is
https://terrytao.wordpress.com/2010/10/16/245a-notes-5-differentiation-theorems/.
The downloaded primary source is `tao_notes.html`. No novelty survey
was performed, and no known failed route has been retired as though
it had been mathematically refuted.
The inherited Wiki index was searched for Hilbert, bi-Lipschitz,
anisotropic, and sheet mechanisms; it supplied no relevant prior result
for this implication.

`verify.py` independently checks the exact coefficient identities,
the schedule substitutions, the rational separation threshold, and the
typed Jacobian SOS output. `Main.lean` and its real compiler certificate
are the evidence for the universal formal statements. Neither bounded
examples nor a solver status is used to infer those statements.
