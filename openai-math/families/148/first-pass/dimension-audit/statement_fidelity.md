# Statement fidelity: dimension-formula verification

## The manuscript claim

`C_DIMENSION_FORMULA` quantifies over every finite nonempty **indexed** family
`x -> r_i*x+t_i` on the real line, with `0 < |r_i| < 1`, arbitrary real
translations, and every strictly positive probability vector. Its measure is
the Bernoulli coding pushforward. The random walk merges equal complete
affine maps, including the signed slope, before taking Shannon entropy.
Writing `h = lim H(G_n)/n` and `chi = -sum p_i log_2 |r_i|`, the conclusion is

    dim_H(mu) = min(1, h/chi).

Here measure dimension is the infimum of Hausdorff dimensions of Borel sets
of positive mass. Exact dimensionality makes the full-mass convention
equivalent. Negative and unequal contractions, duplicate indexed generators,
exact word collisions, zero entropy, and both `h = chi` and `h > chi` are
included. There is no arithmetic or effective separation hypothesis.

The complete argument is in `proof.md`. It uses the unchanged, independently
reviewed `research/pair-bound/` theorem and Feng-Hu Theorem 2.8 for exact
dimensionality. It does **not** assume an entropy-rate dimension formula,
projection-entropy identification, conditional-tail nonsaturation, independence
after observing a sum, or a bound on the finest positive separation.

## Precisely what the new Lean source proves

`Main.lean` imports only Mathlib. Its namespace is
`DimensionWindowCertificate`. It proves `L_DIMENSION_WINDOW_CORE`, not the
analytic self-similar dimension theorem.

`ceiling_increment` quantifies over arbitrary real `s,t`, with no positivity
or order assumption, and proves `ceil(t)-ceil(s) <= t-s+1` in the reals.
`adjusted_depth_antitone` takes an arbitrary nondecreasing real depth sequence
on the natural numbers and any real target `L`; the adjusted depths
`L-ceil(sigma_j)` are nonincreasing.

`finer_window_before_coarser` takes such a sequence, arbitrary natural starts
`j,k` and length `n`, and real `a,B,C,L`. Its hypotheses are exactly a fine
start depth at least `a`, a depth increment at most `C`, the strict
separation `B < a-C-1`, and a coarse start depth at most `B`. Its conclusion
is the strict index inequality `j+n < k`. In the manuscript instantiate
`C = A'*n`. No randomness or independence is assumed.

`ordered_window_gain_bound` quantifies over every real nonnegative antitone
sequence `g`, every finite list of natural endpoint pairs, and every natural
starting index `s`. Every listed left endpoint is at least `s`; every earlier
right endpoint is at most every later left endpoint. It proves that the sum
of the listed decrements is at most `g(s)`. Actual half-open retained windows
satisfy these hypotheses. No independence or probabilistic average is encoded.

`target_recovery` uses integers `U,z,a,b,ell`, with `1<=a`, `0<=z<=U`,
`b<U`, and `a<=ell<=b`. It proves the existence and uniqueness of the target
`1<=L<=2*U` satisfying `L-z=ell`. This is the manuscript's even `T=2*U`
target correspondence, including both band endpoints.

`candidate_mass_bound` takes arbitrary real `D,n,T`, with `D,n` positive,
and proves

    T/(2*D) <= (floor(T/(2*D*n))+1)*n.

For positive manuscript `T` and integral `n`, the factor in parentheses is
the number of candidate starts. The theorem itself does not identify a
cardinality; that elementary identification is supplied in `proof.md`.

`eventually_separated` takes arbitrary real `A,A',B`, with `A'<A`. It
produces a natural `N` such that every natural `n>=N` satisfies
`B < ceil(A*n)-A'*n-2`. Consequently any finite collection of previously
chosen upper endpoints can be passed; it assumes no growth control on them.

`no_uniform_positive_band_count` takes arbitrary positive reals `delta,c`
and any real bound `B`. It disproves `forall q : Nat, delta*c*q <= B`.
After the analytic inequalities in the proof, choose `B=8*D*log_2(M)`.

The source contains no user axioms, `sorry`, upstream dimension theorem, or
analytic hypothesis disguised as a formalized final conclusion. The compiler
and axiom audit decide its formal validity. The preceding pair-bound compiler
certificate remains a separate certificate with its original statement
fidelity and independent approval.

## Evidence boundary

The Python replay checks exact rational coding laws, merged collisions, type
conditioning, entropy identities and inequalities via rational log products,
band endpoints, the strict-Jensen example, and finite retained-window
configurations. These are diagnostics, not proofs of universal analytic claims.
The new Lean theorem is universal for its explicitly stated combinatorial
objects. The remaining analysis is proved in prose and requires independent
Reviewer reading; compiling this source does not certify Feng-Hu or the whole
dimension formula.
