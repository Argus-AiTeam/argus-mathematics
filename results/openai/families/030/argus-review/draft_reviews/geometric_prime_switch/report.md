# Review: geometric-prime-switch draft family

## Assessment and attribution

**Engineer assessment: the bounded geometric-prime-switch bridge is supported,
with the scope qualifications below.** The actual-cover argument, rather than
the matrix certificate, supplies the integral lattice and common monodromy
basis. The abstract algebra has a fresh successful Lean replay. The three
character congruences follow under the stated characteristic-zero comparison
and field-of-definition hypotheses. Neither the full modularity theorem nor
originality is established by these artifacts. The Host-invoked native
Reviewer accepted the bounded review in
`handoffs/cbbf878a4016/round-0001.json`. Final exploratory certification of
the entire objective remains pending; this report is not an acceptance
certificate.

The manuscript is OpenAI, *Modularity of elliptic curves over imaginary
quadratic fields*, October 4, 2026. All manuscript statement references below
mean revision `4eaee87548250b2682affda7d05d947c05554bae`, as specified by
`9100030/MANUSCRIPTS.json`. The reviewed prose and algebraic reconstruction are
the prior Argus work in `9000030/research/geometric_prime_switch`, not a new
paper by this review. Their claims overlap the manuscript's own
`geo:family`, `geo:semistable-models`, `geo:compact-type`, `geo:collision`,
`mon:slit`, `mon:integral-module`, `mon:vanishing-classes`,
`mon:transvections`, `sys:integral-evaluation`, and `sys:congruences`.

The coefficient-uniform cellular presentation is a proposed strengthening
of the manuscript's displayed integral-module result. It is supported by
the explicit argument below, but this review makes no priority or novelty
claim for it. The matrix-only route is an inadequate proof strategy, not a
counterexample to the manuscript. No manuscript assertion was refuted here.

## 1. Complete inventory and version boundary

There is **one mathematical draft unit with five dependent components**,
not eighteen results. `research/DRAFT_REVIEW_INDEX.json` assigns all eighteen
artifact entries and the reference-input/tooling directory to this unit.
The historical ledger contains nine claim IDs and thirteen claim versions;
all thirteen are assessed in Section 3 and in `verdict.json`.

The preserved snapshot manifest and its existing tar archive contain ten of
the eighteen listed artifacts. For each of those ten, the live old-workspace
bytes, recorded byte count, manifest digest, and archive member agree.
All eighteen live byte counts agree with `PRIOR_DRAFTS.json`.

The eight entries **not present in that snapshot manifest** are the two
empty locks, `compile.log`, `jacobian_payload.json`, `jacobian_output.json`,
`lean_runner_receipt.json`, `lean_verify.json`, and
`reviewer_comparison_excerpt.txt`. They are reviewed as listed old-workspace
inputs, not misrepresented as independently preserved snapshot members.
The index identifies the ten snapshot-bound paths explicitly.

The reference directory contains the manuscript README and TeX/bibliography
sources, not a separate Argus proof or a Lean toolchain. All twelve TeX files
listed in `MANUSCRIPTS.json` match its existing digests in both the old
reference directory and the canonical source directory. These include the
nine section files, main file, and two figures. The README attributes the
paper to OpenAI and dates it October 4, 2026. The manifest does not supply
digests for the README or `build/references.bib`, and contains no PDF-source
entries; the revision-fidelity finding is about the listed TeX, not an
unexamined PDF or every bibliography item.

No old objective, historical status, or supporting judgment was adopted as
an instruction or as current acceptance. The old ledger's
`engineer:copilot` and `reviewer:copilot` judgments are documentary evidence.
The old graph still has unconfirmed independent-review flags, and marks the
core/components in progress or awaiting review. A producer label alone does
not override those flags.

## 2. Exact mathematical setting

For the geometric assertions, let
\[
E=\mathbb C/(\mathbb Z a+\mathbb Z b)
\]
have an oriented primitive period basis. Let \(n\geq3\) be odd and let
\(m>1\) divide \(n\). On the connected smooth parameter open where
\(O,R,-R,[n]R,-[n]R\) are pairwise distinct, use the actual normalized
function
\[
\operatorname{div}(f_R)=([n]R)-(-[n]R)-n(R)+n(-R),\qquad f_R(O)=1,
\]
and the normalization of \(Y^m=f_R(Z)\). Further deletion of finitely many
parameters is allowed. The geometric base characteristic is zero throughout.

