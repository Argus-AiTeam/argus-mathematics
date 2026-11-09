# Exact universal verification of the order-six Fourier dichotomy

## Result and scope

**Verification theorem.** Let \(H\) be any complex \(6\) by \(6\) matrix
whose entries have modulus one and for which \(H^*H=6I\). Both identities
in the staged companion's Proposition `prop:pair-certificate` hold.
Consequently either every permuted
\(\alpha=(1,1,1,-1,-1,-1)\) character vanishes, or \(H^{\circ2}\) is
Hadamard. There is no parametrized-family, algebraicity, rational-moment,
dephasing, or membership-in-a-MUB-family hypothesis.

This is a universal proof with a finite exact rational certificate, not a
test on finitely many matrices. `verify.py` reconstructs the target
expressions and verifies direct dual combinations of 255 valid boundary
equations. Both residual coefficient dictionaries are empty. It imports
neither the supplied verifier nor a symbolic or numerical algebra package.
The separate Lean source checks the finite contraction and positivity
bridges, not the entire universal theorem.

**Review status:** Engineer reconstruction and machine checks are complete;
the Host's independent Reviewer has not yet reviewed the mathematics,
statement fidelity, or the three scope-source citations. No false manuscript
assertion has been established in this mission, so no `F_` refutation claim
is warranted. This result does not certify the cubic classification, the
complete-family obstruction, \(N(6)\leq5\), or \(N(6)=3\).

## Exact source assertions

All companion locators below refer to
`research/openai_manuscript/Exact-Fourier-certificates-for-complex-Hadamard-matrices-of-order-six-September-24-2026/build/`.

The assertion under audit is `sections/02-pair-moments.tex`, Proposition
`prop:pair-certificate` (label at line 226; equation label at line 234):

> For every \(6\times6\) Hadamard matrix \(H\) and for each
> \(q\in\{q_{\mathrm{cross}},q_{\mathrm{same}}\}\),
> \[
> 3\bigl\langle |L_{\widetilde H}|^2\bigr\rangle_H+
> \bigl\langle|g_{\widetilde H}(\alpha)g_{\widetilde H}(q)|^2
> \bigr\rangle_H=0.
> \]

Its conclusion is Corollary `cor:dichotomy`, label at line 9. The
load-bearing semantic assertions are the injective-moment definition
(equation label at line 36), contraction Lemma `lem:contraction`
(line 63), its formal seven-row equation (line 78), and equality-pattern
Lemma `lem:partitions` (line 143; equation label at line 157).
The polynomial \(L\) is fixed at equation `eq:pair-L`, line 212.
Section `05-verification.tex` describes an alternative proof through
rational projection rules; the new checker does not trust those rules.

The remaining companion dependencies are explicitly open in the graph:
`prop:cubic-classification` in `03-cubic.tex`;
`lem:basic` and `prop:cubic-exclusion` in `03-complete-family.tex`;
`lem:gram`, `lem:mixed-reductions`, and `prop:mixed-certificate` in
`04-mixed.tex`; and `lem:exact-elimination` in `05-verification.tex`.
The companion's `thm:fourier` additionally needs the cubic classification.
Its `thm:main` additionally needs the cubic exclusion and mixed certificate.
The bound five additionally needs the cited Weiner completion theorem.
None of these additional assertions is inferred from this mission.

The separate main manuscript is mapped, not verified. With its own
`build/sections/` prefix, its chain is `seed.tex:449-491`
(`seed:cover`), `completion.tex:667ff` and `phase-cover.tex`
(`phase:A-cover`), `refinement.tex:502-606`
(`refine:cover-preservation`, `refine:batch-cover`),
`exclusion.tex:639-665` (`exclude:local-certificate`), the outward-error
contract in `rounding.tex`, and the actual terminal/provenance conditions in
`execution.tex`. Its `execute:finite-theorem`, lines 242-247, says:

> Suppose the invocations in Section `execute:control` meet all of its
> terminal conditions, with the record provenance and batch checks stated
> there. Then four mutually unbiased orthonormal bases in \(\mathbb C^6\)
> do not exist.

In particular, conditional coverage/exclusion theorems do not authenticate
the stipulated execution. No numerical records were rerun, rebuilt, or
authenticated here.

