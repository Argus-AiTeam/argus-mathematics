# Relative Frobenius, Cartier scalar, and horizontal lift

**Unit:** `frobenius-trace-lift`; `C_TRACE@1`, `C_TRACE@2`, `C_TRACE@3`.  
**Assessment:** `supported_scope` under the retained hypotheses below. Exploratory Engineer assessment only; native independent review remains `required_pending`. No novelty is asserted.

## Exact claim and scope

On the generic smooth family, relative Frobenius on the Serre-dual lines has the same scalar \(s\in K_0=\operatorname{Frac}R\) on coherent pullback and finite dual trace. Its coherent class has a horizontal de Rham lift \(\lambda\). Consequently the geometric differential identity gives
\[
 s=\sum_jD_j(gt_js),\qquad
 \psi_h(r)=C_u(sr)\quad(r\in K_0),
\]
where \(C_u(x)\,du=\operatorname{Car}_{K_0}(F_*(x\,du))\). In particular \(s\) is **inside** Cartier; there is no assertion that \(s\) is constant or regular at a singular closed point.

The hypotheses are: \(k\) is the algebraically closed geometric residue field of characteristic \(p>0\) (perfection suffices for the field calculations); \(R\) is the retained normal integral finite-type chart algebra; \(K_0/k(u_1,\ldots,u_n)\) is finite separable, supplied by the retained nonzero finite étale normalization locus; and \(h:Z\to\operatorname{Spec}R\) has \(h_*\mathcal O_Z=R\), a smooth proper generic fiber \(Z_0/K_0\) of dimension \(n\), and the volume form \(\sigma_Z\) with relative frame \(\eta=\sigma_Z/du\). The geometric identity \(\eta=\sum_jD_j(gt_j\eta)\), its ordinary coordinate operators, and its de Rham/connection interpretation are retained in this fiber. Finally the absolute Cartier map on the smooth volume-form chart descends to a regular map \(\psi_h:F_*R\to R\). For the clearing application its normalization \(\psi_h(1)=\delta\in k^\times\) is a **separate input**, not a consequence of duality alone.

Evidence is restricted to old `9000041/research/cartier-clearing/proof.md:176–207`, the necessary chart and operator setup, and `build/source/sections/05-base-change.tex:633–651`, `709–815`, particularly `bc:relative-trace-lines`, `bc:scalar-differential`, and `bc:relative-cartier`. The reference source root is `openai-math/preprints/Projective-Space-Bases-of-Lagrangian-Fibrations-September-23-2026`, assigned revision `4eaee87548250b2682affda7d05d947c05554bae` by campaign `9100041/MANUSCRIPTS.json`; the parent already verified the thirteen TeX hashes. The old staged root is a symlink to this reference, **not an immutable historical manuscript snapshot**.

## Duality scalar: no hidden Frobenius power

The trivial relative canonical bundle and \(H^0(Z_0,\mathcal O)=K_0\) give \(W_0=H^0(Z_0,\omega_{Z_0/K_0})=K_0\eta\). Serre duality gives \(V_0=H^n(Z_0,\mathcal O)=K_0v\), with \(\langle v,\eta\rangle=1\). Flat field-Frobenius base change gives the twisted lines
\[
 V_0^{(p)}=V_0\otimes_{K_0,F_{K_0}}K_0,\quad
 W_0^{(p)}=W_0\otimes_{K_0,F_{K_0}}K_0,
\]
whose bases \(v^{(p)}=v\otimes1\), \(\eta^{(p)}=\eta\otimes1\) still pair to one.

Relative Frobenius is a \(K_0\)-morphism. Write \(F_{\rm rel}^*v^{(p)}=sv\). The finite dual trace is the Serre-dual transpose, so
\[
 \langle v^{(p)},\operatorname{Tr}_{F_{\rm rel}}\eta\rangle
   =\langle F_{\rm rel}^*v^{(p)},\eta\rangle=s.
\]
Thus its value is \(s\eta^{(p)}\), and on \(r\eta\) it is \(sr\eta^{(p)}\). Both relative maps are linear over the **second** \(K_0\) in the twist. Confusing them with absolute semilinear coherent Frobenius would incorrectly insert \(s^p\) or \(s^{1/p}\).

## Horizontal lift and scalar differential equation

Choose an affine Čech cocycle \((a_I)\) representing \(v\). Its componentwise \(p\)-th powers satisfy the Čech cocycle condition, since Frobenius is additive, and satisfy \(d_{\rm abs}(a_I^p)=0\) in absolute differentials over \(k\). They therefore form a total relative de Rham cocycle of degree \(n\). Changing the coherent representative by a Čech coboundary changes this lift by the coboundary of the \(p\)-th powers, so it gives a well-defined class \(\lambda\).

