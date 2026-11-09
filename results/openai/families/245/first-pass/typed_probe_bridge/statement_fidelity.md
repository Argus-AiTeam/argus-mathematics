# Statement fidelity: relative typed channel realization

## Claim and quantifiers

`C_TYPED_PROBE_BRIDGE` is a conditional, unbounded verification of the
actual channel macro schemata, not a proof of system-wide normalization.
It reuses the already sealed guarded-core review without replaying it.

`TypedProbe.access_exact` quantifies over an arbitrary family parameter
`a : A`, the original `m : M(a)`, `y : L(a)`, and a supplied typed callback
code. Its only local proof hypothesis is `not flag(a,m)`. Its conclusion
is exactly

```
Access(Bundle(m,y), q) iff q(m, Round(y)).
```

`TypedProbe.realize_four_laws` quantifies over all family parameters and
all data parameters satisfying exactly `Adm`. It proves raw lift
cancellation for every `v : V`, rounded probe evaluation for every
`i : PX`, lift congruence for every `L` relation proof, and validity of
every lift. `Valid` quantifies over all pairs of predicate codes `i,j`
and their pointwise evaluation equivalence. **Neither `Ext(i)` nor
`Ext(j)` is a hypothesis.** `part_probe_congr` retains the exact double
rounding `lift(m, Round(Round(y)))` at which that equivalence is used.

The carriers `PL` and `PX` are predicate-code carriers, not function
spaces. Logical quantification in the realization proof ranges over
these carriers and `L,X`. `A`, `m`, and `v` are metatheoretic open
parameters. The terminal formula and the specialized diagonal are not
part of this theorem.

## Typed syntax and the meaning of type preservation

`TypedProbe.Syntax.Term` and `Formula` are intrinsically many-sorted
syntax, with typed de Bruijn variables and explicit typed substitution.
They are not arbitrary Lean functions taken to be PTS terms. An
explicit substitution node means capture-free **syntactic**
substitution, justified by the upstream labelled substitution theorem;
it is not a logical equivalence or an extra PTS binder.

The local family types are indexed by the exact `Parameter`. Global
`Z,V,Xc,X,PX,U` have no such index. `downZ` denotes the bound
`z-downarrow` in the native outer lambda, not a later selected `A_0`.
The outer native lambda accepts a body in precisely `[Z,PX]` and returns
a term in `[PX]`. The inner lambda binds `Single(downZ)`. Consequently
the template has only the free predicate-code input; it cannot capture
an outer `m`. `uniform_probe_has_no_open_A` also checks the entire
expanded template for external `Parameter.open` annotations.
`global_types_have_no_parameter` records the global type independence.

`probeTemplate` is literally the typed tree

```
lambda^(d,d) z:Z.
  pack_kappa (
    lambda^(d,d) w:Single(z-downarrow).
      send_n (Access(w; o,x. i @ lift_o(x))))
```

with its callbacks expanded by the same `rawL`, `logL`, `predL`,
`bundle`, `inner`, `outer`, `access`, `diamond`, `good`, `rel`,
`classCode`, `unionCode`, `tagged`, `form`, `pair`, `part`, and `lift`
definitions displayed in the manuscript. `probe` substitutes the
supplied code `i` for the one free slot in that fixed template.

`type_preservation` and `formula_preservation` are universal compiler
soundness theorems: for every supported specification and every
`TypingInterpretation` of the primitive typed syntax, every generated
data/formula expression has its indicated target typing. The
interpretation's `data` and `formula` predicates mean typing in a chosen
valid realization of the indexed context, with the indicated family
types already sorted. Its primitive fields express the actual PTS
derivation rules and upstream wrapper/logical/marker judgments, not the
four desired output laws. `uniform_probe_typed`, `access_typed`, and
`lift_typed` instantiate this theorem at the actual expanded macros.

