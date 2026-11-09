# A quantitative, all-point verification of the uniform slice estimate

## Result and scope

For the exact, unscaled map in the staged manuscript, Proposition
`prop:uniform-slice` follows from the proof below, with the following explicit
choice of error for **every integer `k >= 2`**:

\[
\begin{split}
r_k&=1-\frac{\log k}{k},\qquad
L_k=\frac8{\pi^2}\operatorname{atanh}r_k,\qquad
C_0=\frac{3\sqrt2\pi^2}{8},\\
B_k&=\frac{\pi^2}{2}\,k r_k^{\,2k-2}
       +\frac{C_0(1+\pi/e)}{\sqrt{L_k}}.
\end{split}                                                    \tag{1}
\]

In particular, simultaneously for **all** `v+it` in `D`,

\[
\frac{|J_k(v,t)|}{k}
\le \frac{\pi}{4}|g(v+it)|^{2k}+B_k,\qquad
0<B_k\le
\frac{\pi^2e}{2k}
+\frac{3\pi^3(1+\pi/e)}{8\sqrt{\log k}} \longrightarrow0.          \tag{2}
\]

There is no lower bound on the distance to either tip, on the slice length,
or on the difference of the initial and final radii. All of these may depend
on `k`. The leading coefficient `pi/4` is optimal among inequalities of this
form with an all-point error tending to zero.

This is an analytic proof with a Lean-checked universal scalar core, exact
polynomial verification, and separate finite rational stress tests. It is
**not a formalization of the whole proposition**, a refutation, or a
verification of any full Mahler or symplectic-width theorem. Independent
Reviewer acceptance and publication-level novelty assessment remain pending.

## Source inputs and the strongest prior result

All paths here are relative to `research/openai_manuscript/`.

* `Symplectic-Balls-in-Symmetric-Polar-Products-September-22-2026/build/sections/planar.tex`:
  `eq:planar-F`, `lem:planar-map`, `eq:slice-primitive`, and
  `prop:uniform-slice` specify the map, inverse, signed primitive, and exact
  quantifiers. Its existing Steps 1--4 already assert qualitative uniformity,
  including moving endpoints, through a fixed-cutoff estimate with
  `C_* = diam(D) max_{|w|<=r_*}|F'(w)|^{-2}`.
* The same manuscript's `build/sections/realization.tex`, Steps 2--4,
  uses `p=-u-sum_j J_k(v_j,t_j)b_j` and
  `h_K(p)/k <= C_K/k+(pi/4)tau+m epsilon_k`. Here the strip list, `m`,
  and `K` are fixed before `k` varies. Thus the relevant planar coefficient
  is exactly `pi/4`, with no additional scaling of `F`.
* `The-symmetric-Mahler-conjecture-and-its-equality-cases-September-22-2026/build/sections/lens.tex`,
  `eq:lens-map` and `lem:planar-lens`, uses the identical series;
  its half-width `lambda(t)` is `V(t)`. Neither its stronger convexity
  conclusions nor an external theorem from Gross is needed below.

The improvement over the strongest staged result is the cutoff-independent
bound `Re F' >= 2/pi`, giving `C_* <= pi^2/2`, and hence the explicit
varying-cutoff majorant (1), the elementary rate (2), and the sharpness
corollary. Repeating fixed-height convergence would not give these
all-point conclusions. No relevant result was found in the inherited Wiki
index and targeted page search. No external novelty search was performed;
there is no claim of verified-new publication status. The three family main
claims and their unaudited dependencies are separately open in the ledger
and proof graph. Scalar programs in the general manuscript cannot by
themselves establish its noncommutative Gaussian chain.

## 1. The derivative bound and normalization, directly from the series

Let

\[
F(w)=\frac8{\pi^2}\sum_{j=0}^{\infty}
             \frac{(-1)^j w^{2j+1}}{(2j+1)^2},\qquad |w|<1.
\]

Locally uniform convergence and integration of a geometric series give,
including the removable value at zero,

\[
F'(w)=\frac8{\pi^2}\int_0^1\frac{ds}{1+s^2w^2},\qquad
wF'(w)=\frac8{\pi^2}\arctan w.                                  \tag{3}
\]

