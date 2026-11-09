# The moving Euler class of a covered orbit line

## Assessment and exact statement

The explicit formula in the old report is supported by its relative
Euler-sequence/weight calculation, for **every** cover multiplicity and
bundle rank in the stated setting. The endpoint-release convention and
separate deck factor are consistent. The finite checker corroborates
only the \(m=1\), rank-two trivial-bundle specialization; it is not the
proof for all \(m,r\).

This is an exploratory old-draft assessment, not a new formula or final
acceptance. Review-result novelty is `not_applicable`; native independent
acceptance is pending.

Let \(B\) be smooth connected projective over \(\mathbb C\), \(E\) an
algebraic rank-\(r\geq2\) bundle, \(W=\mathbb P_B(E\oplus\mathcal O)\),
\(X=\mathbb P_B(E)\) in the lines convention, and torus weights \(0,1\).
For \(m\geq1\), take the leg gerbe \(q_m:\mathfrak L_m\to X\), with
universal \(M^m=q_m^*\mathcal O_X(-1)\), and **mark both endpoints**.
Put
\[
 a=\frac{\lambda+q_m^*p_X}{m},\qquad
 P_E(t)=\sum_{i=0}^r q_m^*\pi^*c_i(E)t^{r-i}.
\]
The old `L_LOC_EULER@1` asserts
\[
 e_T(N^{\rm vir}_{\mathfrak L_m,2{\rm pt}})
       =m!\,a^m\prod_{k=0}^{m-1}P_E(-\lambda+ka).
\]
The gerbe pushforward \(q_{m*}1=1/m\) is **not included**.
Forgetting one endpoint divides this Euler class by its tangent
\(a_F\), equivalently multiplying its inverse-Euler localization weight
by \(a_F\), where \(a_X=a\), \(a_B=-a\).
This is a leg factor, not a full graph contribution: matching normal
numerators and node smoothing factors remain separate.

## Provenance and attribution

The all-multiplicity formula is in the old
`9000065/research/family_orbit_localization/report.md`, Section 1,
equation (1a), and old `L_LOC_EULER` v1. The underlying gerbe and
tangent conventions are manuscript `04-localization.tex`,
`loc:leg-geometry` and `loc:tangent-gluing`; the explicit product
formula is the report's additional calculation. Actual manuscript
inputs match revision `4eaee87548250b2682affda7d05d947c05554bae`.

The old ledger has one engineer and one historical reviewer supporting
judgement for this claim, not a formal proof. The old graph leaves it
open with `reviewer_confirmed=false`, depending on `L_LOC_LEG`.
Neither label adjudicates the present review. Originality of this
standard localization-weight calculation was not investigated or
certified; attribution remains the existing Argus report.

## Decisive calculation checked

On the universal covered line apply the lines-convention relative
Euler sequence
\[
 [T_{W/B}]=[\mathcal O_W(1)\otimes\pi^*(E\oplus\mathcal O_\lambda)]-1.
\]
The pullback of \(\mathcal O_W(1)\) has degree \(m\), and its derived
sections split in equivariant \(K\)-theory as
\[
 \bigoplus_{k=0}^m M^{-k}\otimes
          \mathbb C_{-(m-k)\lambda/m}.
\]
There is no \(H^1\): the relative tangent on the covered line has
degrees \(2m,m,\ldots,m\), and the base tangent is constant.
Subtract the Euler-sequence trivial line and the automorphism
line of the twice-pointed rational domain; both are fixed.

The fixed summands before subtraction are the \(E\)-term at \(k=m\),
the \(\mathcal O_\lambda\)-term at \(k=0\), and the base tangent.
After the two fixed-line subtractions they give
\[
 q_m^*\pi^*T_B+
 q_m^*\pi^*E\otimes M^{-m}-1=T_X
\]
in \(K\)-theory, as required for the smooth leg gerbe.
The moving summands are precisely
\[
 \bigoplus_{k=0}^{m-1}
 q_m^*\pi^*E\otimes M^{-k}
       \otimes\mathbb C_{-(m-k)\lambda/m}
 \quad\oplus\quad
 \bigoplus_{k=1}^m M^{-k}\otimes\mathbb C_{k\lambda/m}.
\]
Their scalar characters are nonzero. If \(\alpha_j\) denotes a
formal Chern root, the first summand has roots
\(\alpha_j-\lambda+ka\): its Euler factor is exactly
\(P_E(-\lambda+ka)\). The second has classes \(ka\) and product
\(m!a^m\). Thus the formula follows by symmetric Chern-polynomial
calculation; no global splitting of \(E\) was introduced.
The nonzero scalar parts make these Euler classes invertible after
localizing \(\lambda\), regardless of positivity of \(E\).

For the forgetful morphism the relative tangent at the marked
endpoint is \(T_pC\), of equivariant Chern class \(a_F\).
Therefore \(T_{\rm marked}^{\rm vir}=
T_{\rm unmarked}^{\rm vir}+T_pC\), so
\(e_{\rm marked}=a_F e_{\rm unmarked}\).
This verifies the sign and direction of endpoint release, rather
than guessing an unstable factor. It introduces no extra deck
factor. The latter is already \(1/m\) from gerbe integration.

## Exact check and its boundary

The fresh default replay of the **inspected** old `verify.py` passed;
`--write-certificate` was not used. Its
\(B=\mathrm{pt},E=\mathbb C^2,m=1\) specialization has
\[
 a_X=\lambda+h,\quad a_B=-\lambda-h,\quad
 e_{\rm leg}=\lambda^2(\lambda+h).
\]
It checks end contributions after releasing a free endpoint and
the full two-variable bridge against the degree-one common-\(R\)
calculation, with zero exact residuals. This tests that specialization
and its normal/tangent conventions. The code **takes** the leg
Euler formula as input; it does not derive the universal Euler
sequence, higher multiplicities, or gerbe integration. See the
finite-moments unit for actual Python/SymPy, Lean and Jacobian
measurements, including the distinction between source binding and
fresh compilation.

No Lean theorem encodes this Euler class. The all-\(m,r\) support
is the weight calculation above, with the geometric leg
identification assessed in the common-R unit. No concrete sign,
missing moving summand, or deck-normalization error was found.
Remaining acceptance requires the native Reviewer to inspect this
calculation and its exact geometric conventions. This unit neither
certifies all graph assembly nor any Virasoro/sewing theorem.
