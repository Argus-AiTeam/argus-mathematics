# Exact finite-network verification theorem

## Result and scope

The four assertions `lem:scalar-motifs`, `lem:motif-residuals`,
`prop:bit-motif-interface`, and `prop:complex-motif-interface` in
`build/sections/03-motifs.tex` are correct, with their full input and role
quantifiers. This report proves that statement, and the same finite-network
interfaces uniformly for every integer **h >= 40**, replacing the numerical
constants by

    v = binom(h,3), N = v^3, m = h^3, I = 3v^2,
    z_b = 3 binom(h-3,2), z_c = binom(h-3,3) + 3(h-3),
    c_b = h, c_c = h+1, W = 2N + I(vz+c), L = Ich.

The exact ranks are

    s_b = W_b m - N + 2L_b < W_b m,
    s_c = W_c m - 2N + 2L_c < W_c m.

Every scalar input is allowed: all data and every auxiliary input are
arbitrary in F_2 or Z[i,1/2], respectively. For the common-frame assertion,
all arrays on every finite common address set are allowed. The phase
interface holds for **every integer k >= 1**, on every role, including every
individual side and central scratch role. No scratch value is assumed zero.

This is a mathematical verification theorem, with exact algebraic replay and
a Lean-checked structural subtheorem. It is not a finite sample interpreted
as a proof, a refutation, a novelty certification, or a verification of
`thm:main`. In particular, address/tape implementation costs, analytic
resampling, precision recovery and the multiplication complexity theorem
remain open in this audit. Independent Reviewer replay is still required.

The strongest prior project evidence was the empty seed ledger and graph;
there was no prior finite-network certificate to improve. The improvement is
an all-input proof and a parameter-uniform structural reduction, not a larger
sample or an improved multiplication bound. The inherited Wiki index did not
identify a relevant finite-motif result.

## 1. Scalar restoration and all stage orientations

Regard copy V, gather G, side injection J and scatter R as additive maps of
the indicated source, target, side and central modules. They need not
commute, and their modules need not have the same dimension. For initial
(x,y,a,c), the eight rows of `eq:motif-schedule` give

    (x, y + J(Vx) + R(Gx), a, c).

Indeed the old-scratch contribution is
`-Ja-Rc+R(c+Gx)+J(a+Vx)`, so it cancels without a condition on a or c.
The source is never changed. The last two rows restore the two scratch
vectors separately. Reversing the eight rows and negating each update gives
the actual inverse, not another forward shear.

For any ordered pair of triples, write r for its intersection size. These
are exactly the four permutation orbits r=0,1,2,3. In the bit construction
the central coefficient is r modulo two and the side coefficient is one
exactly when r=1. In the complex construction the central coefficient is
(r-1)/2; the side coefficient is its negative for r=0,2 and zero otherwise.
In both cases the sum is one for r=3 and zero otherwise. Since triples have
size three, r=3 means the same triple. Thus JV+RG is the identity.

The middle stage is the inverse invocation with logical source Y and target
X, hence X -= Y. The three stages send

    (x,y) -> (x,y+x) -> (-y,y+x) -> (-y,x).

At stage two the reversed operation names are
V,G,J,R,G,V,R,J, with source Y and target X. Their physical touch order is
Y-side, Y-center, X-side, X-center, Y-center, Y-side, X-center, X-side.
It is the same physical order as the forward stages. The neighbor relation
is symmetric, so a side wire still connects orthogonal physical triples.
Every invocation has separate scratch roles, including across stages.

## 2. Actual subspaces: a universal orthogonal-atom reduction

For rational labels the form is B=I-J/9. As J^2=hJ,

    B^(-1) = I + J/(9-h).

It is nondegenerate for h>=40. For an indicator t of a triple,
`<t,t>=2` and `<s,t>=|S intersect T|-1`. Its actual projector is

    p_t = t (t^T - (1/3) 1^T) / 2.

For binary labels the form is the dot product, `t.t=1`, and the actual
projector is `p_t=t t^T`. Thus neighboring lines are nondegenerate and
orthogonal in precisely the field assigned to that network. The scalar
field/ring is not being identified with the label field.

Fix a stage j, its fixed other two triples, and any neighboring physical
pair t_X,t_Y. Put a=h^(j-1), f=h^(3-j). The genuine tensor decompositions are

    A = P orthogonal B,
    F = <t_X> orthogonal <t_Y> orthogonal K,
    future = Q orthogonal R.

Here dim(P)=dim(Q)=1, dim(B)=a-1, dim(K)=h-2 and dim(R)=f-1.
All components are nondegenerate: an orthogonal complement to a
nondegenerate summand is nondegenerate, and the tensor of invertible Gram
matrices is invertible.

There are twelve orthogonal atoms
`{P,B} x {x,y,K} x {Q,R}`. Each has dimension the product of its three
component dimensions. Zero-dimensional atoms at j=1 or j=3 cause no
problem. This decomposition is **per edge**; it does not assert that all
triple lines are simultaneously mutually orthogonal.

