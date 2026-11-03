# Exploratory negative report: 389.a1 arbitrary scalings

## Result boundary

No counterexample candidate has been found.

For the reviewed semiabelian surface
\[
G=\mathcal O_E(P-O)^\times,\qquad
E:y^2+y=x^3+x^2-2x,
\]
and every positive rational scaling pair
\(\Gamma_{r,s}=\langle rg,sh\rangle\), the local search now has an
exact decision rule at each good odd prime \(p\ne389\):

- if \((v_p(r),v_p(s))\ne(0,0)\), the closure is not open at \(p\);
- if both valuations vanish, the closure is open exactly when
  \[
  \Delta_p(r,s)=
  \det\!\left(
    \log_G(g^{N_p})+N_p\log_p(r)e_T,\,
    \log_G(h^{N_p})+N_p\log_p(s)e_T
  \right)
  \ne0,
  \]
  where \(N_p=(p-1)\#E(\mathbb F_p)\).

This theorem covers negative valuations, scalar numerators and
denominators, arbitrary unit reduction classes, independent generator
signs, and both directions of the openness equivalence.

## What is exactly excluded

The independently reviewed local rational-map theorem says that open
closure at one odd prime rules out every rational plane map defined on
the whole subgroup: a non-dominant image is algebraically non-dense,
and a dominant image contains an unequal pair with nonzero nonsquare
\(p\)-adic squared distance.  Its proof already covers poles, critical
loci, and image collisions.

Using the two independently reviewed formal-log certificates, the
following finite tests are sufficient:
\[
F_5(r,s)=1+q_5(r)-2q_5(s)\pmod5,
\]
\[
F_{66161}(r,s)=
60513+3660q_{66161}(r)+21615q_{66161}(s)
\pmod{66161}.
\]
Here \(q_p\) is computed exactly from the rational residue modulo
\(p^2\).  If \(r,s\) are units at the displayed prime and the
corresponding value is nonzero, then \(\Gamma_{r,s}\) is open and the
pair is excluded from the rational-map construction route.

The first filter rejects \(20\) of \(25\) Fermat-quotient pairs.  The
second rejects \(4377211760\) of \(4377277921\) pairs.  Since
\(q_{66161}(6)=0\), the second filter retains the already reviewed
exclusion of every \((r,s)=(6^m,6^n)\), \(m,n\in\mathbb Z\).

## What is not excluded

A zero finite-filter value is not a zero \(p\)-adic determinant.  It
only says that the determinant is not decided by the retained
precision.  A pair surviving both displayed filters may be excluded
by higher precision at either prime or by any other good unit prime.
It is not a candidate.

The true unresolved local exceptional locus is
\[
\mathcal E=
\left\{
(r,s)\in\mathbb Q_{>0}^2:
\Delta_p(r,s)=0
\text{ for every odd }p\ne389\text{ with }p\nmid rs
\right\}.
\]
The reviewed Zariski-density and trivial-torus-intersection results
give \(d(G,\Gamma_{r,s})=2\).  Hence a single equation
\(\Delta_p(r,s)=0\) is exactly a failure of
\(\dim\overline\Gamma=d(\Gamma)\) for this instance of Poonen's
Question 3.3.  The archived primary source poses that equality as an
open question.  Its Corollary 5.3 relates the question to Leopoldt for
specific restriction-of-scalars tori; it does not prove the 389.a1
case.

No rational point of \(\mathcal E\) is claimed to exist or not exist.
This is a simultaneous \(p\)-adic analytic boundary, not another
finite congruence search.

## Remaining counterexample obligations

Even an exact pair in \(\mathcal E\) would only evade this local
obstruction.  A genuine counterexample construction would still need:

1. exact density of \(\Gamma_{r,s}\) in the relevant real component;
2. a rational plane map defined at every subgroup word;
3. a proof that every unequal word pair has positive rational
   distance;
4. a terminating exact certificate of plane density for the image.

None of these obligations is supplied by finite-filter survival,
numerical logarithms, adapter timeout, or failure to find a rejecting
prime.  The global Erdős--Ulam target therefore remains open.
