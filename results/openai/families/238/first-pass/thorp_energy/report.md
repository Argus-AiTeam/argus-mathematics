# Conditional energy audit and a last-occurrence identity

**Result.** The three targeted assertions hold with their stated
conditioning and quantifiers. The proofs below are uniform in dimension,
time, and the fixed independent label list. They also give an exact
conditional energy formula for arbitrary deterministic coordinate words
and a component-wise extension of opposite-half decoupling. Exhaustive
finite replay is a separate falsification check, not the proof.

The universal finite-vector cancellation core compiles in Lean 4.31.0
with exit code 0 and no proof holes. This is not a Lean formalization of
the entire stochastic model. Independent review, novelty assessment, and
the full campaign's publishability criterion remain pending.

The target is the standalone manuscript dated September 26, 2026,
`Optimal-order-mixing-of-the-Thorp-shuffle-September-26-2026/build/main.tex`.
This audit concerns `lem:path-cylinder` (lines 257-271), `eq:h-2`
(lines 294-301), and `eq:h-3` (lines 308-324). The sources are not modified.

## Exact scope and prior knowledge

Positions are \(V=\mathbb F_2^d\), \(d\geq1\), initially labeled by
the identity permutation. Time counts physical shuffles, equivalently
single matching layers in the rotating frame. A sweep has \(d\) such
layers, not one. At layer \(r\), every edge in direction
\(i_r=1+(r\bmod d)\) has its own independent fair switch coin.

Fix any ordered distinct list, independently of all switch coins, and
\(0\leq\ell<k\leq2^d\). Expose only its first \(\ell\) labeled paths.
\(\mathcal F_r\) includes the list and these paths through \(r\).
The tagged label is the next one; \(B_r\) is the complement of the
exposed positions; \(m=2^d-\ell\geq1\);
\(w_r(x)=\mathbb P(\Pi_r(c_{\ell+1})=x\mid\mathcal F_r)
-\mathbf1_{B_r}(x)/m\).

The three assertions have different quantifiers.

* The cylinder and no-smoothing assertion holds on every feasible finite
  exposed-path event, including when \(\ell=0\) or \(m=1\).
* The energy identity holds for every fixed list and every \(t\geq d\);
  it also holds after averaging an independently sampled list.
* The opposite-half identity holds conditionally on every feasible
  \(\mathcal F_a\)-atom, for \(s\geq d-1\), \(a=s-d+1\), and either half
  in direction \(i_s\). It does not assert independence within one half.

Neither random-list concentration nor mixing uniformly over deterministic
input lists is an assertion under audit. The later concentration estimate
is unconditional and requires a uniform random list; it cannot be used to
prove the conditional identities. The group-theoretic lift and all
companion papers are outside this mission's proof dependencies.

The manuscript explicitly credits averaging and transport to Morris's
chameleon method (its Section 4, Lemma 3 citation) and conditional energy
to the swap-or-not analysis. Those attributions establish that the local
flow rule is not claimed here as new. This proof will derive its finite
product-space facts directly and does not assume either cited theorem.
The supplied project Wiki index contains no Thorp/path-cylinder entry.
No external proposition is presently needed as an unproved assumption.

The seed campaign claim and context remain intact. The added ledger
claims distinguish the cylinder argument, martingale cancellation,
deterministic dipole spreading, the two target identities, and the
unresolved downstream averaged-marginal/full-group steps. Independent
review and the campaign's publishability/novelty gate remain open.

## 1. Product space and the no-smoothing assertion

Fix the list first. For a finite horizon \(T\), use the uniform product
space
\[
 \Omega_T=\{0,1\}^{\mathcal I_T},\qquad
 \mathcal I_T=\{(r,e):0\leq r<T,\ e\text{ is an }i_r\text{-edge}\}.
\]
The switch at \((r,e)\) is the identity when its bit is zero and
transposes the endpoints when its bit is one. Composing these actual
permutations, rather than a proposed recursion for probabilities,
defines every labeled trajectory.

