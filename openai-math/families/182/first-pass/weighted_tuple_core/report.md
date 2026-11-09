# A uniform theorem for the weighted tuple construction

## Result and scope

The bridge `tuple:marking-domination` has the stated direction and the
stated factor `r_*^(-n_*)`. It remains valid for coincident labels, for
non-even edge weights, and when the new component is terminal. Together
with the marked-cut estimate it proves the two requested tuple assertions,
under exactly their quantitative local edge-weight inputs, uniformly in
the auxiliary index. No false manuscript assertion was found in this
scope, and no `F_...` refutation is asserted.

Theorem 1 below also works for arbitrary finite homogeneous directed
kernels, including kernels on nonabelian groups. It permits a free geometric
marking coefficient. Corollary 2 improves the tradeoff for this construction;
Theorem 3 shows that its square-root dependence on the marking coefficient
cannot be removed. Neither result proves either paper's power-saving
theorem. The local polynomial estimates and analytic descent are separate
obligations.

This is an all-parameter mathematical proof with a compiler-certified
combinatorial core, not an exhaustive finite verification of the full
tuple law. The exact extent of the Lean proof is in
`statement_fidelity.md`. Independent mathematical review, statement-fidelity
review and any publishability/novelty determination remain outstanding.

## Sources and what was already known

All source paths below are relative to `research/openai_manuscript/`.

* **I:** `A-power-saving-for-intersective-polynomial-differences-with-an-exponent-depending-only-on-the-degree-October-5-2026/build/manuscript/sections/tuples.tex`.
  The locators are `tuple:list-mixing`, `tuple:marked-positive`,
  `tuple:unmarked-defect`, `tuple:marking-domination` (equations (4)--(6)),
  `tuple:laws`, `tuple:conditional-mixing`, and
  `tuple:threshold-dependence`.
* **P:** `A-Power-Saving-for-Polynomial-Differences-at-Prime-Arguments-October-5-2026/build/sections/tuples.tex`.
  The corresponding locators are `lem:graph-estimates`,
  `eq:tuple-marked-positive`, `eq:tuple-unmarked-error`,
  `eq:tuple-concatenation`, `prop:tuple-laws`, and `eq:tuple-mixing`.
* **S:** `A-power-saving-for-square-difference-free-sets-September-24-2026/build/sections/tuples.tex`,
  especially `lem:marked-positive` and `lem:tuple-marking-domination`;
  its `sections/graph.tex` contains `lem:graph-count` and
  `lem:list-mixing`.

S already contains the marked-block/list-concatenation mechanism for square
indicators. I already contains its weighted version and explicit threshold
constants. These are not new discoveries of this audit. The proof below
does not assume their conclusions: it gives the finite-kernel argument
from its hypotheses. A targeted literature search located no additional
exact theorem matching the homogeneous directed-kernel extension; this
negative retrieval is not evidence of novelty. Search-generated summaries
are not used as mathematical sources.

The only arithmetic inputs to the application are
`0 <= W <= 1`, `c_p >= 1/(2k)`, and
`||W(y-x)-c_p||_op <= p^(-4 delta)`, uniformly in `l`.
They are explicit hypotheses of the specialization here. I derives them
from regular fibers and its local equation (2); P uses allowed regular
fibers and `eq:tuple-edge-fourier`. No assertion about prime-power
exponential sums or the companion zero-free theorem is imported.
The finite-dimensional estimates below are proved here; no unexamined
literature theorem is a dependency of Theorem 1.

## Theorem 1 (homogeneous directed-kernel tuple law)

Let `L >= 3`, `t >= 1` be integers, and put

    w = 2t+1,  K = L!,  r = K/2,  d = K^w,  n = d/2,
    ell_s = r^s,  E = binom(d,2),  Delta = 1/(10L^2),
    kappa = (9/10) Delta^(L-1),
    a = (exp(kappa)-1)^n,  cmark = a ell_(t+1)^(-n),
    b = cmark r^(-n),  B = exp(E),  H = (32E)^(1/4).

Let `X` be any nonempty finite set. Let `A:X x X -> [0,1]` be a
real kernel invariant under a transitive group of permutations of `X`.
Write `c = E_(x,y) A(x,y)`. Suppose `c >= c0 > 0`, `c0 <= 1`,
and `||A-c||_op <= epsilon`, using uniform probability spaces.
No symmetry `A(x,y)=A(y,x)` is assumed.

Construct exactly the manuscript slots, address graphs, list lengths and
index interactions, replacing `W(Y'-Y)` by `A(Y,Y')`. Use geometric
coefficients `q^|S|` instead of `p^(-|S| delta/2)`. Set

    Z = c0^E/2,
    Cmass = 2^w B/Z,
    Clead = Z^(-1) H^2 (2 c0^(-E) + 4 c0^(-2E)).

