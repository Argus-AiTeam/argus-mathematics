# A finite-parameter verification of late-prefix transfer

## Scope and source reading

The target is `lem:late-prefix-transfer`, not the main hypercube Ramsey
theorem. The staged source root is
`research/openai_manuscript/The-hypercube-Ramsey-number-has-linear-order-September-23-2026/build/sections/`.
No manuscript source is changed.

The local theorem takes the following earlier manuscript assertions as
hypotheses; this audit does not prove them.

| Input | Exact source | Use |
|---|---|---|
| Width is `log(N max p)`; no growth rate for `C_n` | Section 2 | Normalizations and quantifiers |
| Discrepancy error `b = n^(-24/25)` at widths `alpha n` and `n^(x_*)`, in either order | Section 12, `cor:deep-discrepancy`, (12.1), `eq:source-9` | Degree exceptions for broad conditional laws |
| Profile cap `max pi_i<=11/M_i` and `M_i=N n^(-o(1))` | Section 14, `prop:balanced-patch-profiles`, `eq:source-16`; Section 16 opening bounds | Small initial law widths |
| Low-mode dimensions, syndrome classes, separated cells, fixed independent cell tapes | Section 16, opening bounds and `lem:late-classes-cells` | One-block geometry and response bounds |
| Averaged critical singleton marginal `q_k <= (1+O(n^-3)) pi_i` | Section 16, `lem:fresh-singleton`, including its final iid-pool calculation | Product domination and positive survival |
| At most `exp((log n)^8)` candidate labels after withholding at most `(log n)^4` external early inputs | Section 17, definition of `S_v` | Fixed response alphabets |
| Uniform nonconflicting-pair integral of `(4 int I_x I_z d pi_i)^(2d)` is at most `exp(O(log n))` | Section 17, immediately after `eq:source-24` | Final survival-weighted witness count |
| Earlier deletion comparisons on the prerequisite gate; fixed mask profiles and reference fallbacks | Section 18, definitions and `lem:late-local-transition` | Pathwise comparison before seeds are fixed |

All of these inputs are recorded as assumptions rather than established
conclusions. The proof graph leaves the main theorem and unrelated inputs
open. The local wiki index supplied no relevant prior result.

The primary-source comparison is Dwork et al.,
*Generalization in Adaptive Data Analysis and Holdout Reuse*,
arXiv:1506.02629v2, Theorems 9 and 13. Description length and approximate
max-information transfer a fixed-test error only after a quantitative
information bound. Counting the whole response transcript here gives an
allowed logarithmic range of order `n^(1.4+o(1))`; multiplying the
available stretched-exponential error by that range is not a useful
uniform estimate. This is a limitation of that route, not a
counterexample to either theorem or to the manuscript. The proof below
uses individual-block cylinders and a stopped likelihood second moment
instead. No claim that these general probabilistic tools are new is made.
The only range calculation used in this comparison is proved directly:
if every fixed output `y` has raw failure probability at most `beta`,
the event selected by the actual output is contained in the union of
those fixed-output events, of probability at most `|Y| beta`.
The uniform proof below does not invoke either external theorem;
their initially recorded dependencies are explicitly retired for
that reason, while the primary-source comparison is retained.

## 1. Finite-parameter transfer theorem

All spaces below are finite, as in the staged experiment.

Let `W` be a witness with law `mu`, let `A` be a set of allowed witnesses,
and let `Z_H`, `1 <= H <= K`, be independent raw block inputs with product
law `P0`. A deterministic protocol, independent of `W`, adaptively reads
one block per update and terminates in at most `L` updates. Its requests
are functions of previous replies and fixed data only. It has no other
access to block inputs. Pad an early termination with null updates.
For each fixed setting of the other blocks, suppose that a block has at
most `S` possible reply prefixes, including variable lengths and aborts.

For `w in A`, let `A_H(w)` be an event on block `H`, with
`c_H(w)=P0(A_H(w)) >= kappa^m`, where `0<kappa<=1` and `m>=1`.
The tilted law `P_w` is the product of the raw block laws conditioned
separately on these events. This law can strongly correlate the
coordinates *inside* a block.

