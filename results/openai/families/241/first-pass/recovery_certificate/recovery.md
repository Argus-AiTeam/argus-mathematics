# Four-value recovery: mathematical verification

## Scope and known input

The target is Proposition `prop:recovery` in the staged September 24, 2026
manuscript, not the separate Slaman--Woodin representation assertion or
unrestricted rigidity. The original ledger contained only the campaign goal,
with no prior recovery certificate. This work preserves the hypotheses:
`F : R -> 2^N` is Borel, has countable fibers, and for every `x,y` there exists
an oracle program computing `F(x+y)` from `F(x) join F(y)`.

The only descriptive-set-theoretic inputs needed here are the Baire category
theorem and the Baire property of Borel sets. The manuscript cites Marker,
*Descriptive Set Theory*, Fall 2002, Theorem 2.52 and Corollary 2.57. The
continuity-on-a-comeager-restriction consequence is proved below; continuity
at every point of the ambient space is neither claimed nor used.

The cited primary PDF has been retrieved locally. At Corollary 2.57 it states
"BP is a sigma-algebra containing the Borel sets" (the PDF uses the sigma
symbol). Theorem 2.52 is the Baire category theorem. Here it is applied only
to nonempty Polish open subspaces. These unpublished notes have no registry
identifier in the ledger; the exact URL and proposition locators are recorded
in the assumption sources, not invented DOI or arXiv identifiers.

Pointwise existence of an oracle-program index is not a uniform way of
choosing indices on an orbit. Likewise, proving each individual branch
computable with a different unspecified program does not prove that the branch
sequence is computable. Neither shortcut is used below.

## Category localization and finite constants

For a fixed program index, success on every bit is a countable Boolean
combination of conditions on finitely many coordinates of `F(x)`, `F(y)`, and
`F(x+y)`. These conditions are Borel. Therefore the least successful index
`e(x,y)` is Borel. For any Borel map into a second-countable space, replace
the inverse images of a countable basis by open sets modulo meager sets.
Outside the union of those exceptional sets, the restricted map is continuous.
Apply this to `F` and to the discrete-valued map `e`, obtaining comeager `D,E`.

Fix irrational `0<t<1` and the countable additive group `H=Q+Qt`. Intersect,
over all `s,a in H`, the conditions

    u+s in D,
    (u+s,v-u+a) in E,
    (v+s,u-v) in E.

Each two-dimensional map here is an affine homeomorphism: the linear
determinants are respectively `1` and `-1`. The first map is an open
coordinate projection followed by a translation; the inverse image of a
nowhere-dense set is nowhere dense. Thus this intersection `G_t` is comeager.

For `(u,v) in G_t`, relative continuity into the discrete space `N` supplies
fixed integers `p=e(u,v-u)` and `q=e(v,u-v)` and `0<rho<1` such that the two
addition reductions use those same indices whenever the old offset, increment,
and new offset have absolute value below `rho`. In particular the return
program is used at the *new* offset.

Choose `-rho<b_-<0<b_+<rho` with both endpoint translates in `D` and with
distinct `F`-values. This is possible because each side has uncountably many
points in `D` while the fiber at the chosen left endpoint is countable.
Choose a distinguishing coordinate `j` and set `h=F(u+b_+)(j)`.
Relative continuity of this single coordinate gives a rational
`0<delta<rho` with `3 delta < b_+-b_-`, for which the bit is different from
`h` on `H cap [b_-,b_-+delta]` and equal to `h` on
`H cap [b_+-delta,b_+]`. No endpoint is required to lie in `H`.

The parameters `p,q,j,h,delta` are finite program constants. The proof does
not require selecting them effectively from `t,u,v`.

## Infinite-time confinement

Define `s_0=0`, let `r_n` be the bit testing whether `F(u+s_n)(j)=h`,
and put `s_(n+1)=s_n+delta(t-r_n)`. Induction proves
`s_n in H cap [b_-,b_+]` for every natural `n`.