Put \(A_m=A[u]/(u^m-1)\) for a commutative coefficient ring \(A\).
The deck generator is \(u:Y\mapsto e^{2\pi i/m}Y\); it is not being
identified with a primitive cyclotomic integer. The supported conclusions
are integral/coefficients-uniform regular-module homology, two monodromy
shears in one transported basis, and their character evaluations.

For the arithmetic assertion, the smooth proper fiber is defined over a
number field \(F\) containing \(\mu_n\), so its deck transformations are
defined over \(F\). A coefficient prime \(\ell\), a common finite extension
\(L/\mathbb Q_\ell\) containing all character values, its integer ring
\(\mathcal O\), and its residue field \(k\) are fixed. Characters being
compared use the **same** coefficient embedding \(j_\ell\) and residue map.
Without these hypotheses, one cannot simply write all Galois matrices over
\(\mathbb Z_\ell[C_n]\) or identify two residual evaluation maps.

In the manuscript's switch, \(K\) is imaginary quadratic, \(E/K\) is non-CM,
\(p>100\) is chosen with the specified large mod-\(p\) image,
\(n=3p\), \(F=K(\mu_n)\), and \(t\in U(K)\). The elementary congruence
argument itself only needs \(p\ne3\) prime and the cover/field hypotheses;
it does not establish the manuscript's existence or adequacy of the later
specialization.

## 3. Every historical claim version

| Historical claim | Disposition |
| --- | --- |
| `C9000030` v1 | Broad old audit/verification objective, not an additional mathematical theorem. It was not completed merely by checking this bridge; full-modularity and independent-acceptance requirements remained open. The present task is review of that work, not continuation of that objective. |
| `C_GPS_GEOMETRY` v1 | Superseded wording, “uniformly off O.” Supported if read locally uniformly; unsupported if read as uniform on all of \(E\setminus\{O\}\), where moving poles remain. Do not silently give it the corrected quantifier. |
| `C_GPS_GEOMETRY` v2 | Corrected compact-subset convergence, split-slit geometry, and order-one nodes are supported by the actual-function argument in Section 4. No formal geometric theorem is claimed. |
| `C_GPS_HOMOLOGY` v1 | Supported integral geometric identification and arbitrary commutative-coefficient base change; Section 5 checks generation, not just ranks over a field. |
| `C_GPS_MONODROMY` v1 | Supported two-shear statement, with independent loop-orientation signs and one transported integral basis; Section 6 checks the common-basis bridge. |
| `C_GPS_EVALUATION` v1 | The natural assertion needs Betti--etale comparison and the stated arithmetic field/embedding hypotheses. Version 1 omitted the explicit comparison assumption. It is not an unconditional self-contained proof. |
| `C_GPS_EVALUATION` v2 | Same natural assertion, now explicitly carrying `A_BETTI_ETALE`. Supported with that classical comparison input; raw residual equality is on the common evaluated lattices, not on all possible lattices. |
| `C_GPS_ALGEBRA` v1 | Superseded initial algebra statement, without the later successful formal certificate. Its elementary content is covered by v3, but v3 evidence must not be assigned to an unencoded v1 statement. |
| `C_GPS_ALGEBRA` v2 | The `prefix` formalization has the retained failed compiler certificate. Parsing failure is inconclusive mathematically, not a counterexample or a successful proof. |
| `C_GPS_ALGEBRA` v3 | The `partialSum` replacement compiles freshly, with compiler and axiom-audit exits 0 and no proof holes. Section 8 limits this to its eleven abstract algebra theorems. |
| `C_GPS_CORE` v1 | The conjunction of the geometric, integral, simultaneous-monodromy, evaluation, and algebraic components is supported within Section 2's hypotheses and the comparison assumption. The finite certificate alone does not prove that conjunction. The bounded review was accepted; final native certification of the entire objective is still required. |
| `C_M_MAIN` v1 | Explicitly unverified by the old bridge. The assertion is full automorphy for every elliptic curve over every imaginary quadratic field, not a corollary of the available certificate; concrete missing verification is listed in Section 10. |
| `C_M_REMAINING` v1 | Explicitly unverified remaining manuscript inputs and deductions. Each named part has a disposition and a specific unresolved verification obligation in Section 10. |

## 4. Actual-cover geometry, not an arbitrary cyclic cover

### Normalization and the split limit

The argument must determine the unramified twisting character; the number
of branch points alone does not determine it. The old report does this.
Inversion and normalization give \(f_R(-Z)=f_R(Z)^{-1}\). Blow up
\((z,r)=(0,0)\), using additive analytic coordinates with the same tangent
normalization. Inversion preserves each vertical component, so the valuation
of \(f\) along it equals its negative and is zero. This excludes a hidden
parameter scalar power. The strict divisor sections meet the exceptional
line at \(n,-n,1,-1\), all distinct in characteristic zero.

