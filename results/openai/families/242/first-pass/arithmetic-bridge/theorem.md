# Complete-witness verification of the elliptic-height/Pell bridge

## Result and boundary of the certification

The arithmetic argument in `elliptic.tex`, Proposition `prop:growth`,
composed with `power.tex`, Proposition `prop:power`, survives the audit
below. No false manuscript assertion or exact counterexample was found.
The result is a mathematical verification argument, accompanied by a
Lean 4.31.0 verification of its universal arithmetic core and exact
finite diagnostics. These are three different forms of evidence.

The formal theorem is stronger than a check of the cancellation
identity: it proves existence and uniqueness of representatives,
selection for every input, the exact square window, both eventual
growth bounds, Pell index pinning, existence of the intended power
witness, and uniqueness of every displayed power coordinate. It also
proves complete rational codes, all seven guarded addition cases,
maxima, and finite-chain uniqueness.

The formal theorem is not a kernel proof of the rank computation,
canonical-height theory, or the translation of the entire literal
polynomial expansion. Their instantiation is the ordinary mathematical
argument below. In particular, the formal theorem's local expansion
premise is discharged here, not silently deleted from its statement.
`statement_fidelity.md` specifies this boundary. Independent Reviewer
acceptance, formal citation attribution, novelty, and publishability
remain pending; none is inferred from a compiler exit code.

Source paths below are relative to
`research/openai_manuscript/Single-fold-Diophantine-representations-September-24-2026/build/`.
The principal sources are `elliptic.tex`, equations `eq:rational-code`,
`eq:uniform-height`, `eq:height-constants`, `eq:representative`,
`eq:index-bracket`, `eq:square-window`, and `eq:growth-bounds`;
`power.tex`, equations `eq:power-input` through
`eq:power-existence-cutoff`; and the arithmetic paragraphs of
`witness-ledger.tex`.

## 1. External elliptic facts and their precise use

Use the group decomposition of `elliptic.tex`, `prop:rank-one`:
for \(E:y^2=x^3-25x\), every rational point is uniquely \(nP+t\),
where \(n\in\mathbb Z\) and
\(t\in\mathcal T=\{O,(0,0),(5,0),(-5,0)\}\).
The staged `rank-one-proof.tex` supplies a descent argument. It is not
formalized in `Main.lean`. Its cited Mordell--Weil, Nagell--Lutz, and
isogeny propositions remain explicit ledger assumptions; their literal
book locators have not been independently opened in this mission.

The geometric facts needed after that decomposition are elementary:
negation preserves \(x\) and reverses \(y\); equal affine
\(x\)-coordinates give equal or opposite points; and a point with
\(y=0\) is 2-torsion. Nontorsion points and their torsion translates
are affine. The chord--tangent formulas are those in
`lem:point-arithmetic`; the exact polynomial substitutions are replayed
in `verify.py`.

Use the canonical-height convention
\[
 \widehat h(Q)=\tfrac12\lim_{N\to\infty}4^{-N}h_x([2^N]Q).
\]
There is a single constant \(c>0\), independent of \(Q\), with
\(\lvert h_x(Q)-2\widehat h(Q)\rvert\le c\);
the height is quadratic and positive at \(P\).
The independent primary-source reader checked Silverman's AWS 2024
notes, Theorems 5.2 and 5.4, with the normalization in Definitions
4.4--4.5 and Theorem 4.8. The relevant symmetric divisor is \(2(O)\),
so its canonical height is twice the convention above. See
`primary_sources.md`. This confirms the mathematical normalization and
uniformity, not the uninspected numbering of the manuscript's book
reference.

Choose \(\kappa\in\mathbb N\) with \(\log\kappa>6c\), and then an
even \(m=m_*>0\) such that, for \(a=2m^2\widehat h(P)\),
\[
 a>2c,\qquad 6c<\log\kappa<2a-6c.
\]
Evenness kills this curve's torsion. Enlarging \(m\) changes \(a\), not
the fixed comparison error \(c\). Thus the manuscript's simultaneous
choice of constants is legitimate.

For \(W(Q)=H(x([m]Q))\), with value 1 at infinity, this yields
\[
 W(nP+t)=W_{|n|},\quad W_0=1,\quad
 |\log W_j-aj^2|\le c\quad(j\ge1).
\]
These are the fields of `HeightSequence`. The coordinate functions
on \(\mathbb Z\times\mathcal T\), with arbitrary dummy values at torsion
where necessary, give `OrbitGeometry`; all its nontrivial fibre and
nonzero-\(y\) conditions concern nonzero integer index. No uniqueness
of representatives or of the growth graph is an external assumption.

## 2. Canonical arithmetic coordinates

