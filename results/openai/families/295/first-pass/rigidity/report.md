# A parameter-uniform verification of first-letter rigidity

## Result and certification boundary

Theorem `thm:rigidity` in the staged September 23, 2026 manuscript is
proved below under its stated hypotheses. In particular, words with
repeated **original** indices are not presumed to satisfy the first-letter
identities. Repeated original indices that cancel must not be discarded.
Only repeated indices in the **surviving reduced word** are discarded.
The proof applies to arbitrary multipliers in the containing algebra,
without freeness or commutation assumptions on them.

The universal finite-word core has a separate Lean 4.31.0 source,
`Main.lean`. It proves sign-language preservation for every free reduction,
coverage and counting of all reduction fibers by insertion histories,
and a uniform bound for repeated surviving labels. It does not formalize
von Neumann algebras, operator norms, tracial ultrapowers, spectral
calculus, or convergence. Those analytic steps are proved in this report.
The exact finite experiments in `../../verify.py` are adversarial
regressions, not the proof of the universal theorem.

No false manuscript assertion has been established by this investigation.
In particular, there is no justified `F_*` refutation claim to file.
No conclusion about the full Kadison--Ringrose conjecture follows:
the walk, martingale selection, normal reduction, and assembly of
cohomological primitives remain separate unaudited dependencies.
Novelty and publishable significance require independent assessment;
this report does not label a reconstruction or a finite experiment
as a new solution of the conjecture.

## 1. Exact statement and a sign-language strengthening

Let `(N,tau)` be a finite von Neumann algebra with a faithful normal
tracial state. Let `R:N -> N` be bounded, complex linear, and satisfy

    sup_n ||x_n|| < infinity, ||x_n||_2 -> 0  =>  ||R(x_n)||_2 -> 0.

Let `g_1,g_2,...` be an exact free Haar family in `N`. Suppose that for
every nonempty signed word with pairwise distinct unsigned indices,
`R(w)=aw` or `bw` according as its first sign is positive or negative.
Then `a=b`.

In fact fewer sign patterns suffice. Call a signed word **good** when it
is nonempty, begins and ends positively, and has no two consecutive
negative signs. It suffices to prescribe `R(w)=aw` on distinct-index
good words and `R(w*)=bw*` on their adjoints. This is a genuine weakening:
the distinct-index pattern `+--+`, for example, is not required in either
class. The proof below also proves this sign-language strengthening,
because every retained block word is good. This is a structural
consequence proved here, not a literature-verified novelty claim.

## 2. Universal reduction facts

Write a signed letter as `(i,epsilon)`. Free reduction deletes adjacent
`(i,+),(i,-)` or `(i,-),(i,+)`.

**Sign invariant.** A good word remains good after any such deletion.
At an internal deletion `+-`, the sign following the deleted minus,
if present, is positive. At a deletion `-+`, the preceding sign, if
present, is positive. Thus deletion cannot create consecutive negatives.
At an endpoint the next surviving sign is positive. Deletion cannot
erase the whole word: a positive-ended word without consecutive
negatives has strictly more positive than negative letters, and each
deletion removes one of each. This also follows directly from the
two-state invariant `admissible` in Lean.

An original block `B_d=z(z*z)^d` has signs
`+,-,+,...,-,+`, so any nonempty ordered product of such blocks is good.
Consequently every reduction is nonempty and positive-ended. The
adjoint reverses signs and order and is negative-ended. This argument
does not impose distinctness on any original label.

**Independent coefficient-count proof by insertion histories.**
Fix a reduced word `w` of length `q`, a degree `L`, and `p` with
`L=q+2p`. A length-`L` word reducing to `w` can be reconstructed by
reversing its `p` adjacent cancellations. At each insertion there are
at most `L+1` insertion positions, `r` unsigned labels, and two signs.
Hence the entire reduction fiber has size at most

    [2(L+1)r]^p.

This is the statement `reduction_fiber_bound` in Lean. It is not
conditional on having guessed a cancellation certificate:
`red_mem_expansions` proves that every `FreeGroup.Red` derivation
belongs to the enumerated insertion family and that its length drops
by exactly `2p`. Repeated or nested cancellations are included.

For comparison, the sharper manuscript constant also holds.
Use the deterministic left-to-right stack reduction and mark each
original position as an opening endpoint, closing endpoint, or final
survivor. Paired positions are nested or disjoint, and a closing endpoint
matches the last still-open endpoint; an original final survivor cannot
lie inside a canceled interval. Thus the ternary marking determines the
matching. There are at most `3^L` markings. For fixed `w`, surviving
labels and signs are prescribed; each of the `p` matched pairs has at
most `r` unsigned label choices. This reconstructs the original word
uniquely from its marking, pair labels, original fixed sign pattern,
and `w`. It follows that its multiplicity is at most `3^L r^p`.
Coincidences between pair labels, and between pair labels and survivor
labels, are permitted, not silently excluded.