Suppressing the future Q factor only in the following notation, define

    T = A tensor F,   D = B tensor F,
    E_X = D orthogonal (P tensor <t_X>),
    E_Y = D orthogonal (P tensor t_Y^perp).

The actual vertex sequences read directly from `eq:motif-labels` are:

| Role | Consecutive labels, before scratch sinks |
|---|---|
| X | A tensor <t_X>, E_X, T, T, T |
| Y | B tensor <t_Y>, B tensor <t_Y>, D, D, E_Y |
| center | 0, D, T, D, T |
| side | 0, B tensor <t_Y>, E_X, E_Y, T |

Tensor all entries by Q. Each scratch sink is the full ambient space.
The twelve atoms give actual orthogonal direct sums for these subspaces.
For example, the side inclusion E_X subset E_Y follows from
`<t_X> subset t_Y^perp`; its residual is P tensor K tensor Q. It is not an
assumption imported from the manuscript's residual-dimension table.

`construct_labels` and `residuals_from_labels` in `verify.py` construct these
vertex sets, take their set differences, and derive every dimension as a
polynomial in a,h,f. This proves comparability and nondegeneracy on every
edge class. The only strict decrease is center time 3 -> 4, with residual
P tensor F tensor Q and loss h.

For the interstage boundaries, let p_i be the triple-line projector in
factor i, and u=p_1 p_2 p_3 their tensor product. At entry to stage j,

    X = product_(i>=j) p_i,
    Y = product_(i>=j) p_i - u.

At exit replace i>=j by i>j. These commuting-projector identities prove that
the outgoing labels equal the next incoming labels, with no uncharged
boundary change. They start at u,0 and finish at 1,1-u. The two final data
edges therefore have zero residual. The verifier checks the identities on
the eight universal spectral atoms, not on eight selected data inputs.

## 3. Complete ranks, including scratch and negative sources

For nested nondegenerate U subset V, their orthogonal projections satisfy
P_U P_V=P_V P_U=P_U. Thus P_V-P_U is an idempotent with image
V intersect U^perp. Its rank is dim(V)-dim(U). Reversing the edge preserves
rank. The Lean theorem `residual_image` certifies the image assertion for
arbitrary nested additive idempotents, not just for this example.

Sum the derived atom dimensions along each actual role sequence:

    X: a(h-1),       Y: a(h-1),
    side: ahf=m,    center: ahf+2h=m+2h.

In particular, side source->0 and last->sink are included; center
source->1 and last->sink are included. A scratch sink contributes
`ah(f-1)` after its last gate. These are not zero-scratch omissions.
For one invocation the absolute label budget is consequently

    2va(h-1) + vz m + c(m+2h).

There are v^2 invocations at each of a=1,h,h^2. The data contribution is
`2v^3(h-1)(1+h+h^2)=2N(m-1)`. The scratch contribution is
`(W-2N)m+2Ich`. The total is **Wm-2N+2L**. This direct derivation agrees
with telescoping but does not assume the displayed residual table.

In the bit interface the only changed source matrices are the N matrices
-P_U on X inputs. At j=1, B=0, and the first X gate has matrix +P_U.
The edge difference is therefore **2P_U**, not zero. Its image equals
image(P_U) because 2 is nonzero in Q; its rank is one. All other edge
differences remain the ordinary projection differences. Thus exactly N
must be added, giving s_b=W_b m-N+2L_b. This argument would not be valid
over F_2; the source matrices here are rational.

For h=40+t, t>=0, the inequalities v>6ch reduce, for c=h+e and e=0,1, to

    (h-1)(h-2)-36(h+e) = t^2+41t+42-36e > 0.

Hence L<N/2 in both constructions, uniformly in h>=40. The two rank
deficits N-2L_b and 2N-2L_c are strictly positive. At h=100 the replay gives:

| Quantity | Bit | Complex |
|---|---:|---:|
| W | 177176569091445000000 | 1873807244643542670000 |
| s | 177176569088785861287000000 | 1873807244636671267308000000 |
| L/N | 100/539 | 101/539 |
| (Wm-s)/(Wm) | 339/22587335000000 | 73/19906842167500 |

The exact deficits also exceed 20*2^-50, as required for the local
exponent comparison in `eq:explicit-motif-exponents`. No recurrence or
tape-cost bound is certified by checking that arithmetic.

## 4. Common frames and the rational routed endpoints

If all incidences of a gate have one invertible R-linear frame D, then
`D(sum c_j x_j)=sum c_j D(x_j)`. On an edge u->v,
`D_v D_u^(-1)` changes D_u x to D_v x. Induction over the gate order gives
the operator

    D_out S_Omega D_in^(-1)

for **every** input, including arrays on scratch roles. This uses the
physical input's logical interpretation D_in^(-1)f, not a promise of
physical zero scratch. These are the structural statements formalized by
`common_frame_gate` and `edge_frame_change`.