For a reduced rational number \(x=A/d\), \(d>0\), its six natural
coordinates are
\[
 p=\max(A,0),\quad n=\max(-A,0),\quad
 t\equiv |A|^{-1}\pmod d,\quad
 s=d-1-t,\quad q=(|A|t+d-1)/d.
\]
For \(d=1\), set \(t=s=q=0\). Conversely, the literal three
equations in `eq:rational-code` imply coprimality: a common divisor of
\(p+n,d\) divides 1. The residue interval and coprimality make \(t\)
unique; the other two witnesses then follow by equality. Zero is
\((0,0,1,0,0,0)\), not the all-zero inactive tuple.
`rational_code_exists_unique` proves this for every rational number,
not just the fractions in the diagnostic range.

A point has its identity flag and two complete rational codes.
The flag is 1 only at infinity, whose two dummy coordinates are zero;
the flag is 0 for an affine point, including \((0,0)\).
`point_code_exists_unique` proves uniqueness for each specified point.
Clearing its affine curve equation uses strictly positive denominators,
so introduces neither extraneous solutions nor multiplier variables.

In addition, the seven guards in `lem:point-arithmetic` are a disjoint
exhaustive partition. At equal \(x\), the curve equation says
\(y_1=\pm y_2\); if not opposite, the common \(y\) is nonzero.
The four active slopes therefore have nonzero divisors.
`addition_guards_partition`, `addition_divisors_nonzero`, and
`addition_complete` check all cases. In `AdditionLocal` the strict
comparison slack is the cross-multiplied numerator difference minus 1
in the chord cases, and respectively \(y_1\)'s numerator minus 1 or
its negative minus 1 in the two tangent cases. These are exactly the
denominator-cleared guard slacks, not rational-valued substitutes.

For the other three cases the local type is `PUnit`: it represents
zero coordinates, not an extra natural witness. Each of the four
slope cases has precisely six slope coordinates and one slack.
All seven selectors are counted. The output point code is shared.
In an inactive case every local coordinate, including the denominator,
is zero; its validity equations are gated. The globally valid output
is never zeroed. `gated_cases_unique` proves existence and uniqueness
of this whole tuple, not merely of its active output.

The two maximum guards are \(a\ge b\) and \(b>a\); the first receives
ties. `maximum_complete` proves uniqueness of its output, both
selectors, and the two local slacks. Every weak or strict integer
comparison likewise has its unique natural difference slack.
`fixed_chain_complete` proves by induction that a fixed number of
unique operations fixes every intermediate output and internal tuple.
The chain length is fixed before inputs, so its trace length is not
a quantified time parameter.

## 3. Representatives, bracket, and exact square window

Fix an absolute index \(j\ge1\). Within \(jP+\mathcal T\), equal
\(x\)-coordinates can only come from equal points: the negative
alternative would imply \(2j=0\) in the free summand. Hence the
finite coset has a unique maximal \(x\)-coordinate. Negation gives
the maximal point in the opposite coset. Their \(y\)-coordinates
are opposite and nonzero, so exactly one is nonnegative.
These are all the representatives, since \(W(Q)>1\) excludes exactly
torsion. This proves the literal inequalities in
`eq:representative`, including every \(Q+t\ne O\).
The proof is formalized for every finite additive torsion type in
`OrbitGeometry.representatives` and `representative_unique`.

The quadratic bounds imply that \(W_j\) is strictly increasing.
For \(j=0\), \(W_1>1\) follows from \(a>2c\); for \(j\ge1\),
the successive logarithmic gap is at least \(a(2j+1)-2c>0\).
An increasing natural sequence is unbounded. Thus for every
\(u\ge0\) there is exactly one \(k\ge1\) with
\[
 W_k\le u+W_1<W_{k+1}.
\]
At \(u=0\) this gives \(k=1\). For any signed nonzero index \(n\),
the maximum of the neighboring heights at \(n+1,n-1\) is
\(W_{|n|+1}\), including negative \(n\) and \(|n|=1\).
The formal results are `strictMono`, `bracket`, and `neighbor_max`.

For the two representatives with absolute indices \(k,r\ge1\), set
\[
 L=W_{2k}W_rW_1,\qquad D=W_k^2W_{r+1}.
\]
Both are positive. Writing each logarithmic height as its quadratic
main term plus error gives
\[
 \log L-\log D=2a(k^2-r)+e,\qquad |e|\le6c.
\]
The coefficient 6 includes the repeated \(W_k\) error twice.
If \(r=k^2\), the absolute logarithmic ratio is \(<\log\kappa\).
Otherwise its absolute value is at least
\(2a-6c>\log\kappa\), because \(k^2-r\) is a nonzero integer.
Therefore
\[
 (L\le\kappa D\ \land\ D\le\kappa L)\quad\Longleftrightarrow\quad r=k^2 .
\]
`HeightSequence.square_window` proves this universally. The literal
doubling and neighbor operations match these indices by
`doubled_index` and `neighbor_max`; no index is a polynomial variable.

