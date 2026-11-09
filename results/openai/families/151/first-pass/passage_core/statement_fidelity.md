# Statement fidelity: complete nonlinear passages

## Declaration and quantifiers

`PassageCore.Orbit.complete_passage` proves
`PassageCore.Orbit.Certified O` for **every** natural number `q`, every
`D : PassageCore.Data q`, every natural number `N`, and every
`O : PassageCore.Orbit D N`. There is no upper bound on `N`, on a readout
index, or on a prediction index. The theorem does not posit the conclusions
of any passage lemma.

`Data` contains the real gain, raw scalar cutoff functions, the saturation
function on finite complex registers, and their displayed elementary
support, range, plateau, reset, and identity-disk conditions.
`Orbit` contains arbitrary sequences of real clocks, complex main
coordinates, and complex registers, obeying the old-state simultaneous
update at every index `n < N`. Its remaining hypotheses say only that the
initial clock lies in `[0,1)`, the terminal clock is at least `100`, and
every earlier clock is less than `100`. In particular, clock agreement,
register norm bounds, nonvanishing, phase alignment, and escape are not
fields of either input structure.

The structures need not be smooth. `S` is completely unrestricted outside
the closed unit disk. These are weakenings of source hypotheses, not
extra assumptions about a passage. The theorem is consequently a
structural verification/generalization of the passage mechanism, not a
formalization of the global smooth map or its entropy.

## Source objects and exact update

Source: the staged September 25, 2026 manuscript, under
`research/openai_manuscript/A-C1-Counterexample-to-the-Entropy-Conjecture-September-25-2026/build/source/`.
The relevant files are `construction.tex` and `orbits.tex`.

| Formal object or hypothesis | Source justification |
|---|---|
| `q : Nat`, channels `Fin q` | The source has a finite `q >= 1`; relabel source channel `l` by `l-1`. The covering hypothesis also excludes an empty channel type. |
| `Data.L`, `gain : 2 < L` | `eq:gain-choice` gives `L > max{B,2}`. The derivative condition `L > B` is not needed for this discrete theorem. |
| `b_bounds`, `b_fast` | `eq:clock-barrier` and `b : R -> [0,1]`; on the fundamental strip `b=1` for `t<=48` or `t>=52`, including both endpoints. |
| `barrier` | The last inequality of `eq:clock-barrier`, for every `0<=t<=50`. |
| `e_bounds`, `e_small` | The range and closed-half-disk condition preceding `eq:clock-increment`. |
| `Data.h` | Exactly `b(t)+(1-b(t))*e(z)` from `eq:clock-increment`. |
| `alpha_bounds`, `alpha_support`, `alpha_plateau` | The first cutoff in the clock-interval subsection: support in `(8,12)` and value one on `[9,11]`. |
| `beta_bounds`, `beta_support` | Each source `beta_l` has values in `[0,1]` and support in `J_l subset (74,80)`. |
| `beta_width` | Two points where one `beta_l` is nonzero belong to the same interval `J_l` of length strictly less than one, hence their distance is strictly less than one. This is a raw support consequence, not the single-hit conclusion. |
| `beta_cover` | Exactly `eq:readout-cover`, on the closed interval `[76,77]`. No disjointness between different channels is assumed. |
| `chi_bounds`, `chi_plateau` | The third cutoff has values in `[0,1]` and is one on `1/2 <= abs(z) <= 1`, including the endpoints. Its vanishing near the poles is unnecessary for this finite-chart passage theorem. |
| `a_reset`, `a_gain` | The conditions `a=0` on `[2,5]` and `a=L` on `[7,90]` in `eq:register-gain`. |
| `S_linear` | `eq:register-saturation` and its following sentence give `S(v)=v` on the closed unit disk. Global boundedness, radial monotonicity, and the particular cutoff outside that disk are unnecessary here. |
| `Data.predict` | Its recursion has initial value `(t,z)` and sends `(u,w)` to `(u+h(u,w),w^2)`, exactly `G^m` from `eq:prediction-map`; its first coordinate is `T_m`. |
| `Data.term`, `Data.input` | Reindex the source sum by `m=d+1`, `d>=0`. Then `L^(1-m)=1/L^d` and `2^(m+1)=2^(d+2)`, precisely the denominator and exponent in the formal term. `beta` is not periodized in this sum. |
| `phase z` | The complex value `z/(norm z)` is the source `z/abs(z)` when nonzero. Its total value at zero is zero. Every preparation value is proved nonzero before phase expressions are used. |
| `Orbit.clock`, `Orbit.main`, `Orbit.register` | Exactly the simultaneous old-state update `eq:map` after translating the chosen period to `[0,100)`. The real-to-complex coercions express real scalar multiplication; moving `20` outside a finite sum changes nothing. |
| `Orbit.start`, `finish`, `before` | Set formal time zero to source `N_k`, and `N=N_(k+1)-N_k`. Minimality of these crossings and increments in `[0,1]` give `0<=s_0<1`, `s_N>=100`, and `s_n<100` for `n<N`. No delay bound is added. |
| Finite complex main coordinate | The source passage branch assumes finite `z_0`; finite additive terms keep every subsequent main coordinate finite. |
| Finite complex registers throughout the passage | Every register output of one source update is finite, even from a register at infinity. Because `100k>t_0`, `N_k>=1`; all registers are therefore already finite at formal time zero. No restriction on the original initial registers is imposed. |

