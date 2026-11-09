# Exploratory negative report: subexponential-factor lexicographic products

## Outcome and exact boundary

No counterexample to Problem 87 is claimed. This report synthesizes the
independently reviewed exclusion, as positive-potential global-minimal
models, of one exact construction grammar: full-cover, \(K_k\)-free
red-blue colorings that are finite iterated lexicographic products and
whose largest atomic factor has order \(2^{o(k)}\).

The conclusion is:

> For every such family, every member that globally minimizes the number
> \(M\) of monochromatic \(G_k\)-copies among same-order \(K_k\)-free
> colorings eventually has \(M=0\). Its eligible hypergraph is therefore
> empty and has independence number \(n\).

Thus this grammar cannot produce a positive-potential global minimizer with
sublinear eligible independence. This is a symbolic exhaustion of the
declared grammar, not a finite-search conclusion, a counterexample, or a
proof of Problem 87.

## Exact objects and factor-sequence grammar

For every integer \(k\ge4\), set
\[
t=t_k=\lfloor\log _2\log _2 k\rfloor,\qquad
s=k-t,\qquad
G_k=K_{k-3t}\vee C_5^{\vee t}.
\tag{1}
\]
The join in (1) makes \(G_k\) contain a \(K_s\), obtained from the complete
core and one edge from each prescribed \(C_5\) factor.

For that \(k\), the host coloring has the exact form
\[
C=C_k=D_{1,k}[D_{2,k}[\cdots[D_{m(k),k}]\cdots]],
\tag{2}
\]
where \(m(k)\ge1\), every \(D_{i,k}\) is a nonempty red-blue coloring of a
finite complete graph, and the factors, their orders, and their number may
all vary with \(k\). There is no fixed catalogue assumption. Write
\[
d_i=|V(D_{i,k})|,\qquad a_{i,c}=\omega_c(D_{i,k}),
\]
and, with every empty product equal to \(1\),
\[
p_{i,c}=\prod_{\ell\le i}a_{\ell,c},\qquad
q_{i,c}=\prod_{\ell>i}a_{\ell,c}
\quad(c\in\{R,B\}).
\tag{3}
\]
The order of \(C\) is \(n=\prod_i d_i\). The family condition exhausted
here is precisely
\[
\max_{1\le i\le m(k)}\log _2d_i=o(k).
\tag{4}
\]

The coloring \(C\) is assumed to have no monochromatic \(K_k\) and to have
the **full Boolean extension cover** by its red and blue
\((k-1)\)-cliques: for every \(X\subseteq V(C)\), either \(X\) contains a
red \(K_{k-1}\), or \(V(C)\setminus X\) contains a blue \(K_{k-1}\).
Equivalently, every one-vertex red-blue extension creates a monochromatic
\(K_k\). The two extreme assignments \(X=V(C)\) and \(X=\varnothing\),
together with \(K_k\)-freeness and the lexicographic clique identity, give
\[
\omega_c(C)=\prod_i a_{i,c}=k-1
\quad(c\in\{R,B\}).
\tag{5}
\]

Let \(\mathcal C_{k,n}\) be the set of \(K_k\)-free red-blue colorings of
\(K_n\), and let \(M(C)\) count monochromatic embeddings of \(G_k\) modulo
\(\operatorname{Aut}(G_k)\). Global \(M\)-minimality means
\[
M(C)=\min_{D\in\mathcal C_{k,n}}M(D).
\tag{6}
\]
The eligible hypergraph has vertex set \(V(C)\); its hyperedges are the
clean prescribed five-cycle factors that extend to actual monochromatic
\(G_k\)-embeddings. Only the immediate implication
\[
M(C)=0\Longrightarrow
\mathcal H_C\text{ is empty and }\alpha(\mathcal H_C)=n
\tag{7}
\]
is used below. The obstruction does not use the additional positive-slack
axiom, so imposing positive slack cannot evade it.

## The balanced/no-balanced dichotomy

A cut after \(D_{i,k}\) is **balanced** when
\[
p_{i,R},p_{i,B}\ge2,\qquad
q_{i,R},q_{i,B}\ge t+2.
\tag{8}
\]
Every finite factor sequence has either a balanced cut or no balanced cut.
The two independently reviewed proofs handle these complementary cases.

