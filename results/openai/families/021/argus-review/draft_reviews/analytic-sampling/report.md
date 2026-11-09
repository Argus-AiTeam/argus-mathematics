# Whole-box harmonic measure and distinct-prime sampling

**Engineer assessment: supported conditionally on the explicit upstream
inputs.** The argument retains point-specific incidences, controls the
exception relative to the whole box, and does not choose the list constants
after the bin width.

## Exact claim, versions, and assumptions

`C_INVERSE_SAMPLE` v1/v2/v3 is one unchanged natural assertion in the old
ledger, not three results. Version 2 records `A_SMALL_SIEVE`; version 3 also
records `A_PNT_MERTENS`. The shared natural-statement content reference
does not mean those newly exposed assumptions were independently proved.
The actual source is `9000021/research/inverse_certificate/REPORT.md`,
the harmonic, freezing and sampling paragraphs of "Application to the
manuscript", compared with staged `inverse.tex`, from "From bad triples
to sampled incidences" through `eq:inverse-rich-points`. Both were read.
The manuscript is the September 25, 2026 source, revision
`4eaee87548250b2682affda7d05d947c05554bae`.

In an independent full regular candidate box suppose bad, nonstructured
triples have normalized harmonic mass greater than `sigma`. With
`L=log z`, `w=L/(log L)^2`, `Z=exp(L/log L)`, and `S=S_q`, the claim is
that there exist selected points and a partial prime-point relation with

```
|X|>=S/Z^4, each point has >=c5*n incidences,
sum_p |T_p|<=n*R/L^6, n comparable to xi*R/log R.
```

Every retained incidence remains nonstructured for the whole-box list
already fixed. Constants `c5>0` and `cp=c5/4` precede fixed `xi`; the
large-`z` threshold may depend on `xi`. The active claim is `R_SAMPLING`.

The active ledger explicitly assumes:

* `A_REGULAR_BOXES`: staged `boxes.tex`, Proposition
  `prop:regular-boxes(iv)`, candidate slack, prime ranges and `S_q/q`
  bound; independent choices, disjoint squarefree factors, singleton bins,
  and length `O(log B)`.
* `A_SMALL_SIEVE`: staged `inputs.tex`, Lemma `lem:small-sieve`,
  `small-upper`, for arbitrary classes and progression step coprime to
  primes at most `w`, once its coordinate length exceeds `w^eta`.
* `A_PNT_MERTENS`: the same file's `lem:prime-inputs(i)` and the actual
  bin-count/`M0` uses in `inverse.tex`.
* `A_MERTENS_DENSITY`: the same lemma's product estimate gives
  `V0` comparable to `1/log w`, used explicitly in the exceptional-residue
  average.
* `A_ADDITIVE_LARGE_SIEVE`: `inputs.tex`, `large-sieve-input`, with
  coefficients on an interval and distinct reduced fractions.

The needed source statements were opened. These are source-only assumptions
from an unpublished staged release, without a fabricated canonical
identifier. This is not certification of the full regular-box construction,
fundamental sieve input, or original manuscript.

## Initial cells: whole-box measure, not conditional badness

Unique factorization identifies sorted bin choices with distinct `q`.
For bin multiplicities `m_j` and counts `n_j>=2*m_j`,

```
#Q = product binom(n_j,m_j)
   >= product (n_j/2)^m_j/m_j!
   >= S*exp(-O_xi((log L)^2)) = S/Z^o(1).
```

The total multiplicity is `O(log L)`, so the logarithmic prime-count,
factorial and fixed-width losses have the asserted subpower size.
`log M0=O(w)=o(log Z)` for `M0=product_{t<=w} t`.
Partition by `(q,b_q) mod M0` and value intervals of ratio at most `1+xi`.
The number of cells is `Z^o(1)`. Cells with fewer than `S/Z` points
contain at most `S*Z^(-1+o(1))` points in total. The global variation of
`1/q` is `(1+xi)^O(log L)=Z^o(1)`; divided by `#Q>=S/Z^o(1)`, this
gives discarded normalized harmonic mass `Z^(-1+o(1))`.

Thus some retained initial cell has conditional harmonic bad-triple density
at least `sigma/2`. Inside it the reciprocal weights of each of `p,q,u`
vary by at most `1+xi`; converting the product measure to counting loses
at most `(1+xi)^3<=8`. The resulting counting density is at least
`beta=sigma/16`. This deduction starts with the whole-box measure and
does not replace it by measure conditional on the bad-edge subset.
Descendant choices may be integrated out because the event depends only
on `p,q,u`.

## Freezing and the large-sieve saving

Set `s_p(q)=(a_p-b_q)/q (mod p)` in `[0,p)`. The parent progression is
`b_q+q*(s_p(q)+p*j)` for `j>=0`, with initial hit in `[1,p*q]`.
On a value cell `[Q_-,Q_+]`, freeze its coordinate interval at
`J=floor(Y/(p*Q_+))`. The actual and frozen intervals differ by
`O(xi*J+1)`. Small-prime patterns depend only on `p`, the fixed cell
residues, and `v=s_p(q) mod M0`.

