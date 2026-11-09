# Low-height rank-metric covering: mathematical audit

**Outcome offered for independent review.** `quantitative_cover.md` gives a
complete quantitative covering proof and a stronger asymptotic corollary:
heights up to \(\exp(N(\log N)^{1/9})\) have a fixed cover of radius
\(N(\log N)^{-2/3}\) and logarithmic cardinality
\(O(N^2(\log N)^{-1/9})\), uniformly for every \(m\le N\).
This implies the manuscript's full statement for every fixed \(D,A>0\);
it is not a finite-parameter substitute.

The original proof's normal balance, expensive-position count, adaptive
reconstruction, and total cost survive this audit. No false literal
manuscript assertion was found. The quantitative proof obtains the exact
expensive-position constant 21 and zero fiber cost at every first flag
position, eliminating single-drop fiber charges.

`Main.lean` has a real Lean 4.31.0 compiler and axiom-audit run, both with
exit code zero and no proof holes, attached to `L_FLAG_AMORTIZATION`.
It verifies only the universally quantified block amortization and stated
algebra, not the entire covering theorem. `verify.py` and
`exact_certificate.json` replay the exact arithmetic and finite regression
examples; they explicitly do not certify either main singularity theorem.
The theorem's full prose proof, source interpretation, external citation
attributions, significance, and originality await the host's independent
Reviewer. This is an Engineer handoff, not campaign completion.

## Scope and source conventions

The target is the complete, eventual, uniform-in-dimension statement
`thm:low-height-cover` in the unbiased manuscript, not a finite-dimensional
analogue. Write \(U\) for the staged October 3 manuscript and \(B\) for the
staged October 4 manuscript, under `research/openai_manuscript/`.
All source paths below are relative to the relevant manuscript's `build/`.
Here \(\ell=\log\log N\), all unmarked logarithms are natural, and
\[
H(W)=\det(W\cap\mathbb Z^m),\qquad
d(V,W)=\dim V+\dim W-2\dim(V\cap W).
\]
The determinant of a rank-zero lattice is one.

The audited assertion (U, `sections/04-low-height-cover.tex:28-41`) is:
for every fixed \(D,A>0\), for all sufficiently large \(N\), simultaneously
for every integer \(0\le m\le N\), there is a list of rational subspaces,
independent of \(W\), with at most \(2^{N^2\ell^{-A}}\) members, covering
every \(H(W)\le\exp(N\ell^D)\) within distance \(N\ell^{-A}\).
The main singularity assertions are separate obligations; resolving this
cover alone does not establish either singularity theorem.

## Scope retrieval and external inputs

The following primary source was opened before mathematical implementation:

