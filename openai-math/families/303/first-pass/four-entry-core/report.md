# Four-entry avoidance: independent mathematical verification

## Scope and source

The target is Proposition `prop:four-avoidance` in the staged September 25,
2026 manuscript, together with `lem:actual-range` and its interface with
Proposition `prop:graph`. All algebras are complex, possibly nonunital and
nonseparable. Property (P) means that every positive element, including every
scalar spectral cutoff, satisfies `a direct-sum a <=_Cu a`; zero is allowed.
No exactness, nuclearity, or closed-range assumption is available.

The proposition asks for four contractions in `Her((X-1/32)_+)` excluding
*every* representation with `||pi(X)|| > 1/4` and `pi(B_i)=pi(T_i)`.
The measurements are fixed before the four contractions are chosen. The
graph proposition has precisely this order of quantifiers, with `k=4`.

The initial source reading identifies the following genuinely separate
obligations: cutoff transport with algebra membership and represented norms;
actual-range, rather than closed-range, positivity; directed finite tests
over an arbitrary algebra; passage of only fixed elements to a norm
ultraproduct; irreducible detection of a nonzero cutoff; reconstruction of
the fixed compressed defect; and the final two-column contradiction.
Successful compilation of algebraic identities alone would not settle
these analytical obligations.

Finite-dimensional matrix searches cannot refute the proposition: no
nonzero finite-dimensional C*-algebra has property (P), by rank monotonicity
of Cuntz comparison. Such matrices may test identities but cannot supply an
admissible nonzero witness. This route is retired, not counted as evidence
for avoidance.

## Prior results and dependencies

The manuscript gives a self-contained cutoff-transport proof in
`foundations.tex`, Lemma `lem:transport`, and a proof of proper-target
ideal comparison in Lemma `lem:comparison-rules`(iii). These will be checked,
not assumed equivalent to the target. Standard continuous and bounded
Borel functional calculus, polar decomposition in the bidual, and
irreducible representations separating positive elements are the remaining
operator-algebra foundations. Exact source locators and independent
citation attribution remain outstanding at this scope checkpoint.

The scaling-element citation is explanatory, not needed as a black box:
the proof can derive the isometry and its nonzero defect directly. No
novelty claim is made for that construction or for the manuscript's
four-entry proposition. The intended contribution is an independent,
source-faithful universal verification, with a formal noncommutative core
and an explicit account of the analytical interfaces.

## Verification theorem

**Theorem.** Let C be any complex C*-algebra satisfying (P).
Fix `0 <= a0 < a < beta < s` and `0 < h < 1`. For every positive
X in C and every four elements B_i in C, there exist contractions
T_i in `Her((X-a0)_+)` for which no representation simultaneously has
`||pi(X)|| > s` and `pi(B_i)=pi(T_i)` for all four i.
The auxiliary defect cutoff may be any `0 < theta < 1`.

The manuscript is the instance
`(a0,a,beta,s,h,theta)=(1/32,1/16,1/8,1/4,1/2,1/2)`.
The proof below verifies the entire construction, not merely a
finite collection of identities. Its kernel-certified part is the
universal algebraic obstruction specified in `statement_fidelity.md`;
the functional-analytic parts are mathematical proofs requiring review.
The arbitrary constants are an elementary extension, not a claim of
independently established publication-level novelty.

### 1. The actual-range lemma, including its boundary

For positive bounded operators x,Q put U=xQ^2x. On the spectrum of U,
the Borel function f(t)=1/t for t>eta and zero otherwise is bounded
by 1/eta. For z in the spectral subspace `(eta,infinity)` of U,
`z=U f(U) z=xQ(Qx f(U)z)`. This is an actual-range factorization,
with no passage to its closure.

If z=xQw and Qz=0, then
`0=<QxQw,w>=||x^(1/2)Qw||^2`; hence xQw=0 and z=0.
Both positivity of x and strict positivity of eta are used.
The statement does not assert that xQ has closed range.

