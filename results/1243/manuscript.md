# Complete rational points and map rigidity on a magic-square branch

**Editorial status.** The arithmetic results used below were independently
accepted in `roles/reviewer/progress.json`, dated 2026-11-03 14:03:55 UTC.
Theorem 2 was independently accepted in the same review record, dated
2026-11-03 17:32:42 UTC. Neither accepted mathematical certificate is changed
or recomputed here. This manuscript assembles their arguments and supplies
theorem-level comparisons for the combined contribution. Originality and
publishable significance still require an independent publication verdict;
neither is inferred from a search miss.

## Abstract

We determine the rational points on an explicit genus-thirteen curve and on
its genus-161 three-square cover arising from a rational family on Bremner's
octic K3 surface. The first curve has two rational points; the full cover has
eight, all mapping to a magic square with only three distinct entries.
The full cover has geometric gonality eight with a unique degree-eight
pencil, and its rational automorphism group consists precisely of its
eight radical-sign changes. Its rational involution quotients have genera
53 and 81, excluding every nonconstant rational morphism to a genus-57
curve, including Bremner's full degree-six square cover.
The arithmetic input is a complete classification of eight quadratic twists
of a genus-two curve whose sextic already occurs in Bremner's work. The
difficult untwisted case is settled using an elliptic cover over a sextic
field: its rank is one and its two-primary Tate--Shafarevich group is
`(Z/2Z)^2`. Global descent completeness is proved using relative class parity,
actual units modulo squares, and exact norm identities, rather than assuming
complete integral class and unit groups. A sufficient finite-index
certificate then makes elliptic Chabauty unconditional. These are applications
of established methods, not new versions of those methods. The conclusion
concerns the specified branch, not all rational points on the K3 surface or
the general magic-square-of-distinct-squares problem.

## 1. Models and statements

All curves mean their smooth projective models. For an ascending coefficient
vector `[c0,...,cn]`, write `[c0,...,cn](x)=sum ci*x^i`. Define

```text
f = [7,-14,15,-108,-87,2,1]
h22 = [38983,-341142,540575,3476884,-11391467,-11069134,
       65554221,17235568,-189164682,-47044812,304712166,145554552,
       -241510758,-194242092,48847050,81082736,9944499,-9509150,
       -2374421,53780,16865,1914,409]
h8a = [29,72,-124,-584,-66,1048,868,168,13]
h8b = [89,-480,428,832,-306,-224,124,0,1]
h10 = [61,-400,513,1408,-2526,-2208,3138,2048,-15,-80,13]
h14a = [-433,2070,2875,-21932,32167,24698,-129157,-89512,
        75829,78890,11849,-4076,-811,6,1]
h14b = [97,354,-7411,15836,30713,-88658,-53699,161224,
        70139,-99554,-54161,3740,5035,18,71]
G1 = f*h22
G2 = (x^2+1)*h8a*h8b*h10
G3 = -h14a*h14b
```

Let
\[
 C_d:\ y^2=d f(x),\qquad H:\ s^2=G_1(x),
\]
and let \(X\) be the normalization of
\[
 y_1^2=G_1(x),\quad y_2^2=G_2(x),\quad y_3^2=G_3(x).                 \tag{1}
\]
The eight displayed irreducible factors are squarefree and pairwise
coprime over \(\mathbf Q\). Their degrees sum to 84. Each nontrivial product
of the three residual classes has an odd valuation at a root of one of
its factors, so their classes are independent even over
\(\overline{\mathbf Q}(x)\). Thus \(X\) is geometrically connected.
The cover \(X\to\mathbf P^1\) has degree eight, with inertia order two
at each of the 84 distinct branch points and no ramification at infinity.
Riemann--Hurwitz gives
\[
 2g(X)-2=-16+4\cdot84=320.
\]
Also \(g(H)=(28-2)/2=13\).

**Theorem 1 (complete arithmetic and branch classification).**

For \(d\in\{-14,-7,-2,-1,1,2,7,14\}\), the complete point sets are:

| \(d\) | \(C_d(\mathbf Q)\) |
|---:|:---|
| \(-14\) | \((-17/3,\ \pm22148/27)\) |
| \(-7\) | \((5/16,\ \pm1841/4096)\) |
| \(-2,-1,2\) | empty |
| \(1\) | the two points at infinity |
| \(7\) | \((0,\ \pm7)\) |
| \(14\) | \((-1,\ \pm28)\) |

The elliptic curve \(E/k_0\) defined in Section 3 has
\[
 \operatorname{rank}E(k_0)=1,\qquad
 \Sha(E/k_0)[2^\infty]\simeq(\mathbf Z/2\mathbf Z)^2.                 \tag{2}
\]
Moreover
\[
 H(\mathbf Q)=\{(-1,896),(-1,-896)\},                              \tag{3}
\]
\[
 X(\mathbf Q)=
 \{(-1,\epsilon_1\,896,\epsilon_2\,1664,\epsilon_3\,2176):
            \epsilon_1,\epsilon_2,\epsilon_3\in\{1,-1\}\}.          \tag{4}
\]
All three signs in (4) are independent. Neither \(H\) nor \(X\) has a
rational point at infinity. Every point in (4) produces repeated entries
in the magic-square family defined below.

No assertion that a specified point generates \(E(k_0)\) is part of
the theorem. Neither finiteness of the whole group \(\Sha(E/k_0)\) nor
GRH is assumed.

### The complete parameterized family

To specify the geometric scope without a branch label or an external
parameter convention, define six polynomials:

```text
u0 = [-345,1532,663,-5184,-11665,1692,58343,25760,
      -71363,-49676,4989,6560,-83,-140,5]
u1 = [196,-1106,-1660,15548,-2964,-51782,-4660,69416,
      47740,-12990,-21956,-3492,468,-106,-12]
u2 = [-396,1896,1188,-15696,14004,31896,-55932,-36960,
      73212,53016,-6708,-8016,-804,-24,12]
u3 = [25,220,-4805,11064,20981,-51980,-43393,67792,
      52891,-21500,-24575,-4488,791,172,5]
u4 = [304,-2294,920,18692,-14904,-53570,29936,60824,
      -10688,-6426,16888,5412,-696,-238]
u5 = [255,-188,-6657,11232,26839,-38652,-56225,37024,
      54053,8588,-4971,-4736,-1531,44,13]
```

Homogenize each to degree fourteen on \(\mathbf P^1_{[p:q]}\);
the degree-thirteen polynomial \(u_4\) acquires a factor \(q\).
The resulting coordinates have no common geometric zero. They satisfy
\[
 u_0^2+u_1^2=u_2^2+u_3^2=u_4^2+u_5^2,\qquad
 u_0u_1+u_2u_3+u_4u_5=0.                                        \tag{5}
\]
This is the Category III magic octic K3 model, in paired coordinates.
Set
\[
 e=u_0^2+u_1^2,\quad a=2u_0u_1,\quad b=2u_2u_3.
\]
Direct polynomial identities give
\[
 G_1=e-a+b,\qquad G_2=e,\qquad G_3=e+a-b.                          \tag{6}
\]
Six entries of the Lucas square
\[
 \begin{pmatrix}
 e+a&e-a-b&e+b\\
 e-a+b&e&e+a-b\\
 e-b&e+a+b&e-a
 \end{pmatrix}                                                   \tag{7}
\]
are already squares, since (5) gives squares for
\(e\pm a,e\pm b,e\pm(a+b)\). Equation (1) imposes precisely the other
three entries. Every row, column and main diagonal of (7) sums to \(3e\).
Thus (4) is a complete classification for all rational parameter values
in this specified family, including the projective boundary.
It does not quantify over arbitrary rational curves or all points on (5).

**Theorem 2 (rational-map rigidity).**

The map \(x:X\to\mathbf P^1\) is the unique geometric degree-eight
pencil, up to postcomposition by a base automorphism, and \(X\) has
geometric gonality eight. For maps defined over \(\mathbf Q\), the
postcomposition belongs to \(\operatorname{PGL}_2(\mathbf Q)\).
Moreover
\[
 \operatorname{Aut}_{\mathbf Q}(X)
   =\{(x,y_1,y_2,y_3)\mapsto
                (x,\epsilon_1y_1,\epsilon_2y_2,\epsilon_3y_3)\}
   \simeq(\mathbf Z/2\mathbf Z)^3.
\]
Its three individual sign involutions have quotient genus 53; its other
four involutions have quotient genus 81. There is no nonconstant
\(\mathbf Q\)-morphism from \(X\) to any smooth projective
geometrically integral curve of genus 57. In particular there is none
to the full equation-(26) square cover \(\mathcal B\) defined in Section 8,
whose genus is exactly 57.

Uniqueness of the pencil is geometric; the automorphism and morphism
conclusions asserted here are over \(\mathbf Q\). No claim that the
geometric automorphism group of \(X\) equals this rational group is needed.

