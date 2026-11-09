# ENGINEER assessment: the unlocalized cut-symbol argument

The strongest abstract argument is supported as a mathematical proof over
commutative Q-algebras. Its application to the manuscript remains conditional
on the BFN/Laurent interface. The Lean proof and the finite computations
support specified parts, not the whole geometric theorem. This is an Engineer
assessment for native independent review, not acceptance.

## Exact claim, hypotheses, and attribution

The substantive Argus draft is the read-only
`9000044/research/cut_symbol/proof.md`, titled *An unlocalized cut-symbol
theorem*. Its Sections 1-6 give the proof; Section 7 describes computations,
formal scope, and literature. It has no individual author attribution beyond
the historical Argus work. It verifies a selected assertion of the OpenAI
manuscript, not a purported counterexample to that manuscript.

Let \(K\) be any commutative Q-algebra, with no reducedness, domain, or flatness
assumption. Let \(I\) be finite, \(\Omega_i\) have \(v_i\geq0\) slots, and
\(n_{ij},w_i\) be nonnegative integers. Put
\[
 P=K[x_d:d\in\Omega],\qquad W=\prod_i S_{\Omega_i}.
\]
The weight multiset has \(n_{ij}\) copies of \(x_e-x_d\) for slots of colors
\(i,j\), omitting diagonal zero weights, and \(w_i\) copies of \(-x_d\).
Define
\[
 E_\rho(\lambda)=(-\langle\rho,\lambda\rangle)_+,\quad
 c(\alpha,\beta)=\prod_\rho
 \rho^{E_\rho(\alpha)+E_\rho(\beta)-E_\rho(\alpha+\beta)},\quad
 L=\bigoplus_{\lambda\in\mathbb Z^\Omega}P r_\lambda,\quad
 r_\alpha r_\beta=c(\alpha,\beta)r_{\alpha+\beta}.
\]
The displayed direct sum is the **definition** over arbitrary \(K\), not an
assumed injection into a ring of fractions. Set
\[
 A=L^W,\qquad
 B=A/\langle A^{(d)}:d\ne0\rangle,\qquad
 \deg_{\rm top}r_\lambda=(\sum_{\Omega_i}\lambda_d)_i .
\]
This is the actual ideal quotient, not its reduction.

An array \(m=(m_{i,s})_{s\geq1}\) satisfies
\(\sum_s s m_{i,s}=v_i\). Put its positive sizes \(s_d\) on gauge slots,
fill the remaining slots with zero, and set
\(\lambda_m=s-1\), \(l_i=\sum_s m_{i,s}\), \(l=\sum_i l_i\).
On positive slots let \(P_m=K[x_d:s_d>0]\) and
\(W_m=\prod_{i,s}S_{m_{i,s}}\). For every nonempty positive-slot subset \(S\),
\[
 q_S=\prod_{d\in S}x_d^{w_{i(d)}}
 \prod_{\substack{d\in S,\ e\notin S\\s_e>0}}
 (x_d-x_e)^{(n_{i(d)i(e)}+n_{i(e)i(d)})\min(s_d,s_e)},\qquad
 J_m=(q_S:S\ne\varnothing).
\]
Let \(F_L\) be the sum in \(B\) of dressed orbit images of the
\(\lambda_m\) with \(l\leq L\), and \(F_{-1}=0\). Orbit sums use distinct
translates. The strongest assertion is
\[
 F_{|\Omega|}=B,\qquad
 \bigoplus_{l(m)=L}(P_m/J_m)^{W_m}[\delta_m]
       \twoheadrightarrow F_L/F_{L-1},
\]
where
\[
 \delta_m=\sum_{i,j}n_{ij}v_iv_j
 -\sum_{d,e:s_d,s_e>0}n_{i(d)i(e)}\min(s_d,s_e)
 +\sum_iw_i(v_i-l_i)\in\mathbb Z_{\geq0}.
\]
The maps are graded \(K\)-module maps, not presentations of an associated
graded algebra. Over a characteristic-zero field they imply the
coefficientwise Hilbert-series upper bound. The Q-algebra extension does
not assert the theorem for shifted arrow/flavor weights, arbitrary
representations, positive characteristic, or arbitrary base change of BFN
geometry.

