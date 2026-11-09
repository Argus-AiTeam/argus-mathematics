# Finite deletion for genuinely adaptive evaluation kernels

## Result and scope

The dependence-sensitive mechanism in Section 3 of the staged OpenAI
manuscript is valid. In particular, conditioning on the deleted subset,
**not** on record stability, gives an explicit finite-pool error:

\[
 {\mathbb E}(\text{full-path bad fraction})
 \le {F(\ell-1)-F(\ell+T-1)\over T}
    +{D\over T}\sum_{t=\ell}^{\ell+T-1}{1\over n-t+1}
 \le {B_0-1\over T}+{D\over n-\ell-T+2}.                 \tag{1}
\]

Here \(D\) bounds the number of pool primes dividing any deleted-path
minor product. This is a general theorem, proved below, not an inference
from the finite computations. The manuscript's `B0/T + o(1)` follows
uniformly. The actual kernels and deterministic patches, including paths
whose expected dimension drops fail, meet the hypotheses.

The contribution relative to the prior project state (an untested
mechanism with no supporting claim) is an all-parameter finite bound,
a faithful application, and formal certification of the finite
incidence/averaging core. It does **not** certify the determinant cut,
counting tree, arithmetic/Hilbert inputs, large-prime tail, or quartic
density theorem. No false literal manuscript assertion has been found
in this scope; no `F_*` refutation is claimed. Independent review and any
claim of publishable novelty remain separate from this engineer's proof.

## Theorem 1: the finite deletion theorem

Let \(P\) be a set of \(n\) distinct primes. For every \(U\subseteq P\)
let \(R(U)\) be an integer with \(0\le R(U)<B_0\), and let
\(m(U)\ne0\) be an integer. It is enough to define these functions on
the levels \(\ell-1,\ldots,\ell+T-1\). Suppose, on every deletion edge,

1. \(R(U\cup\{q\})\le R(U)\), for \(q\notin U\);
2. equality in 1 implies \(m(U\cup\{q\})=m(U)\);
3. at most \(D\) primes of \(P\) divide \(m(U)\).

Let \(\ell,T\) be positive integers with \(m_*=\ell+T-1\le n\).
Sample \(t\) uniformly from this interval, a uniform \(t\)-subset \(B\)
of \(P\), and a uniform \(q\in B\). Put
\(F(s)=\binom ns^{-1}\sum_{|U|=s}R(U)\).
Then (1) holds. The first expectation is precisely the expected
fraction of primes of \(B\) dividing \(m(B)\).

**Proof.** Write \(U=B\setminus\{q\}\). For each \(t\), the map

\[
 (B,q)\longleftrightarrow (U,q),\qquad B=U\cup\{q\},
\]

is a bijection between the \(t\binom nt\) deletion pairs and the
\((n-t+1)\binom n{t-1}\) extension pairs. Each deletion pair has the
same probability \(1/(t\binom nt)\). Therefore \(U\) is uniform among
the \((t-1)\)-subsets, and, conditional on \(U\), \(q\) is uniform in
\(P\setminus U\). These assertions do not condition on stability.

On each edge the following deterministic inequality holds:

\[
 1_{\{q\mid m(B)\}}
 \le 1_{\{R(U)\ne R(B)\}}+1_{\{q\mid m(U)\}}
 \le R(U)-R(B)+1_{\{q\mid m(U)\}}.                    \tag{2}
\]

Indeed, on a stable edge the two integers are equal; otherwise the
nonnegative integer record increment is at least one. Adaptivity of
\(m(B)\) is unrestricted. By the conditional law just proved,

\[
 {\mathbb P}(q\mid m(U)\mid U)
 ={|\{q\in P\setminus U:q\mid m(U)\}|\over n-t+1}
 \le {D\over n-t+1}.                                \tag{3}
\]

Averaging (2) gives
\(A_t\le F(t-1)-F(t)+D/(n-t+1)\).
Summing over the \(T\) consecutive sizes telescopes exactly. The
record span is at most \(B_0-1\), and each denominator is at least
\(n-m_*+1=n-\ell-T+2>0\). This proves both inequalities. If \(D\)
exceeds a complement's cardinality the bound remains valid, merely
nonsharp. In particular, \(\ell=1\) and \(m_*=n\) are included. QED.