For a transcript prefix `T_t`, define the raw cylinder `C_H(T_t)`,
and, on positive-probability transcripts, set

```math
r_H^t(w)=P_0(A_H(w)\mid C_H(T_t))/c_H(w),\qquad
R_t(w)=\prod_H r_H^t(w).
```

Suppose there are transcript-measurable events `E_t`, `1<=t<=L`,
such that, with integration over the **raw** product law and witnesses,

```math
\mathbb E_{\mu,P_0}[1_A1_{E_t}]\le\epsilon.                 \tag{1}
```

If `H` responds at time `t`, then outside `E_t` assume
`|r_H^t-1|<=delta`, where `0<=delta<1`.
For null updates take `E_t` empty. No conditional probability estimate
given the past is assumed. The untouched initial factors equal one,
even on witnesses with atypical denominators.

Let `D(w,T_L)` be an output-deviation event and assume only

```math
\mathbb E_{\mu,P_0}[1_A1_D]\le\beta.
```

For any `B>=1` define

```math
a_0={2\delta\over1-\delta},\quad
M={\kappa^{-m}\over1-\delta},\quad
H_*=(1+a_0^2)^L(1+LB^2M^2\epsilon).
```

**Theorem 1 (integrated-exception transfer).**
Under exactly these hypotheses,

```math
\mathbb E_\mu[1_A P_w(D)]
 \le {H_*\over B}+BML\epsilon+B\beta.                       \tag{2}
```

In particular, the theorem does not replace (1) with a stronger
pointwise conditional bound. The response bound `S` is not used in (2)
directly: it is used below to obtain (1) from raw cylinders.

### Proof: cylinders and likelihood

For a specified transcript prefix, all requests in it have already been
determined by its preceding replies. Replaying a block against those
requests defines a set of inputs `C_H(t)`. An input tuple generates
the specified prefix if and only if every block lies in its own set:

```math
1_{\{T_t=t\}}=\prod_H1_{C_H(t)}.                            \tag{3}
```

This includes adaptive block choice and stopping: both are determined
by preceding replies. Product independence before restriction gives
raw conditional independence of **whole blocks** under (3). Bayes'
formula, applied to each factor of (3), gives

```math
{P_w(T_t=t)\over P_0(T_t=t)}=\prod_Hr_H^t(w)=R_t(w).          \tag{4}
```

Consequently, for each fixed allowed witness `R_t` is a nonnegative
mean-one `P0` martingale. At a live update the previous responding
factor is positive whenever it is good; then
`Z_t=R_t/R_(t-1)=r_H^t/r_H^(t-1)` has conditional mean one.
Conditional expectations here are with respect to the raw transcript
filtration enlarged by the fixed witness.

Stop at the first `E_t` or `R_t>B`, or at the terminal time. Before a
stop, all previous factors are in `[1-delta,1+delta]`, and `R_(t-1)<=B`.
On a nonexceptional live update,

```math
|Z_t-1|\le a_0.
```

On an exceptional live update, the bound `r_H^t<=1/c_H<=kappa^(-m)`
and the previous good factor give `0<=Z_t<=M`. Since `M>=1`,
`(Z_t-1)^2<=M^2` there. Thus for live updates

```math
Z_t^2
 \le 1+2(Z_t-1)+a_0^2+M^2 1_{E_t}.                         \tag{5}
```

Use stopped multiplier one on already stopped paths. On those paths
the increment and the live-exception indicator are zero. This matters:
the stopped likelihood can exceed the barrier after an overshoot, but
its variance contribution from subsequent frozen updates is zero.

Multiplying the exact identity
`Z^2=1+2(Z-1)+(Z-1)^2` by the previous stopped likelihood squared,
then integrating, kills the linear term by the martingale property.
The exceptional term has the **pre-update** barrier bound. Equation
(1), not a conditional version of it, therefore yields

