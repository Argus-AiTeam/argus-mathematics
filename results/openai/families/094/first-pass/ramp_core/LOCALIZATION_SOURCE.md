# Primary-source finding used only by the surrounding dependency graph

Source: Ori Gurel-Gurevich and Sushant Sachdeva, *A Tight Bound on
Localization of Electrical Flows*, arXiv:2605.24130v1, Section 1.1,
Theorem 1.3, https://arxiv.org/html/2605.24130v1.
Retrieved on 2026-11-05.

The source defines a finite network with arbitrarily oriented edges and
positive edge conductances \(c_e\), its edge-by-vertex incidence matrix \(B\),
\(C=\operatorname{diag}(c_e)\), \(L=B^\top C B\), and
\(\Pi=C^{1/2}BL^+B^\top C^{1/2}\).
It calls \(\Pi\) a symmetric orthogonal projection and denotes its entrywise
absolute value by \(\overline{\Pi}\).

Theorem 1.3 states:

> For any graph \(G=(V,E,\{c_e\}_{e\in E})\), with \(m\) edges and \(n\)
> vertices, we have
> \[
> \|\overline{\Pi}\|_{2\to2}\le 2\log n.
> \]

Thus the precise weighted, symmetrized localization statement required by
the staged manuscript is available in this version. This is a source
reading, not an independent proof of localization or of the manuscript's
fixed-point reweighting. The ramp theorem takes the weighted orthogonal
projection and its row-sum bound as hypotheses and does not use this
external theorem.

Independent citation attribution is still owed by a different reader.
