# Universal verification of leading-word transfer

## Result and scope

**Verification theorem.** In the spectral case of the staged September 23,
2026 manuscript, `prop:word-transfer` follows from the original
division-algebra and free-series hypotheses. This includes arbitrary word
length, the full root multiplicity, any permitted complementary block,
simultaneous projected active-space containment, and finitely many commuting
parameters. The argument below establishes the admissible-evaluation,
spectral and scalar-response facts it uses; it does not take
`ADMISS9000201`, `SPECTRAL9000201` or `RESPONSE9000201` on faith.

The decisive point is stronger than invertibility of a complementary
block. Proper-subword vanishing makes the internal zero eigenvalue
semisimple **and** annihilates both endpoint-to-kernel couplings. These two
annihilations remove every contribution from the pole, including finite
terms involving derivatives of the couplings. A separate solution-space
argument identifies the limit with the **original fixed complement**,
not with a newly chosen spectral complement.

This is an independent mathematical verification, not a counterexample,
not an independent novelty finding, and not a verification of the main
division-ring or lifting theorem. Independent Reviewer approval is pending.
Relative to the strongest prior result in
`../cyclic_compatibility/report.md`, the improvement is upstream: that
reviewed cyclic implication assumed transfer and its three prerequisites;
this report supplies their proofs. No previously reviewed artifact is
changed, and the cyclic certificate has not been rerun.

The source locators are `lem:admissible-evaluation`,
`lem:generic-detection`, `lem:nonconstant-roots`,
`lem:stable-multiplicity`, and `lem:scalar-branches` in
`formal-generic.tex`; `lem:paired-scalar` and
`lem:active-specialization` in `responses.tex`; and `lem:killed-pole`
and `prop:word-transfer` in `transfer.tex`. All are under the staged
manuscript's `build/sections/` directory. They were read directly.
No proposition from the bibliography is imported as an unverified
proof dependency: Section 3.0 also supplies the elementary splitting
argument for the central division algebra in the original spectral setup.
The supplied Wiki index contained no relevant division-ring or transfer
result. No claim of literature novelty is made.

## 1. Original data and tensor factors

Let k have characteristic zero and contain all roots of unity. Let A be a
central division k-algebra of degree d, fix an algebraic closure K and a
splitting A tensor K = M_d(K), and let

    w = sum_word a_word z^word in A<<z_1,z_2>>.

The letters commute with A, but not with each other. Put
`W_n(P)=sum a_word tensor P^word`. Every input coefficient is a
scalar n-by-n matrix on the **input** factor. In particular, changing an
input arrow does not give access to arbitrary endomorphisms on the old
coefficient factor.

Let q_0 be the minimal polynomial of w(0). We are in the manuscript's
spectral case `q_0(w) != 0`; if that series is zero, the manuscript
explicitly bypasses this construction. Sections 2--4 construct the
allowed additive progression S, the common multiplicity t, and the
response space T_P from these data.

Take n,N in S and a small input `R=diag(P,C_0)` of size N, where P is
a small generic point of size n. C_0 can be absent, and no
semisimplicity assumption on W(C_0) is imposed. Let I be a finite set
of root labels at P such that W(C_0)-lambda_h is invertible for h in I.
Work in a coefficient field E containing this data, with the
coefficientwise evaluations described below. Write pi_h for the
rank-t root projector embedded at P and f_h=1-pi_h.

For every free input pair Z with constant R, define

    S_h(Z) = pi_h (W(Z)-lambda_h) pi_h
             - pi_h W(Z) f_h
               (f_h (W(Z)-lambda_h) f_h)^(-1)
               f_h W(Z) pi_h.

The inverse is on f_h, with its invertible constant term. We prove that,
if all S_h vanish in degrees below ell, then for every length-ell word
omega

    [S_h(Z)]_omega = c_(h,omega) pi_h,
    (c_(h,omega))_(h in I) belongs to (T_P|_I) tensor E.       (1)

The proof also works for an arbitrary finite alphabet; this modest
extension is not asserted to be new.

## 2. Admissible evaluation and clearing denominators

