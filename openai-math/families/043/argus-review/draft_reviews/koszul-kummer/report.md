# Koszul identity and disconnected Kummer certificate: Engineer assessment

**Disposition:** the universal algebraic identities and the separate finite
example replay exactly. Neither is formal verification of the surrounding
geometry, a moduli-space counterexample, or an all-parameter finite experiment.

## Sources and exact assertions

The read-only source directory is
`families/043/first-pass/determinant_cover_transfer/`.
The relevant files are `verify.py`, `exact_certificate.json`, and the three
historical `jacobian_*.json` files, also embedded in the certificate. They
belong to old `C_KOSZUL_CONTRACTION` v1 and section 3 of `report.md`.
Copies embedded in JSON are not additional results.

**Universal identity, not a parameter sweep.** In a \(\mathbb Q\)-algebra
with a central invertible \(a\), and an endomorphism \(d\) commuting with
that scalar, set
\[
D=\begin{pmatrix}d&0\\a&-d\end{pmatrix},\qquad
h=\begin{pmatrix}0&a^{-1}\\0&0\end{pmatrix}.
\]
Then \(Dh+hD=I\). Indeed
\[
Dh=\begin{pmatrix}0&da^{-1}\\0&1\end{pmatrix},\qquad
hD=\begin{pmatrix}1&-a^{-1}d\\0&0\end{pmatrix}.
\]
Centrality cancels the off-diagonal entries. If \(d^2=0\), then
\(D^2=0\), so this is a contracting homotopy. The polynomial check over
\(\mathbb Q[a,a^{-1},d]\) implies the displayed operator identity by
substitution; it does not require \(d\) to be a numerical scalar.

For torus monodromy over a characteristic-zero splitting field, the Koszul
coefficients are \(a_j=\chi(M_j)-1\). A nonzero coefficient is a unit.
Separating its exterior direction gives the displayed blocks and proves
acyclicity in every dimension and for every cover exponent \(n\).
If every coefficient vanishes, the differential is zero. Fourier
decomposition identifies survivors with characters trivial on the monodromy
image. No assertion that a nonzero element of an arbitrary coefficient
ring must be invertible is being made.

**Universal weight arithmetic.** The script also checks polynomial identities
with \(R=(n^2-1)(g-1)\), \(b=n(n-1)/2\), and
\(\delta=2R+2b+2g\). Starting from actual center \(\delta+2b\), Thom removal
and duality leave \(\delta\), flag extraction leaves \(\delta-2b\), and
conversion to half weights followed by subtracting determinant center \(g\)
leaves \(R\). These are universal rational-polynomial identities, not
proofs that the corresponding geometric objects or maps exist.

## The finite example, at its own scope

Only the following example is exhaustively enumerated:
\[
n=4,\quad g=2,\quad
M=\begin{pmatrix}1&1\\1&-1\\0&2\\2&0\end{pmatrix},\qquad
G=(\mathbb Z/4)^4.
\]
The monodromy image \(H=\operatorname{im}(M\bmod4)\) has order 8.
The cover degree is 256 and its component set is \(G/H\), of size 32.
The component kernel lattice has column basis
\(\begin{pmatrix}2&0\\2&4\end{pmatrix}\), determinant 8.
Exactly 32 characters survive, including 31 nontrivial characters;
224 have exact checked contractions over \(\mathbb Q(i)\), represented
by pairs of rational numbers. The ordinary Betti numbers are
\((32,64,32)\), not the invariant-only \((1,2,1)\).
The integral pullback is not an isomorphism: the index is 8.
Rational pullback is an isomorphism on each component.

The Smith factors of \([4I_4\mid M]\) are \((1,2,4,4)\).
Their product 32 is the index of the generated sublattice and hence
the component count; \(256/32=8\) is the image order.
The existing checker multiplies the full \(UAV=D\) relation and checks
both determinants are units. It does not merely trust the reported factors.

## Actual replay and toolchain

The mandated existing script was run exactly as follows, without regeneration:

```text
PYTHONDONTWRITEBYTECODE=1 $WORKSPACE/argus-latest/.venv/bin/python -B families/043/first-pass/determinant_cover_transfer/verify.py
```

Exit status was **0**. Its preserved `replay.json` reports
`status=verified_exact_core`, `universal_homotopy=true`,
`components=32`, `characters_checked=256`,
`surviving_nontrivial_characters=31`, and
`geometry_machine_checked=false`.
`replay_status.json` records that `--write-certificate` was not used.

`toolchain.json` records the actual executable above, CPython **3.13.5**
(Anaconda build, GCC 11.2.0), Linux
`6.8.0-1068-azure-x86_64-with-glibc2.35`, bytecode writing disabled.
The checker uses the Python standard library only: exact integer,
`Fraction`, Gaussian-rational and Laurent-polynomial arithmetic.
There is no Lean invocation or claimed compiler certificate.

## Fresh bounded Jacobian replay

The adapter was discovered with the query
`certified integer Smith normal form full transformations`, and operation
`matrix.normal_form.smith.certified.compute` was inspected before use.
Its exact contract accepts one integral matrix of at most \(16\times16\),
with canonical integer strings; it returns a positive divisibility Smith
diagonal and full unimodular transformations satisfying \(D=UAV\).

One bounded operation was then executed using the required isolated bridge:

```text
PYTHONDONTWRITEBYTECODE=1 $WORKSPACE/argus-live-update/.venv/bin/python -B -m argus_skill.tools.jacobian run --operation matrix.normal_form.smith.certified.compute --payload-file research/draft_reviews/koszul-kummer/jacobian_payload.json --timeout 45
```

The dedicated JSON payload is the same \(4\times6\) matrix as the old
example. `jacobian_output.json` preserves the full exact request and typed
result, server **0.14.0**, protocol **2025-11-25**, transport `mcp-stdio`,
`EXACT_INTEGER`, `FULL_MATRIX_TRANSFORMATIONS`, and reported runtime 2 ms.
`jacobian_status.json` records actual adapter exit **0** and the 45-second
bound. The adapter returned a complete result with no structured error or
timeout; `jacobian_stderr.txt` is empty.

The fresh response was checked by **the existing source's**
`check_jacobian` function, without changing or replacing that verifier.
`jacobian_validation.json` records its successful exact transformation
check and factors \((1,2,4,4)\). This was a check of newly obtained data,
not an unchanged rerun of the original certificate. No Jacobian package
was imported into the Argus environment.

## Supported scope and limitations

The universal identity has a direct algebraic proof and an exact symbolic
replay. The example is a complete finite calculation for the displayed
matrix. Their scope is different, and neither is promoted to the other's.
The certificate's own `not_machine_checked` list correctly excludes
Mellit's strata and family identification, mixed Hodge theory, integral
relative duality and natural base change, flag geometry, novelty, independent
acceptance, and the separate full-P=W construction.

No remaining algebraic discrepancy was found at this scope. The required
geometric hypotheses remain the duties of the other units; no amount of
character enumeration establishes them. The Koszul contraction and Smith
form are standard algebraic mechanisms, not verified-new contributions.
Historical `reviewer:copilot` support is attributed as historical opinion;
current independent acceptance remains with the native Host Reviewer.
