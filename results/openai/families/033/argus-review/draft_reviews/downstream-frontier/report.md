# Downstream manuscript claims and the unverified frontier

**Assessment:** these claims are explicitly accounted for, but the
Higgs-tail draft does not certify their geometric premises or the entire
manuscript family. Several conditional deductions are readable and
sound; the concrete missing verifications below prevent a broader
conclusion. This is not a claim that the source theorem is false.

## Claim/version coverage and exact source

This unit covers `C9000033`, `C_REVERSE_LOG_MAIN`,
`C_SECTION_CONSTRUCTION` and `C_REMAINING_LOG_INPUTS`, all v1.
The first is a historical campaign goal, not a theorem: audit/refute the
five Family-033 manuscripts or independently verify/repair/generalize
their core theorem with the stipulated certificate/reviewer standard.
It is data, not the current objective. Its reference to
`lean/docs/033.md` and "Partially/Comparator formalized" supplies no
particular theorem, source or compiler evidence in this inventory.

The mathematical downstream statements occur in OpenAI's *The reverse
logarithmic Kodaira inequality and additivity*, dated September 26, 2026,
manifest revision `4eaee87548250b2682affda7d05d947c05554bae`.
`build/main.tex` explicitly attributes that manuscript to OpenAI.
All 10 TeX source files match the reference manifest. The arguments
below are assessed only at their interfaces with the old Argus draft;
this is not a new manuscript-wide error search.

## Main theorem and section construction

Let \(f:X\to Y\) be a connected-fiber surjection of smooth connected
projective complex varieties; \(E,D\) reduced SNC divisors;
\(\operatorname{Supp}(f^*D)\subseteq\operatorname{Supp}(E)\).
Over \(V=Y\setminus\operatorname{Supp}D\), require smoothness of \(X\)
and every irreducible component of every nonempty intersection of
boundary components over \(V\). For very general \(y\in V\), put
\((F,E_F)=(X_y,E|_{X_y})\). The statement `thm:upper-bound` is
\[
 \kappa(X,K_X+E)\le
       \kappa(Y,K_Y+D)+\kappa(F,K_F+E_F),
\]
including \(H^0(X,m(K_X+E))=0\) for every \(m>0\) if either right-hand
term is \(-\infty\). Point dimension is zero and
\(-\infty+a=-\infty\). There is no added abundance or minimal-model
hypothesis, and support inclusion does not erase pullback multiplicities.

`prop:section-construction` says every nonzero
\(s\in H^0(X,m(K_X+E))\), \(m>0\), gives
\(\kappa(Y,K_Y+D)\ge0\). If the latter is zero and \(s|_{X_y}=0\)
for **some \(y\) in the original \(V\)**, there are \(a>0\) and nonzero
\(\tau\in H^0(Y,a(K_Y+D))\) with \(\tau(y)=0\).
Both statements are in `build/sections/introduction.tex`, lines 11-95;
the construction is restated as `prop:nonvanishing` in
`build/sections/nonvanishing.tex`, lines 12-29.

**Classification:** unverified downstream assertions, not consequences
of the numerical equality alone. The conditional restriction argument
when the base has dimension-zero pluricanonical growth is sound:
there is at most one independent section in each nonzero degree, and
one may choose a very general point outside all those zero divisors.
A base section forced to vanish there is a contradiction, so the
section-construction proposition would give degreewise injectivity on
that fiber. This checks an implication, not the hard construction or
the full base-Iitaka reduction.

The source's `cor:additivity` additionally invokes the companion
logarithmic-subadditivity theorem. That opposite inequality, its cited
version and applicability are not certified by the old tail argument.
The corollary and the claimed resolution of a conjecture therefore
remain unverified in this review, rather than silently being counted
as consequences already independently established.

## The six concrete outstanding interfaces

The grouped `C_REMAINING_LOG_INPUTS` is a frontier, not a proved lemma.
Its individual components have the following statements and gaps.

