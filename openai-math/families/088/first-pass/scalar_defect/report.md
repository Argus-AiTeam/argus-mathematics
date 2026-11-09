# A quantitative scalar defect in the Petty norm estimate

## Result and scope

Use precisely the definitions and constants in the staged OpenAI preprint
*Petty's projection-volume conjecture in dimensions at least four*,
September 24, 2026, `build/latex/sections/04_norm.tex`,
Lemma `lem:scalar-estimates`. For every integer \(n\geq4\) and every real
\(z>0\), put \(\Delta_n(z)=2W(z)-\mathcal L(z)\). Then
\[
 \boxed{\quad \Delta_n(z)\ \geq\
 \frac{41}{360}\frac{(z-1)^2}{\max(1,z)^{2n}}.\quad}                 \tag{1}
\]
In particular, the manuscript's pointwise inequality is true, with equality
exactly at \(z=1\). Its separate scalar mean-coefficient estimate is also
true in every dimension. The constant in (1) is a certified uniform
constant, not an optimality claim.

The quantitative norm consequence is
\[
 \boxed{\begin{split}
 (\mathbb E g^k)^2-(\mathbb E g^{k-1})^2-c_{n,k}\|Q(g^k)\|_2^2
 &\geq \frac{41}{360}\,
   \mathbb E\frac{(g-1)^2}{\max(1,g)^{2n}}\\
 &\geq \frac{41}{360\max(1,\|g\|_\infty)^{2n}}\,\|g-1\|_2^2 .
 \end{split}}                                                    \tag{2}
\]
Here \(g\) is a norm on \(\mathbb R^n\), \(\mathbb E g^{-n}=1\),
\(k=1\) if \(n=4\) and \(k=2\) otherwise, and \(Q\) is the manuscript's
orthogonal projection onto the even spherical harmonics of degree at
least four. The transfer uses the manuscript's curvature/projection
reduction as an explicit analytic input. This work does not independently
formalize that input, affine positioning, or the full projection-body
theorem.

Compared with the strongest result asserted at this location in the staged
source, (1) and (2) replace qualitative strictness by an explicit defect.
They are a mathematical strengthening relative to that version, not a
claim of priority over all literature. Independent review, statement-fidelity
approval, and a broader novelty/significance determination belong to the
Host-invoked Reviewer. No false assertion was found in the audited scalar
lemma or its printed algebraic certificates; this is not a verdict on
unaudited parts of the manuscript.

## Definitions used in the recomputation

Write \(p=n-1\), \(d_*=2n+8\), and
\[
 e=(z^{-n}-1)/n,\quad M=z^k-1+ke,\quad W=z^k-z^{k-1}+e,\quad
 G=\beta M\,1_{\{z>1\}},\quad D=z^k-1-G .
\]
The constants are
\[
 \begin{array}{c|c|c|c}
 n&\beta&w&c\\ \hline
 4&1/2&3/14&121/35\\
 5,6&2/3&1/3&(n^2+5n+7)/((n+1)(n+3))\\
 n\geq7&2/3&1/2&(n^2+5n+7)/((n+1)(n+3)).
 \end{array}
\]
For \(z>1\),
\[
 I=k^2\left\{\frac{z^{2k-1}-1}{2k-1}
 -\frac{2(1-z^{k-1-n})}{n+1-k}
 +\frac{1-z^{-2n-1}}{2n+1}\right\},
 \qquad
 \mathcal L=c\left\{\frac{p\beta^2zI-2nG^2}{wd_*}
                    +\frac{D^2}{1-w}\right\}.
\]
For \(z\leq1\), \(I=G=0\). Differentiating the closed form gives
\(I'=M'^2\), and \(I(1)=0\). Thus it is the stated integral, not an
independently postulated function. The Lean source uses `zI` for \(zI(z)\)
and ordinary natural powers and reciprocals; the exact relationship to
these formulas is documented in `statement_fidelity.md`.

## The interval \(0<z\leq1\)

