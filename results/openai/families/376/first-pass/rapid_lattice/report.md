# A sharp scale criterion for periodic overwrite memory

## Result and scope

The full-address arithmetic of the staged rapid-decay manuscript survives this
audit. In particular, its left move really requires the displayed two digit
shifts, its exceptional `beta_0=1/4` is necessary for the fixed initial point,
and its pressure sign is correct. No false manuscript assertion was found in
this scope; there is no manuscript refutation certificate.

The positive result is a universal verification together with the following
structural extension. It is not a finite-search conclusion.

**Theorem (scale-ratio criterion).** Fix a base integer \(b\ge2\), a positive
initial stack width \(d_0\), \(d_n=d_0+2n\),
\(p_n=2d_n+1=p_0+4n\), and fixed smooth pulse and selector profiles as in
lattice.tex. Replace its exponents by any integer sequence satisfying
\[
 K_0\ge p_0+10,\qquad K_{n+1}\ge2K_n.
 \tag{1}
\]
Keep \(\epsilon_n=b^{-K_n}\), \(\beta_0=1/4\), and
\(\beta_n=\epsilon_n\) for \(n\ge1\).
For the execution and halting statement, the loading code must describe a
genuine initial configuration with blank tape outside the two initial stacks;
the manuscript's choice \(d_0=|\omega|+1\) and its marked-origin
preprocessing satisfy this hypothesis.

1. For every finite deterministic machine table, totalized on the entire
   address domain exactly as in the manuscript, all residue, periodicity,
   writing-selector, and all-time halting-detection conclusions hold. They
   do not require addresses to be reachable or remote digits to be valid.
2. The resulting velocities and their residual forces have every rapid mixed
   derivative bound **for every such finite table** if and only if
   \[
     K_{n+1}/K_n\longrightarrow+\infty .
     \tag{2}
   \]
   The necessity is an explicit fixed stationary nonhalting table witnessing
   failure of a derivative bound when (2) fails. It is not a claim that every
   individual table needs (2).
3. If the sequence and a modulus for (2) are computable, the sufficiency
   gives effective constants and the same effective forced-flow
   construction. Without an effective modulus, the analytic bounds still
   exist; no uniform algorithm for their constants is asserted.

The corresponding mean-zero incompressible lift and solenoidal force have the
same event on the flat three-torus. These analytic conclusions use the smooth
calculus, ODE, and Fourier interface described below; they are not Lean
Navier--Stokes theorems.

The manuscript uses
\(K_n=(p_0+10)2^{n(n+1)}\), with ratio \(2^{2n+2}\).
The theorem also permits
\[
 K_n=(p_0+10)(n+1)!
\]
and the much slower sequence
\[
 K_0=p_0+10,\qquad
 K_{n+1}=(2+\lfloor\log_2(n+1)\rfloor)K_n.
 \tag{3}
\]
For (3), a sufficient threshold for the kth derivative estimate is
\(n\ge2^k-1\). More generally, the integer ratios may diverge arbitrarily
slowly, with their divergence modulus supplied when effectiveness is wanted.
The new content relative to the staged theorem is this schedule flexibility
and its sharp converse, not an increased finite test bound.

## What was already known, and retrieval limits

The original target is Theorem `thm:lattice` and Lemmas
`lem:lattice-address`, `lem:lattice-scales` in
`research/openai_manuscript/Computation-under-Rapidly-Vanishing-Navier-Stokes-Forcing-September-27-2026/build/lattice.tex`.
Its analytic interface is in that directory's main.tex,
`lem:realization` (lines 180-203) and `lem:projection` (lines 209-229).
Those staged propositions were read in a separate bounded source pass before
developing this theorem. They are unpublished-version references; no registry
identifier for this staged version has been invented.

The elementary clock obstruction in main.tex, lines 97-104, is genuine:
if \(q\ge0\) and \(q(t)\le C(1+t)^{-2}\), then
\[
 \tau(t)-\tau(0)=\int_0^t q(s)\,ds
 \le C\bigl(1-(1+t)^{-1}\bigr)\le C.
\]
Thus an onto nonnegative scalar slowdown cannot provide an unbounded
computation clock. This is a retired route, not a refutation of the manuscript
or an obstruction to shrinking successive records.