```math
V_t\le(1+a_0^2)V_{t-1}+B^2M^2\epsilon,\quad
V_t=\mathbb E_{\mu,P_0}[1_A R_{t\wedge\tau}^2],\quad V_0\le1.
```

Induction gives `V_L<=H_*`. The finite weighted integration step and
this induction are the universal statements formalized in `Main.lean`.
The formalization explicitly permits frozen paths above the barrier.

For a barrier stop, bounded stopping and (4) give tilted mass
`E[1_A R_tau 1_barrier]`. Since `R_tau>B` there, this is at most
`V_L/B<=H_*/B`. Partition exception stops by their first stopping
time. On such a live update `R_t<=BM`, so their tilted mass is at most
`BM sum_t E[1_A1_E_t]<=BML epsilon`. On paths with no stop the final
likelihood is at most `B`, and their tilted deviation mass is at most
`B beta`. Summing the three bounds proves (2).
Bounded optional stopping here can also be proved directly by summing
(4) over the disjoint transcript cylinders at the first stopping
time; it does not require an external stopping theorem.

### Raw small-cylinder bound

Fix a block `H` and all the other raw block inputs. The replies of
`H` determine the entire protocol execution. Among at most `S` reply
prefixes, the union of cylinders with raw `H`-mass less than `lambda`
has mass at most `S lambda`. Integrate the fixed other inputs, and
then sum over `H`. At any update, including an adaptively chosen
responding block,

```math
P_0\{P_0(C_H(T_t))<\lambda\}\le KS\lambda.                  \tag{6}
```

Overlapping prefix cylinders cause no difficulty for this union
bound. If only complete response sequences were counted, multiply
their number by `L+1` first. Equation (6) is integrated over raw
executions, not uniform over individual transcripts.

## 2. Deriving the survival-factor hypotheses

Here witnesses are one uniform label or two independent uniform
labels of `X_i`; write their number as `u in {1,2}`. Let the uniform
law have width `w_X`, and let `pi=pi_i` have width `w_pi`.
Suppose deep discrepancy has error `b<=1/20` for first-side width
budget `W_X` and second-side budget `W_Y`. Choose `q>0` with
`w_X+q<=W_X`.

For any fixed law `nu` of second-side width at most `W_Y`, the
uniform mass of labels whose `nu`-degree differs from `1/2` by more
than `2b` is at most `2e^(-q)`. Indeed, a larger exceptional set of
one sign, conditioned and normalized, has width at most `w_X+q`;
its density contradicts discrepancy `b`.

For a pair, first require the degree of `x` to be typical. It is at
least `2/5`. The normalized restriction of `nu` to the neighbors of
`x` costs at most `log(5/2)` width. If this also fits `W_Y`, apply
the same argument to `z`. Except on uniform pair mass

```math
\eta_D=4e^{-q},                                             \tag{7}
```

the common-hit probability is in
`[(1/2-2b)^2,(1/2+2b)^2]`, hence differs from `1/4` by at most
`3b`. The same `3b` bound and (7) cover singletons. This proves,
in particular, the raw output-deviation bound `beta<=eta_D`
at the manuscript's tolerance `10b`.

Choose `0<lambda,zeta<=1` and `v_0>=0`. Consider a block of
`j<=m` distinct critical cells. Write their
critical labels as `Y_1,...,Y_j`. Their raw marginal is at most
`D0 pi^j`, with `D0=(1+v_0)^m` if each `q_k<=(1+v_0)pi`.
Restricting the **whole block state** to a cylinder of mass at least
`lambda` gives a label-tuple law `Q<=D0 lambda^(-1) pi^j`.
This does not assert independence under `Q`.

Let `q_l=dQ_(<=l)/d pi^l`. These are densities on the support of
`pi^l`. The `Q`-mass of prefixes with `q_l<zeta` is at most
`zeta`: integrate `q_l` on that set. On the other prefixes the
conditional next-label density relative to `pi` is at most
`D0/(lambda zeta)`. It therefore has width at most

