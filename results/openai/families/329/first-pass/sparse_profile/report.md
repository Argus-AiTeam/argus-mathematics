# Sharp sparse profiles and partition compression

## Result and scope

Write \(a_l=3^l-1\). If \(H,k\ge1\) and
\(3^{k-1}\le H<3^k\), the optimal dilation loss among all nonnegative
real profiles supported on \(0,\ldots,H-1\) is exactly \(1/k\):
\[
 \inf_{\substack{\gamma_j\ge0\\\sum_{j<H}\gamma_j=1}}
 \sup_{d\in\mathbb N\cup\{\infty\}}
 \sum_{j<H}\gamma_j
       ({\bf1}_{d\le3j+2}-{\bf1}_{d\le j})=\frac1k.
\]
The equal-mass profile on \(a_0,\ldots,a_{k-1}\) attains the infimum.
This is a universal theorem over real weights, not a conclusion inferred
from the finite checks in `verify.py`.

The associated partition compression theorem uses only these \(k\)
levels. It changes the column profile to
\[
 \psi_k(d)=\frac1k\sum_{l<k}{\bf1}_{d\le a_l},
 \qquad \psi_k(\infty)=0.
\]
It does not assert a \(k\)-level encoding for the original logarithmic
columns. In particular \(\psi_k(0)=1\), \(0\le\psi_k\le1\), and
\(\psi_k(d)=0\) for \(d>a_{k-1}\), hence for \(d>H\).

## Established sources and comparison

All five staged manuscript sections have been read. The source is
OpenAI, *Counterexamples to the duality conjecture for metric entropy*,
September 24, 2026, staged under `research/openai_manuscript/`.
No false manuscript assertion has been established.

The source propositions used for the construction consequence are:

* Section 2, `lem:matrix-to-bodies`: row separation at least one and a
  signed uniform epsilon-list of size M give
  \(N(K,L)\ge |X|\) and
  \(N(L^\circ,(6\varepsilon+2t)K^\circ)\le M\), for
  \(K=3\operatorname{absconv}\{R_x\}+tB_\infty\).
* Section 3, `prop:compression`: for logarithmic columns, positive
  error interval \([-3\theta,\theta]\) and
  \(Q\le u q^{Hs}(1+s2^u/\theta)^{Hs2^u}\).
  `cor:signed-compression` uses the square of this list and error
  \(6\theta\).
* Section 4, `prop:robust-directions` and `prop:separated-rows`: if
  \(D_j=\binom{r+j-1}{j}\), \(w=2D_H\),
  \(u=\lceil Hw/\theta\rceil\), and the prime
  \(p>\max\{H,H^2u^{2H}\}\), the partition graphs have
  \(|X|=p^{D_H}\), at most \(q=p^{D_{H-1}}\) labels each, and every
  pair of distinct rows has a graph with distance greater than H.
  The graph-distance conclusion does not depend on the logarithmic
  formula for the columns.
* Section 5, `eq:entropy-ratio`: the original leading term is
  \(2H^2s/(r+H-1)\); the remaining encoding term is absorbed by
  choosing the prime last.

The public upstream implementation was inspected at commit
`4eaee87548250b2682affda7d05d947c05554bae`, independently of the
staged-source reading. Although `lean/docs/329.md` links a comparator
with a placeholder, its challenge mapping points to a substantive proof:
`lean/OAI/Analysis/MetricEntropy/Main.lean`.
The relevant declarations are `exists_greedy_pivots`,
`exists_profile_pivots`, `uniform_compression`,
`uniform_signed_compression`, and `form_entropy_ratio_le`.
`CompressionCode.lean` uses
`Fin u x (Fin H -> Fin s -> Fin q) x
(Fin H -> Fin s -> Finset (Fin u) -> Fin N)`;
its exact cardinality is \(u q^{Hs}N^{Hs2^u}\).
`LogProfile.lean` fixes positive logarithmic increments at every radius.
Thus pivots, fixed representatives, coefficient-independent enumeration,
and rounding are source results, not claimed innovations here.
The refinement is the sharp radial optimization and decoupling encoded
levels \(k\) from algebraic degree \(H\).

