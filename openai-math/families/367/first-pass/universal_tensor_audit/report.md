# Universal tensor proposition: semantic audit

## Statement and scope

The target is Proposition `cert:universal` of OpenAI, *The critical dimension
for one-phase Bernoulli minimizers*, September 24, 2026. All coefficients are
the literal integers of `build/appendices/tables.tex`, divided by 250000.
Tensor norms are full Euclidean tensor norms, not norms of lists of distinct
symmetric components.

The interior domain is
`A = A^T`, `tr A = 0`, `tr A^2 = 1`, `X` fully symmetric with all traces
zero, and `g^2 + |p|^2 <= 1`. The scalars `w,z` and the vector `ell` are
unrestricted real variables. The dimension of `STF^3(R^5)` is 30. There is
no positivity restriction on `g,w,z`, and no geometric realizability
hypothesis on these algebraic jets.

The boundary domain is `g=0`, `|p|=1`, `Ap=lambda p`, `lambda<0`, with the
same conditions on `A`. In particular `lambda=0` is excluded as a
counterexample. Orthogonal invariance allows a diagonal `A` and `p=e_5`;
the tangential eigenvalues need not be distinct or positive.

## What is already known, and what remains separate

Jerison--Savin, arXiv:1410.7463v1, Theorem 1.1 and Introduction, states
rigidity for stable homogeneous solutions with smooth cross-section in
dimensions at most four, and records the De Silva--Jerison minimizing
example in dimension seven. This source was opened at
<https://arxiv.org/html/1410.7463v1>. These are background inputs for
`5 <= d_* <= 7`, not assumptions needed to evaluate a tensor polynomial.
The source's hypotheses on the domain and stability must not be dropped.
The assigned Wiki index had no entries matching this manuscript or the
Bernoulli/tensor topic search; no Wiki proposition is used as an assumption.

The manuscript README expressly limits its supplied reproduction to
arithmetic: it does not certify formula-to-code equivalence or the analytic
proof. Reproducing agreement of its two graph engines is therefore not a
route to the present goal.

Even a full verification of the universal proposition would leave separate
analytic obligations: reduction of a first minimizing cone to a smooth
working link; transport of the gradient and strict boundary-sign bounds;
the normalized jet and curvature identities; the interior and boundary
flux comparisons; and passage through Hessian zeros and suspension tips in
the stability test. Conversely, an algebraically admissible violating jet
need not come from any minimizing cone.

## Verification theorem

Let `f,U,K,M,P` have precisely the component meaning and the coefficients
printed in Table I. On the full interior domain above, the following
stronger coercive estimate implies the claimed interior inequality:

\[
 \mathcal I\ \ge\
 \frac{673}{18400}w^2+
 \frac{438907}{12000000}z^2+
 \frac{2844869}{24900000}|\ell|^2+
 \frac{3479389}{7600000}|X|^2.                 \tag{1}
\]

On the full stated boundary domain,
\[
 \mathcal S\ge\frac{6984137359}{31250000000}.   \tag{2}
\]
The same boundary estimate holds on its algebraic closure `lambda<=0`.
No restriction on individual tangential eigenvalue signs is needed.
The polynomials are orthogonally equivariant (invariant for `f`), `U,K`
are even in `p`, and `P=0` at `g=0`. Thus this theorem verifies the complete
universal tensor proposition, not the analytic cone theorem.

The proof below supplies the semantic argument for the finite certificate.
`verify.py` checks the exact identities and all rational comparisons. It
imports neither manuscript graph engine nor any retained arithmetic output.
The bounds and sums coincide with those printed in the manuscript; this is
an independent certification, not a claim that those inequalities were
previously unknown.

## 1. Component semantics and sound symbolic operations

For a word of rank `r`, introduce a separate coordinate at every vector
endpoint and three coordinates at every cubic tensor. Multiply the
specified entries of `A^k`, `p`, `ell`, and `X`, the scalar prefix, and sum
every coordinate not in a free slot. Separate occurrences of the digit
`5` are separate `p` factors, not a repeated coordinate. The digit `7`
labels an entire cubic tensor, not a single coordinate. All coordinate
sums run from one to five. This is the literal Table I/II interpretation.

The symbolic implementation in `verify.py` encodes these Einstein sums.
The following facts prove its operations preserve their values:

1. Disjoint union is multiplication, with free slots renamed and distinct
   cubic occurrences kept distinct until their dummy labels are exchanged.
