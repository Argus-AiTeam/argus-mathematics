# Coupled jet extension under the manuscript's exact input hypotheses

## Result and scope

**Conditional theorem, with an exact identity certificate; independent review
pending.** The curve and residue hypotheses stated in `prop:curve-data` and
`prop:residue-data` suffice for `prop:jets`. More precisely, the coupled
construction works through every finite row index \(N\geq2\), and its choices
have a coefficientwise stable formal limit. The order-three compensation does
not have to preserve the degree-four determinant equation, because that
equation has not yet been imposed. The order-four target obstruction is
represented by an intrinsic exact differential, not by an arbitrary canonical
cocycle.

The proof below supplies the simultaneous existence argument; `verify.py`
independently differentiates ordinary-coordinate vector fields and checks the
universal algebraic identities used in it. The program does **not** prove
Cartan B or Serre duality, construct the input curve, establish convergence of
the infinite formal construction, or certify the analytic and algebraization
sections. No admissible counterexample to `prop:jets` is asserted.

The strongest prior result in the available project artifacts was the
manuscript's asserted finite jet through index seven; the ledger contained
only the campaign objective. The manuscript also describes an induction.
The improvement here is an explicit quantified compatibility proof, including
the stabilization needed to pass to all formal orders, and independently
derived exact residue and transport identities. This is **not** a claim of
verified novelty, publishable significance, or a new Lipman-Zariski
counterexample. Those campaign-level acceptance conditions remain open.

## 1. Statement fidelity

All section spaces and cohomology in this proof are holomorphic. Let \(C\)
be a smooth connected projective complex curve, \(L\) a line bundle of degree
10, and fix \(L^4\simeq K_C\). The precise hypotheses needed from the two
upstream propositions are as follows.

