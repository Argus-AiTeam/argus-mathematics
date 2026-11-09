# A character-complete index theorem for the negative-four cap

## Result and scope

Let \(N\) be the disk bundle \(\mathcal O_{\mathbb {CP}^1}(-4)\),
with its complex orientation and outward boundary \(Y\). Choose the
generator of the quotient link \(Y=S^3/\mu _4\) for which the quotient
chart has action \(g(u,v)=(iu,iv)\). Let \(x[S]=1\), so that the
relative rational square is \(x^2=-1/4\). The following is a **local
verification theorem**, with an analytic proof from the stated index
theorems and a formally verified arithmetic core. It is not a
counterexample to cosmetic surgery and is not a proof of the global
manuscript.

Use the fixed-limit, small positive weight convention of the manuscript.
For ASD operators add the limiting parallel gauge dimension to obtain
the framed index. For Dirac operators use the corresponding APS condition;
the flat round boundary operator has no zero eigenvalue.

**Theorem.** Twist the canonical complex spin-c structure on \(N\) by a
line of degree \(a\in\mathbb Z\). Its determinant evaluation is \(k=2a-2\).
Write \(a=4q+r\), \(0\leq r<4\). Its complex cap Dirac index is
\[
 I(a)=q(1-r-2q)
     =\frac{(2r-2)^2-(2a-2)^2}{32}.                 \tag{1}
\]
The residue \(r\), not just \(k\bmod4\), is part of the boundary data.
For every allowed determinant-normalized rank-two boundary state and
every integer relative charge shift,
\[
\begin{array}{c|c|c|c}
 \text{intrinsic state}&\kappa&\delta_I&n_{D,N}\\ \hline
 +,-&n\in\mathbb Z&8\kappa&-\kappa\\
 \text{trace}&\tfrac14+n,\ n\in\mathbb Z&8\kappa&\tfrac14-\kappa .
\end{array}                                                    \tag{2}
\]
Consequently \(\delta_{\rm sp}=6\kappa\) at either center and
\(\delta_{\rm sp}=2+6(\kappa-\tfrac14)\) at trace.
These are index statements; they do not assert existence of solutions at
every listed charge.

For \(\Lambda[S]=\pm2\), the manuscript's active reference choices have
zero framed tangential correction. The other central-minus choice has
correction \(-2\). At the harmonic minimal trace reducer, assuming the
specified positive-scalar metric and ASD determinant connections, the
coupled Dirac operator is invertible, the framed tangential ASD index is
zero, the normal ASD index is one complex dimension, and the normalized
eigenline sweep has winding of absolute value one.

The determinant bit has the boundary transport described in Section 6
below. In particular the manuscript keeps \(l\), **not \(\Lambda\)**,
fixed. At trace the full characters agree only after the prescribed
Weyl permutation of eigenlines. At a central state tensoring exchanges
the two intrinsic labels; it is not a conjugacy between \(+\mathrm{id}\)
and \(-\mathrm{id}\).

## 1. Index-theorem inputs and source limitations

The primary PDFs and extracted text are in `sources/`.

1. **APS:** Atiyah--Patodi--Singer, *Spectral asymmetry and Riemannian
   geometry I*, DOI `10.1017/S0305004100049410`, Theorem (3.10), p.57,
   and twisted formula (4.3) and following spin-c remark, p.62.
   The hypotheses are a compact smooth manifold with boundary and a
   first-order elliptic operator with product form
   \(D=\sigma(\partial_u+A)\), where \(u\) is inward normal and \(A\)
   is self-adjoint. For the nonnegative spectral boundary projection,
   \[
   \operatorname{ind}D_P=\int\alpha_D-
                   \frac{\eta_A(0)+\dim\ker A}{2}.
   \]
   The spin-c specialization has density
   \(\widehat A\,e^{l/2}\operatorname{ch}(E)\).
   APS I does not state a general orbifold-with-boundary gluing theorem.
   We do not cite it as one.
2. **Orbifold RR:** Kawasaki, *The Riemann--Roch theorem for complex
   V-manifolds*, DOI `10.18910/8716`, formula (III), p.152, and the
   unnumbered theorem (IV), p.153. The hypotheses are a **compact complex
   V-manifold** and a holomorphic vector V-bundle. It computes the
   Euler characteristic of locally invariant sections by the Todd
   integral and fixed-sector terms. The symbol identification with the
   canonical spin-c Dirac index is explained on pp.155--156.
