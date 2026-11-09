# Fu regularity route: exact local-finiteness obstruction

## Verdict

Fu's Theorem 2.8 regularity premise fails as stated. The failure is exact and
does not depend on the choice of Abel function: the allowed system

\[
n=1,\qquad k=u=0,\qquad
P(x,l_1,l_2,\epsilon,\delta)=x^2
\]

has a regular-parameter set \(R\) that is not closed in the full parameter
space. A triangulation by closed simplices that is locally finite over that
full space would have closed union, so the first bullet of Theorem 2.8 cannot
hold. The compatibility bullet with the cells \(D_i\) cannot repair a failure
of the first bullet.

This refutes this concrete construction route, not the campaign's unrestricted
negative claim. No o-minimal counterexample is certified.

## Archived primary source and exact objects

The source is Yayi Fu, *Towards Trans-Exponential O-minimal Expansion of the
Real Ordered Field*, arXiv:2604.03477v2, archived at

```text
/home/argustest/zimo/counterexample-batch-1/audit-shards/01/.work/remaining-audit/grade-a-foundations-1465/sources/fu-2026-v2.pdf
/home/argustest/zimo/counterexample-batch-1/audit-shards/01/.work/remaining-audit/grade-a-foundations-1465/sources/fu-2026-v2.txt
```

The relevant source statements are:

1. Fact 1.2, PDF p.3: a strictly increasing analytic
   \(\psi:\mathbb R\to\mathbb R\) satisfies
   \(\psi(e^x)=\psi(x)+1\).
2. Proposition 1.2.1(4), pp.3-5: for every fixed \(r\),
   \(|\psi(x)|\leq \log^{\circ r}(x)\) eventually.
3. Immediately after Proposition 1.2.1, p.5: "We fix the symbol \(\phi\) for
   this chosen function." Thus the analytic function actually adjoined is
   \(\phi=\psi\), the slow Abel function, not its inverse.
4. Equations (3), (4), and (6), pp.9-10, define the allowed systems, the
   parameter set \(G\), and
   \[
   R=\{(A,\eta,l,\epsilon,\delta)\in
   G\times[-1,1]^{2n+2}:P\circ A-\eta
   \text{ has nonsingular zeros only}\}.
   \]
5. Theorem 2.8, pp.13-14, requires a triangulation
   \(\{\Delta_\alpha\}\) of \(R\) such that every point of
   \(G\times[-1,1]^{2n+2}\) has a neighborhood meeting only finitely many
   \(\Delta_\alpha\), and each simplex is contained in one
   \(D_i\times[-1,1]^{2n+2}\).
6. Theorem 3.14, p.23, derives o-minimality only under that regularity
   assumption.

## The actual growth witness

The notation in Theorem 1.1 calls \(\phi\) trans-exponential, but the selected
\(\phi=\psi\) is eventually smaller than every fixed iterated logarithm. The
candidate structure nevertheless has an exact *definable* growth witness if
it is o-minimal.

Because \(\phi\) is continuous, strictly increasing, and tends to \(+\infty\),
its restriction to \([0,\infty)\) maps onto
\([\phi(0),\infty)\). Define \(T(y)\) to be its unique inverse value in
\([0,\infty)\) when \(y\geq\phi(0)\), and zero otherwise. The graph of this
piecewise function is first-order definable in
\(\mathbb R_{\mathrm{an},\exp,\phi}\), without naming an endpoint of the full
range of \(\phi\).

For each fixed \(r\in\mathbb N\), Proposition 1.2.1 gives, for all sufficiently
large \(y\),

\[
\phi(y)+r\leq \log y+r<y.
\]

Iterating the Abel equation gives

\[
\phi(\exp^{\circ r}(y))=\phi(y)+r<y=\phi(T(y)).
\]

Strict monotonicity of \(\phi\) therefore yields

\[
T(y)>\exp^{\circ r}(y)
\]

eventually. This is exactly the domination quantifier in `OBJECTIVE.md`;
the threshold may depend on \(r\). Thus growth is not the unresolved clause.
O-minimality is.

## Exact violation of Theorem 2.8

Take the allowed system above. Here \(m=3n+k+u+2=5\). Fix arbitrary
\((l,\epsilon,\delta)\in[-1,1]^4\) and consider the identity-coordinate slice

\[
p_\eta=(I_5,\eta,l,\epsilon,\delta).
\]

### 1. The slice lies in the stated parameter space

For every \(\eta\in[-1,1]\), \((I_5,\eta)\in G\).