## 2. Reduction to the eight genus-two twists

The binary forms associated to \(f,h_{22}\) have resultant supported only
at \(2,3,7\). If \((p,q)\) is primitive, any prime dividing both values
must divide their homogeneous resultant: the homogeneous Bezout identities
give the assertion in both charts. If their product is a square and neither
value is zero, their squareclasses agree. Outside \(2,3,7\), an odd valuation
would consequently occur in both values, contradicting the resultant
condition. The common squareclass therefore belongs to
\[
 \langle-1,2,3,7\rangle\subset\mathbf Q^*/\mathbf Q^{*2}.           \tag{8}
\]

There are sixteen classes in (8). The complete simultaneous square tests
for the two binary forms modulo \(256\) leave exactly
\[
 D=\{-14,-7,-2,-1,1,2,7,14\}.                                    \tag{9}
\]
The finite test covers all 384 primitive projective representatives:
\([p:1]\), \(0\le p<256\), and \([1:q]\), \(q\) even,
\(0\le q<256\). Odd rescaling cannot change the tests, since the degrees
six and twenty-two are even. The two-chart test and its exact results
are in `twist-local-filter.json`, first group.

Neither factor has a rational root. Thus every affine point of \(H\)
gives \(f(x)=d r^2\) for some \(d\in D\), and hence the point
\((x,dr)\in C_d(\mathbf Q)\). The same conclusion is valid when an
integer representative of the squareclass is used: a rational square root
of the resulting integer is integral. Infinity is checked separately
in Section 5, so this reduction makes no affine-chart assumption.

### Seven twists settled by first descent and rank-one Chabauty

The sextic field \(k_0=\mathbf Q(\theta)\), \(f(\theta)=0\), has signature
\((4,1)\) and class number one. Over \(\mathbf Q(\sqrt2)\),
\[
 f(x)=\bigl(x^3+(1-7\sqrt2)x^2+(5-4\sqrt2)x+\sqrt2-3\bigr)
      \bigl(x^3+(1+7\sqrt2)x^2+(5+4\sqrt2)x-\sqrt2-3\bigr).        \tag{10}
\]
The complete global fake-two-cover spaces, including the real image,
contain respectively 64 candidates for the twists divisible by 7 and
32 for the remaining twists. Complete local images at \(2,3,7\) leave
one candidate for each of \(-14,-7,1,7,14\), and none for
\(-2,-1,2\). An empty covering set proves emptiness of the original
curve; it is not a failure to find a point.

For the four nonunit survivors, true Jacobian two-descent gives rank one
and trivial rational torsion. The following are the exhaustive
Kummer-height cutoffs in the saturation argument and the complete
sieve/Chabauty data. The height searches enumerate all Jacobian candidates
required by the proven index bound, not all curve points up to an
arbitrary height.

| \(d\) | Kummer cutoff | extra nondivision witnesses \( (\ell,q) \) | Coleman prime | auxiliary sieve prime | surviving generator residues |
|---:|---:|:---|---:|:---|:---|
| \(-14\) | 1954 | \((2,23)\) | 17 | 47 | \(0,2\) |
| \(-7\) | 977 | \((2,151),(3,13),(5,53)\) | 47 | none | \(0,1\) |
| \(7\) | 977 | index bound already one | 23 | 13 | \(0,2\) |
| \(14\) | 1954 | index bound already one | 17 | 67 | \(0,2\) |

The primitive-model finite height correction from [MS] is
\((33/4)\log2+\log3+\log|d|\); the index argument uses [FS].
The known points and their exact halves give the rank-one generators.
Each additional witness excludes division
in the complete finite Jacobian group by testing its cyclic coordinates.
The finite sieves leave the two reductions occupied by the displayed
point pair. A Coleman annihilator is a unit at both reductions.
The local difference quotient consequently has a unit constant term,
so two rational points in the same surviving disk cannot have equal
Coleman integral. The known pair fills the two disks. This proves the
four nonunit point sets in Theorem 1.

The exact saturated Mumford generators, height witnesses, complete group
decompositions and annihilators are supplied in
`rank_one_saturation_*.json` and `rank_one_chabauty_*.json`, with their
producer sources; the proof of the local difference quotient is in
`padic-residue-disk-proof.md`. Section 6 locates these supplements.
For \(d=1\), the rational Jacobian has rank two, equal to the genus;
ordinary rank-less-than-genus Chabauty is therefore not a substitute
for the argument that follows.

## 3. The elliptic cover and unconditional global descent

In \(k_0\), define
\[
\begin{aligned}
 A&=(3\theta^5+5\theta^4-262\theta^3-222\theta^2+359\theta-35)/96,\\
 B&=(-17\theta^5-33\theta^4+1478\theta^3+1690\theta^2-617\theta-149)/96,\\
 C&=(-\theta^5+17\theta^4+114\theta^3-1654\theta^2-1181\theta+729)/96,\\
 D&=(35\theta^5+91\theta^4-3010\theta^3-5614\theta^2-1125\theta+103)/96.
\end{aligned}                                                    \tag{11}
\]
Over \(k_0\), \(f\) factors into degrees \(1,2,3\).
The product of the linear and cubic factors is
\(x^4+Dx^3+Cx^2+Bx+A\). The single surviving fake-cover class of
\(C_1\) is 1. Its partial norm on this degree-four factor is 1; changing
the rational representative by \(r\) changes this norm by \(r^4\),
which is a square. Hence every rational point of \(C_1\) lifts to this
quartic. For \(x\ne0\), put \(t=1/x\); its reciprocal model is
\[
 w^2=1+Dt+Ct^2+Bt^3+At^4.                                       \tag{12}
\]
The value \(x=0\) cannot be a point of \(C_1\), since \(f(0)=7\).

Taking \((t,w)=(0,1)\) as origin identifies (12) with
\[
 E:\ V^2=U^3+CU^2+(BD-4A)U+(AD^2+B^2-4AC).                      \tag{13}
\]
For \(t\ne0\), the maps are
\[
 U=\frac{2(w+1)+Dt}{t^2},\qquad
 V=\frac{2(U+C)-D^2/2}{t}+\frac{DU}{2}+B,
\]
\[
 t=\frac{2(U+C)-D^2/2}{V-DU/2-B},\qquad
 w=\frac{Ut^2-Dt}{2}-1.                                         \tag{14}
\]
They extend on the smooth projective curves. The other point above
\(t=0\) is
\[
 P=(D^2/4-C,\ -D(D^2/4-C)/2-B).
\]
An exact point \(Q\) with \(2Q=P\) is
\[
 Q=\left(
 \frac{21\theta^5+35\theta^4-1834\theta^3-1458\theta^2+593\theta-245}{96},
 2\theta^3+2\theta^2+10\theta-6\right).                           \tag{15}
\]
The finite reduction sieve below uses the forward quartic maps, including
\(t=\infty\), rather than discarding exceptional values of (14).

For descent, an equivalent sextic representation is
\[
 k=\mathbf Q(z),\quad
 z^6-2z^5+3z^4-36z^3+60z^2+32z-56=0,
\]
with the explicitly checked embedding
\[
 \theta=(-19z^5-7z^4-73z^3+511z^2+72z-454)/6.
\]
Writing \(h=(-7z^5+4z^4-15z^3+250z^2-38z-126)/6\), the change
\(U_{\rm old}=U_{\rm new}+h,\ V_{\rm old}=V_{\rm new}\)
gives the optimized coefficients in
`global_squareclass_completeness.md`.
The original \(Q,P\), not merely an unspecified isomorphic elliptic curve,
are transported by this same map.

Let \(K=k(\alpha)\), where \(\alpha\) is a root of the optimized cubic
of (13). The verified relative basis has dimension three, so
\([K:\mathbf Q]=18\) and \(E(k)[2]=0\). Let \(S_K\) be all primes
occurring in its cubic derivative at \(\alpha\), and \(S_k\) all primes
occurring in \(6\Delta(E)\).

**Lemma 2 (complete global norm-square space).** The twelve archived
descent generators form a basis of
\[
 \ker\bigl(N_{K/k}:K(S_K,2)\longrightarrow k(S_k,2)\bigr).          \tag{16}
\]
The domain, target, image and kernel dimensions are \(23,12,11,12\).

**Proof.** For a number field \(L\), \(L(S,2)\) consists of squareclasses
with even valuations outside \(S\). The only class-group information
needed here is the absence of two-primary ideal classes.

The explicit degree-nine field \(F\) in the supplement satisfies
\(K=F(\sqrt2)\). Exact field maps and an involution verify this equality.
Its defining polynomial is

```text
Z^9-1261*Z^8+786366*Z^7-522560650*Z^6+161092297713*Z^5
 -12246611840869*Z^4+640464616958234*Z^3-15581049897157902*Z^2
 +296347358593457424*Z-2655490015435074624.
```

