# Analytic-dual old-draft assessment

## 1. Disposition, authority and inputs

**Disposition: supported conditional on the specified classical inputs and the
separately assessed exponent arguments.** The old report supplies substantive
analytic arguments, not merely numerical evidence, for the exceptional-moment
proposition. The decisive coefficient-independence, conductor, small-dual-length
and uniformity steps survive this bounded reading. No invalid analytic
derivation or counterexample to the proposition was established.

This is an audit-worker assessment, **not final independent Reviewer
acceptance**. In particular, the old title “independent certification,” an
engineer's `supported` judgement, a successful checker, and the historical
citation queue are not acceptance decisions.

Inputs read:

* `OBJECTIVE.md`, `PRIOR_DRAFTS.json`, and `research/DRAFT_REVIEW_INDEX.json`.
* The old `research/exceptional_moments/report.md`, all of Sections 1–7,
  its Theorems 1–3 and scope qualifications, and Section 8's evidence boundary.
* The analytic claim versions in the old `research/MATH_STATE.json`, the
  short citation excerpts, `sources/source_readings.json`,
  `citation_status.json`, and `dual_status.json`.
* The referenced manuscript's `build/sections/dual.tex` in full, including
  the coefficient definition; the relevant definitions and sieve arguments
  in `build/sections/background-type1.tex`.
* The actual passages of the three full literature **text files** listed
  in Section 3, not just the previously prepared short excerpts.

Hereafter `OLD` denotes
`campaigns/9000023`,
`SOURCES` denotes `OLD/research/exceptional_moments/sources`, and `MS` denotes
`openai-math/preprints/An-unconditional-first-moment-for-cubic-Gauss-sums-September-25-2026`.
The manuscript reference is the revision
`4eaee87548250b2682affda7d05d947c05554bae` specified by
`campaigns/9100023/MANUSCRIPTS.json`.
No Git inspection or source modification was used.

The universal exponent obstruction, sharp interval optimization and bounded
factor-count arithmetic belong to the `universal-exponents`, `interval-gap`
and `finite-degree` units. They are explicit dependencies here. Neither their
Lean compilation nor their exact arithmetic proves an analytic bridge.
The parent handles exact-checker and Lean replay; no old `verify.py` was
executed here.

## 2. Exact proposition and coefficient class

The source is `MS/build/sections/dual.tex`, lines 10–23
(`eq:prime-convolution`) and 39–69 (`prop:dual`). Work over
\(\mathcal O=\mathbb Z[\omega]\), \(\lambda=1+2\omega=\sqrt{-3}\),
\(N(z)=|z|^2\), and \(\operatorname{Tr}(z)=z+\bar z\).
“Primary” means congruent to \(1\pmod3\); it supplies the unique generator
of each ideal prime to \(3\). The cubic symbol \(\chi_b(a)=(a/b)_3\)
is extended by zero on nonunits modulo its denominator and
multiplicatively in the denominator.

Fix \(c>0\), \(k_0\ge1\), fixed compact support intervals in
\((0,\infty)\), the constants in \(\prod F_j\asymp Y\), and uniform
smoothness bounds. For each fixed derivative order \(r\), the bound
has the form \(C_r(\log Y)^{B_r}\), with \(C_r,B_r\) fixed over the
coefficient family. The coefficients are precisely
\[
 \beta(b)=\mu^2(b)\!
 \sum_{\substack{b=\pi_1\cdots\pi_k\\\text{ordered primary primes}}}
       \prod_{j=1}^k w_j(N\pi_j/F_j),\qquad
 1\le k\le k_0,\qquad \prod_jF_j\asymp Y.
\]
Every supported prime has norm at least \(Y^c\).
The weights are independently prescribed on their respective prime norm
dyads. There is **no additional sharp product cutoff, least-prime
condition or coupled weight**. The squarefree restriction on \(b\) is
part of this definition. Complex weights and bounded norm lengths are
not excluded.

The quantifier order is: for each such fixed data there exist
\(\delta,\eta>0\), an implied constant and a large-\(Y\) threshold,
all depending only on those data, such that **for every** admissible
coefficient sequence, \(Y\) above that threshold, nonzero \(v,e\in\mathcal O\)
with \(Nv,Ne\le Y^\delta\), and real \(u\) with
\(1+|u|\le Y^{0.36}\), the following holds. Put
\[
 A(p,q)=\sum_{(b,e)=1}\beta(b)(Nb)^{iu}\chi_b(vpq^2).
\]
The row indices are coprime primary squarefree \(p,q\) of norm lengths
\(P,Q\ge1\), with the fixed dyadic-ratio convention. If either
\[
 |\log_Y P-1|\le\delta,\qquad 0\le\log_Y Q\le\delta,
\]
or
\[
 |\log_Y P-\tfrac13|\le\delta,\qquad
 |\log_Y Q-\tfrac13|\le\delta,
\]
then
\[
             \sum_{p,q}|A(p,q)|^2\ll Y^{7/3-\eta}.
\]
Uniformity is over the stated fixed support/smoothness class, not over
arbitrary divisor-bounded coefficients or a growing number of factors.
These are the quantifiers claimed by old Theorem 3 and `C_DUAL` v1.
The old report has not substituted a weaker pointwise endpoint statement.

## 3. Literature inspected, exact imports and version distinctions

Line locators below refer to the persisted full `.txt` files in `SOURCES`;
page numbers are printed publication/preprint pages. Mathematical displays
are transcribed in conventional notation from the text extraction.
The short excerpts were compared with these full-text passages.

