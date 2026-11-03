# Alternative probe: classification and potential uniqueness

This is a materially different route from the geometric cylinder proof in
`flying-wing.md`. A research contributor executed the primary-source probe;
Engineer subsequently archived and read the relevant versioned PDF passages.
It is a research result, not an independent Reviewer verdict. The geometric
certificate is the selected delivery route, so the classification theorem
below is not an additional imported premise of that certificate.

## Primary-source result and convention limitation

Brendle, [arXiv:1202.1264v3](https://arxiv.org/pdf/1202.1264v3),
*Rotational symmetry of self-similar solutions to the Ricci flow*,
Theorem 1.1, printed p. 1, says that a three-dimensional complete, nonflat,
kappa-noncollapsed steady gradient Ricci soliton is rotationally symmetric,
and hence isometric to the Bryant soliton up to scaling. The definition of a
steady soliton on that page is \(2\operatorname{Ric}=\mathcal L_Xg\), so its
gradient convention agrees with Lai's \(\operatorname{Ric}=\nabla^2 f\).

Brendle does not explicitly define kappa-noncollapsed there. His introduction
attributes the noncollapsing assumption to Perelman. Perelman,
[arXiv:math/0211159v1](https://arxiv.org/pdf/math/0211159v1),
Definition 4.2, printed p. 10, defines noncollapse at scale \(\rho\) using
every radius \(r<\rho\) ball with \(|\operatorname{Rm}|\le r^{-2}\) everywhere
on the ball and volume at least \(\kappa r^n\). Requiring this at all scales
is precisely the spatial convention of Lai's Definition 3.4.

Thus the classification route is viable under that explicitly sourced
all-scales reading. It would be inaccurate to claim that Brendle's first
page itself spells out the definition. The chosen geometric certificate
does not need this interpretive bridge.

Local primary files:

- `sources/brendle-1202.1264v3.pdf`, introduction text extraction, pp. 1--3.
- `sources/perelman-0211159v1.pdf`, Definition 4.2 text extraction, p. 10.
- `sources/lai-2010.07272v2.pdf`, Theorem 1.1 and its critical-point convention, p. 2.

The initial contributor obtained sources but wrote no local note; this file
persists the actual mathematical result. No retrieval timeout or missing
artifact was treated as mathematical evidence.

## Hypothesis check

For Lai's \(n=3,\alpha=1/2\) example, dimension, completeness and the gradient
steady equation follow from the precise premises in the main certificate.
Positive curvature operator implies nonflatness. Assume, for contradiction,
that it is spatially kappa-noncollapsed for some positive kappa.
These are exactly the hypotheses of Brendle's theorem in the stated reading.

Even if one asks for the accompanying bounded-curvature eternal flow, the
soliton equation supplies it. Contracting the Bianchi identity and the
commutation formula for third derivatives of \(f\) gives
\(\nabla R=-2\operatorname{Ric}(\nabla f,\cdot)\); hence
\[
                  R+|\nabla f|^2=R(p).
\]
Since \(R>0\), both scalar curvature and the gradient of \(f\) are bounded.
In dimension three positive curvature operator bounds the full curvature
norm by a fixed multiple of \(R\). A bounded smooth vector field on a
complete Riemannian manifold has complete flow: finite-time trajectories
stay inside a compact metric ball, where the ordinary differential equation
continues. Thus \(-\nabla f\) generates the eternal pullback Ricci flow.
Every slice is isometric to \(g\), so the same spatial kappa works on every
slice. This paragraph is supplementary, not an added assumption in Brendle's
stated theorem.

## Non-Bryantness without assuming a marked-point identification

Suppose there is an isometry
\[
             F:(M,g)\longrightarrow(B,cg_B),\qquad c>0,
\]
to a scaled Bryant soliton, and write \(h=cg_B\) and \(u=f\circ F^{-1}\).
Then \(\nabla_h^2u=\operatorname{Ric}_h\). Average \(u\) over the compact
rotation group \(SO(3)\) of the Bryant model to obtain \(\bar u\).
Isometric pullbacks commute with the Hessian and preserve Ricci, so
\(\nabla_h^2\bar u=\operatorname{Ric}_h\).
Consequently
\[
                  V=\nabla_h(u-\bar u)
\]
is parallel. For a parallel field, \(\operatorname{Rm}(A,B)V=0\);
in particular \(\operatorname{Ric}(V,V)=0\). Positive Ricci curvature
therefore gives \(V=0\). It follows that \(u\) differs from its rotational
average by a constant and is itself rotation-invariant.

At the Bryant tip \(o\), the rotations act on the tangent space as the
standard \(SO(3)\) representation. This action has no nonzero invariant
vector, so \(\nabla_hu(o)=0\).
The Hessian of \(u\) is positive definite. Such a function on a complete
connected manifold has at most one critical point: join two putative
critical points by a minimizing unit-speed geodesic and integrate the
strictly positive second derivative of \(u\) along it; its endpoint first
derivatives cannot both vanish.
Since \(F(p)\) is critical, this proves \(F(p)=o\).

At \(o\), the Ricci endomorphism commutes with every rotation, and hence is
a scalar multiple of the identity. Its eigenvalues are all equal.
But Lai's prescription at \(p\) gives \((b/2,b,b)\), with \(b>0\).
Isometry preserves the eigenvalues. This contradiction rules out \(F\).
The equality between the marked points was a conclusion, not an assumption;
constant scaling changes none of the eigenvalue ratios.

## Probe conclusion

With the stated noncollapse convention, Brendle's classification and the
non-Bryant argument contradict the assumed existence of a positive kappa.
This supplies a viable alternative collapse mechanism. It is not a finite
search boundary and is not retired as false. The old shortcut that merely
identifies \(p\) with the Bryant tip remains retired; the potential argument
above is the missing mathematical justification.

The delivered certificate instead transfers curvature-controlled small
volume balls from Lai's smooth cigar-product limit. Its direct imports are
Lai's stated theorems; their internal analytic dependencies are taken with
those theorems, not independently re-proved here.
