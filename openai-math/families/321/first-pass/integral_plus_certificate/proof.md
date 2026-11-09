# Integral filling chains for the original five-generator construction

Let \(G\) have generators \(x_1,a_1,x_2,a_2,s\) and the six oriented
attaching words
\[
r_1=x_1a_1x_1^{-1}a_1^{-4},\quad
r_2=x_2a_2x_2^{-1}a_2^{-3},\quad
r_3=x_1a_2^{-13},\quad
r_4=sx_2s^{-1}a_1^{-5},\quad
t_1=x_1^2,\quad t_2=x_2^3 .
\]
Work over the integral, generally noncommutative ring \(R=\mathbb Z[G]\).
Cellular chains are free **left** modules, written as rows: the boundary
of a chain with coefficients \(c_i\) is \(\sum_i c_i d_i\), with that
order of multiplication. Write \(d_B:R^4\to R^5\) for the first four
Fox rows and \(b_j=\partial t_j\) for the last two. Thus
\[
D_2(v,w)=d_Bv+w_1b_1+w_2b_2.
\]
Here \(\partial\) is the lifted-edge Fox sum, not its evaluation at a
character. All coefficients below are finite integral sums of group words.

Writing \(N_n(a)=1+a+\cdots+a^{n-1}\), these six rows simplify in
\(R\), in the edge order \(x_1,a_1,x_2,a_2,s\), to
\[
\mathcal D_2=
\begin{pmatrix}
1-a_1^4 & x_1-N_4(a_1)&0&0&0\\
0&0&1-a_2^3&x_2-N_3(a_2)&0\\
1&0&0&-N_{13}(a_2)&0\\
0&-N_5(a_1)&s&0&1-a_1^5\\
1+x_1&0&0&0&0\\
0&0&1+x_2+x_2^2&0&0
\end{pmatrix}.
\]
The executable certificate retains the unsimplified lifted-edge sums
as finite sums of free words, so checking this construction does not
assume a word-problem algorithm for \(G\). For example, each negative
letter \(g^{-1}\) after a prefix \(p\) contributes \(-pg^{-1}e_g\).
The fundamental identity
\(\sum_g(\partial_g w)(g-1)=w-1\) gives \(d_1D_2=0\).

## Extracting the six reviewed word witnesses

For a word identity \(w=\prod_\nu c_\nu r_{i_\nu}^{\epsilon_\nu}
c_\nu^{-1}\) in the free group, put
\[
W(w)=\sum_\nu\epsilon_\nu c_\nu e_{i_\nu}\in R^4 .
\]
Since every \(r_i=1\) in \(G\), the Fox product and inverse rules give
\(d_BW(w)=\partial w\). In particular no prefix of the relator product
survives in its image in \(G\); the conjugator \(c_\nu\), on the left,
does survive.

Denote the first four reviewed witness chains by \(U_1,U_2,P_1,P_2\):
their targets are respectively
\[
[t_1,a_1]a_1^{-15},\quad [t_2,a_2]a_2^{-26},\quad
t_1a_2^{-26},\quad st_2s^{-1}a_1^{-15}.
\]
The last two witness chains are \(E_1=P_1-U_2\) and \(E_2=P_2-U_1\).
Their targets are \(t_1[t_2,a_2]^{-1}\) and
\(st_2s^{-1}[t_1,a_1]^{-1}\).

For \(N_n(a)=\sum_{j=0}^{n-1}a^j\), the four chains are explicitly
\[
\begin{aligned}
U_1&=(x_1+1+a_1^4+a_1^8+a_1^{12})e_1,\\
U_2&=\left(x_2^2+x_2(1+a_2^3+a_2^6)
                  +\sum_{j=0}^{8}a_2^{3j}\right)e_2,\\
P_1&=(1+x_1)e_3,\\
P_2&=(1+sx_2s^{-1}+(sx_2s^{-1})^2)e_4 .
\end{aligned}
\]
The reviewed free-word identities, together with \(t_1=t_2=1\), give
\(a_1^{15}=a_2^{26}=1\) in \(G\). Fox differentiation therefore gives
\[
\begin{aligned}
d_BU_1&=(1-a_1)b_1-N_{15}(a_1)e_{a_1},&
d_BU_2&=(1-a_2)b_2-N_{26}(a_2)e_{a_2},\\
d_BP_1&=b_1-N_{26}(a_2)e_{a_2},&
d_BP_2&=s b_2-N_{15}(a_1)e_{a_1},\\
d_BE_1&=b_1-(1-a_2)b_2,&
d_BE_2&=s b_2-(1-a_1)b_1 .
\end{aligned}
\]
These are identities of actual integral one-chains, not identities
only in an abelianized kernel or after scalar specialization.

