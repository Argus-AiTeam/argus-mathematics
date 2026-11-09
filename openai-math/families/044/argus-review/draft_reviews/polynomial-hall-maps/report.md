# ENGINEER source-fidelity assessment: polynomial-hall-maps

Assessment: theorem-level primary sources support the polynomial
generation input and the trigonometric operator maps. The manuscript's
additional rational degeneration, sign normalization, and parameter
regularity argument are conditionally supported, not established by the
old Lean root-excess sign.

## Exact claim and source version

C_POLY_MAPS@1 states that polynomial Hall-to-Coulomb maps specialize
without inverting rotation or arrow parameters, with the required signs.
The precise source lemma concerns any finite **unframed** quiver
\(\Gamma\), loops and repeated arrows allowed, and a gauge dimension
vector \(\mathbf d\). Put
\[
S=\mathbb Q[\hbar,u_a:a\in\Gamma_1],\qquad K=\operatorname{Frac}(S).
\]
The parameters are independent before specialization. In the polynomial
shuffle half, let
\[
e_{\mathbf n,g}
 =g(z)\prod_i\prod_{\alpha,\beta=1}^{n_i}
                    (z_{i\beta}-z_{i\alpha}+\hbar),
\quad
E\star E'=(-1)^{\sum_{a:i\to j}n_jm_i}E*E'.
\]
The negative half is the ordinary opposite algebra. The source asserts
\(S\)-linear algebra maps from these halves to difference operators,
mapping the distinguished elements to the stated constant multiples of
fundamental operators when \(\mathbf n\leq\mathbf d\), and to zero when
that coordinatewise bound fails. Upon
\(\hbar=0,\ w_{i\alpha}=x_{i\alpha},\ u_a=-f_a\), their images belong to
the commutative flavored Coulomb algebra, have charges
\(+\mathbf n\) or \(-\mathbf n\), and preserve finite identities over
the polynomial parameter ring.

Attribution: OpenAI, *The equivariant cohomological Hikita conjecture for
arbitrary quivers*, September 24, 2026, revision
`4eaee87548250b2682affda7d05d947c05554bae`, source root
`openai-math/preprints/The-equivariant-cohomological-Hikita-conjecture-for-arbitrary-quivers-September-24-2026`.
The exact file is `build/sections/cocharacters.tex`,
`lem:polynomial-monopole-maps`, `eq:hall-sign-product`,
and `eq:corrected-monopole-images`; comparison uses
`build/sections/preliminaries.tex`, `prop:minuscule`, `eq:minuscule`.
The cocharacters file matches SHA-256
`ce58a31d9dae7a3f30fae450a816d82042b57362f37e0ef253b886eb87822f3a`
in the reference manifest
`campaigns/9100044/MANUSCRIPTS.json`.
All ten source and nine existing snapshot digests match read-only.
The old source reference is a symlink to this source. These measurements
do not independently prove commit ancestry.

The old ledger/graph leaves C_POLY_MAPS@1 open as a source-only interface;
there is no independent Argus map construction or checker in the
inventory. It is not the formal root-orientation identity C_CUT_CORE.

## Polynomial regularity argument actually present

The target allows the coefficients
\[
S[w_{i\alpha},
 (w_{i\alpha}-w_{i\beta}+r\hbar)^{-1}:
          \alpha\ne\beta,\ r\in\mathbb Z],
\quad
D_{i\alpha}w_{j\beta}
 =(w_{j\beta}+\hbar\delta_{ij}\delta_{\alpha\beta})D_{i\alpha}.
\]
Gauge-root differences may be inverted here. Pure \(\hbar\), arrow
parameters \(u_a\), and their parameter-only combinations are not
inverted in the final polynomial target \(\mathcal C_S\).
This distinction is essential: the claim is not an everywhere polynomial
abelianized gauge-coordinate expression or the no-flavor Laurent model.

For chosen subsets \(A_i\), the fundamental positive operator is the
sum over \(|A_i|=n_i\) of
\[
g(w_A)
\frac{\prod_{a:i\to j}
          \prod_{\alpha\in A_i,\ \beta\notin A_j}
             (w_{i\alpha}-w_{j\beta}+u_a)}
     {\prod_i\prod_{\alpha\in A_i,\ \beta\notin A_i}
             (w_{i\alpha}-w_{i\beta})}
\prod_{i,\alpha\in A_i}D_{i\alpha}.
\]
Call this \(E_{\mathbf n,g}\). The negative operator
\(F_{\mathbf n,g}\) uses \(g(w_A-\hbar)\), incoming-arrow factors
\(w_{i\alpha}-w_{j\beta}-u_a\), the same denominator, and \(D^{-1}\).
\(\mathcal C_S\) is generated over \(S\) by these operators and the
vertexwise symmetric coefficient polynomials.

The manuscript first constructs maps over \(K\) by
\[
q=e^{\varepsilon\hbar},\quad
t_a=e^{\varepsilon u_a},\quad
W_{i\alpha}=e^{\varepsilon w_{i\alpha}}.
\]
The trigonometric shift is inverted for the positive map. Its kernel's
leading term is
\[
\left(\frac{x-\hbar}{x}\right)^{\delta_{ij}}
 \prod_{a:i\to j}[-(x+u_a)]
 \prod_{a:j\to i}(x+\hbar-u_a).
\]
The explicit sign twist is needed to match this kernel; ignoring it
would not produce the same multiplication convention.

