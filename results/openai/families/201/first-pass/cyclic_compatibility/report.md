# Cyclic compatibility: independent mathematical audit

## Scope and source fidelity

The target is `thm:cyclic-compatibility` in the staged September 23, 2026
manuscript, especially `lem:repeated-splitting`, `lem:limiting-columns` and
`lem:hub-nullspace`. The manuscript's main division-ring theorem and algebraic
lifting theorem are **not** conclusions of this local audit.

The source already gives the individual-hub/common-hub argument and a
directed-cycle trace test. Reconstructing those arguments is not a novelty
claim. The independent target is an exact loop-and-hub nullspace theorem
and an arbitrary-added-columns rank formula, followed by a universal
derivation of cyclic compatibility under explicit upstream assumptions.

The upstream assumptions are the admissible-evaluation and spectral-degree
statements in `formal-generic.tex`, the scalar response and specialization
identities in `responses.tex`, `prop:word-transfer` in `transfer.tex`, and the
stable rank bound and compatible dual relations in `global-defect.tex`.
They are manuscript assertions, not independently established results of
this mission. Their precise content is recorded against
`CC-RESOLUTION9000201` in `../MATH_STATE.json`.

The manuscript explicitly treats the singular partner in transfer by
`lem:killed-pole`; transfer must not be silently replaced by a generic
nonsingular statement. The common space in `global-defect.tex` comes from
`lem:common-tangent`, not from separate rank bounds.

Separate rank bounds cannot determine a common nullspace. A rank calculation
for the loop-and-hub matrix alone cannot establish that its relations
annihilate an added curve column. Finite successful examples cannot establish
the assertion for arbitrary repeat size and word length. These are excluded
proof shortcuts, not negative results about the manuscript.

No campaign-specific page was found in the supplied Wiki index using
`201`, `Kurosh`, `division-ring`, `spectral`, and `cyclic compatibility`.
No external novelty search has been performed. The contextual citations to
Procesi and Klep--Spenko are not imported as proof dependencies: the
trace-cycle assertion is proved directly below.

**Outcome:** a universal proof of the cyclic step under the five recorded
upstream assumptions, and a stronger abstract rank-rigidity theorem.
The universal algebraic hub core has a real Lean 4.31.0 compiler certificate
with no proof holes. The spectral specialization and trace-cycle arguments
below are mathematical proofs, not claimed Lean formalizations.
The executable diagnostics are exact but finite. No counterexample to the
stated cyclic theorem was obtained. Independent Reviewer approval,
significance and novelty assessment remain pending.

## 1. Exact assumptions and the statement being verified

Work over an infinite field E of characteristic zero. All tensor factors
below distinguish the old coefficient algebra, the scalar input factor,
and the new repeat factor. In particular, an input loop is in
M_b(E)^2 tensor M_L(E), not an arbitrary operator on the old coefficient
factor.

The following are inputs to this audit, not conclusions about the rest of
the manuscript:

1. **A-ADMISS:** the coefficientwise evaluations and determinant-cleared
   specializations specified in `lem:admissible-evaluation` are valid.
2. **A-SPECTRAL:** on all allowed sizes, e_n=dn/t with common t>0;
   independent generic blocks have disjoint semisimple spectra,
   rank-t root projections and nonzero loop differentials at every root.
   The minimal-polynomial bound deg(min W)<=e_n and the trace-Jacobian
   minor identities survive these admissible specializations.
3. **A-RESPONSE:** the loop and signed mixed-arrow Schur responses are the
   scalar responses D_h and m_h of `responses.tex`, including the
   determinant-cleared specialized versions.
4. **A-TRANSFER:** `prop:word-transfer`, with its stated singular-partner
   regularization, applies to the free and commuting Taylor inputs used
   here. Thus the first unsolved fixed-root Schur coefficients are scalar.
5. **A-GLOBAL:** b,a,g satisfy rho_b=a-g and rho_(bM)<=Ma-g for every
   M>=1. Selected coordinates identify each active space with E^a.
   With L_v=im(D_v) and H_v=E^a/L_v, the common space G has dimension g,
   maps isomorphically to every H_v^*, annihilates all pairs, and restricts
   isomorphically on deleting vertices. For each fixed generic arrow the
   joint pair annihilator is exactly the compatible graph, and both
   endpoint quotient maps are onto.

