# The retired finite-valuation-support shortcut

**Assessment: the shortcut is false; the draft's explicit counterexample to that shortcut is valid.** This is the retired route `R_FINITE_VALUATION_SUPPORT`, not a counterexample to the manuscript's Kummer lemma or main theorem.

## Exact claim and construction

The rejected assertion is that every element of
\(\varprojlim_n\mathbb Q^\times/(\mathbb Q^\times)^{\ell^n}\)
has only finitely many nonzero \(\ell\)-adic valuation coordinates. For distinct rational primes \(p_j\ne\ell\), \(j\ge1\), the old draft, Section 1, gives
\[
 a_n=\prod_{1\le j<n}p_j^{\ell^j}
       \pmod{(\mathbb Q^\times)^{\ell^n}}.
\]
Each \(a_n\) is a finite product. The quotient \(a_{n+1}/a_n=p_n^{\ell^n}\) is an \(\ell^n\)-th power, so the classes form a compatible inverse-limit element. For fixed \(j\), its valuation coordinate is \(\ell^j\in\mathbb Z_\ell\), nonzero for every \(j\). There are infinitely many such coordinates, although only finitely many survive modulo any fixed \(\ell^n\). This verifies both compatibility and the claimed failure of finite support without an infinite product in \(\mathbb Q^\times\).

## Scope and consequence

This element ramifies at infinitely many \(p_j\). It is therefore **not** a class unramified outside a fixed finite \(S\), and does not contradict the simultaneous-valuation-kernel/S-unit statement reviewed in the completion unit. The correct replacement uses the finite-level S-class-group sequence, with multiplication by \(\ell\) on obstruction classes.

The old ledger explicitly records the retirement reason; it must not be reopened as an unresolved promising route. Its goal reference is the latest `L_KUMMER_COMPLETE@v4`, with no outstanding obligations, and the reason is the infinite-support construction above. That route status is more informative than the old graph's empty routes object.

The source is old Argus `research/uniform_kummer_bridge.md`, Section 1, and its ledger. OpenAI's manuscript at revision `4eaee87548250b2682affda7d05d947c05554bae`, October 5, 2026, `build/sections/matching.tex`, `lem:kummer-unramified`, explicitly works in the full completion and does not assume finite valuation support. Rejecting this Argus shortcut must not be reported as finding an error in that manuscript.

This is an exact written construction, not a bounded negative search or a machine-formalized theorem. It needs no new computational search, Lean file or novelty claim. The substantive conclusion is narrow and fully determined; native independent review still decides acceptance of this assessment.