For clarity, replacing the actual range by its closure really can
destroy the statement, even for bounded positive operators.
On `ell^2(N>=1) direct-sum C`, let Q be projection onto the first
summand and set

```
x(f,t) = ((4^(-n)(f_n+t))_n, sum_n 4^(-n) f_n + t).
```

This is bounded and positive: its quadratic form is
`sum_n |2^(-n)(f_n+t)|^2 + (2/3)|t|^2`.
For `f_n^(N)=4^n/N` on `1<=n<=N` and zero elsewhere,
`xQ(f^(N),0)=((1/N) sum_(n<=N) e_n,1)`, whose distance
squared from `(0,1)` is exactly 1/N. Thus the closure of the range
meets ker Q nontrivially, whereas the actual range does not.
This is a sharpness example for a *different, false strengthening*;
it is not a counterexample to any manuscript assertion, which
expressly distinguishes these ranges.

### 2. Comparison and carriers do not hide a regularity hypothesis

We spell out the two uses of the manuscript's foundations.
The basic hereditary-algebra criterion also deserves verification:
`Her(h)=C intersect e_h C** e_h`. One inclusion is immediate.
For a positive u with e_h u=u, take increasing continuous cutoff
functions f_j of h converging strongly to e_h. On the compact
state space of the unitization the continuous nonnegative functions
`phi -> phi(u(1-f_j(h))u)` decrease pointwise to zero, since
states extend normally to C**. Dini's theorem makes convergence
uniform, giving `||(1-f_j(h))u|| -> 0`, and then
`f_j(h)u f_j(h) -> u` in norm. Hence u belongs to Her(h).
Positive and negative parts of the real and imaginary parts give
the general supported element. If `0<=u<=Kv`, compression by
`1-e_v` gives the required support containment.
Finally, for u in Her(v), cutoff approximate units g_j of v give
comparison coefficients `(g_j(v)/sqrt(v)) u^(1/2)` whose
conjugations of v converge to u. Thus this order and hereditary
reasoning also gives the Cuntz comparisons used below.

If d belongs to the ideal generated by a properly infinite v,
approximate d^(1/2) by finite sums `z=sum x_j v^(1/2)y_j`.
With the row X, column Y and block diagonal V formed from these
coefficients, `z=XV^(1/2)Y`. The inequalities
`z*z <= ||X||^2 Y*VY` and
`V^(1/2)YY*V^(1/2) <= ||Y||^2 V`, together with
`Y*VY ~_Cu V^(1/2)YY*V^(1/2)`, give `z*z <=_Cu V`.
Proper infiniteness gives `V <=_Cu v`; norm limits give `d <=_Cu v`.
The same argument in finite matrix corners handles rectangular sizes.
If v=0 its ideal is zero, so this also includes the zero case.
This proves the needed comparison directly; the unavailable
Kirchberg-Rordam citation is not a dependency.

For `d <=_Cu v`, choose a rectangular algebra coefficient z0 with
`||d-z0*vz0|| < epsilon/2`, and put
`l=(d-epsilon)_+`, `z=v^(1/2)z0 l`. Then

```
(epsilon/2) l^2 <= z*z <= (||d||+epsilon/2) l^2.
```

Thus `Her(|z|)=Her(l)`. In the bidual polar decomposition
`z=w|z|`, the carrier has `w*w=e_l` and `ww*<=e_v`.
If g_j are continuous cutoff approximate units for `Her(|z|)`,
vanishing near zero, then
`w g_j(|z|)=z g_j(|z|)/|z|` is an algebra matrix.
Consequently `wk` is an algebra matrix for every k in `Her(l)`;
for positive k, `wkw*=(wk^(1/2))(wk^(1/2))*` belongs to
`Her(v)`. Linear decomposition gives the general case.
The map k -> wkw* is an injective *-homomorphism.