Unconditional class-group quotient certification for \(F\) returns a
trivial group at the actual certification bound 695228. Thus \(h(F)=1\);
this does not require the proposed units to generate its integral unit
group. The signatures of \(F,K\) are \((3,3),(6,6)\). The relative
discriminant has norm \(512\), with valuations \(0,4,2,3\) at the four
primes above 2. These account for every finite ramified place; no real
place ramifies, because the radicand is positive. Thus \(t=3\).

For six actual \(F\)-units, verified together with their integral inverses,
the complete dyadic norm-character matrix is
\[
 \begin{pmatrix}
 0&0&0&0&0&0\\
 0&0&0&0&1&0\\
 0&0&0&0&1&1\\
 0&0&0&0&0&1
 \end{pmatrix}.                                                  \tag{17}
\]
Its rank is two. Unramified finite unit characters vanish, and reciprocity
supplies the single relation on the ramified characters. The cyclic Hasse
norm theorem therefore gives
\([E_F:E_F\cap N_{K/F}(K^*)]=4\).
Lemmermeyer's ambiguous class number formula [L, Theorem 1, (1)] gives
\[
 |\operatorname{Cl}(K)^{\operatorname{Gal}(K/F)}|
   =h(F)\,2^{t-1}/4=1.
\]
If \(\operatorname{Cl}(K)[2]\) were nonzero, the involution would have a
nonzero fixed vector on it: in characteristic two,
\((\sigma-1)^2=0\). That would be an ambiguous class of order two.
Consequently \(h(K)\) is odd. The denominator used above is the index
of units which are norms of **field elements**, not norms of \(K\)-units.

By Dirichlet's theorem, \(E_K/E_K^2\) has dimension twelve.
Eleven actual units and \(-1\), all with checked integral inverses,
have twelve independent quadratic residue characters. They are therefore
a complete basis modulo squares; an odd integral-unit index is harmless.
There are eleven primes in \(S_K\). Exact whole principal-ideal identities
give an \(S_K\)-valuation matrix of rank eleven. Odd class number makes
the valuation sequence
\[
 0\longrightarrow E_K/E_K^2\longrightarrow K(S_K,2)
       \longrightarrow\mathbf F_2^{S_K}\longrightarrow0
\]
exact, so the 23 resulting classes are complete. For \(k\), unconditional
class quotient certification at bound 88 gives class number one.
Its five unit classes and seven support classes similarly give a complete
twelve-dimensional target.

For the resulting bases \(b_i,c_a\), exact number-field identities verify
\[
 N_{K/k}(b_i)=\prod_a c_a^{N_{ai}}s_i^2.
\]
The \(12\times23\) matrix \(N\) has rank eleven. For each original
archived generator \(\beta_j\), a squared exact root verifies
\[
 \beta_j=\prod_i b_i^{C_{ij}}r_j^2.
\]
The matrix \(C\) has rank twelve and \(NC=0\) over \(\mathbf F_2\).
Thus its columns form the full kernel. The supplement also supplies an
invertible change of basis to an independently computed kernel basis and
exact square roots of all twelve archived norms. Sampled residue
characters are used to prove independence, never as a replacement for
these equality and transport checks. This proves (16). \(\square\)

The matrices, elements, ideals and roots in this proof are exact data in
`complete_squareclass_data.gp`; `certify_descent_squareclasses.gp`
checks them. The discovery of candidates by BNF routines is not an
assumption about the completeness of those routines' conditional output.

### Rank and two-primary Tate--Shafarevich group

Complete local images on the basis in Lemma 2 leave
\[
 \operatorname{Sel}_2(E/k)
 =\{0,936,1304,1712,2415,2759,3191,4063\},                        \tag{18}
\]
where the numbers are binary masks, with addition given by XOR.
The Kummer class of \(Q\) is 4063, so \(Q\) is not twice a global point.
The good-reduction torsion argument of Section 4 makes it non-torsion.

The exact global norm preimage for class 2759 gives a smooth point on
the Cassels conic and its tangent. The complete local Hilbert-symbol
product for \((2759,936)\) is \(-1\). Support control accounts for every
omitted finite place, and the infinite contributions are trivial.
The explicit pairing agrees with Cassels--Tate over number fields
[FSS, Theorem 5.2]. Since \(2759=1304+4063\) and the Mordell--Weil
image is in its radical,
\[
 \langle936,1304\rangle_{\rm CT}=\tfrac12.                         \tag{19}
\]
The alternating pairing on the three-dimensional space (18) therefore
has rank two and radical the known Mordell--Weil line. The exact sequence
\[
 0\longrightarrow E(k)/2E(k)\longrightarrow\operatorname{Sel}_2(E/k)
       \longrightarrow\Sha(E/k)[2]\longrightarrow0
\]
and \(E(k)[2]=0\) give rank one and \(\dim\Sha(E/k)[2]=2\).
The induced pairing on \(\Sha[2]\) is nondegenerate. An element \(z\)
of order four would give a nonzero \(2z\in\Sha[2]\), but
\(\langle2z,w\rangle=\langle z,2w\rangle=0\) for every \(w\in\Sha[2]\).
No such element exists, nor an element of larger two-power order.
This proves (2) without assuming finiteness of \(\Sha\).
It determines neither odd index nor all-prime generation by \(Q\).

## 4. Sufficient index information and the untwisted point set

**Lemma 3 (finite-index local closure; standard principle).**
Let an elliptic curve over a number field have rank one and trivial
torsion, and let \(Q\) have infinite order. At every place \(v\mid p\)
assume good reduction, where \(p\) is odd. Put
\[
 M=\operatorname{lcm}_{v\mid p}\#E(\mathbf F_v).
\]
If \(Q\) is not divisible by any prime dividing \(pM\), then all global
points belong to the closure of \(\mathbf ZQ\) in
\(\prod_{v\mid p}E(k_v)\).

**Proof.** Write \(E(k)=\mathbf ZR\), \(Q=\pm mR\). The hypothesis says
\(\gcd(m,pM)=1\). Every finite congruence quotient of the product has
order supported on primes dividing \(pM\). Multiplication by \(m\)
is bijective on it. For a global point \(T\), \(mT\) is a multiple of
\(Q\), so \(T\) is a multiple of \(Q\) in every such quotient.
This is exactly closure membership. \(\square\)

The proof requires full reduction group orders, not just the reduction
orders of \(Q\). This is a convenient rank-one formulation of established
finite-index elliptic-Chabauty methodology [Br, Section 4.2, pp. 44--45];
it is not claimed as a new general lemma.

At \(p=23\), the field has residue degrees \(1,1,1,3\).
The four full group orders are \(19,27,21,12136\); their lcm is
\(M=43580376\). The orders of \(Q\) are \(19,9,21,6068\);
their lcm is \(N=7263396=M/6\).
The gcd of the full group orders is one, which eliminates
prime-to-23 torsion. A good degree-one place above 17 with group order
21 eliminates 23-primary torsion. Hence the torsion is trivial.

The Kummer class in (18) excludes 2-division of \(Q\).
The following exact good-reduction witnesses exclude every other prime
dividing \(23M\). Here \(r^3+13r^2+2r+15=0\) over \(\mathbf F_{23}\).

| \(\ell\) | residue field | image of \(\theta\) | full group order \(n\) | \((n/\ell)\overline Q\ne0\) |
|---:|:---|:---|---:|:---|
| 3 | \(\mathbf F_{23}\) | 7 | 21 | \((1,21)\) |
| 7 | \(\mathbf F_{23}\) | 7 | 21 | \((5,15)\) |
| 19 | \(\mathbf F_{23}\) | 3 | 19 | \((2,4)\) |
| 23 | \(\mathbf F_{193}\) | 103 | 184 | \((19,140)\) |
| 37 | \(\mathbf F_{23^3}\) | \(r\) | 12136 | \((21+8r+20r^2,15+5r+13r^2)\) |
| 41 | \(\mathbf F_{23^3}\) | \(r\) | 12136 | \((11+19r^2,20+2r+9r^2)\) |

Each \(n\) is obtained by exhaustive point counting. If \(Q=\ell T\)
globally, then \((n/\ell)\overline Q=n\overline T=0\), a contradiction.
Thus Lemma 3 applies. These positive finite witnesses prove global
nondivision; they are not a bounded search for rational points.

The complete forward-map reduction sieve covers every
\(t\in\mathbf P^1(\mathbf F_{23})\), at all four places.
It leaves exactly the following \(Q\)-multiple residues modulo \(N\):
\[
 0,\ 2,\ 115292,\ 3325266,\ 3440558,\ 3822840,\ 3938132,\ 7148106.
\]
All have base residue \(t=0\), and all are even. Closure membership
therefore puts every rational-base global point in the closure of
\(\mathbf ZP\), where \(P=2Q\).