For any feasible exposed-path specification \(\gamma\), let
\(J(\gamma)\subseteq\mathcal I_T\) be the time-edges containing an
exposed card immediately before that layer. The observed next position
specifies the bit at each such edge. Two exposed cards sharing an edge
specify the same bit, by feasibility. Necessity gives
\[
 \{\text{exposed paths}=\gamma\}
 \subseteq\{\omega|_{J(\gamma)}=\varepsilon(\gamma)\}.
\]
Conversely, induction on the layer shows that fixing these bits forces
the specified exposed positions: the next position uses only the coin
of the current edge. This proves equality, not just containment. Thus
the path event is exactly one coordinate cylinder, of probability
\(2^{-|J(\gamma)|}\), and all remaining coordinates retain their
independent fair product law. This proves the cylinder part of
`C238_PATH`.

Let \(\gamma_{\leq s}\) be the prefix through \(s\). Its fixed coordinates
are exactly those in \(J(\gamma)\) at times \(r<s\). All additional
constraints have times \(r\geq s\). For this fixed full specification,
they are constants on a disjoint factor of \(\Omega_T\); no statement
that a random visited set is independent has been assumed.
The tagged endpoint at \(s\) is a function of the earlier coin factor.
Consequently, for every \(x\),
\[
 \mathbb P(\Pi_s(c_{\ell+1})=x\mid\gamma)
 =\mathbb P(\Pi_s(c_{\ell+1})=x\mid\gamma_{\leq s}).
\]
This proves the exact no-smoothing assertion even though the full future
exposed paths have been observed.

On an edge with two free inputs, its current bit is unvisited and still
fair, so the two tagged masses average. On an edge with exactly one
free input, its bit is observed from the exposed card and the tagged
mass follows the complementary route. No-smoothing is what justifies
using the old masses without a Bayesian reweighting. An edge with no
free input has zero tagged mass. The uniform vector
\(\mathbf1_{B_r}/m\) undergoes exactly the same two operations.
The centered flow therefore obeys these rules, is supported on \(B_r\),
and has sum zero.

These updates do not increase squared norm: transport preserves it,
and averaging \((u,v)\) changes \(u^2+v^2\) into \((u+v)^2/2\).
Initially the centered point mass has energy \(1-1/m\). Hence
\(\|w_r\|_2^2\leq1\) on every path atom.

## 2. Conditional cancellation without assuming the energy identity

Given a feasible \(\mathcal F_r\)-atom, the next entire layer of coins is
a fresh uniform product, independent of all earlier coins. Its
one-free edges are already determined by \(B_r\). On such an edge
\(e=\{x,x+e_{i_r}\}\), with \(x\) the sole free input, put
\[
 v_{r,e}=\frac{w_r(x)}2(\delta_x-\delta_{x+e_{i_r}}).
\]
The two possible centered updates differ from \(A_{i_r}w_r\) by
\(+v_{r,e}\) and \(-v_{r,e}\). Therefore
\[
 \xi_r=\sum_{e\ {\rm one\!-\!free}}\sigma_{r,e}v_{r,e},\qquad
 w_{r+1}=A_{i_r}w_r+\xi_r.
\]
Conditionally on \(\mathcal F_r\), the signs are independent fair signs,
because they are distinct fresh switch coordinates. In particular,
\(\mathbb E(\xi_r\mid\mathcal F_r)=0\), and \(\xi_r\) is
\(\mathcal F_{r+1}\)-measurable. This proves `C238_NOISE` directly from
the product space.

For any fixed real matrices \(P,Q\), and \(r<u\), the vector
\(P\xi_r\) is \(\mathcal F_u\)-measurable, while
\(\mathbb E(Q\xi_u\mid\mathcal F_u)=0\). Summing separately over the
fresh last-layer coin coordinates proves
\[
 \mathbb E(\langle P\xi_r,Q\xi_u\rangle\mid\mathcal F_a)=0
 \quad(a\leq r<u).
\]
The same row-sum argument kills a cross term with any
\(\mathcal F_a\)-measurable vector. At a fixed time, expansion of the
square and \(\mathbb E(\sigma_e\sigma_f\mid\mathcal F_r)=0\) for
\(e\ne f\) kill all cross-edge terms, even if subsequent projected
supports overlap. No orthogonality of those projected supports is
being asserted.

