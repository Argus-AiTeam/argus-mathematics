# External inputs and the primary-source lookup

The source reader was the separately invoked `analytic-source-reader`, not
an independent Reviewer of `proof.md`. The passages below were returned
after primary-source reading; they are not quotations manufactured from
search summaries. No `citation_check attribute` verdict is claimed here.
That command archives under `research/literature/`, outside this mission's
writable paths. Independent citation adjudication remains for the Host's
review path. No self-supporting attribution has been filed under a second
name.

## Inputs actually used

**A34-RELATIVE (explicit standard input; precise primary locator unobtained).**
For a projective holomorphic map, a holomorphic line ample on every fiber is
relatively ample; a relatively ample line has relative Serre vanishing for
large powers. A finite cover of a compact base makes the threshold uniform.
This is used only in section 1. It is not being inferred from Riemann-Roch.
The local positive metrics needed for the fiberwise criterion are exhibited
there. The ledger deliberately records this source without a fabricated
canonical identifier or proposition number.

**A34-GRR (source read).** Roni N. Levy, *The Riemann-Roch theorem for complex
spaces*, Acta Mathematica 158 (1987), 149-188.
Canonical identifier: `doi:10.1007/BF02392258`.
Locator: opening unnumbered Riemann-Roch theorem, p. 149, parts (a), (b).
Primary scan opened:
<https://archive.ymsc.tsinghua.edu.cn/pacm_download/117/6397-11511_2006_Article_BF02392258.pdf>.

The theorem normalizes the transformation on a regular space and asserts
compatibility for "a proper morphism of complex spaces". This is an analytic
K-homology formulation. The cohomological equation (3) is its standard
smooth-manifold Chern-character/Todd translation, not a purported verbatim
formula from p. 149. Projective analytic maps are within its proper scope.

**A34-FLATTEN (explicit standard input; exact original source unavailable).**
We use projective analytic flattening of a proper projective holomorphic
map by a modification of its base, followed by projective smooth
resolutions; the reduced main transform is equidimensional. The base and
resolved total space can be kept compact Kähler. The original source is
Hironaka, *Flattening Theorem in Complex-Analytic Geometry* (1975).
The JSTOR landing page and PDF endpoint did not yield readable text in the
source lookup. Therefore no original theorem number is asserted or
canonically attributed in the ledger.

Three related primary statements were read, with the following precise
limits:

- Barlet, `arxiv:1504.01579v1`, Theorem 4.1.1, p. 37, with Definition 3.1.1
  and discussion pp. 20-21:
  <https://arxiv.org/pdf/1504.01579>. Under its quasi-proper surjectivity and
  fiber-cycle properness condition, "there exists a modification" making
  the strict transform geometrically f-flat; the discussion explicitly
  gives equidimensionality. It **does not alone state projectivity** of the
  modification, so it is not mislabelled as the entire input.
- Bierstone-Milman, `arxiv:alg-geom/9508005v2`, section 0.2(2), p. 3, and
  Theorem 1.6, p. 5:
  <https://arxiv.org/pdf/alg-geom/9508005>. The permitted category includes
  "Real or complex analytic spaces"; resolution is by a finite sequence of
  blowups with smooth centers.
- Blanchard, `doi:10.24033/asens.1045`, Theorem II.6, p. 202:
  <https://www.numdam.org/item/10.24033/asens.1045.pdf>. For compact Kähler
  \(X\), blowing up a smooth submanifold produces a Kähler manifold.

An unverified search result purported to quote Hironaka Theorem 4.4 from a
copyright-bypass site. It was not opened, used, or accepted as source text.
The standard flattening input is explicit rather than hidden behind that
unverified quotation. The new analytic argument starts **after** this input
and does not presume that its subsequent resolution stays equidimensional.

**A34-REG (sufficient primary replacement read).** Jean-Pierre Demailly,
*Pseudoconvex-Concave Duality and Regularization of Currents*, MSRI
Publications 37 (1999), Theorem 9.1, pp. 263-264:
<https://library.slmath.org/books/Book37/files/demailly.pdf>.

Immediately before Theorem 9.1 the author says it was proved in Demailly
1992. For a closed almost positive current \(T\geq\gamma\), the theorem
gives cohomologous currents smooth off \(E_c(T)\), with lower bound
\[
 T_{c,k}\geq\gamma-\min\{\lambda_k,c\}u-\varepsilon_k\omega,\quad
 \lambda_k(x)\downarrow\nu(T,x),\quad\varepsilon_k\downarrow0.
\]
Here \(u\) is a suitable fixed smooth nonnegative curvature bound.
When all Lelong numbers vanish, \(E_c(T)\) is empty. Compactness and
monotonicity give uniform convergence of the continuous \(\lambda_k\)
to zero, producing smooth representatives with arbitrarily small
negative lower bound. This proves the needed nefness implication.

