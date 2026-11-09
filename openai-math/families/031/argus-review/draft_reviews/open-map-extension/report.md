# Extension from a surjection to an open-image map

**Assessment: supported with the original logarithmic and local hypotheses retained.** This reviews `EXT_OPEN`, the final claim in Section 4 of old `uniform_kummer_bridge.md`. It is not a separately versioned or independently judged claim in the old ledger.

## Exact conditional statement

Take a continuous \(f:G_K\to P_N\) with **open image**, where \(N=\mathbb Q(i)\), or any finite \(N\subset\mathbb Q^s\) under the general-target assessment. Suppose \(\ell\) is odd and \(\log(\chi_\ell f)=\log\chi_{K,\ell}\). Define activity and missed primes relative to this map and the original target field \(N\). The same away-from-\(\ell\) stabilizer bound, and the total bound \(2[K:\mathbb Q]+g_\ell(N)\), follow. Openness alone is not being asserted to imply logarithmic compatibility.

## The additional argument actually needed

Let \(H=f(G_K)\), an open subgroup of \(P_N\). Restriction
\[
 H^1(P_N,M)\longrightarrow H^1(H,M)
\]
is injective for the characteristic-zero module \(M=\mathbb Q_\ell(1)\). This holds even when \(H\) is not normal. Indeed its normal core \(H_0\) is open and normal; a class vanishing on \(H\) vanishes on \(H_0\). Inflation-restriction identifies the latter kernel with finite-group cohomology \(H^1(P_N/H_0,M^{H_0})\), which is zero by the same averaging argument used in the inverse-twist lemma. Averaging is legitimate for a finite group over \(\mathbb Q_\ell\), whether or not its order is divisible by \(\ell\).

The independent original target Kummer classes therefore remain independent on \(H\), and inflation along the surjection \(G_K\twoheadrightarrow H\) is injective with the pulled-back module. This replaces exactly the point in the original proof where target surjectivity was used. Source restriction to the finite twist kernel is unchanged.

Crucially, this does not relabel missed primes as primes of the fixed field of \(H\), nor add an unjustified factor \([P_N:H]\) to the bound. The original \(N\)-prime Kummer classes are the ones being restricted. At the ramification step, Uchida's local statement requires open image and hence still supplies a containing target inertia group at the \(N\)-level. The finite-twist, completion, place-multiplicity and finite-subset arguments consequently remain valid.

## Attribution and remaining scope

The manuscript source is OpenAI, October 5, 2026, revision `4eaee87548250b2682affda7d05d947c05554bae`. Its `preliminaries.tex`, conventions and local part of `thm:local-correspondence`, explicitly allow open image, whereas `matching.tex`, `prop:uniform-missed-primes`, is stated after the normalized surjection. The Argus sentence is thus a conditional extension of that specialized proposition, not a proof of the manuscript's normalization or unrestricted open-homomorphism theorem.

The averaging identity was replayed in `../uniform-missed-primes/replay.json`; the topological normal-core and inflation-restriction reasoning was read as mathematics, not checked by that program. The same classical Kummer, class-group, S-unit and local-correspondence assumptions are retained. The archived and fresh Jacobian evidence supply only the same small rational identity. No Lean compilation or statement-fidelity certificate exists.

No gap was identified in this conditional extension. The concrete obligation in any application is still to supply logarithmic compatibility for the actual open map. It cannot be removed by citing the extension, by a successful symbolic replay, or by the mere fact that the image is open.
