# Statement fidelity: recurrent jet decay

This document describes claim `C_RJD_FORMAL`, not the complete geometric
theorem `C_RJD_BRIDGE`. All declarations are in namespace
`RecurrentJetDecay` in `Main.lean`. They quantify over arbitrary real
parameters and unbounded natural orders; there is no finite-order search.

`uniform_jet_decay` takes positive stable/unstable rates `bs, bu`, a
nonnegative fixed-degree transport exponent `D`, a real growth exponent
`A`, any positive natural parameter degree `k`, a loss `0 < eta < 1`,
and a real sequence `a j n`. In the analytic application, `a j n` is
the supremum norm of the order-`j` stable derivative of `G_{n,k}`.
The theorem does not require nonnegativity because its conclusion is
an upper bound and the analytic application already has it.

The two explicit hypotheses are the following analytic estimates:

1. For every `0 < epsilon <= 1` and every positive natural Taylor
   order `p`, the value sequence has a positive, order-dependent
   constant multiplying
   `exp(-(bu*k-D*epsilon)*n) + exp((A-bs*epsilon*p/8)*n)`.
2. Whenever the value sequence has exponential rate `beta`, the
   order-`j` sequence has the interior interpolation rate
   `beta*(1-j/q)-A*j/q`, plus the value-rate term, for every natural
   `q > j`, again with a positive order-dependent constant.

The conclusion is: for every natural `j` there is a positive constant
independent of every natural time `n` such that
`a j n <= C * exp(-((1-eta)*bu*k)*n)`. Here `k` and `j` are unbounded;
constants may depend on them. Taking `eta = 1-c/bu` gives every
`0 < c < bu`. The hypotheses use one `A` at every interpolation
order. Replacing it by an order-dependent `A_q` changes the theorem.

`choose_sampling_scale`, `choose_taylor_order`,
`choose_interpolation_order`, and `interpolation_budget` give the
positive sampling scale, finite integer orders, and rate comparisons
used by that theorem. The scale may depend on `D`, `k`, and the loss.

`sampling_to_values` and `interpolation_to_derivatives` prove the
corresponding implications for all natural times, with the constants
and exponential inequalities included, not just comparisons of rates.

`degree_weight_product` proves, for every finite list of natural
parameter degrees, that multiplying their exponential weights gives
the weight of their sum. The list is arbitrary; neither its length
nor its entries are bounded. This is the degree accounting needed
when composing a finite truncation with a smooth one-step map.

`choose_actualization_cutoff` proves that every positive decay rate
`c` and every real fixed-order costs `A, B` and requested rate `L`
admit a natural cutoff `R` with
`L < (c*(R+1)-A-B)/2`. It does not construct the geometric limit.

The formalization does NOT establish the analytic sample estimate,
the interpolation inequality itself, local product measure/absolute
continuity, finite-jet equivariance, or convergence of manifold-valued
approximants. The separate mathematical proofs in `report.md`
establish those conditional analytic implications and apply them to
the manuscript's stated inputs. Upstream hull/algebra constructions,
stable tangency, the ideal-boundary contradiction, and the full
entropy-rigidity theorem are not formalized or certified here.

The only imported library is Mathlib. There are no additional axioms,
proof holes, or declarations of assumed results in this source.