If `r_n=0`, the right endpoint rule implies `s_n<b_+-delta`. Its next
increment lies strictly between `0` and `delta`, so it cannot leave the
interval. If `r_n=1`, the left endpoint rule implies `s_n>b_-+delta`;
the decrement lies strictly between `-delta` and `0`, with the same
conclusion. Rationality of `delta` preserves `H`. This proves the invariant
for all time, independently of any computability claim.

The bounded Jacobian operation concerns only the polynomial
`-d*z-g` on `[0,1]^3`. With `z=1-t` and
`g=b_+-delta-s`, it is the upper-end displacement in the zero branch;
the same sign calculation applies at the lower end in the other branch.
It is a sign sanity check, not evidence that an infinite orbit is computable.

## Effective oracle substitution

Write the fixed oracle as the four streams

    T0=F(u), T1=F(u-v),
    T2=F(v-u+delta*t), T3=F(v-u+delta*(t-1)).

Begin with the projection program for `T0`. At stage `n`, its `j`th output
determines `r_n`. Substitute the current stream program and `T(2+r_n)`
into `p`; substitute that result and `T1` into `q`. These are substitutions
of finite program texts, not queries to a state-valued oracle. The invariant
makes the two substituted reductions valid at every stage.

There is an equivalent certificate-search implementation that makes the
termination argument explicit. Enumerate finite halting transcripts of `p`
and `q`, together with finite derivation trees whose leaves are queries to
the four streams. A transcript's internal oracle calls are justified by
earlier derivations for the preceding stream; its increment component is
selected by an already justified branch bit. All such finite trees can be
enumerated and checked using only `T`. An actual halting computation at
stage `n` uses finitely many queries. Replacing each by its finite derivation
from stage `n-1` yields a finite tree. Induction on the stage therefore proves
that a certificate exists for each requested bit; soundness proves that every
accepted certificate gives that bit. Searching these finite certificates is
a single oracle algorithm uniform in the stage and queried bit.

This argument must not be replaced by an assumption that the orbit or branch
sequence is computable. The numerical states, `t,u,v,rho,b_-,b_+` are absent
from the algorithm. They occur only in its correctness proof.

## Terminating cut decoding

For `N>=1`, telescope the recurrence to obtain

    s_N = delta * (N*t - sum_(n<N) r_n).

Since `|s_N|<rho<1`, the rational average `A_N` satisfies
`|t-A_N|<1/(N*delta)`. On a rational query `a`, search for `N` with
`a<A_N-1/(N*delta)` or `a>A_N+1/(N*delta)`. Return respectively the
strict-cut values `1` and `0`. Soundness follows from the strict error
bound. For termination, `a != t` by irrationality; choose `N` with
`2/(N*delta)<|t-a|`. The triangle inequality then gives one of the tested
strict separations. No modulus depending on the unknown gap is an input to
the search. Rational `delta` makes every test effective.

The formal decoder uses a coarser integral bound. Fix any natural
`K >= 1/delta`, with `K>0`, and replace the error by `K/N`.
Such a `K` is obtained by elementary rational arithmetic. This remains a
strict enclosure because the original error is strictly smaller than
`1/(N*delta)`. For a query `(a-b)/D` with `a,b` natural and `D>=1`,
the two tests become exactly

    a*N + K*D < S_N*D + b*N,
    S_N*D + K*D + b*N < a*N.

Only natural-number operations occur in these tests. Every rational query
has this form. Strict equality at either enclosure endpoint does not select
that branch; eventual separation still follows from irrationality.

## Transcript representation and the formal boundary

The formal source uses a concrete representation of oracle programs by
ordinary partial-recursive verifiers of finite halting transcripts. Here is
the effective translation used to connect it to the manuscript's programs.
For a fixed oracle-machine index `e`, a verifier on `(i,b,qs)` first checks
that repeated entries in the finite query/answer table `qs` are consistent.
It then simulates machine `e` on input `i`, answering an oracle query by
looking it up in `qs`. A missing entry cannot yield acceptance. The verifier
accepts exactly when this simulation halts with output `b`. All bookkeeping,
table lookup, and transition simulation use ordinary effective operations on
finite strings; `e` is hardcoded. Thus this is a single ordinary
partial-recursive program. Its bounded universal simulation accepts at some
finite bound precisely when it accepts at all.

