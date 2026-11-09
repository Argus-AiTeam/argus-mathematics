# Character-averaged upper decoding with no single-character loss

## Result and its scope

**Theorem A.** Under every hypothesis of Proposition `prop:upper` in
`build/04-upper-decoding.tex`, the *same two randomized local strategies*
defined there satisfy the stronger bound

\[
 \Pr_i[F_R=F_L|_{H_i'\times H_i'}]
 \ \ge\ \Gamma_j:=b\,\frac{\tau^2}{2}\,2^{-r}>0.
\tag{A}
\]

Every left output remains a normalized product form, and its matrix on the
displayed lower rows has rank at most one. The left input does not contain
the omitted lower direction. The right uses the lower matrix only through
its displayed quotient. The bound is uniform in the lower row count,
branching, source alphabet, source instance, and lower bias accuracies.

Here all constants have their literal manuscript meanings:

\[
\begin{split}
 c&=\varepsilon^2/2,&\kappa&=c/2,&
 \theta&=c^2/16,&\eta&=\theta/2,\\
 h_0&=2^{-r\ell},&g&=\eta^2h_0/4,&q_0&=g h_0,\\
 \rho&=\kappa\alpha/4,&b&=\kappa\alpha q_0/4,&
 \tau&=\rho h_0/4 .
\end{split}
\]

In particular (A) implies Proposition `prop:upper` verbatim. It improves its
displayed guarantee by the exact factor \(2^\ell\), without changing a
decoder, a sampling law, a list threshold, or an accuracy requirement.
There is still dependence on \(\ell=\ell_j\) through \(h_0,\tau,b\).
This is **not** an alphabet-independent constant in \(\ell\).

The proof below is an all-parameter argument, not an extrapolation from
finite tests. Its new ingredient is the excess-preserving counting theorem
in Section 7. The formal source certifies that counting theorem and the
finite-weight averaging implication, together with the scalar inequalities
used at earlier stages. The entire probability-space construction is not
formalized; the exact scope of the kernel result is in
`statement_fidelity.md`.

No manuscript assertion is established false here. The result verifies and
strengthens this *upper interface*, not the whole hardness theorem.
Novelty beyond comparison with the staged manuscript, publishability, and
independent acceptance remain questions for the independent Reviewer.

## 1. External input and what is not being assumed

The only non-elementary input needed for this interface is the Grassmann
expansion consequence used in `01-preliminaries.tex`. Its precise source
is Khot--Minzer--Safra, ECCC TR18-006, revision 2, May 19, 2018,
Theorem 1.12 (PDF p.12), with Definitions 1.8 and 1.10 (pp.10--11).
The primary statement and independent source-reader provenance are retained
in `grassmann-excerpt.txt`.

For retention threshold \(\zeta\in(0,1)\), apply that theorem with
expansion threshold \(1-\zeta/2\). The theorem first fixes its density and
co-order constants, then requires sufficiently large \(\ell\), and *after
fixing \(\ell\)* sufficiently large ambient dimension. Thus the density,
co-order and lower row threshold do not depend on ambient dimension.
The definition of expansion there concerns nonempty sets of density at
most \(1/2\). Larger sets use the whole interval; reduce the density
constant to its minimum with \(1/2\). This gives exactly the form needed
by the manuscript, not a simultaneous limit with an unproved dimension
uniformity.

The manuscript derives its matrix and finite-range inverse statements
from this input by elementary chart, padding and averaging arguments.
Here are the aspects relevant to uniformity. In the graph chart a binary
nonzero rank-one change has a unique factorization, and exactly half the
Grassmann neighbors stay in the chart. The lost zero step and chart
factor therefore change retention only by fixed factors. Intersecting the
selected interval with the chart gives at most \(r\) row and \(r\) column
constraints.

For padding, fix one point \((X_*,Y_*)\) of a nonempty padded slice.
Writing its column argument maps as \(q,d\), the real projection is
precisely

\[
 AX=U_H,\qquad Xq(\lambda)=t(\lambda)\quad(\lambda\in\ker d).
\]

For a real solution \(X\), the prescription
\(d(\lambda)\mapsto(X_*-X)q(\lambda)\) is a well-defined map into
\(\ker A\), and extends to the dummy space. Each real solution has exactly
\(2^{\dim(\ker A)(\dim D-\operatorname{rank}d)}\) lifts. Thus projection
preserves uniform slice measure, even for zero column dimension and
dependent equations.