These are source-grounded **local-manuscript assumptions**, with exact
file/label locators in the claim ledger. They have no invented DOI or
arXiv identifier. `citation_check status` reports them openly as `uncited`,
not as independently authenticated literature theorems.

**Conditional verification theorem.** Under these assumptions, for every
m>=1, every ell>=1, every formal input pair Z with constant
diag(P_1,...,P_m) and all fixed-root Schur expressions zero below ell,
every c in G and every orbit O of **distinct** length-ell rotations satisfy

    sum_(omega in O) sum_(i,h selected) c_(i,h) e_(i,h,omega) = 0.

The assumptions of `global-defect.tex` and `transfer.tex` are not discharged
by proving this implication. Neither algebraic lifting, descent of all
corrections, generation-restoring translation, nor the main division-ring
theorem follows from this audit alone.

## 2. A universal hub-rigidity and rank theorem

Here is an abstract result independent of W and of any asymptotic rank
bound. It also explains precisely where such a bound is subsequently used.

Let there be m leaves and L+1 hubs, with m,L>=1: individual hubs p=1,...,L
and a common hub *. Every vertex v has coordinate space E_v=E^a,
loop image L_v, and an injective map

    p_v : G -> E_v^*,       im(p_v)=L_v^perp.

For each leaf i and hub q, write its fixed-arrow pair map as

    V -> (f_iq(V), f_qi(V)) in E_i direct_sum E_q.

Assume its annihilator among loop-annihilating covectors is exactly

    {(p_i(c),p_q(c)): c in G}.                         (2.1)

For each leaf i and selected label h let Pi_(i,h,j), j in a finite set J,
be nonzero mutually orthogonal idempotents in M_L(E) summing to I_L.
Neither |J|=L nor rank one is needed for this abstract result.
The manuscript application has |J|=L and rank-one idempotents.

Define A_0 to consist of the following columns, with leaf rows (i,h,j)
and hub rows (q,k):

* Leaf loops: D_i(Y)_h tr(Pi_(i,h,j) T), for all Y and T.
  Hub loops are D_q(Y).
* Individual-hub reverses (i,p,r,V): leaf entries
  f_ip(V)_h tr(Pi_(i,h,j) E_pr); hub-p entries
  delta_pr f_pi(V)_k.
* Common-hub reverses (i,*,r,V): leaf entries
  f_i*(V)_h tr(Pi_(i,h,j) sum_p E_pr); hub-* entries f_*i(V)_k.

It suffices to include bases of all the finite direction spaces.
Let R=(m|J|+L+1)a be the number of rows, equal to (mL+L+1)a in the
manuscript application. Define the lift

    Phi(c)_(i,h,j)=p_i(c)_h,    Phi(c)_(q,k)=p_q(c)_k.

**Theorem 2.1.** With g=dim(G),

    ker(A_0^transpose) = Phi(G),     rank(A_0)=R-g.     (2.2)

For any additional q columns C, define

    Theta_C : G -> E^q,    c -> C^transpose Phi(c).

Then

    rank[A_0 C] = R-g + rank(Theta_C).                 (2.3)

Consequently an upper bound rank[A_0 C]<=R-g is equivalent to saying
that **every** compatible relation annihilates **every** added column.
It is not enough to know rank(A_0)<=R-g.

### Proof of the exact nullspace

Let (mu,nu) annihilate A_0 and put

    T_(i,h) = sum_j mu_(i,h,j) Pi_(i,h,j).

For each i, leaf-loop annihilation says

    sum_h D_i(Y)_h tr(T_(i,h) T)=0          for all Y,T.

The trace pairing on matrices is nondegenerate: testing T=E_pr reads
the (r,p) entry. Thus, for each r,p, the vector

    x_(i,r,p) = ((T_(i,h))_rp)_h

annihilates L_i. The hub-loop equations likewise put nu_q in L_q^perp.
No transpose or positive-definite inner product is used here:

    tr(T E_pr)=T_rp.                                  (2.4)

