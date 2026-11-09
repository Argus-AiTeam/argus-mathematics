# The nine-fourths construction over arbitrary fields

## Scope and evidence standard

The question is whether the staged complex-field construction yields
`omega_F <= 9/4` for every field, including finite fields. The staged
nine-fourths manuscript itself states its theorem over the complex numbers;
extending it is not the same as finding an error in its stated theorem.

The proposed bridge is restriction descent along a finite extension, followed
by characteristic-safe Fourier separation and interpolation. A normalized
linear functional, not a normalized field trace, is required if arbitrary
finite extensions are allowed. The failure of a trace-based extension would
not by itself refute an assertion in the manuscript.

The public complex solution is reported as available, but availability is not
an independent compiler result. Neither originality of the all-field extension
nor publishable significance is established by absence of a search result.
The comparator all-field bound in the mission is `2.371054886006746`;
its exact hypotheses and source must be checked before using it as a theorem.

Finite computations in characteristics 2, 3, and 5 are diagnostics only.
A universal proof must keep every extension-degree and interpolation cost
visible until the relevant tensor-power limit has been taken.

## Result and attribution

**Theorem.** For every fixed field F and every real epsilon > 0, two
n-by-n matrices over F can be multiplied using
`O_(F,epsilon)(n^(9/4+epsilon))` exact scalar arithmetic operations.

The proof below extends the staged nine-fourths construction, rather than
transferring one fixed complex algorithm by reduction modulo primes. It
therefore has no exceptional characteristics. Its new ingredient relative
to that staged proof is the explicit field-descent/interpolation bridge;
the separation, profile, and growth argument are attributed to the staged
manuscript, not claimed as new here. The principal comparison is with the
staged every-fixed-field bound `2.371054886006746`, not the weaker trivial
cubic bound. Source-level comparison is in `sources.md`.

This is a complete mathematical proof using the known spectral duality
proposition cited in section 9. The formal certificate covers the
substantive coefficient-descent core and the separation weight identity,
not the entire exponent theorem. Independent review and any originality
or publishable-significance assessment remain pending.

## 1. A power-independent restriction-descent theorem

All tensors in this report are finite three-tensors. A restriction applies
one linear map on each leg. The integer r denotes a full direct sum of r
scalar tensors; `r A` denotes a full direct sum of r copies of A.

Let E/F be a finite extension of degree e, with F-basis
`b_1,...,b_e`. There is an F-linear functional `ell:E -> F` with
`ell(1)=1`: include 1 in an F-basis and take its coordinate functional.
Consequently `ell(c)=c` for `c in F`. This uses no separability.

Suppose the E-linear maps U,V,W restrict an F-defined tensor A to an
F-defined tensor B. Write the first two maps in that basis:

```
U = sum_s b_s U_s,          V = sum_t b_t V_t,
W_(s,t) = ell(b_s b_t W),   1 <= s,t <= e,
```

where U_s and V_t are F-valued coefficient matrices and ell is applied
entrywise in the definition of W_(s,t). At each target coordinate,
linearity and `ell(B)=B` give the universal identity

```
B = sum_(s,t) (U_s tensor V_t tensor W_(s,t))(A).             (1)
```

Each third-leg map depends only on the third-leg source and target
indices; it is not allowed to depend on either of the other source
indices. Thus every summand really is a restriction of the same A.
Apply its three maps to source copy (s,t) and identify the target spaces
on all legs. This is a restriction

```
e^2 A >=_F B.                                               (2)
```

The proof is the same for arbitrary dimensions. If the restriction is
between `A_E^tensor-j` and `B_E^tensor-j`, expand its maps in the SAME
basis of E/F, not in a tensor power of that basis. The cost remains
e^2. In particular,

```
R_F(B) <= e^2 R_E(B_E),
R_F(B^tensor-j) <= e^2 R_E(B_E^tensor-j).                     (3)
```

`Main.lean` formalizes the normalized functional, the universal product
expansion, and (1) with all three substitution matrices and all
coefficient sums quantified. It also checks the count e^2. The exact
formal coverage is specified in `statement_fidelity.md`.

