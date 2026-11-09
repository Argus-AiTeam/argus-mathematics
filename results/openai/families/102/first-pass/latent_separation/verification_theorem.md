# Quantitative verification of the latent separation mechanism

## Result and evidence boundary

The parameter-uniform algebraic obstruction in `lem:latent-generic` is true.
In particular, its quantification over **every** binary-linear extension
does not require selecting an extension before the subspace is randomized.
The common-extension and harmonic-potential arguments also tolerate the
adaptive dependence described in the manuscript. Below is a proof of the
latent lemma with an explicit finite-field genericity bound.

The new formal deliverable is stronger than a finite experiment:
`alignment/Main.lean` proves, for every dimension and every eligible set
of Boolean points, a nonzero polynomial obstruction that works under
specialization into **every commutative characteristic-two ring**.
Its degree bound is `6r+3`. Radical independence is proved, not assumed.
`Main.lean` separately certifies the parameter-uniform adaptive potential,
common linear extension, quotient descent, and detection-averaging theorems.

The complete finite-field construction and its probability interpretation
are proved in this document, not all encoded in Lean. In particular, no
compiler certificate is represented as a kernel proof of the full
existential statement `C_LATENT`, much less of Unique Games hardness.
Statement fidelity, novelty, significance, and acceptance remain questions
for the Host-invoked independent Reviewer. No false manuscript assertion
has been identified; no `F_` refutation claim is warranted by these results.

The only finite experiment is the separately labeled
`exact_certificate.json` checked by the top-level `verify.py`.
The parameter-uniform formal certificate and its compiler replay are instead
`alignment/exact_certificate.json` and `alignment/verify.py`.

## Precise verification theorem

Let

\[
 N_r=2^r-1,\qquad
 A_r=\binom{N_r}{2}+(6r+3)\binom{N_r}{3r+1},
 \qquad H_r=\sum_{j=1}^r\frac1j,
\]

with a binomial coefficient zero when its lower index exceeds its upper
index. For every integer \(r_0\ge1\), every rational
\(0<\epsilon<1\) satisfying \(H_{r_0}2^{r_0}\epsilon\le1\), and every
power \(q=2^d\) satisfying

\[
 3d\ge r_0,\qquad q^3\ge2N_{r_0},\qquad
 q\ge 2A_r/\epsilon\quad(1\le r\le r_0),
 \tag{1}
\]

the manuscript's quadratic atlas, recursion, and two quotients give the
following. Put

\[
 b=3d,\quad \theta=(q^2+q+1)^{-1},\quad
 s=\left\lfloor H_{r_0}/(8\theta)\right\rfloor,\quad r_*=b+2.
\]

For **every** \(\ell\ge r_*\), there exist a finite binary space
\(\mathcal V\) with an identified \(K=\mathbb F_2^\ell\), an equivariant
map \(C:\mathcal V\to K\), and rational noise \(\mu\), such that

\[
 \Pr[C(x+a)\ne C(x)]
  =(1-q^{-3})(1-\theta)^s
  \le \exp(1-H_{r_0}/8),
 \tag{2}
\]

for independent uniform \(x\) and \(a\sim\mu\). For every linear family
\(G\le\mathcal V^*\) with \(\dim(G|_K)\ge r_*\),

\[
 \Pr_{a\sim\mu}[\exists g\in G:\ g(a)\ne0]\ge3/16.
 \tag{3}
\]

Thus choosing \(r_0\) so that the last expression in (2) is at most an
arbitrary prescribed \(p>0\) proves the manuscript's original quantifier
order, with the stronger detection constant \(3/16\). All parameters in
(1) are chosen **before** \(\ell\). Conditions (1) are explicit sufficient
conditions; they are not necessary conditions or optimized dimension bounds.

### 1. Uniform genericity, with a quantitative error

Choose independent uniform \(T_{ij}\in F=\mathbb F_q\), and put
\(x_{ij}=T_{ij}^2\) and \(z_i(t)=\sum_j x_{ij}t_j\).
Squaring is a bijection of a finite characteristic-two field, so the
\(x_{ij}\) are again independent uniform elements. There is no conditioning
on an extension map here.

Fix a set \(E\) of more than \(3r\) distinct nonzero Boolean points.
Let

