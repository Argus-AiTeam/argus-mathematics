# Singular-tail core audit

## Scope and source premises

This work addresses the implication from the local planted-law gain bounds
through coercivity, residue classification, and residual span counts to the
singular-tail estimate. It does not certify the manuscript's main theorem or
the other parts of its rank-layer limit.

The target is the staged September 23, 2026 manuscript
`research/openai_manuscript/A-counterexample-to-Sidorenkos-conjecture-September-23-2026/build/sections/`.
The principal sources are `planted.tex`, `tail.tex`, and the rank-layer
statement in `kernel.tex`. Their hypotheses, not a relaxation silently treated
as geometric realizability, determine the question.

The initial ledger contains only the overall campaign objective and no prior
mathematical certificate. The objective calls the upstream Lean coverage
"Partially/Comparator formalized"; that label alone does not establish any
singular-tail assertion. No novelty or upstream formal coverage is inferred
from it.

The comparator documentation `lean/docs/161.md` links
`lean/ComparatorChallenges/SidorenkoCounterexample.lean`. That file defines the
finite incidence graph and the desired host-graph statement, but its `main`
proof is `sorry`. This is a comparator statement, not a certificate for any
singular-tail lemma. No claim is made here about other upstream Lean files.
The local Wiki index search found no relevant singular-tail or Lagrangian
result. The source proofs, rather than unrelated inherited Wiki pages, are
the prior mathematical comparator.

The downstream theorem will explicitly assume the pointwise gains in
`planted.tex`, Proposition `prop:planted-gain` and Lemma
`lem:two-active-gain`, and the probability estimates and pair transitivity in
`orbits.tex`, Lemma `lem:lagrangian-counts` and Proposition
`prop:triple-orbits`. These statements have been read at their local
locators; they are not independently certified by this node. There is no
external literature theorem needed for the downstream algebra. The finite
complex and its six exposure orders will be checked against `complex.tex`.

The manuscript already proves the qualitative singular-tail conclusion and
states the coercivity constant `1/342`, first-cost lattice saving `1/6`,
direct residual exponent, and nondirect remainder `1641`. Re-establishing
those is independent verification, not a claim of novelty. The intended
additional quantitative output is a fully explicit sufficient dimension
threshold replacing the manuscript's unspecified finite maxima. Its
publication significance and novelty remain for independent assessment.

The active route is a universal symbolic certificate, not a bounded
dimension search. A bounded search cannot establish a sufficiently-large
dimension theorem, and relaxed tuples cannot refute geometric realizability.
Those are excluded proof strategies, not exhausted geometric routes.

The exact source-table replay gives face-graph diameter `L=5`. Set

\[
 K=151,\qquad M_*=(302(L+1))^2=3\,283\,344,
\]
\[
 C_*=15M_*^2+3M_*=161\,705\,227\,185\,072,
 \qquad
 D_*=M_*+44C_*+2=7\,115\,029\,999\,426\,514.
\]

The explicit threshold is sufficient, deliberately conservative, and not a
claim about the smallest admissible dimension.

## Theorems and exact quantifiers

**Numerical reduction theorem.** On the source complex, fix any even integer
`D >= D_*` and any activity set. Assign shared nonnegative integer pair
dimensions `h_e <= D` and, on each face, a common dimension `c` with
`h_l=c+s_l`, `s_l>=0`, `d=D-c`, and `sum s_l <= d`.
On a three-active face choose *any* integer tuple with

\[
 \delta=2u-c,\quad 0\le u\le c,\quad s_l=p_l+t_l,\quad
 P=\sum p_l,\quad T=\sum t_l,\quad
 w=(d-3\delta)/2-P+v,
\]
\[
 c\ge|\delta|,\quad P+T\le d,\quad
 p_l,t_l,v\ge0,\quad t_l,v\le p_l+\delta,\quad w\ge0.
\]

