# Zero-loop strip arch identity

## Source and scope

The target is Proposition `prop:arch-formula` in the staged manuscript
`Critical-strip-crossing-mass-on-the-honeycomb-lattice-September-26-2026`.
All source paths below are relative to its `build/` directory. This audit
concerns the identity for the unnormalized first arch moment, not a proof or
disproof of the physical three-quarter exponent.

The source specifies the following data.

* `sections/02_flux_transfers.tex`, equations `eq:01-rhombic-weights`,
  `eq:full-column`, and Figures `fig:local-operator` and
  `fig:rhombus-dictionary`: nine local diagrams; inputs `(south, west)`,
  outputs `(east, north)`; operator parameter `3 lambda - u`; occupancy
  matching; every closed component has weight zero.
* The same section, definitions of `L_N^0`, `L_N^1` and the source maps:
  vacuum states are noncrossing partial pairings; a one-source state has
  exactly one exterior defect, not enclosed by an arc. The south-source
  map has occupied south and vacant north auxiliary ends.
* `sections/04_arch_formula.tex`, equations `eq:01-integrated-source` and
  `eq:01-moment-gluing`: the integrated source solves
  `(I - T^1) H = b P`. Reflection uses the row list
  `(3 lambda - u_i)`, without reversing row order. Gluing is connectivity
  composition, not the coordinate dot product.
* `sections/02_flux_transfers.tex`, equations `eq:column-reflection` and
  `eq:transfer-intertwiners`, and `sections/04_arch_formula.tex`,
  equation `eq:arch-reflected-source`: the claimed reflected reduction is
  diagrammatic projection by `S_s^t`. No Euclidean-isometry interpretation
  of that projection is licensed.
* `sections/03_vacuum.tex`, equation `eq:01-pfaffian`: the scalar is the
  Pfaffian with kernel `(a-b)(a+b+rho)/D(a,b)`, where
  `D(a,b)=a^2+b^2+2dab-d^2`, and an augmenting column of ones in odd
  size. Coincident arguments require polynomial continuation, not direct
  substitution in the displayed rational expression.
* `sections/03_vacuum.tex`, Lemma `lem:vacuum-degree`, and
  `sections/04_arch_formula.tex`, paragraphs "A polynomial bound from the
  source sector" and "Interpolation": the proposed all-width proof also
  requires the vector degree bound, its source-sector limit, and the
  resulting degree bound `2N` for `p_N^2 m` in each `a_i`.

These are source attributions and definitions, not independently proved
lemmas. In particular neither the reflected intertwiner nor the desired
arch formula is assumed true by the computation.

Two short literal source conventions are worth retaining: "Composition
glues matching slots and annihilates a mismatch or a closed loop", and
"This defect cannot be enclosed by a pair"
(`sections/02_flux_transfers.tex`, diagram algebra and cut-state
definitions, respectively).

## Prior knowledge used

The inherited project Wiki index was searched for honeycomb, arch,
Pfaffian, and strip identities; no relevant prior result was found.
The manuscript explicitly distinguishes its zero-loop observable from
the cited dense/dilute `O(1)` current formulas. None of those external
current formulas is an assumption of this audit. Finite-width transfer
linear systems can be checked directly, so their evaluation need not
assume the manuscript's decay lemma; each evaluated restricted
determinant must instead be exhibited as nonzero. Positive convergence,
if needed to identify an infinite sum, is a separate obligation.

## General verification theorem

Put \(\lambda=\pi/8\), \(d=\cos(2\lambda)\), \(C=\cos\lambda\),
\(c=\cos(3\lambda)\), \(\rho=(2C)^{-1}\), and \(\eta=2d-1\).
Use exactly the nine local diagrams, source convention, and zero-loop
composition specified above. For every integer \(N\geq0\), the rational
stationary arch pairing satisfies
\[
 \operatorname{Glue}(H_X^-,H_X)
 =\sum_{j=1}^N a(u_j)
   -\eta[z^{N-1}]
     \frac{p_{N+1}(a(u_1),\ldots,a(u_N),z)}
          {p_N(a(u_1),\ldots,a(u_N))}.
\]
The size-zero coefficient is zero. At each mixed physical/flat list
\(u_i\in\{0,\lambda,2\lambda,3\lambda\}\) the left side is an
absolutely convergent positive path sum, and the right side has the
corresponding removable continuation. In particular at
\(u_1=\cdots=u_N=\lambda\) it is the physical first rightward arch
displacement moment.