For every `0 <= q <= 1` and `epsilon >= 0` satisfying

    E epsilon <= Z,                 (T1)
    B^2 H epsilon^(1/4) <= b q,     (T2)

the following hold. Here `M=sum_(|S|<=t+1) q^|S| nu_S`,
`mu=M/M(1)`, and `eps` is its normalized terminal subsum.

1. `mu` is reflection positive at every prescribed cut.
2. `M(1) >= Z`. The exceptional mass `eta=eps(1)` satisfies
   `eta <= Cmass q^(t+1)` and is strictly less than one.
3. `mu^o=(mu-eps)/(1-eta)` has
   `A(z_(v_j),z_(v_(j+1)))>0` on every designated cycle edge.
4. Every positive-mass component or subsum has uniform single-slot
   marginals. This includes `mu`, `eps` when nonzero, and `mu^o`.
5. For `rho=mu` or `mu^o`, every slot `v` and every complex uniform
   mean-zero `f` on `X`,

       || E_rho[f(z_v) | (z_u)_(u!=v)] ||_2^2
          <= (Clead epsilon^(1/2) + Cmass q) ||f||_2^2.       (T3)

All constants depend only on `L,t,c0`, not on `|X|`, the kernel, or an
auxiliary index. A bijection of alphabets intertwining two kernels
pushes their component measures, mixtures and exceptional submeasures
to one another, preserving all normalizing masses.

### Proof: directed graph estimates

For an oriented simple graph with `e` edges, telescope its product by
replacing one factor at a time by `c`. Conditional on all other labels,
the factors incident to the two endpoints of the replaced edge separate
as `C f(x)g(y)`, where `|C|,|f|,|g|<=1`. There is no second factor on
this unordered pair. The centered operator bound gives error at most
`epsilon`. Reversed orientation uses the adjoint, of the same norm.
The total counting error is at most `e epsilon`.

For a bipartite graph kernel `K`, let `D=K-c^e`. In uniform orthonormal
coordinates its matrix entries are `D(x,y)/sqrt(N_X N_Y)`.
Consequently

    ||D||_op^4 <= tr((T_D T_D^*)^2)
       = E D(x0,y0) D(x1,y0) D(x1,y1) D(x0,y1).

Expansion gives 16 graph averages. Formal endpoints determine both
the original edge and its corner, so no loop or doubled unordered edge
is introduced. A term with `j` corners has error at most `j e epsilon`.
Every main term is `c^(4e)` with its expansion sign; their sum is zero.
Since `c<=1`, the error sum is at most
`e epsilon sum_j binom(4,j) j = 32e epsilon`.
Thus `||K-c^e||_op <= (32e epsilon)^(1/4)`. Empty graphs give zero
error. This proof uses neither commutativity nor a symmetric kernel.

### Proof: the actual address graphs and their symmetries

A word cannot equal its right shift. Also, a block cannot witness both
directions between two addresses: that would imply `c_cycle^2=1`.
The fixed position cycle has length `L>2`, so this is impossible.
Two opposed address edges would require disjoint sets of at least
`t+1` witnesses in only `w-s<=2t+1` coordinates. Thus each formal
unordered pair carries at most one directed edge, even after replacing
addresses by all their list entries.

There are `K^(w-s) r^s=d/2^s<=d` formal list entries, hence at most
`E` edges. Label coincidences do not identify these formal entries.
Since every interaction is at most one and there are at most `E`
unordered slot pairs, `1<=R_S<=B` and `nu_S(1)<=B`.

Reflection relabels symbols on the left in its block, commuting with
right-position shift. It therefore preserves the directions of the
address edges. It also preserves the positions of every exchanged
pair in `H^S`, hence the index weights. Reindexing independent lists
and indices proves symmetry of each cut matrix. This is not a
negation-invariance argument about `A`.

### Proof: marked cuts, including repeated emitted labels

At a cut in a marked block, let `Acut_(x,y)=H^S_(x,theta y)` on the
plus slots. If the cut symbols in `x` have gap `g`, its diagonal entry
is `Delta^g`. A different transposition crossing the cut moves one
cut symbol strictly past the other, so its positional gap is at least
`g+1`. There are fewer than `L^2` such transpositions. The off-diagonal
row sum is at most `L^2 Delta^(g+1)=Delta^g/10`.

For completeness, symmetric diagonal dominance follows without a
spectral theorem: use `2|u_x u_y|<=u_x^2+u_y^2` on each off-diagonal
term. It gives `Acut >= kappa Id` as a quadratic-form inequality.