For a partial table, defined equality is the sum of each defined fiber's
mass times its retention. Since these masses sum to at most one, a fiber
has retention at least the average; there is no range-size loss. Finally,
if the union of good row fibers had mass below \(\eta/4\), erasing it
would lose less than \(\eta/2\) of defined equality by stationarity.
The inverse theorem would then produce a defined value in an erased good
fiber, a contradiction. A uniform row map encounters a good fiber with
probability at least \((\eta/4)2^{-r\ell}\). Nonempty column slices in a
row fiber have relative mass at least \(2^{-r\ell}\).

Goldreich--Levin and Naor--Naor are historical context, not additional
unproved inputs to this proof. The nonuniform list calculation is proved
in Section 6; small bias is never replaced by total-variation closeness.
Primary-source searches also returned irrelevant or contradictory automated
summaries; none is used as a theorem or as a novelty certificate.

## 2. Joint legality and the untagged quotient table

Use the literal sampling definitions and legal joint-partition labels from
`02-construction.tex`. Fix the two successful levels \(i<j\).
Pair counting with \(d\varepsilon\ge4\), followed by the allowed lower-cut
comparison loss, gives
\(\Pr_i(\mathrm{Acc}_i\cap\mathrm{Acc}_j)\ge c\).
This first comparison is at cut \(i\): retaining its path prefix and the
selected test there is allowed. It is not the upper-cut comparison.

Let \(P\) consist of \(E\), the path through \(D_j\), and *all* matrices
other than \(M=M_{D_j}\). It includes no path continuation below \(D_j\)
and no separate projection metadata. Define

\[
 B(P)=\operatorname{span}\{1,\ s_{C,t}s_{C,u}:
   C\text{ is any level-}i\text{ descendant of }D_j\}.
\]

Every generator belongs to \(H=H_{D_j}(E)\). Choose the section
\(s:H/B\to H\) deterministically from \(P\). The representative response
records the upper value and the outputs at **all** those descendants,
not the one selected by the hidden path.
The retained arrays may carry statistical information about the latent path
or projections. No statistical independence from those choices is assumed:
the raw-law bounds include all those arrays. The restriction here is on
the deterministic observation and its fields, not on what an observer
could infer from their values.

One assignment realizes an entire legal representative response.
Evaluation at that assignment therefore respects every linear relation
among the generators of \(B\). This defines one functional \(b_y\) on
\(B\), with \(b_y(1)=1\) and
\(b_y(s_{C,t}s_{C,u})=(y_C)_t(y_C)_u\).
It is not a separately chosen assignment at each descendant.

For \(\Delta=M-s(\bar M)\), folding gives the restored upper output
\(u+\Delta b_y\), and leaves all the lower outputs unchanged.
Indeed the transformation adds to an upper coordinate a polynomial in
unchanged displayed coordinates. Applying it twice is the identity,
so it preserves the joint fiber partition and its canonical key.
This argument uses equalities of actual functions, not a claim that
the child spaces or product generators are independent.

Fix once and for all

\[
 U(P,\bar M)=
 {\bf1}\{\Pr_i(\mathrm{Acc}_i\mid P,\bar M)\ge\kappa\}.
\]

This conditional probability averages the hidden descendant and all
unexposed data under \(\Pr_i\). Off its conditioning support, set \(U=0\).
Even at points with zero \(\Pr_i\)-mass the resulting partial table is
a fixed function, so it remains a legitimate observable under a different
law. Nothing in the proof recomputes \(U\).

## 3. Exactly which upper-cut comparison is used

The mass of simultaneous success with \(U=0\) is at most \(\kappa\).
Hence \(\Pr_i(\mathrm{Acc}_j,U=1)\ge c/2\).
Fix domains, projections, the path through \(D_i\), the upper omitted
direction \(a\), all other matrices and all upper buckets except \(h_a\).
Call this background \(\mathcal B\). The original and resampled \(h_a\)
are independent with the same conditional law. The level-\(j\) right
query does not depend on \(h_a\). Useful successful responses therefore
share every unchanged output and the upper output modulo \(a\).

This remains true after passage to the representative:
if \(M'-M=a\otimes h\), linearity of the section gives

\[
 [M'-s(\bar M')]-[M-s(\bar M)]
       =a\otimes(h-s(\pi h)).
\]