This is an independent verification of the selected manuscript identity,
not a claim that the identity is first stated here. It does not certify
the later hard-edge estimates, the fixed-length theorem, or their
literature inputs. Publishability, novelty, and independent acceptance
remain for the Host-invoked Reviewer.

## Proof

### 1. Local algebra and existence of the rational vectors

A diagram is stored as its boundary connectivity, not as a matrix on
occupancy bits. Composition first checks occupancies, then joins edges;
a component without external ends makes the term zero. Consequently
equalities checked in this diagram algebra remain equalities after
tensoring with any number of slots and attaching any vacuum or
one-source state.

`verify.py` checks, over \(\mathbb Q(C)(t)\), \(t=\tan(x/2)\),
\[
 R(0)=I,\quad R(x)R(-x)=I,\quad
 R(s\lambda)=S_sS_s^{\mathsf t},
\]
\[
 R_2(x)R_1(x+s\lambda)(I\otimes S_s)
       =(S_s\otimes I)\widehat R_s(x),\qquad s=2,3.
\]
It checks the reflected projection identity directly in the same full
boundary-connectivity algebra as well. The two splitting identities
have respectively 18 and 4 surviving boundary coefficients.
These are identities for a free symbolic parameter, not tests at a
finite collection of angles.

For completeness these identities imply the braid relation without a
two-variable computational assumption. At \(y=2\lambda,3\lambda\)
insert the factorization, use splitting and its transpose, and reflect
slot order. Both products become
\((I\otimes S_s)\widehat R_s(x)(S_s^{\mathsf t}\otimes I)\).
Unitarity gives the two further specializations
\(y=2\lambda-x,3\lambda-x\); \(y=0\) follows from \(R(0)=I\).
After multiplication by the three local denominators each boundary
coefficient of the braid residual has Laurent exponents in \(e^{iy}\)
between \(-4\) and \(4\). The identity
\(R_i(v+\pi)=D_{i+1}R_i(v)D_i\), obtained by changing the signs of
the single-turn weights, gives fixed parity for each coefficient:
internal signs cancel, leaving only fixed boundary occupancy signs.
Thus, after a Laurent monomial shift, its degree in \(e^{2iy}\) is
at most four. The five specializations above are distinct generically.
The residual is zero. Clearing denominators extends the identities
wherever their rational sides are defined.

The empty-coordinate block of the vacuum transfer is \((1,0)\), since
an occupied input disappearing without an output closes a forbidden
loop. Write the remaining block as \(Q\); then
\[
 P=(1,(I-Q)^{-1}v),\qquad H=(I-T^{(1)})^{-1}bP.
\]
These are rational functions once either restricted determinant is
nonzero at one point. At the all-zero row list each surviving strand
moves strictly toward the lower end of the cut; it cannot propagate
through arbitrarily many columns. Thus the two restricted transfers
are nilpotent there.

Here is also the convergence argument needed for the physical
interpretation and for regularity at mixed specializations. Splitting
unit incoming mass into \(\rho e^{i\lambda}\) and
\(\rho e^{-i\lambda}\) conserves it, as \(2\rho C=1\).
Stop at an exit or first collision. The two orientations of a newly
closed simple cycle have the same weight and winding increments
\(\pm4\pi/3\), hence opposite phases for spin \(3/8\). The incoming
stem is outside the cycle because the path began on the boundary and
has not crossed itself. Reversal therefore cancels all collision
terms. On a convex finite domain each remaining boundary phase has
real part at least \(c>0\). Its unsigned boundary partition sum is
at most \(1/c\).

For a fixed-height triangular parallelogram, extend a left-to-right
path down the next new column to a bottom port. The added length is
bounded by a height-dependent constant. Its final bottom port and
first exit into that column recover the extension column and the
original path. Distinct widths therefore give distinct paths in a
larger convex parallelogram, and the preceding bound implies
\(\sum_M q_H(M)<\infty\), in particular \(q_H(M)\to0\).
Same-side single-path sums are bounded by \(1/c\).

