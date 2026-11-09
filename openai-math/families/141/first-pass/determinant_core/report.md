# Specialization-safe multiplication determinants

## Exact question and source premises

This audit concerns `prop:char-coeff` and its use in
`prop:multiplication-determinant` in the staged October 4, 2026 manuscript,
`build/sections/03-algebra.tex`. It does not by itself establish or refute
`thm:main`. The research target remains publishable and exploratory.

The coefficient ring is an arbitrary commutative ring with identity. The
relations are

```
f_i = x_i^ell - r_i,  deg_x(r_i) < ell,
n >= 1, ell >= 2, D = ell^n, tau = (ell-1,...,ell-1).
```

The residue functional is the formal coefficient of
`x_1^-1 ... x_n^-1` in `v / (f_1 ... f_n)`, expanded by decreasing total
degree. Its finite coefficient formula is

```
L(v) = sum_{j >= 0} [x^(tau+ell*j)] v * product_i r_i^j_i.
```

The source proves the monomial basis, then proves `tr(M_v) = L(vJ)` by
polynomial divided differences and a reproducing Bezoutian. Neither
statement assumes reducedness, distinct roots, or a field.

For characteristic coefficients the source assumes `deg_x(v) <= Omega`,
sets `L0 = D*Omega + n*(ell-1)`, and requires prime

```
p > n*(ell-1) + ell*L0 + D^2 + 10.
```

The evaluators of `v`, the indexed `r_i`, and `J` are uniformly in `F_a`.
The conclusion is every coefficient of `det(yI-M_v)` in `F_(a+8)`,
including indices 0 and D. The proof uses

```
t_k = sum_{|j|<=L0} [x^(tau+ell*j)] v^k*J*product_i r_i^j_i,
E(z) = sum_{h=0}^D (-sum_{k=1}^D t_k*z^k/k)^h/h!,
[y^d]det(yI-M_v) = [z^(D-d)]E(z).
```

The two degree requirements for multiplicative-grid extraction are
separate: every numerator exponent and every target exponent must lie
between 0 and `p-2`. The stated prime bound also exceeds `D^2+1`, so
the extraction from the *whole*, untruncated polynomial E is valid.

The multiplication-determinant proposition has parameter variables t.
With common total-degree and log-norm bounds d,b and
`T = d+n*(ell-1)`, its asserted bounds are

```
d_Q = D*(1+d*(1+T)),
b_Q = D^2 + D*(1+b*(1+T)).
```

These are bounds before specialization. Integer lifts of evaluation
points are not allowed to redefine the family cutoff.

## Computational premises already read

The following locally staged propositions from `02-counting.tex` are the
only computational primitives used at scope:

* `lem:counting`: a sum over one polynomial-bit tuple of `F_a` values
  costs one level, including modular sums and restricted domains.
* `lem:field-product`: a product over one polynomial-bit index of `F_a`
  field values is in `F_(a+4)`; in particular, factorial residues are in
  `F_4`.
* `lem:field-coefficient`: for degree and target exponents below `p-1`,
  multiplicative-grid averaging extracts a coefficient.
* `prop:controlled-closure`: indexed differentiation has fixed-depth
  evaluators with short, family-only cutoffs.

These source statements are premises to be audited, not independent
certificates. No external trace-residue theorem is assumed. The inherited
Wiki index contains no entry on this manuscript, pure-power quotient
residues, or this reconstruction; unrelated determinant and trace entries
are not used. No prior certified determinant-core result was present.

## 1. Unbounded theorem and certification scope

**Theorem.** Under exactly the hypotheses and prime range of
`prop:char-coeff`, every requested characteristic coefficient is evaluable
in

\[
                 \mathcal F_{\max(a+2,5)}\subseteq\mathcal F_{a+8}.
\]

No squarefreeness, generic-parameter, or simple-root condition is required.
`prop:multiplication-determinant` also holds with its stated
prespecialization bounds. More specifically, if all its input evaluators
are in a common \(\mathcal F_a\), its characteristic polynomial has an
evaluator in \(\mathcal F_{\max(a+3,5)}\), with a cutoff computed from the
primary family data only.