Set \(u=1-z\). For natural \(j\), let
\[
 B_j=1+ju+\frac{j(j+1)}2u^2 .
\]
The identity
\[
 B_j-zB_{j+1}=\frac{(j+1)(j+2)}2u^3\geq0
\]
and induction give \(B_nz^n\leq1\), including the base \(n=0\).
Since \(z>0\),
\[
 z^{-n}\geq1+n(1-z)+\frac{n(n+1)}2(1-z)^2 .
\]
Consequently \(2W\geq(n+2k-1)(z-1)^2\). Also
\(|z^k-1|\leq k|z-1|\) for the specified \(k=1,2\), so
\[
 \Delta_n(z)\geq
 \left(n+2k-1-\frac{ck^2}{1-w}\right)(z-1)^2.                     \tag{3}
\]
The margins for \(n=4,5,6\) are \(3/5,7/8,43/21\).
For \(n\geq7\), put \(v=n-7\). Exact simplification gives
\[
 10(n+1)(n+3)\left(n+3-8c-\frac9{10}\right)
   =v(10v^2+191v+918)\geq0.                                     \tag{4}
\]
All margins in (3) exceed \(41/360\), proving (1) on this interval.
The formulas give \(\Delta_n(1)=0\) exactly.

## The interval \(z>1\): dimensions \(4,5,6\)

Recompute \(P_n=s_nz^{2n}\Delta_n(z)\) directly from the definitions,
where \((s_4,s_5,s_6)=(2880,712800,221130)\), and put \(x=z-1>0\).
The recomputed polynomials agree exactly with
`eq:small-polynomials`. Full coefficients in both \(z\) and \(x\) are
in `exact_certificate.json`; they are regenerated, not trusted as input.
Exact coefficient subtraction yields
\[
 \begin{array}{c|l}
 n&P_n(1+x)/x^2\text{ is at least}\\ \hline
 4&1728-1446x-6711x^2+17052x^4\\
 5&623700-1505900x-5802775x^2+86314305x^4\\
 6&452790-132249x^2+51269452x^4 .
 \end{array}                                                     \tag{5}
\]
Every discarded coefficient is nonnegative. This checks all coefficients
of each of these three fixed polynomials, rather than extrapolating from
the first few entries of the printed tables.

The exact identity
\[
 4b(a+bu^2-du)=(2bu-d)^2+(4ab-d^2)
\]
proves \(du\leq a+bu^2\) whenever \(b>0\) and \(d^2\leq4ab\).
Apply it to
\[
 \begin{array}{c|r|r|r}
 d&a&b&4ab-d^2\\ \hline
 1446&400&1400&149084\\
 8111&1000&17052&2419679\\
 1505900&200000&2900000&52265190000\\
 8702775&230000&86314305&3670867899375\\
 132249&1000&51269452&187588009999
 \end{array}
\]
with \(u=x,x^2,x,x^2,x^2\), respectively.
The three rows of (5) are therefore at least
\[
 328,\qquad193700,\qquad451790 .
\]
Dividing by \(s_nz^{2n}\) proves (1), since
\[
 \frac{328}{2880}=\frac{41}{360},\qquad
 \frac{193700}{712800}>\frac{41}{360},\qquad
 \frac{451790}{221130}>\frac{41}{360}.
\]
The last row supplies a quantitative version of the manuscript's
discriminant argument in dimension six.

## An all-dimension power-tail inequality

This is the universal ingredient; a finite dimension sweep is not being
used to certify the infinite range. For natural \(j\) and \(x\geq0\), define
\[
 C_j=1+jx+\frac{j(j-1)}2x^2+\frac{j(j-1)(j-2)}6x^3,\qquad
 T_3(j)=(1+x)^j-1-jx-\frac{j(j-1)}2x^2 .
\]
The identity
\[
 (1+x)C_j-C_{j+1}=\frac{j(j-1)(j-2)}6x^4\geq0
\]
proves \(C_j\leq(1+x)^j\) by induction. The coefficient is zero for
\(j=0,1,2\) and positive thereafter. In particular \(T_3(j)\geq0\).