The scalar permutation sends X to Y, Y to X and each scratch role to
itself. The rational endpoint differences are, respectively,

    (I-P_U)-(-P_U)=I,     I-0=I,     I-0=I.

Thus every routed role has the same shear. For the manuscript's finite
modular address fields this implication requires their stated
denominator-coprimality assumption. Choosing radices and charging their
fixed-tape implementation belong to section 04, outside this certificate.

## 5. Binary residual bases and all-k phase correction

Every nonzero binary atom has a norm-one vector. The triple lines and
tensor lines P,Q have their indicator tensors. In a nonzero B or R,
choose a coordinate outside the support of the corresponding tensor
indicator: its support size is 3^d<h^d for d=1,2. In K, choose a coordinate
outside the union of the two triple supports, of size at most six.
Tensoring these units gives a unit in every nonzero atom. Thus every
nonzero residual is nondegenerate and nonalternating.

Here is the needed classification argument, not an appeal to an unexamined
classification theorem. Split off norm-one lines orthogonally as long as
possible. The remaining nondegenerate alternating space splits into
hyperbolic planes: for nonzero a choose b with <a,b>=1 and remove their
nondegenerate plane. Keep one previously split unit w. A plane orthogonal
to w is absorbed using the independent orthonormal vectors

    w+a, w+b, w+a+b.

Repeat with one retained new unit and the next plane. This terminates in an
orthonormal basis. The exact binary Gram change and independence are
replayed by `binary_absorption`; the proof above supplies the induction in
arbitrary dimension.

For binary vectors, the **integer** identity

    wt(z xor w)=wt(z)+wt(w)-2|supp(z) intersect supp(w)|

implies weight additivity modulo four when the binary dot product is zero.
This statement in arbitrary finite dimension is Lean-checked, as is the
exact weight identity. For an orthogonal residual E with orthonormal basis
B, repeated additivity therefore gives

    q_(U orthogonal E)(x)-q_U(x)
      = sum_(v in B) wt(v) [v dot x] mod 4.

Each wt(v) is odd. The direction of the edge supplies the additional sign.
Walsh conjugation sends the character (-1)^(v dot x) to translation by v.
Consequently each term supplies (aI+bX_v) or its inverse, with
a=(1+i)/2, b=(1-i)/2. These matrices and their inverses are Gaussian dyadic.
The basis lengths are exactly the already derived s_c. Nothing is being
deduced from a floating-point rank calculation.

On the X->Y route, put u=u_a. Its norm is one and its weight is exactly
27, for all h in the theorem. Orthogonal weight additivity gives

    q_(U^perp)(x)-q_U(x)
       = wt(x)-2 wt(u)[u dot x]
       = wt(x)+2[u dot x] mod 4.

The extra character is the product of Z characters on the 27 supported
coordinates. After Walsh conjugation, the routed operator is C^(-1) on
those coordinates and C elsewhere. The exact Gaussian identity is

    C = i Z C^(-1) Z.

For any k>=1, put Z on those 27 coordinates in **each** column at input X,
and put `i^(27k) Z_(a,k)` at output Y. Tensoring the identity once for each
of the 27k inverse factors gives C^(tensor mk). The scalar i^(27k) is
applied **once to the whole role**. There is no assumption on a column's
address or value.

The Y->X route already has the desired forward frame but has scalar sign
-1. Negate the physical X output once, independently of k. Tensoring the
address frame does not tensor the scalar role-routing operation k times.
Every scratch route has zero source and full sink, sign +1, and therefore
already has C^(tensor mk). Undo the role permutation rho after these
corrections. This proves the claimed operator on **every** role.

## Replay and evidence limits

Run, from the campaign root:

    $WORKSPACE/argus-live-update/.venv/bin/python research/finite-network-core/verify.py

The script uses the Python standard library only. It recomputes the exact
certificate and requires full equality to `exact_certificate.json`.
Its finite checks are exhaustive **structural reductions**: all four
intersection orbits, all twelve tensor-atom classes, all eight interstage
spectral atoms and the finite generators of the phase algebra. The proof
above establishes why those reductions cover unbounded input values and
column counts. It does not interpret absence of witnesses in a finite
numerical search as a universal theorem.

The Jacobian adapter's single bounded rank operation is bound to the
actual Gram matrix of neighboring rational triple indicators with
intersection one, namely diag(2,2). The exact payload, typed response,
server version 0.14.0, protocol 2025-11-25 and adapter exit status are
preserved in dedicated JSON files. It is supplementary, not an oracle for
the whole proof.

`Main.lean` and `statement_fidelity.md` delimit the formal part. Only a
successful real `lean_evidence verify --claim C_STRUCTURAL_LEAN` run with
no proof holes constitutes compiler evidence. The archived compiler result,
not this report, records its outcome. No false manuscript assertion was
identified in this scoped proof, so there is no invented F_ claim or
refutation judgement. The known Harvey--van der Hoeven 2021 baseline is
recorded separately as an external known-status assumption, not used in
this self-contained theorem and not presented as a new result.
