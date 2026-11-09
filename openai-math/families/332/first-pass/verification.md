# Sharp cubic flatness and stationary metric Markov cotype

## Result and scope

For every finite stochastic matrix A, every probability row vector pi with
pi A = pi (zero masses are allowed), every integer t >= 1, and every
x_1,...,x_n in real ell_1, the manuscript's construction satisfies

    sum_i pi_i ||x_i-y_i||_1^2
      + t sum_ij pi_i A_ij ||y_i-y_j||_1^2
    <= 504 sum_ij pi_i ((A+...+A^t)/t)_ij ||x_i-x_j||_1^2.       (1)

In particular N_2(ell_1) <= sqrt(504) = 6 sqrt(14). This improves the
staged manuscript's squared constant 3024 by a factor of six, without
changing its points y_i. The local flatness constant 18 proved below is
optimal among dimension-free constants for this cubic and potential.
Optimality of 504 as a cotype constant is NOT asserted.

The argument below is a universal mathematical proof, not an inference
from the finite examples in verify.py. The Lean source certifies the
dimension-free weighted flatness core; the matrix transfer and the
ell_1 reduction are proved here. Independent review is still required.

## 1. Sharp flatness

Let I be any finite set, w_i >= 0, u,v in [0,1]^I, and e in {0,1}^I.
Write

    phi(r) = 3r^2-2r^3,
    a = u-e, b = v-e,
    A = sum_i w_i a_i^2, B = sum_i w_i b_i^2,
    C = sum_i w_i a_i b_i,
    R = B^2-A^2-4A(C-A) = B^2+3A^2-4AC.

Then

    (sum_i w_i |phi(v_i)-phi(u_i)|)^2 <= 18 R.                (2)

For 0 <= x,y <= 1, factor

    phi(y)-phi(x) = (y-x) K(x,y),
    K(x,y) = 3(x+y)-2(x^2+xy+y^2).

Here

    K = 2x(1-x)+2y(1-y)+x(1-y)+y(1-x) >= 0,
    K <= 3(x+y).

Consequently |phi(y)-phi(x)| <= 3 |y^2-x^2|. For a bit e_i=1,
apply the same inequality to 1-x,1-y, using phi(1-x)=1-phi(x).
Thus, for either bit,

    |phi(v_i)-phi(u_i)| <= 3 |b_i^2-a_i^2|
                            = 3 |b_i-a_i| |b_i+a_i|.

Weighted Cauchy--Schwarz gives

    L^2 := (sum_i w_i |b_i-a_i| |b_i+a_i|)^2
          <= D S,
    D = A+B-2C = sum_i w_i (b_i-a_i)^2,
    S = A+B+2C = sum_i w_i (b_i+a_i)^2.

The decisive identity, valid for ALL real A,B,C, is

    2R - DS = (B-A)^2 + 4(A-C)^2.                            (3)

It proves DS <= 2R and hence (2). In the manuscript's notation,
C-A = <u-e,v-u>_H, so R is exactly its quartic Bregman
remainder, with no change in orientation or linear term.

### Sharpness of 18

Take two coordinates of weight one, e=(0,0),
u=(r,r), v=(r+d,r-d), with r=1/m and d=1/m^2 for integers m>=2.
All coordinates are in [0,1]. Direct calculation gives

    sum_i |phi(v_i)-phi(u_i)| = 12r(1-r)d-4d^3,
    R = 8r^2 d^2+4d^4 > 0,
    ratio = 4(3m^3-3m^2-1)^2 / (m^4(2m^2+1)) -> 18.

More explicitly, subtracting 18-36/m from the displayed ratio gives

    (18m^4+12m^3+24m^2+4)/(m^4(2m^2+1)) > 0.

For any proposed factor L<18, choose an integer
m>max(2,36/(18-L)); this particular rational example violates L.
Thus no asymptotic numerical inference is needed to choose a witness.
This is a sharpness theorem for (2), not a refutation of the
manuscript's valid factor 108.

