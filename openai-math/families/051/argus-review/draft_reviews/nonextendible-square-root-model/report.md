# Nonextendible square-root disc

**Engineer assessment: supported as a construction on a given compact
Brody-hyperbolic curve, with the exact scalar diagnostics claimed.**
Failure of boundary holomorphic continuation is intentional and is not
a failure of the bridge's hypotheses.

## Exact claim and source

This is the one-dimensional part of old `BH-ALGEBRA@1`, preserved
`9000051/research/boundary-hessian/bridge.md`, section 7, (32)--(33).
Old root `verify.py`, function `check_square_root_model`, and old root
`exact_certificate.json`, field `nonextendible_curved_model`, are
supporting dependencies, not additional drafts or separate results.
The fixed background compact hyperbolic curve is a hypothesis of the
construction, not something inferred by the checker.

Choose a coordinate chart \(|w|<1\) on such a curve \(X\), and a smooth
positive metric agreeing with
\(h(w)=\exp(256|w|^4)|dw|^2\) for \(|w|\le1/2\).
Let
\[
 f(z)=\tfrac14\sqrt{1-z},\qquad B(z)=e^{z-1},\qquad
 F(t,z)=f(z)+tzB(z),\quad |t|<1/16 .
\]
The branch is holomorphic on \(D\) and continuous on \(\overline D\).
The claims are
\[
\begin{gathered}
 f\in W^{1,p}\ \text{exactly for }1\le p<4,\qquad
 f\text{ has no holomorphic extension across }1,\\
 \log N=|z|^2-1,\qquad R_h(f',f')=-1,\qquad
 P_{R_h}=A_{R_h}=-1,\\
 \mathcal LA_h=2,\qquad \mathcal LP_h=1,\qquad
 \mathcal Ld=e^{-1}\quad(k=h).
\end{gathered}
\]
These are an Argus illustrative construction, not a claimed contradiction
of the manuscript, whose frame section already explicitly assumes no
boundary continuation.

## Checking every construction condition

Since \(\operatorname{Re}(1-z)>0\) in \(D\), a single square-root branch
exists there and has a continuous value zero at \(z=1\).
It obeys \(|f|\le\sqrt2/4\). Also
\(|B|=\exp(\operatorname{Re}z-1)\le1\) on the closed disc, so
\[
              |F(t,z)|\le\sqrt2/4+1/16<1/2 .
\]
Thus every displayed variation stays in the chart region with exactly
the specified metric. The family is holomorphic, centered, and has first
variation \(zB\).

A smooth bump function allows positive interpolation with any background
metric outside this region. In complex dimension one every smooth
Hermitian metric is Kahler: its exterior derivative is a three-form
on a real two-manifold. No global curvature requirement on the
interpolated metric is being imposed or checked.

Direct differentiation gives
\[
                    |f'(z)|^2=1/(64|1-z|).
\]
Near \(z=1\), the disc contains and is contained in fixed positive-angle
sectors at sufficiently small scales. Integrability is therefore that
of \(\int_0^\epsilon r^{1-p/2}\,dr\), finite exactly when \(p<4\);
at \(p=4\) it diverges logarithmically. The function itself is bounded.
This is the analytic proof of the threshold, not a finite test of
exponents. Choosing, for example, any \(2<p<4\) makes the model admissible
for the literal bridge.

If a holomorphic continuation across \(1\) existed, its square would
equal \((1-z)/16\) by the identity theorem. The square of a holomorphic
function has an even-order zero, whereas this function has a simple
zero. This proves nonextension independently of any computation.
The frame \(B\), unlike \(f\), is entire, nonzero, and smooth.

## Checking the scalar identities

Since \(256|f|^4=|1-z|^2\),
\[
 \log(h(f)|B|^2)=|1-z|^2+2\operatorname{Re}z-2=|z|^2-1.
\]
In particular \(N=1\) on the boundary. The coefficient of \(R_h\)
is \(-1024|w|^2\); multiplying by \(|f'|^2\) gives \(-1\)
throughout the open disc. Direct integration yields
\(A_{R_h}=P_{R_h}=-1\), with the manuscript's normalizations.

The mixed family Hessian density for \(h(F_z,F_z)\) is, putting
\(u=|z|^2\),
\[
                  e^{u-1}(1+3u+u^2).
\]
Equivalently it is the mixed source derivative of
\(u e^{u-1}\); this equality can be obtained directly by differentiating
the explicit metric and family and is checked in the exact diagnostic.
Its normalized area integral is
\([u(u e^{u-1})']_0^1=2\); its logarithmic integral is the
boundary-minus-center value \(1\). These operations involve smooth
radial functions, despite the original disc's singular boundary
derivative. At the center \(f(0)=1/4\), \(h(f(0))=e\),
and \(B(0)=e^{-1}\), so the central squared-norm Hessian is \(e^{-1}\).
The metric density of the family is integrable for the displayed
parameters since \(f\in W^{1,p}\) for some \(p>2\).

## Evidence, replay, and scope

The old independent receipt
`judgement-BH-ALGEBRA-460a36b262af` by
`reviewer:copilot-4ea18baac059` covers the old exact certificate's
diagnostics; it is shared with the distinct two-dimensional example,
not counted twice as a new independent result. The Engineer opinion is
`judgement-BH-ALGEBRA-7d02f6e912ad`. The old checker source and its
read-only default behavior were inspected before deciding to reuse
that evidence instead of rerunning the unchanged 85 checks.

That old opinion binds a claim digest and certificate path, not a
certificate-byte digest; the root diagnostic files are not entries in
the snapshot manifest. Applicability is therefore scoped to the matching
construction and stated outputs, with current file identities recorded
separately, rather than a claim of authenticated historical file bytes.

Exact SymPy relations and certificate strings alone do not prove
membership/nonmembership in \(W^{1,p}\), a global compact hyperbolic
target, or holomorphic nonextension. The sector integral, image bound,
metric interpolation, and zero-order argument above check those
conditions directly. The certificate's assertion of no analytic kernel
verification remains correct; its pending-independent-review label is
stale relative to the old ledger's diagnostic receipt.

No concrete gap was found in this scoped construction. It is not shown
to be a maximizing disc and supplies no information about the manuscript's
maximizer existence, universal boundary regularity, nefness, volume bound,
or canonical ampleness. No Lean compilation or verified novelty is
claimed. Current native independent acceptance remains pending.
