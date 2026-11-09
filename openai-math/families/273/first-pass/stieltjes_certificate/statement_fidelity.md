# Reading of the formal boundary-derivative certificate

The source `Main.lean` describes real scalar algebra, not the whole
analytic Stieltjes representation. Its principal declaration is
`StieltjesBoundary.boundary_density`.

Its variables `p`, `q`, and `h` range over all real numbers. Its only
hypotheses are `1 < p`, `0 < h`, and `h < 1`. There is deliberately no
hypothesis on `q`: the algebraic sign theorem holds even without `q>0`.
The manuscript application has the stronger conditions `q>0`,
`pi/2<p<pi`, and `h=tanh(q)`. Consequently its actual boundary parameters
satisfy every formal hypothesis.

The definitions denote the following exact rational expressions:

- `jacobian p q h` is `J=p^2+q^2*h^2-q*h`.
- `pDot p q h` is `P=-p*(h+q*(1-h^2))/J`.
- `radius p q h` is `r=(1-h^2)*(p^2/h^2+q^2)`.
- `height p h` is `d=p/h`.
- `densityDenom p q h` is `K=(q*h-1)^2+d^2`.
- `heightDot p q h` is `P/h-p*(1-h^2)/h^2`.
- `radiusDot p q h` is the formal chain-rule expression
  `2*p*P*(1-h^2)/h^2-2*p^2*(1-h^2)/h^3
   +2*q*(1-h^2)-2*q^2*h*(1-h^2)`.

`jacobian_pos`, `radius_pos`, `height_pos`, and `densityDenom_pos`
prove strict positivity of those four denominators/weights under their
displayed relevant hypotheses. `heightDot_eq` and `radiusDot_eq` prove
the identities `heightDot=-p*(1+r)/J` and `radiusDot=-2*h*r*K/J`.

`boundary_density` proves all four strict positivities, strict negativity
of both derivative expressions, and the exact density ratio

```
heightDot / radiusDot = (1+r)*d/(2*r*K).
```

Multiplication by the positive factor `1/pi` gives the density in the
analytic theorem. The factor `pi` itself is not a formal variable or a
conclusion of this source.

The definitions with the suffix `Dot` are algebraic expressions, not Lean
derivative predicates. Their equality to the actual derivatives of the
implicit function is proved in section 2 of `proof.md` by differentiation
of `p*tan(p)=-q*tanh(q)` and `h'=1-h^2`. The compiler does not verify that
translation. The formal theorem does verify that these expressions give
strictly decreasing radius and height, and the positive claimed density,
on every allowed scalar specialization.

The compiler also does not verify existence or uniqueness of `p(q)`,
the inverse-sinc branch, the complex contour proof, endpoint limits,
convergence of integrals, reconstruction of the entire measure, the
absence of singular contributions, originality, or EPnI. Those are not
silently inherited from this algebraic certificate. No additional axioms
are declared, and the final `#print axioms` exposes the kernel dependencies.