Define its gain by the maximand of `eq:planted-gain`, not by assuming
realizability. On a two-active face use `b(floor(h'/2))`, where `h'` is
the active pair's dimension; on other faces use zero. Define

\[
 C_j=(D+1)c_j+\sum_l b(s_l),\qquad
 {\cal C}=\tfrac12\left(\sum_j C_j-\sum_e(1-a_e)b(h_e)\right).
\]

Then `sum_j g_j >= C` implies

\[
 c_j=0,\qquad h_e\in\{0,2\},\qquad
 \sum_jg_j=\tfrac23\sum_e b(h_e).
\]

This theorem is stronger in its domain than a statement about realizable
maximizers: it holds on the necessary-condition relaxation itself. It does
not say the relaxation is realizable.

**Residual count theorem.** For actual independent uniform point
Lagrangians having such a residual profile, let `m` be the number of
nonzero pair spaces. Including the center gains, the nondirect part is
`O_D(q^(-D+1641))`, and the direct part is `O_D(q^(-m))`. The latter
count in fact works for arbitrary prescribed pair-space dimensions before
specializing to `h_e in {0,2}`. Only local endpoint spans must be isotropic;
the total span need not be.

**Conditional singular-tail corollary.** Assume the two recorded upstream
premises, namely the pointwise local-gain bounds and the orbit/profile and
containment estimates. For every fixed even `D >= D_*`,

\[
 \mathbb E\left[
  {\bf1}_{\{\exists e=\{i,k\}:\dim(L_i\cap L_k)>0\}}
  \prod_{(i,j)\in B}J(L_i,Y_j)\right]=O_D(q^{-1/6})
\]

as `q` tends to infinity through odd primes, for every activity set `B`.
The dimension threshold is the same for all `B`. This is a downstream
implication, not an unconditional certification of the upstream premises or
the manuscript's main theorem.

## Proof

### 1. Exposure cost and slack

The checker reads both tables in `complex.tex` directly. Each pair occurs
twice; the six bit classes have valid eleven-face exposure orders covering
all thirteen points; every new face adds one fresh point and shares a pair
with an earlier face. Each face belongs to three classes. A pair with
`rho=3a_e` differing bits is internal in `3-rho` classes.

For one class, first expose its initial triple, at cost `C_j`. At each later
face condition on *all* previously exposed point variables. Its new point
is still independent uniform, and pair transitivity makes its conditional
profile cost `C_j-b(h_e)` for the already exposed parent pair. Subtracting
the costs of all internal pairs, instead of only tree pairs, weakens this
upper bound. If `A` is the full profile event and `A_t` the six class events,
`P(A)^6 <= product_t P(A_t)` since `A` is contained in each `A_t`;
independence between classes is neither asserted nor needed. The
multiplicities just checked give `P(A)=O_D(q^(-C))`.

The selected local gains are pointwise, so center weighting gives
`O_D(q^(sum g_j-C))` without changing that exposure argument. Write

\[
 \beta_j=C_j/2-\tfrac16\sum_{e\subset j}b(h_e),\quad
 S_j=\beta_j-g_j,\quad
 {\cal E}=\tfrac12\sum_e(a_e-\tfrac13)b(h_e)\ge0.
\]

Double pair incidence gives the exact identity
`C-sum g_j=sum S_j+E`.

For a lower-activity face, take `m_0=max s_l` and `h=c+m_0`.
The exact baseline difference is

\[
 \beta-\frac{b(h)}3-\frac{b(c)}6
       -\frac13\sum_{s_l\ne\text{chosen }m_0}b(s_l)
 =\frac c6\left(3d-\sum_l s_l-2m_0\right)\ge0.
\]

Here the sum omits the chosen index, not all tied maxima. The last
parenthesis is `(d-sum s_l)+2(d-m_0)`. For integer `h`,
`b(floor(h/2)) <= b(h)/3` with equality exactly at `h=0,2`.
For `h=2k` the difference is `k(k-1)/6`; for `h=2k+1` it is
`(k+1)(k+2)/6`. Also `b(floor(h/2)) <= h(h+2)/8`. Consequently

