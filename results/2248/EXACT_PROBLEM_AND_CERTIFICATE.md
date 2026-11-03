# Exact problem and certificate

## Source-grounded statement

Erdős's Acta paper asks in section 2, equation (8), whether every
sufficiently large integer has a representation

\[
n=a p^2+b,\qquad p\text{ prime},\quad a\geq 1,\quad 0\leq b<p.
\]

The source is P. Erdős, *Some unconventional problems in number theory*,
Acta Mathematica Academiae Scientiarum Hungaricae 33 (1979), printed
p. 77, DOI `10.1007/BF01903382`. Immediately after (8), Erdős says the
Eratosthenes sieve gives the representation for almost all integers, but
suggests that infinitely many integers may have no solution. "Almost all"
does not decide whether the exceptional set is finite or infinite.

The similarly titled Mathematics Magazine paper, DOI
`10.1080/0025570X.1979.11976756`, item 3 on printed p. 68, instead imposes
\(a>1\) and \(0<b<p\). This is a strict variant: the Acta endpoints
\(a=1\) and \(b=0\) are excluded. Its computation and its discussion of
dropping primality therefore cannot refute the exact Acta statement.
A short passage transcribed from the authoritative primary full text is
archived at
`research/literature/source-excerpts/mathematics-magazine-1979-p68.txt`;
the publisher landing page itself rejected anonymous retrieval with HTTP 403.

At the audit cutoff, the maintained Erdős Problems page
<https://www.erdosproblems.com/676> still presents the inclusive-endpoint
question as open. Its revision history records the same statement on
2026-04-07 at 09:10:44; the immutable database snapshot at commit
`9cfb265f9fa57390908d80624d61b9551d454398` independently labels record 676
open. The exact extract and locators are archived at
`research/literature/source-excerpts/maintained-page-676.txt`. The forum
claim is post 6639 by Zeraoulia Rafik, timestamped 23:03 on 24 May 2026, at
<https://www.erdosproblems.com/forum/thread/676#post-6639>. It reports a
focused interval search and the candidate \(10000001000000006\), but
expressly says that it does not know a genuine infinite family. The relevant
extract is archived at
`research/literature/source-excerpts/forum-post-6639.txt`. Its finite list
and heuristic are not evidence for arbitrary largeness.

## Exact residue equivalence

**Lemma.** A positive integer \(n\) has the required representation if and
only if some prime \(p\leq\lfloor\sqrt n\rfloor\) satisfies
\(n\bmod p^2<p\). Consequently, \(n\) is exceptional if and only if

\[
n\bmod p^2\geq p
\quad\text{for every prime }p\leq\lfloor\sqrt n\rfloor.
\]

**Proof.** If \(n=ap^2+b\) with \(a\geq1\) and \(0\leq b<p\), then
\(p^2\leq n\) and the Euclidean remainder of \(n\) modulo \(p^2\) is
exactly \(b<p\). Conversely, if \(p^2\leq n\) and that remainder is
\(b<p\), Euclidean division gives \(n=ap^2+b\) with
\(a=\lfloor n/p^2\rfloor\geq1\). Negating the existential statement gives
the displayed exceptional predicate. \(\square\)

## Exact certificate contract

An exception certificate contains a positive integer \(n\) and expected
summary fields. `src/exception_verifier.py` independently:

1. computes \(L=\lfloor\sqrt n\rfloor\) with integer square root;
2. deterministically enumerates every prime \(p\leq L\) with a segmented
   sieve;
3. rejects with the explicit representation
   \((p,\lfloor n/p^2\rfloor,n\bmod p^2)\) at the first remainder below
   \(p\);
4. accepts only after every enumerated prime has remainder at least \(p\).

The certificate does not supply or omit the prime list, so acceptance cannot
be obtained by choosing a favorable subset. The retained prime count, last
prime, and least residue margin are reproducibility summaries, not substitutes
for enumeration. `certificates/forum-candidate.json` is deliberately labelled
as one finite calibration and cannot certify the infinite target.

The implementation was cross-checked through \(n=1000\) against a separate
oracle that trial-divides each possible \(p\) and directly enumerates every
defining triple \((a,p,b)\), without calling the remainder equivalence.

## Barrier equivalence

Define \(Q(m)\) to be the largest prime \(q\) for which \(q^2\mid m\), and
put \(Q(m)=0\) when \(m\) is squarefree.

**Lemma.** A positive integer \(n\) is exceptional if and only if

\[
Q(m)\leq n-m\qquad\text{for every }1\leq m\leq n.
\]

**Proof.** A representation gives \(m=ap^2=n-b\), with \(p^2\mid m\) and
\(Q(m)\geq p>b=n-m\). Conversely, if \(Q(m)>n-m\), then
\(p=Q(m)\) satisfies \(p^2\mid m\); writing
\(n=(m/p^2)p^2+(n-m)\) gives a required representation. Negation proves
the equivalence. \(\square\)
