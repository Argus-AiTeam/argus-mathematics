# Statement fidelity: the division-free algebraic core

The registered compiler claim is `F258-CORE`, not the complete
group-homology proposition `C258-ROW`.

`RowRestriction.line_single_support` quantifies over arbitrary families
`E i` and `V i` of abelian groups indexed by all integers. An edge `i`
maps to vertex `i` by `left i` and to vertex `i+1` by
`right (i+1)`. Both endpoint maps must be injective. The family `b`
has exactly the finite nonzero support `s`; there is no bound on its
size, its location, or the groups. At every vertex other than the
arbitrary vertex `root`, the two incident images agree. The conclusion
is that every edge value is zero. This is finite-support trimming, not
an assumption that a vertex map to a homology group is injective.

`RowRestriction.line_vertex_relation` adds a value `v` at `root` and
identifies it with the incidence boundary there, with signs
`left - right`. It proves `v = 0`. Therefore a single vertex summand
has zero intersection with the image of the finite-support incidence
map. For the cokernel, the kernel of the vertex map is precisely that
intersection. Padding with zero groups also covers finite lines.

The other declarations certify local algebra used in the proof:

- `right_pivot_cancel`: in any division ring, right multiplication by
  a nonzero pivot has zero kernel.
- `triangular_injective`: for any index type `B`, any function
  `q : B -> D`, and nonzero `p`, the map
  `(b,c) |-> (b + c*q, c*p)` is injective. Multiplication order is
  exactly the manuscript's coefficient-on-the-left order. A zero
  common alphabet is allowed.
- `private_column`: an injective source chain map whose image has zero
  probe coordinate has zero intersection with a relation map whose
  probe is `coefficient(b)*p`, where `coefficient` is injective and
  `p` is nonzero. The conclusion includes that the original relation
  coefficient is zero. There is no division or lifting of a boundary
  coefficient from a larger ring.
- `root_frame_inverse`: for arbitrary nonzero `x` and arbitrary `s`
  in a possibly noncommutative division ring, the coefficient changes
  `(c,e) |-> (-c*x, c*s+e)` and
  `(c,e) |-> (-c*x^-1, c*x^-1*s+e)` are inverse. These are the Fox
  changes between the root-row bases `(B,x,u)` and `(B,y,u)` when
  `y=x^-1*u^n` and `s` is the Fox power sum for `u^n`. Only the group
  element `x`, not a power sum, is inverted in these chain changes.

The Lean source does not encode group presentations, the existence of
Linnell division rings, the Mackey-Shapiro isomorphisms, the
Mayer-Vietoris sequence, or the identification of the manuscript's
actual stabilizers. Those are proved or sourced explicitly in
`report.md` and require mathematical review. In particular a compiler
success for this file must not be reported as a kernel proof of all
of `row:restriction`. It proves the universal algebraic core, rather
than a finite experiment or a dimension inequality.