Use a complete discretely valued extension of K with v(K*)=0 and
v(epsilon)=1. Finite splitting extensions are allowed with the extended
valuation. Fix a constant input with b upper-triangular blocks, small
diagonal blocks, and arbitrary finite strictly upper blocks.

Fix a word coefficient of degree r after a positive-order perturbation
H. A contributing original word of length L uses at most r
H-insertions. The intervening at most r+1 constant intervals contain
at most `(r+1)(b-1)` upper steps: each such step strictly increases
the block index. All other constant factors are small diagonal factors.
Only finitely many coefficients of H occur at this degree.

Choose c>0 below all diagonal valuations and a finite lower bound m for
the other factors in question. With
`B_r = r+(r+1)(b-1)`, every summand has valuation at least

    c L - (c-min(m,0)) B_r.                                (2)

The lower bound tends to infinity uniformly with L. There are finitely
many words at each L, so the sum converges. Nonarchimedean summability
permits regrouping; addition, multiplication, finite determinants and
fixed-order differentiation therefore preserve entry identities.
This proves precisely the convergence required here, not analytic
convergence in an unrelated norm.

For a Taylor/Laurent parameter xi, fix both r and its requested
xi-coefficient. The bounded number of upper steps and H-insertions
gives a lower bound on their negative xi-order. At the requested
coefficient only boundedly many positive-order diagonal Taylor
factors can occur. Only finitely many coefficients of those factors
are used. Every remaining factor is a small constant diagonal factor.
Thus (2), with a new constant, applies coefficientwise. No interchange
of the epsilon- and xi-Laurent topologies is needed.

We never specialize a geometric inverse expansion on the strength of
this argument. Every inverse involving an auxiliary input is first
replaced by adjugate divided by determinant. The cleared numerator
is a finite sum of products of admissible entry series and fixed
base-point scalars. It can be evaluated by (2). Division is restored
only after the specialized determinant has been proved nonzero.

Here is the detection fact used in this procedure. If
`F(Q)=sum c_alpha Q^alpha` and the valuations of c_alpha have a
common lower bound, then evaluation at Q=epsilon Q^circ, with
independent residues over the already constructed base valued field,
is injective. For a nonzero F, the minimum of
`v(c_alpha)+|alpha|` is attained at finitely many monomials. Their
scaled residues form a nonzero polynomial in independent residues.
It cannot vanish. This proof includes nonintegral discrete value
groups after finite extension.

For the cleared response numerators the required uniform lower bound
exists: there are finitely many base spectral scalars and finitely
many arrows; remaining base-input factors are small and auxiliary
coordinates have been left formal. It need not exist for the
**uncleared** inverse coefficients, which are not used in detection.
Auxiliary residues are adjoined after the base spectrum has been split.

## 3. Spectral prerequisites derived from division

### 3.0 Splitting needs no additional manuscript assumption

For clarity, the standard splitting fact can be proved here as well.
The finite-dimensional algebra S=A tensor_k K is simple. Indeed,
in a nonzero two-sided ideal choose a nonzero tensor of minimal
length, with K-coefficients linearly independent over k. Multiplying
by the inverse of its first nonzero A-coefficient makes that
coefficient 1. Its commutator with any element of A has smaller
tensor length and hence is zero. Independence of the K-coefficients
makes all its A-coefficients central, thus in k. The tensor is a
nonzero K-scalar, so the ideal contains 1.

Choose a minimal nonzero left ideal V of S. It is an irreducible
finite-dimensional K-module, and S acts faithfully because its
annihilator is a proper two-sided ideal. Every nonzero S-endomorphism
of V is invertible: its kernel and image are submodules. Every such
endomorphism has an eigenvalue over the algebraically closed K,
so subtracting that eigenvalue makes a noninvertible endomorphism.
It must be zero. Therefore End_S(V)=K.

Here is the finite density argument, rather than an appeal to it.
For independent v_1,...,v_m in V, induction shows that
`s -> (s v_1,...,s v_m)` maps S onto V^m. The case m=1 is
irreducibility. Given the assertion for m-1, let I be the left
ideal annihilating the first m-1 vectors. The submodule I v_m
is either 0 or V. In the latter case it supplies any remaining
correction to the last target coordinate. In the former case
the assignment

    (s v_1,...,s v_(m-1)) -> s v_m