Its restriction has the prescribed divisor, hence is a scalar times
\[
q_n(v)=\frac{v-n}{v+n}\left(\frac{v+1}{v-1}\right)^n.
\]
The section \(Z=O\) meets \(v=0\). Since \(n\) is odd,
\(q_n(0)=1=f_R(O)\), fixing the scalar. Also \(q_n(\infty)=1\).
The main elliptic component has no remaining divisor; its constant value
is therefore 1 by matching at the node. These are decisive uses of the
actual normalized family.

On a fixed compact complement of a small disk around \(O\), the extended
function is a holomorphic unit, converges uniformly to 1, and has image in
one simply connected neighborhood of 1 for small \(r\). An analytic logarithm
then labels all \(m\) roots throughout a parameter disk including \(r=0\).
This proves split exterior sheets, not merely a rational homology count.
For each fixed compact subset of \(E\setminus\{O\}\), the disk can be
chosen disjoint from it. It does not prove global uniform convergence on
the punctured elliptic curve.

Inside that disk only the two order-\(\pm1\) sections branch: the
order-\(\pm n\) sections have trivial local Kummer monodromy since \(m\mid n\).
A branch meridian acts transitively on the sheets. The boundary monodromy
is zero, giving \(m\) degree-one boundary components. Riemann--Hurwitz for
the disk gives Euler characteristic \(2-m\), so this connected oriented
surface with \(m\) boundary components is planar. Gluing it to the \(m\)
exterior once-punctured tori gives the asserted genus-\(m\) slit surface.

For \(R_s=(s/n)a\), \(0<s<1/2\), the prescribed five points remain
distinct. The moving short arc extends by isotopy without a collision on
this interval; discreteness of the covering character preserves the split
description along it. The vertical path is the corresponding construction
with \(a,b\) exchanged. Additional deleted parameters can be avoided; they
do not remove elements from the monodromy image of the undeleted family.

### Half-period collision and smoothing order

At \(R_*=a/(2n)\), \(Q=a/2\), write \(t=R-R_*\) and \(z=Z-Q\).
The remaining sections avoid \(Q\), so
\[
f_R=g(z,t)\frac{z-nt}{z+nt}
\]
with \(g\) an analytic unit. A local analytic \(m\)-th root of \(g\) gives
\[
(z+nt)(V^m-1)=-2nt.
\]
For each \(\zeta^m=1\), \(m\zeta^{m-1}\ne0\) over \(\mathbb C\).
Thus \(X=z+nt\) and \(U=V^m-1\) give the node equation
\(XU=-2nt\). There are \(m\) nodes, each of smoothing order one.
The constant \(2n\) is a complex unit, not a twist exponent. The same
calculation applies at \(b/(2n)\).

This agrees with `geo:collision`. Its description of the main component
as a connected unramified cover is also consistent: the torsion divisor
class is \((n/m)((-R_*)-(R_*))=-a/m\), of exact order \(m\).
No arithmetic smooth model in residue characteristic dividing \(m\) follows
from this characteristic-zero calculation. No such model is needed for
the coefficient-ring conclusion.

## 5. Integral homology and arbitrary coefficient base change

The lifted handles have intersection matrix
\(\langle a_i,b_j\rangle=\delta_{ij}\), with the other handle pairings
zero. This gives an integral unimodular lattice, not just independent
rational classes. Independently, Mayer--Vietoris for the planar piece and
the \(m\) punctured tori proves generation: each gluing circle meets its
own torus component, making the \(H_0\) gluing map injective, while those
circles generate the planar piece's \(H_1\) and bound in the tori.
The quotient consists exactly of the \(2m\) handles. These maps and
relations work over an arbitrary commutative coefficient ring \(A\).

The alternate cell model has two vertices and face words
\[
a_i b_i a_i^{-1}b_i^{-1}e_i e_{i+1}^{-1}.
\]
Each handle is inserted in a bigon of the two-branched-point sphere
cover; this constructs the slit surface. The two vertex links have
lengths \(5m\) and \(m\), with opposite generating sheet steps.
The boundary maps obtained from these words, not inferred from desired
Betti numbers, are
\[
C_2=A_m,\quad C_1=A_m^3,\quad C_0=A^2,\qquad
d_2q=(0,0,(1-u)q),\quad d_1(a,b,e)=(-\varepsilon(e),\varepsilon(e)).
\]

