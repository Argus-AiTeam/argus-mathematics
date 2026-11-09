# Uniform local scarcity with a larger good-index range

## Statement and scope

**Theorem (C_SCARCITY_EXT).** Fix \(2/3<c<1\) and \(\alpha\geq0\)
with \(2\alpha<3c-1\). Use the exact sine recurrence
\[
q_{i+1}=2q_i+k\sin(2\pi q_i)-q_{i-1},\qquad
K=2\pi k,\quad M=K+4,\quad v(q)=2+K\cos(2\pi q).
\]
Circle orbits are realized by this recurrence on real lifts; its derivative
recurrence is \(u_{i+1}=v(q_i)u_i-u_{i-1}\).

Fix \(q_e\), let \(\theta=q_{e-1}\), and use the two outward paths
\(q_j^-=q_{e-j}\), \(q_j^+=q_{e+j}\). On each path put
\(t_0=0,t_1=1\), and define goodness exactly as in
`can:good-definition`, with the present \(c\):
\[
\begin{split}
\tau_j-\tau_l&\geq c(j-l)\quad(1\leq l<j),&
\tau_{j+1}-\tau_j&\geq c,\\
\upsilon_j-\upsilon_{j+1}&\geq c,&
\upsilon_{j+1}-\upsilon_{j+2}&\geq c,
\end{split}
\]
where \(\tau_l=\log_M\max(|t_l|,|t_{l-1}|)\) and
\(\upsilon_l=\log_M\max(|u_l|,|u_{l-1}|)\).
The solutions on the two paths are common normalized solutions when
\(u_0^-=u_0^+=1\) and \(u_1^-+u_1^+=v(q_e)\).

Suppose \(j_+,j_-\geq2\) are good at a base \(\theta_*\) for such a
solution and
\[
|\log_M L_+-\log_M L_-|\leq\alpha,\qquad
L_\pm=|t_{j_\pm}^\pm(\theta_*)|,\quad L=\max(L_+,L_-).
\]
Let \(S\subset[-1,1]\) consist of those \(h\) for which at
\(\theta_*+h/L\) the same two indices are good for some common normalized
solution. The solution may depend on \(h\); no endpoint smallness, norm
bound on the central pair, or new matching assumption is imposed.

