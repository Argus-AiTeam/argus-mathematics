# Statement fidelity: bounded Lorentz/contact algebra

## Scope and status

`Main.lean` is an independent algebraic formalization intended for the parent's
claim `C349_LORENTZ_ALGEBRA`. It does **not** by itself certify the entire
manuscript lemma `lem:family-all-levels`. In particular, the analytic
chain/quotient-rule bridge and the geometric identification of the contact
matrix remain in the prose proof, as detailed below. This task does not run
`lean_evidence` or modify the claim ledger.

All inner-product statements are universally quantified over an arbitrary real
inner-product space `E`; there is no restriction to a sampled dimension.
All matrix/product statements use arbitrary finite index types, including the
empty type. The rectangular ambient index type is independent of the square
matrix index type.

## Dictionary

Write `ip` for the real inner product. The definitions in the source are:

| Mathematics | Lean definition |
|---|---|
| `B w = w + (C-1) ip(a,w) a` | `boost a C w` |
| `D = C - S ip(a,N)` | `denominator a N C S` |
| `B N - S a` | `normalNumerator a N C S` |
| `n' = (B N - S a)/D` | `transformedNormal a N C S` |
| `O w = B w + S ip(a,w) n'` | `tangentTransport a N C S w` |
| `Y = r O x + b n'` | `targetPoint a N C S r b x` |
| `h = (b + r S ip(a,x))/D` | `contactHeight a N C S r b x` |
| `H = r I - h A` | `contactMatrix A r h` |

Scalar division of vectors is represented by scalar multiplication by the
inverse. Unit vectors are expressed by `ip(v,v)=1`. Perpendicularity is
`ip(v,N)=0`. The time-coordinate function `lorentzHeight` below is distinct
from the contact coefficient `contactHeight`.

## Lorentz and tangent-space core

`boost_add` and `boost_smul` prove linearity directly from the definition.
`axis_inner_boost`, `boost_inner_boost`, and `boost_inner_numerator` prove
the boost identities by bilinear expansion, rather than taking them as
hypotheses. `transport_add` and `transport_smul` likewise establish linearity
of `O`.

`lorentz_contact_core` assumes precisely

* `ip(a,a)=ip(N,N)=1`,
* `1 <= C`, `0 <= S`, and `C^2-S^2=1`.

It proves, together:

1. `D>0`;
2. `ip(n',n')=1`;
3. `ip(O w,n')=0` for every `w` perpendicular to `N`;
4. `ip(O w,O u)=ip(w,u)` for every `w,u` perpendicular to `N`.

The corresponding individual theorems are `denominator_pos`,
`transformed_normal_unit`, `transport_tangent`, and `transport_inner`.
The latter three use only `D != 0` and the algebraic unit/hyperbola
assumptions; the combined theorem derives this nonvanishing from positivity.
In particular, no isometry or boost identity is assumed.

For arbitrary `y,b`, define `z = B y + b S a` and `t = C b + S ip(a,y)`.
`lorentz_norm_identity` proves

    ip(z,z) - t^2 = ip(y,y) - b^2.

`lorentz_spatial_inverse` and `lorentz_height_inverse` prove the inverse
identities

    B z - S t a = y,       C t - S ip(a,z) = b.

These are identities for every `y,b`, not merely on a contact set. They do
not assume positivity, invertibility of a contact matrix, or orientation.

`target_point_unit` proves `ip(Y,Y)=1` when additionally
`ip(x,x)=1`, `ip(x,N)=0`, and `r^2+b^2=1`. This result does not assume
that `Y` is unit or that `O` is an isometry.

## Source-dependent first-order jets

These statements formalize first-order algebra, **not manifold
differentiation in Lean**. The intended source jet has

    dx=w,  dN=k,  df=ip(a,w),  dg=ip(a,k),
    f=ip(a,x),  g=ip(a,N),

with `a,C,S,r,b` held constant. The analytic chain/quotient-rule bridge
is in the prose proof: bilinearity gives
`dD=-S ip(a,k)` and `d(BN-Sa)=Bk`, and the ordinary quotient rule gives

    k' = (1/D) Bk + (S ip(a,k)/D^2) (BN-Sa).

`normalJet` is exactly this displayed quotient-rule expression, not a
free variable or an assumption of `k'=D^-1 O k`. The theorem
`normal_jet_eq` proves the latter equality from the definitions.

The product rule for the actual expression
`Y=r(Bx+S f n')+b n'` gives

    dY = r(Bw + S ip(a,w) n' + S f k') + b k'.

`targetJet` is exactly this full product-rule expression, with `k'`
expanded through `normalJet`. The theorem `target_jet_eq` proves

    targetJet = O (r w + h k),    h=(b+r S f)/D.

In particular, the source dependence of `N` is retained; the `S f k'`
term is present. `target_jet_shape` then specializes `k=-A w` for an
arbitrary real linear map `A` and derives

    targetJet = O (r w - h A w).

This conclusion is **not a hypothesis**. The jet equalities are valid
for every source jet and `D != 0`; they do not need a constant-normal
assumption or a special dimension.

`target_jet_inner` also proves that the inner products of two such
product-rule jets equal the inner products of `r w+h k` and
`r u+h l`, provided `w,k,u,l` are perpendicular to `N`.
`transported_orthonormal_frame` proves that every orthonormal family
in `N`'s perpendicular space remains orthonormal after applying `O`.