For \(\sum c_i=0\), put \(p_0=0\), \(p_{i+1}=p_i+c_i\) and
\(q_i=p_{i+1}\). Then \(p_m=p_0\) and
\(q_i-q_{i-1}=c_i\), including the wraparound at zero.
Conversely cyclic differences have zero sum. Hence
\[
\ker\varepsilon=(1-u)A_m,\qquad
H_1=A_m a\oplus A_m b .
\]
Projection to \((a,b)\) and the section \((a,b)\mapsto(a,b,0)\) are
explicit; this avoids a non-flat tensor-product inference.
Also \(\ker(1-u)=A(1+\cdots+u^{m-1})\), giving \(H_0=H_2=A\).

Deck action shifts both handle indices. The cohomology dual is again
regular, either by index reversal or the perfect coefficient pairing
\([1](xy)\). Equivariant transport across the connected smooth parameter
open extends the result to all its fibers. The manuscript's normalized
constant-\(E\) pullback identifies the covers themselves, not just genera.
These arguments support the integral geometric identification and its
coefficient-uniform strengthening. The rational Jacobian computation is
neither their premise nor a substitute.

## 6. Simultaneous monodromy: the geometric bridge checked directly

The annulus \(XU=t\) produces one Dehn twist when the argument of \(t\)
turns once. Disjoint node annuli therefore act by
\[
\gamma\longmapsto\gamma+
\sigma\sum_i\langle\gamma,\delta_i\rangle\delta_i.
\]
Orienting one vanishing circle oppositely changes neither its summand
nor the resulting matrix. The smoothing calculation fixes exponent one.

As the horizontal slit approaches its half-period collision, a boundary
circle about the shrinking gap has \(m\) closed lifts. A lift uses one
bank on sheet \(i\) and the other on sheet \(i+1\), or \(i-1\) for the
reversed indexing. It misses every horizontal handle and intersects
exactly two vertical handles, once each with opposite signs. Because the
handles already form an **integral** basis, these intersections determine
\(\delta_i=\pm(a_i-a_{i+1})\); they are not merely a plausible ansatz.
The manuscript's slit figure agrees with this description.

For \(D e_i=e_i-e_{i+1}\), the twist sum is
\[
DD^{\mathsf T}=2I-P-P^{-1}.
\]
It sends \(b_j\) to \(b_j+\sigma_a(2a_j-a_{j-1}-a_{j+1})\) and fixes
the \(a_j\). The vertical construction supplies the opposite shear.

Crucially, both initial short slits lie in one disk around \(O\).
The two fixed handle loops lie in its complement. The normalized roots
there extend over a single parameter disk **including** \(R=0\), so
transport between horizontal and vertical starting points preserves their
common sheet labels and handle basis. This rules out an unaccounted
change of basis between the two shear calculations. A common cyclic
relabeling or inversion of the deck generator leaves the Laplacian
unchanged. Based collision loops and their inverses allow the stated
sign choices; signs are constant across sheets.

Passing through the actual constant-\(E\) pullback places both operators
in the original family's monodromy image. This is why the failed
matrix-only route is genuinely insufficient, while the report's
geometric route supplies the missing identification.

## 7. Arithmetic transfer, lattices, and exact congruence scope

### Comparison source and hypotheses

The explicit imported input is `A_BETTI_ETALE`. The author-hosted
J. S. Milne, *Lectures on Etale Cohomology*, version 2.21, March 22, 2013,
was obtained and read, not just registry-resolved:
<https://www.jmilne.org/math/CourseNotes/LEC.pdf>.
The retained source is `sources/Milne-LEC.pdf`.

Theorem 21.1 (printed p.130) compares finite constant-coefficient
cohomology of a nonsingular complex variety with its classical topology.
Corollary 17.8 (p.116) gives invariance for a complete variety and
constructible sheaf under extension of separably closed fields.
Theorem 20.2 (p.127) states proper-smooth local constancy for locally
constant finite-stalk sheaves whose torsion is prime to the base
characteristic. The corollary, rather than local constancy alone, is the
explicit algebraically closed field-extension step.

Our fibers are smooth proper curves in characteristic zero; the constant
sheaves \(\mathbb Z/\ell^s\) meet these hypotheses for every \(\ell\),
including \(\ell\mid n\). Natural comparison and coefficient transition
maps respect deck automorphisms; compatible inverse limits give
\[
M_\ell=H^1_{\mathrm{et}}(C_{n,\overline F},\mathbb Z_\ell)
       \simeq\mathbb Z_\ell[C_n]^2.
\]
This is not an assertion about a smooth cover in residue characteristic
\(\ell\). The old excerpt accurately gives the needed hypotheses,
including Corollary 17.8's field-extension clarification.