This is an unbounded mathematical theorem. The proof follows below.
`Main.lean` formalizes the arbitrary-ring normalized-Bezoutian-to-trace
bridge, the full matrix Newton/truncated-exponential bridge, and their
composition. It does not define the actual multivariate Laurent
functional or formalize complexity machines. Sections 2-3 discharge the
structural hypotheses of the formal residue bridge for the actual
functional; Sections 5-8 prove the remaining arithmetic, uniformity,
size, and specialization assertions. The exact division of labor is
fixed in `statement_fidelity.md`. A kernel verdict on the bridge must not
be presented as a kernel verdict on the entire complexity theorem.

The strengthened levels improve the explicit bookkeeping in the staged
proposition. They are **not claimed to be optimal or independently
verified new in the literature**. In particular, classical residue and
Newton identities are not new mathematics. The mission supplies a
verified local dependency, not a proof of the main two-block theorem or
an independently assessed publishable campaign breakthrough.

## 2. The actual residue and basis over an arbitrary ring

Write \(s=n(\ell-1)\). Work first over an arbitrary commutative ring S.
Formal Laurent sums with total degree bounded above and finite support
in each total degree form a ring: the bounds above leave finitely many
degree pairs contributing to each requested degree. Each
\(r_i x_i^{-\ell}\) has strictly negative total degree, so its geometric
expansion exists in this ring without division in S.

Multiplying the defining Laurent expression by \(f_i\) cancels the ith
geometric factor. In the remaining expression the exponent of \(x_i\)
is nonnegative: all denominators involve the other variables, and every
numerator is a polynomial. Therefore \(L(uf_i)=0\), for every polynomial
u. The functional descends to the quotient.

Expanding the geometric factors gives the displayed finite coefficient
sum. A term with index j has target degree \(s+\ell|j|\), whereas its
numerator has degree at most \(\deg u+(\ell-1)|j|\). Hence a nonzero
term satisfies

\[
                    |j|\le \deg u-s.                 \tag{1}
\]

In particular \(L(u)=[x^\tau]u\) when \(\deg u\le s\).
This argument includes zero polynomials: all their coefficients vanish,
so no degree convention for zero is needed.

Replacing an offending \(x_i^\ell\) by \(r_i\) decreases total x-degree
on every resulting monomial. Induction therefore proves spanning by the
box monomials \(x^\alpha\), \(0\le\alpha_i<\ell\).
For independence consider the square pairing matrix

\[
 P_{\alpha\beta}=L(x^\alpha x^{\tau-\beta}).
\]

If \(|\alpha|<|\beta|\), (1) gives zero. If their total degrees are
equal, the low-degree formula gives the Kronecker delta. Ordering by
total degree makes P triangular in blocks with identity diagonal.
Its determinant is 1; the adjugate therefore gives its inverse over
every S, including rings with torsion and zero divisors. Pairing any
linear relation with all \(x^{\tau-\beta}\) forces its coefficients to
vanish. This proves an S-basis, not merely a spanning set or a generic
basis.

All reduction, pairing, and residue expressions use finitely many ring
operations for each polynomial. They commute with every coefficient-ring
homomorphism. In particular no flatness hypothesis is being suppressed:
the exhibited quotient is free before and after base change.

## 3. From an actual Bezoutian to traces

For a monomial, changing one variable at a time gives divided differences
using

\[
 (X^m-Y^m)/(X-Y)=\sum_{q=0}^{m-1}X^{m-1-q}Y^q;
\]

this is a polynomial identity, including in positive characteristic.
Apply it term by term to obtain