All of these conditional expectations can be read as finite sums:
condition on the cylinder for \(\mathcal F_a\), take compatible earlier
coin assignments as rows, and the full next-layer coin assignments as
columns. The columns have equal positive weight. Row-centering, rather
than merely unconditional centering, is essential. The Lean declarations
`centered_inner`, `finite_centered_energy`, and
`deterministic_matrix_preserves_centering` certify precisely this
universal algebraic step.

## 3. Exact deterministic spreading

For \(S\subseteq\{1,\ldots,d\}\), let
\(D_S=\operatorname{span}_{\mathbb F_2}\{e_i:i\in S\}\), and set
\(A_S=\prod_{i\in S}A_i\). Since the bit-flips commute and square to the
identity, the averages commute and are idempotent. Explicitly,
\[
 (A_S f)(y)=2^{-|S|}\sum_{z\in D_S}f(y+z).
\]
This formula follows by expanding the product of \((I+\tau_i)/2\);
distinct subsets of the independent basis vectors give distinct shifts.

If \(i\in S\), \(A_S(\delta_x-\delta_{x+e_i})=0\).
If \(i\notin S\), the two cosets \(x+D_S\) and \(x+e_i+D_S\) are
disjoint and each has \(2^{|S|}\) points. Hence, for any real \(u\),
\[
 \left\|A_S\frac u2(\delta_x-\delta_{x+e_i})\right\|_2^2
 =2\cdot2^{|S|}\left(\frac{u}{2^{|S|+1}}\right)^2
 =2^{-|S|-1}u^2.                                      \tag{1}
\]
The formal declaration `spread_dipole_energy` proves the final
cardinality/norm computation for every \(|S|\geq0\). The disjoint-coset
identification just given is a separate combinatorial argument.
When \(S\) is the full coordinate set, \(A_S f\) is its spatial mean;
in particular it kills every zero-sum vector. This proves
`C238_SPREAD`.

## 4. A general last-occurrence energy theorem

**Theorem.** Allow any deterministic coordinate word on an interval
\([a,t)\); coordinates may repeat or be omitted. Define
\[
 S=\{i_r:a\leq r<t\},\qquad S_r=\{i_u:r<u<t\}.
\]
On each feasible \(\mathcal F_a\)-atom,
\[
 \boxed{\quad
 \mathbb E(\|w_t\|_2^2\mid\mathcal F_a)
 =\|A_Sw_a\|_2^2+
   \sum_{\substack{a\leq r<t\\ i_r\notin S_r}}
       2^{-|S_r|-1}\mathbb E(L_r\mid\mathcal F_a).
 \quad}                                               \tag{2}
\]
Here \(L_r\) uses the active direction of this word. In particular,
only its last occurrence of each coordinate can leave surviving noise.

**Proof.** Iterate the already derived update to obtain the exact
vector identity
\[
 w_t=A_Sw_a+\sum_{r=a}^{t-1}A_{S_r}\xi_r.
\]
Repetitions in a product of averages disappear by idempotence.
Section 2 kills all cross-time terms and all terms with the initial
vector, conditionally on \(\mathcal F_a\). Within time \(r\),
condition first on \(\mathcal F_r\); the independent signs kill the
cross-edge terms. Formula (1) gives a zero contribution when
\(i_r\in S_r\), and otherwise contributes
\(2^{-|S_r|-1}w_r(x)^2\) for each one-free edge. Each such edge has a
unique free endpoint, so these squares sum exactly to \(L_r\).
Summation followed by conditioning back on \(\mathcal F_a\) proves
(2). No energy identity was used in its derivation. This proves
`C238_GENERAL_ENERGY`.

For the cyclic schedule and \(t\geq d\), take \(a=t-d\).
Then \(S\) is the full set and the initial term vanishes. At
\(r=t-j\), the following coordinates are distinct, avoid \(i_r\),
and number \(j-1\). Thus (2) gives the stronger conditional identity
\[
 \mathbb E(\|w_t\|_2^2\mid\mathcal F_{t-d})
 =\sum_{j=1}^d2^{-j}\mathbb E(L_{t-j}\mid\mathcal F_{t-d}). \tag{3}
\]
Taking expectations gives exactly manuscript `eq:h-2`, proving
`C238_ENERGY`. Equation (2), unlike that displayed manuscript identity,
also identifies the residual initial energy for incomplete words and
the correct weights for noncyclic repeated words.

