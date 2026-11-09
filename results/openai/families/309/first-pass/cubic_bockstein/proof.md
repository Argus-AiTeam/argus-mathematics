# The corrected Brown-Peterson Bockstein cubic

## Statement and source fidelity

The target is the literal assertion \(B(y)^3=0\) in
\(D_{6,81}=\operatorname{Ext}^{6,324}_{(BP_*/3,BP_*BP/3)}(BP_*/3,BP_*/3)\).
Here \(v=v_1\), \(q=v_2^9-v^8v_2^7\), and
\(y=(\eta_R(q)-q)/v^9\), with reduction modulo three **before**
division by \(v^9\). The Bockstein uses an integral lift and the
manuscript's sign:
\[
B(x)=(\Delta\widetilde x-\widetilde x\otimes1-
1\otimes\widetilde x)/3 \pmod3.
\]
Coefficients in the last term move left using the integral right unit.
The lift and its differential must be retained modulo nine until division.

The staged source is
`research/openai_manuscript/The-Kervaire-Invariant-Problem-at-the-Prime-Three-September-24-2026/build/`.
The relevant assertions are `finite.tex:195-240` (`finite:main(i)`,
`finite:low-ranks`, and `finite:low-classes`) and
`recurrence.tex:451-467` (`alg:bockstein`). The claimed smaller-resolution
certificate is described at `recurrence.tex:777-806`: eight coefficient
terms for \(B(y)\), 76 for the cube, and a 2642-term primitive. These
counts and the asserted ranks are not inputs to this audit.

## Inputs and excluded shortcuts

The integral Hazewinkel recursions are `recurrence.tex:26-51`.
The cited source is Ravenel, *Complex Cobordism and Stable Homotopy
Groups of Spheres*, second edition, Theorem A2.1.27, equation (A2.2.1),
and Theorem A2.2.3. The primary-source PDF is retained in this directory.
The smaller resolution and its products are not accepted merely because
the manuscript asserts their correctness.

The characteristic-three identity in `finite:corrected-y` and
`alg:y-convention` is
\[
\delta_9(v_2^9)=y+t'_7,\qquad
t'_7=(\eta_R(v_2^7)-v_2^7)/v.
\]
Thus replacing the corrected \(y\) by the uncorrected ninth power
\((t_1^3-v^2t_1)^9\) changes the target. A Frobenius simplification
of polynomials modulo three also does not compute an integral
Bockstein: division by three precedes its final reduction.
The route using that replacement is retired, not counted as evidence.

The known order-three Kervaire inputs in stems 10 and 106 are classical,
not new audit results. Amelotte, arXiv:1908.05302v1, Theorem 1.1 and
Corollary 1.2, supplies the strong criterion and the stem-106 input;
the surrounding introduction identifies the stem-10 class.
The primary HTML was read. Independent citation attribution remains
the Reviewer's task.

The classification has separate branches. The positive branch is
`cube:order-three`, using the known stem-106 class, the cubic-filtration
step, the finite Adams-Novikov correction/vanishing steps, and the
truncated extended cube. The negative branch is `g:tail-exclusion`,
using the height-six detector, the \(C_3\) differential calculation,
and ascent to \(C_9\). The conjectural coefficient model is not an
assumption of this audit. Neither the negative branch nor the
classification follows just from settling this cubic.

## Jacobian scope

Discovery and exact inspected contracts are retained as dedicated JSON.
The discovered finite-field rank operation takes a direction-bound
matrix family, not a Hopf-algebroid cobar or a Bockstein. It therefore
does not certify the target. A bounded factorization of the actual
numerator \(q\) is submitted to the inspected polynomial operation;
its exact output is only an algebraic check on \(q\), not a cubic
boundary certificate.

## Exact result

The corrected cubic **is a boundary**. The file `exact_certificate.json`
exhibits a weight-81 degree-five cochain \(u\), with 2639 nonzero
coefficient terms on 319 generators, satisfying
\[
d_Cu=\operatorname{get}(B(y))\star
      \operatorname{get}(B(y))\star\operatorname{get}(B(y)).
\]
The right side has 86 nonzero coefficient terms in this certificate.
The producer checks this equality both against the assembled incoming
matrix and by direct cochain evaluation. It also checks the ordinary
cobar Bockstein cocycle, the compared two-cocycle, and the six-cocycle.
Thus, subject to the source-faithfulness justification below,
\(B(y)^3=0\) in the literal Ext group, not just in an associated graded.