The trace route is deliberately not used. For example, in characteristic
p the extension `F_p(s)[u]/(u^p-s)` has degree p: the s-adic valuation of
s is 1, so s is not a p-th power in `F_p(s)`. In its power basis,
multiplication by `u^i`, `0<i<p`, has zero diagonal, while multiplication
by 1 has trace p=0. Hence its field trace vanishes identically.
The constant-coordinate functional nevertheless has `ell(1)=1`.
This refutes a proposed trace-based extension, NOT a literal assertion
in the complex-only staged manuscript.

## 2. Interpolation over the original field

Suppose A,B are F-defined and, over a finite extension E/F of degree e,
a polynomial tensor

```
G(z) = B + z G_1 + ... + z^D G_D
```

is a restriction of A for each nonzero specialization of z. Integer
weights and a shift of the minimum total weight give exactly this form
for every degeneration used below. Individual substitution entries may
have negative powers; evaluation is only at nonzero points.

At power j the degree is at most jD. Put `r_j=jD+1`. If E is infinite,
interpolate at r_j distinct nonzero points of E and set `s_j=1`.
If E has q elements, take its extension of degree

```
s_j = ceil(log_q(jD+2)).
```

It has at least jD+2 elements and hence at least r_j nonzero points.
This extension exists: the roots of `X^(q^s)-X` in a splitting field
form a field, since the q^s-th power map respects addition and
multiplication; the derivative is -1, so there are q^s distinct roots.
They contain E, and the extension degree is s.

Lagrange interpolation expresses the constant coefficient
`B^tensor-j` as a linear combination of r_j specializations. Such a
combination is a restriction of their full direct sum, with each scalar
coefficient absorbed on one leg. Apply (2) over the resulting extension
of F of degree `e s_j`. The exact comparison over F is

```
r_j (e s_j)^2 A^tensor-j >=_F B^tensor-j.                    (4)
```

For every F-tensor character lambda this gives

```
lambda(B)^j <= (jD+1)(e s_j)^2 lambda(A)^j.                  (5)
```

Here a character is an additive, multiplicative, restriction-monotone
map into nonnegative reals, normalized at the scalar tensor. Nonzero
tensors have character value at least 1, by a nonzero coefficient
restriction.

At fixed e,D,
`s_j <= 1+log_2(jD+2)`. Therefore the logarithm of the prefactor in
(5), divided by j, tends to zero. Taking j-th roots gives
`lambda(B) <= lambda(A)` over F itself. This conclusion also holds
when the degeneration coefficients lie in a fixed finite extension.
Zero tensors cause no exception: a degeneration of zero is zero.

## 3. Convolution has the required asymptotic rank in every characteristic

For positive a,b set

```
C(a,b) = sum_(0<=i<a, 0<=j<b) x_i y_j z_(i+j),
S = a+b-1.
```

Choose a finite extension E/F with at least S elements, using F itself
if it is already large enough. Explicitly, if F is finite of size q,
one may take degree `e_0=max(1,ceil(log_q S))`; if F is infinite take
`e_0=1`. Evaluation at S distinct affine points
and polynomial interpolation give `R_E(C(a,b)_E) <= S`.
Use that same extension for every tensor power. Equation (3) yields

```
R_F(C(a,b)^tensor-j) <= e_0^2 S^j.
```

The output flattening has rank S over every F: each of its S rows
has nonempty support, and distinct rows have disjoint support. Tensor
powers have flattening rank S^j. Thus

```
asymptotic_R_F(C(a,b)) = S,      lambda_F(C(a,b)) <= S.        (6)
```

The same holds after any leg permutation. We do NOT assert the staged
complex exact-rank equality `R_F(C)=S` for small finite fields; only
(6) is needed. The interpolation extension degree may grow with a,b.
It is fixed during this tensor-power limit, which is taken separately
for each a,b before letting a tend to infinity.

## 4. Characteristic-safe separation

Let `A=sum_(h=1)^M A_h` have a common first leg and disjoint matched
second- and third-leg sectors, with no cross-sector terms.
If the characteristic is zero, choose L=5M. In characteristic p choose
L=5M unless p divides 5M, in which case choose L=5M+1. Then

```
3(M-1) < L <= 5M+1 <= 6M,        char(F) does not divide L.   (7)
```