Put \(L=N/2=3631698\). On each surviving coset the formal step is
\(LP=NQ\). Its formal-parameter valuations at the four completions
are \(2,1,2,1\). Its integer multiples have a single parameter
\(z\in\mathbf Z_{23}\) in their closure. Rationality of \(t\) gives five
analytic conditions: equality of the values at the three linear
completions, together with equality of the cubic-completion value to
that common rational value in all three coefficients.
Primitive projective coordinate cross-products implement the same
conditions without losing a pole chart.

The complete disk calculation is:

| \(P\)-residue modulo \(L\) | permitted \(z\bmod23\) after modulus \(23^2\) | subsequent conclusion |
|---:|:---|:---|
| 0 | 0 | unique zero, normalized derivative 21 |
| 1 | 0 | unique zero, normalized derivative 2 |
| 57646 | none | excluded modulo \(23^2\) |
| 1662633 | none | excluded modulo \(23^2\) |
| 1720279 | 8 | excluded modulo \(23^3\) |
| 1911420 | 14 | excluded modulo \(23^3\) |
| 1969066 | none | excluded modulo \(23^2\) |
| 3574053 | none | excluded modulo \(23^2\) |

In the two surviving disks the first condition has derivative of
valuation one. Its normalized power series has the displayed unit
linear coefficient and the required higher-coefficient divisibility.
The difference quotient is a unit on the relevant residue disk,
so each disk contains at most one zero, not just one zero to the
computed precision. The exact points \(0,P\) fill those disks.
The six other disks have no possible reduction already at the indicated
finite modulus. This argument applies to the entire local closure,
not merely to integer multiples or a truncated height interval.

The two projective quartic points \(0,P\) have \(t=0,w=\pm1\).
Their genus-two inverse lifts are exactly the two points at infinity.
The covering collection was complete, so \(C_1(\mathbf Q)\) has no
other point. This finishes the twist table in Theorem 1.
No prime outside \(\{2,3,7,19,23,37,41\}\) has been certified as an
index nondivisor, and none is required for this proof.

## 5. Residual values, infinity, and independent signs

By Section 2 and the now complete twist table, any affine point of \(H\)
has \(x\in\{-17/3,5/16,0,-1\}\). Exact rational evaluation gives:

| \(x\) | \(G_1(x)\) square? | \(G_2(x)\) square? | \(G_3(x)\) square? |
|:---|:---:|:---:|:---:|
| \(-17/3\) | no | no | no |
| \(5/16\) | no | no | no |
| 0 | no | no | no |
| \(-1\) | yes | yes | yes |

At \(x=-1\),
\[
 (G_1,G_2,G_3)=(802816,2768896,4734976)
              =(896^2,1664^2,2176^2).
\]
At infinity use \(t=1/x\), \(Y_i=t^{14}y_i\); the residual values are
\((409,169,-71)\). The first is not a rational square and the third is
negative, so neither \(H\) nor \(X\) has a rational point there.
No affine factor has a rational root. Thus no rational branch-point
fiber or normalization fiber has been omitted. Above \(x=-1\) the
cover is unramified, and its three nonzero square roots give precisely
eight distinct independent sign choices. This proves (3)--(4).

At that parameter the six K3 coordinates are
\[
 (0,1664,-1536,640,-640,-1536).
\]
Consequently \(a=0\), and the entries of (7) are
\[
 \begin{pmatrix}
 2768896&4734976&802816\\
 802816&2768896&4734976\\
 4734976&802816&2768896
 \end{pmatrix}.
\]
Changing any residual-root sign changes a signed root, not its square
or these entries. At projective infinity the K3 coordinates are
\((5,-12,12,5,0,13)\), and \(a+b=0\); this boundary also fails the
first and third residual square conditions. Hence every full rational
lift is collision-degenerate. No nine-distinct-square witness is supplied.

## 6. Exact computational supplements and proof dependencies

The statement above defines the objects without relying on a file name.
The larger arithmetic witnesses are supplied as exact computational
supplements, not as numerical assumptions. Paths below are relative to the
campaign root; set

```text
T = research/r2-category3-k3-second-iterate-genus2-covers
R = T/d1-cassels-tate/full-hi-isotropy/relative-squareclasses
N = T/d1-cassels-tate/full-hi-isotropy/relative-class-unit-solve-v2
F = research/r2-category3-k3-second-iterate-factor-descent
P = research/branch483-publication
M = P/map-rigidity
```

| Mathematical obligation | Exact source and data |
|:---|:---|
| (5)--(6), complete homogeneous charts and factorization | the displayed polynomials, `F/factor-data.json`, `F/filter_twist_spaces.py`, `F/twist-local-filter.json` |
| global genus-two covering set and complete local images | `T/genus2_2descent.py`, `T/bruin_stoll_local_images.py`, corresponding JSON outputs |
| rank-one twist saturation and disk uniqueness | `T/rank_one_saturation_*.json`, `T/rank_one_chabauty_*.json`, their producer sources; `research/r2-generic-section-difference/padic-residue-disk-proof.md` |
| the quartic, maps, and the exact original/optimized \(E,Q,P\) | `T/even_factor_covers.py`, `T/even_factor_covers_output.json`, `R/certify_p23_index.py`, `R/p23_index_certificate.json` |
| field degrees, \(F\subset K\), involution and all ramification | `R/field_preflight.gp`, `R/field_data.gp` |
| unconditional class parity and unit squareclasses | `R/certify_relative_parity.gp`, `R/relative_parity_data.gp`, `R/certify_unit_squareclasses.gp`, `R/unit_squareclass_data.gp` |
| full supports, norm coordinates, original basis and square witnesses | `R/descent_support_preflight.gp`, `R/certify_descent_squareclasses.gp`, `R/complete_squareclass_data.gp` |
| full local elliptic two-descent and the nonzero pairing | `T/d1_cover_selmer_local_sieve.json`, its local-image sources; `N/branch483_cached_rnfisnorm_solution_nofilter-c1-015.gp`, `N/order012_conic_point_from_cached.json`, `N/order012_tangent_from_cached.json`, `N/order012_pairing_from_cached.json` |
| exhaustive finite \(p=23\) sieve and all eight analytic disks | `T/d1_cover_rational_base_sieve.py`, `T/d1_cover_rational_base_sieve_p23.json`, `T/d1_cover_padic_disks.py`, `T/d1_cover_padic_disks_p23.json` |
| exact residual evaluations and all inverse signs | `T/known_residual_lifts.py`, `T/known_residual_lifts_output.json` |
| Section 7, prior sextic identity and individual residual genus | `P/jacobian/bremner-model-identity-payload.json`, `P/jacobian/bremner-model-identity-output.json`, `P/jacobian/bremner-residual-payload.json`, `P/jacobian/bremner-residual-output.json`; inspected contracts and adapter statuses in the same directory |
| Section 7, degree-six full-cover genus bound | the middle-row formulas in `P/sources/bremner-sextic-excerpt.txt`, and the Riemann--Hurwitz argument below |
| Section 8, all intermediate quotients, finite Frobenius inputs and exact genus of the prior full cover | `M/verify_rigidity.py`, `M/rigidity-certificate.json` |
| Section 8, bounded Frobenius-ratio elimination | `M/jacobian/resultant-payload.json`, `M/jacobian/resultant-output.json`, `M/jacobian/adapter-status.json`; the resultant contract was inspected before execution |
| Section 8, ordinary absolutely simple reduction principle | `M/sources/lombardo-1610.09674v2.pdf`, `M/sources/lombardo-lemma-2-9-excerpt.txt`, [Lo, Lemma 2.9] |

The arithmetic review accepted Theorem 1's dependencies; the review dated
2026-11-03 17:32:42 UTC separately accepted Theorem 2's argument and finite
inputs. The additional complete-application comparisons in Section 7 have
not yet received an independent publication verdict. No changed arithmetic
or rigidity hypothesis is introduced here. Reproduction uses
the existing pristine PARI/GP 2.17.4 and Sage 10.9 sources; the complete
squareclass producer checks every norm and square identity, rather than
trusting a cached number-field assertion. A formal proof in Lean is not
claimed.

## 7. Prior models, methods, and the precise contribution

### Bremner's sextic is the same model, not a new discovery

In [B, equation (26), p. 302], Bremner displays a degree-six rational
parameterization on his octic K3 surface. The subsequent \(m_{23}\)
residual, p. 303, contains
\[
 B(\lambda)=\lambda^6-2\lambda^5-87\lambda^4+
                   108\lambda^3+15\lambda^2+14\lambda+7.
\]
There is an exact \(\mathbf Q\)-isomorphism
\[
 (\lambda,y)\longmapsto(-\lambda,y):
       \{y^2=dB(\lambda)\}\ \simeq\ C_d.                          \tag{20}
\]
The inverse is the same map. It extends over infinity, where it may
exchange the two signed points. Thus changing the parameter's sign or
writing a different coefficient order cannot establish novelty.
A bounded Jacobian normal-form calculation reduces
\(f(x)-B(\lambda)\) to zero modulo \(\lambda+x\); its inspected contract,
exact payload, typed output and transport status are retained under
`research/branch483-publication/jacobian/`.
This calculation certifies (20), not a literature claim.

