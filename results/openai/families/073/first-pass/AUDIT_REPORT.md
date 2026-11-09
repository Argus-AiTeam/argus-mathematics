# Scheduled recursion audit: scope and mathematical record

The target is the combinatorial engine of Sections 05, 08 and 09 of OpenAI,
*The Falconer distance conjecture in all dimensions*, September 23, 2026.
The campaign remains `research_target_level=publishable` and
`math_objective_mode=exploratory`. This work does not establish the analytic
reductions or the Falconer distance conjecture.

## Exact scope and prior knowledge

The staged source is the primary reference. The assertions under examination
are `test:descriptor-properties`, the scheduling part of `rec:reductions`,
`ledger:payment`, `ledger:termination`, and the combinatorial telescoping in
`ledger:bound`. The strongest relevant prior result is the manuscript's prose
argument, not an independently checked proof of this engine. Comparator proof
holes mentioned in the mission are not used as mathematical evidence.

No external distance-set theorem is needed for the combinatorial certificate.
The analytic inequalities of `rec:reductions`, including terminal and
low-frequency stopping bounds, are explicit conditional hypotheses rather than
established facts. Their source is the locally obtained and read staged
Section 08, not a purported external citation. Sections 03, 04, 06, 07 and 10
remain separate open analytic/assembly obligations.

The actual policy uses a fixed minimum in each block of `q = ceil(kappa*N)`
indices. Each nonterminal interval chooses a minimum among representatives of
whole blocks inside its inner interval. Its descriptor list is the union over
all nonterminal subintervals, with duplicates removed. An angular state's list
is that of its retained base with reached anchors removed; an origin is
specific to a membership, and need not be contained in the current interval.

The first adversarial target is the direct step with an inherited origin.
Neither a finite no-witness search nor a theorem assuming payment or
termination would settle this target. All recorded results below must retain
these quantifiers and this distinction.

## Universal conditional verification theorem

`Main.lean` formalizes the actual block-minimum policy and the complete
descriptor-scheduled combinatorial engine. Its principal theorem,
`FalconerCore.manuscript_closure`, applies to every fixed legal tie rule,
every profile with the stated Lipschitz bound, and every valid initial
state with smoothing index zero. It does not assume payment or termination.

Write `q=ceil(kappa*N)`, `s=ceil(sigma*N)` and
`f=ceil(10*sigma*N)`, with `N>0` and `0<sigma<=kappa<=1`.
For every real-valued state bound satisfying the local max-plus version
of the analytic reductions, with stopping bound `B`, non-low overhead
`epsilon>=0` and low overhead `eta>=0`, the theorem proves

```text
value(root) <= 2*A(start_root)-V(root)+20*D*q+B
                +(20/kappa)*epsilon+(1/sigma)*eta,
```

where `|A(i)-A(j)|<=D*|i-j|`. For `D=d/N`,
`epsilon=C_d*sigma+o(1)`, `eta=o(1)` and
`B=C_d*(kappa+sigma)+o(1)`, this is the Section 09 saving with
`O_d(kappa+sigma/kappa)+o(1)` loss.

The theorem derives a stopping branch from the local inequalities by a
proved well-founded relation. It does not substitute an assumed global
branch inequality for the closure argument. The exact translation,
including the harmless enlargements of the low/far transition sets and
retained-end slack, is in `statement_fidelity.md`.

### Inherited-origin payment

Let `[b,u]` be an origin for a maximal remaining descriptor with anchor
`p` and length `L`. It need not contain the current `[a,v]`. The schedule
gives `b+L<=p`, `p+L<=u`; direct mode gives `v<=a+2*L`.
If `r` minimizes `A` on `[a,p]` and the cost is positive, policy domination
forces `r<b+2*q`. Thus

```text
a <= r < b+2*q,       v <= a+2*L < u+2*q.
```

For any admissible child pair `p<=i<j<=v` with `j-i>=10*q`,
one has `i+2*q<=u`. Policy domination on the origin therefore gives
`A(i)>=A(p)`. Replacing `i` by `r` preserves separation and stays
inside the actual parent `[a,v]`; its sum decreases by at least the
cost. Zero cost follows from containment. The formal theorem is
`inherited_origin_payment`; `step_payment` connects it to actual
remaining-list membership and all six transition rows.

