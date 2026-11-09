# September construction and critical point: ENGINEERING assessment

## Status and scope

**Engineering verdict: supported for all four assigned September claims, with the hypotheses below.** This is a reconstruction and verification of the supplied argument, not an original contribution, a new paper-error search, an independent review, or acceptance of the corpus. No mathematical gap remains identified in these four claims after the algebraic checks below. Novelty is **not asserted**. Native Host-invoked independent review remains required.

The September polynomial is **not stably a coordinate**: the obstruction survives adjoining any finite number of variables. This is different from the October polynomial, which is claimed to be a **one-stable coordinate**. They are different literal polynomials. The shared October Lean declarations do not prove the September theorem.

## 1. Exact sources, version, and attribution

Throughout, `OLD` denotes `campaigns/9000049`, and `CORE` denotes `OLD/research/stable_core_certificate`. All old inputs were treated read-only.

* **[S] September manuscript:** OpenAI, *An explicit noncoordinate polynomial with affine three-space zero fibre*, dated September 24, 2026. Exact source:
  `openai-math/preprints/An-explicit-noncoordinate-polynomial-with-affine-three-space-zero-fibre-September-24-2026/build/paper.tex`.
  The supplied `campaigns/9100049/MANUSCRIPTS.json` identifies revision `4eaee87548250b2682affda7d05d947c05554bae` and SHA-256 `60993c0b524291b7f707e42eec89ec7e910c22760d81f1d3af007c229228c13c`. The actual TeX hash matches. The old ledger's reference copy at `OLD/research/openai_manuscript/An-explicit-noncoordinate-polynomial-with-affine-three-space-zero-fibre-September-24-2026/build/paper.tex` has this same hash. Revision attribution is manifest-based; no Git command was used.
* **[D] Old Argus prose:** `CORE/report.md`, especially lines 490–498, records the September lifting, translation, zero-fibre and critical-point obligations separately from October. This is supporting review prose, not a second result.
* **[V] Old symbolic implementation:** `CORE/verify.py`, all 356 lines inspected; SHA-256 `a891c7fd9051d0a4bc7759bcf987adef58488c255a10f2372cc4d02b11529cf6`. September checks are at lines 221–272.
* **[E] Preserved exact certificate:** `CORE/exact_certificate.json`, SHA-256 `104d3503ab1d34038b0d5a9a2dc633a6a223769866f4107570a3aa51815799c9`.
* **[L] Old ledger and graph:** `OLD/research/MATH_STATE.json:199–254` and `OLD/research/PROOF_GRAPH.json:111–138`. Each assigned claim has one version, version 1. Historical `open`/`reviewer_confirmed=false` labels are not mathematical verdicts.
* **[F] Formal scope evidence:** `CORE/Main.lean`, specifically the literal October definitions at lines 128–135 and eight `#print axioms` commands at lines 167–174. No September formal proof was replayed or inferred.

The source attributes the cusp generators' invariant-theoretic origin to Maubach's 2000 triangular monomial derivation calculation ([S]:140–145, bibliography `MaubachMonomial`) and the ambient critical-locus obstruction to Shpilrain–Yu ([S]:122–128, 324–329, bibliography `SY`). Those are source attributions, not independently established priority findings. Neither citation is needed as an unproved theorem in the elementary argument below.

## 2. Literal polynomial and checked hypotheses

The independent ambient variables, in order, are \((h,u,v,w)\), and \(R=\mathbb C[h,u,v,w]\). The symbols \(x,y,s\) in the following formulas denote polynomials, not additional independent ambient coordinates:
\[
\begin{aligned}
x&=u^3+hv,& y&=-u^2+hw,\\
s&=S(h,u,v,w)
 =2u^3v+3u^4w+h(v^2-3u^2w^2)+h^2w^3,\\
p(x,y,s)&=-2s^2x+3sy^2-3s^3y,&
F&=h-p(x,y,s)-1.
\end{aligned}
\]
These are exactly [S]:85–101, labels `eq:xyz` and `eq:F`, and [V]:223–228, 256, 265–267. Expanding gives the **polynomial identity**
\[
x^2+y^3=hs,
\]
without interpreting \(s\) by division at \(h=0\).