Bremner's following paragraph reports a parameter search with only
trivial cases at \(\lambda=\pm1\); it does not give a complete point
classification of the eight curves in Theorem 1. His \(m_{23}=gB\), where
\(g=[7,38,-9,-36,57,22,-23]\), has the ascending coefficient vector

```text
m23 = [49,364,574,948,3255,-3880,-2172,9352,
       -2865,-4548,2014,68,-23]
```

The separately discovered and inspected Jacobian square-free operation
returns one degree-twelve factor with multiplicity one and exactly
reconstructs this polynomial. Thus the individual \(m_{23}\) square
cover has genus five and is not isomorphic, even over
\(\overline{\mathbf Q}\), to \(H\) or \(X\).

There is also a model-independent obstruction to identifying **the full**
equation-(26) square cover with \(X\). Removing the displayed square
factor from \(m_{21}\), the three remaining radicands have degrees
eight, twelve and twelve; all are even. Their branch support over
\(\overline{\mathbf Q}\) has size at most 32, including no infinity
branch. Every geometric connected component of their three-square
cover has degree \(D\le8\), with inertia order two at a branch point.
For \(D>1\), Riemann--Hurwitz gives
\[
 g\le1-D+(D/4)\,32\le57;
\]
for \(D=1\) the component is rational. Therefore no component can be
birational to the genus-161 curve \(X\), regardless of a change of
parameter, square-factor removal or relabeling of roots. This genus
comparison alone does not rule out nonconstant maps. Section 8 strengthens
it: the exact full cover has genus 57 and there is no nonconstant
\(\mathbf Q\)-morphism from \(X\) to that cover. It still does not exclude
an earlier arithmetic implication through some other curve or construction.

The degree-fourteen family (5)--(6) is specified separately. In
particular, the theorem is not described as a completion of every
residual condition following Bremner's equation (26).

### Complete arithmetic predecessors, not just general methods

The relevant earlier paper is [BI], *On squares of squares*, Acta
Arithmetica 88 (1999), 289--297, cited as reference [3] in [B].
Its title and bibliographic identity are verified from the primary source.
The family in [BI, (5)--(7), pp. 291--292] already has nine square
entries, but only seven of its eight line sums agree. Its construction
uses
\[
 \lambda(\lambda^2-1)Y^2=X(X^2-1)
\]
over \(\mathbf Q(\lambda)\). For the particular degree-eight family
in (12), the remaining diagonal equality is exactly
\[
 1-4s^2-170s^4-36s^6+81s^8=0.
\]
Bremner states that this polynomial is irreducible over \(\mathbf Q\)
[BI, (13), p. 293]. This is a complete exclusion for that affine
parameter condition, not a genus-two point classification. The hypotheses
are different in a mathematically consequential way: (5)--(7) here are
already magic, and the three missing *entries* must be squares.
The function-field elliptic construction in [BI] does not determine
the number-field rank or \(\Sha\) in (2).

[B] also contains a complete arithmetic application distinct from its
equation-(26) search. For Category II, family (9), the center-square
condition becomes
\[
 v^2=(1+u)(1+9u)(1-2u+9u^2),\qquad u=\mu^2.
\]
The printed rank-zero argument forces the affine rational parameter
\(\mu=0\), giving a trivial square [B, p. 295, Remark after (10)].
The adjoining genus-three corner condition is expressly left unproved.
Thus neither paper is being dismissed as containing only experiments:
the complete exclusions they do prove apply to their specified conditions,
not to the degree-fourteen Category III family or the eight twists here.

A closer methodological predecessor is the **complete application** in
[Br, Proposition 5.1, p. 46], which determines
\(\varphi_i(E_i(L))\cap\mathbf P^1(\mathbf Q)\) for twelve specified
elliptic covers. For example, the rational-image set of its \(E_7\) is
exactly \(\{1,1/3,3\}\), with quartic model
\[
\begin{split}
 L&=\mathbf Q(\zeta),\quad
       \zeta^4-\zeta^3+\zeta^2-\zeta+1=0,\\
 2(1-\zeta+\zeta^2)Y^2
   &=X^4-\zeta X^3+\zeta^2X^2-\zeta^3X+\zeta^4,\quad\varphi_7=X.
\end{split}
\]
Bruin's worked proof uses a 2-isogeny descent to obtain an odd-index
subgroup and local logarithms at 31 to exclude 31 from its index.
The reduction groups at the four places over 31 have order 32, so
index prime to \(2\cdot31\) is sufficient; full generation is explicitly
not required [Br, pp. 46--48]. This is the substantive predecessor of
Lemma 3's index principle, not merely a general discussion of Chabauty.
Here \(E_7\) is Bruin's elliptic-cover index; it must not be confused
with the separately indexed genus-two curve \(C_7\) in his Table 3.

There are also actual complete genus-two classifications to compare.
Bruin's Table 3, Lemma 3.14 and the proof of Theorem 1.3 determine:

| Bruin's curve | Defining radicand | Complete rational points |
|:---|:---|:---|
| \(C_5^{\mathrm{Br}}\) | \(X^6+40X^3-32\) | \(\infty_\pm,(1,\pm3)\) |
| \(C_7^{\mathrm{Br}}\) | \(X^6+6X^5-15X^4+20X^3+15X^2+30X-17\) | \(\infty_\pm,(1/2,\pm15/8)\) |
| \(C_9^{\mathrm{Br}}\) | \(X^6-6X^5+45X^4-180X^3+135X^2+162X-405\) | \(\infty_\pm,(9/2,\pm387/8)\) |

Each has four rational points; every \(C_d\) in Theorem 1 has zero or
two. This excludes a \(\mathbf Q\)-isomorphism, not just an equality of
printed polynomials. The negative twists \(C_6^{\mathrm{Br}},
C_8^{\mathrm{Br}},C_{10}^{\mathrm{Br}}\) are excluded too: twisting
an alleged isomorphism by \(-1\), using the unique hyperelliptic
involution, would identify the corresponding positive curve with
\(C_{-d}\). The remaining curves in Bruin's Table 3 have either a
rational quadratic branch factor (\(C_1,C_2,C_{11},C_{12}\)) or
rational Weierstrass points (\(C_3,C_4\)). Our irreducible sextic
has a single degree-six Weierstrass orbit, which a rational
hyperelliptic model transformation must preserve. These are intrinsic
arithmetic obstructions to the relevant model identifications.
For two genus-two curves, Riemann--Hurwitz forces any nonconstant
morphism to have degree one, so these comparisons also exclude
direct transfer by a rational curve morphism.

For \(C_5^{\mathrm{Br}}\) there is a geometric obstruction as well.
If \(\omega^2+\omega+1=0\), then
\[
 (X,Y)\longmapsto(\omega X,Y)
\]
is an order-three automorphism. Its action on \(dX/Y,X\,dX/Y\)
has eigenvalues \(\omega,\omega^2\), and hence is not \(\pm1\).
Its geometric Jacobian endomorphism ring is therefore not \(\mathbf Z\),
whereas (24) gives \(\mathbf Z\) for every quadratic twist of \(C_1\).
Consequently the models are not even geometrically isomorphic.
The new bounded normal-form calculation verifies
\[
 (\omega X)^6+40(\omega X)^3-32-(X^6+40X^3-32)=0
       \pmod{\omega^2+\omega+1};
\]
its exact request and complete typed zero remainder are retained in
`jacobian/bruin-order-three-{payload,output}.json`. The argument uses
the accepted (24), not a new endomorphism replay.

The global arithmetic difference from Bruin's worked example is not simply a larger
field degree. Bruin's other applications include fields specified by
degree-twelve polynomials. Rather, our elliptic curve has no rational
two-torsion over its sextic base, and its cubic descent requires the
actual degree-eighteen norm-square space (16). A three-dimensional
first Selmer group alone leaves rank one *or three*. The completed
global space and the nonzero pairing (19) resolve that ambiguity and
determine the full two-primary \(\Sha\); only then can the sufficient
index information at 23 prove the untwisted genus-two point set.
The published finite-index principle is reused, while these specific
global arithmetic conclusions and complete point sets are the
contribution submitted here.

### Comparison with Auel--Singer

