# Exact local-order verification of the promised norm solver

## Statement and boundaries

The target is Theorem `norm:solve` in the staged manuscript, Section 3.
This report concerns that theorem, not the companion's analytic theorem
or the unconditional polynomial-factorization conclusion.
No false literal assertion has yet been established. In particular,
the factorization oracle allowed in the general Ivanyos--Kutas--Ronyai
algorithm is not an objection to a separately proved cyclic construction.
An example is not a parameter-uniform proof, and an Engineer judgement
is not independent Reviewer approval.

We prove the following verification theorem, with a smaller sufficient
precision budget than the manuscript uses.

**Verification theorem.** Under exactly the hypotheses of `norm:solve`,
put \(d=\deg\operatorname{rad}(FAB)\) and \(L=N+D+2\), where \(G=A/B\)
is reduced. For every choice of the promised residue roots in the stated
local models, all global sections are exactly the solutions of the
finite linear systems on
\[
 c_{ab}=P_{ab}/H^L,\qquad \deg P_{ab}\le L(d+1).
\]
The systems need only precision \(2L+1\), supplied by simple-root
Hensel lifts to precision \(3L+3\). Their infinity evaluation image
contains a rank-one idempotent. The manuscript's lift, power, and final
linear solve consequently return an element of norm \(G\). All dimensions,
degrees, and bit costs are bounded by fixed polynomials in
\(q,N,D,\log|k|\), with no irreducible-factorization oracle.
The manuscript's larger \(M=10q^2(N+D+1)\) therefore works as well.

This is an independent proof and an exact diagnostic of the proposed
construction, not a claim that the entire theorem has been encoded in
Lean. The formal certificate is restricted to the declarations named
in `statement_fidelity.md`. Novelty and publishability require independent
assessment; the absence of a matching source in a bounded search proves
neither.

The Jacobian adapter's finite-field map request was rejected with typed
`INVALID_REQUEST`: its presentation validator excludes a linear modulus,
although that numeric restriction was absent from the returned schema.
The exact discovery, contract, payload, and structured error are preserved
in the dedicated `jacobian_*.json` files. This is a capability finding,
not evidence for or against any mathematical assertion. The separately
inspected rank contract did not match the needed prime-field matrix
problem without introducing different objects; none was forced onto it.

## Source findings and literature scope

The following are source findings, not assumptions that their conclusions
have been independently proved.

* `03-norms.tex`, lines 43--51, explicitly acknowledges the factorization
  oracle in the general IKR algorithm and claims to replace it by cyclic
  local models and a fiber calculation.
* `02-finite-fields.tex`, `ff:unitroot`, states deterministic extraction of
  a promised qth power in a finite reduced algebra, with a supplied
  constant-field primary generator and \(p>(\deg H)^2\).
* `03-norms.tex`, `norm:bundle-split`, supplies a proof of splitting on
  the projective line over the original constant field and cites
  Hazewinkel--Martin (1982).
* `10-analytic.tex`, `analytic:hecke`, attributes a uniform Hecke zero-free
  strip to the companion's Theorem 1.2. The previously reported quotation
  fidelity is not validation of that theorem, and this work does not
  use it.

The source chain is
`ff:unitroot -> norm:solve -> div:divide -> odd:split ->
driver:correctness/complexity:bound -> thm:reduction`.
The separate `analytic:hecke -> analytic:auxiliary` branch is needed for
`thm:factorization`, not for `thm:reduction` or the norm theorem.
Divisor arithmetic, rational lift classes, and geometric separation
are additional inputs to `odd:split`; this report does not certify them.