1. A reduced divisor \(Z=q_1+\cdots+q_6\) is the simple common zero divisor
   of a basis \(r=(r_1,r_2)\) of \(H^0(C,L)\). In the manuscript,
   \(L=H+Z\), \(r=\xi u\), \(g(C)=21\), and \(\deg H=4\).
   We have
   \[
   h^0(L)=h^0(L(Z))=2,\qquad h^0(\mathcal O_C)=h^0(\mathcal O_C(Z))=1.
   \]
   The rows \(r'(q_j)\) span \(\mathbb C^2\). The basis can be chosen so
   that the remaining zeros of \(r_1\) form a reduced degree-four divisor
   disjoint from \(Z\), as in the manuscript.
2. In mutually disjoint disks choose coordinates and frames such that the
   fourth power of the frame of \(L\) corresponds to \(dz\). With
   \(m_j=c_j/z\), \(c_j\ne0\), there is a **single global**
   \(P\in H^0(C,L^2(Z))^{\oplus2}\) such that
   \[
   R_j=m_jr,\qquad p_j=P-m_jr'
   \]
   are holomorphic on the disks. In particular \(R_j(0)\ne0\).
3. With \(X\wedge Y=X_1Y_2-X_2Y_1\), the normalizations are
   \[
   p_j(0)\wedge R_j(0)=1,\qquad
   W_j=R_j(0)\wedge R_j'(0),\qquad
   \sum_j(W_j-1)=-90=-9\deg L.
   \]

These are assumptions about *admissible geometric data*, not conclusions
inferred from a numerical sample. In particular, arbitrary independent local
rows satisfying some scalar equations would not substitute for the global
section \(P\). Its globality is essential to all four order-two tests.

**Theorem.** For every such data set and every integer \(N\geq2\), there are
holomorphic disk-to-outside overlap germs, finite compositions of flows of
orders \(1,\ldots,N\), and local rows \(A_k,B_k\) for \(0\leq k\leq N\),
with \(A_0=r,B_0=0\), such that
\[
v_i=t\left(A_i(t,z)E_t+B_i(t,z)\partial_z\right),\qquad E_t=t\partial_t,
\]
match through row index \(N\), fix the zero section and its conormal bundle,
and satisfy \(A\wedge B=t^2(1+O(t))\).
The construction can also be continued to a compatible formal pair with
\[
v_1\wedge v_2=G\sigma^{-1},\qquad G|_C=1,\qquad
\sigma=t^{-5}dt\wedge dz.
\]
No analytic convergence of the infinite composition is part of the theorem.
For \(N=7\) this gives exactly the conclusion of `prop:jets`.

The proof actually uses only the listed subset of the full curve/trace
hypotheses. It therefore neither assumes an additional unproved compatibility
condition nor claims to establish the existence of the supplied data.

## 2. External input and cohomological conventions

Two substantial external theorems are used.

| Input | Proposition actually read | Application here |
|---|---|---|
| Serre duality | J.-P. Serre, *Un theoreme de dualite*, Comment. Math. Helv. 29 (1955), DOI `10.1007/BF02564268`, section 3, no.13, Theorem 4, p.22; section 4, no.16, Theorem 5 and corollary, p.24 | \(H^1(C,B)^*\simeq H^0(C,K_C B^{-1})\) for the indicated line bundles on the compact smooth complex curve |
| Cartan B | H. Cartan, *Faisceaux analytiques sur les varietes de Stein*, Seminaire H. Cartan 4 (1951-1952), expose 18, section 4, Theorem B, p.18-7; [original source](https://www.numdam.org/item/SHC_1951-1952__4__A18_0/) | Vanishing of positive coherent cohomology on the charts and overlaps, hence local lifting, surjectivity on sections, and an acyclic cover |

Original PDFs, extracted text, and short proposition-level excerpts are in
this directory. Cartan's original page image is also retained: the theorem
says \(q\geq1\), although the OCR incorrectly reads \(q>1\).
Serre's statements are compact-complex-manifold duality statements, not the
purported curve-only statements and page numbers supplied by an initial
search summary. Only the original statements above are used.

The Engineer has read these sources but has not self-certified their
citations as independent review. The ledger records both as external
assumptions of `J_all_orders`; `citation_check status` correctly reports
independent attribution still outstanding. Its `attribute` command would
archive into `research/literature/`, outside this mission's writable paths,
and has not been run under an invented reviewer identity.

Here are the additional elementary details behind the application.
The complement of the nonempty effective divisor \(Z\) admits a closed
holomorphic embedding into affine space: a sufficiently large multiple
of \(Z\) is very ample.
One can see the latter using duality: for sufficiently large \(m\),
\(H^1(\mathcal O(mZ-D))=0\) for every length-two divisor \(D\), so the
sections separate points and tangent directions. The canonical section
of \(\mathcal O(mZ)\) then embeds the complement in a hyperplane complement.
As a closed smooth complex submanifold of affine space it is Stein:
coordinate functions separate points and give local coordinates, and their
bounds make the holomorphic hull of each compact set closed and bounded,
hence compact. Disks and punctured disks are Stein as well. After solving
on this cover, one may restrict to a smaller annular cover. All sheaves used are
line bundles, vector bundles, or kernels of morphisms between them, hence
coherent.

For a line-bundle overlap difference \(f_j\), its duality tests are
\[
\sum_j \frac{1}{2\pi i}\int_{\gamma_j} f_j s,
\qquad s\in H^0(C,K_C B^{-1}),
\tag{2.1}
\]
where each \(\gamma_j\) is positive in its disk. This contour description
follows from the cup-product description in Serre section 3, no.15:
represent the Cech class by cutoff functions on the annuli and apply Stokes
to its Dolbeault representative paired with \(s\). With the convention that
the discrepancy is transported-inside minus outside, choose the cutoff
representative giving the positive contours in (2.1). Reversing this
convention changes all tests by the same sign and not their vanishing.
No meromorphic extension of an outside coefficient to a disk is needed.

We also use the residue theorem and its contour form, which follow by
Stokes after excising disks around the poles. For a single-valued holomorphic
function on an annulus, \(\int_\gamma dh=0\) by integrating its derivative
along the closed path. This assertion does not require the function to be
meromorphic at the missing center.

For later interpolation, the exact sequence for \(L^k(-Z)\subset L^k\)
and Serre duality give
\[
\operatorname{coker}\bigl(H^0(L^k)\longrightarrow H^0(Z,L^k|_Z)\bigr)^*
\simeq
H^0(L^{4-k}(Z))/H^0(L^{4-k}).
\tag{2.2}
\]
For \(k=3\) the quotient is zero by \(h^0(L(Z))=h^0(L)=2\).
For \(k=4\) use \(h^0(\mathcal O(Z))=h^0(\mathcal O)=1\).
For \(k\geq5\), the target bundle has degree
\(10(4-k)+6\leq-4\), so has no nonzero section: a section would define an
effective divisor of negative degree. Thus evaluation is surjective for
**every** \(k\geq3\), not merely for the finitely tested indices.

## 3. Coordinate types and exact infinitesimal identities

A split coordinate change has
\[
\widetilde z=\psi(z),\quad \widetilde t=g(z)t,\quad
g^4=\psi',\quad a=(\log g)'.
\]
It preserves \(\sigma\), because the Jacobian is \(g\psi'=g^5\).
A homogeneous field row of index \(k\) transforms by
\[
\widetilde A_k=g^{-(k+1)}(A_k+aB_k),\qquad
\widetilde B_k=g^{3-k}B_k.
\tag{3.1}
\]
Consequently its sheaf is an extension
\[
0\longrightarrow L^{k+1}\longrightarrow\mathcal E_k
\longrightarrow L^{k-3}\longrightarrow0.
\tag{3.2}
\]
On each Stein chart a horizontal row has a vertical lift, and two vertical
lifts differ by a section of \(L^{k+1}\). The positive-order modifications
do not change these associated graded types.

Write a generator as \(D=t^k(bE_t+h\partial_z)\), \(k>0\). Its
time-one **negative** flow pushes fields forward by
\(\exp(\operatorname{ad}D)\). Differentiating ordinary-coordinate vector
fields, rather than assuming a logarithmic bracket formula, gives
\[
\begin{split}
[D,t^{\ell+1}(AE_t+B\partial_z)]
=t^{k+\ell+1}\bigl(&((\ell+1-k)bA+hA'-Bb')E_t\\
&+((\ell+1)bB+hB'-khA-Bh')\partial_z\bigr).
\end{split}
\tag{3.3}
\]
In particular
\[
\delta A_k=(1-k)br+hr',\quad \delta B_k=-khr,\quad
\operatorname{div}_\sigma D=t^k((k-4)b+h').
\tag{3.4}
\]
For \(k\ne4\), \(b=h'/(4-k)\) therefore preserves \(\sigma\) exactly.

The determinant is a bivector, not an invariant function:
\[
v_1\wedge v_2=t^2(A\wedge B)E_t\wedge\partial_z,\qquad
A\wedge B=t^2G,\qquad v_1\wedge v_2=G\sigma^{-1}.
\tag{3.5}
\]
For \(q=\operatorname{div}_\sigma D\), its transport is
\[
G\longmapsto\exp(D-q)G.
\tag{3.6}
\]
Indeed, differentiating the coefficient \(Gt^5\) of an ordinary bivector
subtracts its ordinary divergence, giving \(D(G)-qG\).
An order-\(k\) generator first changes a target with leading coefficient
one in degree \(k\), by \(-((k-4)b+h')\).
More generally, on \(G_j(z)t^j\) its infinitesimal contribution is
\[
t^{k+j}\bigl((j-k+4)bG_j+hG_j'-h'G_j\bigr).
\tag{3.7}
\]
This formula accounts for old transitions acting on targets already chosen;
it is not permissible to discard those terms after \(G_4\) is nonzero.

## 4. All four order-two obstruction tests

On disk \(j\) set \((A_1,B_1)=(p,mr)\), and on the outside set
\((A_1,B_1)=(P,0)\). Use \(D_1=t(m'E_t/3+m\partial_z)\).
Its leading action \((mr',-mr)\) matches the fields at index one.
The coefficient of degree one in \(A\wedge B\) is zero.

Put \(U=B_2\). On each chart solve
\[
r\wedge U=1-A_1\wedge B_1.
\tag{4.1}
\]
On a disk \(r=z\rho\), with \(\rho(0)\ne0\). The right side vanishes at
the center because \(p(0)\wedge R(0)=1\), so it is divisible by \(z\).
The wedge map with \(\rho\) is locally surjective. Outside, the wedge map
with \(r\) is a surjection of coherent sheaves, so Cartan B makes it
surjective on sections. These observations produce the holomorphic \(U\).

Since the first transition preserves \(\sigma\), the horizontal discrepancy
at index two wedges to zero with \(r\) on each annulus. It is a multiple of
\(r\). An order-two transition with \(b=h'/2\) removes it by
\(\delta U=-2hr\). Fix the outside horizontal row.

The remaining vertical discrepancy is a class in \(H^1(C,L^3)^2\).
Its dual tests are indexed by \(i,n\in\{1,2\}\), using the basis
\(r_i\) of \(H^0(K_C L^{-3})=H^0(L)\).
For a vertical lift \(D^{(2)}=A_2\), put
\[
\Psi_{in}=\left(r_iD^{(2)}_n+
\frac14 r_i'U_n+\frac34r_n'U_i\right)dz.
\tag{4.2}
\]
Once the horizontal rows match, the difference of these expressions is
precisely the dual test differential \(r_i\,\delta A_{2,n}\,dz\).

**Outside total.** Substitution of (3.1) gives
\[
\widetilde\Psi_{in}-\Psi_{in}
=\frac34(r_iU_n-r_nU_i)d\log g
=\frac34\epsilon_{in}d\log g
\tag{4.3}
\]
on the outside, where \(r\wedge U=1\). Hence
\(\Psi_{in}+\frac34\epsilon_{in}d\log r_1\) is intrinsic.
Its four outside poles at the remaining zeros of \(r_1\) have residue
\(\frac34\epsilon_{in}\) each. The contour residue theorem gives total
\(-3\epsilon_{in}\) about \(Z\) for that intrinsic differential.
Subtracting the six residues of \(\frac34\epsilon_{in}d\log r_1\) gives
\[
\sum_Z\operatorname{Res}\Psi^{\rm out}_{in}
=-\frac34\epsilon_{in}\deg L.
\tag{4.4}
\]
This uses contour integrals only, not a meromorphic outside lift.

**Inside total.** Before transport \(\Psi\) is holomorphic on each disk.
The order-two transition changes it by
\[
\delta\Psi_{in}=-\frac12d(hr_ir_n),
\tag{4.5}
\]
whose contour integral is zero. It remains to calculate the first
transition, including half its second bracket. Equation (3.3) gives
\[
\begin{split}
\Delta A_2&=\frac13m'p+mp'+\frac23mm'r'
             +\frac12m^2r''-\frac16mm''r,\\
\Delta U&=-mp+\frac13mm'r.
\end{split}
\tag{4.6}
\]
In particular, the two \(m^2r'\) terms in the horizontal calculation
cancel.

Write \(m=c/z\), \(r=zR/c\). Values on the right in the following
formulas are evaluated at zero:
\[
\begin{split}
F_{in}:=\operatorname{Res}(r_i\Delta A_{2,n}\,dz)
 &=-\frac13R_ip_n-\frac23R_iR_n'-R_i'R_n,\\
H_{in}:=\operatorname{Res}(r_i'\Delta U_n\,dz)
 &=-R_ip_n-\frac13R_iR_n'-\frac23R_i'R_n,\\
T_{in}:=F_{in}+\frac14H_{in}+\frac34H_{ni}
 &=-\frac7{12}R_ip_n-\frac34R_np_i
   -\frac54R_iR_n'-\frac{17}{12}R_i'R_n .
\end{split}
\tag{4.7}
\]
These are the **full matrix**, including both diagonal tests, not just
its alternating entry.

Because
\[
P=p+mr'=\frac{R(0)}z+p(0)+2R'(0)+O(z),
\]
the symmetric and alternating parts are
\[
T^{\rm sym}_{in}=-\frac23\operatorname{Res}(P_iP_n\,dz),
\qquad
T^{\rm alt}_{in}=\frac1{12}\epsilon_{in}
       \bigl(R\wedge p+R\wedge R'\bigr)(0).
\tag{4.8}
\]
The products \(P_iP_n\) are global meromorphic sections of \(L^4=K_C\).
The sum of each symmetric entry is therefore zero by the residue theorem.
The alternating sum is \(\epsilon_{in}\sum_j(W_j-1)/12\), because
\(R\wedge p=-1\).

Thus, in our discrepancy convention, the entire obstruction matrix is
\[
\boxed{\quad
\mathcal O_{in}=\frac{\epsilon_{in}}{12}
       \left(\sum_j(W_j-1)+9\deg L\right).
\quad}
\tag{4.9}
\]
For the given data, the transported-inside and outside total matrices
are both
\[
\begin{pmatrix}0&-15/2\\15/2&0\end{pmatrix};
\]
their difference is zero in **all four entries**. Nondegeneracy of duality
now splits the vertical class. Adding the resulting chartwise vertical
corrections does not change (4.1), since \(B_0=0\).

Equation (4.9) is also a necessary scalar test for this specified
volume-preserving first-two-step procedure if the total-residue hypothesis
is dropped. A changed sign or an inadmissible set of local rows is not a
counterexample to the manuscript; the negative controls in the program
are deliberately invalid identities, not geometric witnesses.

## 5. The simultaneous induction and the order-three correction

After step \(n\geq2\), maintain three assertions:
\[
\begin{array}{ll}
\text{fields:}&\text{rows through index }n\text{ match};\\
\text{equations:}&A\wedge B=t^2G\text{ has been imposed through degree }n;\\
\text{targets:}&G_0=1,G_1,\ldots,G_n\text{ are chosen and compatible
 under (3.6) through degree }n .
\end{array}
\tag{5.1}
\]
The two equations using \(G_{n-1}\) and \(G_n\) are still **unimposed**.
Step two supplies this invariant with \(G=1\), since both transitions
preserve \(\sigma\).

Assume (5.1) through \(k-1\), \(k\geq3\). The required horizontal equation is
\[
r\wedge B_k
 =G_{k-2}-\sum_{a=1}^{k-1}A_a\wedge B_{k-a}.
\tag{5.2}
\]
It is a well-defined equation of split type \(L^{k-2}\).
The extra vertical terms in (3.1) cancel because
\(\sum_{a=1}^{k-1}B_a\wedge B_{k-a}=0\).

Add a global \(a\in H^0(C,L^k)^2\) to \(A_{k-1}\).
It preserves matching through index \(k-1\). By (2.2) its values at all
six points are arbitrary. As \(B_1(q_j)=R_j(0)\ne0\), the functional
\(a(q_j)\mapsto a(q_j)\wedge B_1(q_j)\) is surjective. Choose those values
so the right side of (5.2) vanishes at every \(q_j\).
Only values, not derivatives, need interpolation, since the base divisor
is reduced. Division by \(z\) and Cartan B now give holomorphic \(B_k\).

This global addition is **not** invisible to the old transitions. Its
bracket with the order-one generator contributes at the current index
\[
\delta A_k=\frac{k-1}{3}m'a+ma',\qquad \delta B_k=-ma.
\tag{5.3}
\]
All old generators of order at least two and all repeated brackets affect
later indices. The required determinant consistency is the identity
\[
r\wedge(-ma)=a\wedge(mr).
\tag{5.4}
\]
Include (5.3) in the transported rows before making any comparison.

After transport, all lower field rows agree. The current determinant
difference is therefore \(r\wedge\delta B_k\), with no contribution from
\(\delta A_k\wedge B_0\). Compatibility of the already selected target
\(G_{k-2}\) makes that wedge zero. Since \(r\) has no common zero on an
annulus, there is a unique scalar multiple of \(r\) representing the
horizontal discrepancy. Choose the order-\(k\) generator to remove it
by \(-khr\). Set \(b=h'\) when \(k=3\) and \(b=0\) for \(k\geq4\).
An order-\(k\) transition cannot change target coefficients of degree
less than \(k\), so the target just used is untouched.

After horizontal matching, the remaining class belongs to
\(H^1(C,L^{k+1})^2\). For \(k\geq4\), duality gives
\[
H^1(C,L^{k+1})^*=H^0(C,L^{3-k})=0.
\tag{5.5}
\]
It splits by chartwise vertical corrections. They do not change (5.2).

**The exceptional case \(k=3\).** Here the class is in \(H^1(C,K_C)^2\),
so its two tests are against the constant section \(1\).
On overlap \(j\) change \(h\) by \(\lambda_j/z\), still taking \(b=h'\),
and change only the disk horizontal input at this index by
\[
B_3\longmapsto B_3+3\lambda_jr/z.
\tag{5.6}
\]
This is holomorphic at the center. Its wedge with \(r\) is zero, and it
cancels the new overlap contribution \(-3\lambda_jr/z\).
Keep \(A_3\) fixed in this disk coordinate. This is a legitimate local
section of \(\mathcal E_3\); changing coordinates subsequently introduces
exactly the vertical shear in (3.1), not an additional constraint.
Old positive-order transitions acting on the new index-three input have
index at least four.

The vertical change in the transported discrepancy at index three is
\[
\lambda_j\left(\frac{r'}z+\frac{2r}{z^2}\right),
\qquad
\operatorname{Res}\left[
\lambda_j\left(\frac{r'}z+\frac{2r}{z^2}\right)dz\right]
=3\lambda_j r'(q_j).
\tag{5.7}
\]
These are canonical differentials. If two spanning rows are
\((\alpha,\beta)\) and \((\gamma,\delta)\), with
\(\Delta=\alpha\delta-\beta\gamma\ne0\), and the present obstruction
row is \((o_1,o_2)\), choose
\[
\lambda_1=\frac{-\delta o_1+\gamma o_2}{3\Delta},\qquad
\lambda_2=\frac{\beta o_1-\alpha o_2}{3\Delta},
\tag{5.8}
\]
and all other \(\lambda_j=0\). This kills both entries exactly.
The resulting vertical class splits. The rank-two assertion is therefore
an explicit right inverse, not merely a dimension count.

Here is the complete preservation accounting:

| Change at step \(k\) | First possible determinant degree in \(A\wedge B\) | Consequence for selected targets |
|---|---:|---|
| Global addition to \(A_{k-1}\) | \(k\), through \(a\wedge B_1\) | Changes no imposed equation; (5.3) must be included in the overlap comparison |
| New \(B_k\) | \(k\) | Solves the equation using the fixed \(G_{k-2}\) |
| Chartwise correction to \(A_k\) | \(k+1\) | Equation for the fixed \(G_{k-1}\) has not yet been imposed |
| Order-\(k\) transition | target degree \(k\), thus determinant degree \(k+2\) | Leaves every previously chosen target coefficient below \(k\) unchanged |
| Order-three disk compensation (5.6) | at least \(4\), because \(r\wedge\delta B_3=0\) | May change the pending equation using \(G_2=0\), never the imposed degree-three equation |
| Selecting the new \(G_k\) | \(k+2\) | Does not change any current field equation |

In particular, (5.6) changes the disk degree-four expression by
\(A_1\wedge(3\lambda_jr/z)\); subsequent vertical splitting may also
change its \(A_3\wedge B_1\) term. At step four, arbitrary values of a
global addition to \(A_3\in L^4\) remove these resulting center values.
That addition is global, so it preserves the just-solved index-three
matching. No requirement that (5.6) preserve the unused degree-four
equation has been imposed or silently assumed.

## 6. The intrinsic order-four target obstruction

It remains to extend the targets in (5.1). Their line bundle, on a
realization or on the corresponding finite formal neighborhood, is
\[
\mathcal M=\mathcal I^4\det\mathcal F
           =\mathcal I^5\det\mathcal T_Y,\qquad
\mathcal M|_C=L^4\otimes T_C\simeq\mathcal O_C.
\]
Its degree-\(k\) associated graded is \(L^k\). Hence, once the lower
coefficients are compatible, the next target discrepancy is a Cech
cocycle in \(L^k\).

At \(k=3\) every selected transition preserves \(\sigma\), including the
modified one in (5.6), so retain \(G_1=G_2=G_3=0\).

At \(k=4\), all preceding transitions preserve \(\sigma\) exactly. The
new target discrepancy is consequently \(-h'\) in degree four.
To justify its intrinsic meaning, a horizontal generator transforms by
\[
\widetilde h=g^{4-k}h.
\]
At \(k=4\) it is a scalar. Thus \(h'\,dz=dh\) is an intrinsic exact
one-form on the annulus. The choice \(b=0\) is made in its disk
coordinate; \(b\) need **not** stay zero in another split coordinate.
This is harmless because its contribution to divergence is
\((k-4)b=0\) at this order.

The sole test of the \(L^4=K_C\) target class is against \(1\), and
each contour integral of \(-dh\) is zero separately. This proves that the
target class splits. Choose holomorphic chart coefficients \(G_4\) with
the resulting discrepancy. A conjugation by an earlier positive-order
transition changes an order-four generator only in orders at least five;
likewise old transitions acting on the new \(G_4t^4\) start in degree
five. Thus they do not change this calculation.

This proves simultaneous solvability at order four for *whatever*
horizontal discrepancy was produced by the interpolation and the
order-three compensation. No additional moment condition on those choices
is needed.

For **every** \(k>4\), the new target cocycle, including all contributions
from older transitions acting on previously chosen targets, splits because
\[
H^1(C,L^k)^*=H^0(C,L^{4-k})=0.
\tag{6.1}
\]
It would be wrong to assume that this higher cocycle is still just
\(-dh\) or that every target can be kept identically one. Its general
form is immaterial once (6.1) applies. Selecting \(G_k\) affects only the
still-unimposed determinant equation in degree \(k+2\).
This completes the proof of the invariant (5.1) for every \(k\).

## 7. Finite germs, the formal limit, and the precise cutoff

Each generator is holomorphic near the zero section over a relatively
compact annulus, and has
\[
D(t)=O(t^2),\qquad D(z)=O(t).
\]
Its time-one and time-minus-one holomorphic flow germs exist after a
transverse shrinking. For clarity, this is a local ODE assertion, not a
formal-to-analytic theorem: on a slightly larger annulus choose a small
transverse radius. In the scaled variable \(t=\varepsilon T\), the two
components and their first derivatives are uniformly \(O(\varepsilon^k)\)
on a compact polydisk. For sufficiently small \(\varepsilon\), Picard
iteration on complex time \(|s|\leq1\) is a contraction staying inside the
larger domain; its uniformly convergent holomorphic iterates give the
flow and its inverse. Uniqueness supplies their inverse relation.
For a finite number of generators a common smaller radius works.

The flows fix \(C\), and \(t\) changes by \(t+O(t^2)\); hence they preserve
the conormal \(L\). The disks are mutually disjoint, so there is no
additional triple-overlap equation. This supplies the transition germs
claimed in the finite statement. A Hausdorff analytic realization of their
gluing is a separate assertion in `analytic:realization`.

There is a small but important issue in the infinite statement: the
solutions at consecutive steps are not literally nested, since step
\(k+1\) may modify \(A_k\). Nevertheless, \(A_k\) is modified for the last
time at step \(k+1\), while \(B_k\) is finalized at step \(k\). Every
generator of index \(k\) and every \(G_k\) is finalized at that step.
For any fixed finite degree all these objects therefore stabilize after
finitely many steps. Each positive-order generator raises the
\(\mathcal I\)-adic order; its infinite composition is consequently
well-defined formally. Taking the stabilized coefficients gives matching
formal fields and a formal \(G\). Every fixed determinant equation, once
imposed, is preserved at every later step, so the limit satisfies
\(A\wedge B=t^2G\) exactly. This proves the claimed formal assertion,
without asserting convergence.

A row of index \(k\) contributes coefficients of degree \(k+1\) in the
logarithmic frame \((E_t,\partial_z)\). Thus indices \(0,\ldots,7\)
specify all coefficients in degrees \(1,\ldots,8\), while the constant
coefficient is zero. Their discrepancies are divisible by \(t^9\):
\[
\boxed{\quad \text{row index seven means sections modulo }
\mathcal I^9\mathcal F,\ \text{not modulo }\mathcal I^8\mathcal F.\quad}
\]
The quotient sections lie in \(\mathcal I\mathcal F/\mathcal I^9\mathcal F\).
Since \(A\wedge B\) has leading term \(t^2\), their logarithmic determinant
is \(t^4E_t\wedge\partial_z\), and their ordinary determinant is
\(t^5\partial_t\wedge\partial_z\), with coefficient one.

For comparison with the downstream lifting threshold,
\[
0\longrightarrow L^n
\longrightarrow\mathcal I^n\mathcal F/\mathcal I^{n+1}\mathcal F
\longrightarrow L^{n-4}\longrightarrow0.
\]
For all \(n\geq9\), the dual powers controlling the two first
cohomologies are \(L^{4-n}\) and \(L^{8-n}\), both of negative degree.
This proves the stated **graded** tail vanishing. It does not by itself
prove the formal-functions, contraction, or holomorphic lifting arguments
in section 5 of the manuscript.

## 8. What the exact certificate establishes

Run, without a network connection or a live Jacobian server:

```bash
python3 research/jet_audit/verify.py --negative-controls
```

The installed dependency is SymPy 1.14.0. All arithmetic is rational or
symbolic; floating-point JSON coefficients are rejected. No Lean file or
kernel-level claim has been introduced.

The replay checks 96 exact equalities/conditions, including the general
bracket with symbolic \(k,\ell\), target transport with symbolic \(k,j\),
all four entries of \(F,H,T\), both parts of the residue matrix, the
rank-two right inverse, coordinate covariance of the order-four
differential, and negative-degree formulas with an arbitrary nonnegative
integer parameter and the certificate's stated parameter and matrix shapes.
The parameter checks enforce statement fidelity; they do not prove that
the geometric hypotheses are realizable.

The local residue calculation uses independent Taylor coefficients of
\(R\) and \(p\). This is an exact reduction, not a finite experiment:
(4.6) has bounded pole order, and after \(r=zR/c\) only \(R(0),R'(0),p(0)\)
can contribute to the residues in (4.7). All higher Taylor coefficients
have nonnegative powers after the indicated multiplications. The code
retains additional independent Taylor coefficients and checks their
cancellation. Similarly, the rank-two check is a rational-function
identity conditional on a nonzero minor, not a test of selected numeric
rows. The analytic assertion that every single-valued \(dh\) has zero
contour integral is proved in section 2; the monomial calculation in the
program is not being substituted for that assertion.

Five deliberately corrupted identities are rejected: an order-two matrix
sign, the order-three compensation coefficient, the sign of target
divergence, the sign of the order-four differential, and the quotient
power \(9\). The program uses explicit exceptions rather than Python
`assert`, so its failure behavior is not removed by optimization.
An additional command-line negative test changed \(-7/12\) to \(+7/12\)
in the residue matrix. The standalone program actually exited with code
one and the nonzero residual \(-7R_{01}p_{01}/6\), recorded in
`negative_control_cli_output.json`; its temporary invalid input was removed.

Before any custom certificate code was written, the authorized Argus
adapter discovered and exposed the typed contract for
`polynomial_field.vector.divergence.compute`. A bounded operation computed
the ordinary divergence of
\[
(t^5(z^2+1),t^4z^3)
\]
as \(t^4(8z^2+5)\). Subtracting \(5D(t)/t\) gives the weighted
order-four divergence \(3t^4z^2\), independently replayed by the checker.
This specialization is only a typed-adapter sanity check, not the
quantified proof.

`jacobian_contract.json`, `jacobian_payload.json`, and
`jacobian_output.json` preserve the inspected contract, exact payload, and
typed output. The server was `jacobian` 0.14.0, protocol `2025-11-25`,
transport `mcp-stdio`; the adapter returned exit zero with no structured
error or timeout. No unavailable operation, timeout, or UNKNOWN result was
used as mathematical evidence.

## 9. Manuscript dependency boundary

All eight staged LaTeX files were read, directly for sections 2--4 and by
a bounded read-only source-inventory worker for the other five. The proof
graph and ledger contain all named theorem/lemma/proposition assertions
from that inventory, together with the invariants remark and external
inputs. Source labels are retained instead of inventing new numbering.

| Source | Recorded mathematical assertions | Status of this audit |
|---|---|---|
| `paper.tex` | Environments and inclusion order; no theorem assertion | Read |
| `01-introduction.tex` | `thm:main` | Open; depends on analytic counterexample and algebraization |
| `02-curve.tex` | `curve:six-vectors`, `curve:adjoint-jets`, `prop:curve-data` | Output used as hypotheses; construction remains open |
| `03-trace.tex` | `trace:pairing`, `trace:principal-parts`, `prop:residue-data` | Output used as hypotheses; full trace construction remains open |
| `04-jets.tex` | `jets:bracket`, `jets:second-obstruction`, `prop:jets` | Conditional proof and exact certificate supplied; independent review pending |
| `05-analytic.tex` | `analytic:realization`, `analytic:graded-vanishing`, `analytic:actual-lifting`, `prop:analytic-counterexample`, and `analytic:invariants` | The graded exponent calculation is checked here; realization, lifting, singularity, and the other conclusions remain open |
| `06-algebraization.tex` | `algebra:finite-determinacy`, `prop:algebraization`, `algebra:log-kodaira`, `algebra:derivation-blowups` | Open |
| `bibliography.tex` | Bibliographic source assertions, not new mathematical theorems | Exact jet-input sources read as described above; other applications remain open |

The unresolved upstream citations include the curve's Bertini and GAGA
applications, relative trace duality and splitting on \(\mathbb P^1\).
The unresolved downstream citations include Grauert contraction and formal
functions, the Demailly results, and the approximation/excellence/descent
inputs of algebraization. Their statements and manuscript locators are
recorded as unverified dependencies, not promoted to verified citations.

Neither passing structural checks nor passing the exact script constitutes
independent acceptance. Graph nodes retain `reviewer_confirmed: false`.
The campaign's publishability/novelty gate and its main surface theorem
remain open even if the bounded jet implication is accepted.
