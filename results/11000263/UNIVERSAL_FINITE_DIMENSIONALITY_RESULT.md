# Factorial principal-ideal recursion: exact base and first generic gate

## Setting

Work over \(K=\mathbb Q(q)\), put

\[
s=(q-1)^2(q+1),\qquad e=s^{-1}X_3,\qquad
P(T)=(T-1)(T+q),
\]

and use the two repaired presentations fixed in `OBJECTIVE.md`.  Every
calculation below uses relations common to both repairs.  The extra
direct-limit terminal rows have \(X_4\), or a shifted descendant of \(X_4\),
as a factor and hence add nothing after \(X_4=0\).

The immutable symbolic and modular Burau verifiers were rerun in
`baseline_replay/`.  Both outputs are byte-identical to the reviewed
supervisor artifacts.

## Exact characteristic-zero base theorem

Let \(L_a\) and \(R_a\) denote left and right multiplication by \(a\) on the
reviewed 169-dimensional regular quotient \(Q_4\).  Direct evaluation of
\(X_3\) in the six exact matrices gives

\[
L_e^2=L_e,\qquad R_e^2=R_e,\qquad
\operatorname{tr}(L_e)=\operatorname{tr}(R_e)=8.
\]

An idempotent over a field is diagonalizable with eigenvalues zero and one,
so its rank equals its trace.  Since

\[
\operatorname{im}L_e=eQ_4,\qquad
\operatorname{im}R_e=Q_4e,
\]

this proves

\[
\boxed{\dim_K(Q_4e)=\dim_K(eQ_4)=8=4!/3.}
\]

This is a characteristic-zero theorem, not an inference from the \(q=2\)
fiber.  The certificate also records nonzero \(8\times8\) minors.  For
\(Q_4e\) one such determinant is

\[
q^{-24}(q-1)^{-16}(q+1)^{-8},
\]

and for \(eQ_4\) one is

\[
-q^{-25}(q-1)^{-14}(q+1)^{-8}
(q^2-q+1)(q^2+1)^2(q^3+q-1).
\]

The multiplication map

\[
\mu:(Q_4e)\otimes_K(eQ_4)\longrightarrow Q_4eQ_4=J_4,
\qquad ae\otimes eb\longmapsto aeb,
\]

is surjective.  Its source and target both have dimension \(64\), using the
reviewed exact equality \(\dim_KJ_4=64\).  Therefore

\[
\boxed{\mu\text{ is an isomorphism of }K\text{-vector spaces}.}
\]

The exact Schreier bases at the base step are

\[
\{t v:t\in\{1,\sigma _3,\sigma _2\sigma _3,
\sigma _1\sigma _2\sigma _3\},
v\in\{e,\sigma _1e\}\}
\]

for \(Q_4e\), and

\[
\{v t:v\in\{e,e\sigma _2\},
t\in\{1,\sigma _3,\sigma _3\sigma _2,
\sigma _3\sigma _2\sigma _1\}\}
\]

for \(eQ_4\).  Each displayed eight-vector family has exact rank eight.

The reviewed \(W_a\) cyclicity determinant in
`../infinite_countermodel/parabolic_induction/saturated_relative_initial/`
now identifies the left \(Q_4\)-module \(Q_4e\) with \(W_a\).  Indeed,
\(w_0=X_3e_0\) satisfies \(ew_0=w_0\), so

\[
Q_4e\longrightarrow W_a,\qquad ae\longmapsto aw_0
\]

is a surjective map between two eight-dimensional modules.  Consequently
\(Q_n\otimes_{Q_4}W_a\cong Q_ne\) whenever the induced presentation is
formed over the same coefficient field.  This explains why the existing
\(W_a\)-induced vector enumeration is the relevant computation; it does not
make a specialized closure lift to \(K\).

## The factorial Schreier criterion

For \(1\leq k<n\), define

\[
d_k^{(n)}=\sigma_k\sigma_{k+1}\cdots\sigma_{n-1},
\qquad d_n^{(n)}=1.
\]

The candidate left recursion is

\[
L_3=\operatorname{span}\{e,\sigma _1e\},\qquad
L_n=\sum_{k=1}^n d_k^{(n)}L_{n-1}.                 \tag{1}
\]

For a standard generator \(\sigma_i\), braid and distant-commutation
relations give

\[
\sigma_i d_k^{(n)}=
\begin{cases}
d_k^{(n)}\sigma_i,&i<k-1,\\
d_{k-1}^{(n)},&i=k-1,\\
(1-q)d_k^{(n)}+qd_{k+1}^{(n)}
 +P(\sigma_k)d_{k+1}^{(n)},&i=k,\\
d_k^{(n)}\sigma_{i-1},&i>k.
\end{cases}                                           \tag{2}
\]

Thus all Coxeter-type cases reduce to the previous rank.  The complete new
obligation is

\[
P(\sigma_k)d_{k+1}^{(n)}v\in L_n
\quad(1\leq k<n,\ v\in L_{n-1}).                      \tag{3}
\]

The natural right recursion uses
\(\bar d_k^{(n)}=\sigma_{n-1}\cdots\sigma_k\) and leaves the opposite
obligations

\[
v\bar d_{k+1}^{(n)}P(\sigma_k)\in R_n.                \tag{4}
\]

Positive closure would imply inverse closure because

\[
\sigma_i^{-1}=q^{-4}\bigl(
\sigma_i^2+(q+q^3-1)\sigma_i+q^4-q-q^3
\bigr).
\]

Equations (3) and (4), not the inverse actions, are the missing uniform
mathematics.

## Exact first left gate