is a well-defined S-linear map V^(m-1) -> V. Each of its
component maps belongs to End_S(V)=K. Setting s=1 then makes
v_m a K-linear combination of its predecessors, a contradiction.
Applying the induction to a basis of V shows
`S=End_K(V)`. Dimension gives dim_K(V)=d, so
`A tensor K=M_d(K)` as used above.

### 3.1 Division evaluations and equal multiplicities

For a positive integer n, put F=k(alpha,beta) and introduce
`x^n=alpha`, `y^n=beta`, `yx=zeta_n xy`. The monomials x^i y^j,
0<=i,j<n, together with a k-basis of A, are independent over F.
Indeed, multiply a putative relation by a common central polynomial
denominator. The resulting exponent pairs are distinct modulo n;
independence of Laurent monomials and of the A-basis proves that all
coefficients vanish.

These elements embed in the skew Laurent division ring
`A((x))((y;sigma))`, where sigma fixes A and sends x to zeta_n x.
Inverses there are obtained by factoring out a leading monomial and
inverting a series with constant coefficient 1. Their finite-dimensional
F-span is closed under multiplication and is a domain, hence is
division. Commuting first with A, then with x and y, shows that its
center is exactly F. After splitting A and adjoining n-th roots of
alpha,beta, clock-and-shift matrices give its matrix size dn.
This establishes the generic symbol-division step directly.

Pure central rational extensions embed in iterated central Laurent
division rings. A central Laurent extension of a finite-dimensional
division algebra is its Laurent-series division ring, by expansion
in a finite basis. These extensions therefore remain division.

Choose a basis b_j of the n-symbol algebra and independent central
c_ij, and evaluate

    P_i = epsilon sum_j c_ij b_j.

The resulting w(P) lies in a central division algebra of degree dn
over `k(alpha,beta,c_ij)((epsilon))`. Its minimal polynomial q_n is
irreducible, and is separable in characteristic zero. In a split
representation W(P) is consequently semisimple.

If e_n=deg(q_n), left multiplication on the division algebra has
characteristic polynomial `q_n^((dn)^2/e_n)`: view the algebra as a
vector space over the field generated by w(P). After splitting,
left multiplication acts on each of dn matrix columns by W(P).
Comparison gives the same multiplicity

    t_n = dn/e_n                                             (3)

at every root, and proves that t_n is a positive integer.

The split b_j are a basis of M_n. Their coordinate change to the
c_ij is invertible and independent of those coordinates. Thus this
is an ordinary small generic scalar-input evaluation. Injection of
`K[[P]]` by P=epsilon P^circ, and preservation of ranks of the
vectors `1,W,...` under field extension, identify these e_n and t_n
with those at the formal generic matrix point. No assertion about
arbitrary old-factor input matrices enters this identification.

### 3.2 Nonconstant roots, independent spectra and stable sizes

A nonzero homogeneous coefficient of q_0(w) is detected by its
successive labeled arrows on a directed path. Padding gives
`q_0(W_n(P)) != 0` at every generic size n>=n_0 for some n_0.

Suppose all c_ij-derivations killed one generic root. Their unique
extensions to a separable algebraic field commute with Galois
automorphisms. Irreducibility of q_n then makes them kill every
distinct root, hence every characteristic coefficient. The
epsilon^r coefficient of a characteristic coefficient is a homogeneous
polynomial of degree r in c_ij. In characteristic zero all its
partial derivatives can vanish only if it is constant; for r>0
it is zero. The characteristic polynomial would equal that of
w(0). Since W(P) is semisimple and q_0 is separable, this would
give q_0(W(P))=0, a contradiction.
The derivation-extension fact here is elementary: for a separable
minimal polynomial f of alpha, differentiating f(alpha)=0
forces `partial(alpha)=-(partial f)(alpha)/f'(alpha)`;
the nonzero denominator gives both existence and uniqueness.