The main title's exact value three additionally requires the lower bound
that three bases exist, independent of the no-four result. This is retained
as the open `C_THREE_BASES` input to `C_MAIN_EXACT_THREE`; no lower-bound
construction is being substituted for the current universal identity task.

## Prior result and assumptions

Maxwell--Brierley, arXiv:1402.4070v2, Theorem 4.1, proves the alpha
vanishing for the Karlsson family. Its primary HTML was inspected at
`https://arxiv.org/html/1402.4070v2`; the hypothesis and conclusion are in
`known_result_excerpt.txt`. The paper also reports that its linear-program
experiments did not exclude a complete family. Neither that failed
exclusion attempt nor finite example testing is used as a universal proof.
The known result is recorded on `C_SCOPE_KNOWN`, not assumed by the
verification theorem.

The mathematical assumptions of the proof below are exactly unimodularity
and \(H^*H=6I\), together with ordinary finite-sum algebra over the complex
numbers. In particular no cited external mathematical theorem is an
undischarged dependency of the pair identity. Literature/source attribution
on the scope claims remains for independent review. The staged manuscript
already claims the same universal quantifiers; this work does not claim
to strengthen them. The improvement is a directly replayable dual proof
that removes the projection solver, modular rank, and rational
reconstruction from the trusted verification path. Novelty and publishable
significance remain for the independent Reviewer; `verified_new` is not
asserted by the Engineer.

## Moment semantics and sound rewriting

For a balanced integer charge \(a\in\mathbb Z^6\), define
\[
 g_H(a)=\frac16\sum_{k=0}^5\prod_{i=0}^5 H(i,k)^{a_i}.
\]
Unimodularity gives \(g_H(-a)=\overline{g_H(a)}\).
A square matrix with \(H^*H=6I\) has inverse \(H^*/6\), hence also
\(HH^*=6I\). Thus both \(H\) and \(H^{\mathsf T}\) have orthogonal
rows and columns.

For an integer array \(A\) of size \(p\) by \(q\), with both kinds of
sum zero and \(p,q\leq6\), let
\[
 m_H(A)=\frac12\sum_{K\in(H,H^{\mathsf T})}
  \mathbb E_{\rho,\kappa}\operatorname{Re}
  \prod_{u,v}K(\rho(u),\kappa(v))^{A_{uv}},
\]
where \(\rho,\kappa\) are independent uniform injections into six labels.
The two orientations are counted with multiplicity; the empty moment is
one. This is an actual real moment of every such \(H\).

Row and column permutations merely relabel injections. Global negation
conjugates the monomial, preserving its real part. Transposition swaps
the injections and the equally weighted orientations. A zero axis can
be deleted because the restriction of a uniform injection has a uniform
injective marginal. These are precisely the changes made by `canonical`;
there is no identification under any other operation. Positive-part
orders and lexicographic sorting select names only.

Suppose row \(i\) of \(A\) has order one. It has exactly one \(+1\)
and one \(-1\), in distinct columns \(v_+,v_-\). Fix \(K,\kappa\)
and the injective labels of all other rows. Let \(M\) be their product.
Column orthogonality gives
\[
 M\sum_{t=0}^5 K(t,\kappa(v_+))
       \overline{K(t,\kappa(v_-))}=0.
\]
For \(p\leq6\), the \(p-1\) occupied labels leave \(7-p\) unused
labels. Their sum is \(7-p\) times the conditional expectation of the
missing row. An occupied label merges the missing row's exponents into
its occupying row. Averaging proves
\[
 (7-p)m_H(A)=-\sum_{\ell\ne i}m_H(A_{i\to\ell}).
\]
The retained \(p-1\) labels are uniformly injective, exactly as required
by each merged moment. Deleting any resulting zero axes preserves this
law. The argument applies on the other axis by transposition.

For a **formal seven-row** balanced array with an order-one row, fix the
other six labels injectively. They occupy all physical rows, so there is
no unused-label contribution at all:
\[
 \sum_{\ell\ne i}m_H(A_{i\to\ell})=0.
\]
All six terms have at most six physical rows. This step neither introduces
a seven-row moment nor divides by \(7-7\). The definition of
`boundary_relation` enforces this distinction before invoking `reduced`.
The latter applies only the \(p\leq6\) rule and decreases the sum of axis
lengths at every contraction, so it terminates. Its output therefore has
the same actual moment value as its input.

