# Characteristic-free independence of the actual word series

## Exact scope

The target is `thm:words` in the staged October 4, 2026 manuscript,
`build/sections/words.tex`. For an arbitrary field F, set K = F(t), with
t an indeterminate. In K[[z]], put

    a_i = (1+t)^i,   b_i = z/(1-a_i*z),   1 <= i <= n,
    h_empty = 1,
    h_(iw)(0) = 0,   h_(iw)(tz)-h_(iw)(z) = b_i(z)*h_w(z).

The assertion to settle is independence of all these series over K(z),
with rational functions interpreted in K((z)). A finite vanishing jet,
a characteristic-zero specialization, or an abstract criterion with
unproved specialization does not settle it.

## Source and prior scope findings

The source explicitly supplies the coefficient construction, the fixed-field
calculation, the two-endpoint pole argument, and a minimal-relation argument.
Its prefixed-word convention gives the coefficient

    sigma(R_w)-R_w + sum_i b_i*sigma(R_(iw)).

In particular, the factors on the parent coefficients really are shifted.
No false assertion has been established by reading this formula.
Orders at t=0 and t=-1 are integer orders, not derivatives; characteristic
dividing a letter index does not invalidate this orbit-separation argument.

The source describes Chen--Singer, Section 2.3, as characteristic-zero
background, and Deneufchatel et al., Theorem 1, as a differential analogue.
Neither is an assumption of the proposed direct characteristic-free proof.
The locally staged source was read; the external originals have not been
obtained or attributed here, and no theorem from them is being invoked.
No independent word-independence result is indexed in the inherited Wiki.

The strongest prior result in this campaign is the independently reviewed
complete shift-order theorem. Its source and certificates are preserved.
It does not imply word independence. The superseded minimum-minor route
is already retired, with its reason, in the claim ledger; that route is
not reopened. Finite rank checks cannot replace the universal proof sought
here and will be classified only as finite experiments.

## Independent proof

The coefficient construction is valid because t is transcendental: t^r-1
is nonzero for every positive integer r, including when the characteristic
divides r. The kernel b_i has zero constant coefficient. Consequently the
displayed coefficient formula constructs a unique zero-constant solution of
the shift equation. Coefficient comparison also proves K-linearity and that
vanishing below degree j becomes vanishing below degree j+1.

On Laurent series sigma multiplies the coefficient of z^j by t^j for every
integer j. This map preserves products since t^(j+k)=t^j*t^k and has inverse
given by the parameter t^(-1). If sigma(f)=f, then
(t^j-1)*coeff_j(f)=0. Every coefficient except that at j=0 therefore vanishes,
so the fixed field is exactly K. This proves the full Laurent-series
assertion, not just its rational-function restriction.

Here is a characteristic-free algebraic check of the explicit pole orbits.
If r,i,k are nonnegative integers and

    t^r*(1+t)^i = (1+t)^k,

injectivity of the polynomial embedding gives the same polynomial identity
in F[t]. Evaluation at t=0 forces r=0, and comparison of polynomial degrees
then gives i=k. Clearing the nonzero denominators and splitting an arbitrary
integer shift exponent into its nonnegative or negative case proves

    t^j*(1+t)^(-i) = (1+t)^(-k)  ==>  j=0 and i=k

for positive letter indices. The nonzero powers of t are all distinct.
Thus each displayed orbit is infinite, distinct letters have disjoint
orbits, and no division by a letter index or differentiation is involved.

For rigor at possible multiple poles, call R regular at a if it has some
polynomial fraction representation with denominator nonzero at a.
Coprimality of the reduced numerator and denominator proves that this is
equivalent to nonvanishing of the reduced denominator at a. Its failure set
is therefore finite. Regularity is closed under addition, subtraction and
multiplication, and sigma(R) is regular at a exactly when R is regular at
t*a.

Suppose a nonzero constant combination G=sum_i c_i*b_i were sigma(R)-R,
and choose c_i nonzero. On the i-th orbit G is nonregular exactly at index
0. The set S of nonregular indices of R on this orbit is finite. It cannot
be empty, because otherwise both R and sigma(R) would be regular at index
0. Write l=min S and u=max S. At l-1, R is regular and sigma(R) is
nonregular, so their difference is nonregular. At u, R is nonregular and
sigma(R) is regular, so the difference is again nonregular. Thus l-1=0
and u=0, contradicting l<=u. This proves the exact rational-difference
obstruction, independently of pole orders and interior cancellation.