## 5. Component factorization and opposite halves

Condition on any feasible \(\mathcal F_a\)-atom and any deterministic
word on \([a,s)\), and let \(S\) be its set of coordinates. Every switch
stays in a coset \(D\) of \(D_S\). Section 1 gives a closed local update
for the pair \((B_r,w_r)\): its next restriction to \(D\) uses only
the current restriction to \(D\) and the switch coins inside \(D\).
There is no rescaling by a random within-component mass; \(m\) is fixed.

Conditional on \(\mathcal F_a\), the initial restrictions are fixed.
The future arrays in different components are disjoint independent
factors of the original coin product. Consequently the entire pairs
\[
             (B_s\cap D,\ w_s|_D)
\]
are jointly conditionally independent over **all** components \(D\).
This is stronger than just pairwise independence of two observables.
It follows from local measurability and product factorization, not from
an assumption that a flow and availability in its own component are
independent.

For completeness, write \(Q\) for the actual future permutation.
The free set is \(B_s=Q B_a\). A hypothetical particle started at any
fixed \(z\) at time \(a\) has transition matrix equal to the product of
the coordinate averages: at each layer its new coin is fair conditional
on its past. This product is \(A_S\), even if some coordinates repeat.
It is the uniform kernel on each \(D\). As \(Q\) is a permutation,
\[
 \mathbf1_{\{y\in B_s\}}=\sum_{z\in B_a}\mathbf1_{\{Qz=y\}},
 \qquad
 \mathbb P(y\in B_s\mid\mathcal F_a)=\frac{|B_a\cap D|}{|D|}
 \quad(y\in D).                                      \tag{4}
\]
Linearity of expectation is all that is needed; trajectories of these
hypothetical particles have not been assumed independent. This proves
`C238_COMPONENT`.

In the manuscript's cyclic interval \(a=s-d+1\), the future word has
exactly the coordinates other than \(i_s\). Its components are
\(H_0,H_1\), each of size \(2^{d-1}=n/2\). For \(x\in H_h\),
\(w_s(x)^2\) is a function of the future \(H_h\)-array and
\(\mathbf1_{\{x+e_{i_s}\in B_s\}}\) of the opposite array. By the
factorization just proved and (4),
\[
 \begin{split}
 &\mathbb E\left[\sum_{x\in H_h}w_s(x)^2
             \mathbf1_{\{x+e_{i_s}\in B_s\}}\mid\mathcal F_a\right]\\
 &\qquad=\frac{|B_a\cap H_{1-h}|}{2^{d-1}}\,
       \mathbb E\left[\sum_{x\in H_h}w_s(x)^2\mid\mathcal F_a\right].
 \end{split}
\]
This is exactly `eq:h-3`, proving `C238_HALF`. It also completes
`C238_CORE`.

## 6. Boundary cases and list averaging

For \(d=1\), the opposite-half interval is empty: \(a=s\).
Each half is a singleton, its availability is already
\(\mathcal F_s\)-measurable, and the identity is a deterministic equality.
The energy identity has the single term \(E_t=b_{t-1}/2\) for \(t\geq1\).

For \(\ell=0\), every edge is two-free, there is no noise, and the
initial centered point mass is annihilated after a full sweep. For
\(m=1\), the unique free position determines the tagged card exactly,
so \(w_r=L_r=0\) at every time. Empty intersections with a component
are allowed in (4), and give density zero, not a division by that
intersection size.

For \(T=0\) the cylinder is the whole coin space and no-smoothing is
tautological. For \(a=t\), equation (2) has \(A_\varnothing=I\) and an
empty noise sum. No cyclic one-sweep identity is asserted for \(t<d\);
equation (2) supplies the generally nonzero residual instead.

All arguments condition on each fixed list and require only its
independence from the switch coins. Including a randomly selected
independent list in every \(\mathcal F_r\) preserves the conditional
identities; taking its expectation preserves the unconditional energy
identity. Uniform sampling is not required for this step. It is
required in the manuscript's later concentration argument, which is
not certified here.

