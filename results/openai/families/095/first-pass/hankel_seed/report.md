# Exact audit of the Hankel seed

## Statement and scope

The target is Lemma "Seed matrix" (`lem:seed`, lines 52-71 of
`03-hankel.tex`) in *Hyperbolicity Cones Without Semidefinite Lifts*,
October 5, 2026, staged under `research/openai_manuscript/`.
Its assertion is the existence of a real positive semidefinite Hankel
form T on the 36-dimensional space of quadratics in eight variables,
of rank 20, with positive definite restriction to
L = span(x0^2, x0*x1, ..., x0*x7). For J = ker T,
K = proj_P J, and H0 = {p : T(p,L) = 0}, it requires:

- dim K = 16 and injectivity of Sym^2 K -> R[x1,...,x7]_4;
- K * span(x1,...,x7) = R[x1,...,x7]_3;
- dim(J * H0) = 321 in the 330-dimensional quartic space.

The primary source for the claimed certificate is
`build/source/appendix-certificate.tex` in that same staged preprint.
The appendix supplies weights (0,5,1,9,2,8,4,6) modulo 10,
the parameter (1,6,6,0,3,0,2,5) modulo 7, a 35-coordinate
weight-zero moment variation, pivot rules, minors in weights 0-5,
and a claimed characteristic-zero/real deformation argument.
All these are inputs to audit, not facts assumed proved.

Before computation, the following limits are fixed:

1. A nonzero minor modulo 7 certifies a characteristic-zero minor only
   after denominators and an exactly tangent characteristic-zero lift
   have been justified. A modular rank is not a real positive seed.
2. Weight reversal can prove that finitely many open conditions are
   individually nonempty; simultaneous real data additionally require
   an irreducibility and real-density argument.
3. Rank 302 at the orbit matrix is not rank 321 at the seed. The
   derivative rank must be connected to an actual rank-20 PSD arc.
4. The present verification cannot certify the full no-lift theorem.
   Uniform rank correction, finite inverse limits, separation, the
   polynomial epigraph, and the analytic lift obstruction remain
   distinct downstream obligations.
5. The companion nonspectrahedral cone and its claimed finite lift are
   not the high-dimensional no-lift construction audited here.
6. The staged source directory lists no `verify_certificate.py`.
   That source-availability observation is not a mathematical refutation.
7. Searching the supplied Wiki index for Hankel, semidefinite,
   hyperbolicity, finite-field, and implicit-function material found
   no relevant prior seed verification. No novelty conclusion follows.

The preceding source-status facts and limitations are entered in the
claim ledger before arithmetic. No external classification theorem is
used at this stage.

## Result and classification

**Exact verification theorem (Engineer proof; independent review pending).**
The certificate's literal finite-field assertions all hold. The explicit
rational tangent in `exact_certificate.json` is exactly tangent, not
merely tangent modulo 7. These data, together with the real-density
and local-deformation arguments below, prove the complete seed-existence
statement above.

This is a mathematical proof with an executable exact-arithmetic core,
not a finite search offered as an existence proof and not a Lean
formalization. The executable checks the arithmetic and rational lift;
the real-density and deformation proofs are separate mathematical
arguments requiring independent reading. No false assertion in the
audited lemma or appendix has been demonstrated, so no `F_` refutation
claim is warranted. No novelty or full-campaign completion is claimed.
The research target remains publishable; significance and independent
acceptance are not self-certified here.

Compared with the manuscript's displayed modular certificate, this
deliverable makes the characteristic-zero tangent explicit and checks
all ten weights at the same specialization, instead of relying on
weight reversal to establish the other four nonempty rank conditions.
It verifies, rather than strengthens, the asserted seed theorem.

## Exact reconstruction

`verify.py` uses only Python's standard library: integers modulo 7 and
`fractions.Fraction` in characteristic zero. It reconstructs quadratic
and quartic monomials from combinations with replacement, sorts them
lexicographically, and groups them by the stated weights. It evaluates
each weight-zero moment as 1 + product(a_j), and all other moments
as zero. No manuscript matrix or nullspace column is used as a computed
input: the displayed columns are comparison targets.

For each C_i = [1; u(a)] it solves the specified two pivot columns,
placing the identity on the free coordinates. It separately solves the
eight orthogonality equations defining H0. Kernel derivatives are solved
on the stated two pivot rows and H0 derivatives on the stated L row.
It checks the resulting equations against **all 36** quadratic rows
(and all eight L rows for H0), rather than checking only the equations
used to solve. It also checks the seventeen weight-zero tangency
equations. All other symmetric kernel products pair to zero because
the functional is supported in weight zero.

Polynomial products use ordinary coefficients, with no factor of two
for an unordered mixed product in Sym^2 J. G1 discards every quartic
containing x0; G2 retains exactly one x0. D and D1 are built from the
full products and their Leibniz derivatives. Every omission and
bordered corner is then reconstructed directly.