### 3.1 Heath-Brown through Dunn–Radziwill v3

`dunn_radziwill_v3.txt` identifies arXiv **2109.07463v3, 14 May 2024**
at line 4. Section 1.4, printed page 6, lines 306–320, explicitly
attributes the input to “[HB00, Theorem 2]” and says it holds
“for any sequence \(\beta_b\) supported on squarefree” elements.
Equation (1.11) is
\[
 \sum_{\substack{Na\le A\\a\equiv1\ (3)}}\mu^2(a)
  \left|\sum_{\substack{Nb\le B\\b\equiv1\ (3)}}
       \beta_b(b/a)_3\right|^2
 \ll_\epsilon (AB)^\epsilon
       \{A+B+(AB)^{2/3}\}
       \sum_{\substack{Nb\le B\\b\equiv1\ (3)}}|\beta_b|^2 .
\]
Both squarefree hypotheses are present: the outer \(\mu^2(a)\) and
the stipulated inner support. Dyadic restrictions follow by zero extension
of coefficients and restriction of a nonnegative outer sum. The following
quotation, lines 322–330, warns that without squarefree variables a result
as sharp as Theorem 2 would be impossible. Nothing in this passage supplies
the nonsquarefree extensions used later.

**Heath-Brown's original DOI `10.1007/s11856-000-1273-y` was not
inspected. Only its explicit reproduction in Dunn–Radziwill v3 was
available for this assessment.** Historical subscription/403 reports are
provenance, not a fresh access test. This is a declared imported theorem,
not an original result of the old draft.

`C_HB` versions 1–4 have the same mathematical statement. Version 1 has
no recorded external assumption; v2 records the original Theorem 2 with
lookup pending; v3 retires that direct locator because it was not obtained;
v4 records the actually read reproduction at (1.11). These are citation
revisions, not four different proofs. The v4 attribution is supported at
the reproduction level.

### 3.2 Reciprocity, supplementary laws and Gauss sums

In the same full text, Section 1.2, printed page 4, lines 159–185,
defines the symbol and states, for primary \(a,b\),
\[
 (a/b)_3=(b/a)_3 \tag{1.4}
\]
and, for
\(d\equiv1+\alpha_2\lambda^2+\alpha_3\lambda^3\pmod9\),
\(\alpha_2,\alpha_3\in\{-1,0,1\}\),
\[
        (\omega/d)_3=\omega^{\alpha_2},\qquad
        (\lambda/d)_3=\omega^{-\alpha_3}. \tag{1.5}
\]
Section 2, printed page 10, lines 505–540, supplies the unique primary
generator convention and
\[
 g(c)=\sum_{x\bmod c}(x/c)_3 e(\operatorname{Tr}(x/c)),\qquad
 g(c)^3=\mu(c)c^2\bar c \tag{2.1--2.2}
\]
for \(c\equiv1\pmod3\). It expressly records
\(|g(c)/|c||=\mu^2(c)\) and refers back to (1.4)–(1.5).

Thus `C_RECIPROCITY` v1–2 has an appropriate source, but v2's locator
“Section 2” alone is too coarse for the laws themselves: the operative
displays are in Section 1.2. The short excerpt correctly supplies those
locators. Formula (2.2) is not by itself the mixed-character Gauss theorem
or an exact primitive **Hecke** conductor theorem. Those additional
assertions require, and receive, the arguments in Sections 5 and 6 below.

### 3.3 Primitive Hecke functional equation and entireness

`watkins_2011.txt`, DOI **10.5802/pmb.a-138**, Section 3.6,
printed page 123, lines 217–246, says “we take \(\psi\) to be primitive
so that the conductor and modulus are equal,” extends its coefficients
by zero on ideals not coprime to the conductor, and gives
\[
 \Gamma_{\mathbb C}(s)=2(2\pi)^{-s}\Gamma(s),\quad
 \Lambda_W(s,\psi)=(N\mathfrak f\,|\Delta_K|)^{s/2}
                       L_\infty(s,\psi)L(s,\psi),
\]
together with the conjugate-character functional equation and
\(|\epsilon_\psi|=1\). Its continuation statement is meromorphic;
it identifies the trivial Hecke character as “the only case where the
L-function has a pole.”

For \(K=\mathbb Q(\omega)\), trivial infinity parameter and
\(D=N\mathfrak f\), this specializes to
\[
 \Lambda_W(s,\chi)=2\left(\frac{\sqrt{3D}}{2\pi}\right)^s
                                  \Gamma(s)L(s,\chi).
\]
Dividing the completion by the constant \(2\) gives the old report's
normalization without changing its functional equation. A root number
of absolute value one is not asserted to equal one.

`thorner_zaman_2019.txt`, DOI **10.2140/ant.2019.13.1039**,
Section 2C, printed page 1049, lines 594–624, first assumes an
**abelian extension** \(L/K\), identifies its one-dimensional Artin
characters with primitive Hecke characters by class field theory, and
defines
\[
 \xi(s,\chi)=[s(1-s)]^{\delta(\chi)}
  (D_K N\mathfrak f_\chi)^{s/2}\gamma(s,\chi)L(s,\chi),
 \quad
 \delta(\chi)=\begin{cases}1&\chi\text{ trivial},\\0&\text{otherwise}.
 \end{cases}
\]
After (2-15) and the unit-modulus root number, it says
“\(\xi(s,\chi)\) is an entire function of order 1.”
Finite-order ray characters have the required abelian realization by
class field theory. For a nonprincipal character \(\delta(\chi)=0\);
one must not silently use the pole-removing \(s(1-s)\) factor.
This passage therefore supplies the completed entireness actually
needed for the contour argument.

