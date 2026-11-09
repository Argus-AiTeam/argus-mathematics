# Finite partial-incidence rigidity, CRT height, and fixed-list packing

**Engineer assessment: supported at the stated finite scope.**
The finite counting and arithmetic declarations compile without proof holes.
The prose specialization to modular points is also supported by the
argument below. These are different evidence levels: compilation alone does
not prove polynomial existence, curve extraction, asymptotics, or the
manuscript inverse proposition.

## Source, versions, and exact claim

The read-only source is `9000021/research/inverse_certificate/REPORT.md`,
"Exact finite theorem" through "The list was fixed before the failure set",
and `Main.lean`, namespace `PartialIncidence`. The original reference
`inverse.tex` belongs to the September 25, 2026 manuscript, revision
`4eaee87548250b2682affda7d05d947c05554bae`. The old report makes the finite
inequalities explicit around a pair-counting argument already used there.
This is a verification/refinement, not an established novel theorem.

`C_INVERSE_FINITE` v1/v2 have the same natural statement; v1 has no formal
statement and v2 attaches the formal source. The old mechanical and certificate-reading evidence is bound to
v2, not v1. The repeated files and evidence bindings are not independent
results. The active claims separate the exact formal statements
(`R_FINITE_KERNEL`) from their prose modular specialization
(`R_FINITE_BRIDGE`).

Let `P` consist of `n` distinct primes at least `R>=2`. Let `Q` be a finite
universe of squarefree positive integers coprime to every prime of `P`,
with mutually consistent prescribed residue classes; `b_q` is the CRT
representative in `[1,q]`. Fix positive `t` and integer height caps `H_D,H_A`.
Before any selected points or incidences, define `A_box` to contain every
reduced rational `A/D` with

```
0 < D <= H_D, |A| <= H_A,
#{p in P : D*a_p = A (mod p)} >= t.
```

Take points `X={(q,b_q)}` with distinct `q<=S`, and an arbitrary partial
relation `I` on `P x X`. For every prime `p`, its selected incidences obey
`b_q+s*q=a_p (mod p)` for some `s` in a slope set `T_p`. Put
`K=sum |T_p|`; every point has at least `r` selected incidences.
A nonzero polynomial of degree at most `d` vanishes on `X`, with at most
`E` of its points on nonlinear complex-irreducible components. Suppose
integers `m>=2`, `e,C>=0` satisfy

```
|X| > E+d*(m-1),
H=floor(S/(m-1)) <= H_D, 2*S*H <= H_A,
R^(e+1)>H, R^(C+1)>S, r>=e+t,
K*(C*m^2+n*m) < ((r-e-t)*m)^2.                 (F)
```

Then not all selected incidences are nonstructured relative to `A_box`,
where structure means alignment of `p` and `D*q_E(A/D)<=H_D`.
Furthermore, if

```
R^(B+1)>2*H_A*H_D, t^2>=2*B*n,
```

then `|A_box|*t^2 <= 2*n^2`. The polynomial and `E` bounds are
**hypotheses** of this finite implication, not consequences of the Lean file.

## Decisive argument and arithmetic specialization

Removing the nonlinear points leaves too many points for all at most `d`
line components to contain at most `m-1`. One line therefore contains
`N>=m` points. A vertical line contains at most one because `q` determines
`b_q`; a nonreal line not proportional to a real one has at most one real
point. Two remaining lattice points give

```
d'*b_q=a'*q+b', d'>0, gcd(a',d')=1.
```

Successive positive `q` differences are multiples of `d'`. The corresponding
`b_q` differences are multiples of `a'` and have constant sign. Both
coordinates have span at most `S`; hence
`d',|a'|<=S/(N-1)<=H` and `|b'|<=2*S*H`. This also covers a horizontal
line: then `a'=0,d'=1`.

Set `g=gcd(b',d')>0`, `d'=gD`, `b'=gA`. Coprimality gives `g|q`.
For every prime `ell|q`,

```
g*(D*b_q-A)=a'*q.
```

