# Fourier evaluation: supported zero-safe prose proof

**Assessment.** `L026_FOURIER` v1 supports the stated additive density-sum asymptotic, including arbitrary nonempty equality fibers and zero singular series. Its decisive steps are analytic prose, not consequences of the finite checker alone.

## Claim, hypotheses and source

Context: `CTX026_MOMENTS` v1. Inherited proof: `families/026/first-pass/audit026/moments/verification.md`, sections 3-5 and 9. Comparison source: OpenAI manuscript revision `4eaee87548250b2682affda7d05d947c05554bae`, manifest-matched `build/sections/03-moments.tex`, proof of `prop:mixed-moments`, especially `eq:absolute-euler-sum`, `eq:generic-local-factor`, `eq:zero-safe-comparison`, and `eq:zeta-kernel`. This reproduces the manuscript's additive approach; it does not expose a manuscript division-by-zero error.

Fix dimensions, real functions admitting compact smooth extensions, their nonnegative orthant simplex budgets, a surjection from divisor coordinates \(\Gamma\) to \(t\) numerical-shift labels, and \(D>0,B\ge1\). Distinct integer shifts have absolute value at most \(D(\log X)^B\); an optional mark is distinct from all unmarked shifts. Let \(L=\log X\), \(M=|\Gamma|\), and let \(A_\delta\) be the compatible density sum in the density report. All data other than \(X\) and the permitted numerical shifts are fixed.

The conclusion is
\[
 A_\delta=L^{-t}\{\mathfrak S(\mathcal H)\mathcal C+
 O(L^{-1/2}(\log L)^A)\},
\]
uniformly in those shifts, with \(\mathcal C\) real and depending only on the functions and equality pattern. Each nonempty exact equality fiber contributes one inverse logarithm, regardless of its size. For fibers of size at most two, \(\mathcal C\) is the complete-derivative integral stated below. The stronger remainder is assessed separately.

## Absolute interchange and local normalization

Take the positive-phase Fourier transform \(\Phi_r\) of \(e^{\sum v}\widetilde F_r\), normalized by \((2\pi)^{-j_r}\). Its product \(\Phi\) is Schwartz, and inversion gives
\(F_r(v)=\int\Phi_r(u)e^{-\sum(1+iu_\gamma)v_\gamma}\,du\).
The unsigned divisor sum after inserting inversion is at most
\[
 \prod_p(1+C_Mp^{-1-1/L})\ll_M L^{C_M}.
\]
Multiplying by \(\int|\Phi|<\infty\) justifies the interchange, including the infinite representation of the originally support-truncated sum. Schwartz decay makes frequencies with \(\max|u_\gamma|>\sqrt L\) negligible to every logarithmic power.

With \(z_\gamma=(1+iu_\gamma)/L\), the exact local factor is
\[
 P_p(z)=1+(p-\delta)^{-1}
 \sum_{S\ {\rm allowed}}(-1)^{|S|}p^{-z_S}.
\]
Allowed subsets lie within one occupied residue fiber and, when marked, avoid the mark's residue. Exact numerical equality fibers \(\mathcal M_i\) need not equal these residue fibers. Set
\[
 B_p(z)=\prod_i\prod_{\varnothing\ne S\subset\mathcal M_i}
 (1-p^{-1-z_S})^{-(-1)^{|S|}},\qquad H_p=P_p/B_p.
\]
All elementary denominators have modulus at least \(1-1/p\ge1/2\). The nonempty-fiber sign identity gives
\[
 P_p(0)=\frac{p-\nu_p(\mathcal H)}{p-\delta},\quad
 B_p(0)=(1-1/p)^t,\quad
 H_p(0)=(1-\nu_p/p)(1-1/p)^{-(t+\delta)}.
\]
These equations remain valid at \(\nu_p=p\). The mark does not create another inverse logarithm.

## The zero-safe comparison

Uniformly for \(\Re z_\gamma\ge0\), finite-product differentiation gives
\[
 |H_p(z)|\le e^{C_M/p},\qquad
 |H_p(z)-H_p(0)|\ll_M Z(\log p)/p,\quad Z=\sum_\gamma|z_\gamma|.
\]
The finite number of possible residue patterns makes these constants independent of actual shifts. At a prime without collisions of distinct shifts, the \(1/p\) coefficients in \(P_p\) and \(B_p\) agree, hence \(H_p(z)=1+O_M(p^{-2})\), uniformly even for large imaginary parts.

