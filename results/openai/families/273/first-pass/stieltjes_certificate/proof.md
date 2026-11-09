# The complete Stieltjes measure for the inverse hyperbolic-sinc weight

## Statement

Let
\[
 f(x)=x/\sinh x,\qquad b(x)=x\coth x,\qquad f(0)=b(0)=1,
\]
and initially define \(B(f(x)^2)=b(x)\) for \(x\geq0\).
This note proves the literal assertion `int:stieltjes` in the staged
September 24, 2026 manuscript, and identifies its entire measure.
It does not prove the entropy photon-number inequality.

For each \(q>0\), let \(p=p(q)\in(\pi/2,\pi)\) be the unique root
\[
 p\tan p=-q\tanh q.
\]
Define
\[
 h=\tanh q,\quad a=qh,\quad d=p/h,\quad
 r=r(q)=\frac{p^2}{\sinh^2q}+\frac{q^2}{\cosh^2q},\quad
 K=(a-1)^2+d^2 .
\]

**Theorem.** The function \(r\) is a smooth decreasing bijection from
\((0,\infty)\) onto \((0,\infty)\). The original \(B\) has a
single-valued holomorphic continuation to
\(\Omega=\mathbb C\setminus(-\infty,0]\), real on the positive axis,
with \(B(1)=1\) and \(B'(1)=-1\). On that axis,
\[
 \boxed{\quad
 -B'(s)=\frac1{2s}+\int_0^\infty\frac{w(t)}{s+t}\,dt,\qquad
 w(r(q))=\frac{(1+r(q))d(q)}{2\pi r(q)K(q)}>0 .
 \quad}                                                    \tag{1}
\]
The integral also converges locally uniformly on \(\Omega\).
In particular \(B\) is strictly decreasing. The full representing
measure and its cumulative distribution are
\[
 \nu=\tfrac12\delta_0+w(t)\,dt,\qquad
 \boxed{\ \nu([0,r(q)])=\frac{p(q)\coth q}{\pi}\ }.           \tag{2}
\]
There is no extra singular part and the constant term is zero.
An exact normalization is
\[
 \int_0^\infty\frac{w(t)}{1+t}\,dt=\frac12,\qquad
 \int_{[0,\infty)}\frac{d\nu(t)}{1+t}=1.                    \tag{3}
\]

Compared with the manuscript's existence statement, the added content
is a positive density, a particularly simple distribution function,
and explicit exclusion of every endpoint and singular contribution.
Originality and publication-level significance still require independent
assessment; the source search in `analytic_sources.md` is not a novelty
certificate.

## 1. Selecting the inverse branch without assuming the target lemma

The function \(p\tan p\) has positive derivative
\((p+\sin p\cos p)/\cos^2p\) on \((\pi/2,\pi)\), and its range is
\((-\infty,0)\). Thus \(p(q)\) exists uniquely, is smooth, and has
limits \(\pi\) at zero and \(\pi/2\) at infinity.

Put
\[
 D=\{u=p+iq:q>0,\ 0<p<p(q)\},\qquad A(u)=\sin(u)/u.
\]
 The domain \(D\) is connected: its horizontal sections are intervals,
 all meeting the connected strip \(0<p<\pi/2,\ q>0\).
 The removable value of \(A\) at zero is one. Direct realification gives
\[
 \Re A(u)=\frac{p\sin p\cosh q+q\cos p\sinh q}{p^2+q^2},\quad
 \Im A(u)=\frac{p\cos p\sinh q-q\sin p\cosh q}{p^2+q^2}.
\]
The real part is positive in \(D\): this is immediate before
\(p=\pi/2\), and afterwards is equivalent to
\(p\tan p<-q\tanh q\). The imaginary part is negative. Before
\(\pi/2\) this follows from \(\tan p/p>1>\tanh q/q\);
afterwards the two terms in its numerator have the required signs.
Consequently \(A(D)\) lies in the open fourth quadrant \(Q\).

Here are the boundary and compactness checks needed for a global
inverse. On \(q=0\), \(A\) decreases from 1 to 0; on \(p=0\), it
increases from 1 to infinity. On the curved edge \(p=p(q)\), it is
strictly negative imaginary. Moreover
\[
 |A(p+iq)|\geq\frac{\sinh q}{\sqrt{\pi^2+q^2}}\longrightarrow\infty
\]
uniformly in \(0\leq p\leq\pi\). Thus a sequence whose image stays in
a compact subset of \(Q\) can reach neither a boundary point nor
infinity. This proves properness.

There are no interior critical points, since
\[
 \Im(u\cot u)
 =\frac{q\sin(2p)-p\sinh(2q)}{\cosh(2q)-\cos(2p)}<0,        \tag{4}
\]
where \(\sin(2p)\leq2p\) and \(\sinh(2q)>2q\).
On the other hand \(A'(u)=0\) would force \(u\cot u=1\).
Local holomorphic inversion is therefore available everywhere in \(D\).

For clarity, one-sheetedness can be checked directly, without invoking
the target Stieltjes assertion or a global inverse-sinc theorem.
Properness makes the image relatively closed in \(Q\), whereas local
inversion makes it open. It is nonempty, so connectedness of \(Q\)
gives surjectivity. Every fiber is finite, by properness and isolation
of inverse points. Its cardinality is locally constant: take disjoint
local inverse neighborhoods of the finite fiber; any additional nearby
inverse points would have a convergent subsequence to that same fiber.
Thus the cardinality is constant on \(Q\).

To compute it, let \(z=1-i\epsilon\) tend to 1 from \(Q\).
All preimages tend to \(u=0\): the displayed bound bounds \(q\), and
the only point on the resulting compact closure with \(A(u)=1\) is
zero, by the boundary values and the strict interior sign.
Now \(A(u)=\mathcal A(u^2)\), where
\(\mathcal A(v)=1-v/6+O(v^2)\) has nonzero derivative at zero.
It has a unique local inverse. Squaring is injective in the first
quadrant, so there is at most one preimage near zero. Surjectivity
gives at least one. The constant fiber cardinality is therefore one.
This proves that \(A:D\to Q\) is biholomorphic.

For \(\Im s>0\), choose the principal \(s^{-1/2}\in Q\), set
\(u=A^{-1}(s^{-1/2})\), and define \(B(s)=u\cot u\).
This is holomorphic and has negative imaginary part by (4).
If \(0<s<1\), its limiting parameter is \(u=ix\), where
\(s=(x/\sinh x)^2\); it therefore agrees with the original definition.
If \(s>1\), its limiting parameter is the unique \(u\in(0,\pi)\)
with \(s=(u/\sin u)^2\). These limits are unique, since on the two
straight edges \(A\) takes each positive real value just once.
The derivatives of \(A\) on those edges are nonzero away from zero,
so local inversion extends \(B\) across every positive \(s\ne1\).

At \(s=1\), use \(v=u^2\):
\[
 (u/\sin u)^2=1+\frac v3+\frac{v^2}{15}+O(v^3),\qquad
 u\cot u=1-\frac v3-\frac{v^2}{45}+O(v^3).                 \tag{5}
\]
Local inversion in \(v\) proves extension there and yields the
claimed value and derivative. Reflection extends the function to the
lower half-plane, giving a holomorphic function on \(\Omega\).

## 2. The whole negative-axis boundary and its orientation

On the curved edge, \(p\tan p=-qh\), hence
\[
 \sin p=\frac{qh}{\sqrt{p^2+q^2h^2}},\qquad
 \cos p=-\frac{p}{\sqrt{p^2+q^2h^2}} .
\]
Substituting these identities into \(\sin(p+iq)\) proves
\[
 (u/\sin u)^2=-r(q),\qquad
 \boxed{\ B(-r(q)+i0)=q\tanh q-i\,p\coth q=a-id\ }.        \tag{6}
\]
In particular this is the upper-bank boundary, not its conjugate.

The following exact derivative identities also prove that this boundary
parametrizes each negative-axis point once, with the correct orientation.
Let
\[
 J=p^2+q^2h^2-qh
   =p^2-\tfrac14+(qh-\tfrac12)^2>0.
\]
Implicit differentiation, with \(h'=1-h^2\), gives
\[
 p'=-\frac{p(h+q(1-h^2))}{J},\qquad
 d'=-\frac{p(1+r)}J<0,\qquad
 r'=-\frac{2hrK}J<0.                                    \tag{7}
\]
These are identities for the actual implicitly defined \(p\); the
positivity uses \(p>\pi/2>1\), \(q>0\), and \(0<h<1\).
The algebraic factorizations in (7) are independently checked in
`verify.py` and formalized in `Main.lean`. Their formalization alone
would not establish the analytic branch constructed in section 1.

At the two ends,
\[
 \begin{array}{lll}
 q\downarrow0:& r(q)\sim\pi^2/q^2,&d(q)\sim\pi/q,\\
 q\to\infty:&
 r(q)\sim4(p(q)^2+q^2)e^{-2q},&d(q)\to\pi/2 .
 \end{array}                                             \tag{8}
\]
Thus \(r\) is a smooth decreasing bijection. Write
\(\mathcal D(t)=d(q(t))\) for its reparametrized boundary height.
It is smooth and increasing, with
\[
 \mathcal D(0+)=\pi/2,\qquad
 \mathcal D(t)\sim\sqrt t\quad(t\to\infty).
                                                               \tag{9}
\]
Dividing the two derivative identities in (7) gives
\[
 \frac{\mathcal D'(r(q))}{\pi}
 =\frac{(1+r(q))d(q)}{2\pi r(q)K(q)}=w(r(q))>0.            \tag{10}
\]

## 3. Endpoint control before applying a keyhole contour

All estimates here are uniform up to either bank of the slit.
For the upper half-plane parameter, \(0<p<\pi\). As \(|s|\to0\),
\(|A(u)|=|s|^{-1/2}\to\infty\), so \(q\to\infty\). Uniformly in
that bounded \(p\)-range,
\[
 |s|=4(p^2+q^2)e^{-2q}(1+O(e^{-2q})),\qquad
 \cot(p+iq)=-i+O(e^{-2q}).
 \]
It follows that \(q=O(\log(1/|s|))\) and
\[
 |B(s)|=O(\log(1/|s|))\quad(s\to0).                       \tag{11}
\]
For example, the first estimate gives
\(\log(1/|s|)=2q-2\log q+O(1)\), which bounds \(q\) by a constant
multiple of that logarithm for large \(q\).

As \(|s|\to\infty\), \(A(u)\to0\). The compactness bound in section
1 bounds \(q\); every cluster point must be the sole zero \(u=\pi\)
of \(A\) on that compact closure. At this simple zero,
\[
 A(u)=-(u-\pi)/\pi+O((u-\pi)^2),\quad
 u\cot u=\pi/(u-\pi)+O(1).
 \]
Consequently
\[
 |B(s)|=O(|s|^{1/2})\quad(s\to\infty).                   \tag{12}
\]
Reflection gives the same bounds in the lower half-plane.
The local inverse also exists on a neighborhood of each point of the
curved edge: (4) still holds there, so \(A'\ne0\).
Thus the boundary limits in (6) are locally uniform and smooth on
every compact negative-axis interval away from zero.

## 4. Reconstruction and the absence of omitted contributions

Fix \(s\in\Omega\), \(s\ne1\). Apply the residue theorem to
\[
 \frac{B(z)}{(z-s)(z-1)}
\]
on a finite slit annulus, with inner radius \(\epsilon\) and outer
radius \(R\), first placing both banks a positive angle from the cut.
Let that angle tend to zero while the radii stay fixed. Local boundary
continuation just proved permits this limit. The sum of the residues is
\((B(s)-B(1))/(s-1)\).

The outer circle is \(O(R^{-1/2})\) by (12), and the inner circle
is \(O(\epsilon\log(1/\epsilon))\) by (11); both vanish.
The upper bank is traversed from \(-R\) to \(-\epsilon\), the lower
bank in the reverse direction. Their jump is
\(B(-t+i0)-B(-t-i0)=-2i\mathcal D(t)\).
The residue formula therefore gives, with its sign fixed,
\[
 \boxed{\quad B(s)=1+\frac{1-s}{\pi}
  \int_0^\infty\frac{\mathcal D(t)}{(s+t)(1+t)}\,dt.\quad}  \tag{13}
\]
This also holds at \(s=1\) by continuity.

There is no unsupported interchange in this passage. By (9), the
integrand is bounded at zero and is \(O(t^{-3/2})\) at infinity.
For a compact subset of \(\Omega\),
\(|s+t|\geq c(1+t)\) for some \(c>0\) uniformly in \(t\geq0\).
These bounds prove absolute convergence and local uniform convergence
both for (13) and its differentiated integral. Since the derivative of
\((1-s)/((s+t)(1+t))\) is \(-1/(s+t)^2\),
\[
 -B'(s)=\frac1\pi\int_0^\infty
                    \frac{\mathcal D(t)}{(s+t)^2}\,dt.    \tag{14}
\]

For real \(s>0\), integrate by parts first on \([\epsilon,R]\):
\[
 \int_\epsilon^R\frac{\mathcal D(t)}{(s+t)^2}\,dt
 =-\frac{\mathcal D(R)}{s+R}
   +\frac{\mathcal D(\epsilon)}{s+\epsilon}
   +\int_\epsilon^R\frac{\mathcal D'(t)}{s+t}\,dt .
\]
The first boundary term tends to zero and the second to \(\pi/(2s)\)
by (9). The last integrand is positive, so monotone convergence
proves its convergence as well as equality (1). Formula (5) at \(s=1\)
now gives (3). The weighted integrability in (3) proves local uniform
convergence of (1) throughout \(\Omega\).

This derivation reconstructs \(B\) from its whole jump, not merely a
density read off at individual points. No residual holomorphic term
survives the two contour estimates. Equation (14) followed by the
displayed integration by parts supplies every term in the measure:
the lower endpoint contributes precisely the atom \(1/2\), the upper
endpoint contributes nothing, and the interior is the ordinary
derivative of a smooth increasing function. In particular there is no
singular-continuous component or positive-axis atom.

Indeed (10) and (9) give exactly
\[
 \tfrac12+\int_0^{r(q)}w(t)\,dt
 =\tfrac12+\frac{d(q)-\pi/2}{\pi}=\frac{d(q)}\pi,
 \]
proving (2). Also \(-B'(s)\to0\) as \(s\to\infty\) by dominated
convergence in (1), so a nonnegative constant term must be zero.
The origin residue can separately be checked from
\[
 -B'(s)=\frac{B(s)-s}{2s(B(s)-1)},\qquad 0<s<1,
 \]
which gives \(s(-B'(s))\to1/2\).

If uniqueness among all positive Stieltjes representations is desired,
it does not require an additional hypothesis here. The imaginary part
at \(-t+i\epsilon\), integrated against a continuous compactly supported
test function in \(t>0\), is the Poisson-kernel approximation to the
representing measure. Weighted integrability controls the tails.
Consequently the transform fixes the measure on \((0,\infty)\);
the origin residue fixes its mass at zero, and the limit at infinity
fixes its constant. Thus an alternative representation cannot hide an
additional singular part. This completes the proof.

## 5. What the executable and formal certificates establish

Run

```
$WORKSPACE/argus-live-update/.venv/bin/python research/stieltjes_certificate/verify.py
```

The default execution checks the exact rational identities in (6)-(7),
the inverse-branch Taylor coefficients, the derivative identity, the
boundary-jump sign, and the archived typed Jacobian reciprocal
calculation. It also checks that the saved successful Lean 4.31.0 run
has no proof holes and still matches both the current formal source and
its statement-fidelity document. No floating-point sample is used for
these identities.
`--numeric` adds bounded high-precision diagnostics of (1); those are
not the proof of its universal quantifiers or endpoint assertions.

`Main.lean` proves the universal real-algebra sign and density theorem
under exactly its stated scalar inequalities, with no proof holes.
Its reading is specified in `statement_fidelity.md`. It does not encode
the conformal mapping, contour argument, asymptotics, or measure theory.
Those analytic arguments, and the translation of their actual boundary
variables into the formal algebra theorem, require independent review.
No manuscript assertion has been found false in this focused audit.