The splitting field of `X^L-1` contains L distinct roots. Its roots form
a finite subgroup of the multiplicative group and that subgroup is
cyclic. For completeness, if m is the least common multiple of its
element orders, its abelian structure supplies an element of order m
by taking the maximal prime-power components. Every group element is
a root of `X^m-1`, so L<=m, while Lagrange gives m<=L. Thus m=L.
Choose a primitive root zeta and put `E=F(zeta)`. Its degree e is at
most L, since zeta satisfies a degree-L polynomial.

For the L source copies indexed by r, use the staged substitutions

```
x_a^(r)   -> sum_g zeta^(2rg) X_(a,g),
y_(h,b)^r -> sum_u zeta^(r(u-h)) Y_(h,b,u),
z_(h,c)^r -> L^(-1) sum_v zeta^(r(-v-h)) Z_(h,c,v).
```

The geometric sum is 1 exactly when
`u-v+2(g-h)=0 mod L`, and is zero otherwise. The integer inside
has absolute value at most `3(M-1)<L`, so surviving terms satisfy the
integer equality, not just a residue equality. Invertibility of L
is explicit here.

Assign integer weights `g^2`, `hu-h^2`, and `-hv` to these three
target variables. The universal polynomial identity is

```
[g^2+hu-h^2-hv] - (g-h)^2 = h[u-v+2(g-h)].                  (8)
```

Consequently every surviving term has total integer weight
`(g-h)^2 >= 0`, and weight zero means g=h and u=v. Notice that the
weights are integers used as powers of a parameter: they are NOT
compared in the field, so characteristic two does not identify a
nonzero weight with zero. The result is the F-defined tensor

```
D_M = direct_sum_h (A_h tensor B_X(M)),
B_X(M) = x sum_(u=1)^M y_u z_u.
```

The polynomial degree is at most `(M-1)^2`. Section 2, at this fixed M,
implies

```
L lambda(A) >= lambda(D_M)
            = M^(p_X) sum_h lambda(A_h).                    (9)
```

Here `lambda(B_X(m))=m^(p_X)` with `0<=p_X<=1`.
Indeed that value is a nondecreasing, positive, completely
multiplicative function of the positive integer m, bounded between 1
and m. Comparing powers of m with adjacent powers of 2 and taking
logarithms proves the asserted power law.

### The two limits, in their required order

For rational frequencies q_i and type length N, retain sector words
with Nq_i occurrences in `T^tensor-N`, where `T=sum_i T_i`. Their
number and individual character value are

```
M_N = N! / product_i (Nq_i)!,
K_N = product_i lambda(T_i)^(Nq_i).
```

At fixed N, L_N, the Fourier extension degree e_N, and
`D_N <= (M_N-1)^2` are fixed. The exact F-comparison at interpolation
power j uses at most

```
L_N^j (j D_N+1) (e_N s_(N,j))^2
```

copies of `A_N^tensor-j` to obtain `D_(M_N)^tensor-j`.
Taking j-th roots FIRST removes the extension and interpolation
prefactor. No estimate that is uniform in N is being assumed.
Only after that limit does (9), together with (7), give

```
6 lambda(T)^N >= M_N^(p_X) K_N.
```

Now let N tend to infinity through multiples of the denominator.
The multinomial entropy limit yields

```
lambda(T) >= exp(p_X H(q)) product_i lambda(T_i)^(q_i),       (10)
H(q) = -sum_i q_i log q_i.
```

This entropy limit follows, for example, by summing
`log n! = n log n - n + O(log(n+1))` for a fixed number of types;
the latter estimate follows by integral comparison for log.
Continuity gives arbitrary real frequencies, including zero entries.
Extension degrees exponential in N have therefore NOT been discarded
inside an N-th root. They were removed by the preceding j-limit.

## 5. A simultaneous determinant filtration over the integers

Let `V_e` be the binary forms of degree e in u,v, and let W have basis
s,w. For e>=1, put

```
S_i = u^(e-i) v^i s,        W_i = u^(e-i) v^i w,
Q_i = S_i       (0<=i<=e),  Q_(e+1) = W_e,
K_j = W_j-S_(j+1)          (0<=j<e).
```

The inverse basis formula is explicit:

```
S_i = Q_i,       W_j = Q_(j+1)+K_j (j<e),       W_e=Q_(e+1). (11)
```