This review uses an author exposition, not a newly checked original SGA
proof. There is no supplied DOI/arXiv proposition identifier. The ledger
keeps this as a source-only assumption, not fabricated literature-tier
or kernel-discharge evidence. The Engineer's source reading does not
replace the native Reviewer's independent reading.

### Evaluation without an integral projector

Because rotations are defined over \(F\), Galois acts by invertible
two-by-two matrices over the commutative group ring
\(\mathbb Z_\ell[C_n]\). Evaluation \(e_\theta\) into \(\mathcal O\) gives
\[
T_\theta=M_\ell\otimes_{e_\theta}\mathcal O\simeq\mathcal O^2 .
\]
Evaluation preserves the inverse matrices and continuity. Over \(L\),
where \(1/n\) exists even if \(\ell\mid n\), the group algebra is
semisimple and the evaluated quotient is the specified character space.
No integral character projector is used.

Reduction yields \(M_\ell\otimes_{\overline e_\theta}k\).
Equal residual evaluation maps therefore give identical residual Galois
matrices, before semisimplification, **on these evaluated lattices**.
This statement does not extend to arbitrary stable lattices in an
isomorphic characteristic-zero representation.

In characteristic \(\ell\), an \(\ell^r\)-th root of unity is 1, since
\((z-1)^{\ell^r}=0\) in a field. For \(\chi=\psi\eta\) of orders
\(3p,p,3\), respectively, this proves
\[
\overline V_{\eta,p}\simeq\overline V_{\chi,p},\qquad
\overline V_{\chi,3}\simeq\overline V_{\psi,3},\qquad
\overline V_{\psi,p}\simeq\overline V_{1,p}.
\]
Here the manuscript's bars denote semisimplified reductions, independent
of lattice. Its common evaluated lattices give the stronger raw equality
before taking those semisimplifications.

### Elliptic endpoints and limits of the consequence

The rational finite-cover identifications in `sys:elliptic` are compatible
with this conclusion: pullback followed by trace is the cover degree,
so rational cohomology identifies the invariant character factors.
For \(C_3/\langle w\rangle\), \(w\) acts by \(-1\) on the trivial
rotation part and exchanges the two nontrivial rank-two parts. Its
invariant subspace consequently has dimension two, giving a genus-one
quotient and an elliptic Jacobian. Projection from \(x+w^*x\) to either
nontrivial character part is an isomorphism over the field of definition.
No rational point on that genus-one quotient is required for its Jacobian.

Such rational isomorphisms need not be integral isomorphisms at primes
dividing their degrees. For nested stable lattices with finite quotient
\(Q\), the kernel and cokernel of multiplication by a uniformizer on
\(Q\) have the same composition factors. The reduction exact sequence
therefore proves equality of semisimplifications, not generally equality
of the unreduced lattice reductions. The old report makes the necessary
qualification rather than assuming a degree-divisible integral pullback.

Finally \(2-\lambda-\lambda^{-1}=(1-\lambda)(1-\lambda^{-1})\ne0\)
for a field element \(\lambda\ne0,1\). Two opposite nonzero shears have
no common invariant line, also after field extension. The trivial
character gives zero instead. In particular this alone does not supply
the manuscript's separate mod-\(p\) trivial-character arithmetic image
argument, a simultaneous number-field specialization, or any automorphy
lifting theorem.

## 8. Lean: statement fidelity and fresh compilation are separate

The old successful source and fidelity text were copied by the official
Argus verifier into current writable `replay/`; the old files were not
edited. A fresh real run returned compiler exit 0, axiom-audit exit 0,
empty error streams, and `proof_holes=[]`. Its recorded duration is
15,404 ms. The command was
`$WORKSPACE/.elan/bin/lake env lean` on current `replay/Main.lean`,
with workspace `$WORKSPACE/.local/share/argus-skill/mathlib-v4.31.0`.
Actual reported tools were Lean 4.31.0, commit
`68218e876d2a38b1985b8590fff244a83c321783`, Lake
`5.0.0-src+68218e8`, and elan 4.2.3. Mathlib resolved in that run;
availability was not inferred merely from a directory name.