For r!=p, the individual-hub equation says that
(x_(i,r,p),0) annihilates the pair map. By (2.1) it equals
(p_i(c),p_p(c)) for some c. Injectivity of p_p forces c=0, so
x_(i,r,p)=0. Equivalently, every T_(i,h) is diagonal. This is also
the endpoint-surjectivity argument in the manuscript.

For r=p, (2.1) identifies x_(i,p,p) with the compatible functional
paired with nu_p. The common-hub equation has leaf covector

    sum_p x_(i,r,p)=x_(i,r,r).

It pairs every one of these diagonal covectors with the *same* nu_*.
Injectivity of p_* therefore gives one c in G, independent of r and i,
with x_(i,r,r)=p_i(c). The individual diagonal equations then give
nu_p=p_p(c) for every p, and nu_*=p_*(c). Hence

    T_(i,h)=p_i(c)_h I_L.

Multiplying this identity by any Pi_(i,h,j) gives
(mu_(i,h,j)-p_i(c)_h) Pi_(i,h,j)=0. The projector is nonzero, so
mu_(i,h,j)=p_i(c)_h. This proves inclusion in Phi(G) and uniqueness.

Conversely, for the lifted weights Phi(c), completeness gives
T_(i,h)=p_i(c)_h I_L. Leaf and hub loops vanish because p_v(c)
annihilates L_v. An individual reverse column pairs to

    delta_pr (p_i(c)(f_ip(V)) + p_p(c)(f_pi(V))) = 0.

A common reverse column pairs to the analogous expression without
delta_pr, since tr(sum_p E_pr)=1, **not L**. Both vanish by (2.1).
Thus Phi(G) is the entire nullspace, and Phi is injective.
This proves (2.2).

Finally,

    ker([A_0 C]^transpose) = Phi(ker Theta_C).

Rank-nullity gives (2.3). This proves the theorem without assuming any
differential rank bound. It covers g=0 and L=1 without an exceptional
argument; when L=1 there simply are no off-diagonal entries to eliminate.

### What Lean checks

`Main.lean` formalizes the entry-rigidity proof for arbitrary nonempty leaf
and finite repeat types over **any field**, the converse canonical lift,
and recovery of weights from nonzero orthogonal idempotents.
`hub_projector_rigidity` does not assume a rank bound or rank-one or symmetric
projectors, or a common eigenbasis across different labels.
The predicates in the formal theorem are the componentwise loop and pair
annihilator conditions just displayed; their exact-pair-graph hypothesis
is explicit, not proved about W by the compiler.

The real compiler run returned success, exit 0, no proof holes, and an empty
diagnostic stream. Its archived claim-bound certificate is recorded in
`lean_verify_output.json`; the statement's reading is documented in
`statement_fidelity.md`. Equation (2.3), the spectral arguments below and
the interpretation of the abstract predicates are not separately
formalized. They are proved in this report and require human review.

## 3. Repeated splitting, including the singular specialization

Fix arbitrary L>=1 and arbitrary S_1,S_2 in M_L(E). Substitute
s_c=delta S_c. This respects products and inverses with invertible constant
term coefficientwise; the repeat matrices commute with the old coefficient
and input factors. Transfer gives the leading Schur matrix on the entire
repeated (i,h) root cluster as

    delta^ell (I_t tensor B_(i,h)), where
    B_(i,h)=sum_(|omega|=ell) e_(i,h,omega) S^omega
             +D_(i,h)(Y_i).                           (3.1)

Here the added input loop is delta^ell Y_i, and D acts entrywise on the
repeat factor. It introduces no lower-degree term.

For every old root h, D_(i,h) is a nonzero scalar functional. Consequently
its entrywise extension is onto M_L(E), so the discriminant of B_(i,h)
is a nonzero polynomial in the coordinates of Y_i. The product of these
finitely many polynomials is nonzero, even though different labels share
the same loop variables. Over the infinite field it has a nonvanishing
evaluation. Choose loops making **all** old-root slope matrices simple,
not only the selected ones. For L=1 the condition is automatic.

First separate distinct old roots by a formal output conjugation equal to
identity modulo delta; recursively the off-diagonal equations divide only
by nonzero old-root differences. To check the leading term precisely,
write M=W-lambda in the fixed root/complement decomposition and let F be
the separated root block minus lambda. Its invariant columns are (Q,R)^T,
with Q=I+O(delta), R=O(delta), and

    M (Q,R)^T = (Q,R)^T F.

