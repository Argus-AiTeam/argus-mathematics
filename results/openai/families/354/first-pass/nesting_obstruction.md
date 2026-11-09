# Exact verification theorem for the nesting obstruction

## Result and scope

This work verifies the quantitative implication in `sections/nesting.tex`
and `sections/numerics.tex`, not the complete isoperimetric classification.
The numerical certificate is an integer-arithmetic proof, not sampling.
The geometric and analytic arguments below are ordinary mathematical proofs;
only the declarations identified in `statement_fidelity.md` are Lean proofs.
Independent Reviewer acceptance and a novelty determination are not claimed
by the Engineer.

**Nested-slice obstruction theorem.** Let \(16/25\le h\le9/4\). Suppose
a family \(E_z\subset[0,1]^2\), \(0\le z\le1\), has the following properties.

* The sets are nested down-sets, \(E_z\subset E_0\), with nonincreasing,
  absolutely continuous area \(v\), \(v(0)=s<1\), \(v(1)=0\), and
  \(\int_0^1v(z)\,dz=1/\pi\).
* Except at finitely many levels, each nonempty separating curve is regular
  and is either an occupied-corner curve, an opposite-corner-complement
  curve, or a decreasing strip graph across either coordinate. Corner
  curves have the usual relative planar isoperimetric bounds. The bottom
  complement is bounded by the two adjacent sides at \((1,1)\) and a
  monotone rectifiable arc with positive side extents \(L_x,L_y\).
* On regular nonempty curves there is a measurable \(0<\alpha\le1\) with
  \[
  \int\alpha\,d\ell=hv,\qquad
  -v'=\int\frac{\sqrt{1-\alpha^2}}{\alpha}\,d\ell,\qquad
  A=\int_0^1\int\frac1\alpha\,d\ell\,dz<\infty .
  \]
  Empty and exceptional levels contribute zero. The bottom relative
  perimeter is \(p(0)=hs\).

Then
\[
                 A\ \ge\ 1+\frac9{100000}\ >1.
\]
No minimizing property, genus bound, or external classification theorem is
assumed in this theorem. Establishing these hypotheses for every
nonstandard torus minimizer is a **separate geometric dependency**. In
particular this is not a proof of the main torus theorem from scalar data
alone.

The manuscript already asserts the strict obstruction and its table
implies this same numerical margin. The contribution here is independent
exact replay of the entire continuum certificate and kernel-checked
global cap minimization and interpolation, with the geometric hypotheses
exposed. No improved numerical bound or new classification result is
claimed. Whether this independent certification meets the publishable
novelty bar remains an independent Reviewer question.

## Proof

Write \(\lambda=49/50\), \(\ell=7/25\), \(D=\sqrt{48}/7\), and
\[
g(x)=\frac{1-\lambda x^2}{\sqrt{1-x^2}},\qquad
G(x)=g(\min\{x,D\}).
\]
Here the last formula uses the constant value \(g(D)=\ell\), even for
\(x\ge1\). Differentiation gives
\[
-\frac{d}{dr}g(\sqrt r)=\frac{.48-.49r}{(1-r)^{3/2}}.
\]
Thus \(G\) is nonincreasing, \(\ell\le G\le1\), and \(G\le g\) on
\([0,1)\). These statements also fix the sign of every perimeter
substitution below.

### Flux and the baseline

