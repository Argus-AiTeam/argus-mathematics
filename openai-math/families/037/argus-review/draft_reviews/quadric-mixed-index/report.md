# Quadric mixed-index: old-draft assessment and bounded replay

## Assessment, attribution, and exact statement

**Engineer assessment:** the archived quadric calculation and its all-degree
normal-form argument are supported in their stated coordinates and Taylor
order. The missing mixed index is a **failed Argus attack**, not a manuscript
counterexample. This is not an independent Reviewer acceptance, a novelty
claim, or verification of global adjoint lifting.

The source is the existing Argus draft
`9000037/research/adjoint_jet_lifting/report.md`, especially lines 552–596,
with definitions in its opening section. The old route
`R_AJL_QUADRIC_MIXED` is retired in `research/MATH_STATE.json:747–754`.
There is no separately versioned old claim for this unit:
`old_claim_versions=[]`. Source hashes and exact local input copies are bound
in `source_bindings.json`. The old workspace, snapshot, and ledgers were not
modified. The contract, prior inventory, and current coverage index were read;
this assessment covers only this unit.

Over \(\mathbb C\), put
\[
 Q=\{X_0Y=X_1^2+X_2^2+X_3^2+X_4^2\}\subset\mathbb P^5,\qquad
 L=\mathcal O_Q(1),\quad p=[1:0:0:0:0:0].
\]
On \(X_0\ne0\), use \(z_i=X_i/X_0\) and the frame \(X_0\) of \(L\).
Order Taylor exponents by **increasing total degree, then increasing
lexicographic exponent vector**, with \(z_1,z_2,z_3,z_4\) in that order.
The degree \(j\) is the original homogeneous section degree, not Taylor degree
or a scaled integration coordinate. The exact statement actually in the
source is
\[
 \Gamma=\{(j,\alpha)\in\mathbb Z\times\mathbb Z_{\ge0}^4:
 j\ge \alpha_1+\alpha_2+\alpha_3+\lceil\alpha_4/2\rceil\}.                 \tag{1}
\]

The chart written as \(x_5=-\sum_i y_i^2\) is the same example after
\(X_5=-Y,\ y_i=z_i\). It changes only the sign of the final degree-one
basis section, not any initial exponent or prefix rank. The replay checks
this sign change exactly. No nonlinear coordinate change is being assumed.

## Geometric inputs and the all-degree argument

The quadratic form is nondegenerate. Its six partial derivatives cannot all
vanish at a projective point, so \(Q\) is smooth of dimension four; it is
integral (a reducible quadric would be a product of linear forms and have
rank at most two). It is projective, and \(L\) is ample. The chart at \(p\)
is algebraically isomorphic to \(\mathbb A^4\), by solving for \(Y/X_0\).
Consequently these are actual algebraic coordinates and an algebraic frame,
not unrelated formal coordinates. As an orbifold this is a scheme:
all inertia is trivial, \(m=1\), the fiber character is vacuously faithful,
and the character congruences impose no restriction.

For every integer \(j\) the restriction sequence is
\[
 0\longrightarrow\mathcal O_{\mathbb P^5}(j-2)
 \longrightarrow\mathcal O_{\mathbb P^5}(j)
 \longrightarrow\mathcal O_Q(j)\longrightarrow0.
\]
The standard intermediate-cohomology vanishing
\(H^1(\mathbb P^5,\mathcal O(k))=0\) for every \(k\) identifies the **complete**
section ring in nonnegative degrees with
\[
 R=\mathbb C[X_0,X_1,X_2,X_3,X_4,Y]/
       (X_0Y-X_1^2-X_2^2-X_3^2-X_4^2),
 \qquad \deg X_i=\deg Y=1.
\]
It also gives no sections in negative degrees and only constants in degree
zero. This is the standard projective-space cohomology input to the prose
proof, not a result certified by the rank adapter.

