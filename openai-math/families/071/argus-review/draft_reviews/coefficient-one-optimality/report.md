# Coefficient-one optimality

## Exact claim and attribution

**C_SHARP_OPTIMAL v1:** no universal coefficient strictly below 1 can replace
the coefficient of `||g||_2+||m||_ell2` in the sharp infimum barrier bound,
even with an empty prior list, no gates or earlier laws, zero atomless
measure, `m=0`, and one dust component. This is the Argus sharpness
construction in old `9000071/research/tagged_jump_audit/proof.md`, Section 6,
digest `13bd5180e0de0dda9999506bb95f3aa5e2503003926553b4298a3309b23254ca`.
The original endpoint/barrier class is OpenAI's September 23, 2026 Koebe
manuscript, revision `4eaee87548250b2682affda7d05d947c05554bae`,
`03-barriers.tex`, `def:endpoint` and `thm:barrier`.
The full claim/context hash and old evidence bindings are in the index.

The annular capacity calculation is classical (also Rajala,
`arxiv:2408.12027v1`, Section 1 equation (5)). The argument packages it
into the actual endpoint class with a strictly positive density.
Novelty of this combined application was not established; the present
review adds no new sharpness theorem.

## Construction and verification of every condition

Use the unit-round spherical metric, with stereographic factor
`Lambda(r)=2/(1+r^2)`, on

    G = {|z|>1} union {infinity}.

Collapse the complementary closed unit disk to the sole dust point `b`.
For integers `n>=2`, let `E={|z|>=2} union {infinity}`,
`E_*={|z|>=2+1/n} union {infinity}`, and prescribe collar radii
`r_l=1+2^(-l-2)`, `l>=1`. The anchor is compact with nonempty interior,
`E_*` is compact in its interior, and the smooth collars miss `E`,
are strictly nested and shrink to `b` in the quotient. Zero tolls
are in counting `ell2`; with the listed empty path-system data,
all finite-domain-length paths are allowed.

On `1<r<2` set `g0=1/(Lambda*r*log(2))`, and set it to zero elsewhere.
Put `g_n=g0+1/n`. This is Borel, square-integrable and everywhere at
least `1/n`, including near infinity. Every allowed first-arrival
`E`-to-`b` path must cross each annulus `1+t<r<2`. Radial variation
therefore gives `g0`-length at least
`1-log(1+t)/log(2)`. Letting `t` decrease to zero proves the exact
endpoint hypothesis, for **all** such paths, not only radial paths.
First arrival matters: with this single dust point the path is in `G`
before the final time. Infinite cost also satisfies the lower bound.

Conformal cancellation and ordinary polar integration give

    A = ||g0||_2^2 = 2*pi/log(2),    area_sph(G)=2*pi,
    ||g_n||_2 <= sqrt(A)*(1+1/n).

The norm bound uses the triangle inequality and `0<log(2)<1`.
It does not replace `g_n` by the inadmissible density `g0` with no
positive lower bound.

Any eligible smooth barrier is zero on the circle `R_n=2+1/n` and
one on some required `r_l`. Radial Cauchy-Schwarz, with weight `r dr`,
gives energy on each ray at least `1/log(R_n/r_l)`. Integrating angles
and dropping nonnegative angular energy yields

    ||du||_2 >= sqrt(2*pi/log(R_n)).

Since `r_l>1`, this weaker uniform lower bound holds for every possible
chosen collar; it does not presume a boundary trace value at `b` or
monotonicity of the barrier.

Using `log(2)>=1/2` and `log(1+x)<=x`,

    log(2)/log(2+1/n) >= n/(n+1),
    ||du||_2/||g_n||_2 >= (n/(n+1))^2 = q_n,
    0 < 1-q_n = (2*n+1)/(n+1)^2 < 2/(n+1).

For `0<=c<1`, choose `n` with `2/(n+1)<1-c`.
The lower bound for `||du||_2` then exceeds `c` times the displayed
upper bound for `||g_n||_2` by a positive amount. Choose the permitted
additive error smaller than that amount. No barrier can satisfy the
proposed coefficient-`c` estimate. Negative coefficients are already
excluded by positivity. Thus the quantifiers prove a universal
coefficient obstruction, not a bounded finite exclusion.

## Evidence and limits

Old Reviewer support `judgement-C_SHARP_OPTIMAL-e8263ad40347` matches
this exact version. The current unchanged exact checker passed the
radial integrals, spherical area, logarithmic derivative identity and
rational deficit formulas. The current Jacobian operation checks only
the scalar Cauchy-Schwarz determinant identity. The old Lean source
proves only deficit/error algebra, not the radial geometry, endpoint
condition, energy inequality or limiting universal conclusion.

The above construction and inequalities supply those human mathematical
steps independently of run status. The assessment supports this narrow
optimality result, consistently with prior review. It does not show
attainment at coefficient 1, prescribe exact budget `m` in the general
theorem, verify either full manuscript, or establish novelty. Current
native acceptance of the review remains pending.