\[
 f_i(x)-f_i(x')=\sum_j W_{ij}(x,x')(x_j-x'_j).
\]

Each entry has combined degree at most \(\ell-1\).
The degree-\((\ell-1)\) part is diagonal, with entries
\(\sum_{q=0}^{\ell-1}x_i^{\ell-1-q}(x'_i)^q\);
all contributions from the lower-degree \(r_i\) have combined degree
at most \(\ell-2\). Put \(W=\det(W_{ij})\).

In \(A\otimes_S A\), all the left sides vanish. Multiplication by the
adjugate, which is an identity over every commutative ring, gives

\[
                  (x_j-x'_j)W=0.                     \tag{2}
\]

Applying L in the second factor to W gives 1. Indeed
\(\deg_{x'} W\le s\), so Section 2 identifies this with
\([(x')^\tau]W\). That target exhausts the combined-degree bound s:
only the top diagonal entries can contribute, and each must contribute
\((x'_i)^{\ell-1}\). The result is the constant polynomial 1, with no
positive first-variable degree.

Expand W in the first factor's *proved* basis,

\[
                W=\sum_\alpha b_\alpha\otimes w_\alpha,
       \qquad b_\alpha=x^\alpha.
\]

Tensoring a free basis gives unique coefficients over S, so no
separability or hidden independence assumption is needed. The
normalization just proved becomes
\(\sum_\alpha L(w_\alpha)b_\alpha=1\).
Let \(g_j\) be the class of \(x_j\); these elements generate A as an
S-algebra. Taking first-basis coordinates of (2) gives, for every
generator and basis index,

\[
 g_jw_\alpha
 =\sum_\beta
    \operatorname{coord}_\alpha(g_jb_\beta)w_\beta.     \tag{3}
\]

These are exactly `hgen`, `hnorm`, and `hdiag` in
`ResidueBridge.residue_trace`, not an assumed trace identity.

For completeness, its universal proof is short. Define
\(T(u)=\sum_\alpha L(w_\alpha u)b_\alpha\).
Equation (3), linearity, and the basis expansion show
\(T(g_j u)=g_jT(u)\). The set of elements a for which
\(T(au)=aT(u)\) for every u contains the scalars and generators and is
closed under addition and multiplication. It is therefore all of A.
As \(T(1)=1\), this proves \(T(u)=u\). Consequently
\(\operatorname{coord}_\alpha(u)=L(w_\alpha u)\), and

\[
 \operatorname{tr}(M_v)
  =\sum_\alpha L(w_\alpha v b_\alpha)
  =L\left(v\sum_\alpha b_\alpha w_\alpha\right).
\]

The last sum is the image of W under multiplication
\(A\otimes A\longrightarrow A\). On the diagonal, the displayed
monomial divided difference becomes \(mX^{m-1}\); hence
\(W_{ij}(x,x)=\partial_j f_i(x)\) and the image is exactly J.
This proves \(\operatorname{tr}(M_v)=L(vJ)\) over every S and for
every v, without any root-counting theorem. Multiplication is an algebra
homomorphism, so also
\(\operatorname{tr}(M_v^k)=L(v^kJ)\) for all k.
Every step commutes with coefficient-ring homomorphisms.

## 4. Universal characteristic reconstruction, independently of spectra

The following argument is also proved in `Main.lean`. For any square
matrix A over a commutative ring set \(q(z)=\det(I-zA)\) and
\(B(z)=\operatorname{adj}(I-zA)\). Differentiating the determinant's
permutation expansion gives

\[
             q'(z)=-\operatorname{tr}(B(z)A).
\]

This uses the product rule and Cramer's rule, not diagonalization.
The identity \(B(z)(I-zA)=q(z)I\) gives
\(B_0=I\) and \(B_k=B_{k-1}A+q_kI\), whence
\(B_k=\sum_{i=0}^k q_iA^{k-i}\). Comparing derivative coefficients gives

\[
  (k+1)q_{k+1}
     =-\sum_{i=0}^k q_i\operatorname{tr}(A^{k+1-i}).   \tag{4}
\]

Equation (4) is valid over every commutative ring; no division has
occurred. Now work in a field in which 1,...,D are nonzero and put
\(H=-\sum_{k=1}^D t_k z^k/k\),
\(E=\sum_{j=0}^D H^j/j!\), with the *actual* power traces \(t_k\).
Every factorial denominator is invertible. Differentiating the finite
sum shows \(E'-EH'\) is a scalar multiple of \(H^DH'\).
Since H has zero constant coefficient, this difference has no
coefficient of degree less than D. Thus E satisfies (4) through the
coefficient of degree D. Both constant coefficients are 1.
Induction, canceling the nonzero integers 1,...,D, proves

\[
                  E\equiv q\pmod {z^{D+1}}.           \tag{5}
\]

The induction is universal in the dimension, not a finite experiment.
In characteristic p>D the denominator condition follows from
\(p\nmid k\) for \(1\le k\le D\).
Finally
\(\det(yI-A)=y^D q(y^{-1})\) as a Laurent-polynomial identity.
Its coefficient formula includes d=0 and d=D:
\([y^d]\det(yI-A)=[z^{D-d}]E\).

## 5. The exact prime range and residue grids

For \(1\le k\le D\), the numerator \(v^kJ\) has x-degree at most
\(k\Omega+s\le L_0\). Equation (1) actually permits
\(|j|\le k\Omega\); the larger retained range \(|j|\le L_0\) used by
the source is therefore safe. For every retained index, even those
whose coefficient is automatically zero, the numerator has degree
at most \(\ell L_0\) and the target has total degree at most
\(s+\ell L_0\). These bounds hold after every parameter specialization,
including degree drops.

For a polynomial P with each monomial exponent less than p-1 and a
nonnegative target with each exponent less than p-1,

\[
 [x^\beta]P=(p-1)^{-n}
   \sum_{u\in(\mathbb F_p^*)^n}P(u)u^{-\beta}.         \tag{6}
\]

To prove (6), expand P and sum each coordinate. The group sum of
\(u^e\) is zero unless \(p-1\mid e\), when it is p-1.
All exponent differences lie strictly between \(-(p-1)\) and p-1,
so only equality of exponents contributes. Both bounds are necessary;
neither is inferred merely from the other.

The source cutoff is the strict inequality
\(p>s+\ell L_0+D^2+10\). It implies all the exponent bounds just
listed, \(D^2<p-1\), and p>D. Since the *whole* E has degree at most
D squared, applying (6) to E, not to an unavailable truncation,
extracts every coefficient in (5) without aliasing. The additive
slack also makes the least admissible prime safe; no stronger prime
hypothesis is introduced.

## 6. Uniformity and flattened hierarchy depth

Use the computational primitives in the scope, whose proofs are
recalled in Section 9. All degree and cutoff metadata are computed
from the primary word. The binary length of D is at most
\(1+n\lceil\log_2\ell\rceil\); the binary length of \(L_0\) is
bounded by the sum of this, the length of Omega, and polynomial
overheads. Arithmetic on these metadata has polynomial bit cost.

For comparison, the unflattened source proof already gives
\(\mathcal F_{\max(a+5,6)}\), stronger than its advertised
\(\mathcal F_{a+8}\). The improvement below is relative to that
stronger immediate bookkeeping bound as well: it removes two inner
counting stages and one outer stage, subject to the factorial floor.
It does not replace the source's product primitive by a stronger
external arithmetic theorem.

For a fixed field element z, substitute the residue grid (6) directly
into
\(H(z)=-\sum_{k=1}^D t_kz^k/k\).
This is **one** modular sum over the tuple (k,j,u).
The total tuple length is at most

\[
 \lceil\log_2(D+1)\rceil+
 n\lceil\log_2(L_0+1)\rceil+
 n\lceil\log_2p\rceil
\]

plus polynomial padding and delimiters. Range restrictions are
polynomial-time tests. A summand uses the input evaluators, at most
n ordinary modular powers for the \(r_i^{j_i}\), one for \(v^k\),
ordinary inverses, and arithmetic on short integers. It is in
\(\mathcal F_a\); its arguments have polynomial total length,
including all evaluation points and indices. The entire H(z) is
therefore in \(\mathcal F_{a+1}\).

For \(m=D-d\), the final answer is exactly

\[
 (p-1)^{-1}
 \sum_{\substack{z\in\mathbb F_p^*\\0\le h\le D}}
       (h!)^{-1}H(z)^h z^{-m}.                       \tag{7}
\]

Here h! is in \(\mathcal F_4\); both \(0!=1\) and \(H(z)^0=1\)
are included. The summand is in
\(\mathcal F_{\max(a+1,4)}\). Treat (z,h) as one tuple, not as two
nested counting stages. One application of summation yields
\(\mathcal F_{\max(a+1,4)+1}=\mathcal F_{\max(a+2,5)}\).
The number of coordinates in u or j changes the tuple length, never
the hierarchy depth.

Each evaluation procedure has a fixed machine and fixed oracle;
finite tagged unions combine the finitely many underlying oracle
languages. No oracle query includes an exponentially long coefficient
list, a multiplication matrix, or a full integer trace. Invalid
domains can be recognized by short comparisons and the source's
primality test in \(\mathcal F_1\); the final level is at least 5.
Additional allowed lower cutoffs are simply included in the initial
comparison. This proves the full uniform coefficient proposition.

## 7. Prespecialization bounds and a parameter-independent evaluator

Let d,b be the source's common total-degree and log-norm bounds and
\(T=d+n(\ell-1)\). Starting with \(v x^\alpha\), every branch of a
reduction has initial x-degree at most T. Each replacement strictly
decreases x-degree, so after at most T simultaneous rounds every
branch has terminated. A round increases parameter degree by at
most d and multiplies coefficient norm by at most \(2^b\).
Already terminated branches stay unchanged, which respects this
bound because \(2^b\ge1\). Summing branch norms is valid even when
terms cancel. Thus every multiplication-matrix entry has parameter
degree at most \(d(1+T)\) and norm at most \(2^{b(1+T)}\).

Every entry of \(yI-M_v\) has degree at most \(1+d(1+T)\) and norm
at most \(2^{1+b(1+T)}\). The determinant expansion has D! terms.
Since \(D!\le2^{D^2}\), this proves exactly

\[
 d_Q=D(1+d(1+T)),\qquad
 b_Q=D^2+D(1+b(1+T)).
\]

All these are short, primary-family-only bounds. The matrix is used
only in the proof, not constructed by the evaluator. Monicity follows
from the determinant over \(\mathbb Z[t]\).

A first partial derivative requires less than the general indexed
derivative primitive. Keeping all other variables fixed, a degree-d
polynomial P satisfies, when p>d+1,

\[
 P'(z)=(p-1)^{-1}
   \sum_{\substack{u\in\mathbb F_p^*\\1\le k\le d}}
             k z^{k-1}P(u)u^{-k}.                   \tag{8}
\]

This follows by (6) and termwise differentiation. At z=0 the term
with k=1 uses \(0^0=1\); no evaluation coordinate is inverted.
Equation (8) is one modular sum of \(\mathcal F_a\) terms, so every
first partial is in \(\mathcal F_{a+1}\). The n by n Jacobian
determinant has polynomial dimension and is evaluated by ordinary
field elimination using these entries. Its level is
\(\mathcal F_{a+1}\), not a new n-fold counting level.

Take Omega=d and the maximum of the finitely many input-family
cutoffs, d+1, and the exact characteristic cutoff. This number is
computed before a prime or parameter value is supplied. For each
evaluation point, specialize the parameters using their short
representatives. The input and derivative procedures never change
their family metadata to depend on those representatives.

Now H(z) is in \(\mathcal F_{a+2}\). For evaluation of Q at y, sum
(7) multiplied by \(y^d\), \(0\le d\le D\), using the *single* tuple
(d,z,h). Its summand is in \(\mathcal F_{\max(a+2,4)}\).
One modular sum gives \(\mathcal F_{\max(a+3,5)}\).
This includes y=0 and does not invert it.

## 8. Specialization and degeneration

The finite free monomial basis exists over \(\mathbb Z[t]\) and
over every coefficient-ring specialization. Reduction of a polynomial
is unique by independence, and its coefficients use ring operations
only; therefore its specialization is the reduction of the
specialized polynomial. Multiplication matrices, their determinants,
the residue functional on each input, the divided differences, and
the Jacobian commute with specialization. Determinants are polynomial
in matrix entries, so the characteristic polynomial commutes as well.

Reducing integer lifts of field parameters modulo p gives the same
matrix independently of the chosen lifts. Vanishing lower terms,
parameter collisions, and repeated zeros do not alter any hypothesis
or any cutoff. The residue trace identity remains valid in small
characteristic and over composite coefficient rings; only the
reconstruction and grids use the separately specified prime domain.

## 9. Proofs of the computational primitives used here

A predicate in \(\mathcal F_a\) is evaluated by a polynomial-time
machine with a fixed \(\mathcal C_a\) oracle. For b-bit indices and a
short threshold t, a PP machine uses one choice bit and b random
bits: one branch accepts when the predicate holds, the other on
exactly \(2^b-t\) strings. It has a strict majority exactly when the
count exceeds t. Binary search recovers the count in
\(\mathcal F_{a+1}\). A sum of s-bit nonnegative summands is the
count of pairs (i,j) with \(j<f(i)\), where j has s bits. The output
has at most b+s+1 bits; modular reduction is ordinary short arithmetic.
Tuple restrictions contribute zero. This also proves bounded
existential and universal tests.

For field products, primality is an \(\mathcal F_1\) divisor test.
The multiplicative group of a finite field is cyclic: if L is the
lcm of its element orders, for each prime-power divisor of L choose
an element having that full prime-power part and take the corresponding
power of that element. Multiplying the resulting commuting elements
of pairwise coprime orders produces an element of order L. The
polynomial root bound applied to \(X^L-1\) shows p-1<=L; since the
element lies in a group of size p-1, L<=p-1. Thus it is a generator.
The root bound itself follows inductively from division by \(X-a\)
over a field, so no classification theorem is needed.

Testing a candidate generator by all exponents 1,...,p-2 uses
\(\mathcal F_1\); interval existential search and binary search find
one in \(\mathcal F_2\). For nonzero \(\mathcal F_a\) factors,
interval search recovers their discrete logarithms in
\(\mathcal F_{\max(a,2)+1}\), since powering is polynomial time.
One sum gives their logarithm sum in
\(\mathcal F_{\max(a,2)+2}\subseteq\mathcal F_{a+4}\).
The sum has polynomial bit length because both the count of factors
and p are short. Reduce modulo p-1 and exponentiate. A zero factor
is detected by one bounded existential test and gives zero. In
particular factorials are in \(\mathcal F_4\).

Finite tagged unions of the fixed oracle languages remain at the
same level: induct on the level, select the tagged machine, and use
the tagged union of its finitely many lower-level oracles. Padding
equalizes random-bit bounds. Levels are increasing because the upper
PP machine can ignore its randomness. This justifies every maximum
and every adaptive ordinary computation used above.

## 10. Exact probes and literature boundary

`verify.py` independently constructs quotient multiplication matrices
by decreasing-degree reductions, computes traces by matrix powers,
and computes characteristic polynomials by fraction-free integer
determinants and interpolation, **not** by the trace reconstruction
being tested. It compares with finite residue sums and the entire
finite exponential. Every coefficient index, including both
endpoints, is checked at the least prime above the manuscript cutoff.
Full multiplicative trace grids are also checked in selected cases.
Integral trace identities are separately reduced modulo 2,3,4,6,8,9;
these are not claimed to test characteristic reconstruction outside
its domain.

The 16 exact probes include pure nilpotents, double and triple roots,
vanishing lower terms, constant objectives, coupled nonreduced
specializations, parameter collisions, and a rank-nine cubic example.
They pass. These finite computations detect implementation/sign
mistakes; they do not prove the unbounded theorem.

The Jacobian adapter was discovered and its exact typed contract was
inspected before custom computations. The bounded operation
`matrix.symbolic.characteristic_polynomial.compute` exactly verified
\(\det(yI-\begin{smallmatrix}0&-t^2\\1&2t\end{smallmatrix})=(y-t)^2\).
The exact payload, result, server version, protocol and complete
status are preserved in dedicated JSON files. This is a polynomial
family check, not a generic trace or complexity theorem.

A targeted literature lookup found the primary arXiv HTML document
`https://arxiv.org/html/2610.10514v1` (arXiv:2610.10514v1),
titled "Existential R contained in
CH", read on November 5, 2026. Sections 2.4-2.5 contain residue
traces, specialization to nonreduced fibers, and the finite
exponential reconstruction. Section 3.4 uses a different shared
homotopy/all-moduli interface. Section 4.2 explicitly merges Fourier
and derivative sums under additional represented-family hypotheses.
Thus neither the classical bridge nor flattening in general is
claimed novel. A search-generated assertion that Section 3.4 directly
gives a general \(\mathcal F_{a+3}\) oracle theorem was not adopted:
the inspected passage states a more specialized interface.
No theorem from that external draft is a premise of this proof.

## Present certification status

The mathematical proof is unbounded. The official Lean 4.31.0
invocation for `C_UNIVERSAL_BRIDGE` completed with exit code 0,
`proof_holes=[]`, and a successful axiom audit. It recorded mechanical
evidence in the campaign ledger and archived the source and fidelity
document under `certificates/`. The source and fidelity document have
not been changed since that run.

The 16 quotient probes and four first-derivative profiles pass.
Both official structural checks returned 0 for the exact root
`campaigns/9000141`, not
the shared batch root. Reproduce the complete replay from that root:

```
$WORKSPACE/argus-live-update/.venv/bin/python research/determinant_core/verify.py --write-certificate
```

`--finite-only` is explicitly a finite experiment and cannot overwrite
the unbounded certificate. `exact_certificate.json` records the real
compiler result, its limited formal scope, exact finite results and
campaign-local check statuses.

No false assertion in the staged determinant section has been
established, so no `F_` refutation claim is warranted. Independent
statement-fidelity review, the prose proof, novelty, significance, and
acceptance remain for the Host-invoked Reviewer; no confirming Reviewer
judgement or campaign-level publishable completion is claimed by the
Engineer.