Finally suppose a finite rational relation exists. Choose smallest maximum
word length, and then fewest nonzero coefficients at that length. Normalize
one top coefficient to 1. Applying sigma and subtracting gives the relation
with coefficients

    sigma(R_w)-R_w + sum_i b_i*sigma(R_(iw)).

It introduces no new top word and removes the normalized one. Minimality
therefore forces every transformed coefficient to vanish. Top coefficients
are fixed and hence lie in K. At the next lower length the transformed
equation makes a constant combination of the kernels a rational difference;
the obstruction kills every top coefficient, a contradiction.

The formal proof implements this finite minimality argument by induction on
the length bound and strong induction on the number of nonzero top
coefficients. The transformation, normalization, strict support decrease,
and padding of an arbitrary finite support are proved, not assumed.

## Formal theorem and statement fidelity

`Main.lean` proves the complete instantiated theorem
`WordIndependence.word_series_linearIndependent`. Its only substantive
external parameter hypotheses are `Field F` and `1 <= n`.
The family comprises all finite lists over `Fin n`; formal index i means
printed index i+1. The scalar field is `RatFunc (RatFunc F)`, acting through
the canonical Laurent expansion. It is not a theorem about independence
over constants or about a bounded family of jets.

The detailed declaration-to-manuscript reading is
`statement_fidelity.md`. In particular, the abstract criterion is not the
deliverable by itself: `word_series_finite_relation` supplies its fixed-field,
kernel, pole-orbit and recurrence hypotheses for the exact construction.
No characteristic-zero result or shift-order theorem is a proof dependency.
No false manuscript assertion was identified in this bounded audit, so no
manufactured `F_` refutation claim is registered.

Compared with the strongest prior result, this settles the separate
faithfulness dependency left open by the reviewed shift-order theorem.
Together they still do not certify the formula-system bridge, coefficient
descent, the complete hitting theorem, or mathematical priority.

## Replay and evidence interpretation

Run

```bash
$WORKSPACE/argus-live-update/.venv/bin/python research/word_independence/verify.py
```

The default path invokes the real official Lean 4.31.0 compiler and axiom
audit with `--claim C_WORD_INDEPENDENCE`. It checks the archived source,
statement reading, current claim version, and mechanical ledger entry,
then runs both campaign-local structural checks. Only a successful compiler
and audit with an empty proof-hole list count as the universal certificate.
`exact_certificate.json` records that outcome and the separately classified
finite experiments. Independent Reviewer confirmation remains a Host action.

The finite experiments use QQ(t), F_2(t), F_3(t), and F_5(t), never a
finite-order specialization of t in positive characteristic. They construct
the exact coefficient recursion and test polynomial-coefficient relation
matrices for four small parameter choices per field. Orbit samples include
letter indices divisible by the characteristic; the orientation check
compares h_12 with h_21. These are bounded adversarial experiments, not
proofs of independence for all rational coefficients.

Jacobian discovery and contract inspection preceded custom finite
computations. The installed relevant operation was the already scoped
`formal_series.rational.multiply.compute`, which only handles truncated
QQ series. The dedicated payload multiplies b_1 and h_1 at t=2 modulo z^5.
The exact output is (0,0,1,4,93/7). `jacobian_output.json` preserves the
operation, payload, output, protocol 2025-11-25 and server version 0.14.0.
Its adapter status is success; its scope is this one arithmetic check,
not the universal pole or independence theorem.

## Certification status

The default standalone replay completed successfully through the durable
runner. Official Lean 4.31.0 compilation and axiom audit both exited 0,
with `proof_holes=[]` and only `propext`, `Classical.choice`, and `Quot.sound`.
The source-bound mechanical record is
`certificates/certificates/C_WORD_INDEPENDENCE-0ac71bbe2d9ab11f.json`.
The ledger derives `closed_kernel` for `C_WORD_INDEPENDENCE` version 3,
with no external assumptions. This is a compiler verdict on the encoded
statement; independent statement-fidelity review is still required.

The replay also passed all 16 exact rank experiments and all 182 sampled
orbit points across the four rational-function fields. In every tested
characteristic h_12-h_21 first differs at degree 3. Both official structural
checks exited 0 against the campaign root, not the shared batch directory.
The exact outcomes are in `exact_certificate.json`; the durable task receipt
is `runner_receipt.json`. These measurements are supporting experiments,
not the reason the universal theorem is certified.

The proof graph preserves the prior independent acceptance of the
shift-order theorem. The new word theorem and its internal obligations
remain graph-open for Host-invoked independent Reviewer confirmation.
No independent review or publishable mathematical novelty is claimed yet.