The replay's source digest is
`e0f8617d789f5c6a4fa20e7c0e4419cb7b0bb1a57af12573a3132c464b62e7c6`;
the separate fidelity digest is
`f284b8ac44948193c1c7d699784e9971c9869a17a1fb11eb8a843f53e29d42d9`.
Both agree with the historical successful evidence. Neither input was
edited during or after the compile. `replay/lean_check.json` and
`replay/compile.log` retain the actual fresh answer.

| Lean theorem(s) | Exact supported mathematical reading |
| --- | --- |
| `prefix_difference`, `telescope`, `cyclic_exact` | Every additive commutative group, every natural \(m\), and a finite initial segment of a sequence: zero sum iff it has a successive-difference potential with equal endpoints, normalized to start at zero. No invertibility of \(m\). |
| `homology_coordinates` | Two coordinate triples whose edge sums vanish differ by the defined boundary iff their handle coordinates agree below \(m\). This is an abstract coordinate criterion, not a constructed topological homology isomorphism. The fidelity text correctly explains the cyclic reindexing. |
| `difference_composition` | Opposite differences for any permutation compose to the stated Laplacian on functions into an additive commutative group. The geometric cyclic shift is a later instantiation. |
| `integral_shear_inverse` | The displayed subtraction shear is a left inverse of the upper addition shear. The other direction and lower shear are elementary consequences, not separate encoded declarations. |
| `laplace_factor` | In a commutative ring, \((1-u)(1-v)=2-u-v\) assuming \(uv=1\). |
| `residual_evaluation` | Equality of two composite ring maps implies equality of the entrywise reduced matrices for any index types. It does not construct a Galois lattice or prove that characters reduce equally. |
| `prime_power_root_is_one` | In a field of characteristic prime \(p\), \(z^{p^r}=1\) implies \(z=1\). It is not a characteristic-zero equality. |
| `laplace_nonzero` | In any field, the Laplacian value is nonzero for \(u\ne0,1\). |
| `no_common_invariant_line` | With two nonzero shear parameters, the two determinant-zero conditions force the vector to vanish. Interpreting them as invariant-line conditions is correct and excludes the trivial character. |

These are eleven theorems. The source has no Kummer-curve construction,
no geometric homology comparison, no common-basis transport, no
Betti--etale comparison, and no modularity/automorphy assertion.
The fidelity document is accurate about that boundary; compilation does
not independently certify the document's reading.

The failed certificate `C_GPS_ALGEBRA-01653cf055832bee.json` binds v2 and
reports parsing errors at `prefix`, exit 1. The replacement
`C_GPS_ALGEBRA-93537cc90355f9b6.json` binds v3 and succeeds.
`lean_check.json`, `lean_verify.json`, and `compile.log` are layers of
evidence for the same old successful run, not three proofs.
`lean_runner_receipt.json` says submitted and is not a completion result.
The review ledger records review judgments, not a manufactured
`closed_kernel` status for the geometric conjunction.

## 9. Finite computations: replayed and limited to what is checked

The inspected `verify.py` uses standard-library exact arithmetic and reads
its expected input files. Its CLI writes the old certificate only with
`--write-certificate`; that flag was not used. From current writable
`computations/`, its definitions and `certificate()` were replayed with
bytecode writing disabled, reading old inputs only. The generated object
equals the old `exact_certificate.json` exactly. The retained measurement
is `computations/finite_replay.json`.

| Replay | What it establishes, and what it does not |
| --- | --- |
| Exceptional expression | Twelve listed \((n,m)\) cases with \(n=3,9,15,303,327\): normalization sign at zero and removal of the \(n\)-fold divisor contributions. No universal analytic limit is inferred from them. |
| Actual elliptic fibers | Exact rational chord/tangent factorizations, multiples and distinctness of the five points, and the formal Miller-function divisor on \(y^2=x^3-x+1\), \(R=(0,1)\), for \(n=3,5,9\). They are actual elliptic-curve checks, not just invented matrices. |
| Cellular model | Face links, boundary composition, primitive differences, rational ranks and ranks at 3 and 5 for \(m=3,5,9,15\); finite primitive checks also include modulus 9. Arbitrary-\(A\) exactness comes from Section 5/Lean, not this finite list. |
| Monodromy algebra | Laplacian identity, four sign choices being symplectic, cyclic/reversal invariance, cofactors and characteristic-dependent kernels for those four degrees. This does not identify geometric vanishing cycles or prove simultaneous transport. |
| Character examples | Group-ring basis exponent comparisons for \(p=101,109\), and nonzero-shear checks in small fields. The universal residual conclusion comes from ring maps and prime-power-root algebra. |
| Historical Jacobian/Lean validation inside the script | Validates retained records and source/fidelity freshness, but does not launch Jacobian or Lean. The fresh runs in this review are separate. |