At a mixed list, collapse the flat rows. Outside end pieces of bounded
size, the remaining triangles form a fixed-height homogeneous core;
flat routes drift only a bounded number of columns. Every nonzero
restricted transfer diagram has a component crossing this core.
Cutting all components at its ends and ignoring their mutual
avoidance bounds a matrix entry by a fixed finite sum of products of
single-path sums. A crossing factor tends to zero, and all other
factors stay bounded. With no nonflat rows, every restricted transfer
power is eventually zero. Thus both restricted matrix powers tend to
zero at every mixed list. Finite-dimensional spectral theory gives
spectral radius less than one. The matrices made with absolute tile
weights are continuous and have the same property in a neighborhood
of each such list. This proves regularity and absolute convergence,
including on the specialization hypersurfaces used below. No uniform
gap in \(N\) is asserted.

### 2. Source reduction and the correct gluing adjoint

Local braid and splitting can be moved through a column with its
auxiliary endpoints left unspecified. Fixing those endpoints afterward
therefore proves the vacuum and south-source intertwiners. Reflecting
the complete local diagram gives
\[
 (S_s^{\mathsf t}\otimes I)R_2(x+s\lambda)R_1(x)
   =\widehat R_s(x)(I\otimes S_s^{\mathsf t}).
\]
This is also one of the directly checked symbolic identities. Tensor
it with the other rows to obtain the reflected column projection and
then all its vacuum/source versions.

The projected vacuum has empty coordinate one: a cap contribution
with empty output either closes a loop or came from empty input.
Stationarity and uniqueness give \(S_s^{\mathsf t}P_X^-=P_{\rm red}^-\).
Apply the source projection to the source equation:
\[
 (I-T_{\rm red}^{(1),-})S_s^{\mathsf t}H_X^-
   =b_{\rm red}^-S_s^{\mathsf t}P_X^-
   =b_{\rm red}^-P_{\rm red}^-.
\]
Injectivity of the reduced resolvent gives
\(S_s^{\mathsf t}H_X^-=H_{\rm red}^-\).
The forward intertwiners similarly give \(P_X=S_sP_{\rm red}\)
and \(H_X=S_sH_{\rm red}\). First argue in a regular mixed
neighborhood, then extend rationally along the specialization.

Finally the two connectivity graphs obtained by inserting \(S_s\)
on one side of a glued cut or its reflected diagram on the other
are the same graph with the same coefficient. Occupancy mismatches
and closed loops are zero on both sides. By bilinearity,
\[
 \operatorname{Glue}_N(l,S_sr)
 =\operatorname{Glue}_{\rm red}(S_s^{\mathsf t}l,r).
\]
The arch pairing thus reduces to the smaller width. This uses no
identity \(S_s^{\mathsf t}S_s=I\).

The declarations `projected_source`, `inserted_source`, and
`adjoint_pairing_reduction` in `Main.lean` formalize these
dimension-independent linear-algebra implications. The diagrammatic
intertwiners and adjoint interpretation are established above, not
silently supplied by the compiler.

### 3. Scalar normalization for every size

The degree and leading-coefficient assertions in this paragraph concern
\(N\ge1\); \(p_0=1\) is the separate size-zero convention.
Let \(D(a,b)=a^2+b^2+2dab-d^2\). Clear all \(D\) denominators
in the defining Pfaffian. Its numerator is alternating, hence
divisible by the Vandermonde \(\prod_{i<j}(a_i-a_j)\).
Counting the degree in a distinguished argument before and after
division gives at most \(N-1\). Sending that argument to infinity
gives leading coefficient \(p_{N-1}\): in even size its kernel
column tends to minus the augmenting column, with the Vandermonde
sign cancelling; in odd size add the augmenting row and column
to that argument's row and column first. The resulting isolated
last pair has coefficient one.

At the flat value,
\[
 D(z,c)=(z-c)(z+C),\qquad
 (z-c)(z+c+\rho)/D(z,c)=1,
\]
so \(p_N(Y,c)=p_{N-1}(Y)\prod_{z\in Y}(z+C)\).
For \(f_j=\cos(w+j\lambda)\), \(D(f_0,f_6)=0\).
In the denominator-cleared Pfaffian only matchings pairing these
two arguments survive; \(D(f_0,z)=(z-f_{-6})(z-f_6)\) gives the
deletion rule.