Consequently \(Q,R\), and \(g(u)=W_{k^2}\), exist uniquely for every
natural input. This is `growth_core_unique`, before any asymptotic
cutoff is chosen.

## 4. Both strict growth inequalities

Put \(U=u+W_1\). The bracket gives
\[
 ak^2-c\le\log U< a(k+1)^2+c\le4ak^2+c.
\]
Eventually \(\log u>2c\), so
\(k^2>\log u/(8a)\). Increasing the fixed cutoff again gives
\[
 \log g(u)\ge ak^4-c>
       \frac{(\log u)^2}{128a}.
\]
For the upper bound,
\[
 \log g(u)\le ak^4+c
 \le \frac{(\log(u+W_1)+c)^2}{a}+c,
\]
which is eventually less than \(u\log u\).

`HeightSequence.growth_bounds` proves the strict inequalities with
\(\delta=1/(128a)\) and an existential natural cutoff at least 4.
It uses the explicit real threshold
\(128ac+36/a+3c+4\), then a natural number exceeding its exponential
plus \(W_1+4\); this is a sufficient cutoff, not a numerically
computed canonical-height constant. The elementary estimate
\(\log u\le2\sqrt u\) discharges the upper comparison. Neither
inequality is inferred from plots, sampled heights, or floating point.

## 5. Instantiating the actual complete growth tuple

Here is the source-specific discharge of the formal premise
\[
 \forall u,z,\quad \mathrm{GrowthOK}(u,z)\Longrightarrow
                 \exists!\xi\ E(u,z,\xi).
\]
The parameter \(u\) is essential: different inputs may choose the
same representatives but have different bracket slacks.

Take \(E(u,z,\xi)\) to be the finite expansion prescribed in the
growth-graph paragraph of `witness-ledger.tex`, with its \(Q,R\)
identified with the points represented by `z.first,z.second`.
In this definition the signed indices and torsion tags are semantic
names supplied by the group isomorphism. They are not coordinates
of \(\xi\).

For a fixed valid \(u,z\), first take the unique complete codes of
\(Q,R\). For each representative test take its height computation,
the four torsion translates and additions, and the six comparison
slacks. The representative property proves that every required
comparison has a nonnegative difference and that all required
points are affine. All calls are unique by Section 2.

Next take the five additions \(Q\pm P,R\pm P,[2]Q\) and their five
heights. Every height is computed by the fixed scalar chain followed
by the maximum of the final code's absolute numerator and denominator.
This also works if a neighbor is torsion or infinity: at infinity the
dummy rational code has numerator 0 and denominator 1, so its
maximum is 1. The scalar-chain additions retain all exceptional
branches and all intermediate point codes.

Take the two neighbor maxima, the two named products \(L,D\), and
the four final slacks
\[
 u+W_1-h_Q,\quad N_Q-u-W_1-1,\quad
 \kappa D-L,\quad \kappa L-D.
\]
Their nonnegativity follows from the bracket and square window.
The equalities fix the named products and the duplicate displayed
output \(v=h_R\). This constructs every coordinate of \(\xi\).

Conversely, any satisfying expanded tuple has valid point codes;
the group decomposition assigns unique semantic indices and torsion
tags to \(Q,R\). The actual additions and scalar calls compute the
specified heights, so its representative tests, bracket and window
imply `GrowthOK`. Section 3 fixes both points. Successive application
of the primitive uniqueness theorems then fixes, in the order just
listed, every coordinate of the expansion. Inactive local coordinates
are covered by the same primitive theorems; none can be chosen freely.
This proves both directions, existence, and uniqueness of the literal
finite expansion. It does not assume the growth graph as a premise.

For the specific chain \(Q,2Q,\ldots,mQ\), an addition has 35 internal
coordinates and a point code has 13. A height has
\(48(m-1)+4\) internal coordinates, not counting its displayed output.
A representative test has \(48(m-1)+203\) internal coordinates.
The resulting growth tuple has exactly
\[
 |\xi|=336(m-1)+713
\]
natural coordinates. The count includes seven separate height calls,
thirteen non-scalar additions, all their output point codes, all
selectors and slacks, the two named products, and both codes of
\(Q,R\). Equal-valued outputs of distinct calls are still distinct
variables. No coordinate is removed merely because its value is
known, zero, or equal to another coordinate.

The general projection theorem `GrowthCall.project` forgets semantic
indices without adding them to the natural witness. Thus the root
theorem returns `GrowthCall B`, where \(B\) is the literal auxiliary
tuple type, not `GrowthCall (GrowthWitness × B)`.
The prose instantiation in this section is not itself kernel-checked.

## 6. Universal paired-Pell transfer

