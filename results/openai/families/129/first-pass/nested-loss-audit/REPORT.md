# Universal verification of the nested recurrent-class loss budget

## Result and scope

For arbitrary finite path diagrams, **`nest:absorption`,
`nest:containment`, and `nest:chain` are valid** with the manuscript's
finite-path, path-order, and signed-class conventions. In particular,
for every degree `m >= 1`, every finite nested idempotent chain
`b_0,...,b_k`, and every
`J_0 subset C_(b_0)` containing all `M_(b_0)(b_j)`,
\[
 \sum_{j=1}^k |\mathcal M_{b_{j-1}}(b_j)|\le 2|J_0|.
\]
`Main.lean` proves this universally, including the absorption,
recurrent-factorization, and whole-class containment steps. It does not
assume those manuscript-specific lemmas.

The official Lean 4.31.0 run returned `exit_code=0`, `proof_holes=[]`,
and a successful axiom audit. Mechanical evidence is attached to
`C_NEST_CHAIN` in the campaign ledger and archived under `certificates/`.
The only reported axioms are the ordinary classical Lean axioms
`propext`, `Classical.choice`, and `Quot.sound`. Independent review of
statement fidelity and mathematical significance remains required.

This is a **formal verification theorem**, not a counterexample, a proof
of either full exponential automata lower bound, or a novelty verdict.
No false assertion was identified in the three audited statements, so
no artificial `F_...` refutation claim has been introduced.

## Definitions and first-exit semantics

Let `X` be any finite label set and use two disjoint copies for the
positive and negative directions. A diagram has arbitrary relations
`F,B,L,R` of the four types specified in `diagrams.tex`. A product path
must stop at its first exterior exit. It may make arbitrarily many
internal crossings, but it must be finite.

Every forward product path first uses `F_a`, then makes a finite
number of alternating `L_b,R_a` returns, then uses `F_b`. Conversely,
each such finite witness is a valid product path. The other three
entry/exit choices give the backward and return formulas in
`diag:product`. Thus no infinite-path acceptance, crossing bound, or
determinism assumption enters the algebra. The formal source uses
these coordinate formulas directly. Its reflected version of the
right-return formula is proved identical to the displayed manuscript
formula by `product_R_matches`.

All compositions below are in path order, and star includes the
empty path. For a diagram `a`, write
\[
 K_a=(L_aR_a)^*,\qquad P_a=K_aF_aK_a,\qquad
 U_e(d)=K_eF_dK_e.
\]
The negative sign is obtained by reflection, exchanging `F,B` and
`L,R` and reversing diagram product order. Signed labels are never
identified with each other.

For an idempotent `a`, its forward product equation gives
`F_a K_a F_a=F_a`. Consequently `P_a^2=P_a`; recurrent points are
exactly the points with a `P_a` loop, and their mutual-reachability
classes are nonempty and pairwise disjoint.

The formal missing set is the collection of these classes containing
no `U_e(d)` loop. `uniform_loop` and `missing_iff_at` prove that this
agrees with testing any chosen point of the class, whenever the corner
absorptions hold. Those absorptions are proved, not assumed, for every
pair used in the chain.

## Absorption without an idempotency shortcut

Suppose `ed=de=d`. The return equations imply
`L_e subset L_d` and `R_e subset R_d`; hence `K_e subset K_d`.
Put
\[
 S=(L_dR_e)^*,\qquad T=(L_eR_d)^*.
\]
Then `K_e subset S,T subset K_d`, and the two forward equations are
\[
 F_eSF_d=F_d,\qquad F_dTF_e=F_d.
\]
The two useful return equations are
\[
 L_d=L_e\cup F_eSL_dB_e,\qquad
 R_d=R_e\cup B_eR_dTF_e.
\]

Finite-path induction proves both elementary identities
\[
 (A\cup B)^*=A^*(BA^*)^*,\qquad
 A(BA)^*=(AB)^*A.
\]
Expanding the right return and using these identities gives
\[
 K_d=S(L_dB_eR_dTF_eS)^*,\qquad
 F_eK_dF_d=(F_eSL_dB_eR_dT)^*F_d.
\]
The generator inside the last star is contained in `K_d`: its prefix
`F_eSL_dB_e` is contained in `L_d`, and `T subset K_d`.
Because `K_d` is already reflexive and transitive, the entire star is
contained in `K_d`. Therefore
`F_eK_dF_d subset K_dF_d`.