Eliminating the complementary row gives the exact identity

    (M_11-M_12 M_22^(-1) M_21) Q
        = (Q-M_12 M_22^(-1) R) F.                     (3.2)

Both outer factors reduce to identity. Hence F has no term below ell and
its degree-ell term is I_t tensor B_(i,h). Using just the compression M_11
instead of the Schur expression would not justify this conclusion.

After division by delta^ell, the separated cluster has constant term
I_t tensor B_(i,h). Over a finite splitting extension, its distinct slopes
theta_(i,h,j) can again be separated by integral formal conjugations,
now dividing by their nonzero differences. There are exactly

    m L e_b = e_(bmL)

nonempty resulting blocks, each of size t. Their minimal polynomials over
E((delta)) are pairwise coprime. For different old roots this follows
already at order zero. Within one old root it follows after the affine
change x -> (x-lambda)/delta^ell, because the slope reductions are distinct.
The minimal polynomial of the direct sum therefore has degree the sum of
the individual degrees. The specialization-stable upper bound is e_(bmL);
each of the e_(bmL) nonempty blocks contributes at least one.
Every block consequently has degree one and is scalar.

Thus, for all i,h,j, not just selected h,

    lambda_(i,h,j)(delta)
       =lambda_(i,h)+delta^ell theta_(i,h,j)+O(delta^(ell+1)).

The conjugations and their inverses are integral. The resulting projections
are integral and reduce to pi_(i,h) tensor Pi_(i,h,j).
The Pi's have rank one, are mutually orthogonal and sum to I_L.
The original multiplicity remains t; no t-fold extra repeat weight appears.

This proves the repeated-splitting step universally from the stated
upstream assumptions. In particular, it does not presume that a projector
is regular merely because a limiting matrix is semisimple: the two
explicit separated constant-term problems provide the integral conjugations.

## 4. Limiting derivative columns and the augmented rank

Adjoin L+1 independent generic size-b hubs, with spectra disjoint from all
old roots and from one another. All of these choices are made after fixing
the original substitution, matrix tests and loops. For each of the finitely
many leaf-hub pairs, choose a fixed arrow in the nonempty generic set where
the exact quotient-pair hypotheses hold. Simultaneous choices exist because
there are only finitely many nonzero minor conditions.

At delta!=0 regard the **whole** leaf array as one block. The input is a
star, ordered with this leaf array before the hubs. It has

    N=mL+L+1,        e_(bN)=N e_b

distinct scalar roots over the Laurent field. A loop derivative or a
reverse-arrow derivative can be computed by differentiating traces:
a closed block path using the derivative of a reverse arrow has exactly
one matching forward arrow. A second hub visit would require a second
reverse step, which is absent. Thus the two-block signed Schur response
formula applies with the entire leaf array as its first block. The
trace-to-root Vandermonde change of coordinates is invertible over the
Laurent field; it need not be a unit at delta=0.

For a leaf root branch, the derivative is tr(P dW)/t. The projection P
is integral by Section 3. At delta=0 the derivative of a leaf loop
Y tensor T compresses to D_(i,h)(Y) I_t tensor T. Consequently its limit is

    D_(i,h)(Y) tr(Pi_(i,h,j) T).

The trace over the multiplicity space contributes t, canceled by division
by t. There is no factor t or 1/L left over. Hub loops give their ordinary
responses, and loops at one diagonal block do not affect other roots.

For a reverse derivative from repeat position r to individual hub p,
the leaf-end Schur inverse is on the hub at a leaf root. Its reduction
is invertible. At the hub end the inverse is on the entire leaf array
at a **hub** root, also invertible on reduction. Neither calculation
inverts a difference between two coalescing leaf roots.
All the other response factors are regular by admissibility.
Thus products, inverses with nonzero reduced determinant, and traces
can be reduced coefficientwise.

Writing e_p for a repeat column and e_r^T for the reverse row, the leaf
repeat product is e_p e_r^T=E_pr, whereas the hub product is
e_r^T e_p=delta_rp. Their limits are therefore exactly

    m_(i,h)(P_i,Q_p;U,V) tr(Pi_(i,h,j) E_pr),
    delta_pr m_(p,k)(Q_p,P_i;V,U).

