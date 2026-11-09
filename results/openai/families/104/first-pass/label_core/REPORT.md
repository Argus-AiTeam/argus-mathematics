# A universal verification theorem for simultaneous labeling

## Result and precise scope

The accompanying Lean source proves the deterministic manuscript's entire
simultaneous-labeling recursion, conditional on its explicitly imported
finite-box interface. This is a universal verification theorem, not a
counterexample or an inference from small games. The principal declaration
is `LabelCore.label_good`. Independent mathematical review, statement-fidelity
approval, and assessment of publication significance remain outstanding.

The official Lean 4.31.0 verification and axiom audit returned exit code zero
with `proof_holes=[]`. The claim-bound certificate is
`certificates/C104_LABEL_CORE-03320a67c0cc17a9.json`. The ledger correctly
derives `conditional_kernel`, retaining source assumption `A104_BOX`; it
does not report an unconditional game theorem or independent approval.

**Theorem.** Let `V` be any nonempty finite set. Let
`F : Z^V -> Z^V` be coordinatewise monotone and commute with common integer
translations. Suppose the support-restricted finite-box comparison principle
holds, and a box solver supplies a vector both subsolution and supersolution
in each dyadic box. For every integer lower endpoint `A`, every `d >= 0`,
and every pair of strictly positive rational mass vectors `a,b`, the
specified two-pass procedure with `D=2^d` terminates. Its one returned vector
labels positively every coordinate claimed by any admissible Max witness,
and negatively every coordinate claimed by any admissible Min witness.

There is no bound on dimension, width, endpoints, denominators, or the number
of witnesses in this statement. The theorem is stated for any operator with
the interface, not just for the finite game operator. It does **not** assert
that monotonicity and translation invariance alone imply comparison.

## Scope and source boundary

The target is Theorem `thm:labelling` in the staged September 25, 2026
deterministic manuscript, not just the comparison principle. The input has a
nonempty finite vertex set, integer lower endpoints, dyadic positive width,
and two strictly positive rational mass vectors. A single output must satisfy
all admissible witnesses simultaneously.

The imported interface is the randomized companion's Section 2, Lemmas
`lem:box-comparison` and `lem:box-solution`. Their statements include arbitrary
integer endpoints, support-restricted inequalities, collapsed intervals,
comparison on every coordinate, and a synchronous iteration with its final
stability test counted. The deterministic manuscript explicitly imports this
interface in Section 2, `lem:accepted-box`. The staged proofs have been read;
this is a local, dated source citation, not a claimed DOI or independently
certified external formalization.

The deterministic main theorem additionally needs the wide-box game reduction
and the bit-complexity analysis. The randomized theorem has its own randomized
potential-recovery argument. The stochastic paper adapts simultaneous labeling
to discounted operators and needs additional rounding and value-separation
arguments. The parity paper imports deterministic mean-payoff solving and
positional guarantees. None of those additional conclusions follows merely
from verifying the deterministic labeling core.

The four main source assertions are indexed below. Paths are relative to
`research/openai_manuscript/`; these are dated staged sources, not invented
external publication identifiers.

| Claim | Main statement locator |
|---|---|
| `C104_DETERMINISTIC` | `Deterministic-quasipolynomial-time-mean-payoff-games-September-25-2026/build/source/sections/01-introduction.tex:25-39` |
| `C104_RANDOMIZED` | `Randomized-quasipolynomial-time-mean-payoff-games-September-25-2026/build/source/sections/01-introduction.tex:26-45` |
| `C104_STOCHASTIC` | `Turn-Based-Stochastic-Mean-Payoff-Games-in-Deterministic-Quasipolynomial-Time-October-5-2026/build/build/sections/introduction.tex:18-57` |
| `C104_PARITY` | `Mean-payoff-parity-games-in-quasipolynomial-time-October-5-2026/build/sections/01-introduction.tex:25-42` |

The stochastic introduction explicitly identifies the deterministic labeling
dependency at lines 124-130 and simultaneity at lines 155-166. The parity
introduction identifies its deterministic mean-payoff interface at lines 44-51.

## Proof