Expanding the left return instead gives
\[
 K_d=T(F_eSL_dB_eR_dT)^*,\qquad
 F_dK_dF_e=F_d(SL_dB_eR_dTF_e)^*.
\]
This generator is also contained in `K_d`, using
`B_eR_dTF_e subset R_d` and `S subset K_d`. Thus
`F_dK_dF_e subset F_dK_d`.

Adding the remaining outer `K_d` factors yields
`F_eP_d subset P_d` and `P_dF_e subset P_d`.
Finally `K_dP_d=P_dK_d=P_d` and `K_e subset K_d` yield
`P_eP_d subset P_d` and `P_dP_e subset P_d`.
Reflection proves the negative-sign assertions.

The Lean absorption declarations actually require only `ed=de=d`,
not idempotency of either diagram. Idempotency is needed later for
the recurrent-class arguments. This separation rules out a hidden
use of the containment or counting conclusion in the absorption proof.

## Finite recurrent factors and whole-class containment

The finite combinatorial fact used for rectangles is proved internally:
if a relation `Q` on a finite set satisfies `Q^2=Q`, every edge
`x Q y` factors as
\[
 xQp,\quad pQp,\quad pQy.
\]
To see this, idempotency allows repeated refinement of an edge into
two edges. Starting from an intermediate point between `x` and `y`,
choose an infinite sequence of refinements that stays between them.
Two sequence entries agree because the label set is finite.
Transitivity contracts the nonempty intervening path to a loop.
The retained endpoint relations give the required recurrent point.
The Lean proof implements this argument with a sequence and finite
pigeonhole, not an enumeration cutoff.

Apply this to `Q=F_eK_e`, which is idempotent because
`F_eK_eF_e=F_e`. Since `F_e=QF_e`, every forward edge of `e`
has a factorization
\[
 a(F_eK_e)p,\quad pP_ep,\quad p(K_eF_e)b.
\]
This is the recurrent rectangle factorization required by the nesting
argument. The full transport lemma is not assumed or certified here.
For completeness, `(F_eK_e)P_e=F_eK_e` and
`P_e(K_eF_e)=K_eF_e` follow directly from the same through identity.
Mutually `P_e`-related recurrent points therefore give identical two
rectangle factors. Thus passage from recurrent points to whole-class
rectangles does not change this cover.

Now fix `xP_dx`. Replacing `F_d` by `F_eSF_dTF_e` in its loop
and factoring the two displayed `F_e` edges produces old recurrent
points `p,q` and a witness
\[
 x\,\alpha\,p\,\beta\,q\,\gamma\,x,
\quad
 \alpha=K_dF_eK_e,\quad
 \beta=K_eF_dK_e=U_e(d),\quad
 \gamma=K_eF_eK_d.
\]
Here `beta subset P_d`. Combining the recurrence at `x` with the
proved through absorptions gives `xP_dp` and `qP_dx`. Transitivity
then gives `pP_dx` and `xP_dq`. In particular both old recurrent
points lie in the new recurrent class.

Every point of the entire old `P_e` class of `p` lies in that new
class: concatenate its two old-class edges with the new-class edges
and apply `P_eP_d,P_dP_e subset P_d`. The same holds for `q`.
If these old classes differ, the new class therefore contains two
whole old classes. If they agree, `qP_ep`, and corner absorption
`U_e(d)P_e subset U_e(d)` changes `pU_e(d)q` into a loop at `p`.
That whole old class is nonmissing. This proves the precise
containment dichotomy for both signs.

## The changing identities do not exhaust the same budget twice

Protect every label in every initial class outside `J_0`.
For each stage `j`, none of those initial classes is missing relative
to `b_0`; corner uniformity gives every protected label a loop in
`U_(b_0)(b_j)`.