A focused primary-source search did not locate this specific sparse
compression application. This is not a certification of originality.
The interval optimization has classical ancestry: the sets of distances
\([j+1,3j+2]\) are intervals. Fulkerson--Gross, *Incidence matrices
and interval graphs*, Pacific J. Math. 15 (1965), 835--855,
Section 8, pp. 853--855, proves the relevant consecutive-ones
integrality/interval packing framework. No result from that paper is
needed for the elementary proof below. Primary source:
https://msp.org/pjm/1965/15-3/pjm-v15-n3-p11-s.pdf .
The exact \(1/k\) formula is not attributed to that paper.

## Sharp minimax proof

For the upper bound, the dilation intervals at the selected radii are
\[
 (a_l,3a_l+2]=(3^l-1,3^{l+1}-1].
\]
They are pairwise disjoint, including their indicated endpoint
conventions. Every finite distance lies in at most one; infinite
distance lies in none. The loss of the equal-mass profile is therefore
at most \(1/k\), with equality at distance 1.
The support is admissible since \(a_{k-1}<H\).

For the lower bound, test the k distances \(d_l=a_{l+1}\).
For any integer radius j,
\[
 j<d_l\le3j+2 \quad\Longleftrightarrow\quad a_l\le j<a_{l+1}.
\]
These radius bands partition \(0,\ldots,a_k-1\).
Since \(H<3^k\), every \(j<H\) belongs to exactly one band.
Consequently the sum of the k tested losses equals
\(\sum_{j<H}\gamma_j=1\). At least one tested loss is at least \(1/k\).
Nonnegativity and normalization are the only restrictions on the real
weights; there is no rationality or generic-position assumption.

This also gives the exact cutoff requirement for this mechanism:
loss at most theta requires \(1/k\le\theta\).
In particular \(k\ge\lceil1/\theta\rceil\); a smaller loss cannot be
obtained merely by reweighting radii below the same H.

## Counted approximation-list theorem

Let X be any nonempty finite set. Let \(u,q,k,s\) be positive integers,
\(L_i:X\to\Sigma_i\) have at most q realized labels, and let
\(\mathcal T\) be a fixed nonempty family of subsets of \([u]\).
Assume \(0<\theta<1\), \(s\theta\ge1\),
\(|[u]\setminus T|\le\theta u\) for \(T\in\mathcal T\), and
\(1/k\le\theta\). Distances are those of the source partition graphs,
with infinite distance between components.
For \(y=(v,T)\), set \(g_y(x)=\psi_k(d_T(x,v))\).
There is a single nonempty finite list \(\mathcal A\), independent of
all coefficient vectors, such that
\[
 \sum_y\mu_y g_y(x)-3\theta\le A(x)
 \le\sum_y\mu_y g_y(x)+\theta
 \quad(x\in X)
\]
for some \(A\in\mathcal A\), whenever all \(\mu_y\) are nonnegative
real numbers and \(\sum_y\mu_y\le1\). Its cardinality Q satisfies
\[
 Q\le u q^{ks}N^{ks2^u}
 \le u q^{ks}(1+s2^u/\theta)^{ks2^u},
 \qquad N=\lfloor s2^u/\theta\rfloor+1.
\]

The same counted theorem holds for any fixed k radii and any nonnegative
real profile weights summing to one, provided their universal dilation
loss is at most theta. This general finite-profile version, the actual
finite code list, and its sparse specialization are all formalized in
`Main.lean`; no logarithmic formula is used in the compression proof.

### Proof

