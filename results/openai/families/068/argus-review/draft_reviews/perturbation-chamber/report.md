# Simultaneous perturbation chamber and endpoint sharpness

**Assessment:** the stated chamber is supported in both directions
under the exact toroidal hypotheses. The global family satisfies
those hypotheses and realizes its asserted endpoint. Neither
assertion is a counterexample to the original prescribed correction.

## Exact claim, provenance, and parameter range

Old report section 7, Theorem B and its following construction,
comprise `C_TV_SHARP_CHAMBER` v1. They are proposed structural
refinements of the September 26, 2026 G toroidal-volume theorem,
revision `4eaee87548250b2682affda7d05d947c05554bae`, not statements
already attributed to that source. Their novelty was and remains
unverified.

Retain **all** the original model, smooth semipositive metric,
full generic rank, and resolution hypotheses in the volume unit.
Let \(S\) be **any finite set of toroidal base-boundary primes**
whose **entire** pullbacks are \(p\)-exceptional. For every choice
of rational \(b_Q\geq0\), put
\[
 C_b=A_0+\sum_{Q\in S}b_QQ,\qquad
 \varepsilon_Q=\lambda_Q-a_Q=\min(\lambda_Q,1)>0.
\]
The density metric on \(-K_Y+C_b\) remains semipositive, with
exceptional correction, the smooth-open conclusion, and the
original conditional ordinary-open strictness conclusion. Its
root-frame squared norm is locally integrable **everywhere**
if and only if
\[
                 b_Q<\varepsilon_Q\quad\text{for every }Q\in S.
\]
In this range \((W,-K_{W/X}+f^*C_b)\) is sub-klt at every
divisorial valuation. Endpoints are excluded. This claim neither
uses arbitrary nontoroidal divisors nor quantifies over irrational
coefficients.

## Semipositivity and sufficiency, including intersections

Adding \(\sum b_Q\log|t_Q|^2\) to the extended original weight is
the divisor-metric operation for this line. Nonnegative coefficients
add positive divisor currents, so it remains semipositive for
**all** the stipulated \(b\), not only the integrable ones.
Away from the correction its smooth curvature is unchanged.
The finite exceptional-pullback hypothesis gives exceptionality;
shrinking the original ordinary patch off these divisors preserves
a nonempty patch.

For a branch \(E\to Q\in S\),
\[
 \operatorname{coeff}_E\Theta_b
       =-a_E+e_E(a_Q+b_Q)<1
 \quad\Longleftrightarrow\quad
 a_Q+b_Q<(1+a_E)/e_E.
\]
All these inequalities for one \(Q\) hold exactly when
\(b_Q<\lambda_Q-a_Q\); the minimum is attained in a nonempty
finite collection. Positivity of \(\lambda_Q\) follows from
\(a_E\geq0\), \(e_E>0\).

The reason there are no hidden intersection constraints is
**not** the displayed one-prime inequalities by themselves.
Toroidality puts every component of each \(f^*Q\), \(Q\in S\),
inside the full reduced boundary \(D_W\). Under the strict
inequalities \(B_b=D_W-\Theta_b\) has strictly positive
coefficients on all of \(D_W\); outside \(D_W\), the perturbation
has no support and \(\Theta_b=-K_{W/X}\leq0\).
The divisor is effective rational Cartier, since both
\(K_W+D_W\) and \(K_W+\Theta_b=p^*K_X+f^*C_b\) are
rationally Cartier. Thus
\[
 A_{W,\Theta_b}(v)=A_{W,D_W}(v)+v(B_b)>0
\]
for every centered divisorial valuation, just as in the volume
unit. The full-support term handles centers at all boundary
intersections. Log resolution and proper projection of the
corrected nonnegative measure now prove integrability.

## Necessity and exact endpoints

If any inequality fails, select a branch \(E\to Q\) attaining
\(\lambda_Q\). At its general smooth point, away from other
correction divisors and Jacobian components, the upstairs density
is a bounded positive unit times
\[
 |u_1|^{2\gamma}\,dV_u,\qquad
 \gamma=a_E-e_E(a_Q+b_Q)\leq-1.
\]
The radial integral diverges on every transverse neighborhood.
At equality it is \(\int dr/r\), so the failure is logarithmic,
not an unresolved limiting case. Tonelli and the projection
identity make the base mass infinite in a neighborhood of a
general point of \(Q\). That suffices to refute integrability
at every point of the base. Other primes cannot cancel an infinite
nonnegative contribution. This is a proof of necessity, not just
finite evidence that a selected endpoint fails.

