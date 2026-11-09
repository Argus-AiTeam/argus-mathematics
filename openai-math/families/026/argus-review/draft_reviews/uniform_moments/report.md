# Uniform mixed moments: supported fixed-data analytic package

**Assessment.** `C026_UNIFORM_MOMENTS` v2 is supported by the density reduction and zero-safe Fourier evaluation, with the recorded BV input in the one-mark case. This is a prose verification of a manuscript proposition, not a fully formalized prime-gap theorem.

## Exact objects and quantifiers

Context: `CTX026_MOMENTS` v1. Fix nonnegative dimensions \(j_1,\ldots,j_R\), real \(F_r:[0,\infty)^{j_r}\to\mathbb R\) admitting compact smooth extensions, budgets \(\rho_r\ge0\) with \(F_r=0\) on the orthant outside \(\sum v_\ell\le\rho_r\), and constants \(D>0,B\ge1\). Dimension zero means a scalar and budget zero. Fix a surjection
\(\kappa:\Gamma=\{(r,\ell)\}\to\{1,\ldots,t\}\), whose nonempty fibers \(\mathcal M_i\) record exact numerical equality.

For integer \(X\to\infty\), \(L=\log X\), allow distinct integer \(a_1,\ldots,a_t\) with \(|a_i|\le DL^B\), varying with \(X\). Put \(b_{r,\ell}=a_{\kappa(r,\ell)}\) and
\[
 D_{F_r}(m)=\sum_{d_{r,\ell}\mid m+b_{r,\ell}}
 \prod_\ell\mu(d_{r,\ell})F_r((\log d_{r,\ell}/L)_\ell).
\]
Choose \(\delta=0\) or 1. Unmarked, \(\chi_0=1\) and \(\mathcal H=\{a_1,\ldots,a_t\}\). Marked, take one further distinct bounded integer \(a_0\), set \(\chi_1=\vartheta(m+a_0)\), and add \(a_0\) to \(\mathcal H\). Here \(\vartheta(n)=\log n\) at primes and zero otherwise. The average is over integers \(X<m\le2X\). Require \(\sum_r\rho_r<1\) unmarked or \(<1/2\) marked.

Then there is a real \(\mathcal C\), depending only on the functions and \(\kappa\), such that
\[
 \mathbb E_X[\chi_\delta\prod_rD_{F_r}]
 =L^{-t}\{\mathfrak S(\mathcal H)\mathcal C+
 O(L^{-1/2}(\log L)^A)\}.
\]
The finite exponent \(A\) depends only on \(M=|\Gamma|\); other fixed data may affect the implied constant and starting \(X\), but actual shifts do not. The singular series is
\(\prod_p(1-\nu_p(\mathcal H)/p)(1-1/p)^{-|\mathcal H|}\), with empty-set value one.

If every fiber has size at most two,
\[
 \mathcal C=\int\prod_r(-1)^{j_r}\partial_1\cdots\partial_{j_r}F_r
 ((y_{\kappa(r,\ell)})_\ell)\prod_{i:|\mathcal M_i|=2}dy_i,
\]
where singleton variables are zero and double-fiber variables range over \([0,\infty)\). With \(\Gamma=\varnothing\), \(t=0\) and \(\mathcal C=\prod_rF_r\).

## Provenance and decisive assembly

The comparison source is manifest-matched OpenAI revision `4eaee87548250b2682affda7d05d947c05554bae`, `build/sections/03-moments.tex`, `prop:mixed-moments` and its proof. The inherited Argus draft is `families/026/first-pass/audit026/moments/verification.md`, sections 1-5 and 9. Both sources already allow negative shifts, arbitrary equality fibers and additive errors at zero singular series. These features must not be advertised as discoveries missing from the manuscript.

The density unit proves replacement by \(A_\delta\) with \(O_N(L^{-N})\) for any chosen fixed \(N\). The Fourier unit evaluates \(A_\delta\), with one inverse logarithm per distinct unmarked shift and the stated coefficient. Taking \(N>t+2\) absorbs the arithmetic and discarded-frequency errors into the displayed remainder. The prime mark changes local density normalization and \(|\mathcal H|\), but not \(t\) or the power \(L^{-t}\); a later prime-count sum supplies its own \(1/L\).

This reasoning does not divide by the singular series, so a zero series leaves a valid additive error statement. Repeated labels are not counted as new shifts, and the derivative formula is not extended to larger fibers. For larger fibers, absolute convergence of the general Fourier kernel supplies exactly the finite coefficient needed later.

The realness and extension independence of \(\mathcal C\), the absolute sum/integral interchange, complex double-fiber Laplace representation, and all-scalar case are assessed explicitly in the Fourier and density reports. No factorization assumption on a coupled \(F_r\) is introduced.

## Assumptions and inherited evidence

`BV_ENDPOINT` has identity `101aa9932fc5039e963d1a14b87314c79b92178d924f3d0e4bf9a5032bc0a96e`. It is the ordinary endpoint theorem: for every \(A>0\), some \(b(A)>0\) gives the reduced-class maximum error summed over \(q\le x^{1/2}(\log x)^{-b(A)}\) as \(O_A(x(\log x)^{-A})\), including \(q=1\).

The precise source is BFI, *Acta Mathematica* 156 (1986), DOI `10.1007/BF02399204`, p. 206 (1.4), with \(\psi\) defined on p. 204; the theorem is attributed there to Bombieri and A. I. Vinogradov. The density report records the current primary-PDF reading and verifies the weighted/shifted deductions. These are not stronger hypotheses silently supplied by the source.

Inherited reviewer receipts are `judgement-C026_UNIFORM_MOMENTS-cc339e1a306e` for the present claim and `judgement-BV_ENDPOINT-9b17a45ae42b` for the present assumption, using `verification.md` and `reviewer_BV_excerpt.md`. Claim versions 1 and 2 have identical statement hashes; the assumption remains live. These are human judgements, not new native acceptance or literature-tier attribution. The graph's pending label and the prose's "independent attribution remains" wording are preserved metadata, not reasons to discard existing matching receipts.

The local Lean compilation establishes only the separate Euler-core claim. The finite Python/SymPy and Jacobian checks are exact bounded evidence for parts of the algebra; no such run verifies this analytic assembly.

**Remaining obligations.** No concrete gap was identified within the exact fixed-data proposition. Strict support inequalities, one-mark restriction and the order "fix all functions and dimensions, then let \(X\) grow" remain essential. There is no uniform growing-family limit, novelty judgement, full manuscript certification, or native family acceptance.