Normal extensions of representations carry its two support identities
to the represented supports. Conjugation by the represented w and
back by its adjoint gives *both* norm inequalities, hence equality.
This proves the represented norm assertion, not just abstract
injectivity. Splitting a rectangular carrier into columns gives
orthogonal copies with a common initial support. These arguments use
no separability, exactness, or extra closed-range assertion.
The normal-extension theorem here is Blackadar III.5.2.9,
printed p. 339: every nondegenerate representation of an arbitrary
C*-algebra extends uniquely to a normal representation of its bidual.
In particular it preserves the increasing limit
`h(h+1/j)^(-1) -> e_h`, hence sends e_h to e_(pi(h)).

### 3. Four contractions at one finite test

Fix `x=(X-a)_+`, `V=(X-beta)_+`,
`Q=(h1-B_1B_1*)_+`, and `U=xQ^2x`.
Choose continuous scalar contraction ramps H,K of X, with H
zero near `[0,a]` and one on `[beta,infinity)`, and K zero near
`[0,a0]` and one on `[a,infinity)`. Thus KH=H.
The positive square root `b=(1-H^2)^(1/2)` is in the unitization.
For i=1,2 define `r_i=h^(-1/2)B_i*H`, without asserting
any scaling relation yet. Set

```
P0 = chi(K [1-(r1+b)(r1+b)*] K),
chi(t) = min(1,max(0,t)),
x' = (P0-theta)_+,
Q' = (h1-B3B3*)_+,
R = x'(Q')^2x'.
```

All of these are fixed, independent of the finite test. The
compressed selfadjoint expression is in `Her(K)` even in a
nonunital C. Since chi(0)=0, P0 is a positive contraction there.
In particular `e_(x') <= e_(X-a0)_+`.

For eta>0 and finite E subset C put
`Aeta=(U-eta)_+` and
`D0=Aeta (sum_(w in E) wVw*) Aeta`.
Let D be the continuous ramp of D0 zero through eta and one from
2eta onward. Then

```
D0 = sum_(w in E) (Aeta w V^(1/2))(Aeta w V^(1/2))*,
e_D <= e_(D0-eta)_+ <= e_Aeta <= e_x,
D0 in Id(V).
```

By (P), V is properly infinite; the preceding comparison and
transport give a carrier for `D0 direct-sum D0 <=_Cu V`
after cutoff eta. If w_1,w_2 are its columns, take
`T_i=D^(1/2)w_i*` for i=1,2. These are algebra contractions,
`T_iT_j*=delta_ij D`, with left supports under e_D and right
supports under e_V. Both supports are under `e_(X-a0)_+`;
the universal-bidual characterization of hereditary subalgebras
therefore puts both T_i in the required algebra.

For the second pair apply (P) and transport to
`((R-eta)_+) direct-sum ((R-eta)_+) <=_Cu (R-eta)_+`,
again with cutoff eta. Its columns u_3,u_4 have common initial
support `e_(R-2eta)_+` and final supports under `e_(R-eta)_+`.
For a ramp t_R zero through 2eta and one from 4eta onward take
`T_3=u_3 t_R`, `T_4=u_4 t_R`. These are algebra contractions
in the prescribed hereditary algebra, and

```
T3*T4=0,   T3*T3=T4*T4=t_R^2.
```

Their left supports are under `e_(R-eta)_+`, their right supports
under `e_(R-2eta)_+`, and represented norms equal those of t_R.
This checks the two opposite orientations of the two carrier uses.

Suppose a representation matches all four B_i with these T_i.
Its `B1B1*=D`. The spectral subspace of D above h is killed
by Q and lies under `e_(U-eta)_+`, hence in the actual range
of xQ. Section 1 makes this subspace zero, so `D<=h1`.
The plateau of D now implies `||D0||<=2eta`, since a spectral
value at least 2eta would give `||D||=1>h`.

Similarly, the spectral subspace of `B3B3*` above h is
killed by Q' and lies in the actual range of x'Q'.
Thus `B3B3*<=h1`. If `||R||>4eta`, represented norm
preservation gives `||B3||=||T3||=1`, a contradiction.
Hence `||R||<=4eta`. These bounds do not require the
matching representation to be irreducible.