A separate bounded primary-source lookup obtained:

* C. Moore, *Generalized shifts: unpredictability and undecidability in
  dynamical systems*, Nonlinearity 4 (1991), 199-230,
  DOI [10.1088/0951-7715/4/2/002](https://doi.org/10.1088/0951-7715/4/2/002),
  [author's full text](https://sites.santafe.edu/~moore/nonlinearity-gs.pdf).
  Theorem 7, p. 217, realizes a Turing machine by a generalized shift;
  Theorem 13, p. 227, gives a smooth four-dimensional suspension realization.
  Neither is a scale-ratio theorem. These results are historical comparison,
  not hypotheses of the algebra proved here.
* R. Cardona, E. Miranda, D. Peralta-Salas, F. Presas,
  *Constructing Turing complete Euler flows in dimension 3*,
  DOI [10.1073/pnas.2026818118](https://doi.org/10.1073/pnas.2026818118),
  [full text](https://pmc.ncbi.nlm.nih.gov/articles/PMC8126859/).
  Proposition 5.1 concerns **bijective** generalized shifts and an
  area-preserving disk realization; Theorem 6.1 uses an adjustable metric
  on \(S^3\). Section 6.B, equation (9), has
  \(u(t)=Me^{-\nu t}X\), hence accumulated Euler time
  \(M(1-e^{-\nu t})/\nu<M/\nu\). That construction supplies only a bounded
  amount of Euler time for fixed data; it is not the fixed flat-torus
  shrinking-record construction.
* J. Dyhr, A. Gonzalez-Prieto, E. Miranda, D. Peralta-Salas,
  *Turing complete Navier--Stokes steady states via cosymplectic geometry*,
  DOI [10.1093/pnasnexus/pgag131](https://doi.org/10.1093/pnasnexus/pgag131),
  [full text](https://pmc.ncbi.nlm.nih.gov/articles/PMC13148646/).
  Theorem A assumes a Hodge-admissible compact boundaryless three-manifold
  and allows metric deformation, with the Hodge Laplacian as viscosity.
  It does not concern rapidly vanishing pulses on a fixed flat metric.

No exact criterion (2) for this architecture was located in that bounded
lookup or in a targeted search of the supplied mathematical Wiki. Absence from
these sources is not a novelty proof. Publication significance and novelty
remain for independent review; this report does not mark them verified.

## 1. Full-address transition, without a reachability restriction

Write \(B=b^d\), \(L=l+bq_L\), \(R=a+bq_R\), where
\(0\le l,a<b\). The address is first reduced by the **positive** period
\(b^{2d+1}\), using Euclidean remainder also for negative addresses. Thus
\(0\le L,R<B\), \(0\le s<b\).

Writing a digit \(w\), the three stack operations are
\[
\begin{array}{c|cc}
m&L'&R'\\ \hline
1&w+bL&q_R\\
-1&q_L&l+bw+b^2q_R\\
0&L&w+bq_R .
\end{array}
\tag{4}
\]
These are identities for every base-b digit string, including padded remote
digits. Since \(R-a=bq_R\), the manuscript's left expression
\(l+bw+b(R-a)\) is precisely the second row, not
\(l+bw+(R-a)\). A list-based replay in verify.py is independent of these
integer formulas and distinguishes that erroneous one-shift alternative.

For any \(A\), \(u<b\), \(q<A\) imply
\[
 u+bq<bA.
 \tag{5}
\]
Since \(d\ge1\), \(q_R<b^{d-1}\). Apply (5) successively to see that
every output stack in (4) is less than \(b^{d+1}\).
In particular it fits the next width \(d+2\). For any next state digit
\(s'<b\), the next packed code is below \(b^{2(d+2)+1}\).
If the current state or scanned symbol is invalid, or the state is halting,
the prescribed output is zero. This also fits the next period. The halting
flag depends on the state, so a halting state with an invalid scanned digit
still has flag one, exactly as defined in the manuscript.

All data depend only on the current residue, proving periodicity of both
functions on **all** of \(\mathbb Z\). Valid tape configurations use (4);
padding the enlarged stacks with blanks gives exactly the next configuration.
The added read-only marked origin makes absolute head position recoverable,
and the width growing by two is more than the head's possible unit travel.
This tape preprocessing is a prose argument, not a Lean encoding of a
complete machine.

Lean proves the push/pop identities, the range bounds, decoding of packed
fields, periodicity, and the instruction applied to any congruent packed
configuration. It quantifies over arbitrary optional tables on digit indices,
so no enumeration or reachable-configuration premise enters these proofs.

## 2. Arbitrary histories and torus seams

Induction from (1) gives
\[
 K_n\ge p_0+4n+10=p_n+10.
 \tag{6}
\]
For \(i<n\), monotonicity and the final doubling step give
\[
 K_n-K_i\ge K_n-K_{n-1}\ge K_{n-1}\ge p_n+6.
 \tag{7}
\]
In particular, \(b^{p_n}\) divides \(b^{K_n}\) and
\(b^{K_n-K_i}\). For every finite history length \(n\), **arbitrary integer**
records \(c_i\), and integer lift change \(m\),
\[
 c_n+\sum_{i<n}c_i b^{K_n-K_i}+m b^{K_n}
 \equiv c_n\pmod{b^{p_n}}.
 \tag{8}
\]
Lean proves (8) by divisibility of the finite sum and proves (6)-(7)
from (1), rather than taking either residue cancellation as a hypothesis.

The rescaled actual memory coordinate is the left side of (8). Translation
of a torus lift by one changes its address by \(b^{K_n}\), a multiple of the
table period. Reindexing the selector sum by this integer gives the same
field. This handles seams intrinsically; no preferred global torus chart or
endpoint-only seam test is used.

## 3. Persistence during writing and observation at every real time

Equations (1) and (6) also give
\[
 K_{n+1}-p_{n+1}\ge K_n+6,\qquad
 P_{n+1}\epsilon_{n+1}\le b^{-6}\epsilon_n
 \le\epsilon_n/64<\epsilon_n/4.
 \tag{9}
\]
Let \(j_*\) be the current decoded address, and \(s=\sigma(\tau)\in[0,1]\).
The proposed memory displacement is
\(s\epsilon_{n+1}F_n(j_*)\). It is nonnegative and smaller than
\(\epsilon_n/4\) for **every** \(s\), by the full-address range bound.
Consequently its own selector is identically one along the complete curve,
and every other selector vanishes. Differentiating this proposed curve
therefore gives the prescribed smooth vector field throughout the slot.
Finite-time smooth ODE uniqueness identifies it with the actual trajectory.
This is not an assumption that the moving particle reads its original cell.

For a nonhalting slot, the first-coordinate distance below the boundary is
\[
 \frac12-Y_1(t_n+\tau)
  =(1-s)\beta_n+s\beta_{n+1}>0.
 \tag{10}
\]
This proves exclusion at every real time, including the collars and their
boundaries. On a halting slot the endpoint is
\[
 (1/2-\beta_n)+\beta_n-\beta_{n+1}+2\beta_{n+1}
   =1/2+\beta_{n+1}\in(1/2,1).
 \tag{11}
\]
It is reached at a finite time because the fixed pulse is already one by
\(\tau=2/3\). Before the first such slot, the first coordinate lies between
\(1/4\) and \(1/2\); during it, the coordinate stays below
\(1/2+\beta_{n+1}<1\). There is no wrap that could create a false event.
If the machine never halts, (10) holds on every slot; approaching \(1/2\)
only as \(t\to\infty\) does not enter the open observation set.

The loader holds the first coordinate at \(1/4\), and the first signal slot
uses **\(\beta_0=1/4\)**, not \(\epsilon_0\). Thus (10)-(11) also cover an
initially halted input after loading. Later values use \(\epsilon_n\), which
strictly decrease by (1). Lean proves the real segment inequalities for all
\(s\in[0,1]\); the ODE identification is the analytic step just explained.

## 4. All derivative orders: the sufficient direction

At any spatial point at most one selector is nonzero. A kth spatial
derivative costs at most \(\epsilon_n^{-k}\); an rth time derivative
costs the fixed constant \(\|\sigma^{(r+1)}\|_\infty\), with no n-dependent
time rescaling. The first-coordinate constant drift disappears for \(k>0\);
the halting coefficient is bounded by \(2\epsilon_{n+1}\).
Consequently, uniformly in n and on the whole spatial torus,
\[
 \|\partial_t^r\partial_\xi^\alpha v_n\|_\infty
 \le C_{r,k}\left({\bf1}_{k=0}\beta_n+
       b^{p_{n+1}-K_{n+1}+kK_n}\right),
 \qquad k=|\alpha|.
 \tag{12}
\]
This includes invalid and unvisited addresses. No factor equal to the number
of cells or the history length has been discarded.

If \(K_{n+1}\ge(k+2)K_n\), (6) implies the universal margin
\[
 K_{n+1}-p_{n+1}-kK_n\ge K_n+6.
 \tag{13}
\]
Lean proves (13) for every k and n. Condition (2) gives this hypothesis
eventually for each fixed k. Also (6) gives
\(\epsilon_n\le2^{-n}\). Thus (12) is bounded by
\(C'_{r,k}2^{-n}\) after a finite, order-dependent prefix.
On the nth slot \(1+t\le n+3\), and
\(\sup_n(n+3)^J2^{-n}<\infty\) for every J. The finite prefix includes
the loader and the exceptional first drift.

For effective constants, use the supplied modulus for (2) to find the
prefix. All its scale powers are exact computable integers or rationals.
The remaining weighted geometric bound can be computed by finding an N
with \(2(N+4)^J\le3(N+3)^J\): thereafter the successive ratio is at most
\(3/4\), since that ratio decreases with N. No effective convergence
modulus is inferred merely from computability and existence of a limit.

For the published schedule,
\[
 K_{n+1}=2^{2n+2}K_n,\qquad 2^{2n+2}\ge2n+3.
\]
Hence \(n\ge k\) suffices for (13), recovering the original argument without
losing derivative orders. This instantiation is also proved in Lean.

## 5. Sharp necessity for validity for every finite table

Use the fixed identity instruction in nonhalting state digit 1:
write the scanned symbol unchanged, do not move, keep state 1.
State 0 may be halting. This is a valid finite table (base 2 already
suffices, including an origin-bit alphabet). The all-zero stacks at the
full-domain address \(j_n=b^{2d_n}\) select that instruction, and
\[
 F_n(j_n)=b^{2d_{n+1}}=P_{n+1}/b.
 \tag{14}
\]
These addresses need not be visited by the distinguished computation.
The theorem concerns a uniform spatial norm on the entire torus, so they
cannot be removed. One can also put a marked digit into a lower field;
the output is then at least (14), which is all the estimate needs.

For every k, the fixed nonzero compactly supported smooth bump has some
\(u_k\in(-3/8,3/8)\) with \(\psi^{(k)}(u_k)\ne0\). Otherwise it would
be a polynomial of degree less than k and, by compact support, zero
(for \(k=0\), use its plateau value). Choose a fixed pulse time
\(\tau_*\) where \(\sigma'(\tau_*)>0\), which exists because
\(\int_0^1\sigma'=1\).

Evaluate the kth y derivative of the second planar velocity at
\(y=y_*+\epsilon_n(j_n+u_k)\), modulo the torus. Disjoint supports remove
every other cell. On the coding plane the lifted second component equals
the planar component, so for a constant \(c_k>0\), independent of n,
\[
 \|\partial_y^k U_2(t_n+\tau_*)\|_\infty
 \ge c_k\,b^{p_{n+1}-1-K_{n+1}+kK_n}.
 \tag{15}
\]
If (2) fails, there is an integer M and an infinite subsequence with
\(K_{n+1}\le M K_n\). Choose \(k=M+1\). The exponent on that subsequence
is at least \(p_{n+1}-1+K_n\to\infty\). Thus this one fixed table gives
an unbounded derivative, not merely a failure to prove a rapid estimate.
This proves the necessary direction of the **every-table** criterion.

As a concrete exact subfamily, \(K_{n+1}=2K_n\) satisfies every residue
and plateau condition but (15) with k=2 has exponent \(p_{n+1}-1\).
It already fails the second-derivative bound. This is a counterexample to
that proposed slower schedule, **not** to the manuscript, whose ratios
diverge. No separate necessity classification for each individual table
is claimed.

## 6. Analytic interface, lift, residual, and pressure

The following standard smooth facts remain outside the Lean statement:
effective plateau cutoffs, finite-time smooth ODE existence and uniqueness,
periodic integration by parts and the classical energy identity, and
convergence/differentiation of absolutely summable smooth Fourier series.
The ledger records the staged `lem:realization` and `lem:projection`
interface as an explicit assumption. Their application here can also be
checked directly as follows.

Smooth nondecreasing pulses flat on fixed endpoint collars and a bump with
plateau \([-1/4,1/4]\), support \([-3/8,3/8]\) are obtained from
\(\rho(s)=e^{-1/s}\) for \(s>0\), zero otherwise, and
\(H(s)=\rho(s)/(\rho(s)+\rho(1-s))\).
Every derivative tends to zero at the flat endpoints: each is an
exponential times a finite polynomial in \(1/s\), bounded effectively.
Fixed rescalings and products give the required profiles.
The sum of slot fields is locally finite in time, with fixed zero collars,
so it is smooth at every finite time including the seams and at zero.

For a fixed smooth periodic eta with \(\eta(1/2)=0\),
\(\eta'(1/2)=1\), set
\[
 U=(\eta'v_1,\eta'v_2,-\eta\,\operatorname{div}_\xi v).
 \tag{16}
\]
Differentiation gives
\(\operatorname{div}U=\eta'\operatorname{div}v-
\eta'\operatorname{div}v=0\).
The first two components have zero mean because \(\int\eta'=0\);
the third because \(\int\operatorname{div}v=0\).
On \(z=1/2\), (16) is exactly \((v,0)\), so ODE uniqueness makes
that plane invariant. It preserves the same all-time observation.

A spatial derivative of U of order k uses at most k+1 planar derivatives
of v; time orders are unchanged. For
\[
 g=\partial_tU+(U\cdot\nabla)U-\nu\Delta U
 \tag{17}
\]
a derivative of spatial order k uses at most k+3 planar derivatives and
at most one extra time derivative. For the quadratic term, each factor
uses no more than k+2 planar derivatives; Leibniz's finite sum preserves
rapid bounds by bounding one factor with weight J and the other with
weight zero. No square-root or cancellation assumption is involved.
The zero initial collar gives \(U(0)=0\).
Equation (17) is the forced Navier--Stokes identity with pressure zero.
Its mean vanishes: the time derivative and Laplacian integrate to zero,
and the convection term equals \(\operatorname{div}(U\otimes U)\).

For classical uniqueness on any finite interval, let w be a competitor
velocity minus U. Periodic integration by parts gives
\[
 \tfrac12\frac d{dt}\|w\|_2^2+\nu\|\nabla w\|_2^2
 =-\int(w\cdot\nabla U)\cdot w
 \le\|\nabla U\|_\infty\|w\|_2^2.
\]
The constructed gradient is bounded on that interval. Multiplying the
inequality by \(\exp(-2\int_0^t\|\nabla U(s)\|_\infty\,ds)\) makes the
nonnegative squared norm nonincreasing from zero, hence w=0.
The remaining pressure gradient is
zero, and the zero-mean normalization fixes the pressure. Compactness
and smoothness give the finite-time unique material flow. This is
uniqueness for constructed data in the stated classical class, not a
general global existence assertion.

For a nonzero Fourier wave vector \(\ell\in\mathbb Z^3\), take
\[
 \widehat\phi(\ell)=
  -\frac{i\,\ell\cdot\widehat g(\ell)}{2\pi|\ell|^2},\qquad
 \widehat\phi(0)=0.
 \tag{18}
\]
Then \(\Delta\phi=\operatorname{div}g\) and
\[
 \widehat f(\ell)=
  \left(I-\frac{\ell\ell^T}{|\ell|^2}\right)\widehat g(\ell),
 \quad f=g-\nabla\phi,\quad p=-\phi .
 \tag{19}
\]
In particular **\(-\nabla p+f=g\)**. A competitor pressure q for f
becomes q+phi for g, preserving the normalized uniqueness class.

The multiplier for grad(phi) is order zero and bounded on each mode.
Integrating by parts k+4 times in a largest-frequency coordinate
gives a \(C^k\) sup-norm bound by finitely many \(C^{k+4}\) norms of g,
since \(\sum_{\ell\ne0}|\ell|^{-4}<\infty\) in dimension three.
Time derivatives and weights commute with this fixed spatial operator.
Its Fourier tails also have effective bounds. Thus all rapid mixed
orders and effective evaluation are preserved, with a finite derivative
loss supplied by the already arbitrary-order estimates. The zero mode
is zero separately; no division by a zero wave vector occurs.

## 7. Exact and formal evidence

Run the standalone replay with the installed SymPy environment:

```bash
$WORKSPACE/argus-live-update/.venv/bin/python research/rapid_lattice/verify.py
```

`exact_certificate.json` records finite adversarial tests as finite tests:
all addresses for the listed small bases/widths, all three displacements,
padded state/scanned/remote digits, negative lifts, seam boundary cases,
and exponent-only tests of three slower schedules and the published one.
No huge lattice is materialized. Exact integer arithmetic, modular
exponentiation, rational arithmetic, and symbolic polynomial differentiation
are used, with no numerical tolerances or random sampling.
The verifier rejects an inconsistent certificate, a changed Lean statement,
a changed fidelity reading, a superseded claim, or mismatched Jacobian data.

The universal proof is `Main.lean`, checked by **Lean 4.31.0**, not inferred
from those experiments. The official command used the installed CLI's
positional source argument (it has no `--source` option):

```bash
$WORKSPACE/argus-live-update/.venv/bin/python \
  -m argus_skill.verticals.math.lean_evidence verify \
  research/rapid_lattice/Main.lean --project-root . \
  --claim V_RAPID_LATTICE_CORE \
  --statement-fidelity research/rapid_lattice/statement_fidelity.md --timeout 100
```

The real compiler and axiom audit returned exit code zero, with
`proof_holes=[]`. The immutable compiler record is
`certificates/V_RAPID_LATTICE_CORE-75bd1c2c7438128c.json`.
`statement_fidelity.md` specifies exactly which universal statements
were encoded; it expressly excludes the smooth analytic interface and
the necessity proof from the formalization.

Before custom certificate computation, Jacobian operations were discovered
and their exact contracts inspected. The modular-polynomial contract has a
fixed numerical modulus and cannot certify a symbolic-base divisibility
theorem; that capability mismatch was not treated as mathematical evidence.
One suitable bounded operation,
`matrix.symbolic.multiply.compute`, was then run on the lift's differential
jets:
\[
 [a,a,-a]\,[v_{1,x},v_{2,y},v_{1,x}+v_{2,y}]^T=0.
\]
The exact payload, typed output, empty stderr, adapter exit status, server
0.14.0, and protocol 2025-11-25 are preserved in the adjacent
`jacobian_*.json` files and `jacobian_stderr.txt`. SymPy independently derives
the divergence identity from (16), the convection/mean identity, both
pressure/Fourier signs, and representative derivative budgets.
Jacobian has not proved the scale criterion or any smooth theorem.

**Independent review is pending.** In particular, the natural-to-formal
translation, the analytic interface and sharpness argument, and publication
significance/novelty still require the Host's Reviewer. The compiler result
does not supply those judgements. No Reviewer verdict is written here.
