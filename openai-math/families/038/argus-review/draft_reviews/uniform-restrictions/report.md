# Uniform restriction images

**Engineer assessment: supported at the stated geometric scope.** This is a
reproduction and elaboration of the manuscript's restriction-image lemma, not
a new result, an extension theorem, or independent acceptance of the family.

## Claim, hypotheses, version and attribution

Let \(X/\mathbb C\) be a fixed smooth connected projective \(n\)-fold,
\(n\geq1\), let \(L\) be ample, and fix \(k>0\) such that \(kL\) is very ample.
For each \(1\leq d\leq n\), there are \(C_d,H_d\), depending only on
\((X,L,k,d)\), such that, for every integral closed \(d\)-dimensional
\(W\subset X\) and every integer \(h\geq H_d\),
\[
 (d!I_W(h))^{1/d}\geq h-C_d,\qquad
 I_W(h)=\dim_{\mathbb C}\operatorname{im}
 [H^0(X,hL)\longrightarrow H^0(W,hL|_W)].
\]
No smoothness, normality, degree bound, or fixed choice of \(W\) is imposed.

The historical Argus draft is `9000038/research/fujita_point_center/report.md`,
lines 127-194, equations (2)-(5). `UR9000038` versions 1, 2 and 3 have the
same statement; versions 2 and 3 expose additional external inputs. The
original is OpenAI, *Fujita's freeness conjecture*, September 23, 2026,
`build/sections/centers.tex`, `lem:uniform-restrictions`, lines 27-130.
The seven TeX sources agree with the hashes in the existing manifest at
revision `4eaee87548250b2682affda7d05d947c05554bae`; see
[`../input_bindings.json`](../input_bindings.json). Attribution and version
agreement do not establish the manuscript's main theorem.

## Decisive argument

Set \(D_0=k^d\). Positive integral intersection degree gives
\(D=(kL)^d\cdot W\geq D_0\). A general basepoint-free linear projection
\(W\to\mathbb P^d\) is finite: its pullback of \(\mathcal O(1)\) is ample,
so a positive-dimensional projective fiber would contain a curve on which
that bundle is trivial. Its field degree is \(D\).

The characteristic-zero geometric generic fiber has \(D\) distinct points.
Choosing only \(D_0\) of them is the uniformity step. Products of separating
affine linear forms, homogenized to degree \(D_0\), give rank at least \(D_0\)
for the restriction map over \(K=\mathbb C(\mathbb P^d)\). Rank is preserved
under field extension. Therefore a fixed complex monomial spanning set
contains \(D_0\) forms with \(K\)-independent normalized restrictions.
Multiplying each by all base monomials of degree \(q-D_0\) gives
\[
 I_W(qk)\geq k^d\binom{q-k^d+d}{d},\qquad
 (d!I_W(qk))^{1/d}\geq qk-k^{d+1}.
\]
Independence follows by dividing a complex linear relation by a power of the
projection coordinate: it becomes a relation over \(K\); the remaining base
polynomials vanish because the projection is surjective.

Finally choose a globally generated \(h_rL\) in each residue class modulo
\(k\), once for the fixed ambient variety. A section nonzero on \(W\) injects
restriction images by multiplication because \(W\) is integral. The section,
but not \(h_r\), may vary with \(W\). Thus
\[
 C_d=H_d=\max_r h_r+k^{d+1}
\]
works in every sufficiently large degree, not merely on multiples of \(k\).
Every constructed section comes from \(X\). Replacing \(I_W(h)\) by the full
space on \(W\), or using a center-dependent Hilbert threshold, would miss the
actual assertion; neither substitution occurs in this proof.

## Evidence and external inputs

The proof is an ordinary geometric argument, not a Lean theorem or a finite
experiment. The old source passages are byte-version-bound by the existing
manifests. Stacks Proposition 28.27.13, tag `01Q3`, supplies eventual global
generation; Lemmas 33.45.4, 33.45.9 and 33.45.11, tags `0BEQ`, `0BEV`, `0BEX`,
supply integrality, positivity and finite-map degree multiplication.
The old `reviewer_source_excerpts.txt` quotes their applicable hypotheses.
Finite linear projection is explicitly exposed as a geometric input in the
active ledger, rather than attributed to the Lean certificate.

The old ledger contains both Engineer and `reviewer:copilot` supporting
judgements for this unchanged proposition, and reviewer-labelled readings of
the Stacks inputs. They can be reused as attributable historical opinion and
source passages. The simultaneous pending reviewer receipt means their
independent origin and acceptance authority are not established; the filenames
and labels do not close this review.

## Remaining obligations and exclusions

No mathematical gap was found in this restriction-image derivation under the
stated complex-projective hypotheses. The native Reviewer must examine the
projection/interpolation uniformity and the quoted Stacks inputs. The active
ledger retains the old prose citations without inventing a versioned identifier.
No extension/surjectivity statement, uniform slope
\((L^d\cdot W)^{1/d}\) for unbounded moving centers, verified novelty, or proof
of Fujita's conjecture follows from this unit.
