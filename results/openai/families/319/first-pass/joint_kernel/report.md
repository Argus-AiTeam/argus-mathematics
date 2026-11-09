# Universal joint-kernel bound for the actual height-two chart

## Result and scope

Let the notation and the action be exactly those of Lemma `obs:growth`
in the staged September 26, 2026 manuscript. Put

```
F(A,B) = sigma(bar b_1)(A,B,0),    D = deg F.
```

The symbol hypothesis makes `F` nonzero. Its degree is its ordinary
homogeneous degree, since `A` and `B` both have weight one. If `D=0`,
the joint kernel is zero. Otherwise the following explicit estimate
proves the lemma, for every integer `n>=1` and fixed integer `L=L_0>=0`:

```
v(n)^3 <= D^3 p^6 (3n+4L),                                      (1)
```

where `v(n)` is the dimension asked for in the lemma. Thus one may take
`c_0 = D p^2 (3+4L)^(1/3)` even with `n^(1/3)` instead of
`(1+n)^(1/3)`.

This is a universal proof, not an extrapolation from ranks at finitely
many precisions. It is an independent verification of this lemma
relative to the explicit chart inputs below. It does not certify those
upstream geometric lemmas, the operator construction, dual detection,
the topological counterexample, or novelty. Independent Reviewer replay
is pending. The strongest previous project state was an undecomposed,
open campaign goal; there was no prior certified mathematical result.

## Exact source inputs

All paths in this section are relative to
`research/openai_manuscript/Counterexamples-to-the-Hahn-Wilson-conjecture-at-height-two-September-26-2026/build/sections/`.
The original staged sources are unchanged.

1. `geometry.tex`, `geom:thickened-charts`,
   `geom:group-filtration`, and `geom:skew-filtration`
   (source-mapped lines 421-459 and 586-675): `k=F_(p^2)`,
   `R=k[[x]]`, `K=k((x))`; `H` fixes `k` and acts faithfully on
   `R` by `h(x) in x+x^2R`; `Gamma_s=H(2s+1)` is normal open,
   `g_i^(p^s) in Gamma_s`, and
   `gr Omega=k[A,B,C]` for `Omega=k[[H]]`, with weights `1,1,3`.
   Operators in `Delta=R[[H]]` have coefficients on the left:
   `g c=g(c)g`. Reduction modulo `x` and taking an initial symbol
   are different operations.
2. `operator.tex`, definitions preceding `op:displacement` and the
   balanced construction preceding `op:divided-differences`
   (source-mapped lines 56-100 and 198-252): for `z_h=h(x)/x`,
   `H_l={h:ord_x(z_h-1)>=l}`, `N_l=[H:H_l]`,

   ```
   ord_x(z_h-z_h') >= l  iff  h H_l = h' H_l,
   b_i H_l = b_j H_l     iff  i = j modulo N_l,
   N_l -> infinity,
   r_m = sum_(l>=1) floor(m/N_l) <= kappa m,
   kappa = sum_(l>=1) 1/N_l <= p/(p-1) <= 2.
   ```

3. `operator.tex`, `op:displacement`:

   ```
   Gamma_s subset H_(p^s),    N_(p^s) >= p^(3(s-1))  (s>=1).
   ```

These are explicit upstream dependencies, not conclusions of the
replay script. They are ledger assumptions `A_HEIGHT_TWO_CHART`,
`A_ORBIT_COUNTS`, and `A_LEVEL_GROWTH`; their source assertions were
read through bounded source-extraction tasks, but their proofs have
not received independent Reviewer certification. They have no
versioned public identifier supplied in the staged sources, and are
recorded as local-source assumptions, not as registry-checked
literature theorems.

The local displacement proof bounds a nonzero digit at position `i`
by `r_i=sum_(j=1)^i p^floor(j/2)`. Between successive such bounds
it obtains `N_l>=p^(2i-floor(i/2))`. The sum of the resulting
reciprocals is `1+1/p+1/p^2+...=p/(p-1)`. It obtains the lower
index bound from `H_(p^s) subset H(2s-1)` and the group indices.
The other inclusion uses generation of `Gamma_s` by `p^s` powers
and `(g-1)^(p^s)=g^(p^s)-1` in characteristic `p`.