The separate lifting lemma ([S]:164–246, `lem:lift`) has a stronger base-ring scope than the ambient theorem: \(B\) is **any commutative ring with identity**, and \(h,x,y,s\in B\) satisfy
\[
x^2+y^3=hs,\qquad (h,y)=B.
\]
There is no domain, reducedness, characteristic, or non-zero-divisor assumption. The zero ring is permitted. The conclusion is the \(B\)-algebra isomorphism
\[
B[U,V,W]/(U^3+hV-x,\,-U^2+hW-y,\,S(h,U,V,W)-s)
\cong B[T].
\]

## 3. `C_SEP_LIFT`, version 1: supported, including zero divisors

Here is the decisive ring-level proof, including both directions of the substitutions. Choose \(\alpha,\beta\in B\) with \(\alpha h+\beta y=1\).

First \(G=V+UW\), \(V=G-UW\), is a polynomial substitution with a polynomial inverse over every \(B\). Set
\[
R_W=hW-y-U^2,\qquad L=hG-yU-x.
\]
In the free integer polynomial ring, the first transformed relation is \(L-UR_W\), and
\[
\begin{aligned}
S(h,U,G-UW,W)
={}&hG^2-2UyG+y^2W\\
&+R_W(-2UG+2yW+R_WW).
\end{aligned}
\]
Thus the original three-relation **ideal**, not just its zero set, becomes
\[
(L,\ hW-y-U^2,\ y^2W-s+hG^2-2UyG).
\]
The two residual formulas are replayed as `sep_linear_first` and `sep_linear_S`; no cancellation of \(h\) occurs.

In \(A=B[U,G]/(L)\), put
\[
a=y+U^2,\quad b=s-hG^2+2UyG,\quad
r=\alpha(1+\beta y),\quad q=\beta^2.
\]
The two necessary identities are
\[
y^2a-hb=(hG-yU)^2+y^3-hs=0,\qquad rh+qy^2=1.
\]
The second is a consequence of \(\alpha h=1-\beta y\), not invertibility of either coefficient. Define \(W_0=ra+qb\). Compatibility yields
\[
hW_0=a,\qquad y^2W_0=b.
\]
In \(A[W]\),
\[
W-W_0=r(hW-a)+q(y^2W-b),
\]
and conversely \(hW-a=h(W-W_0)\), \(y^2W-b=y^2(W-W_0)\). Hence
\[
(hW-a,y^2W-b)=(W-W_0).
\]
This proves the quotient is \(A\), scheme-theoretically and with nilpotents retained. Equivalently, two solutions for \(W\) differ by an element killed by both \(h\) and \(y^2\); their Bezout combination forces that difference to be zero. No localization, pointwise argument, or cancellation is concealed here.

Finally the mutually inverse maps are
\[
U=hT-\beta x,\quad G=yT+\alpha x,
\qquad T=\alpha U+\beta G.
\]
The first two expressions satisfy \(hG-yU=x\). For the nontrivial composite in \(A\), writing \(T_0=\alpha U+\beta G\) gives
\[
hT_0-\beta x=U,\qquad yT_0+\alpha x=G,
\]
by \(hG-yU=x\) and \(\alpha h+\beta y=1\). The other composite is
\(\alpha(hT-\beta x)+\beta(yT+\alpha x)=T\).
Recover \(W=W_0\) and \(V=G-UW_0\). These establish the complete \(B\)-algebra inverse, not merely a parameter on an open set.

[S]:180–246 supplies this proof; [V]:230–254 replays nine constituent identities (`sep_linear_S` through `sep_T_inverse`). The \(U,G\) composite just displayed is also checked algebraically here; the script does not name separate checks for both of those equalities. Every coefficient in these residual identities is integral. Their free-polynomial validity therefore specializes to any commutative ring, including rings with zero divisors and the zero ring. A rational-coefficient ideal-membership test by itself would not justify that generalization; it is not what is being used here.

## 4. `C_SEP_TRANSLATION`, version 1: supported

This time \(h,x,y,s\) are independent generators **before** imposing relations. Define
\[
B=\mathbb C[h,x,y,s]/(h-1-p(x,y,s),\,x^2+y^3-sh).
\]
The translation over \(\mathbb C[s]\)
\[
X=x+s^3,\quad Y=y-s^2,\qquad
x=X-s^3,\quad y=Y+s^2
\]
is invertible, and direct expansion gives
\[
X^2+Y^3=x^2+y^3-sp(x,y,s).
\]
In particular, the two \(s^6\) terms cancel with the printed signs. Eliminating \(h=1+p\) changes the other relation into \(X^2+Y^3-s=0\). Eliminating the monic variable \(s\) gives \(B\cong\mathbb C[X,Y]\). Explicitly its inverse presentation is
\[
s=X^2+Y^3,\quad x=X-s^3,\quad y=Y+s^2,\quad h=1+p(x,y,s).
\]
There is no use of ambient algebraic independence of the polynomials \(x,y,s\).