The merge rule follows by induction on the spectator count \(r\).
For \(r=0\), \(p_2(a,b)=a+b+\rho\). In a distinguished spectator
the two proposed sides have degree at most \(r+1\), and their
leading coefficients agree by induction, so the difference has
degree at most \(r\). It vanishes at \(-f_0\) by deletion, at \(c\)
by the flat rule, and at the two deletion partners of every other
spectator. The factor comparisons are precisely
\[
 (C+f_{-2})(C+f_2)=(c+f_0)(C+f_0),
\]
\[
 \prod_{\ell=\pm2}(f_\ell-g_{-6})(f_\ell-g_{12})
 =(f_0+g_0)(f_0+g_6)(f_0-g_{-6})(f_0-g_{12}).
\]
They are checked symbolically with two free half-angle variables.
The \(2r\) roots are generically distinct and \(2r>r\) for \(r\ge1\).
This proves the merge rule and, by changing the signs of the shifts,
both orientations of all scalar reductions.

### 4. The all-width polynomial vacuum bound

This step cannot be replaced by small-width agreement. Here is the
induction, including the potential pole divisors and the residual
degree count. Its degree assertions concern positive width; \(W_0=1\)
is an induction convention, not a negative-degree bound.

Assume \(W_j=p_jP_j\) is Laurent polynomial through size \(N-1\),
with earlier exponents bounded by \(2j-2\). In the last variable
\(y\), put \(b=a(y)\). For \(i<N\) set
\[
 y_i=u_i+3\lambda,\quad
 \beta_i=a(y_i),\quad
 \gamma_i=a(u_i-3\lambda),\quad
 \sigma_i=a(u_i+6\lambda).
\]
At \(y=y_i\), deletion and row exchange prescribe data
\[
 Y_i=(a_i+\beta_i+\rho)
       \prod_{j<N,\ j\ne i}(a_j-\gamma_i)(a_j-\sigma_i)
       {\cal R}_i S_3W_{N-2}.
\]
Here \({\cal R}_i\) moves the inserted row to the top without moving
it past row \(i\). These data equal the genuine rational vector
\(p_NP_N\) on their node hypersurfaces, by the already established
column identities and scalar deletion.

Let \(\ell_i\) be the Lagrange polynomials of the \(\beta_i\)'s.
Construct a candidate \(W\) by
\[
 W_v=W_{N-1}\prod_{i<N}(b-\beta_i)+\sum_{i<N}(Y_i)_v\ell_i(b),
 \qquad
 W_o=\sin y\sum_{i<N}(Y_i)_o\ell_i(b)/\sin y_i .
\]
The empty coordinate is \(p_N\) by scalar interpolation.

The following two identities, checked exactly in `verify.py`, cancel
every moving-box denominator and every displayed dividing sine:
\[
 \frac{(a(v)-a(x-3\lambda))(a(v)-a(x+6\lambda))}
      {L(x+3\lambda-v)}
 =-4\sin(x+v-6\lambda)\sin(x+v+3\lambda),
\]
\[
 a(x)+a(x+3\lambda)+\rho
 =4c\sin(x+3\lambda)\sin(3\lambda-x).
\]
Only simple factors of the node differences remain. Their two
irreducible components are
\(u_i=u_j\pmod\pi\) and \(u_i+u_j=-3\lambda\pmod\pi\), since
\(\beta_i-\beta_j=-2\sin(u_i+u_j+3\lambda)\sin(u_i-u_j)\).
On the first component the two node data agree, including the
occupied data divided by their sine, because both are the same
genuine rational vacuum specialization. Signs under a shift by
\(\pi\) are the corresponding boundary occupancy signs.
On the second component \(a_j=\sigma_i\) and \(a_i=\sigma_j\),
so both node data vanish. Generic moving-box denominators there
are nonzero. These checks remove all possible prime denominator
factors in a Laurent polynomial ring; their intersections cannot
introduce a new pole.