```math
w_\pi+\log D0+\log(1/\lambda)+\log(1/\zeta).                 \tag{8}
```

Assume (8), plus `log(5/2)`, fits `W_Y`. For each such value prefix,
(7) bounds its exceptional uniform witness mass. Fubini bounds by
`eta_D` the witness-averaged `Q`-mass of degree-bad prefixes at
each coordinate. For any `v>0`, Markov and a union over coordinates
leave witness mass at most

```math
\theta=m\eta_D/v                                           \tag{9}
```

on which some coordinate has bad-prefix `Q`-mass more than `v`.
Outside that witness set, the total bad-prefix mass at every
coordinate is at most `e=v+zeta`, including the low-density prefixes.

Let `p=2^(-u)` and `a_l=Q(A_(<=l)(w))`. Integrating the conditional
hit probability against the survival indicator gives, with `a_0=1`,

```math
|a_l-p a_{l-1}|\le3b\,a_{l-1}+e.                           \tag{10}
```

There is no division by the probability of previous survival in
(10). Bad prefixes are bounded in their absolute `Q`-mass.
For `p>=1/4` and `b<=1/20`, `p+3b<1`. Induction on (10) gives

```math
|a_j-p^j|\le p^j\rho,\qquad
\rho=(1+12b)^m-1+m(v+\zeta)4^m.                             \tag{11}
```

For completeness, the upper error is at most
`(p+3b)^j-p^j+e sum_(l<j)(p+3b)^l`.
The lower error is at most
`p^j-(p-3b)^j+e sum_(l<j)(p-3b)^l`.
The lower multiplicative error does not exceed the upper one, by
the binomial expansion; both sums are at most `j`.
Dividing by `p^j` proves (11). The same bound with `m` covers all
smaller nonempty blocks.

Apply (11) also to the unconditioned block law, with the same
constants. The union of the denominator-exception sets of all `K`
blocks has uniform witness mass at most `K theta`. Averaging the
numerator exceptions over **raw** transcripts costs only `theta`:
for each fixed transcript, `Q` is fixed and its exceptional witness
mass is bounded by (9). The protocol is witness-independent, so
raw transcript averaging is legitimate.

If `rho<=1/5`, the numerator and denominator estimates imply

```math
|r_H^t-1|\le\delta={2\rho\over1-\rho}\le1/2.
```

Combine this with (6). The events needed for Theorem 1 satisfy (1)
with the explicit bound

```math
\epsilon=KS\lambda+(K+1)\theta.                             \tag{12}
```

Use the larger denominator-exception union even at time zero:
the initial factors remain exactly one, and that union is charged
only when an update is declared exceptional. There is no
conditioning on the good-witness event and no change of the
witness law to a transcript-dependent law.

The envelope and nonconflict cutoff have one additional use.
They give `c_k(w)>=kappa=3/20` for each critical cell, by the
degree/correlation identity in Section 18 and the `O(n^-3)`
singleton perturbation. Thus the product denominator really
satisfies `c_H>=kappa^j>=kappa^m`, including exceptional witnesses.

## 3. Bounded-response simulation: statement fidelity

This verifies the geometric and simulation part, rather than assuming
that a generic adaptive protocol models the actual reference history.

**Deletion is before seed fixing.** Form the predecessor set of the
mask and tested prefix at `b`, closed backwards under late-label
predecessors. It has at most `r` class steps. On the prerequisite
gate the specified reference deletion comparisons hold throughout
this set. Let `V0` be its even sites with the target outer word `t`.
The syndrome-parity identity in Section 18 forces either `V0={v}`,
or every member of `V0` to be an internal neighbor of the unique
role `b0=v^(k0)` with outer word `t`. A direct role outside `t`
meets `V0` through at most its unique flip back to `t`.
Delete these external tests, or the internal batch at `b0`,
from earlier label kernels. There are at most `max(1,h_i)`
deleted tests per class, so the pathwise product comparison costs
at most

```math
C_{\rm del}=\exp(1000\max(1,h_i)\sum_s e_{v,s})=O(1).
```

