# Independent reading of the endpoint Bombieri--Vinogradov input

Reader: reviewer:copilot-026-moments. Read on 2026-11-05.

Source: E. Bombieri, J. B. Friedlander and H. Iwaniec, *Primes in
arithmetic progressions to large moduli*, Acta Mathematica 156 (1986),
203--251, doi:10.1007/BF02399204.

I independently read printed pages 204 and 206 (PDF pages 2 and 4)
of `research/audit026/moments/BFI1986.pdf`, including the surrounding
text, rather than relying on the Engineer's excerpt or a DOI lookup.
The first PDF page identifies the title and all three authors.

At printed page 204, the notation is L = log x and

    psi(x;q,a) = sum_{n <= x, n = a (mod q)} Lambda(n).

At printed page 206, equation (1.4) reads, in ASCII transcription,

    sum_{q <= Q} max_{(a,q)=1} |psi(x;q,a) - x/phi(q)| << x L^(-A).

The following sentence states:

> for any A > 0 with Q = x^(1/2) L^(-B), where B and the implied constant
> depend on A alone.

There is no exclusion of the positive modulus 1 in this sum. The
surrounding text attributes this ordinary mean-value theorem to
Bombieri and Vinogradov; the subsequent discussion of larger moduli
does not add hypotheses to equation (1.4).

This supports the four ledger assumptions BV_ENDPOINT,
BV_DENSITY_ENDPOINT, BV_WEIGHT_ENDPOINT and BV_REFINEMENT_ENDPOINT.
It is not a citation for their weighted or shifted variants. Those
variants follow from the argument in Section 2 of `verification.md`:
the fixed strict inequality sigma < 1/2 puts X^sigma in the endpoint
range for every required logarithmic saving, and absorbs the summed
prime-power and polylogarithmic endpoint errors. Cauchy--Schwarz and
the stated elementary weighted estimate supply the divisor weights.
No two-prime-mark or short-interval distribution theorem is used.

The native attribution writer has no archive-location option and
would create `research/literature/`, which is not an owned path in
this mission. That directory was re-probed and does not exist.
Consequently no native literature-tier attribution was attempted.
The permitted assumption judgements cite this independently archived
reading; they must not be described as a successful
`citation_check attribute` operation.
