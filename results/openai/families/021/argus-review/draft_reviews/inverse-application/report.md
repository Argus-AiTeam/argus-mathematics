# Conditional application to the manuscript inverse proposition

**Engineer assessment: supported conditionally, with the original order of
quantifiers.** This does not certify the other propositions used for a
uniform quadratic Jacobsthal bound.

## Exact target and versions

The source is `9000021/research/inverse_certificate/REPORT.md`, "Application
to the manuscript, with the original quantifiers", compared against staged
`inverse.tex`, Proposition `prop:inverse`, in the September 25, 2026
manuscript, revision `4eaee87548250b2682affda7d05d947c05554bae`.

For arbitrary prescribed classes and a full regular candidate box, fixed
parameters, witnessing threshold `delta>0`, and `0<sigma<1`, there exist
`cp>0,F<infinity,xi_inv>0` **before** choosing fixed
`0<xi<=xi_inv`. For sufficiently large `z` depending on that fixed width,
the whole candidate box has a list of at most `F` reduced rationals with

```
D<=R*Z^10, |A|<=S*R*Z^10,
#{p in P: D*a_p=A (mod p)}>=cp*n.
```

Outside normalized harmonic measure at most `sigma` relative to the whole
box, every edge satisfying the stated discrepancy
`|N_pqu-N_pq/u|>delta*Y*V0/(p*q*u)` aligns at `p` with a listed intercept
and has `D*q_E<=R*Z^10`. This is the exact inverse-step target, not a
statement that every bad triple is structured without an exceptional set.

Historical `C_INVERSE` v1/v2 has the same natural statement and content
reference; v2 exposes `A_REGULAR_BOXES`. `C_INVERSE_APPLICATION` v1 records
the conditional asymptotic bridge. They are target and application of the
same argument, not two independent proofs. Active `R_APPLICATION` explicitly
retains the upstream assumptions recorded for
[analytic-sampling](../analytic-sampling/report.md).

## Quantifiers and finite hypotheses

Write `L=log z`, `Z=exp(L/log L)`, `R=z^alpha`,
`S=z^(2-alpha+o(1))`, with fixed
`0<alpha_min<=alpha<=alpha_max=1/100`.
The sampling unit supplies

```
|X|>=S/Z^4, r>=c5*n, K<=n*R/L^6,
n comparable to xi*R/log R.
```

The constants are selected as in the source:
`beta=sigma/16`,
`gamma_inc=(beta/2)*(beta/4)^h1`,
`c5=gamma_inc/8`, `cp=c5/4`, with fixed
`a_star*h1/2>12`. They do not depend on the failure set, refined cell,
sample, or eventual width. The whole-box list uses the original caps,
not smaller caps selected from the extracted line.

Take the integer parameters

```
d=floor(R/L^2), m=ceil(S/(R*Z^6)),
r=ceil(c5*n), t=ceil(cp*n),
H_D=floor(R*Z^10), H_A=floor(S*R*Z^10).
```

Richness is integer-valued, so its real threshold implies the stated
ceiling for `r`. Likewise `t` is exactly the integer alignment threshold
corresponding to `cp*n`, not a newly chosen list.

## Checking every asymptotic bridge

**Line height and roundings.** Let `x=S/(R*Z^6)`. Its exponent is
`2-2*alpha+o(1)>0`, so `x` tends to infinity and
`m-1>=x/2` eventually. Thus `H=floor(S/(m-1))<=2*R*Z^6`.
The extra `Z^4` room gives `H<=H_D` and `2*S*H<=H_A` even after
flooring, once `z` is large. Choose fixed integers `e,C` satisfying
`alpha_min*(e+1)>alpha_max` and `alpha_min*(C+1)>2`.
These ensure `R^(e+1)>H` and `R^(C+1)>S` uniformly over boxes.
Their choices precede `xi`.

**Nonlinear and short-line losses.** The cubic unit bounds the nonlinear
loss by `512*d^3*(1+ceil_cuberoot(S^2))`. Relative to `S/Z^4` its main
power is

```
z^((10*alpha-2)/3+o(1)).
```

At `alpha<=1/100` this exponent is at most `-19/30`; the term without
`S^(2/3)` is smaller. Also
`d*(m-1)<=S/(L^2*Z^6)=o(S/Z^4)`. Consequently the strict finite
line-extraction inequality `|X|>E+d*(m-1)` holds. This is a uniform
power saving on the fixed compact exponent range.

**Polynomial coefficient box and vanishing.** With
`v=(d+1)*(d+2)/2`, the congruence construction admits

```
log(2*h)<=log 4+2*K*log(2R)/(d+2)=O(R/L^4).
```

The index constraint and coefficient nontriviality are proved in the
[polynomial unit](../polynomial-concentration/report.md). Then
`log(v*h*S^d)=O(R/L)=o(R)`, while
`r*log R` is at least a positive multiple of `c5*xi*R`.
For each fixed positive `xi`, the latter eventually exceeds the former.
No lower bound independent of varying `xi(z)` is being used.

**Strict collision margin.** We have `r-e-t>=0` eventually, and
`(r-e-t)/n -> c5-cp=3*c5/4>0`. Normalizing the finite left side by
`n^2*m^2` gives

```
K*(C+n/m)/n^2
 <= C*R/(n*L^6)+R/(m*L^6)
 = O_xi(L^-5)+z^(3*alpha-2+o(1)) -> 0.
```

This establishes the strict inequality in (F), not merely a comparison
of leading exponents without a positive right-side margin. It applies to
all `N>=m` because `n/N<=n/m`.

**The original list's size.** Its determinant cap is
`2*S*R^2*Z^20=z^(2+alpha+o(1))`. A fixed integer `B` with
`alpha_min*(B+1)>2+alpha_max` bounds common aligning primes.
Since `n` tends to infinity for each fixed width,
`n>=2*B/cp^2` eventually and `t^2>=2*B*n`.
The finite packing bound gives `M<=2/cp^2`, so
`F=ceil(2/cp^2)` is independent of `xi`. This bound was not obtained by
enumerating a sample-dependent list.

Every hypothesis of the finite contradiction is now supplied. The
sampling unit preserves nonstructuredness, whereas the finite unit makes
all-nonstructured richness impossible. Its initial losses are measured
relative to the whole box, and its later refinement loss relative to
the retained initial cell. Therefore the contradiction bounds the original
whole-box harmonic bad mass, not only a fraction of bad edges.

## Evidence, attribution, and remaining obligations

The source's corresponding argument was read, including the original
quartic nonlinear ratio `(13*alpha-2)/3` and the difference-product
calculation. The old draft supplies explicit finite inequalities and uses
the sharper cubic bookkeeping. It is an independent reconstruction/local
verification in the mathematical sense, not a new counterexample or an
established original global theorem.

The shared exact replay checks finite numerical inequalities, fixed
constants and exponent identities. The fresh Lean replay checks finite
counting/arithmetic and rational exponent inequalities, not limits,
uniformity, or order of quantifiers. Neither substitutes for the prose
checks above. Actual toolchain and outputs are in
[finite-rigidity/report.md](../finite-rigidity/report.md).

No concrete failure was identified in this conditional application.
Removing the conditional qualification would require verification of the
regular-box construction and analytic inputs; concluding the Jacobsthal
theorem would additionally require the reference, prime-path, survivor,
variance, stopping and assembly obligations. They remain outside this
draft's supported scope. Final independent acceptance is pending.