Write \(z=\sigma_3\), \(w=\sigma_4\), and \(V=ze-e\).  In rank five, the
first two diagonal \(w\)-transitions satisfy

\[
P(w)e=P(w)\sigma_1e=0.
\]

The next transition is

\[
w(wze)=(1-q)wze+qze+P(w)V.                            \tag{5}
\]

Hence the first genuinely unresolved generic identity is exactly

\[
\boxed{P(w)V\in L_5.}                                 \tag{6}
\]

It is important that (6) does not ask for \(P(w)V=0\).  That stronger
identity is false.

The complete 61-dimensional local algebra on \(e,z,w\), with its 20-rule
Groebner--Shirshov basis and all 201 overlap compositions zero, gives

\[
\operatorname{NF}(P(w)V)
=w^2ze+(q-1)wze-qze.
\]

The six local Schreier states

\[
e,\ ze,\ we,\ wze,\ zwe,\ zwze
\]

have rank six, while adjoining \(P(w)V\) raises the rank to seven.  The
coefficient of the normal word \(w^2ze\) is an exact separating functional.
Therefore no proof of (6) can use only this complete local relation system:
it must use relations involving \(\sigma_1\) or \(\sigma_2\).

This local separation does **not** refute (6) in the full quotient \(Q_5\).
The full quotient has additional nonlocal syzygies, and a quotient of the
61-dimensional local algebra may kill the separated class.

## Finite-fiber discovery, not a lift

In the exact \((q,p)=(2,101)\) induced fibers, the forward representatives

\[
\{1,\sigma_{n-1},\sigma_{n-2}\sigma_{n-1},\ldots,
\sigma_1\cdots\sigma_{n-1}\}
\]

give successive block ranks

\[
8,16,24,32,40
\]

at \(n=5\), and

\[
40,80,120,160,200,240
\]

at \(n=6\).  Reversing these representatives on the same left module gives
only ranks \(16\) and \(80\), respectively.  This fixes the candidate
orientation but says nothing about the genuine right principal module.

At \(p=101\) and \(q=2,3,5,7,11\), the unique coordinates of the first
target in the 40-vector forward basis agree with the candidate identity

\[
\begin{aligned}
P(d)(ce-e)
={}&\frac{q-1}{q}\,cdP(c)e\\
&+(1-q)(a+q)bcd\,bc\,e,                               \tag{7}
\end{aligned}
\]

where \(a=\sigma_1,b=\sigma_2,c=\sigma_3,d=\sigma_4\).
Expanded, the five candidate coefficients are

\[
1-q,\quad \frac{(q-1)^2}{q},\quad\frac{q-1}{q},
\quad q(1-q),\quad1-q.
\]

Equation (7) is **not proved over \(K\)**.  The exact original-ideal
membership problem is

\[
\bigl[
qP(d)(c-1)-(q-1)cdP(c)-q(1-q)(a+q)bcdbc
\bigr]X_3=0.                                          \tag{8}
\]

No defining-row combination or characteristic-zero quotient separator for
(8) is currently known.

The bounded exact \(K\)-vector enumeration used one CPU, an 8 GiB virtual
memory ceiling, and a 1200-second limit.  It reached 139 live states at
weight nine but did not close and emitted no action table.  This timeout is
nonconclusive: 139 is neither a dimension nor a lower bound.

## Dimension consequences and status

Because \(e\) is a nonzero scalar multiple of \(X_3\),

\[
J_n=Q_nX_3Q_n=Q_neQ_n                                      \tag{9}
\]

for every \(n\) and both repairs.  The reviewed BMW projection gives

\[
Q_n/J_n\cong\operatorname{BMW}_n(q,-q^3),
\qquad \dim_K(Q_n/J_n)=(2n-1)!!.
\]

The reviewed Burau representation has nonzero \(X_3\), so \(J_n\ne0\).
Therefore the lower bound

\[
\boxed{\dim_KQ_n\geq(2n-1)!!+1}
\]

holds independently of the factorial recursion.

If both principal recursions were proved, multiplication would give a
surjection

\[
(Q_ne)\otimes_K(eQ_n)\twoheadrightarrow J_n
\]

and hence

\[
\dim_KJ_n\leq(n!/3)^2,\qquad
\dim_KQ_n\leq(2n-1)!!+(n!/3)^2.
\]

The premise is still open already at the full rank-five membership (8).
Accordingly, this mission does not prove universal finite-dimensionality,
the factorial upper bound, or a counterexample.  Its strict advance over the
previous state is the exact characteristic-zero rank-eight theorem on both
principal sides, the 64-dimensional tensor multiplication isomorphism, and
the isolation of the first full-\(Q_5\) transition that a uniform proof must
settle.

## Exact replay

From the campaign root:

```text
/usr/bin/python3 \
  research/principal_ideal_factorial_recursion/verify_base_and_candidate_transversals.py \
  --jacobian-output \
  research/principal_ideal_factorial_recursion/jacobian/output-q4-left-principal-minor.json

/usr/bin/python3 \
  research/principal_ideal_factorial_recursion/verify_first_schreier_transition.py

/usr/bin/python3 \
  research/principal_ideal_factorial_recursion/sample_first_transition_fibers.py
```

The inspected Jacobian operation is
`matrix.symbolic.rank.compute`, protocol `2025-11-25`, server version
`0.14.0`.  On the typed \(8\times8\) \(Q_4e\) minor it returned rank eight
with pivot columns \(0,\ldots,7\) in 23150 ms.  The exact request and typed
output are preserved under `jacobian/`; this checks only that minor, not the
noncommutative recursion.
