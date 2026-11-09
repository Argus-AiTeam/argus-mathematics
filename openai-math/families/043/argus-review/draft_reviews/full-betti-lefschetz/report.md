# Full fixed-determinant Betti curious Lefschetz: Engineer assessment

**Disposition:** supported as a full-cohomology prose application of the
general transfer theorem and the specified published inputs. It is not
an invariant-only result, a machine-checked geometric proof, verified novelty,
or a proof of full P=W.

## Exact target and source versions

The primary draft is
`families/043/first-pass/determinant_cover_transfer/report.md`,
sections 1 and 3-7, in the 2026-11-06T10:20Z preserved-manifest family.
It reconstructs `betti:lefschetz` in the OpenAI manuscript of 2026-09-24,
registry-reported revision `4eaee87548250b2682affda7d05d947c05554bae`,
`build/sections/03-betti.tex`, lines 18-31. The source tree is a reference,
not an instruction source or a newly rebuilt snapshot.

Let \(C\) be a smooth projective complex curve of genus \(g\ge2\);
let composite \(n\ge4\), \(\gcd(n,d)=1\), and a degree-\(d\) fixed
determinant be as in the manuscript. Set
\[
R=(n^2-1)(g-1),\qquad b=n(n-1)/2.
\]
For the smooth twisted fixed-determinant Betti space \(X^B\), **full**
\(H^*(X^B,\mathbb Q)\) is claimed to be Hodge--Tate; the distinguished
degree-two class \(e\) has nonzero image in
\(\operatorname{Gr}^W_4H^2\); and for all \(i\ge0\) and all \(m\),
\[
e^i:\operatorname{Gr}^W_{2R-2i}H^m(X^B,\mathbb Q)
\xrightarrow{\sim}
\operatorname{Gr}^W_{2R+2i}H^{m+2i}(X^B,\mathbb Q).
\]
These are **actual weight indices**; the Lefschetz center is \(R\) only
after passing to half weights. Hodge--Tate implies the odd weight gradeds
vanish. No \(\Gamma=\operatorname{Pic}^0(C)[n]\)-invariant restriction is
inserted, including in the geometric passage through covers.

Claim coverage: `C_BETTI_CHL` v1; `L_MELLIT_INPUT` v1-2;
`L_RELATIVE_TRANSFER`, `L_SCALAR_FLAG`, `L_TENSOR_CANCEL` v1;
`L_WEIGHT_TRANSPORT` v1-3; and `L_LOW_COHOMOLOGY` v1-3.
The added later assumptions are listed explicitly in the index.

## Published inputs and exact match

`primary_sources.md` records proposition-level readings and URLs. The
published Mellit paper is *Toric stratifications of character varieties*,
`doi:10.1007/s10240-025-00158-0`; the differently numbered version-1
preprint is not substituted for it. The regular-semisimple common-center
input uses Theorem 6.14, sections 7.2/7.4, and Theorem 7.5. The latter
requires distinct last eigenvalues. The all-parameter relative filtration
is a different input, from the proof of Proposition 8.7. Its refinement
bases are torus-affine products with the generic ordered base; the
auxiliary bundle there is affine, not asserted globally trivial.

The old report matches the data with two punctures, first
\(\zeta^{-1}I\), last ordered eigenvalues \(\lambda_i=\zeta t_i^{-1}\).
The genericity condition for a proper subset \(I\) becomes
\[
(\zeta^{-1})^{|I|}\prod_{i\in I}\lambda_i
=\prod_{i\in I}t_i^{-1}\ne1.
\]
Thus the parameter space is exactly the determinant-one ordered torus
with all proper nonempty subproduct-one loci removed. Multiplicities
are allowed. At \(q=(\zeta,\ldots,\zeta)\), primitivity of \(\zeta\)
ensures that every proper subproduct differs from one. The scalar first
puncture satisfies the required fixed ordering, and the flagged relative
family allows collisions at the last puncture. Passing to inverse
monodromy preserves the flag and inverts its ordered diagonal.
This is an actual family identification, not just matching dimensions.