We compare with the actual text of [AS], **arXiv:2609.09351v1**.
Theorems 1--3, pp. 3--4, determine the geometric automorphism group,
topological/Hodge invariants and bounds on the geometric Picard rank of
the magic-square surface. Section 4.2, pp. 28--32, identifies orbit 3
with Bremner's octic K3 \(Y\). Proposition 4.11 classifies fourteen magic
octic K3 surfaces up to automorphism; Proposition 4.12 proves twisted
derived equivalence of associated K3 resolutions **over \(\mathbf C\)**.
These are geometric assertions about surfaces, not enumerations of
\(C_d(\mathbf Q)\), \(H(\mathbf Q)\), or \(X(\mathbf Q)\).
Their symbol \(X\) denotes an orbit-7 K3 surface, not the curve (1).
Derived-category twists are Brauer twists of sheaves, not the quadratic
twists \(C_d\). Neither terminology nor matching an ambient K3 gives
an isomorphism of the arithmetic curve models.

The earlier [BTV, arXiv:1912.08908v3, Theorem 1.5, p. 7] proves
algebraic quasihyperbolicity of the complex magic-square surface.
Its assertion is finiteness of curves of geometric genus zero or one,
not a complete rational-point set. It therefore does not supply the
effective classifications (3)--(4). The present theorem does not
improve that geometric finiteness theorem or establish quasihyperbolicity
for a new surface.

### Comparison with a complete curve-rigidity theorem

The actual primary generalized-Fermat result is [HKLP, Theorem 3,
Section 2.2, p. 5]. In characteristic zero it proves uniqueness of the
generalized Fermat group of type \((k,n)\), and a monomial description
of the full automorphism group, when \((k-1)(n-1)>2\). Its defining
hypothesis is a group \((\mathbf Z/k\mathbf Z)^n\) whose quotient is
\(\mathbf P^1\) with exactly \(n+1\) branch points of order \(k\).
It is not a theorem for an arbitrary many-branch
\((\mathbf Z/2\mathbf Z)^3\) cover. In particular a type \((2,3)\)
cover has only four branch points and genus one, not our 84 branch
points and genus 161.

This mismatch cannot be concealed by choosing a different abstract
generalized-Fermat model. The primary genus formula is
\[
 g(k,n)=1+\frac{k^{n-1}}2\bigl((n-1)(k-1)-2\bigr).
\]
It is increasing in \(k\ge2\) for each \(n\). The adjacent values
bracketing 161 are:

| \(n\) | Adjacent \(k\)'s | Corresponding genera |
|---:|:---:|:---:|
| 2 | 19,20 | 153,171 |
| 3 | 6,7 | 145,246 |
| 4 | 3,4 | 55,225 |
| 5 | 2,3 | 17,244 |
| 6 | 2,3 | 49,973 |
| 7 | 2,3 | 129,3646 |

For \(n\ge8\), even \(k=2\) gives genus at least 321.
Thus no generalized Fermat curve of any type has genus 161.
Our cover can be studied as a quotient of a much larger multiquadratic
cover, but a uniqueness theorem for that larger curve does not assert
uniqueness of a pencil or an automorphism group for its quotient.
Also, uniqueness of a distinguished deck subgroup does not say that
every automorphism lies in it: permitted branch permutations can
enlarge the full group. Theorem 2 instead eliminates rational base
permutations using the actual degree-six closed branch point and (24),
and determines all rational involution quotients. Neither the
generalized-Fermat theorem nor the surface statements above give
these rational conclusions or Theorem 1's point sets.

The unique pencil supplies a concrete test for any further plausible
degree-eight predecessor, not an invitation to compare coefficient
strings. If \(Z/\mathbf Q\) has a degree-eight map \(t\) to
\(\mathbf P^1\) and \(\phi:X\to Z\) is a rational isomorphism, then
\[
                  t\circ\phi=\beta\circ x,\qquad
                  \beta\in\operatorname{PGL}_2(\mathbf Q).
\]
Its branch divisor, including inertia data up to conjugation of the
deck group when the cover is Galois, must be transported by \(\beta\).
In particular the degrees of closed branch points must be
\(\{2,6,8,8,10,14,14,22\}\). This criterion handles arbitrary
rational reparameterization. For the identified full Bremner cover
the stronger accepted obstruction is already available: its genus
is 57, and Theorem 2 excludes *every* nonconstant rational morphism
to any curve of that genus. No claim about morphisms to all other
genera or about every possible indirect arithmetic construction
follows from this test.

### The techniques are established; the completed arithmetic is the candidate contribution

[BS2, Theorem 3.4 and Section 6] supplies the covering and global
squareclass framework, including its class/unit bottleneck.
[FSS, Theorem 5.2] already identifies the explicit pairing with
Cassels--Tate over arbitrary number fields without full rational
two-torsion. [Br, Section 4.2, Lemmas 4.1--4.3] treats elliptic points
with a base-field-rational parameter and explicitly relaxes full
Mordell--Weil generation to appropriate local/index information.
[BSM, Section 4.4] explains the combination with a Mordell--Weil sieve.
Lemmermeyer's norm-index criterion in Lemma 2 is also established prior
art. No new descent algorithm, pairing formula, or general saturation
principle is claimed here.

The mathematically substantive additional result relative to these
specified prior statements is the **unconditional explicit application**:
complete global norm-squareclasses for the actual degree-eighteen field,
the numerical rank and full two-primary \(\Sha\) in (2), and the
complete eight-twist and residual-cover point sets. The genus-two
Jacobian in the untwisted case has rank equal to the genus, so the
known-point table alone cannot finish it. A nonzero pairing on some
classes also cannot finish it until the global Selmer space is complete.
Lemma 2 discharges that missing global obligation; Lemma 3 and the
complete disk table discharge the remaining local-index obligation.
The resulting classification excludes an entire rational-parameter
family, not an enlarged finite search box.

The case for publishable significance rests on those completed
arithmetic obligations and their use in an effective family theorem.
It does **not** rest solely on the genus number 161, on a failed
absolute class-group computation, or on lack of an indexed polynomial
match. There is a clear comparison with the strongest prior campaign
result: a certified field isomorphism and a nonzero pairing previously
left rank and point determination conditional on unproved global
completeness. That condition is now removed, and (2)--(4) are
unconditional.

These comparisons establish what the named primary results do and do
not assert. They are not a proof that no equivalent classification exists
elsewhere. No identification with every reduced genus-two database model
or every unpublished computation is claimed. Independent assessment
must decide the original contribution and its significance before the
campaign labels either as verified. A source that supplies the same
complete arithmetic under an explicit rational model equivalence would
defeat the originality claim without changing Theorem 1's correctness.

Relative to the strongest already accepted campaign theorem, Theorem 2
adds pencil uniqueness, the exact rational automorphism group and a
nonconstant-map exclusion; it does not add rational points or repeat
the Selmer computation. In particular, different genera have been
replaced by a field-theoretic and involution-quotient argument.
This is an explicit rigidity application, not a claimed new
Castelnuovo--Severi inequality or endomorphism algorithm. Its absence
from the named primary statements is not by itself verified originality.
The combined contribution and its publishable significance remain for
independent assessment. Maps to other lower-genus quotients, including
the existing map \(X\to H\), are not excluded.

### Originality submission and field-level significance

The submitted original result is the **combined explicit unconditional
application**, not a new sextic or a new rigidity principle:
the complete norm-square kernel for the specified degree-eighteen field,
the numerical rank and full two-primary \(\Sha\), all eight twist point
sets, the complete rational-parameter family exclusion, and the pencil,
rational-automorphism and genus-57 morphism conclusions for its full cover.
The source comparisons above test actual complete applications:
Bremner's complete conditions quantify over different families; Bruin's
complete genus-two models fail intrinsic identification and morphism tests;
the generalized-Fermat classification cannot have this genus. The exact
shared sextic and the genuinely applicable finite-index method are
positively identified and attributed rather than advertised as discoveries.

The technical core is of arithmetic-geometric significance because it
closes the two obstructions that prevent the usual computations from being
a theorem. First, relative class parity and a complete unit basis *modulo
squares*, with exact ideal and norm transport, certify all global
Selmer directions without GRH or an unproved full integral-unit index.
Second, the nondegenerate residual pairing detects nontrivial
two-primary \(\Sha\) and lowers the elliptic rank enough for complete
rational-base Chabauty even though the original genus-two Jacobian has
rank equal to its genus. The local index argument then avoids an
unnecessary all-prime generator assertion. Together these give an
effective, independently replayable unbounded arithmetic classification
on a historically studied magic-square K3 family. The rigidity companion
shows why the specifically identified earlier full-cover classification
cannot be pulled back by a rational morphism. A high genus, a computation
time, or an enlarged finite search would not establish any of these facts.

