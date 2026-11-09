# Universal rigidity on the determinant ring

## Scope and source facts

The question is exactly Proposition `prop:rigidity` in the unchanged staged
`build/sections/06-rigidity.tex`:

> There is no nonzero locally nilpotent \(\mathbb C\)-derivation \(E\) of
> \(B=\mathbb C[a,d,b,c,u]/(ac-bd-1)\) with a fixed fiber shift \(e\leq0\)
> and \(E^2(a^3b-a^2u^3-d^2)=0\).

The ordered generator weights are \((1,1,-1,-1,0)\). This question does not
assert that the manuscript's stabilization, lifting, extraction, or full
cancellation theorem is correct. Those dependencies remain separate open nodes
of `research/PROOF_GRAPH.json`. The source uses \(\mathbb k=\mathbb C\).

The following primary-source propositions were read before implementation:

* Seewoo Lee, *Formalizing Mason--Stothers Theorem and its Corollaries in Lean 4*,
  [arXiv:2408.15180v2](https://arxiv.org/html/2408.15180v2), Theorem 1.1:
  for nonzero pairwise coprime polynomials \(x+y+z=0\) over any field,
  either all three formal derivatives vanish or
  \(\max(\deg x,\deg y,\deg z)<\deg\operatorname{rad}(xyz)\).
  In characteristic zero the derivative alternative means constants.
  This statement neither requires nor authorizes replacing the coefficient
  field by its algebraic closure. The manuscript also gives a Wronskian proof.
* Michel Brion, *On linearization of line bundles*,
  [arXiv:1312.6267v3](https://arxiv.org/html/1312.6267v3), Lemma 2.9:
  on a reduced \(G\)-scheme, a line bundle is \(G\)-linearizable exactly when
  its action and projection pullbacks to \(G\times X\) are isomorphic.
* In the same version, Proposition 2.10 gives, for a reduced \(G\)-scheme,
  the equivariant Units--Picard exact sequence; in particular
  \(\operatorname{Pic}^G(X)\to\operatorname{Pic}(X)\to
  \operatorname{Pic}(G\times X)/p_2^*\operatorname{Pic}(X)\) is exact.
* In the same version, Theorem 2.14 requires a **normal** \(G\)-scheme and
  a connected linear algebraic group. It linearizes \(L^{\otimes n}\),
  with \(n\) the stable exponent of \(\operatorname{Pic}(G)\).
  For \(G=\mathbb G_a\), that exponent is one. This supplies general
  additive-action linearization under the manuscript's smooth integral
  hypotheses, not its specialized grading compatibility or extraction.

The Brion facts are upstream source dependencies, not hypotheses of the
rigidity proof. Their bibliographic attributions are recorded for the
independent Reviewer; the Engineer does not self-certify those citations.
The inherited Wiki index yielded no relevant prior rigidity result.

The positive-weight boundary must be preserved: the derivation
\(E_0(a)=E_0(d)=E_0(u)=0,\ E_0(b)=a,\ E_0(c)=d\)
has shift \(+2\), is locally nilpotent, and satisfies \(E_0^2(v)=0\).
Thus a statement omitting the weight restriction would be false; the
manuscript does not omit it.

## Result

**The literal rigidity proposition is true.** The proof below is universal,
not a search through a bounded family of derivations. The characteristic-zero
polynomial-orbit core, including derived coprimality and nonsquareness over a
rational-function field, is kernel checked in `Main.lean`. The passage from
arbitrary derivations to that core and the determinant-ring intersection are
proved below in ordinary algebra; they are not claimed to be Lean formalized.

There is a useful structural strengthening.

**Theorem (odd-power, lower-auxiliary perturbations).** Let \(k\) be any
characteristic-zero field, let \(m\geq3\) be odd, and set
\[
 B_k=k[a,d,b,c,u]/(ac-bd-1),\qquad N_m=d^2+a^2u^m.
\]
Keep fiber weights \((1,1,-1,-1,0)\), and give these generators auxiliary
degrees \((0,m,-m,0,2)\). Let \(P\in B_k\) have every auxiliary component of
degree strictly less than \(2m\), including the possibility \(P=0\).
If a fiber-homogeneous locally nilpotent \(k\)-derivation \(E\) has integer
shift \(e<2\) and satisfies \(E^2(P-N_m)=0\), then \(E=0\).

Taking \(m=3,\ P=a^3b,\ k=\mathbb C\) proves the manuscript's claim, and
also excludes shift \(+1\). The threshold \(2\) is sharp for this choice
of \(P\), by \(E_0\) above. The general odd-\(m\) theorem is a prose theorem;
the compiled source specializes the orbit theorem to \(m=3\). No literature
novelty or publishability verdict is inferred from this extension.

### 1. The original domain and coefficient field

In the UFD \(k[a,d,b,u]\), the polynomial \(ac-(bd+1)\), considered as a
polynomial in \(c\), is primitive: \(a\) and \(bd+1\) are coprime.
It is a nonconstant linear polynomial over \(k(a,d,b,u)\), hence
irreducible there. Gauss's lemma makes it irreducible, and therefore prime,
in \(k[a,d,b,u,c]\). Thus \(B_k\) is a domain.

Localizing and solving the determinant equation gives **two actual
polynomial charts**
\[
 B_k[a^{-1}]=k[a,a^{-1},d,u][b],
 \quad c=(1+bd)/a,
\]
\[
 B_k[d^{-1}]=k[a,d,d^{-1},u][c],
 \quad b=(ac-1)/d.
\]
For example these isomorphisms have inverse maps sending the displayed
indeterminates to their classes in the localization. They show that
\(a,d,b,u\) are algebraically independent, that \(a,d,u,N_m\) are
nonzero, and that
\[
 K=\operatorname{Frac}(B_k)=k(a,d,b)(u).
\]
In particular \(u\) is a transcendental variable over \(k(a,d,b)\).
There is no extension of this coefficient field in the proof.

### 2. Passing to the highest auxiliary derivation

The determinant relation has auxiliary degree zero. Decompose
\(E=\sum_j E_j\) by auxiliary shift. Each \(E_j\) is a derivation by
projecting the product rule. The set of nonzero shifts is finite because
there are only five generators and every generator image is a finite
homogeneous sum. If \(E\ne0\), choose its largest nonzero shift
\(\lambda\), and put \(\delta=E_\lambda\ne0\).

For any auxiliary-homogeneous \(r\) of degree \(i\), the component of
\(E^n(r)\) in degree \(i+n\lambda\) is \(\delta^n(r)\): a sum of \(n\)
shifts each at most \(\lambda\) equals \(n\lambda\) only if each shift
equals \(\lambda\). This proves local nilpotence of \(\delta\), first
on homogeneous elements and then on finite sums. No bounded-below
grading hypothesis is used. Because the two gradings commute, \(\delta\)
has the same fiber shift \(e\).

The polynomial \(N_m\) is auxiliary homogeneous of degree \(2m\).
Every component of \(E^2(P)\) has degree strictly less than
\(2m+2\lambda\). The degree-\((2m+2\lambda)\) part of
\(E^2(P-N_m)=0\) is therefore \(-\delta^2(N_m)\). Consequently
\[
 \delta^2(N_m)=0.                                      \tag{1}
\]
For the literal manuscript, the two input degrees are \(-3\) and \(6\);
this is not a comparison of fiber or valuation degrees.

### 3. A universal polynomial-orbit theorem

The following argument works over any characteristic-zero field \(K\).
Suppose \(A,D,U\in K[q]\) are nonzero, \(U(0)=u_0\), and
\[
 N=D^2+A^2U^m\ne0,\qquad \deg N\leq1,\qquad
 -u_0^m\text{ is not a square in }K,                   \tag{2}
\]
where \(m\geq3\). Then \(A,D,U\) are constant.

**Coprimality, without closing the field.**
If an irreducible polynomial \(\pi\) divided both \(D\) and \(AU\),
then \(\pi^2\) would divide \(D^2\) and \(A^2U^m\), since \(m\geq2\).
It would divide their nonzero sum \(N\), forcing
\(\deg N\geq2\deg\pi\geq2\), a contradiction. Thus \(D\) and \(AU\)
are coprime. It follows that \(X=D^2\) and \(Y=A^2U^m\) are coprime,
and hence that \(X,Y,N=X+Y\) are pairwise coprime. Neither coprimality
of \(A\) and \(U\) nor an algebraic closure is assumed.

Set \(d_A=\deg A,\ d_D=\deg D,\ d_U=\deg U,\ n=\deg N\).
The radical of \(XYN\) has degree at most
\[
 d_D+d_A+d_U+n,                                       \tag{3}
\]
because powers do not change the radical, and
\(\operatorname{rad}(A^2U^m)\) divides the product of the radicals
of \(A\) and \(U\).

If Mason--Stothers gives its derivative-zero alternative, characteristic
zero makes \(X,Y,N\) constant. Their nonvanishing gives
\(2d_D=0,\ 2d_A+md_U=0\), so all three input degrees are zero.
Otherwise its two degree bounds, (3), and \(n\leq1\) give
\[
 2d_D\leq d_D+d_A+d_U,\qquad
 2d_A+md_U\leq d_D+d_A+d_U.
\]
Thus
\[
 d_A+(m-1)d_U\leq d_D\leq d_A+d_U.
\]
Since \(m\geq3\) and all degrees are nonnegative, \(d_U=0\) and
\(d_D=d_A\). Therefore \(U=u_0\).

Write \(\alpha,\eta\ne0\) for the leading coefficients of \(A,D\).
Their squared summands have equal degree. Their leading coefficients
cannot cancel: cancellation would give
\[
 (\eta/\alpha)^2=-u_0^m
\]
**in \(K\)**, contradicting (2). Their sum has degree \(2d_D\leq1\),
so \(d_D=d_A=0\). This completes the universal orbit proof.

For \(m=3\), every part of this argument, including the coprimality
derivation and invocation of the actual Mathlib theorem `Polynomial.abc`,
is formalized by `Rigidity047.orbit_polynomials_constant`.

### 4. Applying the theorem in the original field

Apply the polynomial-orbit theorem to
\[
 A(q)=\exp(q\delta)(a),\quad D(q)=\exp(q\delta)(d),\quad
 U(q)=\exp(q\delta)(u)\quad\text{in }B_k[q]\subset K[q].
\]
The exponential sums are finite by local nilpotence, and the iterated
Leibniz rule proves multiplicativity in characteristic zero.
The three polynomials are nonzero by their values \(a,d,u\) at zero.
Equation (1) gives
\[
 D(q)^2+A(q)^2U(q)^m=N_m+q\delta(N_m),
\]
a nonzero polynomial of degree at most one.

Let \(F=k(a,d,b)\), so \(K=F(u)\). If \(r^2=-u^m\) in \(K\),
write \(r=f(u)/g(u)\) with \(f,g\in F[u]\) nonzero. Taking degrees
in \(f^2=-u^m g^2\) gives
\[
 2\deg f=m+2\deg g,
\]
which is impossible for odd \(m\). No numerator-denominator
coprimality is even needed here. The equivalent integer-degree
argument for \(m=3\) is formalized by
`Rigidity047.ratFunc_neg_X_cube_not_square`. Its corollary
`Rigidity047.ratFunc_orbit_polynomials_constant` has no supplied
nonsquareness hypothesis.

The orbit theorem now gives \(A=a,\ D=d,\ U=u\). Comparing
coefficients of \(q\) proves
\[
 \delta(a)=\delta(d)=\delta(u)=0.                       \tag{4}
\]

### 5. The determinant-ring coefficient intersection

This is a global step, not a conclusion drawn from a single chart.
Differentiate \(ac-bd=1\) and use (4). Set
\[
 x=\delta(b),\quad y=\delta(c),\quad h=cx-by\in B_k.
\]
Then \(ay=dx\), and the following two polynomial identities hold:
\[
 ah-x=x(ac-bd-1)-b(ay-dx),\qquad
 dh-y=y(ac-bd-1)-c(ay-dx).
\]
Consequently
\[
 \delta(b)=ah,\qquad \delta(c)=dh.                     \tag{5}
\]
These identities do not divide by \(a\) or \(d\).
They are kernel checked by `Rigidity047.determinant_coefficients`
and independently replayed as exact ideal identities.

Put \(C_0=k[a,d,u]\), \(Q=k(a,d,u)\), and
\(S=C_0\setminus\{0\}\). By (4), every denominator in \(S\) is
\(\delta\)-invariant. Hence \(\delta\) extends to a **locally
nilpotent** \(Q\)-derivation of \(S^{-1}B_k=Q[b]\):
\(\delta^n(r/s)=\delta^n(r)/s\).

A locally nilpotent \(Q\)-derivation of \(Q[b]\) sends \(b\) to \(Q\).
Indeed, write it as \(T(b)\,d/db\). If \(T\ne0\) has degree \(t\geq1\)
and leading coefficient \(\gamma\), induction gives degree
\(1+n(t-1)\) and leading coefficient
\[
 \gamma^n\prod_{j=0}^{n-1}(1+j(t-1))
\]
for its \(n\)-th iterate on \(b\). No factor vanishes in
characteristic zero. This contradicts local nilpotence; thus \(T\)
has degree zero, or is zero.

It follows from (5) that \(h\in Q\). Because \(h\in B_k\), comparison
of coefficients of the transcendental variable \(b\) in the \(a\)-chart
gives \(h\in C_0[a^{-1}]\). Comparison of coefficients of the
transcendental variable \(c\) in the \(d\)-chart gives
\(h\in C_0[d^{-1}]\). Finally
\[
 C_0[a^{-1}]\cap C_0[d^{-1}]=C_0                       \tag{6}
\]
inside \(Q\): write any element in reduced numerator-denominator
form in the UFD \(C_0\). Its denominator must divide a power of
\(a\) and a power of \(d\). These distinct polynomial variables
are coprime, so that denominator is a unit. The reverse inclusion
is immediate. This proves the full, universal intersection
\[
 B_k\cap k(a,d,u)=k[a,d,u],\qquad h\in C_0.             \tag{7}
\]
It is not a finite Gröbner computation or an assumed Hartogs statement.
The script checks the exact chart and determinant identities; the
coefficient-comparison and UFD proof of (6)--(7) are mathematical prose.

### 6. The weight contradiction

Both terms of \(h=c\delta(b)-b\delta(c)\) have fiber weight \(e-2\).
Every monomial of \(C_0\) has nonnegative weight, because \(a,d,u\)
have weights \(1,1,0\). If \(e<2\), (7) therefore implies \(h=0\).
Equations (4)--(5) make \(\delta\) zero on all five generators,
contradicting its construction as a nonzero highest component.
This proves the theorem, and hence the literal proposition.

## Adversarial boundary certificates

The exact replay contains three deliberately distinguished boundaries:

1. The global shear \(E_0\) has shift \(+2\), preserves the determinant,
   is locally nilpotent, and sends \(v\) to \(a^4\) and then to zero.
   It is **not** a counterexample to the manuscript.
2. On the \(a\)-chart alone,
   \(a^{-2}(a\partial_b+d\partial_c)\) has shift zero and square zero
   on \(v\). It does not preserve \(B_k\): it sends \(b\) to \(a^{-1}\).
   The element \(a\) is not a unit globally, as shown by the point
   \((a,d,b,c,u)=(0,1,-1,0,0)\). This explains why (7), not merely
   passage to \(Q[b]\), is essential.
3. If one adjoins a forbidden square root \(s\) with \(s^2=-u^3\),
   the polynomials \(A=a+q,\ D=d+sq,\ U=u\) have
   \[
   D^2+A^2U^3=N_3+2q(ds+au^3)
   \]
   but \(A,D\) are nonconstant. This is an exact example over an
   **enlarged** coefficient field, not over the original \(K\).
   The script checks the identity modulo \(s^2+u^3\).

These are hypothesis-boundary demonstrations, not false assertions found in
the manuscript. No `F_<LABEL>` refutation is manufactured from them.
No false manuscript assertion was identified within this mission's scope.

## What is machine checked

| Manuscript step | Evidence and extent |
|---|---|
| `rig:auxiliary-grading`, `rig:linear-orbit` | Exact generator/relation degrees in `verify.py`; universal highest-component proof in Section 2 |
| Coprimality before `rig:degree-bound` | Universal Lean theorem `low_degree_coprime`, not a supplied hypothesis |
| `rig:abc`, `rig:degree-bound` | Actual proved `Polynomial.abc` and radical bounds in `orbit_polynomials_constant` |
| `rig:original-field` and nonsquare step | Two-chart/domain proof in Section 1; universal `ratFunc_neg_X_cube_not_square` and its orbit corollary |
| `rig:h-formulas` | Universal Lean `determinant_coefficients`, exact polynomial syzygies, and replayed Jacobian basis |
| Coefficient intersection after `rig:h-formulas` | Universal two-chart/UFD proof in Section 5; script verifies chart identities, not arbitrary-denominator quantifiers |
| `rig:one-variable` | Full characteristic-zero induction in Section 5 |
| Final fiber-weight exclusion | Universal argument in Section 6, with exact weight bookkeeping and sharp \(+2\) example |

`Main.lean` and its separate, unchanged `statement_fidelity.md` have a real
Lean **4.31.0** compiler and axiom-audit run, both exit zero, with
`proof_holes=[]`. The official result is `lean_check.json`, and the
claim-bound archive is
`certificates/C_RIGIDITY047-0d83b4a504326607.json`.
The explicit ledger assumption `A_PROSE_BRIDGE047` records the parts not
formalized; the result is not described as a full kernel proof of all LND
and localization arguments.

The Jacobian adapter was discovered and its exact typed contract inspected
before the single bounded operation
`polynomial.ideal.groebner_basis.compute`. Its payload and full typed result
are in `jacobian_payload.json` and `jacobian_output.json`; the separate
adapter-status record distinguishes transport/exit status from the
mathematical outcome. Server version is `0.14.0`, protocol `2025-11-25`,
adapter exit is zero, and outcome is `COMPUTED`. Its three-generator basis
is replayed with exact rational arithmetic. It certifies determinant ideal
identities only, not the infinite-dimensional derivation theorem.

## Replay and remaining review

From the campaign root:

```bash
$WORKSPACE/argus-live-update/.venv/bin/python research/rigidity/verify.py
```

By default this obtains a fresh official Lean run bound to `C_RIGIDITY047`,
runs both campaign-local structural checks, and replays all exact algebra
against `exact_certificate.json`. The `--reuse-lean` option instead verifies
the source/fidelity bindings of the existing successful compiler certificate;
it explicitly reports that no new compilation was performed. It is useful
when the compiler has just run and the mathematical inputs have not changed.
`--write-certificate` writes the deterministic certificate only after all
requested checks succeed.

Relative to the previously uncertified cubic/nonpositive-shift source proof,
this result supplies a universal kernel-checked orbit theorem, derives rather
than assumes its coprimality, preserves the original rational-function field,
and proves the global determinant intersection explicitly. It also extends
the prose theorem to shifts below \(2\), all odd \(m\geq3\), and arbitrary
lower-auxiliary perturbations \(P\). This is not a bounded exclusion and does
not verify the rest of the cancellation theorem.

Independent Host-invoked review remains required for statement fidelity,
the complete prose bridge, the external source attributions recorded in the
ledger, and any novelty/significance classification. The Engineer does not
file those independent approvals.
