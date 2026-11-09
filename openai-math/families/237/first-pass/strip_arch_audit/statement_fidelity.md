# Statement fidelity

`Main.lean` formalizes the dimension-independent algebraic bridge used by
the strip arch proof. It does **not** encode the honeycomb lattice, the
Pfaffian, the vacuum polynomial construction, convergence of infinite
path sums, or the full assertion of Proposition `prop:arch-formula`.
Those identifications and arguments are in `report.md`; the exact local
diagram identities are checked in `verify.py`.

The declarations described below are `projected_source`,
`inserted_source`, `adjoint_pairing_reduction`, and `arch_interpolation`,
all in namespace `StripArchAudit`.

## `StripArchAudit.projected_source`

The scalar ring `K` is arbitrary. `V0,V1,W0,W1` are arbitrary modules
over it, with additive commutative groups. The maps `tx,tr` are source
transfers on the large and reduced one-source modules; `bx,br` insert a
source from the corresponding vacuum modules. `q0,q1` are linear
projection maps, not coordinate transposes and not assumed to be
isometries.

All vectors and maps are universally quantified. The hypotheses are:
`q0 px = pr`; the two inhomogeneous source equations
`hx-tx hx=bx px` and `hr-tr hr=br pr`; projection intertwining for both
the transfer and source insertion; and injectivity of `w -> w-tr w`.
The conclusion is exactly `q1 hx=hr`. In the manuscript application,
the projections are the diagrammatic `S_s^t` in their respective
sectors. Injectivity follows at the regular mixed lists from the
restricted transfer decay, and elsewhere only by rational continuation.

## `StripArchAudit.inserted_source`

The same types and source equations occur, but `s0,s1` insert the
reduced vacuum/source modules into the larger ones. The hypotheses are
`s0 pr=px`, the forward transfer and insertion intertwiners, and
injectivity of `v -> v-tx v`. The conclusion is `hx=s1 hr`.
No relation between these insertion maps and the projection maps is
assumed.

## `StripArchAudit.adjoint_pairing_reduction`

The five types, insertion and projection functions, and pairing
functions are arbitrary. Assuming the adjoint gluing relation
`glue l (insert r)=glueRed (project l) r`, projected equality of the
left source and inserted equality of the right source, the conclusion
is equality of the two glued values. Bilinearity is not needed for this
implication, so the formal statement is more general than the
diagrammatic application. In particular there is no hypothesis
`S_s^t S_s=I`.

## `StripArchAudit.arch_interpolation`

For every field `F`, every natural number `N>=2`, and any polynomials
`p,q` of natural degree at most `2N`, a finite set of at least `4N-3`
distinct nodes on which they agree forces `p=q`. The finite set type
itself removes duplicate nodes. The source's trigonometric
specializations are shown to be generically distinct in the prose
proof; that identification is not a Lean hypothesis silently proved
by the compiler. The `N=0,1` arch base cases are outside this
declaration.

The mechanical evidence is attached to claim `C_ARCH_RESOLVENT`,
whose projection/pairing assertion is proved by the first three
declarations. The fourth declaration additionally certifies the
abstract uniqueness implication in claim `C_ARCH_INTERPOLATION`;
it must not be presented as a Lean formalization of the entire arch
formula.
