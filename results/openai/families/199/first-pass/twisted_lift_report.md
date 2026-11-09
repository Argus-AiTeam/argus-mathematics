# Exact audit of the twisted two-cone lift

## Question and scope

The literal target is Lemma `coc:data` and Proposition `lift:main` of
*An explicit counterexample to the Auslander--Reiten conjecture*,
September 23, 2026. The field is
`k = F_2(q,H_1,H_2)`, with three algebraically independent variables.
The lift proposition quantifies over **every** `H` in `k^*`, not just
`H_1,H_2`. The staged sources are unchanged.

The finite calculation must use all 179 listed cochain values, all zero
values, the dual bimodule actions, and the relative-bar endpoints. An
initially successful finite calculation does not establish an all-degree
lift. The separate remaining obligations are the homotopies, their
passage to projective tails, and nonfactorization of the evaluated map.

There was no earlier mathematical result in the campaign ledger to
strengthen: the initial claim and graph were open. The supplied Wiki index
contained no relevant family-199 entry. The two manuscript dependency
extractions are source reading, not independent mathematical verification.

## Source facts and outstanding manuscript claims

In the AR manuscript, `03-algebra.tex` specifies the ten-dimensional
algebra `C`, the dual actions, `T=C lt DC`, and the relative bar resolution
`P`. Lemma `coc:data` asserts endpoint/weight compatibility, cocycle
closure, nonzero evaluation on
`q^2[t|x|J]+[t|y|J]`, and the twisted boundary identity.
`09-cochain.tex` is the complete data, including its zero convention.

`04-resolution.tex`, Lemmas `res:base`, `res:polynomial`, and `res:tensor`,
assert the all-degree polynomial self-extension algebra.
`05-cones.tex`, Lemma `cone:finite` and Proposition `cone:profile`, assert
the finite side-projective cone representative and its full stable Hom
profile. These are distinct from the present finite-data obligation.
`06-lift.tex`, Lemmas `lift:B`, `lift:G`, and `lift:evaluation`, feed
Proposition `lift:main`. `07-branches.tex`, `branch:finite-fiber`,
`branch:profile`, and `branch:comparison`, feed `conv:proposition` in
`02-conversion.tex`, and then `thm:main`. The last theorem and the
consequences/base-change claims are not automatically certified by a
certificate for the lift.

The companion Tachikawa manuscript has a different lift argument.
Its `a:table`, `a:dual-dimensions`, and `a:resolution` feed
`e:polynomial`, `e:all-degrees`, `e:socle`, and `e:twists`.
Those feed `b:bimodule`, including `b:trace-obstruction`,
`b:stable-adjunction`, and `b:evaluated-lift`.
Next `t:comparison-maps`, `t:finite-module`, and `t:vanishing` feed
`tr:transfer` and `thm:main`. The transfer needs self-Hom vanishing in
degrees `a > 0` **and** `a <= -2`; the remaining group at `a=-1` is
intentional. The AR lift certificate does not verify this companion chain.

No external theorem is presently being used as an unproved assumption
in the finite calculation. The trace-coevaluation and stable
nonfactorization arguments below will be proved directly, rather than
accepted solely from the manuscript's Broue/Linckelmann citations.
The other manuscripts' cited results remain within unverified source
claims, not silently adopted assumptions of the audit theorem.

## Exact finite calculation

`verify.py` parses the multiplication equations and all table entries
directly from the staged LaTeX. Polynomial coefficients are bit vectors
in `F_2[q]`: addition is XOR and multiplication is carryless polynomial
multiplication. No numerical specialization, floating-point operation,
random search, or finite-field sampling is used.

The complete calculation has **zero failures**:

| Obligation | Exact scope |
|---|---|
| Cochain data | 179 distinct inputs: 20 coefficients `q^2`, 123 `q`, 4 `q^3`, 32 `1` |
| Algebra associativity | All `20^3 = 8000` basis triples |
| Trace-dual pairing | All 400 basis pairs |
| Positive grading and the simple character | All 400 product pairs for each |
| Cocycle equation | All `18^4 = 104976` radical four-words, including 15250 composable words |
| Twisted boundary | All 324 input pairs, with formal constant and linear coefficients in `H` |
| Twisted Casimir identity | All 20 basis letters |
| Radical endpoint and augmentation | Both vertices |
| Projected Casimir identity | All 18 radical letters, coefficientwise as Laurent polynomials in `H` |
| Displayed cycle | Boundary zero, evaluation exactly `q^3 f` |

The algebra has **12** listed non-idempotent products: the source's
`xu=yu=v` specifies two products, not one. This is a parsing detail,
not a flaw in the manuscript.