The Lean insertion bound is intentionally different from `3^L r^p`.
It yields the same required power of `r`:
for example `[2(L+1)]^L r^p` is a uniform bound. The sharper ternary
constant is proved in the preceding paragraph and checked finitely
by the executable, but is not claimed to be a Lean theorem.

**Repeated-survivor count.** Among length-`q` signed strings, those with
a repeated unsigned label number at most

    2^q binomial(q,2) r^(q-1).

Indeed choose a pair of equal positions, then its common label and
the other `q-2` labels, and finally all signs. This overcounts freely.
For `q=1` there are none. Lean proves the slightly weaker uniform
bound `2^q q^2 r^(q-1)`, including the empty-alphabet and zero-length
boundary cases, by deleting one coordinate of a collision slice and
injecting into functions on `q-1` remaining coordinates.

## 3. Length estimate and the repeated-survivor operator error

For a homogeneous length-`q` free-group polynomial
`T=sum_{|w|=q} c_w lambda(w)`, split its convolution action according
to the number `t=0,...,q` of cancellations between `w` and an input
basis word. For fixed `t`, write

    w=uv, x=v^(-1)h, wx=uh,
    |u|=q-t, |v|=t,

with all displayed concatenations reduced. An input word uniquely
determines its suffix `h` after removing its first `t` letters; an
output uniquely determines that same suffix after removing its first
`q-t` letters. Different `h` therefore give orthogonal input and
output spaces. Within each matrix block, entries are `c_{uv}` or zero.
The fixed cut makes `(u,v) -> uv` injective. The Hilbert--Schmidt
bound gives norm at most `(sum |c_w|^2)^(1/2)` for each block.
Summing the `q+1` operators gives

    ||T|| <= (q+1) (sum |c_w|^2)^(1/2).                 (3.1)

This includes exhausted input words and empty suffix `h`.
It transfers to `g_j` in the containing algebra: for positive `A`
and faithful tracial state `rho`,

    ||A|| = lim_n rho(A^n)^(1/n).

The upper bound is immediate; the lower bound follows from a nonzero
spectral projection `1_(c,infinity)(A)` for every `c<||A||` and its
strictly positive trace. Free Haar moment equality applied to
`(p* p)^n` now gives equality of polynomial norms with the regular
representation. Orthogonality of reduced words gives the coefficient
2-norm identity. No reference theorem is needed for (3.1).

Put `s_r=r^(-1/2)sum_{j=1}^r g_j`; then `||s_r||<=2` and
`||s_r||_2=1`. For an arbitrary fixed ordered block product of degree
`L`, collect its expansion by reduced words:

    P(s_r)=sum_{q=1}^L sum_{|w|=q} c_w(r) w(g).

There is no scalar coefficient by Section 2. The ternary count gives
`|c_w(r)|<=3^L r^(-q/2)`. Let `E_{r,q}` retain just those reduced
words with repeated surviving unsigned indices. Orthogonality gives

    ||E_{r,q}||_2^2
      <= 9^L 2^q binomial(q,2) / r.

Thus, uniformly for every positive integer `r`,

    ||E_r|| <= K_L / sqrt(r),
    K_L = 3^L sum_{q=2}^L (q+1)sqrt(2^q binomial(q,2)). (3.2)

This is a theorem for every `L` and every ordered block product,
not extrapolation from a maximal computed degree.
Replacing `3^L` by `[2(L+1)]^L` and `binomial(q,2)` by `q^2`
gives a weaker version whose two combinatorial inputs are both
Lean-certified.

For `Q_r=P(s_r)-E_r`, every word is good and has distinct surviving
unsigned indices. Therefore `R(Q_r)=aQ_r` and `R(Q_r*)=bQ_r*`.
The original repetitions which disappeared in reduction remain in
the scalar coefficients of `Q_r`. Since `||P(s_r)||<=2^L`,
both sequences are bounded, and

    ||R(P(s_r))-aP(s_r)|| <= (||R||+||a||)K_L/sqrt(r),

with the analogous adjoint estimate using `b`.

## 4. Ultrapower passage without strengthening continuity