### 1. A balanced cut exposes an improving edge

Associate the factors across a balanced cut as \(C=P[Q]\), and write
\(p_c=\omega_c(P)\) and \(q_c=\omega_c(Q)\). Equation (5) becomes
\[
p_Rq_R=p_Bq_B=k-1.
\tag{9}
\]
Every required edge of \(G_k\) lies in a required \(K_s\). If \(M(C)>0\),
a monochromatic \(G_k\)-copy therefore supplies a required edge \(uv\)
between two \(Q\)-fibers. Recolor only \(uv\) to the other color.

Every new opposite-color clique through \(uv\) has order at most
\[
2+(p_{\bar c}-1)q_{\bar c}
=k+1-q_{\bar c}
\le k-t-1<s.
\tag{10}
\]
Hence the flip creates neither a monochromatic \(G_k\) nor a
monochromatic \(K_k\), while it destroys at least the selected original
copy. Its exact integer change is
\[
M(C\triangle\{uv\})-M(C)=-D_{uv}\le-1.
\tag{11}
\]
Thus a balanced product with \(M>0\) is not a global minimizer. A balanced
product that is a global minimizer must have \(M=0\), and (7) gives
\(\alpha(\mathcal H_C)=n\).

This is exactly the theorem proved in
`research/varying-base-lexicographic-star-obstruction/proof.md`; no
finite diagnostic is being substituted for (9)--(11).

### 2. No balanced cut forces one dominant atomic factor

Maximum-clique Boolean coverage satisfies the exact product equivalence
\[
\mathsf{Cov}(P[Q])
\Longleftrightarrow
\mathsf{Cov}(P)\ \text{and}\ \mathsf{Cov}(Q).
\tag{12}
\]
Here \(\mathsf{Cov}(X)\) means that every subset of \(V(X)\) contains a
maximum red clique of \(X\), or its complement contains a maximum blue
clique of \(X\). Consequently every atomic factor \(D_{i,k}\) in (2) is
itself full-cover with respect to its own two maximum clique sizes.

Assume no cut is balanced. By (5), there is a first index \(j\) with
\[
p_{j,R},p_{j,B}\ge2.
\tag{13}
\]
The preceding product
\[
P=D_{1,k}[\cdots[D_{j-1,k}]\cdots]
\]
has one color clique number equal to \(1\), so it is a monochromatic
complete graph in the other color and
\[
|P|\le k-1.
\tag{14}
\]
For the residual suffix
\[
Q=D_{j+1,k}[\cdots[D_{m(k),k}]\cdots],
\]
put \(q_R=q_{j,R}\), \(q_B=q_{j,B}\), and
\(h=\min(q_R,q_B)\). Since the cut after \(D_{j,k}\) is not balanced,
\[
h\le t+1.
\tag{15}
\]
Also (5) and (13) imply \(q_R+q_B\le k-1\). The elementary Ramsey
recurrence therefore gives the strict suffix bound
\[
|Q|
<r(q_R+1,q_B+1)
\le\binom{q_R+q_B}{h}
\le\binom{k+t}{t+1}.
\tag{16}
\]
Combining (14)--(16), with
\[
B_k=\binom{k+t}{t+1},\qquad \Delta_k=(k-1)B_k,
\]
gives the dominant-factor inequality
\[
n=|P|\,d_j\,|Q|<\Delta_kd_j.
\tag{17}
\]
In particular,
\[
n\ge R(k-t)
\Longrightarrow
d_j>\frac{R(k-t)}
{(k-1)\binom{k+t}{t+1}}.
\tag{18}
\]
The factor \(D_{j,k}\) in (18) is full-cover by (12).

For \(k\ge5\), the reviewed diagonal Ramsey floor at \(s=k-t\) is
\[
R(s)>
\left\lfloor\frac{s2^{s/2}}8\right\rfloor
\ge\frac{s2^{s/2}}{16}.
\tag{19}
\]
Moreover,
\[
\log _2\Delta_k
\le\log _2(k-1)+(t+1)\log _2(k+t)
=O(\log k\log\log k)=o(k).
\tag{20}
\]
Since \(s=k-O(\log\log k)\), (18)--(20) show that its factor threshold is
bounded below by
\[
\frac{(k-t)2^{(k-t)/2}}
{16(k-1)\binom{k+t}{t+1}},
\tag{21}
\]
whose base-two logarithm is \(k/2-o(k)\).