This is a nonnegative path-integral upper comparison, not a
claim that deletion preserves the history distribution. Keep the
side-draw factors at this point. The current tested prefix already
excludes its target batch, hence has no `V0` sketch. Later current
lists do not use masks or sketches, only late labels and their
specified direct initial data. After weakening the event to
`E_keep`, no remaining kernel or retained event reads an erased
sketch; its side factors integrate to one. Only now fix
independent seeds. This order avoids conditioning fixed seeds
using an estimate that holds only before seed fixing.

**One-block geometry.** Partition critical coordinates by ID coset,
merging the cosets of internal coordinates into one block.
Each block has at most `max(1,h_i)r` coordinates. The equation
`eq:late-coset-parity` is equality of basis-vector sums over `F_2`;
its left side is supported on the internal cosets `H_i`, which
are distinct and determine all the internal bits.

At a remaining direct even site whose own slice is `t^k`,
an external flip goes either to the erased word `t`, or to a
word differing from `t` in two positions. Only its own critical
slice is then read. At any other remaining site, a critical
external observation must have outer word `t^(kj)`, and its
only possible second critical observation is through flip `k`,
in slice `t^j`. Criticality and early status give both cosets
different from `C_v` and `C_w`. If `A_k!=A_j`, the two basis
coordinates cannot cancel in the parity equation; both must
belong to `H_i`. They are in the merged block. If the cosets
are equal, they already belong to a single block. An internal
observation stays in the own patch and slice. This covers own
priors as well as external early observations. It uses no
independence between different slices of the same cell.

For a critical coordinate `k`, a site observing it externally
through `j` has `A_j!=C_w`. The same parity equation gives
`A_j in H_i union {A_k,C_v}`. There are at most `(h_i+2)r`
possible flips `j`. For each outer word at most `h_i+3`
syndrome cosets `C_w` can work, each fixing all internal bits.
A block of size `j` affects at most
`j[1+(h_i+2)r](h_i+3)` direct even sites, with at most `r`
sketch calls per site. This is polylogarithmic. Internal axes
lie beyond all allocation prefixes, so the reasoning still
applies when such an observation crosses a patch boundary.

**Total protocol and aborts.** The sets `L_w` use only fixed
noncritical early labels and the envelope; they ignore own
priors, critical early labels, and late hits. At a queried site
they omit at most `m=max(1,h_i)r` external early inputs.
Eventually `m<=log(n)^4`. Initial validity therefore implies
`|L_w|<=exp(log(n)^8)` and every genuine sketch lies in `L_w`.

Order predecessor roles by class and a fixed role order. A block
receives preceding labels and fixed data, computes its current
sketch using the fixed seed, and returns indices in the fixed
ordered `L_w`. Return an abort if the list is too large or any
sample lies outside it. Empty lists, invalid initial data, and
zero normalizers use exactly the manuscript's fixed reference
fallbacks; abort does not add a favorable conditioning.
Unaffected operations read only fixed data and earlier replies.
Thus each request is computed without reading a second block.
On `E_keep` no abort occurs and induction gives exactly the
modified reference execution and tested prefix.

There are `K<=n` blocks and at most
`L=n (log n)^C` critical-block response steps for a fixed
constant `C`. Per block there are only polylogarithmically many
calls, with `ceil(n^(.25))` indices per call and log-range
`(log n)^8` per index. Include aborts, response positions, and
variable-length prefixes. Eventually

```math
\log S\le n^{.4}+O(\log L).
```

No bound on request lengths is used. Importantly, the possibly
much larger predecessor computation is not the number `L`.

An abort outputs the current role's mask law. Otherwise output
the tested prefix law if its mass is at least `e^(-g0 n)`,
and the mask law if not. Every mask subset has at least half the
late pool, so on **all** inputs

```math
\operatorname{width}(U)
 \le\log(2N/M_{\rm late})+g_0n<\alpha n/2.
```