### 4. Directed ultraproduct: fixed elements and all quantifiers

Assume for contradiction that every four-entry choice can be
matched in a representation with `||pi(X)||>s`. Use
`Lambda=N>=1 times fin(C)`, ordered by increasing first coordinate
and inclusion of the second, and eta=1/m. At each index choose
a matching representation for Section 3's entries. It can be
restricted to a nondegenerate cyclic reducing subrepresentation
still detecting norm greater than s. The collection of cyclic
representations can be chosen as a set, so this is not a proper-class
product.

The tails have the finite intersection property. In ZFC they
extend to an ultrafilter omega. Take the quotient of the bounded
product of B(H_lambda) by the ideal of norm-omega-zero families.
For every bounded family z_lambda, its quotient norm is
`lim_omega ||z_lambda||`: the lower inequality follows from the
triangle inequality modulo a norm-zero family; for the upper
inequality truncate the family to zero on the omega-small set
where its norm exceeds its ultralimit plus epsilon. Thus this
is a norm ultraproduct with the asserted norm formula.

The map `Phi(z)=[pi_lambda(z)]` is a *-homomorphism.
Its image B is closed by the closed-image theorem. Only fixed
elements are used as elements of B. In particular none of the
varying D0,D,T_i,t_R is silently included in B.

For each fixed w in C the tail E containing w gives

```
||pi_lambda(Aeta w V^(1/2))||^2 <= 2eta,
||pi_lambda(UwV)|| <= sqrt(2eta)||V||^(1/2)
                       + eta ||w|| ||V||.
```

The latter tends to zero, since `||U-Aeta||<=eta`.
It follows for *every* w that `Phi(U)Phi(w)Phi(V)=0`,
or UBV=0. This handles nonseparable algebras without selecting
a countable dense set. Also R=0 in B.

All other relations pass because they concern fixed polynomials
and fixed continuous functional calculus:

```
||X|| >= s,  B1B1* <= h1,  BiBj*=delta_ij B1B1* (i,j<=2),
HBi*=Bi*,  B3B3* <= h1,  B3*B4=0,  B3*B3=B4*B4.
```

Choose a fixed continuous h_P vanishing at zero and equal to one
on `[theta,1]`. The left support of each represented T4 is under
`e_(P0-theta)_+`, so also `h_P(P0)B4=B4` in the limit.
The strict inequalities `||pi_lambda(X)||>s` need not remain
strict: **only `||X||>=s` is claimed**, and beta<s is sufficient.
Neither B nor the ambient ultraproduct is assumed to satisfy (P).

### 5. Irreducible reduction and the unit

In B, `V=(X-beta)_+` is nonzero. Take a nondegenerate
irreducible representation detecting V. If B does not contain
the ambient unit, its extension to `B+C1` is
`b+lambda 1 -> pi(b)+lambda I`. If B has its own unit
e different from the ambient unit, nondegeneracy gives pi(e)=I
and this extension kills `1-e`. If the ambient unit already
belongs to B, nondegeneracy makes its representation I.
Thus no unitality or injectivity of this extension is being assumed.

The closure of BVH is a nonzero reducing subspace. By
irreducibility it is all of H. UBV=0 then gives U=0.
Since `D1=B1B1*<=h1`, Q=h1-D1 and
`U=(Qx)*(Qx)=0`, so `D1 x=h x`.
Continuity on the closure of the range of x gives D1=h on
e_x H. In particular `D1 H=h H`. One can alternatively use
the bounded scalar factorization H=x f(X), since H vanishes
on a neighborhood of a.

Consequently
`r_i*r_j=delta_ij H^2`, and `H r_i=r_i` follows from
`HBi*=Bi*`. Moreover HV=V!=0, so H!=0.
These are derived relations in this irreducible image, not
assumptions on the original B_i in C.

### 6. The kernel-certified noncommutative obstruction