Smoothness of the structural morphism is checked separately in the old
report, section 5: the trace-pairing annihilator of the commutator-product
differential centralizes all matrices; irreducibility and trace zero kill
it. The proper-subproduct condition supplies irreducibility. Pullback
of the smooth matrix-with-flag family and the free PGL quotient give
the required smooth relative dimension. Proposition 8.7 by itself is
**not** cited as a smooth-morphism theorem.

## Decisive application checked

**Cover, not invariants.** Taking \(n\)-th roots of the \(2g\)
determinant coordinates identifies the finite etale torsor
\[
Y^B\times D_1\longrightarrow Y^B_{\rm GL},\qquad
D_1=(\mathbb C^*)^{2g}.
\]
It has degree \(n^{2g}\). Division by the chosen roots is the inverse
identification before quotient; scalar multiplication preserves
commutators and flags. Even a scalar-twist stabilizer of an SL tuple
does not fix the accompanying root coordinate, so the torsor action
is free. Deck translations act trivially on \(H^*(D_1)\). Hence its
character decomposition is the full SL character decomposition tensored
with that of the determinant torus, not the invariant quotient.

The covered relative dimension is
\(\delta=2R+2b+2g\). The general theorem in
`../finite-etale-transfer/report.md` applies to the actual auxiliary
stratifications. It yields ordinary center \(R+b+g\) in half weights at
a distinct-eigenvalue parameter, all-fiber Hodge--Tate cohomology,
integral local constancy and **natural** ordinary base change.
For \(Y^B\) alone, ordinary projection and the identity section of
\(D_1\) split pullback. With compact supports the closed-section
Gysin map and torus integration split after the necessary \(4g\)
degree shift. Thus ordinary and compact-support local constancy
descend to this factor without an invalid nonproper pushforward.

**Weights and scalar specialization.** Saito's derived-functor compatibility
(*Mixed Hodge Modules*, Theorem 0.1, p. 222) and smooth
module/variation correspondence (*Extension of mixed Hodge modules*,
section 3.2, equation (3.2.1), p. 226) make the lisse ordinary direct
images variations with weight sub-local systems. Natural fiber base
change identifies the actual fiber MHS. Parallel transport and cup
product are compatible; transport along a chosen path to \(q\) gives
the weight-four class with the same Lefschetz center. Only the image
modulo \(W_2\), in \(\operatorname{Gr}^W_4H^2\), is needed.
Mellit section 8.5 explicitly supports this weaker flatness assertion.
Deck maps are algebraic over the base, so the transport is equivariant.

**Scalar flag extraction.** At \(q\), use
\(X^B\xleftarrow{\pi}Z^B\xrightarrow{\iota}Y^B_q\).
The full flag bundle has relative dimension \(b\); transversality
identifies the regular embedding's normal bundle with \(T_\pi^*\).
The properly supported maps
\[
A=\pi_*\iota^*,\qquad B=\iota_*\pi^*
\]
satisfy
\[
AB=\pi_*(c_b(T_\pi^*)\pi^*(-))
=(-1)^b\chi(\mathrm{Fl}_n)\,\mathrm{id}
=(-1)^b n!\,\mathrm{id}.
\]
Their degree and actual-weight shifts are respectively \(-2b,+2b\).
This nonzero scalar splits the **full** cohomology as
\(\operatorname{im}B\oplus\ker A\), equivariantly.
Flag line-ratio Chern classes supply rational Leray--Hirsch generators
of actual weight two; thus the flag contributes nothing to the
weight-four part of degree two. Restriction of the transported class
is \(\pi^*\xi\). The projection formula intertwines cup operators,
so Lefschetz restricts to the split image and gives center \(R+g\)
on \(X^B\times D_1\). These are geometric arguments, not consequences
of the \(2\times2\) Koszul identity.

