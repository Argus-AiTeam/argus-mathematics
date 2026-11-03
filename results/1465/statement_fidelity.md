# Statement fidelity for `Main.lean`

The declarations formalize the one-dimensional parameter slice used in the
route report.

- `RegularEta eta` means that every real zero of
  \(P_\eta(x)=x^2-\eta\) is nonsingular. Its derivative is \(2x\).
- `regularEta_iff` proves that the unrestricted polynomial regular-parameter
  set is \(\mathbb R\setminus\{0\}\).
- `FuRegularSlice` imposes Fu's exact parameter constraint
  \(\eta\in[-1,1]\).
- `fuRegularSlice_eq` proves that the exact slice is
  \([-1,1]\setminus\{0\}\), and `fuRegularSlice_not_isClosed` proves that it
  is not closed in the real parameter line.
- `no_locallyFinite_closed_cover` proves that it cannot be the union of a
  locally finite family of closed pieces.

In Fu's notation, this line is the slice of the set \(R\) from equation (6)
with \(n=1\), \(P(x,l,\epsilon,\delta)=x^2\), \(A=I_5\), and fixed
\((l,\epsilon,\delta)\). The separate route report verifies that
\((I_5,\eta)\in G\) for every \(\eta\in[-1,1]\) and maps the intersections of
closed triangulation simplices with this slice to the `pieces` in the formal
theorem.

The Lean file does not formalize Fu's paper, the definition of \(G\), or the
claim that a standard triangulation has closed simplex images. Those
statement-fidelity steps are elementary arguments given explicitly in
`REPORT.md` and remain for independent Reviewer inspection.
