# Sparse twist sectors and the remaining complex residue sum

## Result and limitation

Under the analytic inputs of the independently reviewed contour framework,
the **entire real-square-twist sector** satisfies the requested
`O(X^(1+epsilon))` residue budget at `Q=X^(2/21)`.
This includes the sector containing any possible exceptional real zeros.
The proof uses absolute convergence and the individual functional equations;
it uses neither `t<=5/22` nor the diagonal formula (5.1) from the previous note.

The dense sector of nonreal square twists remains uncontrolled. Thus this
is a partial analytic result, not a proof of `t<=19/84`, not an assertion
that any pole exists, and not a verified-new publishable result.

Notation and the meaning of the cofinal grouped limit are those of
`gl4_degree20_residues.md`. In particular `H_(q,chi)` includes the removal
of the q-Euler factor when chi^2=1. The input absolute convergence is the
one proved from the two Rankin-Selberg functions; its finite local part
uses only local unitarity, not the inherited improved local exponent.

## 1. A direct sparse-sector lemma

For arbitrary subsets E_q of the characters modulo each eligible prime
q in [Q,2Q], define

    W_E(Q) = sum_q |E_q|/(q-1).

Restrict the three expressions A, B_left, and R_group in the contour note
to chi in E_q, and call them A_E, B_E, and R_E. The character weights are
still `conjugate(chi(X)^2)/(q-1)`.
Linearity of the finite sums and the common good-height limit gives

    R_E = A_E - B_E.                                      (1.1)

All actual crossed poles, with their full Laurent multiplicities, remain
in R_E. We do not select individual zeros from a character's pole set.

**Lemma.** For any sufficiently small admissible delta>0 and any epsilon>0,

    |R_E(X,Q)|
      << W_E(Q) [ X^(1+epsilon)
                   + X^-delta Q^(10+20*delta) ].           (1.2)

The constants are independent of E_q, X, and Q. In particular, if
`W_E(Q) <<_eta Q^eta` for every eta>0, then at `Q=X^(2/21)`,

    R_E(X,Q) <<_epsilon X^(1+epsilon).                     (1.3)

The subsets may depend on X or on the L-functions. Only their weighted
cardinality enters the estimate.

**Proof.** Absolute convergence of `sum |a(n)| n^(-1-epsilon)` implies

    sum_n |a(n) g(n/X)| << X^(1+epsilon).

Since |chi(n)|<=1, this gives directly

    |A_E(X,Q)| << W_E(Q) X^(1+epsilon).                    (1.4)

There is no use of a local coefficient estimate in (1.4).

For chi^2 nontrivial, the left-line functional equation in the contour
note has the factors

    tau(chi^2)^20 q^(-20s) G_(chi^2)(s) F_(chi^-2)^S(1-s).

The Gauss sum has absolute value sqrt(q). The local Laurent expansion
of G has uniformly bounded sum of absolute coefficients, up to a fixed
polynomial in |Im(s)|; the dual series is uniformly absolutely convergent
on Re(1-s)=1+delta. Thus each left integral has absolute value

    << X^-delta q^(10+20*delta).                          (1.5)

For either character with chi^2=1, the q-depletion polynomial bound
(4.4) in the contour note gives the very same estimate (1.5).
This is the local unitarity bound, not a consequence of t<=5/22.

Multiplying (1.5) by 1/(q-1), summing only over E_q, and using q<=2Q
proves

    |B_E(X,Q)| << W_E(Q) X^-delta Q^(10+20*delta).          (1.6)

The constants attached to the good-height selection do not occur in
(1.4) or (1.6). They are used only to establish (1.1) for the finite
character family, after which the uniform estimates apply.
This proves (1.2).

For (1.3), the exponent of X in the second bracketed term is

    -delta + (2/21)(10+20*delta)
      = 20/21 + 19*delta/21 < 1                           (1.7)

when 0<delta<1/19. Admissible deltas can be chosen arbitrarily small
in the fixed pole-free band from the reviewed contour argument.
Choose the exponent eta in the hypothesis on W_E and the epsilon
in (1.4) smaller than the desired final epsilon. Equation (1.3) follows.
No bound on any individual reciprocal zero derivative was used. QED.

The lemma also applies whenever the total number of selected characters
is `O_eta(Q^(1+eta))` for every eta>0. This is a sufficient cardinality
criterion, not an assertion that a particular zero-density estimate
supplies such a set at all heights.

## 2. Real square twists are a uniformly sparse sector

For an odd prime q, let

    E_real(q) = {chi modulo q : chi^4=1}.

A finite-order character eta=chi^2 is real-valued exactly when eta^2=1.
Therefore E_real is exactly the real-square sector.
The character group is cyclic of order q-1, so

    d_q := |E_real(q)| = gcd(4,q-1) <= 4.                  (2.1)

This includes both imprimitive square characters. When q=1 mod 4,
it also includes the two quartic characters whose square is the
nontrivial quadratic character. When q=3 mod 4, that quadratic
character is not a square, and d_q=2.

