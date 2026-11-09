# A uniform affine-orthogonal obstruction to direct Runge

## Statement and status

Let \(g\geq3\), let
\[
 V=\mathbb F _2^{\,2g},\qquad q(x_1,y_1,\ldots,x_g,y_g)=\sum_i x_i y_i,
\]
let \(b(x,y)=q(x+y)+q(x)+q(y)\), and let
\(O=O^+_{2g}(2)\) be the **full** isometry group. Put \(G=V\rtimes O\),
acting naturally on the affine space \(V\).

**Theorem.**

1. The least index of an intransitive subgroup of \(G\) is
   \[
   \mu_g=2^{2g}-2^g.
   \]
   For any \(v\) with \(q(v)=1\), it is attained by
   \(H=v^\perp\rtimes O_v\). Its two orbits both have size \(2^{2g-1}\).
2. Let \(k\) be any number field. Suppose the reduced pole support of a
   rational function on a curve over \(k\) has arithmetic permutation
   image \(G\) in this action. For every finite extension \(K/k\), the
   number \(r_K\) of \(K\)-irreducible points of this support satisfies
   \[
   r_K\leq s_\infty(K)=r_1(K)+r_2(K).
   \]
   More precisely, if \(E/k\) is its splitting field and
   \(d=[E\cap K:k]>1\), then \(r_K\leq d/2\).
   The least relative degree \([K:k]\) for which \(r_K>1\) is \(\mu_g\).
   No extension can therefore satisfy \(r_K>|S_K|\) for an \(S_K\)
   containing all archimedean places.

This is a universal **prose proof**, not a formal compiler certificate.
The accompanying exact replay checks the small-rank falsification test,
the new bounded Jacobian computation, and the unchanged reviewed \(g=4\)
input. Finite tests are not the proof for arbitrary \(g\).
Independent review of the proof, originality and publishable significance
is still required.

## Scope and antecedents

The strongest relevant reviewed project result is
`K-K8-56-THETA-2COVER-EXTENSION-STABILITY`, in
`research/k8_56_theta_2cover_extension_stability_theorem.md` and its
unchanged certificate. It treats \(g=4\), obtaining the minimum \(240\)
by enumerating all \(417198\) proper subspaces, and proves the
all-number-fields pole inequality for that cover. The improvement here
is a proof for **every** \(g\geq3\), with no subgroup classification or
unbounded enumeration. The number-field argument also permits an
arbitrary number field as the base.

All quadratic-space counts and group-theoretic bounds used below are
proved here. The campaign specialization takes its monodromy and the
identification of the pole support from the two reviewed project claims;
it does not re-prove those arithmetic inputs.

Levin, *Variations on a theme of Runge*, published version,
DOI `10.5802/jtnb.634`, Theorems 1.2 and 1.3, is antecedent material for
the strict pole-count criterion and its varying-number-field formulation,
not a source for the new group inequality. Bilu--Parent,
`arxiv:0907.3306v1`, Theorem 1.2, likewise formulates a Runge condition
using Galois orbits on cusps. These passages were consulted by the
independent literature reader `orthogonal-literature`. No finiteness
conclusion from either theorem is needed to prove the inequalities here.

That bounded primary-source search did **not** locate a verified direct
antecedent for the exact affine minimum or the primitive-group obstruction.
It did identify Cooperstein, *Minimal degree for a permutation
representation of a classical group*, Israel J. Math. 30 (1978),
213--235, DOI `10.1007/BF02761072`, as an unresolved priority check.
Its text was unavailable to the reader; no proposition or lower bound
from it is assumed here. A general minimal-permutation-degree result
would also require checking its low-rank exceptions and whether it
actually bounds the subspace stabilizers needed here.
Absence of an obtained antecedent is **not** verified novelty.

## 1. Elementary quadratic-space facts