The sequential continuity hypothesis is equivalent to a uniform
modulus at zero on each operator-norm ball: otherwise choosing
`||x_n||<=C`, `||x_n||_2<1/n` and a fixed positive lower bound
on `||R(x_n)||_2` contradicts the hypothesis.

For a free ultrafilter `omega`, this modulus makes the coordinatewise
map preserve the ideal of bounded 2-null sequences, so it defines
`S=R^omega` on the finite tracial ultrapower `N^omega`, with
`||S||<=||R||`. To check ball continuity there, represent a class
of norm at most `C` by a sequence with norm at most `C+1`.
Choose the original modulus on that larger ball with output tolerance
`epsilon/2`. If the ultrapower 2-norm is less than half its input
tolerance, the input coordinates satisfy the original tolerance on
an `omega`-large set. The output ultrapower 2-norm is at most
`epsilon/2`. This proves the required uniform continuity.

Consequently `s=(s_r)_omega` and (3.2) give, for every ordered
block product,

    S(P(s))=aP(s), S(P(s)*)=bP(s)*.                     (4.1)

Here `a,b` are constant classes, with no freeness added.

## 5. Zero kernel and the polar unitary

Set `A=s*s`, so `0<=A<=4`. For `d>=1`, the coordinate moment
`tau((s_r*s_r)^d)` is `r^(-d)` times the number of identity words
with alternating signs `-,+,...,-,+` on `2d` positions.
Stack cancellation gives a noncrossing perfect matching, so there
are at most `d` labels. Assignments with at most `d-1` labels are
bounded by

    sum_{j=1}^{d-1} r^j j^(2d) = O_d(r^(d-1)).

For exactly `d` labels, each occurs twice, and hence determines its
pair uniquely. A noncrossing perfect matching has endpoints of
opposite parity: its interior is itself perfectly matched. Thus
all pairs have opposite signs in the alternating string, and distinct
labels on its pairs give an identity word. The leading count is exactly
`C_d (r)_d`, where `C_d` counts the noncrossing perfect matchings.
The first partner recurrence gives `C_0=1` and
`C_d=sum_{j=0}^{d-1} C_j C_{d-1-j}=binomial(2d,d)/(d+1)`.
Thus `tau_hat(A^d)=C_d`.

The probability density

    dnu(x) = (1/(2*pi)) sqrt((4-x)/x) 1_(0,4)(x) dx

has these moments: substituting `x=4t` gives
`4^(d+1)/(2*pi) B(d+1/2,3/2)=(2d)!/[d!(d+1)!]`,
including `d=0`. Both measures are supported on `[0,4]`;
polynomial density in the continuous functions determines the measure
uniquely. Hence this is the spectral distribution of `A`.
It has no atom at zero. Faithfulness implies `ker A=0`.
In `s=V A^(1/2)`, this makes `V*V=1`; finiteness and the faithful
trace give `VV*=1`, so `V` is unitary.

For `epsilon>0`, put

    x_epsilon=s(A+epsilon)^(-1/2)
             =V [A/(A+epsilon)]^(1/2).

These are contractions. For a scalar polynomial `p`,
the literal noncommutative ordered expansion of `[s p(A)]^k`
is a linear combination of all products
`[s A^(d_1)] ... [s A^(d_k)]`, so (4.1) applies to it
and, separately, to its adjoint with conjugated coefficients.
Uniformly approximate `(t+epsilon)^(-1/2)` on `[0,4]` by
polynomials and use norm continuity of the bounded map `S`.
This proves

    S(x_epsilon^k)=a x_epsilon^k,
    S((x_epsilon^k)*)=b (x_epsilon^k)*.

Dominated convergence against `nu`, which has no zero atom, gives
`||x_epsilon-V||_2 -> 0`. The exact noncommutative telescoping
identity implies

    ||x_epsilon^k-V^k||_2 <= k ||x_epsilon-V||_2.

All powers are contractions. Bounded-ball 2-continuity of `S`,
along `epsilon=1/n`, therefore gives

    S(V^k)=aV^k, S(V^(-k))=bV^(-k), for every k>=1.     (5.1)

This order of limits is important: first polynomial approximation
for fixed regularization, then 2-norm removal of regularization.

## 6. A quantitative finite-trace spectral theorem

The following estimate proves the last manuscript lemma and also
allows nonzero errors. Let `V` be any unitary in a finite faithfully
tracial von Neumann algebra and `S` any bounded complex-linear map.
Define

    e_k^+ = S(V^k)-aV^k, e_k^- = S(V^(-k))-bV^(-k),
    h_m = sum_{k=1}^m 1/k,
    D_m = sum_{k=1}^m (||e_k^+||+||e_k^-||)/k,
    B = 1+pi, C = B(2||S||+||a||+||b||).