A bounded literature search did not obtain a primary-source proposition
establishing this exact factorization-free promised norm construction.
It did not establish novelty. The primary IKR source was subsequently
obtained: arXiv:1508.07755v3, Abstract and Theorem 1
(https://arxiv.org/html/1508.07755v3). It explicitly defines an f-algorithm
to allow the finite-field polynomial-factorization oracle. The short
passage and its scope are in `ikr_primary_excerpt.txt`. Its general
intersection-of-orders strategy is prior art, not a novelty claimed here.
The Hazewinkel--Martin bibliographic attribution remains source-qualified;
the bundle proof above does not rely on obtaining that paper.

## 1. Residue roots do not conceal irreducible factorization

Here is the algebraic content of `ff:unitroot`, independently checked.
Distinct-degree decomposition uses gcds with \(X^{Q^e}-X\), so produces
equal-degree parts without factoring them. On a degree-e part, set
\(Q^e-1=q^s t\), with \(q\nmid t\). If \(q\nmid e\), the supplied
constant-field generator already has order \(q^s\).
Otherwise solve the linear equation
\(v^{Q^{e/q}}=\zeta v\).
On each field component a nonzero solution exists because
\(\zeta^{1+Q^{e/q}+\cdots+Q^{(q-1)e/q}}=1\).
If such a solution has order with q-adic valuation r, the equality
\(v^{Q^{e/q}-1}=\zeta\), together with
\(v_q(Q^{e/q}-1)=s-1\), forces \(r=s\).
This last valuation identity follows by binomial expansion for odd q.

For a kernel basis \(v_0,\ldots,v_{r-1}\), each component excludes at
most \(r-1\) scalars from \(\sum c^jv_j\). With at most h components
and \(r\le h\), fewer than \(h^2\) scalars are excluded. The stated
characteristic hypothesis makes \(0,\ldots,h^2\) distinct. A gcd tests
unit status. Raising a unit candidate to t gives the primary generator.
Primary discrete logarithms are recovered digit by digit, partitioning
by gcds at equality tests; at most h pieces coexist. The promised
qth-power property says that every resulting logarithm is divisible
by q. The prime-to-q part is rooted by a modular inverse exponent.
Chinese remaindering finishes the root.

The representation dimensions are at most h; powering exponents have
bit length \(O(h\log Q)\); the scalar search has \(h^2+1\) trials.
Thus this is a deterministic polynomial-time routine, not an oracle.
The theorem's \(p>(N+2D+1)^2\) implies the needed bound for every group.

## 2. Local models and the uniform coordinate bound

An irreducible factor of the positive-degree square-free F gives a place
of valuation one. The polynomial \(Y^q-F\) is Eisenstein there, so \(\mathcal L\) is
indeed a degree-q field extension, not a product that would invalidate
the extraction argument.

Square-free decomposition of A and B, refined by gcds with F and with
each other, gives coprime square-free groups \(H_i\). Degrees are below
p, so no inseparable residual case occurs. At a place in a group,
\(T=H_i\) is a uniformizer, even when the group has several factors.
The quotient modulo \(H_i^s\) is the product of the corresponding
ordinary-local quotients; no factors need be known.

The norm promise splits the cyclic algebra by the existence-only action
\(Y:m_Y,\ V:h_0\rho\). Independence of the q automorphisms follows from
the invertible Fourier matrix \((\zeta^{ij})\). This proves existence
of a matrix algebra, but the algorithm does not use \(h_0\).

At a ramified place, \(V'=Y^{-w}V\) has unit qth power \(G/F^w\).
The norm of \(Y\) is F because q is odd. The valuation of the norm of
an element is its normalized upstairs valuation at this totally
ramified place. Reduction of a unit norm is a qth power. This supplies
the root R used in the diagonal model. With \(D_R e_j=\zeta^jRe_j\),
\[
 YD_R=\zeta^{-1}D_RY,\qquad
 (Y^wD_R)^b=\zeta^{wb(b-1)/2}Y^{wb}D_R^b.
\]
Thus the sign of the manuscript's commutation factor is correct.
For every integer t, the nonzero entry of \(Y^t\) in column j has
valuation \(\lfloor(j+t)/q\rfloor\), including negative t. For
\(t=a+wb\), its absolute value and the inverse bound are at most D+2.

At an unramified place with \(q\nmid w\), a non-qth-power residue of F
would give an unramified field extension of prime degree q. Every norm
valuation would then be divisible by q. Thus a residue root S exists.
The diagonal \(Y\) with entries \(\zeta^{-j}S\) and weighted shift V
satisfy \(VY=\zeta YV\), including the wraparound column. Entries of
\(V^b\) have valuations 0 or w; inverse entries have opposite valuations.
If \(q\mid w\), scaling V by \(T^{-w/q}\) gives the unit-monomial order.

At infinity, \(z^{N/q}Y\) is diagonal with a simple-root Hensel lift
of constant term 1, and V is the same weighted shift. The basis-entry
and inverse-entry bounds are N+D. Each local matrix model is a full
matrix algebra: interpolation in the distinct diagonal entries gives
diagonal units, and the invertible shift gives all other units.
The integral matrix order is maximal, since multiplication by matrix
units and integral traces detects every entry of an overorder. Trace
integrality here is not an extra assumption: the regular left action
on the finite free order has integral trace, and that trace is q times
matrix trace; q is a unit.
The scaled-basis order is maximal by its integral trace-dual basis.

Finally
\[
 c_{ab}=q^{-1}\operatorname{tr}(cW_{ab}^{-1}).
\]
The field characteristic does not divide q. In a matrix order the
entries of c are integral, so the inverse-entry bound bounds each
coordinate below by \(-L\). The scaled-basis change has exponents
at most D and gives the same conclusion. Away from the exceptional
places, the unscaled monomials form the order and coordinates are
integral. This proves the claimed bound \(L=N+D+2\).

## 3. Exactness of finite precision and completeness

Here is the precise link to the formal power-series theorem, including
non-rational finite places. For residue field \(\kappa_v\) of cardinality
Q_v, every residue root of \(Z^{Q_v}-Z\) lifts uniquely to the complete
valuation ring, since its derivative is -1. These lifts form a subfield:
Q_v-power Frobenius respects addition and multiplication, and uniqueness
identifies sums and products with the corresponding residue lifts.
Successive residue subtraction and division by T, followed by
completeness, identify the ring with \(\kappa_v[[T]]\). Thus the formal
theorem applies componentwise over \(\kappa_v\), not necessarily over k.
This identification is used only to justify coefficient language.
The algorithm does not construct coefficient fields or irreducible
factors: multiplication and divisibility in the known quotient
\(k[X]/H_i^s\) compute the same local residue classes intrinsically.
At infinity the coefficient field is k itself. This distinction matters:
the degree-less-than-\(\deg H_i\) representatives in H_i-adic arithmetic
need not themselves form a coefficient subfield.

A rational coordinate integral away from H, with poles of order at
most L along H, is \(P/H^L\). Its infinity order is
\(L\deg H-\deg P\). The bound \(-L\) therefore gives exactly
\(\deg P\le L(\deg H+1)\). This proves inclusion of **every** section
in the ansatz, not merely a bounded search for some sections.

At an exceptional finite place or infinity, write a coordinate and
a basis-matrix entry as \(T^{-L}C_i\) and \(T^{-L}E_{ij}\), respectively,
with C and E integral. Each matrix entry of a candidate section is
\[
 T^{-2L}\sum_i C_iE_{ij}.
\]
It is integral if and only if the sum has all coefficients of degrees
less than 2L zero. Its reduction, once integral, is the coefficient
of degree 2L. Both depend only on C and E modulo \(T^{2L+1}\).
The same statement holds componentwise at a group and for the
scaled-basis coordinates. It is an equivalence, so no spurious
solutions are introduced by truncation.

Each basis entry is \(T^eu\) with \(-L\le e\le L\), where u is a product
of known units and unit roots or their inverses. Precision \(3L+3\)
for the roots implies at least that precision for these products and
inverses. Multiplication by \(T^{L+e}\), a nonnegative power, cannot
lose precision. This is more than needed through degree 2L.
For rational coordinates, cancelling \(T^L\) from \(H^L\) leaves a
unit denominator locally; at infinity cancelling known z powers
does the same. Euclidean inverses in quotient rings compute it exactly.

All other finite places are automatically integral by the ansatz.
Consequently the finite systems compute exactly the intersection of
the local orders, with its exact evaluation map at infinity.

## 4. Why the computed image contains a rank-one idempotent

There is no algorithmic reliance on a hidden splitting isomorphism in
this argument. Such an isomorphism is fixed only to prove the shape
of the computed algebra. A completed lattice between two powers of
a rational uniformizer is determined by finitely many congruences.
Rational approximation of a basis to that precision descends it to
the ordinary local ring. Its order is maximal by completion.
An ordinary-local maximal order stabilizes the lattice obtained by
applying its finite module of matrices to the standard lattice;
maximality makes it the whole endomorphism order of that lattice.
These lattices are standard away from finitely many points and glue
to a vector bundle V on the projective line. Thus the computed space
is \(H^0(\operatorname{End}V)\).

For completeness, the splitting theorem needed here works over k.
Line bundles on the two polynomial charts have transitions \(X^d\),
because both chart rings are principal ideal domains and their
Laurent overlap has precisely monomial units. The Cech computation
gives \(H^0(O(t))=0\) for t<0 and \(H^1(O(t))=0\) for t>=-1.
Choose maximal d with a nonzero map \(O(d)\to V\).
Clearing the finitely many finite poles of a rational column and then
allowing a sufficiently large pole at infinity proves existence.
Enclosing the defining lattices between twists of a fixed rational
trivial bundle embeds V in \(O(t)^q\) for some t, which bounds d above.
Saturation cannot increase d, so the image is a line subbundle.
Induction splits its quotient as \(\bigoplus O(t_i)\).
After twisting by -d-1, a quotient section lifts: the only gluing
obstruction is a Laurent cocycle in \(O(-1)\), whose computed Cech
quotient is zero. Maximality of d therefore gives \(t_i\le d\).
An extension of each \(O(t_i)\) by \(O(d)\) has an off-diagonal
transition cocycle in \(O(d-t_i)\). Its Cech quotient is also zero.
Changing chart lifts kills all these off-diagonal terms, proving
splitting without importing an unproved extension-class theorem.

Order the summand degrees decreasingly. The (i,j) entry is a section
of \(O(d_i-d_j)\). Its value at infinity is arbitrary when that degree
is nonnegative and zero otherwise. Therefore the exact computed
fiber image is conjugate to a full block upper triangular algebra.
The trace-pairing kernel is exactly its strictly block-upper part:
the diagonal-block matrix trace pairings are nondegenerate in every
characteristic. The common column kernel is its first block space.
For any nonzero v there, choose w with wv=1. The matrix vw belongs
to that block-upper algebra and is a rank-one idempotent.
Kernels, normalization, and a linear lift compute it in the original
coordinates; a conjugating matrix or the bundle splitting is not used.

## 5. Lift, power, and extraction

Lift the fiber matrix to b in the computed space. Its generic
characteristic coefficients are regular at every place, hence are
constants. The fiber characteristic polynomial therefore gives
\(\chi_b(T)=T^{q-1}(T-1)\). Cayley--Hamilton yields
\(b^q=b^{q-1}\), so all powers at least q-1 agree.
In particular \(e=b^q\) is idempotent. The coprime-primary decomposition
shows that its image is the 1-primary space, of dimension one.
This is valid even when the other primary space has a nilpotent part.

The left ideal Ee has dimension q. The map \(a\mapsto ae\) from the
degree-q field \(\mathcal L\) is injective and hence onto it. Thus the explicit
linear system \(Ve=he\) has a unique solution h in L. Iterating and
using \(Va=\rho(a)V\) gives \(Ge=\operatorname{Norm}(h)e\).
Since e is nonzero and both coefficients are central scalars, this
implies \(\operatorname{Norm}(h)=G\), in particular h is nonzero.

## 6. Uniform polynomial bounds and the oracle boundary

There are at most d groups. The ansatz has
\(q^2(L(d+1)+1)\) unknowns, and \(O(q^2L(d+1))\) conditions.
Every quotient used for roots has dimension at most \((3L+3)d\).
All these quantities are polynomial in the varying q,N,D, not just
for fixed q. Section elimination is linear algebra over k.
The finite-field root routine has the bounds proved in Section 1.

For b with numerator bound \(P_*=L(d+1)\), coefficients of \(b^s\)
can use denominator \(H^{Ls}B^{s-1}\) and numerator degree at most
\(sP_*+(s-1)(N+D)\). A monomial multiplication introduces at most
one F and one A/B, proving this by induction. At s=q all degrees
remain polynomial. Clearing \(Ve=he\) adds at most one B; q-by-q
minors bound the solution degrees by q times the cleared entry bound.
Dense arithmetic and fraction-reducing elimination therefore have
polynomial bit cost in q,N,D and log|k|.

The actual operations are gcds, square-free and distinct-degree
decomposition, arithmetic modulo known polynomials, simple-root
Hensel iteration, primary digit logarithms using q trials per digit,
and linear algebra. None asks for irreducible factors. Their
field-dependent decisions are zero tests (including degree and pivot
tests). The manuscript's simultaneous-execution assertion follows.

## 7. Prescribed exact diagnostic: what is computed

The verifier uses \(q=3,\ k=\mathbf F_{19},\ \zeta=7,\ \omega=4\),
\(F=X^3-2,\ G=2\). The known element X-Y checks only the norm promise;
it is never supplied to the construction.

There is one exceptional finite group F, with w=0. The residue root
of 2 is computed by the primary-generator/eigenvector routine, not
chosen by inserting X-Y. A sharp trace bound gives all sections in
the equivalent, smaller ansatz
\[
 c_{0b}\in k,\quad c_{1b}=P_{1b}/F,\ \deg P_{1b}\le2,\quad
 c_{2b}=P_{2b}/F,\ \deg P_{2b}\le1.
\]
Indeed inverse monomials at F have orders >=-1 (and >=0 for a=0);
at infinity their orders are at least a. These are exact necessary
coordinate bounds, independent of the promised solution.
The ansatz has 18 scalar unknowns.

Let r be the computed residue root. For a=1 require
\(\sum_bP_{1b}\zeta^{jb}r^b=0\bmod F\) for j=0,1;
for a=2 require the same for j=0. Other columns wrap and contribute
a factor F. These are exactly the finite integrality conditions.
At infinity every entry is already integral and evaluation of a>0
uses the leading allowed coefficient of P, times
\(\operatorname{diag}(1,\zeta^{-1},\zeta^{-2})^aV^b\).
This is algebraic elimination of redundant coordinates in the
manuscript's large ansatz, not a different splitting construction.

The verifier also constructs the **full** sufficient ansatz with L=5:
189 numerator coefficients of degree at most 20. It builds 135 finite
conditions (including nine identically zero rows), 90 infinity
conditions, and the nine evaluation rows directly from the truncated
models. Thus it actually eliminates a 225-by-189 matrix, of rank 180,
rather than relying solely on the hand-compressed ansatz. It checks
that the compressed space embeds into this kernel with equal dimension.
The fiber construction and final extraction use the full-system basis.
The certificate records the full kernel, matrices, and rational
coefficients, so the checks concern the computed construction rather
than a substituted norm solution.

The original generous precision is also exercised, not just inferred
from the compressed system. Set T=F. The computed residue root is X;
the simple-root lift has the form R=X U(T), where
\((T+2)U(T)^3=2\). Newton iteration computes U to precision
\(3M+3=1083\). Independently it computes
\(S(z)^3=1-2z^3,\ S(0)=1\) to the same precision at infinity.
For the compressed coordinates, a nonintegral finite entry can start
only at order \(2M-1=719\) after scaling. Polynomial multiplication
in the presentation \(X^3=T+2\) computes those low coefficients and
reproduces the section equations exactly. All lower coefficients
vanish for degree reasons; wrapping columns start at order 2M.
At infinity all products start at order 2M and the coefficient at
that order is the evaluation described above. Thus using the large
precision does not change the computed section algebra or fiber.

## 8. Results, improvement, and reproduction

The full section algebra has dimension 9, and its infinity image has
dimension 9, hence is the entire \(M_3(\mathbf F_{19})\).
Its trace-pairing kernel is zero; the common column kernel is the full
three-dimensional space. The deterministic choice gives the fiber
idempotent \(E_{00}\). The computed lift satisfies \(b^3=b^2\);
\(e=b^3\) is nonzero and idempotent with a three-dimensional left ideal.
Solving \(Ve=he\) returns \(h=X-Y\). Independent multiplication of its
three conjugates gives exactly 2. This equality is an output check;
the known norm solution was not an input to any construction step.

Relative to the strongest prior result in the staged source, the
parameter-uniform improvement proved here is the sufficient budget
\(L=N+D+2\) in place of \(M=10q^2(N+D+1)\). Consequently the sufficient
number of scalar unknowns is
\[
 q^2((N+D+2)(d+1)+1)
\]
rather than \(q^2(10q^2(N+D+1)(d+1)+1)\). This is an algebraic dimension
bound, not a measured runtime claim. The general intersection-of-orders
strategy is already in IKR; no novelty is claimed for that strategy.
Whether this verification and sharper precision budget meet the
publishable bar is for independent assessment, not inferred from a
failed literature search.

From the campaign root, replay the persisted exact certificate with:

```sh
$WORKSPACE/argus-live-update/.venv/bin/python research/norm_solver/verify.py
```

The parameter-uniform precision core and the explicitly delimited
idempotent identities were compiled and axiom-audited with Lean 4.31.0:
`exit_code=0`, `audit_exit_code=0`, `proof_holes=[]`. The immutable
compiler certificate is
`research/norm_solver/certificates/L_NORM_FORMAL_CORE-ed51652a939dd550.json`.
Its source and statement-fidelity document have not been edited since
that successful run. Reproduction, if either document is changed, is:

```sh
$WORKSPACE/argus-live-update/.venv/bin/python -m argus_skill.verticals.math.lean_evidence verify research/norm_solver/Main.lean --statement-fidelity research/norm_solver/statement_fidelity.md --claim L_NORM_FORMAL_CORE --project-root .
```

The full norm theorem is supported here by a mathematical proof, not
by a complete Lean encoding. The exact diagnostic is one finite-field
instance, not universal computational testing. No manuscript claim is
marked refuted, and no independent Reviewer approval is asserted.