For the required comaximality, use the actual polynomial witnesses
\[
\alpha=1+2s^2x+4s^5,\qquad
\beta=(3s^3-3sy)(1+2s^2x)-4s^4y^2.
\]
The free-polynomial identity is
\[
\alpha h+\beta y-1
=(1+2s^2x)(h-1-p)-4s^4(x^2+y^3-sh).
\]
It proves \(\alpha h+\beta y=1\) **in \(B\)**. In the ambient \(R\), it instead reads \(\alpha h+\beta y-1=(1+2s^2x)F\); one must not impose the Bezout equation away from \(F=0\).

Sources: [S]:259–290 (`eq:shiftidentity`, `eq:B`, `eq:Bplane`, `eq:Bparam`) and 348–359 (`eq:alphabeta`, `eq:certificate`); exact replay checks `sep_cusp_translation` and `sep_explicit_bezout` at [V]:256–264. The source's shorter quotient argument also works with nilpotents: modulo \((h,y)\), \(x^2=0\) and \(1=2s^2x\), whose square forces \(1=0\). The explicit witnesses remove any reliance on a closed-point/Nullstellensatz interpretation.

## 5. `C_SEP_ZERO`, version 1: supported

Form the lifting algebra of section 3 over the \(B\) in section 4. In its seven-generator presentation, the three equations
\[
x=u^3+hv,\qquad y=-u^2+hw,\qquad s=S(h,u,v,w)
\]
eliminate \(x,y,s\) exactly. The relation \(x^2+y^3-sh\) becomes the zero polynomial (`sep_cusp`), and \(h-1-p\) becomes the literal \(F\). Consequently this algebra is \(R/(F)\), not merely a localization or a quotient mapping onto it. Therefore
\[
R/(F)\cong B[T]\cong\mathbb C[X,Y,T].
\]
This is the argument of [S]:292–304 (`eq:fiber`).

For completeness, the zero-fibre coordinate map is
\[
(h,u,v,w)\longmapsto
\bigl(x+s^3,\ y-s^2,\ \alpha u+\beta(v+uw)\bigr).
\]
Given independent \(X,Y,T\), reconstruct \(s,x,y,h\) by section 4, then \(\alpha,\beta\) above, and set
\[
\begin{aligned}
u&=hT-\beta x,& g&=yT+\alpha x,\\
w&=\alpha(1+\beta y)(y+u^2)
  +\beta^2(s-hg^2+2uyg),&
v&=g-uw.
\end{aligned}
\]
These are [S]:361–376 (`eq:fibercoords`, `eq:explicitinverse`). Their two composites are identities by the two triangular eliminations and the complete \(U,G,W,V\) inverse proof in sections 3–4. In particular every relation is respected; no \(h^{-1}\), \(y^{-1}\), or open-chart restriction is needed.

The replay verifies the constituent identities, **not** a separately expanded four-variable composite of these potentially large formulas. The quotient universal properties and inverse-map proof supply that obligation. This is an isomorphism of the zero fibre only; it is not an ambient automorphism with first component \(F\).

## 6. `C_SEP_CRITICAL`, version 1: supported in every polynomial extension

In the original ambient ring, without setting \(F=0\),
\[
X^2+Y^3=hs-sp=s(h-p)=s(1+F).
\]
At the exact rational point \(P=(2,0,-1/2,1/2)\), in order \((h,u,v,w)\),
\[
(x,y,s,p,X,Y,F)=(-1,1,1,2,0,0,-1).
\]
Differentiation gives
\[
2X\,dX+3Y^2\,dY=(1+F)\,ds+s\,dF.
\]
Since \(s(P)=1\), this specializes to \(dF(P)=0\). Independently, the shared replay substitutes this rational point into the literal composed polynomial and all four symbolic partial derivatives: `sep_critical_value` and `sep_critical_derivative_h/U/V/W` all have exact zero residual. The use of uppercase `U,V,W` in those check names is just the script's symbol naming; it corresponds to the manuscript's \(u,v,w\).

