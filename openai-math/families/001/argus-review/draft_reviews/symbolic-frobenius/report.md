# Symbolic Frobenius: exact local algebra and a convention diagnostic

**Engineer assessment:** supported in the stated matrix family.
**Result class:** exact algebraic calculation with a local convention diagnostic.
**Novelty:** not assessed/not claimed.
**Independent review:** `pending_native_reviewer`.

## Exact claim, hypotheses, and attribution

This reproduces historical Argus work supporting PF-CORE, not a separate
geometric theorem. Historical sources are under
`families/001/first-pass/prescribed-filtration-audit/`:
`verify.py`, `exact_certificate.json`, and the three `jacobian-*.json` files.
The relevant prose is “Exact algebraic core and a route that fails” in
`realization_proof.md`.

Work first over \(\mathbf Q(p,u,v)\), with \(p,u,v\) algebraically independent.
For a Frobenius interpretation, the characteristic-zero coefficient field
has an endomorphism \(\sigma\) fixing rational scalars, \(p\ne0\),
\(u=\sigma(t)\), and \(v=\sigma^2(t)\). Define

\[
 \operatorname{dual}(a)=(a^{-1})^t,\quad
 b=\begin{pmatrix}0&1\\-1/p&0\end{pmatrix},\quad
 g=\begin{pmatrix}1&t\\0&1\end{pmatrix}.
\]

The asserted cohomological frame is
\(S=\operatorname{dual}(\sigma(g))\), not
\(\operatorname{dual}(g)\). With \(B=\operatorname{dual}(b)\), the equation
\(SA=B\sigma(S)\) has

\[
 A=\begin{pmatrix}-v&1\\-p-uv&u\end{pmatrix},
 \qquad\det A=p.
\]

This convention is attributed in the historical draft to **Mark Kisin and
Rong Zhou**, arXiv:2505.02165v1, §2.1.14. The preserved source
`sources/KZ-2505.02165v1.txt`, lines 492–502, indeed identifies a Frobenius
descent of a linear dual and writes the Frobenius on the chosen Dieudonné
module as \(\sigma(b_x)\sigma\). Its surrounding geometric hypotheses are
not established by this matrix calculation. The OpenAI October 7, 2026
manuscript is context, not the target of a counterexample here.

## Decisive algebra

Inverse followed by transpose reverses order twice, so `dual` is a group
homomorphism, not an antihomomorphism. It commutes with coefficient Frobenius.
Since \(b\) has rational entries, \(\sigma(b)=b\). Thus

\[
 S=\begin{pmatrix}1&0\\-u&1\end{pmatrix},\quad
 B=\begin{pmatrix}0&1\\-p&0\end{pmatrix},\quad
 \sigma(S)=\begin{pmatrix}1&0\\-v&1\end{pmatrix}.
\]

Multiplication verifies \(SA=B\sigma(S)\) entry by entry;
\(\det A=-uv+(p+uv)=p\). The row-major four-unknown linear system
has coefficient determinant **1**, so its solution is unique without an
exceptional parameter locus for that system. The original matrix \(b\) and
the invertible-frame interpretation still require \(p\ne0\).
The checker also verifies
\[
 A=\operatorname{dual}\bigl(\sigma(g)^{-1}b\sigma^2(g)\bigr).
\]
These are symbolic identities, not a finite sample. They instantiate the
abstract homomorphism identity in `lean-core`; they do not prove all
geometric applications of it.

## The \(p=2\) quadratic diagnostic

Take \(t^2+t+1=0\). Reduction modulo 2 has no root and has nonzero derivative;
this gives the unramified quadratic \(2\)-adic interpretation. Its
nontrivial Frobenius is \(t\mapsto-1-t=t^2\), of order two.
Exact reduction in the quadratic algebra gives

\[
 A_{\mathrm{correct}}=
 \begin{pmatrix}-t&1\\-3&-1-t\end{pmatrix},\qquad
 A_{\mathrm{omitted\ }\sigma\mathrm{\ basis}}=
 \begin{pmatrix}1+t&1\\-3&t\end{pmatrix}.
\]

Their difference is \(-(1+2t)I\ne0\). Both determinants are 2, so checking
only the determinant would miss this convention error. The second matrix
uses the wrong basis \(\operatorname{dual}(g)\); it is **not a refutation**
of the manuscript's indicated convention. The finite mod-2 root check,
exact quadratic specialization, universal symbolic matrix family, and
universal abstract Lean identity are distinct levels of evidence.

## Safe exact replay and versions

Before execution, the entire old `verify.py` was inspected: it reads JSON
relative to its own `ROOT`, prints results, and contains no file-write calls.
Byte-identical copies of that checker and its inputs are in
`historical-replay/` **inside this unit**. In particular:

- `verify.py` SHA-256:
  `28d352ec78c988c0fe315bc809b531e1f10e66fc4ae22c1f496150bb60b9ba28`.