The computed determinant values, in weight order 0 through 5, are:

| Quantity | 0 | 1 | 2 | 3 | 4 | 5 |
|---|---:|---:|---:|---:|---:|---:|
| G1 minor | 3 | 4 | 4 | 5 | 6 | 5 |
| G2 minor | 6 | 6 | 2 | 6 | 6 | 4 |
| E minor | 6 | 1 | 6 | 3 | 5 | 3 |
| Z corner | 5 | 5 | 6 | 1 | 1 | 2 |

Every displayed corner **entry**, not just its determinant, agrees.
The determinant of T restricted to L is 6, and rank(T) is 20.
The two advertised signed-pivot sequences also agree. Negative pivot
representatives are compared as residues: for example -2 is 5 in F_7.
That is an ordering/representative convention, not an arithmetic error.

With the specified retained rows followed by the added rows, and
retained first-block columns followed by added first-block columns and
then retained second-block columns, the actual bordered determinant is

    (-1)^(size(E)*size(Z)) * det(E)^2 * det(Z).

The code checks this identity on the actual bordered submatrices.
Their determinants in weights 0-5 are (5,5,6,2,4,4).
This also checks the sign issue hidden by the source's "up to ordering
sign" qualification.

Full elimination in all ten weights gives:

| Matrix | 0 | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 | Total |
|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| G1 | 17 | 11 | 16 | 11 | 16 | 11 | 16 | 11 | 16 | 11 | 136 |
| G2 | 8 | 8 | 9 | 8 | 9 | 8 | 9 | 8 | 9 | 8 | 84 |
| D | 32 | 28 | 32 | 29 | 32 | 28 | 32 | 29 | 32 | 28 | 302 |
| [D,0;D1,D] | 65 | 58 | 66 | 60 | 66 | 58 | 66 | 60 | 66 | 58 | 623 |

These are exact finite-field ranks. In characteristic zero, reduction
initially proves the corresponding **lower bounds**, not upper bounds.
The upper bounds needed below are proved separately.

Jacobian 0.14.0, protocol 2025-11-25, was first discovered and inspected
through the authorized Argus adapter. The bounded operation
`prime_field.matrix.rank.compute` independently returned rank 8 for
the actual 8-by-8 L restriction. Its exact payload and typed output are
preserved in `jacobian_payload.json` and `jacobian_output.json`;
`jacobian_contract.json` records its inspected contract. The adapter
completed with exit code 0, without timeout or structured error.
This operation does not supply the Hankel construction or the
characteristic-zero/real proof. The full matrices require the separate
reconstruction just described.

## 1. An exactly tangent characteristic-zero lift

Lift a to the same integer vector, with a0 = 1. Every chosen C_i pivot,
N_i pivot, and two-by-two T pivot block is a unit modulo 7. The
corresponding rational bases therefore lie in Z_(7), where denominators
are prime to 7, and reduce to the finite-field bases.

Let Q be the 35-by-17 matrix of ordinary weight-zero products in
Sym^2 J. Select, in the **full weight-zero quartic list**, rows

    14,15,16,17,18,19,20,21,22,23,24,25,26,27,29,30,31.

These are precisely the retained rows of the source's weight-zero
pure-quartic G1 minor, converted back to the full quartic list.
The corresponding 17-by-17 matrix has rational determinant

    -512/961,

which is a unit of Z_(7) and reduces to 3. Thus Q has independent
columns. Keep the remaining eighteen moment coordinates equal to
their displayed integer representatives, and solve Q^T t = 0 for
the selected seventeen coordinates. The complete result is the
35-coordinate rational vector in `characteristic_zero_lift` in
`exact_certificate.json`; it is recomputed, not trusted, by the script.

For example, the coordinate at 1111 becomes -79555639/28512,
rather than simply keeping its modular representative 5. All
denominators are prime to 7. Uniqueness of the pivot solution over
Z_(7) implies that it reduces to the original tangent vector, and the
script checks this coordinate by coordinate. It verifies Q^T t = 0
over the rationals, every differentiated kernel/H0 equation over the
rationals, and reduction of **every entry** of J, N, J', N', G1, G2,
D, and D1 in all weights.

Consequently each modular nonzero minor is the reduction of a
characteristic-zero nonzero minor of the **same exactly tangent
data**. The all-weight elimination additionally gives simultaneous
lower bounds (136,84,302,623) at this one rational parameter/tangent.
There is no inference that an arbitrary integer lift of the tangent
would be tangent.

## 2. Simultaneous real data

Here is a complete arithmetic-to-real argument. Work over C and let
U be the set of parameters a in C^7 for which all C_i have rank two,
T|L is invertible, and the seventeen weight-zero products in Sym^2 J
are independent. These are intrinsic open rank conditions. The
previous paragraph gives a point of U, so U is a nonempty Zariski
open subset of the irreducible affine space C^7.