The definitions of support and claims are exactly those in deterministic
Section 2. In particular the inequalities of a subsolution or supersolution
are imposed only on its respective support. All witness quantifiers remain
simultaneous; no witness is supplied to the procedure.

### Translation and exact boundaries

In a recursive case write `D=4096h` with positive integer `h`. Then
`c=A+2048h`, `M=512h`, `P=128h`, `q=32h`, and `p=h`.
For a Max witness put `s=max_i(x_i-k_i)` and
`g_i=s-(x_i-k_i)`. A parent claim and the pivot bounds give
`s >= 1408h`. Outside the parent support, `x_i=A_i` and
`x_i-k_i <= -1536h`; hence `g_i >= 2944h > D/2`.

For either child width `r` in `{32h,2048h}`, translate and clip:
`x'_i=max(k_i-r/2,x_i-s+r/2)`.
Its support is **exactly** `g_i<r`, is contained in the original support,
and its claims include every `g_i<=r/32`. On its new support the old
subsolution inequality applies; globally `x' >= x-s+r/2`.
Monotonicity and common-shift invariance give the new subsolution inequality.
The Min proof uses `s=max_i(k_i-y_i)` and
`y'_i=min(k_i+r/2,y_i+s-r/2)` with the inequalities reversed.

The translation uses two different thresholds: support at gap strictly below
the child width, and claims at gap at most one thirty-second of that width.
The Lean definitions multiply claim inequalities by 32, so no threshold is
rounded even when `D<32`.

### Motion, stationary pivots, and safe overrides

The downward narrow child keeps Max masses unchanged. Every Max gap at most
`p` is therefore labeled positive and stays fixed. A remaining coordinate
has gap greater than `p` and moves down by at most `p`; it cannot overtake
the previous peak. A maximizing coordinate stays fixed, so the Max peak is
preserved exactly, not approximately. Initially it is at most `D/2`.
Thus a Max claim forces `k_down_i >= c_i-P`, proving negative overrides safe.

Take a Min witness with some claim outside the negative mark. At the stopped
downward pivot its peak is at least `D/2-2P`, which is strictly greater than
`D/2-M`. A lower-capped coordinate cannot attain this peak. If the total
Min mass of gaps `<q` were at most `3/4`, the narrow translation would be
admissible at the child's scaled masses `4b/3`. Its maximizer would have to
receive a negative label and move down, contradicting the unchanged update.
Consequently that mass is **strictly greater than `3/4`**. Equality also
produces the contradiction.

The upward pass similarly preserves every relevant Min peak exactly, since
Min masses are now unchanged. This makes positive overrides safe. Every
coordinate increases while the Min peak stays fixed, so each Min gap can
only decrease. Therefore the first heavy support can only grow, and its
strict mass bound survives the entire second pass. At its stopped pivot the
dual stationary argument gives Max gap-support mass greater than `3/4` for
every Max witness with a claim outside the positive mark.

These are absolute mass bounds, not fractions relative to a witness's own
support mass. Their strength is essential.

### Provisional labels and survival

The provisional child has width `r=D/2`, so
`q=D/128 < r/32=D/64`. Every coordinate in either heavy gap support is
claimed by the corresponding unchanged-mass translation. That child must
therefore label the heavy support favorably.

For a Max witness with an unsettled claim, write `S` for its original
support and `Q_+` for the provisional positive coordinates. Then

```
bar_a(S) = (8/5)*a(S) - (4/5)*a(S intersect Q_+)
         < (8/5)*1 - (4/5)*(3/4)
         = 1.
```

The original subsolution vector consequently remains a witness in the
same parent box. The analogous identity for `b` and provisional negative
labels preserves every unsettled Min witness. The continuation must meet
their original claims. Safe overrides settle the remaining claims; their
intersection contains no claim of either type, so negative precedence is
harmless.

### Actual recursion and well-founded induction

The formal function `label` implements the mass base case first, the small
width case second, then both repeated passes, the provisional call, the
same-box continuation, and the final overrides. It is not defined by
choosing a vector satisfying the desired conclusion.

