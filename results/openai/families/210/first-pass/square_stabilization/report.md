# Square stabilization of the normalized canonical Foulkes--Howe map

## Statement and source scope

The target is the specific map
\[
\mu_{a,b,V}:\operatorname{Sym}^b(\operatorname{Sym}^a V)
\longrightarrow\operatorname{Sym}^a(\operatorname{Sym}^b V)
\]
obtained by identifying symmetric powers with invariant tensors using
the normalized average \(1/a!\), then multiplying componentwise in
\((\operatorname{Sym} V)^{\otimes a}\). It is not merely the existence
of some equivariant map of maximal rank.

The theorem to be established is surjectivity for every finite-dimensional
complex \(V\), every integer \(a\ge2\), and every integer
\(b\ge(a-1)^2\).

The staged sources read are:

1. OpenAI, *Quadratic stabilization of the canonical Foulkes--Howe map*,
   September 25, 2026, `build/paper.tex`: equations `average` and `map`,
   Theorem `thm:main`, the diagonal criterion in Section `sec:map`,
   Lemma `lem:shift`, and all four steps of Proposition `prop:vanishing`.
   Its stated uniform bound is \(b\ge a(a-1)\).
2. OpenAI, *Foulkes' conjecture for the sixth symmetric power*,
   September 25, 2026, `build/sections/introduction.tex`,
   `reduction.tex`, and `verification.tex`: the abstract comparison
   theorem; Corollary `cor:quadratic-range`; Lemma `lem:polarization`;
   the module-generation consequence; and the division between base
   comparisons \(6\le b\le25\), band comparisons \(26\le b\le29\),
   and canonical surjectivity \(b\ge30\).

The public source snapshot located by the literature reader is
`openai/math` commit `4eaee87548250b2682affda7d05d947c05554bae`.
Local staged text is the authoritative object of this audit. Its map,
bound, and relevant proof steps agree with the inspected public statements.
Source propositions are recorded as assumptions in `research/MATH_STATE.json`;
independent citation attribution remains a Reviewer obligation.

## Known results and originality boundary

The companion's whole-power polarization argument already uses the
fact that a lowering operator's \(L\)-th power is injective on
an \(\mathfrak{sl}_2\) weight space of weight at least \(L\).
That fact is not claimed as new. The proposed improvement is to apply
it to the *last* composition of the quadratic paper, rather than
cancel each of its \(r^2\) derivatives separately.

A bounded primary-source comparison found:

- Brion (1997), Theorem 3.3, a dimension-dependent effective bound for
  canonical surjectivity.
- Ikenmeyer, arXiv:1509.04957v1, Theorem 1.3, propagation from an
  already injective canonical seed, not a uniform seed bound.
- Cheung--Ikenmeyer--Mkrtchyan, arXiv:1509.03944v1, Theorem 6(a),
  injectivity at \((5,6)\), hence a stronger small-\(a=5\) range
  than the proposed uniform square bound.

No source in this focused comparison states the uniform square bound.
This is a defensible comparison with the staged theorem, not a proof of
global bibliographic novelty. The present route does not claim optimal
stabilization, or improvement on every known small-\(a\) result.

The two rectangular tensor maps in opposite directions are adjoint
under the tensor-induced perfect pairings, up to invertible
normalization scalars. Thus the cited canonical injectivity results
give the opposite canonical surjectivity results. Naturality and a
projection onto a direct summand transfer surjectivity from stable
dimension to every smaller dimension. These observations explain the
small-\(a\) comparison without substituting abstract Foulkes positivity
for canonical rank.

The inherited Wiki index has no Foulkes or shared-vector power-shift
entry relevant to this route. No external theorem is needed for the
elementary algebraic proof below beyond characteristic-zero linear
algebra and splitting a binary form over the complex numbers.

## 1. A whole-power theorem without semisimplicity