3. **Character convention:** Atiyah--Singer, *The index of elliptic
   operators III*, DOI `10.2307/1970717`, equivariant Chern character
   p.560 and holomorphic Lefschetz formulas (4.4)--(4.6),
   pp.565--566. The numerator uses the **actual bundle-fiber action**;
   the isolated-point denominator uses the **dual normal action**.
   Riemann--Roch (4.3), pp.564--565, also supplies the smooth case.

These are external mathematical inputs, not consequences of the Python
or Lean calculation. Their propositions are recorded as ledger
assumptions. A separate source-retrieval agent read all three primary
texts; Host-invoked Reviewer attribution remains necessary. The current
mission does not authorize the additional `research/literature/` path
which `citation_check attribute` always writes, so this Engineer has not
silently run that out-of-scope write or relabelled an opinion as
literature evidence.

## 2. Boundary identification and the analytic comparison

Compactify \(N\) in \(R=\mathbb F_4\), with negative section \(S\) and
fiber \(T\). Then
\[
 S^2=-4,\quad S T=1,\quad T^2=0,\quad K_R=-2S-6T.
\]
Contract \(S\) to obtain the weighted projective **orbifold**
\(X=\mathbb P(1,1,4)\), with local quotient ball \(Q=B^4/\mu _4\).
The complement of \(S\) is biholomorphic to the complement of the
quotient point. Under this identification
\(\mathcal O_R(aT)\) agrees with the orbifold line \(\mathcal O_X(a)\).
For example a fiber divisor maps to a weight-one coordinate divisor;
the normal slice gives \(x[S]=1\) and the isotropy character \(i^a\).
The canonical determinant has degree \(-2\) on \(S\) and isotropy
character \(i^2\). Twisting changes it to \(k=2a-2\) and character
\(i^{2+2a}\). The full spin-c lift retains \(i^a\).

Take the same product operator on the common **smooth** lens collar
in the two compactifications. Relative index comparison then gives
\[
 \operatorname{ind}D_N-\operatorname{ind}D_Q
       =\operatorname{ind}D_R-\operatorname{ind}D_X.       \tag{3}
\]
Here is the analytic justification used in (3). On cylindrical
completions, cut and interchange the identical exteriors for the
direct sum of the two operators. A two-by-two rotation of the two
copies, constant away from the collar, identifies their principal
symbols after this cut-and-paste. The difference is a zeroth-order
operator supported in a compact smooth collar. As an operator from
the first Sobolev domain to \(L^2\), it is compact by the compact
Sobolev inclusion on that collar. Thus the Fredholm index of the
direct sum does not change. The common exterior indices cancel.
The usual boundary matching correction also cancels, since the
boundary operators and spectral conditions are identical. In the
Dirac case there are no boundary zero modes. For ASD, use the same
weight and add the same limiting stabilizer factor on both sides.
The rotation, parametrices, and collar identifications are on a smooth
collar; the finite quotient chart is untouched. Interior parametrices
and Sobolev estimates on that chart are obtained by averaging the
ordinary ones over \(\mu _4\). Thus no APS theorem for singular
boundaries or assumed orbifold characteristic formula with boundary
is hidden in (3).

The quotient-ball Dirac index is zero in every fiber character.
Indeed, upstairs use a rotation-invariant positive-scalar metric
which is a product near the round boundary and flat determinant and
twisting connections. Such a metric is obtained by a round
hemispherical cap followed by a smooth concave transition to a
cylinder. The Clifford commutator identity is
\(D^*D=\nabla^*\nabla+s/4\) when the twisting curvatures vanish.
It kills both \(L^2\) chiral kernels; taking a finite-group invariant
subspace preserves this conclusion. The boundary operator is
invertible by the same identity on the positive-scalar round link.
The APS/cylindrical index is therefore zero. This argument uses the
equivariant canonical spin-c lift, not an arbitrary spin lift.

For a flat adjoint quotient-ball operator, invariant degree-one
deformation cohomology and degree-two obstruction cohomology vanish:
upstairs the ball is contractible, and finite-group averaging is
exact. The unframed gauge contribution is minus the invariant
parallel gauge dimension; framing cancels precisely this dimension.
The framed quotient-ball ASD index is consequently zero, both for a
trivial character and for a trace character.

## 3. Equivariant derivation for all integer twists

On \(R\), \(c_1^2=8\), \(c_2=4\), \(T c_1=2\), and \(T^2=0\).
Smooth RR therefore gives
\[
 \chi(R,\mathcal O(aT))=a+1                         \tag{4}
\]
for **every** integer \(a\), not just effective twists.

