# Statement fidelity: universal hard-core pressure coefficients

`Main.lean` uses Lean 4.31.0 and Mathlib. Its main declarations are
`PressureCore.hard_core_pressure_nonnegative` and
`PressureCore.monomial_pressure_nonnegative`.

## Objects and quantifiers

`V` is an arbitrary type of site labels. A site polynomial is an element of
`MvPolynomial V Real`. `Series V` is a univariate formal power series in an
additional grading variable, here called `t`, with those site polynomials as
coefficients. Neither the order in `t` nor any site multiplicity is bounded.
`PolyNN` means that every real monomial coefficient is nonnegative;
`SeriesNN` applies that condition to every coefficient in `t`.

`P` is an arbitrary type of polymer labels with decidable equality, and
`s : Finset P` is an arbitrary finite collection. `rel` is an arbitrary
decidable symmetric **compatibility** relation. Its diagonal is irrelevant:
`Compatible rel T` tests `rel p q` only for distinct members of `T`.
`partition rel activity s` is defined by the actual finite sum

    Z_s = sum over compatible T subset s of product_{p in T} (-activity p).

Thus it is the negative-activity hard-core partition series, not a series
defined by declaring its logarithmic coefficients positive.

## Hypotheses and conclusions

`hard_core_pressure_nonnegative` assumes that every activity is a formal
series with zero constant coefficient in `t` and with nonnegative
coefficients in both `t` and the site variables. It proves that the actual
formal negative logarithm `-PowerSeries.logOf Z_s` has the same coefficient
nonnegativity. The logarithm is Mathlib's substitution of the formal
`log(1+X)` series at `Z_s-1`. The proof establishes `Z_s(0)=1`, the
finite-polymer deletion identity, nonnegative coefficients of every
induced-subsystem ratio `Z_T/Z_s` for `T subset s`, and the logarithmic
derivative identity. It does not assume any of these identities as a
hypothesis.

`monomial_pressure_nonnegative` specializes each activity to

    amplitude(p) * t^(degree(p)) * x^(site(p)),

where `amplitude(p)` is any nonnegative real number, `degree(p)` is any
strictly positive integer, and `site(p)` is any finitely supported
nonnegative-integer site multiindex. For every `n` and every `m`, it proves
that the coefficient of `t^n x^m` in `-log Z_s` is nonnegative. In particular,
`m` is not squarefree, and may contain arbitrarily many repetitions.

The auxiliary inverse `inv1 f` is `invOfUnit f 1`. It is used as a
multiplicative inverse only after proving that the constant term of `f` is
one. `geometric_nonnegative` by itself concerns the coefficients produced
by that definition; all uses as `1/(1-a)` additionally establish `a(0)=0`.

## Relation to the manuscript

For a simple FK graph, put `gamma_i = product_{e incident i}(1+v_e)^(-1)`
and define the rescaled polynomial

    Ftilde_H(y) = F_H((y_i/gamma_i)_i).

The standalone proof in `report.md` establishes, for every admissible
finite FK graph after removing loops and combining parallel edges,
the exact identity

    Ftilde_H(t y) = Z_s,

with polymers the nonempty connected vertex subsets, compatibility equal
to disjointness, degree equal to support cardinality, and amplitude

    lambda(S) =
      -sum_{D subset E(H[S]), (S,D) connected}
          v_D * Z((S,D); -u, 1+v).

The amplitudes are nonnegative by the connected negative-parameter
partition argument proved in the report. The finite diagnostics compare
the graph expressions independently but are not the reason the universal
identity holds. Taking `n=|m|` in the formal theorem then gives the
manuscript's unrestricted logarithmic coefficient signs. The positive
incident rescaling from `y` to `x` preserves the signs.

**Kernel boundary:** Lean checks the complete generic hard-core
coefficient mechanism, including the actual finite partition sum and
formal logarithm, for all activities, sizes, degrees and site
multiindices stated above. The FK-to-polymer identity, the connected
negative-parameter Tutte sign proof, connected site support, analytic
convergence beyond the unit polydisk, and the hub/planar-duality deduction
of Rayleigh are proved in prose in `report.md`, not encoded as Lean graph
or analytic theorems. In particular this source is not a formalization of
interface convergence, nor an unconditional kernel proof of all the
manuscript's assertions. The independent Reviewer must check those
reductions and this reading.

No mathematical axiom, unproved hypothesis about FK coefficients,
proof placeholder or external literature theorem is added to the Lean
environment.
