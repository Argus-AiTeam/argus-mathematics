# First-lift obstruction for pure prime powers

This is a local exclusion mechanism, not a proof of Agrawal's conjecture.
All statements below require p prime, e>=2, r>=2, and gcd(p,r)=1.

Write

    F_m(X) = (X-1)^m - X^m + 1.

In (Z/p^2 Z)[X], Frobenius modulo p and the binomial theorem give

    F_(p^e)(X) = F_p(X^(p^(e-1))) (mod p^2).

Indeed, (X-1)^(p^(e-1)) = X^(p^(e-1))-1 + p*H(X) modulo p^2,
and raising to p kills every term containing H modulo p^2.
Since multiplication by p^(e-1) permutes Z/rZ, substitution
X -> X^(p^(e-1)) is an automorphism modulo X^r-1.
Consequently, a nonzero coefficient in F_p modulo (p^2,X^r-1)
excludes **every** pure power p^e, e>=2, for that p,r.

There is a cheap necessary scalar condition for that first lift:

    r^(p-1) = 1 (mod p^2).

To see it, use the free rank-(r-1) algebra

    A = (Z/p^2 Z)[X]/(1+X+...+X^(r-1)).

The determinant norm of X-1 is (-1)^(r-1)*r. The substitution X -> X^p
is an automorphism, since gcd(p,r)=1: it is invertible on X^r=1 and
permutes the sum of the r monomials, so descends to this quotient.
If F_p=0 in the full ring, then (X-1)^p=X^p-1 in A. Taking norms gives
((-1)^(r-1)*r)^p=(-1)^(r-1)*r modulo p^2. For odd p, the signs cancel;
r is invertible, giving the scalar condition.

The implementation uses this necessary condition only as a rejection filter.
Every survivor is checked coefficientwise modulo p^2 in the full quotient
by X^r-1. A first-lift survivor would remain unresolved until higher powers
were examined; a finite exponent search would not exclude all exponents.
Also, p^2=1 modulo r excludes every exponent from the **failed-conclusion**
requirement, independently of the polynomial identity.

The bounded batch declares its prime bound and r list in its JSON output.
Even if every exponent is excluded for every listed p,r, it says nothing
about larger p, other r, or mixed nonsquarefree integers such as p^e*q.
The latter mechanism does not reduce to F_p by the argument above.

## Evaluated domain

The batch `search/prime-power-first-lift-p100000.json` covers odd primes
p<=100000 and r in {5,7,11,13,17,19,23,29,31}. After excluding noncoprime
p,r, there are 86310 pairs. Of these, 15925 cannot satisfy the failed
conclusion for any exponent, and 70369 fail the scalar norm condition.
Every one of the remaining 16 pairs has a nonzero full-ring coefficient
modulo p^2. No first-lift survivor remains.

The coefficient vectors for those 16 pairs are in the batch output. A separate
schoolbook cyclic-ring implementation and independent prime enumeration
recomputed the entire boundary in `certificates/bounded-route-replay.json`:

    /home/argustest/zimo/argus-latest/.venv/bin/python certificates/replay_boundary.py \
      search/prime-power-first-lift-p100000.json

Together with the lemma above, this excludes every e>=2 in this explicit
pure-prime-power domain. It is not a counterexample, a global exclusion of
nonsquarefree n, an independent Reviewer verdict, or a kernel-checked proof.