The formal graph version uses lower vertices \(U\) of size \(t-1\),
upper vertices \(B\) of size \(t\), incidence \(U\subset B\), and edge
label the unique prime in \(B\setminus U\). Row degree is \(n-t+1\)
and column degree is \(t\). Dividing `regular_deletion_step` by the
positive edge count gives exactly the preceding one-step inequality:

\[
 {c\sum_U R(U)-t\sum_B R(B)+|L_{t-1}|D\over |L_{t-1}|c}
 =F(t-1)-F(t)+D/c.
\]

This explains every sampler hypothesis used in the formalization; an
independence hypothesis is neither present nor supplied later.

## Theorem 2: the manuscript's actual paths satisfy the hypotheses

Fix \(z\), the other prime blocks, and the degree limits \(D_i\).
Run **all** \(r\) stages, even for exceptional or zero-dimensional
parents. Use precisely `eq:affine-evaluation-kernel`, and the first
covering patch in the fixed patch list of the entire intersection.
For a varying block \(B\subseteq P\), let

\[
 m_z(B)=\prod_{j=0}^r\Delta_j^{B}(z).
\]

These are not replaced by minors of a fixed variety or by independently
sampled integers.
Every factor is nonzero because its patch covers \(z\). Since the
labels are prime, \(q\mid m_z(B)\) is equivalent to \(q\) dividing at
least one of those factors, exactly the manuscript's bad-prime event.

### Kernel nesting and stability

Compare \(B\) with \(B\cup\{q\}\). Their initial patches agree.
Inductively, as long as previous codimensions agree, their parent
patches agree. The congruence modulus at the next stage is either
unchanged (before the affected block) or has acquired the extra prime.
Within the same parent its residue class is a subset of the old one.
Consequently the old evaluation kernel is a subspace of the new one.
Both lie in the same fixed vector space of degree at most \(D_i\).

Equal codimensions imply equal kernels. Equal kernels and equal parent
varieties give the same entire algebraic intersection, and hence the
same ordered patch list and first covering patch at \(z\). This uses
the actual convention after `lem:affine-patches`: the list is a function
of the input variety, its fixed degree allowance, and \(S\), with no
extra inspection of the primes. All equalities are equalities of
polynomial spaces and of their resulting inputs, not merely equality
of numerical ranks on unrelated parents.

Thus the first changed codimension can only decrease. Later entries
need not be separately monotone and are not assumed to be so. If the
complete vectors agree, the induction never stops, so every kernel,
patch, chosen Jacobian minor and evaluated integer agrees.

### Mixed-radix encoding

Put \(M_i=\binom{N+D_i}{N}\) and
\(w_i=\prod_{j>i}(M_j+1)\). The elementary identity

\[
 \sum_i M_iw_i=\prod_i(M_i+1)-1=B_0-1
\]

follows by expanding the product successively, starting with the last
factor. Each \(0\le\rho_i\le M_i\). If the first change is at \(k\),
the decrease in \(\rho_kw_k\) is at least \(w_k\); the largest possible
opposing change in the suffix is \(w_k-1\). Hence the integer encoding
decreases by at least one. Its range is \([0,B_0-1]\), and it is an
injective encoding of the vector. In particular equal encodings force
the equal minor products required by Theorem 1.

### Degree and height uniformity, without initial coefficient bounds

Here are the geometric and linear-algebra details behind the height
input, rather than a new assumption of prime independence.

At any step there are at most \(M_i\) generators of the kernel, all of
degree at most \(D_i\). Intersecting with their common zero set has
degree bounded in terms of the parent degree, \(M_i,D_i,N\), even if
some generators vanish on components. To see the relevant degree
fact, for an irreducible component use the homogeneous coordinate
ring of its projective closure. A nonzero homogeneous polynomial of
degree \(d\) is a nonzerodivisor, and the exact sequence
\(0\to R(-d)\to R\to R/(f)\to0\) gives the hypersurface-section bound
\(d\deg A\) from the leading Hilbert coefficient. Components contained
in the hypersurface are retained, not counted as proper cuts.
Iterating proves a bound for any fixed finite list of equations.