### The manuscript's martingale corollary

For any martingale in the finite cube, with an initially measurable
binary center e, apply (2) to successive values. The gradient
4||M_m-e||_H^2(M_m-e) is bounded and measurable at time m.
Its pairing with the next martingale increment has expectation zero.
Summing finitely many inequalities telescopes the potentials.
The cube bounds every potential by (sum w)^2; bounded convergence
therefore applies to the terminal potential, and monotone convergence
to the nonnegative jump-energy sum. This proves the manuscript's
`cor:martingale`, indeed with 18 in place of 108. In the killed
stationary walk, the time-m expected jump is
p q^m B+q^{m+1}E_A. Summing the convergent geometric series gives
B+(q/p)E_A exactly, as in its `eq:jump-identity`.

## 2. Finite Green-matrix transfer

This section avoids an informal stopping-time argument altogether.
Let 0<p<1, q=1-p, and A be any n-by-n stochastic matrix.
The matrix H=I-qA is invertible: if Hv=0, choose a coordinate
with maximal |v_i| to obtain ||v||_infinity <= q||v||_infinity,
and hence v=0. Put K=H^{-1} and G=pK.

The inverse K is entrywise nonnegative. Indeed, if f>=0 and
v=Kf has a negative minimum v_i, then

    f_i = v_i-q sum_j A_ij v_j <= (1-q)v_i < 0,

a contradiction. Since H1=p1, K1=p^{-1}1, so G is stochastic.
Stationarity gives pi H=p pi, whence pi K=p^{-1}pi and pi G=pi.
No division by pi_i occurs, so zero stationary masses cause no exception.

For arbitrary binary vectors z_i in a finite weighted cube, define
h_i=sum_j G_ij z_j. Then h_i lies in the cube and

    h_i = p z_i + q sum_j A_ij h_j.                           (4)

Set

    b_i = ||z_i-Phi(h_i)||_{1,w}^2,
    e_i = sum_j A_ij ||Phi(h_j)-Phi(h_i)||_{1,w}^2,
    g_i = p b_i + q e_i.

For each fixed initial index r, put

    f_i^(r) = ||h_i-z_r||_H^4,
    d_i^(r) = ||z_i-z_r||_H^4.

Apply (2), centered at z_r, to h_i -> z_i with weight p and
to h_i -> h_j with weights q A_ij. The linear terms sum to zero
by (4). The result is the componentwise inequality

    g <= 18 [p d^(r) - (I-qA) f^(r)].                        (5)

Multiply (5) by the nonnegative row K_{r,*}, then sum in r
with weights pi_r. The identities KH=I and pi K=pi/p give

    sum_i pi_i b_i + (q/p) sum_i pi_i e_i
      <= 18 [sum_ri pi_r G_ri ||z_i-z_r||_H^4
                     - sum_r pi_r ||h_r-z_r||_H^4]
      <= 18 sum_ri pi_r G_ri ||z_i-z_r||_H^4.                (6)

All sums and all cancellations in (5)-(6) are finite. The same proof
works whenever a map and binary terminal values satisfy (2) with any
constant L, replacing 18 by L. It is not restricted to reversible A.

For comparison with the geometric law, the finite geometric identity is

    G = p sum_{s=0}^N q^s A^s + q^{N+1} A^{N+1} G.

The last matrix has row sums q^{N+1}, so it tends to zero.
Therefore G=p sum_{s>=0} q^s A^s. This proves the endpoint
interpretation without using stopping-time sampling.

## 3. Geometric-to-Cesaro comparison, including t=1

This argument works in any metric space. For a stationary A-chain set
D(s)=sum_ij pi_i (A^s)_ij d(x_i,x_j)^2 and D(0)=0.
The triangle inequality and Cauchy--Schwarz on the finite joint law
pi_i(A^r)_ij(A^s)_jk give

    sqrt(D(r+s)) <= sqrt(D(r)) + sqrt(D(s)).

