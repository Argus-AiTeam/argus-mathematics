# Source audit: Costa genus-one/four-end family

## Finding

The cited paper constructs a one-parameter family of **immersions** with four
ends that are individually planar and embedded. It does not claim that the
whole surface is embedded. The family is exactly obstructed from global
embeddedness for every parameter: after the real constant term in Costa's
Gauss map is retained, the end value at \(\pi(\omega _1)\) still has a
strictly positive real part on all \(y>1\). Thus its limiting normal is not
parallel to the vertical limiting normal at \(\pi(0)\), whereas disjoint
embedded finite-total-curvature ends must have parallel limiting normals.

## Primary source

Celso J. Costa, *Complete minimal surfaces in \(R^3\) of genus one and four
planar embedded ends*, Proceedings of the American Mathematical Society
**119** (1993), 1279-1287,
DOI `10.1090/S0002-9939-1993-1160295-2`.

- Crossref confirms the author, title, journal, volume, issue, pages, date,
  DOI, and abstract.
- The complete nine-page AMS version-of-record PDF is preserved at
  `research/costa-g1-k4/source/costa-1993-ams-version-of-record.pdf`.
  Crossref, Unpaywall, Semantic Scholar, and the preserved OpenAlex metadata
  identify the official AMS URL as the published version.
- Direct requests from this host to the current AMS URL returned a Cloudflare
  403 challenge. No challenge was bypassed. The PDF was retrieved from the
  Internet Archive's raw 2017-08-13 Wayback capture of that official AMS URL.
  Its SHA-1 base32 digest exactly matches the Wayback time-map payload digest;
  its SHA-256 is
  `a24dbaae5561cbbd59b9fcad6a0dc18b2e8b25186407bf0ff43b7f4b7d79447f`.
- PDF pages 2, 3, and 4 are printed pages 1280, 1281, and 1282. Readable
  renderings, retrieval URLs and timestamps, time-map metadata, and all file
  hashes are recorded in `research/costa-g1-k4/source/PROVENANCE.md`.
- `research/costa-g1-k4/source/primary-pages-audit.md` compares every sign,
  factor, square, denominator, definition, and strict inequality used by the
  corrected proof against those three page images. No mismatch was found.
- Theorem A (pp. 1279-1280) gives \(I_y:M_y\to\mathbb R^3\) for every
  \(y>1\), where
  \[
  M_y=\mathbb C/L(iy)\setminus
  \{\pi(0),\pi(\omega_1),\pi(\omega_2),\pi(\omega_3)\},
  \]
  \(L(iy)=\{m+niy:m,n\in\mathbb Z\}\),
  \(\omega_1=1/2\), \(\omega_2=(1+iy)/2\), and
  \(\omega_3=iy/2\).
- With \(\wp=\wp_{L(iy)}\), \(e_j=\wp(\omega_j)\), and
  \(a=\alpha+i\beta\), \(b=\alpha-i\beta\), the data are
  \[
  g_y(z)=a(y)\wp(z)+b(y)\wp(z-\omega_3)+e_3c(y),
  \qquad
  f_y(z)=\wp(z-\omega_1)+\wp(z-\omega_2)+e_3.
  \]
  This is formula (1), p. 1280; its last term is real, not \(ic\).
- Equation (7), p. 1281, defines
  \(S_j=2\eta_1+e_j\) and \(S=S_1+S_2\). Equation (10) gives
  \(S_1,S_2>0\), \(e_1>e_2>e_3\), and \(e_3<0\).
- Lemma 1 and equation (12), p. 1282, choose
  \(\alpha(y),\beta(y)>0\) by
  \[
  \frac{(e_1-e_2)^2}{S_j^2}
  \left[\alpha_j(\alpha^2-\beta^2)
        +\beta_j(\alpha^2+\beta^2)\right]=\gamma_j,
  \qquad j=1,2.
  \]
- Equation (13), p. 1282, fixes the real function
  \[
  c(y)=-\frac{2(e_1S_2+e_2S_1)}{e_3S}\,\alpha(y).
  \]
- Proposition 1 and Lemma 1 (pp. 1281-1282) prove, using
  \(e_1>e_2>e_3\) and \(e_3<0\), that the period equations have positive
  differentiable solutions \(\alpha(y),\beta(y)\) for the complete source
  domain \(y>1\). No numerical root search is used.
