# Multiplicative-shift order theorem

## Scope and source fidelity

The target is `thm:order` in the staged manuscript *Uniform Matrix Hitting
Points in Every Positive Characteristic*, dated October 4, 2026,
`build/sections/order.tex`, lines 18-36. The quantifiers are an arbitrary
field K, a nonzero element tau of infinite multiplicative order, integers
m >= 1 and nu >= 0, polynomial P and Q of degrees at most nu with Q(0) != 0,
and H invertible **over K[[z]]**, not just over K((z)).
The equation is sigma(H) = (P/Q) H, with left multiplication by P/Q.
Both u and v have coefficients in K and are fixed by sigma.
The requested conclusion is ord_z(u H v) <= nu * binom(m,2) whenever
u H v is nonzero.

The shifted-row recurrence printed at lines 91-107 is
R_(j+1) = sigma(R_j) A and N_(j+1) = sigma(N_j) P.
Its order of multiplication agrees with the equation for H.
The denominator is the product of Q(tau^e z), 0 <= e < j.
The proof uses constant-field linear independence, not independence
over K(z), when it selects components of uH.
The comparison at lines 129-141 needs H and H^(-1) to have power-series
entries; invertibility over the Laurent-series field would not suffice.
These are source readings, not independent certificates.

The downstream application is `construction.tex`,
`eq:z-truncation-length` and the paragraph preceding
`eq:rational-hitting`: conditional on word-series independence and
`prop:formula-system`, the bound gives a nonzero coefficient before
N = 1 + n * binom(2s,2). Verifying the order bound alone does not verify
either dependency, coefficient descent, or the complete hitting theorem.

## Prior results and dependencies

The manuscript cites Moura (2003), *Bounds for the Vanishing Order for
Solutions of a Linear Differential System*, DOI 10.1023/A:1022155217548,
and the staged characteristic-zero companion's Section 4, Theorem 4.2.
The latter's `build/multiplicity.tex` was read: its differential argument
uses R_(j+1) = R_j' + R_j P/q and a characteristic-zero Wronskian.
It is not a theorem about multiplicative shifts in arbitrary
characteristic and is not being assumed as a proof of the target.

The cited Bostan--Dumas paper (arXiv:1301.6598v1, Lemmas 1--3) concerns
Wronskians. No external theorem from it or Moura is an assumption of
the proposed independent proof. Their statements have not yet been
independently attributed from the external originals here.
The inherited project wiki has no indexed result about this Casoratian
or this noncommutative hitting construction.

The installed Mathlib API discovery found power-series order, rescaling,
and Vandermonde determinant APIs. It did not find an off-the-shelf
adapted-order basis or general Cauchy--Binet theorem.
Those are formalization obligations, not mathematical failures.

## Independent proof

Put g = uH and let V be the K-linear span of its m component series.
Let S be the set of all finite orders attained by elements of V. Choose
one series of each order in S. These series are linearly independent:
in a nontrivial finite relation, the term of least order has a nonzero
coefficient that no other term can cancel. Thus S is finite. Conversely,
the coefficient map V -> K^S is injective, since the leading coefficient
of a nonzero element occurs at an order in S. The two dimension
inequalities show that the chosen series form a basis w_1,...,w_k,
where k = dim(V) <= m. Write their distinct orders as c_i.
Every nonzero y in V has order in S and therefore at most sum_i c_i.
This construction does not assume that the orders are bounded in advance.

Let W have entries sigma^j(w_i), 0 <= j < k. Factor z^(c_i) from
column i. The constant determinant left over is the product of the
nonzero leading coefficients times the Vandermonde determinant at
tau^(c_i). Injectivity of natural powers of tau makes it nonzero over
every field. Hence ord(det W) = sum_i c_i.

Choose constant matrices A and L expressing g in the w basis and
the w basis in the components of g, respectively. If G has rows
sigma^j(g), these choices give G = W A and W = G L. These are
constant changes of generators, not changes over K(z).

Define polynomial numerator rows N_0 = u,
N_(j+1) = sigma(N_j) P and scalar series
D_0 = 1, D_(j+1) = sigma(D_j) Q. Direct induction on j proves
N_j H = D_j sigma^j(g), with the order of factors unchanged.
Every entry of N_j has polynomial degree at most j*nu.
Every D_j is nonzero, since its constant coefficient is Q(0)^j.
Let N be the k-by-m matrix of these polynomial rows, and let D be
the diagonal matrix with entries D_j. Then N H = D G, so
N (H L) = D W. Its determinant is nonzero.

The proof uses the following unrestricted multilinear expansion, over
any commutative ring, for a k-by-m matrix X and an m-by-k matrix Y:

    det(XY) = sum_(f : {1,...,k} -> {1,...,m})
                  (product_i Y_(f(i),i)) det(X_columns_f).