The return inclusions telescope to `K_(b_0) subset K_(b_j)`.
The formal source also propagates the base-to-stage forward corner
absorptions by induction on the adjacent identities, rather than
assuming global nesting or diagram associativity as an additional
hypothesis. Therefore every protected label remains recurrent.
If a previous class contains a protected label, that label's loop in
`U_(b_0)(b_j)` is also a loop in `U_(b_(j-1))(b_j)`, so the class
cannot be missing at this step.

Let `s_j` be the number of unprotected classes at stage `j`, and put
`delta_j=|M_(b_(j-1))(b_j)|`. Then `s_0=|J_0|`, and all
`delta_j` missing classes are unprotected. Give an old unprotected
class weight one if it is missing, and weight two otherwise.
The total old weight is `2s_(j-1)-delta_j`.

Every new unprotected class contains weight at least two by the
proved containment dichotomy. All old classes it contains are
unprotected. Distinct new classes cannot use the same old class:
the old class is nonempty and the signed new classes are disjoint.
Summing the disjoint supports therefore gives
\[
 2s_j+\delta_j\le 2s_{j-1}.
\]
Telescoping, including the cases `k=0` and `J_0` empty, proves
\[
 \sum_j\delta_j+2s_k\le2|J_0|,
\]
and hence the required inequality.

## Exact adversarial checks and a nontrivial merger

The earlier finite checkpoint covered all 56 nested pairs in degree
one, 4,000 deterministic seeded sampled pairs in degrees two and three,
and 800 sampled chains. The universal Lean theorem is strictly stronger
than that checkpoint: neither the degree nor the chain length is bounded.
The finite agreement itself is not used as a proof.

`verify.py` separately implements coordinate multiplication and direct
reachability through entry nodes, stopping at exterior exits. It checks
idempotency and nesting against actual paths as well as against the
formulas. A retained degree-two chain specifically exercises a merger:
\[
\begin{array}{c|rrrr}
 &F&B&L&R\\ \hline
 e&9&1&0&0\\
 d&2&1&5&3\\
 z&0&1&5&3
\end{array}
\]
Here bit `2i+j` represents the edge `(i,j)` in a two-label relation.
Thus `F_e` is the identity; `B_e` fixes only negative label zero;
`F_d` is the single edge from positive zero to positive one;
`L_d` sends both positive labels to negative zero; and `R_d`
sends negative zero to both positive labels. `z` removes only `F_d`.

All three diagrams are idempotent and `z` is nested under `d`,
which is nested under `e`. The two old positive singleton classes
are both missing in `d`, yet `d` has one recurrent positive class
containing both labels. The protected negative singleton survives.
The next step loses the merged positive class. The losses are
`2,1` and the initial budget has size two: `3 <= 4`.
This is an exact construction **supporting** the stated dichotomy,
not a counterexample. It also shows why charging at most one loss
per initially missing class would be false.

The Jacobian adapter independently returned all sixteen idempotents of
the degree-one diagram semigroup. Its exact multiplication-table input,
typed operation contract, and unmodified typed output are retained in
`jacobian/`. This bounded operation is not credited with proving the
arbitrary-degree theorem.

## Reproduction and remaining review boundary

From the campaign root:

```bash
$WORKSPACE/argus-live-update/.venv/bin/python research/nested-loss-audit/verify.py
```

By default this recomputes the finite checks, validates the exact
Jacobian result and source-bound official archive, performs a fresh
Lean 4.31.0 compilation, checks the printed axiom dependencies, and
compares the mathematical output with `exact_certificate.json`.
It does not manufacture a new mechanical ledger verdict. A Reviewer
can additionally run the official `lean_evidence verify --claim
C_NEST_CHAIN` command to attach its fresh compiler run to the ledger.

`statement_fidelity.md` gives the declaration-level correspondence and
explicit limits. No external unproved literature theorem is an
assumption of this verification; the citation checker reported no
outstanding cited assumptions. The supplied wiki index contained no
applicable automata/nesting entry. The main dependency chains of both
manuscripts remain in the ledger and proof graph, with their unaudited
parts left open. In particular, this result does not transfer a
certificate to transport, amplification, automata encodings, or either
full lower-bound theorem.

Independent Reviewer replay and a judgement on statement fidelity,
novelty, and publishable significance remain outstanding. They have
not been replaced by the Engineer's compiler result.