Thus every root has a nonzero input differential. Derivations in
one independent input set kill roots of another, but cannot kill
one of its own roots in all directions. Independent generic
spectra are disjoint, and avoid the constant spectrum of w(0).
The coordinate change in 3.1 transports this statement to ordinary
scalar matrix entries.

Choose p>=n_0 minimizing the positive integer t_n, and set
`t=t_p`, `S={pM:M>=1}`. At a direct sum of M independent size-p
points there are M e_p distinct roots. The upper bound on generic
minimal-polynomial degree survives this specialization: it is
expressed by the zero `(e_(pM)+1)`-minors of the columns
`vec(1),vec(W),...,vec(W^e_(pM))`, and Section 2 evaluates these
entry identities. Hence `e_(pM)>=M e_p`. Minimality of t and (3)
give the opposite inequality. Therefore

    t_(pM)=t,       e_(pM)=M e_p=dpM/t.                     (4)

The same minor identities bound the minimal-polynomial degree by e_n
at every admissible specialization of size n in S, including over
a commuting Taylor fraction field.

### 3.3 Scalar Taylor branches and trace ranks

Let a commuting Taylor deformation have a split semisimple constant
term with e distinct roots and minimal-polynomial degree at most e.
Successive homogeneous changes of basis remove off-diagonal root
blocks: the equation between roots i,j is division by the nonzero
scalar lambda_i-lambda_j. The resulting blocks reduce to scalar
matrices lambda_i I.

Their characteristic polynomials have pairwise unit resultants,
so their minimal polynomials over the Taylor fraction field are
pairwise coprime. The minimal-polynomial degree of the direct sum
is the sum of their degrees. There are e nonempty blocks and the
sum is at most e; each degree is one. Every block is scalar,
with scalar in the Taylor ring itself. This proves scalar
branches without assuming simple roots of multiplicity one.

For completeness, the trace-rank assertions in `SPECTRAL9000201`
also follow. Trace derivatives and all their minors are admissible
entry identities. At a maximal-root-count point,

    d tr(W^j) = j t sum_h lambda_h^(j-1) d lambda_h.

For j=1,...,e_n the multiplier matrix is invertible by the
Vandermonde determinant and characteristic zero. Thus trace and
root Jacobians have equal rank there, and their generic rank
bounds specialize. No global-defect or linkage assertion is used.

## 4. Scalar responses and projected specialization

At a generic P of size n in S, Section 3.3 applied to P+xY gives

    pi_h W'_P(Y) pi_h = D_h(P;Y) pi_h.

Each D_h is a nonzero linear functional by Section 3.2. A finite
union of proper K-linear subspaces cannot cover the coordinate
direction space over the infinite field K. Hence a single
constant scalar-input direction v has D_h(P;v)!=0 for every h in I.

Take an independent generic Q of any size n' in S and scalar input
arrows U,V. Apply Section 3.3 to the commuting input

    [[P,xU],[yV,Q]].

At zero there are e_n+e_n'=e_(n+n') distinct roots, each of
multiplicity t. Either arrow alone gives triangular output with
unchanged diagonal spectrum, so the branch at P has no pure-x
or pure-y terms. Its xy coefficient is

    M_h = pi_h [ F - E_1 (W(Q)-lambda_h)^(-1) E_2 ] pi_h,
                                                               (5)

where E_1,E_2,F are the output blocks of the three-state chain
`[[P,U,0],[0,Q,V],[0,0,P]]`. Direct input paths give F.
Eliminating Q gives the term with the **minus** sign and the
displayed order. Other eigenspaces at P contribute nothing at xy:
their couplings within the P block have no constant or
first-order term under these off-diagonal perturbations.
The branch eigenspace is a graph, so its fixed-branch Schur
expression is zero; subtracting the branch xy coefficient from
(5) proves `M_h=m_h pi_h`.

At Q=0 the inverses in (5) exist since lambda_h is not a root of
w(0). Expand formally there. Define T_P as the span of loop
columns and all paired scalar coefficient tuples, for all allowed
partner sizes and coordinate arrows. It is a subspace of the
finite-dimensional space Omega_P^(e_n).