The positive grading is `deg(u)=deg(t)=1`,
`deg(x)=deg(y)=deg(n)=2`, `deg(v)=deg(j)=3`, `deg(z)=4`,
and `deg(a^*)=5-deg(a)`. Every non-idempotent basis vector of `T`
has positive degree at most five. Thus their span is a nilpotent ideal,
its sixth power is zero, and its quotient is `k e + k f`.
This verifies the asserted radical rather than presupposing it.
The checked trace-dual pairing is the identity matrix after starring
one basis, so the trace is nondegenerate. Its symmetry follows from the
trivial-extension product, or the same pairing.

The cochain is extended by zero on unlisted inputs. Endpoint and weight
checks cover every nonzero entry; associativity and endpoint compatibility
make the other relative-bar equations meaningful. Nevertheless the
verifier evaluates all 104976 four-words, not just the composable ones.
It computes all five terms of the Hochschild differential.

For the boundary calculation, `z_H(a)=H gamma_a a`,
where `gamma_a=q` on the nine specified letters and zero otherwise.
For a basis output `v`, the right side is

```text
H gamma_b mu_ab^v + H gamma_v mu_ab^v
    + H^(1-epsilon_b) gamma_a mu_ab^v.
```

The left side is computed directly from `p(a,b,w) w^*`, with its
factor `H^epsilon_w`. Only exponents zero and one occur. Therefore
the result is an identity of polynomials, and substituting any
`H in k^*` is legitimate, including rational functions in all three
field variables. There is no assumption that this particular `H`
is transcendental or independent.

Finally the two bar words are composable with endpoints `(f,f)`.
The simple character kills all outer radical terms. The two internal
boundary terms cancel exactly, and
`q^2 p(t,x,J)+p(t,y,J)=q^3 f`. A coboundary pairs to zero with a
cycle. Since `q` is transcendental, this proves the required nonzero
evaluation in `Ext_T^3(s,s)`.

### Jacobian boundary

Jacobian discovery reported server `0.14.0`, MCP protocol `2025-11-25`.
The inspected operation was `modular.polynomial_identity.compute`.
One bounded call attempted the `j` coefficient of the `(t,y)` boundary
equation, namely `q^3 H = q^3 H`.
The operation's validator rejected the uppercase variable name `H`
as noncanonical (`INVALID_REQUEST`, adapter exit code 2).
The exact payload, structured error, protocol and server version are
preserved in `exact_certificate.json`. This call is **not mathematical
evidence**, and no successful Jacobian verdict is claimed. There was no
automatic retry. The full identities above were established by the
independent exact polynomial calculation, not by this failed call.

## All-degree argument

### Verification theorem

Over the literal field `k=F_2(q,H_1,H_2)`, with the algebra, cochain and
bar conventions of the source, Lemma `coc:data` holds. For **every**
`H in k^*` there is the stable bimodule map of Proposition `lift:main`,
with precisely its specified top projection. Its evaluation is nonzero
modulo projective factorizations. This theorem does not require the
polynomial self-extension calculation or the full cone Hom profile.

Here is the all-degree proof, separately from the finite verification.

### 1. The augmented bar complexes and finite cones

Put `I=k e + k f`, `r=rad(T)`, and
`P_i=T tensor_I r^(tensor_I i) tensor_I T`.
The usual multiplication differential squares to zero by associativity
and characteristic two. Its augmented complex has the contraction
which projects the first outer coefficient to `r`, inserts that
projection as a first bar, and puts the appropriate idempotent in
the new outer coefficient. In augmented degree it sends `a` to `1[]a`.
Expanding `d sigma + sigma d`, all consecutive multiplications cancel;
the omitted `I` component is precisely the balancing relation over `I`.
Thus this is an exact augmented complex in all degrees. The contraction
is right `T`-linear; it need not be bimodule-linear for exactness.

Each bar term is a finite direct sum of `T i tensor j T`, hence
projective as a bimodule. Twisting the right action by `h_H` is an
exact equivalence, so the source complex `Q=P_h` is likewise a
projective bimodule resolution of `T_h`.
The checked cocycle identity makes the suffix formula `p:P->P[3]`
a chain map: prefix multiplications cancel and the remaining five
terms are precisely its Hochschild differential, in every length.

In the external product of two cones, the four cells are
`Ptot`, two copies of `Ptot[-2]`, and `Ptot[-4]`.
Their homology is concentrated in degrees `0,-2,-4`; hence the cone
`K` is exact in every positive degree.
Its high cokernel filtration has factors which are syzygies of `A`.
These syzygies are projective on either `A`-side: the augmented
resolution starts with the side-projective regular module and its
surjections split on each side, inductively.
The filtration extensions also split on each side.
Thus the stable tail `Ccal=<K>` has a finite side-projective
representative, as required in the statement.

For completeness, shifting this representative does not require an
infinite module. Over the symmetric `A^e`, take a finite projective
surjection for a syzygy and a finite projective-injective embedding
for a cosyzygy. Their sequences split on each `A`-side, using
side-projectivity and side-injectivity respectively. The resulting
finite representatives remain side-projective.