## Check of the global sharpness construction

For every integer \(c\geq2\) and \(r\geq0\), the old construction is
\[
 Y=\operatorname{Bl}_{x_0}\mathbb P^c,\quad
 W=Y\times\mathbb P^r,\quad X=\mathbb P^c\times\mathbb P^r,
 \quad p=\beta\times\mathrm{id},\quad f=\operatorname{pr}_Y,
\]
with \(x_0\) a torus-fixed point, exceptional divisor \(D\subset Y\),
and \(\rho=\mathrm{id}\). Each original premise checks separately:

| Premise | Check |
|---|---|
| Smooth connected projective \(X,Y,Z=W\), normal integral \(W\), positive base dimension | Blowup of smooth \(\mathbb P^c\) at a point and products with \(\mathbb P^r\); \(\dim Y=c\geq2\). |
| Projective birational \(p\); projective surjective equidimensional toroidal \(f\) | Product of the blowup with the identity; smooth projection with fiber \(\mathbb P^r\). Standard smooth toric embeddings are strict, and the product projection is toroidal. |
| Smooth semipositive coefficient metric | Product Fubini-Study metric on \(-K_X=\mathcal O(c+1,r+1)\); the \(\mathbb P^0\) factor is a point when \(r=0\). |
| Relative canonical order | Blowup center \(\{x_0\}\times\mathbb P^r\) has codimension \(c\), so \(K_{W/X}=(c-1)(D\times\mathbb P^r)\). |
| Full generic adjoint rank one | \(f_*\mathcal O_W(K_{W/X})=\mathcal O_Y((c-1)D)\), using \(H^0(\mathbb P^r,\mathcal O)=\mathbb C\), also for \(r=0\). |
| Exceptional entire pullback | \(D\times\mathbb P^r\) maps to \(\{x_0\}\times\mathbb P^r\), codimension \(c\geq2\) in \(X\). |
| Horizontal strictness patch | Away from \(D\), \(p\) is locally an isomorphism and the coefficient curvature is positive; on a smaller patch it dominates a positive base form by some positive constant. |
| Exact correction and room | Over \(D\), \(a_E=c-1,e_E=1,\lambda_D=c,a_D=c-1,\varepsilon_D=1\). Every other prime has \(a_E=0,e_E=1\), so its correction vanishes. |

In the chart \(\beta(u,z_2,\ldots,z_c)
=(u,uz_2,\ldots,uz_c)\), the determinant is \(u^{c-1}\).
Product fiber integration leaves a positive smooth unit times
\(|u|^{2(c-1)}\). Correcting by \((c-1+s)D\) leaves
\(|u|^{-2s}\), integrable exactly for rational \(s<1\) in the
stated nonnegative parameter range; at \(s=1\) it diverges
logarithmically. The original prescribed correction has \(s=0\)
and remains integrable. This checks an all-dimension geometric
family, not merely an exponent detached from a model.

This family realizes the one-prime endpoint \(1\); it does not
claim to realize every possible chamber vector or every
\(\lambda_Q<1\). The general simultaneous statement is proved
by the full-support argument above.

## Evidence limits and attribution

The shared replay passed its exact threshold and sampled
intersection-weight cases and reproduced the historical symbolic
determinant identity. These are finite checks of arithmetic and
the checker, not a proof of all valuations or construction of this
family. The shared Lean statements prove the conditional sharp
prime inequality, full-support sign implication, and numerical
blowup endpoint, not toroidal geometry or analytic divergence.
The historical ledger route `R_TV_SHARP_CHAMBER` binds formal-core
v1, not the later v3 compiler-backed source. That provenance is
preserved in the index; the fresh retained-source replay is separate
review evidence, not an automatic update to the old route.

No gap was identified under the exact hypotheses. Extending the
chamber to arbitrary nontoroidal divisors would require new
intersection/discrepancy control and is not justified by this
argument. Dropping entire-pullback exceptionality would lose the
claimed disposable correction. Those are explicit boundaries,
not repairs attempted here. Classical threshold and discrepancy
ingredients are not asserted new; priority and significance of
the particular refinement remain unverified. Native independent
acceptance is pending.