**Theorem 1 (locally nilpotent power shift; `C_POWER`).**
Let \(K\) be a characteristic-zero field, \(M\) a \(K\)-vector space,
and \(D,E,H\) linear endomorphisms satisfying
\[
 ED-DE=H,\qquad HD-DH=-2D,\qquad HE-EH=2E.
\]
If \(Hv=wv\), where \(w,L\) are natural numbers with \(w\ge L\), and
\(E^Nv=0\) for some natural number \(N\), then
\[
 D^Lv=0\quad\Longrightarrow\quad v=0.
\]
Neither finite-dimensionality nor a decomposition into irreducible
representations is required.

**Proof.**
For an arbitrary scalar weight \(w\), induction using the first two
commutators gives
\[
 H D^nv=(w-2n)D^nv,\qquad
 E D^{n+1}v=D^{n+1}Ev+(n+1)(w-n)D^nv.                 \tag{1}
\]
For completeness, the coefficient in the second induction changes by
\[
 (n+1)(w-n)+(w-2(n+1))=(n+2)(w-n-1).
\]
Thus (1) is an identity of endomorphisms on the indicated weight
vectors, not an appeal to complete reducibility.

First suppose \(Ev=0\). Induct on \(L\). The case \(L=0\) is the
identity operator. If \(D^{n+1}v=0\) and \(n+1\le w\), applying \(E\)
and (1) gives
\[
 0=(n+1)(w-n)D^nv.
\]
The scalar is nonzero in characteristic zero, so \(D^nv=0\);
the induction proves \(v=0\).

Now induct on the nilpotence bound \(N\), simultaneously for all
\(v,w,L\). If \(N=0\), the hypothesis already says \(v=0\).
In the successor case \(E^{N+1}v=0\), the vector \(Ev\) has weight
\(w+2\) and satisfies \(E^N(Ev)=0\). From \(D^Lv=0\) also
\(D^{L+1}v=0\); equation (1), with \(n=L\), gives
\(D^{L+1}(Ev)=0\). Since \(L+1\le w+2\), the induction hypothesis
applied to \(Ev\) yields \(Ev=0\). The primitive case just proved
then gives \(v=0\). This proves the theorem.

This entire operator theorem, including (1) and the two inductions, is
proved in `Main.lean`. Its main declaration is
`SquareStabilization.sl2_power_injective`; the precise translation and
its limits are in `statement_fidelity.md`. In particular, the formal
source assumes commutator identities, **not** injectivity.

**Polynomial specialization.**
On a polynomial ring in independent coordinate blocks \(x,y\), and
any finite collection of spectator variables, set
\[
 D=\sum_k y_k\partial_{x_k},\quad
 E=\sum_k x_k\partial_{y_k},\quad
 H=\sum_k x_k\partial_{x_k}-\sum_k y_k\partial_{y_k}.
\]
The product rule and commutation of partial derivatives give
\[
 ED-DE=\sum_k x_k\partial_{x_k}-\sum_k y_k\partial_{y_k};
\]
the mixed second-derivative terms cancel with the displayed signs.
The other two commutators follow either by the same calculation or
by observing that \(D\) changes the two degrees by \((-1,+1)\)
and \(E\) changes them by \((+1,-1)\).
On bidegree \((p,q)\), \(H\) acts by \(p-q\), while
\(E^{q+1}=0\). Consequently
\[
             p-q\ge L \quad\Longrightarrow\quad D^L
             \text{ is injective}.                  \tag{2}
\]
This includes equality, arbitrary spectators, and \(L=0\).
The coordinate calculation and this specialization are a prose proof,
not additional Lean declarations.

## 2. The exact universal joint threshold