Equations (12)--(21) are exactly the theorem proved in
`research/no-balanced-lexicographic-dominant-factor/proof.md`.

### 3. Eventual exclusion under subexponential factors

Condition (4) makes every \(d_i\) eventually smaller than the threshold
in (18), because the threshold has logarithm \(k/2-o(k)\). Therefore a
no-balanced product satisfying (4) must eventually have
\[
n<R(k-t).
\tag{22}
\]
By the definition of \(R(k-t)\), at that same order \(n\) there exists a
red-blue coloring with no monochromatic \(K_{k-t}\). It is both
\(K_k\)-free and \(G_k\)-free because \(G_k\) contains \(K_{k-t}\).
Hence
\[
\min_{D\in\mathcal C_{k,n}}M(D)=0.
\tag{23}
\]
A no-balanced product that is a global minimizer must consequently have
\(M=0\). The balanced case already gives the same conclusion by
(10)--(11). These cases exhaust every finite factor sequence, proving
the stated grammar boundary and, by (7), eligible independence exactly
\(n\).

The quantifier in this conclusion is important: arbitrary product colorings
need not have \(M=0\). The conclusion concerns product members satisfying
the stated hypotheses that also satisfy global minimality (6).

## Reviewed dependency and evidence map

The report introduces no mathematical assertion beyond claims already
recorded in schema-version-2 `research/MATH_STATE.json`. In the readable
map below, the claim names locate the Reviewer-produced `supports`
judgements in that ledger, while the Reviewer identities and UTC times
locate the corresponding public review actions in `activity.jsonl`.
Internal integrity suffixes are intentionally not used as public evidence
labels.

| Assertion used here | Semantic claim(s) in `research/MATH_STATE.json` | Proof artifact | Independent Reviewer record |
|---|---|---|---|
| Definitions of the Boolean cover, \(M\), global minimality, and genuine eligibility | `C-positive-slack-language`; `C-positive-slack-global-minimality` | `research/positive-slack-global-language/proof.md`, Sections 1--3 | `reviewer:copilot-positive-slack-global-language`; mathematical review at `2026-08-30T04:22:05Z` |
| Lexicographic clique multiplication and the two full-cover identities (5) | `C-varying-base-lexicographic-identities` | `research/varying-base-lexicographic-star-obstruction/proof.md`, Section 2 | `reviewer:copilot-varying-base-balanced-cut-round1`; mathematical review at `2026-08-30T10:13:42Z` |
| Every required edge of \(G_k\) lies in \(K_{k-t}\) | `C-varying-base-G-edge-clique` | `research/varying-base-lexicographic-star-obstruction/proof.md`, Section 3 | `reviewer:copilot-varying-base-balanced-cut-round1`; mathematical review at `2026-08-30T10:13:42Z` |
| Balanced-cut improving flip and balanced decision, (10)--(11) | `C-varying-base-balanced-flip`; `C-varying-base-balanced-decision` | `research/varying-base-lexicographic-star-obstruction/proof.md`, Sections 4--6 | `reviewer:copilot-varying-base-balanced-cut-round1`; mathematical review at `2026-08-30T10:13:42Z` |
| Full-cover descent (12) and first-prefix/suffix bounds (13)--(16) | `C-no-balanced-cover-descent`; `C-no-balanced-prefix-suffix` | `research/no-balanced-lexicographic-dominant-factor/proof.md`, Sections 2--4 | `reviewer:copilot-no-balanced-dominant-factor-round1`; mathematical review at `2026-08-30T10:38:18Z` |
| Dominant-factor threshold (17)--(21) | `C-no-balanced-dominant-factor`; dependency `C-ramsey-scale` | `research/no-balanced-lexicographic-dominant-factor/proof.md`, Section 5; the Ramsey-floor claim is recorded in `research/MATH_STATE.json` | `reviewer:copilot-no-balanced-dominant-factor-round1` at `2026-08-30T10:38:18Z`; `C-ramsey-scale` was independently supported by `reviewer:copilot-l2-exploratory-report-round1` at `2026-08-29T23:38:44Z` |
| Zero-potential implication (22)--(23) and the combined eventual exclusion | `C-positive-slack-zero-potential`; `C-no-balanced-subexponential-decision` | `research/positive-slack-global-language/proof.md`, Section 3; `research/no-balanced-lexicographic-dominant-factor/proof.md`, Section 5 | `reviewer:copilot-positive-slack-global-language` at `2026-08-30T04:22:05Z`; `reviewer:copilot-no-balanced-dominant-factor-round1` at `2026-08-30T10:38:18Z` |