- If \(\eta<0\), \(Z(P-\eta)=\varnothing\).
- If \(\eta=0\),
  \(Z(P-\eta)=\{0\}\times\mathbb R^4\). For every \(w\in\mathbb R^4\), choose
  a bounded neighborhood \(W\) of \(w\); the inverse image
  \(\{0\}\times W\) under the projection is bounded.
- If \(\eta>0\),
  \(Z(P-\eta)=\{-\sqrt\eta,\sqrt\eta\}\times\mathbb R^4\), and the inverse
  image of the same bounded \(W\) is the union of two bounded sets
  \(\{\pm\sqrt\eta\}\times W\).

These statements are exactly Definition 2.2 and equation (4), not a numerical
approximation.

### 2. An exact sequence of regular parameters has a singular limit

For every integer \(j\geq1\), set \(\eta_j=-1/j\). Then

\[
P(x)-\eta_j=x^2+\frac1j>0
\]

for all real \(x\), so there are no zeros. "Has nonsingular zeros only" is a
universal condition and is therefore true. Hence \(p_{\eta_j}\in R\).

At \(\eta=0\), \(P(x)-\eta=x^2\) has the zero \(x=0\), and its Jacobian is
\(2x=0\) there. Hence \(p_0\notin R\).

For completeness, when \(\eta>0\) the only zeros are
\(\pm\sqrt\eta\), and their Jacobians are
\(\pm2\sqrt\eta\neq0\). Together with the vacuous \(\eta<0\) case, this
gives the exact slice rather than merely the convergent obstruction sequence.

Since \(p_{\eta_j}\to p_0\) in
\(G\times[-1,1]^4\), the set \(R\) is not closed in the exact ambient
parameter space. On the allowed \(\eta\)-slice its regular set is precisely
\([-1,1]\setminus\{0\}\); `Main.lean` proves this identity and its
nonclosedness.

### 3. Local finiteness is impossible

In a standard triangulation, each \(\Delta_\alpha\) is the image of a closed
finite-dimensional simplex. It is compact, hence closed in the Hausdorff
ambient parameter space. A locally finite union of closed subsets is closed:
near any point only finitely many pieces occur, and the finite union is
locally closed.

Equivalently, apply the first bullet at \(p_0\). All sufficiently large
\(p_{\eta_j}\) lie in its neighborhood. If only finitely many simplices meet
that neighborhood, one closed simplex contains a convergent subsequence and
therefore contains \(p_0\), contradicting
\(\Delta_\alpha\subseteq R\).

Thus every triangulation of \(R\) has infinitely many members meeting every
ambient neighborhood of \(p_0\). This is the requested explicit quantified
violation:

\[
\forall\{\Delta_\alpha\}\text{ triangulating }R,\quad
\forall U\ni p_0,\quad
\#\{\alpha:U\cap\Delta_\alpha\neq\varnothing\}=\infty.
\]

The paper's own Claim 2.9 uses the closed-simplex interpretation when it
infers membership in a simplex from density and local finiteness. If
"\(\Delta_\alpha\)" were instead reinterpreted as open simplex interiors,
that inference is invalid at the displayed \(p_0\), so the proof of Theorem
2.8 would no longer establish its conclusion. That reinterpretation cannot
rescue Theorem 1.1.

## Rerun

The exact algebraic and topological core is checked by:

```bash
/home/argustest/zimo/argus-latest/.venv/bin/python \
  -m argus_skill.verticals.math.lean_evidence verify \
  research/routes/fu-regularity-counterexample/Main.lean \
  --statement-fidelity \
  research/routes/fu-regularity-counterexample/statement_fidelity.md \
  --claim C_1465_FU_X2_REGULAR_SLICE_OBSTRUCTION \
  --project-root /home/argustest/zimo/counterexample-batch-1/campaigns/1465
```

The bounded Jacobian operation
`implication_system.closure.compute` checks only the finite dependency chain
from the exact slice facts to failure of the theorem application. Its
discovery result, typed contract, exact payload, typed output, and run status
are stored beside this report. It is a bookkeeping check, not the proof.

## Comparison with the objective

| Objective clause | Exact result |
|---|---|
| Expansion of the actual real field | Fu uses \(\mathbb R_{\mathrm{an},\exp,\phi}\). |
| Definable unary witness | The inverse-tail extension \(T\) is definable. |
| Domination of every fixed iterate | Proved above from the Abel equation and Proposition 1.2.1. |
| O-minimality | Not obtained: the stated Theorem 2.8 premise fails for \(P=x^2\). |
| Unconditional counterexample | **No.** |
| Unrestricted negative theorem | **Still open.** |

The strongest concrete Fu construction is therefore retired for a new exact
mathematical reason. This does not revive or re-certify the preserved
exhausted-boundary report.
