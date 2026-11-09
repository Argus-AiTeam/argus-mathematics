# Statement fidelity: the exact algebraic bridge

This document describes the declarations in `Main.lean`, namespace
`HellingerPairAudit`. It does not claim that Lean checks the interval
program, concavity, region coverage, or the whole scalar lemma.

All scalar variables are arbitrary real numbers. `g0,gd,ge,g1` denote
the four values `G(p0),G(p_delta),G(p_(1-delta)),G(p1)`, but the
formal algebra allows arbitrary values, so it requires no smoothness
or concavity of `G`. The spacing `z` denotes `p1-p0`, and `delta`
denotes the interpolation weight. Translating every node by `p0`
does not change any node distance.

`pairD` is exactly `(gd+ge-g0-g1)/2`. `pairK` is minus one eighth
of the sum of the two second divided differences. For nodes
`p0,p_delta,p1`, the successive distances are `delta*z`,
`(1-delta)*z`, and `z`; for `p0,p_(1-delta),p1` the first two
are interchanged. The explicit expression in `pairK` preserves this
order. In particular it is not the negated or rescaled curvature
from the reflected endpoint parametrization.

`deficit_normalization` quantifies over all six real inputs with
`delta!=0`, `1-delta!=0`, and `z!=0`, and proves
`D=4*delta*(1-delta)*z^2*K`. `shear_normalization` quantifies over
all four real inputs with `z!=0,L!=0` and proves
`z-(g1-g0)/(4L)=z*(1-((g1-g0)/z)/(4L))`.

`quadratic_gap_factorization` is an unconditional polynomial identity
for seven arbitrary real inputs. Its symbol `s2` means the scalar
`s^2`, not the scalar `s`; no positivity is needed for this identity.

`original_pair_of_normalized_gap` assumes `0<delta<1`, `z>0`,
`L!=0`, and strictly positive

    K*(S+Lambda*D)-mu*(1-((g1-g0)/z)/(4L))^2.

It proves the strict original quadratic inequality with noise factor
`4*delta*(1-delta)`. The real inputs `mu,Lambda,S` have no other
hypotheses. In the application `S=alpha*G(p1)+(1-alpha)*G(p0)`;
that specialization is not needed for this algebra.

The positive-gap hypothesis is substantive and is NOT proved in
Lean. It is supplied by the independent normalized interval signs
and the analytic bridge in `PROOF.md`. The separate assertion
`D>=0` is NOT a conclusion of this formalization: the prose proof
derives it from repeated-node endpoint signs and strict concavity.

Repeated original endpoints (`z=0`), zero noise, and singular
probability endpoints are not passed to divisions by zero. The first
two are handled directly in the prose theorem, and distinct pairs
including a probability endpoint still have `z>0` and the positive
node distances encoded here. Therefore the abstract algebra applies
to those distinct boundary pairs without requiring derivatives of
`G` there.