\[
 M_{t,(i,j)}=t_jz_i(t),\qquad
 c_t=\left(\sum_jT_{1j}t_j\right)
     \left(\sum_jT_{2j}t_j\right)
     \left(\sum_jT_{3j}t_j\right).
 \tag{4}
\]

Then \(c_t^2=z_1(t)z_2(t)z_3(t)\). On an injective parametrization,
arbitrary basis values of a binary-linear \(g:S\to F^3\) are precisely
the arbitrary \(F\)-coefficients of the columns of \(M\).
Consequently one such \(g\) aligns on all of \(E\) if and only if
\(c\in\operatorname{col}_F M\). This single membership condition accounts
for **all** extension maps, including maps chosen after seeing \(S\).

Here is the algebraic reason membership is exceptional. In the rational
function field \(\mathbb F_2(T_{ij})\), the \(r^3\) products
\(T_{1j}T_{2k}T_{3l}\) are independent over its actual subfield of squares.
Indeed, after taking square roots of square-subfield coefficients and
clearing one common denominator, a relation becomes a polynomial relation
whose summands have distinct exponent parity vectors. No two such parity
classes can cancel. `radicals/Main.lean` proves this argument for all
squarefree monomials, including the denominator-clearing step.

In the expansion of \(c\), the coefficient vectors of those products are
\((t_jt_kt_l)_{t\in E}\). If \(c\) belonged to the scalar-extended column
space, coefficientwise extraction would put every such vector in the
original column space. The extraction is valid even when column weights
lie anywhere in the larger field: extend each coordinate functional on
the independent radical span linearly to the entire extension.

Let \(V_h\) be the evaluation span on \(E\) of positive-degree Boolean
monomials of degree at most \(h\). Repeated indices among the cubic
monomials give all degrees one and two. Thus membership would imply

\[
 V_3\subseteq\operatorname{col}M\subseteq V_2\subseteq V_3.
\]

The common space is stable under multiplication by every coordinate.
It contains every positive-degree monomial, hence every point indicator:
start with a coordinate that is one at that nonzero point and multiply by
the remaining selectors \(t_i\) or \(1-t_i\). It is therefore all of
the function space on \(E\), contradicting \(|E|>3r\).
This argument and unrestricted coefficient extraction are proved in
`genericity/Main.lean`.

For completeness, passage to specialization does not require an
algebraic-geometric genericity convention. Work directly in the \(T\)'s.
The entries of \(M\) have degree at most two and \(c\) has degree at most
three. Choose \(h\le3r\) generically independent columns spanning all the
columns of \(M\). A nonzero augmented minor \(P_E\) has
degree at most \(2h+3\le6r+3\). Replacing its last column by any original
column gives the zero polynomial. These identities survive every ring
homomorphism, so specialized column membership forces \(P_E=0\),
even when the chosen generic basis loses rank on specialization.
`alignment/Main.lean` proves the actual-column instantiation, this minor
construction, degree bound, and specialization implication. No independence
or nonmembership hypothesis remains in its final theorem.

A nonzero polynomial of total degree \(D\) in \(n\) variables over
\(\mathbb F_q\) has at most \(Dq^{n-1}\) zeros. One self-contained proof
is induction on \(n\): expand in the last variable with highest exponent
\(k\). Its leading coefficient has degree at most \(D-k\).
At most \((D-k)q^{n-2}\) assignments kill this coefficient, and at most
\(k\) last-coordinate values are roots on every other assignment.
The resulting upper bound is at most \(Dq^{n-1}\).
The one-variable root bound follows by factoring off each distinct root.

There are \(\binom{N_r}{3r+1}\) potential sets \(E\) of the smallest
forbidden size. Hence the raw alignment-failure probability is at most
\((6r+3)\binom{N_r}{3r+1}/q\).

The random parametrization fails to be injective with probability at most
\(N_r/q^3\). For a pair of distinct nonzero Boolean inputs, their images
are independent uniform vectors in \(F^3\): these two inputs are
independent over \(F\). Their probability of field-linear dependence,
including zero images, is

\[
 q^{-3}+(1-q^{-3})q^{-2}\le q^{-1}\qquad(q\ge2).
\]