For t>=1 put W=(D(1)+...+D(t))/t. Averaging
D(t)<=2D(r)+2D(t-r), 1<=r<=t, yields D(t)<=4W.
Writing s=jt+r, 0<=r<t, gives

    D(s) <= 2j^2 D(t)+2D(r).

For the geometric law P(S=s)=p q^s with p=1/(t+1),
q=t/(t+1), one has E S^2=2t^2+t. Consequently, with
J=floor(S/t), Remainder=S-tJ,

    E J^2 <= 2+1/t <= 3,
    P(Remainder=r) = p q^r/(1-q^t) <= 2/t.

The last inequality follows from (1+1/t)^t>=2, which follows
by retaining the constant and linear terms in the binomial expansion.
It follows that E D(Remainder)<=2W and

    sum_ij pi_i G_ij d(x_i,x_j)^2 = E D(S) <= 28W.           (7)

For t=1, Remainder=0 identically; all formulas above still apply.
There is no irreducibility, positive-mass, or reversibility hypothesis.
Boundedness of the finitely many distances justifies every geometric
sum; the displayed moments can alternatively be obtained by
differentiating a convergent geometric power series.

## 4. Reduction from arbitrary real ell_1 data

For finitely many x_i in real ell_1 define, for every coordinate k,

    v(k)=min_i x_i(k),
    b_B(k)=(min_{i in B}x_i(k)-max_{i not in B}x_i(k))_+

for all nonempty proper B subset [n]. These vectors belong to ell_1:
|v(k)| <= sum_i |x_i(k)| and 0<=b_B(k)<=2 sum_i |x_i(k)|.
Retain only B with w_B=||b_B||_1>0, and let z_i(B)=1_{i in B}.
There are at most 2^n-2 retained cuts. Define

    T(u)=v+sum_B u_B b_B.

At any coordinate k, list the distinct input values
alpha_1<...<alpha_m. The only positive b_B(k) are the gaps
alpha_{r+1}-alpha_r on upper threshold cuts
B={i:x_i(k)>=alpha_{r+1}}. Telescoping the gaps proves

    T(z_i)=x_i,
    ||x_i-x_j||_1=sum_B w_B |z_i(B)-z_j(B)|
                  =||z_i-z_j||_H^2,
    ||T(u)-T(v)||_1 <= sum_B w_B |u_B-v_B|.                 (8)

The sums over cuts are finite, so the passage to the countably many
ell_1 coordinates uses only sums of nonnegative absolutely summable
terms. If no cuts remain, all the input points coincide and (1)
holds with y_i=x_i. This includes n=1.

Otherwise use p=1/(t+1), h=Gz and y_i=T(Phi(h_i)).
Contractivity in (8) bounds the left side of (1) by the left side
of (6). The binary identity in (8) turns the right side of (6)
into at most 18 sum_ij pi_i G_ij ||x_i-x_j||_1^2.
Now (7) proves (1), since 18*28=504.

This proves the manuscript's complete real cotype conclusion with a
strictly better constant and the stronger stationary hypothesis.
The same real/imaginary coordinate map as in its complex corollary
gives squared constant 1008 for complex ell_1.

## 5. Evidence boundaries and prior work

The baseline being improved is the staged OpenAI manuscript
"Metric Markov Cotype Two of ell_1", October 5, 2026,
Lemma `lem:flat` (108), equation `eq:jump-identity`, and
Theorem `thm:main` (3024). We do not claim a new affirmative
answer to the question already answered by that manuscript.

A targeted literature search for the specific flatness factor 18
and squared cotype constant 504 located no matching independent
prior result. This is a bounded search outcome, not a proof of
global novelty; novelty and publishability remain for the independent
Reviewer to assess. The universal proof above is self-contained and
does not depend on a literature theorem.

## 6. Hilbert-to-ell_1 extension and the external assumption

