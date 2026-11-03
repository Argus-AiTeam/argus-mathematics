# Chen criterion audit for the Hashimoto--Murabayashi discriminant-6 point

## Result

Neither Chen, arXiv:2511.07814v1, Theorem 1.1 nor any of the three
alternatives in Theorem 1.2 applies to the Hashimoto--Murabayashi Example
1.6 curve at

\[
  (t,s)=\left(\frac14,\frac{\sqrt{11}}2\right).
\]

The decisive arithmetic is

\[
 j_6=-\frac{2025}{1024},\qquad
 v_2(j_6)=-10,\qquad v_3(j_6)=4.
\]

Theorem 1.1 fails because potentially smooth stable reduction is equivalent
to zero \(j_6\)-valuation, and the valuations at both 2 and 3 are nonzero.
Theorem 1.2 fails case-by-case below. Consequently Chen's paper supplies no
conclusion about the supersingular or superspecial primes of this Jacobian.
In particular, this audit does **not** refute the candidate and does not
change `C_TARGET`.

## 1. Exact curve and arithmetic coordinate

Hashimoto--Murabayashi Example 1.6 gives

\[
C:\quad y^2=x\left(
x^4+\left(\sqrt{11}+\frac12\right)x^3+\frac{99}{20}x^2
+\left(\sqrt{11}-\frac12\right)x+1\right)
\]

over the explicit definition field
\(K_0=\mathbf Q(\sqrt{11})\). Baba--Granath Theorem 3.4 restates the
parameter family as

\[
\begin{aligned}
y^2&=x(x^4-Px^3+Qx^2-Rx+1),\\
4s^2t^2-s^2+t^2+2&=0,\\
P&=-2(s+t),\qquad R=-2(s-t),\\
Q&=\frac{(1+2t^2)(11-28t^2+8t^4)}
        {3(1-t^2)(1-4t^2)}.
\end{aligned}
\]

Here \(s^2=11/4\), and exact substitution gives

\[
4\frac{11}{4}\frac1{16}-\frac{11}{4}+\frac1{16}+2=0,
\quad
P=-\sqrt{11}-\frac12,\quad
Q=\frac{99}{20},\quad
R=-\sqrt{11}+\frac12.
\]

Baba--Granath's Remark after Proposition 3.6 gives the arithmetic Shimura
coordinate

\[
j_6=
\frac{16(2t^2+1)^4(t^2-1)^2}{27(4t^2-1)^3}.
\]

It is the genus-two discriminant-6 Shimura coordinate

\[
j_6=\frac{12^{10}J_{10}^2}{(J_2^2-24J_4)^5},
\]

not a classical elliptic \(j\)-invariant. At \(t=1/4\),

\[
\begin{aligned}
j_6
&=\frac{16(9/8)^4(15/16)^2}{27(-3/4)^3}\\
&=-\frac{2025}{1024}
 =-\frac{3^4 5^2}{2^{10}}.
\end{aligned}
\]

The exact computation is rerunnable with
`research/evidence/chen-qm-candidate/008-compute-exact.command.sh`.

## 2. Fields attached to this point

Baba--Granath Proposition 3.16 states
\(k_Z=\mathbf Q[j(C)]\). Since \(j_6\) is rational, the exact field of
moduli of the curve is

\[
 k_Z=\mathbf Q.
\]

This does not identify the field of moduli with a field of definition.
The displayed Hashimoto--Murabayashi equation is defined over
\(\mathbf Q(\sqrt{11})\). Also,
\(j_6\notin\{-16/27,81/64\}\), so Proposition 3.12 gives trivial
automorphism group and Theorem 3.14 supplies another model over

\[
\mathbf Q(\sqrt{-6j_6})
=\mathbf Q\left(\sqrt{6(45/32)^2}\right)
=\mathbf Q(\sqrt6).
\]

No minimality, and no model over \(\mathbf Q\), is asserted here.

Theorem 3.17 gives the field of moduli of the full
\(\mathcal O_6\)-action:

\[
\begin{aligned}
k_{\mathcal O}
&=\mathbf Q\left(\sqrt{j_6},
                 \sqrt{-(27j_6+16)}\right),\\
\sqrt{j_6}&=\frac{45}{32}\sqrt{-1},\\
\sqrt{-(27j_6+16)}&=\frac{59}{32}\sqrt{11},\\
k_{\mathcal O}&=\mathbf Q(i,\sqrt{11}).
\end{aligned}
\]

