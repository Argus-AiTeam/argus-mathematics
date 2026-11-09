# ENGINEER source-fidelity assessment: looped-comparison

Assessment: conditionally sound dimension-squeeze assembly, not an
independent Argus proof of the geometric comparison.

## Exact claim and hypotheses

C_LOOP_CASE@1 states that for a quiver with a loop at each positive-rank
vertex, determinant-stability cohomology equals \(B_0\) under the
coefficient map. Precisely, with complex coefficients, no flavor,
\(G=\prod_i GL(V_i)\), the usual arrow/framing representation, and
\(\nu_{\det}=\prod_i\det_{V_i}\), the source asserts
\[
B_0=A_0/\langle A_0^{(d)}:d\ne0\rangle
 \xrightarrow{\ \sim\ }H^*(X_{\det}(v,w);\mathbb C)
\]
as graded \(R_0=H_G^*(\mathrm{pt})\)-algebras, using the previously
constructed coefficient-compatible map. Empty varieties and zero-rank
factors are included.

Attribution: OpenAI, *The equivariant cohomological Hikita conjecture for
arbitrary quivers*, September 24, 2026, revision
`4eaee87548250b2682affda7d05d947c05554bae`.
Source root:
`openai-math/preprints/The-equivariant-cohomological-Hikita-conjecture-for-arbitrary-quivers-September-24-2026`.
The exact conclusion is `build/sections/counting.tex`,
`cor:loop-isomorphism`. Its inputs are
`build/sections/stable-pairs.tex`, `prop:kernel-inclusion`;
`build/sections/laurent.tex`, `prop:filtration-bound`,
`eq:filtration-symbol-surjection`, `eq:multipartition-shift`;
and `build/sections/counting.tex`, `prop:hausel-identification`,
`eq:hausel-cut-bound`.

The reference manifest is
`campaigns/9100044/MANUSCRIPTS.json`.
The three relevant source digests match:

- counting: `10859f6ab290811c40bef1992379cda73aff7e7618b0d711dc8e5dfe50bdc8a9`;
- laurent: `eb6558781166a8468bc18af307bba5f04e3ff4e3d53cfa077356af627f45fb34`;
- stable-pairs: `0311b4a4ee05fe673682aeb1bf83abef5228fd4f711a2183034c8186ef203f2e`.

The read-only total was 10/10 manuscript digests and 9/9 existing
snapshot digests matching. The old manuscript reference is a symlink to
this source, not a second frozen copy. No Git or snapshot rebuild was used.

## Old disposition

The ledger contains one source-only version, C_LOOP_CASE@1. The old graph
leaves it open with dependencies C_KERNEL, C_CUT_SYMBOL, and C_COUNTING.
It has no separate Argus proof, formalization, or dimension certificate
in the inventory. Compiling the old arithmetic core would not establish
any of the two geometric comparisons used here.

## Decisive argument checked

First, determinant stability is regular in the source's convention.
Semistability is cyclicity under doubled-quiver paths from incoming
framing. A proper cyclic span gives a destabilizing one-parameter
subgroup. At a cyclic point, path images supply bases; their determinants
give a nonvanishing positive semi-invariant, and path-basis slices give
closed orbits in the semistable locus. A stabilizer fixes every path
image, hence is the identity. Loops do not change this argument. The
opposite linearization convention uses the dual cocyclic statement.

Second, the kernel unit supplies a **specified** graded algebra
surjection \(\alpha:B_0\to H^*(X_{\det})\), not merely an unspecified
map between rings with the same dimension.

Third, the finite support-length filtration, if applicable to the BFN
algebra through the Laurent interface, gives in every half degree \(j\)
\[
\dim B_0^{2j}
 \leq [q^j]\sum_{\|m\|=v}q^{\delta_m}h_m(q),
\qquad
\delta_m=C(v)-D_m+w\cdot(v-l).
\]
The counting unit identifies the right side with
\(\dim H^{2j}(X_{\det})\). Each cut quotient is finite dimensional,
the array set is finite, and the shifts are nonnegative integers.
Coefficient generation makes \(B_0\) nonnegatively and evenly graded;
no positivity assertion about the entire \(A_0\) is required.

Surjectivity of \(\alpha\) gives the opposite inequality in each degree.
Thus \(\ker\alpha\) has zero graded pieces and is zero. Because this is
the original \(R_0\)-algebra map, it proves equality of coefficient
ideals and retains nilpotents. A bare total-dimension coincidence would
not by itself have provided this coefficient-compatible algebra result.

Boundary checks in the source agree with the assembly: if \(v=0\), the
unique empty array gives \(\mathbb C\). If a supported component is
unframed, a unit cut makes its terms zero, and determinant stability is
empty there. A surjection to the zero ring plus the zero upper bound
forces \(B_0=0\); no reduction is taken.

## Supported scope and concrete remaining gaps

The final squeeze has no additional algebraic gap once its three inputs
hold with their stated grading and coefficient map. Those inputs have
not become independent Argus theorems merely by being assembled:

1. C_KERNEL requires the stable-pair and finite-correspondence interfaces
   described in kernel-inclusion/report.md.
2. The cut-symbol theorem must apply to the geometric BFN algebra, not
   only to the parent's explicit abstract Laurent algebra. In
   particular historical C_CUT_SYMBOL@4 retains INPUT_LAURENT.
3. C_COUNTING requires the invariant recurrence and the ordinary Betti
   comparison, including the particular moment-level geometry.
   The retrieved Hausel source is arXiv:math/0511163v2, Theorem 5,
   Equation (9); it is not a substitute for the symbol map.

Consequently this is a conditionally supported source assembly for the
looped determinant-stability case, not a proof for arbitrary stability or
arbitrary flavor without the separate deformation argument. It does not
establish equality with the stability-cocharacter fixed quotient.

Classification: source-only conditional assembly using known and proposed
inputs; no independent new contribution or originality certification.
No contradiction in C_LOOP_CASE@1 was found. Native Host-invoked
independent review remains required and pending; no engineer
self-acceptance is made.
