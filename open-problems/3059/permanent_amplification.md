# Repeated-column permanent rank and the F5 coefficient bridge

This note proves ANAMP3059, AMP3059 and PGC3059 directly. No statement
from Yu's inaccessible original article is assumed. The amplification
is used as a reconstruction of the required bridge, not claimed as a
new theorem. The completed independent project review accepted all
three arguments. Final campaign submission certification remains a
separate Host-invoked Reviewer decision; no formal kernel verification
is claimed.

## 1. A linear-annihilator bound (ANAMP3059)

Let F be any field, let m >= 1, and work in the graded algebra

    R = F[z_1,...,z_m]/(z_1^2,...,z_m^2).

For S contained in [m], write z_S = product_(i in S) z_i. These
squarefree monomials form an F-basis of R. Let g be a nonzero homogeneous
element of degree d, and choose a d-element set S with coefficient
g_S != 0. Define

    Ann_1(g) = {l in R_1 : l*g = 0}.

**Lemma.** dim_F Ann_1(g) <= d.

**Proof.** Write l = sum_i b_i z_i. For i outside S the coefficient of
z_(S union {i}) in l*g is

    b_i g_S + sum_(j in S) b_j g_((S minus {j}) union {i}).

Consequently, for an annihilator l, all b_i outside S are uniquely
determined by the b_j on S. The restriction map
Ann_1(g) -> F^S is therefore injective, proving the bound. This also
covers d=0 and d=m. No division by an integer or characteristic
restriction is involved. QED.

## 2. Amplification by one further copy (AMP3059)

Let A be an invertible m by m matrix over F. Its j-th column defines

    l_j = sum_(i=1)^m A_ij z_i in R_1.

The l_j form a basis of R_1. Let A^[k] be k horizontal copies of A;
put r_k = perrank(A^[k]) for k >= 1 and r_0=0. Permanent rank means
the largest order of a square submatrix having nonzero permanent.

For a multiset of columns with multiplicities alpha_j, the coefficient
of z_S in product_j l_j^alpha_j, where |S|=sum_j alpha_j, is exactly
the permanent of those columns restricted to rows S. The copies are
labelled in the product expansion, just as columns are labelled in
the permanent. This identity does not divide by multiplicity factorials.
Thus r_k is the largest degree of a nonzero such product with
0 <= alpha_j <= k.

**Theorem.** For every integer k >= 0,

    r_(k+1) >= ceil((m+r_k)/2).

**Proof.** Choose a nonzero product

    f = product_j l_j^alpha_j,    sum_j alpha_j = r_k,
    0 <= alpha_j <= k.

For k=0 use f=1. Among subsets J of [m] for which

    g = f product_(j in J) l_j

is nonzero, choose one of maximum cardinality t. The empty subset
is allowed, so a choice exists. Put d=r_k+t. For every j not in J,
maximality gives l_j*g=0. These m-t linear forms are independent,
because they are a subset of the column basis. Section 1 gives

    m-t <= dim_F Ann_1(g) <= d = r_k+t.

On the other hand, g uses each l_j at most k+1 times, so its nonzero
degree d is at most r_(k+1). Hence

    m+r_k <= 2(r_k+t) = 2d <= 2r_(k+1),

as required. QED.

Notice that J adds at most one copy of each original column; it is
not an unrestricted extension of a permanent minor. This is what
places g inside A^[k+1]. The argument works in every characteristic.
In particular k=0 recovers r_1 >= ceil(m/2).

For the precise cases needed here the integer bounds are:

| m | Assumption | r_2 at least | r_3 at least |
|---|------------|--------------|--------------|
| 8 | r_1 >= 5 | ceil(13/2)=7 | ceil(15/2)=8 |
| 9 | r_1 >= 6 | ceil(15/2)=8 | ceil(17/2)=9 |

Since permanent rank is at most the number of rows, r_3=m in both
cases. For m=9 and r_1=5 the same argument gives only r_2>=7 and
r_3>=8; the reviewed sparsity theorem is genuinely needed for the
remaining branch.

## 3. From three copies to a torus point (PGC3059)

Now let F=F5 and let A be any m by m matrix, not necessarily
invertible. Suppose r_3=m. Select m columns from A^[3] whose full
m-row permanent is nonzero, and call the resulting matrix B.
Let alpha_j count the selected copies of column j of A. Then

    0 <= alpha_j <= 3,    sum_j alpha_j=m.

In the ordinary polynomial ring put

    P_A(X) = product_(i=1)^m (sum_(j=1)^m A_ij X_j).

Expanding by assignments of rows to column types gives the identity

    per(B) = (product_j alpha_j!) [X^alpha] P_A.

Indeed, after a row-to-type assignment has been chosen, its alpha_j
rows can be bijected to the alpha_j labelled copies of type j in
alpha_j! ways, independently for each j. This proves both the
orientation of the identity and the multiplicity factor.

In F5 the four possible factorials 0!,1!,2!,3! are respectively
1,1,2,1. They are all nonzero. Thus c=[X^alpha]P_A is nonzero.

Reduce P_A modulo (X_1^4-1,...,X_m^4-1), obtaining a polynomial Q
of degree at most three in each variable. The coefficient of X^alpha
in Q is still c. To see this without an unjustified no-cancellation
assumption, any original monomial reducing to X^alpha must have
exponent alpha_j+4h_j in variable j, with h_j>=0. Every monomial
of P_A has total degree m=sum_j alpha_j, so sum_j h_j=0. Only
X^alpha itself can contribute.

Finally a polynomial with degree at most three in each variable
which vanishes on (F5*)^m is zero. Fix all but one variable and use
the four-root bound; its coefficients vanish on the smaller grid,
and induction finishes the proof. Q is nonzero, so Q(x)=P_A(x)!=0
at some x in that torus. Every row factor is then nonzero. This
proves PGC3059. No outside Nullstellensatz theorem is needed.

## 4. Exact illustration, not a universal computational proof

Let C=[[1,1,1],[1,2,1],[1,1,0]] and A=diag(C,C,C). Selecting three
copies of the first column of each block gives B=diag(J_3,J_3,J_3),
where J_3 is the all-one matrix. Here

    alpha=(3,0,0,3,0,0,3,0,0),
    per(B)=(3!)^3=216,
    product_j alpha_j!=216,
    [X^alpha]P_A=1.

The Argus-isolated Jacobian operation `matrix.permanent.compute`
returned the exact rational 216/1 for B, in 32 ms. Its domain is QQ;
the F5 value is obtained by reducing the integer permanent polynomial,
not by pretending that the operation was a finite-field computation.
The reduced permanent and factorial factor both equal one.

The discovery, inspected typed contract, exact payload and complete
typed response are preserved in
`jacobian_amplification_discovery.json`,
`jacobian_amplification_permanent_contract.json`,
`jacobian_amplification_permanent_payload.json` and
`jacobian_amplification_permanent_result.json`.
Server version 0.14.0; protocol 2025-11-25; adapter exit status 0;
complete output; no timeout or structured error.

`test_permanent_amplification.py` independently checks the algebra
and coefficient identities on explicitly bounded domains and the
eight/nine-dimensional block illustrations. Those tests are regression
checks, not coverage of GL_8(F5) or GL_9(F5). The universal proofs
are Sections 1--3.
