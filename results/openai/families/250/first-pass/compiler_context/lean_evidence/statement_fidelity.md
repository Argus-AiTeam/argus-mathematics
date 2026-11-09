# Statement fidelity: bounded raw-run algebra

`CompilerContext.Token A B` has a raw constructor carrying any finite word over
an arbitrary type `A`, and a barrier constructor carrying any element of an
arbitrary type `B`. No finiteness, decidable equality, or cleanliness hypothesis
is imposed on those types. Barriers encode already-preprocessed non-full-raw
sectors, not the original machine configurations.

`Budget f m` quantifies over every word and every three-word context whose
concatenation has length at most `m`. Its two fields are precisely length
nonincrease and `f(x f(w) y) = f(x w y)` on that ball. The formal `f` is a total
function; for a partial manuscript program satisfying the budget, an arbitrary
total extension off that ball suffices. `normal_safe` proves that normalization
never consults the extension. This is not a global-totality assumption about
the program.

`normal` is a right-to-left implementation of adjacent-raw contraction.
`normal_singleton` fixes every raw singleton literally, including payloads not
fixed by `f`, and `normal_empty` fixes the empty list. `normal_mass` bounds the
sum of output payload lengths. `normal_safe` checks the length of every call
made by this recursive implementation.

`bounded_associativity` and `contract_normal` quantify over all payloads and
all token contexts, not over a finite experiment. `Contracts` replaces
`raw(u), raw(v)` by `raw(f(uv))` in an arbitrary context, with the original
argument length within the budget. `Derives` is the finite forward closure of
these contextual contractions. `normal_derivation` constructs such a derivation
from each bounded token list to its output. `contract_grade` and `derives_grade`
use the manuscript's full-raw grade `3 + |u|` and any nonnegative barrier cost;
they prove grade nonincrease at every step. `derives_normal` proves invariance
along bounded derivations. `bounded_context_compatibility` proves the exact
two-sided implication from equal normalized token lists to equal normalized
contextualized token lists, provided both contextual inputs stay in budget.

`sourceRun` is exactly the source's rule for a single maximal raw run: no call
on a singleton, and one call on the concatenation for a run of length at least
two. `normal_raw_run` proves that the recursive implementation agrees with
that rule for every finite raw run in budget. `normal_grade`,
`normal_safe_grade`, and `bounded_context_grade` express the corresponding
bounds and contextual implication using total grade rather than payload mass.

The claim `C_COMPILER_RUN_ALGEBRA` is restricted to this raw-run algebra.
The source does **not** encode the scan compiler, its internal weak components,
quiver parsing, quota removal, or entry-priority preprocessing. In particular
it is not a formal proof of `C_COMPILER_CONTEXT`, and the existence of this
formalization does not discharge those separate obligations.