The independently reconstructed cochain dimensions are
\((9301,11419,12864)\), and the computed incoming rank is 5256.
These are outputs, not hypotheses. In particular, the decisive evidence
is the displayed primitive and its boundary, not agreement with a rank.
Our cochain counts need not reproduce the source's 76-term cube and
2642-term preimage: a permitted integral lift, chain lift, and
elimination order affect representatives, not the Ext product.

The previous strongest project record was the manuscript's asserted
rank calculation without a primitive. This audit adds a complete
serialized primitive and a standalone arithmetic replay. It does not
add a new stem-322 construction, a survival proof, or a classification.
No manuscript flaw has been established on this route. This is a
bounded exact verification checkpoint; independent Reviewer acceptance
and citation attribution are still pending. No claim of publishable
novelty or campaign completion is made.

## Replaying and decoding the witness

Run from the campaign root:

```bash
$WORKSPACE/argus-live-update/.venv/bin/python research/cubic_bockstein/verify.py
```

Only the Python standard library is needed. The default stage reads the
persisted certificate, reconstructs the operations, Bockstein and cube,
and verifies the supplied primitive. It does not solve again for a
primitive or accept a supplied rank. A failed equality raises an error.
The original producer is `--stage certify --cutoff 81`. Long runs use
the authorized durable runner; receipts and their exact statuses are
retained in this directory.

The first fresh replay of the persisted certificate completed with
exit code zero and `verified_outcome: boundary`. Its exact durable
result is `replay_wait.json`; `calculation_verify_81.json` records the
reconstructed cochains and checks. This is Engineer replay, not an
independent Reviewer verdict.

Each serialized cochain is a list of pairs `[g, polynomial]`.
The generator is packed in base 16:
\(e_k=\lfloor g/16^k\rfloor\bmod16\).
The `digits` list specifies their order, with **zero-based** coordinate
index \(i-1\) and nonnegative digit index \(j\). A coefficient polynomial
is a list `[[[Q1,Q2,Q3,Q4],c], ...]`, with canonical \(c=1,2\) in
\(\mathbf F_3\). Coefficient exponents and all generator weights are
checked during replay.

For a compact cross-check, the reconstructed two-cochain takes the
following values. Unlisted exponents of a generator are zero; these
are resolution coordinates, not assertions that the displayed
generators themselves are cohomology classes.

| Nonzero generator exponents | Value of \(\operatorname{get}(B(y))\) |
|---|---|
| \(e_{(1,0)}=2\) | \(v_2^6\) |
| \(e_{(1,1)}=e_{(1,0)}=1\) | \(-v^{11}v_2^3+v^7v_2^4\) |
| \(e_{(2,0)}=e_{(1,1)}=1\) | \(v^8v_2^3\) |
| \(e_{(1,2)}=e_{(1,0)}=1\) | \(-v^{13}v_2-vv_2^4\) |
| \(e_{(2,0)}=e_{(1,2)}=1\) | \(-v^2v_2^3\) |
| \(e_{(1,2)}=2\) | \(-1\) |

The lift used for the ordinary cobar calculation takes every coefficient
of the expanded mod-three polynomial \(y\) in \(\{0,1,2\}\).
It has 18 terms, and its integral Bockstein has 177 terms.

## Why the implemented complex and product compute the stated Ext class

The following justification is separate from the numerical claims in the
manuscript. In particular, no table rank is assumed.

All variables have nonnegative weight, and \(w_5=121>81\); hence only
coordinates and coefficients of indices at most four can occur.
For integral arithmetic, the program stores \(L_n=3^n l_n\) and
\(S_n=3^n\rho_n\) modulo \(3^{12}\). The right-unit numerator is
divided by \(3^{n-1}\), losing at most \(0+1+2+3=6\) digits through
index four. The coproduct numerator is divided by \(3^n\), losing at
most \(1+2+3+4=10\) digits. Thus both retain at least precision
modulo nine. Divisibility is checked on integer residues before every
division. The ordinary operations are then reduced modulo three;
the Bockstein numerator is divided by three while still modulo nine.
No inverse of three in a finite field is used.

