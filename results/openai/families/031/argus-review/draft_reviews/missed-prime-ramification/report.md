# Ramification of missed-prime classes

**Assessment: supported conditional written lemma using Uchida's local input, including a ramified twist extension.** This covers `L_RAMIFICATION@v1` and `@v2`. Version 2 records `A_UCHIDA_LOCAL`; the natural statement did not change. Both old supports judgements bind version 2.

## Exact claim and source

In the surjective, logarithmically compatible setting of the inverse-twist assessment, every missed-prime Kummer class restricted to \(G_F\) is unramified at every finite prime \(u\nmid\ell\) of \(F\), including those ramified in \(F/K\). The draft is old `uniform_kummer_bridge.md`, Section 3. The manuscript counterpart is OpenAI's October 5, 2026 manuscript, revision `4eaee87548250b2682affda7d05d947c05554bae`, `build/sections/matching.tex`, proof of `prop:uniform-missed-primes`; the local theorem is in `preliminaries.tex`, `thm:local-correspondence`.

The external proposition actually needed is Uchida, DOI `10.2969/jmsj/03340595`, Section 1, pp. 595-596: for the indicated solvably closed Galois extensions of number fields and a continuous map with open image, a source prime away from odd \(\ell\) with surviving pro-\(\ell\) inertia is in case (ii). The containing target prime is unique and away from \(\ell\), and surviving pro-\(\ell\) inertia maps into its inertia. Case (i) kills this inertia; the exceptional torsion case (iii) requires \(\ell=2\).

## Decisive argument

Use the inherited cocycle, not an arbitrarily altered representative. If its inertia restriction at \(u\nmid\ell\) is nonzero, it is a nonzero continuous homomorphism \(I_u\to\mathbb Q_\ell(1)\): the Tate module is unramified there, so inertia coboundaries are zero. Its image is compact, hence pro-\(\ell\). A pro-\(\ell\) Sylow \(J_u\) maps onto that image, by finite Sylow theory and inverse limits.

For the prime \(v\) below \(u\), choose a compatible pro-\(\ell\) Sylow \(J_v\) containing \(J_u\). The extension \(F/K\) is Galois and has degree dividing \(\ell-1\). The inertia quotient has order dividing that degree, so every pro-\(\ell\) subgroup of \(I_v\) lies in \(I_u\). This is why ramification of \(F/K\), even away from \(\ell\), is harmless. It is not being assumed absent.

The inherited pulled-back cocycle vanishes on \(\ker f\), so its nonzero evaluation on \(J_u\) implies \(f(J_v)\ne1\). Thus \(v\) is active. Uchida's local case supplies a target prime \(t\nmid\ell\) with \(f(J_v)\subset I_t\). Since \(w\) is missed, \(t\ne w\). The original Kummer class for \(w\) is unramified at \(t\); because the coefficient action on \(I_t\) is trivial, its cocycle itself is zero on \(I_t\), not merely a coboundary there. Pulling back gives zero on \(J_u\), contradicting its choice.

This uses only containment of the surviving pro-\(\ell\) subgroup. It never asserts that all of \(I_v\) maps into target inertia. The source algebraic closure and \(\mathbb Q^s/B\) meet the solvably closed-extension hypotheses; a surjection is in particular an open-image map.

## Evidence and exclusions

The archived `reviewer-uchida-local.txt`, `uchida1981.txt`, and supporting citation metadata `c973a66be116b913f3670513826e22fd.json` agree on these local alternatives and hypotheses. The earlier DOI-resolution metadata `ce9696cde7dbbca5099924fcdf7a2169.json` was inconclusive; existence of a paper is not attribution of this proposition.

Uchida's Proposition 1 on p. 597 supplies a global cofinite-coverage statement in the manuscript's larger local-correspondence theorem. It is **not** used to prove the bridge's uniform coverage. This separates the actual local dependency from a circular use of the conclusion under investigation.

The local symbolic replay verifies the prime-to-\(\ell\) Bezout identity, and its quadratic fixtures include a twist ramified away from \(\ell\). Neither is a machine proof of the local theorem or an arithmetic realization of a map. No Lean theorem was supplied. No gap was identified in this conditional ramification argument; the full manuscript's other anabelian inputs remain separate obligations.