Let \(h=c_1\mathcal O_X(1)\). The weighted quotient's Euler sequence is
\[
 0\longrightarrow\mathcal O\longrightarrow
 \mathcal O(1)\oplus\mathcal O(1)\oplus\mathcal O(4)
 \longrightarrow TX\longrightarrow0.
\]
It is obtained by differentiating the weighted \(\mathbb C^*\) action.
Thus \(c_1(TX)=6h\) and \(c_2(TX)=9h^2\).
The divisors of the two weight-one coordinates intersect at the
quotient point with stabilizer of order four, so \(\int_Xh^2=1/4\).
The identity-sector RR integral is
\[
 P(a)=\int_Xe^{ah}\operatorname{Td}(TX)
     =\frac{a^2}{8}+\frac{3a}{4}+\frac{15}{16}.        \tag{5}
\]
There is one isolated quotient point. The exact nonidentity term is
\[
 B(a)=\frac14\sum_{j=1}^3
          \frac{i^{aj}}{(1-i^{-j})^2}.
\]
It is four-periodic, and direct arithmetic in \(\mathbb Q(i)\) gives
\[
 (B(0),B(1),B(2),B(3))=(1,3,1,-5)/16.               \tag{6}
\]
Kawasaki's theorem applies to each holomorphic orbifold line, including
negative twists. Equations (3)--(6) give, with no range restriction,
\[
 I(a)=a+1-P(a)-B(a)
     =\frac{1+4a-2a^2}{16}-B(a).
\]
Substituting \(a=4q+r\) proves (1). In particular
\[
 I(a+4)-I(a)=-a-1,\qquad I(2-a)=I(a),\qquad I(a)\leq0,
\]
and \(I(a)=0\) exactly for the five integers \(-1\leq a\leq3\).
The inequalities follow by separating \(q=0\), \(q\geq1\), and
\(q\leq-1\) in (1); the zero set also includes \(q=-1,r=3\).

This is an independent equivariant derivation, rather than a replay
of the manuscript's seven coherent Euler characteristics. Replacing
the dual tangent eigenvalues with tangent eigenvalues incorrectly
interchanges \(B(1)\) and \(B(3)\). The two characters also have the
same determinant character \(i^{2+2r}=1\), but their contributions
differ by \(1/2\). Either shortcut loses essential data. The staged
manuscript explicitly avoids these shortcuts; these tests do not
refute a manuscript assertion.

## 4. ASD and coupled Dirac corrections in every charge sector

Write the summand difference as \(d=2m\), \(m\in\mathbb Z\).
The intrinsic normalized eigenvalues are \(i^m,i^{-m}\).
The state is \(+\) for \(m\equiv0\pmod4\), \(-\) for
\(m\equiv2\pmod4\), and trace for odd \(m\). A split cap has
\[
 \kappa_{\rm split}=d^2/16=m^2/4.
\]
The scalar tangential ASD operator has unframed index \(-1\),
since \(b_1(N)=b^+(N)=0\); matching its one parallel scalar
generator makes its framed contribution zero.
The Kähler normal ASD symbol is the sum of the reversed Dolbeault
symbols for the difference line and its inverse. To see the factors,
complexify the real off-diagonal bundle; it is \(L_d\oplus L_{-d}\).
The real symbol has the compatible complex structure, and its
complex index is the negative sum of the two holomorphic Euler
characteristics. Comparing with the quotient ball using (3) gives
\[
 \delta_I=-2(I(d)+I(-d))=d^2/2=8\kappa_{\rm split}.    \tag{7}
\]
For even \(d\), (6) gives \(B(d)+B(-d)=1/8\), proving
the equality for every \(m\).

For either \(\lambda=\Lambda[S]=2\) or \(-2\), the two spin-c
determinants are \(k_\pm=\lambda\pm2m\). Their canonical twist
degrees are \(a_\pm=(\lambda+2)/2\pm m\). Formula (1) gives
\[
 I(a_+)+I(a_-)=\frac{-m^2+(m\bmod2)}4
       =-\kappa_{\rm split}+
         \begin{cases}0&m\text{ even},\\1/4&m\text{ odd}.\end{cases} \tag{8}
\]
All four residues of \(m\bmod4\) are used here, keeping the ordered
trace character as well as both centers.