### 2. The twisted Casimir and the universal `B` homotopy

Let `xi_H=sum_w h_H(w) tensor_I w^*`, with all twenty letters.
The exact checks prove

```text
h_H(a) xi_H = xi_H a,
pi(xi_H) = 0,
sum_(w radical, left(w)=r) h_H(w) w^* = r^*.
```

These are identities in formal `q,H`, not observations at selected
values. The middle equality also follows from the even row and
column dimensions `(6,4)` of `C`. Consequently
`b:T_h -> ker(pi)` given by `b(x)=x xi_H` is a bimodule map:
`b(x h_H(a))=b(x) a`.

For every `i>=0`, define the source's `B_i` by appending
`h_H(w)` and multiplying the right coefficient by `w^*`,
retaining composable terms. Extend a bar generator by
`a_0 B_i(generator) h_H^(-1)(a_(i+1))`, exactly as in the source.
This is well-defined and bimodule-linear, since `h_H` fixes `I`
and all terms have the prescribed endpoints.

For a radical letter `a` with right vertex `r`, the finite projected
identity checked by the script is

```text
sum_(w radical) a h_H(w) tensor w^*
 + sum_(w radical) h_H(w) tensor w^* h_H^(-1)(a)
 = a tensor r^*.
```

In `dB_i+B_(i-1)d`, every multiplication strictly before the old
last bar occurs twice and cancels. For `i>0`, the two remaining
terms adjacent to the old last bar combine by this identity to
the prefix followed by `[a] r^*`. The final multiplication in
`dB_i` is exactly the same expression by the endpoint identity,
so it cancels too.
For `i=0`, the final multiplication instead restores the omitted
idempotent term of `xi_H`, and gives `b epsilon`.
Thus, with `B_(-1)=0`,

```text
dB+Bd = D_b
```

holds for **every** nonnegative degree, where `D_b` is `b epsilon`
in degree zero and zero elsewhere. This is a length-independent
cancellation argument, not an extrapolation from finitely many lengths.

### 3. The all-degree `G` homotopy

Since `p` is a chain map and `pD_b=0`, `pB` is a degree-two
chain map. Its augmentation in source degree two is exactly
`sum_w p(a,b,h_H(w))w^*`.
The checked boundary identity identifies this with `z'd`, where
`z'([a])=z_H(a)` with the stipulated twisted extension.

Choose a bimodule lift `G_1:Q_1->P_0` of `z'` through the
surjective augmentation and set `G_0=0`.
The residual `(pB)_2+G_1 d` is in the augmentation kernel.
Exactness of `P` and projectivity of `Q_2` give `G_2` with
`dG_2=(pB)_2+G_1d`.
Inductively, if the equations hold below degree `i>=3`, then

```text
d((pB)_i+G_(i-1)d)
 = (pB)_(i-1)d + ((pB)_(i-1)+G_(i-2)d)d
 = 0.
```

Therefore exactness and projectivity give `G_i` as a bimodule map.
The equations in degrees zero and one are zero for index reasons.
This constructs a single family satisfying `pB=dG+Gd` in all degrees.
There is no uniform finite cutoff to choose and no inverse limit or
compactness assumption.

`Main.lean`, declaration `augmented_nullhomotopy`, formalizes precisely
this infinite induction for arbitrary module families, using actual
`Module.Projective`, exactness and a boundary at the augmentation.
It is not a finite test of the induction. The index translation is
spelled out in `STATEMENT_FIDELITY.md`.

### 4. Tensor cancellation, tails, and the prescribed top projection

Let `V=B tensor D_b`. Its equation is

```text
dV+Vd = D_b tensor D_b = beta_H epsilon_tot.
```

In degree zero this says `dV_0=beta_H epsilon_tot_0`; in positive
degrees it is the ordinary comparison equation for the truncated
resolution of `Omega A`. Thus `V` represents the actual map
`beta_H=b tensor b`, not merely a map with a similar evaluation.

In the top cell of `K[3]` put `B tensor D_b`; in the singleton
cell `{2}` put `G tensor D_b`; put zero in the other cells.
Deleting slot 1 from the top cell contributes `pB tensor D_b`,
which the singleton's differential cancels by the preceding
homotopy. Deleting slot 2 gives zero, since `pD_b=0`, also for
the singleton correction. The only remaining chain defect is
`D_b tensor D_b`, supported in total source degree zero.
This proves the tail-map equation in every positive total degree.

Take a common cokernel index `N>=4`. The source and target are
exact above this index. The chain equation at `N+1` makes the
map descend to cokernels. The exact sequences

```text
0 -> c_(N+1) -> V_N -> c_N -> 0
```

