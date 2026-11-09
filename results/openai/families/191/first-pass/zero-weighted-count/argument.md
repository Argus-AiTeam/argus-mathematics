# A uniform weighted zero-determinant estimate

## Statement and source scope

The assertion being checked is Proposition `zero:weighted-zero` in the
staged September 25, 2026 OpenAI manuscript:

> For the lattice $\Lambda$ and weight $W$ above, let $\mathcal Z$ be
> the set of integer $3\times3$ matrices whose columns belong to
> $\mathcal B$, whose rows belong to $\Lambda$, whose determinant is
> zero, and whose three projected columns are pairwise distinct. Then
> $\sum_{A\in\mathcal Z}W(A)\ll\log(2N)N^6/I^2$.
> The implied constant is independent of the fixed digit matrix $C$.

Here $B$ is prime, $h=B^k\ge2$, and the reduction of $C$ modulo $h$
has a unit entry and Smith exponents $(0,b,e)$, with
$0\le b\le e\le k$. Put $D=B^b$, $E=B^e$, $I=DE$, and let $\Lambda$
be the inverse image of the **row** span of $C$. Also $H=h^2$,
$h^{100}<q\le2h^{100}$ with $q$ prime, and $N=(hq)^{10}$.
The box is $[0,N)^2\times[N,2N)$, with integer coordinates.

The auxiliary definitions are those of Section 5: $w=\lfloor
q/(1000H^2)\rfloor$, a fixed cap $S\subset[0,w)^3$ of size $s\ge
w^3/q$, an allowed shift $a$, and a uniform invertible $G$ over
$\mathbb F_q$. Set $V=G(a+S)$ and
$W(A)=(q^3/s)^3\Pr(A_{\cdot1},A_{\cdot2},A_{\cdot3}\bmod q\in V)$.
The probability includes repeated columns; it is not the probability of
three independent choices of $V$.

The proof below establishes the assertion with the explicit absolute
constant $K=10^{33}$. In fact it works for every integer $N\ge1$ and
every main-modulus matrix with a unit entry, not only digit matrices,
and only needs $q\ge h^{26}$ in place of $q>h^{100}$.

Scope findings: the sources read were manuscript Sections 1--8, particularly
`orb:diagonal`, `lat:plane-count`, `lat:plane-covolume`,
`aux:random-set`, and `aux:weights`. Their needed inputs are proved
below, rather than treated as unchecked literature theorems.
No relevant page was found in the supplied project Wiki index.
The upstream source contains a separate logarithmic zero-count theorem
`Problem355.ZeroGlobalCount.weighted_count_le_log`; the log-squared
`UniformFixedFiberCount.matrix_fiber_le` is not a substitute for it.
Upstream statement and axiom fidelity are separate from the elementary
proof below. No false manuscript assertion is claimed by this argument.

## 1. Main-modulus algebra and plane geometry

Elementary invertible row and column operations over $\mathbb Z/B^k$
give $C=P\operatorname{diag}(1,D,E)Q$. A unit is the first pivot;
in the remaining block select a nonzero entry of smallest $B$-adic
valuation, clear its row and column, and repeat. A zero remaining block
gives $b=e=k$; no division by a nonunit is used.
The row module has $h^3/(DE)$ elements and contains
$E(\mathbb Z/h)^3$, even when a diagonal entry is zero modulo $h$.
Consequently $[\mathbb Z^3:\Lambda]=I$ and $E\mathbb Z^3\subset\Lambda$.

For primitive $x\in\mathbb Z^3$, write $x\cdot\Lambda=g(x)\mathbb Z$
and $L_x=\Lambda\cap x^\perp$. Bezout's identity and the containment
just proved show $g(x)\mid E$. Choose $u\in\Lambda$ with $x\cdot u=g(x)$.
The map $v\mapsto x\cdot v/g(x)$ splits by $1\mapsto u$, so a basis
of $L_x$ together with $u$ is a basis of $\Lambda$. Comparing volumes,
with height $g(x)/|x|$, gives

