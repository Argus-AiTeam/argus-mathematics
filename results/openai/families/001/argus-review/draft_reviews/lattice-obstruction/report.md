# Lattice obstruction: a counterexample to an insufficient proof shortcut

**Engineer assessment:** the counterexample is correct in its explicitly
restricted scope. **Result class:** counterexample to the
arbitrary-stable-lattice integral-tensor shortcut, **not** a counterexample to
existential abelian realization. **Novelty:** not assessed/not claimed.
**Independent review:** `pending_native_reviewer`.

## Exact claim, source, and attribution

This is historical Argus claim **PF-LATTICE-OBSTRUCTION, version 1**, not a
new manuscript-error claim. Its historical ledger hash is
`27c5d9457f1ec998cdf64b99b397bcf7645cd2107d3deab4c2662764f4da5087`.
The sources are under
`families/001/first-pass/prescribed-filtration-audit/`:
`exact_certificate.json` (`integral_shortcut_obstruction`),
`verify.py` (`verify_integral_obstruction`), and the lattice paragraph of
`realization_proof.md`.

Let \(V=\mathbf Q_2^2\) and use **columns** of
\[
 L=\begin{pmatrix}1&0\\1&2\end{pmatrix}
\]
as a \(\mathbf Z_2\)-basis of a lattice \(\Lambda=L\mathbf Z_2^2\).
For **every** \(s\in\mathbf Z_2\), put
\(D_s=\operatorname{diag}(1,1+2s)\). The claim is that \(\Lambda\) is preserved
as a lattice by all \(D_s\), although the invariant rational idempotent
\(e=\operatorname{diag}(1,0)\) does not belong to
\(\operatorname{End}_{\mathbf Z_2}(\Lambda)\).

## Universal verification, not a finite sample

The determinant of \(L\) is 2, so its columns span a full lattice in \(V\),
although \(L\notin\operatorname{GL}_2(\mathbf Z_2)\). Exact multiplication gives
\[
 L^{-1}D_sL=\begin{pmatrix}1&0\\s&1+2s\end{pmatrix}.
\]
Its entries lie in \(\mathbf Z_2\) for every \(2\)-adic \(s\), and its
determinant \(1+2s\) reduces to 1 modulo 2. Hence this matrix is in
\(\operatorname{GL}_2(\mathbf Z_2)\), not merely an integral endomorphism.
Thus \(D_s\Lambda=\Lambda\) for **every** \(s\in\mathbf Z_2\).
Equivalently, the representation of \(\mathbf Z_2^\times\) by
\(a\mapsto\operatorname{diag}(1,a)\) preserves \(\Lambda\).

The projector satisfies \(e^2=e\) and commutes with all \(D_s\), so it is an
invariant rational tensor of endomorphism type. However,
\[
 L^{-1}eL=\begin{pmatrix}1&0\\-\tfrac12&0\end{pmatrix}
\]
has an entry of \(2\)-adic valuation \(-1\); it is not integral.
There is also a direct witness: \((1,1)\in\Lambda\), but
\(e(1,1)=(1,0)\notin\Lambda\), since
\(\Lambda=\{(x,y)\in\mathbf Z_2^2:y-x\in2\mathbf Z_2\}\).
The fixed tensor is \(e\); clearing its denominator by replacing it with
\(2e\) is not preservation of the specified idempotent tensor.

These identities are polynomial/rational identities, and the unit argument
applies to arbitrary \(2\)-adic integers. Testing a finite list of integers
would not establish the stated quantifier; neither the argument nor the
replay is limited to such tests.

## Why this is not an existential counterexample

The **standard lattice** \(\Lambda_0=\mathbf Z_2^2\) is stable under every
\(D_s\) and carries the same \(e\) integrally. Consequently this example
disproves the shortcut

> an arbitrary stable lattice automatically carries the specified invariant
> rational projector tensor integrally,

not the assertion that **some** suitable lattice can be chosen. It supplies
no polarized abelian variety, local Shimura point, prescribed filtration, or
fixed universal abelian marking violating a realization theorem. In
particular, it does not refute PF-REALIZATION or the manuscript. Turning
failure on this one chosen lattice into nonexistence of an allowed geometric
realization would be a quantifier error. The historical certificate and prose
already make this distinction; their scope is correct.

## Replay, exact outputs, and versions

The old checker's write behavior was inspected before execution. Its source
reads JSON relative to `ROOT` and prints JSON, without write calls. It was
copied unchanged with its inputs into the sibling unit's
`symbolic-frobenius/historical-replay/`; nothing was executed with an old
directory as a writable output location.

Exact historical checker invocation from the current campaign root:

```sh
PYTHONDONTWRITEBYTECODE=1 $WORKSPACE/miniconda3/bin/python -B research/draft_reviews/symbolic-frobenius/historical-replay/verify.py
```

Exit **0**, empty stderr, **0.302 seconds**. Relevant exact stdout field:
`"arbitrary_lattice_shortcut": "REFUTED; not a manuscript counterexample"`.
The full stdout and command are retained in
`../symbolic-frobenius/exact-replay.json`; `replay.json` here records the
universal matrix identity, determinant reduction, nonintegral entry and
standard-lattice control.

The focused recorded calculations were produced by:

```sh
PYTHONDONTWRITEBYTECODE=1 $WORKSPACE/miniconda3/bin/python -B research/draft_reviews/symbolic-frobenius/replay.py check
```

Result: **PASS**, including the exact polynomial determinant reduction modulo
2, projector conjugation and commutation. Runtime was **Python 3.13.5**
(Anaconda build, GCC 11.2.0), **SymPy 1.14.0**. This replay used an already
installed runtime after the `argus-latest` venv lacked SymPy; no packages were
installed. Bytecode writing was disabled.

Checker SHA-256:
`28d352ec78c988c0fe315bc809b531e1f10e66fc4ae22c1f496150bb60b9ba28`.
Historical certificate SHA-256:
`1bffa67f2097d014cdb2fec54f524dcf03479f21a7e6db8061d4e32a137a881f`.
Copied source bytes match; original hashes are unchanged; no old
`__pycache__` was created. The shared checker run supports two related units
and is not counted as two independent computations. The lattice argument is
not among the four Lean declarations and has no separate kernel certificate.

## Supported scope and limitations

The arithmetic and its \( \forall s\in\mathbf Z_2 \) extension are complete
for this example. The exact local obstruction is substantive even though its
role is to reject a proof shortcut. No geometric existence claim is settled,
no global paper certification follows, and no claim of novelty or native
independent acceptance is made.