View the relation as monic in \(X_4^2\) over
\(A=\mathbb C[X_0,X_1,X_2,X_3,Y]\). Polynomial division by this monic
quadratic over \(A\) is unique: \(R=A\oplus AX_4\) as an \(A\)-module.
The relation is homogeneous, so a basis of \(R_j\) is
\[
 X_0^{a_0}X_1^{a_1}X_2^{a_2}X_3^{a_3}X_4^\epsilon Y^b,\quad
 a_0+a_1+a_2+a_3+\epsilon+b=j,\quad \epsilon\in\{0,1\}.
\]
On the chart this becomes
\[
 z_1^{a_1}z_2^{a_2}z_3^{a_3}z_4^\epsilon
       (z_1^2+z_2^2+z_3^2+z_4^2)^b .
\]
All its terms have the same total Taylor degree. Its lexicographically
smallest exponent is
\((a_1,a_2,a_3,\epsilon+2b)\), with coefficient one: \(z_4^{2b}\)
is the first term of the power of the quadratic. This order is compatible
with exponent addition.

For fixed \(j\), these initial exponents are pairwise distinct:
the first three entries determine \(a_1,a_2,a_3\), the parity of the fourth
determines \(\epsilon\), then \(b\) and the degree equation determine
everything else. In a nonzero linear combination choose the smallest
initial among the basis terms with nonzero coefficients. No term whose
initial is larger can contain that smaller monomial, so its coefficient
cannot cancel. Hence a linear combination has one of the displayed basis
initials; there are no hidden later initials from elimination.

Conversely, for any nonnegative \(\alpha\), set
\[
 \epsilon=\alpha_4\bmod2,\quad b=\lfloor\alpha_4/2\rfloor,\quad
 a_i=\alpha_i\ (i\le3),\quad
 a_0=j-\alpha_1-\alpha_2-\alpha_3-\lceil\alpha_4/2\rceil .
\]
This basis element exists exactly when the last number is nonnegative.
This proves (1) **in every degree**, independently of bounded enumeration.
Eliminating \(Y\) on the chart must not reassign it degree two: \(Y\) is an
original degree-one section despite its quadratic Taylor expression.

## Cone, lattice, and hypothesis checks for this example

Write
\[
 \eta(j,\alpha)=2j-2\alpha_1-2\alpha_2-2\alpha_3-\alpha_4.
\]
Formula (1) gives
\[
 K=\{\alpha_i\ge0,\ \eta\ge0\},\qquad \Gamma=K\cap\mathbb Z^5.            \tag{2}
\]
Indeed this cone is generated by the five actual section indices for
\(X_0,X_1,X_2,X_3,Y\):
\[
 v_0=(1,0,0,0,0),\quad v_i=(1,e_i)\ (1\le i\le3),\quad
 v_4=(1,0,0,0,2).
\]
For a point of the displayed cone its coefficients are
\(j-\alpha_1-\alpha_2-\alpha_3-\alpha_4/2,\alpha_1,\alpha_2,
\alpha_3,\alpha_4/2\). Their determinant has absolute value two, so the
cone is full-dimensional. It is closed, proper, and rational polyhedral.
The actual section indices for \(X_0,X_1,\ldots,X_4\) generate the full
group \(\mathbb Z^5\): subtract the index of \(X_0\) to obtain the four
exponent basis vectors. There is no parity restriction on the lattice.

Degree slices are bounded since
\(\alpha_1+\alpha_2+\alpha_3+\alpha_4/2\le j\).
The positive degree ray is present, and the cone projects onto the whole
exponent orthant. Every finite Taylor jet through total degree \(D\) is
realized in every \(j\ge D\), by the sections
\(X_0^{j-|\alpha|}\prod X_i^{\alpha_i}\) for \(|\alpha|\le D\).
This directly checks the finite-jet hypothesis, rather than inferring it
from initial exponents alone.

