# A kernel-checked radial Vandermonde identity and its charge-cancellation consequence

## Abstract

We submit an independent verification of the finite-algebraic cancellation
in OpenAI's September 23, 2026 bulk-Ising manuscript, not a proof of
Ising universality. For every even cardinality and every complex point
configuration, a Lean 4.31.0 theorem proves the balanced Vandermonde
second-moment identity, including collisions. A reviewed ordinary proof
then recovers the manuscript's original charge-weight identity and the
vanishing quarter-turn-averaged quadratic coefficient of its displayed
square-root expression. These mathematical identities and their role in
the manuscript are attributed to OpenAI. The contribution submitted for
final assessment is their independently checked algebraic verification,
with an interpolation-based proof and explicit statement-fidelity limits.
Mathematical correctness has received bounded independent support;
publication-level significance and originality have not been certified.

## Scope and source

The source is
`research/openai_manuscript/Conformal-universality-of-bulk-Ising-correlations-under-weak-interactions-September-23-2026/build/sections/radial.tex`.
The scoped assertions are the definitions beginning at line 147,
Lemma `rad:identity` at line 163, equation `eq:rad-vandermonde` at
line 185, the agreement sum at line 252, and the quadratic
cancellation in Proposition `rad:spectrum` (lines 359-385).
Line numbers identify the staged source, not a separately retrieved revision.
The author and date are specified by the staged `build/main.tex` and
manuscript README. On November 6, 2026, the staged `radial.tex` was
compared byte-for-byte with the primary repository at revision
`4eaee87548250b2682affda7d05d947c05554bae`; the files agreed.
Primary-source links and the formalization comparison appear below.

For any list of distinct complex points, the source defines

    w_X(mu) = product_(i<j) |z_i-z_j|^(mu_i mu_j/2),
    W_s(X) = sum_(sum mu=s) w_X(mu).

Signs take values in {-1,1}. Impossible charges have weight zero.
An empty Vandermonde equals one; the empty list has W_0=1.
For every nonempty even list, W_0>0 and E_0 is normalized by W_0.
No geometric symmetry of the list is a hypothesis.

The universal polynomial obligation is

    sum_(sum mu=0) |D_+(mu)D_-(mu)|^2 |sum_i mu_i z_i|^2 = 2 V_2,
    V_s = sum_(sum mu=s) |D_+(mu)D_-(mu)|^2.

It is stated for arbitrary cardinality 2m, including m=0. Distinctness
is unnecessary for this polynomial identity, but is necessary for the
negative powers in w_X.

The bridge obligation is the printed equality

    E_0 |sum_i mu_i z_i|^2 = 4 (W_2/W_0)^2.

The last obligation concerns the square root of the explicit finite
charge sum `eq:rad-plane-expansion`, not an independent proof of that
continuum spin formula. It must distinguish averaging the square from
averaging its square root, and preserve the original charge weights.
The low-spectrum conclusion additionally uses positivity and the
analytic arguments outside this algebraic audit.

## Exact verification theorem and coverage

Let I be a finite ordered set with |I|=2m, where m is any natural
number, and let z:I -> C be arbitrary. Define

    Delta_z(S) = product_(i<j, i,j in S) (z_i-z_j),
    M_z(S) = 2 sum_(i in S) z_i - sum_(i in I) z_i.

**Theorem (kernel-checked polynomial identity).**

    sum_(S subset I, |S|=m)
      |Delta_z(S)Delta_z(I\S)|^2 |M_z(S)|^2
        = 2 sum_(T subset I, |T|=m+1)
              |Delta_z(T)Delta_z(I\T)|^2.

There are no distinctness, symmetry, or cardinality-cutoff hypotheses.
This is the manuscript's `eq:rad-vandermonde`, not a new identity
claimed here. Its declaration is `Radial.vandermonde_identity_all`;
the certificate is attached to `C_RAD_VD` version 2.

**Consequences (reviewed ordinary proofs with checked components).**
For every even list of distinct complex points, the original weights
give the printed charge identity with coefficient 4. For two such
lists X,Y, let F_X,Y(t) be the positive square root of the displayed
finite sum `eq:rad-plane-expansion`. Put
m(X)=(2^(-|X|/2)W_0(X))^(1/2), and a_X=W_2(X)/W_0(X).
Then, as real t tends to zero through positive values,

    (1/4) sum_(r=0,1,2,3) F_(i^r X),Y(t)
      = m(X)m(Y)(1+a_X a_Y t) + O_(X,Y)(t^3).