Two labels require particular care. `elliptic_function_replay()` returns
`normalized_value_at_O: 1` as a constant; it does not compute that value.
The prose normalization is nevertheless justified: with local parameter
\(z=-x/y\) at \(O\), each nonvertical Miller line/vertical ratio has
leading term \(-z^{-1}\), independent of the chosen points. Thus
\(G_{n,-R}/G_{n,R}\) has value 1 at \(O\). This is a mathematical
argument, not an additional assertion tested by that flag.
Likewise `node_smoothing_order_in_characteristic_zero: 1` is supplied
after a polynomial identity check; the geometric reason it is one is
the unit/derivative argument of Section 4. The finite certificate must not
be cited as independently computing either geometric conclusion.

The Laplacian can have larger kernel in characteristic dividing \(m\),
while the cellular difference still has rank \(m-1\). This is not
torsion in the surface's \(H_1\); conflating those two matrices would
invalidate an integral-lattice inference.

### One bounded fresh Jacobian operation

The isolated Argus adapter was used with the required live-update
interpreter, not by importing Jacobian into the legacy environment.
A five-result discovery was followed by inspection of
`chain_complex.homology.compute`'s exact typed contract, then **one**
execution for the existing \(m=3\) rational complex.

`computations/jacobian_payload.json` is semantically identical to the
old payload: field `QQ`, degrees 0--2, dimensions `[2,9,3]`, and the
explicit cellular matrices. `computations/jacobian_output.json` retains
the unaltered adapter envelope, exact request, typed output, server
0.14.0, and protocol `2025-11-25`. Adapter exit was 0, with no error or
timeout. It returns cycle ranks `[2,8,1]`, boundary ranks `[1,2,0]`,
and Betti numbers `[1,6,1]`. This is a finite rational computation.
It supplies no integral or universal topological certificate.

## 10. Dependencies, exclusions, and concrete remaining obligations

The old graph's fifteen dependency edges are all represented in the index
and verdict: the old audit goal depends on the core; the core on its five
components; homology on geometry/algebra; monodromy on
geometry/homology/algebra; evaluation on homology/algebra; and the
manuscript's main theorem on core plus remaining inputs. Geometry and
algebra are leaf nodes in that graph, as is the remaining-inputs bundle.
These edges are a plan, not a checked implication proving full modularity.

`R_GPS_GEOMETRIC_CURRENT` is the current historical decomposition.
`R_GPS_GEOMETRIC` is a parked older version snapshot, replaced when the
uniformity quantifier and formal algebra changed; that is not a
mathematical obstruction. Evaluation v1 and v2 have the same natural
claim digest because adding an assumption does not change it; citing that
digest is not itself a stale-reference defect, but the effective
comparison assumption must still be carried.
`R_GPS_MATRIX_ONLY` is ruled out because algebra alone cannot identify
the actual integral lattice or common transported basis. That reason is
also recorded in the active ledger; no retired attack was reopened.

`C_M_MAIN` asserts, for every imaginary quadratic \(K\) and elliptic
\(E/K\), an isobaric weight-zero automorphic representation with trivial
central character, all \(\ell\)-adic realizations of \(H^1(E)\), full
finite-place local compatibility including monodromy in the stated Tate
normalization, the complex-place parameter and \(L\)-function shift, and
cuspidality in the non-CM case (with the stated CM alternatives).
The bridge does not prove that assertion.

For `C_M_REMAINING`, “unverified” has the following concrete content.
These are manuscript assertions whose proofs/foreign inputs were not
certified by the old unit or by this bounded review, not assertions shown
false or accepted wholesale.