Thus this change of basis is integral and unimodular; it requires no
division by e, by 2, or by the characteristic. Under diagonal
substitution `(s,w)=(u,v)`, the Q's map to the standard basis of
`V_(e+1)`, and K_j equals `(uw-vs)u^(e-1-j)v^j` and maps to zero.
This proves the determinant exact sequence over every field.

More importantly it gives ONE pair of bases for ALL multiplication
slices. At input degree e=b-1 and output degree E=e+a-1, multiplication
by `u^(a-1-i)v^i` satisfies

```
Q_j -> Q_(i+j)                         (j<=e),
K_j -> K_(i+j),
Q_(e+1) -> Q_(e+i+1)+K_(e+i)            (i<a-1),
Q_(e+1) -> Q_(E+1)                     (i=a-1).              (12)
```

The same formulas in both fixed bases hold simultaneously for every
first input, by linearity in its monomial coefficients. The slice
matrix has quotient/kernel blocks `[[M_plus,0],[*,M_minus]]`,
whose diagonal tensors are exactly `C(a,b+1)` and `C(a,b-1)`.
The source is `C(a,b) tensor B_X(2)`.

Give first-leg and quotient coordinates weight zero, input-kernel
coordinates weight -1, and output-DUAL kernel coordinates weight +1.
The only potentially negative block is identically zero for every
slice by (12). The lower-left block disappears and the two diagonal
blocks survive, sharing the first leg. This establishes the
degeneration over F itself, including characteristics 2, 3, and 5.

## 6. The middle sector and balanced profile

For each character lambda define its three dot-product exponents
`p_X,p_Y,p_Z`. The product of the three oriented dot products is
isomorphic, by reindexing, to the square matrix multiplication tensor
T_m. Thus

```
lambda(T_m) = m^(p_X+p_Y+p_Z) = m^(3t),  t=(p_X+p_Y+p_Z)/3.
```

The diagonal restriction `T_m >= m` implies `t>=1/3>0`.
For each of the six leg permutations pi let `lambda_pi` be the
permuted character. Each dot-product exponent occurs twice, so
`sum_pi p_X^(pi)=6t`. Define

```
P(a,b) = (product_pi lambda_pi(C(a,b)))^(1/(6t)).
```

Equation (6), the input swap, and `C(1,b)=B_X(b)` give

```
P(a,b)=P(b,a)>0,    P(1,b)=b,    P(a,b)<=(a+b-1)^(1/t).       (13)
```

Apply (10) to the two blocks from section 5, with the SAME probability
pair q for all six characters. Multiplication followed by the power
`1/(6t)` gives

```
2 P(a,b) >= exp(H(q)) P(a,b+1)^(q_+) P(a,b-1)^(q_-).
```

For positive A,B the maximum of the right-hand expression is A+B:
take `q=(A,B)/(A+B)` and use the weighted arithmetic-geometric mean
inequality for the upper bound. Hence

```
2 P(a,b) >= P(a,b+1)+P(a,b-1),        a>=1, b>=2.             (14)
```

Next set `B=3h+a-1` and partition the Y and Z indices of C(a,B):

| Sector | Y indices | Z indices |
|---|---|---|
| Left | 0,...,h-1 | 0,...,h+a-2 |
| Middle | h,...,2h+a-2 | h+a-1,...,2h+a-2 |
| Right | 2h+a-1,...,3h+a-2 | 2h+a-1,...,3h+2a-3 |

Assign weight +1 to middle Y, -1 to middle Z, and zero otherwise.
Left Y can only reach left Z; right Y can only reach right Z.
Thus no supported term has negative weight, and the zero-weight
part is exactly the three matched sectors.

Both outer sectors are C(a,h). The middle sector is exactly

```
sum_(u=0)^(a-1) sum_(r=0)^(h-1)
 x_(a-1-u) y_(h+u+r) z_(h+a-1+r).                           (15)
```

Its individual isomorphism with `C(a,h)` exchanges the second and
third legs AND reverses the first basis. This is not a different
first-leg map applied to each branch of the whole shared-leg tensor.
If sigma swaps legs two and three, the uniform instance of (10) is

```
lambda_pi(C(a,B)) >= 3^(p_X^(pi))
 lambda_pi(C(a,h))^(2/3) lambda_pi(C(a,h)^sigma)^(1/3).
```

Composition with sigma permutes ALL six factors. Their product
therefore gives