The other elementary degree bounds needed for patch descent follow in
the same way. The associated graded Hilbert series of the affine
product is the product of those of the factors, giving a degree bound
in terms of their degrees and ambient dimensions. Intersect that
product with the linear diagonal to bound the intersection of any two
bounded-degree sets; at each linear cut retain contained components
and apply the preceding proper-cut bound to the others. Finally, a
same-dimensional linear projection induces an injection of filtered
coordinate rings. Comparison of their leading Hilbert coefficients
shows that the image degree does not exceed the source degree.
These arguments are the degree inequalities used here; they do not
assume proper intersection of every pair of equations.

For completeness, the patch height construction then works as follows.
For a non-\(\mathbb Q\)-defined component \(A\), choose a
\(\mathbb Q\)-fixing automorphism \(\sigma\) with \(\sigma A\ne A\).
Every rational point on \(A\) lies on the proper, bounded-degree
intersection \(A\cap\sigma A\). Recurse in smaller dimension.
The descent criterion is justified by uniqueness of the reduced
row-echelon bases of the finite-dimensional degree pieces of the
ideal: invariance under all such automorphisms makes their
coefficients rational. The fixed field is \(\mathbb Q\), by algebraic
conjugacy and extension of automorphisms of a transcendence basis.

For a rational irreducible \(A\) of degree \(e\) and dimension \(h\),
choose \(h\) algebraically independent coordinate functions. Project
onto those and each additional coordinate in turn. Each image is a
hypersurface of degree at most \(e\). Its irreducible equation has
nonzero derivative in the additional coordinate in characteristic
zero. Lift the equations back. Their Jacobian in the \(N-h\)
additional coordinates is diagonal with nonzero generic determinant.
Thus equations of degree at most \(e\) have generic rank \(N-h\).

Evaluate **all** monomials of degree at most \(e\) on \(S\cap A\).
There are boundedly many columns, with entries bounded by a fixed
power of \(X\). Cofactors of a maximal nonsingular submatrix give an
integer spanning set of its rational nullspace with the same kind
of bound. This uses only bounded-size determinants, regardless of
the number of evaluation rows or the coefficients defining \(A\).

The ideal's degree-\(e\) piece is contained in that nullspace after
complexification. If containment is strict, one spanning polynomial
is not identically zero on \(A\); intersect with it and recurse
properly. Otherwise the bounded-height spanning polynomials give
the generic Jacobian rank just established. Choose a nonzero minor
and recurse on its zero set for uncovered points. A rational
zero-dimensional component containing an integer point is that
point, with equations \(x_l-z_l\) and minor \(1\).

Every recursive branch decreases dimension; all degrees, numbers of
components, and cofactor sizes are bounded in terms of the preceding
degree allowance and fixed dimension. This gives boundedly many
patches with polynomially bounded coefficients. Evaluating their
fixed-degree minors in the weighted box gives, for fixed constants,

\[
 1\le |m_z(B)|\le C_*X^{K_*}\le X^K \quad (X\ge2).     \tag{4}
\]

Increase the fixed \(K\) to absorb \(C_*\). The constants are uniform
in \(z\), every block, and all initial defining coefficients. Indeed
the input variety enters the height argument only through its degree,
not through its coefficient size. This is also why conditioning on
arbitrary other blocks causes no loss of uniformity.

The finite path length and the degree limits are fixed before the
small prime exponent \(\zeta\) is chosen. Thus \(K\) can be fixed
before \(\zeta\), rather than increasing with the prime choices.

### The explicit divisor budget

If distinct pool primes \(q_1,\ldots,q_s\), each at least \(X^\zeta\),
divide a nonzero integer \(m_z(U)\), their product divides its absolute
value. From (4),

\[
 X^{\zeta s}\le\prod q_j\le |m_z(U)|\le X^K,
 \qquad s\le K/\zeta.
\]

