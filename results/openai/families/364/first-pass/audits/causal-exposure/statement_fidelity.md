# Statement fidelity: L_CAUSAL_CORE

The source is `research/audits/causal-exposure/Main.lean`, namespace
`CausalExposure`. It uses Lean/Mathlib without additional axioms or proof holes.
Its claim is only the universal finite algebraic/combinatorial core, not
Proposition `exp:exposure`.

## Dormant translation algebra

For every additive commutative group `V`, every index type `A`, every
relative configuration `q : A -> V`, and any `i,l : A`,
`install anchor q i l = anchor + q l - q i`.
`install_gauge_invariant` says that adding one common vector to every
relative position does not change installed positions.
`install_recovers` assumes the exact contact equation
`anchor = c + q i` and concludes `install anchor q i l = c + q l`.
For the manuscript, `anchor` is `x_j(t) + epsilon*n`, not `x_j(t)`.
`relative_merge_recovers` is the analogous exact two-component contact
translation identity. None of these declarations proves that a
Hamiltonian trajectory actually has the assumed contact equation.

## Coordinate dependence

`AgreesOn S u v` means that environments `u,v : I -> Omega` agree at every
coordinate in `S`. `SupportedBy S f` means that such agreement forces
`f u = f v`. The sets and types are arbitrary; no probability law is encoded.
The fixed exterior coordinate `xi` is held fixed when this definition is
applied to the selected-block environment.

`supported_install` derives support of installed positions from support of
the anchor and the entire relative configuration. It does not silently
assume relative configurations of dormant components have this support.
`Update` explicitly requires `depends_only_on_reads`, saying that a state update, for
fixed input state, reads only its declared coordinate set.
`run_supported` proves by induction that an arbitrary finite update list
reads only the initial support and the union of those declared sets.
Consequently this is a noninterference theorem **conditional on the local
support specifications**, not a compiler verification that the manuscript's
concrete ODE updates satisfy them. That semantic obligation remains an
analytic proof obligation in `report.md`.

## Exposure counts

For every type with decidable equality, `fresh_disjoint` proves that newly
requested coordinates after subtracting `seen` are disjoint from `seen`;
`fresh_cap` preserves a size-at-most-two bound. `exposure_count` quantifies
over an arbitrary finite set `K` and arbitrary list of finite sets `Bs`.
If `K` is covered by their union and each has cardinality at most two,
it concludes `K.card <= 2 * Bs.length`. There is no finite enumeration bound
and no independence premise hidden in this cardinality statement.
It does not prove that actual trajectory contacts induce such a covering
list, or prove a measure/product bound.

## Flux identity

`contact_flux_numerator` holds over every commutative ring for six arbitrary
elements `e,u,v,x,y,z`. It is the exact determinant of the polynomial
matrix in `jacobian_payload.json`. Over the reals, putting
`D = 1+u^2+v^2`, the two latter columns are `e*D^2` times the derivatives
of `n(u,v) = (2u,2v,1-u^2-v^2)/D`. Dividing the polynomial identity by
`D^4` gives `det[w,e*n_u,e*n_v] = e^2 (w dot n) 4/D^2`.
That division, the area element `4/D^2`, and the area formula are
explained analytically in the report; they are not Lean declarations.

## Power-complexity parameter core

`powerEta B alpha` is the real number `alpha / (800 * (3*B+1))`.
`power_eta_pos` assumes `1 <= B` and `0 < alpha` and proves this
number positive. `power_eta_budget` assumes only `1 <= B` and proves
`(3*B+1) * powerEta B alpha = alpha/800` for every real `alpha`.

`power_budget_bounds` quantifies over arbitrary real `B,alpha,eta`.
It assumes `1 <= B`, `alpha <= 1`, `0 <= eta`, and
`(3*B+1)*eta <= alpha/800`. Its three conclusions are
`23/2400 <= 1/100-B*eta`, `239/2400 <= 1/10-B*eta`, and
`(2*B+alpha*B/2)*eta-alpha/200 <= -3*alpha/800`.
The assumption `alpha > 0`, used for a strictly positive decay
exponent in Theorem PCE, is not needed for this weak inequality;
the budget already forces `alpha >= 0`.

These are universal ordered-field inequalities, not a finite grid
search. They certify the scalar exponent accounting in (11)--(13)
of the report. They do not prove the existence of the coarse
constant `B`, its independence from the mesh count, or any of
the analytic estimates to which these scalar parameters are applied.

## What this compilation cannot establish

The file contains no ODE, Hamiltonian flow, scattering map, Haar probability,
surface integral, source norm, epsilon limit, chronological first-contact
search, or continuous tube estimate. A successful compiler run therefore
certifies L_CAUSAL_CORE only. It cannot confer `closed_kernel` on
P_EXPOSURE, P_REPLAY_AGREEMENT, P_FRESH_BLOCK, V_POWER_EXPOSURE_001, or
either manuscript's main theorem. The natural-language interpretation and the concrete semantic
bridge require independent review.
