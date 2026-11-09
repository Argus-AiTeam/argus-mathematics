# A norm boundary symbol for selective peaking bridges

## Result and scope

The bridge's operator-norm assertion holds under its actual hypotheses.
The proof below works for every fixed finite word length, over the product
of the two excision index sets, including arbitrary old pure states outside
the designated classes. It also proves unique extension and exactly the
stated exclusion of other joins.

A stronger theorem identifies the nonzero boundary terms rather than only
proving their absence in the admissible tests. It permits any finite family
of pairwise inequivalent peaking states, grouped into prescribed blocks.
The resulting boundary map is a conditional expectation onto the constant
block-matrix algebra. Its norm-asymptotic formula holds at every fixed matrix
amplification. The original two-state bridge is the one-block, two-state
specialization.

These are mathematical proofs, not conclusions from a bounded search.
`Main.lean` separately certifies the complementary-corner norm inequality,
its product-filter consequence, and the length/tail arithmetic. It does not
formalize pure states or amalgamated free products. `verify.py` replays the
exact symbolic certificate and checks the scope and binding of that compiler
evidence. Neither file alone certifies the analytic applications.
Independent mathematical review and independent novelty assessment remain
required; neither has been performed by the Engineer.

Let `S` denote the staged source directory

    research/openai_manuscript/
      A-counterexample-to-Naimarks-problem-in-ZFC-September-24-2026/
      build/sections/

The exact target is `S/bridge.tex`, equations `eq:bridge-tests`,
`eq:bridge-word-decay`, and `eq:bridge-centering`, especially lines 110-292.
The theorem's consequences are in lines 294-357. No staged source is changed.
This report does not verify reordering, dependency-closed subiterations, or
the final ZFC recursion. Those remain separate open nodes in the proof graph.
No false manuscript assertion was identified, so there is no justified
`F_<LABEL>` refutation to register.

## 1. Statement of the stronger theorem

Let \(N\geq1\) be finite. Let \(A\) be a unital complex \(C^*\)-algebra with a
faithful tracial state \(\tau\) and no finite-dimensional irreducible
representations. For \(1\leq i\leq N\), let
\((p_n^i)_{n\geq0}\) be decreasing projections peaking to pairwise
inequivalent pure states \(f_i\), with

\[
 p_0^i=1,\qquad
 \tau(p_n^i)=t_n,\qquad
 1=t_0>t_1>\cdots>0,\qquad t_n\longrightarrow0.
\tag{H}
\]

"Peaking" means that exactly one state takes value one on all projections,
not merely weak or strong convergence in a chosen representation.

Write \(D_i=C^*(p_n^i)\), \(S_0=\mathbb N_0\cup\{\infty\}\), and identify
each \(D_i\) with \(D_0=C(S_0)\), matching all \(p_n^i\). Fix any partition
\(\mathcal P\) of \(\{1,\ldots,N\}\). Set

\[
 F=M_N(A),\quad D=\bigoplus_iD_i,\quad
 G=\bigoplus_{C\in\mathcal P}M_{|C|}(D_0),\quad Z=F*_DG.
\]

In \(F\), \(D\) is diagonal. In \(G\), use the indicated identifications
on its diagonal. The expectation from \(F\) applies the peaking expectation
to each diagonal entry; that from \(G\) takes its diagonal.
Give \(F\) its normalized matrix trace and give \(G\) the trace
\(N^{-1}\sum_i\tau_0(g_{ii})\). Thus a block of size \(r\) has weight \(r/N\);
this is not an unweighted sum of normalized block traces.

Let \(e_i\) be the common diagonal projections and, for \(u\ne v\) in
one block, write \(b_{uv}=e_{uv}^G\). Put

\[
 P_n^i=p_n^ie_i,\qquad Q_n=\sum_iP_n^i,\qquad
 \phi_i(a)=f_i(a_{ii}),\qquad
 B=\bigoplus_{C\in\mathcal P}M_{|C|}(\mathbb C)\subset G.
\]

For \(q\geq0\), define \(J_q:B\to G\) by

\[
 J_q(c)=\sum_{u,v\text{ in one block}}c_{uv}b_{uv}P_q^v,
 \qquad b_{ii}=e_i.
\tag{1}
\]