For a nonsingular quadratic space of dimension \(2n\) and type
\(\epsilon\in\{+1,-1\}\) over \(\mathbb F _2\), write \(O^\epsilon_{2n}(2)\)
for its full isometry group. A hyperbolic plane has quadratic form \(xy\);
an anisotropic plane has form \(x^2+xy+y^2\).
Symplectic Gram--Schmidt decomposes any such space into nonsingular
planes. Every plane is of one of these two types, and the orthogonal sum
of two anisotropic planes is hyperbolic: if their paired bases are
\(e,f\) and \(e',f'\), then \(e+e',f+e'\) is a hyperbolic pair, and
its two-dimensional complement contains the singular vector \(e+f+f'\),
so is hyperbolic too. Thus the parity of the number
of anisotropic planes determines the type. This also gives isometries
between spaces of the same dimension and type.

The signed sum \(\sum_x(-1)^{q(x)}\) is \(2\) on a hyperbolic plane and
\(-2\) on an anisotropic plane, and multiplies under orthogonal sum.
Consequently
\[
 \#\{q=0\}=2^{2n-1}+\epsilon2^{n-1},\qquad
 \#\{q=1\}=2^{2n-1}-\epsilon2^{n-1}.
 \tag{1}
\]
In the plus space set
\[
 N_g=2^{g-1}(2^g-1),\qquad
 Z_g=2^{g-1}(2^g+1)-1=(2^{g-1}+1)(2^g-1).
 \tag{2}
\]
These count nonsingular vectors and nonzero singular vectors respectively.

We spell out the transitivity facts used below. A nonzero singular
vector \(e\) extends to a hyperbolic pair: choose \(f\) with \(b(e,f)=1\)
and, if necessary, replace \(f\) by \(f+e\) to make \(q(f)=0\).
The complement has the same type as the original space. Repeating this
construction extends any totally singular subspace to the first
coordinates of a hyperbolic decomposition. At each step the remaining
basis of that subspace can be adjusted by multiples of \(e\) to lie in
the complement. Hence \(O\) is transitive on the totally singular
subspaces of each dimension.

For a nonsingular \(v\) in the plus space, some member \(w\) of the
standard singular basis has \(b(v,w)=1\). Then \(w,v+w\) is a hyperbolic
pair and \(v=w+(v+w)\). Extending that pair gives transitivity on
\(q=1\); the preceding construction gives transitivity on nonzero
\(q=0\). Finally, isometries between two nonsingular subspaces of the
same dimension and type, and between their orthogonal complements,
combine into an ambient isometry.

Counting ordered hyperbolic pairs gives
\[
 |O^\epsilon_{2n}(2)|
 =2^{n(n-1)+1}(2^n-\epsilon)
   \prod_{i=1}^{n-1}(2^{2i}-1),\qquad n\geq1.
 \tag{3}
\]
Here is a derivation including the small dimensions. There are
\((2^{n-1}+\epsilon)(2^n-\epsilon)\) nonzero singular first vectors.
For each there are \(2^{2n-2}\) singular partners with pairing one:
adding the first vector pairs up that affine hyperplane and toggles
the quadratic value. The complement retains the type. This gives
the recurrence down to \(|O^+_2(2)|=2\), or to
\(|O^-_2(2)|=6\), the permutations of its three nonzero vectors.
These bases and the recurrence give (3). The zero-dimensional plus
space has group order one.

## 2. Every proper nonzero subspace has at least \(N_g\) conjugates

**Lemma.** For \(0<U<V\),
\[
 [O:O_U]\geq N_g.
 \tag{4}
\]

First consider totally singular subspaces of dimension \(r\).
The transitivity just proved and a count of ordered singular bases give
their number
\[
 T_g(r)=
 \frac{\prod_{j=0}^{r-1}Z_{g-j}}
      {\prod_{i=1}^{r}(2^i-1)},\qquad 1\leq r\leq g.
 \tag{5}
\]
Indeed, after choosing a \(j\)-dimensional totally singular space,
the next basis vector has \(2^jZ_{g-j}\) choices in its perpendicular
space, outside itself. Dividing by the number
\(\prod_{j=0}^{r-1}(2^r-2^j)\) of ordered bases cancels the factors \(2^j\).

The ratios
\[
 \frac{T_g(r+1)}{T_g(r)}
 =\frac{Z_{g-r}}{2^{r+1}-1}
 \tag{6}
\]
strictly decrease with \(r\). A positive sequence with decreasing
successive ratios has no strict interior minimum: it first increases
and then decreases, allowing either segment to be empty. Thus the
minimum of (5) occurs at an endpoint. The endpoints satisfy
\[
 T_g(1)=Z_g>N_g,\qquad
 T_g(g)=2\prod_{i=1}^{g-1}(2^i+1)>N_g.
 \tag{7}
\]
For the second inequality, \(g=3\) gives \(30>28\). For \(g\geq4\),
the product is greater than \(2^{1+g(g-1)/2}\), whose exponent is at
least \(2g-1\), since \((g-1)(g-4)\geq0\).

Now let \(R=U\cap U^\perp\) be the radical of the polar form on \(U\).
If \(R\ne0\) and \(q|_R=0\), its stabilizer is contained in the
stabilizer of the totally singular subspace \(R\), so (7) proves (4).
If \(q|_R\ne0\), it is a nonzero linear functional because \(b|_R=0\).
When \(\dim R=1\), \(R\) is a nonsingular line, with orbit size \(N_g\).
When \(\dim R>1\), the characteristic subspace
\(\ker(q|_R)\) is a nonzero totally singular subspace, again giving (4).
This includes all subspaces of odd dimension and all degenerate even
dimensions; no assumption that a polar radical is totally singular
has been made.

It remains to consider \(R=0\). Then \(\dim U=2k\), with
\(1\leq k\leq g-1\), and its complement has dimension \(2l\), where
\(l=g-k\). Both restrictions have the same type \(\epsilon\), since
the ambient type is plus. The orthogonal decomposition and transitivity
above give exactly
\[
 [O:O_U]=
 \frac{|O^+_{2g}(2)|}
 {|O^\epsilon_{2k}(2)|\,|O^\epsilon_{2l}(2)|}.
 \tag{8}
\]
For clarity, the following deliberately loose bound avoids any
optimization of this formula. Rewriting (3) yields
\[
 |O^\epsilon_{2n}(2)|
 =2^{2n^2-n+1}(1-\epsilon2^{-n})
       \prod_{i=1}^{n-1}(1-4^{-i}).
 \tag{9}
\]
For any finite product here,
\(\prod_{i=1}^{g-1}(1-4^{-i})>1-\sum_{i=1}^{\infty}4^{-i}=2/3\).
Also \(1-2^{-g}\geq7/8\), while
\((1-\epsilon2^{-k})(1-\epsilon2^{-l})\leq9/4\) and the two
remaining denominator products are at most one. Therefore
\[
 [O:O_U]>
 \frac7{54}\,2^{4kl}>
 2^{4kl-3}\geq2^{4g-7}\geq2^{2g-1}>N_g.
 \tag{10}
\]
The inequalities use \(7/54>1/8\),
\(kl\geq g-1\), and \(g\geq3\).
This finishes the proof of (4), uniformly in \(g\).

The rank restriction is substantive. In dimension four, the orthogonal
sum of two anisotropic planes has full group order \(72\), while the
stabilizer of either plane has order \(6^2=36\). Taking the translations
in one plane and this stabilizer gives an intransitive affine subgroup
of index \(8<2^4-2^2=12\), with orbit sizes \(4,12\).

## 3. All affine subgroups, and attainment

Let \(H\leq G\) be intransitive. Set \(W=H\cap V\), and let \(P\) be
the image of \(H\) in \(O\). The translation subgroup \(V\) is normal,
so conjugation makes \(W\) a \(P\)-invariant linear subspace.
The exact sequence \(1\to W\to H\to P\to1\), without any assertion
that it splits, gives
\[
 [G:H]=2^{2g-\dim W}[O:P]
 \geq 2^{2g-\dim W}[O:O_W].
 \tag{11}
\]
The possibility \(W=V\) is excluded because translations alone are
transitive. If \(W=0\), (11) is at least \(2^{2g}>2N_g\).
Otherwise (4) applies and \(2^{2g-\dim W}\geq2\). Thus every
intransitive \(H\), including nonsplit subgroups, has
\[
 [G:H]\geq2N_g=2^{2g}-2^g.
 \tag{12}
\]
Equivalently, one can apply (4) to \(W^\perp\); the two subspace
stabilizers agree because \(b\) is nonsingular and \(O\)-invariant.

For attainment take \(q(v)=1\) and \(W=v^\perp\). Transitivity on
nonsingular vectors gives \([O:O_v]=N_g\).
Because the only nonzero scalar is one, \(O_W=O_v\).
Every member of \(O_v\) fixes \(b(v,x)\), while \(W\)-translations
are transitive on each of its two fibers. Hence
\[
 H=W\rtimes O_v
\]
has exactly these two affine orbits, each of size \(2^{2g-1}\),
and index \(2N_g\). This proves the first assertion.

## 4. Double cosets, field intersection, and archimedean places

We first give the abstract counting mechanism. Suppose a finite
primitive permutation group \(A\) has degree \(m\), point stabilizer
\(B\), and permutation rank
\(\rho=|B\backslash A/B|\leq m/2\).
For any proper subgroup \(J<A\), put \(d=[A:J]\).
The \(J\)-orbits on \(A/B\) are the double cosets \(J\backslash A/B\),
equivalently the right \(B\)-orbits on \(J\backslash A\).
The latter have sizes
\[
 [B:B\cap a^{-1}Ja]
 \tag{13}
\]
and their sizes sum to \(d\).
If none is a singleton, their number is at most \(d/2\).
If one is a singleton, \(aBa^{-1}\leq J\).
Primitivity says \(B\) is maximal, so properness forces
\(J=aBa^{-1}\). In this exceptional case \(d=m\), and the number
of double cosets is \(\rho\leq d/2\) again.
Thus, for every proper \(J\),
\[
 |J\backslash A/B|\leq[A:J]/2.
 \tag{14}
\]
For \(J=A\) the orbit count is one. This is a general elementary
lemma, not a claim that every primitive group has rank at most \(m/2\).

For our \(G\), the natural module \(V\) is irreducible. Indeed the
singular orbit spans the standard singular basis. The nonsingular
orbit also spans \(V\): for \(j\ne i\), the nonsingular vectors
\(e_j+f_j\) and \(e_i+e_j+f_j\) differ by \(e_i\), and the same
construction gives \(f_i\). An invariant nonzero subspace contains
one of these entire orbits. This proves irreducibility.

Consequently \(B=O\) is maximal in \(G\). Explicitly, any subgroup
containing \(B\) is \(U\rtimes B\) for the \(B\)-invariant translation
space \(U\); irreducibility leaves only \(U=0,V\).
The three \(B\)-orbits are
\[
 \{0\},\quad \{q=1\},\quad \{q=0\}\setminus\{0\},
\]
so \(m=2^{2g}\), \(\rho=3\leq m/2\), and (14) applies.

Embed \(E\) and \(K\) in a common algebraic closure of \(k\), put
\(F=E\cap K\), and set \(J=\operatorname{Gal}(E/F)\).
No normality hypothesis on \(K/k\) is needed. The compositum
\(EK/K\) is Galois. Restriction embeds its Galois group into
\(\operatorname{Gal}(E/k)\); the fixed field of its image inside \(E\)
is exactly \(E\cap K=F\). Galois correspondence therefore identifies
that image with \(J\). This proves that the pole components over \(K\)
are exactly the \(J\)-orbits on \(G/B\), and
\[
 r_K=|J\backslash G/B|,\qquad [G:J]=[F:k]=d.
 \tag{15}
\]
For \(d>1\), (14) gives \(r_K\leq d/2\).
Writing \(n=[K:\mathbb Q]\), the tower law and signature formula give
\[
 d\leq[K:k]\leq n,\qquad
 s_\infty(K)=\frac{n+r_1(K)}2\geq n/2\geq d/2.
 \tag{16}
\]
For \(d=1\), \(r_K=1\leq s_\infty(K)\) separately.
Adding finite places to \(S_K\) can only increase its cardinality.
This proves the claimed obstruction for arbitrary number fields.

Finally \(r_K>1\) means \(J\) is intransitive, so (12) and the tower
law give \([K:k]\geq d\geq\mu_g\). Conversely, the intermediate field
\(E^H\), with \(H\) from Section 3, has relative degree \(\mu_g\)
and exactly two pole components. This proves that the splitting
threshold is attained among number fields, not just abstract subgroups.

## 5. Campaign specialization and exact replay

The reviewed pole support of the nonzero \(D_{(25,2)}\) theta cover of
\[
 (T-1)(T-9)(T-25)=384u(u^2-1)(u^2-4)
\]
has precisely this monodromy for \(g=4\). Substitution into the theorem gives
\[
 |V|=256,\quad N_4=120,\quad \mu_4=240,\quad
 |H\text{-orbits}|=(128,128).
\]
It recovers the reviewed result without editing or re-running its
enumeration. The universal proof replaces that enumeration as the
reason for the minimum and applies in every larger rank, and in rank
six, as well. It is not a new exclusion of the \((5,6)\) curve.
Neither surviving \(K(a)=8\) system is excluded; no assertion about
unit completeness, the full Selmer group, \(K(a)\geq9\), or
multiplicity-five nonrealizability follows.

The small falsification test enumerates only the \(2824\) proper
subspaces of \(\mathbb F _2^6\), including zero, and obtains minimum
affine index \(56\), attained with two size-\(32\) orbits.
The new Jacobian operation
`group.order.compute` takes the exact permutations of its 28
nonsingular transvections on 64 vectors. Its inspected typed contract
allows degree at most 64. Comparing its group order with (3) identifies
the generated group as the full \(O^+_6(2)\).
The previously inspected subset-canonicalization contract is not used:
its degree-50 and order-10000 limits do not fit this test.
The exact payload, typed output, server/protocol identifiers and adapter
exit status are retained in the dedicated `affine_orthogonal_runge_*.json`
files. Jacobian `0.14.0`, protocol `2025-11-25`, returned order
`40320` in `21 ms`, with adapter exit zero and no error or timeout.
No transport error, timeout, or incomplete result is interpreted
as a mathematical answer.

Generate and run the one bounded adapter request:

```bash
/home/argustest/zimo/argus-live-update/.venv/bin/python \
  research/affine_orthogonal_runge_verify.py prepare
/home/argustest/zimo/argus-live-update/.venv/bin/python \
  research/affine_orthogonal_runge_verify.py execute
```

The execution action calls exactly the configured Argus adapter with
`run --operation group.order.compute --payload-file
research/affine_orthogonal_runge_jacobian_payload.json --timeout 60`,
and records its actual exit status separately. An outer 90-second
process limit also records a timeout as a non-conclusion.

Certify once, or independently replay without writing:

```bash
/home/argustest/zimo/argus-live-update/.venv/bin/python \
  research/affine_orthogonal_runge_verify.py certify
/home/argustest/zimo/argus-live-update/.venv/bin/python \
  research/affine_orthogonal_runge_verify.py verify
```

The exact computation is corroboration and a rerunnable certificate of
the computational ingredients only. The quantified claims in Sections
2--4 require independent mathematical reading, not extrapolation from
the checked ranks. Originality, the inaccessible Cooperstein priority
check, and field-level publishable significance remain review obligations.
