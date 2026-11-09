# Single-cycle Jordan transport: all-rank prior art and exact descent algebra

## Outcome and its limits

There is an all-rank, literature-based verification of the **operator identity**
in Proposition `prop:single-cycle`: Enguehard, arXiv:1312.0106v1,
Proposition 5.3, supplies classical connected-center compatibility, and
Bonnafe--Michel, arXiv:1003.4922v1, Theorem 3.8(4), supplies its Mackey
hypothesis, including defining field size 2. This applies to individual
characters, not only uniform functions or sums of split labels.

This is **known mathematics, not a new publishable theorem**. It does not
complete the campaign's publishable/verified-new acceptance condition.
No false assertion of the staged manuscript has been established by this
work, and there is no admissible counterexample and no new `F_` claim.
Neither main Donovan theorem is verified or refuted.

The accompanying executable reconstructs nineteen universal equational
identities underlying the proposed descent, and one finite D4 diagnostic
that really has an F-stable double position with no F-fixed Weyl
representative. It does **not** check Lang's theorem, Jordan decomposition,
the whole rational-diagram equivalence, or character induction in arbitrary
rank. Its output explicitly preserves these limits. The mathematical
verification below uses cited theorems; it is not a computer proof of them.
Independent Reviewer acceptance and formal citation attribution are pending.

## Exact question and hypotheses

The target is the field manuscript's
`build/sections/04_labels.tex`, Proposition `prop:single-cycle`,
equation `lab:single-cycle-matrix`, with its preceding setup, not an
arbitrary choice of Jordan bijections:

\[
 A=\epsilon B,\qquad
 B=[R^{\mathbf C}_{\mathbf C_M}]_{\rm unip},\qquad
 \epsilon=\varepsilon_{\mathbf H}\varepsilon_{\mathbf M}
          \varepsilon_{\mathbf C}\varepsilon_{\mathbf C_M}.
\]

Here \(\mathbf H\) is one of the specified regular classical groups or
its successive Levis; both sides of its duality have connected centers
and simply connected derived groups as required in the setup. The
rational semisimple parameter \(s\in\mathbf H^{*F}\) is fixed in the
specified rational class of \(\mathbf M^*\), not summed over fusion
classes. Put
\[
 \mathbf C=C_{\mathbf H^*}(s),\quad
 \mathbf M^*=C_{\mathbf H^*}(\mathbf V),\quad
 \mathbf C_M=C_{\mathbf C}(\mathbf V).
\]
The torus \(\mathbf V\) is either the stated split coordinate or the
primitive cyclotomic part of one permitted signed cycle in one active
classical packet. Earlier disjoint extracts and other linear packets
are fixed. The coefficient prime is odd and different from the defining
characteristic. The assertion includes split D labels individually,
rootless residual packets and the marked Frobenius structures.

## Scope settled against primary sources

The complete primary PDFs and searchable text are saved in `sources/`.
The separate source-reader's findings are in `sources/source_notes.md`.
The following specific passages were also read in the persisted copies:

* Enguehard, Proposition 5.3 and equation (5.3.1), text lines 5423--5448:
  classical connected-center G, nested rational dual Levis containing a
  fixed semisimple s, and the Mackey hypothesis. Its equality is an
  equality of operators on the full unipotent character space.
* Enguehard, Section 1.3.1, text lines 752--765, and Proposition 1.3.2,
  text lines 882--946: the induction normalization, torus pairings,
  irreducible Jordan bijections, isomorphism equivariance and central
  products.
* Bonnafe--Michel, Theorem 3.8, text lines 789--796: alternative (4),
  unlike alternative (3), has no restriction q > 2. No forbidden
  exceptional component occurs in the present classical groups.
* Digne--Michel, Proposition 6.3 and Theorem 7.1, printed pages
  134--135 and 138--139: separation of individual classical parameters,
  the normalized torus rule, and isomorphism compatibility.