On this basis the Engineer supports originality and publishable significance
of the exact combined application, while leaving the independent publication
verdict open. This is a mathematical contribution judgment, not a claim to
have searched every paper or unpublished computation. The bounded new trail
read Bremner I/II and Bruin's application statements, and one primary
generalized-Fermat rigidity theorem. Bruin's large KASH supplement was not
retrieved; the displayed genus-two models suffice for the specific intrinsic
comparisons above, but no broader claim about that supplement is made.
Secondary search suggestions were used only to locate primary sources;
misidentified titles and an erroneous secondary inequality were discarded.
The archived primary passages, not absence of search hits, are the evidence
submitted for independent assessment. Theorem 1 maps directly to the
operator-authorized global-completeness/rank/point-classification objective
(a); it does not substitute Theorem 2 or a geometric surface result for that
arithmetic objective, and does not claim the general magic-square problem
is solved.

## 8. Rational-map rigidity

### Every intermediate quotient

Work first over \(k=\overline{\mathbf Q}\). Write
\(F=k(X)\), \(K=k(x)\), and identify
\(\operatorname{Gal}(F/K)=G=\mathbf F_2^3\), with \(e_i\) changing
only \(y_i\). At each of the 28 roots of \(G_i\) the inertia subgroup
is \(\langle e_i\rangle\). The supports are disjoint; infinity is
unramified. These facts are the unchanged accepted factorization, not
new arithmetic assumptions.

