# Exact audit of the all-role binary-frame network

**Result.** The assertions `net:edge`, `net:residuals`, and
`net:finite-interface` hold, including the reversed second stage, unrestricted
auxiliary inputs, all integers f>=1, and arbitrary spectator bits. The actual
h=100 construction has exactly the stated W, s and positive saving Delta.
The charged indexing argument gives the stated `net:tensor-bound` recurrence
and critical exponent. Sections 1-7 below give the universal proof; the
standard-library `verify.py` replays its exact algebraic certificate.

The same proof extends the interface to every integer h>=7, with strict
saving exactly when h>=22 in that range. Choosing h=25 improves the gap
1-theta by a factor greater than 1500 over the padded h=100 construction.
This is a network verification and parameter-extension theorem, not a proof
of either manuscript's full Fourier theorem or a certified novelty claim.
Independent Reviewer replay and publication/novelty assessment are pending.

## Scope and source facts

The target is `build/sections/network.tex` in
`An-explicit-power-saving-for-the-exact-discrete-Fourier-transform-September-25-2026`.
The manuscript sources, not the companion's abstract price argument, define
the network audited here. The computational model charges complex scalar
arithmetic and operations on logarithmic-size address words as in that source.
The campaign remains `research_target_level=publishable` and
`math_objective_mode=exploratory`. Independent Reviewer acceptance is pending.

The following are source assertions, not assumptions that this audit grants:

* `net:parameters`, `net:wire-count`: h=100, v=binomial(h,3)=161700,
  N0=v^3, m=h^3, I0=3v^2, ordered neighbor degree
  d=binomial(97,3)+3*97=147731, and
  W=2N0+I0*(v*d+101)=1873807244643542670000.
* `net:schedule`, `net:scalar`: the eight updates subtract JA and Rc,
  add Vx and Gx to auxiliaries, add Rc and JA to the target, and
  subtract Gx and Vx from auxiliaries. They claim the full map
  (x,y,A,c) -> (x,y+x,A,c), without a zero-auxiliary hypothesis.
  Stages 1 and 3 are forward X-to-Y, while stage 2 reverses the
  scalar updates and their signs with logical source Y and target X.
* `net:frame`, `net:edge`: Phi_U=J diag(i^wt(P_U x)) J for a
  nondegenerate binary label U. A nested edge with an orthonormal
  residual of dimension rho uses rho forward or inverse directional
  kernels aI+bR_z, with a=(1+i)/2 and b=(1-i)/2.
* `net:labels`, `net:residuals`: chronological physical touches are
  Y-side, Y-center, X-side, X-center, Y-center, Y-side, X-center,
  X-side, including stage 2. Only a central wire's edge 3->4
  decreases; its dimension loss is h. The asserted total is
  s=Wm-2N0+2I0*(h+1)*h=1873807244636671267308000000 and
  Delta=Wm-s=6871402692000000.
* `net:telescoping`, `net:finite-interface`: all physical arrays,
  including arbitrary auxiliary arrays, are transformed for every
  integer f>=1 and arbitrary spectator bits. The exceptional
  X_d-to-Y_d route has ratio R_u C^(tensor m), where wt(u)=27;
  sink translations and the signed bank exchange must be undone.
* `net:indexing`, `net:padding`, `net:tensor-bound`: column address
  changes cost O(2^k), W*=2^71, S=W_*m-Delta, lambda=S/W*, and
  t(k)<=A+lambda*t(floor(k/m)) above K=m*72. Neither the finite
  interface nor its recurrence certifies the separate Fourier compiler.

The primary manuscript's remaining dependency chain is the local compiler
(`loc:compiler`), packed sector addressing (`lem:sector-address`), synchronized
tensor Fourier transform (`prop:tensor-fourier`), small coprime factors
(`lem:prime-lengths`), working length, chirp convolution, and master-root
construction, leading to the introduction's all-length Fourier theorem.
These propositions are unaudited here and remain open.

The companion's distinct route runs through global prices under a no-win
hypothesis (`thm:prices`), word bounds (`price:word-bounds`), coefficient
boundaries (`lem:boundary-comparison`), feedback (`thm:feedback`),
specialization (`thm:specialization`), pivots (`lem:pivot-bound`,
`lem:scalar-pivot`), dense-pair prices (`lem:pair-price`), sparse reflection,
and finite win (`thm:finite-win`), followed by `prop:win-to-fourier`.
These are source assertions, not inputs to the network proof. Their external
Good/Bluestein and related references have not been attributed in this audit;
no result from those references is being assumed for the network theorem.

