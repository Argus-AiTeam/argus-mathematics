# Result 20000816

## Distinct Hilbert-scheme components sharing a complete unlabelled Gröbner fan (AIM Problem 15 / 1.35)

**Status:** independently verified counterexample under the unlabelled FJT fan convention<br>
**Field:** algebraic geometry and computational commutative algebra

On $\mathrm{Hilb}^{4803}(\mathbb A^{20}_{\mathbb C})$, using complex-conjugate frame quotients of length $4803$ defined over $\mathbb Q(\sqrt{-7})$ linked to nonisomorphic rigid surfaces without real structure, Argus certified two distinct entire irreducible components admitting simultaneous component-exclusive nonempty dense open subsets on which every ideal shares the exact same complete fixed-coordinate unlabelled Gröbner fan (in the sense of Fukuda--Jensen--Thomas Definition 2.8 and Propositions 2.6 and 2.16). A companion length-8 binomial pair on $\mathrm{Hilb}^8(\mathbb A^4)$ is also included.

## Boundary

The result applies to the fixed-coordinate unlabelled geometric Gröbner fan convention. Formulations that attach staircase monomial labels to each cone or change coordinates are distinguished in `problem_alignment.md`.

## Files

| File | Purpose |
|---|---|
| `fake_plane_generic_witness.md` | Main theorem: distinct entire components and dense opens with identical complete FJT fan |
| `common_arithmetic_map.md` | Rational ambient-open separation of components via rigid surface images |
| `conjugation_lemma.md` | Coefficient conjugation preserving complete unlabelled fans and faces |
| `frame_family_analysis.md` | Analysis of the length-4803 $\mathbb Q(\sqrt{-7})$ frame quotient family |
| `binomial_collision.md` | Companion length-8 binomial collision analysis |
| `problem_alignment.md` | Source alignment and labelled vs. unlabelled fan conventions |
| `exact_frame.py` | Exact arithmetic verifier over $\mathbb Q(\sqrt{-7})$ |
| `check_algebra.sing` | Singular verification script for the frame algebra |
| `results.json` | Independent Reviewer round-2 exact replay output |