Empty lists use the stated conventions. The finite sum is analytic
near zero, and its positive constant term fixes the square-root branch.
This assertion concerns that explicit expression; identifying it with
a continuum correlation is outside the verification. In particular,
neither this Taylor statement nor the complete normalized charge sum
is asserted to be a single kernel-checked theorem.

| Assertion | Exact evidence | What it does not establish |
|---|---|---|
| All-cardinality polynomial identity, including collisions | `Main.lean`, native certificate for `C_RAD_VD` v2 | Original negative-power weights at collisions |
| Original charge identity for distinct lists | Universal ordinary proof below; checked factorization, reindexing and normalization components | A complete Lean declaration for the normalized charge sum |
| Quarter-turn square-root quadratic cancellation | Universal ordinary Taylor argument below; checked angular and scalar polynomials | Continuum spin formula, uniform operator estimate or spectral extraction |
| Exact arithmetic on five stored examples | `verify.py` and unchanged `exact_certificate.json` | Any universal assertion by finite sampling alone |

## Dependencies and prior knowledge

At the start of the radial route, the campaign ledger contained no
certified radial result. It now contains the kernel certificate and
independent supporting judgements specified below. The shared Wiki
index has no matching entry for this manuscript or charge identity.
No external theorem is being taken as an unproved assumption:
the certification is self-contained finite algebra using kernel-proved
Mathlib results. In particular, Lagrange interpolation is existing
mathematics and existing library infrastructure, not an originality
claim. The manuscript's exterior-algebra/SU(2) argument was an assertion
to audit, not a theorem assumed in the independent proof.

The current dependency chain is the universal Vandermonde identity,
then the agreement/disagreement decomposition of two charge assignments,
then the angular coefficients and the scalar square-root coefficient.
Finite tests alone cannot establish the first obligation. A proof
that assumes the charge identity, imposes symmetry on the point lists,
or bounds their cardinality would not settle this mission.

## An independent all-cardinality algebraic proof

The following argument is a proof in ordinary mathematics; compiler
coverage is reported separately. It does not use the charge identity
as an assumption.

Let the index set have size 2m, let the points be distinct, and write

    C(S) = product_(i in S, j not in S) (z_i-z_j),
    c(S) = 1/C(S) if |S|=m, and 0 otherwise.

These denominators are nonzero. On functions of subsets define

    (E_z f)(T) = sum_(i in T) z_i f(T\{i}),
    (E f)(T)   = sum_(i in T) f(T\{i}),
    (F f)(S)   = sum_(i not in S) f(S union {i}),
    (H_z f)(S) = (2 sum_(i in S) z_i - sum_i z_i) f(S).

Here E=E_1. Suppose |T|=m+1 and let B be its complement. Direct
factorization gives, for each i in T,

    c(T\{i}) =
      (-1)^m/C(T) *
      product_(j in B)(z_i-z_j) /
      product_(j in T\{i})(z_i-z_j).

Lagrange interpolation on T says that the sum of the last fraction,
with numerator p(z_i), is the degree-m coefficient of p whenever
deg p <= m. Apply it first to the monic degree-(m-1) polynomial
product_(j in B)(Z-z_j), and then to Z times that polynomial.
The sums are respectively zero and one. Consequently

    E c = 0,
    (E_z c)(T) = (-1)^m/C(T) for |T|=m+1,

and E_z c vanishes on all other subset sizes. The case m=0 is
handled directly. For balanced S,

    c(complement S) = (-1)^(m^2) c(S).

Complementation converts F c into the corresponding E c, so F c=0.
These are interpolation identities, not the desired quadratic identity.

For the usual finite Hermitian pairing, F is the adjoint of E.
The local two-state operators give

    F E_z - E_z F = -H_z,
    E H_z - H_z E = -2 E_z.

Since E c=F c=0,

    <H_z c,H_z c>
      = -<F E_z c,H_z c>
      = -<E_z c,E H_z c>
      = 2 <E_z c,E_z c>.

Thus, for every m without a cardinality cutoff,

    sum_(|S|=m) |2 sum_S z_i-sum_all z_i|^2 / |C(S)|^2
        = 2 sum_(|T|=m+1) 1/|C(T)|^2.

Let Delta be the Vandermonde of the complete ordered list. Partitioning
its pairs into the two within-group families and the cross family gives

    |Delta|^2 / |C(S)|^2 = |D(S)D(complement S)|^2.

Multiply the preceding identity by |Delta|^2. The result is exactly
`eq:rad-vandermonde`, including its factor two. It is also valid at
colliding points: both sides of that final equality are polynomials
in the real and imaginary parts and agree on the dense set of distinct
lists. The charge-weight conclusion below uses only distinct lists.