The source's signed induction notation must not be silently identified
with the manuscript's unsigned cohomological induction. In particular,
Enguehard's prose calls its rank ``semi-simple F_q-rank'', whereas the
manuscript specifies its split-rank signs. The argument below determines
the resulting overall sign from the manuscript's own torus rule instead
of assuming that two descriptions of rank are identical.

The approach retired as `R_SINGLE_CYCLE_UNIFORM_ONLY` is genuinely
insufficient: tests separate individual labels but do not determine an
arbitrary integral combination of nonuniform characters. Unique
minimum-norm predicted rows yield a lower bound, not norm equality.
An unmarked Weyl-double-position count also loses the fixed rational
parameter at both ends. None of these observations refutes an assertion
in the manuscript, which explicitly supplies extra arguments.

## All-rank verification of the operator identity using prior art

**Theorem (known-result verification).** Take the groups, fixed rational
Levi parameter and ordinary Jordan bijections just specified. The
single-cycle operator identity above holds, and therefore
\[
 \|A\|_{\rm HS}^2=\|B\|_{\rm HS}^2 .
\]
There is no rank bound in this assertion.

**Proof.** Apply Enguehard's Proposition 5.3 with its ambient group
\(G=\mathbf H\), its larger Levi \(M=\mathbf H\), and its smaller
Levi \(L=\mathbf M\), and with the marked dual groups in the target
setup. All these are classical; the connected-center hypothesis holds;
\(s\in\mathbf M^{*F}\) is the same rational semisimple element at the
Levi endpoint. Bonnafe--Michel Theorem 3.8(4) supplies the required
Mackey formula for their Levi subgroups. The duality markings are
exactly the common-torus markings stipulated in the proof of that
proposition, not independent unmarked choices.

Let \(\Psi_{\mathbf K,s}=J_{\mathbf K,s}^{-1}\).
The cited equality, after removing its induction normalizations, says
that the two ordinary matrices agree up to a single overall sign
\(\sigma\):
\[
 A=\sigma B .
\]
The Jordan maps here are the ordinary irreducible maps of Proposition
1.3.2; in classical type their torus characterization and
Digne--Michel separation identify the same marked ordinary labels.
There is no quotient that identifies the two degenerate D characters.

One can recover \(\sigma\) without equating ambiguous rank conventions.
Take a rational maximal torus \(\mathbf T\subseteq\mathbf M\) with
dual \(\mathbf T^*\subseteq\mathbf M^*\) containing s, and its dual
character \(\theta_s\). Torus transitivity and the ordinary Jordan
torus rule give, as identities of class functions,
\[
 R_{\mathbf M}^{\mathbf H} R_{\mathbf T}^{\mathbf M}(\theta_s)
 =\varepsilon_{\mathbf H}\varepsilon_{\mathbf C}
   \Psi_{\mathbf H,s}R_{\mathbf T^*}^{\mathbf C}(1),
\]
whereas transporting the inner torus character first and then
applying the centralizer induction gives the factor
\(\varepsilon_{\mathbf M}\varepsilon_{\mathbf C_M}\).
The class function \(R_{\mathbf T^*}^{\mathbf C}(1)\) is nonzero:
its standard Deligne--Lusztig degree has nonzero prime-to-defining-
characteristic numerator and torus-order denominator. Thus comparison
with \(A=\sigma B\) forces
\[
 \sigma=
 \varepsilon_{\mathbf H}\varepsilon_{\mathbf M}
 \varepsilon_{\mathbf C}\varepsilon_{\mathbf C_M}.
\]
Squaring matrix entries gives the Hilbert--Schmidt equality.

The cited theorem is for the full semisimple series, not its uniform
projection. It therefore includes every individual nonuniform label.
Products with fixed factors use its product/central-product
compatibility. Empty or toral centralizer factors are included in
the same statement. For a split extraction the two matrices are
ordinary Harish--Chandra induction matrices with nonnegative entries
and are nonzero; hence their relative sign is positive. This proves
the stated version of the identity. \(\square\)