**Theorem 2 (`C_JOINT`, with obstruction `C_DET`).**
Fix integers \(r,L\ge1\) and \(j\ge0\). In coordinate dimension \(n\),
let \(F_{n,r,j}\) consist of polynomials in independent blocks
\(x_1,\ldots,x_r\), separately homogeneous of degree \(j\), initially
independent of an additional block \(y\). Put
\[
             J_{r,L}=\prod_{i=1}^r
                       (y\cdot\partial_{x_i})^L .
\]
Then \(J_{r,L}|_{F_{n,r,j}}\) is injective for **every** finite \(n\)
if and only if \(j\ge rL\). Necessity is a statement about all
dimensions together, not a purported threshold in each fixed dimension.

**Sufficiency.**
Apply the \(r\) powers in any fixed order. Before the \(i\)-th power,
its untouched source block has degree \(j\) and the shared destination
block has degree \((i-1)L\). Its weight is therefore
\[
                    j-(i-1)L\ge L.
\]
Equation (2) makes that full power injective on the entire intermediate
homogeneous space, including its spectator blocks. Thus the product
is injective. For \(n=0\) the same conclusion follows from the
polynomial ring \(K\): the positive-\(j\) homogeneous source is zero;
the sufficient range has \(j\ge rL>0\).

**Necessity and a symbolic certificate.**
Take \(n=r\), write \(X\) for the matrix with columns \(x_i\), and set
\[
                         f=\det(X)^j.
\]
This is nonzero: for \(j>0\) the diagonal monomial
\(\prod_i x_{ii}^j\) has coefficient one; for \(j=0\) it is the
constant one. It has degree \(j\) in each block. Multilinearity of
the determinant and alternation give the rank-one update identity
\[
 \det(x_1+t_1y,\ldots,x_r+t_ry)
       =\det(X)+\sum_i t_i\det(x_1,\ldots,y,\ldots,x_r).       \tag{3}
\]
Terms involving two or more replaced columns have repeated columns
\(y\) and are zero. Raising (3) to the \(j\)-th power gives total
\(t\)-degree at most \(j\). Taylor's formula gives
\[
 J_{r,L}f=(L!)^r[t_1^L\cdots t_r^L]\,
                    f(x_1+t_1y,\ldots,x_r+t_ry).
\]
The coefficient has total degree \(rL\), so it is zero when
\(j<rL\). This proves the general obstruction, not just its finite
examples. For \(n=1\) a smaller threshold can hold; this does not
contradict the universal assertion.

In particular, the sufficient threshold in the sixth-power
manuscript's polarization lemma is universally sharp. Equivalently,
for \(j\ge rL\),
\[
 (\operatorname{Sym}^j V)^{\otimes r}
  =\sum_{y\in V}(y^{\otimes r})^L
                  (\operatorname{Sym}^{j-L}V)^{\otimes r}.
\]
The dual map, up to a nonzero Taylor-factorial scalar, is exactly
\(J_{r,L}\). When \(L\le j<rL\), the determinant functional shows
failure of this spanning statement in dimension \(r\).

## 3. Vanishing at the square bound

**Theorem 3 (`C_SQUARE_VAN`).**
Let \(V\) be a finite-dimensional complex vector space,
\(a\ge1\), \(b\ge0\), and \(b\ge(a-1)^2\). Suppose a symmetric
\(a\)-linear form \(T\) on \(\operatorname{Sym}^bV\) satisfies
\[
 T(P,\ldots,P)=0
 \quad\text{for every product \(P\) of \(b\) vectors.}        \tag{4}
\]
The empty product for \(b=0\) is one. Then \(T=0\).

**Proof.**
Induct on \(a\), simultaneously in \(b,V\).
For \(a=1\), products span \(\operatorname{Sym}^bV\), including
\(\operatorname{Sym}^0V=K\).
For \(a\ge2\), put \(r=a-1\), \(m=b-r\). Then
\[
 b\ge r^2,\qquad
 m\ge r(r-1)\ge(r-1)^2,\qquad m\ge0.                       \tag{5}
\]
If \(V=0\), then \(b\ge1\) and \(\operatorname{Sym}^bV=0\),
so the assertion is immediate. Otherwise work in coordinates.