identify successive cokernels as syzygies in the stable category.
Shifting back by `N` therefore gives
`f_H:U_H -> Ccal[3]`, independently of increasing the common
index. Its top-cell component is still `V`, whose comparison
augmentation has just been identified with `beta_H`.
Hence its stable top projection is exactly the one stated in
`lift:main`.

### 5. Evaluation and stable nonfactorization

The sequence defining `Omega A` splits as a right `A`-module
sequence because its quotient is the regular module `A`.
Consequently tensoring it with `X` preserves exactness. In one
slot, `P_0 tensor_T s` is `Tf`. The only term of `xi_H` whose
right coefficient survives on `s` has `w^*=f`, namely `w=F`;
its value is `H F`. The external square consequently gives

```text
beta_H X(1) = H^2 (F tensor F)
    in rad(A)(f tensor f) = Omega X.
```

The original cover evaluates to `A(f tensor f)->X`.
Every sequence used to implement stable shifts and the finite
cone representative is right-split. Evaluation therefore preserves
those shifts and maps as well. This does **not** assume that `X`
is flat. Projective bimodules evaluate to projective left modules.

To prove nonfactorization without assuming the full Hom profile,
write `J=rad(A)` and use the nondegenerate symmetric trace on `A`.
If `J u=0`, then for `j in J` and `a in A`,

```text
tr(a u j) = tr(j a u) = 0,
```

because `j a in J`. Nondegeneracy gives `u j=0`.
For a map `X->A^n`, every coordinate of every image is killed
on the left by `J`, since `J X=0`; hence it kills `J` on the
right. A map `A^n->J(f tensor f)` sends each free basis vector
into `J`, so the composite is a sum of zero products.
This finite-free factorization statement is the other universal
theorem in `Main.lean`.

Every finite projective is a direct summand of a finite free
module: take a finite free surjection and split it by projectivity.
A factorization through that summand extends to a finite-free one
by its inclusion and projection. Thus every projective
factorization `X->J(f tensor f)` is zero.
The displayed value of `beta_H X` is nonzero, because `F tensor F`
is a basis vector and `H^2!=0` for every `H in k^*`.
This proves stable nonfactorization. Finally, a zero stable
evaluation of `f_H` would have zero composite with the evaluated
top projection, contrary to this result. No isomorphism assertion
about the top projection is needed.

## Formal statement fidelity and independent review

`Main.lean` contains the universal all-degree homotopy-extension
theorem and the trace/finite-free-factorization theorem, not an
encoding of the concrete 179-entry table or of an entire manuscript.
`STATEMENT_FIDELITY.md` states every formal hypothesis and the
translation to the concrete argument. Official compiler certification
has completed with **Lean 4.31.0, exit code 0, `proof_holes=[]`**;
the separate axiom audit also exited zero. The compiler's stdout and
stderr were empty. The durable run was `family199-formal-core`,
run ID `family199-formal-core-1793894190706710510`, and completed
successfully in 16.5 seconds.

The official mechanical certificate is
`certificates/V_FORMAL_CORE-511d6bce9fe46b99.json`.
The installed official tool copied the supplied fidelity text verbatim
to its canonical `statement_fidelity.md` and bound that copy into the
certificate; this generated copy and the generated certificate are left
unchanged. The ledger reports `V_FORMAL_CORE` as `closed_kernel`,
while explicitly retaining the unverified statement-fidelity caveat.
The source and both fidelity copies have not been edited since that
compiler run. No project Lake file was created: the prebuilt host
Mathlib workspace was used.

The finite replay command is

```sh
$WORKSPACE/argus-live-update/.venv/bin/python verify.py --check
```

Independent compiler replay uses

```sh
$WORKSPACE/argus-live-update/.venv/bin/python -m argus_skill.verticals.math.lean_evidence verify Main.lean --project-root . --statement-fidelity research/STATEMENT_FIDELITY.md --claim V_FORMAL_CORE
```

The official citation work list is empty: no unproved external proposition
has been adopted as an assumption of this verification. This does not
clear citations in the unverified remainder of either manuscript.

The result classification is an **exact verification theorem with a
separately delimited formal core**, not a counterexample, not a bounded
experiment extrapolated to all degrees, and not a verification of either
manuscript's main theorem. The underlying projective-lifting and trace
arguments are standard; no novelty claim is made for those general
lemmas. The campaign evidence added here is the literal-data reconstruction,
complete symbolic replay, and formally certified all-degree implication.
Publishability and novelty of this verification remain for the
independent Reviewer; the campaign-wide publishable target is unchanged.

No false literal manuscript assertion has been established in this
scope, so there is no justified `F_<LABEL>` refutation to register.
An unresolved claim elsewhere in either dependency chain is not a
refutation. All independent-review flags remain false until the host's
Reviewer replays the certificate and reads the all-degree proof and
formal statement fidelity. This Engineer does not impersonate that
Reviewer or declare campaign completion.