Each changing pivot update strictly decreases a finite integer-distance
measure to the relevant cap. The formal loop functions `fall` and `rise`
therefore terminate, and their proved specifications include the final
stationary update. The sharper numerical pass bound is not needed for this
termination proof.

Let `mu=min_i a_i*b_i` and let `B(t)` be the least natural `j` satisfying
`t*(32/25)^j>1`. Existence is proved using the Archimedean property.
This equals the manuscript's logarithmic budget: it is zero for `t>1`;
otherwise it is `1+floor(log_(32/25)(1/t))`.
The rank is `d+B(mu)`.

The pivot children multiply every mass product by `4/3 >= 32/25`.
The continuation multiplies every product by
`(4/5)*(8/5)=32/25`, regardless of its provisional label. Each decreases
`B` by at least one. Only the provisional child preserves the masses;
it decreases `d` by one. Every recursive child has strictly smaller rank.

Finally, the mass base excludes a competing claim by support positivity.
In the small-width base, comparison sandwiches every witness around Basic's
box solution, and the strict midpoint test has the required sign. Induction
on the stated rank now supplies all child guarantees used above and proves
the simultaneous theorem for every input.

## Comparison with the prior boundary

The initial ledger had no certificate for this recursion. The operator's
reported existing comparator formalization would cover neither pivot pass,
the stationary strict inequalities, persistence, survival, nor the
same-width continuation. The present formal source covers all these
obligations and closes them by a defined well-founded recursive function.
The staged manuscript tree contains no Lean files; this is not a claim that
all other possible external formalizations have been surveyed.

## Additional exact diagnostics

`verify.py --exact-only` has replayed six fixed finite game inputs with exact
integer and rational arithmetic: positive and negative one-vertex games,
opposite-sign loops, positive and negative two-cycles, asymmetric masses,
negative endpoints, the `3/4` boundary, and `D=1`'s rational midpoint.
It checked 43 sampled admissible witnesses, including exact translated
supports, safe overrides, strict stationary mass, and reweighted survival
where applicable. These are bounded diagnostics, not the universal proof.

## Jacobian scope

Discovery used the approved Argus adapter. It offered bounded exact rational
linear programming, support evaluation, finite distributions, and recurrence
table checking, not a typed operation for universal recursive-labeling
correctness. The inspected LP operation returned an exact optimum of one for the closed
relaxation of the reweighting inequality. Its primal and dual data are replayed
in `verify.py`; the exact payload and typed output are preserved separately.
That operation cannot establish strict stationary mass, termination, or
induction. Those are proved in Lean instead. `jacobian_status.json` also
discloses that the original shell pipeline did not separately capture the
adapter process's exit code; no such measurement is invented.

## Reproduction and limitations

The installed verifier takes the source as a positional argument; it does not
accept the older `--source` spelling in the mission example. The intended
fresh compilation command is:

```
$WORKSPACE/argus-live-update/.venv/bin/python \
  -m argus_skill.verticals.math.lean_evidence verify \
  research/label_core/Main.lean --project-root . --claim C104_LABEL_CORE \
  --statement-fidelity research/label_core/STATEMENT_FIDELITY.md
```

The tool creates its canonical, byte-identical `statement_fidelity.md` and
archives claim-bound evidence in this source directory's `certificates/`.
`verify.py` requires the canonical and requested fidelity texts to agree and
checks the recorded formal evidence as well as replaying the exact diagnostics.

No staged assertion has been established false, so no `F_` refutation claim
has been manufactured. The finite-box interface remains an explicit
source-backed assumption rather than a falsely reported unconditional proof
of the entire game theorem. The four manuscript main results and their
remaining dependencies stay open in the proof graph. In particular this work
does not certify bit complexity, the stochastic discounted adaptation, or
the parity reduction. Independent Reviewer replay and judgement are required.

The final campaign-local `math_state check` and `proof_graph_check check`
both returned zero against
`campaigns/9000104`.
`final_check_status.json` records those measured statuses. The earlier
post-compilation check's stale route-reference failure was repaired without
changing any mathematical assertion, route decomposition, or retired reason.