**Binary coefficient.**
Let \(Q=y_1\cdots y_m\), with \(Q=1\) when \(m=0\).
For all \(c\in\mathbb C\), the binary form \(X^r+cY^r\) splits
into \(r\) linear factors. Substitution, even for dependent vectors
\(x,t\), shows that \((x^r+ct^r)Q\) is a product of \(b\) vectors.
The coefficient of \(c\) in (4) is therefore zero. Since \(a\ne0\),
\[
                   T(x^rQ,\ldots,x^rQ,t^rQ)=0.             \tag{6}
\]
Here the first input occurs in \(r\) slots.

**Freeing the last slot.**
For fixed \(x\), regard
\[
                   H_x=T(x^rQ,\ldots,x^rQ,t^b)
\]
as a polynomial in \(t,y_1,\ldots,y_m\). Apply in order
\(y_i\cdot\partial_t\), for \(1\le i\le m\). The result is
\[
 \frac{b!}{r!}\,
                   T(x^rQ,\ldots,x^rQ,t^rQ)=0.
\]
Before step \(i\), the source \(t\)-degree is \(b-i+1\) and
the untouched \(y_i\)-degree is \(r\), so their difference is
\(m-i+1\ge1\). Equation (2) with \(L=1\) cancels every
operator and gives \(H_x=0\). If \(m=0\), this is the empty
composition and (6) already gives the same conclusion.
Pointwise vanishing is a polynomial identity because \(\mathbb C\)
is infinite.

**Induction on the remaining slots.**
For fixed \(x,t\), define the symmetric \(r\)-linear form
\[
 S_{x,t}(Q_1,\ldots,Q_r)
              =T(x^rQ_1,\ldots,x^rQ_r,t^b)
 \quad\text{on }\operatorname{Sym}^mV.
\]
Its diagonal vanishes on all products of \(m\) vectors by the
preceding paragraph. The induction hypothesis applies because
\(m\ge(r-1)^2\), including \(r=1,m=0\). Thus
\[
 T(x^rQ_1,\ldots,x^rQ_r,t^b)=0
       \quad\text{for arbitrary }Q_i\in\operatorname{Sym}^mV.  \tag{7}
\]

**Removing the shared power.**
Fix \(t\) and form
\[
                         f=T(v_1^b,\ldots,v_r^b,t^b).
\]
Introduce an independent block \(x\), of initial degree zero.
With \(D_i=x\cdot\partial_{v_i}\), differentiation acts only
on the indicated slot, and (7) gives
\[
 \prod_{i=1}^rD_i^rf
      =\left(\frac{b!}{m!}\right)^r
                  T(x^rv_1^m,\ldots,x^rv_r^m,t^b)=0.        \tag{8}
\]
Theorem 2 applies with \(j=b,L=r\), because \(b\ge r^2\).
Equivalently, before power \(i\) the weight is
\(b-(i-1)r\ge r\), including equality at the last power
when \(b=r^2\). Therefore (8) implies \(f=0\).
As \(t\) is arbitrary, \(T\) vanishes on all tuples of pure powers.

Pure powers span: for \(k\ge1\), inclusion-exclusion in the symmetric
algebra gives
\[
 k!\,u_1\cdots u_k=
 \sum_{J\subseteq\{1,\ldots,k\}}(-1)^{k-|J|}
                 \left(\sum_{j\in J}u_j\right)^k.
\]
Only monomials containing every index survive, with coefficient \(k!\).
For \(k=0\), one spans \(\operatorname{Sym}^0V\).
Multilinearity now gives \(T=0\), completing the induction.

The corner \(a=2,b=1\) has \(r=1,m=0\).
In fact (6) is directly \(T(x,t)=0\); no positive-length
product or strict inequality at a whole-power endpoint is being assumed.

## 4. The exact canonical map

