# Exact coefficient-gcd completion

No counterexample is claimed here. This construction leaves the final prime
free instead of placing it in a smooth-order pool.

## The exact completion identity

Let P>=2 and r>=2, let q be prime with gcd(q,r)=1, and put

    F_P(X) = (X-1)^P - X^P + 1.

In characteristic q,

    F_(P*q)(X) = F_P(X^q).

Substitution X -> X^q permutes the monomials in the quotient by X^r-1.
It is therefore an automorphism, and

    F_(P*q)=0 modulo (q,X^r-1)
        iff F_P=0 modulo (q,X^r-1).

Compute the r integer coefficients c_0,...,c_(r-1) of F_P after cyclic
reduction, and set G_r(P)=gcd(c_0,...,c_(r-1)). Every possible prime q completing
the local identity must divide this exact integer. Conversely, each such
prime q, if coprime to r, satisfies the identity modulo q.

When P is a product of two distinct primes and q is different from them,
the remaining local conditions are checked at the prefix primes. Their
success and the modulo-q identity imply the identity modulo n=P*q by
integer CRT. Nevertheless every resulting candidate is replayed with
`certificates/verify_candidate.py`, including the proper divisor, coprimality,
failed conclusion, and all coefficients modulo n.

This is not a sufficient heuristic about orders. A complete factorization of
G_r(P) gives every admissible final prime for that prefix/r pair, with no
prime-size cutoff. An incomplete factorization leaves that pair unresolved,
even if all known factors have been rejected.

## Implementation and bounded factor contracts

`free_prime_completion.py` computes the coefficients by exact signed-integer
cyclic multiplication and binary exponentiation. It records G_r(P), the
prefix, and r, so the integer result can be independently recomputed.

Small factors are removed by exact trial division through 1000. If a remaining
cofactor has at most 30 decimal digits, the already inspected pinned Jacobian
operation `integer.factor.certified_compute` is used. Its typed output contains
prime-power factors with Pratt certificates. The output's input binding and
integer product are checked, and the full payload, typed output, structured
execution status, and stderr are retained in dedicated files. UNKNOWN,
process errors, timeouts, and cofactors larger than the installed contract
remain unresolved. A partial factorization is not relabeled complete.

The initial declared construction uses two distinct odd prefix primes at most
97 with product at most 5000, and r in
{5,7,9,11,13,15,17,19,21,23,25,27,29,31}. The final prime is unrestricted.
This domain is a construction attempt, not the universe of the conjecture.

## A concrete first completion

At P=83*107=8881 and r=5 the exact coefficient gcd is

    2288314296913494601150435872
      = 2^5 * 3^2 * 11 * 31 * 41 * 61 * 149 * 241
        * 1481 * 2221 * 4441 * 17761.

The inspected certified Jacobian operation returned COMPLETE. All twelve
prime completions were passed through the full-ring verifier; none meets the
counterexample contract. This single-prefix computation demonstrates that
the construction reaches final primes outside the earlier prime cutoff,
not that it has found a witness.

The exact evidence is in
`jacobian/free-prime-prefix-83-107.payload.json`,
`jacobian/free-prime-prefix-83-107.output.json`, and
`jacobian/free-prime-prefix-83-107.execution.json`. The direct CLI reports
neither an MCP protocol nor a server version; the execution record states
that limitation instead of inventing metadata.

## Completed initial domain and exact cofactor resolution

The initial batch processed all 3,148 prefix/r systems. It obtained 3,143
complete factorizations and five UNKNOWN cases, with no candidate. The five
cases shared only three remaining cofactors; their Jacobian calls timed out
at 30 seconds and supplied no mathematical conclusion.

Complete trial division through each remaining cofactor's square root gave

    27012001  = 3001 * 9001,
    157352771 = 6871 * 22901,
    2538251   = 1301 * 1951.

The respective square-root bounds are 5197, 12544, and 1593. Testing these
previously missing final-prime completions produced no witness. The original
timeout records are preserved; they were not relabeled as successful
Jacobian executions.

`free-prime-coefficient-gcd-p97-P5000.resolved.json` contains complete
factorizations and rejected completions for all 3,148 systems, and refers
back to `free-prime-coefficient-gcd-p97-P5000.json`. Thus Engineer computation
excludes this stated two-prefix-prime family even with no bound on the final
prime. Independent review is not asserted, and larger or different prefixes,
other ring lengths, and other constructions remain outside the result.