For a split \(s=a+b\), with \(b=s\) on \(S\) and zero elsewhere, put
\(\alpha=a-1,\ \beta=b,\ H=W_{\lambda_m},\
H_S=W_\alpha\cap W_\beta\). The precise leading dressing is
\[
 (-1)^{\epsilon_S}\operatorname{Tr}_{H_S}^{H}(q_Sp_ap_b),\quad
 \operatorname{Tr}_{H_S}^{H}(f)=\sum_{h\in H/H_S}h(f),\quad
 \epsilon_S=\sum_{d\in S}w_{i(d)}
 +\sum_{\substack{d\in S,\ e\notin S\\s_e>0}}
 n_{i(d)i(e)}\min(s_d,s_e).
\]
The trace is an unnormalized coset sum. No group-order multiplicity or
zero-slot factorial is silently inserted.

## All historical versions and the strongest prior result

| Historical claim versions | Disposition |
| --- | --- |
| `C_CUT_SYMBOL@1` | Geometric assertion without filed interface assumptions; not evidence of an unconditional geometric proof. |
| `C_CUT_SYMBOL@2` | Same assertion with `INPUT_LAURENT` made explicit. |
| `C_CUT_SYMBOL@3` | Also files the separate `INPUT_COEFFICIENT_GENERATION`. |
| `C_CUT_SYMBOL@4` | Retains `INPUT_LAURENT`; retires separate generation because the explicit algebra now has its own generation proof. |
| `C_CUT_ABSTRACT@1` | Characteristic-zero-field statement conditional on coefficient generation; subsumed by version 2. |
| `C_CUT_ABSTRACT@2` | Arbitrary commutative Q-algebra, free-module construction, and internally proved generation: strongest abstract result supplied. |
| `C_CUT_GENERATION@1` | Generation by invariant coefficients and dressed positive/negative subset coweights. |
| `C_CUT_CORE@1`, `@2` | Same arithmetic/support/sign core; version 2 binds the formal source and compiler evidence. |
| `C_CUT_ZERO@1` | Charge-preserving derivations and arbitrary-multiplier zero-slot elimination. |
| `C_CUT_TRACE@1` | Top decompositions are cosets and give the stated signed trace. |
| `C_CUT_REYNOLDS@1` | All invariant cut-ideal relations, with arbitrary multipliers, kill the symbol. |
| `C_CUT_SHIFT@1` | Degree formula, nonnegativity, loops, and empty/unframed boundaries. |

Thus thirteen claim versions belong to one argument with constituent lemmas,
not thirteen independent results. Historical reviewer support exists for the
strong algebraic versions and their lemmas; the Laurent judgment was
inconclusive. Pending-review markers in the graph and exact certificate are
compatible with those historical opinions and are not overwritten here.
The Lean certificate's statement-fidelity approval field also remains
historical, not a newly earned independent approval.

Compared with the weaker field/conditional version, the mathematical
improvement was internal coefficient generation and the free-module
Q-algebra extension. This review does not improve on `C_CUT_ABSTRACT@2` or
remove `INPUT_LAURENT` from `C_CUT_SYMBOL@4`; it checks their boundaries.
The two retired conditional routes were superseded for those reasons, not
refuted by a counterexample.

## Decisive proof assessment

### Construction and coefficient generation

The inequality \(u_++v_+-(u+v)_+\geq0\) makes the coefficients polynomial.
Associativity follows by telescoping the three \(E\)-terms on each weight;
\(r_0\) is the identity. The weight multiset is \(W\)-stable, so its action
is by algebra automorphisms. Because \(L\) is free on the specified basis,
invariants decompose uniquely as finite dressed distinct-orbit sums, even
when coefficients have zero divisors.

For a nonbase coweight with a positive entry take
\(\alpha_d=1_{\lambda_d>0}\), \(\gamma=\lambda-\alpha\); otherwise take
\(\alpha_d=-1_{\lambda_d<0}\). Both squared norms are smaller outside the
subset base cases. The two functions of each coordinate are nondecreasing
and sign-compatible, so every root and framing excess for their aligned
product is zero: \(c(\alpha,\gamma)=1\).

At each color an indicator maximizes its scalar product by choosing the
largest entries of \(\gamma\), or the smallest for a negative indicator.
Ties only give the same orbit of sums. Consequently every other resulting
orbit is lower norm. At a fixed \(\lambda\), an incorrect selected subset
would select a nonpositive coordinate while missing a positive one, giving
a strictly improving exchange; the negative case reverses this argument.
The top decomposition is therefore unique and its coefficient is
\(p_\alpha p_\gamma\), not an orbit multiple.