Adjunction gives \(K_Q=\mathcal O_Q(-4)\), hence \(r=4\) and
\(c=(4,1,1,1,1)\). The canonical congruence is automatic modulo one.
All four coordinate facets and \(\eta\) are primitive integral forms and
have value one at \(c\); for \(\eta\), primitivity follows also from its
coefficient \(-1\). Thus \(c\in\operatorname{Int}K\).
The numerical large-stabilizer inequality is \(1\ge4/4\).
In this example (2) also proves saturation and the shifted-interior
identity directly, using integral facet values; it does not prove the
general cone theorem or global lifting.

No K-polystability, minimizing-Reeb-ray, or normalized-volume calculation
is used or independently certified here. Such inherited manuscript
hypotheses would still have to be checked if this example were promoted
to a complete manuscript-level application. The local boundary exclusion
below does not depend on them.

## Decisive mixed-index exclusion and prefix completeness

The complete degree-one basis is
\(1,z_1,z_2,z_3,z_4,\sum z_i^2\). There are exactly 15 Taylor rows
through degree two, and no higher nonzero Taylor coefficients for these
sections. Their first seven exponent rows are
\[
 0000,\ 0001,\ 0010,\ 0100,\ 1000,\ 0002,\ 0011.
\]
For a coefficient row \(r_\alpha\), an initial at \(\alpha\) exists iff
there is a section coefficient vector annihilated by all earlier rows
but not by \(r_\alpha\). Over \(\mathbb Q\), equivalently \(\mathbb C\)
for this rational matrix, this is precisely a strict prefix-rank
increase. The prefix contains **every** earlier row in the prescribed
order, not just selected monomials.

At \(\alpha=(0,0,0,2)\) the ranks are \(5\to6\), giving the initial of
the quadratic. At \(\alpha=(0,0,1,1)\) they are **\(6\to6\)**; the
additional row is zero and the preceding six rows already have zero
kernel. The mixed index
\[
 q_{\rm mix}=(1,0,0,1,1)
\]
is therefore absent. This is consistent with (1), whose minimum degree
there is two. Crucially,
\[
 q_{\rm mix}+c=(5,1,1,2,2),\qquad \eta(q_{\rm mix}+c)=0.
\]
Its shift is on the boundary of \(K\), not in its strict interior.
The conditional lifting assertion therefore says nothing about this
point. It refutes the proposed Argus attack, **not the manuscript**.

For comparison, the attained square index \(q=(1,0,0,0,2)\) satisfies
\[
 q+c=(5,1,1,1,3)
   =\tfrac12v_0+v_1+v_2+v_3+\tfrac32v_4.
\]
All coefficients are strictly positive in a full-dimensional cone of
actual section indices; equivalently all coordinate facets and \(\eta\)
are positive. This is an exact strict-interior witness, not an
asymptotic-body inference.

## Replay assessment, archived coverage, and actual toolchain

The entire 13,952-byte archived `verify.py` was read before execution.
It contains no external-command, network, or compiler invocation.
Its `main` can overwrite files beside itself with `--prepare-jacobian`
or `--write-certificate`; its `certificate` also reads the old ledger
through `lean_check`. Those entry points were **not** run. Six exact
archived inputs were copied into local `archive/` with mode 0444.
`replay.py` imports only this local copy and calls its arithmetic,
quadric, Taylor-data, and archived-Jacobian-check functions.
No old locks, certificates, or ledgers were generated.

The replay reproduces the relevant fields of `exact_certificate.json`
exactly, including dimensions **1, 6, 20, 50, 105** in degrees 0–4.
The finite enumeration visits every degree-\(j\) normal-form monomial
with \(a_4\le1\), tests its predicted initial and uniqueness, and checks
the hypersurface Hilbert dimension. Enumerating exponents through
Taylor degree \(2j\) is complete because chart substitution doubles
degree at most. However, the script assumes the normal-form basis and
tests the proposed formula: it is not an independent all-degree oracle.
Spanning, the absence of unseen cancellation, and all-degree validity
come from the proof above, not from its bounded sets or dimension counts.
The Hilbert-series rational-function identity is also exact, but equal
Hilbert series alone would not prove the asserted initial semigroup.

