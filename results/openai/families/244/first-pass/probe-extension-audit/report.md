# Probe-extension algebra

## Exact question and scope

The target is `lem:mono-probe-algebra` in the staged
`build/sections/monoid.tex`, especially lines 168--338. The presentation is

    p_i = d_i p_(i+1),    p_i b = c_i e,
    n_0 = 1,    n_i d_i = n_(i+1),    n_i c_i = a.

The base monoid is left cancellative and conical, has conditional right
joins, and carries the manuscript's height and cost functions; `b` and `e`
are nonidentity elements. Right cancellation is not a hypothesis.

The live question is whether the actual presented monoid conservatively
contains the base, is left cancellative, and has the asserted least-old-
multiple gate and old-factor implication. A finite search cannot answer it.
No conclusion about the forcing argument or the full consistency theorem
follows merely from resolving this algebraic dependency.

## Scope retrieval

The campaign ledger initially contained only its top-level audit claim and
no prior mathematical result. The supplied wiki index has no page about
this probe construction or the Partition Principle. The manuscript's proof
uses Newman's lemma; a verification should instead prove the needed
normalization facts directly or explicitly account for that dependency.
No external theorem has yet been adopted as a mathematical assumption.

The first Jacobian discovery for monoid presentations returned unrelated
finite algebra operations. A refined discovery found the bounded operation
`term_rewriting.critical_pairs.compute`. Its exact typed contract was inspected
and one bounded operation was executed. It returned two candidate positions,
one unifiable critical pair, and no error or timeout. The payload, contract
and typed output are preserved in dedicated JSON files. This is only the
finite first-order shadow of the internal-letter reduction, not a certificate
for the infinite presentation.

## Current mathematical status

The universal algebraic theorem below has passed the official Lean 4.31.0
compiler and axiom audit, both with exit code `0` and `proof_holes=[]`.
Mechanical evidence is recorded on `C_PROBE_CORE`, with the source and
statement-fidelity document bound by the verifier. Both campaign-local
checks passed at
`campaigns/9000244`:
`math_state=0`, `proof_graph_check=0`. Independent statement-fidelity,
novelty and significance review remain pending.
`math_state show` derives `closed_kernel` for `C_PROBE_CORE`; that
compiler-earned status is not independent Reviewer acceptance.

No false assertion has been established. In particular, noninjective maps
`x -> x d_i` do not invalidate the common-finite-stage argument: after
bringing representatives to one stage, an old *left* multiplier cancels.
The theorem proves the existence and behavior of gates.

## Independent normalization theorem

The following argument avoids an appeal to Newman's lemma. It also isolates
an abstract generalization of the presentation: an injective left action of
`M` on a set `S`, together with an equivariant map `h:S -> M`, suffices for
the normal-form construction, provided `s` never belongs to `h(s)S`.
For conservation and gates, intersections of old cones must lift to `S`.
Below these properties are proved from the manuscript data, not added as
hypotheses on that data.

### 1. The direct limit, including noninjective transitions

For `i <= j` write `D(i,j)=d_i ... d_(j-1)`, with empty product `1`.
Represent `S` by pairs `(x,i)` modulo

    (x,i) ~ (y,j) iff
    there exists k >= i,j with x D(i,k) = y D(j,k).

Associativity gives transitivity by moving two witnessing equalities to a
larger common stage. No transition map is required to be injective.
The action is `u[x,i]=[ux,i]`. If `u[x,i]=u[y,j]`, cancellation at
a witnessing common stage gives `[x,i]=[y,j]`. Thus each left action is
injective.

The identities `D(i,j)c_j=c_i` give the well-defined equivariant maps

    k([x,i])=xc_i,    h(s)=k(s)e.

If `s=u t`, then `k(s)=u k(t)`. Consequently `s=h(s)t` would imply
`k(s)=k(s)e k(t)`. Left cancellation would give `e k(t)=1`,
contrary to conicality and `e != 1`. This proves head separation.
It also implies `h(s) != 1`.

If a letter lies in both `xS` and `yS`, representatives at a common
stage give an old common multiple of `x,y`. If their old join is `j`,
factor that common multiple through `j` at that same stage. The letter
then lies in `jS`. Conversely `jS` lies in both cones. Therefore

    xS intersection yS = jS

when the old join exists, and the intersection is empty when there is no
old common multiple. This is the precise point at which noninjective
transitions are handled; cancelling a right factor would be invalid.

### 2. A constructed monoid, not an assumed normal-form theorem

A raw word is `old(y)` or `cons(s,W)`. Define `A_u` on raw words by
multiplying an old terminal value, or acting on just the first letter.
Each `A_u` is injective. Say that a raw word is a `b`-multiple when it is
`A_b(V)` for some raw word `V`; the quotient is unique.

Define a new-letter operator on *all* raw words:

    P_s(A_b(V)) = A_(h(s))(V),
    P_s(W)      = cons(s,W) if W is not a b-multiple.