`C_HECKE_FE` v1–3 has unchanged mathematical content. Version 2 adds
Watkins and explicitly leaves entireness needing a source or proof;
v3 adds the above Thorner–Zaman passage. The short excerpts agree with
these hypotheses and the factor-of-two specialization. The final imported
statement is supported for **primitive nonprincipal finite-order Hecke
characters of this field with trivial infinity parameter**, not for an
uncompleted, imprimitive or arbitrarily angular sum.

### 3.4 Poisson

`dunn_radziwill_v3.txt`, Section 4, printed page 12, lines 594–650,
gives covolume \(\sqrt3/2\), trace-dual lattice \(\lambda^{-1}\mathcal O\),
and Lemma 4.2 for nonzero \(q\), an arbitrary \(q\)-periodic function
and a smooth Schwartz function on \(\mathbb R^2\). Its formula has
factor \(2/(\sqrt3 Nq)\), finite Fourier argument \(tk/(q\lambda)\)
and continuous Fourier argument \(k/q\).
The full text uses a negative sign in the finite transform and a positive
sign in the continuous transform. The short excerpt reverses **both**
signs; the substitution \(k\mapsto-k\) makes it equivalent. No estimate
here relies on mixing those conventions.

The primary-coset specialization is Lemma 4.3, printed pages 13–14,
lines 669–756. Corollary 4.1 and its proof, printed pages 14–15,
lines 758–850, exhibit the common principal factor, primitive
residue characters and \(3\lambda=(-\lambda)^3\), explicitly at (4.9).
These corroborate, rather than replace, the mixed-character derivation
below. `C_POISSON` v1–2 has unchanged content; v2 records the precise
Lemma 4.2 import.

The cited sieve, reciprocity, Gauss identities and Poisson passages do
not assume GRH. Other theorems in Dunn–Radziwill v3 do; none of those
conditional moment/dispersion results is being imported here.

## 4. Coefficients and the two cubic extensions (`C_EXTENSIONS` v1)

