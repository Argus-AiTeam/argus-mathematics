# A finite certificate for the aligned-chord obstruction

## Scope and known input

The target is Section 5 of OpenAI, *A positive solution to Tingley's
problem*, September 23, 2026, in the staged `build/main.tex`. The assertion
under investigation is conditional: the aligned configuration of
`prop:alignment`, together with the uniform signed defect bounds, is
impossible when its defect is positive. It is not the full extension
theorem. Neither attainment nor alignment is assumed to have been proved
by this audit.

The manuscript already asserts this obstruction. Our proof refinement
is a finite proof of its large-parameter case: an explicit inward vector
replaces the compact-dual-ball subsequence and support-sign argument.
This is an independent verification route, not a new solution to Tingley's
problem or a counterexample. Novelty and publishability require independent
assessment.

The public primary-source `openai/math/lean/docs/322.md` was read during
scope. It describes the intended extension statement and links
`ComparatorChallenges/TingleySphereIsometry.lean`; that description is not
proof evidence for Section 5. A targeted literature search located the
manuscript and secondary descriptions but no independently checked
proposition needed here. In particular, secondary assertions of complete
formalization are not adopted. The proof below needs only norm axioms and
real ordered-field algebra, not an external theorem taken on trust.

## Exact mathematical interface

Let

\[
 N(a,b)=\|av+by\|,\qquad P(a,b)=\|aw+bb_0\|,
\]

where \(v,y,w,b_0\) are unit vectors in arbitrary real normed spaces.
The coincident letters in \(P(a,b)\) are scalar coordinates; \(b_0=f(y)\).
The coordinate functions can be seminorms, since the two unit vectors
need not be independent.

Suppose \(0<t<1\), \(p,r,s,u,M>0\),
\(s=p+M,\ r=u+M,\ d=p+r=s+u\le2\). Assume the four endpoint
norms are one, the distances from each endpoint to its base unit vector
are preserved, and for every \(0\le q\le1\),

\[
 P(s,t-q)-N(p,t-q)\le M,\qquad
 N(r,q-t)-P(u,q-t)\le M.
\]

These are only two of the signed inequalities supplied by the
manuscript's global absolute defect bound. The conclusion to certify is
that these hypotheses imply `False`. No dimension, completeness,
smoothness, strict convexity, or compactness hypothesis is imposed.

## Finite secant argument

Write \(e=1-t,\ A=p/d,\ B=u/d\), and

\[
 a=p/s,\quad c=r/u,\quad
 h=\min(t/s,e/u),\quad X=N(a,h),\quad Z=N(c,h).
\]

Here \(0<a<c\) and \(h>0\). The two defect inequalities at
\(q_x=t-sh,\ q_z=t+uh\), together with the endpoint equalities, give

\[
 Z-X\le k(c-a),\qquad
 k=\begin{cases}1-B&B\le e,\\ B&B>e.\end{cases}
\]

The identities behind the cancellation are
\(sr-up=Md\), \(c-a=Md/(su)\),
\((1-B)(c-a)=M/u\), and \(B(c-a)=M/s\).
Convexity, expressed as a triangle inequality, gives

\[
 cX\le aZ+(c-a)h,\qquad X\le h+ak.
\]

The unit endpoint \(N(p,t)=1\) and \(sh\le t\) imply
\(1\le sX+t-sh\), hence \(e\le pk\).
Thus the required numerical consequence of `lem:secant` is obtained
without choosing any support.

The full support statement also has a finite proof. Let \(l_v,l_y\)
be the values of any norm-dominated linear functional supporting
\((a,h)\). Then \(l_y\le1\) and \(X=al_v+hl_y\). The same endpoint
triangle inequality gives

\[
 1\le sX+t-sh
   =pl_v+t+sh(l_y-1)\le pl_v+t,
\]

so \(e/p\le l_v\). Domination at \((c,h)\) gives
\((c-a)l_v\le Z-X\), proving \(l_v\le K\le k\).
Every manuscript support at \(v+\theta y\), \(\theta=hs/p\),
supports \((a,h)\) after multiplication by \(a>0\).
This proves the literal universal-support bound of `lem:secant`;
it does not weaken its quantifier to a selected support.

## Large parameters: explicit finite replacement

If \(B>e\), then \(h=e/u,\ k=B\) and \(e\le pB=pu/d\).
Consequently \(h\le a(1-B)\), whence

\[
 X\le a,\qquad Z\le a+B(c-a)<c.
\]

Thus the explicit number \(\delta=h/c>0\) satisfies
\(N(1,\delta)<1\). Also

\[
 hr+tc=N(hr+tc,0)
 \le hN(r,-t)+tN(c,h)<h+tc,
\]

so \(r<1\), and therefore \(u<1\) and \(A>e\).

