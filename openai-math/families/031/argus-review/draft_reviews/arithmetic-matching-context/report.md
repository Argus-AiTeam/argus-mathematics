# Surrounding local arithmetic and matching claims

**Assessment: partial contextual support, not certification of the four surrounding manuscript results.** The reviewed bridge proves one input to the matching chain. It does not prove that chain's norm, finite-fiber, simultaneous-separation or residue-characteristic claims.

## Exact source and statements

The source is OpenAI, October 5, 2026, revision `4eaee87548250b2682affda7d05d947c05554bae`, `build/sections/preliminaries.tex` and `matching.tex`. The old ledger versions are all 1.

**`L_NORM_IDENTITY`.** In `lem:norm-identity`, for an active pair \((v,w)\) at odd \(\ell\), \(b(g)\) is the source residue exponent and \(a(g)\) the target residue exponent of the image, measured by \(Nv\)- and \(Nw\)-Frobenius. The claim is
\[
 (Nv)^{b(g)}=(Nw)^{a(g)}\quad\text{in }\mathbb Z_\ell^\times
 \qquad(g\in D_v),
\]
with continuous profinite powering. The source explicitly does **not** assume all source inertia maps into target inertia. The missing certification is the tame-conjugation/local-decomposition calculation for these actual exponent maps. The bridge's prime-to-\(\ell\) index identity is not this equality.

**`C_FINITE_FIBERS`.** In `matching.tex`, lines 5-19, retain the constructed normalized \(\beta\), put \(B=\mathbb Q(i)\), \(G_K=\beta^{-1}(P_B)\), and let \(\mathcal V_w\) be the union of active source partners over **all** eligible auxiliary primes. `lem:finite-fibers` asserts that this union is finite for all but finitely many target primes over rational primes split in \(B\). This is stronger than finite fibers for one fixed auxiliary prime.

The written deduction is visible: choose a fixed eligible \(r\), a nonzero sign character \(\psi\), and
\(z=\psi(\operatorname{Fr}_w)/\log_r q\ne0\) for suitable degree-one \(w\mid q\). Pull back \(\psi-z\log\chi_r\) to \(y\) on \(G_K\). Its corestriction is
\(-z[K:\mathbb Q]\log\chi_{\mathbb Q,r}\ne0\). Decomposition containment makes \(y\) vanish at the partners away from \(r\), and character-detection (iii) bounds their number; primes above \(r\) add only a finite set. This explains the conditional mechanism. The concrete unverified prerequisites are the sign character, normalization, decomposition containment across the varying activity primes, and the exact character-detection theorem. The missed-prime unit count alone gives none of them.

**`C_POWER_SEPARATION`.** `lem:power-separation`, matching.tex line 132, says: for \(m,d\ge1\), distinct rational primes \(q_1,\ldots,q_n\), and finite prime sets \(\mathcal P_j\) with \(q_j\notin\mathcal P_j\), there are infinitely many odd \(\ell\equiv1\bmod m\), outside any prescribed finite avoidance set and all displayed prime sets, such that
\[
 p^f\bmod\ell\notin\langle q_j\bmod\ell\rangle
 \quad(1\le j\le n,\ p\in\mathcal P_j,\ 1\le f\le d).
\]
The \(\mathcal P_j\)'s may overlap and may contain \(q_i\) for \(i\ne j\). The concrete unverified obligation is simultaneous Kummer/Frobenius separation with these overlap and congruence constraints and infinitely many auxiliary primes. The saved field fixtures and a single nonquadratic residue computation do not address it. No contrary example or falsehood is asserted here.

**`C_SAME_CHARACTERISTIC`.** `prop:same-characteristic`, matching.tex line 159, asserts: for all but finitely many \(w\) above rational primes \(q\) split in \(B\), some \(v\mid q\) of \(K\) and some \(\ell\in\mathcal L\) form an active pair for \(\beta_B\). The auxiliary prime may depend on the pair. The old graph correctly requires finite fibers, power separation, the uniform missed-prime bound and the norm identity. A cardinality bound on missed targets at a fixed \(\ell\) does not by itself identify any source residue characteristic.

## Claim-to-evidence boundary

These four versions have no old ledger supports judgements or mechanical proofs. The reference source is accessible, so this is not an access-failure assessment. Their written assertions and dependency mechanism are identified, but auditing their remaining proofs would be the new manuscript-error search that the current objective excludes.

The only promoted input here is the **conditional** uniform bridge, together with the local Uchida hypothesis within its exact scope. We have not treated the manuscript's full local-correspondence statement, including cofinite coverage, as a new independent result. Nor has the verifier tested the infinitely many primes, exponent maps, overlaps or varying-\(\ell\) fibers above. No Lean compilation or formal statement-fidelity result is present.

Consequently the finite-fiber deduction is understandable conditionally and the uniform-bound input is supported, while the surrounding chain remains uncertified by the old evidence. This identifies concrete obligations without declaring the manuscript correct or invalid and without launching a new search.