Define
\[
 E_j=(1+x)^{2j}-8(1+x)^j+7+6jx+(2j^2-3j)x^2 .
\]
Direct algebra gives \(E_0=0\) and
\[
 \begin{split}
 E_{j+1}={}&(1+x)^2E_j+
  8x\big((1+x)^{j+1}-C_{j+1}\big)+4jx^3\\
 &+\frac{j(4j^2-6j+5)}3x^4 .                                  \tag{6}
 \end{split}
\]
All terms on the right are nonnegative if \(E_j\geq0\).
Indeed \(4j^2-6j+5=4(j-3/4)^2+11/4>0\).
Induction proves
\[
             T_3(2j)\geq8T_3(j)\geq0                           \tag{7}
\]
for every natural \(j\). Both induction identities and their base cases
are checked exactly by the verifier and proved in Lean. No binomial
ratio estimate, external positivity oracle, or numerical sampling is
needed for (7).

## The interval \(z>1\): every \(n\geq7\)

Set \(a=z^n\), \(x=z-1\), and \(S=9(n+4)/c\). Expanding the definitions,
treating \(a,z\) as independent symbols until the final substitution, gives
\[
 Sz^{2n}\Delta_n(z)=
 a^2(q_0+q_1x+q_2x^2+q_3x^3+q_4x^4)
 +a(r_0+r_1x+r_2x^2)+T.                                       \tag{8}
\]
The verifier derives the coefficients before comparing them with
`eq:large-coefficients`. In the notation of `eq:large-signs`,
\[
 \begin{gathered}
 q_0+r_0/8=\frac{V_0}{4n^2(2n+1)(n^2+5n+7)},\quad
 q_1=\frac{2V_1}{n(2n+1)(n^2+5n+7)},\\
 q_2=\frac{2(n+4)V_2}{n(n^2+5n+7)},\quad
 r_0=-\frac{2R}{n^2(n^2+5n+7)},\\
 q_3=8(n-4)/3,\quad q_4=2(n-4)/3,\quad
 r_1=32+128/n,\quad r_2=16+64/n.
 \end{gathered}
\]
The positive-coefficient expansions of \(V_0(10+t),V_1(10+t)\),
\(V_2(7+t),R(7+t)\) recompute exactly as printed. Thus for \(n\geq10\),
\(q_0+r_0/8,q_1,q_2,q_3,q_4,r_1,r_2\geq0\) and \(r_0\leq0\).
The constant and linear coefficients in (8) vanish, and its quadratic
coefficient is
\[
                  K=S(n+3-8c).                                \tag{9}
\]

Write \(T_2(j)=z^j-1-jx\) and \(T_1(j)=z^j-1\); these are nonnegative
for \(x\geq0\). Subtracting \(Kx^2\) from (8) gives the exact
nonnegative decomposition
\[
 \begin{split}
 &(q_0+r_0/8)T_3(2n)
 +(-r_0/8)\big(T_3(2n)-8T_3(n)\big)\\
 &\quad+q_1xT_2(2n)+r_1xT_2(n)
 +q_2x^2T_1(2n)+r_2x^2T_1(n)
 +q_3x^3z^{2n}+q_4x^4z^{2n}.                                  \tag{10}
 \end{split}
\]
Equations (7) and (10) prove \(Sz^{2n}\Delta_n(z)\geq Kx^2\) for
all \(n\geq10\).

The three remaining dimensions \(7,8,9\) are fixed finite algebraic
cases, not a substitute for the universal proof. Direct expansion of
(8) in \(x\) has zero constant and linear coefficients, nonnegative
coefficients thereafter, and quadratic coefficients
\[
                 7128/91,\quad7236/37,\quad43992/133.
\]
These equal (9) exactly. The complete coefficient lists are in the
certificate, and Lean expands the defining expressions itself.
Hence, for all \(n\geq7\),
\[
 \Delta_n(z)\geq(n+3-8c)(z-1)^2/z^{2n}
              \geq(9/10)(z-1)^2/z^{2n}.
\]
This proves (1) on the remaining domain.

## Mean bound and transfer to norms