The fixed seeds, fixed noncritical inputs, fixed ordered lists,
and protocol do not depend on the witness. Uniformity over mask
profiles follows from the same width bound, not from a favorable
choice of profiles.

## 4. Manuscript specialization and surviving witnesses

Set `m=ceil(C(log n)^(11/10))`, increasing a fixed constant if needed,
and use

```math
b=n^{-24/25},\quad
\lambda=\zeta=e^{-\alpha n/8},\quad
q=n^{x_*}/2,\quad v=e^{-n^{x_*}/8}.
```

The profile cap `max pi_i<=11/M_i` and `M_i=N n^(-o(1))`
give `w_pi=O(log n)` and `w_X=O(log n)`. Thus `w_X+q<n^(x_*)`,
and (8), even after the bounded pair-hit width cost, is below
`alpha n/2` eventually. Also `log D0=O(m n^-3)=o(1)`.
The number of critical coordinates is `d=n-O(log n)`.

Equations (7)-(12) now yield

```math
\rho=O(mb),\quad\delta=O(mb),\quad
\epsilon\le e^{-n^{x_*/2}},\quad
\beta\le4e^{-n^{x_*}/2},\quad M=e^{O(m)}.
```

These are eventual inequalities, not assertions about small
dimensions. Choose `B=exp(n^(x_*/4))`.
The crucial second-moment exponent is

```math
L a_0^2=O(n(\log n)^C m^2 b^2)
       =n^{-23/25}(\log n)^{O(1)}=o(1).
```

Furthermore `L B^2 M^2 epsilon=o(1)`. Hence `H_*=1+o(1)`,
and (2) gives integrated tilted deviation at most
`exp(-c n^(x_*/4))` for a fixed `c>0`.
All uses of a polylogarithm being smaller than a positive power
are uniform in fixed constants: put `t=log n` and bound
`e^(epsilon t)` below by an arbitrarily high term of its power
series. No estimate here uses a lower bound on the growth rate
of `C_n`.

It remains essential to undo survival conditioning; (2) alone
would not be the manuscript lemma. Let
`c(w)=product_k c_k(w)` and `p_tilt(w)=P_w(D)`.
The expected number of surviving deviating ordered `u`-witnesses
is exactly

```math
M_i^u\mathbb E_\mu[1_A c(w)p_{\rm tilt}(w)].
```

Define `W=E_mu[1_A(2^(u d)c(w))^2]`. Cauchy--Schwarz and
`p_tilt^2<=p_tilt` give the finite bound

```math
M_i^u2^{-ud}\sqrt{W\,\mathbb E_\mu[1_Ap_{\rm tilt}]}.         \tag{13}
```

For a singleton the cleaned degree bound
`n|D_i(x)-1/2|=O(log n)` gives `W<=exp(O(log n))`.
For pairs the precise unconditioned uniform integral after
`eq:source-24` gives the same bound. Only upper marginal
domination is needed:
`c_k<= (1+O(n^-3)) integral I_x I_z d pi_i`; it contributes
`(1+O(n^-3))^(2d)=O(1)`, and no relative lower comparison is
silently inferred from total variation.

Since `M_i<=n2^n` and `d=n-O(log n)`,
`M_i^u2^(-u d)` is polynomial. Equation (13) is therefore
`exp(-n^c1)` for, for example, any sufficiently small fixed
`c1<x_*/4`. This bounds the probability of at least one such
witness. Multiply by `C_del=O(1)` and average fixed seeds and
noncritical inputs to bound the original gated bad event.
One omitted critical cell changes `d` by one and block sizes
downwards only, so the same proof is uniform in that omission.

**Conclusion.** Subject to the explicitly unaudited upstream
inputs in the table, `lem:late-prefix-transfer` follows with
its stated uniformity and asymptotic quantifiers. The
bounded-response and stopped-likelihood argument in lines
418-658 does not need a pointwise conditional exception
estimate or independence of coordinates after conditioning.
No false literal manuscript assertion was identified in this
local verification, so there is no fabricated `F_` refutation
entry. The main Ramsey theorem, terminal conditioning, late
assignment, and endpoint/Hall estimates remain open in the
audit graph.