O. Regev and N. Stephens-Davidowitz, *A Reverse Minkowski Theorem*,
arXiv:1611.05979v6 (7 July 2022), Theorem 1.2,
<https://arxiv.org/html/1611.05979v6#S1.Thmtheorem2>.
Its hypotheses are **all sublattices**, not just the full lattice or
rank-one sublattices. Its conclusion, in the source's normalization, is
\[
\det L'\ge1\quad(\text{every sublattice }L'\subseteq L)
\quad\Longrightarrow\quad
\rho_{1/t}(L)\le3/2,\qquad t=10(\log n+2),
\]
where \(\rho_s(L)=\sum_{x\in L}\exp(-\pi\|x\|^2/s^2)\).
Scaling by \(T^{-1}\) gives parameter \(T/t\) when the determinant
lower bound is \(T^{\operatorname{rank}L'}\).
This proposition is an external input, not a theorem proved by this audit.
The source statement has been read by the Engineer; independent citation
attribution remains for the host's Reviewer.

A targeted search for a prior cover with the same simultaneous height,
rank-distance, and entropy bounds did not yield an independently usable
primary source. This is a retrieval limitation, not evidence of novelty.
Generic search summaries supplied inconsistent Grassmannian-counting and
random-matrix bibliographic claims; none is used as a mathematical input.
An attempted arXiv identifier `2106.10278` resolved to an unrelated
correlation-functions paper and was rejected. No claim about the strongest
previous singularity bound or verified originality is made on this basis.
The inherited Wiki index and targeted topic search supplied no directly
applicable low-height covering result.

No failed mathematical route is yet asserted. A fixed small dimension
cannot disprove an eventual asymptotic statement, and a finite exhaustion
cannot prove it.

The second external input is the same primary source, Section 2.1,
Equation (5): \(\rho_s(M)=s^k\rho_{1/s}(M^*)/\det M\) for full-rank
rank-\(k\) lattices. It proves the Gaussian comparison in Section 4 of
`quantitative_cover.md`. Both relevant passages, including their
hypotheses, are transcribed in `literature/rsd_*_excerpt.txt`.
The ledger's `citation_check status` still reports four independent
attributions pending: these two propositions on `C_QUANT_COVER` and
on `L_VECTOR_COUNT`. The Engineer has not self-certified those citations
under a second identity.

## Exact evidence and replay

From the campaign root:

```sh
$WORKSPACE/argus-live-update/.venv/bin/python research/low_height_audit/verify.py
```

The persisted certificate records 13,275 exact cross-submodularity tests
on 15 rational spaces; exhaustive global minimizer candidates in
dimension three at \(N=4,a=1/4\) for six graph-chain targets, including
two multidrop targets; a primitive normal-height and projected-quotient
example with squared determinants \(3,6,2,1/3\); 1,555 abstract flag-block
regressions; exact exponent algebra; and the binding to the existing
fresh compiler attestation. These counts describe experiments, not
proofs of infinite claims.

The Jacobian adapter was discovered and its `matrix.rank.compute`
typed contract inspected before custom finite computation. Its exact
payload and full successful typed output are preserved in
`jacobian_rank_payload.json` and `jacobian_rank_output.json`. The latter
records server 0.14.0, protocol 2025-11-25, the input matrix, rank two,
pivots 0 and 1, and no transport/timeout error. Its mathematical scope
is just that one rank check.

The current compiler certificate is
`certificates/L_FLAG_AMORTIZATION-c86e8ee9c39b8590.json`.
To independently replay compilation without changing the source or its
fidelity document:

```sh
$WORKSPACE/argus-live-update/.venv/bin/python -m argus_skill.verticals.math.lean_evidence verify research/low_height_audit/Main.lean --statement-fidelity research/low_height_audit/statement_fidelity.md --artifact-dir research/low_height_audit --claim L_FLAG_AMORTIZATION --project-root .
```

The earlier durable compiler receipt is retained in
`lean_runner_receipt.json`; that first run found source-level proof
errors, not a mathematical counterexample. The corrected source's
successful real compiler run is `lean_check.json` and `compile.log`.
No mathematical route was retired on account of those implementation
errors.

## Dependency interfaces

U, `sections/01-introduction.tex:7-15`, asserts
\(\Pr(\det A_n=0)=2^{-n+o(n)}\) for unbiased symmetric sign matrices.
Its proof uses the corank/column reductions in Section 2; lattice and robust
extraction tools in Section 3; this cover in Section 4; simultaneous
rank/spectral estimates in Section 5; discriminant pairing and coloring
in Section 6; minor moves in Section 7; and cube concentration,
certificate pricing, and retention cost in Sections 8--10.
These dependencies are recorded as open, not certified.

B, `sections/01-introduction.tex:8-17`, asserts, for each fixed
\(p\in(0,1)\setminus\{1/2\}\),
\[
\lim_{n\to\infty}\Pr(\det A_n^{(p)}=0)^{1/n}
=p^2+(1-p)^2.
\]
Its Section 2 corank/column reduction feeds the static column bound and
path-retention estimates in Sections 5--6. Its
`sections/03-typical.tex:91-117`, `thm:height-cover`, imports this cover
with parameters named \(D,P\), citing U, Theorem 4.1.
Its `sections/04-lattice.tex:76-83` uses height exponent 2 in
`thm:small-intersection`; `:327-460` uses the size of the fixed list in
the tester/net union bound. The latter theorem is simultaneous over
\(B\mathbb Z^m\subseteq K\subseteq\mathbb Z^m\) with
\([\mathbb Z^m:K]\ge N^{\ell^{-D}N}\), and all translates, and bounds
their Boolean-cube intersections by \(2^{\alpha N}\).
It is then used for the color subgroups in B,
`sections/05-pairings.tex:235-275`, and for retention in B,
`sections/06-paths.tex:167-180`.

The source-mapping pass was read-only and did not verify these surrounding
probabilistic or lattice-intersection assertions.