## Integral Bezout filling

If \(a^n=1\), then
\(N_n(a)(1-a)=0\) and \(N_n(a)^2=nN_n(a)\). Define
\[
\begin{aligned}
F_{26}&=26P_1-N_{26}(a_2)U_2,\\
F_{15,2}&=s^{-1}(15P_2-N_{15}(a_1)U_1),\\
F_{15,1}&=15E_1+(1-a_2)F_{15,2},\\
F_1&=7F_{15,1}-4F_{26},\\
F_2&=s^{-1}(E_2+(1-a_1)F_1).
\end{aligned}
\]
Substituting the six boundary equations above gives, in order,
\[
d_BF_{26}=26b_1,\qquad d_BF_{15,2}=15b_2,\qquad
d_BF_{15,1}=15b_1,\qquad d_BF_1=b_1,\qquad d_BF_2=b_2.
\]
The penultimate equality uses \(7\cdot15-4\cdot26=1\).
Only powers of a single group element are interchanged in the norm
identities. In particular neither \(s^{-1}\) nor \(1-a_2\) is commuted
past \(N_{15}(a_1)\). There is no division.

Set \(F(w)=w_1F_1+w_2F_2\). The requested map is
\[
D_3(w)=(-F(w),w),\qquad q(v,w)=w.
\]
It follows that \(D_2D_3=0\) and \(qD_3=1\). This fixes the
orientation of both new three-cells.

## Retraction, contraction, and coefficient modules

Put \(A=-F\). The degree-two retraction and homotopy are
\[
r_2(v,w)=v+F(w),\qquad h_2(v,w)=w.
\]
Take \(r_1,r_0\) to be the identities, \(r_3=0\), and all other
\(h_j=0\). For the inclusion \(i(v)=(v,0)\), direct substitution gives
\[
ri=1,\quad r_2D_3=0,\quad d_Br_2=D_2,\quad
1-ir=D_3h_2\text{ in degree 2},\quad h_2D_3=1\text{ in degree 3}.
\]
Consequently the complex is the direct sum of the old complex and
\(0\to R^2\xrightarrow{1}R^2\to0\) in degrees 3 and 2. These are
identities of \(R\)-linear maps. Tensoring the identities with any
right \(R\)-module preserves the homotopy, with no flatness,
finite-generation, or torsion-freeness hypothesis. For any left
\(R\)-module \(M\), every cochain \(\varphi:R^2\to M\) extends to
\(\varphi q\), because \((\varphi q)D_3=\varphi\). This gives the
arbitrary-module third-cohomology vanishing.

## Topological realization and scope

Use the reviewed covering-space and cellular-homology identifications
in `research/wall_d2_audit/report.md`, Sections 4 and 6. The universal
cover of the six-relator presentation complex is simply connected
and two-dimensional. Each of the two explicitly displayed cycles
\((-F_j,e_j)\) therefore determines an integral \(H_2\) class. The
degree-two Hurewicz isomorphism represents it by a sphere map. Project
that map and attach a three-cell, choosing its lift and orientation to
agree with the cycle. There are no pre-existing three-boundaries, so
representing the homology class represents exactly that cellular
two-cycle. The resulting cellular boundary is the certified \(D_3\).
No algorithm producing geometric sphere maps is claimed.