Since `sum_(Q<=q<2Q) 1/(q-1) << 1`, even when bounded by all integers
in the interval, `W_real(Q) << 1`. The lemma proves

    R_real(X,X^(2/21)) <<_epsilon X^(1+epsilon).            (2.2)

Thus possible exceptional real zeros do not obstruct the target through
the **total real-twist contribution**. Equation (2.2) does not bound a
single zero's residue separately: cancellation among poles of a selected
twist is allowed by its grouped contour identity.
No zero-free region, simplicity hypothesis, or multiplicity estimate
is needed for (2.2).

### Exact projector and the retained diagonal

For y in F_q^*, write lambda_q for the quadratic character. The real-sector
kernel is

    K_real,q(y) = (1/(q-1)) sum_(chi^4=1) chi(y)^2
                = 2/(q-1),                         q=3 mod 4,
                = 2(1+lambda_q(y))/(q-1),           q=1 mod 4.    (2.3)

To prove (2.3), choose a generator of F_q^* and write y as its k-th power.
The d_q selected characters give the sum
`sum_(a=0)^(d_q-1) exp(2*pi*i*2ak/d_q)`.
For d_q=2 this is 2. For d_q=4 it is `2(1+(-1)^k)`.
This proves the formula for every odd prime, rather than for a finite
sample of primes.

The complementary kernel is

    K_complex,q(y) = 1_(y^2=1) - K_real,q(y).

At y=1 it equals `1-d_q/(q-1)`. Consequently its total diagonal weight is

    N_complex(Q) = N(Q) - W_real(Q) = N(Q) + O(1).

The dense complex sector retains the original amplifier's diagonal
asymptotically. Removing the real twists does not remove the quantity
that detects the local exponent.

For an exact replay of the small algebra in (2.3), let A be the
four-by-four cyclic shift matrix. The faithful regular representation of
Q[z]/(z^4-1) sends z to A, and

    I + A^2 + A^4 + A^6 = 2(I+A^2).

The inspected Jacobian polynomial-at-matrix operation checks this exact
identity over Q using the dedicated files
`jacobian/quartic-projector-input.json` and
`jacobian/quartic-projector-output.json`.
Its use certifies only this finite-dimensional identity; the uniform
analytic lemma is the proof above, not a computational conclusion.

Replay the bounded operation with:

    /home/argustest/zimo/argus-live-update/.venv/bin/python -m argus_skill.tools.jacobian run --operation matrix.polynomial.evaluate.compute --payload-file research/jacobian/quartic-projector-input.json

The recorded run used Jacobian 0.14.0, protocol 2025-11-25, exited 0,
and returned the matrix with alternating rows (2,0,2,0) and (0,2,0,2).
The returned source matrix and polynomial exactly match the input.
No adapter error or timeout occurred. This is not independent Reviewer
acceptance of the analytic lemma.

## 3. The remaining obligation is genuinely dense

Let R_complex be the grouped sum restricted to chi^4!=1.
Every such square character is nonreal and primitive of conductor q.
By finite-family linearity,

    R_group = R_real + R_complex.

In view of (2.2), the full target budget holds if and only if

    R_complex(X,X^(2/21)) <<_epsilon X^(1+epsilon)

for every epsilon>0 and all sufficiently large ell.
This has not been proved.

There are q-1-d_q remaining characters at each auxiliary prime.
Their normalized mass over the primes is of size Q/log Q, not Q^o(1).
Thus applying (1.2) to this sector does not establish the target.
The controlled sparse sector cannot be substituted for the full average.

## 4. Diagnostic for a different proposed shortcut

A zero-free strip and a termwise convexity estimate do not by themselves
supply the missing cancellation. The following is an exact budget
calculation under deliberately favorable hypothetical bounds, not a
claim that those bounds have been proved for every twist here.

Suppose one could shift each dense-sector Mellin integral to a common
line Re(s)=sigma, 0<=sigma<=1, without crossed poles, and had

    |N_eta(s)| << q^((21/2)(1-sigma)+epsilon) (1+|Im(s)|)^B,
    |1/L^S(s,eta)| << q^epsilon (1+|Im(s)|)^B,

where `N_eta=L^S(s,Pi,Sym^2 tensor omega^-1 eta)`.
The resulting individual bound would be

    |D_(q,chi)(X)| << X^sigma q^((21/2)(1-sigma)+epsilon).

Even under these favorable premises, taking absolute values before the
character/prime average gives the envelope

    Q X^sigma Q^((21/2)(1-sigma)+epsilon)
      = X^(23/21+epsilon),              Q=X^(2/21),        (4.1)

up to logarithms. Indeed

    2/21 + sigma + (2/21)(21/2)(1-sigma) = 23/21.

Moving sigma, including making it depend on Q through a classical
near-1 zero-free strip, does not improve this displayed power.
This retires only the inference that this termwise bound alone proves
the desired average. It is not a lower bound for the actual residue sum
and does not rule out a useful zero-density theorem combined with a
genuinely new averaged estimate.

The bounded task therefore still has a proof-layer blocker: dense
complex-square cancellation. The present result removes the real-square
sector without the inherited local bound, but supplies no improvement
of that local bound. No claim about the unresolved global-family
construction or publication-level novelty changes.
