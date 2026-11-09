# Weighted initial modules and the actual frame-relation kernel

## Result and scope

Lemma `lem:frame-marked-factor` in the staged September 24, 2026 manuscript
is valid. Its argument in fact gives the stronger, all-dimensions inequality

$$
\sum_{W=A\oplus B}(\dim A)\dim P(A)\dim C(B)
\ \leq\ (h-2)\dim C(W),\qquad h=\dim W\geq2.                 \tag{1}
$$

Here **C is the manuscript's actual kernel**, not a surrogate relation
module, and decompositions have exactly its admissibility and orthogonality
requirements. Consequently

$$
(D-2)\mathsf C\geq(D\mathsf P)\mathsf C,\qquad
D\mathsf C\geq(D\mathsf P)\mathsf C.                         \tag{2}
$$

The conditional implication `eq:frame-log-bound` is also valid:
if $D J$ is coefficientwise nonnegative, then $D\mathsf P\geq D J$.
The proof below does not assert that hypothesis without the separate
plane-count argument.

This is a mathematical verification theorem, with a kernel-checked
all-dimensions combinatorial core and finite exact checks of actual
presentations. It is not a counterexample, a formalization of the entire
Lie-superalgebra construction, a novelty certification, or a verification
of the global Quillen theorem. Independent review is pending. The initial
ledger had only the campaign objective, with no prior local result; the
improvement is the explicit certified insertion map, a complete
actual-kernel bridge, and the sharper capacity $h-2$.

## Objects and the external theorem used

Work in a fixed finite ambient space $W_0$ in any of the four settings
specified at the start of Section 4. A good degree is an admissible
supporting subspace. Addition is allowed direct sum (orthogonal when a
form is present); every forbidden sum has the absorbing degree $\bot$.
In particular, no product of bad degree can have a good-degree summand.

There is an odd generator $e_L$ for every allowed line, and

$$
r_Q=\sum_{(A,B):\,Q=A\oplus B}e_Ae_B
    =\sum_{\{A,B\}:\,Q=A\oplus B}[e_A,e_B].
$$

Both orders of a frame occur once. The bracket of two odd generators is
$e_Ae_B+e_Be_A$. Thus these are precisely the manuscript's even,
support-homogeneous plane relations. Put

$$
P=\mathfrak L(V)/(r_Q)_{\rm Lie},\quad
U=T(V)/(r_Q)_{\rm ass},\quad
R=\bigoplus_Q\mathbb Q\,\mathbf r_Q,
$$

and use exactly its left-linear map

$$
d_2(u\otimes\mathbf r_Q)=
\sum_{(A,B):Q=A\oplus B}u e_A\otimes e_B,\qquad C=\ker d_2.    \tag{3}
$$

The universal enveloping algebra of $P$ is $U$ by their universal
properties. The one external theorem used is characteristic-zero
graded PBW: with the factor filtration,

$$
\operatorname{gr}U=\operatorname{Sym}(P_{\rm even})
                     \otimes\bigwedge(P_{\rm odd}),
$$

and $P\longrightarrow U$ is injective. The primary source is
Milnor--Moore (1965), DOI 10.2307/1970615, Definition 5.12,
Section 5.14, and Theorem 5.16, printed pp. 242-243. Its sign conventions
are those of the positive word-length grading here.
`pbw_source.md` records the separately retrieved source and the limits
of what it explicitly states. This external result is recorded as
assumption `A_MM_PBW` of claim `C_FK_PBW`, not passed off as a Lean proof.
The unrelated Wiki Hopf-scalar theorem is not a premise, and the
historical Golod--Shafarevich citation is not needed.

PBW retains the extra support grading for the following reason. Each
defining relation
$xy-(-1)^{|x||y|}yx-[x,y]$ is homogeneous in that grading, as is the
factor filtration. The canonical PBW comparison map is therefore
support-homogeneous. A bijective graded linear map restricts to a
bijection in each homogeneous component: decompose a preimage by
degree and use injectivity on its other-degree components. This
justifies the extra grading here rather than attributing it to an
unstated clause of the cited theorem.

Good components are finite-dimensional: an associative word of good
degree $X$ is an ordered allowed frame and has length $\dim X$.
Only generators and relations contained in $X$ can contribute to it.
The same is true of $P(X)$ by the injective PBW map.

## A general support-graded module theorem