The topological inputs are the already independently attributed
assumptions of `C-FOUNDATIONS` (Hatcher, Proposition 1.26,
Theorems 1.38, 2.35, 4.32 at \(n=2\), and Section 3.H), and the reviewed
plus-construction argument `C-PLUS-ATTACH`. They are not new Lean
theorems. Neither the cyclic-tower obstruction nor Wall's entire
counterexample is formalized here.

Compared with the strongest retained certificate, this construction
replaces the existential map \(A\) in Section 6 by two explicit
integral four-chains extracted from the same six word witnesses.
It addresses exactly the universal algebraic step excluded by
Section 9 of that report. It does not assert new mathematical
priority, publication-level significance, or campaign completion.

## Exact executable certificate

Run `python3 research/integral_plus_certificate/verify.py --self-test`.
The verifier works in \(T=\mathbb Z[F(x_1,a_1,x_2,a_2,s)]\).
Every equality it accepts has its difference expanded literally as
\[
\sum_\nu n_\nu u_\nu (r_{i_\nu}-1)v_\nu,
\]
where \(r_1,\ldots,r_6\) are exactly the six attaching words above and
\(u_\nu,v_\nu\) are free words. Hence the equality holds in
\(\mathbb Z[G]\). This is finite symbolic proof evidence for universal
integral identities, not a finite experiment on representations.
The usual presentation universal property identifies
\(T/(r_i-1:1\leq i\leq6)\) with \(\mathbb Z[G]\): the images of the
free generators remain units, satisfy the defining group relations,
and induce mutually inverse maps between the two rings.

The replay derives both torsion equalities from the original witnesses
and \(t_1=t_2=1\), never treating them as extra ideal generators.
It reconstructs all ten coordinates of \(d_BF_j-b_j\), the two
three-boundary rows, and the retraction and homotopy matrices. In the
final replay, all 2,892 intermediate equalities were checked by literal
ideal expansion, including 553,446 ideal terms with repetitions across
the intermediate proofs. All ten final coordinate expansions matched.
Thirty altered orientations, conjugators, arithmetic and splitting
coefficients, and malformed JSON inputs were rejected. A separate
public-CLI corrupted-file invocation exited 2 and its fixture was removed.
The number of checked equalities measures replay work, not the strength
or novelty of the mathematical theorem.

The authorized Jacobian adapter's inspected operation
`integer.compute.extended_gcd`, with exact payload
`{"left":"15","right":"26"}`, returned gcd 1 and coefficients 7, -4
(server 0.14.0, protocol 2025-11-25, adapter exit 0).
Its saved typed result supports only that integer substep.
The bounded discovery supplied no applicable noncommutative Fox
operation; no commutative substitute was used.

## Kernel certification and review boundary

The source `Main.lean` defines the actual six-relator presented group,
its integral group ring, the lifted-edge Fox derivative, the six
free-group witness products, and the explicit fillings above.
`IntegralPlus.instantiated_integral_plus` proves the chain identities
and retraction degree by degree; the other named declarations and
the exact scope are described in `statement-fidelity.md`.

The installed native CLI accepts the source as a positional argument.
The completed invocation was:

```bash
$WORKSPACE/argus-live-update/.venv/bin/python \
  -m argus_skill.verticals.math.lean_evidence verify \
  --project-root . --claim C-INTEGRAL-PLUS-CERT \
  research/integral_plus_certificate/Main.lean \
  --statement-fidelity research/integral_plus_certificate/statement-fidelity.md \
  --timeout 180
```

Lean 4.31.0 returned exit code 0, and the native axiom audit also
returned 0 with `proof_holes=[]`. The two printed theorem axiom
sets contain only `propext`, `Classical.choice`, and `Quot.sound`.
The tool recorded mechanical support for claim version 2 and
archived it in
`certificates/C-INTEGRAL-PLUS-CERT-c09c9366c2325e62.json`.
Its generated `statement_fidelity.md` is the canonical copy of the
requested hyphenated fidelity document, not a second interpretation.

The compiler establishes the encoded algebra, not the source reading,
Python implementation, Hurewicz realization, novelty, or significance.
Those distinctions are preserved in the ledger and the requested
Host independent review. The accepted manuscript verification and
G5/G6 results have not been revised or rerun.
