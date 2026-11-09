# Rounded ranges and the manuscript search

**Assessment: the range/parameter arguments and conditional search transfer
are supported; the entropy inputs remain explicit rather than becoming
compiler-certified.** All three `C_ER_SEARCH` versions are one assertion,
with a progressively more honest dependency envelope.

## Exact claim and version accounting

Under all hypotheses of `lemma:compression`, Section 04
`entropy-refinement:search` asserts a finite-valued refinement `W` and index
`j` such that

```
G_1(empty)-G_1(W) <= C*D_*^2/(E*h^2),
K_{m_{j,1}}(W;r_j) <= K_{m_{j,0}}(W;r_j)+E,
```

with numerical `C`, uniform in the finite letter set. The claims are
`L_ER_RANGES@1`, `L_ER_PARAMETERS@1`, and `C_ER_SEARCH@1,@2,@3`.
They use old context `CTX_ER@1`. The old report and Section 04 reference
bytes are bound in the index; the manuscript source matches reference
revision `4eaee87548250b2682affda7d05d947c05554bae`.

Search v1 has no recorded external inputs, v2 adds `A_CONTEXT_BOUNDS`,
and v3 also adds `A_BLOCK_GLUE`. All three have the same natural statement
and content hash
`9fb6c39dd8099db603f229df80abafee67fbb00ef0e2ba76fd45fd643a437c87`.
The old schema did not change that hash when assumptions were added.
Accordingly a subject-hash judgement does not independently verify each
dependency envelope; the review displays all three rather than collapsing
the missing-assumption history.

## Ranges and asymptotic parameter check

Here `w=(log d)^(1/4)`, `h=log log d=4 log w`,
`T=floor(d h^-5)`, `T_0=floor(T/4)`, `L=d exp(w)`,
`m_*=floor(exp(w^3))`, and
`M=floor(w^2/6-w/3)+1`.
Section 04 defines

```
m_{j,0}=ceil(exp(w^2+3*w*(M-j))),
r_j=floor(T_0/(2*m_{j,0})),
m_{j,1}=ceil(L/r_j).
```

The largest unrounded lower endpoint is at most `exp(w^3/2)`, while
`T_0` has order `d/h^5`. Thus `T_0/(2*m_{j,0})` tends to infinity
uniformly, justifying the floor bound
`T_0/(4*m_{j,0}) <= r_j <= T_0/(2*m_{j,0})`.
Consequently `m_{j,1}/m_{j,0} <= 4L/T_0+1/m_{j,0} <= exp(2w)`
eventually. Adjacent lower endpoints have ratio at least
`exp(3w)/(1+exp(-w^2)) > exp(2w)`. This separates the **whole rounded
ranges**, not merely their unrounded lower endpoints. The unrounded row
counts grow by that divergent ratio while their minimum tends to infinity,
so taking floors preserves strict increase.

The same bounds give
`r_j <= T exp(-w^2)/8`, `2r_j m_{j,0} <= T_0`,
`L <= r_j m_{j,1} < L+r_j < 2L < d^2`, and
`exp(w^2) <= m_{j,0}<m_{j,1}<=m_*` eventually. In particular
the context and low-end cost domains are respected. These estimates are
uniform in index and alphabet; thresholds may depend on the manuscript's
fixed `D_0,P_0`.

Put `n=floor(sqrt M)`, `N=floor(M^(1/10))`, `t=log N`, `ell=log n`,
`q=ceil(2*t^2)`. The integer `N^5 <= sqrt M` implies `n>=N^5`.
With `N>=4`, the formal specialization's hypotheses hold. The partition
fits because
`N*q*n <= M^(3/5)*(1+(log M)^2/50) <= M` eventually.
For `w>=12`, `w^2/12<=M<=w^2` and `log M>=log w`.
For sufficiently large `M`, flooring gives
`log n >= log M/4`, `log N >= log M/20`. Hence the old report's loose,
but valid, numerical constant is

```
4*alpha_1 = 400000/(log n*log N) <= 512000000/h^2.
```

This final asymptotic translation is prose, not a Lean theorem about `d`.
The explicit scalar inequalities themselves are universally proved in the
Lean specialization; the three exact finite samples are only diagnostics.

## Transfer fidelity and conditional scope

Use the preorder of finite further context refinements and substitute

```
a_j=I_{r_{j+1}}/D_*,
H_j=G_{m_{j+1,1}}/D_*, L_j=G_{m_{j+1,0}}/D_*,
cost=(E/D_*)*(G_1(empty)-G_1(W))/D_*,
good=[the desired K inequality].
```

Context bounds, ordered ranges and the offer argument in the entropy-inputs
unit verify exactly the model hypotheses. The zero-based shift is necessary.
After the last manuscript index, extending `a=1`, `H=L=0`, `good=true`
preserves index order, time monotonicity and offers. The witness is before
`N*q*n<=M` and therefore never uses this artificial tail. Finitely many
finite-channel updates leave a finite-valued context. Undoing normalization
gives entropy loss `4*alpha_1*D_*^2/E` and the displayed numerical bound.

The old independent records
`judgement-L_ER_RANGES-17e286d38f8c`,
`judgement-L_ER_PARAMETERS-b7382660f775`,
`judgement-C_ER_SEARCH-4a5a583af884` support these arguments.
The range/parameter and search opinions cite the report, whose bytes match
the preserved manifest. The earlier engineer search judgement
`judgement-C_ER_SEARCH-727008c335b9` was inconclusive; it is not an
independent refutation. The graph's blanket open flags are not a stronger
mathematical verdict than the subsequent matching independent support.

For this review the old search is **partially supported as an unconditional
audit result, supported as the stated conditional reduction**. To discharge
its remaining entropy scope, establish the particular constructed `nu,Psi`
and all contextual/gluing hypotheses under the original compression
assumptions, with the same uniform constants. Neither the finite source
nor its certificate does that. Historical v1 additionally failed to expose
those dependencies. This is a concrete boundary on the evidence, not a
claim that the source proposition is false or that another numerical search
would settle it. No new result or literary novelty is asserted.