The original JAG 1 (1992), Theorem 1.1, URL
<https://www-fourier.univ-grenoble-alpes.fr/~demailly/manuscripts/regularization.pdf>
was unavailable through the attempted fetches. Its exact wording is **not**
claimed to have been checked. The sufficient replacement above, not that
unread text, is what the proof relies on.

**A34-KT (source read).** Dinh-Nguyen, *The mixed Hodge-Riemann bilinear
relations for compact Kähler manifolds*, `arxiv:math/0501449v2`, Theorem A,
p. 3, definitions p. 2:
<https://arxiv.org/pdf/math/0501449>. The theorem assumes a compact Kähler
manifold and Kähler forms and proves positivity on the mixed primitive
subspace. The index inequality in degree \((1,1)\) yields the usual mixed
intersection log-concavity; nef real classes follow by perturbation and
continuity.

For an explicit inequality statement the reader also opened Demailly,
*L2 Vanishing Theorems for Positive Line Bundles and Adjunction Theory*,
`arxiv:alg-geom/9410022v3`, Proposition 10.2(b), p. 69, and Remark 10.3,
pp. 70-71: <https://arxiv.org/pdf/alg-geom/9410022>.
Remark 10.3 displays the mixed inequality and its nef-cohomology version.
Its generalized inequality is posed as an exercise there; Dinh-Nguyen is
the proved primary foundation used above.

**A34-VOL (source read).** Boucksom, *On the volume of a line bundle*,
`arxiv:math/0201031v1`: <https://arxiv.org/pdf/math/0201031>.
Definition 1.3, p. 3 defines volume for real pseudo-effective classes by
the supremum of absolutely continuous Monge-Ampere masses. Proposition
4.1, p. 12 gives pullback volume multiplied by the degree of a generically
finite holomorphic map; degree one gives modification invariance.
Proposition 4.3, p. 12 identifies nef volume with top intersection.
Proposition 4.7, p. 15 states superadditivity and continuity.
Monotonicity in pseudo-effective order follows from that superadditivity
and nonnegativity. No pushforward-invariance claim is inferred.

## Inputs avoided and known failed shortcuts

The full signed-current support statement was not located at an exact
primary proposition, so section 3 proves it locally. Demailly's same
`alg-geom/9410022v3`, Exercise 1.21 and the preceding proof, p. 11, do
support the dimension-principle half: a normal degree-\(q\) current
supported on a real submanifold of codimension \(>q\) is zero. That is
consistent with, but not a substitute for, the full proof supplied here.
The original manuscript's exceptional cohomological kernel and relative
negativity claims are not external dependencies of our replacement.

Pseudo-effectivity alone cannot yield nefness: the exceptional curve on
\(\operatorname{Bl}_z\mathbb P^2\) is effective and has self-intersection
\(-1\). Route R34-NAIVE-NEF is retired for this reason. Nor can zero Lelong
numbers simply be asserted before flattening; (25) supplies a compliant
non-equidimensional example with a positive Lelong number.

The local wiki index search for direct images, flattening, nefness,
Kähler intersection theory, and nonvanishing found no relevant entry.
No inherited cross-campaign fact was used.

## Narrow prior-art result and novelty limit

A search-generated claim attributed the exact relative volume inequality
to BFJ, `math/0612138`, Section 8, Theorem 8.1. The source reader opened
<https://arxiv.org/abs/math/0612138>: that identifier instead denotes
Futer-Kalfagianni-Purcell, *Dehn filling, volume, and the Jones polynomial*.
The actual BFJ preprint, *Differentiability of volumes of divisors and a
problem of Teissier*, `arxiv:math/0608260v2`, was opened at
<https://arxiv.org/pdf/math/0608260> and
<https://arxiv.org/html/math/0608260v2>. Its contents list only sections
1-4. The alleged locator does not exist in that version.

This rejects that particular retrieval lead, not the possibility that
the inequality, its nef extension, or sharpness is known elsewhere.
No priority or verified-new claim is made. The present result is an
independent universal verification of the assigned lemma with an explicit
optimality construction, awaiting independent mathematical review.