Scalarity of these formal paired expressions follows from generic
scalarity: clear the determinant and use the detection statement
of Section 2. For containment, apply any linear functional
annihilating T_P to the formal tuple. This gives the zero series.
After clearing the relevant determinants its bounded-coefficient
numerator remains zero under every admissible specialization.
If the specialized determinants are nonzero, divide back.

For a subset I, a functional annihilating T_P|_I extends by zero
outside I to one annihilating T_P. Thus only the determinants for
h in I need be cleared or inverted. This proves

    specialized (m_h)_(h in I) belongs to (T_P|_I) tensor E.    (6)

The same entrywise argument preserves scalarity. In particular,
the specialized partner need not itself have simple, disjoint,
or semisimple spectrum: only its selected resolvents must exist.
Taylor and Laurent specializations are legitimate by Section 2.
This proves the exact response prerequisites used below, without
the active-partition theorem, functional linkage or global relations.

## 5. A universal regularized-inverse lemma

Let M(xi) be a finite square matrix over E[[xi]]. Assume zero is
semisimple for M_0. Write V=K_0 direct_sum U_0 with
`K_0=ker M_0`, `U_0=im M_0`, and spectral projector Pi onto K_0.
Suppose

    G = Pi M'(0) Pi |_K_0

is invertible. In this decomposition M has blocks

    [[xi G+O(xi^2), O(xi)],
     [O(xi),       D+O(xi)]],        D=M_0|_U_0 invertible.

Its lower Schur complement has inverse, and the upper Schur
complement is xi G+O(xi^2). The inverse blocks therefore have
orders `[[>=-1,>=0],[>=0,>=0]]`, and the lower-right block has
constant coefficient D^(-1). In particular, this is a
**simple-pole** inverse, not just a nonzero determinant.

For any compatible regular couplings L(xi),B(xi) such that

    L(0) Pi=0,             Pi B(0)=0,                       (7)

their K_0 components both have order at least one. Multiplying
the four inverse blocks proves

    lim L(xi) M(xi)^(-1) B(xi) = L(0) J B(0),               (8)

where J is zero on K_0 and D^(-1) on U_0. The potentially
singular term has order at least `1-1+1=1`. The off-diagonal
terms also have positive order. No coupling-derivative residue
survives.

Now fix an idempotent e, put f=1-e, assume fM_0f is invertible
and `e:ker M_0 -> eV` is an isomorphism. For b=B(0)u, (7)
puts b in im M_0. All solutions of M_0 x=b differ by ker M_0.
Exactly one has ex=0, obtained by subtracting the unique kernel
vector with the same e-component. It is

    x = f (fM_0f)^(-1) f b.

Since L(0) kills ker M_0, all these solutions have the same
image under L(0). Comparing with Jb proves

    L(0) J B(0)
      = L(0) f (fM_0f)^(-1) f B(0).                        (9)

There is no equality asserted between J and the fixed-complement
inverse as operators. Equality is only asserted after the two
couplings are applied.

The universal graph and fixed-complement solution/sandwich part
of this argument is encoded in `Main.lean`. It does not encode
the Laurent-series limit in (8) or the spectral prerequisites.
The finite negative controls in `verify.py` show why one
annihilation alone and a nonsemisimple zero eigenvalue are
insufficient. These are counterexamples to weakened statements,
not to the manuscript.

## 6. Unfolding, semisimplicity and the two killed couplings

For ell=1 the Schur correction has order at least two. Only the
P-to-P input coefficient can contribute to the derivative compressed
by pi_h; at a block diagonal constant an excursion to C_0 and back
requires two positive-order insertions. Section 4 proves (1).

Let ell>=2 and fix omega. Number states 0,...,ell and substitute

    s_a -> sum_(j:omega_(j+1)=a) E_(j,j+1).

Tensor these scalar path matrices with the input identity.
This is a homomorphism from the free ring modulo degrees >ell
to upper-triangular block matrices. Its (i,j) block extracts
exactly the coefficient of the literal substring
omega_(i+1)...omega_j. It preserves every formal inverse with
invertible constant term, by the finite nilpotent inverse
recursion. Section 2 permits regrouping the evaluation of w
with this finite substitution.

