# The rational all-weight upper bound

## Statement and present evidence

The target is Corollary `cor:dimension-bound` of the staged September 23,
2026 manuscript. For every nonnegative integer n,

    dim_Q W_n <= dim_Q FreeLie_Q(e_3,e_5,e_7,...)_n,  wt(e_j)=j.

Here W is exactly the ordinary rational free-Lie solution space of the
antisymmetry, three-term, and four-strand pentagon equations in Section 1.
There is no assumption that arbitrary solutions in characteristic two lift
to characteristic zero, and no replacement of ordinary Lie elements by
arbitrary primitive elements.

The Engineer certificate is complete and awaits the Host's independent
Reviewer. It combines a universally quantified Lean proof for n>2 with
the exhaustive algebraic base-case proof below. Only the n>2 component is
Lean-formalized; no mathematical novelty or campaign-final acceptance is
asserted.

The upstream candidate is
`OAI.DeligneDrinfeld.RationalBound.finrank_Wn_le`, in
`lean/OAI/Algebra/Drinfeld/Ihara.lean`, with hypotheses `n : Nat` and `2 < n`.
The Host identifies the candidate revision as
`openai/math@4eaee87548250b2682affda7d05d947c05554bae`.
Its declared toolchain is Lean 4.34.1. Both the 4.34.1 and 4.31.0 compiler
executables are installed, but the upstream checkout has no `.lake` build
directory. A direct 4.31.0 invocation in the supplied, built Mathlib workspace
failed because the OAI dependency modules had not been compiled. This is an
environment/dependency observation, not a mathematical counterexample.

The certificate procedure compiles only the transitive OAI import closure of
`Ihara`. Original upstream sources are never modified. Any incompatibility is
reported as a failed compiler run, not as a refutation.
The minimal closure consists of Foundations, Ordering, Grading, Transport,
Reduction and Ihara: six files and 13,856 source lines, rather than the
holonomy/completion construction. The unchanged Foundations file failed
against Mathlib 4.31.0 after 173.028 seconds, with renamed induction cases
and associative-algebra API differences. A wholesale backport is not the
selected approach.

The primary GitHub API resolves the stated OpenAI revision and the matching
Mathlib revision `d13f23b723b8a846827a245b89c10fc7d3f11612`, whose commit message
is "chore: bump toolchain to v4.34.1". No public Actions run at the exact OpenAI
revision was returned.

The matching replay restored 8,908 canonical cached Mathlib dependency
artifacts, built only the small cache reader, and compiled all six OAI
modules successfully using Lean 4.34.1. The source pin receipt verifies that
every compiled OAI source is byte-identical to the stated public revision.
No whole-Mathlib rebuild or source backport was performed.

The official `lean_evidence verify --claim C_UB_GT2` replay then passed:
compiler exit 0, proof-hole audit exit 0, `proof_holes=[]`, and exactly
`propext`, `Classical.choice`, and `Quot.sound` in the printed axiom
closure. The immutable receipt is
`certificates/C_UB_GT2-2c372ff5ea7abe86.json`; the ledger derives
`closed_kernel` for C_UB_GT2 with no undischarged assumptions. The source
and statement-fidelity hashes both match the files actually compiled.
This is a Lean 4.34.1 certificate, not a Lean 4.31.0 certificate.

The first successful compiler run was not eligible for ledger recording:
its fidelity document named the declarations only with namespace
qualifiers. That refused receipt is preserved in `attempt_fidelity/`.
Adding the four unqualified declaration names did not change the stated
interpretation; a fresh actual compiler run earned the accepted receipt.

## Mathematical dependency chain

1. `lem:lie-lattice` and `lem:free-fiber` give integral, torsion-free ordinary
   free-Lie and braid targets. `lem:special` is proved over Q before reduction.
   `prop:saturated-reduction` identifies dim_Q W_n with the dimension of its
   embedded saturated-lattice reduction.
2. `lem:abc-free` embeds the ordinary Lie presentation on A=x^2, C=[x,y],
   B=y into the associative algebra in x,y. Original weights are 2,2,1.
3. `prop:leading-pentagon` transfers the leading relation by opposite
   count-monotone ordering procedures. Independence is used only in the
   source braid algebra, not in the target arrangement algebra. At count r
   and weight n=2m+r, the target symbolic length is m+r, not n.
4. The integral deletion representation and `lem:deletion-kernel` reduce a
   projection kernel to P(A,B). The reduced special identity eliminates
   that residual kernel, including the m=1, r=1,2 boundary cases.
   This is `prop:projection-injective`.
5. Antisymmetry yields the even-index restriction. Polynomial shifts
   B -> B+s(C), with independent scalar indeterminates, yield a Vandermonde
   system over a rational-function field. Its consecutive-divisibility
   consequence and an ordinary free-Lie retraction remove g_0=B.
   Thus `prop:image-bound` places each projected piece in the ordinary free
   Lie algebra on g_k=ad_C^k B, k>=1, of weight 2k+1 and length one.
6. Finite filtration additivity and characteristic-independent ordinary
   free-Lie dimensions give the bound for n>2. Weight zero has no free-Lie
   monomials. The degree-one pentagon has residual
   -alpha*t_12-beta*t_34, and the degree-two three-term equation on [x,y]
   has residual 3[x,y]. These cover n=0,1,2.