The level blocks of \(\alpha\) and \(\gamma\) are interval partitions in
the ordered \(\lambda\)-coordinates. Every boundary of a
\(\lambda\)-block is a boundary of at least one of them. Prefix power sums
at those boundaries, followed by differences, give every
\(\lambda\)-block power sum. The fundamental symmetric-polynomial
elimination works over any coefficient ring; Newton identities turn the
elementary generators into power sums because integers are invertible in
\(K\). Thus
\[
 P^{W_\lambda}=\langle P^{W_\alpha},P^{W_\gamma}\rangle.
\]
This commutative algebra is spanned over \(K\) by products from the two
subrings. Subtracting lower-norm orbit terms proves generation, including
all polynomial dressings. This is a genuine induction, not an inference
from the tested finite coweight grid.

Every nontrivial subset generator has nonzero charge, so only the image
of \(P^W\) remains in \(B\). The all-size-one array has \(\lambda_m=0\),
proving finite exhaustion in the quotient. It does not claim that these
arrays span the neutral part of \(A\) before quotienting.

### Zero slots

The \(P\)-linear operator
\[
 D_{i,k}(p r_\lambda)
   =p r_\lambda\sum_{d\in\Omega_i}\lambda_d x_d^k
\]
is a derivation by additivity in \(\lambda\), commutes with \(W\), and
preserves each charge space and its generated ideal. Its induced
derivation kills the coefficient-generated \(B\). Applying it to
**every** dressing multiple gives
\[
 \mathsf S_{\lambda_m}\left(
 p\left[\sum_{s_d>0,\ i(d)=i}(s_d-1)x_d^k
             -\sum_{s_z=0,\ i(z)=i}x_z^k\right]\right)=0.
\]
The arbitrary multiplier permits repeated substitution in a polynomial
in zero-block power sums. Newton identities then eliminate all zero-block
invariants, not only a few undressed relations. The replacement is
evaluation on \(s_d-1\) copies of each positive variable; their number is
\(v_i-l_i\), exactly the zero-block size. This proves spanning and
degree preservation, not independence or an isomorphism of dressing rings.

### Support, excess, and the trace

Every translated pair has nonnegative size sum \(t=a'+b'\) with the right
color sums, and
\[
 |\operatorname{supp}t|=l-
 |\operatorname{supp}a'\cap\operatorname{supp}b'|.
\]
An overlap therefore lies in the actual lower filtration, with polynomial
stabilizer-invariant dressing, not merely on a smaller reduced support.
A disjoint pair has exactly the original multiset of positive sizes.

For a disjoint split the root excess is
\(\min(a_d,b_e)+\min(b_d,a_e)\), and the framing excess is
\(1_{b_d>0}\). Reversing \(x_e-x_d\) contributes the sign precisely when
the source slot is selected. Remaining loops contribute
\(2n_{ii}\min(s_d,s_e)\) and parity \(n_{ii}\min(s_d,s_e)\).
Diagonal zero weights are never used.