Encode a half-index assignment by the vector of its one-hot slot
indices. The cross-index matrix is the entrywise exponential of the
Gram form `Acut tensor Id`. Splitting off `kappa Id` gives an
entrywise product of two positive semidefinite matrices. Indeed a
Gram matrix has positive semidefinite entrywise powers, by tensoring
its Gram vectors; the exponential power series preserves that fact.
The first exponential has diagonal at least one, since its generating
Gram matrix has nonnegative diagonal. The second is the tensor
product, over `n` slots, of

    11^T + (exp(kappa)-1) Id.

It dominates `a Id`: diagonalize each factor, whose eigenvalues are
at least `exp(kappa)-1>0`, and tensor the eigenbases. Alternatively,
expand the tensor product as a sum of positive semidefinite tensors
and retain its all-identity term. Schur products preserve positivity
by the same tensor-Gram argument. Hence their product dominates
`a Id`. Within-half interactions give the same diagonal factor,
with entries at least one, on the two sides, and preserve the bound.

For fixed lists, a slot and its reflection share an address, so the
two half-label evaluations are the same vector on half-index
assignments. This remains true when the evaluation map is not injective.
With `N=ell_s^n` such assignments, uniform double averaging gives
`a/N` times the uniform mean square, not `a` times that mean square.
After averaging lists,

    Q_S(J) >= a ell_s^(-n) E[I_S J^2]
           >= cmark E[I_S J^2].                          (M)

### Proof: unmarked defect and the exact marking bridge

At an unmarked cut the address lists split into plus and minus lists.
No index interaction crosses the cut. Let `I_plus` be the internal
plus-edge product and `R_plus` its index interaction. Reflection
identifies the two half-functions. With

    g(Y_plus) = I_plus E_(j_plus)[R_plus J],
    D_S(J) = E_(Y_plus,j_plus)[I_plus J^2],

weighted Cauchy--Schwarz and `I_plus^2<=I_plus` give
`||g||_2^2<=B^2 D_S(J)`. The cross-edge graph estimate replaces its
kernel by the nonnegative constant `c^(e_cross)` with error at most
`H epsilon^(1/4)`. Therefore

    Q_S(J) >= -B^2 H epsilon^(1/4) D_S(J).               (U)

In the terminal case the cross kernel is one and its form is
nonnegative.

Now mark the cut block `b`, writing `S'=S union {b}`. Each new
address has exactly `r` old plus addresses above it, one per plus
word `q_b`. The map of *formal entries*

    ((u,q_b),i) <-> (u,(q_b,i))

is a bijection. Both sides therefore give exactly the same independent
uniform list law, without an extra probability factor. Every new
address edge has `t+1` witnesses outside `b`. They certify the old
edge for **every** pair of plus words in `b`. Its ordered endpoints
and indices map injectively to the old formal edges. Thus every new
directed factor occurs once among the old internal factors:

    I_plus(Y_plus) <= I_(S')(Y').                       (F)

This inequality uses `[0,1]`, not idempotence; if `S'` is terminal
its right side is one.

