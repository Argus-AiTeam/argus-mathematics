# Exact selected-bin receiver-coefficient implication

## Statement and source boundary

The target is Lemma `sel:exponents` of the staged OpenAI preprint *Global
classical solutions of the three-dimensional relativistic Vlasov--Maxwell
system*, dated September 23, 2026. All source locators below are relative to
that preprint's `build/sections/` directory.

Fix `M,A >= 1` and positive fixed decomposition constants `C0,C1`. Put
`epsilon = 1/100000`, `beta = 29/25`, `L = log(2+P)`, `m = min(p,w)`, and

```
lambda^(-1/2) = C1 (P/m) (M/phi + sqrt(A L/phi)),
I0 = (m/P)^2,
W = (P theta)^(-epsilon) phi^epsilon h^epsilon,
U = w^(-1) min(h^2 (p theta)^3, (p theta h phi^2)^(-1)).
```

Let `Mstar` be the **exact** minimum of these applicable entries:

| Entry | Inclusion condition |
|---|---|
| `max(I,h)/p` | Always |
| `(h/p) max(1,I/lambda,h/lambda)` | `phi > C0/m` |
| `(h/p) phi^(-beta) max(1,I/I0,h/I0)` | `p,w >= P^(7/10)` and `j^(-49/100) <= phi <= j^(-4/25)` for both `j=p,w` |

Selection means that **both** entries of

```
min(I sqrt(h) p^2 phi^2, sqrt(I) sqrt(p Mstar)/(theta h))
```

strictly exceed `P sqrt(I) W`. The theorem to be verified is:
for all sufficiently large `P`, uniformly over all eligible representatives
and every `0 < I <= (w/P)^2`, selection implies `U <= w^(-1/2) W`.

The original conventions are not replaced with rounded momentum scales.
In `occupation.tex`, the source representative is `p=64 p0`, where `p0` is a
nonnegative power of two, so `64 <= p <= P`; `w=2^k`, `k>=0`, satisfies
`1 <= w <= P`; and `theta,phi,h` are nonpositive powers of two.
Nonempty bins obey `theta >= 1/p`. Small bins have `theta < kappa phi`.
The argument below proves the stronger continuous representative statement
with `1 <= p,w <= P`, `p theta >= 1`, and `0 < phi,h <= 1`; it therefore
retains all original bins without rounding or discarding endpoint bins.

## What is assumed, and what is not verified

The three displayed pure entries are definitions for this algebraic theorem,
not numerical approximations to occupation. Their analytic relevance is
conditional on the manuscript's claims `Moccupation <= C Mstar`
(`occupation.tex`, `occ:energy`, `occ:actual`; `direction.tex`,
`ang:improved-occupation`) and on the coefficient majorant `C U`
(`cancellation.tex`, `can:receiver-coefficient`).

Those analytic propositions, the direction-change argument and its
noncircularity, the signed retarded identity and cutoff errors, bootstrap
closure, and continuation are not established here. They remain open in
the proof graph. No external theorem is needed for the rational core.
The targeted search of the supplied Wiki index found no relevant page.
No wider novelty search was performed, and no external source is relied on
for this source-specific implication. The manuscript's own proof is the
prior result being audited; this work must not be described as a new proof
of global regularity or as verified publication novelty. The four local
manuscript assumptions on `C_SEL362_ANALYTIC` are explicitly recorded as
uncited, unverified analytic inputs, not dependencies of the rational theorem.

A finite search in `P` cannot disprove or prove an unspecified eventual
threshold. That route is excluded as a method of completing this objective;
there is no finite-search-based mathematical conclusion.

## Universal proof

Assume `P>1`. Write the representatives as **exact** real powers

```
p=P^(1-a), w=P^z, c=1-z, p theta=P^b,
phi=P^(-y), h=P^(-H), d=(a+b+y+H)/100000.
```

All six exponents are nonnegative, `z+c=1`, and `W=P^(-d)`.
There is no discreteness approximation. Strict selection and the interval
upper bound imply

```
N:  2a + H/2 + 2y < z+d,
E0: b < H/2-a+d                 if H <= 2c,
E1: b < H-c-a+d                 if H > 2c.
```

Indeed, `H<=2c` implies `h>=P^(-2c)>=I`, including equality;
otherwise **both** `h` and `I` are at most `P^(-2c)`.
These exhaust the energy entry, regardless of which entry minimizes
`Mstar`. Far selection can use every included upper bound because
`Mstar` is their minimum.

In either energy branch, `b <= H-a+d`. Thus

```
a+b+y+H <= 2H+y+d < 4z+5d,
0 <= d < (4/99995) z < z/1000, and z>0.
```

If `U>w^(-1/2)W`, both terms of its minimum give

```
U0: 2H/3 + z/6 - d/3 < b,
U1: b < H+2y-z/2+d.
```

The branch `E0` would imply `H+z+6a<8d`, impossible since
`d<z/1000`. Consequently `H>2c` and `E1` holds. Combining it
with `U0`, and then `N`, yields

```
H > (62/125)z + 3(a+c),
(7/2)a + (3/2)c + 2y < (753/1000)z,
z > 500/751,
y < (377/1000)z - (7/4)a - (3/4)c.
```

In particular, `z-y>623/1000` and `1-a-y>623/1000`.
Therefore `m phi > P^(623/1000) > P^(3/10)`. For a uniform
large threshold this forces the stable entry to be included.

Put `rho=max(a,c)`. After the uniform absorption justified below,

```
lambda^(-1/2) <= P^(rho+y+z/1000).
```

Since `I,h <= P^(-2c)`, the exponent
`2rho-2c+2y+2z/1000` is nonnegative and bounds all three exponents
in `max(1,I/lambda,h/lambda)`. Thus **every** stable maximum
branch, including its constant plateau, is covered. Far selection gives