The zero fibre is smooth affine three-space. The hypersurface fibre **\(F=-1\)** is singular at \(P\), by the hypersurface Jacobian criterion over \(\mathbb C\). Its equation \(F+1\) is nonzero (at \((1,0,0,0)\), \(F+1=1\)), but is in the square of the maximal ideal at \(P\); its local hypersurface ring has embedding dimension four and dimension three. This claim concerns the fibre scheme defined by that equation; no assertion about all other fibres is needed.

If \(F\) were a coordinate, take a polynomial automorphism having \(F\) as its first component. Its Jacobian at \(P\) has a zero first row. The chain rule with its polynomial inverse makes that same matrix invertible, a contradiction. This proves noncoordinateness without relying on an abstract classification of the singular fibre.

For every finite \(m\geq0\),
\[
R[z_1,\ldots,z_m]/(F)\cong\mathbb C[X,Y,T,z_1,\ldots,z_m].
\]
The extended \(F\) has its original zero derivatives at \((P,0,\ldots,0)\), and all added-variable derivatives are identically zero. The same chain-rule proof works for a matrix of size \(4+m\). Thus the polynomial is **not a stable coordinate**, and its affine-space zero fibre persists in every ambient dimension at least four. These are [S]:306–339 (`eq:ambient` and `cor:dimension`), not an inference from any October assertion.

## 7. Sole fresh full symbolic replay

### Safety inspection and output adaptation

All of [V] was inspected before execution. Its `compute()` performs exact SymPy algebra and reads three preserved JSON files at lines 274–276; it does not write files, call a process, or contact a service. Its `main()` at lines 341–356 **does not support `--output`**. It supports `--write-certificate`, which would overwrite the preserved certificate. That main routine and that writing option were never executed.

The review-local [`replay_exact.py`](replay_exact.py) adds only output transport, a 110-second subprocess bound, provenance, and JSON-content comparison. It loads [V] using `runpy.run_path` with a non-`__main__` run name and calls the **unchanged `compute()`** once. It introduces no mathematical expressions or substitute checker. Both the adapter and its child receive the explicit current-unit `--output` path. All manually written artifacts and generated outputs are confined to this review directory. `PYTHONDONTWRITEBYTECODE=1` was set; no `__pycache__` directory was created in the preserved verifier directory.

Before that adapter was written, a delegated preliminary probe inspected the read-only `polynomial.ideal.normal_form.compute` contract via
`$WORKSPACE/argus-latest/.venv/bin/python -m argus_skill.tools.jacobian inspect --operation polynomial.ideal.normal_form.compute`.
The command exited 0; its exact response is [`installed_normal_form_contract.json`](installed_normal_form_contract.json). This legacy-wrapper probe did not follow the current canonical-interpreter directive and is retained as an operational limitation, not relabelled as a compliant live invocation. The parent's separate discovery, exact-contract inspection and bounded GCD execution use `$WORKSPACE/argus-live-update/.venv/bin/python` directly; their JSON payload and typed result are in `../provenance-known-status/`. The preliminary response reports server 0.14.0 and protocol `2025-11-25`. Its scope is bounded exact normal forms in \(\mathbb Q[\mathbf x]\), with at most eight variables, 64 generators and 4096 terms per polynomial; incomplete outcomes include `ERROR`, `LIMIT_EXCEEDED`, and `TIMEOUT`. Neither that contract nor the parent's GCD result certifies arbitrary-ring lifting or a universal LND statement. The symbolic replay itself calls the unchanged local SymPy computation, not this adapter.

### Execution and result

The Argus virtualenv lacked SymPy package metadata: an initial dependency preflight exited 1 **before loading [V], launching the child, or running any symbolic check**. Its exact command, error, and resolution are preserved in [`exact_replay_preflight.json`](exact_replay_preflight.json). No package was installed and no failed mathematical replay is counted. An existing non-Argus interpreter already had the required dependencies:

```text
PYTHONDONTWRITEBYTECODE=1 $WORKSPACE/miniconda3/bin/python \
  research/draft_reviews/september-construction-critical-point/replay_exact.py \
  --output families/049/argus-review/draft_reviews/september-construction-critical-point/exact_replay.json
```