For the common hub the forward repeat column is the all-ones vector u.
The products are u e_r^T=sum_p E_pr and e_r^T u=1.
This proves both the orientation and the **single**, rather than L-fold,
common-hub contribution.

Along the complete input curve, hubs and forward arrows are constant.
The chain rule places its derivative in the input-Jacobian column span
over E((delta)). Scaling by delta^(1-ell) is allowed in that field.
Section 3 gives its finite limits as

    ell theta_(i,h,j) on leaves, and 0 on hubs.        (4.1)

Scaling is essential for ell>1: the unscaled limit would be zero.

Select all L branches of each selected old root and the a selected roots
of each hub, giving R=Na rows. For the full root Jacobian the trace-minor
identities and A-GLOBAL give rank<=rho_(bN)<=Na-g.
The selected Jacobian and every finite matrix of its column combinations,
**including the scaled curve**, satisfy this bound over the Laurent field.
All the columns just computed are integral. Every (Na-g+1)-minor therefore
specializes to zero, proving the same upper bound for the limiting matrix.

This is the only upper-semicontinuity step needed. It gives an upper rank
bound, not preservation of a nullspace. The latter is supplied separately
by Theorem 2.1, so a hidden specialization-induced loss of compatible
relations is not being assumed away.

## 5. All compatible relations survive the curve test

The non-curve limiting columns are exactly A_0 of Section 2, using the
extended compatible space on old blocks and hubs. Their left nullspace is
already exactly Phi(G), of dimension g, before using a rank inequality.
Apply (2.3) to the one extra column (4.1).
Section 4 bounds its augmented rank by R-g, so its obstruction map is zero:
for **every** c in the original G, extended uniquely to all hubs,

    0=ell sum_(i,h,j) c_(i,h) theta_(i,h,j)
      =ell sum_(i,h) c_(i,h) tr(B_(i,h)).

Characteristic zero allows cancellation of ell. This proves precisely
the manuscript's full-g-dimensional nullspace statement, not merely
existence of some surviving relations.

To remove auxiliary loops, expand each allowed input loop as a finite sum
Y_i=sum_alpha Y_(i,alpha) tensor T_(i,alpha). Then

    sum_h c_(i,h) tr(D_(i,h)(Y_i))
      =sum_alpha tr(T_(i,alpha))
                    sum_h c_(i,h) D_(i,h)(Y_(i,alpha))=0,

since c_i annihilates the loop image. Thus for every repeat size and every
pair of test matrices,

    sum_(|omega|=ell) a_omega(c) tr(S^omega)=0,
    a_omega(c)=sum_(i,h) c_(i,h)e_(i,h,omega).           (5.1)

Although the chosen auxiliary loops depend on the test matrices, their
contribution vanishes identically; no uniform choice is needed.
The finite splitting extensions do not weaken the conclusion: the
resulting scalar relation is defined over the original coefficient field,
whose map to its extension is injective.

## 6. Distinct rotations and all word lengths

Fix any word w=c_0...c_(ell-1). On ell vertices modulo ell put

    S_c=sum_(j:c_j=c) E_(j,j+1).

An entry of a matrix product is the sum of the weights of its directed
paths. From each starting vertex this labeled directed cycle has exactly
one length-ell path, returning to that vertex. Its label is the rotation of
w beginning there. Hence the trace of S^omega counts exactly the starting
vertices giving omega. It is zero outside the orbit O of distinct rotations.
For each omega in O, the starting-vertex fiber has size

    |Stab(w)|=ell/|O|.

Indeed the rotations form a cyclic group of order ell; two starting
vertices give the same word exactly when their difference stabilizes w.
This proves equal positive integer multiplicity for **each distinct word**,
also for periodic and constant-letter words and ell=1.
For example `1212` has two distinct rotations, each trace equal to two.

Substituting in (5.1) gives

    (ell/|O|) sum_(omega in O) a_omega(c)=0.

The integer is nonzero in characteristic zero, so the required distinct-word
orbit sum vanishes. This completes the conditional verification theorem
for every ell and m. Conversely, cyclic orbit sums imply all trace tests
by tr(AB)=tr(BA); that identity follows immediately by summing A_rs B_sr.
Thus the cycle test introduces neither a missing orbit nor a spurious
commutative identification of different free words.