The left side of `eq:scalar-mean-bound` recomputes to
\(11/12,589/864,1387/1890\) for \(n=4,5,6\).
For \(n\geq7\), its difference from \(3/4\), with \(3/4\) first, is
\[
 \frac{3n^3+128n^2+505n+548}{36(n+1)(n+3)(n+4)}>0 .
\]
Thus the mean bound is valid with the unmodified constants.

For completeness, retain every loss in the manuscript's norm deduction.
Put \(m=\mathbb E g^k-1\), \(\ell=\mathbb E g^{k-1}-1\), \(t=\mathbb E G(g)\).
Normalization and Jensen give \(m\geq0\), \(0\leq t\leq\beta m\), and
\(0\leq\ell\leq(k-1)m/k\). The curvature/projection reduction says
\[
 c\|Q(g^k)\|_2^2\leq
 \mathbb E\mathcal L(g)+
 c\left(\frac{2nt^2}{wd_*}-\frac{(m-t)^2}{1-w}\right).
\]
The last parenthesis is increasing on \(0\leq t\leq m\); its derivative
is \(4nt/(wd_*)+2(m-t)/(1-w)\geq0\).
Since \(\beta\leq1\), its value is at most that at \(t=\beta m\).
The verified mean estimate and the range of \(\ell\) bound the resulting
term by
\[
 \frac{2k-1}{k^2}m^2\leq m^2-\ell^2 .
\]
Now \(\mathbb E W(g)=m-\ell\), so the total norm deficit is at least
\(\mathbb E(2W(g)-\mathcal L(g))\). Integrate (1) to obtain the first
inequality in (2). The second follows pointwise from
\(\max(1,g)\leq\max(1,\|g\|_\infty)\).
All functions involved are bounded and continuous on the sphere and
\(g\) is bounded away from zero. The nonnegative integrand in (2)
vanishes exactly when \(g=1\); continuity and full support of spherical
measure show that its expectation vanishes exactly for the constant
unit norm. This also preserves the original equality condition.

## Reproduction and evidence boundaries

Run

```sh
$WORKSPACE/argus-live-update/.venv/bin/python research/scalar_defect/verify.py --test-tamper
```

The default verifier never rewrites its certificate. It recomputes every
coefficient, rational identity, induction, sign witness, and margin,
then compares the complete result with `exact_certificate.json`.
`--write-certificate` is the explicit generation mode. A changed
coefficient is rejected; no approximate arithmetic or finite search
stands in for (6)--(10).

Before custom certificate code, the installed Jacobian adapter's SOS and
box-enclosure typed contracts were inspected. The matching bounded SOS
operation verified
\[
 5600(400-1446x+1400x^2)
 =(2800x-1446)^2+386^2+6^2+6^2+4^2.
\]
The exact payload, retained typed response, server/protocol versions,
and zero adapter exit status are in `jacobian_payload.json`,
`jacobian_output.json`, and `jacobian_status.json`. Those inspected
contracts do not express a natural-number-indexed exponent or an
unbounded half-line; their success is only evidence for the stated
fixed SOS subproblem, not for the universal theorem.

The separate Lean certificate must be read with `statement_fidelity.md`.
Compilation certifies the encoded scalar statement. It does not certify
the prose's interpretation, an independent review verdict, literature
priority, or the full geometric theorem.

The final claim-recording run used Lean **4.31.0**, returned exit code
**0** and `proof_holes=[]`, and archived
`certificates/C_SCALAR_DEFECT-aeb6e84e428855c8.json`. The command was

```sh
$WORKSPACE/argus-live-update/.venv/bin/python -m argus_skill.verticals.math.lean_evidence verify research/scalar_defect/Main.lean --project-root . --claim C_SCALAR_DEFECT --statement-fidelity research/scalar_defect/statement_fidelity.md
```

The exact verifier returned zero. In addition to its built-in tamper
test, a separate invocation of the standalone CLI with an altered
all-dimension sign coefficient returned nonzero with the expected
certificate-mismatch error. Both official ledger/graph checks passed
against `campaigns/9000088`,
not the shared batch directory. Independent Reviewer approval remains
pending; it has not been supplied by the Engineer.