## Bridge to the original charge weights

Put M(mu)=sum_i mu_i z_i and
N_0=sum_(sum mu=0) w(mu)|M(mu)|^2. In N_0 W_0, let
A={i:mu_i=nu_i} and B be its complement. Both restrictions of mu
are balanced. Cross-group distance factors cancel. For I=A or B,

    product_(i<j in I) |z_i-z_j|^(mu_i mu_j)
       = q(I) |D_+(mu)D_-(mu)|^2,
    q(I)=product_(i<j in I) |z_i-z_j|^(-1).

The mixed term in |M_A+M_B|^2 vanishes after sign reversal on A
(or on B). Applying the polynomial identity separately to the two
groups therefore gives

    N_0 W_0 =
      2 sum_(A disjoint-union B=X) q(A)q(B)
        [V_2(A)V_0(B)+V_0(A)V_2(B)].

This is a sum over ordered complementary groups, with no factor 1/2.
For two assignments of total charge (2,2), agreement has charge 2
and disagreement charge 0. This identifies the first bracketed sum
with W_2^2. For charges (2,-2), the charges on agreement and
disagreement are 0 and 2, identifying the second with W_2 W_-2.
Global sign reversal gives W_-2=W_2. Hence N_0 W_0=4W_2^2.
Division by the strictly positive W_0^2 proves the printed identity.
For the empty list N_0=W_2=0 and the stated convention gives zero.

## Angular coefficient and the square root

Assume the finite squared-correlation expression
`eq:rad-plane-expansion` (source lines 321-330). Normalize its
constant coefficient to one and put a_X=W_2(X)/W_0(X).
All points may be arbitrary distinct complex numbers; for a Taylor
expansion choose real t sufficiently close to zero that the finite
cross products have no zeros.

Under independent charge-zero weights let

    A_X=sum mu_i x_i,  B_X=sum mu_i x_i^2,

and similarly for Y. The logarithm of the charge-zero cross product
through order two is

    -t/2 Re(A_X conjugate(A_Y))
    -t^2/4 Re(B_X conjugate(B_Y)).

The second term has angular frequency two, so its quarter-turn
average is zero. If U=A_X conjugate(A_Y), averaging the square of
the first term uses

    average_(r=0,1,2,3) Re(i^r U)^2 = |U|^2/2.

This gives the invariant quadratic coefficient

    E_0|A_X|^2 E_0|A_Y|^2 / 16 = (a_X a_Y)^2.

The zero-charge linear coefficient is zero before averaging by sign
reversal. The charges +2 and -2 have leading power t and supply
the rotation-independent coefficient 2a_X a_Y. Their order-t
cross corrections have angular frequency one, so contribute no
averaged quadratic coefficient. Charges of absolute value >=4
start at t^4 and do not enter this computation.

For each rotation the positive square root has constant term one,
linear coefficient a_X a_Y, and quadratic coefficient
c_2(rotation)/2-(2a_X a_Y)^2/8. The linear coefficient is independent
of rotation, so averaging this square-root expansion is legitimate:

    average quadratic coefficient
      = (a_X a_Y)^2/2 - (2a_X a_Y)^2/8 = 0.

This proves the claimed O(t^3) algebraic remainder for arbitrary
even lists, not merely symmetric point configurations. Empty lists
have constant pairings and are checked directly. Inferring the
Hilbert-space operator estimate still requires the source's
positivity, density, and spectral arguments; none is certified here.

## Mechanical evidence and limits

Jacobian 0.14.0, protocol 2025-11-25, returned
`is_valid=true`, method `EXACT_COEFFICIENT_IDENTITY`, for

    (xu+yv)^2+(xv-yu)^2=(x^2+y^2)(u^2+v^2).

The exact typed request and response, adapter exit status, and timeout
status are preserved in `exact_certificate.json`. This checks the
angular polynomial, not the all-cardinality Vandermonde theorem.
No false source assertion has been established. The ledger contains
independent supporting mathematical judgements on the four radial
claims; final publication-level significance and novelty assessment
remain pending. No new Jacobian operation or mathematical replay is
needed for this submission of unchanged reviewed evidence.

The universal polynomial identity itself is proved by
`Radial.vandermonde_identity_all` in `Main.lean`. The official
`lean_evidence verify` run used Lean 4.31.0, exited 0, and reported
`proof_holes=[]` and axiom-audit exit code 0. Its archived certificate is
`certificates/C_RAD_VD-b4a01cf8155b9ee0.json`; `C_RAD_VD` version 2
has derived status `closed_kernel`. The source and fidelity text remain
unchanged since that run. The tool automatically archived a byte-identical
copy of `research/statement_fidelity.md` as `statement_fidelity.md`.