```
b < H/2 - min(a,c) + y + z/1000 + d
  < H/2 + y + z/500.
```

Combining this weaker bound with `U0` and `N` gives

```
2y > H/3 + (41/125)z,
H < (2019/2500)z < (81/100)z,
a+c < (21/200)z,
z > 200/221 > 9/10,
1-a > 179/200.
```

Also `U0,U1` imply
`y > z/3-H/6-2d/3 > (19/100)z`.
The preceding inequalities certify **both momenta and both endpoints**
of the improved window:

```
z,1-a > 7/10,
(4/25)z < y,             (4/25)(1-a) < y,
y < (49/100)z,           y < (49/100)(1-a).
```

The improved entry is therefore applicable. Its maximum is also covered
in full: `2rho-2c>=0`, and it bounds `0`, the exponent of `I/I0`,
and the exponent of `h/I0`. Far selection consequently yields

```
b < H/2 - min(a,c) + (29/50)y+d
  <= H/2 + (29/50)y+d.
```

Using `U0`, `N`, and `d<z/1000`, one obtains

```
(29/25)y > H/3 + (33/100)z,
(29/25)y < (291/500)z - (29/100)H.
```

Hence `H < (378/935)z`, contradicting
`H > (62/125)z + 3(a+c)`. This disproves the assumed unsafe
coefficient. Equality in the requested safe conclusion is allowed.

## Uniform large-P quantifier, including constants and logarithms

Only the stable entry uses constants. Here is an explicit sufficient
threshold; its size is irrelevant to the quantifier.
Let

```
K = C1 (M + sqrt(2A)),
T = max(1, log(2), 8000000 K,
        (10/3) log(max(C0,1)) + 1),
Pstar = exp(T).
```

For any real `P>=Pstar`, put `t=log P`. Then
`log(2+P)<=2t`, and

```
C1 (M+sqrt(A log(2+P))) <= K t
  <= t^2/8000000
  <= exp(t/2000) = P^(1/2000).
```

The last inequality follows from `exp(x)>=x^2/2` for `x>=0`.
Moreover `1/2000 < z/1000`, since `z>500/751`.
Using `phi<=1` gives the asserted stable-cell exponent bound.
Also `P^(3/10)>C0`, so the stable entry is included whenever it is
invoked. All these conditions depend only on `M,A` and the fixed
decomposition constants, **not** on a bin or `I`.

This proves `exists Pstar, forall P>=Pstar, forall eligible bins,
forall I in (0,(w/P)^2], selection -> safety`, rather than merely
an asymptotic statement for fixed exponents. Dyadic `P` are a subset.
No lower bound on `I` or on `h` is introduced.

## Obtained certification and its boundary

`exact_certificate.json` records nonnegative rational combinations proving
each displayed exponent bound and the two exhaustive contradictions.
`verify.py` checks the coefficients with Python's exact `Fraction`, tracks
strict premises, and requires that both occupation windows have been proved
before their far bound is introduced. It also checks all energy and
occupation-maximum branches. This is a finite **proof certificate of a
universal implication**, not a finite parameter experiment. The replay passed;
corrupting an exact coefficient, deleting an energy branch, and deleting a
source-window endpoint were each rejected.

`Main.lean` independently establishes the rational contradiction and the
maximum envelopes over all real exponents. The prescribed `lean_evidence
verify` run used the existing Mathlib workspace and **Lean 4.31.0**, with
compiler `exit_code=0`, axiom-audit `exit_code=0`, and `proof_holes=[]`.
The wrapper returned zero and recorded actual mechanical evidence on
`C_SEL362_CORE`. Its immutable certificate is
`certificates/C_SEL362_CORE-558f5164dbe0e539.json`; `lean_verification.json`
contains the compiler result. No project Lake configuration or new library
installation was needed. `statement-fidelity.md` is the input document;
`statement_fidelity.md` is its compiler-paired canonical copy.

Jacobian discovery and contract inspection found the general exact-rational
LP operation `optimization.linear.rational_general_optimum.compute`.
The one bounded invocation of a closed final-stage relaxation was rejected
at normalization admission because its possible simplex bases exceeded
the tool's one-million-candidate bound. The exact payload, server/protocol
metadata, typed error, timeout setting, and adapter exit status are retained
in the `jacobian_*.json` files. This is **no mathematical conclusion**;
neither the proof nor its certificate relies on a solver status.

Compared with the manuscript's prior handwritten exponent contradiction,
the improvement here is an independently replayable exact linear certificate,
kernel certification of the rational core, complete branch/window coverage,
and an explicit threshold uniform over all representatives and interval
lengths. No false literal assertion was found in the audited implication;
no manuscript-refutation judgement is warranted by this result.

The real-power/logarithm translation and explicit threshold have a prose
proof; they are not silently included in the Lean theorem. The full
representative theorem is claim `C_SEL362_EXPONENTS`; the threshold claim is
`C_SEL362_THRESHOLD`. Engineer support is not independent Reviewer approval.
The Reviewer must read the source-to-exponent translation, the uniform
threshold, and statement fidelity, as well as replay the exact certificate.
This local result alone cannot complete the campaign's global or
publication-novelty objective.

Reproduce the exact replay from the campaign root:

```
python3 research/selected_bin_coefficient/verify.py
```

The claim-linked compiler command is:

```
$WORKSPACE/argus-live-update/.venv/bin/python -m argus_skill.verticals.math.lean_evidence verify research/selected_bin_coefficient/Main.lean --statement-fidelity research/selected_bin_coefficient/statement-fidelity.md --claim C_SEL362_CORE --project-root .
```