At either Laurent extreme of an earlier \(u_k\), a moving box is
bounded. For \(i\ne k\), node data grow at most as
\(a_k^{N-1}\), while \(\ell_i\) stays bounded. For \(i=k\),
the scalar data grow at most as \(a_k^{2N-3}\) and
\(\ell_k=O(a_k^{-(N-2)})\). Dividing occupied data by
\(\sin y_k\) only improves this bound. The leading term has the
same bound. Since poles have been removed, every earlier Laurent
exponent is between \(-(2N-2)\) and \(2N-2\).
The last-variable forms are, by construction,
\(\deg_bW_v\le N-1\), with leading coefficient \(W_{N-1}\), and
\(\deg_b(W_o/\sin y)\le N-2\).

Two additional relations follow by this same last-variable
interpolation, not by assuming stationarity of the candidate.
Earlier-row exchange preserves the node set, its genuine data and
the leading coefficient, and so gives covariance. If earlier
adjacent rows have separation \(2\lambda\) or \(3\lambda\), the
split smaller vector times the scalar quotient has the required
last-variable degrees and leading coefficient. At every node
except the upper member of that pair, equality follows from the
genuine rational vacuum identities at a regular simultaneous
mixed specialization. At that exceptional node both sides vanish:
its last argument is \(-a(u_r+\lambda)\) for merge, and
\(\sigma_r\) for deletion; on the node-data side the corresponding
spectator factor is zero, with no moving box crossing row \(r\).
The flat first-row formulas follow in the same way. Multiplication
by \(b+C\) clears the only last-box denominator; the vacant
contribution alone gives the leading degree. The exceptional
flat/deletion node has the scalar zero \(b+C\).

It remains to prove stationarity. Let
\[
 V=\left(\prod_jL(u_j)\right)(T_N-I)W,\quad n=N-1,\quad
 q=W_o/\sin y,\quad \Lambda_n=\prod_{j<N}L(u_j).
\]
Examining the last box, with its north port vacant, gives exactly
\[
 V_v=\frac{\Lambda_n}{2}
       \big((b+C)(T_n-I)W_v+d(b-c){\cal C}^{\rm north}_n q\big),
\]
\[
 V_o/\sin y=\frac{\Lambda_n}{2}
       \big((b-c)T_n^{(1)}q-(b+C)q+2d b_n^{\rm north}W_v\big).
\]
The map \({\cal C}^{\rm north}\) ties the north auxiliary end to
the input defect. These blocks follow from the four possible
last-box weights \(1,A,U,B\) and
\(L(y)=(b+C)/2\),
\(\sin y\sin(3\lambda-y)=(b-c)/2\).
Both blocks have degree at most \(N-1\) in \(b\):
the possible degree \(N\) term of \(V_v\) is
\(\Lambda_n(T_n-I)W_n/2=0\) by the induction hypothesis.
Node stationarity makes \(V\) divisible by
\(\prod_{i<N}(b-\beta_i)\).

For each fixed earlier \(k\), its flat and pair-specialization zeros
give the additional divisor
\[
 (b-\beta_k)\sin u_k\sin(u_k-3\lambda)
 \prod_{\substack{j<k\\s=2,3}}\sin(u_k-u_j-s\lambda)
 \prod_{\substack{k<j<N\\s=2,3}}\sin(u_j-u_k-s\lambda).
\]
For generic other parameters these factors are distinct. Its Laurent
extremes in \(u_k\) are exactly \(\pm2N\):
two from \(b-\beta_k\), two from the flat factors, and
\(2(N-2)\) from the pair factors. It is even under \(u_k\mapsto
u_k+\pi\). Every coordinate of \(V\) has the same exponent bound
\(2N\), so division leaves something independent of \(e^{iu_k}\).
An occupied slot has odd occupancy parity, forcing that quotient
to vanish. Every nonempty vacuum state has an occupied earlier
slot, since it has at least two occupied slots. The empty
coordinate residual is already zero. Hence \(V=0\).
Generic normalized uniqueness now identifies the constructed
candidate with \(p_NP_N\). This completes the induction.

### 5. Source bound, symmetries, and interpolation

