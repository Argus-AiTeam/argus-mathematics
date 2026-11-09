# Local shell estimates: Theorems A and B

**Engineer assessment: supported under the stated local hypotheses.** The
all-depth argument is a mathematical proof, not an extrapolation from the
finite certificate. Theorem A reproduces the specified manuscript lemma;
Theorem B strengthens its support and odd-prime constants. This is not a
kernel-checked result, a novelty determination, or native Reviewer acceptance.

## Exact source and attribution

The submitted source is the unchanged old
`9000015/research/quartic_shell/theorem.md`, Sections 1-5. Its identity and the
checker identity match the existing preserved manifest; see
`research/DRAFT_REVIEW_INDEX.json`. The old claims covered are
`MAP_QUARTIC_SHELL@1`, `QS_DECAY@1,2`, `QS_SUPPORT@1,2`, and
`QS_BOUNDARY@1,2`. `QS_CERT@1,2` aggregates these and the other units; it is
not another proof.

The comparison source is OpenAI's quartic manuscript (the author is explicit
in its `main.tex`)
`Equidistribution-of-Primitive-Quartic-Torus-Packets-for-Arbitrary-Orders-October-5-2026`,
revision `4eaee87548250b2682affda7d05d947c05554bae`,
`build/manuscript/local-fourier.tex`: "Quadratic data and the trace marginal",
`lem:fourier-shift`, `lem:fourier-quadratic-transform`, and
`lem:fourier-shell-estimates`. The four audited equations are
`eq:fourier-shell-decay`, `eq:fourier-inverse-support`,
`eq:fourier-boundary-support`, and `eq:fourier-boundary-decay`.
The referenced manuscript paths and reference-directory copies match the
existing manuscript manifest. The manuscript already states the local lemma;
reproducing it must not be presented as discovering an error in it.

## Hypotheses and normalization

Here `p` is any prime, `E=product E_nu` is an etale algebra of degree three
over `Q_p`, `R` is its maximal order, and `d` is its different. Field factors
may be ramified, including wildly ramified; integral components of a frequency
may be zero. `W` is free of rank two over `E`, the action `rho` is unital
and faithful, and the nondegenerate symmetric `Q_p`-bilinear form `B` makes
that action self-adjoint. The full lattice `L` is `B`-self-dual and
`Q_1(x)=B(x,x)/2` is integral on `L`. At 2 the last condition is essential;
self-duality is not a replacement for it.

The character has conductor `Z_p`. The self-dual measures give `L` mass one
and `R` volume `product q_nu^(-d_nu/2)`. In particular, ramified volume
factors cannot be suppressed by setting `vol(R)=1`. Write

```
C = {a in E : rho(a)L subset L},       C_sharp = Z_p + 2C,
h = product q_nu^(h_nu),              H = Norm(h),
g = log_p [h : h intersect C],
c = min {n >= 0 : p^n h subset C}.
```

`C` is the actual multiplier order, not a convenient smaller chosen order.
The finite additive quotient has cardinality `p^g` and exponent `p^c`;
thus `c<=g` and `c=0` exactly when `g=0`. On the shell the positive
components have valuation exactly `-h_nu`; the zero-depth components range
over all of `R_nu`. `gamma` averages `integral_L psi(u Q_A)` over units
with probability measure, and `K_h` is the inverse trace-pairing Fourier
transform of its zero-extended shell restriction.

## Statements checked

For any scalar shift satisfying the manuscript's valuation conditions, put
`alpha=A+s`, `beta=alpha^(-1)`,
`j=min{n>=0:p^n beta in C}`, and `iota=1` for `p<=5`, otherwise zero.
Theorem A gives

```
|gamma(A)| <= p^(3 iota) H^(-1) p^(-j/2),
||K_h||_infinity <= p^(3 iota) vol(R),
supp K_h subset (C_sharp)^vee,
supp K_h subset p^(-4(g+1)) h d^(-1)  if g>0 or p<=5.
```