As a normalization/sign check, for
\(A=((1,-1),(-1,1))\) this gives \(5m_H(A)=-1\).
The inspected Jacobian operation `linear.rational_solution.compute`
returned the exact solution \(-1/5\) for this equation. Its declared
contract solves rational systems with at most 32 unknowns, so it was not
used to represent or solve the full pair table. The exact payload and
typed result are preserved in `jacobian_payload.json` and
`jacobian_output.json`; the latter retains server 0.14.0, protocol
2025-11-25, the operation id, and `SOLUTION` status. There was no adapter
error or timeout. This auxiliary calculation is not the universal proof.

## Equality patterns and the two exact target vectors

For balanced charges \(a_1,\ldots,a_n\) with sum zero, expand
\(\prod_j g_K(a_j)\) by independently sampling its \(n\) columns.
Each equality partition \(\mathcal S\) with \(k\) blocks has precisely
\((6)_k\) injective assignments of block labels, out of \(6^n\) samples.
Conditional on this pattern, add the charges in each block. After the
row-permutation/orientation average and real part, this proves
\[
 \left\langle\operatorname{Re}\prod_jg_{\widetilde H}(a_j)\right\rangle_H
 =\sum_{\mathcal S,\ |\mathcal S|\leq6}
     \frac{(6)_{|\mathcal S|}}{6^n}m_H(A_{\mathcal S}).
\]
The zero-total-charge condition gives balanced rows, and each balanced
charge gives balanced columns. Thus every moment supplied to the
contraction rules is in their domain.

The checker independently enumerates set partitions by choosing the block
containing the first remaining position. It also enumerates all \(6^n\)
column samples for \(0\leq n\leq4\), confirming every individual partition
multiplicity. The partition counts are \(1,1,2,5,15\). This checks a
finite combinatorial identity used in the proof, not sample matrices.

The target charges and polynomial are hard-coded, rather than accepted
from an untrusted target description:
\[
\begin{split}
 w&=(-3,-2,0,1,2,2),\\
 a_1&=(-1,-1,0,0,1,1),&
 a_2&=(-2,0,0,0,1,1),\\
 a_3&=(-1,-1,0,1,0,1),&
 a_4&=(-1,-1,0,1,1,0),\\
 L_H&=-g_H(w)+2g_H(a_1)g_H(w-a_1)
           +\sum_{j=2}^4g_H(a_j)g_H(w-a_j),\\
 q_{\rm cross}&=(2,0,0,-2,0,0),&
 q_{\rm same}&=(2,-2,0,0,0,0).
\end{split}
\]
Expanding every ordered term of \(3L\overline L\), then adding
the four-factor product with charges \((\alpha,q,-\alpha,-q)\), gives
the required real averaged quantity. Every product has at most four
factors and total order ten. The checker verifies those conditions.
After the sound reductions above, each target has 28 nonzero moment
coordinates.

## Direct dual certificate

For each supplied seven-row array \(B_j\), let
\[
 R_j=\sum_{\ell\ne i_j}U_0((B_j)_{i_j\to\ell}),
\]
where \(U_0\) is the sound, terminating contraction expansion. Each
\(R_j\) is zero on every actual moment vector. The certificate gives
two rational coefficients \(\lambda_{j,q}\) for each array. Its exact
claim, independently checked coefficient by coefficient, is
\[
 F_q=\sum_{j=1}^{255}\lambda_{j,q}R_j
 \qquad(q=q_{\rm cross},q_{\rm same}),
\]
where \(F_q\) is the freshly reconstructed target, not a supplied vector.
It follows immediately that \(F_q(m_H)=0\) for every \(H\) in the theorem.
Indeed, this formal identity holds for any real moment assignment
satisfying the stated rewriting and boundary equations.

Every witness is checked for integer entries, rectangular shape, zero
row/column sums, seven formal rows, an order-one contracted row, positive
row orders, column orders at least two, at most four columns, and total
order between seven and eleven. The total-order distribution is
\[
 \begin{array}{c|rrrrr}
 \text{order}&7&8&9&10&11\\ \hline
 \text{witnesses}&1&15&28&91&120
 \end{array}
\]
and the column-count distribution is \(3,68,184\) for two, three, four
columns. The cross and same duals have respectively 255 and 108 nonzero
coefficients. The largest absolute numerator is 233368115 and the largest
denominator is 1469664.