Use the inverse configuration
\((p',s',r',u')=(u,r,s,p)\), with directions
\((v',w',y',b')=(-w,-v,b_0,y)\).
The same calculation supplies \(\delta'>0\) with
\(P(1,-\delta')<1\).
For any \(0<\eta<\min(t,p\delta)\), convexity gives
\(N(p,\eta)<p\). The triangle inequality

\[
 s\delta'+\eta
 \le \delta'P(s,\eta)+\eta P(1,-\delta')
 < \delta'P(s,\eta)+\eta
\]

gives \(P(s,\eta)>s\). The defect bound at \(q=t-\eta\)
now contradicts \(s-p=M\). The inverse argument also excludes \(A>e\).
This argument is finite and uses no compactness or differentiability.

## Small parameters

If \(A,B\le e\), the two secants give
\(e\le dA(1-B)\) and \(e\le dB(1-A)\).
Since \(A+B<1\), the smaller product is strictly less than \(1/4\);
as \(d\le2\), this implies \(e<1/2<t\). In particular \(A<t\).

Put \(D=N(r,e)=P(u,e)\), the preserved distance from \(y\) to \(z\).
Two nonnegative linear combinations give

\[
 r=rN(p,t)\le pD+(rt-pe),\qquad
 sD\le uP(s,t)+(se-ut).
\]

Their coefficients are nonnegative because \(A<t\) and \(B\le e\).
Rearranging gives \(ed\le pD\) and \(sD\le ed\), impossible since
\(s>p\) and \(D>0\). This is the convexity contradiction of
`prop:no-defect`, in division-free form.

## Dependencies and limitations

The coordinate-norm model explicitly permits dependent directions and
arbitrary real normed ambient spaces. The inverse swaps spaces and negates
the first direction; it does not assume antipodal preservation of the
sphere map. Attainment, common-support propagation, Darbo's theorem,
the alignment construction, and the extension theorem remain separate
unverified manuscript claims. No false manuscript assertion has been
identified in this route.

## Certification and replay

`Main.lean` contains the universal coordinate theorem, the full
support bound, and `manuscript_chords_impossible`, a formal implication
from actual normed-space endpoint data and the manuscript's absolute
defect bounds. `STATEMENT_FIDELITY.md` gives all hypotheses and the
precise scope. The three principal declarations print their axioms.

The official recording command for this installed CLI uses a positional
source argument:

```bash
$WORKSPACE/argus-live-update/.venv/bin/python \
  -m argus_skill.verticals.math.lean_evidence verify \
  research/chord_obstruction/Main.lean --project-root . \
  --claim C_CHORD_OBSTRUCTION \
  --statement-fidelity research/chord_obstruction/STATEMENT_FIDELITY.md \
  --timeout 100
```

`lean_check.json` and the archived `certificates/` record contain the
actual compiler outcome, source hash, and statement-fidelity hash.
No compiler verdict is asserted by the hand-authored
`exact_certificate.json`; it points to this real record.

Run the independently rerunnable certificate with:

```bash
$WORKSPACE/argus-live-update/.venv/bin/python \
  research/chord_obstruction/verify.py
```

The default checks the retained compiler record for freshness and invokes
Lean 4.31.0 again. It also checks thirteen symbolic identities with exact
rational arithmetic, independently replays the retained Jacobian matrix
product, and runs an exact small-parameter orientation/boundary search.
Those finite checks are sanity checks, not the universal proof.
`--arithmetic-only` explicitly omits the compiler replay and makes no
universal-proof assertion.

Jacobian 0.14.0, protocol 2025-11-25, operation
`matrix.symbolic.multiply.compute`, returned the exact zero polynomial
for \((p+M)(u+M)-pu-M(p+u+M)\). The inspected contract, exact payload,
typed response, and adapter exit status are retained in separate JSON
files. This one bounded operation certifies only the cancellation
identity; the norm theorem is certified by Lean.

Relative to the prior untested Section 5, the mathematical improvement is
a universal finite verification, an explicit map from the manuscript
hypotheses, and removal of the compactness argument from the terminal
perturbation. No claim of independent novelty verification, publication
acceptance, or completion of the full campaign is made. The Host-invoked
Reviewer must replay the certificate, assess statement fidelity, and
decide significance.

The completed Engineer run recorded `C_CHORD_OBSTRUCTION` as
`closed_kernel` using the official verifier: Lean 4.31.0,
`exit_code=0`, `proof_holes=[]`, and axiom audit exit code zero.
The archived compiler certificate is
`certificates/C_CHORD_OBSTRUCTION-b724ae2c2d6c594c.json`.
The end-to-end `verify.py` replay also exited zero, with all thirteen
symbolic identities, the retained Jacobian result, and 2,156 exact
rational parameter cases checked. Eight parameter cases survived the
scalar small-regime filters; in each the required distance interval
was empty. This count is not presented as a proof of universality.

Both official structural checks passed against the exact campaign root
`campaigns/9000322`.
The citation queue is empty because no external theorem is an
undischarged assumption of this verification. Independent Reviewer
confirmation remains pending, so proof-graph nodes are not marked
reviewer-confirmed.