The open source decomposition has these locators (paths relative to each
manuscript's `build/` directory):

| Ledger claims | Source locator |
|---|---|
| E_LOCAL | `sections/local.tex:23-47`, `loc:compiler`; its Newton/replay/Toeplitz/Fourier sublemmas remain unaudited |
| E_SECTORS, E_SYNC | `sections/synchronization.tex:24-99`, `lem:sector-address`, `prop:tensor-fourier` |
| E_PRIMES, E_LENGTH | `sections/all-lengths.tex:12-57` |
| E_CHIRP, E_ROOT | `sections/all-lengths.tex:91-129,163-201` |
| E_MAIN | `sections/introduction.tex:85-91` |
| Q_PRICE, Q_WORD | `sections/04-packing-prices.tex:1-37,545-560` |
| Q_BOUNDARY, Q_FEEDBACK, Q_SPECIAL | `sections/06-feedback.tex:43-486` |
| Q_PIVOT, Q_SCALAR_PIVOT, Q_DENSE | `sections/07-pivots.tex:13-104,175-239,275-413` |
| Q_REFLECT, Q_WIN | `sections/08-reflection.tex:246-531` |
| Q_TRANSFER, Q_FOURIER | `sections/03-fourier-transfer.tex`, `prop:win-to-fourier`; `main.tex`, abstract |

The shared Wiki contains a closely related earlier reconstruction,
`pages/c9000109/finite-network-core_theorem.md`. It treats analogous bit
and complex motifs uniformly for h>=40, has the same complex h=100
dimension count, and explicitly does not certify the address-cost
recurrence. It is not adopted as an assumption. The present contribution
relative to that stronger related prior evidence is the h>=22 strict-saving
threshold, the explicit h=25 exponent comparison, and the complete charged
binary-frame recurrence for this manuscript, not discovery of the common
frame trick. The current campaign's seed ledger itself had no prior verified
network result.

No external theorem is needed below: the necessary binary-form
classification, character cancellation, tensor lifting and recurrence
estimate are proved here. The other manuscripts' citations are not silently
being accepted as assumptions. No false assertion in the three target
propositions was identified, so there is no invented `F_` refutation claim.

## 1. Scalar restoration, ordered neighbors, and the reversed stage

First allow J,R,V,G to be arbitrary well-typed linear maps. Direct expansion
of the eight updates gives

    x' = x,
    y' = y - JA - Rc + R(c+Gx) + J(A+Vx)
       = y + RGx + JVx,
    A' = A,   c' = c.

This identity is in the free noncommutative algebra of the four maps;
neither commuting maps nor zero auxiliaries are used. The verifier expands
the actual parsed source schedule in that algebra, retaining every initial
input as a separate formal variable. Reversing the rows and all signs gives
the inverse and changes the displayed net addition to its negative.

For triples S,T, put r=|S intersect T|. The coefficient of RG is (r-1)/2.
The coefficient of JV is its negative for r=0,2, and zero otherwise.
Thus their sum is zero for r=0,1,2 and one for r=3. Since both sets have
size three, r=3 is equivalent to S=T. This proves RG+JV=I for every pair
of triples, not for selected matrix entries.

Each stage partitions each bank into the v^2 fixed-other-index lists.
Consequently the first and third stages are Y+=X on every entry, and the
middle stage is X-=Y on every entry. Their composition is

    (X,Y) -> (X,Y+X) -> (-Y,Y+X) -> (-Y,X).

For the middle stage, the actual chronological operations are
V,G,J,R,G,V,R,J with signs +,+,-,-,-,-,+,+, logical source Y and
logical target X. They touch, in order,

    Y-side, Y-center, X-side, X-center,
    Y-center, Y-side, X-center, X-side.

This is exactly the chronological physical order used by the labels.
Relabeling an ordered side pair interchanges its physical source and target;
the neighbor relation is symmetric, so their two indicators remain
orthogonal. Auxiliaries of different invocations are distinct and each is
restored separately.

For a fixed triple, the number of triples with intersection r is
binomial(3,r)*binomial(h-3,3-r), by choosing the inside and outside
elements. Neighbors are exactly r=0 or r=2. At h=100 these four counts
are 147440,13968,291,1, giving degree 147731 and v=161700.
There are v*degree ordered side roles per invocation, not half that number.

## 2. Binary nondegeneracy and orthonormal residual bases

If a subspace is nondegenerate, the ambient space splits as its orthogonal
direct sum with its orthogonal complement. The complement is nondegenerate:
a vector in its radical is orthogonal to both summands and hence to the
whole nondegenerate ambient space. Tensor products of nondegenerate forms
are nondegenerate because their Gram matrices are Kronecker products of
invertible matrices.

A nondegenerate symmetric binary space containing a unit vector has an
orthonormal basis. Split off unit lines until the remaining space is
alternating. A nonzero nondegenerate alternating space contains p,q with
p.p=q.q=0 and p.q=1, and their nondegenerate plane splits off. Retain one
previously removed unit w. In its orthogonal sum with this plane, replace
the basis by

    w+p,   w+q,   w+p+q.

Its Gram matrix is I_3 and its change-of-basis matrix has rank three.
These are exact GF(2) calculations, replayed locally and by the saved
Jacobian operation. Retain one of the new unit vectors and repeat with
the remaining alternating planes. Dimension decreases at each removal;
therefore this procedure terminates and proves the assertion in every
finite dimension. Nondegeneracy alone, without a unit vector, would not
have sufficed.

For the actual labels, each triple indicator has norm one. A tensor of
such indicators also has norm one. Its support in a d-factor prefix or
future space has size 3^d, strictly smaller than h^d for d=1,2 and
h>=7. A coordinate unit outside that support belongs to the orthogonal
complement of its tensor line. For two neighboring triples, the complement
of their two orthogonal unit lines contains a coordinate unit outside
their union, whose size is at most six. Full spaces and the triple lines
also have units. Every nonzero tensor atom below therefore has a unit,
as does every nonzero orthogonal sum of atoms.

These are support inequalities for all triples and all h>=7. No randomly
chosen vectors or finite collection of network instances is used.

## 3. Residuals derived from the actual physical incidences

Fix a stage j and one neighboring physical side pair. Put

    a=h^(j-1), b=h^(3-j),
    prefix = P orthogonal B,
    current factor = <t_X> orthogonal <t_Y> orthogonal H,
    future = Q orthogonal F.

The component dimensions are respectively (1,a-1), (1,1,h-2) and
(1,b-1). There are twelve orthogonal atoms
{P,B} x {t_X,t_Y,H} x {Q,F}. Some atoms are zero at the first or
last stage. This is a decomposition for the particular edge under
discussion; it does not assert that all triple lines are mutually
orthogonal.

Write D0=B tensor D and D1=prefix tensor D; suppress the common Q
factor until an auxiliary sink. The source-parsed gate labels give
these complete physical vertex sequences:

| Role | Consecutive labels |
|---|---|
| X | prefix tensor <t_X>, D0+P tensor <t_X>, D1, D1, D1, D1 |
| Y | B tensor <t_Y>, B tensor <t_Y>, D0, D0, D0+P tensor t_Y^perp, D0+P tensor t_Y^perp |
| side | 0, B tensor <t_Y>, D0+P tensor <t_X>, D0+P tensor t_Y^perp, D1, full ambient |
| center | 0, D0, D1, D0, D1, full ambient |

Every plus sign here is an orthogonal direct sum. All labels before
an auxiliary sink are tensored with Q. The sink adds D1 tensor F.
The bank sequences include their stage entry and exit, and hence include
zero edges as well.

The program interprets the actual gate-label expressions as sets of these
atoms, derives each role's row list from the physical gate touches, and
takes differences of consecutive sets. It never uses the manuscript's
residual table as an input. Every pair of consecutive sets is nested.
For clarity, the derived nonzero residual dimensions are:

| Role and edge | Dimension |
|---|---|
| X: in->2 | (a-1)(h-1) |
| X: 2->3 | h-1 |
| Y: 0->1 | (a-1)(h-1) |
| Y: 4->5 | h-1 |
| side: source->0 | a-1 |
| side: 0->2 | (a-1)(h-1)+1 |
| side: 2->5 | h-2 |
| side: 5->7 | 1 |
| side: 7->sink | ah(b-1) |
| center: source->1 | (a-1)h |
| center: 1->3, 3->4, 4->6 | h each |
| center: 6->sink | ah(b-1) |

Only center 3->4 decreases. Each residual is an orthogonal sum of the
nondegenerate unit-containing atoms proved in Section 2; it therefore has
an orthonormal basis. Taking absolute dimensions along the sequences gives
the polynomial identities

    X: a(h-1),  Y: a(h-1),  side: ahb,  center: ahb+2h.

The verifier derives these identities in Z[a,h,b], not by evaluating
them at h=100. The only total decrease per central wire is h.

There is no uncharged interstage transition. Let p_i be the triple-line
projector in factor i, and u=p_1 p_2 p_3 their tensor product. The actual
stage-j entry projectors are

    X: product_(i>=j) p_i,
    Y: product_(i>=j) p_i - u,

and the exit replaces i>=j by i>j. These formulas follow by expanding
B=I-P in the displayed entry and exit labels. The exit of a stage is
exactly the next entry. Initially the projectors are u,0 and finally
I,I-u, as required. The eight joint spectral atoms of the three commuting
idempotents check these identities in their universal idempotent algebra;
they are not eight sampled data arrays.

## 4. Edge frame orientation and exact directional kernels

For binary coordinate bits x,y,

    x xor y = x+y-2xy.

Summing this integer identity over arbitrary coordinates proves
wt(x+y)=wt(x)+wt(y)-2|supp(x) intersect supp(y)|. Binary orthogonality
means the last cardinality is even, giving weight additivity modulo four.
Repeated use is valid for any finite orthogonal list.

Let V=U orthogonal E and let z_1,...,z_rho be an orthonormal basis of E.
The orthogonal projections satisfy

    P_V x = P_U x + sum_j z_j [z_j.x],
    q_V(x)-q_U(x) = sum_j wt(z_j)[z_j.x] mod 4.

The summands are orthogonal; every wt(z_j) is odd. Reversing the
edge negates the entire difference.

The binary character sum is zero when its character is nontrivial:
pair every address with its translate in a coordinate on which the
character is nontrivial. For the zero character the sum is 2^m.
This proves J_m^2=I and J_m diag((-1)^(z.x)) J_m=R_z in every
dimension. Thus

    Phi_V Phi_U^(-1) = J_m diag(i^(q_V-q_U)) J_m.

For a=(1+i)/2, b=(1-i)/2, the identity
i^[z.x]=a+b(-1)^(z.x) turns a positive odd-weight phase into C_z
or C_z^(-1), according as that weight is 1 or 3 modulo four.
All four combinations of increasing/decreasing orientation and odd weight
are checked with exact Gaussian rational arithmetic. Also

    C_z^2 = (a^2+b^2)I+2ab R_z = R_z,
    C_z^(-1) = R_z C_z.

The product has exactly rho scheduled directional kernels. Inverse kernels
require one forward kernel and one translation, not another transform.
Finally Phi_0=I and Phi_whole=C^(tensor m), by factoring the coordinate
phases. Walsh transforms only prove identities; none is executed.

## 5. All columns, all spectators, and every routed physical role

For any f>=1 and r>=0 set

    F_U = Phi_U^(tensor f) tensor I_(2^r).

The tensor multiplication identity
(A tensor B)(C tensor D)=(AC) tensor (BD) follows by distributing
each matrix coefficient sum. Starting with f=1, this identity proves
every edge factorization and inverse formula for f+1 from f. The
spectator identity factor is unchanged. This is induction for arbitrary
f and r, not an extrapolation from small f.

A pointwise scalar gate with coefficients c_ij commutes with its common
address frame:

    F(sum_j c_ij v_j)=sum_j c_ij F(v_j).

An edge U->V changes an array F_U v to F_V v by F_V F_U^(-1).
Induction over the chronological gates consequently gives the complete map

    diag_sinks(F_U) S diag_sources(F_U^(-1))

for arbitrary physical input arrays. The input need not already be in
the source frame: its logical interpretation is F_source^(-1) times
that physical input, still arbitrary. The scalar map S is the signed
bank exchange from Section 1 and the identity on every auxiliary role.
Only address frames are tensor-powered; S is not replaced by S^(tensor f).
In particular its bank sign is applied once, not raised to the f-th power.

All ordinary routed source/sink pairs have labels 0 and whole. For the
exceptional X_d->Y_d pair, let u=t_d1 tensor t_d2 tensor t_d3.
Then u.u=1, wt(u)=27 and P_U x=u[u.x]. Orthogonal additivity gives

    q_(U_perp)(x)-q_U(x)
      = wt(x)-2 wt(u)[u.x]
      = wt(x)+2[u.x] mod 4.

The routed ratio is therefore R_u C^(tensor m) in each column.
Writing T=C^(tensor mf) tensor I_(2^r) and
R=R_u^(tensor f) tensor I_(2^r), the uncorrected sinks are

    X_sink = -T Y_input,
    Y_sink = R T X_input,
    every auxiliary_sink = T auxiliary_input.

Translate Y_sink by R, then output (corrected Y_sink,-X_sink).
Since R^2=I, both banks and every individual auxiliary role now have
exactly their own T-transformed input.

For a nonzero direction z, extend z to a binary basis and let L have z
as its first column. With A_L v(x)=v(L^(-1)x),

    A_L R_e A_L^(-1) v(x)
       = v(L(L^(-1)x+e)) = v(x+Le).

Thus C_z=A_L C_e A_L^(-1). Applying this in all columns makes the
directional product C^(tensor f) on the f selected bits, independently
on each fiber of the other bits. Inverse products add only the single
all-column translation. All residual bases, directions, gates and terminal
corrections are fixed once h is fixed, independently of f and r.

## 6. Exact dimension count and a smaller-parameter extension

There are v^2 invocations at each of a=1,h,h^2 and ahb=m=h^3.
The incidence-derived bank contribution is

    v^2 sum_(a=1,h,h^2) 2v*a(h-1) = 2v^3(m-1).

For every invocation its v*degree ordered side roles each contribute m,
and its h+1 central roles each contribute m+2h. Consequently

    W = 2v^3 + 3v^2(v*degree+h+1),
    s = 2v^3(m-1) + 3v^2(v*degree*m+(h+1)(m+2h))
      = Wm-2v^3+6v^2(h+1)h,
    Delta = Wm-s = 2v^2(v-3h(h+1)).

This includes auxiliary source edges, their final exits from the Q frame,
and both senses of each central decrease. Independently, the source ranks
sum to v^3 and sink ranks to Wm-v^3. Their signed difference is Wm-2v^3,
and replacing the signed central losses by absolute losses adds exactly
2*(3v^2)*(h+1)*h, agreeing with the direct count.

At h=100 the replay gives:

| Quantity | Exact value |
|---|---:|
| v | 161700 |
| N0 | 4227952113000000 |
| I0 | 78440670000 |
| degree | 147731 |
| m | 1000000 |
| W | 1873807244643542670000 |
| s | 1873807244636671267308000000 |
| Delta | 6871402692000000 |

For every h>=7, all earlier identities and unit witnesses still apply.
Since

    v-3h(h+1) = h*(h^2-21h-16)/6,

strict saving is equivalent to h>=22 in this parameter range.
For h=22+t the last quadratic is t^2+23t+6>0; for 7<=h<=21
it is h(h-21)-16<0. No claim that h=7 is a necessary lower bound
for validity of the interface is made.

As an explicit extension, h=25 gives m=15625,
W=58645352620000, Delta=3703000000 and W*=2^46.
The padded coefficient is

    lambda_25 = 17179869126140625/1099511627776.

Let epsilon_h=Delta_h/(W*_h*m_h) and
g_h=1-log_(m_h)(lambda_h). For 0<epsilon<1, integration of
1/(1-t) over [0,epsilon] gives

    epsilon <= -log(1-epsilon) <= epsilon/(1-epsilon).

Because m_25<2^14 and m_100>2^19, these inequalities imply

    g_25/g_100 >
      19*epsilon_25*(1-epsilon_100)/(14*epsilon_100) > 1500.

The last comparison is exact rational arithmetic in the certificate.
This is a proven improvement of the network's critical exponent, not
a global parameter optimum or certification of the downstream Fourier
transfer.

## 7. Charged indexing, exact batches, and the tensor bound

For fixed h and m, a table for all 2^m column digits records the fixed
binary address map, its selected bit and remaining bits. This table is
finite, constructible by binary arithmetic, and of constant cost relative
to k. For f columns and r<m spectators, compute all displaced input and
output contributions and strides in O(f+1) operations on k+O(1)-bit
words. Put selected bits in the least significant output field.

Enumerate the column digits by their prefix tree, retaining partial input
and output address sums. Each edge updates two sums in constant time using
the appropriate displaced digit table; a leaf copies one value to a
separate output array. Every nontrivial digit has radix at least two;
omit the spectator digit when r=0. For a finite rooted tree,

    sum_internal(degree-1)=leaves-1.

This follows inductively by attaching the children at a root. Thus the
number of internal nodes is at most leaves-1, and the entire traversal
costs O(2^k). Setup is also O(2^k), since f+1<=k+1<=2^k
for nonzero column counts. The zero-length case is a base case.
Swapping the input and output sums implements the inverse permutation.
No leaf scans f columns. Fibers of size 2^f are contiguous, so grouping
W* consecutive fibers needs no additional index search.

For h=100, the least power of two at least W is W_star=2^71.
Use m ordinary coordinate directions on each extra role. The total is

    S = s+(W_star-W)m = W_star*m-Delta
      = 2361183241427951204156000000,
    lambda = S/W_star
      = 9223372036827934391234375/9223372036854775808,
    1 < lambda < m.

Let T(k) be the charged cost to transform W_star arbitrary arrays of length
2^k. For k<K=m*(71+1)=72000000, use ordinary coordinate kernels;
the normalized cost is bounded over this fixed finite base range.
For k>=K write k=mf+r. Charge the r ordinary leftover layers,
then use the all-role interface on W roles and the ordinary padded
roles. Each of the S grouped directional steps has exactly 2^(k-f)
fibers requiring C^(tensor f). We have

    f>=72,  k-f>=(m-1)f>=71,  f<k.

Hence W_star divides the fiber count, so exactly 2^(k-f)/W_star recursive
batches occur, with no incomplete batch. Every batch input may be
arbitrary because the interface transforms arbitrary values on all
roles. All fixed gates, address permutations, translations, leftover
layers, initialization and batch setup are O(W_star*2^k) outside calls.
Thus, for an absolute A,

    T(k) <= A W_star*2^k + S*(2^(k-f)/W_star)*T(f),
    t(k) <= A + lambda*t(floor(k/m)),
    t(k) = T(k)/(W_star*2^k).

Successive integer arguments are floor(k/m^j), by Euclidean division.
Unroll d steps to the base range. For
theta=log_m(lambda), 0<theta<1, and
d<=ceil(log_m(k+1)),

    t(k) <= A sum_(j<d) lambda^j + B lambda^d
         <= (A/(lambda-1)+B) lambda^d
         = O((k+1)^theta).

The bound lambda^d<=lambda*(k+1)^theta proves the last equality.
Increasing the constant includes every base k, including k=0.
For one requested array initialize W_star-1 other roles to zero and keep
the requested output role; its O(W_star*2^k) initialization is charged.
This proves `net:tensor-bound`, including construction and indexing,
with only rational constants and i. The same padding argument applies
to the strict-saving h>=22 extension with its own fixed W_star and K.

## 8. Certificate interpretation and remaining obligations

Run from the campaign root:

    $WORKSPACE/argus-live-update/.venv/bin/python research/network-audit/verify.py

The verifier parses and binds the actual schedule, chronological labels,
parameter equations, reversed-stage instruction and terminal assertions.
It expands the free-map cancellation, compares the four exhaustive
intersection orbits, derives all twenty physical edge classes, computes
dimension polynomials over Z[a,h,b], checks universal idempotent atoms,
and replays exact Gaussian rational phase identities and the binary
absorption matrix. It also checks the lifting induction schemas, indexing
tree identity, exact recurrence constants and rational exponent comparison.
These are symbolic identities for the explicitly proved universal
reductions, not sampled finite network executions.

Seven deliberately invalid certificate mutations were rejected: an
initial auxiliary sign, the reversed physical bank, omission of the side
role cost, an invalid absorption basis, tensor-powering the bank sign,
an off-by-one total step count, and an unjustified recursion threshold.

The saved Jacobian request uses `prime_field.matrix.rank.compute` over
GF(2), after inspection of its exact typed contract. The payload, full
typed output, protocol 2025-11-25, server version 0.14.0, operation id and
adapter exit status zero are retained in the dedicated JSON files.
The result certifies only the three-dimensional basis change. The local
verifier independently redoes that computation; Jacobian is not being
treated as a proof oracle for the whole network.

No Lean source is claimed or left uncompiled. This deliverable is an exact
structural replay with the mathematical proofs above, not a kernel-checked
formalization of the entire statement. In particular, a reader still must
check statement fidelity, the universal induction arguments and the
specified cost model; compilation is not being substituted for that review.
Engineer support in the ledger is a mathematical judgement, not
`closed_kernel` status.

The local compiler, mixed-radix synchronization, all-length Fourier
transfer, and companion price/feedback/pivot/reflection route remain open.
Their source assertions are decomposed in the ledger and proof graph but
receive no supporting verdict from this audit. Independent Reviewer replay,
including any novelty/publication assessment, is the next required owner.