Fix a representative of every realized label before choosing coefficients.
Averaging the omitted coefficient mass over the u partitions yields
one common index i whose omitted mass is at most theta. For each of
the k radii \(a_l\), apply the finite greedy selection to
\[
 I_x=\{(v,T):i\in T,\ d_T(x,v)\le a_l\}.
\]
Whenever some residual \(I_x\setminus U\) has mass greater than theta,
add x as a pivot and include its incidence set in U.
The increments are disjoint and each has mass greater than theta;
at most s pivots can be selected. On termination every residual has
mass at most theta. This includes zero mass, when no pivot is needed.
Assign each covered column to its first pivot.

Replace a pivot z by its fixed i-label representative z'. For an
assigned column \((v,T)\), \(i\in T\), hence z and z' have distance
at most one in that graph. Therefore
\[
 d_T(v,z')\le a_l+1,\qquad
 d_T(x,v)\le a_l\ \Longrightarrow\
 d_T(x,z')\le2a_l+1,
\]
and
\[
 d_T(x,z')\le2a_l+1\ \Longrightarrow\
 d_T(x,v)\le3a_l+2.
\]
These implications use only finite distances under their hypotheses,
so no connectivity assumption is present.

Let \(A_l(x)\) be the mass of assigned columns for which the middle
indicator is one. The omitted and residual masses give
\[
 f_{\mu,l}(x)-2\theta\le A_l(x)
 \le\sum_y\mu_y{\bf1}_{d_T(x,v)\le3a_l+2}.
\]
Averaging these inequalities with weight \(1/k\), then using the
disjoint dilation intervals, gives
\[
 f_\mu-2\theta\le F:=k^{-1}\sum_{l<k} A_l\le f_\mu+\theta.
\]

For each l, group assigned columns by their pivot slot t and retained
set T. This replaces their individual centers by the common fixed
representative and gives weights \(w_{l,t,T}\in[0,1]\).
Pad to exactly s slots with a fixed realized label and zero weights.
Include all \(2^u\) possible T in the code, assigning zero to unused
ones. Set \(M_0=s2^u\), \(\delta=\theta/M_0>0\), and round each
weight down to \(\delta\lfloor w/\delta\rfloor\).
For each weight the loss is in \([0,\delta)\); at exact mesh
boundaries it is zero. There are \(M_0\) weights per level, so the
pointwise loss is at most theta per level and at most theta after
averaging. Thus the rounded decoder A has the asserted interval.

The complete code consists of i, ks realized pivot labels, and
\(ks2^u\) integers in \(\{0,\ldots,N-1\}\).
Enumerate all such codes before any coefficient vector is specified,
allowing codes which never arise in the greedy procedure.
Decoding uses only the fixed graphs, representatives, radii, and mesh.
Its image has at most the displayed number of elements. Every chosen
approximant is in this image. There is no stored center in X and no
factor depending on \(|X|\). The all-zero weights ensure nonemptiness.

## Signed coefficients and convex-body consequence

For any real vector lambda of l1 mass at most one, split it into its
positive and negative parts. Each part is covered by the same positive
list, so \(\mathcal A-\mathcal A\) has at most \(Q^2\) elements and
uniform error at most \(6\theta\). (The asymmetric positive interval
also permits the stronger bound \(4\theta\); we retain the source's
constant for a like-for-like comparison.) First-approximant fibers
in the coefficient ball have image diameter at most \(12\theta\).
Choose an actual coefficient vector in each nonempty fiber.
For two vectors in a fiber their difference has l1 mass at most two,
and the support function of
\(K=3\operatorname{absconv}\{R_x\}+\theta B_\infty\) is
\(h_K(\eta)=3\|f_\eta\|_\infty+\theta\|\eta\|_1\).
Thus these actual representatives cover \(L^\circ=B_1\) by translates
of \(38\theta K^\circ\). This explains why list centers need not lie
in the column hull, and why replacing them directly by ambient
coefficient vectors would not be justified.

Use the source's degree-H finite-field partitions, but use sparse
columns. Their separating graph has distance greater than H, while
the new profile is one at zero and zero beyond H. Row separation is
therefore still exactly one. With \(D_j=\binom{r+j-1}{j}\),
\[
 \log Q\le ksD_{H-1}\log p+C',\qquad
 C'=\log u+ks2^u\log(1+s2^u/\theta),
\]
and
\[
 \frac{\log(Q^2)}{\log(p^{D_H})}
 \le\frac{2ksH}{r+H-1}+\frac{2C'}{D_H\log p}.
\]
This improves the original leading coefficient by the factor k/H,
without claiming a small ambient dimension.

For arbitrary a,b at least one, choose theta \(=1/(1000a)\), then
s \(=\lceil1/\theta\rceil\), k with \(1/k\le\theta\), and
\(H=3^{k-1}\) (or any H in its admissible band). Choose r so that
\(r+H-1>8bksH\). Set \(w=2D_H\) and
\(u=\lceil Hw/\theta\rceil\). Only now is C' fixed.
Choose a prime
\[
 p>\max\{H,H^2u^{2H},\exp(8bC'/D_H)\}.
\]
The source's finite-field construction applies; its assumptions have
not been weakened. Each entropy-ratio term is less than \(1/(4b)\).
Since \(38\theta<a^{-1}\), the same strict violation of metric-entropy
duality follows. The prime is chosen last, after every encoding cost.

## Evidence boundary

`verify.py` is an exact rational, deterministic replay and adversarial
finite experiment, not by itself a proof for all real coefficients.
The universal proofs are the argument above and the declarations
described precisely in `statement_fidelity.md`; the compiler records
their actual checked scope. Independent review, including originality
and publishable significance, is still required. No reviewer verdict
is pre-empted by this report.

The deterministic replay covers 256 cutoff values with exact primal/dual
profile certificates, 444 partition inputs, 9,694 nonnegative coefficient
vectors, and 19,076 signed coefficient vectors. Of the partition inputs,
324 include infinite distances. It also checks 5,076 rounding boundary
cases, 900 exact symmetric-form dimension identities, and a complete tiny
coefficient-independent code enumeration. These are scope-qualified finite
checks; the real-coefficient and all-H assertions rely on the universal
proof, not extrapolation.

Jacobian was used only through the specified Argus adapter, after typed
contract inspection. The first H=3 LP formulation was rejected by the
adapter's simplex-basis admission bound (exit 2). The reduced equivalent
formulation was admitted, but its typed result was `UNKNOWN` (adapter
exit 0). Neither result is evidence for or against the mathematics.
Both exact payloads and both structured responses are preserved as
dedicated JSON files here, including server version 0.14.0 and protocol
2025-11-25 in the admitted response. The independent rational certificate
and proof do not depend on obtaining an optimizer verdict.

To replay the finite certificate, run
`python3 research/sparse_profile/verify.py` from the campaign root.
The certificate-generation flag is for material changes, not for silently
accepting a changed expected result. The ordinary replay compares its
entire computed result against `exact_certificate.json`.

The official Lean 4.31.0 compiler and axiom audit both exited zero, with
`proof_holes=[]`. Mechanical evidence is attached to `C_SPARSE_CORE` in
the mathematical ledger and archived at
`certificates/C_SPARSE_CORE-4cd1f9daa1d309e9.json`.
The audited new declarations depend only on `propext`, `Classical.choice`,
and `Quot.sound`. The source and fidelity document have not changed
since this successful bound run. This certifies the encoded minimax and
counted compression statements, not independent statement-fidelity approval
or originality/significance.

The corresponding rerun command is
`$WORKSPACE/argus-live-update/.venv/bin/python -m argus_skill.verticals.math.lean_evidence verify research/sparse_profile/Main.lean --statement-fidelity research/sparse_profile/statement_fidelity.md --claim C_SPARSE_CORE --project-root .`.
The host's independent Reviewer must inspect the statement reading,
replay the finite certificate, check the stated source dependencies,
and decide publishable significance and originality before campaign
acceptance. No manuscript refutation claim has been made.