$$J_x=\det L_x=\frac{I|x|}{g(x)},\qquad
 \frac{g(x)^3}{I}\le\frac{E^2}{D}\le h^2. \tag{1}$$

Primitivity implies $\bar x\ne0$ modulo **every** prime, without a
size hypothesis. The reduction of $\mathbb Z^3\cap x^\perp$ maps
onto $\Pi_x=\bar x^\perp$: if $x\cdot z=1$ and a lift $v$ satisfies
$x\cdot v=qa$, replace $v$ by $v-qaz$. Multiplication by $E$ is
invertible modulo $q$, so $L_x$ also maps onto $\Pi_x$.

For completeness, a rank-two Euclidean lattice $L$ with two independent
vectors of length at most $T$ has at most $9\pi T^2/\det L$ points
in a ball of radius $T$. Choose successive shortest independent vectors
$v_1,v_2$. Their fundamental parallelogram has diameter at most $2T$.
For each coset of their span in $L$, attach these disjoint parallelograms
to the points being counted; they lie in a disk of radius $3T$.
Sum their areas, then sum over the cosets. This proof allows arbitrarily
skew lattices and needs no unproved successive-minima estimate.

Thus, if $\Gamma\subset L_x$ has index $m$, the number of ordered
triples of its vectors of length at most $4N$ and spanning a plane is at
most

$$C_{\rm row}\frac{N^6}{(mJ_x)^3},
 \qquad C_{\rm row}=576^3. \tag{2}$$

Indeed, existence of such a triple implies the second successive minimum
is at most $4N$, after which each row has at most $144\pi N^2/(mJ_x)
<576N^2/(mJ_x)$ choices. If no such triple exists the bound is automatic.
This last observation is essential: a rank-one set of short lattice
vectors is not bounded by the plane-area term, but is never counted here.

## 2. A uniform null-vector moment

For every real $R\ge h$,

$$\sum_{\substack{x\ {\rm primitive}\\R\le |x|<2R}}g(x)^3
 \le250R^3 I. \tag{3}$$

To prove it, for $0\le j\le e$, the condition $B^j\mid g(x)$ is
equivalent to $Cx=0\bmod B^j$. This uses the **right** column $x$
against the row lattice, not a left null vector. In Smith coordinates
the number of solutions modulo $B^j$ is
$B^{3j-j-\max(j-b,0)}$. The third diagonal entry imposes no condition
because $j\le e$, including $e=k$.
Each residue class contributes at most
$(4R/B^j+1)^3\le125(R/B^j)^3$ vectors of norm less than $2R$.
Discarding primitivity only increases this count. Since $g=B^a$,

$$g^3\le\sum_{j=0}^e B^{3j}{\bf1}_{B^j\mid g}.$$

The resulting sum is bounded by
$125R^3\sum_{j=0}^eB^{2j-\max(j-b,0)}\le250R^3B^{b+e}$:
the last exponent is $b+e$ and consecutive exponents increase by
at least one. This proves (3) uniformly in $B,b,e,k$ and the
orientation of $C$.

## 3. Exact auxiliary normalization and constants

The cap exists by intersecting a translate of
$(u,v,u^2-\nu v^2)$, with $\nu$ a nonsquare, with $[0,w)^3$.
Its quadratic restriction to a nonvertical line has nonzero leading
coefficient, and a vertical line meets it once. Averaging translates
gives $s\ge w^3/q$.

The assumption $q\ge h^{26}$ implies $q\ge2000H^2$ for $h\ge2$,
so $q/(2000H^2)\le w$. Define $L=2000^3$. Then

$$s\ge q^2/(Lh^{12}),\qquad U=q^3/s\le Lqh^{12}. \tag{4}$$

For an unrestricted uniform shift, the probability of violating the
allowed-shift test at any $1\le m\le3H$ is at most
$3H(6Hw+1)/q\le18/1000+3/(2000H)<1/2$.
Here $3H<q$ and $3Hw<q/2$, so multiplication by $m$ permutes the
field and the count of forbidden residues is valid. Conditioning on
the allowed shifts therefore increases every probability by at most two.
It also excludes zero from $a+S$.

