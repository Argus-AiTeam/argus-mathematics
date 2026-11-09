# Exact finite-law conditioning-to-threshold transfer

## The theorem

Let A be any family of finite binary probability laws, closed under the
explicit independent products defined below. Let v >= 0, L >= 0,
0 < delta < 1-v, and 0 < T <= delta/4. For a law on n > 0 coordinates,
write E_C for all tested coordinates C succeeding, p_C for its probability,
and W for the number of successful coordinates. Assume uniformly over A
and every proper C with p_C > 0 that

    [log(1/p_C)+|C|L]/(n-|C|) <= T

implies an untested conditional mean at most v+delta/4. Then every law in A
satisfies

    Pr(W >= ceil((v+delta)n))
        <= exp[-delta*T*n/(16*(1+L))].

This is a distribution-family generalization and complete formal
certification of the manuscript's prose transfer, not a claim that its
threshold exponent or Song's rounding lemma is newly discovered.

## Finite tested-set selection

Put q = v+delta, q0 = v+delta/2, eta = delta/16. For any positive tail
probability p = Pr(W >= qn), choose

    r = log(q/q0),
    ell = ceil(log(4/(eta*p))/r).

Draw ell coordinates uniformly and independently with replacement; C is
their distinct set. For each fixed binary string with w successful
coordinates there are exactly w^ell draws contained in its success set.
Consequently, if a_C = Pr(E_C) and
b_C = Pr(E_C and W < q0*n), the uniform draw averages satisfy

    average(a_C) >= p*q^ell = A0,
    average(b_C) <= q0^ell <= eta*A0/4.

These are finite-sum identities and inequalities, not independence
assumptions on the binary law. There is a draw with
a_C >= A0/2 and b_C <= eta*a_C. For otherwise every draw would satisfy
eta*a_C <= eta*A0/2+b_C; summing would give
eta*A0 <= 3*eta*A0/4, impossible. Also |C| <= ell.
This proof is `upper_tail_selection` in the formal source.

## Uniform large-length contradiction

Set R = L-log q, c = delta*T/(16*(1+L)),
t = 1+log(4/eta)/r, and B = log 2+R*t.
The inequality log x >= 1-1/x implies

    delta <= 2q*r,    q*(L-log q) <= L+1-q.

It follows that c/r <= T/8 <= eta/2 and
c*(1+R/r) <= 3T/16. Choose an integer K larger than both
2t/eta and 16B/T. This choice depends only on the real parameters.

If n >= K and p >= exp(-cn), then log(1/p) <= cn and
ell <= cn/r+t <= eta*n. The selected C is therefore proper.
Its event probability is positive and its cost numerator satisfies

    log(1/p_C)+|C|L
      <= log(1/p)+log 2+ell*R
      <= c*(1+R/r)*n+B
      <= T*n/4
      <= T*(n-|C|).

Thus the conditioning input applies. On the other hand, with s = |C|,
the good tested states and nonnegativity of the remaining wins give

    E[(W-s) 1_{E_C}] >= (1-eta)*p_C*(q0*n-s).

The identity

    (1-eta)*(q0*n-s) - (q0-eta)*(n-s)
        = (1-q0)*(eta*n-s) >= 0

shows that the remaining conditional mean is at least
q0-eta = v+7delta/16, strictly above v+delta/4. This contradicts
the input. `large_length_threshold` proves the resulting uniform cutoff.

## Independent products and every length

For a binary law mu on a finite coordinate set I, define the law on
Fin(N) x I by

    mu_N(x) = product_j mu(x restricted to block j).

Finite distributivity proves its total mass is one. For every event P,
the all-block event has probability Pr_mu(P)^N. The number of wins in
the combined string is the sum of the block win counts. Thus all blocks
having at least q*|I| wins implies that the combined string has at least
q*N*|I| wins. This also proves the ceiling inclusion exactly.

For a fixed nonempty I, take N = K+1. Its product length is at least K,
so product closure and the large-length result imply

    p^N <= exp(-c*N*|I|) = [exp(-c*|I|)]^N.

Monotonicity of the positive integer power gives p <= exp(-c*|I|).
This is `all_lengths_of_large`, used by the full transfer theorem.
Taking a nonempty supremum of already bounded probabilities needs no
maximizer; `threshold_supremum` formalizes this step.

For repeated-game strategies, independent products really are available:
tensor the N finite shared states, group each player's question string
into the N blocks, and use the tensor product of the original joint
POVMs. The sums of these measurement operators are identities and their
operators are positive. The tensor-product Born probability factors into
the product of the N block probabilities; the fresh question pairs also
have a product law. Summing over questions and answers with any prescribed
binary block outcomes gives exactly mu_N above. The dimension is the
finite Nth power of the original finite dimension. This is a construction,
not an attainment argument. The finite-law factorization is formalized;
the quantum operator representation itself is outside the formal model.

## External fourth-root input and fifth-power application

Song's actual Definition 4.3 and Lemma 4.4, at pp. 11-12 of the official
TR26-199 PDF, have precisely the arbitrary-proper-set quantifiers required
here. The proof dependencies are delimited in `primary_source.md`.
No extra high-success, full-support, or finite-dimension-bound assumption
was found in that statement.

Given that external estimate with universal B4 >= 1, set
T = (delta/(4B4))^4. Since 0 < delta < 1, this budget is positive,
at most delta/4, and at most one. Nonnegativity of its conditioning cost
follows from p_C <= 1, L >= 0, and properness. Monotonicity of the fourth
root gives the required excess at most B4*T^(1/4) = delta/4.
The exact resulting rate is

    delta^5/[16*(4B4)^4*(1+log d)].

The formal certificate does not discharge Song's quantum theorem or its
Chapter 6 dependencies. The source reading establishes applicability of
the citation, not an independent quantum proof. No refutation claim is
filed because no false literal manuscript assertion was established.

## Replay and limitations

Run `python3 research/conditioning_bridge/verify.py` from the campaign root.
It performs exact rational finite sanity checks, replays the saved typed
Jacobian result, invokes the real Lean evidence compiler with the authorized
interpreter, and runs both official campaign-local structural checks.
`exact_certificate.json` records measured outcomes. The universal theorem
is established by Lean, NOT by the bounded finite checks.

The mathematical improvement over the initial project state is the complete
machine-checked distribution-family transfer, including its set selection,
constants, properness, ceiling, and product extension; the initial ledger
contained only the campaign objective. Independent statement-fidelity,
primary-source, and publishability review remains the Host Reviewer's job.