Above U, the kernel J is an algebraic vector bundle with fixed
weight-block dimensions. Restrict a quartic functional to weight
zero. The seventeen independent products impose seventeen
independent linear conditions on its 35 coordinates. The solutions
therefore form an algebraic vector bundle E of rank 18 over U.
To see this directly, on each nonzero 17-by-17 product minor one
solves for seventeen coordinates in terms of the other eighteen.
The total space E is irreducible: a bundle chart is a product of an
irreducible open base with C^18, and such charts overlap on dense
open sets.

Inside E, impose:

    rank(G1) = 136,  rank(G2) = 84,
    rank(D) >= 302, rank([D,0;D1,D]) >= 623.

These are open rank conditions, independent of local bases. Indeed,
changing derivatives of the chosen bases adds D times a column
matrix to D1, which a block row/column operation removes from the
bordered matrix. A constant change of quartic coordinates is also
invertible. By the exact lift in Section 1, all these conditions
hold at one point of E. Their intersection W is therefore a
nonempty Zariski open subset of E. This direct same-parameter
certificate makes weight reversal unnecessary for nonemptiness.

Now let tau be conjugation combined with the permutation
(2 3)(4 5)(6 7), fixing indices 0 and 1. It negates the weights
and preserves the orbit formula, U, and the weight-zero tangent
equations. Its fixed parameter set is

    a1 real,  a3 = conjugate(a2),
    a5 = conjugate(a4),  a7 = conjugate(a6).

This real form is Zariski dense in C^7: write each pair as
(u+iv,u-iv). The resulting coordinate change is complex invertible,
and a polynomial zero on all real coordinate vectors is zero,
by induction on the number of variables. It follows that its
intersection with U is dense in U.

At any fixed base parameter, the solution fiber E_a is stable under
the antilinear involution. Its fixed vectors complexify to the whole
fiber: v = (v+tau(v))/2 + i*(v-tau(v))/(2i). Thus that real vector
space is Zariski dense in E_a. The real fixed total space is
Zariski dense in E as well. To justify the last assertion without
assuming it, trivialize the bundle on an open chart. A regular
function vanishing at all real fixed vectors vanishes identically
on every fiber above a real fixed base point. All its polynomial
fiber coefficients then vanish on a dense set of base parameters,
so vanish identically. The same argument applies after clearing
the chart's denominators. A proper closed subset cannot contain
the real fixed total space.

Therefore W contains a real fixed parameter/tangent pair. This
uses a single point for **all** conditions, not different real
points for different minors.

In the corresponding real coordinates, all twenty cyclic orbit
points are real. The diagonal action respects each conjugate
pair, the weight-five coordinate changes by +/-1, and x0 stays 1.
The functional is the sum of their evaluations with positive
weights 1/10. Hence T(f,f) is a sum of positive multiples of real
squares: T is PSD. The C_i ranks imply rank(T)=20, since its
only weight-i block is C_(-i)^T C_i and each factor has rank two.
Its restriction to L is nonsingular and PSD, hence positive
definite.

For explicit ordinary real coordinates take
(x2+x3)/2, (x2-x3)/(2i), and likewise in the other two pairs,
keeping x0 and x1. This change preserves L and P separately and
commutes with projection to P. Multiplication and all total ranks
are preserved by the induced invertible coordinate changes.
The resulting data are therefore in precisely the real polynomial
spaces and projection convention of Lemma "Seed matrix".

## 3. The necessary upper bounds

For completeness these bounds are proved, not imported from the
source as assumptions. At any characteristic-zero rank-20 Hankel
form with J intersect L = 0, write its kernel in the affine chart
as

    f_p(s) = p(s) + b(p)(s) + a(p),   p in K.

Assume cubic spanning. A nonzero translation direction c cannot
annihilate all directional derivatives of p in K: after a linear
coordinate change these quadratics would omit one variable, and
their products with linear forms could not span that variable's
cube. If a=b=0, kernel annihilation and cubic spanning force every
moment of degrees three and four to vanish. In degree order
0,1,2, the first eight matrix rows then have rank at most eight
and the last twenty-eight rows have rank at most one. This would
give rank at most nine, a contradiction.

The infinitesimal translation c and dilation alpha act on the
kernel coefficients by

    delta b(p) = -partial_c p + alpha*b(p),
    delta a(p) = -b(p)(c) + 2*alpha*a(p).

If these vanish, alpha=0 implies c=0. If alpha is nonzero, put
d=c/alpha. Then b(p)=partial_d p and a(p)=p(d), so f_p(s)=p(s+d).
A translation would give a=b=0, the excluded case. Thus all eight
affine kernel variations are independent.