If the original oracle machine halts on actual joined streams, its finite
computation supplies a consistent table on which this verifier accepts.
Conversely, an accepted table agreeing with those streams gives exactly the
same deterministic computation and output. This proves the equivalence
`Runs` used in `Main.lean`. Apply this translation separately to the fixed
forward and return programs; it introduces no new real parameter or oracle.
The translation is a human-proved programming lemma, not an additional
formalized oracle-machine model equivalence.

The Lean development then proves the uniform computation, rather than
postulating it. Its finite certificates are lists with every premise
justified earlier in the list. An odd layer represents the forward program;
the following even layer represents the return program. The branch selecting
the increment stream is itself a premise at the preceding even layer.
`all_stage_proofs` proves certificates exist for every output coordinate of
every even stage. `valid_sound` proves every accepted certificate is true.
`relative_search` and `infinite_oracle_substitution` use Mathlib's actual
`Nat.RecursiveIn` predicate, primitive recursion and unbounded minimization
to make the search a uniform oracle algorithm. The oracles do not include
the orbit, a table of branch values, or any of the real parameters.

`four_value_recovery` applies this result to the orbit defined from `F`,
proves its local-program hypotheses from confinement, and concludes relative
computability of both the whole branch sequence and the strict rational cut.
It works for natural-valued streams, so characteristic functions are a
special case. The four-stream addressing used in Lean repeats the fourth
component for unused component labels; it is computably equivalent to the
usual fourfold join and encodes no additional information.

## Replay and significance

Run `python3 research/recovery_certificate/verify.py` from this campaign.
The script performs exact rational endpoint and orientation stress checks,
checks the retained typed Jacobian result, and invokes the official Lean
evidence verifier on the universal recovery theorem. It then runs both
official checks at this campaign's physical root and writes
`exact_certificate.json` only if all required commands succeed.

The rational finite experiments and the exact quadratic cut fixtures are
explicitly finite experiments. They do not prove an infinite theorem; the
Lean compilation supplies that part. The axiom reports identify whether
the main declarations use anything beyond the standard logical axioms.

The primary comparator linked by `openai/math`'s `lean/docs/241.md` is
[`lean/ComparatorChallenges/DegreeRigidity.lean`](https://github.com/openai/math/blob/main/lean/ComparatorChallenges/DegreeRigidity.lean).
The retrieved source is retained as `prior-DegreeRigidity.lean.txt`. It
defines the Turing-degree order and the full rigidity statement, but
`OAI.TuringRigidity.ManuscriptMain.rigidity` ends with `sorry`; it supplies
no hole-free recovery proof. This comparison concerns that linked file,
not every branch or file of the upstream repository.

The improvement over that baseline is a machine-checked construction of
the uniform stage-bit reduction, joined to an all-natural-stage confinement
proof and a total strict-cut decoder, rather than a statement of rigidity
with a proof placeholder. Publication-level significance and verified
novelty remain matters for independent review, not conclusions of a
compiler run.

## Certification boundary

This note proves the recovery implication in ordinary mathematics. The
compiler certificate, source-to-statement fidelity document, and executable
certificate identify exactly which infinite-computation assertions are
mechanically checked. The official replay completed with Lean 4.31.0,
`exit_code=0`, and `proof_holes=[]`; the three reported declarations depend
only on `propext`, `Classical.choice`, and `Quot.sound`. The claim ledger
derives `closed_kernel` for `C_RECOVERY_CORE`. Both official structural
checks returned zero at this campaign's physical root.

Independent Reviewer replay and judgement are still required, especially
for statement fidelity, the category proof, and the transcript translation.
This Engineer note supplies no Reviewer acceptance and makes no verified-new
or publishability claim on its own. It does not certify the all-input
representation theorem or unrestricted rigidity.