For a subgroup \(H\le G\), let \(Y_H=X/H\) be the smooth projective
curve with function field \(F^H\), and put
\(m=[G:H]\), \(r=\#\{i:e_i\notin H\}\). Its map to the base has
exactly \(28r\) branch points, each of inertia two. For \(m>1\),
Riemann--Hurwitz gives
\[
 2g(Y_H)-2=-2m+(m/2)\,28r,\qquad
 g(Y_H)=1-m+7mr.                                                \tag{21}
\]
For \(H=G\) it is the rational base itself. Thus all sixteen
subgroups, not just the seven character quotients, give:

| \(H\) | Number | Degree \(m\) to the base | Genus |
|:---|---:|---:|:---|
| \(G\) | 1 | 1 | 0 |
| \(\ker w\), \(w\ne0\), weight \(j=1,2,3\) | \(3,3,1\) | 2 | \(14j-1=13,27,41\) |
| \(\langle e_i\rangle\) | 3 | 4 | 53 |
| \(\langle v\rangle\), weight \(v\ge2\) | 4 | 4 | 81 |
| \(\{0\}\) | 1 | 8 | 161 |

Here weight means the number of nonzero coordinates. The quadratic
quotient for \(w\) has equation
\(z^2=\prod_{w_i=1}G_i(x)\); the other rows follow directly from (21).
All the fields remain connected over \(k\), by the independent odd
branch valuations. The certificate enumerates each subgroup and its
annihilator characters explicitly.

### Bidegree genus and the actual common field

We use the following elementary form of the known bidegree genus bound.
If two functions generate the function field of a smooth projective curve
\(Y\), and their maps to \(\mathbf P^1\) have degrees \(m,n\), their
image in \(\mathbf P^1\times\mathbf P^1\) is an integral divisor \(D\)
with those projection degrees, and \(Y\) is its normalization.
The divisor exact sequence and
\(\chi(\mathcal O(a,b))=(a+1)(b+1)\) give
\(p_a(D)=(m-1)(n-1)\). The normalization sequence has a
zero-dimensional cokernel of nonnegative length, so
\[
                    g(Y)\le(m-1)(n-1).                         \tag{22}
\]
This proves the needed inequality without invoking a field-generation
hypothesis that has not been established.

Let \(t\) be any nonconstant function on \(X_k\) of degree \(d\le8\).
Set \(L=k(x,t)\), \(h=[F:L]\). Since \(F/K\) is the Galois
extension above, \(L=F^H\) for a subgroup \(H\) of order \(h\);
also \(h\) divides \(d\). On the smooth curve with field \(L\), the
functions \(x,t\) really do generate the field, with degrees
\[
                     m=8/h,\qquad n=d/h\le m.
\]
If \(m=8,4,2\), its genus is respectively at least \(161,53,13\);
these exceed \((m-1)^2=49,9,1\). This contradicts (22) in every
proper-intermediate case. If \(m=1\), then \(L=K\),
\(d=8n\), hence \(d=8,n=1\) and \(k(t)=k(x)\).
Thus there is no smaller pencil, and every degree-eight pencil is
\(t=\beta(x)\) for \(\beta\in\operatorname{PGL}_2(k)\).
If \(t\) is defined over \(\mathbf Q\), uniqueness and Galois descent
make \(\beta\) an automorphism of \(\mathbf P^1_{\mathbf Q}\).

### The endomorphism input and rational base symmetries

We justify the recorded
`geometric_endomorphism_ring_is_ZZ(B=200, proof=True)` result for
\(J(C_1)\) by small explicit finite inputs, rather than treating
geometric simplicity as the needed stronger statement.
The sextic has smooth reduction at 5 and 13. Counting all affine
points and the two infinities over \(\mathbf F_p,\mathbf F_{p^2}\)
gives:

| \(p\) | \(\#C_1(\mathbf F_p)\) | \(\#C_1(\mathbf F_{p^2})\) | Frobenius polynomial \(P_p(T)\) |
|---:|---:|---:|:---|
| 5 | 8 | 40 | \(T^4+2T^3+9T^2+10T+25\) |
| 13 | 16 | 200 | \(T^4+2T^3+17T^2+26T+169\) |

The middle coefficients are nonzero modulo \(p\), so both reductions
are ordinary [Lo, Lemma 2.9]. Their Frobenius fields are
\[
 E_5=\mathbf Q(\sqrt2,\sqrt{-17-2\sqrt2}),\qquad
 E_{13}=\mathbf Q(\sqrt{10},\sqrt{-41-2\sqrt{10}}).                \tag{23}
\]
Indeed \(P_p(T)=(T^2+T+p)^2-DT^2\) for \(D=2,10\);
if \(\alpha\) is a root, then
\(u=\alpha+p/\alpha=-1\pm\sqrt D\).
The imaginary radicand is negative in both real embeddings,
so the fields have degree four and \(P_p\) is irreducible.
The two radicand norms are \(281,1641\), respectively.
Neither is a square in its real quadratic field: a rational number
is a square in \(\mathbf Q(\sqrt D)\) only if it or its quotient
by \(D\) is a rational square.
Consequently the quartic fields are nonnormal. Otherwise the
conjugate imaginary radicand would become a square in the same
quadratic extension, forcing its norm to be a square in the real
field. A nonnormal quartic field containing a quadratic field has
no second quadratic subfield, since two would make it biquadratic.
Thus the indicated real fields in (23) are the unique quadratic
subfields, and they are not isomorphic.

For completeness, the finite certificate also proves absolute
simplicity, not just irreducibility over the residue field.
For each \(p\) it forms
\[
 R_p(t)=\operatorname{Res}_z(P_p(z),P_p(tz)).
\]
This degree-sixteen polynomial has precisely the Frobenius root
ratios as its roots. The factor \(t-1\) has multiplicity four.
For every \(2\le n\le512\) with \(\varphi(n)\le16\), exact
polynomial gcd gives \(\gcd(R_p,\Phi_n)=1\).
This exhausts all possible nontrivial roots of unity:
\(\varphi(n)^2\ge n/2\), as follows by multiplying
\(p^{a-2}(p-1)^2\) over \(p^a\Vert n\).
Every odd-prime factor is at least one and only the factor at 2
can be as small as \(1/2\).
Hence no two distinct Frobenius roots have a root-of-unity ratio.
Their positive powers remain distinct, so the polynomial with
roots \(\alpha_i^N\) remains irreducible of degree four for every
\(N\). A proper abelian subvariety over any finite extension
would give a proper rational Frobenius factor, a contradiction.
Both reductions are therefore absolutely simple.

Specialization at good reduction injects geometric endomorphisms
after a finite extension where they are defined; this can be seen
on any prime-to-\(p\) Tate module. For these ordinary absolutely
simple reductions the geometric rational endomorphism algebra is
\(E_p\), unchanged by residue extension [Lo, Lemma 2.9].
Thus \(\operatorname{End}^0_{\overline{\mathbf Q}}J(C_1)\)
embeds into both fields in (23). It is consequently a field of
degree dividing four. Degree two would identify their unique
quadratic subfields, and degree four would identify the whole
fields and hence those subfields. Both are impossible. Its degree
is one, and integrality of endomorphisms gives
\[
                 \operatorname{End}_{\overline{\mathbf Q}}
                         J(C_1)=\mathbf Z.                     \tag{24}
\]
This is an explicit justification of the existing certificate,
not a new endomorphism-detection method or an arithmetic rank computation.

Now take \(\sigma\in\operatorname{Aut}_{\mathbf Q}(X)\).
Pencil uniqueness gives \(x\circ\sigma=\beta\circ x\) with
\(\beta\in\operatorname{PGL}_2(\mathbf Q)\). It preserves the branch
divisor. A rational base automorphism preserves the degrees of
closed points. The eight irreducible branch factors have degrees
\(6,22,2,8,8,10,14,14\), so the unique degree-six factor \(f\)
must be preserved. Over \(\overline{\mathbf Q}\), a base
automorphism preserving its six roots lifts to an automorphism
of \(C_1:y^2=f(x)\): the transformed binary sextic is a scalar
multiple, and that scalar has a square root.
Its induced Jacobian automorphism is a unit in (24), hence
\(\pm1\). On the two-dimensional space of holomorphic
differentials this is scalar, so it acts trivially on the
canonical map \([dx/y:x\,dx/y]=[1:x]\). Therefore
\(\beta\) is identity. The kernel of the base action is exactly
the already known Galois group \(G\), proving the asserted
rational automorphism group. Merely knowing that the Jacobian
is geometrically simple would not justify this scalar-action step.

### Involution quotients and the exact prior full cover

Each individual sign change \(e_i\) fixes the four points above
each of the 28 roots of \(G_i\), hence 112 geometric points.
Every other nonidentity sign change fixes none, because it is
in no inertia subgroup. There are no additional fixed points
at infinity. For the smooth quotient by an involution \(\tau\),
Riemann--Hurwitz gives
\[
          320=2(2g(X/\tau)-2)+\#\operatorname{Fix}(\tau),
\]
so the quotient genera are 53 and 81, agreeing with (21).
This determines all rational involution quotients, not just a
selection of natural ones.

To identify the target exactly, use Bremner's three residuals
after equation (26), with the displayed square in \(m_{21}\)
removed:
\[
\begin{aligned}
 B_1(\lambda)&=1-200\lambda-436\lambda^2+232\lambda^3+
 94\lambda^4-88\lambda^5+860\lambda^6-520\lambda^7+73\lambda^8,\\
 B_2(\lambda)&=(5-4\lambda+\lambda^2)(1+4\lambda+5\lambda^2)
             (1+18\lambda^2+\lambda^4)(5-6\lambda^2+5\lambda^4),\\
 B_3(\lambda)&=g(\lambda)B(\lambda),
\end{aligned}
\]
where \(g,B\) are the explicit sextics in Section 7.
Let \(\mathcal B\) be the smooth projective normalization of
\(z_i^2=B_i(\lambda)\), \(i=1,2,3\).
Exact polynomial gcd checks show that the three residuals are
squarefree and pairwise coprime of degrees \(8,12,12\).
Their classes are geometrically independent by odd valuations,
and infinity is unramified. Thus this cover is geometrically
connected of degree eight, with 32 branch points, and
\[
                g(\mathcal B)=1-8+2\cdot32=57.                  \tag{25}
\]
Removing the square factor changes the displayed affine
coordinates, not this smooth projective function field.

If a nonconstant \(\mathbf Q\)-morphism from \(X\) to a smooth
genus-57 curve existed, Riemann--Hurwitz would give
\[
                         320\ge112d,
\]
so its degree \(d\) would be one or two. Degree one would be an
isomorphism of smooth projective curves, contradicting the genera.
In degree two the extension of rational function fields is
quadratic and separable. Its nontrivial automorphism extends to
a rational involution of \(X\), and the target is its smooth
quotient. Neither possible quotient genus is 57. This proves the
last assertion of Theorem 2, in particular for (25).

The rerunnable source `map-rigidity/verify_rigidity.py` checks every
finite input just used, all sixteen subgroup records, and the
exact prior full-cover genus. The isolated Jacobian operation is
the inspected degree-eight resultant for \(P_5P_{13}\); its typed
output is compared exactly with the defining resultant. It supplies
an algebraic computation, not the proof strategy or a publication
verdict. No point, Selmer or pairing certificate from Theorem 1
has been changed or rerun.

From the campaign root, the exact finite replay is:

```bash
/home/argustest/zimo/argus-live-update/.venv/bin/python \
  research/branch483-publication/map-rigidity/verify_rigidity.py
```

It checks the saved typed resultant without requiring a live sidecar,
and writes `map-rigidity/rigidity-certificate.json`. The source and
certificate verify finite inputs to the prose proof, not a formal proof
or an independent originality verdict.

## References

- **[BI]** Andrew Bremner, *On squares of squares*, Acta Arithmetica
  88(3) (1999), 289--297, doi:10.4064/aa-88-3-289-297,
  equations (5)--(7), pp. 291--292, and (12)--(13), p. 293.
  https://www.impan.pl/shop/publication/transaction/download/product/110732
- **[B]** Andrew Bremner, *On squares of squares II*, Acta Arithmetica
  99(3) (2001), 289--308, doi:10.4064/aa99-3-6. Equation (26),
  pp. 302--303, and its following residual and search paragraph.
  The separate complete Category II center condition is the Remark
  following (10), p. 295.
  The published excerpt was independently attributed in the accepted
  arithmetic review.
- **[AS]** Asher Auel and Benjamin Singer, *The algebraic geometry of 3-by-3 magic squares
  of squares*, arXiv:2609.09351v1 (8 September 2026), Theorems 1--3
  and Section 4.2, Propositions 4.11--4.12.
  https://arxiv.org/pdf/2609.09351v1
- **[BTV]** Nils Bruin, Jordan Thomas, Anthony Varilly-Alvarado,
  *Explicit computation of symmetric differentials and its application
  to quasi-hyperbolicity*, arXiv:1912.08908v3 (12 October 2021),
  Theorem 1.5. https://arxiv.org/pdf/1912.08908v3
- **[Br]** Nils Bruin, *Chabauty methods using elliptic curves*,
  J. reine angew. Math. 562 (2003), 27--49,
  doi:10.1515/crll.2003.076, Section 4.2, pp. 42--45;
  Tables 1, 3--4, Lemma 3.14, Proposition 5.1 and the proof of
  Theorem 1.3, pp. 46--49.
  Published author-hosted copy:
  https://www.cecm.sfu.ca/~nbruin/bruin_crelle.pdf
- **[BS2]** Nils Bruin and Michael Stoll, *Two-cover descent on
  hyperelliptic curves*, arXiv:0803.2052v2 (21 October 2008),
  Theorem 3.4 and Section 6. https://arxiv.org/pdf/0803.2052v2
- **[BSM]** Nils Bruin and Michael Stoll, *The Mordell--Weil sieve*,
  arXiv:0906.1934v2 (30 November 2009), p. 2 and Section 4.4,
  pp. 16--17. https://arxiv.org/pdf/0906.1934v2
- **[FSS]** Tom Fisher, Edward F. Schaefer and Michael Stoll,
  *The yoga of the Cassels--Tate pairing*, arXiv:0710.2079v1
  (10 October 2007), Section 2 and Theorem 5.2.
  https://arxiv.org/pdf/0710.2079v1
- **[L]** Franz Lemmermeyer, *The Ambiguous Class Number Formula
  Revisited*, arXiv:1309.1071v1, Introduction, Theorem 1,
  equation (1) and the following local-norm paragraph.
  https://arxiv.org/html/1309.1071v1
- **[MS]** J. Steffen Mueller and Michael Stoll, *Canonical Heights on
  Genus Two Jacobians*, arXiv:1603.00640v2, Theorem 11.3, Lemma 16.1,
  Sections 17--18. The established arithmetic dependency and its
  citation are reused from the accepted rank-one classification.
- **[FS]** E. V. Flynn and N. P. Smart, *Canonical heights on the
  Jacobians of curves of genus 2 and the infinite descent*, Acta
  Arithmetica 79 (1997), 333--352, Sections 7--8, pp. 343--346,
  urn:eudml:doc:206982. The accepted rank-one index argument is reused.
- **[Lo]** Davide Lombardo, *Computing the geometric endomorphism ring
  of a genus 2 Jacobian*, arXiv:1610.09674v2, Section 2.3,
  Lemma 2.9. https://arxiv.org/pdf/1610.09674v2.
  The finite-reduction principle is established prior art; the
  explicit calculations (23)--(24) are supplied here.
- **[HKLP]** Ruben A. Hidalgo, Aristides Kontogeorgis,
  Maximiliano Leyton-Alvarez and Panagiotis Paramantzoglou,
  *Automorphisms of Generalized Fermat Curves*, arXiv:1409.3063v2,
  Section 2, equation (1), and Section 2.2, Theorem 3, pp. 3,5.
  https://arxiv.org/pdf/1409.3063v2

The primary PDFs/text used for the new comparisons are retained in
`research/branch483-publication/sources/`. Bremner's and Lemmermeyer's
previously attributed primary excerpts remain in the accepted
`relative-squareclasses/` directory; their arithmetic review is reused.
The additional complete-application passages are in
`sources/arithmetic-comparison/`; the generalized-Fermat theorem passage
is `sources/hidalgo-theorem-3-excerpt.txt`.