```
P(a,3h+a-1) >= 3 P(a,h).                                   (16)
```

All these substitutions have integral coefficients and characteristic-
independent support; the only Fourier field issue was already removed.

## 7. Universal diagonal growth

This section reproduces the staged discrete growth argument with all
indices and constants explicit. At fixed a, put
`Delta_(a,h)=P(a,h+1)-P(a,h)`, `D_a=P(a,a)`, and
`H_a=2D_a/(3a-1)`. Concavity (14) says the Delta's decrease in h.
Tripling with h=a gives

```
2D_a <= sum_(h=a)^(4a-2) Delta_(a,h)
     <= (3a-1) Delta_(a,a).
```

Hence `Delta_(a,a)>=H_a`. Symmetry and concavity imply, for a>=2,

```
D_a-D_(a-1)
 = Delta_(a-1,a-1)+Delta_(a,a-1) >= H_(a-1)+H_a.
```

Substitution and rearrangement give

```
(3a-3)H_a >= (3a-2)H_(a-1),
H_a >= product_(m=1)^(a-1) (1+1/(3m)),       H_1=1.
```

For every positive m,

```
(3m+1)^3 - 27m^3 - 27m^2 = 9m+1 > 0.
```

Thus `(1+1/(3m))^3 >= 1+1/m`. Multiplication telescopes to
`H_a^3>=a`. Since `(3a-1)/2>=a`, we obtain

```
P(a,a)=D_a >= a H_a >= a^(4/3).                             (17)
```

This is a universal proof, not an inference from the finite recurrence
diagnostics in `verify.py`.

## 8. Bounding every character

Equations (13) and (17) yield

```
a^(4/3) <= P(a,a) <= (2a-1)^(1/t).
```

Let a tend to infinity AFTER the fixed-(a,b) tensor-power limit in
section 3. Dividing logarithms by log a gives `4/3<=1/t`.
Consequently `t<=3/4` and

```
lambda_F(T_d) <= d^(9/4) for EVERY F-tensor character.        (18)
```

There is no uniformity requirement on the character, a Fourier
extension, or an interpolation extension as a varies; all field
extension factors were removed at fixed underlying tensors.

## 9. Spectral detection over F, not a larger field

The sole substantive external theorem used here is the general
spectral duality in Christandl--Vrana--Zuiddam,
*Universal points in the asymptotic spectrum of tensors*,
arXiv:1709.07851v3, section 1.2, Theorem 1.1 and Proposition 1.6.
The field in section 1.1 is explicitly arbitrary. Proposition 1.6
says that asymptotic rank is the maximum of character values on a
unital tensor semiring. The relevant passage, including its scope,
is in `spectral_excerpt.md`. This is a known result, not a new
existence theorem inferred from finite experiments.

Apply it to the full restriction semiring of finite three-tensors
over the ORIGINAL F. It is a unital semiring containing all diagonal
tensors; `R(A)>=A>=1` for nonzero A, and the diagonal order is the
usual integer order, as detected by flattening ranks. Thus the
required semiring and order hypotheses hold, independently of the
cardinality and characteristic of F.

To connect exactly to the staged detecting-character formulation, set

```
nu_F = inf_(n>=2) log_n R_F(T_n).
```

We have `2<=nu_F<=3` by flattening and the naive expansion.
For every d>=2,

```
asymptotic_R_F(T_d) = d^(nu_F).                             (19)
```

The lower bound follows because
`R_F(T_(d^j)) >= (d^j)^(nu_F)`. For the upper bound, given delta>0
choose a FIXED u>=2 with `R_F(T_u)<u^(nu_F+delta)`, and put
`ell_j=ceil(log_u(d^j))`. Padding and tensoring give

```
R_F(T_(d^j)) <= R_F(T_u)^(ell_j)
             <= (u d^j)^(nu_F+delta).
```

Take j-th roots, then delta down to zero. The asymptotic-rank limit
exists by submultiplicativity (equivalently, subadditivity of its
logarithm). This proves (19).

Spectral duality now supplies a character with value `d^(nu_F)`,
and therefore in particular one with value at least any integer
`0<=k<d^(nu_F)`. This is stronger than the staged detecting lemma,
with no appeal to complex-field tensor characters. Combining (18)
and (19) yields `nu_F<=9/4`.