The formal theorem covers every even cardinality, without distinctness,
whereas the ordinary charge-weight proof requires distinctness. This is
strictly more than any finite check: it includes arbitrarily many points
and all configurations, including those with no spatial symmetry.
The development supplies explicit checked algebraic components of the
charge bridge and angular cancellation. It does not label the full
normalized charge sum or its Taylor remainder as an all-in-one
kernel theorem; the exact coverage is explained in the fidelity document.

`verify.py` uses only Python's standard library. Run

    python3 verify.py

It replays the stored Jacobian coefficient identity, the scalar
square-root cancellation, and the actual Vandermonde/charge/regrouped
sums on the certificate's Gaussian-integer examples using integer and
multiquadratic rational arithmetic. It checks every even agreement
subgroup on these examples, not just the final normalized equality.
The examples have cardinalities 0, 2, 4, 6, 8, with 171 even agreement
groups in total; all residuals are exactly zero. These are finite
diagnostics, explicitly separate from the universal theorem.
By default the script also checks that the current source, fidelity,
native certificate, and claim ledger agree, then performs a real Lean
4.31.0 compiler replay. `--finite-only` deliberately skips that universal
evidence check and cannot certify the theorem.

The official recorder can be replayed independently with

    $WORKSPACE/argus-live-update/.venv/bin/python -m argus_skill.verticals.math.lean_evidence verify Main.lean --project-root . --claim C_RAD_VD --statement-fidelity research/statement_fidelity.md

No unproved external proposition or unchecked literature citation is
needed for this finite algebraic proof. The literature checker reported
no outstanding assumptions. The operator's publishable/exploratory
settings are unchanged; novelty and publishability are questions for the
independent Reviewer, not conclusions manufactured from compiler success.

## Attribution and comparison with primary sources

**What the manuscript already supplies.** In `radial.tex` lines 147-264,
OpenAI defines these weights, states the charge identity, and proves
the all-cardinality polynomial identity using an exterior-algebra
singlet and the SU(2) relation `||A_3 v||^2=2||A_+ v||^2`.
It then gives the same agreement/disagreement regrouping used in the
charge bridge. Lines 359-385 already derive the angular coefficient and
the square-root cancellation. Accordingly, the coefficient 2, the
coefficient 4, unrestricted even cardinality, and the cancellation
itself are not discoveries of this audit. Nor is the collision case
claimed as a new mathematical generalization: the source's polynomial
argument does not need distinctness.

**What this verification adds.** The checked proof realizes the
singlet through reciprocal cross products on subsets. Lagrange
interpolation proves its annihilation and raising identities;
explicit adjoint and commutator calculations give the second moment;
Vandermonde factorization clears the denominators; and a checked
continuity argument admits collisions. This replaces reliance on the
source's exterior-algebra argument with an independently inspectable
kernel proof of its exact conclusion. The accompanying ordinary
argument and modular formal lemmas make the half exponents, agreement
bijection, ordered-group multiplicity, sign reversal, and
average-of-square-root distinction explicit. These are the technical
substance of the verification, not grounds for claiming a new Ising
theorem or a previously missing proof in the manuscript.

**Available formalization comparison.** The primary
`openai/math` document `lean/docs/218.md` describes its selected scope as
finite-graph buffered Ising likelihood comparison, and links
`lean/ComparatorChallenges/BufferedIsing.lean`. At the inspected revision,
`OAI.BufferedIsing.finite_graph_comparison` (lines 98-109) concerns real
couplings, external fields, pinned vertices, boundary mixtures and an
FK connection probability. It neither states the complex-point
Vandermonde identity nor its radial consequences. That comparator
statement ends in `sorry`; it is not used as certified evidence here,
and its placeholder is not a counterexample to any manuscript claim.
This establishes different coverage from the **selected comparator**,
not absence of every possible radial formalization elsewhere.

Mathlib v4.31.0 already supplies `Lagrange.coeff_eq_sum` under injective
nodes and degree less than the number of nodes, and
`Lagrange.leadingCoeff_eq_sum` when that number is degree plus one.
Their source proves these results from interpolation. They are the
existing primitives used by `Radial.lagrange_zero` and
`Radial.lagrange_one`; the finite-subset construction and subsequent
identifications are the campaign's additional formal development.

