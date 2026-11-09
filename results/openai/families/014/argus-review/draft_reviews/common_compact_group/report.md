# One compact group and one auxiliary degree

**Assessment: supported for supplied compatible boundary data.** The source is
`L_ABG_COMPACT@1`, old `theorem.md` Section 2, using Section 1. This is a
local construction, not a proof that the required arithmetic boundary data
have already been lifted from the finite field.

## Exact statement and hypotheses

Let \(L/\mathbb Q_\ell\) be finite, \(H_0\subset\mathrm{PGL}_n(L)\)
compact, and let finitely many boundary cocharacters \(c_i\) be supplied.
One compact open \(J\) contains \(H_0\) and all
\(P_i=c_i(-1/e)\), for a single integer \(e>1\) prime to \(\ell\).
For the arithmetic assertion the additional input is a permutation \(\pi\)
of the punctures and actual transports \(B_i\in H_0\) satisfying
\(\operatorname{Ad}(B_i)N_i=qN_{\pi i}\), where \(q>1\) is the
finite-field cardinality and \(\ell\nmid q\). Return products on a
length-\(d\) orbit scale \(N_i\) by \(q^d\).

## Decisive argument

In a closed faithful linear representation, compactness gives an
\(H_0\)-stable lattice: the orbit span of an initial lattice lies between
two fixed lattices and is finitely generated. The inverse image of its
linear stabilizer is open and compact; the **closed** embedding is what
justifies compactness. This supplies \(J\) before choosing \(e\).

Finitely many continuous \(c_i\) all map a sufficiently small neighborhood
of 1 into \(J\). Choose \(M\) sufficiently large and
\(e=\ell^M-1>1\). Then
\[
 -1/e-1=\ell^M/(1-\ell^M),
 \qquad \operatorname{Ad}(P_i)N_i=-N_i/e,
 \qquad P_i\exp(-eaN_i)P_i^{-1}=\exp(aN_i).
\]
This proves the common-degree and sign assertions; it does not assert that
every small prime-to-\(\ell\) integer works for a fixed lattice.

On each arithmetic orbit apply the primary grading to the return matrix
with multiplier \(q^d\). Naturality gives
\(c_{\pi i}=B_ic_iB_i^{-1}\), hence
\(P_{\pi i}B_i=B_iP_i\). The return condition follows because the grading
commutes with the return matrix. Requiring each \(P_i\) to commute with
each individual \(B_i\) would be the wrong condition at permuted punctures.
Zero logarithms permit the trivial cocharacter on their whole orbit.
These arguments are sufficient under the stated input hypotheses.

## Attribution and evidence limits

The manuscript comparator, at the revision in `MANUSCRIPTS.json`,
`Frobenius-Structures.../build/sections/parameters.tex:249-299`,
assumes a **regular** nilpotent and allows a finite coefficient extension.
The old draft applies the supported primary-space construction to arbitrary
nilpotent types and several arithmetic orbits over \(L\) itself. This is a
statement-level strengthening of that comparator, not verified literature
originality and not a new eigensheaf theorem.

The replay checks four selected dimension-four boundary fixtures in one
chosen integral compact group, with \(q=11,\ell=5,e=24\), reductions modulo
\(5,25,125\), and a two-puncture orbit. It includes a fixture with
nonintegral primary projectors and negative controls for an unsuitable
degree, orientation, and commutation requirement. These are exact checks
of those fixtures, not a universal compactness certificate. Details are in
[replay.json](../computation/replay.json).

The old independent support receipt is
`judgement-L_ABG_COMPACT-8a2c1c5d9be4`; the author receipt is
`...-220499cc7e52`. Neither closes the upstream arithmetic-lift gap.
This assessment retains their supported local scope. Native independent
review remains pending.