| Component and source locator | Required mathematical content | Assessment and concrete unverified obligation |
|---|---|---|
| Geometric-vector lattice, `geometric-vector.tex`, `prop:logarithmic-vector` (125-160) and `lem:zero-test` (539-550) | A nonzero algebraic highest-Hodge vector from source \(-L_Y\), and all Higgs iterates, have regular coefficients at **every prime on the specified models** in the original logarithmic frames. A degree-\(a\) homogeneous replacement has source \(-aL_Y\). At an original fiber zero, ramification order \(e\) divisible by \(m\) gives orders at least \(e/m\), respectively \(ae/m\), along the point/blowup exceptional test. | Not checked by the tail certificate. One must verify the covering/weight-quotient construction, original coefficient lattice across the extra discriminant, and preservation of the specified zero on all of the original \(V\), not only the smaller VHS open. |
| Actual marked descent and adjoint bigness, `marked-periods.tex`, `prop:marked-period` (10-77), and `boundary-rank.tex`, `prop:adjoint-bigness` (649-652) | Homogeneous tensor operations descend an **actual** irreducible variation through a rational semisimple adjoint group; finite scalar kernel monodromy is eliminated, the marks have the stated compatibility, and \(\mathcal H\) is the specified nef line. For \(\dim S>0\), \(K_S+b\mathcal H\) is big for all sufficiently large rational \(b\). | Not certified by assuming the full marked-data setting. Verify the descent and scalar-monodromy elimination, algebraic quotient, initial adjoint positivity, boundary rank drop and boundary removal. The reviewed tail theorem takes these marked data as input; it does not construct them. |
| Relative-Iitaka exact section comparison, `relative-iitaka.tex`, `lem:relative-iitaka-construction` (69-86) and `prop:rank-one-base` (317-347) | A prepared \(Y\to W\to S\) with geometrically connected generic fibers, \(u_*=\omega x^*u_W\), and \(L_W\) big over \(S\); for every sufficiently divisible \(l\), \(H^0(W,lL_W)\simeq H^0(Y_0,l(K_{Y_0}+D_{Y_0}))\) for the **fixed original** source. Also \(L_W=K_W+B_W+M_W\), \(0\le B_W\le1\) SNC and \(M_W\) nef. | The needed valuation/minimum-rule comparison, fixed-source invariance, and canonical-bundle-formula rank condition for the auxiliary possibly negative subpair have no old exact certificate or independent receipt here. Merely having a relative rational map does not prove the section isomorphism or nef moduli part. |
| Uniform pseudoeffective threshold, `nonvanishing.tex`, `lem:pseff-threshold` (385-393) | \(L_W\) is pseudoeffective and a **fixed** \(Q>0\), depending only on the fixed Higgs maps, satisfies \(Q\pi^*L_W\ge_{\rm pe}P\). | Verify the adapted-cover/cotangent positivity argument, existence of its required maps, and constants uniform in the ample perturbation/boundary. The equality \(\nu(P+\widetilde H)=\nu(P)\) proves none of this domination or pseudoeffectivity. |
| Relative pseudoeffectivity, `nonvanishing.tex`, `lem:nonvanishing-relative` | \(L_W-h^*K_S\) is pseudoeffective for the prepared rank-one base. | Its geometric and external positivity premises and their application are unverified here; no local operator certificate addresses them. |
| Numerical twist removal, `nonvanishing.tex`, `prop:twist-removal` (84-105), with `lem:nef-morse` (117-123) | If \(L\) is big on the generic \(h\)-fiber, \(L-h^*K_S\) is pseudoeffective, \(K_S+bH\) is big for some rational \(b\ge0\), and a smooth dominant generically finite \(\pi\) gives nef \(P\), \(Q>0\), \(\nu(P+\pi^*h^*H)=\nu(P)\), \(Q\pi^*L\ge_{\rm pe}P\), then \(L\) is big. | The **conditional numerical implication** is supported by its displayed argument; the application to \(L_W\) still requires the preceding geometric, bigness and domination premises. No abundance shortcut \(\kappa=\nu\) is allowed. |

Two conditional subarguments should not be obscured by the open frontier.
In the point-quotient case, **if** the original lattice and zero test
hold, constant-frame coordinates are rational base pluriforms regular
at every prime, hence regular globally by normality. At least one is
nonzero, and the positive exceptional order gives the desired vanishing.
This is a sound assembly step, not a verification of the lattice premises.

The numerical twist argument likewise has substantive support. If
\(r=\nu(P+H)=\nu(P)\), the nef mixed intersections force all
\(P^iHA^{n-1-i}\) with \(i\ge r\) to vanish.
Thus \((A+tP)^n\) has positive leading degree \(r\), while
\(nb(A+tP)^{n-1}H\) has lower degree (or is zero for \(r=0\)).
The source's strict nef-Morse/restriction argument gives bigness of
\(A+tP-bH\). The first two twist hypotheses make \(L+bh^*H\) big
using relative bigness and a pseudoeffective ample pullback bound.
Then
\[
 (1+tQ)\pi^*L\ge_{\rm pe}A'+tP-b\pi^*h^*H
\]
proves bigness and generically finite descent. This uses all three
premises, so checking the numerical lemma does not certify the
positive-period construction.

## Reference directory and family boundary

`research/openai_manuscript` contains five linked reference packages:
*Orbifold and logarithmic Iitaka subadditivity* (September 26, 2026);
*Logarithmic Kodaira dimension and whole-fiber variation* (same date);
the reverse-logarithmic article (same date);
*Projective Hodge lines and ordinary Iitaka subadditivity*
(September 27, 2026); and *B-semiampleness for compact log-smooth
Kahler fibrations* (September 10, 2026). They are reference inputs,
not five additional Argus drafts or five reviewed results.

Their 58 TeX files match the assigned reference manifest; each package
also contains one Markdown file and one bibliography. The directory
inventory found no Python/shell/Lean checker sources or Lake toolchain.
The other four complete manuscripts and the companion subadditivity
input are **not independently verified** here. Their exclusion as
new Argus units is justified by their reference-input role, not by an
assertion that their mathematics is already correct.

The old graph keeps the main theorem, section construction, grouped
frontier and campaign goal open, with no confirming reviewer flag.
The old tail-support receipts do not bind proofs of these downstream
claims. The result of this unit is a complete, concrete **unverified
frontier assessment**, including the supported conditional substeps,
not a missing-access verdict, a new counterexample search or a claimed
solution of the old campaign. Current acceptance belongs to the native
independent Reviewer.