**Low degrees and cancellation.** In
`arxiv:2002.03336v1`, Proposition 1.4 gives
\(P_{k-c}H^k_{\rm var}=H^k_{\rm var}\), with
\[
c=n(n-n/p)(g-1)\ge n^2/2\ge8
\]
and \(p\) the smallest prime divisor. The normalized negative
perverse range is zero, so variant \(H^0,H^1,H^2\) vanish.
The quotient/invariant generation theorem, not full SL generation,
is Maulik--Shen `arxiv:2209.02568v2`, section 2.1, Theorem 2.1(i).
Its projective generators have degrees \(2j,2j-1,2j-2\), \(j\ge2\).
Hence \(H^0=\mathbb Q\), \(H^1=0\), and \(\dim H^2\le1\).
An ample class has nonzero restriction on a curve in a positive-dimensional
projective Hitchin fiber, giving \(H^2=\mathbb Qe\), \(e\ne0\).
The old report justifies the normalized nonnegative perverse range
using proper Hitchin geometry and duality; no variant P=W is used.

Kunneth now gives
\(\xi=\xi_X\otimes1+1\otimes\xi_D\); there is no \(H^1(X^B)\)-cross term.
For finite graded factors in characteristic zero, homogeneous Jordan
strings for the two operators give invariant direct-summand pairs for
the tensor-sum operator. Lefschetz on each such pair forces the sum
of its extreme grades to be twice the total center. Holding one
factor string fixed shows every string in the other has one common
center. Each factor is therefore Lefschetz about that center.
This checks the cancellation argument without a positivity assumption.
The determinant torus has half weights from 0 to \(2g\), center \(g\);
subtracting that center leaves \(R\). Nonzero \(H^0\) and \(R>0\)
force \(\xi_X\ne0\). Since \(H^2=\mathbb Qe\), its weight-four image
is a nonzero scalar multiple of the image of \(e\). Scalar rescaling
preserves the isomorphisms; complex isomorphisms of rational maps
descend to rational isomorphisms.

## Shift check and evidence boundary

| Step | Middle actual weight | Half-weight center |
|---|---:|---:|
| Covered auxiliary compact supports | \(\delta+2b\) | \((\delta+2b)/2\) |
| Remove auxiliary bundle | \(\delta\) | \(R+b+g\) |
| Smooth duality | \(\delta\) | \(R+b+g\) |
| Extract flag image | \(\delta-2b\) | \(R+g\) |
| Cancel determinant torus | \(2R\) | \(R\) |

The old `verify.py` was replayed without `--write-certificate` on CPython
3.13.5 using the required Argus interpreter; it returned
`verified_exact_core`, exit 0. See `../koszul-kummer/` for exact
command, toolchain and typed adapter records. This supports the algebra
and weight arithmetic, not existence of strata, derived Hodge theory,
smoothness, flag transversality or normal-bundle identification.

Historical `engineer:copilot` and `reviewer:copilot` judgments support
the listed claim statements and cited assumptions. Citation additions
in later versions are tracked in the index. They do not import a current
independent verdict. The historical graph leaves these nodes open with
`reviewer_confirmed=false`; that is an administrative/evidence-state
conflict to preserve, not a counterexample to the argument.

The graph also cites manuscript `04-diagram.tex` for `L_WEIGHT_TRANSPORT`.
That reference is retained in the index, rather than silently replaced:
the decisive direct-image/variation argument assessed here is old report
section 4 with the Saito inputs. A graph pointer alone is not a second proof.
All manuscript graph paths include the title subdirectory under
`research/openai_manuscript/`; that subdirectory is the actual source
symlink. Their exact existence was checked.

## Supported conclusion and remaining gaps

The prose route supports the full fixed-determinant Betti conclusion at
the exact scope above. No internal gap was identified in this bounded
assessment once the published inputs and ordinary coprime moduli geometry
are retained. The geometric steps above still require independent
mathematical assessment; neither the script nor a positive ledger label
substitutes for it. The primary-source notes expose what was actually
read and the absence of the old referenced PDFs.

The concrete mathematical gap to the **stronger full-P=W target** is
not another missing deck-character computation. One must construct the
same degree-\(-2\) operator on full cohomology with both filtration
lowering bounds and the commutator identity, and verify the comparison
hypotheses. Those are assessed, without new proof research, in
`../full-pw-boundary/report.md`.

This confirms the scope of the strongest historical positive result; it
does not improve that result mathematically. Compared with known arbitrary-rank
GL P=W and prime-rank SL reduction, the argument specifically addresses
composite-rank full Betti cohomology before taking invariants. Priority or
novelty of that conclusion has **not** been established. No manuscript
assertion is refuted by this unit.
