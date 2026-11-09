# Unramified Kummer completion

**Assessment: supported written lemma, conditional on the recorded classical inputs; not a kernel proof.** This reviews `L_KUMMER_COMPLETE` versions 1-4 in the old ledger. The natural statement is unchanged; versions 2, 3 and 4 successively disclose finite Kummer theory, class finiteness and S-unit finite generation. The old engineer and reviewer judgements bind version 4, not the earlier assumption-incomplete records.

## Exact statement and attribution

For a number field \(F\), a rational prime \(\ell\), and a finite set \(S\) containing infinity and the primes above \(\ell\),
\[
 H^1_{\rm cont}(G_F,\mathbb Q_\ell(1))_{\rm unr\ outside\ S}
 \simeq \mathcal O_{F,S}^{\times}\otimes_{\mathbb Z}\mathbb Q_\ell
\]
equivariantly for field automorphisms preserving \(S\), with the coefficient action on the Tate twist included. The bridge uses odd \(\ell\); this completion argument itself does not use oddness.

The Argus argument is old `research/uniform_kummer_bridge.md`, Section 1. Its manuscript counterpart is OpenAI, *Open Homomorphisms of Global Solvably Closed Galois Groups*, October 5, 2026, revision `4eaee87548250b2682affda7d05d947c05554bae`, `build/sections/matching.tex`, `lem:kummer-unramified`, lines 45-77. This is a detailed reproduction of standard Kummer/S-unit reasoning, not an established new result.

## Decisive argument

Finite Kummer theory identifies \(H^1(G_F,\mu_{\ell^n})\) with \(F^\times/(F^\times)^{\ell^n}\). In passing to integral continuous cohomology, the possible \(\varprojlim^1 H^0\) vanishes: the degree-zero groups are finite, so the images at each fixed level stabilize. This is a Mittag--Leffler assertion, not an assumption that all transition maps are surjective.

A continuous rational cocycle on the compact group \(G_F\) has bounded image and can be scaled into \(\mathbb Z_\ell(1)\). A rational cobounding element can likewise be scaled to an integral one. These two observations justify localization of integral \(H^1\), including its kernel, rather than merely an informal exchange of tensor product and inverse limit.

Away from \(\ell\), the Tate module is unramified. Local Kummer restriction is valuation times the tame \(\ell\)-adic character: prime-to-residue-characteristic roots of units lie in the maximal unramified extension by Hensel lifting. The resulting integral inertia homomorphisms are torsion-free, and inertia coboundaries vanish. Consequently a rationally unramified integral class has zero integral valuation coordinate at every prime outside \(S\).

Let \(H_n\) consist of finite-level classes with these valuations divisible by \(\ell^n\), and put \(A=\operatorname{Cl}_S(F)\), \(U=\mathcal O_{F,S}^{\times}\). The sequence
\[
 0\longrightarrow U/U^{\ell^n}\longrightarrow H_n
 \longrightarrow A[\ell^n]\longrightarrow0
\]
sends \([a]\), with \(\operatorname{div}_S(a)=\ell^nD\), to \([D]\). Its transition on \(A[\ell^n]\) is multiplication by \(\ell\): the same divisor at the preceding level is \(\ell^n(\ell D)\). This direction is essential.

If \(\ell^a A\{\ell\}=0\), a compatible obstruction satisfies \(x_n=\ell^a x_{n+a}=0\). At every level the corresponding class therefore has a unique preimage in \(U/U^{\ell^n}\); uniqueness makes these preimages compatible. Thus the simultaneous kernel of all outside-\(S\) valuations is precisely the completed S-unit group. Finite generation then gives its rationalization \(U\otimes\mathbb Q_\ell\). Divisors, units, class-group maps and Kummer maps respect field automorphisms and the Tate twist. None of these steps assumes finite valuation support in the full completion.

## Sources and evidence limits

The exact inputs are Stacks `stacks:03PK`, Lemma 59.28.1 (tag 03PL) and the following \(H^1\)-Picard sequence, with the invertibility hypothesis; Milne, *Algebraic Number Theory* **v3.08 (2020-07-19)**, Theorem 4.4, p. 70, for finite class number and its S-class quotient; and Bass, DOI `10.1017/S0027763000026258`, Section 3, p. 402, for S-unit finite generation. Invertibility holds on both \(\operatorname{Spec} F\) and the S-integer scheme because \(S\) contains the primes above \(\ell\).

The old `reviewer-finite-kummer.txt`, `reviewer-class-finiteness.txt`, and `reviewer-bass-units.txt` were reconciled with the archived primary passages. The supporting citation records are respectively `c0277005786d7c14e39a0bb319be4497.json`, `27ccd20493b8fe8c80cefed0afe5f3f4.json`, and `7076545e94dc543e6ca89d45d260ab2d.json` under old `research/literature/`. They do not prove the inverse-limit argument for us; that argument was read above.

The shared fresh replay in `../uniform-missed-primes/replay.json` checks the divisor-transition identity and rejects its identity-transition corruption. It does not mechanically prove class finiteness, the cohomological limit comparison or local unramifiedness. There is no Lean theorem, compiler certificate or statement-fidelity approval to inherit. No mathematical gap in this scoped written lemma was identified; its use in the full manuscript still requires the separate upstream hypotheses.