This is an injective *-homomorphism into the corner \(Q_qGQ_q\):
in each block it is \(c\mapsto c\otimes p_q\), and \(p_q\ne0\).
In particular \(J_q\) is isometric, completely isometric, and order
reflecting at every matrix level.

**Theorem.** There is a conditional expectation \(\beta:Z\to B\) such that,
for every \(z\in Z\),

\[
 \left\|Q_nzQ_t-J_{\max(n,t)}(\beta(z))\right\|
   \longrightarrow0
 \quad ((n,t)\longrightarrow\infty\text{ in }\mathbb N_0^2).
\tag{2}
\]

The same statement holds entrywise, hence in norm, on \(M_k(Z)\) for every
fixed finite \(k\). The formula for \(\beta\) on the dense centered-word
span is

\[
\begin{aligned}
 \beta(a)&=\operatorname{diag}(\phi_i(a)) &&(a\in F),\\
 \beta(a_0b_{uv}a_1)&=\phi_u(a_0)\phi_v(a_1)e_{uv},\\
 \beta(a_0b_1a_1\cdots b_ma_m)&=0 &&(m\geq2),
\end{aligned}
\tag{3}
\]

where \(E_D^F(a_j)=0\) for \(0<j<m\). Consequently
\(\|Q_nzQ_t\|\to\|\beta(z)\|\), also at every fixed matrix level.

Every pure state of \(F\) extends uniquely to \(Z\), and the extensions are
pure. The equivalence relation on old representation classes changes
exactly by identifying the classes of \(\phi_i\) within each block.
The same conclusions hold for \(A=e_1Fe_1\subset e_1Ze_1\).
The corner has a faithful extending trace and a faithful trace-preserving
expectation onto \(A\); if \(A\) is simple, the corner is simple.

The assertions quantify over arbitrary fixed coefficients and every finite
length, not uniformly over the unit ball or over unbounded varying lengths.

## 2. State-theoretic inputs, with their logical content

The classical inputs are Kadison's finite-vector transitivity (including
self-adjoint data), basic GNS and bidual theory, and compactness of state
spaces. AAP Proposition 2.2 and AW Lemma 1 provide published versions of
excision and cross-excision. For clarity, the particular forms needed here
are justified next, so a diagonal-limit reading of the latter cannot enter
the proof.

### 2.1 Decreasing and projection excision

For a pure state \(h\) of a unital algebra \(F\), set
\(L=\{a:h(a^*a)=0\}\) and \(M=L\cap L^*\). If \(a\in L\), then
\(a^*a\in M\), since \(h((a^*a)^2)\leq\|a\|^2h(a^*a)=0\).
The only state annihilating \(M\) is \(h\). Indeed, such a state \(k\)
annihilates \(a^*a\) for every \(a\in L\). Kadison transitivity makes
\(a\mapsto\pi_h(a)\xi_h\) onto \(H_h\). The open mapping theorem, applied
to its quotient by \(L\), makes
\(\pi_h(a)\xi_h\mapsto\pi_k(a)\xi_k\) a bounded intertwiner \(T\).
Irreducibility gives \(T^*T=c1\), and its value at \(\xi_h\) gives \(c=1\).
Thus \(k=h\).

For \(s\in M_+\), ordered by the usual directed order, put
\(x_s=(1+s)^{-1}\) and \(u_s=1-x_s\). Inversion is operator monotone
decreasing, so \(u_s\) increases. If \(s\geq m(bb^*+b^*b)\), then
\[
 \|x_sb\|^2,\ \|bx_s\|^2
 \leq m^{-1}\|(1+s)^{-1}s(1+s)^{-1}\|\leq(4m)^{-1}.
\]
Hence \(u_s\) is an approximate identity for \(M\), \(h(x_s)=1\),
and \(x_s\) decreases strongly to \(1-q\), where \(q\) supports \(M\).
Every normal state supported on \(1-q\) annihilates \(M\), and conversely
\(h(1-q)=1\). Normal states separate the corner, so its unique normal
state implies that \(1-q=r_h\) is minimal. Thus
\(r_har_h=h(a)r_h\).