The argument below proves its own interpolation and integral-valued
polynomial statements. It therefore does not invoke Weierstrass
preparation, Bhargava's Theorem 24, or Amice's interpolation theorem.
Those literature references are not hidden assumptions of this proof.
The existing Wiki contained no entry matching this height-two,
Iwasawa, or semilinear joint-kernel problem.

## Proof

### 1. Quantitative separation of orbit functions

Choose any finite family `f_1,...,f_v` in the joint kernel,
independent modulo `x^nR`. Write

```
F_i(y)=y^L f_i(y) in k[[y]],    phi_i(h)=h(f_i).
```

We first prove the following separation statement. If `c_i in R`
and `min_i ord_x(c_i)=0`, set

```
F(y)=sum_i c_i F_i(y)=sum_(j>=0) a_j y^j,
Phi(h)=sum_i c_i phi_i(h).
```

Some residue of `c_i` is nonzero. Independence modulo `x^nR`
implies that `F(y) modulo x` has a nonzero coefficient at some
first index `d<n+L`. In particular `a_d` is a unit.

Put `z_j=z_(b_j)` for `0<=j<=d`. These are distinct. For each
`j`, balancedness gives

```
ord_x product_(0<=i<=d, i!=j)(z_j-z_i) <= r_d.                  (2)
```

Indeed at each congruence level at most `floor(d/N_l)` of the
other `d` indices are in the same residue class as `j`.

For distinct indeterminates `z_0,...,z_d`, the exact rational identity

```
sum_(j=0)^d 1 / ((1-z_j T) product_(i!=j)(z_j-z_i))
       = T^d / product_(j=0)^d (1-z_j T)                       (3)
```

follows by partial fractions. Its coefficient of `T^m` says that
the divided difference of `z^m` is zero for `m<d`, one for `m=d`,
and the complete homogeneous polynomial `h_(m-d)(z_0,...,z_d)`
for `m>d`. Substituting our orbit points and the convergent series
`F(xz)` gives

```
sum_(j=0)^d F(xz_j) / product_(i!=j)(z_j-z_i)
  = x^d [a_d + sum_(m>d) a_m x^(m-d) h_(m-d)(z_0,...,z_d)].
```

The expression in brackets is a unit: every term after `a_d`
belongs to `xR`. The sum therefore has valuation exactly `d`.
Since `F(xz_j)=(xz_j)^L Phi(b_j)`, (2) forces

```
min_(0<=j<=d) ord_x Phi(b_j) <= d+r_d-L <= 3d-L.               (4)
```

All series operations here converge `x`-adically; the denominators
are fixed nonzero elements, and the complete homogeneous
polynomials have integral values at the `z_j`. No preparation
theorem is needed.

Equation (4) first proves that the `phi_i` are independent over
`K`: a nonzero relation can be scaled to have integral coefficients
of minimum valuation zero and would contradict (4).

### 2. A full, saturated integral lattice

Let `W` be the `K`-span of the `phi_i`, and put

```
M = {Phi in W: Phi(h) in R for every h in H}.
```

For a nonzero `Phi=sum c_i phi_i in M`, let
`t=min_i ord_x c_i`. Normalize the coefficients by `x^(-t)`.
Equation (4) supplies an `h` with

```
ord_x Phi(h) <= t+3(n+L-1)-L.
```

Its left side is nonnegative. In particular every coefficient
satisfies

```
ord_x c_i >= -B,    B=3(n+L).                                (5)
```

The deliberately loose integer `B` avoids any rounding convention.
Conversely `x^L phi_i` is integral-valued. In the coefficient
coordinates `W=K^v` we consequently have

```
x^L R^v subset M subset x^(-B) R^v.
```