The small-prime upper bound supplies `m<=constant*J*V0`. It also bounds
the freezing error by `O(xi*J*V0)` and, in a specified edge residue, by
`O(xi*J*V0/u)`. Indeed the latter coordinate length is comparable to
`xi*J/u`; the regular-box slack gives `J/U` at least a constant times
`w^(3*a_star/4)`. For each fixed positive `xi`, both required difference
lengths eventually exceed `w^(a_star/2)`. Their progression steps are
coprime to all small primes. The sieve constant is independent of fixed
`xi`, although its eventual applicability threshold is not.

Choosing a sufficiently small upper width `xi_inv` after the fixed
witnessing threshold `delta` ensures a bad edge has frozen discrepancy
greater than `delta'*J*V0/u`, for a fixed `delta'>0`. Let `E_{p,u}(v)`
be those exceptional residues.

Orthogonality gives

```
u*sum_e (m_{e,u}-m/u)^2 = sum_{a=1}^{u-1}|S(a/u)|^2.
```

For distinct edge primes the reduced fractions are distinct and separated
by at least `1/(4*U^2)`. The additive large sieve bounds their total by
`constant*(J+U^2)*m`. Each exceptional residue contributes more than
`(delta'*J*V0)^2/u`; hence

```
average_u |E_{p,u}(v)|/u
 <= constant_xi*(log w)^2*(1/U+U/J)
 <= w^(-a_star/2).
```

Here `U>=w`, `J/U` has the slack above, and logarithms and fixed-`xi`
factors are absorbed by the strictly smaller exponent. Uniformity is in
`p,v` and the cell for each fixed `xi`, not in variable `xi(z)`.
The elementary proof of the large-sieve input was also read: disjoint
arcs of length equal to the separation, the fundamental theorem of
calculus, Parseval and `||T'||_2<=2*pi*(J-1)||T||_2` give the required
order bound. No structure of the survivor sequence beyond interval
support is imposed.

## One sample satisfies both demands

Fix `h1` before `xi` with `a_star*h1/2>12`. If `f(p,q)` is the bad
fraction of edge primes, average density at least `beta` implies at least
a `beta/2` proportion of pairs with `f>=beta/2`. For sufficiently large
`n_u`, an ordered sample of `h1` distinct primes is entirely bad for each
such pair with probability at least `(beta/4)^h1`. Consequently its
sampled-incidence density has expectation at least

```
gamma_inc=(beta/2)*(beta/4)^h1.
```

Refine by `(q,b_q) mod W`, `W=product_i u_i`. For fixed `v mod M0`,
the edge test as a function of `s mod u_i` has invertible coefficient
`-1/p`. Exactly `|E_{p,u_i}(v)|` residues pass. CRT with the pairwise
coprime moduli gives, uniformly in the refinement centers,

```
|T_p| <= K_p
      = (p/M0)*sum_v product_i (|E_{p,u_i}(v)|/u_i)+M0*W.
```

The rounding term follows by counting each allowed residue modulo `M0*W`
in an interval of length `p`; it is not an unjustified relative-density
estimate. Disjoint prime factors make every required inverse legitimate.

Products averaged over distinct ordered samples are at most the products
averaged with replacement times `n_u^h1/(n_u)_{h1}`, tending to one.
Therefore

```
E[K_p/p] <= 2*w^(-a_star*h1/2)+z^(-c'),
E[sum K_p/(n*R)] = o(L^-6).
```

`M0*W=z^o(1)` and `p>=z^alpha_min` justify the last power saving.
Markov bounds the probability of violating the slope budget by `o(1)`.
Incidence density lies in `[0,1]`, so discarding those samples removes
only `o(1)` of its expectation. A single good sample therefore has density
at least `gamma_inc/2` **and** the required budget. Two unrelated samples
were not combined.

There are at most `W^2` refinements. Discarding cells of size below
`S/Z^3` loses at most `W^2/Z^2=o(1)` **relative to the retained initial
cell**, whose size is at least `S/Z`. Some remaining refinement has
incidence density at least `gamma_inc/4`. A `gamma_inc/8=c5` fraction of
its points has at least `c5*n` incidences. Since `c5` is fixed and
positive, their number is at least `c5*S/Z^3>=S/Z^4` eventually.
All these incidences retain the original nonstructured condition.

## Replays, attribution, and unresolved scope

The shared exact replay verifies two CRT-center counts, 39 and 38, against
the center-independent bound `14742363/2210`, including rounding 6630.
It also verifies the illustrative constants `h1=2401`, `a_star=1/100`,
`gamma_inc=2^-16813`, `c5=2^-16816`, `cp=2^-16818`.
These finite checks do not prove prime distribution, the large sieve,
harmonic asymptotics, or existence above a practical finite threshold.
The real Python/toolchain record is in
[finite-rigidity/report.md](../finite-rigidity/report.md).
There is no Lean formalization of this sampling argument.

The old argument is a reconstruction of the staged manuscript's sampling
proof, not a newly established theorem. No concrete logical gap was found
in the transfers above under the recorded inputs. The unresolved obligation
for an **unconditional global** claim is proving those upstream box and
analytic hypotheses, together with the other global manuscript dependencies;
the absence of that certification is not a refutation. Native independent
review of this conditional assessment is still required.