This proof does not independently certify every sentence in the
manuscript's replacement proof. In particular, a theorem implying its
conclusion cannot validate a particular proposed term-by-term
correspondence. The following calculations audit that interface more
directly.

## Universal descent identities: no F-fixed representative assumed

Work first in an arbitrary group with an endomorphism F. Assume
\[
 F(n)=anb^{-1},\quad F(x)=xa^{-1},\quad F(y)=yb^{-1}.
\]
Then \(g=xny^{-1}\) is F-fixed. For
\(F_1=\operatorname{Ad}(a^{-1})F\) and
\(F_2=\operatorname{Ad}(b^{-1})F\),
\[
 F_2\operatorname{Ad}(n^{-1})
   =\operatorname{Ad}(n^{-1})F_1,
\]
and
\[
 \operatorname{Ad}(g^{-1})\operatorname{Ad}(x)
   =\operatorname{Ad}(y)\operatorname{Ad}(n^{-1}).
\]
These are group identities, not a finite experiment. The script proves
them by substituting the displayed relations and freely reducing words.
The images of the unconstrained generators are arbitrary, so validity
in the free group implies validity in every group satisfying the
relations.

For new choices \(a'=ak,\ b'=b(n^{-1}kn)\), choose z satisfying
\(F_1(z)=zk^{-1}\). The same word calculation proves that
\(x'=xz,\ y'=y(n^{-1}zn)\) satisfy the new Lang equations and
\(x'ny'^{-1}=xny^{-1}\). It also checks the stated change
\(n'=lnr^{-1}\), with \(a'=F(l)al^{-1}\) and
\(b'=F(r)br^{-1}\). Existence of the Lang solutions and connectedness
of the algebraic intersections are separate geometric inputs, not
deduced by this word checker.

On lattices let Q,w,u,v be invertible and satisfy
\(wQv=Quw\). Set
\[
 Q^\vee=Q^t,\quad w^\vee=w^{-t},\quad
 U=(Q^\vee)^{-1}u^tQ^\vee,\quad
 V=(Q^\vee)^{-1}v^tQ^\vee.
\]
Eliminate u as \(Q^{-1}wQvw^{-1}\) and regard transposition as an
involutive anti-automorphism. Free-word reduction proves exactly
\[
 (Q^\vee)^{-1}w^\vee Q^\vee=Uw^\vee V^{-1},\quad
 Q^\vee U=(Qu)^t,\quad Q^\vee V=(Qv)^t,
\]
\[
 w^\vee Q^\vee V=Q^\vee Uw^\vee.
\]
Thus the specific transposes and inverses in this passage have no
algebraic orientation error. The proof holds for invertible matrices
of every size, including their central coordinates. It does not
assert that every abstract matrix in the computation is a root-datum
automorphism or a Frobenius of an algebraic group.

## A universal parameter-quotient calculation

There is also a group-theoretic correspondence that does not require
any root system. Let H be a group, M a subgroup and \(s\in M\).
Let S be an M-biinvariant subset of H. Consider triples
\((g,m_1,m_2)\in S\times M\times M\) satisfying
\[
 m_1sm_1^{-1}=g m_2sm_2^{-1}g^{-1}.
\]
Put \(h=m_1^{-1}gm_2\). The equation is equivalent to
\(h\in C_H(s)\), and \(h\in S\). The endpoint action
\[
 (g,m_1,m_2)\longmapsto
 (\ell gr^{-1},\,\ell m_1c_1,\,rm_2c_2),
 \qquad \ell,r\in M,\quad c_1,c_2\in C_M(s),
\]
changes h to \(c_1^{-1}hc_2\). Every triple is equivalent to
\((h,1,1)\), by taking \(\ell=m_1^{-1}, r=m_2^{-1}\).
Consequently this quotient is bijective to
\[
 C_M(s)\backslash(S\cap C_H(s))/C_M(s).
\]
This proves surjectivity and injectivity with both endpoints retained;
it is not just a count of the two sets.

For \(h\in C_H(s)\), let \(K=M\cap{}^hM\). Its parameter stabilizer
is exactly
\[
 C_M(s)\cap{}^h C_M(s)=C_K(s),
\]
and its two embeddings are inclusion and \(\operatorname{Ad}(h^{-1})\).
The second fixes s. This follows directly by membership in the
displayed intersections; the conjugation identities used in both
directions are among the script's universal reductions.

Applied to rational points this explains the refinement after the
dual rational Mackey positions have been obtained. It is not, on its
own, a proof that a dualization of arbitrary algebraic Levi diagrams
commutes with forgetting an auxiliary torus, or that its geometric
admissibility and Jordan-label comparisons hold. Those assertions
remain distinct nodes in the proof graph.

## Exact graph-twisted D4 diagnostic

This is a finite root-data example, not a character-level witness.
Use signed permutations of four coordinates, with an even number of
minus signs, for \(W(D_4)\). Its order is 192. Let \(W_M=W(D_3)\)
fix the fourth coordinate positively; its order is 24. Frobenius on
the Weyl group is conjugation by
\(\tau=(1,2,3,-4)\), the usual graph involution.

There are exactly three algebraic double positions:

| Support of the fourth coordinate | Size | F-stable | F-fixed representatives |
|---|---:|---|---:|
| Equal, positive | 24 | yes | 24 |
| Equal, negative | 24 | yes | 24 |
| Disjoint | 144 | yes | 0 |

An explicit representative of the last position and valid corrections
are
\[
 w=(4,2,3,1),\qquad u=v=(-1,-2,3,4),\qquad
 F(w)=(-4,2,3,-1)=uwv^{-1}.
\]
The corrected common-torus action is
\(\tau u=(-1,-2,3,-4)\). This is why demanding an F-fixed w would
miss a genuine rational position. The manuscript expressly warns
against that demand, so this is not a refutation of its literal claim.

For a further fixed diagnostic, take the centralizer root subsystem
\(D_2\{1,4\}\times D_2\{2,3\}\), with Weyl group order 16, and its
intersection with \(W_M\), of order 4. It has four algebraic double
positions but only two F-stable ones, both of equal support. There
is no stable disjoint position in this centralizer subsystem. Thus
even in D4 an ambient unmarked double-position count is not the
parameter-refined count. No actual semisimple element in the
regular integral lattice is constructed here, so the example is not
promoted to a group-level counterexample.

Before any custom root or signed-matrix code, the installed Jacobian
catalog was searched and the exact contract for
`root_system.positive_roots.compute` inspected. One D4 operation was
then run successfully. Its exact payload, inspected contract and
typed output are adjacent JSON files. The replay independently
generates the 24 roots by simple reflections and checks the returned
positive roots, negative roots, highest root, marks and Coxeter number.
The catalog search did not furnish a rational-Mackey or character-
transport operation. The root operation is only a diagnostic.

## What remains open

The strongest prior result is already Enguehard's full classical
operator theorem. The present work does not strengthen its mathematical
conclusion. It adds rerunnable checks of the explicit descent algebra
and a nontrivial warning example for rational positions, neither of
which establishes novelty.

For an audit of the manuscript's particular proof, the precise
remaining interface is global: prove that the local dual lattice
descent gives a choice-independent correspondence of rational
two-embedded Levi diagrams, with the fixed rational semisimple
refinements, and then compare every trace contribution by the
equal/disjoint support induction, including individual D labels.
Local word identities and the abstract parameter quotient do not
replace those geometric and character-theoretic assertions. They
remain open as an independently audited proof route; the operator
identity itself is supported here by the separate prior-art route.

Replay with:

```text
python3 research/single_cycle_transport/verify.py
```

The default mode reconstructs the certificate and compares it exactly,
rather than trusting a stored pass flag. Replacing a recorded
conclusion, a word normal form, the root payload/output, or the Weyl
counts makes replay fail. The JSON explicitly reports known-result
classification, missing full character-theory machine verification,
pending independent review and noncompletion of the publishable
campaign. No Lean file was introduced. The graph leaves the main
theorems and all unreviewed obligations open.