\[
 S\ge0,\qquad S\ge h^2/24-h/12.
\]

Equality requires `c=0` and either all pair dimensions zero or one pair
dimension two; in the latter case its two endpoints must be the two active
incidences. These conclusions also cover zero and one active incidence.

### 2. Universal coercivity, including both signs of delta

For a three-active face let `n_l=2p_l-t_l`. Exact substitution gives

\[
\begin{split}
 S={}&\frac{c(d+\delta-1)-\delta(d+2)+2\delta^2}{4}\\
 &+\sum_l\left(\frac{n_l(n_l-1)}6+\delta p_l
                   -\frac c6(p_l+t_l)\right)+vw-b(v).
\end{split}
\]

Let `Q` be its homogeneous quadratic part. Then

\[
 S=Q-c/4-\delta/2-(2P-T)/6-v/2.
\]

All the following inequalities hold for real tuples in the stated cone,
not just dimensions. Put

\[
 A_0=(d-3\delta)/2-P,\quad a=(-A_0)_+,\quad
 v_0=\min(P/3+\delta,(P-T+3\delta)/2).
\]

The constraints give `0<=a<=v_0`: `w>=0` gives `a<=v`,
the three bounds on `v` give `v<=P/3+delta`, and `d>=P+T`
gives `a<=(P-T+3delta)/2`. Both arguments of the minimum are
nonnegative. Completing the square gives
`A_0 v+v^2/2 >= -a^2/2 >= -v_0^2/2`. The exact variance identity

\[
 \frac16\sum_l n_l^2-\frac1{18}(\sum_l n_l)^2
 =\frac1{18}\sum_{l<k}(n_l-n_k)^2
\]

therefore bounds `Q` below by

\[
 H=\frac{c(d+\delta)-\delta d+2\delta^2}{4}
    +\frac{(2P-T)^2}{18}+\delta P-\frac{c(P+T)}6-\frac{v_0^2}{2}.
\]

The coefficient of `c` is
`(d-P-T)/6+(d+3delta)/12 >= 0`. Indeed
`d+3delta=(d-P-T)+(P+3delta-T)+2T`. Hence set `c=|delta|`
to lower this bound.

For `delta>=0`, the result is

\[
 F(T)=3\delta^2/4+(2P-T)^2/18+(5P-T)\delta/6
       -\tfrac12\min(P/3+\delta,(P-T+3\delta)/2)^2.
\]

Its interval is `0<=T<=P+3delta`. The breakpoint is
`B=P/3+delta`, and the last endpoint is `U=P+3delta`. On
`T=B-z`, `z>=0`, the first branch exceeds its breakpoint value by
`z(5P/27+delta/18)+z^2/18`. The second branch is a quadratic
of coefficient `-5/72`, so its difference from its endpoint chord is
`(5/72)(T-B)(U-T)>=0`.

For `delta=-y<0`, put `x=P-3y>=0`; then `0<=T<=x`.
Set `d=P+T` to decrease `H`, since its coefficient is `y/2`.
The resulting expression is

\[
 G(T)=y^2/4+(2x-T)y/3+(2x-T)^2/18
       -\tfrac12\min(x/3,(x-T)/2)^2.
\]

Here `B=x/3`, `U=x`. The first-branch breakpoint difference is
`z(5x/27+y/3)+z^2/18`, and the second branch has the same
nonnegative chord difference as above. The four endpoint margins are:

| Branch value minus the claimed lower bound | Exact nonnegative margin |
|---|---|
| `F(B)-(P^2+delta^2)/18` | `(14P^2+84P delta+27delta^2)/324` |
| `F(U)-(P^2+delta^2)/18` | `(12P delta+25delta^2)/36` |
| `G(B)-(x^2+y^2)/18` | `(14x^2+180xy+63y^2)/324` |
| `G(U)-(x^2+y^2)/18` | `(12xy+7y^2)/36` |