An allowed shift excludes any nonzero relation of Euclidean norm at
most $H$ whose integer coefficient sum is nonzero, by looking at the
first coordinate. A zero-sum relation among three distinct cap points
is excluded by affine independence: its coefficients are not all zero
modulo $q$, since $H<q$.

The affine group has $q^3(q^3-1)(q^3-q)$ ordered affinely independent
triples; $S$ has $s(s-1)(s-2)$ such triples. For two independent
target columns, their inverse images under a uniform invertible linear
map range over $(q^3-1)(q^3-q)$ ordered independent pairs. For one
nonzero target column they range over $q^3-1$ nonzero vectors.
Multiplying these probabilities by $q^9/s^3$, with the factor two only
where conditioning is needed, gives the following explicit bounds:

$$W\le4\quad\hbox{on affine-independent triples},\qquad
 W\le2U\quad\hbox{at rank at least two modulo }q,\qquad
 W\le2U^2\quad\hbox{always}. \tag{5}$$

For example $(1-q^{-3})(1-q^{-2})\ge21/32$ for $q\ge2$,
so the first constant can be $64/21<4$ and the second $32/21<2$.
The last uses $(1-q^{-3})^{-1}\le8/7<2$.
The support is affine-independent triples or triples with an equal
pair, and all columns on the support are nonzero.
These calculations include all-equal triples and linear rank one.

## 4. The four shell contributions

Every matrix being counted has rational rank exactly two: a nonzero
column cannot be proportional to another column with a different
projection. Its right nullspace has a primitive integer generator $x$,
unique up to sign. No coordinate of $x$ is zero, since otherwise two
columns would be proportional. The cross product of two independent
rows gives $|x|\le16N^2$. Both signs may be counted for an upper bound.

Split $x$ into dyadic shells $R\le |x|<2R$, $R=1,2,4,\ldots$.
For a fixed $x$, (1)--(2) give

$$\#A\le C_{\rm row}
 \frac{N^6g(x)^3}{m^3I^3R^3} \tag{6}$$

when the rows satisfy an index-$m$ sublattice condition.

**Affine-independent residues.**
By the short-relation exclusion, $|x|>H$, so a contributing shell
has $R>H/2\ge h$. Equations (3), (5), and (6) give a contribution
at most $1000C_{\rm row}N^6/I^2$.

For the other cases, select an equal pair $i<j$ and set
$\delta=\mathbf e_i-\mathbf e_j$. Summing over the three pairs is
an upper bound even when all three columns coincide.

**An equal pair with an independent row equation.**
If $\bar x\notin\mathbb F_q\delta$, the functional
$v\mapsto v_i-v_j$ is nonzero on $\Pi_x$; its kernel in $L_x$
has index $q$, by surjectivity. There are at most $125R^3$ integer
vectors in the shell. Use $g^3\le Ih^2$, $m=q$, and $W\le2U^2$.
For each pair the result is at most

$$250C_{\rm row}L^2\frac{h^{26}}q\,\frac{N^6}{I^2}. \tag{7}$$

This includes every possible rank modulo $q$.

**An equal pair without an independent equation, rank at least two.**
If $\bar x\in\mathbb F_q\delta$, the coordinate outside the pair is
a nonzero multiple of $q$. Thus $|x|\ge q$ and $R>q/2$.
There are $q-1$ nonzero residue classes along this line. Each contains
at most $(4R/q+1)^3\le216R^3/q^3$ vectors in the ball, hence at
most $216R^3/q^2$ possible normals. Use $m=1$ and $W\le2U$.
For each pair the contribution is at most

$$432C_{\rm row}L\frac{h^{14}}q\,\frac{N^6}{I^2}. \tag{8}$$

The nonzero-coordinate condition is why no short exceptional normals
were lost at this step.