If `ell` does not align, then it does not divide `D*b_q-A`, so it divides
`g`. Distinct prime factors are pairwise coprime and their product `q_E`
divides `g`. Thus `D*q_E<=D*g=d'<=H_D`. No step assumes that `D` or `d'`
is squarefree, or cancels a factor shared by `D` and `g`.

At most `e` isolated primes divide `d'`. At an unaligned prime outside this
exceptional set, incidence implies

```
(a'+d'*s)*q=d'*a_p-b' != 0 (mod p).
```

The coefficient is nonzero for an incident point. Each slope therefore
determines one residue class of `q`. Make cells labelled by `(p,s)`, leaving
aligned and exceptional cells empty. Count all line points passing that
test; they may include more than the originally selected incidences.
Because `q` is a unit modulo `p`, at most one slope cell per prime contains
a given point, so the cell mass `H_I` is at most `n*N`.

Two distinct points in one cell have equal `q` residues. Their nonzero
difference has absolute value at most `S` and at most `C` tested prime
divisors. Therefore

```
sum cell_population^2 <= C*N*(N-1)+H_I,
H_I^2 <= K*(C*N*(N-1)+H_I)
      <= K*(C*N^2+n*N).
```

The diagonal is **the mass**, not zero, `N`, or an assumed common incident
prime set. Richness gives `r*N <= (a+e)*N+H_I`, where `a` counts aligned
primes. For `N>=m`, dividing (F) by `m^2` and using `n/N<=n/m` yields the
strict contradiction if `a<=t`. Thus `a>t`, and the height estimates place
the reduced intercept in the pre-fixed list.

That alignment count is not by itself the final contradiction. Once the
intercept is listed, every selected incidence at an aligned prime would
be structured. If all selected incidences were nonstructured, the covering
bound would instead be `r*N<=e*N+H_I`; the same strict margin contradicts
this as well. This two-stage use is exactly what
`no_rich_nonstructured_line` encodes.

For packing, distinct reduced rationals have nonzero integer determinant
`A1*D2-A2*D1` of size at most `2*H_A*H_D`. A common aligning prime divides
that determinant. Hence two list entries have at most `B` common aligning
primes. Apply the same energy bound with primes as cells and rationals as
points. Combining degree at least `t` with `t^2>=2*B*n` gives
`M*t^2<=2*n^2`. Finiteness is supplied by the height rectangle, not assumed
from the desired packing bound. The list's definition uses the whole
prime universe, not the sample or failure set.

## Independent statement-fidelity reading

The copied [statement_fidelity.md](replay/statement_fidelity.md) accurately
describes the encoded scope:

| Formal declarations | What is actually quantified or assumed |
|---|---|
| `transpose_mass`, `energy_identity`, `energy_bound`, `partial_collision_bound` | Arbitrary finite sets and predicates; actual cardinalities and diagonal accounting are proved. |
| `partial_incidence_forces_alignment` | A covering alternative, pointwise richness, explicit mass budget, exceptional-count gap and strict margin are hypotheses; `t<|A|` is the conclusion. |
| `no_rich_nonstructured_line` | Additionally assumes the conditional ban on aligned full incidences once the list threshold is exceeded; it does not manufacture the geometric list. |
| `fixed_list_packing` | Pair overlap, degree threshold and scale inequality are hypotheses. No concrete rational height rectangle is constructed in Lean. |
| `same_slope_same_residue` | A field, the line equations, same-slope tests and unalignment; integer-to-`ZMod p` interpretation is prose. |
| `common_alignment_determinant` | Integer divisibility identity; determinant nonvanishing/height for distinct reduced rationals is prose. |
| `line_g_divides_q`, `line_nonaligned_prime_divides_g`, `squarefree_exception_product`, `squarefree_exception_height` | Explicit line equation, prime/coprime support and sign hypotheses; no squarefree-denominator hypothesis. |
| `prime_product_forces_zero` | Coprime divisibility and a strict size bound, not polynomial construction. |
| `marked_abscissa_constant`, `structural_exponent_margin` | Natural-degree arithmetic and rational linear inequalities only. |