**Theorem 4 (`C_SQUARE`).**
For every finite-dimensional complex \(V\), \(a\ge2\) and
\(b\ge(a-1)^2\), the normalized canonical map \(\mu_{a,b,V}\)
is surjective.

**Proof, including the diagonal criterion `M_MAP`.**
Let
\[
 R_j=((\operatorname{Sym}^jV)^{\otimes a})^{\mathfrak S_a},
 \qquad A\subseteq\bigoplus_jR_j
       \text{ be the algebra generated by }R_1 .
\]
The quotient projection composed with the normalized average is the
identity on the symmetric-power quotient, and averaging composed with
the quotient is the identity on invariant tensors. Thus these are
inverse identifications, with no unspecified normalization scalar.
Multiplication sends \(\operatorname{Sym}^bR_1\) to \(A_b\).

By pure-power spanning, \(z(u)=u^{\otimes a}\) spans \(R_1\).
Componentwise multiplication gives exactly
\[
 z(u_1)\cdots z(u_b)=(u_1\cdots u_b)^{\otimes a}.
\]
Hence \(A_b\) is precisely the span of \(P^{\otimes a}\) over all
products \(P\) of \(b\) vectors.
Every linear functional \(\lambda\) on \(R_b\) determines the symmetric
\(a\)-linear form
\[
 T_\lambda(w_1,\ldots,w_a)
              =\lambda(\operatorname{Av}(w_1\otimes\cdots\otimes w_a)).
\]
Conversely, linearization and restriction to \(R_b\) recover the
functional from any such symmetric form; averages of simple tensors
span \(R_b\). Therefore the annihilator of \(A_b\) corresponds exactly
to the forms in (4). Theorem 3 makes that annihilator zero.
Finite-dimensional duality gives \(A_b=R_b\), exactly the stated
surjectivity. If \(V=0\), both source and target are zero because
\(a,b\ge1\); the same conclusion holds.

The improvement over the staged uniform theorem is the additive
quantity \(a-1\):
\[
                     a(a-1)-(a-1)^2=a-1.
\]
This is a universal theorem, not extrapolation from ranks in small
dimensions. For \(a=6\) the canonical-surjectivity range begins at
\(b=25\), rather than \(30\). Complete reducibility then supplies
abstract equivariant embeddings in that range. Combining this theorem
with the manuscript's already separate base comparison for
\(6\le b\le24\) would prove its sixth-power comparison without any
use of the residual \(26\)--\(29\) band calculation. That application
is conditional on the manuscript's base computations; the present
certificate does not rerun or certify those large programs.

## 5. Certification scope and independent-review boundary

The proof above is a complete mathematical proof of the square-bound
statement and of the exact universal joint threshold. The universal
algebraic operator core is independently compiler-checkable. Its
polynomial realization, determinant argument, invariant-tensor
identification, and multilinear induction are proved in prose here.
They must not be reported as if Lean checked them.

`verify.py` is a deterministic exact replay of the associated symbolic
identities and bounded adversarial diagnostics, paired with source-bound
Lean evidence. Its finite matrix ranks are diagnostics, not the proof
of a universal theorem. The Jacobian operation checks a precisely
declared finite specialization of the determinant obstruction; its
typed payload, output, server version, and exit status are separate JSON
files. A constant-coefficient operation does not accept unspecialized
polynomial coefficients \(y_k\), so no such unsupported call is made.

No false literal manuscript assertion has been established on this
route. A non-sharp sufficient bound is not a false assertion, and no
`F_...` refutation claim is warranted merely because the proof improves it.

Independent Reviewer replay, statement-fidelity approval, citation
attribution, and a final originality/significance judgement have not
occurred. In particular, `verified_new` and independent acceptance are
not claimed by the Engineer.

### Focused primary-source references