The comparison is deliberately bounded to the primary manuscript, its
named family-218 comparator, and these Mathlib primitives. The attempted
recursive repository path index reported `truncated=true`, so it
cannot support an exhaustive negative search. No claim of the first
formalization, globally new proof method, or literature-wide priority
has been established. In particular, `novelty_status=verified_new`
would require an additional independent finding; it is not warranted
by the source comparison alone.

Primary sources inspected:

1. OpenAI, *Conformal universality of bulk Ising correlations under weak
   interactions*, September 23, 2026:
   [radial source at the inspected revision](https://github.com/openai/math/blob/4eaee87548250b2682affda7d05d947c05554bae/preprints/Conformal-universality-of-bulk-Ising-correlations-under-weak-interactions-September-23-2026/build/sections/radial.tex).
   Locators: Lemma `rad:identity`, equations `eq:rad-vandermonde`,
   `eq:rad-agreement`, `eq:rad-plane-expansion`, and Proposition
   `rad:spectrum`.
2. OpenAI, [family-218 formalization scope at the inspected revision](https://github.com/openai/math/blob/4eaee87548250b2682affda7d05d947c05554bae/lean/docs/218.md),
   retrieved November 6, 2026; and
   [selected comparator at the inspected revision](https://github.com/openai/math/blob/4eaee87548250b2682affda7d05d947c05554bae/lean/ComparatorChallenges/BufferedIsing.lean),
   declaration `OAI.BufferedIsing.finite_graph_comparison`.
3. Kenny Lau, Wrenna Robson and Mathlib contributors,
   [Lagrange interpolation, Mathlib v4.31.0](https://github.com/leanprover-community/mathlib4/blob/v4.31.0/Mathlib/LinearAlgebra/Lagrange.lean),
   declarations `Lagrange.coeff_eq_sum` and
   `Lagrange.leadingCoeff_eq_sum`.

These are source-attribution and coverage comparisons, not unproved
external mathematical assumptions added to the proof.

## Scientific significance and the campaign completion question

The selected cancellation is load-bearing for the source's argument.
`radial.tex` lines 44-56 explains that the square-symmetric even
remainder must improve from dimension two to dimension three:
summing translated local terms costs two powers of scale.
The staged `renormalization.tex` lines 504-586 makes that dependence
explicit in Proposition `rg:linear`, with a quotient bound proportional
to `L^2(1+M)(CM/L)^3`. Checking the coefficient cancellation therefore
addresses a specific algebraic prerequisite for that contraction,
rather than an unrelated scalar identity.

Nevertheless, cancellation of a finite correlation coefficient is not
the radial operator theorem. Passing to spectral support requires
positivity and Hilbert-space arguments; uniform conditional averaging
also requires the source's soft-field norms, comparison and calibration
steps. None of those steps, the renormalization theorem, or the
weak-interaction/random-bond universality conclusions is certified by
this submission. No claim is made to audit all six family manuscripts.

The strongest prior result is already the reviewed, all-cardinality
theorem and its reviewed charge/Taylor consequences, not the finite
examples. This final submission makes no stronger mathematical claim.
It adds primary-source attribution, a bounded formalization comparison,
an explicit coverage statement and the link to the campaign objective.
The Lean source, fidelity documents, native certificate, exact
certificate, stored examples and replay code have not been changed
or rebuilt for presentation.

In the existing ledger, `C_RAD_VD` v2 has mechanical support and the
independent judgement `reviewer:copilot`; `C_RAD_CHARGE` v1,
`C_RAD_QUAD` v1 and `C_RADIAL_218` v1 have independent supporting
judgements on the ordinary proof and its stated limits. Those are
bounded mathematical reviews, not publication-level certification.
The unchanged fidelity document describes the original certification
state; the later supporting judgements are recorded in the ledger.
Route `R9000218_RADIAL_SUBMISSION` presents `C_RADIAL_218` as the
candidate verification contribution to the unchanged campaign claim
`C9000218` v1. A route records a proposal; it does not prove that the
candidate meets the campaign's acceptance boundary.

The proof graph therefore leaves `C9000218` open after the reviewed
radial obligations. The remaining decision belongs to the Host-invoked
independent Reviewer through the normal final research assessment:
does this precise, partly formal verification of an already proved,
load-bearing algebraic mechanism constitute a sufficiently original
and significant contribution at the preserved publishable target?
Neither a successful compiler run nor the label `complete_solution`
in the exact certificate answers that question; that label is scoped
to the radial mechanism. If the answer is no, the unmet obligation is
an original, publishable verification contribution, not another replay
of these identities. The Reviewer must identify the concrete scientific
deficit; this submission does not manufacture its resolution.