First use R at every state. At the endpoints discard C_0 and
keep only P. This does not change the required compressed
coefficient. A path at an endpoint follows constant block
diagonal input until it changes state; constant output commutes
with pi_h. It cannot enter the first endpoint complement from
pi_h, or leave the last endpoint complement for pi_h. State
indices never decrease. Thus every complementary elimination
that matters occurs at an internal state. The same observation
discards the endpoint P-complements from the Schur calculation,
but not the internal ones.

Group the k=ell-1 internal states into Q_0. Its scalar input
size kN belongs to S. The cropped input has form

    T_0 = [[P,G_1,Y],[0,Q_0,G_2],[0,0,P]].

Let E_1,E_2,F be its output blocks. Fix h, put
`M_0=W(Q_0)-lambda_h`, let e be the sum of the k fixed target
projectors, and f=1-e. The block fM_0f is upper triangular
with invertible diagonal complements.

The Schur complement of fM_0f on e is zero. Its diagonal
blocks are zero; each strictly upper block is a proper-subword
coefficient of S_h(Z), so is zero by hypothesis. Gaussian
elimination consequently identifies the full kernel as

    u -> u-f(fM_0f)^(-1)fM_0 e u,       u in eV.             (10)

Its dimension is kt, and e restricted to this kernel is an
isomorphism. Triangularity gives algebraic multiplicity kt
for zero: each internal diagonal has its original rank-t
target eigenspace and C_0 has no target eigenvalue. Thus
geometric and algebraic multiplicities coincide, and zero is
semisimple. Other eigenvalues may have Jordan blocks.

Apply the identical argument to the prefix chain consisting of
the first endpoint and all internal states. All its substrings
have length at most ell-1, so its target kernel has dimension
`t+kt`. Write A_0=W(P)-lambda_h. For

    [[A_0,E_1],[0,M_0]],

a vector b in ker M_0 extends to a kernel vector exactly when
`A_0 x=-E_1 b` is solvable. Since A_0 is semisimple at zero,
this is equivalent to pi_h E_1 b=0. The kernel's dimension
is `t+dim{b in ker M_0: pi_h E_1 b=0}`. Its full value
t+kt forces this set to be all ker M_0. Hence

    pi_h E_1 Pi=0.                                          (11)

For the suffix chain the block matrix is
`[[M_0,E_2],[0,A_0]]`. Its kernel dimension t+kt similarly
forces E_2 pi_h to lie in im M_0. Semisimplicity of M_0 at
zero identifies im M_0 with ker Pi, giving

    Pi E_2 pi_h=0.                                          (12)

This establishes both couplings, using prefix and suffix
proper-subword equations, not merely the internal equations.

## 7. Regularization and the unchanged fixed complement

Choose the single scalar-input v from Section 4. In every internal
copy of R replace P by P+xi v, leaving C_0 and every arrow fixed.
Call the partner Q(xi) and put M(xi)=W(Q(xi))-lambda_h.
All output blocks, including E_1(xi), E_2(xi), F(xi), are in
E[[xi]] by Section 2.

Pi is upper triangular in the state order with diagonal equal
to the original target projectors. For example, since the zero
root is semisimple, its spectral projector is a polynomial in
M_0 separating zero from the other primary factors; a polynomial
of an upper-triangular block matrix remains upper triangular.
This works even if the other primary factors are nonsemisimple.
The graph map in (10) is also upper triangular with identity
diagonal on the target spaces.

In the graph coordinates, `Pi M'(0) Pi|ker M_0` has matrix
`e Pi M'(0) Gamma`, where Gamma is (10). It is upper triangular.
Every diagonal block is

    pi_h W'_P(v) pi_h = D_h(P;v) I_t.

The nonzero differential makes all these diagonal blocks
invertible. Section 5 therefore applies, including any
off-diagonal arrows and any root multiplicity.

Over E((xi)) the selected resolvents are now invertible.
The endpoint expression is

    E_h(xi)
       = pi_h [F(xi)-E_1(xi)M(xi)^(-1)E_2(xi)] pi_h
       = D_h(P;Y) pi_h
           + M_h(P,Q(xi);G_1,G_2).                         (13)