Alternatively, the staged Appendix A's detecting-state proof is
field-independent: its finite-dimensional separation, additive
catalyst argument, and fixed-point construction use only the same
semiring/order facts. The argument above uses the explicitly cited
general duality to avoid silently importing a complex-only statement.

## 10. Exact arithmetic on the original field

Fix epsilon>0 and choose `0<delta<epsilon`. The infimum defining nu_F
supplies a fixed u>=2 and an EXACT F-coefficient rank decomposition
of T_u of length `r<u^(9/4+delta)`. There is no extension field left
in this statement.

Each bilinear identity remains valid on matrix blocks: expand its
left-input linear form times its right-input linear form in that
order. The coefficients lie in the center F, and the coefficient
identities are exactly those of T_u. Therefore for powers N of u,

```
S(N) <= r S(N/u) + C_(F,u,r) (N/u)^2.
```

Flattening gives `r>=u^2`. If `r>u^2`, summing the levels yields
`O(N^(log_u r))`; if `r=u^2`, it yields `O(N^2 log N)`.
Either is `O_(F,epsilon)(N^(9/4+epsilon))`. Pad general n to the
next power of u, increasing it by less than the fixed factor u.
This proves the theorem, in exact scalar arithmetic over F.

## 11. What the certificates do and do not establish

The universal proof is sections 1--10. Its mathematical delta from the
staged complex construction is the original-field descent and the
ordered-limit justification, not the finite test range.

`Main.lean` is the formal descent core; the official compiler record
must be read together with `statement_fidelity.md`. `verify.py` checks
exact symbolic identities, integral simultaneous slice matrices,
the middle-branch permutation, finite-extension Fourier projections,
and interpolation/reconstruction diagnostics in characteristics
2, 3, and 5. Those bounded calculations do not prove the real
limits or the spectral theorem. `exact_certificate.json` records
their exact scope rather than labeling them an all-dimension proof.

Jacobian discovery found that `finite_field.restrict_scalars.compute`
and `finite_field.linear_map.rank.compute` concern a directional
matrix action `B -> B^T b`, not the tensor restriction-descent
theorem. Their typed contracts are retained and are NOT used as
support for descent. A matching, bounded coefficientwise modular
polynomial operation is used only for the characteristic-three
instance of (8); the integral identity and Lean proof establish
its universal form.

The official Lean 4.31.0 verification of the final source returned
`exit_code=0`, `proof_holes=[]`, and `audit_exit_code=0`.
Its printed principal theorem axioms are only `propext`,
`Classical.choice`, and `Quot.sound`. The ledger derives
`closed_kernel` for `AF_DESCENT_CORE`; the broader theorem has NOT
been assigned that status. The source and fidelity text have not
been edited after this successful compilation.

The exact diagnostic certificate includes 63 finite-field Fourier sums,
294 sector quadruples, 75 simultaneous multiplication slices, 42
tripling parameter pairs, and 396 reconstructed convolution
coefficients. The formal theorem, rather than these finite ranges,
establishes the universal coefficient-descent identity.

To replay the exact certificate, using the existing SymPy dependency:

```bash
$WORKSPACE/argus-live-update/.venv/bin/python research/all_fields_nine_fourths/verify.py
```

This checks the stored genuine compiler record and the required
source/fidelity hashes; it does not pretend to run a new compiler.
For a fresh real compilation and ledger entry:

```bash
$WORKSPACE/argus-live-update/.venv/bin/python -m argus_skill.verticals.math.lean_evidence verify research/all_fields_nine_fourths/Main.lean --statement-fidelity research/all_fields_nine_fourths/statement_fidelity.md --claim AF_DESCENT_CORE --project-root . --artifact-dir research/all_fields_nine_fourths/lean_certificates --timeout 110 > research/all_fields_nine_fourths/lean_result.json
```

No literal false assertion in the staged manuscript has been
identified in this route. In particular, its complex exact-rank
interpolation and choice L=5M are valid in their stated setting.
Changing those ingredients in an all-field extension is not a
refutation of that manuscript.

Independent attribution of the cited propositions, reading of this
proof, statement-fidelity approval, and significance/novelty
assessment are reserved to the Host-invoked Reviewer. This report
does not manufacture any of those confirmations.