- Historical `exact_certificate.json` SHA-256:
  `1bffa67f2097d014cdb2fec54f524dcf03479f21a7e6db8061d4e32a137a881f`.
- Historical payload SHA-256:
  `3421839b30fcf3f4930b6b64141cbd0c247eef7aa1c206723d37ebdb2755c926`.

The exact historical checker command, from the current campaign root, was:

```sh
PYTHONDONTWRITEBYTECODE=1 $WORKSPACE/miniconda3/bin/python -B research/draft_reviews/symbolic-frobenius/historical-replay/verify.py
```

Exit 0, empty stderr, **0.302 seconds**. Its exact JSON stdout is retained in
`exact-replay.json`: algebra PASS, symbolic determinant \(p\), quadratic
diagnostic PASS, and the arbitrary-lattice shortcut refuted **without**
claiming a manuscript counterexample. It explicitly says geometry is not
machine-checked.

Actual checker runtime: **Python 3.13.5**, Anaconda build, GCC 11.2.0;
**SymPy 1.14.0**. The requested `argus-latest` environment lacked SymPy;
the existing system runtime was used instead, with no installation or
environment modification. Argus modules themselves used the mandated
interpreters. Bytecode writing was disabled; old and copied `__pycache__`
directories were not created, and checked historical hashes stayed unchanged.

## One inspected, bounded Jacobian replay

No direct Jacobian import was used. Discovery requested **three** operation
cards in domain `matrix`; only
`matrix.symbolic.linear_system.solve` was executed. The exact current contract
was read before that run and agrees with the historical contract. It requires
canonical sparse rational functions over a common ordered parameter list;
it returns a **generic** rational-function solution, not specialization cases.
The existing 4-by-4, three-parameter system lies within its bounded schema.

Exact operation command:

```sh
PYTHONDONTWRITEBYTECODE=1 $WORKSPACE/argus-live-update/.venv/bin/python -B -m argus_skill.tools.jacobian run --operation matrix.symbolic.linear_system.solve --payload-file research/draft_reviews/symbolic-frobenius/jacobian-payload.json --timeout 60
```

Server **jacobian 0.14.0**, protocol **2025-11-25**, transport `mcp-stdio`.
One mathematical operation attempt: exit **0**, `timed_out=false`,
`adapter_error=null`; CLI time **3.265 seconds**, server runtime **25 ms**.
Typed result: `UNIQUE`, `EXACT_RATIONAL_FUNCTION`,
`GENERIC_OVER_QQ_FIELD`, with the expected solution.
The historical and current mathematical outputs agree. The copied exact
checker independently reconstructs the equations and verifies the returned
solution and residual, rather than trusting the classification string.
This recomputation and the sidecar both use SymPy-based arithmetic; they
are not independent foundational kernels.

Dedicated JSON files hold the transport data, not this report:

- `jacobian-discovery.json`: bounded discovery request and cards.
- `jacobian-contract.json`: exact typed input/output contract.
- `jacobian-payload.json`: exact input, byte-identical to the historical input.
- `jacobian-output.json`: current typed output.
- `jacobian-adapter-status.json`: exact commands/stdout/stderr, executable,
  server version, protocol, operation ID, error/timeout status and attempt count.

The original `jacobian-linear-contract.json`, `jacobian-payload.json`, and
`jacobian-output.json` remain read-only historical evidence for the same
operation and version, also preserved in `historical-replay/`.
No server-backend Python/SymPy version is exposed by this contract, so it is
not inferred from the checker's runtime.

The reproduction driver was run as:

```sh
PYTHONDONTWRITEBYTECODE=1 $WORKSPACE/miniconda3/bin/python -B research/draft_reviews/symbolic-frobenius/replay.py discover
PYTHONDONTWRITEBYTECODE=1 $WORKSPACE/miniconda3/bin/python -B research/draft_reviews/symbolic-frobenius/replay.py execute
PYTHONDONTWRITEBYTECODE=1 $WORKSPACE/miniconda3/bin/python -B research/draft_reviews/symbolic-frobenius/replay.py check
```

The final check reports **PASS** for the historical solution, current adapter
solution, quadratic diagnostic, and universal lattice identity. Timeout,
UNKNOWN or incomplete output would be a non-conclusion; none occurred.

## Scope and limitations

The historical certificate's computational statements agree with the exact
source and results. Its PF-REALIZATION bundle label is not a theorem proved by
this script. The separately matched Lean certificate supports only the four
abstract statements discussed in `../lean-core/report.md`.

This unit supplies no abelian realization, integral tensor torsor, admissible
filtration, weak-admissibility proof, ramified Frobenius extension, or
verification of external geometric theorem applicability. Generic parameter
arithmetic is not a global paper certificate. No local algebraic error was
found; novelty and the manuscript's global correctness are not assessed.