Add a last row \(y\) to the vacuum and identify its occupied-slot
sector with the earlier one-source sector. The last-box equation is
\[
 (P_{N+1})_o=B(y)T_N^{(1)}(P_{N+1})_o
                  +U(y)b_N^{\rm north}(P_{N+1})_v.
\]
As \(b=a(y)\to\infty\), the vacant vector tends to \(P_N\),
\(B(y)\to1\), and \(U(y)=2d\sin y/(b+C)\). Thus
\[
 p_N H_N^{\rm north}
   =\frac1{2d}[b^{N-1}]\big((W_{N+1})_o/\sin y\big).
\]
By the preceding induction, each earlier Laurent exponent is bounded
by \(2N\). Top-bottom reflection reverses row order and replaces
each \(u_i\) by \(3\lambda-u_i\); it preserves \(a_i\), \(p_N\),
and the exponent bound. Horizontal reflection gives the other
source half. Consequently both \(p_NH_N\) and \(p_NH_N^-\)
have exponent bound \(2N\), so \(p_N^2m\) has bound \(4N\).

Moving an exchange box through the glued diagram proves row
symmetry. Occupancy signs from a \(\pi\) shift cancel between the
halves. To reflect a single row, first exchange it to the top.
With vacant top ports, each visit to it is a disjoint interval of
length \(\ell\ge1\), of weight \(AU B^{\ell-1}\). This is
unchanged by \(u\mapsto3\lambda-u\). At \(a=c\), \(AU=0\),
and omitting that flat row leaves the same arch sum.
These arguments are justified for absolutely convergent sums near
physical lists and hence extend rationally.

A \(\pi\)-periodic Laurent polynomial can be written in
\(z=e^{2iu}\). Reflection sends \(z\) to \(e^{6i\lambda}/z\).
An invariant Laurent polynomial is a polynomial in
\((e^{-3i\lambda}z+e^{3i\lambda}/z)/2=a(u)\):
the symmetric pairs of powers obey the usual two-term recurrence.
The exponent bound \(4N\) therefore gives degree at most \(2N\)
in each \(a_i\) for \(p_N^2m\).

Let \(\widetilde m\) denote the proposed Pfaffian expression.
The leading coefficient of \(p_{N+1}\) is \(p_N\), so its quotient
is monic of degree \(N\). The scalar merge, deletion, and flat
rules multiply the quotient, respectively, by
\(z+f_0\), \((z-f_{-6})(z-f_{12})\), and \(z+C\).
The checked identities
\[
 f_{-2}+f_2-f_0=\eta f_0,\quad
 f_0+f_6=-\eta(f_{-6}+f_{12}),\quad c=\eta C
\]
show that \(\widetilde m\) has exactly the reductions already proved
for \(m\). Also \(p_N^2\widetilde m\) has degree at most \(2N\)
in each argument, directly from the scalar degree bounds.

Induct on \(N\). The base cases are \(m_0=0\) and
\[
 m_1(u)=AU/(1-B)^2=a(u)-\eta(a(u)+\rho);
\]
the latter rational identity is checked symbolically, not merely
at \(u=\lambda\). For a distinguished argument and each spectator
\(a_j=\cos\theta_j\), the induction supplies the four nodes
\(\cos(\theta_j\pm4\lambda)\) and
\(\cos(\theta_j\pm6\lambda)\), as well as the single flat node \(c\).
Within one spectator these are distinct nonidentical linear
combinations of \(\cos\theta_j,\sin\theta_j\); between different
spectators algebraic independence prevents an identity. None is
identically constant \(c\). Thus there are generically \(4N-3\)
distinct nodes. The polynomial
\(p_N^2(m-\widetilde m)\) has degree at most \(2N\) and vanishes
at all of them. Since \(4N-3>2N\) for \(N\ge2\), it is zero.
This last abstract uniqueness implication is
`StripArchAudit.arch_interpolation` in `Main.lean`.
The rational identity follows, and regularity of the arch sum
gives the claimed removable physical limit.

### 6. Identifying the pairing with physical arches