Hence one may take \(D=\lfloor K/\zeta\rfloor\) in (1). For a pool of
size \(n(X)\), the manuscript's error is explicitly bounded by

\[
 {\lfloor K/\zeta\rfloor\over n(X)-\ell-T+2}.          \tag{5}
\]

When \(\ell,T,\zeta\) are fixed and \(n(X)\to\infty\), this tends to
zero uniformly in the point and the other blocks. No event of record
stability has been conditioned on in obtaining this error. QED.

## An admissible stress family: why a tempting alternative proof fails

For any prescribed positive degree limits \(D_1,D_2\), choose \(L\)
larger than both, and more than \(L\) primes, all larger than \(L+1\).
Let \(Z=\mathbb A^2\), \(r=2\), \(z=(0,0)\), and

\[
 S=\{(0,0)\}\cup\{(pk,p^2k):p\in P,\ 1\le k\le L+1\}.
\]

 This family can satisfy even the full affine theorem's input
 hypotheses: take both coordinate weights, both \(\delta_h\), and the
 box constant to be 1. Every irreducible curve has a nonconstant
 coordinate, whose powers give \(H_A(T)\ge\lfloor T\rfloor+1\);
 the plane has \(H(T)=\binom{\lfloor T\rfloor+2}{2}\).
 Thus the Hilbert alternatives hold uniformly for all positive-dimensional
 subvarieties of \(Z\), without using the exceptional alternative.
 Choose \(0<\zeta<1/2\) and pool primes at most \(32X^\zeta\).
 After the degree limits and \(L\) are fixed, sufficiently large \(X\)
 makes every coordinate at most \(X\), every prime larger than \(L+1\),
 and the number of lines larger than \(L\). There is no circular choice
 of a box constant after choosing the cut degrees.

 Keep the second block empty and vary the first. With an empty first
block, any polynomial of degree at most either limit vanishing on
the points vanishes on each of more than \(L\) distinct lines, and
therefore is zero. Both parents remain the plane.

For a singleton block \(\{p\}\), its entire residue class consists
exactly of the points on \(y=px\), including the origin. There are
more points than either degree limit, so its evaluation kernels are
the degree-truncated ideals of that line. Choose its primitive
equation \(px-y\), with the first nonzero Jacobian column. The full
minor is \(p\); the deleted-path plane minors are \(1\). Thus

\[
 {\mathbb P}(q\mid m(B))=1,\qquad
 {\mathbb P}(q\mid m(B\setminus\{q\}))=0
 \quad (|B|=1).
\]

For blocks of at least two primes the class is just the origin.
All these are the actual full kernels and deterministic patches, not
invented adaptive integers. Their coefficients and points fit a
weighted box by taking \(\zeta\) sufficiently small; arbitrarily large
chosen degree limits do not remove the example. Full paths continue
even when a parent is exceptional, as required in the manuscript.
On the singleton deletion edge the first rank strictly changes, so
(2) remains true. This family refutes only the **alternative** idea
of treating a full-path minor as fixed when deleting a prime. The
manuscript does not make that assertion. The corresponding route is
retired in the ledger, not mislabelled as a manuscript refutation.

## Theorem 3: constant order and cumulative good products

Use the manuscript's \(h_i=r+1-i\),
\(E_h=\max_{h\le s\le r}\delta_s\), \(E_{r+1}=0\), and
\(a_i=E_{h_i}-E_{h_i+1}\ge0\). For any \(\epsilon>0\), the following
explicit choices are sufficient:

\[
 \begin{split}
 \gamma&=\min\{1,\epsilon/(16r(r+1))\},\\
 \xi&=\min\{1/4,\ \gamma/[4(E_1+r\gamma)],\
                    \epsilon/[16N(E_1+2r\gamma)]\},\\
 T&=\lfloor 8rB_0/\xi\rfloor+1,\qquad
 \zeta=\gamma/[2(T+1)],\\
 \ell_i&=\lceil(a_i+\gamma)/\zeta\rceil .
 \end{split}                                                     \tag{6}
\]