After a union bound over the pairs and conditioning on injectivity,
the fraction of nongeneric binary rank-\(r\) subspaces is at most

\[
 \frac{A_r}{q(1-N_r/q^3)}\le \frac{2A_r}{q}
 \quad\text{if }q^3\ge2N_r.                     \tag{5}
\]

Conditioned on injectivity the image subspace is uniform, since every
subspace has the same number of ordered binary bases.
Equations (1) and (5) establish the genericity estimate simultaneously
at every rank through \(r_0\), without any dependence on \(\ell\).

### 2. Block identities and the rank-loss estimate

Use the trace pairing on \(F^3\). With
\(Q(x)=(x_2x_3,x_1x_3,x_1x_2)\), let
\(D(x,a)=Q(x+a)+Q(x)+Q(a)\). For a field line \(A=Fv\) define

\[
 D_A=\{w:v\cdot w=0\},\qquad
 U_A=\{(a,Q(a)+w):a\in A,\ w\in D_A\}.
\]

The trace pairing is nondegenerate: the trace polynomial
\(\sum_{j=0}^{d-1}T^{2^j}\) is nonzero of degree less than \(q\), so
trace is not the zero function; multiplication by a nonzero scalar
then supplies a nonzero pairing with that scalar.

Direct expansion gives \(v\cdot D(x,tv)=0\) and \(D(tv,t'v)=0\).
Thus \(U_A\) is binary linear of dimension \(d+2d=b\).
The trace annihilator of \(D_A\) is \(A\). The three coordinate lines
give all horizontal coordinate directions and their vertical hyperplanes,
so the \(U_A\)'s span \(X\oplus B\).

For a linear extension represented by \((g(z),z)\), vanishing on \(U_A\)
first forces \(z\in A\). For nonzero \(z\), put \(A=Fz\); the remaining
condition, evaluated on \((tz,Q(tz))\), is

\[
 \operatorname{Tr}\bigl(t\,g(z)\cdot z+t^2z_1z_2z_3\bigr)=0
 \quad\text{for all }t.
\]

Trace invariance under squaring and nondegeneracy make this equivalent
to \(z\cdot g(z)=\sqrt{z_1z_2z_3}\).
For generic \(S\), each line therefore kills at most one dimension and
at most \(3r\) lines kill anything. A uniform line gives

\[
 \Pr[r_A<r]\le3r\theta,\qquad
 \mathbb E[H_r-H_{r_A}]\le3\theta.               \tag{6}
\]

For arbitrary \(S\), a loss requires the line of one of its nonzero
characters, giving probability at most \(2^r\theta\) and potential
loss at most \(H_r\). Both harmonic implications, with the actual
rational harmonic function, are formalized in `Main.lean`.

### 3. Exact nonlinear recurrence

At height zero take \(P_0=R_0=B\), \(C_0=\lambda_0=\mathrm{id}\).
Let the child index set contain every \((A,J)\), where \(J:B\to U_A\)
is a binary isomorphism. Recursively set

\[
 P_t=\prod_{A,J}P_{t-1},\quad
 (x,y)=\sum_{A,J}J C_{t-1}(u_{AJ}),\quad
 C_t(u)=y+Q(x).
\]

Inside the product of child shift spaces, let \(R_t\) consist of shifts
whose aggregate has zero horizontal component, and let \(\lambda_t\)
be its vertical component. Inductively,
\(C_t(u+h)=C_t(u)+\lambda_t(h)\).
The aggregate is onto because the \(U_A\)'s span; thus \(\lambda_t\)
is onto. This also makes \(C_t\) uniform on uniform input.

The noise chooses one uniform child at each level, and finally adds a
uniform symbol of \(B\). For a fixed child perturbation, its output
difference \(\Delta\) is invariant under every child shift, whereas
its initial output is translated by every element of \(B\).
Consequently the initial output is uniform conditional on both
\(\Delta\) and that perturbation. All other child outputs are independently
uniform. The full aggregate is therefore uniform conditional on
\((A,J,\Delta)\), and independent of \(J\Delta\).

The law of \(\Delta\) is independent of the selected child index because
all children have the same function and inner noise law. Conditional
on \(A\) and \(\Delta\ne0\), \(J\) remains uniform and \(J\Delta\)
is uniform on \(U_A\setminus\{0\}\).

On all of \(U_A\), the output difference of the block is uniform on
\(D_A\), hence nonzero with probability \(1-q^{-2}\). The zero
update, of mass \(q^{-3}\), never changes the output. Conditional on a
nonzero update the change probability is

\[
 (1-q^{-2})/(1-q^{-3})=1-\theta.
\]

It follows exactly that \(p_0=1-q^{-3}\) and
\(p_t=p_{t-1}(1-\theta)\). The preceding conditional statements,
not just a marginal uniformity claim, justify this recurrence.

### 4. Every lift has one common extension map

Fix a binary-linear family \(\psi_z\) on \(P_t\) restricting on \(R_t\)
to \(z\lambda_t\). A child shift in \(\ker\lambda_{t-1}\), supported
on that child, is a parent zero-translation shift. The child restriction
therefore factors through \(\lambda_{t-1}\).

On the space \(T=\prod_{A,J}B\) of child translations, subtract from
the sum of those child characters the character \(z\) of the aggregate
vertical component. The difference vanishes on the kernel of the
horizontal aggregate. Since that aggregate is onto \(X\), it factors
uniquely through one character \(\gamma_z\) on \(X\).
Uniqueness makes \(z\mapsto\gamma_z\) linear and common to all children.
Thus each outgoing domain is

\[
 S'=J^*\operatorname{im}\bigl[z\mapsto(\gamma_z,z)|_{U_A}\bigr].
\]

`Main.lean:common_extension_map` constructs this common linear family
from exactly the aggregate kernel compatibility, over arbitrary fields.
Choosing a linear section of the displayed image map gives a child lift.
Fixing a deterministic rule for such sections uses only the already
chosen path. No future noisy child or final symbol is inspected.

### 5. Adaptive rank survival

Conditional on the entire preceding path and the outgoing line \(A\),
the image inside \(U_A^*\), and hence its rank, is fixed before \(J\).
Uniform isomorphisms act transitively on rank-\(r'\) binary subspaces:
each target subspace has the same number of isomorphisms carrying a
fixed image to it. Thus the next domain is uniform conditional on its
rank, even though its induced lift may depend on the revealed \(J\).

By (5), the probability that a positive next domain is nongeneric is
at most \(\epsilon\). This is sufficient because (6) holds for every
extension map on a generic domain. There is no assertion that the
incoming orientation is independent of the subsequently induced lift.

Start the full lift on a fixed generic rank-\(r_0\) subspace and track
its image lifts. Put \(B_j=1\) for a positive nongeneric domain and
zero otherwise. The outgoing line is uniform conditional on the past, so

\[
 \mathbb E[\Delta_j\mid\text{past}]
 \le3\theta+H_{r_0}2^{r_0}\theta B_j,\qquad
 \Delta_j=H_{r_j}-H_{r_{j+1}}.
\]

At the root \(B_0=0\); at later levels \(\mathbb E B_j\le\epsilon\).
Hence \(\mathbb E\Delta_j\le4\theta\). Summing at the chosen depth
gives total expected loss at most \(H_{r_0}/2\). Extinction costs
\(H_{r_0}\), so it has probability at most one half.
At a surviving leaf, rank \(r_s>0\) detects a uniform independent
symbol with probability \(1-2^{-r_s}\ge1/2\).
Every surviving functional is a restriction of the original family.
Its detection probability is therefore at least \(1/4\).

`Main.lean:adaptive_rank_survival` proves this finite-process potential
argument with arbitrary joint path weights. Its hypotheses do not assume
independence of orientations, bad events, or induced lifts.

### 6. The first quotient and enlargement

Quotient \(P_s\) by \(\ker\lambda_s\) inside \(R_s\).
Equivariance makes \(C_s\) constant on these cosets, and
\(R_s/\ker\lambda_s\cong B\) realizes output translations as an
actual input subspace. `Main.lean:shift_kernel_descent` proves both
the descended function and injectivity of this translation embedding.
Uniform input pushes to uniform input because all quotient fibres have
equal size; pushing the noise preserves the change probability.

If \(G_0\le V_0^*\) restricts onto \(B^*\), choose a linear section of
restriction and pull it back to \(P_s\). It is a full lift, and
evaluation on the pulled-back noise equals evaluation on the pushed-forward
noise. Thus \(G_0\) detects with probability at least \(1/4\).

For \(\ell\ge b+2\), take one copy of \(V_0\) for every injection
\(L:B\to K\), and sum \(L\overline C\) as output. The translation
map \(\Lambda:\prod_L B\to K\) is onto: any nonzero vector of \(K\)
extends to the image of an injection. Quotient by its kernel inside
the product of shift spaces, exactly as before. Choose one uniform
copy and its base noise. Injectivity of \(L\) makes the change probability
exactly the base change probability, not merely an upper bound.

For a family of restriction rank \(r\), put \(S=G|_K\).
The family on copy \(L\) restricts to \(L^*S\) on \(B\).
Failure of surjectivity is equivalent to some nonzero \(b'\in B\)
satisfying \(Lb'\in S^\perp\). A uniform injection sends each fixed
nonzero \(b'\) uniformly to \(K\setminus\{0\}\), by the transitive
action of \(\mathrm{GL}(K)\). Therefore

\[
 \Pr[Lb'\in S^\perp]
 =\frac{2^{\ell-r}-1}{2^\ell-1}\le2^{-r},\qquad
 \Pr[L^*S\ne B^*]\le(2^b-1)2^{-r}\le1/4
\]

when \(r\ge b+2\). On the other copies detection is at least \(1/4\),
giving \(3/16\). The union and averaging implications are formalized
in `Main.lean`. No independence among the failure events is needed.

### 7. Quantifiers and effective choices

Choose \(r_0\) first, using divergence of \(H_r\).
Indeed, grouping the terms between successive powers of two gives
\(H_{2^n}\ge1+n/2\).
Choose, for example,
\(\epsilon=(H_{r_0}2^{r_0}+1)^{-1}\); then choose \(d\) by (1).
All are independent of \(\ell\). Since
\(s\ge H_{r_0}/(8\theta)-1\), (2) follows from
\((1-\theta)^s\le e^{-\theta s}\) and \(\theta\le1\).
Both quotients preserve the exact change probability, proving (2)
for the final gadget.

For rational \(p\), find an integer \(m\ge0\) with \(2^{-m}\le p\),
then an \(r_0\) with \(H_{r_0}\ge8(m+1)\).
All these tests, and (1), use exact integers and rationals.
The inequality \(e^{-m}\le2^{-m}\) verifies the desired real bound.
Enumerating finite binary subspaces finds a generic top domain because
(5) makes its fraction positive. All products, isomorphisms, injections,
quotients, function tables, and pushforward laws are finite and
deterministically enumerable. Their noise probabilities are rational.
This proves termination as well as existence. It does not claim that
the astronomical tables for small \(p\) were physically generated here.
Existence of a field of size \(2^d\) can be seen directly: in a splitting
field, the roots of \(T^{2^d}-T\) form a field, and its nonzero derivative
gives exactly \(2^d\) distinct roots. Finite field tables can therefore
also be found by exhaustive finite enumeration, without an unproved
algorithmic search assumption.

## What this improves and what it does not establish

The staged source supplies a qualitative genericity argument and an
existential choice of the field. The independent evidence now supplies:

* a zero-hole formal proof of actual radical independence, actual-column
  nonmembership, and a degree-bounded obstruction under arbitrary
  characteristic-two commutative-ring specialization;
* zero-hole, parameter-uniform formal proofs of the adaptive potential
  and the common-extension/quotient algebra;
* the explicit nongenericity estimate (5), which suffices to choose the
  field by the finite rational inequalities (1).

The exact finite example is not used to justify these universal statements.
No claim of literature-verified originality or publishability is made.
A targeted lookup did not locate an earlier statement of this exact
uniform alignment theorem; that is not proof of novelty. Attempts to
obtain the original Schwartz article were unsuccessful, so no unchecked
citation to that article is a proof dependency: the counting argument
used here is given above.

The downstream consequence is restricted to the latent interface:
in `04-matrix.tex`, high restriction-rank frequencies have eigenvalue at
most \(7/8\) because detection is at least \(1/8\).
Nothing here certifies the external inverse theorem, the reduction from
games, or any of the manuscript family's final hardness theorems.