- [OpenAI quadratic source, fixed snapshot](https://github.com/openai/math/blob/4eaee87548250b2682affda7d05d947c05554bae/preprints/Quadratic-Stabilization-of-the-Canonical-Foulkes-Howe-Map-September-25-2026/build/paper.tex).
- [OpenAI sixth-power introduction, fixed snapshot](https://github.com/openai/math/blob/4eaee87548250b2682affda7d05d947c05554bae/preprints/Foulkes-Conjecture-for-the-Sixth-Symmetric-Power-September-25-2026/build/sections/introduction.tex).
- [Brion's 1997 primary-source introduction, reproducing Theorem 3.3](https://smf.emath.fr/sites/default/files/2026-07/smf_sem-cong_2_157-183__sample.pdf).
  For \(\dim V=d\), with \(N\) least such that
  \(dN\ge\binom{m+d-1}{d-1}\), the displayed bound is
  \(n\ge(m-1)(d-1)(mN+m-N)\).
- [Ikenmeyer, arXiv:1509.04957v1](https://arxiv.org/abs/1509.04957v1),
  Theorem 1.3: injectivity at a canonical seed propagates upward.
- [Cheung--Ikenmeyer--Mkrtchyan, arXiv:1509.03944v1](https://arxiv.org/abs/1509.03944v1),
  Theorem 6(a): canonical injectivity at \((5,6)\).

### Remaining manuscript dependency spine

These are source assertions recorded for audit scope, not results newly
reproduced by the present small exact replay:

| Ledger claim | Source locator | Role in the sixth-power proof |
|---|---|---|
| `M_STRIP_UPPER` | `upper.tex`, `lem:strips`, `prop:upper` | Signed strip removals and the gap-monotone bound \(F\le U\) |
| `M_RECURRENCES` | `upper.tex`, `targetrec`, `sourcerec` | Exact target tables and source fallback computations |
| `M_POWER_LOWER` | `lower.tex`, `lem:sumset`, `prop:power` | Independent highest-weight products amplify target seeds |
| `M_RECTANGLES` | `reduction.tex`, `lem:rectangles` | Rectangular occurrence and transport, including \(F(d+6e_6)=F(d)\) |
| `M_CERT_COVER` | `certificates.tex`, `ver:certificates` | Exhaustive residue/mode classification leaves only \(t_2\le27\) |
| `M_BAND_FORMULA` | `band.tex`, `finalinteger`, Laurent window | Seven rational rows extract exactly \(720(Q-F)\) without clipping relevant terms |
| `M_CHART` | `reduction.tex`, `lem:chart`, `cor:module-generation`, `prop:large` | Independent bound \(b\ge a(a-1)^2\), combined with retained finite verification through 149 |

`M_FINITE` and `M_BAND` record the manuscript's execution assertions
separately from these mathematical formulas. The square-bound theorem
does not depend on either execution assertion, the chart route, or
the finite source/target recurrences.

### Replaying the certificate

From the campaign root:

```sh
python3 -B research/square_stabilization/verify.py
```

The measured exact replay checks 516 monomials with a spectator variable,
three commutators and four power identities per monomial, 18 determinant
power images, 13 joint-operator ranks, and 11 canonically normalized
maps. It includes a genuine half-coefficient normalization check, not
just a test of rank. The source-bound formal certificate has compiler
and axiom-audit exit code zero, with no proof holes.

To obtain a fresh official compiler verdict, rather than only checking
the archived verdict's binding to the present source:

```sh
$WORKSPACE/argus-live-update/.venv/bin/python -m argus_skill.verticals.math.lean_evidence verify research/square_stabilization/Main.lean --statement-fidelity research/square_stabilization/statement_fidelity.md --claim C_POWER --project-root .
```

The native certificate is
`research/square_stabilization/certificates/C_POWER-8a8a3aff2ac03190.json`.
Its derived ledger status is `closed_kernel`; that status does not
certify the separate statement-fidelity reading or the whole canonical
surjectivity theorem. The graph deliberately leaves independent-review
flags false pending Host review.