The order is important: choose \(\gamma\), then the successive degree
limits supplied by the residue-cut lemma and resulting \(B_0,K\);
then choose \(\xi,T,\zeta,\ell_i\); only afterwards enlarge \(X\).
In particular \(K,B_0\) do not depend on these late prime choices.
The assertion here does not independently prove the residue-cut lemma;
any fixed degree limits it supplies are allowed in Theorem 2.

Every allowed size satisfies

\[
 a_i+\gamma\le\zeta t_i
 \le a_i+\gamma+\zeta T\le a_i+2\gamma.               \tag{7}
\]

Let \(m_{\max}=\max_i(\ell_i+T-1)\) and
\(n_{\min}=\min_i |P_i|\). Take disjoint pools in
\([X^\zeta,C_rX^\zeta]\) and take \(X\) large enough that

\[
 {D\over n_{\min}-m_{\max}+1}\le {\xi\over8r},
 \qquad n_{\min}\ge m_{\max}.                         \tag{8}
\]

These conditions are possible with fixed \(\zeta,T,\ell_i,D\).
Here is an elementary justification of pool growth, so no unverified
prime-distribution citation is needed. Write
\(\theta(x)=\sum_{p\le x}\log p\). Primes in \((m,2m]\) divide
\(\binom{2m}{m}\le4^m\). Strong induction with \(m=\lceil n/2\rceil\)
therefore gives \(\theta(x)\le4(\log2)x\) for \(x\ge2\).
Also \(\binom{2n}{n}\ge4^n/(2n+1)\), whereas

\[
 \log\binom{2n}{n}\le\psi(2n)
 =\theta(2n)+\sum_{k\ge2}\theta((2n)^{1/k}).
\]

The sum on the right is \(O(\sqrt n\log n)\) by the upper bound.
Consequently \(\theta(x)\ge(\log2)x/4\) for sufficiently large real
\(x\). It follows that
\(\theta(32x)-\theta(x)\ge4(\log2)x\), and hence
\((x,32x]\) contains at least \(4(\log2)x/\log(32x)\) primes.
Partition these into \(r\) comparable pools. Each size tends to
infinity. Thus \(C_r=32\) is sufficient for fixed \(r\).

Sample blocks independently as in Theorem 1. Its bound is uniform
conditional on every choice of the other blocks, hence remains valid
after averaging those choices. For each fixed \(z\), Markov's
inequality and the union bound give

\[
 {\mathbb P}(z\text{ is not regular})
 \le {r\over\xi}
       \left({B_0-1\over T}+{D\over n_{\min}-m_{\max}+1}\right)
 < {1\over4} < {1\over2}.                            \tag{9}
\]

Here regular means that in each block at most a fraction \(\xi\)
divides **any** of its own full-path minors. Summing (9) over the
finite original set \(S\) gives a single block choice for which at
least half the points are regular. This does not select independent
minors, and does not change \(S\) in the evaluation-kernel definition.

For a regular point, in each of the first \(i\) blocks at least
\((1-\xi)t_j\) primes avoid its current parent minor, because they
avoid all its full-path minors. Distinctness across pools and the
lower prime size give the cumulative product bound

\[
 \prod_{\substack{q\in B_1\cup\cdots\cup B_i\\
                  q\nmid\Delta_{i-1}(z)}}q
 \ge X^{(1-\xi)\zeta\sum_{j\le i}t_j}
 \ge X^{(1-\xi)(E_{h_i}+i\gamma)}
 \ge X^{\delta_{h_i}+\gamma/2}.                        \tag{10}
\]

Indeed \(\sum_{j\le i}a_j=E_{h_i}\), and
\(\xi(E_{h_i}+i\gamma)\le\xi(E_1+r\gamma)\le\gamma/4\).
Earlier primes remain eligible even though they helped construct the
current parent; their adaptivity is exactly what Theorems 1-2 handled.
The auxiliary arithmetic error bounds also have the required order:
\(\gamma r(r+1)\le\epsilon/16\) and
\(N\xi(E_1+2r\gamma)\le\epsilon/16\).
These facts check the stated order of constant selection without
claiming a verification of the remaining counting tree. QED.