| Manuscript assertion | Unresolved verification needed beyond this draft |
| --- | --- |
| `sys:properties` | Semisimplicity, determinant, all labelled Hodge--Tate weights, potential semistability, and common Frobenius polynomials require the pairing, Hodge, \(p\)-adic comparison and compatibility arguments. Rank-two freeness verifies only its dimension input. |
| `loc:opens` | Prove nonempty local neighborhoods at every \(v_0\mid3p\), simultaneous potential reduction types of the full Jacobian (ordinary, all slopes \(1/2\), or toric rank \(n\)), with extensions uniform on each neighborhood. Complex smoothing and coefficient-prime freeness do not provide this local-field statement. |
| `loc:characters` | Deduce each character summand's ordinary/nonordinary crystalline type or rank-one local monodromy, including coefficient prime equal to residue characteristic. Complex geometric shears do not settle this. |
| `res:specialization` | Produce one \(t\in U(K)\) meeting all local opens, all relevant cyclotomic absolute-irreducibility and decomposed-genericity conditions in both conjugate factors, the trivial-character mod-\(p\) condition, and non-CM of the genus-one quotient's Jacobian. Generic geometric monodromy or one finite fiber does not produce that simultaneous arithmetic point. |
| `aut:lift`, `aut:seed`, `aut:elliptic-compat` | Check the manuscript's cited Caraiani--Newton third-version propositions and their specialized hypotheses, dual/Tate normalization, the \(\ell=3\) case, local alternatives, and the elliptic starting/compatibility assertions. They are named unverified inputs here, not imported as proved results. |
| `aut:transport` | Establish compatible systems and use the good-place/semisimplicity argument at every next coefficient prime; abstract residual matrices do not imply this transport. |
| `aut:automorphic-local` | Verify the use of semisimplified Weil compatibility, the deduction of zero/nonzero monodromy, and the ordinary Steinberg-twist input, including ramified twists. Equality of underlying Weil semisimplifications alone is not blanket equality of monodromy. |
| `aut:over-F` | Check all three lifts \(V_\eta\to V_\chi\) at \(p\), \(V_\chi\to V_\psi\) at 3, and \(V_\psi\to V_1\) at \(p\), with every local/residual hypothesis and the non-CM seed. Three congruences alone are insufficient. |
| `aut:descent` and final deductions | Check cyclic base change/descent, the finite character adjustment, coefficient/local compatibility after descent and twisting, and the CM case before claiming `thm:main`. None is encoded in the Lean source. |

This is a completed assessment of the **old draft's evidentiary scope**,
not a completed proof or refutation of those larger assertions. Missing
support has been identified mathematically rather than inferred from a
failed execution or unavailable manuscript.

## 11. Comparison with prior work and delivery checks

The strongest prior result is the corrected geometry v2 plus algebra v3
and evaluation v2 with comparison, accompanied by prose judgments and
finite certificates. This review does not improve the theorem, bound, or
construction. It improves the assessment: complete claim/version coverage,
direct inspection of the geometric/common-basis and arithmetic transfer
arguments, a fresh compiler/audit, a fresh bounded adapter result, primary
comparison-source verification, and precise qualifications of certificate
labels and excluded manuscript claims. No new counterexample search or
unverified originality claim was substituted for the requested review.

Scope retrieval found no relevant entry in the supplied wiki index for
prime switching, this old campaign, imaginary quadratic modularity, or
Milne. The comparison source was obtainable and checked. No direct original
SGA 7 passage or separate published common-basis theorem was imported;
the report's annulus and actual-cover arguments were assessed instead.
No novelty lookup was required because no originality claim is made.

The completed bounded review ran official checks against the exact campaign root
`campaigns/9200030`,
not the shared batch root. `math_state check` returned **0** with no
issues. `proof_graph_check check` returned **2** because
`research/PROOF_GRAPH.json` does not exist. That path is outside this
mission's writable boundary. In
`handoffs/cbbf878a4016/round-0001.json`, the native Reviewer explicitly
decided: "A root proof graph is not required by this bounded review."
That applicability decision resolves the previously reported graph issue;
it does not change exit 2 into a successful graph check. No graph was
invented, no statement weakened, and no zero exit fabricated.

The same native receipt accepts substantive assessment of all eighteen
artifacts, the reference directory, thirteen claim versions and fifteen
dependencies, and the bounded bridge with its formal/computational limits.
The receipt is at
`$WORKSPACE/.argus-campaign-9200030/projects/4541ef6587c7/handoffs/cbbf878a4016/round-0001.json`.
Its acceptance is reused, not presented as final exploratory certification.

`campaign.json` and `.argus/PIPELINE_STATE.json` persist
`research_target_level=exploratory`; the pipeline is now at `review`.
This submission changes only review-status disclosures, not mathematical
claims, assumptions, formal sources, or replay evidence. Unchanged
validation is therefore reused rather than rerun.

All review conclusions in the active ledger remain Engineer judgments.
Neither those judgments nor this report self-accepts the mission. The
Host-invoked independent Reviewer alone must decide final completion
against `OBJECTIVE.md` for the whole coverage index, substantive unit
report/verdict and `OLD_ROUND_REVIEW.md`, not merely issue another bounded
component receipt. Full modularity and novelty remain outside the
established result.