Every weak-* cluster point of the positive functionals
\(\rho_s(x_s\,\cdot\,x_s)\), with arbitrary states \(\rho_s\), annihilates
\(M\) by the displayed estimates. It is zero or a scalar multiple of \(h\).
For self-adjoint \(a\), norming states for
\(x_s(a-h(a))x_s\) would contradict this fact if its norm stayed bounded
away from zero on a subnet. Real and imaginary parts prove excision for
all \(a\).

If projections \(P_n\) peak to \(h\), their infimum in \(F^{**}\) supports
only \(h\), so is \(r_h\). Cluster points of
\(\rho_n(P_n\,\cdot\,P_n)\) are likewise zero or multiples of \(h\);
they satisfy each fixed earlier peaking constraint. The same norming-state
argument proves
\[
 \|P_n(a-h(a))P_n\|\to0.
\tag{4}
\]
If \(h(a)=0\), nesting gives the genuinely rectangular estimate
\[
 \|P_naP_t\|\leq\|P_{\min(n,t)}aP_{\min(n,t)}\|\to0.
\tag{5}
\]
Both indices must exceed a common threshold. No diagonal-only inference
is used.

### 2.2 Cross-excision on a rectangular tail

For inequivalent pure states \(h,k\), \(\pi_h^{**}(r_k)=0\). Otherwise a
unit vector in its range, using \(r_kar_k=k(a)r_k\), represents \(k\)
in the irreducible \(h\)-representation, making them equivalent.
For decreasing contractive excision nets \(x_\lambda,y_\nu\),
\(h(ay_{\nu_0}a^*)\to0\). For all \(\nu\geq\nu_0\),

\[
\begin{aligned}
 \|x_\lambda ay_\nu\|^2
 &\leq\|x_\lambda ay_{\nu_0}a^*x_\lambda\|\\
 &\leq h(ay_{\nu_0}a^*)+
 \|x_\lambda(ay_{\nu_0}a^*-h(ay_{\nu_0}a^*))x_\lambda\|.
\end{aligned}
\tag{6}
\]

Given a tolerance, choose \(\nu_0\), then \(\lambda_0\) for that fixed
coefficient. The bound holds for every
\((\lambda,\nu)\geq(\lambda_0,\nu_0)\). This proves the product-net
statement, including when either net is a peaking sequence.

### 2.3 Trace-null supports and the peaking expectations

The GNS Hilbert space of every pure \(h\) is infinite-dimensional.
Kadison transitivity supplies unitaries \(u_j\) carrying its cyclic
vector to orthonormal vectors. The minimal projections
\(u_jr_hu_j^*\) are orthogonal, all of normal trace \(\tau_F(r_h)\).
Thus \(m\tau_F(r_h)\leq1\) for all \(m\), and
\(\tau_F(r_h)=0\). The normal extension of a trace is tracial; it need
not be faithful on \(F^{**}\).

For each original peaking sequence put \(d_n^i=p_n^i-p_{n+1}^i\).
These are nonzero orthogonal projections. They generate \(c_0\), and
adjoining 1 gives \(D_i=C(S_0)\). For \(a\in A\), set

\[
 E_i(a)(n)=\frac{\tau(d_n^iad_n^i)}{\tau(d_n^i)},\qquad
 E_i(a)(\infty)=f_i(a).
\tag{7}
\]

Equation (4), and \(d_n^i\leq p_n^i\), prove continuity at infinity.
Each coordinate is a state, so the map is UCP. Finite coordinates and
the character \(f_i|_{D_i}\), with Cauchy--Schwarz, prove bimodularity.
The trace has atom masses \(t_n-t_{n+1}\) and no mass at infinity;
summing proves trace preservation. Faithfulness follows from that of
\(\tau\). These establish the expectations used in (H), not an
assumption about an arbitrary MASA.

## 3. Reduced-module estimate and all endpoint states

For completeness the relevant reduced model is the Hilbert \(D\)-module
\[
 K=D\ \oplus\!
 \bigoplus_{\text{alternating }i_1,\ldots,i_r\in\{F,G\}}
 L_{i_1}^{\circ}\otimes_D\cdots\otimes_D L_{i_r}^{\circ},
 \qquad L_i=L^2(i,E_D^i).
\tag{8}
\]
Left multiplication using \(K=L_i\otimes_DK^{(i)}\) represents both
factors faithfully: annihilation of the vacuum implies
\(E_D^i(a^*a)=0\), hence \(a=0\) by the faithful factor trace.
Centered letters acting on words not starting in their factor create
a leg. Vacuum compression gives \(E_D\); compression to \(L_F\)
gives \(E_F\), and kills every centered word with a \(G\)-letter.
Centering arbitrary polynomials gives their dense linear span.

