# Independence and inverse-character orientation

**Assessment: supported conditional written lemma.** This is old `L_TWIST_INJECT@v1`, Section 2 of `uniform_kummer_bridge.md`, supported by the old engineer and reviewer judgement records. Those judgements are opinions about this conditional lemma, not full-manuscript certificates.

## Exact setting and claim

Let \(B=\mathbb Q(i)\), let \(f:G_K\twoheadrightarrow P_B=\operatorname{Gal}(\mathbb Q^s/B)\) be continuous, and let \(\ell\) be odd with \(\log(\chi_\ell f)=\log\chi_{K,\ell}\). Set
\[
 \rho=\chi_\ell f,\quad \epsilon=\rho/\chi_{K,\ell},\quad
 F=\overline K^{\ker\epsilon},\quad \Delta=\operatorname{Gal}(F/K).
\]
The logarithmic kernel in \(\mathbb Z_\ell^\times\) is \(\mu_{\ell-1}\), so \(\Delta\) is finite cyclic, of order dividing \(\ell-1\), and \(\epsilon\) is faithful on it. No equality of the full cyclotomic characters is assumed.

For any finite set of missed target primes away from \(\ell\), their Kummer classes remain independent after pullback and restriction to \(G_F\). Under the natural action on \(H^1(G_F,\mathbb Q_\ell(1))\), their character is **\(\epsilon^{-1}\)**.

The reference manuscript is OpenAI, October 5, 2026, revision `4eaee87548250b2682affda7d05d947c05554bae`, `build/sections/matching.tex`, proof of `prop:uniform-missed-primes`. In that manuscript \(K\) is defined by \(G_K=\beta^{-1}(P_B)\), with \(K/k\) quadratic. One must not replace this definition by an assumption that the map is ordinary field restriction or that \(K\) contains \(B\).

## Decisive argument

Choose \((a_w)=w^{h_w}\), \(h_w>0\). Finite class number permits this; for \(B\) it also follows from class number one. The cyclotomic/radical extensions needed for compatible Kummer cocycles lie in \(\mathbb Q^s\): after a finite solvable normal closure over \(\mathbb Q\), adjoining roots of unity and radicals and taking the finitely many conjugates still gives a solvable extension. Thus these are genuinely classes on \(P_B\), not merely on \(G_B\).

Inflating to \(G_B\) and evaluating at the different \(w\)'s gives the diagonal matrix with entries \(h_w\). Its diagonal is nonzero in \(\mathbb Q_\ell\), even if \(\ell\mid h_w\). This proves independence. Pullback along a surjection is injective for the pulled-back coefficient module: any coboundary identity holding after pullback holds at every target element.

Restriction to the finite-index normal subgroup \(G_F\) is injective as well. A cocycle trivial on that subgroup descends to a cocycle of \(\Delta\) valued in the invariant module. Averaging over \(\Delta\) kills its cohomology in characteristic zero. In the convention \(\delta m(g)=gm-m\), if \(b=|\Delta|^{-1}\sum_d z(d)\), then \(z(g)=b-gb=\delta(-b)(g)\). The sign agrees with the verifier's parameter `-s/d`. No unramifiedness of \(F/K\) is needed.

For a lift \(g\) of \(d\in\Delta\), the natural action on a restricted cocycle \(c\) is
\[
 (d.c)(h)=\chi_{K,\ell}(g)c(g^{-1}hg).
\]
The \(\rho\)-cocycle identity gives
\[
 \rho(g)z(g^{-1}hg)=z(h)+(\rho(h)-1)z(g).
\]
Since \(\rho|_{G_F}=\chi_{K,\ell}|_{G_F}\), this becomes
\[
 (d.c)(h)=\epsilon(d)^{-1}c(h)
       +(\chi_{K,\ell}(h)-1)\epsilon(d)^{-1}z(g).
\]
The second term is an actual coboundary on \(G_F\). Hence the cohomology eigenvalue is the inverse character. Inverting the character cannot be hidden by testing only quadratic twists.

## Evidence and limits

The shared read-only replay (`../uniform-missed-primes/replay.json`) verifies conjugation, the inverse twist modulo coboundary, averaging and diagonal independence. Its order-three residue fixture is \(2\in\mathbb F_7^\times\), with inverse \(4\), not the false assertion that the integer 2 has order three in \(\mathbb Q_7^\times\). It distinguishes the orientations, but constructs no global Galois map. Mutations of the orientation, averaging sign and diagonal recovery are among the 16 rejected built-in certificates.

Finite class number and finite Kummer theory are the same cited inputs detailed in the completion assessment. The finite-group and cocycle arguments above are direct written arguments. No Lean compilation is involved. No gap was identified under the stated hypotheses; existence and normalization of the manuscript's \(f\) are not conclusions of this unit.