## 7. Exact finite falsification and formal evidence

Run from the campaign root:

```bash
python3 research/thorp_energy/verify.py
```

The verifier enumerates complete fair switch-coin arrays and composes
the actual labeled permutations. It groups these histories by exposed
path prefixes to reconstruct tagged conditional laws by integer counts.
It never uses averaging/transport, `eq:h-2`, or `eq:h-3` to construct
those laws; those formulas are checked afterwards.

There are 80 cases with 120864 equally weighted full coin atoms
**counted across cases**, not 120864 distinct arrays of a single space.
For \(d=1,2\), the specified cyclic horizons include every exposed
subset and every remaining tagged label. Ordering the exposed labels
only reindexes the same sigma-field, and unexposed list suffixes have
no effect. The \(d=3\) cases are selected tests, not exhaustive
coverage of all lists or times. Noncyclic repeated-coordinate cases
also test (2).

The exact replay checks 18555 path cylinders, 474688 no-smoothing
coordinate equalities, 2792 conditionally centered updates with the full
joint fair-sign law, 22181 conditional energy atoms, 22181 conditional
component-law atoms, and 2606 opposite-half identities. Component tests
compare full joint laws with the product of **all** component marginals,
not just pairwise covariances.

For an explicit nontrivial conditional atom, take \(d=2\), tagged
label 0, exposed label 1, and its prefix \(1\to1\) through \(a=1\).
At \(s=2\), the next direction is the low bit, and choose its zero
half. The opposite initial free density is \(1/2\), the conditional
half energy is \(1/18\), and the conditional mixed energy is \(1/36\).
These exact values are stored in `exact_certificate.json`.

Before this custom computation, the authorized Jacobian adapter
discovered and inspected
`probability.process.doob_martingale.compute`. Its bounded 16-atom
diagnostic independently computes conditional expectations of the
terminal event that the tagged card is at 0, under the observed exposed
paths. All 48 returned rational entries agree with independent
enumeration. The exact payload, typed output, discovery, inspection,
server version 0.14.0, protocol 2025-11-25, and completed adapter status
are retained under `jacobian/`. This operation is suitable for the finite
diagnostic, not for proving arbitrary-dimensional martingale identities.
Search hits about graph independent sets are unrelated and were not used.

The formal core was checked using:

```bash
$WORKSPACE/argus-live-update/.venv/bin/python \
  -m argus_skill.verticals.math.lean_evidence verify \
  research/thorp_energy/Main.lean \
  --statement-fidelity research/thorp_energy/statement_fidelity.md \
  --claim C238_FINITE_KERNEL --project-root . --timeout 90
```

The successful run has `exit_code=0`, `proof_holes=[]`, and
`audit_exit_code=0`; its immutable claim-bound certificate is
`certificates/C238_FINITE_KERNEL-cf9d415852637732.json`.
The original tactic error was recorded as inconclusive, corrected, and
superseded by this fresh real compiler run. It was never treated as a
mathematical refutation. The fidelity document was unchanged between runs.
`statement_fidelity.md` gives the exact formalized quantifiers and
states the remaining probabilistic/combinatorial interpretation.

## 8. What this establishes, and what it does not

Equations (2) and (4) explicitly extend the strongest relevant prior
statements in the staged standalone manuscript: unconditional cyclic
one-sweep energy becomes conditional last-occurrence energy for any
deterministic coordinate word, and opposite-half independence becomes
joint independence of all untouched-coordinate components. These are
proof-level improvements in scope, not a literature-verified novelty
claim. No false literal manuscript assertion was found in the targeted
three statements, so there is no admissible `F_<LABEL>` refutation to
record for this mission.

The full \(1600d\) mixing theorem is **not** certified by this report.
The ledger and graph leave the averaged-marginal remainder and the
group-theoretic remainder open, separately from independent review of
this core. In particular, neither a finite no-witness result nor this
formal algebraic core establishes the campaign's
`novelty_status=verified_new` or publishability gate. The campaign goal
must remain open after this bounded handoff.