Let \(C\) be the complete growth call just constructed. Choose one
fixed natural \(\ell\ge1\) with \(3<\delta\ell\log2\).
`PowerOK` has exactly the displayed polynomial equations and the
six unique slacks of `witness-ledger.tex`. Its `PowerWitness` counts
the output \(c\) as well as \(u,v,X,Y,F,H,q,q',r\), the slacks,
and the complete nested growth tuple. It has no Pell-index variable
and no sign choice for a square root.

For \(a\ge2\), the specialized Pell sequences enumerate every
nonnegative solution of \(x^2-(a^2-1)y^2=1\).
`Pell.eq_pell` supplies completeness; strict increase of \(y_i\)
supplies index uniqueness. The residue and size bounds are
\[
 y_i(a)\equiv i\pmod{a-1},\qquad
 (2a-1)^{i-1}\le y_i(a)\le(2a)^{i-1}.
\]
The existing Mathlib completeness theorem is used as a kernel-checked
lemma, not as an uninspected literature assumption.

`paired_lower` proves by simultaneous induction on the two
coordinates that \(b^n y_{n+1}(u)\le y_{n+1}(bu)\).
`paired_ratio` combines this with the size bounds for the full upper
ratio inequality in `lem:pell-sequences`. For quotient extraction,
`power_gap` gives the exact integer replacement
\[
 (s-n)(s+1)^n\le s^{n+1}\quad(n\le s),
\]
so `quotient_window` proves
\[
 b^nH\le F<(b^n+1)H
 \quad\text{if}\quad b^n n<2u-1-n.
\]
This avoids real series estimates without weakening their conclusion.

In an arbitrary solution, the positive Pell coordinates have indices
\(i,j\ge1\). The upper growth bound and the universal
`index_cutoff` inequality
\(u^u<(2u-1)^{u-1}\), \(u\ge4\), imply \(1\le i,j<u\).
The residue equations and \(1\le n+1<u-1\) force
\(i=j=n+1\). In the \(H\) equation the possible endpoint \(j=u-1\)
has residue zero and is excluded explicitly; it is not incorrectly
treated as a residue strictly smaller than its modulus.

The lower paired comparison and division give \(b^n\le c\).
The prescribed
\(u=(c+1)^\ell(n+1)(b+1)+u_0\) gives
\(cn<2u-1-n\), hence the quotient window forces \(c=b^n\).
These steps are `power_indices` and `power_output`.

Conversely set \(c=b^n\), fix the prescribed \(u\), take the unique
growth tuple, and use \(x_{n+1},y_{n+1}\) for both Pell equations.
The congruences and \(y_{n+1}\ge n+1\) give nonnegative \(q,q'\);
the quotient window gives a natural \(r<H\).
The lower growth bound, \(\log u\ge\ell n\log2\), and
\(\log(2bu)\le3\log u\) imply \(F,H<v\), including \(n=0\).
This is `growth_lower` and `power_exists`.

Finally `power_witness_unique` fixes \(c\), then \(u\), then the
whole growth call, \(F,H\), the unique natural square roots \(X,Y\),
the residue quotients, the remainder, and all six slacks.
For \(n=0\) it gives \(c=F=H=1\), \(X=bu,Y=u\), and
\(q=q'=r=0\); the complete growth call is still present.
For \(b=0,1\), the base slack equation excludes every witness.
The formal root `elliptic_pell_complete` states these conclusions
for every natural \(b,n\).

## 7. What the replay establishes

`verify.py` runs exact symbolic curve and height identities, bounded
boundary diagnostics, and a real Lean replay. It checks the complete
addition tuples, not just output points. Its Pell diagnostics do not
invent a growth function or an arbitrary value of \(v\).
The universal result comes from the proofs above and `Main.lean`,
not from increasing any finite bound.

From the campaign root, replay the persisted certificate with:

```bash
$WORKSPACE/argus-live-update/.venv/bin/python research/arithmetic-bridge/verify.py
```

This requires SymPy and the built Lean/Mathlib 4.31.0 workspace.
`--mathlib-workspace PATH` selects another already-built workspace.
The replay checks the official source/fidelity bindings before a real
compiler run and compares its result with `exact_certificate.json`.
It does not write a Reviewer judgement or modify the claim ledger.

The Jacobian result is a separate exact doubling diagnostic for
\((-4,6)\), with payload, operation identifier, typed output, server
version and adapter status preserved in dedicated JSON files. It
does not certify a generator or the growth theorem.

Compared with a reconstruction of the earlier paired-Pell method,
the present verification covers the missing universal
bounded-error-height construction and the entire witness, rather
than assuming a cutoff with a single-fold graph. It does not claim
that a novelty search, independent acceptance, or the campaign's
publishable-result gate has already been completed.