For repeated-slot strings of lengths \(m_{i\alpha}\), the source sets
\(\kappa(\mathbf n)=\sum_{a:i\to j}n_in_j\),
\(P_2=\sum_{i,\alpha}\ell_i m_{i\alpha}^2\), and
\(L_i^+=\sum_{a:i\to j}d_j-d_i+1\), with the incoming version \(L_i^-\).
Its three tabulated orders sum as follows:
\[
(L^\pm\cdot\mathbf n-\sum_i\ell_i n_i)
 +(-P_2+\sum_i\ell_i n_i)
 +(-\kappa(\mathbf n)+P_2)
 =L^\pm\cdot\mathbf n-\kappa(\mathbf n).
\]
The lifted input adds \(\kappa(\mathbf n)\), giving an order independent
of the string composition. The remaining normalization
\(\varepsilon^{-L^\pm\cdot\mathbf n}\) is additive in dimension, as
required for multiplication. This arithmetic balance is correct; it is
not by itself a derivation of each row from the general operator formulas.

For distinguished elements, a same-color factor vanishes on every
string of length at least two. Only subsets of distinct slots survive.
The diagonal factors contribute \(\hbar^{|\mathbf n|}\), cancelling
the intermediate normalization \(\hbar^{-|\mathbf n|}\); other
selected-selected factors cancel the corresponding denominators.
The polynomial-generation theorem for these distinguished elements then
puts the **entire** polynomial half in \(\mathcal C_S\).
This is the actual regularity mechanism. An intermediate construction
over \(K\) is not being directly specialized at a pole.

## Exact signs and specialization

The source's formulas are
\[
\Psi_+(e_{\mathbf n,g})
 =(-1)^{L^+\cdot\mathbf n+\kappa(\mathbf n)}E_{\mathbf n,g},
\qquad
\Psi_-(f_{\mathbf n,g})=F_{\mathbf n,g}.
\]
After the specified specialization, the BFN comparisons are
\[
M^+_{\mathbf n,g}
 =(-1)^{\sum_{a:i\to j}n_i(d_j-n_j)}
                       E_{\mathbf n,g}|,\qquad
M^-_{\mathbf n,g}
 =(-1)^{\sum_i n_i(d_i-n_i)}
                       F_{\mathbf n,g}|.
\]
The first is the outgoing-matter reversal sign; the second is the
negative tangent-root reversal sign. As an internal parity check, the
combined positive exponent is congruent to
\(\sum_i n_i(1-d_i)\); the negative exponent is congruent to the same
quantity modulo two. This checks compatibility of the displayed signs,
not the full general degeneration from scratch.

Every allowed target denominator becomes \(x_{i\alpha}-x_{i\beta}\)
with distinct same-color slots. Thus specialization defines a map to
the rational-coefficient coweight algebra. The minuscule formula puts
the specialized generators in the actual BFN algebra, so all their
polynomial words lie there. No injectivity, flatness, or surjectivity
of a specialized Hall map is asserted.

In particular, one must specialize the abstract polynomial half through
this map. Ambient polynomial divisibility by \(\hbar\) does not imply
membership in \(\hbar\mathcal S_S^+\). Discarding distinguished elements
because their ambient representatives vanish at \(\hbar=0\) would
invalidate this argument; the source explicitly avoids that operation.

## Exact primary sources obtained

1. Shivang Jindal and Andrei Negut, *The loop-nilpotent cohomological
   Hall algebra*, **arXiv:2607.23544v1**:
   <https://arxiv.org/html/2607.23544v1> and
   <https://arxiv.org/pdf/2607.23544v1>.
   Definition 2.3 defines the polynomial/divisibility shuffle form.
   Theorem 2.4 gives generation over its parameter ring by
   \(e_{\mathbf n,g}\), not merely after passing to its fraction field.
   The PDF's Section 2.2, (29)-(30), requires nonzero \(\hbar\),
   loop weights outside \(\mathbb Z\hbar\), and the geometric
   parameter setting. Remark 2.6 restricts the exponential-based
   argument to that setting, rather than arbitrary elements of an
   arbitrary field. Independent universal equivariant parameters
   satisfy it. The PDF was streamed and read in memory; no archive was
   written. PDF equation numbers differ from some HTML numbering.
2. Alexander Tsymbaliuk, *Difference operators via GKLO-type
   homomorphisms: shuffle approach and application to quantum
   Q-systems*, **arXiv:2207.02804v2**, Section 5.1 and Theorem 5.7(a)-(b),
   Equations (93) and (96):
   <https://arxiv.org/html/2207.02804v2>.
   These give maps from the full trigonometric shuffle algebra and
   its opposite, summing over strings assigned to gauge slots,
   including loops. The parameters satisfy
   \(|q|<|t_a|<1\). The source's real open region
   \(\hbar<u_a<0\), followed by small positive \(\varepsilon\),
   satisfies these inequalities and can justify rational coefficient
   identities. The primary theorem is not itself a theorem about the
   rational polynomial specialization at \(\hbar=0\).

## Supported scope and remaining proof obligations

The source has a meaningful polynomial regularity proof: universal
parameters first, explicit generator images, generation over \(S\), and
only then specialization. It is not a generic-parameter argument
mistaken for regularity, and the retrieved generation theorem supports
the integral-form step over rational coefficients.

The concrete unestablished interface in the old inventory is the general
filtered degeneration: each of the three order rows, the lift-independence
of normalized leading maps for arbitrary polynomial shuffle inputs, and
the full sign calculation for loops/repeated strings must agree with
Tsymbaliuk's (93)/(96). The table balances, but no old certificate checks
that general calculation. The last geometric membership step also uses
the coefficient- and convention-compatible BFN minuscule formula.
These are specific remaining obligations, not a missing-access verdict;
the cited primary theorem statements were obtained.

Classification: reconstruction of known Hall/operator inputs and a
source-only proposed rational/polynomial bridge; originality unverified.
No contradiction in C_POLY_MAPS@1 is established here. Native
Host-invoked independent review is required and pending, with no engineer
self-acceptance.