For a fixed determinant and fixed **full** boundary data, any two
relative rank-two bundle sectors differ by an integer clutching degree.
This follows by trivializing over a small interior ball: the remaining
obstruction is \(\pi_3(SU(2))=\mathbb Z\), detected by \(c_2\).
Equivalently the compactly supported relative \(c_2\) lies in
\(H^4(N,Y;\mathbb Z)=\mathbb Z\).
Changing this degree by \(t\in\mathbb Z\) changes
\(\kappa\) by \(t\), the ASD index by \(8t\), and the complex
coupled Dirac index by \(-t\).
For completeness these coefficients are local closed-index
coefficients: \(\Delta p_1(\operatorname{ad}E)=-4t\);
the complexified ASD symbol is the reversed spin Dirac symbol
twisted by \(S^+\otimes\operatorname{ad}_{\mathbb C}E\), giving
\(-2\Delta p_1=8t\). The coupled spin Dirac symbol has
degree-four Chern-character change \(-t\). The closed case of the
twisted index theorem gives these changes. Since the replacement is
inside a ball, there is no change in boundary character, eta
invariant, stabilizer matching, or determinant transition.
Applying these changes to (7)--(8) proves (2) for **every** relative
sector. Charges assigned to a separated cap and its trajectories obey
the same congruences by additivity; none of this asserts that an
arbitrarily assigned trajectory exists.

## 5. Tangential references and the minimal trace reducer

The real tangential correction for an active line is \(2I(a_+)\),
since the framed scalar ASD correction is zero. Its exact zero set
is \(|k_+|\leq4\) with \(k_+\) even.

At intrinsic \(+\), take \(d=0\). At intrinsic \(-\), take
\(d=-2\lambda\), so \(k_+=-\lambda\); both \(d=\pm4\) restrict
to the same active boundary character. They differ by degree four
on the active bundle line, whose restriction to \(Y\) is trivial.
Use a parallel boundary trivialization on that line and its inverse
on the complementary line. The identification is determinant one.
The homotopy classes of these scalar trivializations have no extra
degree, because \([Y,U(1)]=H^1(Y;\mathbb Z)=0\).
At trace take \(d=2\) or \(-2\) according to the **prescribed**
normalized eigenvalue. Then \(k_+\) is \(0,4\), or \(-4\).
All of these references have \(I=0\). Choosing \(d=2\lambda\)
at intrinsic \(-\) instead gives \(k_+=3\lambda=\pm6\),
\(I=-1\), and real correction \(-2\).

At minimal trace charge \(1/4\), the normalized summand has degree
one, up to reversing its order and the sphere orientation. The unique
harmonic Abelian extension follows from \(b^+=0\) and \(H^1(N)=0\):
the self-dual obstruction vanishes, and the difference of two
extensions has zero exact-curvature norm by integration by parts,
then is gauge trivial. Equation (7) gives framed ASD index two
with tangent index zero, hence normal complex index one.
Both line Dirac indices in (8) are zero. With positive scalar
curvature and ASD determinant/twisting curvature, the positive
Dirac Weitzenbock formula has just
\(\nabla^*\nabla+s/4\); integration with finite-energy cutoffs kills
the kernel. Index zero then kills the cokernel.
For a degree-one eigenline the continuous holonomy phase around a
sphere sweep changes by one, by the curvature integral over \(S\).
Its winding has absolute value one.
These conclusions do **not** imply normal ASD surjectivity,
cut transversality, or a signed gluing count.

## 6. The actual determinant-bit transport

The convention must also use `05-stack.tex`, equations
`eq:stack:bit-lifts` and `eq:stack:sphere-pairings`:
\[
 c_e[S]=-4e,\quad \Lambda_e[S]=2-4e,\quad l[S]=2,\qquad e=0,1. \tag{9}
\]
Thus \(\Lambda_e-c_e=l\) is fixed. A calculation keeping \(\Lambda\)
fixed and changing \(l\) instead is a different family and cannot
certify this manuscript transition. That preliminary audit route is
retired in the ledger.

For an ordered split with \(d=2m\), the two bundle line degrees,
determinant-root degree, and total spinor twists are
\[
 p_e=-2e+m,\quad q_e=-2e-m,\quad R_e=-2e,\qquad
 (a_{e,+},a_{e,-})=(2-2e+m,2-2e-m).                \tag{10}
\]
The intrinsic normalized holonomy is
\(\operatorname{diag}(i^m,i^{-m})\) for either bit.
In the fixed common exterior determinant normalization it is
\[
 \alpha_e=(-1)^e\operatorname{diag}(i^m,i^{-m}).     \tag{11}
\]
Tensoring by the degree-minus-two line has precisely this order-two
boundary character. Its square is trivially represented on the
boundary, so a parallel determinant-preserving boundary
identification is available.