Here is a slightly stronger universal algebraic statement, also
useful for separating what the analysis actually has to prove.
In any unital complex C*-algebra let H,b,r1,r2 obey

```
H*=H, H!=0, b*=b, b^2=1-H^2,
H r_i=r_i, r_i*r_j=delta_ij H^2.
```

For z=b r_i, its star-square is
`r_i* (1-H^2) r_i=0`. The C*-identity forces z=0.
Taking adjoints also gives `r_i*b=0`; it does **not** give
`r_i b=0` or `b r_i*=0`. These latter cross terms must be
retained. It follows that v=r1+b is an isometry and v*r2=0.
For P=1-vv*, P*=P and P^2=P, while `P r2=r2!=0`.
Here r2!=0 follows from `r2*r2=H^2` and selfadjoint
H!=0, using the C*-identity a second time.

The fixed cutoff is not allowed to lose this defect.
The scalar ramps give KH=H and Kb=bK. From H r1=r1,
`K r1=r1`; from the definition r1=h^(-1/2)B1*H,
`r1 K=r1`. Expanding,

```
P=H^2-r1r1*-r1 b-b r1*.
```

All four summands are fixed by K on both sides, so KPK=P.
As P is a projection and chi(0)=0, chi(1)=1,
functional calculus gives `P0=chi(KPK)=P`.
This is why two-sided cutoff support is essential.

For the last pair, `x'=(1-theta)P`. R=0 gives Q'x'=0,
and hence `(B3B3*)P=h P` because 1-theta is nonzero.
The fixed support-ramp relation gives PB4=B4. But

```
(B3B3*)B4 = B3(B3*B4) = 0,
(B3B3*)B4 = (B3B3*)P B4 = h B4.
```

Thus B4=0. Equal Gram matrices give B3*B3=0, hence B3=0.
Then hP=0 and P=0, contradicting P!=0.

In fact the last paragraph is valid for *any* P, without
positivity or idempotence, and for *any nonzero complex scalar* h.
`two_column_obstruction` proves precisely that stronger statement.
The source `Main.lean` also derives the annihilation, the isometry,
the nonzero defect, and its two-sided compression; none is a
placeholder assumption equivalent to avoidance.

The contradiction proves the verification theorem: some finite test
has no matching representation, and its four contractions have all
the required hereditary memberships.

### 7. Exact interface with the graph proposition

Fix k=4 *before* constructing the graph. The allowed coefficients
`gamma=1/2`, `sigma=1/(2 sqrt(5))` satisfy
`gamma^2+4sigma^2=9/20<1`. By (P) the required positive
cutoffs of a are properly infinite, so the common carrier supplies
the six slots `v0,v1,...,v4,v*` with
`vi*vj=delta_ij e` and algebra membership after multiplying
the input hereditary algebra. The scalar term plus that hereditary
algebra is a unital algebra with unit e, so the square root

```
J=((1-gamma^2)e - sigma^2 sum Si*Si)^(1/2)
```

exists there and multiplies the hereditary algebra into itself.
Its radicand is bounded below by the strictly positive scalar
`1-gamma^2-4sigma^2`. Orthogonal slots give
`L=gamma v0+sigma sum vi Si+v*J`, `L*L=e`.
The carrier argument then proves that `p=LtL*` is an algebra
positive contraction, is rich, and preserves every represented norm
of t. This includes the zero corner e=0. The slot system, X,
and the measurements are independent of the choices Si.

In a representation where `y(1-c*p^2c)y=0`,
the equality `||p c y xi||=||y xi||` and the contraction
inequalities force c to be isometric on e_y H and p to act as
the identity on c e_y H. The latter follows since the positive
operator 1-p^2 has zero quadratic form there, and
ker(1-p^2)=ker(1-p) for positive p.
Hence F=cyc* is supported on that p=1 subspace.
For `H0=L*FL`, the isometry L identifies this subspace with
the t=1 subspace. Therefore