When an interval degenerates, evaluate its common endpoint; no division by
its length is used. The checker verifies the chord identities after
multiplication by that length.

Finally,

\[
 19(P^2+\delta^2)-[P^2+(P+3\delta)^2+\delta^2]
 =16P^2+(P-3\delta)^2\ge0,
\]

and the same identity with `(P,delta)` replaced by `(x,y)` handles
`(x+3y)^2+x^2+y^2`. Since `T` is bounded by the appropriate last
endpoint, these estimates prove
`Q >= (P^2+T^2+delta^2)/342` in both signs, including the zero cases.

### 3. Explicit uniform bound and integer residues

Let `M=max h_e`. On three-active faces, `c<=M`,
`P<=3(M-c)`, `delta<=c`, and `v<=M`. Thus
`S>=Q-3M/2`; in fact the linear loss is at most `3M/2-c/4`.
If `sum S_j+E<=0`, summing over the twenty-two faces gives

\[
 \sum_{j\in J_3}(P_j^2+T_j^2+\delta_j^2)/342
 +\sum_{j\notin J_3}h_j^2/24+{\cal E}\le33M.
\]

Every summand is nonnegative. Since
`151^2=22801 >= 2*342*33=22572` and `151^2>=24*33`,
we have `P_j+T_j<=151 sqrt(M)` on three-active faces and
`h_j<=151 sqrt(M)` on the others.

Suppose `M>M_*=(2K(L+1))^2`, and start at a face containing a
pair of dimension `M`. A face with such a large pair cannot have lower
activity. On a three-active face, every reduced pair dimension is at most
`K sqrt(M)`, so a pair of dimension `h` forces all pairs of that face
to have dimension at least `h-K sqrt(M)`. Along shortest face paths,
induction gives three-active faces and pair dimensions at least
`M-(t+1)K sqrt(M)`. For `t<=L`, this is greater than `M/2`,
and `M/2>K sqrt(M)`; the induction never stops at a lower-activity face.

The distinguished pair `{0,2}` has `a_e=1`. Therefore
`E >= M^2/24`. The budget `E<=33M` would imply `M<=792`,
contradicting `M>M_*>792`. Thus every tuple assignment under consideration
has `M<=M_*`, uniformly in `D` and activity.

Substitute `w` in the exact slack:

\[
 S=A d+R,\qquad A=(c-\delta+2v)/4=(c-u+v)/2.
\]

The polynomial `R` is independent of `d`. In the variables
`c,delta,p_1,p_2,p_3,t_1,t_2,t_3,v`, the sum of absolute coefficients
of its degree-two part is `57/4`, and that of its degree-one part is
`11/4`; the checker expands it exactly. All those variables have absolute
value at most `M_*`. Hence

\[
 |R|\le(57/4)M_*^2+(11/4)M_*
       \le15M_*^2+3M_*=C_*.
\]

As `c,u,v` are integers with `u<=c`, either `A=0` or `A>=1/2`.
If one face has positive `A`, its slack plus all other slacks and `E`
is at least `(D-M_*)/2-22C_* >= 1`, by the definition of `D_*`.
This contradicts the assumed nonpositive total. Thus every three-active
face has `u=c`, `delta=c`, `v=0`. Its exact slack is

\[
 S=3c(c-1)/4+\tfrac16\sum_l[n_l^2+(c-1)n_l+3cp_l].
\]

For `c>=2`, completion of squares bounds this below by
`(c-1)(5c+1)/8>0`. For `c=1` it is `sum(n_l^2+3p_l)/6`,
whose only zero has all `p_l=t_l=0`. For `c=0`, the constraints
give integer `n_l>=p_l>=0`. Each `n_l(n_l-1)` is nonnegative;
its zeros force exactly `(p_l,t_l)=(0,0)` or `(1,1)`.