For trace, let
\[
 J=\begin{pmatrix}0&-1\\1&0\end{pmatrix},\qquad
 J\alpha_1J^{-1}=\alpha_0,\quad \det J=1,\quad J^2=-1.
\]
This map **swaps** the eigenlines. In the new exterior order,
the twists at \(e=1\) are therefore \((-m,m)\), not \((m,-m)\).
Compared with \(e=0\), their differences are
\[
 -m-(2+m)=-2(m+1),\qquad
 m-(2-m)=2(m-1).
\]
Both are multiples of four for every odd \(m\). Hence the full
coupled boundary characters, including the prescribed active
eigenline, agree. The individual cap indices agree as well:
\(I(-m)=I(2+m)\) and \(I(m)=I(2-m)\), by \(I(2-a)=I(a)\).
This last equality is an index equality, not an identification of
the two interior coupled spinor bundles. The nontrivial twisting
line is not being given a nonexistent global trivialization.

At a center, \(+\mathrm{id}\) and \(-\mathrm{id}\) are not conjugate.
Equation (11) exchanges the two intrinsic labels. If one instead
compares reference fillings at a **fixed exterior** central state,
choose \(m_1=m_0+2\). The new active total twist is
\(2-2+(m_0+2)=2+m_0\), exactly the old one; the new complementary
twist is the old one minus four. The reference charge changes by
\[
 (m_0+2)^2/4-m_0^2/4=m_0+1\in\mathbb Z,
\]
which must be retained as a relative degree change.
For the sharp choices: exterior \(+\) uses \(m_0=0,m_1=2\);
exterior \(-\) uses \(m_0=-2,m_1=0\). The active \(K\) is
respectively \(2\) and \(-2\) on both sides, so the tangential
correction remains zero. This comparison is not the fixed-charge
trace tensor pairing disguised as a central pairing.

Finally \(c_e^2=-4e^2\) and \(c_2=\kappa-e^2\).
At \(e=0\to1\), \(\Delta c^2=-4\), \(\Delta c_2=-1\),
and \(\Delta(c_2-c^2/4)=0\), as in
`eq:negative:tensor-charge`. The matrix and character identifications
are complex linear on the boundary. Their determinant-one property
does not determine the real ASD determinant-line comparison sign
including toral, framing, mark, and target factors. The manuscript
keeps that sign as \(s\); this audit does not replace it by \(+1\).

The boundary identification here is the parallel intertwiner \(J\)
in the specified flat representation models, with a chosen parallel
trivialization of the squared twisting line. It is not an arbitrary
map \(Y\to SU(2)\) substituted without its degree. Composing with
such a map of nonzero degree changes the relative clutching sector
and is accounted for by the integer shift in Section 4. At the
minimum the sector is fixed by the harmonic cap's actual charge
\(1/4\). The remaining parallel ambiguity is its connected torus
centralizer, and hence contributes no extra integer degree.
We do not infer a gauge degree merely from a constant matrix in a
local flat chart.

## 7. Exact evidence and comparison with the prior result

Run

```
$WORKSPACE/argus-live-update/.venv/bin/python research/lens_cap_audit/verify.py
```

The script uses exact rational/complex arithmetic and coefficient
identities with free integer parameters in each exhaustive character
class. It checks all integer twists, both signs of \(\Lambda[S]\),
every integral charge shift, the tangential references, and the
fixed-\(l\) determinant transport. It independently replays the
four-character Fourier calculation archived from Jacobian; it does not
need a live Jacobian server. `exact_certificate.json` records its
deterministic mathematical output. There is no sampled charge bound.

`Main.lean` formalizes the quantified arithmetic, exact four complex
fixed-point values, charge identities, and Weyl matrix identities.
`statement_fidelity.md` separates these from the analytic bridge.
The prescribed evidence command records an actual Lean 4.31.0
compiler outcome in the claim ledger; the formal source has no proof
holes.

The inherited campaign ledger had no earlier mathematical result.
The manuscript already gives an all-integer Euler-characteristic
expression via its function \(H\), as well as an all-charge table;
this audit does not claim a stronger numerical conclusion.
The improvement in evidence is the independent equivariant
derivation (1), a quantified compiler-checked arithmetic certificate,
and the explicit fixed-\(l\) determinant/eigenline transport
(9)--(11), rather than a finite check of the seven displayed rows.
The local displayed formulas agree.
No literal false assertion in the staged manuscript has been
established by this route, so there is no justified `F_...` refutation
to register. This is not a claim that the rest of the manuscript is
correct, nor a claim of verified mathematical novelty or publishable
significance. Those assessments, source attribution, and independent
acceptance belong to the Host-invoked Reviewer; the campaign remains
open.