Periodicity of `b`, `a`, and `U`, and the identity
`bar_beta_l(t_n)=beta_l(s_n)` within a single period, justify the
translated update. On prediction inputs the source already uses the
nonperiodic real-line `beta_l` with initial clock `s_i`.

At source `z=0`, the cutoff makes the input zero. The formal total phase
also makes every term zero. The infinity chart is not part of this
finite-main-coordinate passage branch. Neither chart issue is an
assumption about the phase dynamics.

## Conclusions and their precise scope

`Certified` records reset by time `8`, preparation supported on the four
indices `{8,9,10,11}`, a unit preparation coefficient at time `9`, and
preparation radii strictly greater than `1/2`.
The source's weaker bound of five preparation indices follows.

`Window` consists of first crossings of `70` and `82`.
`window_exists` proves that such a window exists from `Orbit`'s completion
hypothesis. Its existence is not an extra premise of `complete_passage`.
`Certified.clocks` gives clock agreement for every eligible starting
index through this window. `single_hit` and `predicted_hit` identify
every predicted coefficient with the unique actual channel readout,
for every natural prediction index, with all other indices zero.
`predicted_beta` and `predict_after` additionally cover channels without
an actual hit: their predicted coefficients are all zero.

For every register with a nonzero readout at `j`,
`linear_until_own_readout` proves its candidate formula and norm at most
`1/2` at **all** times `8<=u<=j`, independently of the phases of its
signals. The candidate denominator is `L^(j-u)`; thus this is a theorem
for arbitrary physical waiting time, not displacement of the clock.
`exact_register` supplies the exact readout sum. No statement restricts a
register after its own readout.

Writing `W=sum_(i=8)^11 alpha(s_i)*chi(z_i)`, `radial_update` proves,
at every `8<=n<N`, the exact equality

    abs(z_(n+1)) = abs(z_n)^2 + 2*W*sum_l beta_l(s_n)^2.

`nonzero`, `phase_doubling`, `square_lower_bound`, and `escape` prove the
nonvanishing, doubled phases, square lower bounds, and an index strictly
before the end of the passage with radius greater than one.
The auxiliary `addition_aligned` and `step_radial` prove the corresponding
complex equalities; no radial surrogate replaces the actual main update.
Overlapping readouts contribute the sum of their squared coefficients.

The source starts these conclusions at `min I`. Since `I` is nonempty,
is contained in `{8,9,10,11}`, and has no readouts before it, the
stronger formal conclusions from time `8` imply the stated source
conclusions from `min I`. If the formal escape index precedes `min I`,
the square lower bound keeps its radius greater than one up to `min I`;
otherwise it is already a source escape index.

## What this compilation does not establish

Lean checks the quantified theorem above using Mathlib and the usual Lean
foundations. It does not independently check this translation document,
the asserted source application, novelty, or publication significance.
Those are independent Reviewer obligations. It does not prove global
`C^1` regularity, the bounded-clock limit, the iteration across later
passages, entropy localization, register entropy, or the homological
eigenvalue. No independent Reviewer approval is claimed.
