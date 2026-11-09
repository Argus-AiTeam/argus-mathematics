# Uniform bounds for every relevant competitor

**Assessment:** `L_LC_SUBLEVEL` v1 is supported for the quasi-monomial
sublevel competitors in the written proof, not merely for a selected
sequence of minimizers. Its use in exact realization is not circular.

## Exact statement and inherited hypotheses

On the fixed complex positive-dimensional Q-Gorenstein klt germ, put
`e=A_X-v(Psi)>=0`. `Psi` is an effective rational lc Cartier boundary
with a centred zero-defect ray. On a fixed adapted resolution let
`r=r_F(v)`. The heights are
`b_eta=alpha*A_X+sum beta_i*v(g_i)` for finitely many fixed functions.
The coefficient family `K` is compact and every height is positive on
**all** nonzero `A_X=1` lc rays, including noncentred faces. The
perturbations are uniformly effective; their resolved discrepancies
are positive for sufficiently small parameters.

For `A_X(v)=1`, every centred quasi-monomial competitor satisfying

```
(e(v)+lambda*b_eta(v))*vol(v)^(1/n) <= lambda*M0
```

has `e=O(lambda)`, bounded volume, and uniformly positive
`v(m),r(m)`, simultaneously in `v,eta` and small positive `lambda`.
The constants do not depend on a test function. This is the precise
domain of `verification.md:302-344`. The short ledger statement omits
the quasi-monomial qualifier; the proof does not establish a separate
all-valuations extension.

`M0` is chosen from one fixed centred lc ray; it is not chosen from an
assumed constrained minimizer. Actual ordinary klt minimizers belong to
this sublevel by comparison with that ray and are quasi-monomial by
the imported theorem.

## Decisive chain of estimates

First, klt is checked on the fixed log resolution. The numerator of
the perturbed discrepancy has residual coefficient `1+lambda*alpha`
and component coefficients `delta_i+lambda*b_eta(E_i)`. The positive
`delta_i` stay positive uniformly because there are finitely many and
the height coefficients are bounded. For zero `delta_i`, positivity
on all normalized lc faces supplies a uniform positive lower bound.
Effectivity is a separate hypothesis, not a consequence of this test.

Bare-germ Izumi on `A_X=1` gives `v(f)<=C*ord_m(f)`. Consequently
`a_t(v)` is contained in an appropriate `m`-power and Hilbert--Samuel
growth gives `vol(v)^(1/n)>=c>0`. The same Izumi bound on finitely many
fixed equations gives `|b_eta(v)|<=H1`. The sublevel inequality then
yields

```
e(v) <= lambda*(M0/c+H1).
```

Component formulas, independent of the all-functions comparison, give
`1-H*e<=A_X(r)<=1` and height loss at most `D*e`. For small `lambda`,
`r` is nontrivial. Its normalized ray lies in the compact lc skeleton,
possibly at first on a noncentred face. The assumed face positivity
therefore gives uniform `beta<=b_eta(r)<=B`, and then
`b_eta(v)>=beta/2`. This explains why positivity only on centred rays
would not be an adequate substitute.

The sublevel bound now gives
`vol(v)^(1/n)<=2*M0/beta`. Li's **bare-germ** properness
`A_X(v)^n*vol(v)>=c'/v(m)` bounds `v(m)` below. The fixed resolved
maximal-ideal formula gives
`0<=v(m)-r(m)<=H*e`, so `r(m)` too is bounded below for small
`lambda`. Only at this point are the hypotheses of `L_LC_ALL`
available. Thus the proof does not assume the centering or comparison
it is trying to prove.

## Attribution, previous review and limits

The same sublevel argument occurs in the Cartier manuscript's proof of
`thm:E-exact-minimizer`; the old formulation makes compact-family
uniformity explicit. Its originality as a strengthening was not
established by the old lookup and is not asserted here.

Prior independent support
`judgement-L_LC_SUBLEVEL-11779a72c805` binds the exact v1 claim hash to
the unchanged proof draft. The graph's open node is a workflow label,
not a conflicting mathematical argument. This review reuses the
judgment after checking the estimates above; it does not self-accept.

Dependencies are the fixed-model discrepancy/retraction formulas,
Li's Izumi and properness results (`arxiv:1511.08164v4`, Theorem 3.1,
Theorem 1.1 and Corollary 4.3), the volume-length limit, and the
quasi-monomiality of actual minimizers. No Lean declaration encodes
this chain. No new computation is needed to certify an analytic
uniformity argument.

There is no identified missing step in the stated working domain.
Two extensions are not established: allowing arbitrary non-quasi-monomial
competitors, or dropping positivity at noncentred faces. Neither is
needed for the rational bridge actually proved.