For clarity, these are exhaustive base cases, not agreement with a finite
table of conjectured dimensions. A positive-weight Lie word cannot have
weight zero. In weight one its leaves are x or y. The six coordinate maps
from the braid algebra to its abelianization are well defined because all
its defining relations are brackets; hence t_12 and t_34 are independent.
In weight two the complete bracket list is [x,x], [x,y], [y,x], [y,y],
whose associative expansions are 0, xy-yx, yx-xy, 0. Thus the piece is
spanned by [x,y]. The coefficient of xy in the three-term residual on
c[x,y] is 3c, so c=0 over Q. Together with a theorem quantified over
every n>2, these three base cases cover every nonnegative weight.

The dimensions in the formal endpoint are genuine finite dimensions.
At weight n, an ordinary word has at most n leaves and only finitely many
binary bracket trees. On the right, only indices k with 2k+3<=n can occur.
Consequently both homogeneous spans, and the solution subspace, are
finite-dimensional. The use of `Module.finrank` is not a zero-by-infinite-
dimension shortcut.

The upstream lattice argument uses Z, while the manuscript uses Z_(2).
For any integral lattice M and rational subspace U, put K=U intersect M.
Then K localized at 2 equals U intersect M_(2): multiplying a vector in
the latter by a common odd denominator puts it in K. The converse is
immediate. Their reductions modulo 2 therefore agree. Saturation is the
identity K intersect 2M = 2K, since 2v in U implies v in U. This explains
the compatibility of the two presentations; it does not assert a lift
of an arbitrary modular solution.

The characteristic-two objects used upstream include the additional
identities inherited from rational solutions. The final rational theorem,
not a theorem about an arbitrary modular solution space, is the intended
certificate endpoint.

## Scope and comparison with prior results

Willwacher, arXiv:2607.18793v2, Theorems 1.1 and 1.2, supplies the known
free odd-generator subalgebra and the stronger freeness criterion for any
homogeneous odd-weight family with nonzero depth-one coefficients.
This is the reverse inequality, not a proof of the upper bound.

Naef--Willwacher, arXiv:2508.08081v1, Theorem 5 and Corollary 7, establishes
the relevant equality through weight 29. A finite-weight reconstruction
cannot settle the present universal quantifier and is not the selected
route. The present certificate replays an all-weight proof, rather than
enlarging that finite range. It verifies an existing upstream theorem;
it is not claimed to be a new proof of the conjecture or a novel theorem.

Both primary arXiv sources were obtained and their indicated statements
read. Their citation assumptions remain subject to the Host's independent
Reviewer attribution; the Engineer does not self-certify its citations.

The wiki index contains no Deligne--Drinfeld or upper-bound topic. No
relevant prior receipt was found there. The intentional `sorry` in
`ComparatorChallenges/DeligneDrinfeld.lean` is a comparison exercise,
not a flaw in the manuscript or the implementation theorem.

## Reproducibility and trust

`verify.py --restore-mathlib` restores the exact compatible Mathlib revision
and its manifest-pinned dependencies from primary source archives. It uses
the canonical master artifact cache through its typed reader API, without
Git operations, a fork cache, or a cache fallback. The generated cache
reader and package sources live under `.lake`, not among the mathematical
declarations being certified.

`verify.py --prepare` checks the six sources against the pinned primary
revision, builds only the necessary upstream OAI modules, and writes
the actual commands, exit codes, logs, source identities and artifact
identities, and stops on a compiler failure.
`verify.py` replays the final statement, checks its axiom closure and
the exact low-weight calculations, and produces `exact_certificate.json`.
The persisted successful certificate has `all_weights=true`,
`lean_evidence_exit_code=0`, and
`status=engineer_verified_pending_independent_review`.
It requires a real non-refused claim-ledger receipt and unchanged source
and fidelity bindings, not merely a successful compiler status.
The mathematical endpoint is `C_UB_GT2`; the ledger must not label the
all-weight combination `closed_kernel` merely because its n>2 component
compiled. The base-case proof and the statement-fidelity reading remain
explicit human-readable components.
No finite calculation or source scan is allowed to stand in for the
universal compiler endpoint.

With the persisted dependencies and compiled import closure, the independent
replay command is:

```sh
$WORKSPACE/argus-live-update/.venv/bin/python research/upper_bound_certificate/verify.py
```

For a clean dependency setup, use the same script with `--restore-mathlib`,
then `--prepare`, then no option. Long commands must use the Argus durable
runner as in `matching_build_submission.json` and `final_submission.json`.
The default replay never treats a saved success flag as a fresh compiler
answer: it actually invokes `lean_evidence verify --claim C_UB_GT2`.

`jacobian_payload.json` is the explicit GF(2) coefficient matrix comparing
the residual-kernel boundary vectors [B,[A,B]] and ABB+BAB+BBA in the
ordered word basis ABB,BAB,BBA. Its rank is only an auxiliary exact
boundary check, never evidence for all weights.

The script also verifies the 21 incident and nonincident source action
formulas in `lem:action-tables` as identities in the free noncommutative
polynomial ring over F_2. It implements the displayed free-fiber derivations
and expands their squares and commutators independently. These are symbolic
polynomial identities, not weight-bounded searches.

All graph nodes remain unconfirmed pending independent review; this does
not erase the separately recorded kernel closure of C_UB_GT2. The direct
certificate route needs that theorem, its natural-statement fidelity,
and the complete base cases. The more detailed manuscript-lemma graph
is retained without claiming separate formal certificates for each
literal intermediate assertion.

The Host's independent Reviewer must replay the certificate, inspect
the printed solution and grading definitions against the manuscript,
read the base-case proof, and attribute the two contextual literature
citations. No false manuscript assertion was identified, so no F_* claim
or manuscript `refutes` judgement is warranted by these results.
