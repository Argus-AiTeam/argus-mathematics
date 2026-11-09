# Statement fidelity: H_VARIANCE

The declaration `uniform_influence`, fully qualified as
`HypergraphInfluence.uniform_influence`, in `Main.lean`
formalizes the complete variance inequality in `thm:main` of the staged
October 5, 2026 hypergraph manuscript. It is not a finite experiment,
a theorem conditional on a restriction estimate, or the monotone-only
threshold corollary.

## Objects and quantifiers

The theorem has the following quantifier order:

```
for every natural r with 3 <= r,
there exists a real C with 0 < C,
for every natural n with r <= n,
for every real p with 0 < p < 1,
for every f : Config n r -> Bool with IsInvariant f,
variance p f <= C * totalInfluence p f /
  (Real.log (n : Real)) ^ ((r : Real) / ((r : Real) - 1)).
```

Thus `C` depends on `r` only, not on `n`, `p`, or `f`. All reals are
finite reals. The exponent is a real quotient, not natural-number
division. `Real.log` is the natural logarithm. Since `n >= r >= 3`,
its value and the denominator are positive.

`Edge n r` is the subtype `{e : Finset (Fin n) // e.card = r}`.
Its elements are all unordered sets of exactly `r` distinct vertices.
`Config n r` is `Edge n r -> Bool`; every such function is one simple
`r`-uniform hypergraph. Relabeling `Fin n` by `i -> i+1` identifies the
vertex set with the manuscript's `[n]`.

`edgePerm sigma` maps an edge by the vertex permutation `sigma`.
`Reindex.config (edgePerm sigma)` transports a configuration by the
inverse coordinate permutation. `IsInvariant f` requires equality of
`f` before and after this transport for every vertex permutation and
every configuration. Because all permutations are quantified, this is
exactly invariance under all vertex relabelings. There is no increasing,
monotone, nontrivial, or balanced-function hypothesis. Constant functions
and arbitrary nonmonotone invariant Boolean functions are included.

## Product law, variance, and influence

The generic Fourier library defines

```
weight p x = product over edges e of (if x e = true then p else 1-p).
boolReal false = 0; boolReal true = 1.
```

`weight_mass_one` proves that these weights sum to one. For `0<p<1`
they are positive Bernoulli product probabilities.
`fourier p f S` is the actual biased Fourier coefficient of `boolReal`
composed with `f`. Its empty coefficient is the product expectation,
by `coeff_empty`. The definition in `Model.lean` is

```
variance p f =
  sum over configurations x of
    weight p x * (boolReal (f x) - fourier p f empty)^2.
```

This is genuine product-measure variance, not a separately supplied
number or an assumed spectral identity. The explicit local classical
equality instance in this definition only selects an enumeration of a
finite function space; it does not change the probability law.
`variance_eq_mass` derives its nonconstant Fourier representation from
the compiled generic Parseval theorem.

`totalInfluence p f` is the sum over edges of
`OAI.Problem313.Reindex.influence p f e`. The latter sums `weight p x`
over configurations for which
`f(update x e true) != f(update x e false)`. This event does not depend
on `x e`; summing that coordinate contributes `p+(1-p)=1`.
It is therefore exactly the pivotal probability over the other
coordinates. No resampling factor, `p(1-p)` factor, normalization by
the number of edges, or monotonicity identification is built in.
`weighted_mass` proves the separate identity
`sum_S |S| * fourier(S)^2 = p*(1-p)*totalInfluence`.

## Discharged dependencies

`averaged_block` proves the restriction estimate, rather than taking it
as a hypothesis. The free coordinates are **all** edges intersecting
the vertex block. It proves preservation of the exterior assignment,
influence equality along block orbits, and orbit cardinality
`choose(m,j) >= m` for `1 <= j <= r < m`. Restricted Fourier averaging
retains all exterior degrees, and averaged restricted pivotal influences
are the original influences of the free coordinates.

`captured_mass` maps an arbitrary Fourier support injectively to a
simple uniform support and invokes the unchanged, independently accepted
`HypergraphCapture.hypergraph_capture`. Its sampling law is uniform over
all `m`-element vertex subsets. Its cutoff
`L = ((sqrt(p*(1-p))*log(m)/64)/r)^(r/(r-1))` is real, without rounding.
`empty_low_range` proves the empty-sum case `L<1`.
`variance_le_low_add_tail` and `variance_le_dirichlet` are proved for
arbitrary Boolean functions, without symmetry.

`uniform_numerical_parameters` proves the small-`n`/large-`n`
dichotomy used by the final theorem. It chooses the large-`n` block
size independently of the positive real bias parameter: a natural
ceiling of `sqrt n`. This differs from the manuscript's floor but
does not change its conclusion or hypotheses. The analytic tail bound
is uniform for every `0 < sigma <= 1/2`, with no positive lower bound:
it uses `sigma^2 <= sigma^alpha` when `alpha <= 2`. The existence
of a large enough scale and the bound for every remaining `n` are
proved, not external assumptions.

The generic analytic imports are the locally compiled Lean 4.31.0
port of the pinned upstream sources identified in the certificate.
Neither Lean 4.34.1 binaries nor an unproved hypercontractive premise
are used. `#print axioms` in `Main.lean` audits the final theorem and
its load-bearing dependencies; the permitted foundational axioms are
only `propext`, `Classical.choice`, and `Quot.sound`.

The compiler establishes the encoded theorem. The correspondence to
the manuscript and the product-probability interpretation documented
here still require independent human/Reviewer inspection; this document
does not claim that such inspection has already occurred.
