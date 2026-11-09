# Supplied-data local normalization

**Engineer assessment: supported as a prose algebra theorem conditional on the
declared Jacquet model; the exact replay succeeds.** Identifying that model
with the intended automorphic representation is a different obligation.
Native independent acceptance is pending.

## Claim, source and attribution

This unit covers `C_REFLECTION_ALGEBRA`, `C_WHITTAKER_NORMALIZATION` and
`C_MASKS_AND_LOCAL_WEYL`, not three independent discoveries. Its draft is
old `research/reflection_audit/REPORT.md`, Section 2; its checker/output are
`verify.py` and `exact_certificate.json`. The corresponding manuscript
arguments are the primary paper's `10-whittaker-calculation.tex`,
Sections "The shells of the Jacquet integral" onward, and
`04-reflection.tex`, Lemma `reflection-local-Weyl`. All these manuscript
sources agree with reference revision
`4eaee87548250b2682affda7d05d947c05554bae`.
The manuscript directories are links to the assigned reference sources,
not independent archived copies; this identifies the version read now,
not immutable manuscript bytes from the old run.

The hypotheses are a prime power `q = 1 mod 12`, an exact order-six residue
character `chi`, a nontrivial conductor-zero additive character, the specified
torus lifts, inducing datum and stable Jacquet shell rules. Every character
power is extended by zero on nonunits, including exponent zero. Consequently
`chi(-1)=1`. These hypotheses are essential; the checker does not construct
the cover or prove the shell rules from representation theory.

This is an Argus verification/reproduction of formulas also present in the
supplied manuscript, using classical character orthogonality. No priority or
novelty is established, and no counterexample is exhibited.

## Decisive argument

Write `G_j = sum chi(x)^j psi(x)` with the mask. Then `G_0=-1` and
`G_j G_(-j)=q` for nontrivial powers. Expanding the product and summing the
additive character over nonzero residues proves the latter identity, since
`chi(-1)=1`. In particular all denominators used below are nonzero.

For `e=3k+r`, the accumulated ball and nonoscillating shells have coefficient
`C_k=q^k`: the base is `C_0=1`, and
`C_(k+1)=C_k+(1-1/q)q^(k+1)=q^(k+1)`. Deep shells vanish by additive
orthogonality; the terminal shell is retained, including its trivial-character
value `-1/q`. With `A=G_2`, `B=G_4`, `AB=q`, it follows that

```text
J_0 = e_0 + q^(-2/3) B e_2,
J_(3k)   = q^(-k) J_0,
J_(3k+1) = q^(-k-1) A J_0,
J_(3k+2) = 0.
```

The nonzero `e_0` coordinate makes normalization legitimate. The measure,
modular and inducing factors multiply to `q^(-2e/3)`; omitting the modular
factor would change the triple step. The induction and three residue classes,
not the finite experiment, cover every nonnegative valuation. Negative
valuations vanish by upper-root equivariance, subject to the stated spherical
model. Local uniqueness is needed to interpret these ratios as the chosen
Whittaker values; it is assessed in the representation unit.

For nontrivial `j`, Fourier coefficients are
`alpha_j(v)=chi(v)^(-j)/G_(-j)` for `v!=0`, and zero at zero.
For `j=0`, they are `alpha_0(0)=1-1/q` and `alpha_0(v)=-1/q` otherwise.
Their transform is the masked `chi(t)^j`, not the constant function for
`j=0`. With the declared Bruhat lift, the nonzero-digit transform is

```text
R_(j,e)(t) =
  W_e chi(t)^(4+2e) sum_(v!=0) alpha_j(v) chi(v)^4 psi(p^(e-1)t/v).
```

For `e>0`, the additive factor is trivial and the digit sum vanishes unless
`j=4`. At `e=0`, substituting `x=t/v` gives exponent `8-j`; the scalar is
`G_(j-4)/G_(-j)` for `j!=0`, and `-G_2/q` for `j=0`.
Thus the squared zero-valuation magnitude is `1/q` for `j=0,4` and one
otherwise. For positive valuations the triple recurrence is multiplication
by `q^(-1)`. **It does not include the step from e=0 to e=3.**

The positive supported values are bounded by
`beta(1+3k)=q^(-k)` and `beta(3k)=q^(1/2-k)` for `k>=1` in the latter
case; their squared ratio to the majorant is `(1-1/q)^2`.
Finally `1-4=3 mod 6` gives the quadratic row/column interaction, while
`2(3k)=0 mod 6` shows why arbitrarily large cube factors add no such
interaction. Shared primes of the squarefree factor and cube are not removed.

## Exact replay and its limits

The script was inspected before execution. Without `--write-certificate` it
computes its result and compares it with its neighboring old JSON; it does
not write. Execution used `-B`, preventing bytecode writes. No source or old
certificate was copied, edited or regenerated.

```text
$WORKSPACE/argus-live-update/.venv/bin/python -B \
  families/029/first-pass/reflection_audit/verify.py
```

Actual result: exit 0 in 10.791 seconds, Python 3.13.5, SymPy 1.14.0;
12 zero polynomial remainders, 78 Fourier-mask checks and 360 local-unit
checks. The exact command, toolchain, stdout and empty stderr are in
`replay.json`. The first harness attempt under `argus-latest` lacked SymPy
and did not start the checker; the successful non-Argus script used its
original SymPy-capable interpreter. No dependency was installed. Argus math
modules themselves were invoked with the assigned `argus-latest` interpreter.

The universal polynomial part checks the shell expressions modulo `AB=q`
and `T^6=q`, together with induction/exponent identities. The finite part is
arithmetic in `Q(zeta_78)`, representing `F_13` Gauss sums exactly, not
floating point. It cannot certify arbitrary residue-field orthogonality,
the validity of the supplied Jacquet model, global profile estimates, a large
sieve application or an analytic moment theorem. There is no Lean source or
Lean compiler certificate among the listed artifacts.

The old and fresh Jacobian runs use
`dirichlet_character.principal.compute` with exactly `{"modulus":13}`.
The inspected contract bounds the modulus by 2048. The fresh typed result,
payload, contract and exit receipt are under `jacobian/`: server 0.14.0,
protocol `2025-11-25`, MCP stdio, exit 0, no returned adapter error or timeout.
The values are zero at 0 and one at residues 1 through 12, identical to the
old typed output. This proves only that finite principal mask. The old
`Gauss` discovery found a binary-form reduction operation, not a suitable
Gauss-sum operation; not using it was correct.

## Disposition

The supplied-data all-valuation argument is materially stronger than the
`q=13` diagnostic, but was already in the old draft; this review does not
claim a new strengthening. The representation identification remains
conditional on the next unit. The global estimate and both manuscript main
theorems are not conclusions of this certificate. The retired old route
`R_FINITE_SAMPLES_ONLY` remains excluded for its stated mathematical reason.