Both functions are Schwartz--Bruhat, and their stated intrinsic support
implies integral trace. When `g=0,p>5`, the component support is
`d_nu^(-1)` at `h_nu=0` and `q_nu^(h_nu-1)d_nu^(-1)` otherwise.
The boundary consists exactly of the positive-depth components outside
`q_nu^(h_nu)d_nu^(-1)`. On it the bound is
`8 vol(R) product_boundary q_nu^(-1/2)`.

Theorem B improves the sup norm to `vol(R)` at every odd prime. For odd
`p,c>0`, its support is `p^(-c) h d^(-1)`. For odd `p,c=0`, the same
one-step boundary assertion holds even at 3 and 5. At 2 the support is
`2^(-N) h d^(-1)`, `N=max(c+3,4)`; no optimality of the additive
constant at 2 is asserted.

## Decisive argument

1. **The Gaussian identity is proved rather than imported.** For an
   invertible self-adjoint operator `P`, choose a small lattice `U` with
   `q_P(U)` integral. The integral on `x+U` is zero unless
   `Px in U^perp`. All contributing cosets therefore lie in one fixed
   compact lattice. Integrals over sufficiently large lattices stabilize.
   Differencing on `p^(-N)L` gives a squared absolute value
   `vol(p^(-N)L) vol(P^(-1)p^N L)=|det P|_p^(-1)` for large `N`.
   Completing the square, then integrating the dual variable on `L`, gives
   the reciprocal identity in Section 2. These operations are on finite
   compact integrals; there is no unjustified pointwise improper inversion.
   Changing variables by `T` proves invariance of the normalized phase
   under `T^*PT`. Taking `T=rho(r)` allows multiplication of `alpha`
   by a square in `E`, without requiring `rL=L`.

2. **The index bound uses the right quotient.** Differencing the inverse
   integral restricts it to `L intersect rho(beta)^(-1)L`. The image of
   `L -> W/L`, `x -> rho(beta)x mod L`, is
   `(L+rho(beta)L)/L`. Its exponent is exactly `p^j`, so its order is
   at least `p^j`. This gives the square-root bound `p^(-j/2)` without
   assumptions about repeated elementary divisors.

3. **Scalar shifts include the small primes and zero components.** Among
   `0,1,2,3`, each integral field component forbids at most one candidate
   with valuation greater than `e_nu` at small primes, or positive valuation
   at `p>5`. The norm loss is at most `p^3`. Integrality of `Q_1`
   preserves each fixed-unit integral. If there is a pole and `p` is odd,
   at most two integral components remain; `0,1,2` give unit shifts even
   at 3, with norm exactly `H`. With no pole, `H=1` and the probability
   bound already suffices. Also `p^c h subset C` and
   `beta in p^(-iota)h` imply `j<=c+iota<=g+iota`.
   This justifies the improved odd sup norm and the stated denominator bound.

4. **Support comes from a proved period, uniformly in depth.** At odd
   `p,c>0`, take `t in p^c h^(-1)` and the improved shift. Then

   ```
   t beta in p^c R,
   (alpha+t)^(-1)-beta = -t beta^2/(1+t beta) in p^c h subset C.
   ```

   Translation preserves the shell and the shift valuations.
   The element `1+t beta` is a square unit in every field factor.
   Thus the norm, Gaussian phase, and inverse integral are unchanged.
   The annihilator of this period is precisely `p^(-c) h d^(-1)`.
   If `h=R`, the direct period `p^c R subset C` proves the same result.

   At 2, the original shift only gives `beta in 2^(-1)h`.
   With `N=max(c+3,4)`, the corresponding quantities lie in
   `2^(N-1)R subset 8R` and `2^(N-2)h subset 2C`.
   In a field factor the square-root Hensel inequality is
   `v_nu(t beta)>=3e_nu>2v_nu(2)`, valid also in wild extensions.
   Membership of the inverse difference in **2C**, not just `C`,
   ensures the required quadratic integrality. No conductor depth or
   different exponent was bounded in this argument.