It follows directly from multilinearity in the columns. Repeated
columns contribute zero. A nonzero determinant of XY therefore
implies that at least one of the displayed minors of X is nonzero.
Apply this to X = N and Y = H L.

Write J = H^(-1), which has power-series entries by hypothesis.
The identity N = (D W) (A J) now gives, for the chosen nonzero minor,

    det(N_columns_f) = det(D W) det((A J)_columns_f).

All factors are power series. Additivity and nonnegativity of their
orders imply ord(det W) <= ord(det(N_columns_f)).
The latter is the order of a nonzero polynomial of degree at most
sum_(j<k) j*nu = nu*binom(k,2). Consequently

    ord(y) <= ord(det W) <= nu*binom(k,2) <= nu*binom(m,2).

This is an independent proof of the complete printed statement.
It avoids assuming minor-valuation invariance: the needed direction
is derived from a factorization and a proved multilinear expansion.
In fact it does not use the degree bound on Q. That is a transparent
strengthening of the argument, not an additional hypothesis or a
claim of priority.

## Lean statement fidelity

`Main.lean` imports the installed Mathlib for Lean 4.31.0 and declares
`MultiplicativeShiftOrder.multiplicative_shift_order`. Its universe
variable K has only the typeclass assumption `Field K`; there is no
characteristic assumption. The indices are `Fin m`, and m and nu
are arbitrary natural numbers, with the printed hypothesis 1 <= m.

The formal scalar is

    sum_i sum_j C(u_i) * H_(i,j) * C(v_j).

Here C embeds constants from K into `PowerSeries K`. Thus its two
vectors are constant, its multiplication order is u H v, and it is
not an arbitrarily chosen entry of an unrelated matrix. The explicit
nonzero hypothesis excludes zero, whose `PowerSeries.order` is top.
The conclusion is its order, in the extended natural numbers, at
most the natural number nu * Nat.choose m 2.

The parameter tau is nonzero and its natural powers are injective.
The separately proved declaration
`infinite_order_iff_injective_powers`, for units of K, equates this
condition with `orderOf tau = 0`, Lean's infinite-order convention.
Thus no finite-order exception has been hidden in the translation.

P has polynomial entries and Q is a polynomial; the formal hypotheses
give `natDegree <= nu` for every entry and Q, and `Q.coeff 0 != 0`.
For the zero polynomial, `natDegree` is zero, which is compatible with
the printed upper bound because nu >= 0.
The matrices H and J have entries in `PowerSeries K` and satisfy
H J = J H = I. These are precisely regular invertibility, not merely
invertibility over the fraction field.

`PowerSeries.rescale tau` has nth coefficient tau^n times the nth
coefficient of its argument, so it is exactly substitution z -> tau*z.
The formal system is the denominator-cleared equation

    Q * rescale(tau,H) = P * H.

Since Q(0) != 0, Q is a power-series unit, so this is equivalent to
the printed sigma(H) = (P/Q)H. The formal theorem assumes neither
a Casoratian conclusion nor a bound, basis, minor, or finite-jet
certificate as input. All such steps are proved in this source.

`exists_order_basis` formalizes the dimension argument for S.
`casoratian_order` formalizes the leading Vandermonde calculation.
The private helpers `det_mul_rect` and `exists_nonzero_minor`
formalize the unrestricted multilinear expansion above.
`numeratorRows_identity` and `numeratorRows_degree` prove the shifted
system and its polynomial bounds. `order_bound_in_span` combines
them, and the public theorem verifies membership of the exact scalar
u H v in V.

The assumptions on the degree of Q, the lower bound on m, the
explicit nonzeroness of tau, and the left-inverse identity are
retained for fidelity although the proof establishes a stronger
statement without using them separately. No additional axiom is
introduced. The source's `#print axioms` exposes the assumptions
of its final declaration.

The official, source-hashed compiler record determines whether this
formalization was actually checked. This document states what that
record means; it does not substitute a prose verdict for a compiler
run. Independent Reviewer confirmation is a separate, required step.
No claim of mathematical novelty or of the complete hitting theorem
is made here.

## Jacobian capability

Discovery used the Argus sidecar, protocol 2025-11-25, Jacobian 0.14.0.
The closest inspected operation,
`formal_series.rational.multiply.compute`, accepts only truncated
rational scalar series of order at most 512. It does not certify
arbitrary fields, matrix systems, Casoratians, or the universal bound.
The dedicated payload and typed output record only one bounded
arithmetic cross-check on a rational sharp example; they are not
evidence for the universal theorem.