This is an action-moduli field, not by definition an endomorphism-definition
field. Applying Proposition 3.18 to the displayed model over \(K_0\) does
give the explicit field

\[
 K_0 k_{\mathcal O}=\mathbf Q(i,\sqrt{11})
\]

over which all \(\mathcal O_6\)-endomorphisms are defined.

## 3. Chen Theorem 1.1

Chen's Theorem 1.1 assumes potentially smooth stable reduction at every
prime above 2 and 3. Baba--Granath, *Primes of Superspecial Reduction for
QM Abelian Surfaces*, Proposition 2 proves, for this \(E_6^0\) family,

\[
C\text{ has potentially smooth stable reduction at }\mathfrak p
\quad\Longleftrightarrow\quad
v_{\mathfrak p}(j_6)=0.
\]

Over the field of moduli \(\mathbf Q\), the unique valuations are

\[
v_2(j_6)=-10,\qquad v_3(j_6)=4.
\]

The actual displayed curve is over \(K_0=\mathbf Q(\sqrt{11})\), where
\(\mathcal O_{K_0}=\mathbf Z[\sqrt{11}]\) and
\(\operatorname{disc}(K_0)=44\). There is one ramified prime over 2 and
one inert prime over 3. With normalized discrete valuations,

\[
v_{\mathfrak p_2}(j_6)=2v_2(j_6)=-20,\qquad
v_{\mathfrak p_3}(j_6)=v_3(j_6)=4.
\]

Both are nonzero. Proposition 2 therefore says that the stable reduction
is a pair of elliptic curves meeting transversally at both places, rather
than a smooth curve: the component elliptic \(j\)-invariants are 1728
above 2 and 0 above 3. Base extension multiplies these nonzero valuations
by ramification indices, so it cannot turn either valuation into zero.
Thus Theorem 1.1 does not apply.

## 4. Chen Theorem 1.2

For Chen's field of moduli \(L=\mathbf Q\),

\[
\operatorname{Nm}_{L/\mathbf Q}(j_6)
=-\frac{2025}{1024}=\frac nd,
\quad n=-2025,\quad d=1024,\quad (n,d,6)=1.
\]

Moreover,

\[
\begin{aligned}
27j_6+16
  &=-\frac{38291}{1024}
   =-\frac{11\cdot59^2}{2^{10}},\\
d\,\operatorname{Nm}_{L/\mathbf Q}(27j_6+16)
  &=-38291,\\
[L:\mathbf Q]+v_3\!\left(
d\,\operatorname{Nm}_{L/\mathbf Q}(27j_6+16)\right)
  &=1+0=1,
\end{aligned}
\]

so the parity expression is odd. The only real conjugate is

\[
j_6=-\frac{2025}{1024}<-\frac{16}{27}.
\]

Each alternative nevertheless fails as a conjunction:

| Chen case | Conditions that hold | Exact failed condition(s) |
|---|---|---|
| (1) | The parity expression is odd; \(v_2(j_6)\leq0\). | \(v_3(j_6)=4\not\leq0\); also \(j_6\notin(-16/27,0)\). |
| (2) | None of its three extra conditions. | \(v_2(j_6)=-10\not\geq0\), \(v_3(j_6)=4\not\leq0\), and \(j_6<0\). |
| (3) | \(v_3(j_6)\geq0\) and \(j_6\in(-\infty,-16/27)\). | \([L:\mathbf Q]=1\) is odd and \(v_2(j_6)=-10\not\geq0\). |

Hence no case of Theorem 1.2 applies.

## 5. Jacobian adapter evidence

The Argus sidecar discovered the bounded exact operation
`algebraic_number.multiply.compute`, and its typed contract was inspected
before execution. The exact payload multiplies
\((\sqrt{11}/2)(\sqrt{11}/2)\). Jacobian 0.14.0, protocol
`2025-11-25`, over `mcp-stdio`, returned

\[
\frac{11}{4}+0\sqrt{11}
\]

in 1 ms. The adapter command exited 0 with empty stderr and no structured
error or timeout. The discovery, inspected schema, exact payload, typed
output, protocol, and server version are preserved under
`research/evidence/chen-qm-candidate/`.

## 6. Exact boundary

Chen's sufficient hypotheses fail. That is a theorem-applicability result,
not a theorem about this Jacobian's reduction set. No infinite
superspecial-prime sequence has been obtained, and no claim is made that
such primes are finite or infinite. The proposition that the actual
Hashimoto--Murabayashi Jacobian has infinitely many good superspecial
places over an explicit definition field therefore remains unresolved.