This is a **relative typed-macro theorem**, not a new deep embedding or
independent proof of all labelled PTS metatheory. Interpreting its
primitive signature as the manuscript's PTS remains an explicit
upstream obligation. In particular it does not certify the earlier
graph-path existence proof or construct the primitive terminals.
It does resolve the new macro-level binder/product question: no
additional directness of `p` or `k`, missing function-space rule, or
predicate comprehension is silently introduced.

## Every binder and its supporting product

| Construction | Bound source | Target/sorting support | Exact source labels |
|---|---|---|---|
| `Raw`, `Log`, first-channel predicate | `B`, `B`, `Lc` respectively | odd `alpha:k->p`, `lambda:k->j`, `eta:p->h` | `chan-basic-types`, `chan-raw-log`, `chan-paths` |
| Bundle | `f:F(A)` | odd `alpha:k->p`, result `Single(A):p` | `chan-single`, `chan-bundle-definition` |
| `f_i`, `f_e` | `o':M(A)`, `o:M(A)` | odd `beta:p->k`, result `F(A):k` | `chan-access-definition` |
| `pred(x.Psi(o,x))` in `f_i` | callback `c:Lc(A)`; `x` is exact substitution by `Log(c)` | odd `eta:p->h`, result `PL(A):h` | `chan-raw-log`, `chan-predicate-evaluation` |
| Native inner data lambda | `w:Single(z-downarrow):p` | **`(p,n,g)`**, body `send_n(...):U_n:n`, result `Fun:g` | `chan-fun`, `rel-lifts` |
| Native even pack/use | `f:Fun(A):g` in its formula callback | even `kappa:g->J` | `chan-diamond`, `chan-paths` |
| Native outer data lambda | `z:Z:I` | **`(I,J,k)`**, codomain `W_kappa(Fun(z-downarrow)):J` | `chan-z`, `chan-v`, `rel-lifts` |
| `Raw_X`, `Log_X`, `pred_X` | `V`, `V`, `Xc` | same odd `alpha`, `lambda`, `eta`; `Xc:p`, `X:j`, `PX:h` | `chan-x-types`, `chan-x-evaluation` |
| Lift's `mk_X` | `v:V:k` | odd `lambda:k->j`, result `X:j` | `rel-lifts`, `lem:enc-data-cancellation` |
| Logical `forall/exists` over `L,X` | fixed direct annotation `j` | its fixed triple `(j,J_j,K_j)`, `J_j,K_j` in the logic SCC, and fixed even proof paths | wrappers' direct-domain construction; channels' final quantifier table |
| Logical `forall/exists` over `PL,PX` | fixed direct annotation `h` | its fixed triple `(h,J_h,K_h)` and fixed even proof paths | same |

`Syntax.Support` permits any assignment of the vertex names, including
coincident vertices and nonfunctional specifications. Sort support is
not asserted to be an exact profile. It requires the two displayed
native product rules, the fixed path supports, and directness only at
`j,h`. All products internal to a primitive path wrapper belong to the
explicit upstream path-formation interface.

No PTS product is asserted for schematic `o:M`, `m:M`, `i:PX`, or
`A:s` merely because a Lean proof or term-builder takes that parameter.
Only the displayed native data lambdas and the primitive wrappers
introduce such binders. Formula-building notation denotes a typed
syntactic callback, not an object-level function from an arbitrary
non-direct type to the logic vertex.

## Primitive realization interface, not hidden output assumptions

`Primitives` contains only data constructors for the explicit callback
codes. `Callback.user` holds a supplied typed formula symbol;
`Callback.probe` holds an actual predicate code. There is **no**
constructor taking an arbitrary semantic predicate and returning a
predicate code, and no assertion that every function has a code.
`PredicateCode` contains only the named callback/class/union/pair/part
schemata. `FCode`, `SingleCode`, `XCode`, and `SendCode` quote their
displayed callback bodies. The corresponding interpretation functions
spell out those bodies using exactly the original data parameters.

`PrimitiveLaws` exposes these upstream inputs:

1. `predicate_cancel`: rounded evaluation of a supplied typed first
   channel predicate callback (`chan-predicate-evaluation`).
2. `f_cancel`, `single_cancel`, `x_cancel`: the generic odd-wrapper
   cancellation builder at the quoted callback and its **exact** input
   (`lem:enc-data-cancellation`, `chan-cancellation`).
3. `dummy_flag`, `point_flag`, `point_query`: the marker/decoder/point
   facts (`chan-marker-laws`, `chan-point-laws`, `chan-point-query`).
4. `beta_z`: application of the actual outer labelled lambda to
   `A-up`, using `(A-up)-down =_beta A` and the fixed wrapper choices.
   `beta_w`: application of the actual inner labelled lambda to its
   exact bundle argument. These two equalities are **native beta
   conversion**, not equality inferred from a logical biconditional.
5. `pack_use`, `read_send`: the even wrapper and read/send
   biconditionals (`chan-cancellation`, `eq:enc-read-send`).
6. `round_observe`: primitive `X` observational rounding
   (`chan-x-evaluation`), used only for the additional `round_equiv`.

The primitive signature's native compiler is the above literal
`probeTemplate`; `compileW` is its inner lambda and `compileZ` its
outer lambda. The relative typing theorem checks that template, while
`probe_rounded_notD` derives its formula observation by `beta_z`,
`pack_use`, `beta_w`, `read_send`, and the separately proved
`access_exact`, in that order. The primitive interface does **not**
contain `lift_congr`, `lift_valid`, or `probe_rounded`.
`raw_lift_cancel` is the specialization of generic `x_cancel` to the
literal `sb` callback; it is not an extra assumed lift law.

## Admissibility and the four guarded-core fields

`Adm` is exactly `not D(m)` and congruence of each of the seven tags
other than `pt` under `ApproxL`. It does not impose congruence of `pt`.
The stronger specialized query realization, tagged pair-left/right
laws, response hypotheses, and extensionality of predicate codes are
not assumed. `class_eval`, `union_eval`, `class_congr`, `union_congr`,
`tagged_congr`, `form_congr`, `pair_eval`, and `pair_congr` prove the
generic relational preliminaries directly from rounded predicate
evaluation, the definition of `Rel`, and this generic `Adm`.

`RealizedLaws` has precisely the types of the reviewed core's
`lift_cancel`, `probe_rounded`, `lift_congr`, and `lift_valid`, under
the interpretation `observe=[xv]`, `diamond=v diamond_m y`,
`evalX=i@x`, `roundL=Round`, and the displayed `lift/probe/sb`.
No data equality is used to transfer pointwise-equivalent predicate
codes. Query congruence is applied only after proving the required
pointwise comparison.

The accepted core is not recompiled, imported, or retrospectively
declared unconditional. Its remaining tag law and its other ten laws
are not discharged by this node. Its four original upstream assumption
groups are preserved; a group containing several laws must not be
retired merely because some of its fields are now supplied.

## What the checks do and do not establish

The unbounded result is the Lean proof, over arbitrary carriers,
contexts, callback syntax, data parameters, and code carriers. The
finite functional replay and SAT query are independent checks of the
expanded local Access calculation, not substitutes for that theorem.
Deleting `not D(m)` or replacing the exact parameter in the callback
produces diagnostic failures; neither is a false manuscript assertion,
because the manuscript includes the guard and exact substitution.

`verify.py` records a fresh real Lean 4.31.0 compiler result through
the official evidence command with `--claim`, and both campaign-local
checks. The main realization and typing theorems use no axioms. The
closed-template Boolean normalization additionally uses Lean's standard
`propext` through generated recursive definitions; no custom axiom,
`sorry`, or `admit` is used.

An independent Reviewer must still assess this correspondence between
the code schemata, primitive judgments, and manuscript. Neither that
review, independent realization of the primitive PTS fragment,
specialized pairing, observation substitution bounds, full
normalization, nor publication-level novelty is asserted by compilation.