Put \(H(P,S)=P+S+(PS)^{2/3}\). Lattice counting gives
\(\#\{\mathfrak n:N\mathfrak n\le T\}=O(T)\), hence the harmonic
ideal bound. For fixed divisor order, fixed convolutions and a fixed
number of copies, the coefficient square norm on a norm dyad \(S\)
is \(S Y^{o(1)}\). Here and below \(Y^{o(1)}\) means availability of
every prescribed small positive power loss, with constants depending
on the fixed degree and data; it is not a logarithmic saving.

For the unrestricted **inner** variable the unique decomposition
\[
 n=st^2d^3,\quad s,t\text{ coprime squarefree},\qquad
 Ns\asymp S,\ Nt\asymp V,\ Nd\asymp C
\]
has \(SV^2C^3\asymp Z\).
For fixed \(t,d\), multiplication by \(\chi_a(t^2d^3)\) contracts
the outer square-sum norm. The squarefree sieve on \(s\) gives squared
norm at most \(Y^\epsilon S H(P,S)\). The triangle inequality over
\(O(VC)\) pairs costs its **square**, producing old equation (1):
\[
       Y^\epsilon (VC)^2 S H(P,S).
\]
Since \((VC)^2S\ll Z\) and \(S\ll Z\), logarithmically many norm
dyads give old equation (2):
\[
 \sum_{\substack{Na\asymp P\\a\ {\rm primary\ squarefree}}}
      \left|\sum_{Nn\asymp Z}c_n\chi_a(n)\right|^2
       \ll Y^\epsilon Z H(P,Z).
\]
This is for divisor-bounded \(c_n\), uniformly at fixed divisor order.
It is **not** an unrestricted operator inequality with
\(\sum|c_n|^2\) in place of \(Z\). No later step needs that stronger
and unjustified replacement.

For the unrestricted **outer** variable, the same factorization has
\(SV^2C^3\ll J\). If \(S\ge V\), fixing \(t,d\) gives
\[
 VC\{S+P+(SP)^{2/3}\}\sum_b|u_b|^2.
\]
The three needed inequalities are
\(SVC\le O(J)\), \(VC\le O(J^{1/3})\) and
\(VC S^{2/3}\le O(J^{2/3})\).
If \(S<V\), fixing \(s,d\) and conjugating the character on \(t\)
gives the corresponding bounds with \(SC,V\). These follow from
\(SV^2C^3\ll J\) and \(S,V,C\ge1\). Thus
\[
 \sum_{Na\asymp J}\left|\sum_{\substack{Nb\asymp P\\
                              b\ {\rm primary\ squarefree}}}
             u_b\chi_b(a)\right|^2
 \ll Y^\epsilon
       \{J+(JP)^{2/3}+J^{1/3}P\}\sum_b|u_b|^2 .
\]
The coefficient restriction arising from \(d\) only decreases its norm.
Units and powers of \(\lambda\) can be split off as rowwise scalars or
fixed coefficient twists; the number of norm-dyadic splits is logarithmic.
This also permits full-lattice frequency coefficients in the inner
extension. Both extensions are derived from the imported squarefree
sieve, not supplied by that theorem's statement.

## 5. Ordinary sieve and multiplicity (`C_ORDINARY` v1)

For primitive finite group characters modulo a tame primary \(r\),
primitive Gauss expansion and orthogonality give
\[
 \sum_{\chi\bmod r}^{*}\left|\sum_n c_n\chi(n)\right|^2
 \le \frac{\varphi(r)}{Nr}
           \sum_{\substack{h\bmod r\\(h,r)=1}}|S(h/r)|^2
 \le \sum_{(h,r)=1}|S(h/r)|^2,
\]
with \(S(y)=\sum c_n e(\operatorname{Tr}(ny))\).
The normalization is \(Nr\), not a conductor power loss.
Fixing bounded ramified data leaves a subset of such group characters;
allowing all of them is an upper bound.

For \(Nr,Nr'\ll Q\), distinct reduced fractions on the trace-dual
torus have distance \(\gg Q^{-1}\): after a lattice translation their
difference has a nonzero lattice numerator and a denominator of
complex absolute value \(O(Q)\). The fixed trace-dual scaling changes
only constants. A Schwartz majorant at spatial scale \(\sqrt Z\)
and Poisson give additive Gram entries bounded by
\[
 C_A Z\sum_\ell(1+\sqrt Z\,|y-y'+\ell|)^{-A}.
\]
Packing a \(Q^{-1}\)-separated planar set gives row sum \(O(Z+Q^2)\).
The elementary Hermitian row-sum/operator-norm argument then proves
\[
        \sum_\chi\left|\sum_n c_n\chi(n)\right|^2
                  \ll (Z+Q^2)\sum_n|c_n|^2 .
\]
There is no need to insert \(Q^\epsilon\).
This proof is specific to the stated field, trivial infinite parameter
and bounded ramified modulus; no assertion over arbitrary number
fields or growing infinite parameters is inferred.

For the required row family, reciprocity identifies
\(\chi_b(pq^2)=\chi_p(b)\chi_q(b)^2\) on primary arguments.
The local exponents \(1\) and \(2\) at disjoint squarefree prime
factors distinguish which primes belong to \(p\) and to \(q\).
Each tame prime is present in the primitive conductor. Thus
\(N\mathfrak f\ll PQ\), and different pairs cannot acquire a hidden
positive-power multiplicity; bounded ramified choices cost only a
bounded factor. The extra \(\chi_b(v)\) and \((b,e)=1\) can instead
be kept in the common coefficients for the ordinary moment applications.
The full-sum branch uses the more detailed local partition below.

## 6. Gram estimate (`C_GRAM` v1)

This is the decisive analytic bridge; it is not assumed from the
manuscript or inferred from a finite-ring check.

Fix a primary squarefree \(p\) with \(Np\asymp P\), and a distinct
primary squarefree \(p'\) of the same norm length. Write
\[
 k=(p,p'),\quad p=ka,\quad p'=kb,\quad K=Nk,\quad B=P/K.
\]
Squarefreeness gives pairwise coprimality of \(k,a,b\), and exactly
\[
 \chi_p(n)\overline{\chi_{p'}(n)}
       =1_{(n,k)=1}\chi_a(n)\overline{\chi_b(n)}.
\]
The character \(\psi=\chi_a\bar\chi_b\) modulo \(c=ab\) has a
nontrivial local cubic character at every prime in \(c\); it is primitive
and nonprincipal. The sole principal case would be \(a=b=1\),
hence \(p=p'\), already excluded.

The general primitive Gauss evaluation is justified separately from
source (2.2). For unit frequency its Fourier coefficient is
\(\bar\psi(h)g(\psi)\) by change of variable. For nonunit frequency,
primitivity supplies a unit fixing the additive character but having
nontrivial \(\psi\)-value, so the coefficient vanishes. Finite Parseval
then gives
\(\varphi(c)|g(\psi)|^2=Nc\,\varphi(c)\), or
\(|g(\psi)|=\sqrt{Nc}\). This applies to the mixed local exponents.

Remove \(1_{(n,k)=1}\) by Möbius inversion. For \(m\mid k\),
\(M=Nm\), put \(n=mx\). Primary \(m\) preserves the primary coset,
\((m,c)=1\), and \(\psi(m)\) is only a unit-modulus scalar.
The norm weight now has scale \(Z/M\).

Here is the finite Fourier coefficient in the convention with the
positive sign in the finite transform:
\[
 \begin{split}
 C_c(h)
 &=\sum_{s\bmod c}\psi(c+3s)
                e\!\left(\operatorname{Tr}
                    \frac{(c+3s)h}{3c\lambda}\right)\\
 &=e\!\left(\operatorname{Tr}\frac{h}{3\lambda}\right)
               \psi(3\lambda)\bar\psi(h)g(\psi)\\
 &=e\!\left(\operatorname{Tr}\frac{h}{3\lambda}\right)
               \bar\psi(h)g(\psi).
 \end{split}
\]
The primary classes are \(c+3s\), since \(c\equiv1\pmod3\);
\(3\lambda=(-\lambda)^3\) makes the omitted character scalar one.
For \(h=x+y\omega\), \(\operatorname{Tr}(h/\lambda)=y\), so the
extra phase is the fixed \(\omega^y\), independent of \(b\).
The formula also holds when \(h\) is nonunit modulo \(c\), by the
vanishing just proved. In particular the zero frequency is zero.

Poisson therefore has amplitude and natural norm scale
\[
      \frac{Z}{M\sqrt{Nc}}\asymp\frac{ZK}{MP},
 \qquad J_0\asymp\frac{Nc\,M}{Z}
                    \asymp\frac{P^2M}{K^2Z}.
\]
The Gauss factor, \(\psi(m)\) and CRT factors are scalars for each
\(b\). The frequency character is
\(\overline{\chi_a(h)}\chi_b(h)\).
Radiality is essential: the Fourier kernel's dependence on \(b\)
is through \(Nb\), not its complex argument.

On \(Nh\asymp J\), use the compact scaled variables \(Nh/J\) and
\(Nb/B\). One may take a reference \(J_0\asymp Na\,B\,M/Z\),
independent of \(b\), since \(Nb/B\) ranges over a fixed compact
interval. Mellin separation of this smooth kernel has a common
integrable majorant of mass
\(O_A((1+J/J_0)^{-A})\). Logarithmic derivatives in both compact
variables have the same bound after increasing \(A\), by Schwartz
decay of the radial Fourier transform. The separated coefficients in
\(h\) are independent of the variable \(b\); the separated norm twist
in \(b\) has absolute value one. Dependence on the *fixed* \(p,k,m\)
is harmless for a uniform row bound. Exact unit and ramified powers
in \(h\) can be split without changing this independence.

Consequently Minkowski and the **length-form** inner extension, not a
stronger coefficient-norm version, bound a frequency dyad's squared
row norm by old equation (5):
\[
 (PZ)^\epsilon
       \left(\frac{ZK}{MP}\right)^2
       J\{P/K+J+(PJ/K)^{2/3}\}(1+J/J_0)^{-A}.
\]
Dropping the restrictions on \(b\) is now legitimate in a nonnegative
square sum.

The powers of \(J\) are \(1,2,5/3\).
For \(J_0\ge1\), split the geometric dyadic sums at \(J_0\).
For \(J_0<1\), \(J\ge1\) and
\[
 J^q(1+J/J_0)^{-A}\le J_0^A J^{q-A},\qquad A>q.
\]
Thus the sum is \(O(J_0^q)\) in both cases. Applying the same argument
to the square roots controls the Minkowski sum before squaring.
No extra unsmoothed term at dual length one is needed, and no
zero-frequency main term is present.

Substitution gives precisely
\[
       \frac{ZP}{MK},\qquad \frac{P^2}{K^2},\qquad
       \frac{P^2 Z^{1/3}}{K^2M^{1/3}} .
\]
Since \(Z,K,M\ge1\), these are bounded in total by
\(O(ZP+P^2Z^{1/3})\). Divisor-boundedly many \(k\mid p\), \(m\mid k\)
and Cauchy/triangle costs are absorbed into a rechoice of \(\epsilon\).
This gives old equation (7), with uniform constants at fixed weight:
\[
 \sum_{p'\ne p}|T_{p,p'}|^2
       \ll_\epsilon(PZ)^\epsilon\{ZP+P^2Z^{1/3}\}.
\]
Subsets only decrease the left side.

For the subsequent Hilbert-space use, the chosen radial majorant is
real nonnegative and at least one on the copied polynomial's support.
Its diagonal is \(O(Z)\). Expanding a quadratic form and using
\(2|\alpha_p\alpha_{p'}|\le|\alpha_p|^2+|\alpha_{p'}|^2\)
proves the required Hermitian absolute-row-sum bound. For a coefficient
square norm \(Z Y^{o(1)}\) it yields
\[
 RY^{5z/3+o(1)}
 \le ZY^{o(1)}
 \left(O(Z)+\sqrt R\,Y^{o(1)}
                    \sqrt{ZP+P^2Z^{1/3}}\right).
\]
This is the actual analytic input to the separately assessed exponent
contradiction. It does not import an unverified Hilbert-space lemma.

The old report describes exact finite Fourier tests at quotient norms
28, 49 and 91, and a common-factor/Gauss test at norm 196. Those are
**finite checks only**, not a universal proof of primitivity, Mellin
separation, decay, the sieve extensions or this estimate. Their replay
belongs to the parent; the analytic support here is the argument above.

## 7. Full smooth sums (`C_DUALITY` v1) and the full-factor branch

For a primitive nonprincipal finite-order Hecke character of conductor
norm \(D\) and trivial infinity parameter, put
\[
 C_D=\frac{\sqrt{3D}}{2\pi},\quad
 \Lambda(s,\chi)=C_D^s\Gamma(s)L(s,\chi).
\]
The imports in Section 3 give completed entireness and
\[
 L(s,\chi)=\epsilon(\chi)C_D^{\,1-2s}
            \frac{\Gamma(1-s)}{\Gamma(s)}
            L(1-s,\bar\chi).
\]
This includes the field discriminant, the gamma factor, conjugation
and the conductor exponent. It is not a functional equation for a
prime-to-\(3\) or otherwise Euler-deleted series.

For a **full ideal sum** with weight \(W(Nn/Z)\) and twist \(t\),
Mellin inversion is
\[
    \frac1{2\pi i}\int \widetilde W(s)Z^s L(s-it,\chi)\,ds.
\]
Move first to a sufficiently far-left line. Nonprincipality is needed
to avoid a residue; the dual Dirichlet series is then absolutely
convergent. Stirling and rapid Mellin decay discard dual norm dyads
beyond
\[
                  J\ll Y^\epsilon D(1+|t|)^2/Z
\]
with arbitrarily small polynomial tails, for polynomially bounded
lengths, conductors and heights. This truncation precedes moving the
retained finite polynomials back to \(\Re s=1/2\).

On that line the factor outside a retained dual polynomial is, apart
from a constant-field-scale unit phase,
\[
 \epsilon(\chi)D^{i(t-\tau)}Z^{i\tau}
 \frac{\Gamma(1/2-i(\tau-t))}
      {\Gamma(1/2+i(\tau-t))}.
\]
It has absolute value one for every row and \(\tau\).
The polynomial has character \(\bar\chi\), common coefficient
\((Nn)^{-1/2+i(\tau-t)}\), and a fixed smooth norm-dyadic cutoff.
Extracting \(J^{-1/2}\) gives amplitude \(Y^\epsilon\sqrt{Z/J}\).
The gamma poles are to the right of this return contour move.
An integrable majorant from \(\widetilde W(1/2+i\tau)\), of
polylogarithmic or \(Y^\epsilon\) mass, is common to all conductors.
A dyadic cutoff using the largest conductor in the average is allowed.
Thus Minkowski uses the **same shifts** for every row. Root numbers
and conductor phases remain rowwise scalars, never hidden inside
summation-index coefficients.

### Missing factors, nonprincipality and exact tame conductors

The old report explicitly supplies the passage from restricted sums to
the full sums just used. Along a limiting unsaved sequence put
\(S=\{\mathfrak p:\mathfrak p\mid3ve\}\).
The radical norm is \(Y^{o(1)}\). Fix the \(S\)-parts of \(p,q\)
and the remaining local character data, including the bounded
ramified class. All choices, divisor rescalings and multiplicities
are subpower. Write the remaining variable parts as \(p_0,q_0\).
Outside \(S\) the local exponents are exactly one on \(p_0\) and
two on \(q_0\), up to a common conjugation.

This is a finite-order ideal character, not merely a residue-symbol
heuristic. Choose primary generators on ideals prime to \(3\);
reciprocity gives periodicity at the tame cube-free numerator primes,
and (1.5) gives the remaining periodicity modulo the fixed modulus
\((9)\). It is therefore a ray character of trivial infinite parameter
with modulus dividing \((9)\) times that tame radical.
CRT permits independent variation at each tame prime while holding
the other residues and the ramified class fixed. A nontrivial
local exponent one or two cannot disappear on passing to the primitive
character. Its conductor outside \(S\) is exactly \(p_0q_0\);
the remaining conductor norm is subpower. This derives, rather than
misattributes to (2.2), the conductor assertion.

At the first endpoint \(Np_0=Y^{1+o(1)}\); at the second,
\(N(p_0q_0)=Y^{2/3+o(1)}\). Thus the fixed local twist cannot make
the character principal. The primitive conductor norms are at most
\(Y^{1+o(1)}\) and \(Y^{2/3+o(1)}\), respectively.

Every missing Euler factor is removed before applying the functional
equation. Inclusion–exclusion replaces a restricted sum by full ideal
sums rescaled by divisors of the subpower radical. Factors such as
\(\chi(d)\) are only rowwise scalars. This includes the prime above
\(3\) if the primitive character is unramified there; its value is
not incorrectly set to zero. On the dual side, the fixed local
character is a common coefficient twist. These observations justify
averaging the dual sums with the appropriate sieve.

Only genuinely full factors can enter this branch. The short Möbius
factors below have length exponent at most \(1/2\); a length exponent
one, or at least \(19/20\), must therefore belong to a full smooth
\(1\) or \(\log N\) factor, after the above Euler-factor removal.
No full-sum duality is assumed for an arbitrary character polynomial.

For a full factor of exponent \(a\), other factors have trivial
total exponent at most \(1-a\). Initial Mellin shifts can be truncated
below \(Y^\kappa\) with fixed \(\kappa<1/100\). The original
\(1+|u|\le Y^{0.36}\), plus boundedly many such shifts, gives total
height at most \(Y^{0.37}\) for large \(Y\). The dual length at the
first endpoint is therefore \(Y^{j+o(1)}\),
\(j=87/50-a\). Amplitude squared \(Y^a/J\), followed by the
length-form inner extension \(JH(Y,J)\), gives total moment exponent
\[
       E_1(a)=2-a+\max\{1,j,2(1+j)/3\}.
\]
At the second endpoint the trivial dual estimate is at most
\(Y^{1/3+37/100+o(1)}\), giving
\[
       E_2(a)=4/3+37/50+2(1-a).
\]
These are the analytic derivations of the full-factor inequalities.
The recorded arithmetic gaps for \(19/20\le a\le1\),
\(E_1(a)\le7/3-9/100\) and \(E_2(a)\le7/3-4/25\),
belong also to the parent-assessed finite-degree unit. At \(a=1\)
the exponents are \(54/25\) and \(311/150\).
The argument has not left the full-length boundary untreated.

## 8. Reduction from prime weights (`C_REDUCTION` v1)

### 8.1 Discrepancy support and moment bounds

Replace each prime weight by its smooth \(\Lambda/\log N\) analogue
and remove \(\mu^2(b)\). Their difference is divisor-bounded and
supported on repeated primes or prime powers of exponent at least two.
The fixed support ratios permit a harmless decrease of \(c\) if needed;
supported prime-power norm lengths are still a fixed positive power
of \(Y\).

If \(N(\pi^j)\ge Y^c\), \(j\ge2\), its square divisor
\(\pi^{\lfloor j/2\rfloor}\) has norm at least \(Y^{c/4}\).
Counting multiples of such square divisors by
\(\sum_{Nd\ge Y^{c/4}}O(Y/(Nd)^2)\) bounds support size by a fixed
power below \(Y\). Repeated primes have the same property.
In \(b=st^2d^3\), their total prime exponent also implies
\(N(b/s)\ge N(\pi^j)^{1/2}\), so
\(Ns\le Y^{1-\theta'}\) for some fixed \(\theta'>0\).
These statements include prime powers with small base prime; that case
was not silently omitted.

At the first endpoint fix \(q\) at subpower cost. The retained dyadic
inner bound has \((VC)^2S\ll Y\), \(S\le Y^{1-\theta'}\), and
therefore discrepancy moment
\[
 \ll Y^{1+o(1)}
       \{Y+Y^{1-\theta'}+Y^{(4-2\theta')/3}\}.
\]
Its exponent is strictly below \(7/3\); merely knowing sparse support
without the shorter squarefree part would not give this conclusion.

At the second endpoint, a discrepancy support of size
\(Y^{1-\theta}\) yields a squared polynomial of length \(Y^2\),
support size at most \(Y^{2-2\theta}\) and divisor-bounded
coefficients. The ordinary sieve, with conductor norm
\(Y^{2/3+o(1)}\), gives fourth moment at most
\(Y^{4-2\theta+o(1)}\). Cauchy over \(Y^{2/3+o(1)}\) rows then
gives second moment \(Y^{7/3-\theta+o(1)}\).
The twists and exclusions are common coefficients in these applications.
Thus both discrepancies can be discarded in an unsaved sequence.

### 8.2 Exact identity and genuinely independent factors

For a factor dyad with upper endpoint \(F'\), let
\(m=\mu\,1_{N\le\sqrt{F'}}\) and let \(\varepsilon_*\) be the
Dirichlet-convolution identity. Since
\(\varepsilon_*-m*1\) vanishes through norm \(\sqrt{F'}\),
its convolution square, also after convolution with \(\Lambda\),
vanishes through \(F'\). Expanding and using \(1*\Lambda=\log N\)
gives the exact old equation (9):
\[
              \Lambda=(2m-m*m*1)*\log N
                         \quad (Nn\le F').
\]
This is a proved local algebraic identity, not a probabilistic
approximation. Each original factor contributes at most four factors,
so there are at most \(4k_0\) after choosing terms.

Smooth norm partitions and Mellin inversion separate the independently
specified original weights. Any sharp truncation remains confined
to an individual Möbius factor; the \(1\) and \(\log N\) factors
are full smooth sums. The common norm twist, \(\chi_b(v)\), and
the condition \((b,e)=1\) distribute multiplicatively over all
factors. They do not create row-dependent coefficients.

The initial number of norm pieces and Mellin \(L^1\) masses can be
bounded by fixed powers of \(\log Y\), using finitely many of the
assumed derivative bounds. Choose a fixed shift truncation exponent
\(\kappa<1/100\); sufficiently high fixed derivative orders make
the discarded tails negligible using trivial bounds. Thus this
initial selection loses \(Y^{o(1)}\), **not an irrevocably fixed
positive power** chosen before a later copy degree. Minkowski can
select common shifts and a product retaining an unsaved moment.

On a subsequence, its factor lengths have exponents
\(a_i\ge0\), \(\sum a_i=1\), with a bounded number of factors.
Möbius factors have \(a_i\le1/2\), providing the full-factor
classification used in Section 7. Discarding individual values below
\(Y^{-10}\) is harmless by the bounded row count and trivial bounds
for the remaining factors. Dyadic value pigeonholing gives one common
row set with values \(Y^{v_i+o(1)}\), \(v_i\le a_i\),
\(v_i\) in a fixed bounded interval, and
\[
               r+2\sum_i v_i\ge7/3,\qquad
               r=\lim\log_Y R.
\]

For every subsequently selected **fixed** multiplicity vector, products
still have common divisor-bounded coefficients and a fixed support
ratio; their divisor order may depend on that vector. The sieve's
arbitrarily small power loss can be chosen after fixing the vector.
There is no assertion of a uniform divisor bound for degrees growing
with \(Y\).

This supplies precisely the analytic hypotheses used by the abstract
endpoint arguments:

* At the second endpoint the ordinary sieve on the squared product
  gives \(r+4v\le4\), cardinality gives \(r\le2/3\), and the
  repeated-factor ordinary bound has scale \(Z+Y^{4/3+o(1)}\).
* At the first endpoint fixing \(q\) costs only a subpower. For a
  copied product of length \(Y^{z+o(1)}\), the inner extension gives
  \[
   r+2\sum k_i v_i
       \le z+\max\{1,z,2(1+z)/3\}.
  \]
  The Gram inequality in Section 6 applies to the selected copied
  polynomial, with coefficient norm \(ZY^{o(1)}\).

The parent-assessed real-inequality arguments then exclude both
endpoints. In particular, the common interval gap is not being used
to justify any of the analytic estimates that lead to it.

## 9. Fixed neighborhoods and height (`C_UNIFORM` v1)

Old Section 7 correctly addresses the stronger quantifiers of
`prop:dual`. If there were no fixed \(\delta,\eta>0\) and uniform
implied constant, choose shrinking \(\delta_j,\eta_j\) and arbitrarily
large counterexamples \(Y_j\) with moment at least
\(Y_j^{7/3-\eta_j}\). Failure of an implied constant permits such
large choices: at bounded \(Y\) the fixed support and zeroth
derivative bounds give a uniform finite trivial bound.

One endpoint holds on a subsequence. Then
\(Nv,Ne=Y_j^{o(1)}\), and the length exponents converge to that
endpoint. The positive-power discrepancy savings are uniform in
the fixed data. Local partitions/rescalings, initial Mellin masses,
numbers of pieces and omitted tails have the required subpower or
negligible bounds. Fix the factor count on a subsequence and use
compactness of the length simplex and the bounded value-exponent
box. The selected shifts may vary with \(j\), but remain common
to all rows and inside the height bound already established.

If a limiting exponent is one, the full-sum argument has a fixed
positive gap. Otherwise the separately assessed endpoint theorem
chooses a fixed integer multiplicity from the limiting vector.
Only after that choice are the divisor order, constants and small
sieve losses fixed, before sending \(j\) to infinity. Thus a tiny
limiting short length causes no illicit \(Y\)-dependent copy degree.
The finite-degree alternative, after excluding the fixed near-full
region, supplies a finite collection of choices for fixed \(k_0\);
it is an additional dependency, not a necessary replacement for this
sequential argument.

Each strict limiting contradiction survives sufficiently small fixed
losses. Consequently the negation of the original uniform statement
is impossible, conditional on the imported inputs and endpoint
inequalities as stated. The original height \(Y^{0.36}\) is retained;
\(Y^{0.37}\) is only the internal allowance for added Mellin shifts.
There is **no claim that the final saving \(\eta\) is \(1/30\)**.
Identity, neighborhood, Mellin and sieve losses must all be absorbed.

## 10. Claim-by-claim outcome and concrete limits

| Claim/version | Bounded assessment |
|---|---|
| `C_DUAL` v1 / old Theorem 3 | Supported conditional on the stated classical imports and separately assessed exponent dependencies, for exactly Section 2's coefficient class and quantifiers. |
| `C_HB` v1–4 | Imported theorem supported by the inspected v3 reproduction; original article uninspected. Versions change attribution, not mathematics. |
| `C_RECIPROCITY` v1–2 | Imported laws supported with corrected precise locators; mixed Gauss and tame conductor assertions additionally justified locally above. |
| `C_HECKE_FE` v1–3 | Supported import with primitive/nonprincipal/trivial-infinity hypotheses, correct discriminant and gamma normalization; v3 supplies the entireness citation missing from v2's recorded imports. |
| `C_POISSON` v1–2 | Supported import for the stated periodic Schwartz setting; simultaneous sign reversal in the excerpt is harmless. |
| `C_ORDINARY` v1 | Derived from primitive Gauss orthogonality, planar packing and Poisson; applicable row multiplicity checked, no conductor power loss required. |
| `C_EXTENSIONS` v1, inner | Derived length bound \(Y^\epsilon ZH(P,Z)\) for fixed divisor-bounded coefficients, not an unrestricted coefficient-norm operator bound. |
| `C_EXTENSIONS` v1, outer | Derived bound \(Y^\epsilon[J+(JP)^{2/3}+J^{1/3}P]\sum|u_b|^2\), with squarefree primary inner coefficients; full-lattice outer splitting allowed. |
| `C_GRAM` v1 | Derived conditional on the sieve/Poisson imports; common-factor removal, general primitive Gauss evaluation, coefficient separation and \(J_0<1\) tails checked. Finite checks are only partial computational corroboration. |
| `C_DUALITY` v1 | Derived from the properly completed, pole-free primitive equation; common shifts, rowwise phases, missing Euler factors and nonprincipality justified. |
| `C_REDUCTION` v1 | Exact short identity proved; prime-power/repetition errors have the stated power-saving bounds; independent weights give common factors with fixed count and controlled Mellin masses. |
| `C_UNIFORM` v1 | Supported compactness/negation argument with the actual uniform coefficient class and height range, subject to the same explicit dependencies. |
| `C_GENERIC_OBSTRUCTION` v1 | Supported failed generic-only route: both available endpoint bounds have exponent \(7/3\); this proves no positive saving from those bounds alone, not failure of `prop:dual`. |

For the last row, the first generic bound is
\(Y\{Y+Y+Y^{4/3}\}\), and the second is
\(Y\{Y+Y^{4/3}\}\). Neither finite exponent samples nor the
absence of a saving in these particular upper bounds refutes the
structured-coefficient proposition.

**Concrete unresolved downstream obligations:** `C_MAIN` needs the full
prime asymptotic argument; `C_TYPE_I` the level/height comparison;
`C_DISPERSION` the corrected global dispersion estimates and reduction;
`C_DECOMPOSITION` the prime decomposition and transition control;
`C_UNSMOOTHING` the cutoff/large-height passage; `C_ANGULAR` and
`C_ANGULAR_INPUTS` the fixed-angular theorem and its shifted-Hecke/Type I
inputs. In this old-draft package these are unresolved placeholders,
not supplied proofs. This unit establishes none of them, including
the angular extension, and their absence is not evidence that the
original manuscript is false.

No concrete remaining analytic gap was found in the **bounded argument
assessed here**. This does not turn unread original sources into read
ones or finite computations into analytic proofs. Outstanding review
boundaries are explicit: original Heath-Brown inspection has not occurred;
the parent owns the other three mathematical units and mechanical replay;
the native Host-invoked independent Reviewer must examine the coverage
and these substantive assessments before accepting family completion.
The old citation queue remains historical and unmodified.

Theorem 3 is a proposed independent verification of the manuscript's
existing proposition, using imported classical theorems. The elementary
derivations here are assessed as arguments, not as established novel
contributions. The quantitative interval/degree refinements have their
own units. No literature-wide novelty or publication-significance claim
is made, and no new repair or error-search project was undertaken.

`independent_review_required = true`  
`independent_review_complete = false`
