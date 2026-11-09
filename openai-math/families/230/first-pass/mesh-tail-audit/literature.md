# Primary-source scope readings

The independent `mesh-literature` source reader checked the following primary
texts on November 5, 2026. This note preserves its mathematical readings;
it is not independent Reviewer acceptance of this audit's theorem.

## Fixed-order estimates, not the disputed tail

[Rezaei--Zhan, arXiv:1412.3700v2](https://arxiv.org/pdf/1412.3700v2),
Theorems 1.1--1.2, PDF p. 3; Remark 4, p. 4; proof pp. 21--22.
The arXiv version record dates v2 to July 21, 2017; the fetched PDF's
title page has a later date. This version/date discrepancy is not silently
treated as a different theorem.

For fixed \(0<\kappa<8\), put \(d=1+\kappa/8\), \(p=2-d\),
\(\alpha=8/\kappa-1\), and

\[
 P_y(x)=
 \begin{cases}y^{\alpha-p}x^p&x\le y,\\x^\alpha&x\ge y.\end{cases}
\]

For distinct \(z_0=0,z_1,\ldots,z_n\in\overline{\mathbb H}\), write
\(y_k=\Im z_k\) and \(\ell_k=\min_{j<k}|z_k-z_j|\). Theorem 1.1 gives

\[
 \mathbb P\{\operatorname{dist}(z_k,\gamma)\le r_k,\ 1\le k\le n\}
 \le C_{\kappa,n}\prod_{k=1}^n
       P_{y_k}(r_k\wedge\ell_k)/P_{y_k}(\ell_k).
\]

The enumeration is not a chronological visit order. Theorem 1.2 gives
finite moments of every integer order of natural content in a bounded
observation subset of the half-plane. It is not a uniform estimate over
initial marked domains. Remark 4 describes an exponential moment as a
guess, not a proved theorem.

Fixed-order finiteness alone cannot yield
\(\mathbb P(X>u)\le C\exp(-cu^{2/p})\). One would need quantitative
growth, for example \(\|X\|_n\le K n^{p/2}\), uniformly over the actual
domain and mesh class. Moreover natural content and the finite-mesh
stopped-density integral are different variables.

## Green decrease

[Schramm--Sheffield, arXiv:1008.2447v1](https://arxiv.org/pdf/1008.2447v1),
August 14, 2010, Lemmas 2.5--2.6, pp. 16--18.
These statements concern SLE4, with \(W_t=2B_t\),
\(f_t=g_t-W_t\), and
\(h_t=\sqrt{\pi/8}(1-2\arg f_t/\pi)\).
With

\[
 G_{\mathbb H}(z,w)=(2\pi)^{-1}
       \log|(z-\bar w)/(z-w)|,
\]

Lemma 2.5 identifies \(dG_t(z,w)=-d\langle h(z),h(w)\rangle_t\).
Lemma 2.6 integrates against deterministic smooth compactly supported
real test functions. This is not a cited theorem about the asynchronous
cutoffs or every \(\kappa\).

## Finite Green changes of law

[Lawler--Werness, arXiv:1011.3551v4](https://arxiv.org/pdf/1011.3551v4),
June 5, 2013, Sections 2.3--2.4, Lemmas 2.8--2.9,
equations (7)--(9), and Proposition 2.12, PDF pp. 10--14.
Their parameters are \(a=2/\kappa\), \(d=1+1/(4a)\),
\(\beta=4a-1\); their conformal radius is half the full radius.
The tilted angle satisfies

\[
 d\Theta_t=dB_t^*+2a\cot\Theta_t\,dt,
 \qquad \pi(d\theta)=C_{4a}\sin^{4a}\theta\,d\theta.
\]

Lemma 2.9 gives uniform estimates for nonnegative integrable test
functions after any fixed positive elapsed time. The choice
\(F=\sin^{-\beta}\) is integrable since \(4a-\beta=1\).
Proposition 2.12 identifies the finite-radius Radon--Nikodym density
with \(\varepsilon^{d-2}\sin^\beta\Theta_{\rho_\varepsilon}/G(z)\).
The ordinary law is restricted to the finite-hit event; it is not the
normalized conditional law and no completed infinite-future density is
claimed.

## Trace and topology

[Rohde--Schramm, published Annals PDF](https://annals.math.princeton.edu/wp-content/uploads/annals-v161-n2-p07.pdf),
161 (2005), 883--924, DOI 10.4007/annals.2005.161.883,
Theorem 5.1, printed p. 899.
For fixed \(\kappa\ne8\), the shifted inverse-map limit exists at all
times almost surely, is continuous, and generates the stated unbounded
surviving component. This covers each fixed \(0<\kappa<8\).

[Loridant--Luo, arXiv:1703.05914v1](https://arxiv.org/pdf/1703.05914v1),
March 17, 2017, Lemmas 2.4 and 2.6, pp. 7--8.
Lemma 2.4 preserves local connectedness when complementary components
of a continuum are filled. Lemma 2.6 gives local connectedness of the
boundary of a complementary component of a locally connected planar
continuum. Its additional simple-closed-curve conclusion requires no
cut point; that stronger conclusion is not used here.

## Occupation identity: version limitation

[Mörters--Peres author draft](https://www.stat.berkeley.edu/~aldous/205B/bmbook.pdf),
May 25, 2008, Definitions 3.27/3.30 and Theorem 3.31, pp. 82--83.
For Brownian motion killed at exit \(T\) from a bounded domain, with
killed transition subdensity \(p^*\) and
\(G(x,y)=\int_0^\infty p^*(t,x,y)\,dt\), the nonnegative occupation identity is

\[
 \mathbb E_x\int_0^T f(B_t)\,dt=\int f(y)G(x,y)\,dy.
\]

This allows infinite values. It implies no uniform boundary-layer bound
without an additional argument. The final 2010 edition's numbered
Definitions 3.28/3.31 and Theorem 3.32 were not obtained from the publisher's
access page. The draft's numbering is not represented as the final edition.

## Bounded originality comparison

The source reader also inspected
[Holden--Yuan, arXiv:2211.15609v4](https://arxiv.org/pdf/2211.15609v4),
Proposition 3.10, pp. 19--20, and Proposition 6.3, pp. 42--43.
The former controls diameter increments for specified whole-plane
variants, hence a different direction of content fluctuation.
The latter's ordinary non-space-filling conclusion is superpolynomial
control of restricted variation; the exponential assertion is for a
different, space-filling functional.

No inspected result states the final-mesh-uniform
\(\exp(-cu^{2/p})\) stopped-density estimate or its uniform extension
to all bounded locally connected simply connected initial domains.
This is a bounded comparison, not verified global novelty.

## Additional directly read conformal background

The Engineer obtained the cited June 8, 2015 author notes from
<https://people.maths.ox.ac.uk/belyaev/TCC/lecture_notes.pdf>.
The primary PDF and its text are retained as
`sources/beliaev2015.pdf` and `sources/beliaev2015.txt`.
Theorem 3.2.5 and Corollary 3.2.6, pp. 39--40, give the normalized
Koebe quarter theorem and boundary-distance interval \([1/4,1]\).
Theorem 2.6.6, p. 23, gives the boundary homeomorphism for Jordan
domains. Theorem 2.6.13, p. 26, states the general prime-end
correspondence; the notes explicitly present it without a proof.
The report supplies the locally connected-boundary consequence rather
than misquoting the Jordan-only theorem as that stronger assertion.

The primary Pommerenke 1985 article was also obtained from the publisher:
<https://msp.org/pjm/1985/120-2/pjm-v120-n2-p13-p.pdf>,
retained under `sources/pommerenke1985.*`. Its Theorem 1 is an
exceptional-set decomposition of boundary behavior, not a universal
fresh-tip uniqueness theorem. The report proves the needed uniqueness
by the complement-minus-tip Jordan separation argument; it does not
invoke that theorem's exceptional-set conclusion at a selected tip.
