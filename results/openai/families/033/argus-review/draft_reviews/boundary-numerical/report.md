# Prescribed extensions, mixed mass, and numerical dimension

**Assessment:** the prescribed unipotent/tautological extensions support
the nefness and curvature-rank-to-numerical-dimension step, with the
identified analytic inputs. The argument is stronger than merely
discarding the boundary from an intersection integral. Arbitrary
divisorial extensions and Iitaka dimension are not covered.

## Statement and source versions

`C_LOG_MASS` versions 1-4 have the same statement. Versions 2, 3, and 4
add norm estimates, zero-Lelong nefness, and full-mass monotonicity.
Section 5 of the old Argus report is the proof; this is one argument,
not four mathematical results.

On the smooth projective resolved unipotent level \(B\), the extensions
are the full-rank tautological subbundles in the pulled-back canonical
Hodge grades. Their induced metrics, determinants, duals and the
specified tensor combinations have two-sided power-log bounds
\[
 C^{-1}\Lambda^{-m}h_0\le h\le C\Lambda^mh_0,\qquad
 \Lambda=\prod_i(-\log|z_i|).
\]
For a rational line \(L\) with smooth semipositive curvature \(\Theta\)
on \(B^\circ=B\setminus D\), \(D\) SNC, and these two-sided log-log
weights, the asserted consequence, for a Kähler form \(\eta\), is
\[
 L\text{ nef},\qquad
 \int_{B^\circ}\Theta^k\eta^{n-k}
       =c_1(L)^k[\eta]^{n-k}\ (0\le k\le n),\qquad
 \nu(L)=\max_{B^\circ}\operatorname{rank}\Theta.
\]
Here \(\nu\) is numerical dimension for a nef rational line. No equality
with its Iitaka dimension is asserted.

The Hodge-sector source is Cattani--Kaplan, *Degenerating variations of
Hodge structure*, Asterisque 179-180 (1989), Theorem 5.1 pp. 86-87,
`url:https://www.numdam.org/item/AST_1989__179-180__67_0/`.
The retained text and image represent the same theorem. Its finite
sector log-ratio formula, canonical untwisting polynomial and dual
bound imply the displayed power-log estimates; the displayed inequality
is a deduction, not a quotation attributed verbatim to that theorem.

## Why the extension choice matters

After resolving the Grassmann maps, the tautological inclusions have
full rank even at the boundary, so restriction of the ambient metric
preserves both bounds. Canonical unipotent pullback is compatible with
the resolved monomial boundary maps: new residues are sums of commuting
nilpotent residues. An arbitrary divisorial twist would change the
extension and its intersections and cannot be inserted into this
argument. Thus the local certificate alone cannot specify a permissible
global extension.

## Decisive mass argument

Semipositive local weights extend as plurisubharmonic weights using
\(\epsilon\sum\log|z_i|\) and the maximum principle. The log-log bound
gives zero Lelong numbers. Regularization then gives nefness. This is
a genuine external analytic theorem, not a result of rational
matrix arithmetic.

For each \(\epsilon>0\), take a Kähler representative
\(\omega_\epsilon\) of \(c_1(L)+\epsilon[\eta]\).
The global potential is less singular, up to a constant, than
\(\psi=-\delta\sum_i u_i^b\), with
\(u_i=-\log\|s_i\|^2\ge1,\ 0<b<1\). Choose \(\delta>0\) sufficiently
small for this background form. Concave truncations of \(u_i^b\)
produce semipositive smooth approximants whose top powers are dominated
by the top power of
\[
 \eta_0+\sum_i
 \frac{\sqrt{-1}\,dz_i\wedge d\bar z_i}
 {|z_i|^2(-\log|z_i|)^{2-b}}.
\]
Each singular summand has rank one, so no squared copy of the same
normal singularity appears. Its normal integral is
\(\int^\infty u^{b-2}\,du<\infty\).
Dominated convergence and Stokes give full Monge--Ampere mass for the
barrier. Passing to the less singular original potential preserves full
mass. Thus for **every** \(\epsilon>0\),
\[
 \int_{B^\circ}(\Theta+\epsilon\eta)^n
             =(c_1(L)+\epsilon[\eta])^n.
\]
Nonnegativity makes the mixed integrals finite; comparison of polynomial
coefficients gives every displayed mixed identity. Positivity on a
nonempty open is equivalent to curvature rank at least \(k\) somewhere,
which proves the numerical-dimension formula. Full mass is what
justifies this step; zero Lelong numbers alone were not substituted for it.

## Source support and remaining limits

Guedj--Zeriahi, `arxiv:math/0612630v2`, Proposition 1.6 p. 7,
states that if \(\varphi\in\mathcal E(X,\omega)\),
\(\psi\in\operatorname{PSH}(X,\omega)\), and \(\varphi\le\psi\),
then \(\psi\in\mathcal E(X,\omega)\), in the compact Kähler/Kähler-form
setting. The retained text has this statement at lines 341-342; its
PDF and text are one source, not two results. The background used above
meets its Kähler requirement for each positive \(\epsilon\).

The engineer's original Demailly-1992 source access failed. The later
independent packet instead gives the primary coauthored
Demailly--Peternell--Schneider result,
`arxiv:math/0006205v2`, Lemma 5.1 p. 39: a pseudoeffective line on a
normal compact Kähler space with at most isolated singularities is nef
when a positive metric has zero Lelong numbers outside a countable set.
Our smooth projective base and everywhere-zero Lelong numbers meet this
scope; a Cartier multiple handles rational lines. That packet says the
source proof cites Demailly 1992 Corollary 6.4. This verifies the needed
line-bundle consequence, **not** a fresh reading of the inaccessible
1992 text or an independent attribution of every broader current-class
variant. The ledger's original uncited label is preserved as historical
metadata, alongside the later supporting reading.

`judgement-C_LOG_MASS-b152173cb2e8` and the three assumption receipts
support the exact historical subjects. The report matches the preserved
snapshot. The later source packet is path-referenced rather than
snapshot-bound, and the historical receipts are judgements, not compiler
or citation-attribution certificates.

No specific internal gap was identified for the stated rational-line
application. The barrier, extension comparison and external analytic
inputs are prose mathematics, not checked by `verify.py`. No new
novelty claim, arbitrary-extension theorem, abundance statement, or
whole-manuscript certification follows. Native independent review is
still required.
