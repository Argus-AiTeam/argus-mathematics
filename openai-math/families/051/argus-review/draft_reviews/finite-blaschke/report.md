# Finite Blaschke multipliers

**Engineer assessment: supported under the literal bridge hypotheses;
the endpoint variant is conditional on a supplied family.**
The degree-two diagnostic is a check of one instance, not the proof.

## Exact claim, source, and attribution

Old `BH-BLASCHKE@1` is Theorem 4 of the preserved
`9000051/research/boundary-hessian/bridge.md`. Let \(B,f,h,k,q\) satisfy
the literal bridge hypotheses. For every finite Blaschke product
\[
 \psi(z)=\lambda\prod_{\ell=1}^m
                 \frac{z-a_\ell}{1-\bar a_\ell z},\qquad
 |\lambda|=1,\quad |a_\ell|<1,\quad \psi(0)=0,
\]
there is a centered family with first variations \(\psi b_j\).
Here \(m\ge1\). Its determinant and Poisson formulas are unchanged, and
\[
 \mathcal Ld=|\psi'(0)|^2\operatorname{tr}(B(0)^*kB(0)),\qquad
 \mathcal LA_h=mn-A_{R_h}(f).
\]
Conditionally, the same identities hold in
\(C^0\cap W^{1,2}\) if a family in that topology with these first
variations is given. This last assertion does not construct an endpoint
family.

This is a proposed Argus extension, not a claim of literature-verified
originality. It uses the bridge's finite-list section integration,
local-potential identity, determinant calculation, and flux lemma.
Its \(p>2\) existence part inherits `A-CG`, `A-OKA`, and `A-MORREY`
through the bridge, with the exact source/version/receipt information
in that unit. The extension adds no new external theorem.

## Decisive review

Finite \(\psi\) is smooth on a neighborhood of \(\overline D\);
\(\psi b_j\) is holomorphic, continuous, \(W^{1,\rho}\), and vanishes
at the center. The finite-list construction therefore integrates it.
If \(V_j=\psi b_j\), then
\(V'_j(0)=\psi'(0)b_j(0)\) because \(\psi(0)=0\).
This proves the central factor, including zero when \(\psi\) has a
multiple zero at the center.

The local Hessian identity becomes
\[
 \mathcal Lq(F_z,F_z)=\partial_z\partial_{\bar z}
       (|\psi|^2\operatorname{tr}(B^*qB)).
\]
Its central value is zero and its boundary value is
\(\operatorname{tr}_h q\), because \(|\psi|=1\) there. The normalized
Green formula proves the unchanged Poisson identity.
The determinant identity involves only \(f,B,h\), not their realizing
family, so it is unchanged as well.

For the area identity put \(T=\operatorname{tr}N\). On an interior circle,
Green's area formula gives
\[
 (r/2)\langle \partial_r(|\psi|^2)T
                         +|\psi|^2T_r\rangle_r .
\]
Uniform boundary convergence \(T\to n\) and smoothness of \(\psi\)
handle its first summand. A factor with zero \(a\) has boundary derivative
\[
 \left.\partial_r\left|
    \frac{re^{i\theta}-a}{1-\bar a re^{i\theta}}\right|^2
 \right|_{r=1}
 =2\frac{1-|a|^2}{|e^{i\theta}-a|^2}.
\]
The normalized mean of this Poisson kernel is one. On the boundary all
other factor moduli are one, so the derivatives add and their mean is
\(2m\). The first summand therefore tends to \(mn\), not \(n\).

The remaining term requires a weak-boundary estimate; replacing
\(|\psi|^2\) by its boundary value without one would be a gap.
Finiteness gives uniformly
\(\big||\psi(re^{i\theta})|^2-1\big|\le C(1-r)\).
Along the flux lemma's sequence, with
\((1-r)g(r)\le1\), its error is at most
\[
              C(1-r)\sqrt{g(r)}\le C\sqrt{1-r}\longrightarrow0.
\]
Thus \((r/2)\langle|\psi|^2T_r\rangle_r\) has the same limit as
\((r/2)\langle(\log\det N)_r\rangle_r\), namely \(-A_{R_h}\).
This establishes the asserted area formula. The same proof works with
the endpoint density/Green argument when the stronger family hypotheses
of that conditional theorem are supplied.

## Evidence and limits

The old opinion `judgement-BH-BLASCHKE-5342b3daade3` is by the Engineer.
There is no old independently targeted `BH-BLASCHKE` verdict. Reusing the
old independent bridge/flux evidence does not change that fact.

The explicit diagnostic
\(\psi=z(z-1/2)/(1-z/2)\), \(n=2\), has
\(|\psi'(0)|^2=1/4\) and \(mn-A_{R_h}=4+1/4=17/4\).
It is the same example as in the curved-model unit and old exact
certificate, not a second result or a universal proof. Its applicable
old diagnostic evidence is reused without an unchanged replay.

No concrete gap was found for finite products and the stated hypotheses.
An infinite inner function need not supply the smooth boundary derivative
or the uniform \(O(1-r)\) error used here; that stronger statement is not
established. Dropping \(\psi(0)=0\) also changes both the centered variation
and the Poisson central-value calculation. No kernel proof, novelty
verification, or canonical-ampleness consequence is claimed. Native
independent review of this extension remains pending.
