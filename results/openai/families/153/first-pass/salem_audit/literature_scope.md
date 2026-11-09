# Scope of the independent Salem audit

The target is exactly `sal:main` in the staged `build/salem.tex`: for every
quartic Salem number beta in (1,2), the unbiased Bernoulli convolution at
1/beta is singular. The arithmetic classification and the degree-31 example
are outside this mission.

The staged proof has five load-bearing components: the integer trace and
absence of half-integers; a single multiplier sequence satisfying all the
growth and cosine-floor requirements; the sublinear loss estimate; independent
phase windows; and simultaneous separation in the two measures. None is
assumed merely because it appears in the manuscript.

## Retrieved prior results

The primary source https://arxiv.org/html/2610.12072v2, Cheng--Fang--Ma--Zhang,
*Strict Hausdorff-dimension drop for Quartic Salem Bernoulli convolutions*,
Theorem 1.1, states:

> For every quartic Salem number beta, dim_H nu_(beta^(-1)) < 1.

The signs defining that measure in Section 1 are independent and have the
two probabilities 1/2. The introduction explicitly compares its result with
Theorem 5.1 of the OpenAI preprint, says the latter proves singularity, and
states that its own proof does not depend on that preprint. This source is
scope evidence, not an assumption used to prove the audit theorem.

The primary source https://arxiv.org/abs/1111.2414v1, Feng,
*Multifractal analysis of Bernoulli convolutions associated with Salem
numbers*, studies multifractal spectra, and its abstract explicitly notes
that rich multifractal structure can also occur for absolutely continuous
measures. Such structure alone is not a singularity proof.

An independent bounded literature search additionally checked Garsia,
*Entropy and singularity of infinite convolutions* (1963), Theorem 1.4,
printed pp. 1161--1162,
https://msp.org/pjm/1963/13-4/pjm-v13-n4-p09-s.pdf,
and Shmerkin, https://arxiv.org/html/1303.3992v2, Section 1.3, Theorem 1.1.
The former is a conditional entropy criterion, including non-identically
distributed independent finite-valued variables. The latter is an
almost-every-parameter absolute-continuity result for stationary biased
convolutions. Neither retrieved statement proves the arbitrary,
nonstationary probability-sequence extension considered here.

No prior theorem for all nonstationary independent sign probabilities was
located in this bounded search. This is not a proof of novelty. A claimed
novelty status must remain subject to independent review.
Attempts to retrieve the Peres--Schlag--Solomyak survey and Garsia's 1962
paper did not yield accessible source text in that search. No proposition
from either unavailable source is a proof dependency.

## Excluded shortcuts

Fourier decay or nondecay is not used as a substitute for singularity.
A finite sample of multipliers, a supplied degree-31 verifier, and mere
resolution of a bibliographic identifier cannot verify `sal:main`.
The proof below must establish one infinite sequence with all the stated
bounds, not a separate sequence for each index.

A single Lebesgue-null set carrying the laws for *all* probability sequences
is impossible: deterministic sign sequences, allowed by probabilities 0
and 1, realize the whole support interval. The extension has quantifiers
"for every probability sequence there exists a null set", not the reverse.