Together with the lower-activity inequality this makes every slack
nonnegative. Their sum and `E` can be nonpositive only if all vanish.
A zero-slack `c=1` face has all pair dimensions one; across any shared
pair the next face must also be a `c=1` three-active equality face.
Connectivity would give `h_e=1` everywhere, contradicting `E=0` at
the distinguished pair. Consequently all `c_j=0`, all `h_e` are zero
or two, and
`sum g_j=sum beta_j=(2/3)sum b(h_e)`. This proves the numerical
reduction theorem on the entire necessary-condition relaxation.

### 4. Nondirect pair spaces and the strict span inequality

For arbitrary subspaces `H_e` on distinct edges of any simple graph, set
`k=dim(sum H_e)` and `k_i=dim(sum_{e incident i}H_e)`.
In any edge order, its local dimension increment at either endpoint is
at least its global increment: the earlier local span is contained in
the earlier global span. Summing yields `sum k_i>=2k`.

If the family is nondirect, choose an inclusion-minimal nondirect subfamily
`T`, put it first in the order, and let `e` be last in `T`. Write
`delta_*=dim(H_e intersect sum_{f in T-e}H_f)>0`.
An endpoint `i` of `e` misses some other edge of `T`, since distinct
edges of a simple graph cannot contain both endpoints of `e`.
The subfamily visible at `i`, including `e`, is proper in `T` and
therefore direct. Its local last increment is `dim H_e`, while the
global increment is `dim H_e-delta_*`. Every other comparison remains
nonnegative, so

\[
 \sum_i k_i\ge2k+\delta_*\ge2k+1.
\]

This proof includes partial intersections; it does not presume whole
two-spaces coincide or that their total span is isotropic.

For a residual profile with `m` two-spaces, choose an arbitrary global
`k`-space in the `2D`-space and then the `m` two-spaces inside it.
Their count is
`O_D(q^(k(2D-k)+2m(k-2)))`. For fixed actual local dimensions `k_i`,
isotropic local spans have containment probabilities
`O_D(q^(-D k_i+binom(k_i,2)))` independently over endpoints.
Nonisotropic local spans contribute zero. This gives exponent

\[
 -D(\sum_i k_i-2k)-k^2+2mk-4m+\sum_i\binom{k_i}{2}.
\]

The exact degree sequence implies
`sum binom(k_i,2)<=sum binom(2deg(i),2)=618`.
Also `-k^2+2mk=m^2-(k-m)^2<=m^2`.
For `0<=m<=33`,

\[
 1575-(m^2-4m+618)=(33-m)(m+29)\ge0.
\]

The probability is therefore `O_D(q^(-D+1575))`. The total gain is
`2m<=66`, giving the required `O_D(q^(-D+1641))`. Alternatively the
weighted remainder follows directly from
`1641-(m^2-2m+618)=(33-m)(m+31)>=0`.
The stratification uses only finitely many `k<=66` and
`k_i<=2deg(i)`, independently of `D`.

### 5. Direct pair spaces and exact cross-term cancellation

This count works with arbitrary nonnegative integer dimensions `h_e`.
In an edge order, choose ordered bases for `H_e`. A new basis vector
must be orthogonal to earlier vectors of its own space and of every
earlier space sharing an endpoint. Directness makes all these earlier
vectors independent. Nondegeneracy of the ambient symplectic form makes
their orthogonality equations independent, regardless of mutual
orthogonality. With `a` equations there are exactly `q^(2D-a)` choices;
discarding vectors that destroy directness only decreases the count.

Let `e~f` denote distinct adjacent edges, counted as an unordered pair.
Divide by the numbers of ordered bases, of exponents `h_e^2`.
The family-count exponent is at most

\[
 2D\sum_eh_e-\sum_eh_e^2-\sum_e\binom{h_e}{2}
                       -\sum_{e\sim f}h_eh_f.
\]

For a direct family, `k_i=sum_{e incident i}h_e`. Simplicity gives

\[
 \sum_i k_i=2\sum_e h_e,\qquad
 \sum_i\binom{k_i}{2}
   =2\sum_e\binom{h_e}{2}+\sum_{e\sim f}h_eh_f.
\]

