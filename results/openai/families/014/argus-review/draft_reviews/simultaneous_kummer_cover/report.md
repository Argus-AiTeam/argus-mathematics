# Simultaneous Kummer cover

**Assessment: supported characteristic-zero construction; arithmetic
compatibility is relative to already supplied actions.** This is
`L_ABG_COVER@1`, old `theorem.md` Section 4. It does not prove that the
finite-field arithmetic tower has been transported to this base.

## Exact statement and hypotheses

Let \(C_1/D\) be a smooth projective geometrically connected curve over a
characteristic-zero field, with a nonempty finite reduced marked divisor
\(\Delta_1\) and compatible local tangent parameters at its closed points.
For a positive integer \(e>1\), choose one rational function \(t\) having
valuation one and the prescribed first jet at every marking. Normalizing
\(w^e=t\) gives a geometrically connected degree-\(e\) cover \(C_2\to C_1\),
with one point above each marking, ramification index \(e\), and unchanged
residue field. In the application \(e\) is the common prime-to-\(\ell\)
integer chosen by `L_ABG_COMPACT`.

The pullback of a supplied boundary system has logarithm \(eN_i\).
If its semilinear action, parameters, and frames have the stated descent
compatibility, the cover preserves its transports. Neither split markings
nor regular/nonzero \(N_i\) are necessary.

## Decisive argument and assumptions

For genus \(g\) and \(\delta=\deg\Delta_1\), take a pole divisor \(E\)
disjoint from the markings with \(\deg E>2g-2+2\delta\). Serre duality
gives \(H^1(\mathcal O(E-2\Delta_1))=0\); the jet sequence is surjective.
Thus a **single** \(D\)-rational function can satisfy all prescribed first
jets, including at nonrational closed points. This is the use of inherited
`A_RR_JETS`: Stacks Project `curves.tex`, `lemma-rr` and
`lemma-genus-gorenstein`, source reading dated 2026-11-05, as retained in
`primary_sources.txt` item 4 and `reviewer_primary_excerpts.txt`.
The source has a prose citation, not an invented stable tag or revision.

At any geometric marking \(w^e-t\) is Eisenstein, proving degree \(e\)
and geometric irreducibility. The local extension is
\(k(x)[[t]]\subset k(x)[[w]]\), \(t=w^e\), which proves the asserted
unique point, ramification, and residue field. Normalization of the
projective curve in characteristic zero gives the stated smooth projective
curve. Other branch points are allowed; the pullback local system remains
unramified there because its original extends across their images.

The residual-gerbe map is \(\zeta\mapsto\zeta^e\). The parameter comparison
has no constant-unit twist: \(t/t_i\) has residue 1, so compatible formal
roots with constant term 1 are unique. A cover and parameters defined over
the base commute with an already supplied compatible semilinear action.
After removing the additional branch values, the cover is finite etale;
the induced finite-index image remains Zariski dense in connected
\(\mathrm{PGL}_n\) if the original image is dense.

## Evidence and boundary of support

The replay's genus-zero polynomial has simple zeros and derivative 1 at
0, 1, and 2. That witnesses one jet construction, not Serre duality on all
curves or an arithmetic descent theorem. See
[replay.json](../computation/replay.json). No compiler checked the geometry.

The inherited independent mathematical support is
`judgement-L_ABG_COVER-ba277ea4cb65`, and the independent source reading is
`judgement-A_RR_JETS-f489290092e1`; the author opinion is `...-b7aeb6a4370c`.
The archive records the algebraic ingredients as standard inputs, not novel
theorems. The direct regular one-point manuscript comparator already uses
an Eisenstein Kummer cover; this draft combines the prescribed jets for
several points. No priority claim is established.

There is no identified gap in this construction over the stated base.
Its use in the combined theorem still requires the separate arithmetic
field-comparison obligation. Native independent review is pending.