The two route-closing reviews at `2026-08-30T10:13:42Z` and
`2026-08-30T10:38:18Z` replayed the exact certificates and treated the
Jacobian outputs only as bounded diagnostics.

## Reproduction

From the campaign root, the two reviewed symbolic replays are pinned by:

```bash
ROOT=/home/argustest/zimo/counterexample-batch-1/campaigns/1921
PY=/home/argustest/zimo/argus-latest/.venv/bin/python
cd "$ROOT"

"$PY" research/varying-base-lexicographic-star-obstruction/certificate.py \
  --max-k 4096 \
  | diff -u \
      research/varying-base-lexicographic-star-obstruction/symbolic_replay.json -

"$PY" research/no-balanced-lexicographic-dominant-factor/certificate.py \
  --max-k 4096 \
  | diff -u \
      research/no-balanced-lexicographic-dominant-factor/symbolic_replay.json -
```

The first replay covers the constructive edge lemma, floor transitions,
and \(22151\) qualifying divisor cases through \(k=4096\). The second
checks cover descent on all \(121\) ordered small-factor pairs, the exact
\(k=7\) no-balanced convention, \(144364\) admissible suffix-divisor pairs
through \(k=4096\), and the integer form of (19). These bounded checks guard
the implementations; the displayed symbolic proofs carry the universal
quantifiers.

The two preserved Jacobian diagnostics can be rerun, without changing
their payloads, by:

```bash
JACPY=/home/argustest/zimo/argus-live-update/.venv/bin/python

"$JACPY" -m argus_skill.tools.jacobian run \
  --operation graph.invariant.clique_number.compute \
  --payload-file \
  research/varying-base-lexicographic-star-obstruction/jacobian_payload.json

"$JACPY" -m argus_skill.tools.jacobian run \
  --operation graph.invariant.clique_number.compute \
  --payload-file \
  research/no-balanced-lexicographic-dominant-factor/jacobian_payload.json
```

Their inspected contracts, exact payloads, typed outputs, and adapter
statuses are preserved in the respective directories. Both operations used
Jacobian server `0.14.0` and protocol `2025-11-25`; they established exact
clique numbers only for the finite \(k=7\) diagnostics and are not evidence
for the all-\(k\) theorem.

The official campaign-local gates are:

```bash
ROOT=/home/argustest/zimo/counterexample-batch-1/campaigns/1921
PY=/home/argustest/zimo/argus-latest/.venv/bin/python

"$PY" -m argus_skill.verticals.math.math_state check \
  --project-root "$ROOT"
"$PY" -m argus_skill.verticals.math.proof_graph_check check \
  --project-root "$ROOT"
```

At Engineer handoff, the exact project root above was used; the
schema-version-2 math state was read without migration, and both commands
exited \(0\).

## Explicit limitations

1. This is an exclusion theorem for the exact grammar (2)--(6), not a
   counterexample and not a proof of either asymptotic branch of Problem 87.
2. The proof does not exclude an exponential-size atomic factor capable of
   meeting (18), including the \(2^{k/2-o(k)}\) dominant-factor scale.
3. Non-product colorings, and colorings not satisfying the full Boolean
   extension cover or the global-minimality condition, are outside the
   theorem.
4. The result does not determine \(R(G_k)/R(k)\) and does not turn the
   positive-slack relaxation into a theorem about every graph of chromatic
   number \(k\).
5. The finite certificate sweeps and the two Jacobian outputs are
   diagnostics only. They neither broaden the grammar nor replace the
   universal derivation.
6. `C-positive-slack-language-decision` and Problem 87 remain open. This
   complete synthesis still requires an independent project-level Reviewer
   verdict against `OBJECTIVE.md`; the earlier claim-level reviews do not
   themselves certify this report.