The other symbolic checks are formal cancellations of divisor expressions.
They do not establish canonical divisor identities geometrically,
nefness, SNC conditions, multiplier ideals, vanishing, or global lifting.
The certificate's broader `complete_solution` label is not adopted by this
unit, and its Lean field was neither replayed nor promoted to geometry.

All four archived Jacobian files are covered:

* `jacobian_payload.json`: complete original 15-by-6 rational Taylor matrix;
  equality with freshly generated coefficients was checked.
* `jacobian_output.json`: request and returned matrix match that payload;
  exact rational row reduction returned rank six, pivots 0–5, server
  0.14.0, protocol 2025-11-25.
* `jacobian_exit.json`: exit zero and `timeout=false`, checked with the
  typed result, not used as standalone mathematical evidence.
* `jacobian_stderr.txt`: zero bytes, explicitly inspected and preserved;
  no extra mathematical conclusion follows from empty diagnostics.

A fresh small adapter search and inspection are saved as
`jacobian_discovery.json` and `jacobian_contract.json`. The inspected
`matrix.rank.compute` contract accepts a nonempty rectangular `QQ` matrix
with at most 64 rows and returns exact rank/pivots bounded by 32. The
original 15-by-6 payload uses canonical 0/1 rationals and fits these bounds.
**Exactly one** fresh mathematical operation was executed, on that exact
original matrix, not a substitute lattice problem. It returned rank six,
pivots 0–5, `EXACT_RATIONAL_ROW_REDUCTION`, and the same source matrix.
Runtime reported by the server was 3 ms; adapter elapsed time was
3.228039 s. Adapter exit was zero, no timeout, no error, and empty stderr.
This full-matrix adapter rank is auxiliary evidence; the two prefix ranks
were checked locally, not falsely attributed to separate server calls.

Dedicated fresh files preserve payload, raw typed output, server identity,
protocol/transport, exit/error/timeout status, and stderr:
`jacobian_payload.json`, `jacobian_output.json`, `jacobian_server.json`,
`jacobian_protocol.json`, `jacobian_exit.json`, `jacobian_stderr.json`.
No Jacobian package was directly imported.

The requested default legacy interpreter
`$WORKSPACE/argus-latest/.venv/bin/python` failed once on the
replay with `ModuleNotFoundError: No module named 'sympy'` (exit one).
Instead of installing or modifying the shared environment, the replay
used the existing `$WORKSPACE/argus-live-update/.venv/bin/python`,
**Python 3.13.5, SymPy 1.14.0**, and passed (exit zero).
The adapter used that exact required live-update interpreter, Argus
distribution 0.1.2, Jacobian server **0.14.0**, protocol **2025-11-25**,
transport `mcp-stdio`. Metadata are in `replay.json` and
`adapter_toolchain.json`. No Lean/compiler was run and no package installed.

## Exact reproduction and remaining obligations

Successful arithmetic replay, from the current campaign root:

```sh
PYTHONDONTWRITEBYTECODE=1 $WORKSPACE/argus-live-update/.venv/bin/python research/draft_reviews/quadric-mixed-index/replay.py
```

The one already-completed adapter operation was:

```sh
$WORKSPACE/argus-live-update/.venv/bin/python -m argus_skill.tools.jacobian run --operation matrix.rank.compute --payload-file families/037/argus-review/draft_reviews/quadric-mixed-index/jacobian_payload.json --timeout 60
```

`adapter_replay.py` records this call with a 100-second outer bound and
refuses an unchanged second run when evidence exists. Discovery and
inspection commands are recorded in `verdict.json`; neither performs a
mathematical operation. No command needed a durable runner.

There is no remaining arithmetic or normal-form gap for this example
identified by this assessment. Independent review must still examine the
prose argument, coordinate/order fidelity, and evidence bindings.
Global adjoint lifting, the general lattice-strip theorem, Lean statement
fidelity, inherited volume-gap inputs, and campaign-wide acceptance belong
to other units/the native Reviewer. Finite success does not discharge
them. Novelty is **not claimed**; independent review remains required.