2. Tracing two free slots sums their common coordinate. If their incident
   paths are distinct, the equality
   `sum_i (A^h)_{ai}(A^k)_{ib}=(A^(h+k))_{ab}` joins those paths. If the
   two slots are on the same path, its contribution is `tr A^k`.
   Symmetry of every `A^k` justifies either edge orientation.
3. Sorting factors and exchanging the two *identical* copies of `X`
   preserve a product of scalar entries. Neither operation creates a
   factorial. The only discarded traces are `tr Id=5`, `tr A=0`,
   `tr A^2=1`, and contractions of two slots of `X` against `Id`,
   which vanish by trace-freeness.
4. A slot permutation just relabels the free coordinates. Consequently
   the implementation's `einsum` is literal tensor product followed by
   the requested traces and a final permutation. Its index signatures
   in `interior_row` are those of the displayed formula for `I`,
   including `D_l C_{lijk}` and both curvature contractions.
5. To differentiate `A^k`, differentiate each of its `k` factors,
   insert `X_l`, and subtract `k q_l A^k`. For a trace the `k`
   insertion positions agree cyclically. Each `p` incidence contributes
   separately, as `w A_{l i}-g z delta_{l i}`, and `g^h` contributes
   `h z g^(h-1) p_l`. These are exactly the declared derivation rules.
   The rules respect the reduced traces, since
   `D_l tr A=0` and `D_l tr A^2=2q_l-2q_l=0`.
   No differentiated expression or factor `X,w,z` is differentiated.

These are identities for arbitrary component values under the stated
symmetry, trace, and normalization hypotheses. Induction over the finite
expression tree therefore proves the symbolic expansion is an identity
on the *entire* admissible tensor domain. There is no interpolation,
finite-jet restriction, numerical inference, or assertion that a particular
sample is generic. Unimposed relations between distinct collected
monomials can only make the subsequent triangle bound less sharp.

As a semantic anchor, a single unscaled row `U=A` produces exactly
`5z^2+|X|^2-(21/25)|q|^2`, including full tensor multiplicities.
The supplemental direct component implementation in `tensor_semantics.py`
also checks each of the 231 Table I contributions separately, using exact
rational entries and independently differentiated dense tensors. It checks
the sum of all 19 Gram blocks directly as dense tensors as well. These
regressions detect translation errors but are *not* the universal proof;
the value-preserving identities and induction above are.

## 2. Positivity on the full tensor spaces

For every projection kind used in the nineteen blocks, the verifier
constructs its complete integer matrix on the ordered component basis:
dimensions `1,5,25,125` for ranks `0,1,2,3`. It checks, entry by entry,
`P^T=P` and `P^2=cP`, with positive scales

| Operator | Scale `c` |
|---|---:|
| rank 0 or 1, none | 1 |
| rank 2, anti | 2 |
| rank 2, sym | 10 |
| rank 3, sym | 42 |
| rank 3, hook | 48 |

It follows for every real component vector `v` that
`<v,Pv>=|Pv|^2/c>=0`. This is a universal finite-matrix certificate, not
an eigenvalue approximation or a test of selected tensors. With weights
`1` or `chi=1-|p|^2-g^2>=0`, all nineteen Gram blocks are nonnegative.
Their row-pair expansion uses twice the off-diagonal row product and
exactly the coefficient dot product within that block; no columns or
consecutive identical headers are merged.

## 3. Universal graph bounds, with the sharp cubic contraction

Put `theta=4/5`. If `alpha_i` are the five eigenvalues of `A`, then
`alpha_i^2 <= 4 sum_(j!=i) alpha_j^2`, so
`||A||op^2<=theta`. Hence
`|A^k|^2<=theta^(k-1)` for `k>=1` and
`|tr A^k|^2<=theta^(k-2)` for `k>=2`.

For the sharper trace estimate, maximize the cubic trace on the compact
trace-zero unit sphere of eigenvalues. The two constraint gradients are
independent. At an extremum the eigenvalues solve one quadratic equation,
so there are exactly two distinct values, with multiplicities `j,5-j`.
Their cubic traces squared are `(5-2j)^2/(5j(5-j))`. The verifier checks
the four possibilities `9/20,1/30,1/30,9/20` exactly. Thus
`|tr A^3|^2<=9/20`.