Multiplying the independent endpoint containment probabilities cancels
all `D` terms and adjacent-edge cross terms. The remaining exponent is
exactly `-sum_e b(h_e)`. Adding the residual gain leaves
`-(1/3)sum b(h_e)=-m`. For a singular residual profile `m>=1`,
so this saves at least one.

### 6. The first-cost lattice and summation

Every selected gain is integral: `r,u,c,p_l,t_l,v` are integers,
`w=3r'-d-P+v` is integral, and `b(n)` is integral on integers.
Writing `rho_e=3a_e`, we have the exact integer identity

\[
 6({\cal C}-\sum_jg_j)
   =3\sum_jC_j-\sum_e(3-\rho_e)b(h_e)-6\sum_jg_j.
\]

Thus a strictly positive first-cost saving is at least `1/6`.
For all other singular profiles the numerical reduction theorem applies,
and the direct or nondirect residual count saves at least one, since
even `D>=D_*>1641` implies `D>=1642`.

At fixed `D` there are finitely many profiles, activity sets, and local
integer tuples. A profile with a zero face factor contributes zero; otherwise
each three-active face has a nonempty finite union of actual tuples from
which a maximizer can be selected. The source's union over fields selects gains independently
of `q`; there is no need to realize their maximizing tuples simultaneously.
Summing the profile bounds proves the conditional `O_D(q^(-1/6))`
singular-tail corollary. There is no simultaneous limit in `D` and `q`.

## Certificate, adapter result, and limits

Run, from any working directory:

```bash
$WORKSPACE/argus-live-update/.venv/bin/python \
  families/161/first-pass/singular_tail/verify.py
```

The standalone script uses exact SymPy rational polynomial arithmetic.
It checks 46 universal identities, 14 nonnegative-coefficient polynomials,
all six source exposure orders, pair multiplicities, the diameter, exact
integer zero cases, both residual exponent cancellations, the remainder
coefficient bound, and the explicit threshold. The only finite enumerations
are the fixed source complex and the forced zeros `n=0,1`, not ambient
dimensions, fields, profiles, or activity sets. The stored certificate also
retains the source equations, so the read-only replay detects changes to
those equations.

Jacobian discovery and contract inspection preceded custom certificate code.
The matching bounded operation was `polynomial.box.enclosure.compute`,
server `0.14.0`, protocol `2025-11-25`. Its exact payload is in
`jacobian_payload.json`, its typed output in `jacobian_output.json`, and
adapter exit/error information in `jacobian_status.json`. It returned
`[0,125/324]` for the positive-delta breakpoint margin on `[0,1]^2`,
with adapter exit zero and no stderr. Homogeneity or the positive coefficients
extends this one margin to the nonnegative quadrant; the adapter output alone
does not prove the full piecewise unbounded-cone argument. Discovery and the
complete inspected schema are retained separately.

The checker verifies algebra and the fixed finite combinatorial data. The
geometric dimension-increment proof and counting argument above are ordinary
mathematical proofs requiring independent reading; the script is not a
formal proof assistant. No Lean file is added in this phase. Faithful
zero-hole Lean certification remains a dependent phase, not a purported
compiler result.

No false manuscript assertion was found in the audited implication, so no
`F_` refutation claim is manufactured. The local negative slack
`S=-D/4` when all three Lagrangians coincide is checked symbolically and is
already explicitly acknowledged in the source; it is not a refutation.
The claim ledger retains every upstream premise, and the main theorem,
transverse estimate, and activation/pinning nodes remain open.

The meaningful improvement over the source comparator is the explicit
threshold and the independently replayable universal algebra certificate,
not a new counterexample or a claim that the source theorem was previously
unknown. Independent replay, statement fidelity, significance, and novelty
assessment are still required. This is an Engineer handoff, not Reviewer
acceptance or completion of the full publishable campaign.