The two cases have disjoint ranges. The second has head `s`, whereas
the first is old or has head in `h(s)S`. Within each case injectivity
follows respectively from injectivity of `A_(h(s))` and of `cons`.
Hence `P_s` is injective.

Equivariance and the unique `b`-quotient give identities of operators

    A_u A_v = A_(uv),
    A_u P_s = P_(us),
    P_s A_b = A_(h(s)).

A word is normal when every suffix following a new letter is not a
`b`-multiple, recursively. Both `A_u` and `P_s` preserve normality.
For raw `X`, define `F_old(u)=A_u` and
`F_cons(s,T)=P_s F_T`. Direct recursion proves

    F_(A_u X) = A_u F_X,
    F_(P_s X) = P_s F_X,
    F_(F_X(Y)) = F_X F_Y.

On normal words put `X*Y=F_X(Y)`. The last identity proves associativity.
The identity is `old(1)`; right identity follows by recursion using
normality. Every left multiplication is injective, since it is a
composition of injective `A` and `P` operators.

No product with a new left word can be `old(1)`: its outermost `P_s`
either leaves a head or gives an old multiple of the nonidentity
`h(s)`. Conicality of `M` excludes the latter being `1`. For two old
words conicality is that of `M`. Thus the constructed monoid is conical.

To identify this construction with the *actual* presentation, let
`f:M -> N` be a monoid homomorphism, and let `q:S -> N` satisfy

    q(us)=f(u)q(s),    q(s)f(b)=f(h(s)).

Evaluation `old(u) -> f(u)`, `cons(s,T) -> q(s)eval(T)` respects both
cases defining `P_s`, and hence defines a homomorphism from the constructed
monoid. It is the unique such homomorphism because every normal word is
a product of old elements and letters.

For manuscript generators `q_i` satisfying the two displayed presentation
relations, the formula `q([x,i])=f(x)q_i` is well-defined: move an equality
to a finite common stage and iterate `q_i=f(d_i)q_(i+1)`.
Conversely the abstract relations specialize to exactly
`p_i=d_i p_(i+1)` and `p_i b=c_i e`. This proves the universal property
of the manuscript presentation. In particular the constructed normal
forms neither impose extra equations nor omit presentation equations.

### 3. Conservation

For old `x`, its cone consists of its old cone together with precisely
the normal words whose first letter lies in `xS`. An equation from an
old element to an old element must therefore have an old right factor,
and is exactly its original equation in `M`.

The letter-cone calculation in part 1 now proves that an old join remains
the exact intersection root in the constructed monoid. Old disjoint
cones stay disjoint. This proves conservation in the manuscript's full
sense, not just injectivity of the base map.

### 4. Exit cones and old gate factors

Write `B_s` for normal words with first letter `s`. For every normal
new word `W=sY`, prove by induction on its length the following stronger
alternative:

    W M' is contained in B_s; or
    W M' minus B_s = old(g) M',
    where W old(c)=old(g) for some c in M.

If `Y` is old, intersect its old cone with the old cone of `b`.
If `Y=tZ` is new, normality gives `t notin bS`. Its fixed-head block
is therefore disjoint from the cone of old `b`. By induction, its
intersection with that cone is the intersection of its old gate cone
with the old `b` cone, or is empty if it has no gate. Conservation
computes each nonempty intersection as an old-rooted cone `zM'`,
where `z=bu` with old `u`.

In the nonempty case the inductively obtained right factor from `Y`
to `z` is old: for old `Y` it is the old join quotient; for new `Y`
it is the product of its old gate factor and an old join quotient.
Call it `c`. Then

    W old(c) = s z = s b u = h(s)u = old(g).

Every exit has this form times a further right factor, and every
multiple of `g` is outside `B_s`, by head separation. This proves
the alternative and the exact exit-cone identity.

Every old multiple is an exit. A word with an old multiple consequently
has a gate `g`, itself an old multiple, dividing every old multiple.
The right factor in an old-to-old comparison is old by conservation,
so this is a least old right multiple in the *old* order as well.

Finally a separate induction proves that appending an old factor to a
normal word either preserves its first head or produces an entirely old
word. For `sY`, if `Y` still has its original new head, that head is not
in `bS`, so it cannot consume `s`; if `Y` has become old, consuming `s`
leaves an old value. As the gate cone is disjoint from `B_s`,

    d old and g(W) divides Wd  =>  Wd old.

This proves precisely the gate implication in the live objective,
without using right cancellation or taking conservation, gates, or
unique normal forms as premises.

### 5. All conditional joins and repeated algebraic extensions

The formalization also proves conditional joins for the whole extension.
For equal new heads, cancel the head and induct on the sum of word
lengths. An old and a new cone either have the new root as their join,
or their intersection exits the new block and is computed through its
old gate. For distinct new heads, an intersection inside either block
forces one original root to divide the other: the entering word exits
its own block through an old gate, and an old divisor of one word in
the other block divides every word in that block. Otherwise all common
multiples exit both blocks, so their intersection is computed by the
old join of their gates. A missing gate or old common multiple makes
the intersection empty.

