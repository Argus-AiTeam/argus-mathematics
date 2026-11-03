# ID 20001224 - AIM Question 47

**Audit cutoff:** 2026-08-27  
**Producer candidate:** `refuted`  
**Claim alignment:** exact  
**Review state:** pending independent review

## Recovered question

The controlling source is the American Institute of Mathematics,
*Computational Algebraic Statistics* problem compilation,
[original TeX](https://aimath.org/WWN/compalgstat/compalgstat.tex) and
[hard-copy PDF](https://aimath.org/WWN/compalgstat/compalgstat.pdf).
The document was prepared by Seth Sullivant and is dated 2004-03-27. The
workshop ran 2003-12-14 through 2003-12-18; the
[official workshop page](https://aimath.org/pastworkshops/compalgstat.html)
lists Bernd Sturmfels among the organizers.

Question 47 is the item labelled `ques:pis` in the TeX and appears on PDF
p. 10. Its complete mathematical content is:

1. Let
   \(D=\{v_1,\ldots,v_N\}\subseteq\mathbb Q^d\) be \(N\) distinct rational
   design points.
2. Let \(x^{\alpha_1},\ldots,x^{\alpha_N}\) be monomials in
   \(\mathbb Q[x_1,\ldots,x_n]\) whose residue classes are linearly
   independent modulo the design ideal \(I(D)\).
3. Assume these monomials are exactly the standard monomials of a monomial
   ideal \(M=\langle m_1,\ldots,m_r\rangle\).
4. Express each \(m_i\) uniquely in the selected quotient basis and subtract
   that representative, obtaining \(f_i\in I(D)\).
5. Ask whether
   \[
     V(f_1,\ldots,f_r)=D.
   \]

The source itself switches from \(D\subseteq\mathbb Q^d\) to a polynomial
ring with \(n\) variables. The counterexample below takes \(d=n=2\), so it
does not depend on resolving that notational mismatch.

Immediately after the question, AIM says:

> Question 47 was answered in the negative by Bernd Sturmfels at the
> conference.

## Route A - attributed conference answer

**Route result:** official AIM record only; no checkable attributed witness.

The sentence above names a person and an occasion, but supplies no design,
monomial ideal, equations, proof, talk, paper, example number, reference, or
named construction. The separate AIM workshop-activities report merely says
that several questions were answered and does not identify this question.
The workshop schedule and Sturmfels homework also contain no corresponding
example.

Targeted searches of the AIM TeX/PDF/HTML artifacts, workshop material,
Sturmfels's later *Open Problems in Algebraic Statistics*, author-hosted
books, and Pistone/design-ideal literature located background on identifiable
monomial bases and border bases but no primary full text that records
Sturmfels's conference witness.

**Route A failure reason:** `no_checkable_attributed_primary_witness`.

This limits the historical attribution. It does not decide the mathematical
claim, which Route B checks directly.

## Route B - exact rational counterexample

Work in \(R=\mathbb Q[x,y]\). Set
\[
  D=\{(0,0),(1,1),(2,2),(0,1)\}
\]
and choose
\[
  \mathcal O=\{1,x,y,xy\},\qquad
  M=\langle x^2,y^2\rangle.
\]

### Every hypothesis

The four points are distinct and rational. Evaluation of \(\mathcal O\) on
the displayed order of \(D\) gives
\[
 E=
 \begin{pmatrix}
 1&0&0&0\\
 1&1&1&1\\
 1&2&2&4\\
 1&0&1&0
 \end{pmatrix},
 \qquad \det(E)=-2.
\]
Thus the four monomial residue classes are linearly independent modulo
\(I(D)\). Since a reduced set of four rational points has quotient dimension
four, they form a basis.

A monomial is outside \(M=\langle x^2,y^2\rangle\) exactly when both
exponents are at most one. Hence
\[
  \operatorname{Std}(M)=\{1,x,y,xy\}=\mathcal O,
\]
and the minimal monomial generators are \(m_1=x^2\) and \(m_2=y^2\).

Pointwise evaluation on all four points gives the unique quotient
representations
\[
  x^2\equiv xy\pmod{I(D)},\qquad
  y^2\equiv xy-x+y\pmod{I(D)}.
\]
Question 47 therefore produces
\[
  f_1=x^2-xy=x(x-y),
\]
\[
  f_2=y^2-xy+x-y=(y-1)(y-x).
\]

### Exact negation

Both polynomials vanish on the entire line \(x=y\). More precisely,
\[
  V(f_1,f_2)=V(x-y)\cup\{(0,1)\}.
\]
Indeed, away from \(x=y\), \(f_1=0\) forces \(x=0\), and then \(f_2=0\)
forces \(y=1\). In particular,
\[
  (3,3)\in V(f_1,f_2)\setminus D.
\]

The witness is rational, so it refutes the question whether \(V\) is read
over \(\mathbb Q\), \(\mathbb R\), \(\mathbb C\), or
\(\overline{\mathbb Q}\). The determinant, four pointwise identities, and
factorizations are a complete exact proof, not a numerical experiment.

The mechanism is that Question 47 keeps only the corners \(x^2,y^2\) of the
monomial complement. The full border of \(\mathcal O\) also contains
\(x^2y,xy^2\). Their interpolation relations include
\[
  x^2y+2x-3xy=0,
\]
which restricts the extra line \(x=y=t\) to
\(t(t-1)(t-2)=0\). Omitting the non-corner border relations permits the
positive-dimensional extra component.

**Route B result:** exact refutation by a finite rational certificate.

The four-point example was not located verbatim in a primary source and is
not attributed to Sturmfels. It independently verifies the mathematical
negative answer that AIM recorded without support.

## Jacobian contract and replay

The installed Jacobian catalogue was inspected before execution. Two
relevant bounded operations were
`matrix.determinant.compute` and `polynomial.factor.compute`. The selected
operation was:

- operation id: `matrix.determinant.compute`
- input type: a square matrix of canonical rationals over `QQ`, order at
  most 64
- output type: one canonical rational determinant, with method
  `FRACTION_FREE_BAREISS`
- read-only: true

The exact payload was:

```json
{"matrix":{"entries":[[{"num":"1","den":"1"},{"num":"0","den":"1"},{"num":"0","den":"1"},{"num":"0","den":"1"}],[{"num":"1","den":"1"},{"num":"1","den":"1"},{"num":"1","den":"1"},{"num":"1","den":"1"}],[{"num":"1","den":"1"},{"num":"2","den":"1"},{"num":"2","den":"1"},{"num":"4","den":"1"}],[{"num":"1","den":"1"},{"num":"0","den":"1"},{"num":"1","den":"1"},{"num":"0","den":"1"}]]}}
```

Reproduction command:

```sh
/home/argustest/zimo/references/jacobian/.venv/bin/jacobian run matrix.determinant.compute --json '{"matrix":{"entries":[[{"num":"1","den":"1"},{"num":"0","den":"1"},{"num":"0","den":"1"},{"num":"0","den":"1"}],[{"num":"1","den":"1"},{"num":"1","den":"1"},{"num":"1","den":"1"},{"num":"1","den":"1"}],[{"num":"1","den":"1"},{"num":"2","den":"1"},{"num":"2","den":"1"},{"num":"4","den":"1"}],[{"num":"1","den":"1"},{"num":"0","den":"1"},{"num":"1","den":"1"},{"num":"0","den":"1"}]]}}'
```

Exact typed output:

```json
{"operation_id": "matrix.determinant.compute", "output": {"determinant": {"den": "1", "num": "-2"}, "method": "FRACTION_FREE_BAREISS"}, "runtime_ms": 1}
```

The process exited successfully with no timeout and no structured error.
The assigned direct CLI did not emit server-version or protocol fields in
`catalog`, `inspect`, or `run`; those fields are recorded as `not_reported`
rather than inferred. Jacobian certifies only the determinant. The
interpolation identities and extra zero are established by the exact proof
above.

## Decision

Route A establishes only that AIM recorded a negative answer. Route B
supplies the missing exact witness and verifies every condition. The item is
therefore `refuted`, with resolution date `2026-08-27` denoting this audit's
independent certificate, not a claimed date for Sturmfels's unrecorded
conference example.