* Python: 3.13.5, Anaconda build, GCC 11.2.0; SymPy **1.14.0**, mpmath **1.3.0**.
* Started `2026-11-07T18:54:39.970999+00:00`; completed `2026-11-07T18:54:40.630231+00:00`; bounded-child elapsed **0.646261835 seconds**.
* Child exit **0**, adapter exit **0**, tool command exit **0**; no timeout, deferred task, or background session.
* **81/81 checks:** 70 exact polynomial/localized identities, six exact \(\mathbb Q\)-ideal-membership computations, five exact nonzero-polynomial witnesses.
* The complete ordered list of 81 check dictionaries, including statements, residuals, ideal generators and nonzero witnesses, equals [E] by contents. The entire result also equals [E], and its serialized bytes match. No changed, missing, or additional check entry was found.
* [`exact_replay.json`](exact_replay.json) has SHA-256 `104d3503ab1d34038b0d5a9a2dc633a6a223769866f4107570a3aa51815799c9`, identical to the preserved certificate.
* [`exact_replay_run.json`](exact_replay_run.json) records commands, interpreter, versions, counts, names, comparison results, timeout bound, timestamps and before/after hashes. All eleven hashed preserved/source/manifest inputs are unchanged.
* [`exact_replay.stdout`](exact_replay.stdout) contains `PASS: 81 exact checks from unchanged compute(); preserved main() was not called.`; [`exact_replay.stderr`](exact_replay.stderr) is empty.

This is the **one common full symbolic replay for the corpus**; other units should cite it, not rerun it unchanged. The earlier dependency failure executed zero symbolic checks.

The seventeen September entries are `sep_cusp`; `sep_linear_S`, `sep_linear_first`, `sep_compatibility`, `sep_squared_bezout`, `sep_W0_first`, `sep_W0_second`, `sep_ideal_W`, `sep_UG_relation`, `sep_T_inverse`; `sep_cusp_translation`, `sep_explicit_bezout`; `sep_critical_value`; and the four critical-derivative entries. They are exact algebra, not sampled numerical experiments.

The old function additionally checks consistency of the **historical** Jacobian request, contract, server/protocol identifiers and zero-remainder result. It does **not** call Jacobian afresh. In particular, the `adapter_exit_code: 0` inside the reproduced certificate's `jacobian` field describes old evidence, not a new service computation. The independent SymPy ideal reductions are fresh.

## 8. Proof obligations not supplied by “81 PASS”

| Obligation absent as a standalone computational theorem | Engineering disposition |
|---|---|
| Quantification over every commutative base, including nilpotents, zero divisors, all characteristics and the zero ring | Closed by the integral identities, ideal equality and explicit inverse in section 3; not by rational-point tests or \(\mathbb Q\)-Groebner computations. |
| Both \(U,G\) composites and the full zero-fibre inverse | Closed algebraically in sections 3–5; the giant composite was not separately expanded by the script. |
| \(B\cong\mathbb C[X,Y]\) and the precise kernel giving \(C\cong R/(F)\) | Closed by invertible translation and monic variable elimination, not by the mere vanishing of a few substituted relations. |
| From a critical point to noncoordinateness in arbitrarily many variables | Closed by the chain rule and the symbolic extension argument of section 6; five point checks alone do not quantify over ambient automorphisms or all dimensions. |
| September theorem in Lean | Not supplied. [F]'s eight prints concern determinant principalization, the October signed quadric, rigidity, invariant exclusion, and October literal coordinate assertions. They neither state nor formalize this cusp lifting theorem or September \(F\). No Lean compilation or rebuild was attempted here. |
| Universal October obstruction, arbitrary LNDs, or all polynomial-family members | Not proved by this replay. Their separate unit assessments are necessary; the shared certificate itself says universal claims are not inferred from computation. |

Computational trust is ordinary CPython/SymPy exact algebra over integers/rationals, not a fresh proof-kernel certificate. The mathematical assessment separately uses only polynomial-ring/quotient universal properties, Bezout ideal combinations, the polynomial inverse chain rule, and (for the singular-fibre description) the hypersurface regularity/Jacobian criterion over \(\mathbb C\). No external classification theorem, literature novelty claim, or October theorem is needed for the four September conclusions.

**Remaining scope limits:** no unsupported mathematical obligation was found within the stated four claims; there is no new September formalization, no priority/novelty determination, no claim of correctness of unreviewed paper sections, and no independent acceptance. Those limitations are not evidence of a counterexample to the manuscript. The old ledger and all global coverage files were left untouched.