Every collision prime divides a nonzero shift difference of size at most \(2DL^B\). Take \(Y=\max(2,2DL^B)\). Additive telescoping for \(p\le Y\), with mixed products bounded by a power of \(\log Y\), and the absolutely convergent collision-free tails give
\[
 \left|\prod_pH_p(z)-\mathfrak S(\mathcal H)\right|
 \ll(\log L)^A(Z+L^{-B}),\qquad
 0\le\mathfrak S(\mathcal H)\ll(\log L)^A.
\]
No quotient by \(P_p(0)\), \(H_p(0)\), or \(\mathfrak S\) appears. This is the substantive reason zeros are harmless; numerical tests at nonzero singular series would not establish it.

## Pole order, general fibers and derivatives

On the core, absolute Euler products and the local Laurent expansion give
\[
 \prod_pB_p(z)=L^{-t}K(w)(1+O_M(Z)),\quad
 K(w)=\prod_i\prod_{\varnothing\ne S\subset\mathcal M_i}
 \left(\sum_{\gamma\in S}w_\gamma\right)^{(-1)^{|S|+1}},
 \quad w_\gamma=1+iu_\gamma .
\]
Each fiber's sign sum is \(-1\), yielding exactly \(L^{-t}\). Every denominator subset sum has positive integer real part; consequently \(K\) has at most polynomial growth for every fixed fiber size. Thus \(\mathcal C=\int\Phi K\) converges absolutely and is real by conjugation \(u\mapsto-u\).

Extension independence is not assumed: choose one fixed admissible shift set consisting of distinct multiples of the product of primes at most \(t+\delta\), with mark zero when present. Its singular series is positive (small primes occupy one residue; larger primes have fewer than \(p\) shifts; the remaining product converges absolutely). Two extensions give asymptotics for the same divisor sum at those shifts; subtraction and passage to the limit force equal constants. These fixed shifts eventually satisfy every allowed logarithmic bound. The Fourier definition also makes independence of \(\delta\) explicit.

For a singleton \(K=w_\gamma\). For a double fiber,
\[
 K=\frac{w_\gamma w_\eta}{w_\gamma+w_\eta}
 =w_\gamma w_\eta\int_0^\infty e^{-(w_\gamma+w_\eta)y}\,dy .
\]
Absolute values contribute \(e^{-2\sum y}\) times a polynomial in frequencies times a Schwartz function. This justifies Fubini and differentiation of inversion, yielding
\[
 \mathcal C=\int
 \prod_r(-1)^{j_r}\partial_1\cdots\partial_{j_r}F_r
 ((y_{\kappa(r,\ell)})_\ell)\prod_{i:|\mathcal M_i|=2}dy_i,
\]
with singleton variables set to zero. This also covers both labels of a double fiber lying in one coupled \(F_r\); no coordinate independence was assumed. Larger fibers use the finite Fourier kernel, not this double-fiber formula.

Section 9 supplies the ordinary analytic facts used: repeated integration by parts and Gaussian regularization for Fourier inversion, absolute Euler products for \(\Re s>1\), and the locally uniformly convergent series for \(\zeta(1+z)-1/z\) near zero. No zero-free region, PNT, or unrecorded prime-distribution input is required for this density-sum evaluation. When \(M=0\), the density sum is exactly the product of scalars and is handled separately.

## Evidence and obligations

Inherited reviewer judgement `judgement-L026_FOURIER-97945bd8c994` supports the present claim identity and preserved `verification.md`. The local universal sign/normalization portion has the separate Euler-core certificate. Fresh `../euler_core/finite_replay.json` reproduces 48 bounded first-order symbolic cases and the small-kernel examples, but does not check the infinite products, complex integration or uniform analytic bounds. Those were assessed directly above.

**Remaining obligations.** No specific analytic gap was found within these fixed-data hypotheses. The analytic passage is not Lean-formalized, its human review must not be inherited from a mere compiler exit, and the native Reviewer must assess this unit and the stronger-error unit separately.