The extension consequence uses Mendel--Naor, *Spectral calculus and
Lipschitz extension for barycentric metric spaces*,
arXiv:1301.3963v2 (20 May 2013), Theorem 1.11 and Corollary 1.13,
pp. 8 and 10; the published DOI is 10.2478/agms-2013-0003.
The primary PDF and an exact statement excerpt are retained in
`research/literature/`. Unlike a web search's erroneous generated
quotations of this source, the actual Corollary 1.13 says that,
under Theorem 1.11's hypotheses, a dual Banach target satisfies
e(X,Y) <= universal_constant * M_p(X) N_p(Y).
Theorem 1.11 requires the target to be W_p barycentric.

Every Banach space satisfies that additional hypothesis with constant
one: for a coupling (U,V) of two finitely supported probability laws,
||E U-E V|| <= E||U-V|| <= (E||U-V||^2)^(1/2).
Take the infimum over couplings. Moreover real ell_1 is isometrically
(c_0)^*: a bounded functional is represented by its coordinate
values a_k, and applying it to finitely supported signs proves
sum |a_k| <= ||functional||; density then gives the representation
and equality of norms.

For completeness Hilbert Markov type two with constant one follows
by restricting a reversible chain to the support of pi, which is
closed under its transitions. The Markov operator is a self-adjoint
contraction on the finite-dimensional weighted real Hilbert space.
For Hilbert-valued data only their finite-dimensional linear span
matters. In an orthonormal eigenbasis its endpoint energy is
2 sum_lambda (1-lambda^t)||coefficient_lambda||^2, with
-1<=lambda<=1. Since
1-lambda^t=(1-lambda) sum_{j=0}^{t-1}lambda^j <= t(1-lambda),
the defining Markov-type inequality holds with constant one.
Zero-mass indices contribute nothing.

Thus Corollary 1.13, together with (1), implies that any Lipschitz
map from any subset of any real Hilbert space into real ell_1
extends with a universal multiplicative loss. The absolute numerical
factor in that cited extension theorem is not computed here.
The primary-source applicability has been checked by the Engineer;
its independent citation attribution is explicitly left to the
Reviewer, rather than filed under a second name by the same reader.

## 7. Replay and limitations

Run `python3 verify.py` in the campaign root, using an interpreter
with SymPy installed. It independently recomputes the polynomial
identities and explicit sharpness threshold, checks the exact
Jacobian Gram payload against this particular flatness polynomial,
and replays the stored exact certificate. Its 7,500 cube cases and
109 rational stationary-chain cases are bounded adversarial tests,
not the justification for the universal quantifiers. They include
empty cuts, coincident points, singleton data, zero weights,
zero stationary masses, nonreversible chains, and t=1.

The official Lean replay is:

    $WORKSPACE/argus-live-update/.venv/bin/python -m \
      argus_skill.verticals.math.lean_evidence verify research/lean/Main.lean \
      --statement-fidelity research/lean/statement_fidelity.md \
      --claim C_FLAT18 --project-root .

The real compiler and axiom audit, not this Python script, establish
the formal core. The first compilation succeeded with no proof holes
but its ledger attachment was correctly refused because the initial
claim had not yet carried its formal source. That operational
binding issue is repaired by the authorized `revise-claim` command;
it is not a failed mathematical route or a manuscript refutation.
The source and its fidelity document are unchanged by that repair.

The subsequent official run recorded
`research/lean/certificates/C_FLAT18-8d53a7444ef039c8.json`:
Lean 4.31.0 compiler exit 0, axiom-audit exit 0, and
`proof_holes=[]`. The ledger derives `C_FLAT18=closed_kernel`.
Only the standard axioms `propext`, `Classical.choice`, and
`Quot.sound` occur. This does not certify the separate prose
matrix argument or inherit an independent fidelity judgement.

No false staged manuscript assertion has been established in this
route, so there is no invented `F_` refutation. All claims in the proof
graph remain unconfirmed until the independent Reviewer evaluates
the proof, statement fidelity, novelty, and citation applicability.