Let \(P_T\) be dual to the monomial \(t^T\). The algebra of continuous
operations is left-free over \(B\) on these elements. Its action and
product are obtained by extracting coefficients of \(\eta_R(v^Q)\)
and \(\Delta(t^U)\), respectively. With coefficients on the left,
\[
P_S v^Q P_T =
\sum_{I\leq S,U}[t^I]\eta_R(v^Q)
[t^{S-I}s^T]\Delta(t^U)P_U.
\]
This formula is implemented directly, not inferred from an Ext chart.
Homogeneity gives \(|U|\geq |T|\) for every output operator, so a
discarded high-pure-weight term cannot return under left multiplication.

For the additive coproduct, the digit operations are tensor factors
\(\mathbf F_3[x_\nu]/(x_\nu^3)\). The tensor product of their alternating
periodic resolutions has differential \(P_{m_\nu}\) in odd degree and
\(-P_{2m_\nu}\) in even degree, with the tensor signs. On the first
active digit, the contraction transfers one or two units of the operator
digit to the resolution generator, with coefficient \(j_0!\).
The one-digit identities are \(1\cdot1=1\) and \(-2=1\) in
\(\mathbf F_3\); the remaining tensor terms cancel with opposite signs.
Thus \(\partial^0H+H\partial^0=1-\iota\varepsilon\), and \(H\)
preserves pure weight and the digit-content tuple.

Order terms by pure weight and then by the tuple \(T+C(g)\), with
largest coordinate index most significant. A non-additive product term
either has a positive coefficient and hence larger pure weight, or has
zero coefficient weight and a strictly larger output tuple: a
nonprimitive coproduct term splits a coordinate into lower-index
coordinates. The positive coefficient ideal is invariant modulo three,
as follows by specializing the right-unit recursion:
\(a_n=3t_n-\sum_{j=1}^{n-1}t_j a_{n-j}^{3^j}\), and induction gives
\(a_n\equiv0\bmod3\). Thus left multiplication preserves the strict
increase. The additive
leading part of a cycle is an additive cycle. Subtracting the actual
boundary of its contracted leading part therefore removes that leading
part and introduces only larger terms. Below weight 81 there are
finitely many such order values.

Inductively start with \(\partial_1=\partial_1^0\). For a generator in
degree \(s\), put \(p=\partial_s^0g\), lift the cycle
\(\partial_{s-1}p\) by the just-described procedure, and subtract its
lift from \(p\). This gives \(\partial^2=0\) and an exact completed
resolution: the same procedure lifts every cycle. The program checks
strict increase at every nonzero correction, rather than accepting
termination on trust.

There is a normalized relative bar resolution with generators
\([P_{T_1}|\cdots|P_{T_s}]\), all \(T_i\ne0\). Coefficients move left
by the displayed product rule; the augmentation is the action on 1,
not an algebra augmentation to \(B\). Inserting the leftmost nonzero
operator gives its \(B\)-linear contraction. Applying this contraction
to the image of each generator's boundary constructs the comparison
from the smaller resolution. In degree two it is precisely the
coefficient-extraction rule `alg:get-two`. Constructing the reverse
comparison and the two homotopies uses the cycle-lifting procedure.
All these maps respect the finite cutoff.

A cochain of internal weight \(d\) evaluates \(g\) in coefficient
weight \(d-w(g)\). A term \(v^QP_Tg\) of pure weight greater than \(d\)
cannot contribute: the operation \(P_T\) lowers coefficient weight by
\(|T|\). Hence truncation at 81 computes the ordinary cobar cohomology
in weight 81, not a quotient approximation. The code also checks
the Bockstein cocycle directly in the ordinary cobar before comparing.

Finally a degree-two cochain \(p\) is lifted to a chain map by exact
cycle lifting, starting at its coefficient values on degree-two
generators. Evaluating another cocycle on this lift is Yoneda
composition. Here both factors have even filtration, so neither the
signed lift convention nor opposite ordering changes the cubic.
The lift cutoff is \(81-27=54\); the discarded terms cannot contribute
to the weight-54 square used as the other factor. Thus an exhibited
primitive of the computed cubic certifies the literal ordinary Ext
identity, not merely a product in the additive associated graded.