Here the logarithm in
`arctan w=(1/(2i)) log((1+iw)/(1-iw))` is on the right half-plane:
the fraction has real part `(1-|w|^2)/|1-iw|^2>0`.

The key scalar inequality is, for `0 <= q < 1` and `x^2+y^2 <= q^2`,

\[
\Re\frac1{1+x+iy}=\frac{1+x}{(1+x)^2+y^2}\ge\frac1{1+q}.          \tag{4}
\]

Indeed `-q<=x<=q`, both denominators are positive, and the difference
after multiplication by the denominators is

\[
(1+q)(1+x)-((1+x)^2+y^2)
=(q^2-x^2-y^2)+(1-q)(q-x)\ge0.                                  \tag{5}
\]

For `z=s^2 w^2` take `q=s^2|w|^2<1`. Therefore

\[
\Re F'(w)\ge\frac8{\pi^2}\int_0^1\frac{ds}{1+s^2}
             =\frac2\pi,\qquad |F'(w)|^{-2}\le\frac{\pi^2}{4}.    \tag{6}
\]

The substitution in this integral, its evaluation by the real
arctangent, and the series manipulations are analytic steps, not assertions
of the Lean file. Formulae (4)--(5) are proved there for all real variables.
The constant in (6) is sharp: for real `w` increasing to `1`,
`F'(w)=(8/pi^2) arctan(w)/w` tends to `2/pi`.

There is also a direct proof of global injectivity, avoiding any external
univalence criterion. The disk is convex, and for distinct `w_1,w_2`

\[
\frac{F(w_2)-F(w_1)}{w_2-w_1}
 =\int_0^1 F'(w_1+s(w_2-w_1))\,ds
\]

has real part at least `2/pi`. In particular it cannot vanish, and
`|F(w_2)-F(w_1)| >= (2/pi)|w_2-w_1|`. Thus `g=F^{-1}` is holomorphic
on `D=F(disk)`, and `|g'|<=pi/2`; in fact `g` is globally
`pi/2`-Lipschitz.

For `w=r exp(i theta)` put `A=Re(wF'(w))`. Formula (3) gives

\[
A(r,\theta)=\frac4{\pi^2}
   \arctan\frac{2r\cos\theta}{1-r^2}.                            \tag{7}
\]

On the right semicircle `0<A<2/pi`. Write `F(ir)=iT(r)`. Angular
integration, using `F(r)` real, and differentiation along the imaginary
axis give

\[
T(r)=\int_0^{\pi/2}A(r,\theta)\,d\theta,\qquad
T'(r)=\frac8{\pi^2}\frac{\operatorname{atanh}r}{r}>0.              \tag{8}
\]

The continuous value at zero of the derivative is `8/pi^2`.
For every angle strictly below `pi/2`, the integrand in (8) tends to
`2/pi` as `r` tends to `1`, and it is bounded by that constant.
Dominated convergence gives `T(r) -> 1`. Also, by coefficientwise
absolute values in the series,

\[
|F(w)|\le \frac8{\pi^2}\sum_{j\ge0}
                 \frac{|w|^{2j+1}}{(2j+1)^2}
          =T(|w|)<1.
\]

Consequently `D` is bounded and `diam(D)<=2`. This argument does not
assume a value for the sum of the reciprocal odd squares.

## 2. Slice geometry, signs, and the exact change of variables

Oddness and conjugation symmetry of the series give
`F(-conj(w))=-conj(F(w))`. Its real part is positive on the right
half-disk: the radial derivative is `A/r>0` and its limit at zero is
zero. On each right semicircle the imaginary coordinate is strictly
increasing, since its angular derivative is `A`; it ranges from `-T(r)`
to `T(r)`.

For any `|t|<1`, let `r_0=T^{-1}(|t|)`. For every `r_0<r<1`
there is exactly one angle `theta(r,t)` in `(-pi/2,pi/2)` with
`Im F(r exp(i theta))=t`. Write `wF'(w)=A+iB`. Implicit
differentiation gives