The load-bearing self-edge estimate is
`|X:A|^2 <= (5/7)|X|^2`. Here is its full algebraic derivation.
For a vector `v`, let
`B_ijk=(v_i A_jk+v_j A_ik+v_k A_ij)/3`,
and let `(J u)_ijk=delta_ij u_k+delta_ik u_j+delta_jk u_i`.
Then `tr_12 B=(2/3)Av`, `tr_12 J u=7u`, and
`F=B-J(tr_12 B)/7` is symmetric trace-free. The exact universal identity
is
\[
 |F|^2=\tfrac13|A|^2|v|^2+\tfrac{10}{21}|Av|^2.       \tag{3}
\]
The verifier expands (3) coefficientwise for a generic symmetric
trace-free matrix with 14 independent entries and a vector with five
independent entries. Equivalently, it checks the integer identity
`|7 SymSum(v tensor A)-2 J(Av)|^2
 =147 |A|^2 |v|^2+210 |Av|^2`,
as well as every symmetry and trace identity. This is a polynomial
identity, not a selection of matrices.

The same generic quartic identity is also proved in
`lean/Main.lean`, declaration
`UniversalTensorAudit.universal_stf_quartic`. A real Lean 4.31.0
compiler run succeeded with exit code zero and `proof_holes=[]`;
the axiom audit also exited zero. Mechanical evidence is attached to
`C_CUBIC_CORE`, with the archived certificate
`lean/certificates/C_CUBIC_CORE-7d26cc23babbd429.json`.
`lean/statement_fidelity.md` identifies the parameterization, all
quantifiers, full component multiplicities, and the precise limitations.
Neither source nor fidelity note has been edited since that run.
This is a kernel proof of the generic tensor algebra, not a conditional
coercive-margin lemma and not a kernel proof of the entire proposition.

Since `|A|=1` and `|Av|^2<=(4/5)|v|^2`, (3) gives
`|F|^2<=(5/7)|v|^2`. For STF `X`,
`<X:A,v>=<X,F>`, so Cauchy--Schwarz and vector duality prove the
claimed contraction bound. For a self-edge of power `k>=2`, ordinary
tensor Cauchy--Schwarz gives
`|X:A^k|<=|X| theta^((k-1)/2)`.

After reducing self-edges, there are at most two cubic vertices and all
other vertices are vector leaves. Each connected component therefore is
an edge between leaves, one cubic with three leaves, or two cubics joined
by one, two, or three paths, with remaining leaves. For the last case,
contract the leaves first and apply
`|<Y,(A^k1 tensor ... tensor A^kr) Z>|
 <=|Y||Z| product ||A^ks||op`.
This includes three parallel paths without a spurious dimension factor.
Disconnected components multiply. The incidence and two-cubic
restrictions are checked for every retained term by the verifier.

If a monomial contains `g^h` and `b` copies of `p`, the square of that
factor is bounded jointly, not separately: for positive `h,b` its bound
is `(h/(h+b))^h (b/(h+b))^b`, by maximizing `s^h t^b` on
`s,t>=0`, `s+t<=1`. If either exponent is zero, the bound is one.
Combining the preceding factors gives exactly the rational `L_t^2`
stored for each term, and
`|M(t)|<=L_t y_i y_j` for
`y=(|w|,|z|,|ell|,|X|)`.

## 4. Exact interior identity and coercivity

Let `Gamma` be the nineteen nonnegative blocks and
`d=(2/25,2/25,1/4,1)`. Sound expansion gives the identity
\[
 Q^2(\Gamma+\sum_i d_i y_i^2-\mathcal I)
       =\sum_t N_t\mathcal M(t).
\]
All 1714 integer coefficients `N_t`, degree types, squared bounds, and
upward-rounded numerators are recorded in `exact_certificate.json`.
No floating-point square root is used: `n_t` is the smallest integer
with `n_t^2 >= 10^10 L_t^2`. For each diagonal type the scaled error
sum receives `2|N_t|n_t`; for each off-diagonal type it receives
`|N_t|n_t`. These are precisely `2*10^5*Q^2 (D0)_ij`.
All ten exact sums and term counts are compared with the printed
`cert:exact-interior-sums` table.