Then for every positive integer `m`,

    ||a-b||_2 <= (C+D_m)/(cos(1) h_m).                 (6.1)

**Proof.** The sine sums `sum_{k=1}^m sin(k theta)/k` are uniformly
bounded by `B`. For angular distance `t in (0,pi]`, sum directly
through `floor(1/t)` using `|sin(kt)|<=kt`, which costs at most one.
Every interval sum of the remaining sines is at most `pi/t`, by
geometric summation and `sin(t/2)>=t/pi`. Abel summation starting
at `p=floor(1/t)+1` costs at most `pi/(tp)<=pi`.
At `t=0` the sum vanishes. This includes the case `floor(1/t)=0`.

Write `H_m(lambda V)=X+iY`, where
`H_m(z)=sum_{k=1}^m z^k/k` and `|lambda|=1`.
Then `||Y||<=B`. Complex linearity, with the adjoint expansion
handled separately, gives

    ||(a-b)X|| <= C+D_m.

Partition the circle into finitely many disjoint half-open arcs of
length at most `1/m`. For one arc let `e` be its spectral projection
and rotate its midpoint to one. On that arc,
`X>=cos(1)h_m`. Borel functional calculus supplies `F`, zero off
the arc, with `XF=e` and `||F||<=1/(cos(1)h_m)`.
Right multiplication by `F`, with no commutation of `a,b`,
gives `||(a-b)e|| <= (C+D_m)/(cos(1)h_m)=delta_m`.
Hence `e(a-b)*(a-b)e<=delta_m^2 e`.
Taking traces and summing the orthogonal spectral projections yields
`||a-b||_2^2 <= delta_m^2 sum rho(e)=delta_m^2`, proving (6.1).
There is no factor equal to the number of arcs.

For the exact identities (5.1), `D_m=0` and `h_m -> infinity`,
so faithfulness gives `a=b`. The constant inclusion `N -> N^omega`
is faithful, giving equality back in `N`. More generally,
`D_m/h_m -> 0` also suffices; uniform errors at most `delta`
in each of the two power identities give
`||a-b||_2 <= 2delta/cos(1)`. These quantitative conclusions
require neither ball continuity of `S` nor a specified spectral
distribution of `V`.

## 7. Adversarial computation and limitations

The rerunnable script uses exact signed free words, not finite matrices
as substitutes for a free Haar family. It checks stack reduction
against an independent adjacent-deletion reducer, cancellation-certificate
reconstruction, all ordered block sign patterns within stated finite
bounds, multiplicity bounds, and the repeated-survivor coefficient
square estimate. It also checks the leading Catalan moment count.
The exact example `g_1 g_2^(-1) g_2 = g_1` explicitly detects
the incorrect strategy of discarding all repeated original labels.
That incorrect strategy is not the staged manuscript's assertion.
More uniformly, in `s_r s_r* s_r` the one-letter multiplicity of each
`g_j` is `2r-1`: either the first two labels agree or the last two
agree, with the all-equal assignment counted twice. Its degree-one
component is therefore `(2-1/r)s_r`. Deleting all original repeated
labels removes this entire component, so the resulting error has
2-norm at least `2-1/r`, not a vanishing error. This excludes that
shortcut for every `r`, not just the displayed three-letter example.

Jacobian discovery and a typed contract were inspected before these
custom counting routines. The available edge-path operation returned
`["e1","e2^-1","e2"]` of length three for the submitted backtracking
path. It therefore supplies edge labels rather than the needed
freely reduced output on this example. Its successful adapter transport
is not mathematical verification of cancellation. No matching
coefficient-count or Catalan-matching contract was found among the
small discovered candidate sets. Exact request, typed output, server
version, and protocol are preserved in dedicated JSON files.

The analytical proof above, the Lean universal theorems, and the
finite executable checks are distinct evidence classes. Independent
review must assess their statement fidelity and the analytic argument;
an exit-zero finite check or compiler alone does not certify the
entire operator-algebra theorem.

## 8. Replay

From the campaign root, run

    $WORKSPACE/argus-live-update/.venv/bin/python verify.py --compile-lean

This obtains a real compiler and axiom-audit verdict through the official
`lean_evidence verify --claim C_BLOCK_CORE` path and then runs both
campaign-local structural checks. Without `--compile-lean`, the script
replays the exact finite regressions and checks the existing compiler
record against the current source and statement-fidelity bytes.
The output `exact_certificate.json` explicitly leaves independent
analytic review and novelty assessment outstanding.