As a submodule of a finite free module over the discrete valuation
ring `R`, `M` is finite free, and these inclusions show that its
rank is `v`.

Reduction of values induces an injection

```
M/xM -> Functions(H,k).                                      (6)
```

This assertion uses the full integral-valued lattice, not the
possibly nonsaturated span of the original orbit functions.
If all the values of `Phi in M` lie in `xR`, then `x^(-1)Phi`
still belongs to `W` and is integral-valued, hence belongs to `M`.
Thus the kernel of reduction is exactly `xM`, proving (6).

### 3. Residues factor through a controlled finite quotient

For `Phi=sum c_i phi_i in M`, multiplication by
`z_h^L` does not change its residue, since `z_h=1 modulo x`.
Its resulting expression is

```
z_h^L Phi(h) = x^(-L) sum_i c_i F_i(x z_h).
```

By (5), truncating the right side at degree

```
J=B+L=3n+4L                                                 (7)
```

changes every value by an element of `xR`. It is therefore an
integral-valued polynomial in `z_h` of degree at most `J`.

Here is the required integral-valued polynomial basis, proved
directly. Set

```
P_m(z)=x^(-r_m) product_(i=0)^(m-1)(z-z_i),   0<=m<=J.
```

For every orbit point, at least `floor(m/N_l)` of the first `m`
factors vanish modulo `x^l`, so `P_m` is integral-valued.
At `z_m`, these counts are exactly `floor(m/N_l)`, making
`P_m(z_m)` a unit. Also `P_m(z_i)=0` for `i<m`.
Successive evaluation and subtraction now express any
integral-valued polynomial of degree at most `J` uniquely as an
`R`-linear combination of `P_0,...,P_J`. This is a finite
triangular argument.

Suppose `z` and `z'` are orbit points congruent modulo `x^l`,
where `N_l>J`. For `m<=J`, telescope the difference of the
products defining `P_m`. At a level `a<l`, the factors evaluated
at either point have the same matching pattern. Deleting the
single replaced factor loses at most one required match at that
level. At levels `a>=l`, no match is required because `N_a>m`.
The replaced factor contributes `z-z'`, of valuation at least
`l`. Thus each summand in the numerator difference has valuation
at least

```
r_m - sum_(1<=a<l) min(1,floor(m/N_a)) + l >= r_m+1.
```

Division by `x^r_m` proves `P_m(z)=P_m(z') modulo x`.
Consequently every residue in (6) is constant on `H_l` cosets.

Choose the least integer `s>=1` with

```
p^(3(s-1)) > J,
```

and put `t=p^s`. The source inputs give `N_(p^s)>J` and
`Gamma_s subset H_(p^s)`. Residues therefore factor through
`Q_s=H/Gamma_s`. Since `J>=3`, minimality gives `s>=2` and

```
t^3 = p^6 p^(3(s-2)) <= p^6 J.                              (8)
```

This argument treats every precision, including values on the
boundary of a `p^3` scale; it does not select a subsequence of `n`.

### 4. Both annihilator equations survive saturation and reduction

For an original orbit function and `mu=a_1` or `b_1`, applying
`h` to `mu(f_i)=0` gives

```
integral_(g in H) h(mu(g)) phi_i(hg) = 0.                     (9)
```

For any `Phi=sum c_i phi_i in W`, the same equation holds with
`Phi` in place of `phi_i`. The coefficients `c_i` are outside
the evaluation by `h`; the equation is `K`-linear in the
function `Phi`. It does NOT assert that `sum c_i f_i` is itself
killed by `mu`, nor move a Laurent coefficient through a
semilinear operator.

For `Phi in M`, all function values in (9) are integral.
Compute each integral first at finite coefficient and group
precision. Reduction is legitimate, and `h` acts trivially
on the residue field `k`. If `psi` is the reduction, (9)
becomes

```
integral_(g in H) bar mu(g) psi(hg) = 0  for every h in H.    (10)
```