## Evidence, prior-art scope, and reproduction

`Main.lean` proves the edge indicator inequality, the arbitrary finite
regular-incidence inequality, and the all-parameter telescoping bound,
including the denominator \(n-\ell-T+2\). The precise boundary between
formal proof and the application above is in `statement_fidelity.md`.
Compilation must be performed with the official `lean_evidence` command
below; an uncompiled source file is not evidence.

The recorded real Lean 4.31.0 compilation has `exit_code=0`,
`proof_holes=[]`, and axiom-audit exit code 0. Its immutable claim
certificate is
`certificates/C_ADAPTIVE_FORMAL-4ccb75a212da5f7d.json`.
The source and fidelity document have not changed since that run.
This certifies `C_ADAPTIVE_FORMAL`, not the still-unreviewed application.

`verify.py` uses only Python's standard library and exact rational
arithmetic. It checks all 194 monotone records valued in \(\{0,1,2\}\)
on pools of sizes 1, 2 and 3, optimizing the bad-prime map on each
rank-stable connected component. For each record and interval the
objective is linear in that component's chosen prime indicators;
choosing the largest weights therefore maximizes over **every**
adaptive map with the specified divisor cap. It verifies 4,224 such
cases, including deletion at size one, the full-pool endpoint, and
zero divisor budget. These remain finite regression checks.
It also verifies that the official compiler result is successful,
hole-free and bound to the current source and fidelity bytes.

It also computes the actual rational evaluation kernels of the line
family in degrees 1, 2, 3, including every subset of each tested pool.
The Jacobian adapter independently computes rank 1 over \(\mathbb F_7\)
for the degree-two evaluation matrix of the \(p=7\) line after reducing
its points modulo 7. The rational rank is 3. This is a bad-reduction
cross-check, not evidence against the manuscript. The exact payload
and complete typed output (server 0.14.0, protocol 2025-11-25) are in
`jacobian_payload.json` and `jacobian_result.json`; the operation is
`prime_field.matrix.rank.compute`. The run succeeded without timeout
or structured adapter error.

Before developing the proof, a limited prior-art lookup found
Hanneke--Kontorovich, *Stable Sample Compression Schemes* (ALT 2021,
PMLR 132:697-721), whose primary abstract describes invariance after
deleting noncompression points:
<https://proceedings.mlr.press/v132/hanneke21a.html>.
That is contextual prior art, not a theorem used here and not an
established identification with (1). No novelty conclusion follows
from that lookup. A queried Guth lecture on Bezout covers a planar
bound and a special three-dimensional statement; it was **not** used
to support a general degree bound. An attempted Tao webpage lookup
returned 404. Instead the degree and prime-pool facts actually used
above have been derived explicitly. There are no imported research
theorems or unresolved external citations needed for (1).

Reproduce the exact arithmetic certificate from the campaign root:

```sh
python3 research/adaptive_prime_audit/verify.py
```

Reproduce the formal certification, placing its generated artifacts
inside this mission's owned directory:

```sh
$WORKSPACE/argus-live-update/.venv/bin/python \
  -m argus_skill.verticals.math.lean_evidence verify \
  research/adaptive_prime_audit/Main.lean \
  --statement-fidelity research/adaptive_prime_audit/statement_fidelity.md \
  --claim C_ADAPTIVE_FORMAL \
  --project-root campaigns/9000020 \
  --artifact-dir research/adaptive_prime_audit
```

For a potentially long compile use the operator's durable direct runner,
retain its receipt, and retrieve that task's result; do not edit the
source or fidelity document while verification runs. The Host's
independent Reviewer must read the proof, replay the certificate, inspect
the real compiler result and statement fidelity, and run both official
campaign-local checks. This engineer does not supply that independent
verdict or declare the campaign's publishable/novelty gate passed.

The artifact directory is deliberately the canonical source's directory.
Using a separate child artifact directory compiles an archived source
copy but leaves the original source without an adjacent compiler record;
the official project-wide Lean check correctly reports that original
as `lean_result_missing`. The canonical-directory run remedies that
recording issue without changing the theorem or its fidelity document.