Entrywise `D0<=Dbar`, with
\[
 \overline D=10^{-5}
 \begin{pmatrix}
2571&773&2358&3087\\
773&2157&926&1002\\
2358&926&4845&4948\\
3087&1002&4948&8037
 \end{pmatrix}.
\]
For `nu=(2484,1440,996,304)>0`, the verifier computes
`d_i-(Dbar nu)_i/nu_i` as the four strictly positive coefficients
in (1). Weighted Young's inequality, applied to nonnegative `y_i`,
gives `y^T D0 y <= sum_i ((Dbar nu)_i/nu_i)y_i^2`.
The triangle bound for the remainder and `Gamma>=0` now prove (1).
The smallest slack is exactly `epsilon_*=438907/12000000`; in
particular the `z^2` and `|ell|^2` coefficients are at least that
number. Setting `X=w=z=0` and taking `|ell|=1` proves `f>=epsilon_*`
for every allowed `A,p,g`.

## 5. Direct symbolic boundary computation

Orthogonal invariance allows `p=e_5` and
`A=diag(x_1,x_2,x_3,x_4,lambda)`, where
`lambda=-sum x_i` and `R=sum x_i^2+(sum x_i)^2=1`.
Put `b_i=lambda x_i-x_i^2`. Directly from the tensor components,
\[
 \mathcal S=-\lambda f+U_{55}+M_5+
 \sum_{i=1}^4 b_i(U_{ii}+C_{5i5i}+C_{5ii5}).
\]
In particular `C_{55jk}=0` removes the all-normal term of the skew
contraction. The verifier evaluates this formula row by row as an
ordinary four-variable polynomial, without using the interior
contraction engine, and checks permutation symmetry and degree at most
five. It evaluates both boundary square blocks by their coefficient
dot products.

For a degree `j` monomial multiply by `R^floor((5-j)/2)` before
collection. This preserves its value on `R=1`. Average over all 24
tangential permutations. Sorting an exponent vector and summing the
coefficients over its orbit is the coefficient of the *averaged*
monomial; there is no further factor of 24. This gives
`Lambda+1/4-S=sum_beta e_beta Av(x^beta)` on `R=1`.
All eleven coefficients agree exactly with
`cert:eleven-coefficients`, and
`Q^2 sum |e_beta|=1656725282`.

Every `|x_i|<=1` on `R=1`, hence every averaged monomial has magnitude
at most one. Since `sum x_i=-lambda>0`, the `H`-weighted square block
is nonnegative; so is the unweighted block. Consequently
`S>=1/4-1656725282/Q^2=6984137359/31250000000`, proving (2).
The proof itself also works at `lambda=0`. Repeated eigenvalues do not
require a limiting argument or a division.

## Reproduction and limitations

From the campaign root, run:

```sh
$WORKSPACE/argus-live-update/.venv/bin/python research/universal_tensor_audit/verify.py
```

Only Python, NumPy, the staged printed LaTeX inputs, and the files in this
directory are required. The script recomputes the identity coefficients,
bounds, margins, projection identities, generic quartic identity, and
supplemental exact component checks, then compares every certificate field.
The numerical search in `search.py` is exploratory only. Its initial
saved numerical summary has an overwritten sample-count field (the
boundary loop reused that variable); the source is corrected, and no
numerical summary is used in this theorem.

The separate formal core can be compiled and recorded with:

```sh
$WORKSPACE/argus-live-update/.venv/bin/python -m argus_skill.verticals.math.lean_evidence verify research/universal_tensor_audit/lean/Main.lean --statement-fidelity research/universal_tensor_audit/lean/statement_fidelity.md --artifact-dir research/universal_tensor_audit/lean --project-root . --claim C_CUBIC_CORE
```

The host's prebuilt Mathlib v4.31.0 workspace is used; no project Lake
workspace or dependency installation was created.

Jacobian operation `quadratic_form.evaluate.compute` was discovered and
its typed contract inspected before custom algebra code was written.
`jacobian_payload.json` and `jacobian_output.json` retain its exact
request and typed result, server version `0.14.0`, and protocol
`2025-11-25`. The adapter returned normally, without error or timeout.
It evaluated the printed comparison form at `nu` to `285734938/625`.
This one-point auxiliary computation is not used as a substitute for
any universal inequality.

No false manuscript assertion has been established by this audit.
No `refutes` judgement is warranted by either the exploratory search or
the checker implementation error encountered during development.
Independent Reviewer replay and judgement remain required. The
background Jerison--Savin citation still requires independent attribution;
it is not an assumption of the tensor verification theorem.