Thus the new monoid again satisfies all *algebraic* antecedents of
the core theorem. It can be applied repeatedly without inserting a
right-cancellation assumption. Height/cost extension, the full probe
profile, and conservative simulation are not certified by this theorem.

## A genuinely non-right-cancellative infinite test family

The executable checks use `M=N^3` with ordinal addition below `omega^3`,
written in coordinates `(A,B,C)`. Explicitly,

    (A,B,C)(D,E,F) =
        (A+D,E,F)       if D>0;
        (A,B+E,F)       if D=0 and E>0;
        (A,B,C+F)       if D=E=0.

Identity is `(0,0,0)`. For a fixed left factor the displayed map is
injective (the first nonzero coordinate of the right factor determines
the disjoint case); the formula is associative by the same case split.
No nonidentity product is the identity. Right divisibility is exactly
lexicographic order, and joins are lexicographic maxima. In particular,
with `u=(0,0,1)` and `d=(0,1,0)`,

    u != 1,    ud = d = 1d.

This is infinite and not right cancellative, not a purported finite
left-cancellative conical example.

It satisfies the full margin hypotheses as well. Put

    epsilon_(A,B,C) = 2^(-A-B-C-6),
    rho(x) = 1/4 + 2 sum_(z <=lex x) epsilon_z.

The total sum of the costs is `1/8`. For `x<y`, the height difference
is twice the positive sum of costs over `x<z<=y`, strictly greater
than their supremum. All heights lie between `0` and `1`, and all
costs between `0` and `1`. The script uses the exact rational closed
form of this convergent sum.

Choose

    a=b=e=(1,0,0),    n_i=(0,i,0),    d_i=(0,1,0),    c_i=a.

Every transition is noninjective, and the path never stabilizes.
Equality in its direct limit is decided exactly by

    [(A,B,C),i] <-> (A,B-i) in N x Z.

The lost coordinate `C` is genuinely lost; no right cancellation is
silently used. The left action on a letter `(D,z)` is

    (A,B,C)(D,z) = (A+D,z) if D>0, and (A,B+z) if D=0.

In particular the infinitely many letters `(0,-i)` are distinct even
though they have the same `k` and `h`. This is a sensitive test of
head equality and of the old gate threshold.

For repeated extensions, right multiplication by `(0,1,0)` keeps all
normal-form heads, increments the bottom terminal `B`, and erases its
`C`. This follows recursively: a normal suffix is not a `b`-multiple,
and this operation cannot turn it into one. Its direct limit therefore
has an exact signed-bottom-coordinate normal form at every tested
extension level. The implementation uses those forms and the constructed
`A/P` operators, never bounded word-rewriting equality.

These deterministic examples are adversarial finite experiments *inside
infinite monoids*. Their counts and their classification are recorded
separately from the universal Lean theorem. They are not an exhaustion
argument or the evidence for its universal quantifier.

## Improvement and remaining frontier

The initial campaign state had only an opaque top-level audit goal.
The mathematical improvement is a universal, source-faithful
verification of an upstream algebraic dependency, including a proof of
the presentation's universal property and full exit cones. It is not
another bounded no-counterexample report.

The results downstream of this dependency remain open in the proof
graph: margin extension, probe profile, simulation, countable-base
rearrangement and descent, countable stabilizer quotients, quotient
assembly, and the two main model-theoretic conclusions. No `F_` claim
is appropriate because this work has not established a false manuscript
assertion. Independent review must assess both statement fidelity and
the significance/novelty of this verification theorem; this report does
not certify its own publishability.

## Reproduction and exact evidence

Run from the campaign root:

    $WORKSPACE/argus-live-update/.venv/bin/python research/probe-extension-audit/verify.py

This replays the exact infinite-base examples, checks the saved typed
Jacobian overlap result, invokes the official Lean verifier with
`--claim C_PROBE_CORE`, and runs both official campaign-local checks.
It writes the measured result to `exact_certificate.json`. The installed
verifier takes the Lean source as a positional argument; the precise
native command is recorded in that certificate.

The immutable compiler certificate for this run is
`certificates/C_PROBE_CORE-ac5bdb45d8970097.json`.
The development compiler's printed axiom lists contain only
`propext`, `Classical.choice`, and `Quot.sound`; the official axiom
audit also exited `0`. No Mathlib project was initialized and no
staged manuscript source was edited.

The exact experiments cover three successive extensions of the
non-right-cancellative infinite base, with 30 presentation-relation
checks, 616 common-stage action checks, 228 exit-cone checks and 202
old-factor gate checks. These numbers describe finite experiments;
the universal conclusion comes from the separately checked Lean proof.