Apply (M) to `S'`. In its nonnegative expectation restrict each of
the `n` independent new slot indices to the sublist bearing that
slot's actual word in block `b`. This event has probability exactly
`r^(-n)`. Conditional on it, all residual old indices are independent
uniform and the emitted labels are the old labels. Equation (F)
gives

    Q_(S')(J) >= cmark r^(-n) D_S(J) = b D_S(J).         (B)

Restrictions are on indices, not on their values; coincident field
labels neither change their probability nor remove a factor. This is
the literal bridge in I and P.

### Proof: mixture, exceptional mass, support and covariance

For a fixed cut block, pair each `S` omitting it with `S union {b}`
when `|S|<=t`. Every containing component is used exactly once.
By (U) and (B), its paired form is at least

    q^|S| (b q - B^2 H epsilon^(1/4)) D_S(J) >= 0.

The unpaired components are terminal and nonnegative. This proves
reflection positivity. It includes `q=0`, with the usual `q^0=1`.

The leading component has `e0<=E` edges and no index weights.
Its mass is at least `c^e0-e0 epsilon >= c0^E-E epsilon>=Z`.
There are at most `2^w` components, each of mass at most `B`.
For `q<=1`, the terminal mass divided by `M(1)` is at most
`Cmass q^(t+1)`, and the nonleading probability in either full or
nonterminal normalized mixture is at most `Cmass q`.
The latter denominator still contains the leading mass `Z`.
In particular `eta<1`, regardless of whether its displayed upper
bound happens to exceed one.

Every nonterminal marking leaves at least `t+1` clean blocks.
The designated cycle shifts in all of them, including its closing
edge. Its addresses are distinct and joined by the required directed
edge. Positive component weight therefore forces each of the selected
edge factors to be positive.

The simultaneous transitive group action on list labels preserves
every edge weight and the product uniform law, and does not change
the indices. Each component is consequently invariant; its normalized
one-slot marginals are uniform. No pair-marginal uniformity on all
admissible edges is claimed for a general weight.

Finally a kernel-intertwining bijection applied to every list entry
preserves each defining average and mass, proving the asserted
covariance.

### Proof: conditional mixing, without a lower bound at every conditioning value

In the normalized leading component write `x=z_v`, and `y` for
the other labels. The unnormalized density is `K1(x,y) K2(y)`,
where `K1` consists of the `m<=E` incident edges. Let

    A0(y)=E_x K1(x,y),   F0(y)=E_x f(x) K1(x,y).

The bipartite incident-graph estimate, also applied to its adjoint,
gives

    ||A0-c^m||_2 <= H epsilon^(1/4),
    ||F0||_2 <= H epsilon^(1/4) ||f||_2.

The squared conditional norm is exactly
`Z0^(-1) E_y K2 |F0|^2/A0`, interpreting the integrand as zero
where `A0=0`. This is legitimate: nonnegativity implies every
`K1(x,y)=0` there and the marginal density is also zero.

On `A0>=c^m/2` the contribution is at most
`Z^(-1) 2 c0^(-E) H^2 epsilon^(1/2) ||f||_2^2`.
The complementary set has uniform probability at most
`4 c0^(-2E) H^2 epsilon^(1/2)`. On it, weighted Cauchy--Schwarz
gives `|F0|^2/A0 <= E_x |f(x)|^2 K1 <= ||f||_2^2`.
Use `K2<=1` and `Z0>=Z` to obtain the leading term in (T3).
For `m=0` the conditional expectation is zero.

For either mixture, retain the component index as an additional
random variable. The tower property and conditional Jensen show that
forgetting it can only decrease the squared conditional norm. Within
every component the trivial contraction bound is `||f||_2^2`,
because that component's single-slot marginal is uniform. Their total
nonleading probability is at most `Cmass q`, proving (T3) for complex
as well as real `f`. This completes the proof.

## Application to the exact manuscript quantifiers

Take `X=F_p` and `A(x,y)=W_(l,p)(y-x)`, with `c0=1/(2k)`,
`epsilon=p^(-4 delta)` and `q=p^(-delta/2)`. Translation is a
transitive symmetry. The three local inputs stated above diagonalize
the centered convolution operator in the character basis, independently
of whether `W` is even.

(T1) holds once `E p^(-4 delta)<=Z`. (T2) holds once
`p^(delta/2)>=B^2 H/b`. The exceptional estimate is
`Cmass p^(-(t+1)delta/2)`, at most `p^(-4)` once
`p^((t+1)delta/2-4)>=Cmass`. The exponent is positive because the
manuscript chooses `(t+1)delta/2>5`.

(T3) is at most
`(Clead+Cmass) p^(-delta/2) ||f||_2^2`. It implies the requested
norm bound `p^(-gamma)||f||_2` when
`p^(delta/2-2 gamma)>=Clead+Cmass`; for `gamma=delta/10` the exponent
is `3 delta/10>0`. All these constants are independent of `l`.
This is an actual all-large-primes argument; no small-prime test is
being extrapolated.

In P, replace regular fibers by allowed regular fibers. The bound
`[0,1]`, density lower bound and Fourier input have exactly the same
form, and no later tuple argument inspects polynomial arguments.
Thus the construction is covered without any prime-distribution or
zero-free input.

For covariance, the stated auxiliary identity and its derivative give
`W_(lD,p)(y)=W_(l,p)(lambda(D)y)` when `p` does not divide `D`.
The affine label bijection in each paper intertwines the kernels.
In P the additional argument condition is preserved by the exact
identity `T_l(Dx-i)=T_(lD)(x)`. This is a conditional use of those
displayed auxiliary identities, not an audit of their other consequences.

## Corollary 2 (a stronger tradeoff with different mixture coefficients)

If additionally `epsilon<=(b/(B^2 H))^4`, choose
`q=(B^2 H/b) epsilon^(1/4)`. Then

    eta <= Cmass (B^2 H/b)^(t+1) epsilon^((t+1)/4),
    conditional norm <= C(L,t,c0) epsilon^(1/8) ||f||_2.

For `epsilon<=1`, the leading squared term `epsilon^(1/2)` is at
most `epsilon^(1/4)`. With the manuscript's Fourier input these
become `O(p^(-(t+1)delta))` exceptional mass and
`O(p^(-delta/2))` conditional norm. These bounds concern the
*modified* coefficients `const*p^(-|S|delta)`, not the original
mixture; they are not silently attributed to the manuscript.

Finite nonabelian groups are included: set `A(x,y)=W(x^(-1)y)` and
assume its centered uniform operator norm is small. Simultaneous left
translation preserves the kernel. The support statement becomes an
ordered cycle of allowed group quotients, whose product is the
identity. No abelian Fourier theorem is needed for this extension.

## Theorem 3 (the square-root marking term is necessary)

Fix `L,t` as above and use `A=1` on an even alphabet of size `N`.
Let `T=2^w B`, `B2=2^(w-1) B`, and `J=binom(K-1,2)`.
For

    0 < q <= min(1, 1/(2r B2)),    N >= J/q,

both the full and nonterminal normalized mixture have a slot `v`
and a balanced function `f:X->{-1,1}` such that

    || E[f(z_v) | (z_u)_(u!=v)] ||_2^2
        >= q / (4 r^2 T^2 (B2+1)).                      (S1)

Thus a uniform estimate with an `o(sqrt(q))` marking contribution
cannot hold for these very mixtures.

### Proof

Fix a block `b` and the `K` slots obtained by varying just that block;
call this cluster `C` and fix `v` in it. Put `m=K-1`. Let `Edup`
be the event that some two of the other `m` labels in `C` coincide,
and set `g=1_Edup sum_(u in C minus {v}) f(z_u)`.

If `b` is unmarked, these cluster slots have distinct addresses.
Conditional on all indices their chosen labels are independent uniform,
since `I_S=1` and `R_S` does not depend on lists. Hence, after
normalization, the cluster still has product uniform law. Its contribution
to `E[f(z_v)g]` is exactly zero and its collision probability is
at most `J/N`.

For `S={b}`, all `K` labels use one list of length `r=K/2`.
As `K>=6`, `m>r`, so `Edup` is certain by the pigeonhole principle.
For fixed indices, independence and balancedness give

    E_Y[f(Y_(j_v)) sum_(u!=v) f(Y_(j_u))]
       = sum_(u!=v) 1_(j_v=j_u).

Consequently the *unnormalized* singleton component contributes
at least `m/r`, because `R_S>=1` and each equality has independent
uniform index probability `1/r`. Other address-list factors integrate
to the same inequality; no normalization of `R_S` is omitted.

Markings containing `b` with size at least two have total unnormalized
weight at most `B2 q^2`; their possible negative contribution is at
most `m B2 q^2`. Writing `Mgood` for either relevant normalizer,
`1<=Mgood<=T`, we have

    E[f(z_v)g] >= m(q/r-B2 q^2)/Mgood >= m q/(2rT).

Also the total normalized mass of components containing `b` is at most
`B2 q`. Therefore

    ||g||_2^2 <= m^2 P(Edup)
               <= m^2(B2 q+J/N) <= m^2(B2+1)q.

Since `g` is measurable in the other labels, conditional
Cauchy--Schwarz gives (S1). The argument is unchanged when terminal
components are removed: the singleton remains nonterminal for `t>=1`,
and all discarded-error upper bounds remain valid. Since `||f||_2=1`,
this proves the stated sharpness. It does not assert optimality of the
spectral exponent among every possible tuple construction.

## Exact and formal evidence

`Main.lean` proves the universal directed witness and normalization
lemmas, the crossing-gap inequality, and the defect/gain balance.
The compiler record and its archived certificate are authoritative for
that limited scope. They do not certify the surrounding analytic proof
by association.

`verify.py` is a fail-closed replay of `exact_certificate.json`, the
current official Lean evidence, source locators and exact rational
diagnostics. Its finite diagnostics deliberately include non-even weights,
repeated labels, terminal markings and the exact index-event cardinality.
They corroborate, rather than replace, the quantified proofs above.

The Jacobian adapter's bounded symbolic computation is the exact spectrum
of the genuine `L=3` marked-cut matrix

    [[D,0,D^2],[0,D^2,0],[D^2,0,D]].

The typed contract, exact payload and full typed result are stored in the
adjacent `jacobian_*.json` files, including server version and protocol.
The eigenvalues `D-D^2,D^2,D+D^2` are also replayed algebraically.
This one operation is a diagnostic of the marked positivity calculation,
not the proof for arbitrary `L`. A timeout, error or incomplete response
would fail replay and provide no mathematical verdict.