These affine motions preserve K. Continue each f_p with highest
part fixed; its derivative is in L. Differentiating T(t)f_p(t)=0
gives T'J contained in T(L), so the quartic functional T'
annihilates J H0. Scaling T supplies a ninth independent
annihilator: its kernel derivative is zero whereas the eight
affine kernel derivatives are independent. Since the quartic
space has dimension 330, this proves

    dim(J H0) <= 321.

At the orbit matrix, all twenty individual point evaluations
annihilate J H0. They are independent on quadratics, since T
has rank twenty and factors through their twenty-dimensional
evaluation space; hence they are also independent on quartics
by multiplication by x0^2. Varying their weights does not
change J, so the eight affine directions remain independent
modulo these twenty. Consequently

    dim(J H0) <= 302

at the orbit matrix. Combined with the certified lower bound,
its rank D is exactly 302 in characteristic zero. Neither
upper bound is inferred from a finite-field rank.

## 4. A real rank-20 PSD deformation

The injection of Sym^2 K implies injection of Sym^2 J by taking
highest pure-degree parts of a relation. Dualizing multiplication
therefore shows that the restriction map from the 330-dimensional
Hankel space to Sym(J) is onto.

Choose a twenty-dimensional complement to J on which T is positive
definite. In the corresponding fixed basis, nearby Hankel forms
have blocks [A,B;B^T,C]. Rank twenty is equivalent to

    F(Y) = C - B^T A^(-1) B = 0.

At T its derivative is restriction to J, and is onto the
136-dimensional symmetric matrix space. In particular T1 is in
its kernel by exact tangency. The local implicit step needed
here can be proved directly. Choose a 136-dimensional linear
space V of Hankel variations on which dF_T is an isomorphism,
and seek

    Y(t) = T + t*T1 + v(t),   v(t) in V.

Let A0 = dF_T|V. The map

    v -> v - A0^(-1) F(T+t*T1+v)

has derivative zero in v at (t,v)=(0,0). On a sufficiently
small neighborhood it is a contraction, say with constant 1/2.
Its value at v=0 is O(t^2), since F(T)=0 and dF_T(T1)=0.
For a fixed sufficiently large M it therefore maps the ball
||v|| <= M*t^2 to itself. Iterating from zero gives a Cauchy
sequence (successive differences decrease geometrically);
its limit is a solution v(t)=O(t^2). This proves the required
arc with Y(t)=T+t*T1+O(t^2) without treating an unproved
generic integrability assertion as evidence.

For small t the block A remains positive definite. The Schur
complement is zero, so Y(t) is congruent to diag(A,0), hence is
PSD of rank twenty. Its L restriction remains positive definite.
The two product conditions remain valid by their nonzero minors.
Kernel and H0 bases can be solved from invertible blocks; they
therefore have first-order expansions with the computed derivatives,
up to harmless basis changes. The contraction construction's
O(t^2) remainder is sufficient; a globally analytic arc is not
needed for the following rank argument.

Put D(0) into rank normal form [I_302,0;0,0] using fixed invertible
row and column operations. Write the transformed derivative as
[A1,B1;C1,F1]. Block elimination gives exactly

    rank([D(0),0;D'(0),D(0)]) = 604 + rank(F1).

The lifted lower bound 623 therefore gives rank(F1) >= 19.
For D(t), eliminate its still invertible leading block. The
remaining Schur complement is

    t*F1 + O(t^2),

because both off-diagonal blocks vanish at zero. A nonzero
19-by-19 minor of F1 makes the corresponding minor nonzero
for every sufficiently small nonzero real t (divide by t^19).
Thus rank D(t) >= 321. Section 3 gives the opposite inequality,
so rank D(t)=321. Taking one such Y(t) proves every condition
of the stated seed lemma, including codimension nine.

No unresolved downstream lemma is used in this proof. The
independent Reviewer must read the real-density and local
deformation arguments; the Python result alone does not certify
them.

## Reproduction and remaining boundary

From the campaign root:

```bash
$WORKSPACE/argus-live-update/.venv/bin/python research/hankel_seed/verify.py --self-test --details
```

The default invocation reads only `exact_certificate.json` beside
the standalone script; it needs neither manuscript files, Jacobian,
nor third-party Python packages. `--self-test` additionally rejects
an altered decisive corner, an altered claimed rational lift, and
a one-coordinate corruption of the tangent. An externally altered
corner is also required to make the normal verifier exit nonzero.
`verification.json` records the successful detailed reconstruction.

The official campaign-local ledger and graph checks must be run
after their final updates. Independent Reviewer replay is pending;
the Engineer does not set `reviewer_confirmed=true`, claim
`closed_kernel`, or label the entire no-lift theorem verified.
The graph retains the uniform-rank-correction/finite-inverse-limit,
separation, hyperbolicity, and analytic-obstruction obligations
as open.