## 5. Exact and formal evidence: what is and is not checked

`Main.lean` formalizes the real-algebraic one-step integrated
second-moment bound and its finite iteration for arbitrary
finite weights. In particular it allows the exception
probability to be controlled only after summing all histories
and witnesses. `statement_fidelity.md` names the declarations
and maps all their hypotheses. It does **not** claim a Lean
formalization of discrepancy, the protocol geometry,
conditional probabilities, or the entire Ramsey theorem.

`verify.py` is a standalone standard-library exact replay.
It checks product cylinders and all likelihood martingale
identities in a deterministic family of adaptive protocols,
replays stops including overshoots, checks each second-moment
and tilted-event inequality with rational arithmetic, and
checks the survival-recursion bounds and the exact exponent
`1-2(24/25)=-23/25`. Its finite models are diagnostics of the
proved theorem, not manuscript counterexamples and not a
replacement for the uniform proof in Sections 1-4. They
deliberately include a raw history where the next exception
has conditional probability one, while its integrated
probability is small, and a cylinder creating dependence
between originally independent label coordinates.

`exact_certificate.json` records those exact outputs and
the finite theorem's parameter formulas. Re-running
`verify.py` checks it byte-independently as parsed JSON.
The separate Jacobian conditioning call checks the finite
survival normalization used in the replay; its typed output
is not promoted to a universal proof.

This is stronger than the previously available generic
information-transfer comparison: it derives the local
per-block survival factors, keeps their exceptional sets
integrated, proves the stopped transfer estimate, and
retains the survival weights in the final witness count.
It is a local mathematical verification, not a claim that
the general change-of-measure tools are original.
Independent certification, statement-fidelity approval,
and publication/novelty assessment remain for the
Host-invoked Reviewer.

### Mapping to the exact target passage

Line numbers refer to the staged Section 18 `.tex` file.

| Manuscript lines | Independent proof above | Ledger obligation |
|---|---|---|
| 420-454: total simulation, fallbacks, broad output | Section 3, total protocol and aborts | `V_LPT_PROTOCOL` |
| 455-471: bounded per-block replies, witness-independent protocol | Section 3, explicit `L,S` bounds | `V_LPT_PROTOCOL` |
| 472-499: conditioning whole cells on witness survival | Sections 1 and 2, positive denominators and product tilt | `V_LPT_SURVIVAL` |
| 500-525: transcript cylinders, integrated small-cylinder bound | Section 1, (3), (4), (6) | `V_LPT_CYLINDERS` |
| 526-572: survival under a restricted tuple law | Section 2, (7)-(12) | `V_LPT_SURVIVAL` |
| 573-629: stopped likelihood and integrated exceptions | Section 1, Theorem 1 and its proof | `V_LPT_STOPPED`, `V_LPT_L2_STEP` |
| 630-658: survival-weighted witness count | Section 4, (13) and upstream pair-integral hypothesis | `V_LPT_WEIGHTED` |

### Reproduction and measured result

Run from the campaign root:

```sh
python3 research/late-prefix-transfer/verify.py
```

The generated exact certificate records 250 deterministic adaptive
protocols, 2,000 stopped-transfer replays, 6,000 integrated
second-moment inequalities, 192,000 pointwise stopped inequalities,
and 612 survival-recursion endpoint checks, all with rational
arithmetic. The sensitive witness class has uniform mass
`1/1048576`; one live raw history has next-exception conditional
probability exactly one while the integrated bound remains
`1/1048576`. This is a negative control against a stronger
conditional assumption, not a manuscript counterexample.

The actual Lean 4.31.0 compiler and axiom audit both exited zero,
with `proof_holes=[]`. The current mechanical certificate is
`certificates/V_LPT_L2_STEP-ad77bac0e0a5e2c5.json`.
An earlier unsuccessful compile is retained as stale inconclusive
history, not as evidence against any mathematical statement.