For \(0\le J\le1\) put
\[
 f_J(x)=x^{-1}-\lambda x-J\sqrt{1-x^2}/x.
\]
Its second derivative obeys
\[
x^3f_J''(x)=2-J(2-3x^2)/(1-x^2)^{3/2}\ge0.
\]
Indeed \((2-3r)/(1-r)^{3/2}\) decreases from 2 to 0 on \([0,2/3]\),
with derivative \(-3r/[2(1-r)^{5/2}]\), and is nonpositive afterwards.
The function is continuous at \(x=1\). With arclength probability measure
and mean \(m=hv/p\), Jensen at \(J=G(m)\) yields
\[
 \int\alpha^{-1}\,d\ell-\lambda hv
 \ge G(hv/p)(-v').
\]
For \(m<1\), \(f_J(m)=\sqrt{1-m^2}(g(m)-G(m))/m\ge0\);
for \(m=1\), \(f_J(1)=1-\lambda>0\). Finite coarea area supplies the
needed integrability almost everywhere; infinite slice integrals are
handled by the corresponding nonnegative extended inequality.

Reflection of a corner across its two adjacent sides gives
\(p^2\ge\pi v\), or \(p^2\ge\pi(1-v)\) for the complementary corner.
A strip graph in either orientation has length at least 1. Consequently
\[
p\ge p_*(v)=\min\{\sqrt{\pi v},1,\sqrt{\pi(1-v)}\}.
\]
Since \(G\) is nonincreasing, the valid comparison is
\(G(hv/p)\ge G(hv/p_*(v))\), not the reverse. Absolute-continuity
substitution for \(v\), including plateaus, now gives
\[
A-1\ge B(h)+\ell(s-t),\qquad
B(h)=\lambda h/\pi+\int_0^tG(hv/p_*(v))\,dv-1,
\]
where \(h^2t^2=\pi(1-t)\), \(0<t<1\). The bottom corner inequality
\(hs\ge\sqrt{\pi(1-s)}\) gives \(s\ge t\).

### Calibration, both orientations, and the capped interval

Use complementary-corner coordinates \((\xi,\eta)\). Along its arc,
\(d\xi\ge0,d\eta\le0\). Pairing the tangent with the unit vector
\((\eta/L,-\sqrt{1-\eta^2/L^2})\), for \(L=L_y\), gives
\[
hs\ge\frac1L\int\eta\,d\xi-\int\sqrt{1-\eta^2/L^2}\,d\eta
   =\frac{1-s}{L}+\frac{\pi L}{4}.
\]
Exchanging the coordinates gives exactly the same bound for \(L_x\).
This argument needs monotonicity, not convexity or \(L_x=L_y\).
Both extents are therefore at least
\[
\frac2\pi\left(hs-\sqrt{h^2s^2-\pi(1-s)}\right).
\]
Containment bounds the smaller endpoint of either strip orientation by
\[
e\le1-2ht/\pi+QY,\qquad
Y=\sqrt{s-t},\quad Q=\frac2\pi\sqrt{\pi+2h^2t}.
\]
To see this, the discriminant equals
\((\pi+2h^2t)Y^2+h^2Y^4\), whose square root is at most
\(\sqrt{\pi+2h^2t}Y+hY^2\); the quadratic slack cancels.

In the central range \(1.02\le h\le1.62\) define
\[
a_0=1/\pi,\ b_0=1-1/\pi,\quad
u=\min\{b_0,.96/h\},\quad P=u-1+2ht/\pi,
\]
\[
d=.21,\quad c=2.7,\quad
\delta=\min\{d,(P-QY)_+\},\quad
H(q)=\min\{q^2,\pi(1-q)/(cd)\}.
\]
The inequalities \(u-d\ge1033/2700>.38>a_0\), \(u\le b_0\),
\(hu\le.96\), and \(h^2u^2<1\le\pi(1-u)\) imply
\([u-\delta,u]\subset[a_0,b_0]\cap[0,t]\).
If \(\delta>0\), put \(q=(v-u+\delta)/\delta\). Containment gives
the strip endpoint bound \(f(1)\le u-\delta\).

For an occupied corner,
\(p^2-1\ge\pi v-1>.14>cd^2\ge c\delta^2H(q)\).
For a complementary corner,
\[
p^2-1\ge\pi(b_0-v)\ge\pi\delta(1-q)
        \ge c\delta^2H(q).
\]
This includes \(q=1,u=b_0\), where \(H=0\).
For a strip in either orientation,
\[
\int_0^1x|df|=v-f(1)\ge\delta q=:j.
\]
With \(k=2.5j\le.525\), tangent calibration gives
\[
p\ge kj+\int_0^1\sqrt{1-k^2x^2}\,dx
\ge1+\left(\frac{35}{24}-\frac{25j^2}{16}\right)j^2
\ge1+1.35j^2.
\]
The square-root bound used here is
\(\sqrt{1-w}\ge1-w/2-w^2/5\) for \(0\le w\le.525^2\).
Its right side is positive, and its square minus \(1-w\) is
\(w^2(-3/20+w/5+w^2/25)\le0\).
The polynomial in parentheses is increasing and negative at the right
endpoint. Jacobian independently enclosed it on this entire interval;
`verify.py` also checks the endpoint argument with rational arithmetic.
Thus, for all three types, including orientation or type changes,
\[
                         p^2\ge1+c\delta^2H(q).
\]

### The area gain and its exact minimization

On \(0\le X\le.96\),
\[
\frac{.48-.49X^2}{(1-X^2)^{3/2}}\ge .91X.
\]
An exact elementary proof divides by \(X>0\), writing the result as
\[
\frac{.49-.01/(1-X^2)}{X\sqrt{1-X^2}}.
\]
On intervals \([0,.84],[.84,.89],[.89,.94],[.94,.96]\), valid
numerator lower bounds are \(.456,.44,.40,.36\), and denominator
upper bounds are \(.50,.46,.41,.33\). Each ratio exceeds .91.
All eight bounds, and their rational margins, are replayed.

Let \(M=\int H\), \(q_m=\int qH/M\), and \(p_2=1+cd^2\max H\).
The unique branch crossing \(\theta\) satisfies \(cd\theta^2=\pi(1-\theta)\).
Integration gives
\[
M=\theta^2(3-\theta)/6,\quad
q_m=(2+2\theta-\theta^2)/(2(3-\theta)),\quad
p_2=1+cd^2\theta^2.
\]
Rational comparison gives \(32/37<\theta<13/15\), hence
\(M>.2659,\ q_m>.697,\ p_2<1.09\). The coefficient bound is
\[
\frac{.91cM}{p_2^{3/2}}
 [h(u-(1-q_m)d)]^3\ge C_0(h):=\min\{.134h^3,.36\}.
\]
For completeness the prefactor exceeds .574: after squaring, the margin
is \(14121304169/10^{14}>0\). Put \(\beta=.303d=.06363\).
On the constant-\(u\) branch \(u-\beta>.617\) and
\(.574(.617)^3>.134\). On the reciprocal branch
\(h(u-\beta)>.856\) and \(.574(.856)^3>.36\).

Writing \(K=c\delta^2H(q)\), the derivative bound implies
\[
G(hv/\sqrt{1+K})-G(hv)
\ge .91(hv)^3K/(1+K)^{3/2}.
\]
Here \(hv\le.96<D\), so no clipped branch is being differentiated.
Integration in \(v\), followed by Jensen for \(v^3\) with density \(H/M\),
gives an additional \(C_0\delta^3\). The case \(\delta=0\) contributes
zero and never divides by \(\delta\). Therefore
\[
A-1\ge B(h)+S(h),\qquad
S(h)=\inf_{y\ge0}\{\ell y^2+C_0\min(d,(P-Qy)_+)^3\}.
\]

All coefficients \(P,Q,C_0\) are positive. In particular \(P>83/1188\).
Set
\[
q_*=\frac{2P}{1+\sqrt{1+6C_0Q^2P/\ell}},\qquad
F(w)=\ell(P-w)^2/Q^2+C_0w^3.
\]
Then \(0<q_*<P\), \(F'(q_*)=0\), and
\[
S=\min\{C_0d^3,F(q_*)\}.
\]
This formula includes infeasible \(q_*>d\): then
\(F(q_*)\ge C_0q_*^3>C_0d^3\), so the cap wins.
If \(P<d\), the infeasible cap candidate exceeds
\(F(P)\ge F(q_*)\), so the uncapped candidate wins. Equality at either
threshold is harmless.
An algebraic global-minimum proof, valid for arbitrary positive
coefficients, is formalized in Lean. Its key identity, with
\(a=\ell/Q^2\), is
\[
F(w)-F(q_*)=(w-q_*)^2[a+C_0(w+2q_*)]\quad(w\ge0).
\]
For \(w\le0\), \(a(P-w)^2\ge aP^2=F(0)\ge F(q_*)\).
This proves the global bound and attainment, not just stationarity.

### Continuum control of the baseline

Let \(\rho\) invert \(v/\sqrt{\pi(1-v)}\):
\[
\rho(k)=\sqrt\pi\,k\sqrt{1+\pi k^2/4}-\pi k^2/2.
\]
Then \(t=\rho(1/h)\). With \(W=-G'\ge0\) on \([0,D]\) and
\(\int W=.72\), layer cake gives
\[
B+1=\lambda h/\pi+\ell t+
\int_0^D W(X)\min\{\pi(X/h)^2,X/h,\rho(X/h)\}\,dX .
\]
This follows by inverting the increasing
\(hv/p_*(v)=\max\{h\sqrt{v/\pi},hv,hv/\sqrt{\pi(1-v)}\}\);
the restriction \(v\le t\) is redundant for \(X\le D<1\).

The selected branches, as \(h\) increases, are \(\rho(X/h)\),
\(X/h\), and \(\pi(X/h)^2\), with switches at \(X/h=b_0,a_0\).
Since \(\rho\) is increasing and concave and \(k\rho'(k)\le1\),
its second \(h\)-derivative is at most \(2/h^2\). The selected
linear and quadratic branches have second derivatives at most \(2/h^2\):
the latter uses \(6\pi k^2\le6/\pi<2\).
At the first switch \(\rho'(b_0)=2/(\pi+1)<1\), so the first
\(h\)-derivative jumps down; at the second it changes from
\(-a_0/h\) to \(-2a_0/h\), also down.
Thus on \([a,b]\), subtracting \(h^2/a^2\) makes every selected
function concave. The same holds for \(t\), and the weights sum to
\(\ell+.72=1\). Hence \(B\) has upper second derivative \(2/a^2\),
including the formula switches.

### Continuum control of the gain

For each fixed \(y\ge0\), put
\[
F_y=\ell y^2+C_0\min\{d,(u-1+R-Qy)_+\}^3,\quad R=2ht/\pi.
\]
Direct implicit differentiation gives
\[
R'=\frac{2t^2}{\pi(2-t)},\quad R''\le0,\quad
\frac{Q'}Q=\frac{2h}{\pi+4h^2},\quad
\frac{Q''}Q=\frac{2\pi-4h^2}{(\pi+4h^2)^2}.
\]
In particular \(0<Q'/Q\le1/(2h)\), \(Q''/Q\ge-1/(4h^2)\).
On the central interval, rational endpoint substitution gives
\(.64<t<.8,\ t(1.62)<.65,\ .19<R'<.34,\ R<.671\).
On an active cubic branch \(w=u-1+R-Qy\in(0,d)\),
\(0\le Qy<P<.36\). The reciprocal branch of \(u\) starts after
\(h=1.4\). Consequently
\[
-.50<w'<.34,\qquad w''<.8.
\]
On the constant branch the stronger lower bound \(w'>0\) follows.
Also \(0<C_0\le.36,\ 0\le C_0'\le1.08,\ 0\le C_0''\le2.16\)
on each smooth piece. The product rule therefore yields
\[
(C_0w^3)''
\le2.16d^3+6(1.08)d^2(.34)+6(.36)d(.50)^2+3(.36)d^2(.8)
=.26866728<.4.
\]
On zero pieces the second derivative is zero, and on capped pieces it
is at most \(2.16d^3<.4\).

At switches, both \(u'\) and \(C_0'\) jump only down. At \(w=0\)
the cubic and its derivative vanish. At \(w=d\), entering a cap deletes
a nonnegative derivative and leaving it adds a nonpositive derivative.
More explicitly, the contributions from the left and right are
\(3d^2\max(w'_-,0)\) and \(3d^2\min(w'_+,0)\); their difference is
nonpositive since \(w'_+\le w'_-\). Simultaneous changes in \(C_0\)
add \(d^3\Delta C_0'\le0\). This includes tangencies and coincident
switches. Branches are algebraic; threshold sets have finitely many
components unless a threshold holds identically, where these same
matching derivatives apply.
Thus \(F_y-.2h^2\) is concave. Taking the pointwise infimum preserves
concavity (its hypograph is the intersection of convex hypographs), so
\(S\) has upper second derivative .4 on the whole central interval,
including changes of its minimizing \(y\).

### Exact evaluation and every interpolation interval

`verify.py` uses only integer operations, `Fraction`, and integer square
roots. It constructs outward intervals on the grid \(10^{-40}\) for
every operation, including even powers crossing zero and coordinatewise
minima. The manuscript's 24 knot values and 16 applicable gains are
computed independently, rather than read from the certificate.

Machin's identity, odd alternating arctangent sums of lengths 32 and 10,
proves \(3.14159265358979<\pi<3.14159265358980\).
Twice applying the arcsine half-angle identity gives
\(\arcsin z=4\arcsin j_z\), \(j_z<.36\). In fact
\(j_D^2=(1-2/\sqrt7)/2<1/8\), since \(64>63\).
Eleven positive series terms and the bound
\(4j_z^{23}/(1-j_z^2)\) enclose the tail.
Integration by parts gives the \(L_n,J_j\) recurrences reproduced in the
code; differentiating them recovers the original moment integrands.

The only approximation to the layer-cake integral replaces \(\rho\)
on \([b_0,D/h]\), when nonempty, by its midpoint cubic. Since
\[
\rho''''(k)=-15\sqrt\pi(\pi/4)^2k/(1+\pi k^2/4)^{7/2},
\]
its magnitude decreases for \(6(\pi/4)k^2\ge1\). The exact squared
endpoint comparison in the verifier proves \(|\rho''''|<4\).
The integrated Taylor remainder is at most
\(.72\cdot4(L/2)^4/24=.0075L^4<.008L^4\).
For rational interpolation use
\[
E(h)=.008\max\{.989743318611/h-(1-1/\pi_-),0\}^4.
\]
The verifier checks that this is a conservative upper error bound.

If \(f-Kh^2/2\) is concave on \([a,b]\), its chord gives
\[
f(h)\ge\min\{f(a),f(b)\}-K(b-a)^2/8 .
\]
Use \(K=2/a^2\) outside the central range and \(K=2.4\) inside,
where \(2/(1.02)^2+.4<2.4\). The script checks, for **all 23**
successive knot intervals, the corrected endpoint values minus this
interpolation loss, including every formula switch. The minimum rational
lower bound is \(9/100000\), attained by the two certificate intervals
\([1.42,1.46]\) and \([1.46,1.50]\).
This proves the stated theorem for every curvature in the closed interval.

## What remains unproved here

The full torus classification still requires the classical structure
input, reflection and strict-normal reduction, regularity/coarea setup,
the parameter interval, the other endpoint exclusions, and the
two-volume argument. The dependency graph leaves these visible rather
than treating a scalar certificate as a certificate of all geometry.
Primary-source acquisition and numbering limitations are recorded in
`literature/source_grounding.txt` and in the assumption ledger.

The baseline-only route is genuinely insufficient: its value at
\(h=73/50\) is negative, with no Taylor error on that branch. The current
result supplies the needed nesting gain instead of reopening that route.
No false literal manuscript assertion has been established by this
audit; no `F_` refutation claim is fabricated. A discrepancy found by
independent review must be entered as its own literal `F_` claim.

## Replay

Run `python3 verify.py` from this directory or another working directory.
The result is compared to `exact_certificate.json`, not merely printed.
`--write` regenerates that certificate from the computations.
The saved Jacobian request and typed answer are additional corroboration;
the rational proof of the strip estimate does not depend on Arb.
The official `lean_evidence` run used Lean 4.31.0 and returned compiler
exit code 0, axiom-audit exit code 0, and `proof_holes=[]`. Its claim-bound
certificate is
`research/lean/certificates/L_FORMAL_ALGEBRA-215a062a6a220107.json`.
The delivered root source and fidelity text match the compiler-certified
copies in `research/lean/` byte for byte. This closes only the formal
algebra/interpolation subclaim; it is not a kernel proof of the whole
nested-slice theorem.
