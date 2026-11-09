# Combined arithmetic boundary gluing

**Assessment: substantial partial support, but not an established combined
theorem.** This unit covers all seven versions `C_ABG@1` through `C_ABG@7`.
They have the same mathematical statement; later versions progressively
record six external assumptions. They are not seven drafts or results.
The source is old `theorem.md`, Statement and Sections 1-7, with the
informal `statement_fidelity.md` and shared computational evidence.

## Exact statement and hypotheses

Let \(k_0=\mathbb F_q\), \(\ell\ne\operatorname{char}k_0\),
\(L/\mathbb Q_\ell\) finite, \(n\ge2\), and \(X_0/k_0\) a smooth
projective geometrically connected curve with a nonempty finite reduced
divisor \(\Delta_0\). A continuous arithmetic parameter
\[
 \rho:\pi_1^{\mathrm{et}}(X_0-\Delta_0)\longrightarrow
 \mathrm{PGL}_n(L)
\]
has dense geometric image, kills wild inertia, and has unipotent tame
boundary. The draft claims, without extending \(L\):

- A pointed lift over \(D=\operatorname{Frac}W(k_0)\), and a
  geometrically connected degree-\(e\) auxiliary cover, for one
  \(e>1\) prime to \(\ell\), totally ramified at every marking with
  unchanged residue fields.
- A compact-valued lift of the entire prescribed arithmetic torsor tower
  over \(\bar D\), with exact geometric image and boundary transports;
  its pullback has logarithms \(eN_i\).
- A simultaneous projective nodal smoothing and a dense unramified
  \(J\)-valued parameter on the smooth geometric generic curve over
  \(\Omega=\overline{\bar D((s))}\), recovering the component systems,
  prescribed semilinear action, and every tensor comparison.

Arbitrary Jordan types, zero logarithms, nonsemisimple return matrices,
and Frobenius-permuted punctures are explicitly included. The empty
divisor remark uses an auxiliary unramified marking. The conclusion is
about parameters and their specialization data, **not** Weil structures
on geometric eigensheaves or a proof of an entire manuscript family.

## Dependency assessment

The [primary grading](../primary_space_grading/report.md),
[common compact group](../common_compact_group/report.md), and
[Kummer cover](../simultaneous_kummer_cover/report.md) have supported
written arguments in their stated scopes. The
[component lemma](../component_partitions/report.md) is supported on its
specified proper tame trait. The
[gluing](../balanced_torsor_gluing/report.md) and
[density](../monodromy_density/report.md) arguments are supported
**given** the compatible lifted systems and actions.

The missing link is [arithmetic-lift obligation F1](../arithmetic_tower_lift/report.md).
Section 3 moves from \(W(\bar k_0)\) “and then to \(\bar D\)”
without specifying the comparison of the completed unramified generic
base with the asserted algebraic generic fiber. Exact geometric images,
chosen Frobenius action, boundary frames, and all tower transitions have
to survive that comparison. Proper henselian invariance and the component
lemma do not themselves identify those fields. This is a concrete
unsupported step in the written argument, not an explicit counterexample
to the theorem. This review does not supply a repair.

F1 blocks the claimed unconditional arithmetic tower and therefore the
combined conclusion. Later correct manipulations of supplied transports
cannot manufacture the missing input. The six geometric assumptions in
`C_ABG@7` are recorded with their original citations and source readings:
`A_RYDH_PROPER`, `A_LO_ROOTS`, `A_OLSSON_BALANCED`, `A_RR_JETS`,
`A_CURVE_DEFORM`, and `A_PROPER_COHOMOLOGY`. Their hypotheses and
limitations are assessed in the linked unit reports.

## Reconciliation of old receipts and graph labels

The old ledger contains independent support for GRADING, COMPACT, COVER,
COMPONENT_ORBITS, GLUE, and DENSITY, but independent **inconclusive**
receipts for LIFT, `C_ABG`, and NOVELTY. In particular
`judgement-C_ABG-03081a937480` does not accept the theorem; the earlier
`...-e216b4588a0d` is the author's support. All are preserved with their
original attribution in the current ledger and coverage index.

The old graph marks every node open and `reviewer_confirmed:false`.
Those coarse labels are compatible with supported informal subsidiary
arguments, conditional applications, and an unresolved combined goal.
They must not be used either to erase the six support receipts or to
promote them to a closed combined proof. No kernel evidence exists.

## Computation, fidelity, and attribution

The non-writing [replay](../computation/replay.json) passed in 1.01 seconds
with Python 3.13.5 and SymPy 1.14.0, using the existing system interpreter
after the Argus environment lacked SymPy. Default execution recomputed
and exactly compared the archived certificate; it did not rewrite it.
The 58 partition/basis cases, four additional primary cases, four compact
fixtures, twelve finite stages, orbit fixture, and jet polynomial are
finite algebraic checks, including symbolic identities for fixed matrices.
They do not certify root-stack descent, a universal geometric construction,
F1, density on all curves, or originality.

`statement_fidelity.md` is an informal scope reading; its final limitation
correctly separates universal geometry from the checker. It is not a
Lean statement-fidelity certificate. No `.lean` source or real compiler
run belongs to this inventory, so no formal verification is asserted.

At the manifest revision, the Frobenius manuscript's
`lem:compact-conjugator` and `prop:nodal-parameter` supply the regular
one-rational-puncture comparator. The several-point manuscript supplies
geometric multi-node constructions with arbitrary, possibly zero
nilpotents, explicitly without Frobenius. The old draft proposes a
parameter-level arithmetic strengthening combining those scopes. It is
neither an established new theorem nor a demonstrated flaw in either
manuscript. [Originality remains unresolved](../originality_scope/report.md).

Compared with the strongest relevant prior evidence, this review preserves
the six supported subsidiary arguments and makes their conditional use
and the inherited field-comparison gap explicit. It produces no stronger
mathematical theorem. Native independent review of the complete family,
not author acceptance, is still required.