### A weighted-rank termination certificate

Let `r(a)` count the fixed representatives deeper than `a`. Give a
nonterminal angular state credit 2 in near mode and 1 in direct mode;
give positive and terminal states credit 0. Define

```text
tokens = 3*r(a) + credit,       resource = q*tokens + finish.
```

High and direct steps pass a representative. A near step either passes
one, or preserves its remaining list and hence enters direct mode or
terminality. A far step spends angular credit. Suffix steps lower the
end by at least `q`; low steps lower it by at least `s`.
`step_resources` proves the resulting resource drops. Consequently,
for `K` fixed representatives and any branch with `n` non-low and `m`
low transitions, `run_integer_budget` gives

```text
q*n <= q*(3*K+2)+N,       s*m <= N.
```

This supplies an explicit universal rank in place of the manuscript's
informal charging argument and the sharper intermediate non-low bound
`n<=3*K+2+N/q`. It implies the claimed `20/kappa` and `1/sigma`
budgets and leaves the next mask support level strictly below `J0`.
Actual width also decreases strictly at every move, independently
proving well-foundedness.

`run_profile_saving` proves exact telescoping of the start normalization
and paid costs. A last child shorter than `10*q` is proved to have
zero cost; the final comparison uses the last defined potential and a
nearby separated pair. There is no invented potential on a short interval.

## Exact experiment and Jacobian boundary

`verify.py` reconstructs the manuscript's block choices and unions over
all nonterminal origins using exact integer arithmetic. For 20 specified
profiles at `(q,N)=(1,128)` and `(2,256)`, it replays 29,624 suffix/high
cost-row cases, 437 direct cases, 485 inherited-origin memberships,
seven strictly positive direct costs, and six strictly positive
inherited-origin memberships. The first count includes zero costs.
No violating case was found.

These are **finite experiments**, not the universal proof. The integer
profiles test a larger class for the payment question; they are not
asserted to be realized Frostman profiles. No counterexample to the
manuscript is claimed, and no false manuscript assertion was identified
in this scoped investigation.

Jacobian discovery and typed inspection selected
`optimization.linear.rational_general_optimum.compute` on server 0.14.0,
protocol 2025-11-25. Both the bounded request and its reduced-bound
revision were rejected by the normalizer's simplex-basis admission limit.
Their exact payloads, typed structured errors and exit statuses are
preserved in `exact_certificate.json`. Neither rejection is mathematical
support or refutation; the universal result comes from Lean.

## Certification, replay and remaining obligations

The prescribed Lean 4.31.0 compiler and environment axiom audit have both
returned exit zero, with `proof_holes=[]`. Only `propext`,
`Classical.choice` and `Quot.sound` occur in the printed axiom dependencies
of the principal theorems. The immutable compiler certificate is cited
by the current C_ENGINE ledger evidence; `lean_check.json` is the current
source- and fidelity-bound compiler record.

The ledger derives **`conditional_kernel`**, not `closed_kernel`, because
`A_ANALYTIC_REDUCTIONS` remains undischarged. The assumption names the
locally read Section 08 proposition; it is deliberately not presented as
an independently verified external theorem. No external literature
theorem is needed for this finite combinatorial formalization.

Run:

```bash
$WORKSPACE/argus-live-update/.venv/bin/python verify.py
```

This replays the finite experiment and checks the current source, fidelity,
compiler axiom audit, immutable archive and claim binding. To obtain a
fresh compiler record as well, use `verify.py --lean`; it invokes the
prescribed adapter with `--claim C_ENGINE` and both campaign-local checks.
Compiler-generated canonical copies and certificate files are owned by
that adapter, not substitutes for the authored source and fidelity note.

Compared with the strongest prior result in scope, this adds a universal
kernel-checked schedule-to-closure theorem and an explicit weighted-rank
bound, rather than another bounded no-witness search or a comparator
proof-hole observation. Global novelty and publishability are not
self-certified.

**Independent Reviewer acceptance is still required.** In particular,
the Reviewer must compare the formal statements and this fidelity reading
with the staged source, replay the certificate, and assess the target
significance. The analytic preparation/reduction and Section 10 assembly
claims remain open. This engineering milestone is not completion of the
Falconer campaign.