**The same exceptional normals, rank at most one.**
The row space modulo $q$ lies in one of the $q+1$ lines of the
two-dimensional plane $\Pi_x$. The zero row space is covered too.
Each preimage line has index $q$ in $L_x$; thus their total count
is at most $(q+1)C_{\rm row}N^6/(q^3J_x^3)
\le2C_{\rm row}N^6/(q^2J_x^3)$.
Using the sparse-normal count, $g^3\le Ih^2$ and $W\le2U^2$,
the contribution for each pair is at most

$$864C_{\rm row}L^2\frac{h^{26}}{q^2}\,\frac{N^6}{I^2}. \tag{9}$$

No rank-two-modulo-$q$ hypothesis was smuggled into this case: only
the rational row rank is two. Overcounting zero row spaces in several
lines is harmless.

Since $q\ge h^{26}$, each remaining power quotient in (7)--(9)
is at most one. Including the three equal pairs, the contribution of
one shell is at most

$$C_{\rm row}(1000+3342L^2+1296L)\frac{N^6}{I^2}. \tag{10}$$

Finally the number of shells with $R\le16N^2$ is at most
$5+2\log_2N\le8\log(2N)$ for $N\ge1$.
The elementary inequality $\log2>5/8$ follows, for example, by integrating
$1/t$ on the four equal subintervals of $[1,2]$ and using the
right endpoint lower sums. Direct integer arithmetic gives

$$8\cdot576^3(1000+3342\cdot2000^6+1296\cdot2000^3)<10^{33}.$$

Combining this with (10) proves the stated uniform bound. The actual
manuscript parameters are a subset of the hypotheses, not a proxy
parameter regime used in place of them.

## 5. A simpler, rank-free alternative

The following stronger auxiliary estimate explains the distinct proof
organization used in the formal certificate:

$$p_i\ne p_j\quad\Longrightarrow\quad W(p_1,p_2,p_3)\le4U. \tag{11}$$

It does **not** require that the two columns be linearly independent.
Under an unconditional affine map, an ordered distinct pair is uniform
among $q^3(q^3-1)$ pairs. Conditioning on allowed input shifts costs at
most two, and requiring the third inclusion only reduces probability.
Consequently the weight is at most
$2q^6/(s(q^3-1))\le(16/7)U<4U$.
This is also the upstream formal theorem's pair estimate, so it is not
claimed as a new literature result.

If all three residue columns are equal, choose an equal pair whose
$\delta$ is not parallel to $\bar x$: the coordinate differences for
pairs $(1,2)$ and $(1,3)$ are independent over every field, so such a
pair always exists. This assigns all-equal triples to (7), with the
general weight bound and an index-$q$ row equation.

The remaining exceptional equal-pair triples have at least two distinct
residue columns and satisfy (11), whether their linear rank modulo $q$
is one or two. The sparse-normal argument then gives (8) with coefficient
$864$ instead of $432$, and no low-rank line subdivision is needed.
This gives an independent three-case proof of the same single-log
estimate. It is not an assumption that the troublesome low-rank count
already holds.

## Certification boundary

The preceding is an infinite-parameter proof, not a finite experiment.
The accompanying exact verifier checks the stated constant arithmetic,
the symbolic dependence of all four cases, and explicit boundary fixtures.
Those finite checks do not on their own certify lattice point counting,
the cap construction, or a novelty claim.
Any Lean certificate is to be read with its separate statement-fidelity
document. Independent Reviewer approval is not asserted here.

The finite Gram example uses rows $(1,1,1)$ and $(1,3,2)$, with primitive
normal $(1,1,-2)$ and squared covolume $6$. It illustrates a plane for
which $g=h$, $I=h$, so the pointwise loss $g^3/I=h^2$ really can occur.
It is a structural fixture, not a purported counterexample satisfying all
digit-construction parameters. The exact Jacobian response is preserved;
its `covolume_rational` metadata is not used in any inference.

Replay with `python3 research/zero-weighted-count/verify.py`. A full
dependency replay uses `--rebuild-upstream` and should be submitted through
the host's durable runner if it may exceed two minutes. The exact
certificate separates the finite arithmetic fixtures from the universal
Lean theorem and makes no novelty or campaign-completion claim.