- The proof of Theorem A reduces all periods to the two lattice generators:
  the puncture residues vanish, \(\operatorname{Re}\int g f\,dz=0\), and
  \(\int g^2f\,dz=\int f\,dz\). Equations (30)-(31) are shown algebraically
  equivalent to Lemma 1's equations (12).
- On p. 1283 Costa checks regularity and completeness: \(g,f\) are
  holomorphic on \(M_y\), \(f\ne0\) there, the pole/zero orders match, and
  the double poles at the punctures make the metric complete.
- On p. 1286 Costa concludes that \(\deg g_y=4\), hence the total curvature
  is \(-16\pi\), and that \(M_y\) has genus one and four planar embedded
  ends.
- The map is proper: every planar embedded end is asymptotic to a plane and
  escapes every compact subset; removing four sufficiently small end
  neighborhoods leaves a compact subset of the torus. Properness does not
  imply injectivity.
- The paper's conclusion is explicitly a "complete minimal immersion."
  "Embedded" in the title and theorem modifies the ends, not the global map.

The endpoint calculation uses only the cited formulas and the elliptic
identity \(e_1+e_2+e_3=0\). Put
\(\Delta=e_1-e_2>0\) and \(S=S_1+S_2>0\). From (13),
\[
\begin{aligned}
e_3(c-\alpha)
 &=-\frac{\alpha}{S}
   \left(2(e_1S_2+e_2S_1)+e_3S\right)\\
 &=-\frac{\alpha}{S}(4e_1e_2-e_3^2)
   =\frac{\alpha\Delta^2}{S}>0.
\end{aligned}
\]
The middle equality uses \(S_j=2\eta_1+e_j\), and the last uses
\(e_3=-(e_1+e_2)\). Hence the exact zero set of
\(e_3(c-\alpha)\) on \(y>1\) is empty.

The four limiting Gauss values are therefore
\[
\begin{array}{c|c}
p_0=\pi(0) & \infty\\
p_1=\pi(\omega_1) & \alpha\Delta^2/S+i\beta\Delta\\
p_2=\pi(\omega_2) & \alpha\Delta^2/S-i\beta\Delta\\
p_3=\pi(\omega_3) & \infty.
\end{array}
\]
In particular, the \(p_1\) value is finite with positive real part, so its
normal is nonvertical and cannot be parallel to the vertical \(p_0\) normal.

## Exact embedded-end boundary

David Hoffman and Hermann Karcher, *Complete Embedded Minimal Surfaces of
Finite Total Curvature*, arXiv `math/9508213v1` (1995), local source copy
`research/costa-g1-k4/source/hoffman-karcher-1995.pdf`.

- Section 2.3 derives the asymptotic expansion of an embedded
  finite-total-curvature end as a planar or catenoidal end.
- Proposition 2.2(ii), p. 22, states that if no two ends intersect, then
  after a rotation all limiting Gauss normals are \((0,0,\pm1)\). Its proof
  immediately notes that two planar/catenoidal ends with nonparallel limiting
  normals must intersect.
- Proposition 2.5(ii)-(iii), p. 31, restates properness and parallel limiting
  normals as necessary conditions for a complete nonplanar conformal minimal
  embedding of finite total curvature.

Applying Proposition 2.2(ii) contrapositively to the two Costa ends above
produces an actual intersection between distinct end neighborhoods. Therefore
no \(I_y\), \(y>1\), is globally injective.

## Reliability boundary

The publisher PDF and independently readable images of printed pages
1280-1282 are preserved under `research/costa-g1-k4/source/`; their provenance
and exact formula comparison are in `PROVENANCE.md` and
`primary-pages-audit.md`. The normalized convenience transcription, including
locators for (1), (12), and (13), remains in
`research/costa-g1-k4/source/costa-formulas-1-12-13-excerpt.txt`.
Search-generated summaries that called the full Costa surfaces embedded were
discarded because they contradict the source's theorem and proof language.
The audit establishes exact exhaustion only of Costa's source family \(y>1\);
it does not prove the campaign's overall conjecture and says nothing about
unrelated genus-one/four-end families.