`A` and `E` need not be disjoint or subsets of `P` in the abstract covering
theorem; this weakens the counting bound harmlessly. The arbitrary cell
system does not automatically have mass at most `|P|*|X|`; that is an
explicit hypothesis justified by modular units in the application.
Rational-line extraction, prime-divisor counts, polynomial construction,
real curve geometry and asymptotic limits remain outside the kernel.

## Fresh replays and their limits

The original `verify.py` was executed once, read-only, with Python 3.13.5
(Anaconda, GCC 11.2.0) at
`$WORKSPACE/argus-latest/.venv/bin/python`.
[fixture_replay.json](fixture_replay.json) and
[fixture_toolchain.json](fixture_toolchain.json) preserve the actual result
and Python environment. It passed 5,058 small finite-family energy cases,
including empty/singleton cases. Its main selected-line fixture has
`n=209,N=8,r=206,t=52,K=211`, collision margin
`379800<1478656`, and packing threshold `2508<=2704`.
The line is `3773*b=q+231`, reduced intercept `3/49`, `g=77`;
the shared factor `gcd(D,g)=7` is tested while each `q` stays squarefree.
The exceptional product is 77 and structured height 3773.

The reported 12,945,042 Cartesian triples are the product of constructed
bin cardinalities, **not an exhaustive test of every triple's incidence**.
The actual incidence test uses the eight selected line points. The list
bound 32 is a bound, not enumeration of all rationals in the rectangle.
The separate complete small fixture verifies the polynomial and finite
numerical hypotheses together. None is an asymptotic counterexample.

Fresh formal replay used the official Argus `lean_evidence verify` with
`--artifact-dir research/draft_reviews/finite-rigidity/replay`,
`--claim R_FINITE_KERNEL`, the exact active project root, and untouched old
source/fidelity inputs. The adapter copied canonical inputs into the owned
replay directory; the old workspace was not compiled in place or changed.
The durable runner receipt is [runner_submission.json](runner_submission.json):
task `review021-lean-replay`, run
`review021-lean-replay-1794069303258166200`, state `submitted`; its recorded
`check_with` later returned `done`, exit 0, elapsed 19.1 seconds.

[compiler_result.json](replay/compiler_result.json) records Lean 4.31.0
(`68218e876d2a38b1985b8590fff244a83c321783`), Lake
5.0.0-src+68218e8, elan 4.2.3, and prebuilt workspace
`$WORKSPACE/.local/share/argus-skill/mathlib-v4.31.0`.
Compiler and axiom-audit exits are both 0, `proof_holes=[]`, and compiler
duration is 18,695 ms. Mechanical evidence was actually recorded as
[R_FINITE_KERNEL-03dc49553ed63800.json](replay/certificates/R_FINITE_KERNEL-03dc49553ed63800.json).
There is no new lakefile. The source and fidelity text remain unchanged.
The certificate's fidelity field still correctly says `verified_by: null`;
this report is an Engineer reading, not inherited independent approval.

Jacobian discovery returned a small candidate list; the exact typed contract
of `matrix.determinant.compute` was inspected before executing that one
operation through the required live-update sidecar adapter. Dedicated
[payload](jacobian_payload.json), [typed output](jacobian_output.json),
[status](jacobian_status.json) and [stderr](jacobian_stderr.txt) preserve
the operation, exact matrix, server 0.14.0, protocol 2025-11-25, adapter
exit 0, no timeout, and no stderr. It returns exact determinant `0/1`,
method `FRACTION_FREE_BAREISS`, for the historical boundary points
`(438,19),(582,25),(1158,49)`. This verifies those supplied points'
collinearity, not the universal theorem or the existence of a line.

No mathematical defect was identified in this unit at its stated scope.
Independent review must still read the prose specialization and fidelity;
the local compiler cannot certify them or any global manuscript dependency.