```
F=L H0 L*,  tH0=H0=H0t,  ||H0||=||F||=||y||.
```

The last equality uses the just-proved isometry of c on e_y H,
not any global isometry assumption on c.
Substituting the slot identities into the fixed measurements gives

```
X=H0,  Bi=t Si X t h_inv(X).
```

If `||pi(y)||>1/4`, the first relation gives `||pi(X)||>1/4`.
The equality tX=X makes t the identity on the support of X.
Both supports of each Si are under `e_(X-1/32)_+`.
Thus `tSi=Si`, `Xt=X`, and
`Si (X h_inv(X))=Si`, because the scalar factor equals one
for spectral values at least 1/32. The formal theorem
`graph_recovery` now gives Bi=Si, in the *same* representation.
There is no change from all representations to irreducible ones
in this implication.

Choose Si to be the four contractions given by avoidance. If the
graph defect vanished with norm(y)>1/4, the preceding paragraph
would yield the forbidden matching representation. Therefore

```
pi(y(1-c*p^2c)y)=0  implies  ||pi(y)|| <= 1/4
```

for every representation, exactly the premise of
`lem:conditional-shrinking`. The subsequent global shrinking,
iteration, main strong-pure-infiniteness theorem, and absorption
corollary are not asserted to have been independently certified
by this bounded mission.

## What the executable certificate does and does not prove

`verify.py` checks exact rational coefficient identities in a free
noncommutative star algebra, the coefficient system for the final
two-column implication, the fixed threshold inequalities, and the
sharp actual-range example. Its checks are universal polynomial
identities, not a search in finite-dimensional algebras. The
C*-implication `z*z=0 -> z=0` and the formal universal implication
are additionally checked by Lean.

The one bounded Jacobian operation solves the coefficient system
for a *noncommutative ideal-membership certificate*: with
`D=B3B3*`, `G1=DP-hP`, `G2=PB4-B4`, `G3=B3*B4`,

```
h B4 = D G2 - G1 B4 - h G2 + B3 G3.
```

The four distinct words `DPB4, DB4, PB4, B4` are the row basis.
The exact payload, typed contract, server/protocol identifiers,
and typed result are preserved in the `jacobian_*.json` files.
The local verifier independently checks the matrix, the returned
coefficients, and the free-word identity. The operation supplies
only this mathematical move, not the analytical proof.

Neither executable verification nor a Lean compiler checks the
truth of this report's translation from operator analysis. That
is explicitly the Host Reviewer's obligation. No false literal
manuscript assertion has been established, so no `F_` refutation
claim is manufactured.

## Review status

The mathematical proof is complete at Engineer level. Exact
standalone replay passed with 15 universal noncommutative identity
checks, including the source-bound Jacobian coefficient certificate.
The real Lean 4.31.0 run exited 0 in 9.640 seconds with
`proof_holes=[]`; its transitive audit also exited 0.
The printed axioms were exactly `propext`, `Classical.choice`,
and `Quot.sound`, with no user or placeholder axiom.
The archived mechanical evidence is
`certificates/V_FOUR_ENTRY_CORE-5f3e0567b624caf0.json`.
The ledger derives `closed_kernel` for **V_FOUR_ENTRY_CORE only**.

At the final Engineer gate, both official checks exited 0 against
`campaigns/9000303`;
the proof graph has 18 nodes. Nodes are deliberately not marked
Reviewer-confirmed. The two retired route goal pointers were
updated to the current avoidance statement after the official
checker identified stale versions; their retirement reasons and
the mathematical statements were not weakened.

The five canonical foundational citations still need independent
`citation_check attribute` records. The primary author PDF and
exact bidual passage are available locally for that review.
The unavailable Kirchberg-Rordam attribution is not a proof
assumption. The independent Reviewer has not yet accepted the
analytical proof, citations, statement fidelity, significance,
or novelty. This is a verification result, not a manuscript
counterexample, campaign-final publishability verdict, or claim
that the entire manuscript is Lean-formalized.