## 7. Exact diagnostics and their limits

Run from the campaign root:

    python3 research/cyclic_compatibility/verify.py

The executable needs Python 3 and SymPy. It uses no random numbers, network
access, floating-point arithmetic, Sage service, or Jacobian installation
for replay. The archived Jacobian response is independently replayed using
standard-library `fractions.Fraction` row reduction.

`exact_certificate.json` records:

* Nine exact abstract hub models, including g=0, L=1, g=2, L=4, and
  noncommuting eigenbases at different labels; it checks the exact
  nullspace dimension and the arbitrary-added-columns rank formula.
* A direct commutator-polynomial response model W=z1*z2-z2*z1 with
  b=2, L=2, a=2, g=1. The ten-row matrix of 104 actual loop and pair
  columns has rank nine; its scaled ell=2 curve preserves nullity one.
  These explicit rational points are **not independent generic points**,
  so this is a diagnostic of the formulas, not an admissible counterexample
  to the manuscript.
* Rational-function Schur and projector identities for ell=1,2,3,
  with a nonconstant integral output conjugation and nonsymmetric
  projectors. These check 30 paired-column limits, four loop limits,
  projector integrality, the curve scaling and normalization by t=1,2,3.
  The ell=3 control detects that naive compression has a nonzero
  degree-two term which the correct Schur expression cancels.
* 21,844 actual word/matrix trace comparisons for all binary directed
  cycles and all test words through length seven, with periodic words
  counted by distinct rotations.
* Negative controls: deleting the common hub can leave two independent
  repeat-position weights instead of g=1; an incompatible curve can raise
  a five-row model's rank from four to five; equal separate ranks need not
  bound the collective span. These refute weakened hypotheses, **not**
  the stated manuscript theorem.

The bounded Jacobian call was `matrix.nullspace.compute` on the transpose
of a five-row model with a compatible ell=2 curve. Its exact payload,
typed output, protocol `2025-11-25`, server version `0.14.0`, and successful
adapter status are preserved in `jacobian.*.json`. It returned rank four,
nullity one and the all-ones kernel vector. The inspected operation accepts
finite rational matrices, not a universal arbitrary-size assertion; it is
used only for that matching finite postcondition.

The verifier additionally checks that the real successful Lean result
still matches both `Main.lean` and its fidelity document, and that mechanical
evidence was recorded against `CC-FORMAL-HUB9000201`. It does **not** invoke
Lean again. To perform a new compiler run and record it through the official
producer, use the authorized interpreter:

    $WORKSPACE/argus-live-update/.venv/bin/python -m argus_skill.verticals.math.lean_evidence verify research/cyclic_compatibility/Main.lean --statement-fidelity research/cyclic_compatibility/statement_fidelity.md --artifact-dir research/cyclic_compatibility --project-root campaigns/9000201 --claim CC-FORMAL-HUB9000201

No certificate claims exhaustive testing at arbitrary size. Universality
comes from the proofs in Sections 2--6, with the precise abstract algebraic
core kernel-checked as described in the fidelity document.

## 8. Improvement over the source and remaining frontier

The source proves injection of the augmented nullspace into G, then uses
the augmented rank bound to recover surjectivity. Theorem 2.1 instead
identifies the **non-curve** nullspace exactly without any rank bound and
quantifies the entire rank defect after adding **arbitrarily many** columns.
This distinguishes a correct hub calculation from the separate,
indispensable claim that the curve lies within the global rank cap.
Its projector-weight argument needs only nonzero orthogonal idempotents,
not rank-one or symmetric ones. This is a structural strengthening of the
local argument, not a new Kurosh counterexample and not a verified novelty
claim.

The unresolved manuscript frontier is explicit in `PROOF_GRAPH.json`:
admissibility and spectral bounds, scalar-response specialization, transfer,
active-space linkage and the global compatible-relation construction,
then eleven-block correction, central descent, generation restoration and
the actual-center application. This audit resolves the cyclic implication
**assuming its recorded inputs**, rather than silently certifying those
inputs. All public Reviewer flags remain false pending the normal
independent review path. The overall campaign remains incomplete.