`propose.py` uses the staged program only to propose boundary arrays and
modular candidates for dual coefficients. It selects 897 rows from the
8871-equation, 909-coordinate table and reconstructs direct duals. Those
selection, rank and reconstruction operations are **not trusted**:
`verify.py` needs only the supplied arrays and coefficients and proves the
two displayed equalities over `Fraction`. Completeness of the table and
independence of the selected rows are unnecessary to the verification.
Thus the new artifact replaces the manuscript's 897-row projection
verification with 255 explicit true equations and a direct linear identity.

Five deliberate corruptions were rejected: changing a dual coefficient,
unbalancing a boundary row, selecting an invalid contracted row, changing
a target charge, and removing a needed boundary witness. Exact replay and
mutation outcomes are in `verification_output.json` and
`mutation_test_output.json`.

## Positivity implies the actual dichotomy

There are \(2\cdot6!=1440\) equally weighted orientation/order samples.
All weights are positive. Each of the two now-proved identities is a
sum of nonnegative real numbers. Hence separately for every row order of
the original \(H\),
\[
 g_{H^\pi}(\alpha)g_{H^\pi}(q_{\rm cross})=0,\qquad
 g_{H^\pi}(\alpha)g_{H^\pi}(q_{\rm same})=0.
\]
In fact every \(L_{H^\pi}\) is also zero.

If a permuted alpha character is nonzero, its positive and negative
supports are triples \(I_+,I_-\). Reordering within a triple leaves this
character unchanged. The cross product treats every ordered pair from
\(I_+\) to \(I_-\); the same product treats every ordered distinct pair
within \(I_+\). Exchanging the triples conjugates the nonzero alpha
character, so the same reasoning treats the reverse cross pairs and all
pairs within \(I_-\). Consequently
\[
 g_H(2(e_i-e_j))=0\quad(i\ne j).
\]
For additional exact combinatorial checking, `check_dichotomy_routing`
enumerates all 720 row permutations, all 20 alpha sign partitions, and
checks that the two products together with conjugation cover all 30
ordered distinct pairs for each partition.

Finally the squared rows have norm squared six, and
\[
 \sum_k H(i,k)^2\overline{H(j,k)^2}
       =6g_H(2(e_i-e_j))=0\quad(i\ne j).
\]
Thus \(H^{\circ2}(H^{\circ2})^*=6I\). It is square and unimodular,
so it is Hadamard. If no such nonzero alpha character exists, alternative
(M) holds instead. This proves precisely the requested dichotomy.

## Formal boundary and replay

Lean 4.31.0 compiled `Main.lean` successfully with exit code zero and
`proof_holes=[]`. The official `lean_evidence verify --claim
C_CONTRACTION_BRIDGE` command recorded the successful compiler evidence.
Its immutable certificate is
`certificates/C_CONTRACTION_BRIDGE-077bd49424221a4b.json`.
The initial source required the usual `noncomputable` annotation for
complex division; the corrected, current source was recompiled successfully.
The failed earlier run is not used as evidence.

`occupied_unused_split`, `normalized_order_one_contraction`,
`normalized_real_contraction`, and `seven_row_boundary` prove the finite
complex/real normalization and boundary facts. `nonnegative_sums_vanish`
and `pointwise_products_from_certificate` prove the finite positivity
implication. `statement_fidelity.md` explicitly distinguishes these formal
statements from the unformalized uniform-injection and exponent-monomial
interpretations proved above. It has not been independently approved yet.

The standalone exact replay is:

```sh
python3 research/fourier_dichotomy/verify.py
```

The formal replay, from the campaign root, is:

```sh
$WORKSPACE/argus-live-update/.venv/bin/python \
  -m argus_skill.verticals.math.lean_evidence verify \
  research/fourier_dichotomy/Main.lean \
  --statement-fidelity research/fourier_dichotomy/statement_fidelity.md \
  --claim C_CONTRACTION_BRIDGE --project-root .
```

No Lake project was created; the installed Mathlib v4.31.0 workspace was
used. The ledger and proof graph retain unaudited nodes as open and all
Reviewer confirmation flags as false. Engineer support judgements are not
independent Reviewer judgements.