The composed trace \(\tau_D E_D\) is tracial: cyclically moving a
factor past an alternating centered word gives zero except for the
one-factor case, where it is the factor trace. If
\(\tau_D E_D(z^*z)=0\), traciality implies
\(E_D((zt)^*(zt))=0\) for every polynomial \(t\). Hence \(zt1=0\).
The vacuum is cyclic for elementary tensors, so \(z=0\).
Thus this trace, and consequently both trace-preserving expectations,
are faithful. This also supplies the trace and expectations used below
without an unstated reduced-product embedding theorem.

Let \(P\) project onto the words starting in \(G\). For any \(d\in F\),
vectors there are \(1\otimes\eta\) in the \(F\)-decomposition, whence
\[
 \|dP\|\leq\|E_D^F(d^*d)\|^{1/2}.
\tag{9}
\]
If
\(w=b_1a_1\cdots a_{m-1}b_m\), with every internal coefficient
centered, applying its letters from right to left to a word not
starting in \(G\) creates a leg at every step. Therefore
\[
 (1-P)w(1-P)=0,\qquad w=Pw+(1-P)wP.
\tag{10}
\]
This proves (10) for every finite \(m\), not up to a tested cutoff.
Equations (9)-(10) give, with \(d=xa_0e_{\ell(b_1)}\) and
\(d'=e_{r(b_m)}a_my\),
\[
 \|dwd'\|\leq
 \|dP\|\|w\|\|d'\|+\|d\|\|w\|\|Pd'\|.
\tag{11}
\]
The algebraic identity and norm inequality in (11), and their
product-filter consequence, are precisely the main Lean declarations.

For an arbitrary pure \(h\) of \(F\), take decreasing excision
\(x_\lambda\) as in section 2. For a fixed coefficient \(a\) and index
\(i\), \(E_D^F(e_i a^*x_\lambda a e_i)\) is a decreasing net of positive
continuous functions on the \(i\)-th convergent sequence. At a finite
atom \(R=P_n^i-P_{n+1}^i\), its limit is
\[
 \tau_F(Ra^*r_haR)/\tau_F(R)=0
\]
by trace-nullity and traciality. At infinity its limit is
\(\phi_i(a^*r_ha)\), which is zero if \(h\not\sim\phi_i\).
If \(h=\phi_i\), it equals \(|\phi_i(a)|^2\).

If this last value is zero, compactness makes the convergence uniform:
the open sets where individual functions are below a fixed tolerance
cover the spectrum; a finite subcover and a dominating index suffice.
This proves the required monotone-net version of Dini's argument
directly. Crucially, apply it to \(x_\lambda\), not to \(x_\lambda^2\).
The latter need not be monotone. The order
\(0\leq x_\lambda^2\leq x_\lambda\) is all that is needed.
Consequently
\[
 \|E_D^F(e_i a^*x_\lambda^2 a e_i)\|\to0
 \quad\text{if } h\not\sim\phi_i
       \text{ or }(h=\phi_i,\ \phi_i(a)=0).
\tag{12}
\]
The right endpoint is the adjoint-symmetric statement. By (11), any
word whose two endpoint defects in (12) vanish has norm decay.
This criterion has **no condition on equivalence of the two states**.

## 4. Sharp word calculation: every finite length

Whenever an endpoint state's class is designated, use its representative
\(\phi_i\) and its sequence \(P_n^i\). States outside all designated
classes are arbitrary and use the nets of section 2.
Call the left endpoint matched if \(h=\phi_{\ell(b_1)}\), and the
right matched if \(k=\phi_{r(b_m)}\).

At a matched left endpoint split
\(a_0=\phi_{\ell(b_1)}(a_0)1+a_0^0\), and make the analogous split
at a matched right endpoint. A zero-value branch has (12); an
unmatched endpoint has (12) without any split. For each scalar branch
use the exact relation in \(G\)
\[
 P_n^u b_{uv}=b_{uv}P_n^v.
\tag{13}
\]
There are at most four branches and at most two outer transfers.

If a core remains, each transferred endpoint exposes an original
internal \(a_j\). Centering implies
\(\phi_i(a_j)=0\) for every \(i\), by evaluation of \(E_D^F(a_j)\)
at infinity. The new endpoints therefore satisfy (12), whether
matched or unmatched. An untransferred endpoint is already good
by its branch choice. Apply (11) to the remaining core and keep
the removed matrix units, of norm one, as outside factors.
This handles zero transfers, one transfer when \(m\geq2\), and
two transfers when \(m\geq3\). All original index variables remain
independent. In particular no admissible-pair condition is imposed
on the transferred states.

Here are **all** empty-core cases.

* If \(m=1\) and exactly one scalar branch is transferred, the
  remaining expression is \(P_n^v a_1 y_\nu\), or its right-hand
  counterpart. If the other state is not \(\phi_v\), (6) applies.
  If it is \(\phi_v\), that endpoint's untransferred coefficient
  has zero \(\phi_v\)-value, so (5) applies.
* If \(m=1\) and both branches are scalar, both endpoints are
  matched. There is an **exact surviving term**
  \[
   \phi_u(a_0)\phi_v(a_1)b_{uv}P_{\max(n,t)}^v.
  \tag{14}
  \]
  It is not discarded or estimated by cross-excision.
* If \(m=2\) and both branches are scalar, the remaining compression
  is \(P_n^{r(b_1)}a_1P_t^{\ell(b_2)}\).
  If these indices differ, their pure states are inequivalent and
  (6) applies. If equal, centering gives zero state value and (5)
  applies. This also covers \(N>2\), where the exposed indices
  need not coincide even if the original endpoints do.

There are no further cases: at most two letters are removed, so a
word of length at least three cannot lose its entire core.
This arithmetic is universally quantified in Lean, not inferred
from finite enumeration.

It follows that, for every representative endpoint pair, all words
with \(m\geq2\) tend to zero in norm, without a pair restriction.
For \(m=1\), the same is true except for the double-matched term
(14); subtracting that term always gives a product-net null family.
Its norm is exactly
\(|\phi_u(a_0)\phi_v(a_1)|\), since every nonzero
\(b_{uv}P_q^v\) has norm one.

For the original \(N=2\) bridge, the equal-state test cannot double
match an off-diagonal letter. The inequivalent-pair test expressly
excludes this double match. Thus (14) is absent in **exactly** the
tests of the manuscript, proving `eq:bridge-word-decay`.

## 5. From normal forms to the boundary expectation

For \(a\in F\), (4)-(6) give the entrywise version of (2) with
\(\beta(a)=\operatorname{diag}(\phi_i(a))\).
Section 4 proves it for every nonempty normal form with exactly
the values in (3). Summing the finitely many matrix entries proves
(2) on the dense word span.

These formulas are well-defined even if an element has two normal-form
expressions. Their difference represents zero; (2) and the isometry of
\(J_q\) force its proposed symbol to have norm zero. They define a linear
map there and give
\(\|\beta(z)\|=\lim_{n,t}\|Q_nzQ_t\|\leq\|z\|\).
Extend it continuously to all \(Z\).
For a dense approximation \(z_0\),
\[
 \|Q_nzQ_t-J_{\max(n,t)}\beta(z)\|
 \leq 2\|z-z_0\|+
       \|Q_nz_0Q_t-J_{\max(n,t)}\beta(z_0)\|.
\tag{15}
\]
This proves (2) on a rectangular tail for every \(z\).

At each fixed matrix size the same entrywise convergence holds.
For positive \(T\in M_k(Z)\), the positive compression
\((1_k\otimes Q_n)T(1_k\otimes Q_n)\) approaches
\(J_n^{(k)}(\beta^{(k)}T)\). Because \(J_n^{(k)}\) is an isometric,
order-reflecting *-monomorphism, a negative spectral value of
\(\beta^{(k)}T\) would give a fixed positive lower bound on its
distance to positive elements, a contradiction. Adjoint preservation
follows first from the same asymptotic formula. Thus \(\beta\) is CP.
It is unital by (3), and restricts on \(G\) to matrix evaluation at
infinity, hence fixes the constant algebra \(B\).

For \(c,d\in B\), \(Q_n\) commutes with \(c,d\), and
\(cJ_q(b)d=J_q(cbd)\). Applying (2) and its uniqueness yields
\(\beta(czd)=c\beta(z)d\). This proves the asserted conditional
expectation without assuming a multiplicative-domain theorem.
No faithfulness or trace-preservation claim is made for \(\beta\).

## 6. Unique extension, exact selectivity, and the corner

For any pure \(h\) of \(F\), the equal-state case of section 4 gives
\(\|x_\lambda Wy_\nu\|\to0\) for all nonempty centered normal forms.
Any state extension \(\psi\) of \(h\) has its cyclic vector fixed
by every excision contraction: \(h(x)=1\), \(0\leq x\leq1\)
imply \(\|(1-\pi_\psi(x))\xi_\psi\|^2\leq\psi(1-x)=0\).
Consequently \(\psi(W)=0\).
The dense span and its prescribed values on \(F\) force
\(\psi=hE_F\). Existence is given by this composition.
It is pure: any convex decomposition would restrict to the pure
state \(h\), and uniqueness makes the decomposition trivial.
Kadison's self-adjoint transitivity gives a unitary in \(F\)
conjugating any two equivalent pure states (exponentiate a
finite-dimensional self-adjoint logarithm). Thus the representative
convention loses no old state.

Now let \(h,k\) be inequivalent and not both designated in one block.
Cross-excision kills \(x_\lambda ay_\nu\) for \(a\in F\).
Section 4 kills all nonempty normal forms: (14) could occur only
for two designated classes in one block. By density it kills
\(x_\lambda zy_\nu\) for every \(z\in Z\).
If the unique lifts were equivalent, realize them by unit vectors
\(\xi_h,\xi_k\) in one irreducible representation. Then
\[
 \langle\pi(z)\xi_k,\xi_h\rangle
 =\langle\pi(x_\lambda zy_\nu)\xi_k,\xi_h\rangle=0
 \quad(z\in Z),
\]
contradicting cyclicity of \(\xi_k\).

Within a designated block, the unique lift of \(\phi_i\) is
\(z\mapsto\beta(z)_{ii}\). The \(B\)-bimodule property gives
\[
 \widetilde\phi_j(b_{ij}^*zb_{ij})=\widetilde\phi_i(z).
\]
The vector \(\pi(b_{ij})\xi_j\) has norm one and represents the
other pure lift in the same irreducible representation. Hence
exactly these classes join. Equivalent old states continue to have
equivalent lifts by the conjugating old unitary.

The matrix units of \(F\) identify \(Z=M_N(e_1Ze_1)\).
Compression identifies states of \(A=e_1Fe_1\) with the
\(e_1\)-supported states of \(F\), and similarly for the corner
of \(Z\). This is a bijection on extension sets; its GNS
representations are matrix amplifications, preserving purity and
equivalence. Therefore the conclusions descend to \(A\).
For a block pair \(i,j\), the corner unitary
\(e_{1i}^F b_{ij} e_{j1}^F\) carries \(p_n^j\) to \(p_n^i\).
For \(N=2\), \(b_{21}=s\), this is exactly the source's
\(v=e_{12}^Fs\); so the identified corner is its reduced HNN bridge.

The trace on the corner, scaled by \(N\), extends \(\tau\);
the restriction of \(E_F\) is a faithful trace-preserving
expectation onto \(A\).
If \(A\) is simple and \(J\) a proper ideal of the corner, the
quotient is injective on \(A\). Every pure state of \(A\) then
extends through this quotient; uniqueness makes it \(hE_A\).
For every positive \(a\in J\), all pure \(h\) vanish on \(E_A(a)\).
Pure states separate positive elements, and faithfulness gives
\(a=0\). Thus \(J=0\).

## 7. A genuinely infinite-dimensional sharpness example

The assumptions are not vacuous. Take
\(A=\bigotimes_{r=1}^\infty M_2\), with its product trace, and
\[
 p_n^1=e_{00}^{\otimes n}\otimes1,\qquad
 p_n^2=e_{11}^{\otimes n}\otimes1,\qquad p_0^i=1.
\]
Their traces are \(2^{-n}\). Each sequence determines the appropriate
vector state on every local matrix algebra and hence exactly one
state on the norm-dense union and its completion. This proves peaking
and purity, not merely a local finite-dimensional analogy.
No nonzero finite-dimensional unital representation exists: its
dimension would be divisible by \(2^n\) for every \(n\).
The trace is faithful, for example by simplicity of the unital matrix
inductive limit and its trace-null ideal.

In the all-zero GNS representation, vectors obtained by finitely
many bit flips are dense. The all-one-prefix projections \(p_n^2\)
eventually annihilate each such vector, so converge strongly to zero.
In their own GNS representation they fix the cyclic vector.
The two representations are therefore inequivalent.

In the resulting two-state bridge,
\[
 P_n^2sP_t^1=sP_{\max(n,t)}^1,\qquad
 \|P_n^2sP_t^1\|=1\quad\text{for all }n,t.
\tag{16}
\]
This is the sharp surviving boundary term. It is **not** a
counterexample to the manuscript, whose tests exclude this pair.
It demonstrates why deleting that exclusion would be false while
satisfying all the infinite-dimensional and peaking hypotheses.

## 8. Prior art, evidence limits, and open downstream claims

Primary sources were opened, not inferred from search summaries.
Kadison Theorem 1 (doi:10.1073/pnas.43.3.273, p. 274) has exactly
the finite-vector and self-adjoint clauses used above.
Akemann--Anderson--Pedersen Proposition 2.2
(doi:10.4153/CJM-1986-063-7) gives decreasing pure-state excision.
Akemann--Weaver Lemma 1
(doi:10.1073/pnas.0401489101) explicitly permits replacing two
index sets by their product. Its Corollary 3 controls the selected
pair, not every old pure state.

Blanchard--Dykema Lemma 1.1 and Theorem 1.3
(doi:10.2140/pjm.2001.199.1) give factor expectations and compatible
embeddings with GNS-faithful expectations. Ueda
(arxiv:math/0601706v4, Proposition 2.2 and following discussion)
gives the matrix-corner model, already for finite families. Those
constructions are prior art, not claimed as new here.
Farah--Hirshberg (arxiv:1612.01170v2, Lemma 2.3) realizes an
equivalence pattern on specified countable sets; it does not
assert the all-old-state property proved here.
Naimpally--Peters, Theorem 1.5, page 306 of the cited 2013 paper,
explicitly treats monotone nets on compact Hausdorff spaces, so the
manuscript's Dini citation has the required scope.
The published KOS PDF was also checked at Theorem 1.1; the identical
arXiv statement was not used as a substitute for checking its DOI.

The mathematical addition to the staged pair bridge is (2)-(3):
the full sharp block-matrix norm symbol, rectangular convergence
for every element and every fixed matrix amplification, and the
simultaneous finite-block formulation. This is stronger than
the source's vanishing tests. A bounded comparison with the
named sources is not exhaustive novelty verification.

The exact rational Jacobian calculation is only a warning against
an invalid alternative proof: for
\[
 X=\begin{pmatrix}1&0\\0&1/2\end{pmatrix},\qquad
 Y=\begin{pmatrix}7/8&-1/8\\-1/8&3/8\end{pmatrix},
\]
\(0\leq Y\leq X\leq1\), but
\(\det(X^2-Y^2)=-1/256\).
The source correctly uses \(x^2\leq x\) before monotone compactness,
so this is not a flaw in the source.
The payload and typed output record Jacobian 0.14.0, protocol
2025-11-25, operation `matrix.subsystem.psd_order.decide`,
with no timeout or transport failure.

The exact script checks universal noncommutative polynomial identities
and the complete symbolic length-case split, not merely a finite range
of lengths. Its rational matrix replay is supplementary. The real Lean
certificate has the narrower scope stated in `statement_fidelity.md`.
Analytic statements in sections 2-6 still require a human mathematical
Reviewer; executable evidence is not substituted for that review.

The graph also records, without claiming their proof, the source's
`na:reorder`, `na:closed-extension`, `na:countable-determination`,
`na:state-count`, and final `na:main`. The KOS homogeneity theorem
is a downstream cited input only. This bridge certificate does not
discharge those nodes or certify a ZFC counterexample to Naimark's
problem.