Projection to coherent cohomology gives \(F_{\rm rel}^*v^{(p)}=sv\). Cup product with the relative top form, in the order giving Serre evaluation, is represented in Čech degree \(n\) and form degree \(n\). Its trace is precisely \(\langle sv,\eta\rangle=s\).

The absolute closed representative also proves horizontality. In the filtration of the absolute de Rham complex by base differentials, the connecting operation defining Gauss–Manin is represented by its absolute differential; here that differential is zero. Hence \(\nabla\lambda=0\). Connection compatibility of the cup pairing gives, for each coordinate derivative,
\[
 \partial_i\langle\lambda,x\rangle
   =\langle\lambda,\nabla_i x\rangle.
\]
Iterating and including the regular base multiplication coefficients gives
\[
 \langle\lambda,D_j(gt_j\eta)\rangle=D_j(gt_js).
\]
Pairing the retained geometric identity now proves the displayed scalar equation. All derivatives of \(s\), \(g\), and \(t_j\) remain in this formula. Horizontality applies to \(\lambda\), **not** to \(\eta\) or \(s\). The Frobenius lift is newly constructed in characteristic \(p\); it is not falsely claimed to be a characteristic-zero object spread through infinitely many primes.

## Absolute trace and Cartier

The archived Stacks **Tag 0CC6**, Definition 33.36.4 (**Tag 0CC9**), defines \(Z_0^{(p)}=Z_0\times_{K_0,F_{K_0}}K_0\) and the factorization \(F_{Z_0}=w\circ F_{\rm rel}\). Lemma 33.36.8 supplies finiteness of relative Frobenius for a finite-type scheme. These facts were checked in `stacks-0CC6.txt:27–50`.

Finite separability over \(k(u)\) gives the \(p\)-basis \(u\) of \(K_0\), so \(F_{K_0}\) is finite of rank \(p^n\) and is flat, as any field extension is. In the Cartesian square defining \(w\), this gives Tor independence. Archived **Tag 0E5A**, setup 86.4.0.1, explicitly requires this hypothesis. **Tag 0E5K**, §86.6, defines trace as the right-adjoint **counit**; **Tag 0E5L**, Lemma 86.6.1, states compatibility of that counit with the derived base-change maps. For the finite locally free field map here, the needed identification is also elementary: base change of the finite-projective dual \(\operatorname{Hom}(F_*K_0,K_0)\) is the dual of its base change.

These are duality traces, not ordinary field traces of purely inseparable Frobenius extensions, which would vanish. Under the canonical top-form identification, the field counit is Cartier. Explicitly,
\[
 x=\sum_{0\le\alpha_i<p}u^\alpha c_\alpha^p
 \quad\Longrightarrow\quad C_u(x)=c_{(p-1)\mathbf1}.
\]
This also fixes its normalization and its rule \(C_u(a^px)=aC_u(x)\). The decomposition of absolute top forms into relative top forms and the base factor \(du\), with \(\eta^{(p)}=w^*\eta\), permits the projection formula: after relative trace produces \(sr\eta^{(p)}\), the trace for \(w\) applies \(C_u\) to the remaining coefficient \(sr\,du\). Transitivity of finite counits thus gives \(\psi_h(r)\,du=\operatorname{Car}_{K_0}(F_*(sr\,du))\).

The archived Stacks versions are the texts retrieved **2026-11-05**, with those numbered locators; no Stacks repository revision is recorded. The inherited records `1f7f06a3687e7ebed91359cd9cb8b3c4.json` and `8fbf97ec704afa85b3e1729be9d5c9ed.json` remain unchanged. Their attribution support does not supply the geometric premises.

## Clearing inputs and unsupported consequences

On an operator open \(D(f)\) containing \(\mu(b)\), \(B=k[u]_f\subset R_b\) is derivative-stable, as checked in the differential-identity unit. Finite separability makes \(u\) a \(p\)-basis: for a finite separable extension \(E/F\), \(E=FE^p\) because \(E/FE^p\) is both separable and purely inseparable, and \([E:E^p]=[F:F^p]\). Thus the monomial basis persists. Neither a branch-degree bound \(e_\mu<p\) nor regularity of \(s\) is used in this unit.

Setting \(r=1\) gives \(C_u(s)=\psi_h(1)=\delta\), **conditional on** the independent nonzero Cartier input at `633–651`, `709–724`. It does not say \(s=\delta\). The supported result is the generic duality/horizontality bridge and its rational formula. Independent construction of the charts, simultaneous geometric/cohomological retention, existence of sufficiently large nonzero-Cartier reductions, and all global base-change or projective-space consequences remain uncertified here. There is no unresolved internal step in the stated conditional bridge, and no independent Reviewer acceptance is claimed.