Not formalized here: a smooth manifold, an immersion, a normal field,
the proof that its differential is `-A`, or a `HasFDerivAt`/manifold
chain-rule theorem identifying `normalJet` and `targetJet` with actual
differentials. Those identifications require the regularity hypotheses
of the prose argument. The algebraic theorem alone must not be described
as a formalized manifold differentiation proof.

## Determinant bound, including the semidefinite boundary

`nonnegative_product_bound` proves for an arbitrary finite family
`values i >= 0` that

    sum values = card * r
      => 0 <= product values <= r^card.

It uses the library real AM-GM inequality. No entry is assumed positive.
For a nonempty family the proof derives `r>=0`; for an empty family both
products are `1`, so no assumption on `r` is necessary.

`contact_eigenvalue_bounds` specializes this to

    values i = r - h * kappa i,       sum kappa = 0.

It assumes only the displayed trace condition and nonnegativity of these
contact eigenvalues. It allows arbitrary real `h`, including `h=0`,
and zero eigenvalues.

The source also proves the full matrix result, not just an eigenvalue
surrogate. `psd_determinant_bounds` assumes a real square matrix
`H.PosSemidef` and `H.trace=card*r`, and proves

    0 <= det H <= r^card.

Mathlib's formal Hermitian spectral theorem supplies
`Matrix.IsHermitian.trace_eq_sum_eigenvalues`,
`Matrix.IsHermitian.det_eq_prod_eigenvalues`, and
`Matrix.PosSemidef.eigenvalues_nonneg`. Thus the spectral bridge for
this generic matrix theorem is inside Lean, not an unformalized
spectral assumption. `PosSemidef` includes Hermitian symmetry.

`contact_matrix_determinant_bounds` applies this result to `H=rI-hA`
when `trace A=0` and `H` is positive semidefinite. No positive
definiteness, matrix invertibility, or nonzero eigenvalue is assumed.

## Rectangular metric Jacobian and its contact bound

For arbitrary real rectangular `Q` and square `H` with `Q.transpose*Q=I`,
the source proves:

* `rectangular_gram_factor`:
  `(QH).transpose*(QH) = H.transpose*H`;
* `rectangular_gram_determinant`:
  `det((QH).transpose*(QH)) = (det H)^2`;
* `rectangular_gram_jacobian`:
  `sqrt(det((QH).transpose*(QH))) = abs(det H)`.

These three theorems place **no** positivity or invertibility
hypothesis on `H`. They are orientation-free and include singular
`H`, either determinant sign, and zero-dimensional square factors.

`contact_metric_jacobian_bounds` adds only `H.PosSemidef` and
`trace H=card*r`; it proves that the metric Jacobian equals `det H`
and belongs to `[0,r^card]`.
`contact_matrix_metric_jacobian_bounds` gives the same conclusion
for `H=rI-hA`, `trace A=0`, on the semidefinite contact set.

The remaining geometric bridge is the choice of orthonormal source
tangent bases and identification of the actual differential with
`QH`, where `Q` represents the already-proved tangent-space isometry
`O`. The geometric shape operator's symmetry, its trace-zero
condition, and the contact-set semidefiniteness must come from the
manuscript's geometric hypotheses; they are not derived from
arbitrary `x,N` in this file. There is no global area formula,
surjectivity, degree argument, contact-set existence theorem,
integration theorem, or verification of manuscript citations here.

## Compiler evidence

The installed compiler was checked first and reports:

    Lean (version 4.31.0, x86_64-unknown-linux-gnu,
          commit 68218e876d2a38b1985b8590fff244a83c321783, Release)

The compiler workspace is the existing
`$WORKSPACE/.local/share/argus-skill/mathlib-v4.31.0`; no
lakefile is created. The real compilation command is

    cd $WORKSPACE/.local/share/argus-skill/mathlib-v4.31.0 &&
      lake env lean families/349/first-pass/lorentz_contact/Main.lean

Submission/result receipts and compiler logs are retained under
`formal_dev/`. Failed development attempts are diagnostics, not
proofs or refutations.

The final receipt is `formal_dev/final-success-result.json`:
`state="done"`, `exit_code=0`, task
`c349-lorentz-final-success-001`, run
`c349-lorentz-final-success-001-1793878916839315689`.
`formal_dev/final-success-submission.json` retains the submitted
state, task/run identifiers, and the actual `check_with` operation.
The plain command displayed above succeeded; both its
`formal_dev/final-success/compiler.log` and the subsequent `.olean`
export log are empty (no errors or warnings).

The compiled source SHA-256, independently rechecked after completion, is:

    3db8f54e35dea44b7a82ff34bcc453111c6fb11cfce9308683e49e7af1322994

The additional `formal_dev/KernelCheck.lean` check imports the freshly
exported `Main.olean`. It successfully runs `#print axioms` on the
17 main result theorems listed there. The retained
`formal_dev/final-success/kernel-axioms.log` reports only the ordinary
Lean foundations `propext`, `Classical.choice`, and `Quot.sound`;
there is no `sorryAx` or custom axiom. The delivered `Main.lean`
contains no `sorry`, `admit`, user axiom, unsafe declaration, or
`native_decide`. This compiler evidence is not an official
`lean_evidence` ledger certification.
