# Reading of `Main.lean`

Claim `C_NG_ALG`, not claim `C_NG`, is the statement certified by Lean.
All scalar variables are real numbers. Finite sums are genuinely arbitrary:
the number of Cartier layers is any natural number, and the variance and
mixture declarations quantify over any finite type. There is no bounded
enumeration and no assertion that a sheaf is represented by a sampled tuple.

`NongradedObstruction.layer_quadratic_nonneg` proves, for every natural k
and every sequence with 0 <= n(j) <= N,

    N sum_{j<k} (2j+1)n(j) - (sum_{j<k} n(j))^2 >= 0.

No decrease or positivity of the layer ranks is assumed. The bounds on every
natural index lose no finite case: extend a finite sequence by zero. The
declaration `layer_chern_nonneg` allows the second Chern-character numerator
to exceed the rank-only lower bound. Geometrically, N is a rank, n(j) is a
quotient-layer rank, and d is twice the second Chern character after twisting.
Obtaining those facts from coherent sheaves is proved in `REPORT.md`, not Lean.

`centered_sum` and `variance_identity` give the weighted square identities.
`weighted_variance_bound` assumes nonnegative weights summing to one and
real values between a and b, and proves variance <= (b-a)^2/4.
`weighted_variance_strict` additionally assumes a <= b and b-a < 1 and
proves variance < 1/4, including a one-factor or zero-width interval.
The weights are NOT assumed equal. `mixture_identity` proves the exact
mixture identity for normalized first and second Chern characters; positivity
is unnecessary for that identity.

`potential_increment` proves the lower bound p(k) >= p(0)+k/r for a sequence
whose successive increments are at least 1/r. `no_infinite_modifications`
assumes r>0 and excludes any such infinite real sequence bounded above.
The sheaf-theoretic increment and upper bound are separate prose obligations.

`rr_variance_identity` is the identity obtained by equating the linear and
constant terms in the two surface Euler polynomials. Here chi is chi(O_X),
h=H^2, u is the factor rank, mu its normalized slope, k=K_X.H,
ch=ch_2(G), and gk=c_1(G).K_X. The displayed nonzero-denominator hypotheses
are sufficient; this declaration does NOT assert Riemann--Roch or Bogomolov.
`noether_identity` uses the explicitly assumed scalar identity
12 chi=K2+c2 and h != 0; it does NOT prove Noether's geometric theorem.

`factor_upper_bound` proves the complete scalar upper-bound step, not
just an identity: h>0, 12 chi=K2+c2, e<=s, and
h(s-t+K2/4)<=(z-k/2)^2 imply that the right side of the
Riemann--Roch variance identity is <=1/4-(K2-2c2)/(12h).
The interpretation is e=2 ch_2(G)/u, s=(c_1(G)/u)^2,
t=(c_1(G)/u).K, z=(c_1(G)/u).H, and k=K.H.
Thus e<=s is precisely Bogomolov and the other inequality is precisely
Hodge for c_1(G)/u-K/2. Neither surface theorem is proved by Lean.

`obstruction_assembly` assumes h>0, 0<=v, and
v<=1/4-c/(12h)+variance and proves c<=(3+12 variance)h.
`strict_obstruction_assembly` adds variance<1/4 and proves c<6h.
In the geometric application c=K_X^2-2c_2(X). The conclusion is universal
real algebra, not a proof of the existence, restriction, modification,
or finite-pushforward properties of an arbitrary MCM module.

`full_numeric_obstruction` combines the universal ingredients without
assuming either the lattice inequality v>=0 or the desired conclusion.
It quantifies over any number of layers and any finite factor type.
Its hypotheses are N,h>0, 0<=n(j)<=N, d>=sum(2j+1)n(j),
nonnegative normalized weights, sum w*m=(sum n)/N,
2 sum w*q=d/N, a common factor-mean interval of width <1, and the
individual factor inequalities. It derives the lattice lower bound
and weighted-mixture upper bound internally and proves c<6h.
Here d=2 ch_2(F), m_i=c_1(f_*G_i)/rank(f_*G_i), and
q_i=ch_2(f_*G_i)/rank(f_*G_i), with a simultaneous integral twist
allowed to put the lattice inside O^N. The geometric proof explains
why such a twist leaves slope width and each variance unchanged.
Individual factor inequalities are supplied by `factor_upper_bound`
after the geometric Riemann--Roch identities and the external
Bogomolov/Hodge/Noether hypotheses. All identifications with actual
sheaves remain independent prose obligations.

The geometric theorem `C_NG` additionally depends on `C_NG_MODEL`,
`C_NG_BALANCE`, `C_NG_LATTICE`, and `C_NG_FACTOR`, proved in `REPORT.md`
using the external commutative-algebra and surface theorems recorded in the
ledger. These obligations remain subject to independent human review.
Compilation alone must never be reported as a kernel proof of `C_NG`.