5. **The boundary argument does not assume independence of the unit
   averages.** When `h subset C`, zero-depth idempotents preserve `L`
   and split off self-dual orthogonal summands. On the combined pole
   summand the inverse frequency preserves its lattice, so its inverse
   quadratic integral is one at odd primes. The remaining bounded phase
   function depends on at most three residue square classes. Its finite
   Fourier expansion has at most eight coefficients, each of modulus at
   most one, even with the common averaging unit. The trivial-character
   inverse is a difference of two ball indicators with factors `1` and
   `q^(-1)`. The quadratic-character inverse is on the intervening
   boundary and has modulus `vol(R_nu) q_nu^(-1/2)`, by the explicitly
   proved finite-field Gauss-sum identity. Multiplying the component
   formulas retains every different and volume factor.

The earlier `C_sharp` period gives the general trace-dual support and local
constancy. Since `C_sharp subset R`, the shell retains that period.
Compact support and the open period justify the Schwartz--Bruhat assertions.
The coarse manuscript exponent follows from `c<=g`,
`max(c+3,4)<=4(g+1)`, and the one-step boundary inclusion at 3 and 5.
No mathematical gap was found in these steps.

## Replay and its limits

The unchanged default checker was run once, without `--write-certificate`:

```
$WORKSPACE/argus-latest/.venv/bin/python -B \
  families/015/first-pass/quartic_shell/verify.py
```

The durable receipt is `replay_submission.json` in this unit. Task
`old-draft-exact-replay`, run `old-draft-exact-replay-1794068701420562246`,
completed with exit 0 in 10.0 seconds. The actual stdout is
`.argus_subagents/old-draft-exact-replay_logs/stdout.log`
relative to the project root. The receipt's requested `run_dir` was
not created in direct mode; it is not cited as an existing output artifact.
The output reports PASS, 8,376 frequency tests, 25,128 improved-period tests,
28 direct finite kernel counts, seven exact finite Fourier instances, and
48 deep sharpness-family instances. It compares the complete recomputed
certificate with the existing JSON, not just its descriptive labels.

The environment was Python 3.13.5, GCC 11.2.0 build, Linux x86_64/glibc 2.35.
The checker uses the standard library, rational arithmetic, minors/Smith
exponents, and exact prime-power cyclotomic reduction. Its ramified tests
are hyperbolic `E`-spaces, with trace duals computed from multiplication
tables; they do not exhaust all forms or all local algebras. The default
lattice depths are `0,1,2,6,12`. The unbounded conclusion rests on the proof
above, not those test ranges.

The isolated Jacobian adapter was independently discovered and inspected,
then run exactly once on the old payload. The four JSON files under
`jacobian/` retain discovery, contract, exact payload and typed output.
The executable was
`$WORKSPACE/argus-live-update/.venv/bin/python -m argus_skill.tools.jacobian`;
server 0.14.0, protocol `2025-11-25`, operation
`finite_abelian_group.spectral_pair.decide`. For the six units of `Z/9Z`
and frequencies `0,...,5`, it returns `is_spectral=false`,
`NONORTHOGONAL_FREQUENCIES`, first pair `0,3`, difference 6, and remainder
`[-3,0,0,0,0,0]`. Adapter exit 0, error null, no timeout. This is exactly
one residue-character sum, not a verdict on a p-adic theorem.

## Improvement, dependencies and remaining scope

Compared with the manuscript's `4(g+1)`, the odd-prime bound uses the actual
quotient exponent `c`; the boundary and norm conclusions also extend to 3
and 5. Compared with the strongest old submission, this review adds no new
bound: the v1-to-v2 local claims change proof requests into assertions with
the same mathematics. Publication originality remains unverified.

The direct proofs avoid reliance on an unread Weil citation; ELMV Proposition
9.9 is not a premise. The basic character-orthogonality, lattice and
local-field facts are used explicitly, not a theorem about packets.
The manuscript's `exterior.tex`, `lem:ext-quadratic-structure`, has the
required rank-two action and signed hyperbolic scalar form, with unimodular
polarization, as its displayed proof explains. This comparison checks the
local interface, not every assertion in `MAP_QUARTIC_STRUCTURE`, its density
normalization, or the surrounding global geometry.

There is no Lean source to compile. Neither the finite replay nor this
Engineer opinion supplies statement-fidelity or kernel evidence. The
downstream density expansion, nonscalar Poisson estimates, sieve, rigidity
and all three equidistribution theorems remain outside this conclusion.
Native independent review of the entire indexed family is still required.