\[
\partial_r\theta=-\frac B{rA},\qquad
\frac{dv}{dr}=\frac{A^2+B^2}{rA}
              =\frac{r|F'(w)|^2}{A}>0.                         \tag{9}
\]

As `r` decreases to `r_0`, `v` tends to zero; for `r_0=0` this
uses `F(0)=0`. Boundedness gives an increasing range `(0,V(t))`.
Reflection gives the negative half, so every horizontal section of `D`
is `(-V(t),V(t))`. All imaginary coordinates are in `(-1,1)` and
each such coordinate occurs. Thus every integration segment used here
is contained in `D`.

For an integer `k>=2`, the density
`(|g|^2)^(k-1)|g'|^2` is smooth, even at the zero of `g`.
The formula

\[
J_k(v,t)=k^2v\int_0^1
      |g(av+it)|^{2k-2}|g'(av+it)|^2\,da
\]

proves smoothness locally, since these segments remain in a compact
subset of `D` for nearby endpoints. The fundamental theorem of calculus
gives the claimed nonnegative derivative. Reflection makes the density
even in the real coordinate, and `J_k` is odd in `v`.

It remains to consider `v>0`. Put `R=|g(v+it)|`; then `r_0<R<1`.
Equations (9) and `g'(F(w))=1/F'(w)` give the exact identity

\[
\frac{J_k(v,t)}k
 = k\int_{r_0}^{R}\frac{r^{2k-1}}{A(r,\theta(r,t))}\,dr.         \tag{10}
\]

At `r_0` this is an improper integral. First change variables on a
segment starting at positive real coordinate; then let that coordinate
decrease to zero. The original integrand is smooth on its compact
segment, and nonnegative transformed integrals increase to the same
finite answer. This also covers `t=0`, `r_0=0`.

## 3. Tip control, with the constants checked

For `X>0`,

\[
\frac1{\arctan X}-\frac2\pi\le\frac2X.                           \tag{11}
\]

If `X<=1`, integration of `1/(1+u^2)>=1/2` gives
`arctan X>=X/2`, which implies (11). If `X>=1`, then
`arctan X>=pi/4` and
`pi/2-arctan X=arctan(1/X)<=1/X`. Hence the left side is at
most `8/(pi^2 X)<=2/X`. All denominators are strictly positive.

For `1/2<=r<1`, set `s=pi/2-|theta|` in `(0,pi/2]` and
`X=2r sin(s)/(1-r^2)`. From (7), (11), `sin s>=2s/pi`, and
`(1+r)/(2r)<=3/2`, one obtains

\[
\frac1A-\frac\pi2
\le\frac{\pi^2(1-r^2)}{4r\sin s}
\le\frac{3\pi^3}{8}\frac{1-r}{s}.                              \tag{12}
\]

The vertical gap from the appropriate tip of that semicircle satisfies

\[
\begin{split}
\Delta&=T(r)-|\Im F(r e^{i\theta})|\\
 &=\frac4{\pi^2}\int_0^s
      \arctan\frac{2r\sin \xi}{1-r^2}\,d\xi\\
 &\le\frac{4r s^2}{\pi^2(1-r^2)}
 \le\frac{2s^2}{\pi^2(1-r)}.
\end{split}                                                   \tag{13}
\]

This uses `arctan u<=u`, `sin xi<=xi`, and `2r<=1+r`.
Thus `s >= (pi/sqrt(2)) sqrt(Delta(1-r))`. Substitution in
(12) gives, with exactly the constant in (1),

\[
\frac1{A(r,\theta(r,t))}
\le\frac\pi2+C_0\sqrt{\frac{1-r}{T(r)-|t|}}.                    \tag{14}
\]

The identity
`C_0^2 (pi^2/2)=(3pi^3/8)^2` is also proved in Lean.
All quantities being compared in this constant conversion are
nonnegative. Equation (14) holds for every slice and every `r>r_0`
in the indicated radial range; it excludes neither tip region.

## 4. A genuinely uniform endpoint integral

For any integer `k>=2` and any `0<=a<1`, put `H=k(1-a)>0`. Then

\[
\begin{split}
I(k,a)&=k\int_a^1 r^{2k-1}\sqrt{\frac{1-r}{r-a}}\,dr\\
 &=\int_0^H (1-y/k)^{2k-1}\sqrt{\frac{y}{H-y}}\,dy\\
 &\le\int_0^H e^{-y}\sqrt{\frac{y}{H-y}}\,dy
 \le 1+\frac{\pi}{e}. 
\end{split}                                                   \tag{15}
\]

The substitution is `y=k(1-r)`. Since `log r<=-(1-r)` and
`2k-1>=k`, the power is bounded by `exp(-y)`. At a possible zero
endpoint this follows by a limit.

For completeness, on `[0,H/2]` the square-root factor is at most
one, and the integral of `exp(-y)` there is at most one. On
`[H/2,H]` the exponential is at most `exp(-H/2)`, while

\[
\int_0^H\sqrt{\frac{y}{H-y}}\,dy
=2H\int_0^{\pi/2}\sin^2 u\,du=\frac{\pi H}{2}.                 \tag{16}
\]

Finally `(H/2) exp(-H/2)<=exp(-1)`. A particularly short proof,
also checked in Lean, multiplies `x<=exp(x-1)` by `exp(-x)`.
The inequality `x<=exp(x-1)` is `1+z<=exp(z)` with `z=x-1`.
The same calculation without the exponential yields

\[
I(k,a)\le \min\{\pi H/2,\ 1+\pi/e\}.                            \tag{17}
\]

These are universal inequalities in `H>0`, not estimates for fixed
`a`. They cover `H` tending to zero, to a positive constant, to
infinity, or oscillating. In particular they address the potential
moving-tip quantifier problem directly.

## 5. Combining the regions without losing endpoints

Fix temporarily `1/2<r_*<1`, and set
`L_*=(8/pi^2) atanh(r_*)`. The part of the positive horizontal
integral where `|g|<=r_*` is an initial segment (possibly empty or
the whole segment). By (6), its contribution to `J_k/k` is at most

\[
k r_*^{2k-2}\,(\pi/2)^2\,\operatorname{diam}(D)
\le \frac{\pi^2}{2}k r_*^{2k-2}.                               \tag{18}
\]

If an outer part remains, its lower endpoint is
`a=max(r_0,r_*)<R`. By (8) and monotonicity of `atanh`,
`T'(r)>=(8/pi^2) atanh(r_*)=L_*` on `[a,1)`. As
`T(a)>=|t|`, it follows that
`T(r)-|t|>=L_*(r-a)` for `r>a`. Combining (10), (14), and
(15), the outer contribution is at most

\[
\frac\pi4(R^{2k}-a^{2k})
+\frac{C_0}{\sqrt{L_*}}I(k,a)
\le \frac\pi4R^{2k}
+\frac{C_0(1+\pi/e)}{\sqrt{L_*}}.                              \tag{19}
\]

Extending the error integral to `1` only increases it. If there is no
outer part, (18) alone bounds the whole integral, which is even stronger
than the asserted bound. If `v=0`, the assertion is immediate;
negative `v` follows by oddness. Thus (18)--(19) hold simultaneously
over all of `D`, with constants independent of `t`, `r_0`, and `R`.

## 6. An explicit cutoff and convergence for every `k>=2`

For real `x>=2`, the function `x/2-log x` is nondecreasing and its
value at `2` is `1-log 2>0`. Therefore `0<log k/k<1/2` for every
integer `k>=2`, so `1/2<r_k<1`. We may insert this cutoff directly
in (18)--(19); the cutoff need not be fixed once its constant is the
global constant in (18). This proves (1)--(2)'s all-point inequality.

The elementary inequality `log(1-u)<=-u`, `0<u<1`, gives

\[
k r_k^{2k-2}
\le \exp\left(-\log k+\frac{2\log k}{k}\right)
\le\frac e k.                                                 \tag{20}
\]

Also `sqrt(x)-log x` attains its minimum on `[2,infinity)` at
`x=4`, where it is `2-2log 2>0`. Hence `log k<=sqrt(k)`.
With `u=log k/k`, one has

\[
\operatorname{atanh}r_k
=\frac12\log\frac{2-u}{u}
\ge\frac12\log\frac1u
\ge\frac14\log k.
\]

Thus `L_k >= (2/pi^2)log k`. Substitution in (1), together with
(20), proves the second inequality in (2) with exactly
`C_0*pi/sqrt(2)=3pi^3/8`. Both terms tend to zero. All formulae
were established already at `k=2`; no unhandled finite prefix is
hidden in this conclusion. One may take `epsilon_k=B_k`, or use
the manuscript's nonnegative supremum error, which is bounded by `B_k`.

## 7. Sharpness of the leading coefficient

At `t=0`, `r_0=0` and `0<A<2/pi`; hence (10) gives

\[
\frac{J_k(F(R),0)}k \ge \frac\pi4 R^{2k}\quad(0<R<1),
\]

where `F(R)` is real. Take the legitimate interior points
`R_k=1-1/k^2` and `v_k=F(R_k)`. Induction on the integer `m`
gives `(1-u)^m>=1-mu` for `0<=u<=1`; applying it with
`m=2k`, `u=1/k^2` yields

\[
1\ge R_k^{2k}\ge1-\frac2k\longrightarrow1.
\]

If an inequality with a coefficient `c<pi/4` and an all-point
vanishing error held, it would force
`epsilon_k >= (pi/4-c)R_k^(2k)`, a contradiction. This is a
universal analytic obstruction, not a numerically discovered
counterexample to the manuscript; its coefficient is already `pi/4`.

## 8. What the machines establish, and what they do not

`Main.lean` proves the universally quantified disk-resolvent inequality,
its slack identity, the universal exponential peak bound, the left-half
kernel bound, and the exact tip-constant square identity. The separate
statement-fidelity document names every declaration and explicitly
excludes all unformalized analytic steps. The real compiler result,
source-bound archive, and durable-run receipt are local to this directory.

The inspected Jacobian operation `polynomial.box.enclosure.compute`
encloses `d+u*v` on `[0,1] x [0,2] x [0,1]` by `[0,3]`. For
(5) take `d=q^2-x^2-y^2`, `u=q-x`, `v=1-q`; the disk
hypotheses put these variables in that box. Its exact payload, typed
output, server version, protocol, and adapter exit status are preserved
in dedicated JSON files. This is an atomic polynomial check, not an
integration oracle or an independent review of the analytic proof.

`verify.py` uses only the Python standard library. It checks the
polynomial identity coefficientwise, the rational constant conversion,
the exact Jacobian input/output, and the freshness and success of the
real Lean certificate. It also performs separately labelled exact
rational stress tests of the scalar inequality, the endpoint integral
at moving lower endpoints, and the sharpness sequence. For those
finite endpoint tests it uses

\[
\frac{I(k,a)}\pi
= k(1-a)\sum_{j=0}^{2k-1}
 \binom{2k-1}{j}a^{2k-1-j}(1-a)^j
 \frac{\mathrm{Cat}_j}{2\,4^j},                                \tag{21}
\]

where `Cat_j=binom(2j,j)/(j+1)`. The beta moments in (21) follow
from the substitution `r=a+(1-a)u` and
`B(1/2,3/2)=pi/2`, followed by integration by parts; their
normalized recurrence is `c_j/c_(j-1)=(2j-1)/(2j+2)`.
Equation (21) is a finite rational expression for integer `k`,
so no floating-point quadrature or tip truncation is involved.
These finite experiments are not the justification of (15).

The proof still requiring human review consists of the ordinary
complex/real analysis in Sections 1--7: series differentiation and
integration, the inverse-map and slice argument, dominated convergence,
the arctangent and sine inequalities, the improper substitutions, and
the uniform combination and convergence. No failure or invalid
manuscript assertion was identified in this shard, so no artificial
`F_...` refutation claim is created. The required next step is
Host-invoked independent Reviewer replay of precisely these statements.

Replay the exact obligations from the campaign root with
`python3 research/uniform_slice/verify.py`. The completed real Lean run
used Lean 4.31.0, returned `exit_code=0`, `audit_exit_code=0`, and
`proof_holes=[]`, and recorded `C_SCALAR_CORE` as `closed_kernel`.
Its immutable ledger archive is named in `exact_certificate.json`.
To obtain a new compiler result rather than merely replaying the recorded one:

```bash
$WORKSPACE/argus-live-update/.venv/bin/python -m argus_skill.verticals.math.lean_evidence verify research/uniform_slice/Main.lean --statement-fidelity research/uniform_slice/statement_fidelity.md --claim C_SCALAR_CORE --project-root .
```