Define `lambda_psi(delta_h)=psi(h)`. Under the ordinary
function/group-algebra pairing, (10) is exactly
`lambda_psi(delta_h bar mu)=0`. Thus `lambda_psi` annihilates
the LEFT ideals `Omega bar a_1` and `Omega bar b_1`. There is
no inversion and no right-ideal substitution. Since `psi`
factors through `Q_s`, it also annihilates the kernel of
`Omega -> k[Q_s]`.

Equations (6) and (10) yield

```
v <= dim_k Omega /
     (Omega bar a_1 + Omega bar b_1 + ker(Omega -> k[Q_s])).  (11)
```

All `v` reduced dimensions survive. This is where saturation is
essential.

### 5. The finite filtered quotient and its dimension

Let the quotient in (11) be `V_s`, with its induced weight
filtration. It is a quotient of the finite-dimensional algebra
`k[Q_s]`. Its filtration terminates: `Q_s` is a finite `p`-group,
its augmentation ideal is nilpotent, and large weight implies
large ordinary augmentation degree. Hence
`dim V_s=dim gr V_s`.

The initial ideal of the defining left ideal contains

```
C, sigma(bar b_1), A^t, B^t, C^t.
```

Here the first inclusion uses the EXACT hypothesis
`(sigma(bar a_1))=(C)`, not merely divisibility by `C`.
The powers come from
`(g_i-1)^t=g_i^t-1` and `g_i^t in Gamma_s`. The associated
graded algebra is commutative, so the associated graded of a
left ideal is an ordinary ideal. No assertion that the
unfiltered operators commute is used.

It follows that

```
dim V_s <= dim k[A,B]/(A^t,B^t,F(A,B)).
```

If `D=0`, this is zero. Otherwise choose a leading monomial
`A^u B^v` of `F` in any fixed monomial order. Its degree is
`u+v=D`. Polynomial division shows that monomials outside
`(A^t,B^t,A^u B^v)` span the quotient: reductions strictly
decrease that order. Their exact number is

```
q(t,u,v) = t^2 - max(t-u,0) max(t-v,0) <= (u+v)t = Dt.       (12)
```

If `u,v<t`, the inequality follows from
`q=(u+v)t-uv`; otherwise `q=t^2<=Dt`.
This includes constant symbols and exponents at least `t`.

Combining (7), (8), (11), and (12) proves (1) for every finite
independent family. The ambient image lies in the finite
dimensional space `x^(-L)R/x^nR`, so taking a basis proves
(1) for its dimension. This completes the proof.

## Exact replay and its boundary

Run `python3 research/joint_kernel/verify.py` from the campaign root
or run the script by absolute path from any directory. It compares
its freshly computed output with `exact_certificate.json` and checks
the saved typed Jacobian result.

The script checks exact rational interpolation identities (including
nonunit differences), balanced nested-congruence counts, a concrete
saturation calculation where naive reduction loses rank, oriented
left-translate equations in a noncommutative finite group, an exact
semilinear coefficient-movement example, finite
filtered-quotient examples, monomial counts, and scale boundaries.
All arithmetic is integral, rational, or modulo an explicitly named
prime; there are no floating-point tolerances. The finite examples
are labelled as finite examples. They do not prove a universal
statement about the height-two action.

The universal proof is the argument above, including the general
identities (3), (8), (12) and the saturation argument. Neither the
Python replay nor Jacobian is a proof-assistant verification of
this prose. The typed Jacobian operation checks only one declared
finite-field rank in (12), retains its exact input, and is not
passed off as an operation on the actual stabilizer. Its mismatch
with the infinite-action postcondition is explicit. No Lean file
or kernel-closure claim is made.

## What remains open

Independent review must read the universal proof, validate the
three chart-input assumptions against the staged source proofs,
and replay the script. `research/PROOF_GRAPH.json` retains the
upstream chart, displacement, operator, gluing, microlocal,
dual-ghost, finite-tower, and topological-transfer obligations.
Even acceptance of this lemma alone is not campaign completion
or a publishable-new result.