Expand each stationary vacuum and source resolvent in its absolutely
convergent column series. A finite arch cut between its endpoints
has a unique source-containing fragment on each side and possibly
paired fragments on either side. Its two restricted configurations
therefore occur once in the two source vectors. Their union has
matching occupancy, one source-to-source component, and no loop,
so its gluing coefficient is one. Conversely such a glued diagram
is exactly one admissible arch; the local tiles prohibit vertex
reuse. For endpoint separation \(k>0\), exactly \(k\) column cuts
lie between the endpoints. Summing over cuts gives
\(\operatorname{Glue}(H_X^-,H_X)=\sum_{k\ge1}kK_X(k)\).
At \(u_i=\lambda\), each rhombus is two triangular tiles with
weight \(\rho\) per visited vertex, so the displacement and endpoint
conventions are those in the physical definition. This completes
the verification theorem.

## Exact controls and certificate scope

The independent connectivity implementation agrees with the formula
at row lists
\[
 (\lambda),\quad(\lambda,\lambda),\quad
 (\lambda,\lambda,\lambda),\quad
 (0,2\lambda,\lambda),\quad(0,3\lambda,\lambda).
\]
Width three is the first one-source sector with paired fragments.
In its basis of three singleton defects followed by
\((\mathrm{defect}\ 0,\mathrm{pair}\ 12)\) and
\((\mathrm{pair}\ 01,\mathrm{defect}\ 2)\), the gluing matrix is
\(\operatorname{diag}(1,1,1)\oplus
\left(\begin{smallmatrix}0&1\\1&0\end{smallmatrix}\right)\).
In particular the implementation does not substitute a dot product.
All these tests are controls; the all-width conclusion comes from
the proof, not from their extent.

`exact_certificate.json` records every evaluated transfer, insertion,
stationary/source vector, gluing matrix, restricted determinant, and
positive contraction witness. For each nonnegative restricted
transfer \(T\), the witness satisfies \((I-T)w=\mathbf1\) and
\(w>0\), giving spectral radius less than one in the weighted
supremum norm. Signs are decided with rational interval arithmetic
at the unique root \(C\in(9/10,1)\) of \(8C^4-8C^2+1\);
no floating-point comparison is used.

The Jacobian adapter was discovered and its determinant contract
inspected before execution. Its dedicated payload is the
two-band source resolvent with its entries represented as
polynomials in an algebraically independent `q`. The returned
determinant is
\[
 -4q^4+11q^2-6.
\]
Only afterward is \(q=C\) imposed, giving
\(7C^2-11/2=(7\sqrt2-8)/4>0\).
The exact payload, full typed output, server/protocol versions,
and zero adapter exit status are retained in the three
`jacobian_*.json` files and replayed by `verify.py`.

The Lean source is intentionally scoped to the universal source
projection/insertion/gluing implications and interpolation uniqueness.
Its separate fidelity document explicitly excludes the geometric
and all-width vacuum induction from the compiler claim. The Python
certificate checks the exact local rational identities and finite
controls, not the truth of arbitrary prose. Independent mathematical
review of the complete proof is therefore still required.

The prescribed Lean 4.31.0 verifier completed successfully with
`exit_code=0`, `proof_holes=[]`, and axiom-audit exit code zero.
Its immutable archive is
`lean_evidence/certificates/C_ARCH_RESOLVENT-cc5ca50e72f28b73.json`.
The ledger consequently reports `C_ARCH_RESOLVENT` as `closed_kernel`;
that status does not apply to the entire arch formula. The original
source and fidelity text match the compiler archive in the successful
default `verify.py` replay.

No false manuscript assertion was identified in this selected
identity chain, and no `F_*` refutation claim is warranted by these
results. An initial direct comparison of SymPy rational-function
objects was rejected as an implementation issue: distinct constant
denominator representatives can have zero exact difference while
object equality reports false. The final checker compares residuals
in the coefficient field, and a constant-angle control independently
confirmed that this was not a manuscript unitarity counterexample.

## Reproduction

From the campaign root, run
`$WORKSPACE/argus-live-update/.venv/bin/python research/strip_arch_audit/verify.py`.
The default replays the persisted certificate without rewriting it and
checks that the original Lean source and fidelity text match the
successful compiler archive. SymPy is the only nonstandard Python
dependency. A compiler replay uses `lean_evidence verify` with
`--claim C_ARCH_RESOLVENT` and the explicit
`--artifact-dir research/strip_arch_audit/lean_evidence`; its scope is
the four declarations named in the fidelity document, not the entire
proposition.
