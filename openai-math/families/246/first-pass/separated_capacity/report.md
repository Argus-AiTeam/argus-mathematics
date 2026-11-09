# Uniform separated capacity: a quantitative verification

## Result and scope

This is a proof of the separated-capacity hinge, conditional on its actual
upstream scalar and geometric hypotheses, not a counterexample and not a proof
of Cannon's conjecture. The conclusion is stronger than the manuscript's
unit-capacity assertion: the maximum separated capacity tends to infinity
uniformly over **all** nodes and all positive lengths of their value intervals.
No false manuscript assertion was identified in this hinge.

The precise strengthening is the following. All constants, the scalar
function, the modulus sequence, and the maximum permitted parent scale are
fixed first. Write \(r=a^{-D}R\), \(s=a^{-d}R\), and
\[
 {\cal C}_{D}(x,R,J)=
 \max_{\substack{Y'\subset Y\\d(y,y')>Hr}}
 \sum_{y\in Y'}\min\{a^{-\gamma D}t_y,a^{\tau D}t_y^2\}.
\]
There are \(c>0\) and fixed lower bounds on \(d\) and \(D-d\), independent of
\(x,R,J,D,d\), such that
\[
 \boxed{\quad {\cal C}_{D}(x,R,J)\ \ge\
 c\min\left\{a^{d-\gamma D},
       \frac{a^{\tau D-(Q-2)d}}{M(D-d)}\right\}.\quad}                 \tag{1}
\]
This estimate does not require subexponential growth. With the manuscript's
\(\tau=1/20\), \(\beta=\tau/[4(Q+1)]\), \(\gamma=\beta/2\),
\(d=\lceil\beta D\rceil\), and its subexponential hypothesis, it implies
\[
 {\cal C}_{D}(x,R,J)\ge c' a^{\gamma D}\qquad(D\ge D_1),             \tag{2}
\]
with \(c',D_1\) independent of the node and \(|J|>0\).
In particular one sufficiently large \(D\) works throughout the tree.

The useful improvement over the supplied proof is a quantitative estimate
valid before assuming failed capacity, a finite weighted-cover theorem for
arbitrary real inputs, and an explicit accounting of every uniform constant.
Novelty and publishable significance remain questions for independent review;
neither a bounded search nor the present literature lookup establishes novelty.

## Exact premises and source dependence

The local source is the staged manuscript dated September 23, 2026:

* `01_geometry.tex`: Lemmas `expansion`, `packing`, `paths`, and the definition
  `macro-modulus`. Assume their uniform constants \(c_E,C_E,C_P,Q,L\), \(Q\ge2\),
  and that scale-\(s\) expansions exist. Use maximal separated target nets
  and the macroscopic path family defining \(M(n)>0\).
* `02_scalar.tex`: the level-continuum part of Proposition `scalar-limit`.
  Assume \(u\) continuous on \(U\), and, for every \(0<t<1\), a continuum
  \(C_t\) of diameter at least \(d_1\), meeting every compact straddling path
  in \(U\), with \(u=t\) on \(C_t\cap U\).
* `04_flow.tex`: the fixed geometry \(c_0,A,B_0=A+10,H,K,K^+\), the definition
  `node-straddling`, the candidate annulus and maximal \(r\)-net \(Y\), and,
  only for (2), equation `subexponential-growth`.

These are assumptions, not upstream theorems certified by this report.
In particular the measure \(\mu\), its oscillation bound, the approximants
\(H_N\), and the fixed-transform energy estimates are **not used** in (1).
The scalar level identity is never asserted outside \(U\). Non-local-constancy
is needed to obtain a root, not in the proof for an already admissible node.

The source margins can be fixed independently of \(D\): all points used below
are within \((B_0+2)R\), or a fixed source enlargement, of the parent center.
Choose the maximum parent scale so these sets lie in \(K^+\subset U\), all
packing estimates apply, and \((B_0+2)R<d_1/2\). Choose \(d,D-d\) large enough
that \(s<R/4\), \(r<s\), and all fixed multiples of the relative mesh
\(q=r/s\) are in the small-scale range. None of these choices mentions \(J\).

The Wiki index contained no task-specific capacity result. Primary-source
retrieval of Bourdon--Kleiner, *Combinatorial modulus, the Combinatorial Loewner
Property, and Coxeter groups*, arXiv:1002.1991, Sections 2.1 and 3.2
(`https://ar5iv.labs.arxiv.org/html/1002.1991`), confirmed the surrounding
uniformization criterion in Corollary 3.5. That criterion is not an input to
this proof. Lemma 2.3 there concerns an extremal weight on a cell, not the
separated-capacity theorem sought here. The retrieved passages supply no
novelty determination for (1). No external theorem is needed for the finite
argument below beyond real arithmetic and finite Cauchy--Schwarz, proved by
the sum-of-squares identity also checked in the accompanying evidence.

A route fixing \(J\) and then taking a depth from an absolute continuity or
oscillation tolerance was retired: it reverses the required quantifiers.
The proof below normalizes the entire interval before taking any threshold.

## The finite weighted-cover theorem

Let \(J=(j_-,j_+)\), \(\Delta=j_+-j_->0\). There are finitely many closed
range intervals \(I_y\), finitely many bins \({\cal B}\) of cardinality \(N\),
and incidences \(B_y\subset{\cal B}\), with \(\#B_y\le m\), \(m>0\).
Set \(t_y=|J\cap I_y|/\Delta\).
Let \(\lambda,\Lambda,E>0\), \(\sigma_y\ge0\), and
\(\sum_y\sigma_y^2\le E\). Declare \(y\) large exactly when
\(t_y\ge\lambda/\Lambda\).
Assume that for every unmarked \((b,t)\in{\cal B}\times J\),
\[
 \sum_{\substack{y\ {\rm small}\\b\in B_y}}
       \sigma_y{\bf1}_{I_y}(t)\ge1,                               \tag{3}
\]
where marked means belonging to some large incident range.
Then
\[
 S:=\sum_y\min\{\lambda t_y,\Lambda t_y^2\}
 \ \ge\ \min\left\{\frac{\lambda N}{2m},
                    \frac{\Lambda N^2}{4m^2E}\right\}.             \tag{4}
\]

Here is an exact finite reduction of the apparently analytic assumption.
Cut \(J\) at all interval endpoints lying strictly inside it. Each resulting
open atom \(A_\alpha\) has weight
\(\ell_\alpha=|A_\alpha|/\Delta>0\), with \(\sum_\alpha\ell_\alpha=1\).
On each atom all closed-interval indicators are constant; define
\(e_{\alpha y}\in\{0,1\}\) to be that constant and
\(d_{by}={\bf1}_{B_y}(b)\). Thus \(t_y=\sum_\alpha\ell_\alpha e_{\alpha y}\).
The finitely many cut points have zero length; singleton ranges cause no
problem. Marked rows contribute at least one from a large candidate, and
unmarked rows satisfy (3). Therefore, for every \(b,\alpha\),
\[
 1\le\sum_y d_{by}e_{\alpha y}
             \begin{cases}1&y\ {\rm large},\\\sigma_y&y\ {\rm small}.
             \end{cases}                                       \tag{5}
\]
There is no selection or measurability premise about \(C_t\) in (5).

Multiply (5) by \(\ell_\alpha\), sum, and use
\(\sum_b d_{by}\le m\). With
\(L=\sum_{\rm large}t_y\), \(T=\sum_{\rm small}\sigma_y t_y\),
\(V=\sum_{\rm small}t_y^2\), obtain
\[
 N\le m(L+T),\qquad T^2\le EV,\qquad
 \lambda L\le S,\quad\Lambda V\le S.                              \tag{6}
\]
The last two inequalities use the actual branches of the minimum:
on large candidates the minimum is linear, on small ones quadratic.
If \(S<\lambda N/(2m)\), then \(mL<N/2\), so \(mT>N/2\).
Consequently \(S\ge\Lambda V>\Lambda N^2/(4m^2E)\).
This proves (4), including equality cases by contradiction.

If a proper \(\chi\)-coloring partitions candidates into separated classes,
some class has capacity at least \(S/\chi\). This is finite pigeonholing,
not an assumption that all candidates are separated.

`Main.lean` proves the universal weighted-row implication, (4) with real
coefficients and arbitrary finite index types, its hybrid-minimum
specialization, and the color-class conclusion. Thus the finite theorem is
not inferred from a few tested arrays. `verify.py` additionally reconstructs
atoms and detectors from rational interval/transfer fixtures, checks all
their hypotheses, and rejects deliberately broken fixtures. Those fixtures
are tests of the exact reduction, not counterexamples or metric spheres.

## Construction of the actual finite data

### Radial persistence and bin multiplicity

For each \(t\in J\), node-straddling supplies two points of the closed
\(c_0R\)-ball with \(u\)-values strictly on opposite sides of \(t\).
The controlled-path premise joins them in \(B(x,Lc_0R)\subset U\), so the
scalar straddling premise puts a point of \(C_t\) there. The diameter
condition prevents \(C_t\) from being contained in
\(\overline B(x,(B_0+2)R)\): that ball has diameter less than \(d_1\).
Since \(Lc_0<A\), continuity of distance on the connected set \(C_t\)
shows that it meets every sphere used below.

Take the explicitly \(s\)-spaced bins
\[
 b_j=(A+1)R+js,\qquad
 0\le j\le\lfloor8R/s\rfloor .
\]
They lie in \([(A+1)R,(B_0-1)R]\), and
\(N=\lfloor8a^d\rfloor+1\ge8a^d\).
Let \(b\in B_y\) exactly when \(|d(x,y)-b|\le5s\).
An interval of length \(10s\) contains at most eleven \(s\)-spaced bins;
thus \(m=11\), including boundary equality.

### Transfer of the admissible weights

Take a maximal \(s\)-separated set \({\cal Z}_s\) in the same annulus.
It covers the annulus and satisfies \(\#{\cal Z}_s\le C_Za^{Qd}\).
For \(n=D-d\), \(q=a^{-n}\), take a minimizing macroscopic admissible
target weight \(\omega\) of squared mass \(M(n)\). Its existence follows
from the finite target-cell incidence definition of modulus; it does not
depend on \(J\).

For a fixed \(C_T>2+C_E\), use exactly the manuscript's transfer:
\[
 \sigma_y^z={\bf1}_{d(y,z)\le3s}
       \sum_{\xi:\ d(\xi,h_zy)\le C_Tq}\omega_\xi,
 \qquad \sigma_y=\sum_z\sigma_y^z.                                \tag{7}
\]
All these weights are independent of \(b,t\), and of which paths will detect
them. Three fixed packing bounds suffice:

1. A target \(q\)-net has at most \(K_T\) centers within \(C_Tq\) of a point.
2. The images of distinct \(y\in Y\cap\overline B(z,3s)\) are
   \((c_E/9)q\)-separated, by the lower expansion inequality.
   Hence a target center is charged by at most \(K_Y\) candidates for fixed \(z\).
3. Each \(y\) belongs to at most \(K_Z\) balls \(\overline B(z,3s)\), since
   the \(z\)'s are \(s\)-separated.

Finite Cauchy--Schwarz, applied first inside each transfer sum and then across
the auxiliary centers, gives
\[
 \sum_y(\sigma_y^z)^2\le K_TK_Y M(n),\qquad
 \sum_y\sigma_y^2\le
 K_ZK_TK_Y C_Z a^{Qd}M(n)=:E.                                    \tag{8}
\]
In particular every factor is uniform in parent scale, center, and interval.
The verifier checks this exact row/column/overlap transfer inequality on its
serialized transfer data, rather than accepting a declared energy.

### Why every unmarked row is detected

Fix an unmarked \((b,t)\). Radial persistence gives \(w\in C_t\) with
\(d(x,w)=b\), and the \(s\)-net gives \(z\in{\cal Z}_s\) with \(d(w,z)\le s\).
The diameter bound gives a point of \(C_t\) outside \(\overline B(w,2s)\).
Join it to \(w\) in the open \(r/4\)-neighborhood of \(C_t\), using the
controlled-path premise. Stop at the first sphere of radius \(s\) about \(w\).
The stopped path \(\pi\) is contained in \(\overline B(w,s)\subset
\overline B(z,2s)\) and has diameter at least \(s\).
Its expansion is macroscopic by the fixed choice of \(d_0\).

Every \(v\in\pi\) lies in the candidate annulus, because \(s<R/4\) and
the bins have a full \(R\)-margin. Choose \(y\in Y\) with \(d(v,y)\le r\).
Then \(d(y,z)\le r+2s<3s\), and \(|d(x,y)-b|\le s+r<5s\).
For every target cell meeting \(h_z\pi\) at \(h_zv\), its center \(\xi\)
satisfies
\[
 d(\xi,h_zy)<(2+C_E)q<C_Tq.
\]
Here the upper expansion inequality uses denominators at least \(s\).
Its weight therefore occurs in \(\sigma_y^z\).

There is \(w'\in C_t\) with \(d(v,w')<r/4\). The source margin places
\(w'\) in \(K^+\subset U\), so the scalar premise really gives \(u(w')=t\).
Also \(d(y,w')<5r/4<c_0r\), so \(t\in I_y^{\rm out}\), without any
connected-ball assumption. Since \(b\in B_y\) and the pair is unmarked,
this candidate is small. Summing over all hit target cells, with the
nonnegative transfer sums counting every cell at least once, proves (3)
from macroscopic admissibility. Different cells may use the same \(y\);
this is permitted because that candidate's transfer contains their sum.

Thus (3) and (8) hold for the actual ranges of every admissible node.
Applying the finite theorem with \(\lambda=a^{-\gamma D}\),
\(\Lambda=a^{\tau D}\), and \(N\ge8a^d\) gives
\[
 S\ge\min\left\{\frac4{11}a^{d-\gamma D},
 \frac{16}{121C_ZK_ZK_TK_Y}
       \frac{a^{\tau D-(Q-2)d}}{M(D-d)}\right\}.                   \tag{9}
\]
Packing bounds the degree of the candidate graph with edges at distance
at most \(Hr\), so a fixed integer \(\chi\) colors it. Divide (9) by
\(\chi\) to obtain (1). No candidate-count or path-selection constant
depends on the node's interval.

## Uniform threshold and a growth-sensitive extension

Under \(\limsup M(j)^{1/j}\le1\), for each \(\varepsilon>0\) one has
\(M(j)\le a^{\varepsilon j}\) for all sufficiently large \(j\).
Take \(\varepsilon=\tau/4\); because \(D-d\le D\), eventually
\(M(D-d)\le a^{\tau D/4}\). Since \(Q\ge2\) and
\(d\le\beta D+1\), the second term in (1) is at least
\[
 a^{-(Q-2)}a^{[3\tau/4-(Q-2)\beta]D}
 \ge a^{-(Q-2)}a^{\tau D/2}.
\]
The first term is at least \(a^{(\beta-\gamma)D}=a^{\gamma D}\).
As \(\gamma<\tau/2\), (2) follows after decreasing a fixed positive
constant. Increase \(D_1\) once more so \(c'a^{\gamma D_1}\ge1\).
This \(D_1\) depends on the fixed modulus sequence and geometry, which is
allowed; it does not depend on \(x,R,J\). The order of quantifiers is
\[
 \forall\ {\rm fixed\ admissible\ data}\quad
 \exists D_1\quad \forall D\ge D_1\quad
 \forall(x,R,J)\quad \exists Y'.
\]

More generally, for any fixed \(0\le\gamma<\beta<1\), \(\tau>0\), (1)
still yields uniform diverging capacity whenever, for some \(\eta\ge0\),
\[
 M(j)\le C_M a^{\eta j}\quad(j\ {\rm large}),\qquad
 \tau-(Q-2)\beta-\eta(1-\beta)>0.                                \tag{10}
\]
The ceiling changes only a constant, including when \(\eta>Q-2\).
The growth rate supplied by the method is
\(\min\{\beta-\gamma,\tau-(Q-2)\beta-\eta(1-\beta)\}>0\).
This explicitly separates the geometric reduction from the choice of
subexponential branch.

## Evidence boundaries

`exact_certificate.json` records exact rational interval/transfer instances,
the universal symbolic identities, expected mutation failures, and provenance
of the Jacobian operation. `verify.py` is a deterministic replay, with no
network or external Python dependencies. It verifies source-level premises
of its finite fixtures, not the truth of the upstream manuscript propositions.
`Main.lean` certifies the general finite implication, not just those fixtures.
The analytic construction and statement fidelity require an independent
human/Reviewer reading; the compiler cannot certify that this report faithfully
models metric continua.

The Jacobian catalog did not expose a typed operation for topological
continua, macroscopic modulus transfer, or uniform capacity. Its exact
sum-of-squares operation is used only for the Cauchy--Schwarz algebraic
kernel. Discovery, inspected contract, exact payload, and typed output are
preserved separately. No adapter timeout or UNKNOWN is evidence for (1).

Independent Reviewer confirmation is still required. The main theorem,
scalar-limit construction, and the exponential and pair-comparison branches
remain open in the campaign proof graph.

To replay the exact reduction from the campaign root, run
`python3 research/separated_capacity/verify.py`. To obtain a new actual compiler
certificate, use:

```sh
$WORKSPACE/argus-live-update/.venv/bin/python \
  -m argus_skill.verticals.math.lean_evidence verify \
  research/separated_capacity/Main.lean \
  --statement-fidelity research/separated_capacity/statement_fidelity.md \
  --project-root . --claim SC_FINITE
```

The verifier checks both open atoms and their interior endpoints. Its transfer
fixtures include nontrivial row, column, and auxiliary-overlap multiplicities,
and mutations that violate each of these bounds are rejected.