The two folding corrections differ by a multiple of \(a\), since the
successful samples share \(b_y\). There are thus at most two useful
successful representative values in each background. For their
probabilities \(p_1,p_2\), the probability of equal defined responses is
at least \(p_1^2+p_2^2\ge(p_1+p_2)^2/2\).
Averaging and the elementary second-moment inequality give \(c^2/8\).

The background \(\mathcal B\) was only used to prove this probability.
It is **not** the record to which the upper-cut TV theorem is applied.
The equality event itself is a deterministic function of
\((P,M,M')\), with the fixed partial tables. These data have a common
representation from the upper exterior record, its retained scalar
values including the fresh bucket, all descendant arrays, and independent
directions. Ancestor reconstruction uses pending scalar calls separate
from the upper matrix's own buckets. No internal factor decomposition
or selected lower-descendant tag is needed to evaluate this event.

Consequently `eq:two-cut-triangle` applies. Its allowed error \(c^2/16\)
leaves defined equality at least \(\theta=c^2/16\). In the unrestricted
upper-cut law, own buckets are uniform and independent of pending
ancestor calls and descendant arrays. Thus \(M\) is uniform independently
of \(P\), and replacing \(h_a\) gives
\(M'=M+a\otimes h\), with \(h\) uniform and independent of the old data.
Quotienting gives the ordinary rank-one walk on \(K\otimes(H/B)\).

In particular, this proof does **not** transfer \(\mathrm{Acc}_i\) itself
through the upper cut. Doing that would in general require the forbidden
hidden descendant. It transfers only the untagged equality and, below,
the fixed advice predicates.

## 4. Frozen advice and a positive unconditional excess

The set of \(P\) with conditional defined equality at least
\(\eta=\theta/2\) has mass at least \(\eta\).
Section 1 then gives good advice with probability at least
\(g=\eta^2h_0/4\). Choose its witnessing column constraints and defined
response deterministically from \((P,A,A\bar M)\), never from the
actual position within the slice.

Pulling the columns back gives \(Z\subseteq\operatorname{Ann}(B)\),
\(\dim Z\le r\). Define \(z_0\) to equal \(b_y\) on \(B\) and zero on
the section. Every element of \(z_0+Z\) is normalized and has the
rank-at-most-one matrix \(y_Cy_C^{\mathsf t}\) on every lower descendant's
displayed rows. On a match to the selected representative, the restored
upper output is \(Mz_0+u\).

Let \(J\) mean good advice and satisfaction of its selected columns,
and let \(I\) additionally require the fixed partial-table response.
They are functions of \((P,A,\bar M)\) alone. Under the uniform
reference law, writing \(h=\Pr_j^0(J)\), one has

\[
 h\ge q_0,\qquad\Pr_j^0(I)\ge\alpha h.
\]

These are again common upper-cut observations: no selected descendant,
projection metadata, or factor ingredients have been appended. All
witness choices and marks are now frozen.

The independent row map \(A\) supplies no extra information about
\(\mathrm{Acc}_i\) conditional on \((P,\bar M)\). Therefore
\(\Pr_i(I\cap\mathrm{Acc}_i)\ge\kappa\Pr_i(I)\).
On this event the level-\(i\) right response preserves the upper
component, and canonical sharing gives its evaluation directly on \(O\).
Unconditional TV at most \(v\le\alpha q_0/16\) implies

\[
\begin{split}
 &\Pr_i(J,R_j^{(i)}=Mz_0+u)-\rho\Pr_i(J)\\
 &\qquad\ge(\kappa\alpha-\rho)h-(\kappa+\rho)v
 \ \ge b .
\tag{B}
\end{split}
\]

The last step is a universal polynomial inequality. For
\(\rho=\kappa\alpha/4\), the difference from \(b=\kappa\alpha q_0/4\)
has the exact nonnegative decomposition

\[
 \frac34\kappa\alpha(h-q_0)
 +\kappa(1+\alpha/4)(\alpha q_0/16-v)
 +\frac{\kappa\alpha q_0(28-\alpha)}{64}.
\]

It holds for the stated \(0<\alpha\le1\). This proof never asserts
usefulness conditional on a more detailed analytical exposure.

## 5. The right input's own hidden law

Put \(W=\ker A\) and decompose the actual upper matrix as
\[
 M=M_{\rm known}+X,\quad
 M_{\rm known}=\sum_{v\notin W}v\otimes h_v,\quad
 X=\sum_{v\in W\setminus\{0\}}v\otimes h_v.
\]

Use the inputs exactly as displayed in `eq:upper-left-input` and
`eq:upper-right-input`. In particular the left has full \(S=M_{D_i}\)
but no \(a_i\) or projection metadata; the right has \(O,a_i\) and
\(S\bmod\langle a_i\rangle\), not the missing component of \(S\).
Neither has \(X\). Both have \(A\) and all nonhidden upper buckets.
The left can compute \(P\) and \(A\bar M\), since \(AX=0\).

Condition first on \(O\), the projections, and the path through \(D_i\).
Each actual matrix has its own tape. Each scalar bucket has a separate
recursive call tree, whose calls at \(D_i\) terminate in independent
uniform draws. Thus the hidden upper buckets are independent of all
other actual matrices and all nonhidden buckets. In particular,
pending calls used in an ancestor and buckets of the actual upper
matrix never reuse a draw at a geometric node.

The intrinsic distribution of a hidden bucket is computed by recursion
on the *\(O\)-spaces* along that path, stopping uniformly at \(D_i\).
It is therefore a function of \(O\), the path and fixed parameters.
Original \(E\) and the projection maps specify embeddings into the
original spaces; they do not occur in this intrinsic sampler.
All this information is in the right input or is fixed beforehand.

For analysis expose \(\mathcal D\): both domains, all projection maps,
the path through \(D_i\), \(A,a_i\), nonhidden upper buckets and all
other actual matrices, including full \(S\). The preceding factorization
shows that the conditional law of \(X\) is still precisely this same
\(\mu_{\mathcal R}\). Conditioning only on \(\mathcal R\) is a mixture
of those identical laws and has the same result. This proves own-input
measurability and the stronger exposure invariance, rather than assuming
independence after revealing arbitrary correlated side information.

The right function \(G_{\mathcal R}(X)\) assembles its quotient query and
restores its upper response. It is defined on the entire tensor space:
the fixed labeling was extended to all legal auxiliary keys, and every
matrix there is a legal array. The assembly uses the quotient of \(S\)
only. This supplies a total local \(G_{\mathcal R}\) independent of any
chosen left witness.

For completeness, quarter balance gives the required bias without a
dimension factor. If \(B(g,h)\) is a nonzero bilinear form of two
independent quarter-balanced draws, the probability that
\(B(g,\cdot)\ne0\) is at least \(1/4\). Conditional on this event,
both bits of \(B(g,h)\) have probability at least \(1/4\).
Thus each bit unconditionally has probability at least \(1/16\),
and its character bias is at most \(7/8\). If a nonzero functional
sees an ordinary uniform child its bias is zero; otherwise it sees
the special child's nonzero product form. Independence of its \(R_p\)
products bounds its bias by \((7/8)^{R_p}\).
Taking, for example, \(R_{\min}=6\) gives
\((7/8)^6=117649/262144<1/2\), closing quarter-balance induction.
At and below the modified cut the uniform laws start that induction.

A nonzero character of \(W\otimes H'\) is nonzero on some
\(v\otimes H'\), \(v\in W\setminus\{0\}\). Independence of the hidden
buckets factors its expectation. That bucket contributes a factor at
most \((7/8)^{R_j}\le\lambda\); all others contribute factors at most
one. This is unconditional under \(\mu_{\mathcal R}\), with \(\mathcal D\)
fixed, not a small-bias assertion after conditioning on a slice.

## 6. Universal affine-slice capture under that same law

Fix an exposure \(\mathcal D\) on which the advice is good and the
column equations are compatible. Set \(Q=Z|_{H'}\) and \(z'=z_0|_{H'}\).
Dependent or vanishing restricted columns cause no difficulty:
the equations either are inconsistent (then set \(p=0\)), or specify
a linear map \(Q\to W\) and one nonempty affine slice \(\mathcal C\).
Let \(w=\dim W,\ q_{\rm col}=\dim Q\le r\).
The restriction map onto \(\operatorname{Hom}(Q,W)\) is surjective,
so the annihilator of the slice is
\(L=W^*\otimes Q\) with \(|L|=2^{wq_{\rm col}}\).

For any \(X_0\in\mathcal C\), orthogonality of binary characters gives
the pointwise identity
\[
 {\bf1}_{\mathcal C}(X)
   =|L|^{-1}\sum_{\Psi\in L}\chi_\Psi(X_0)\chi_\Psi(X).
\tag{C}
\]
If \(X-X_0\) is not in the slice direction, a character in \(L\)
takes value \(-1\); pairing the sum with translation by that character
cancels it. Otherwise every summand is one. This proves (C) in all
dimensions, including \(Q=0\).

Under the original unconditional small-bias law,
\[
 p:=\mu_{\mathcal R}(\mathcal C)
 \ge 2^{-wq_{\rm col}}-\lambda
 \ge h_0-\lambda\ge h_0/2>0.
\tag{D}
\]
For any output character \(\sigma\), if
\[
 \left|\mathbb E_\mu[
 g_\sigma\chi_{(\sigma|_W)\otimes z'}\mid\mathcal C]\right|
 \ge\rho/2,
\tag{E}
\]
multiply by \(p\) and use (C). The resulting signed average of
unconditional correlations has absolute value at least
\(\rho h_0/4=\tau\), so at least one summand has absolute value at
least \(\tau\). It belongs to the fixed list \(\mathcal H_\sigma\)
and the coset
\[
 (\sigma|_W)\otimes z'+W^*\otimes Q.
\tag{F}
\]
This step does not use a bias bound on the conditioned law.

For \(m\) distinct elements of \(\mathcal H_\sigma\), align correlation
signs and apply Cauchy--Schwarz to their sum. Distinct characters have
nonzero product character, whose unconditional bias is at most
\(\lambda\). Thus
\[
 m^2\tau^2\le m+m(m-1)\lambda\le m+m^2\lambda.
\]
For \(m>0,\lambda\le\tau^2/2\), division yields \(m\le2/\tau^2\).
The empty case is immediate. No number of possible characters or
ambient dimension is summed in this bound.

## 7. The new excess-preserving counting step

**Theorem B (finite-character excess transfer).**
Let \(\Sigma\) be any nonempty finite set, let \(B_{\rm bad}\subseteq
\Sigma\), and let \(c_\sigma\in[-1,1]\). Suppose
\[
 q\le|\Sigma|^{-1}\sum_\sigma|c_\sigma|,\qquad
 |B_{\rm bad}|/|\Sigma|+t\le\rho,\qquad t\ge0.
\]
Let \(T\) be the fraction of \(\sigma\notin B_{\rm bad}\) with
\(|c_\sigma|\ge t\). For every \(p\in[0,1]\),
\[
 T\ge p(q-\rho).
\tag{G}
\]

**Proof.** Pointwise,
\[
 |c_\sigma|\le{\bf1}_{B_{\rm bad}}(\sigma)
  +{\bf1}_{\{\sigma\notin B_{\rm bad},\,|c_\sigma|\ge t\}}+t.
\]
Averaging gives \(q-\rho\le T\). Also \(T\ge0\). If \(q\ge\rho\),
multiplication of the nonnegative \(q-\rho\) by \(p\le1\) can only
decrease it. If \(q<\rho\), the right side of (G) is nonpositive.
This proves (G). Both cases and the finite sum/count identity are
formalized in `UpperDecoder.productive_characters`.

Now let \(q\) denote the conditional prediction probability on
\(\mathcal C\) from Section 6, with fixed target offset
\(k_0=M_{\rm known}z_0+u\). Fourier expansion of equality over \(K\)
gives
\[
 q=2^{-\ell}\sum_{\sigma\in K^*}
   (-1)^{\sigma(k_0)}
   \mathbb E_\mu[g_\sigma
        \chi_{(\sigma|_W)\otimes z'}\mid\mathcal C].
\tag{H}
\]
In particular \(q\) is at most the average of the absolute correlations.
The fraction of output characters annihilating \(W\) is
\(a=2^{-w}\le2^{-(\ell-r)}<\rho/8\).
Take \(t=\rho/2\). Then \(a+t<5\rho/8\le\rho\), so Theorem B
applies. Let \(T_{\mathcal D}\) count precisely the nonannihilating
characters satisfying (E). It follows that
\[
 T_{\mathcal D}\ge p_{\mathcal D}(q_{\mathcal D}-\rho).
\tag{I}
\]
On incompatible or bad advice put \(p_{\mathcal D}=q_{\mathcal D}
=T_{\mathcal D}=0\); (I) still holds.

Disintegrate the already established **unconditional** inequality (B),
using the exact hidden law from Section 5:
\[
 \mathbb E[p_{\mathcal D}(q_{\mathcal D}-\rho)]\ge b .
\]
Therefore \(\mathbb E T_{\mathcal D}\ge b\). There is no need to
choose one character per exposure or to first discard unfavorable
exposures. This preserves the whole positive excess and is the point
where the manuscript instead incurs its \(2^{-\ell}\) factor.

The argument actually only needs \(a+t\le\rho\). The stricter
manuscript row-count condition is more than sufficient; it is not
a missing hypothesis being added to its statement.

## 8. Local algorithms and agreement

Use exactly the manuscript's algorithms. The left, on good advice,
samples uniformly from \(z_0+Z\) with fresh private randomness and
returns its product form on \(H_i\). Normalization and the displayed
rank bound follow from Section 2. On bad advice use point evaluation
at a fixed legal assignment; this also has both properties.
This is a left-input function and does not use \(a_i\).

The right constructs every \(\mathcal H_\sigma\) from its own original
\(\mu_{\mathcal R}\) and \(G_{\mathcal R}\). It chooses \(\sigma\)
uniformly, then a list element uniformly when that list is nonempty
and \(\sigma|_W\ne0\). Its fixed \(h_\sigma\in W\) satisfies
\(\sigma(h_\sigma)=1\), and it outputs the product form given by
\(z_R=\Phi(h_\sigma)\). In the remaining cases it outputs the zero
form, exactly as in the manuscript.

For each fixed exposure, a fraction \(T_{\mathcal D}\) of choices
of \(\sigma\) has an element (F) in its list. That element is chosen
with probability at least \(\tau^2/2\). Contracting at \(h_\sigma\)
gives \(z_R\in z'+Q\). The linear restriction map \(Z\to Q\) is
surjective; its fibers are cosets of one kernel, so a uniform left
choice restricts uniformly to \(z'+Q\). Its probability of equaling
this particular \(z_R\) is \(2^{-\dim Q}\ge2^{-r}\).
The two final random choices are independent conditional on the
exposure. Equality on \(H'\) implies equality of the product forms
on \(H_i'\times H_i'\).

Thus conditional agreement is at least
\(T_{\mathcal D}(\tau^2/2)2^{-r}\). Averaging and (I) prove (A).
These same lists work for every compatible left input: their law,
function, threshold and contraction vector all depend on the right
input alone. Summing over exposures incurs no witness-count factor.

## 9. Parameters, reproducibility, and outstanding scope

All explicit constants in (A) depend only on \(c,\alpha,r,\ell_j\).
The inverse constants depend only on \(c\), by Section 1. Hidden-law
bias requires an upper product count \(R_j\) meeting the upper tolerance;
at lower levels it uses only the absolute quarter-balance minimum.
Cut error bounds can require branching depending on lower dimensions,
but their required tolerances and the achieved agreement constant do not.
This is precisely the independence needed before a later choice of
\(\ell_i\) and the source repetition power.

`verify.py` is a deterministic, exact-arithmetic replay of the polynomial
identities, the retained Jacobian result, and adversarial finite Fourier
instances (including affine shifts, dependent restrictions, zero column
space, nonuniform laws at the allowed bias boundary, and errors outside
the chosen slice). It also checks that the current official Lean
certificate has exit code zero, no proof holes, the expected source and
fidelity bindings, and an archived mechanical ledger record. The symbolic
and Lean checks, not the finite examples, are the universal evidence.

The formalization does not certify external citations, conditional-law
fidelity, or translation of all the manuscript's objects; those are
proved above and must be independently read. The primary-source
assumption is visibly recorded in the ledger rather than silently
treated as a proved claim. The downstream low-rank and clean-repetition
claims are mapped in `research/PROOF_GRAPH.json` but not certified by
this mission. None of their open nodes is marked proved.

The strongest prior result used for comparison is the literal manuscript
bound \(b\,2^{-\ell}\tau^2\,2^{-r}/2\). The improvement is its replacement
by \(b\,\tau^2\,2^{-r}/2\), for the same algorithms and assumptions.
No finding from a finite search is being relabeled as a counterexample
or as proof of the complete hardness theorem.