The second equality is a block-path identity: a path either
takes the direct endpoint arrow or visits the internal partner;
an upper-triangular path cannot do both. The arrows in this
identity remain scalar-input arrows.

By Section 4, after clearing only the target determinants,
the tuple in (13) is scalar and lies in
`(T_P|_I) tensor E((xi))`. No scalar-branch theorem is applied
at the resonant Q_0, nor is any inverse evaluated at xi=0.

Equations (11)--(12) give the two hypotheses (7), with
L=pi_h E_1 and B=E_2 pi_h. Equations (8)--(9) give the regular
limit

    pi_h [F-E_1 f(fM_0f)^(-1)f E_2] pi_h.                 (14)

Expression (14) eliminates exactly the **fixed internal**
complements that came from the unfolding. Section 6 identifies
it with `[S_h(Z)]_omega`. In particular, a group inverse is
not substituted into the original coefficient formula without
the sandwich argument (9).

For every h, scalarity in (13) is a finite collection of linear
entry equations. Membership in the fixed finite-dimensional
projected space is also a finite collection of linear equations,
with coefficients independent of xi. Taking constant
coefficients in these equations preserves them. All labels use
the same v and the same regularization, so this proves (1)
simultaneously, not just separate marginal containments.
The scalar coefficients themselves are regular: they are
`tr(E_h(xi))/t`, and t is nonzero in characteristic zero.

## 8. Commuting parameters

For a perturbation in finitely many commuting variables h_j,
substitute h_j=a_j z, with arbitrary scalar a_j and one free
letter z. All lower-degree Schur coefficients remain zero.
Sections 6--7 prove scalarity and projected containment of
the degree-ell coefficient on every such line.

Apply a scalarity entry functional, or any functional
annihilating T_P|_I. Its value is a homogeneous polynomial
in the a_j, zero for all a over the infinite field E. Every
monomial coefficient is zero. This proves the claimed result
for each homogeneous commuting coefficient, without
identifying a commuting coefficient with one particular
noncommuting word.

## 9. A division-faithful diagnostic family

The script's split matrices are not being offered as an arbitrary
matrix counterexample in place of a division-algebra example.
Here is the actual division family behind them.

Let u,v,r_0,s_0 be independent central variables and

    k = Q(mu_infinity)(u,v,r_0,s_0),
    A = (u,v)_2 tensor (r_0,s_0)_2,
    w = x z_1 + y z_2,

where x^2=u, y^2=v and yx=-xy in the first quaternion factor.
Applying the symbol-division argument of Section 3.1 twice,
with independent parameter pairs, proves that A is division
of degree 4 over this countable field with all roots of unity.
The second quaternion factor is a genuine division factor,
not an extra input-direction space.

In a splitting field choose a^2=u, b^2=v. Up to permutation
of tensor factors, x=a Z tensor I_2, y=b X tensor I_2,
where Z=diag(1,-1), X=[[0,1],[1,0]]. On inputs
`z_1=b Y_1`, `z_2=a Y_2`, division of the output by ab gives

    Z tensor Y_1 + X tensor Y_2,

with the old spectator identity I_2. This normalization
does **not** specialize u or v to 1. Its scalar input
coefficients remain in the permitted split field.

At size n the core has dimension 2n. It has 2n distinct
roots at Y_2=0 and generic diagonal Y_1, so the generic
root count is exactly 2n; the old spectator gives t=2.
Consequently all sizes are allowed, with p=1.

The invertible old-factor operator J=ZX anticommutes
with every core output, at every scalar-input size.
It sends the two size-one base roots to each other's
negatives and sends the corresponding first and paired
responses to their negatives. All paired tuples therefore
satisfy c_++c_-=0. A nonzero loop response shows

    T_P = {(c,-c):c in Omega_P}

at a generic size-one base. This proves the active space
of this example without appealing to the manuscript's
partition or linkage assertions.

The symbolic paired checks use the dominant coordinates
`(p_1,p_2)=(r(1-t^2),2rt)`, whose Jacobian is
`2r(1+t^2) != 0`. Their two entries are algebraically
independent; taking r=epsilon rho with independent
residues rho,t gives a genuine small generic base.
Its core roots are +/-r(1+t^2).