The argument applies more generally as follows. Let $L$ be a
support-graded rational Lie superalgebra with finite good components
and no degree-zero component. Let $E=U(L)$. Let $R'$ have a finite
homogeneous basis of labels, all supported on subspaces of the same
dimension $r$. If $N\subseteq E\otimes R'$ is any support-graded left
$E$-submodule, then

$$
\sum_{W=A\oplus B}(\dim A)\dim L(A)\dim N(B)
\ \leq\ (h-r)\dim N(W),\qquad h=\dim W\geq r.               \tag{4}
$$

For $h<r$, both sides of the intended nonnegative-capacity formulation
are zero. The hypotheses on supports mean that good monomials have
independent factor supports and label support. A free-module
hypothesis on $N$, a regular-sequence hypothesis on relations, and
strictness of a presentation differential are **not** required.

### Proof: the induced filtration

Give $E\otimes R'$ the PBW factor filtration, with labels in
filtration degree zero, and set
$F_kN=N\cap F_k(E\otimes R')$. The inclusion induces an injection

$$
\operatorname{gr}N\hookrightarrow\operatorname{gr}E\otimes R'. \tag{5}
$$

Indeed, an element representing zero in an ambient graded quotient
already belongs to $N\cap F_{k-1}$. Since $N$ is a submodule and the
ambient filtration is multiplicative,
$F_iE\,F_jN\subseteq F_{i+j}N$. Hence (5) is a module injection.
This proves the assertion even if a map defining $N$ has no compatible
filtration at all.

Support grading is preserved by intersections with this filtration.
Every good component has a finite exhaustive filtration, so

$$
\dim\operatorname{gr}N(B)=\dim N(B).                        \tag{6}
$$

### Proof: good leading monomials really are stable

Choose a homogeneous, parity-homogeneous basis of $L(A)$ for every
nonzero good $A\leq W_0$. These are finitely many basis vectors.
A good PBW module monomial consists of distinct such factors and a
single label. Its supports, including the label, form an allowed
direct decomposition. In particular **an even factor cannot repeat
in a good monomial either**.

Embed their exponent vectors in an ordinary polynomial monomial
order, for example graded lexicographic order, and prioritize the
label when ordering module monomials. Restrict this one order to
each good component. Let $I(B)$ be all leading monomials of nonzero
elements of $\operatorname{gr}N(B)$. Row elimination in its finite
ambient monomial basis gives

$$
|I(B)|=\dim N(B).                                         \tag{7}
$$

Now let $W=A\oplus B$, let $p$ be a chosen basis vector in $L(A)$,
and let $m\in I(B)$. Choose an element with leading monomial $m$.
Every one of its terms has support $B$. Therefore $p$ is absent
from every term, and adjoining it preserves allowed directness,
including orthogonality and the label support. All terms survive
exterior multiplication; no two resulting monomials collide.
Their signs may change, but their nonzero coefficients do not
cancel because the resulting monomials are distinct.

On these surviving products the ordinary exponent-vector order is
multiplicative. Thus the product has leading monomial $pm$.
The submodule property in (5) proves

$$
m\in I(B),\ p\in L(A),\ W=A\oplus B
\quad\Longrightarrow\quad pm\in I(W).                     \tag{8}
$$

This is not a blanket claim that multiplication in an exterior
algebra preserves leading terms when some terms vanish. Direct
support independence proves precisely the nonvanishing needed here.

### Proof: the injection is constructed, not assumed

Let the input family consist of pairs $(p,m)$ as in (8). Regard the
factors of $m$ as a finite set and retain its label. Define

$$
(p,m)\longmapsto (pm,p).                                  \tag{9}
$$

The second coordinate is a marked factor of the first monomial.
It recovers $p$, and erasing $p$ recovers the complete original
monomial and its unchanged label. It also recovers the decomposition:
the support of $p$ is $A$, and the sum of the remaining supports
including the label is $B$. Thus (9) is injective on the actual
input family, even when distinct decompositions have isometric
summands.

Give each input weight $\dim\operatorname{supp}(p)$. For a fixed
output $n$, sum these weights over the marks in its image.
Injectivity prevents a given factor from being counted twice.
The sum is at most the sum of dimensions of **all** factors of $n$.
Its label has dimension $r$, so that total factor weight is exactly
$h-r$. Summing over $n\in I(W)$ proves (4), using (7).

For complete clarity, this is a weighted injection to
output/factor pairs, not a purported linear injection
$\bigoplus L(A)\otimes N(B)\hookrightarrow N(W)$.
The latter need not exist, and is not used.

The Lean declaration `mark_injective_on_fresh` constructs (9) and
proves its inverse-by-erasure property. `weighted_marking` proves
the weighted sum comparison by summing over the image of this map
and including it in all output/factor pairs.
`homogeneous_relation_bound` derives (4)'s capacity from the exact
homogeneity equation. These declarations quantify over arbitrary
finite families and all natural dimensions, rather than a bounded
list of dimensions.

## Specialization to the actual kernel

The map (3) is left $U$-linear and support-homogeneous. Therefore its
actual kernel $C$ satisfies every hypothesis just used. Its induced
filtration is exactly the one in (5); no statement about a filtered
or strict $d_2$ has been inserted. Every label is an actual plane
label, of dimension two. Set $L=P$, $N=C$, $r=2$ in (4).
This proves (1) with all manuscript hypotheses and all dimensions.

There are no good components of $U\otimes R$, hence none of $C$,
in dimensions zero and one. In dimension two, $d_2$ on the one
plane label is nonzero because the plane admits a frame; its
ordered-frame terms are distinct. Thus $C(Q)=0$ there as well.
The original inequality consequently holds also at every boundary
dimension. The stronger formulation $(D-2)\mathsf C$ has no
negative low-dimensional coefficients.

To pass from (1) to normalized type series, isomorphisms or isometries
preserve the presentation and maps, so $\dim C(W)$ depends only on
the type. For specified types of ordered summands, the full group
$G_W$ acts transitively on decompositions with stabilizer
$G_A\times G_B$: direct-sum the chosen isomorphisms or isometries.
Hence the number of such decompositions is
$|G_W|/(|G_A||G_B|)$. Divide (1) by $|G_W|$ to get the first
inequality in (2). Adding $2\mathsf C\geq0$ gives the manuscript's
inequality. This retains both orthogonal determinant types separately.

## Exact relation complex and the logarithmic consequence

Here the identities used in the implication are also justified.
Write $T=T(V)$ and $I=(r_Q)_{\rm ass}$. Splitting a word before its
last letter identifies $T_+$ with $T\otimes V$ and identifies
$U\otimes V$ with $T_+/(IV)$, where $IV$ denotes concatenation of
an element of $I$ and a single last letter. The kernel of
multiplication $d_1:U\otimes V\to U$ is $I/(IV)$.

Every term $a r_Q b$ with $b$ nonempty lies in $IV$ after splitting
off the last letter of $b$. Terms with empty $b$ are exactly the
images of (3). Changing a representative of $a$ modulo $I$ changes
$a r_Q$ by an element of $IV$, since $r_Q$ has positive length.
Thus the complex is exact, with $C$ its actual leftmost kernel:

$$
0\longrightarrow C\longrightarrow U\otimes R
\longrightarrow U\otimes V\longrightarrow U
\longrightarrow\mathbb Q\longrightarrow0.
$$

All maps are support-homogeneous. Euler dimensions in each good
component, followed by the same decomposition normalization, give

$$
\mathsf U(1-v+w)=1+\mathsf C.                              \tag{10}
$$

The good-degree PBW basis is indexed by unordered independent
nonzero supports with one basis factor on each. There are exactly
$k!$ ways to order $k$ distinct actual supports, even if some have
the same type. Therefore its normalized count is

$$
\mathsf U=\sum_{k\geq0}\frac{\mathsf P^k}{k!}
          =\exp(\mathsf P).                               \tag{11}
$$

The coefficient ring is the rational type algebra, completed by
dimension. It can have zero divisors; none of the argument requires
it to be a domain. The series $1-v+w$ and $\mathsf U$ have constant
term one, and their formal logarithms, exponentials, and inverses
exist in the dimension completion. In each dimension all operations
use finitely many coefficients. $D$ is a derivation because direct
sum adds dimensions.

Let $J=-\log(1-v+w)$. Formal differentiation of (10)-(11) gives

$$
D\mathsf C=(1+\mathsf C)(D\mathsf P-DJ).
$$

Rearrange this identity BEFORE applying coefficientwise order:

$$
D\mathsf P
=DJ+\mathsf C\,DJ+
  \bigl(D\mathsf C-\mathsf C\,D\mathsf P\bigr).             \tag{12}
$$

The last summand is nonnegative by (2). If $DJ\geq0$, the middle
summand is also nonnegative: each coefficient is a finite sum of
products of nonnegative rational numbers. Thus

$$
D\mathsf P\geq(1+\mathsf C)DJ\geq DJ.
$$

No inequality was multiplied by an inverse or divided by a series
of unknown signs. `logarithmic_coefficient_step` checks the ordered
rational arithmetic at each coefficient of (12); the formal-series
identities and their coefficient interpretation are proved above.
Establishing $DJ\geq0$ and its explicit frame constants remains the
separate claim `C_FRAME_CONSTANTS`.

## Executable evidence and what it does not prove

Run from the campaign root:

```bash
$WORKSPACE/argus-live-update/.venv/bin/python research/frame_kernel/verify.py
```

The script uses exact finite-field arithmetic and rational row
elimination. It constructs all allowed lines, all admissible supports
and frames in each listed example, then constructs every good
relation $a r_Q b$. It computes the actual associative quotients,
images of the fixed-first-letter super-Lie combs, and the actual
matrix (3). It checks $d_1d_2=0$, exactness, kernel dimensions,
and (1) on every enumerated support, not just on the ambient space.
The Lie computation uses all brackets needed: super skew-symmetry
places a distinguished leaf on the left, and repeated super Jacobi
expands every nontrivial right subtree until only individual letters
are appended. Induction therefore spans the brackets on each frame
by fixed-first-letter left combs. Every good bracket has a frame
as its leaves. PBW identifies the images of their normal forms in
the associative quotient with $P(W)$, so their exact row rank is
the actual Lie dimension.
It also checks that the official archived proof and statement
fidelity are the exact current texts, and by default freshly
compiles the universal Lean source. `--finite-only` explicitly
omits that fresh compile and is only a development checkpoint.

| Ambient example | dim U(W) | dim P(W) | dim C(W) | Marked left side | (h-2) dim C(W) |
|---|---:|---:|---:|---:|---:|
| square lines, identity form over F_3, h=2 | 1 | 0 | 0 | 0 | 0 |
| square lines, identity form over F_3, h=3 | 1 | 0 | 1 | 0 | 1 |
| square lines, identity form over F_3, h=4 | 3 | 0 | 9 | 12 | 18 |
| no form over F_2, h=3 | 113 | 29 | 1 | 0 | 1 |
| both line types, identity form over F_5, h=3 | 71 | 16 | 1 | 0 | 1 |

These are 124 actual supports across five ambient examples.
The small-field cases test the lemma, whose algebraic setup has no
numerical lower-field restriction; they are not claimed to satisfy
the separate field ranges of all numerical frame bounds.
The F_5 example does lie in the two-type frame-bound range.
The F_3 four-dimensional example makes the marked left side
nonzero; the F_2 and F_5 examples retain nonzero higher Lie pieces
and multi-frame plane relations.

For the three-dimensional square-line F_3 example, the only allowed
lines are the three coordinate lines (norm-square vectors have
Hamming weight one). Order them as indices 0,1,2. Use ascending
words for the three plane quotient bases, target rows ordered by
last line, and domain columns $e_i\otimes\mathbf r_{i^\perp}$.
The actual matrix is

$$
\begin{pmatrix}
0&1&-1\\
1&0&-1\\
1&-1&0
\end{pmatrix}.
$$

Its rank is two and its kernel is spanned by $(1,1,1)$.
The separately inspected Jacobian operation `matrix.rank.compute`
returned rank two and pivot columns 0,1 for exactly this matrix.
The request, typed contract, typed result, adapter exit status,
server version 0.14.0, and protocol version 2025-11-25 are preserved
in dedicated JSON files. The verifier regenerates the matrix from
the actual plane presentation and checks the binding; the sidecar
result is not treated as an all-dimensions proof.

The prescribed `lean_evidence verify --claim C_FK_MARKING` run
completed with exit code zero and `proof_holes=[]` on Lean 4.31.0.
`lean_verification.json` and its archived certificate are the
mechanical evidence. The source and fidelity text have not been
modified since that run. See `statement_fidelity.md` for the precise
formal/unformalized boundary.

No false manuscript assertion has been established in this local
argument, so no `F_<LABEL>` refutation is manufactured.
Remaining independent-review work is to replay the certificate,
read the bridge proof and its statement fidelity, and attribute the
primary PBW citation. `C_FRAME_COEFFICIENT`, `C_FRAME_CONSTANTS`,
the classical and exceptional group arguments, and all global
reductions/propagation claims remain open in the proof graph.
Publication-level novelty and significance have not been certified.