For every \(\eta>0\) there are \(\eta'>0\) and \(M_\eta<\infty\),
depending only on \(c,\alpha,\eta\), such that for every \(M\geq M_\eta\),
\[
\operatorname{Leb}_{\mathbb R}\{x:\operatorname{dist}(x,S)<\eta'\}\leq\eta.
\]
In particular \(c=99/100,\alpha=3/5\) proves the entire statement
`can:local-scarcity`, not a bounded-index or finite-parameter substitute.

This is an analytic proof with exact algebraic certificates for its
load-bearing identities and inequalities. The full analytic theorem is
**not** claimed to be a Lean theorem or to follow from numerical sampling.
No false assertion of the staged local proof has been established.
The main entropy theorem, bridge estimate, and multiscale argument remain
outside the result.

## 1. Uniform orbit jets, without a bound on the selected index

Fix either path and its selected index \(j\). Put
\[
L_j=|t_j(\theta_*)|,\quad \xi=L_j(\theta-\theta_*),\quad
B_l=M^{-c(j-l)},\quad D=d/d\xi .
\]
Goodness implies
\[
|t_l(0)|/L_j\leq B_l\ (1\leq l\leq j),\qquad L_j\geq M^{c(j-1)}.
\tag{1}
\]
Indeed the strict increase of successive pair maxima makes \(t_j\)
the dominant entry, and the first goodness inequality then gives (1).
Initially \(q_0\) is fixed and \(q_1\) is affine with derivative
\(\pm L_j^{-1}\). Every one-step transfer matrix, on any varied orbit,
has norm at most \(M\). Every fixed-order derivative of the sine potential
is bounded by a constant times \(M\).

Writing \(\Delta_l=q_l(\xi)-q_l(0)\), variation of constants in the
base recurrence and Taylor's formula give, for \(|\xi|\leq1\),
\[
|\Delta_l|\leq B_l+
 C\sum_{d=1}^{l-1}M^{l-d}|\Delta_d|^2.
\]
Under the inductive bound \(|\Delta_d|\leq2B_d\), the sum is at most
\(4C B_l^2\sum_{a\geq1}M^{(1-2c)a}=o(B_l)\).
This proves the bound uniformly in \(l,j\). Comparing \(Dq_l\) to its
base variation gives the same sum, with forcing
\((v(q_d(\xi))-v(q_d(0)))Dq_d(\xi)\). Thus
\[
|\Delta_l|+|Dq_l|\leq C B_l.                         \tag{2}
\]
For \(2\leq p\leq9\), differentiated recurrence forcing consists of
products \(\phi^{(s)}(q_d)\prod_i D^{m_i}q_d\) with \(s\geq2\),
\(m_i<p\), and \(\sum m_i=p\). Induction bounds it by \(C_p M B_d^p\):
for \(m_i\geq2\), the extra factor \(M^{1-m_i c}\) is at most one.
The higher initial derivatives vanish. Propagation on the varied orbit gives
\[
|D^p q_l|\leq C_p B_l^p\sum_{a\geq1}M^{(1-pc)a}
 \leq C'_p B_l^p M^{1-pc}.                         \tag{3}
\]
These are geometric sums, not estimates accumulating a factor \(j\).

At the selected site \(Dq_j(0)=\pm1\), and (3) with \(p=2\) gives
\(|Dq_j|\geq1/2\) for all sufficiently large \(M\). Consequently
\[
|t_j(\xi)|\geq L_j/2,\quad |t_l(\xi)|\leq C L_j B_l,\quad
|D^p E|\leq C_p M^{-c}\ (0\leq p\leq8),\quad
E=t_{j-1}/t_j.                                    \tag{4}
\]
For the last assertion differentiate \(E=Dq_{j-1}/Dq_j\).
The numerator and its first eight derivatives are \(O(M^{-c})\);
the denominator is bounded away from zero and its first eight
derivatives are bounded by (2)-(3). This proves C_PATH_JETS.
The estimates (1)-(4) actually require only a fixed \(1/2<c<1\);
in particular they also hold at \(c=2/3\), as used in (10).

## 2. A sharp chain estimate and the eighth boundary derivative

Let \(R_j\) be the value at site one of the Dirichlet solution
\(U_0=1,U_j=0\). The interior matrix \(B\) has diagonal \(v(q_a)\)
and adjacent diagonals \(-1\), with determinant \(t_j\).
Its inverse satisfies
\[
G_{ab}=t_{\min(a,b)}U_{\max(a,b)},\qquad
L_j|U_a|\leq2M^{j-a-1}.                            \tag{5}
\]
To verify signs, the Wronskian is
\(U_{a-1}t_a-U_at_{a-1}=1\).
The column in (5) has output
\(t_{b+1}U_b-t_bU_{b+1}=1\) at row \(b\), and zero at all other
interior rows. Also \(U_{j-1}=1/t_j\), which gives the backward bound.

Writing \(d_a=j-a\geq1\), (4)-(5) imply
\[
|G_{ab}|\leq C M^{\min(d_a,d_b)-1-c\max(d_a,d_b)},\qquad
|D^p v(q_a)|\leq C_p M^{1-cp d_a}\quad(1\leq p\leq8).       \tag{6}
\]
The ordered-composition formula for differentiating an inverse is
\[
D^n G=\sum_{s=1}^n(-1)^s
 \sum_{\substack{p_1+\cdots+p_s=n\\p_i\geq1}}
 \frac{n!}{p_1!\cdots p_s!}
 G(D^{p_1}B)G\cdots(D^{p_s}B)G.                    \tag{7}
\]
It follows directly by differentiating \(G B=I\), or by differentiating
the previous order and grouping ordered compositions. The verifier
independently checks this noncommutative coefficient recursion through
order eight.

For the \((1,1)\) entry in (7), the exterior factors are \(U_{a_1}\)
and \(U_{a_s}\). After multiplication by \(L_j^2\), the exponent supplied
by (5)-(6) is
\[
H=-1+d_1+d_s+\sum_{i<s}
 (\min(d_i,d_{i+1})-c\max(d_i,d_{i+1}))
 -c\sum_i p_i d_i.                                \tag{8}
\]

Here is a useful general sharp estimate. Let \(n\geq4\),
\(c_n=(n+2)/(2n-1)\), \(c_n\leq c<1\), and \(\sum p_i=n\).
Then
\[
H\leq n-(2n-1)c-\frac1n\sum_i p_i(d_i-1)
 \leq n-(2n-1)c-\frac1n\sum_i(d_i-1).              \tag{9}
\]
This is an all-depth inequality, not a finite-depth experiment.

**Proof of (9).** Repeat each \(d_i\) exactly \(p_i\) times, obtaining
\(x_1,\ldots,x_n\). The exponent of this expanded chain is the
original exponent plus \((1-c)\sum_i(p_i-1)d_i\), hence is no smaller.
Put \(A=\sum_{i<n}\min(x_i,x_{i+1})\),
\(V=\sum_{i<n}\max(x_i,x_{i+1})\), and \(T=\sum_i x_i\).
For each edge,
\[
n\min(x_i,x_{i+1})\leq i x_i+(n-i)x_{i+1}.
\]
Summing gives \(nA\leq x_1+x_n+(n+1)\sum_{1<i<n}x_i\);
also \(A+V=x_1+x_n+2\sum_{1<i<n}x_i\).
Substitution at \(c=c_n\) yields
\[
x_1+x_n+A-c_n(V+T)\leq-T/n.
\]
Since \(x_i\geq1\), \(V+T\geq2n-1\). Subtracting
\((c-c_n)(V+T)\) proves (9), because \(T=\sum p_i d_i\).
The expanded \(n=8\) inequality, with unrestricted real depths
\(x_i\geq1\) and real \(c\geq2/3\), is formalized in `Main.lean`.

For \(n=8\), (9) gives
\[
H\leq8-15c-\tfrac18\sum_i(d_i-1).
\]
The independent site sums are bounded by
\[
M^{8-15c}\prod_{i=1}^s(1-M^{-p_i/8})^{-1}\leq C M^{8-15c}.
\]
There are only \(2^7\) ordered compositions and fixed differentiation
coefficients. In particular
\[
L_j^2|D^8 R_j|\leq C M^{8-15c}.                   \tag{10}
\]
This proves C_CHAIN_BOUND uniformly in the unbounded selected index.
The same estimate for \(n=4\) gives \(L_j^2|D^4 R_j|\leq C M^{4-7c}\)
when \(c\geq6/7\). At the manuscript's \(c=99/100\) this exponent is
\(-293/100\), stronger than its claimed \(-2-4/5=-280/100\);
thus this audit verifies, rather than refutes, `loc:boundary-fourth`.

## 3. The actual success equation and its uniform error

Order the paths so the first has the larger base scale. In the coordinate
\(h=L(\theta-\theta_*)\), denote their selected positions by \(Q_i\),
their quotients by \(E_i\), and write
\[
b_i=Q_i'(0),\quad |b_1|=1,\quad |b_2|=r\in[M^{-\alpha},1].
\]
Equations (2)-(4) give
\[
\begin{split}
Q_i&=z_i+b_i h+\tfrac12 d_i h^2
       +O_{C^1}(|b_i|^3M^{1-3c}),\\
|d_i|&\leq C|b_i|^2 M^{1-2c},\qquad
|Q_i^{(p)}|\leq C_p|b_i|^p M^{1-pc}\ (2\leq p\leq9),\\
|Q_i'|&\asymp|b_i|,\qquad
|\partial_h^p E_i|\leq C_p M^{-c}|b_i|^p\ (0\leq p\leq8).
\end{split}                                                     \tag{11}
\]

At a good index the two decreases of the solution-pair maxima imply
\(|u_{j+1}|\leq M^{-2c}|u_{j-1}|\).
The Wronskian and \(|t_{j-1}/t_j|\leq M^{-c}\) give
\(|u_{j-1}||t_j|\leq(1-M^{-2c})^{-1}\leq2\).
Together with \(|t_{j+1}|\geq M^c|t_j|\), the exact identity
\(R_{j+1}-R_j=1/(t_jt_{j+1})\) gives
\[
u_1=R_j+\frac1{t_j^2(v_j-t_{j-1}/t_j)}
       +O(M^{-3c}|t_j|^{-2}).                    \tag{12}
\]
This holds separately for every successful \(h\), whatever solution
witnesses it. No selection or continuity of those solutions is used.

Apply (12) to the central equation and multiply by \(KL^2\).
Use (10) to replace its left side by its degree-at-most-seven Taylor
polynomial \(P_M\). Since the scale change is \(\xi=|b_i|h\), its
remainder is bounded by
\(C K |b_i|^6 M^{8-15c}\).
Thus, at every successful \(h\),
\[
P_M(h)=\sum_{i=1}^2
\frac1{(Q_i'(h))^2(\cos(2\pi Q_i(h))+(2-E_i(h))/K)}
+\varepsilon_M(h),                              \tag{13}
\]
\[
|\varepsilon_M|\leq C\{M^{9-15c}+r^{-2}M^{1-3c}\}=o(1).
\tag{14}
\]
The last equality uses \(c>2/3\) and \(2\alpha<3c-1\).
If \(r\) has positive limit, (14) is in fact \(o(M^{-1})\).
This sharper assertion, not just the coarse \(o(1)\), will be used
in the opposite-cosine normalization.

## 4. Polynomial extraction

Suppose a sequence with \(M\to\infty\) has nonempty success-set closures
converging in Hausdorff distance to a compact set \(F\) of positive measure.
Such a subsequence always exists: the distance functions to nonempty
closed subsets of \([-1,1]\) are uniformly bounded and 1-Lipschitz.
A diagonal subsequence on rational points converges uniformly by a finite
mesh argument. Taking minimizers shows the limit is the distance to its
nonempty zero set; this is Hausdorff convergence.

The following extraction applies to every normalization of (13) below.
If a polynomial of degree at most seven equals a locally uniformly
convergent function on successful points, up to \(o(1)\), away from a
fixed finite set of limiting poles, choose eight distinct points of \(F\)
outside those poles. Successful points approach these points by Hausdorff
convergence and the definition of closure. Their polynomial values are
bounded. The Vandermonde matrices converge to an invertible matrix,
so all coefficients are bounded. A subsequence converges coefficientwise;
the same approximation gives equality on \(F\) outside the poles.
After clearing the relevant analytic denominators, equality is an identity
on all of \(\mathbb R\). Indeed a nonzero analytic function has isolated
zeros by its first nonzero Taylor coefficient; an accumulation of zeros
forces local, and then connected-domain, identical vanishing.
Every further subsequence retains the same Hausdorff limit \(F\).

## 5. Nonzero slopes, including opposite-cosine cancellation

Take subsequences of the phases modulo integers and of the slope signs.
If \(r\to r_0>0\), the right side of (13) tends away from poles to
\[
\sec(2\pi(z+bh))+r_0^{-2}\sec(2\pi(z'+b'h)),
\quad |b|=1,\quad |b'|=r_0.
\]
If this equaled a polynomial on positive measure, clearing the two
cosines would give an identity. At every zero of either cosine the other
must vanish. Their zero progressions therefore coincide, forcing
\(r_0=1\). The two cosines are equal or opposite. Equality gives twice
a secant, which cannot be polynomial: multiply by its cosine and
evaluate at a zero.

For opposite cosines, reflect and translate the second phase by an odd
half-integer so that \(\widetilde Q_2\) and \(Q_1\) have the same limiting
affine phase. This is only a change inside the cosine and squared derivative;
the transformed phase is not asserted to be a new sine orbit. By (11),
\[
\widetilde Q_2-Q_1=p_M(h)+O_{C^1}(M^{1-3c}),\quad
\deg p_M\leq2,\quad \|p_M\|_{\rm coeff}\to0.
\]
Set \(\ell=\max(\|p_M\|_{\rm coeff},K^{-1})\).
Since \(c>2/3\), both this phase error and (14) are \(o(\ell)\).
Away from the common limiting cosine zeros, expand the two reciprocal
shifts first at the **actual** common phase. For
\(f(x,y)=y^{-2}\sec(2\pi x)\), the difference is
\(-f_xp_M-f_yp_M'+o(\ell)\); the two shifts together give
\(-4K^{-1}b_1^{-2}\sec^2 A+o(\ell)\), where
\(A=2\pi(z_1+b_1h)\).
Replacing the derivatives of \(f\) by their affine-phase values costs
only \(O(\ell M^{1-2c})=o(\ell)\). Explicitly,
\[
P_M=\frac{2p_M'}{b_1^3}\sec A
 -\frac{2\pi p_M}{b_1^2}\sin A\,\sec^2 A
 -\frac4{K b_1^2}\sec^2 A+o(\ell).                \tag{15}
\]
The reciprocal-shift expansion error is
\(O(K^{-2}+M^{-c}/K)=o(\ell)\).

Take \(p_M/\ell\to\bar p\), \(K^{-1}/\ell\to\beta\).
Their maximum coefficient norm is one. Extract the polynomial \(P_M/\ell\)
and multiply its identity by \(b^2\cos^2(2\pi(z+bh))\). At every cosine zero,
\[
2\pi\bar p(h)\sin(2\pi(z+bh))+4\beta=0.            \tag{16}
\]
At four consecutive zeros \(h=a+n\Delta\), \(n=0,1,2,3\),
\(\Delta=1/2\), the sine values alternate. After an invertible affine
change in the quadratic \(\bar p\), these are the four equations
\[
C+D=0,\quad A+B+C-D=0,\quad
4A+2B+C+D=0,\quad 9A+3B+C-D=0.
\]
Their determinant is 16. Hence \(A=B=C=D=0\), so \(\bar p=0\) and
\(\beta=0\), contradicting normalization. This proves C_OPPOSITE_CASE.
The determinant is independently computed by Jacobian and by the
standalone verifier; the implication is also a Lean theorem.

## 6. Every vanishing-slope regime

Suppose \(r\to0\). The fast term tends away from its poles to
\(\sec(2\pi(z+bh))\), \(|b|=1\). Write the second term as
\[
g(h)=\frac1{r^2 S(h)},\quad
S(h)=\left(\frac{Q_2'(h)}r\right)^2
\left(\cos(2\pi Q_2(h))+\frac{2-E_2(h)}K\right),\quad
w=\max(|S(0)|,r).
\]
By (11) and the product rule,
\[
|S^{(m)}|\leq C_m r^m\quad(1\leq m\leq8).         \tag{17}
\]
Here derivatives of \(Q_2'/r\) through order eight use orbit jets
through order nine, explaining that order in Section 1.
If \(w\to0\), then
\[
|S'(0)|/r\longrightarrow2\pi.                     \tag{18}
\]
In fact \(Q_2'(0)/r=\pm1\), the shifted cosine at zero is \(S(0)\to0\),
and thus the sine tends in absolute value to one.
Differentiating the squared derivative factor contributes
\(O(rwM^{1-2c})=o(r)\); the shift contributes
\(O(rM^{-c}/K)=o(r)\). The remaining derivative is
\(-2\pi\sin(2\pi Q_2(0))Q_2'(0)\).

Pass to a subsequence on which \(r/w\) has a limit.

If that limit is positive, \(w\to0\), and
\[
S(h)/w=S(0)/w+(S'(0)/w)h+O(r^2/w)
\]
converges uniformly to an affine polynomial \(A_0\) with nonzero slope,
by (17)-(18). Multiply (13) by \(r^2w\). The fast term and error vanish
away from fast poles, and the slow term tends to \(1/A_0\) away from
its possible zero. Extraction would give a polynomial \(B\) with
\(BA_0=1\) identically, impossible at the real zero of \(A_0\).

Otherwise \(r/w\to0\). Eventually \(w=|S(0)|\), and
\[
S(h)/S(0)=1+O(r/w)\to1
\]
uniformly. In particular \(S\) has no zeros on the working interval.
Let \(T_7g\) be the degree-seven Taylor polynomial of \(g\) at zero.
If \(w\) stays away from zero, (17) gives \(g^{(8)}=O(r^6)\);
then \(g-T_7g=o(1)\). Subtracting \(T_7g\) from (13) leaves a
polynomial equal to the fast secant, already impossible.

The final regime is \(w\to0\), \(r/w\to0\).
The exact reciprocal derivative formula has leading term
\[
g^{(8)}=\frac1{r^2}
\left(\frac{8!(S')^8}{S^9}+
\sum_{\substack{m_1+2m_2+\cdots+8m_8=8\\
                 k=m_1+\cdots+m_8<8}}
\frac{(-1)^k\,8!\,k!}{\prod_i m_i!(i!)^{m_i}}\,
\frac{\prod_i(S^{(i)})^{m_i}}{S^{k+1}}\right).      \tag{19}
\]
All 22 monomials, their signs, and factorial coefficients are checked
symbolically by the verifier, not by floating-point differentiation.
Equation (17) bounds each other numerator by \(C r^8\); relative to the
leading term it is \(O(w^{8-k})\). Also
\(S'(h)/S'(0)=1+O(r)\) by (17)-(18).
Thus, uniformly on \([-1,1]\),
\[
g^{(8)}=(8!+o(1))a_M,\qquad
a_M=\frac{S'(0)^8}{r^2S(0)^9}.
\]
Taylor's integral remainder, valid on both sides of zero, gives
\[
g(h)-T_7g(h)=a_M h^8+o(|a_M|).                    \tag{20}
\]
If \(|a_M|\to\infty\) on a subsequence, subtract \(T_7g\) from (13)
and divide by \(a_M\). Extraction identifies a degree-at-most-seven
polynomial with \(h^8\), impossible.
Otherwise take \(a_M\to a\in\mathbb R\). Without division, extraction
identifies such a polynomial with
\(\sec(2\pi(z+bh))+a h^8\). Move the polynomial term across, multiply
by the cosine, and evaluate at a cosine zero: again impossible.
The original error (14) vanishes in every subtraction, and after division
by an unbounded \(a_M\) also vanishes. This exhausts every subsequential
regime and proves C_SLOW_CASE.

## 7. Uniform neighborhoods and the original lemma

We have excluded every positive-measure Hausdorff limit of nonempty
success-set closures along \(M\to\infty\).
If the theorem failed for some \(\eta>0\), for each integer \(n\)
one could choose a configuration with \(M_n\geq n\) whose \(1/n\)
neighborhood has measure greater than \(\eta\).
Take a Hausdorff limit \(F\) of their closures. For every
\(\epsilon>0\), eventually their \(1/n\) neighborhoods lie inside
the \(\epsilon\) neighborhood of \(F\). All those latter neighborhoods
therefore have measure at least \(\eta\). Continuity from above for
bounded measurable sets gives \(\operatorname{Leb}(F)\geq\eta\),
a contradiction. Empty success sets cause no difficulty.
Neighborhoods are open regardless of any measurability of a choice
of witnessing solutions. This proves C_COMPACT_EXTRACTION and the theorem.

Finally \(2(3/5)=6/5<197/100=3(99/100)-1\), so the theorem applies
with every original quantifier and hypothesis intact to C_LOCAL_SCARCITY.

## Source comparison and novelty boundary

The comparison source is the staged September 23, 2026 manuscript:
`cancellation.tex`, `can:local-scarcity`; and `local-scarcity.tex`,
especially `loc:boundary-fourth`, `loc:cubic-relation`,
`loc:opposite-expansion`, and `loc:quartic-remainder`.
Its stated constants are \(c=99/100,\alpha=3/5\), and its boundary
Taylor order is four. The present argument supplies the explicit
all-depth estimate (9), uses order eight, and proves the larger
\(c>2/3,\ 2\alpha<3c-1\) range.

A targeted Wiki search found no relevant standard-map scarcity result.
A web-search summary attributed an eighth-order threshold extension to
the staged fourth-order manuscript without furnishing a matching primary
passage. That summary is not used as mathematical or novelty evidence.
No independently verified literature source for this extension was
obtained. Novelty and publishable significance remain questions for the
independent Reviewer; neither is certified by an algebra script.
The elementary compactness, interpolation, and analytic-identity steps
used here are justified in Section 4 rather than imported as unchecked
external propositions.