For the finite word calculations the script specializes
instead to the nondegenerate small base
P=epsilon(3,4) and C_0=epsilon(1,2). This is explicitly a
finite specialized diagnostic, not a generic-point proof.
The selected roots are +/-5 epsilon; the C_0 core has
characteristic polynomial T^2-5 epsilon^2 and hence avoids
both. Set

    H=I+K_1 s_1+K_2 s_2,
    Z_j=H R_j H^(-1) + homogeneous degree-ell error.

K_1,K_2 and every coefficient of Z_j are scalar input
matrices. The conjugacy makes all proper Schur coefficients
zero. The script computes those coefficients rather than
assuming this conclusion. It then extracts every length-ell
word for ell=1,2,3,4, crops its endpoints, and verifies the
fixed-complement formula. Internal projectors differ from
the fixed ones in 48 of the 60 label-word cases. Four cases
also compute the actual regularized inverse and its limit.
The rank-two old spectator is restored in a tensor check.

The separate four-dimensional algebraic model has a
nontrivial Jordan block at the **nonzero** complementary
eigenvalue, two internal zero modes, a nonspectral fixed
complement, compressed derivative [[1,5],[0,1]], and
varying endpoint couplings. Its exact regularized sandwich
limit is -595/4. It tests the general inverse lemma, not
the existence of a new source-faithful input construction.

## 10. Executable and formal evidence: exact scope

`verify.py` recomputes its exact arithmetic results and compares
them with `exact_certificate.json`; it does not merely check a
stored success field. Its finite and symbolic checks are
diagnostics for the universal proof above, not an induction
over all possible word lengths.

The finite checks include 44 proper-coefficient equalities,
60 leading scalar equalities, 60 cropped fixed-complement
equalities, 28 abelianized commuting-monomial equalities,
eight symbolic paired coordinate responses, and 12 exact
tail-valuation measurements through Taylor degree two.
The latter use three triangular blocks with diagonal
valuation 1 and upper-arrow valuation -2; their measured
tail valuations attain the proved lower bound in every
recorded sample. Neither the finite word range nor these
convergence samples replace the universal proofs.

From the campaign root, replay with

```sh
$WORKSPACE/argus-live-update/.venv/bin/python research/word_transfer/verify.py
```

The Engineer replay exited 0 against the persisted exact
certificate. This is not an independent Reviewer verdict.

The negative controls give limit 2 instead of fixed value
1 when only one coupling is killed. For the nilpotent
zero block [[0,1],[0,0]], regularization by xi I and
couplings xi(1,0), xi(0,1)^T give limit -1 despite
both zero-order couplings vanishing. Its inverse has a
double pole. Thus dropping semisimplicity is also invalid.
The actual manuscript does not drop either condition.

The recorded Jacobian call is
`matrix.symbolic.determinant.compute`, inspected before use.
Its exact payload and unmodified typed response are
`jacobian_payload.json` and `jacobian_output.json`. The adapter
reports server 0.14.0, protocol 2025-11-25 and a completed
Bareiss determinant `xi^2 (2+3 xi)^2`. The script binds the
response to the payload, independently recomputes the determinant
and checks the exact polynomial. This finite determinant
does not by itself prove a simple-pole inverse.

`Main.lean` formalizes the universal kernel graph and
fixed-complement solution/sandwich identity, for arbitrary
modules over a field. `statement_fidelity.md` names its
quantifiers, hypotheses and exclusions. Compiler evidence
was produced by the official claim-bound Lean producer:
Lean 4.31.0 exited 0, the axiom audit exited 0, and
`proof_holes=[]`. The archived certificate is
`certificates/certificates/WT-FIXED-COMPLEMENT9000201-deb7bc464c558bca.json`.
The full transfer theorem is **not** claimed kernel-formalized.

Independent review must read the universal proof as well as replay
the finite checks. No bounded no-witness search is being
submitted as completion of the campaign. Linkage, the compatible
global dual space, all-order correction, central descent,
generation restoration and the actual-center application remain
outside this result.