At the fixed representative, choose the selected copies of each positive
type. The choices are a transitive \(H\)-set with stabilizer exactly
\(H_S\), giving one pair per coset, with count
\(\prod_{i,s}\binom{m_{i,s}}{\#S_{i,s}}\).
Zero blocks add no choices. Equivariance and the type-count dependence
of \(\epsilon_S\) give the displayed signed trace. Since \(\beta\)
has nonzero charge, the product vanishes in \(B\), and its trace has
zero top symbol. This coset proof is a nonformal mathematical step.

### Arbitrary cut-ideal multipliers and the degree

Dressings supported on positive blocks of \(a\) and \(b\) are allowed
by their respective stabilizers. Their products span \(P_m^{H_S}\).
For arbitrary \(f\in P_m\),
\[
 \operatorname{Av}_H(q_Sf)
 =\frac{1}{[H:H_S]}
   \operatorname{Tr}_{H_S}^{H}
       (q_S\operatorname{Av}_{H_S}f).
\]
This does not require \(H_S\) to be normal. All denominators are rational
integer constants. Averaging an ideal expression for
\(g\in J_m\cap P_m^{W_m}\) proves that its symbol vanishes.
Averaging a lift of an invariant quotient class also proves
\[
 P_m^{W_m}/(J_m\cap P_m^{W_m})=(P_m/J_m)^{W_m}.
\]
This is the needed exactness, valid over Q-algebras without a domain
hypothesis. Undressed traces alone would not have sufficed.

Finally \((s_d-s_e)_+=s_d-\min(s_d,s_e)\), together with
the color size sums, gives the stated shift; the original sum of positive
parts proves nonnegativity directly. The empty slot set gives \(K\to K\).
For nonempty entirely unframed data the full cut is 1 and \(B=0\), also
seen from an invertible nonzero-charge constant coweight. Isolated
unframed components, rank one, repeated sizes, full cuts, and empty zero
blocks require no additional hypothesis. No weight inversion, radical
replacement, or closed-point argument enters this proof.

## Manuscript fidelity and provenance

The referenced manuscript is *The equivariant cohomological Hikita
conjecture for arbitrary quivers*, September 24, 2026, revision
`4eaee87548250b2682affda7d05d947c05554bae`, as specified in
`9100044/MANUSCRIPTS.json`. The decisive file is
`build/sections/laurent.tex` under its recorded source directory.
The selected proposition and equations were read, not only searched for:

| Source locator | Reading against the Argus proof |
| --- | --- |
| `prop:filtration-bound`, lines 237-300 | Full-charge quotient, finite filtration in the quotient, coefficientwise Hilbert upper bound; not a ring presentation. |
| `eq:multipartition-shift`, lines 267-285 | Same half-degree shift; remaining loops use \(c_{ii}=2n_{ii}\). |
| `eq:zero-slot-power-sums`, lines 309-340 | Same derivation argument, with arbitrary dressing multiplier. |
| Split/excess/sign calculation, lines 342-398 | Same nonzero-charge split, support drop, and selected-source sign. |
| `eq:cut-leading-trace`, lines 399-435 | Same \(H/H_S\), unnormalized trace, and arbitrary-multiplier Reynolds step. |
| `eq:filtration-symbol-surjection`, lines 437-448 | Same graded vector-space surjection and shift convention. |
| `rem:filtration-edge-cases`, lines 451-459 | Same empty, unframed, and full-cut cases. |

For \(K=\mathbb C\), the assertion is faithful **provided**
`prop:laurent-model` identifies the BFN algebra, coefficients, charges,
and neutral grading with this algebra. The manuscript assumes an original
loop at each positive-rank vertex and deletes one to obtain the displayed
remaining-arrow multiplicities. That geometric hypothesis is not
required by the independently defined abstract algebra.

All ten manuscript TeX entries match the reference manifest, including
`laurent.tex`. The old manuscript path is a symlink to that source, not a
second historical freeze. All nine inventory entries actually listed in
the preserved snapshot manifest match its recorded digests; the other
nine inventory entries have no manifest attestation. The index lists all
eighteen and the bfn-laurent-generation report gives the measured tables.
Matching source bytes do not prove commit ancestry; no Git history or
snapshot reconstruction was used.

## Lean: exact theorem, real toolchain, and reuse

The historical `lean/Main.lean` contains two definitions and eight theorems
in namespace `CutSymbol`:

| Declaration | Exact quantified scope |
| --- | --- |
| `excess_nonnegative` | Every two integers, no bounded exponent hypothesis. |
| `root_excess_disjoint` | Four nonnegative integers; at each endpoint at least one split size is zero. |
| `framing_excess_disjoint` | Nonnegative \(a,b\), with \(a=0\) or \(b=0\). |
| `support_length` | Union/intersection cardinality for any two finite sets. |
| `overlap_strictly_lowers_length` | The preceding setting with nonempty intersection. |
| `oriented_root_sign` | Every commutative ring, two elements, two natural exponents. |
| `finite_sign_product` | Every finite index set, commutative ring, and natural exponent family. |
| `finite_root_excess` | Every finite family satisfying the pointwise root hypotheses. |

The separate fidelity document accurately describes these objects,
quantifiers, hypotheses, and conclusions. Instantiating them with the
manuscript weights remains a mathematical interpretation. No declaration
formalizes invariant-algebra generation, the derivation argument, the
coset bijection, Reynolds averaging, a Hilbert series, or BFN geometry.

The version-matched archived certificate
`lean/certificates/C_CUT_CORE-62172a94b4f90e85.json` records actual Lean
4.31.0, Lake 5.0.0, and elan 4.2.3, compiler exit 0, axiom-audit exit 0,
and no proof holes. Its embedded source and fidelity text match the old
files and the formal `C_CUT_CORE@2` record. The compile log and verification
JSON are provenance for that same run, not extra proofs. Its independent
statement-fidelity approval was not thereby earned.

That unchanged real compiler evidence is reused; no active Lean source was
created, no old source was edited, and no new compiler run is claimed.
The Python checker's phrase "fresh formal-core evidence" is a historical
label: `check_lean()` reads the archived certificate and compares text;
it does not invoke Lean during this review.

## Bounded computation replay

The unchanged historical checker was executed read-only, with all new
outputs under this unit. Its documented dependency environment is
`$WORKSPACE/argus-live-update/.venv/bin/python`, with SymPy
1.14.0. The durable run `review044-cut-replay-live` exited **0** in
**23.3 seconds**. `replay.json` reports:

| Check | Count |
| --- | ---: |
| Quiver configurations / multipartition instances | 9 / 23 |
| Nonempty cuts / dressed trace identities | 116 / 580 |
| Leading decompositions / orbit pairs | 248 / 1174 |
| Lower-length pairs / zero-block generator identities | 650 / 20 |
| Nonbase generation coweights / subset base cases | 2022 / 134 |
| Block-span identities / coordinate values | 6632 / 5 |

The nine configurations have ranks at most four, at most two colors,
including asymmetric arrows, remaining loops, repeated sizes, and
unframed cases. Every partition and nonempty cut is checked at those
configurations, with five selected dressing pairs per cut, not all
polynomial dressings. The generation grid is exactly
\(\{-2,-1,0,1,2\}^{|\Omega|}\) for the recorded dimension signatures.
The checker compares the generated certificate with the old serialized
certificate, including its limitations; it does not turn these finite
checks into a universal proof.

The first submission, `review044-cut-replay`, exited 1 before any test:
the legacy Argus interpreter lacks SymPy. Its receipt and error status
are preserved separately. No dependency was installed in a shared
environment. Probing the script's documented interpreter found the
existing dependency and enabled the substantive run. That import failure
is neither support nor refutation of a mathematical assertion.

The adapter was separately used for **one** inspected bounded operation,
`polynomial.ideal.normal_form.compute`, with exactly the old payload:
\[
 J=(x(x-y)^2,\ y(y-x)^2,\ xy),\qquad f=(x+y)^2
 \quad\text{in }\mathbb Q[x,y],\quad\text{order grevlex}.
\]
The discovery, current typed contract, exact payload, and typed output
are retained in `jacobian_find.json`, `jacobian_contract.json`,
`jacobian_payload.json`, and `jacobian_output.json`.
The isolated adapter used the mandated live-update interpreter, server
**0.14.0**, protocol **2025-11-25**. It exited **0**, returned
`outcome=COMPUTED`, `detail=null`, `in_ideal=false`, and exact remainder
\(x^2+y^2\); no error, timeout, or UNKNOWN was treated as a conclusion.

The checker independently verifies
\(J=(x^3,y^3,xy)\), the quotient's standard monomials, and
\((\mathbb Q[x,y]/J)^{S_2}\simeq\mathbb Q[t]/(t^3)\), \(t=x+y\).
This detects the nilpotent square lost by radical replacement.
It is a finite construction/check of one **cut source**, not a universal
trace proof, a counterexample to the manuscript, or proof that every
symbol target has that exact nilpotence order.

## Known status, supported scope, and remaining gaps

The known-status note and active ledger were written before substantive
assessment. The theorem-level source reading in the companion reports
confirms Weekes, arXiv:1903.07734v2, Proposition 3.1 and Remarks 3.3-3.4,
for dressed minuscule generation, and identifies Lemma 2.10 as a nilHecke
pushforward, not the Laurent theorem. RRT, arXiv:2207.11861v2, Lemma 4.2,
Corollary 4.3 and Section 4.4, concerns related cocircuit constructions,
not this support-length symbol proof. Neither is required as an
unproved input to the self-contained abstract argument above.

No mathematical gap was found in the stated all-Q-algebra proof.
Its remaining delivery boundaries are concrete:

- The BFN/Laurent identification, its coefficient/charge conventions,
  and neutral grading are external to this proof and this Lean source.
  `INPUT_LAURENT` is not retired.
- The nonformal generation, derivation, trace, and Reynolds steps require
  independent mathematical reading; compiler success is not that reading.
- The manuscript's kernel, counting, deformation, Hall-map, root and
  cocharacter arguments are separate units, not consequences of this
  certificate. No full Hikita verification follows from this unit alone.
- The proposed Q-algebra strengthening may be mathematically useful, but
  the old `new_theorem` label and a bounded unsuccessful prior-art search
  do not establish originality or publishable significance.
- Formal archival citation attribution is still outstanding; the current
  write boundary excludes the official tool's `research/literature/`.
  The retrieved source scopes and the unexamined geometric interfaces are
  stated explicitly rather than hidden behind that restriction.

Classification: a supported prose proof of the abstract claim, a proposed
base-ring strengthening with originality unverified, a conditional
geometric application, a version-matched formal arithmetic core, and
bounded exact regressions. There is no failed manuscript attack or
counterexample established by this draft. Native Host-invoked independent
review of this unit and the whole family remains required and pending.
