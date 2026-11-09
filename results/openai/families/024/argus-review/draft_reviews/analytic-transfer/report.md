# Quantitative ordered prefix-collision transfer

**Engineer assessment: `supported_in_stated_scope`, conditional on the two
named external analytic inputs.** The existing prose argument supports its
quantitative transfer theorem (T) and hence the staged prefix-collision
proposition. It does not certify the main totient asymptotic, and none of its
finite computations compiles this analytic argument. This is a completed unit
assessment at **exploratory** level. The native Host-invoked Reviewer accepted
it as part of the complete **bounded substantive review**, recorded in
[`round-0001.json`]($WORKSPACE/.argus-campaign-9200024/projects/245cf7797dc6/handoffs/22092fed6282/round-0001.json).
That acceptance is not final project delivery; the corrected review is
returned to the Host for final disposition.

## Exact source, objects and quantifiers

The primary draft is the read-only
`9000024/research/prefix-collisions/proof.md`, equations (1)-(23), with preserved
snapshot hash
`089c7da006ddbaf8d2f15f46fb67ffe6b54c4718a3907fd5535d993037dbe38c`.
Its target is `collisions.tex`, `prop:collisions`, in the September 25, 2026
manuscript. All eight TeX files match the existing reference-manifest version
`4eaee87548250b2682affda7d05d947c05554bae`. The reference symlink resolves to the
manifest's source directory; no historical source or manifest was edited.

Let \(a_j=\int_j^{j+1}\log t\,dt\), and let \(\rho\in(0,1)\) be the unique
root of \(\sum_{j\ge1}a_j\rho^j=1\). Set \(\lambda=\log(1/\rho)\),
\(B=\log\log x\),
\[
 m=\left\lfloor\frac{\log B-\log\log B}{\lambda}\right\rfloor,\qquad
 g_0=1,\quad g_j=\sum_{d=1}^j a_dg_{j-d},\qquad
 G_j=\frac{B^j}{j!\prod_{r=1}^j g_r}.
\]
The phase \(\theta\) is the fractional part defining \(m\).
For a sufficiently large fixed positive integer \(H\), put
\(P=\lfloor\log\log H\rfloor\), \(R=m-H\), \(L=m-P\).

A tuple is \(\tau=(p_0,\ldots,p_R,d)\), not a preimage or a collection of tail
witnesses. A basic witness extends its decreasing displayed primes through
\(p_L\), with an integer \(a\ge1\), \(P^+(a)\le p_L\),
\(\log a\le\exp(2\widetilde b_L)\), \(p_0\ge x^{0.9}\), and the specified
coarse bands and simplex inequalities. Here
\[
 \alpha=B\rho^m/m,\quad b_i=\alpha(m-i)\rho^{-(m-i)},\quad
 \widetilde b_i=\lambda e^{\lambda\theta}(m-i)\rho^{-(m-i)},\quad u_0=B.
\]
For \(i\ge1\), \(u_i=\log\log p_i\). The tail has
\(w=p_{R+1}\cdots p_La\), \(d=\varphi(w)>0\), and
\(F(\tau)=d\prod_{j=0}^R(p_j-1)\).

Goodness requires **every** basic witness of this tuple, for every
\(0\le i\le R\), to satisfy the strict simplex slack, \(S_i\)-normality,
squarefreeness of the whole displayed comparison product on primes **strictly
above** \(z_i\), and \(\Omega(D_i)\le b_i/(m-i)^8\).
The source normality definition counts prime factors with multiplicity:
\[
 \Omega(p-1,1,S)\le2\log_2 S,\quad
 |\Omega(p-1,U,T)-(\log_2T-\log_2U)|
 <\sqrt{\log_2S\,\log_2T}
\]
for every \(S\le U<T\le p-1\).
Here \(D_i=\varphi(p_{i+J_i+1}\cdots p_La)\),
\(J_i=\lceil30\log(m-i)\rceil\),
\(\log_2 S_i=b_i^{1/3}\), and \(\log_2 z_i=0.7b_{i+J_i}\).

With all these parameters formed from **x**, \(\mathcal G(t)\) restricts good
tuples by the **closed** inequality \(F(\tau)\le t\).
Let \(K(t)\) count **ordered unequal tuple pairs** with equal values.
The strongest existing draft asserts absolute \(C,\kappa>0,H_0\) such that,
for each fixed integer \(H\ge H_0\), all sufficiently large \(x\), and
**simultaneously every real \(0\le t\le x\)**,
\[
 \frac{K(t)}{xG_m/\log x}
 \le C e^{-\kappa B/m^4}
   +C\sum_{h\ge H}h^4e^{-\kappa\rho^{-h}/h^3}. \tag{T}
\]
Constants and sufficiently-large estimates are uniform in phase; \(x\) is
chosen after \(H\), not separately after each \(h\).
The manuscript explicitly defines the two requested endpoints \(x,x/c\),
with fixed \(c>1\). The all-\(t\) assertion uses the natural extension of that
same definition, not a different parameter choice. It implies
\[
 K(t)\le(\epsilon_H+o_{x;H}(1))xG_m/\log x,\qquad \epsilon_H\longrightarrow0.
\]
There is no conversion to unordered pairs, collided values or tail-preimage
counts hidden in this statement.

## Retrieved assumptions and attribution

| External input | Exact version and passage read | Use and limit |
|---|---|---|
| Ford's ordered comparison bound | Kevin Ford, *The distribution of totients*, `arxiv:1104.3264v2`, 14 July 2013, Lemma 5.1, printed pp. 21-24. The existing text, p. 21 statement image and complete historical excerpt were opened. | Its original size, cutoff, normality, unequal-prime, smoothness and large-divisor hypotheses are retained. The proof's additional \(k\le\log_2 y\) on p. 23 is met. The theorem is an external analytic input, not proved by this review. |
| Mertens unit-box estimate | The same version, proof of Lemma 3.1, p. 11, including the displayed \(s_m=\sum_{p\in I_m}1/(p-1)=1+O(e^{-m})\). | With \(m=v+1\), this gives \(\sum_{v\le\log_2 p<v+1}1/(p-1)=1+O(e^{-v})\) for integer \(v\ge2\), uniformly. The index shift changes only an absolute constant. |

These are recorded as `A_FORD51_RETRIEVED` and `A_MERTENS_RETRIEVED` in the
**active** ledger. The defining-root bounds are instead discharged by the
exact-arithmetic unit; the historical decimal-value dependency was retired
with its reason. The projected-prefix proof does not assume the renewal
asymptotic \(g_j\sim\gamma\rho^{-j}\), the full totient theorem, extraction
coverage or the discarded-tuple estimate.

Ford's lemma has parameters \(k\ge1,\ell\ge0\), not a fixed-layer-only
assertion. Its actual count has factor
\[
 \frac{y}{dr}(c_4B_y)^{6k}(k+1)^{\Omega(d)}
 (\log V_k)^{20(k+\ell)\log(k+\ell)+1}
 (\log y)^{-2+\sum_{j=1}^{k-1}a_j\nu_j+E},
\]
where
\(E=\delta\sum_{j=2}^k(j\log j+j)+2\sum_{j=1}^{k-1}(\nu_j-\mu_j)\).
The primary image settles the weak/strict symbols obscured in extracted text,
in particular squarefreeness at primes **at least** \(V_k\).

The old Argus author is `engineer:prefix`. The application-level uniform
transfer is the draft's claimed contribution. The root, recurrence,
shifted-prime comparison method, allocation bound and monotonicity ingredients
are classical/elementary reproductions. Novelty of the application has **not**
been verified. The Spring 2023 sieve notes are cited by the manuscript's
separate `layers.tex` comparison, but are not an external assumption of this
Argus route; reading their identity does not certify that separate theorem.

## Checking the decisive analytic chain

### Scales, suffix identity and alignment

Write \(h=m-i\), \(\beta=b_i\), \(J=\lceil30\log h\rceil\).
The alpha comparison and the exact root/logarithm bracket give, uniformly,
\(1/2\le\alpha\le3\), \(0.99\le\alpha_\theta/\alpha\le1\),
\[
 J<h/2,\qquad
 c h^{-20}\le b_{i+J}/\beta=(1-J/h)\rho^J\le C h^{-18},\qquad
 \log\beta=O(h).
\]
The ceiling affects only fixed factors, since \(18<30\lambda<20\).
Also \(i+J<L\) because \(P<h/2\). These are whole-tail asymptotic bounds,
not extrapolations from 480 finite examples.

Distinct collided tuples have a unique first unequal displayed prime index:
otherwise the equal value would also force \(d=d'\).
The displayed primes before the residual are coprime to that residual
preimage; repetitions of \(p_L\) in \(a\) occur entirely inside the residual.
Thus the suffix identity
\[
 v=D\prod_{j=0}^J(p_{i+j}-1)
   =D'\prod_{j=0}^J(q_{i+j}-1)
\]
is exact. Choosing one admissible continuation per suffix pair avoids witness
multiplicity; counting the larger set of all admissible auxiliary descriptions
is still an upper bound.

The post-\(p_i\) preimage tail has logarithm at most
\(h e^{0.62\beta}+e^{2\widetilde b_L}\), whereas
\(\log p_i\ge e^{0.88\beta}\). Here
\(2\widetilde b_L<0.61\beta\) uniformly once \(H\) is large.
For \(i\ge1\), placing \(v\) in \((y/2,y]\) gives
\[
 p_i,q_i\ge y^{0.9},\quad
 0.88\beta\le B_y=\log_2y\le1.12\beta,\quad u_i\le B_y+O(1).
\]
For \(i=0\), \(y=x\) and \(u_0=B=B_y\), rather than \(\log_2p_0\).
Using the convention correctly changes the actual largest-factor height by
only \(O(1)\).

Normality implies \(\Omega(p_{i+j}-1)\le4B_y\) and hence
\(\log_2P^+(p_{i+j}-1)=u_{i+j}+O(\log\beta)\).
The disjoint band gaps are at least \(c\beta h^{-20}\), much larger than
this error; all these largest factors exceed \(z\), while both residuals are
\(z\)-smooth.
For \(A_j>A'_j\), the first \(j+1\) shifts on one side contribute at least
\((e-\delta)B_y\) factors to \((A'_j,A_j]\); only the first \(j\) on the
other side can contribute, each at most \((e+\delta)B_y\).
Here \(e=(\log_2A_j-\log_2A'_j)/B_y\), and
\(\delta=\sqrt{\beta^{1/3}/B_y}=O(\beta^{-1/3})\).
All relevant lower endpoints exceed \(S\). Capping an upper endpoint at its
shift only decreases its upper contribution. Equality of products therefore
gives \(e\le(2j+1)\delta\); reversing the sides proves the other order.
This checks the alignment argument with multiplicities, not just distinct
prime factors.

### The actual Ford hypotheses

Cancel equal primes only at the same original band index, and let \(r\) be the
product of their shifts. The first index survives, and \(1\le b\le J+1\).
Apply the lemma with **\(k=b,\ell=1,f_1=1,d=D,e=D'\)**.

| Required hypothesis | Why the actual configuration satisfies it |
|---|---|
| Ordered cutoffs and \(S\le V_b\) | Use \(\log_2V_b=0.75b_{i+J}\), strictly above \(\log_2z=0.7b_{i+J}\). The lowest surviving largest factors have height at least \(0.9\widetilde b_{i+J}-O(\log\beta)\), leaving a positive gap. |
| Paired largest factors in closed intervals, unequal paired primes | The alignment bound allows padded delta-grid intervals of width \(O(J\delta)\); disjoint original bands preserve their order after cancellation. |
| Normalized gaps at least \(2\delta\) | Gaps are at least \(c h^{-20}\), whereas the grid perturbation is \(O(J\delta)=o(h^{-20})\). |
| \(V_1\le y^{1/(10B_y)}\) | All positive-index upper heights are below \(0.75B_y\), since \(0.62/0.88<0.75\); \(10B_y e^{-B_y/4}\to0\). The case \(b=1\) uses \(V_1=V_b\). |
| \(r\le y^{1/10}\), \(D\le y^{1/100}\) | Each logarithm is at most \((h+1)e^{0.62\beta}\), with ratio to \(\log y\) at most \((h+1)e^{-0.26\beta}\to0\) uniformly. |
| Smooth residual and auxiliary factors | \(P^+(D),P^+(D')<z<V_b\); the unit factor has \(\Omega(f_1)=0\). |
| Squarefreeness at primes at least \(V_b\) | Goodness makes the entire common product squarefree above \(z\); every prime at least \(V_b\) is strictly above \(z\), and cancellation preserves this. |
| Top large divisor at least \(y^{1/2}\) | The part of \(p_i-1\) at primes at most \(V_1\) has logarithm at most \(4B_y e^{0.75B_y}=o(\log y)\), while \(p_i\ge y^{0.9}\). The complementary part is larger than \(\sqrt y\). |
| \(k\le B_y\) used on p. 23 | \(k=b\le J+1=O(\log h)\), whereas \(B_y\asymp\beta\) grows exponentially with \(h\). |

The unit factor also makes \(k+\ell\ge2\), avoiding a degenerate
smooth-allocation interpretation when \(b=1\). No original size restriction
has been silently removed to apply a nearby theorem.

### Slack, two residuals and summing the descriptions

If the surviving positive original indices are \(j_k\ge k\), then
\(a_k\le a_{j_k}\). Using largest-factor upper bounds and the strict good
simplex inequality gives
\[
 \sum_{k=1}^{b-1}a_k\nu_k
 \le1-h^{-4}+O(B_y^{-1}+J^2\log(2J)\delta).
\]
The lemma's error has the same latter order. Exponential growth of \(\beta\)
therefore leaves logarithmic exponent at most \(-1-1/(2h^4)\), uniformly
for all \(h\ge H\) after increasing \(H\).
The per-layer constant stays raised to \(b\); it is not treated as a
fixed-depth constant.

For \(R>i+J\), the missing tuple coordinates give the **ordered** factorization
\[
 D=d\prod_{j=i+J+1}^R(p_j-1).
\]
The bound \(w<p_R\), obtained directly from the coarse tail size, ensures the
needed coprimality. For \(R\le i+J\), no tuple primes are forgotten and
\(d=D\prod_{j=R+1}^{i+J}(p_j-1)\).
The same statements hold for the primed side.
Each factorization recovers each missing prime uniquely by adding 1, and the
residual slot recovers \(d\). Together with the selected comparison data this
is injective on ordered suffix pairs, not on preimage witnesses.

The universal finite core bounds a positive integer's \(k\)-factorizations
by \(k^{\Omega(n)}\), retaining repeated occurrences. Both sides are needed:
\[
 (h+1)^{\Omega(D)+\Omega(D')}
 \le \exp\{2\beta\log(h+1)/h^8\}.
\]
This source-specific injection was checked in prose here; its universal
finite-set bound is the separately compiled unit.

Before enlarging the residual sums, use the two \(\Omega\) restrictions also
in Ford's factor \((b+1)^{\Omega(D)}\).
Mertens gives \(O(\beta)\) reciprocal-shift mass per canceled prime and
\[
 \sum_{P^+(D)<z}D^{-1}
 \le\prod_{p<z}(1-1/p)^{-1}=O(\log z).
\]
The Euler product includes repeated powers. The product estimate follows by
summing the unit-box prime estimate and using
\(-\log(1-1/p)=1/p+O(1/p^2)\).
Canceled-index sets, grids and per-layer constants cost \(\exp(O(h^2))\).
The logarithm of all positive costs is
\[
 O(h^2)+O(\beta\log h/h^8)
       +O(\beta\log h\log\log(3h)/h^{18})=o(\beta/h^4).
\]
The respective ratios are controlled by
\(h^5\rho^h,\ \log h/h^4,\ \log h\log\log(3h)/h^{14}\).
Thus one obtains \(C y(\log y)^{-1}e^{-\kappa B_y/h^4}\) suffix pairs in
each dyadic interval. The arithmetic certificate supports decay facts;
it does not verify this counting chain or give an effective analytic \(H_0\).

### Projected-prefix mass without an asymptotic assumption

For the unit-coefficient simplex, the triangular variables
\(s_i=u_i-\sum_{r>i}a_{r-i}u_r\) have determinant 1.
The recurrence gives
\(u_i=\sum_{r\ge i}g_{r-i}s_r\); the zeroth inequality becomes
\(\sum_{r=1}^j g_rs_r\le B\).
The volume is therefore exactly \(G_j\), including dimension zero.
Induction from the defining root gives \(0<\rho^jg_j\le1\), without invoking
Ford's recurrence asymptotic. For \(q=m-j\),
\[
 G_j/G_m
 =\prod_{r=j+1}^m(rg_r/B)
 \le\alpha^{-q}\rho^{q(q-1)/2}\le C.
\]
The last bound follows from a negative quadratic exponent in \(q\) and
\(\alpha\ge1/2,\rho<109/200\); it also gives \(1/G_m\le C\).

Unit boxes perturb a simplex constraint by \(O(h_i^2)\). Basic lower bands
allow coefficients enlarged to
\(\eta_i=1+C(e^{-h_i/40}+h_i^2\rho^{h_i})\).
Dividing \(u_i\) by \(\prod_{r<i}\eta_r\) maps this enlarged simplex into the
unit-coefficient simplex: later-coordinate scale ratios are at least
\(\eta_i\), so the original constraint yields the new one.
Its inverse Jacobian is bounded by
\[
 \prod_{r<j}\eta_r^{j-r}
 \le \exp\left\{C\sum_{h\ge H}h(e^{-h/40}+h^2\rho^h)\right\}\le C.
\]
Mertens' unit-box errors also have bounded product, because the lower
double-logarithmic prime bands grow geometrically.
The box union consequently has reciprocal-shift mass \(O(G_m)\).
For \(j=0\) the mass is 1, already covered by the preceding ratio.
This verifies the required upper bound, not a limiting arithmetic coefficient.

### Dyadic restoration and exact endpoint fidelity

Dividing each dyadic count by its lower value endpoint gives weighted suffix
mass at most
\[
 C\sum_{\log(n\log2)\ge0.88\beta-O(1)}
   \frac{e^{-\kappa\log(n\log2)/h^4}}{n\log2}
 \le C h^4e^{-\kappa'\beta/h^4}.
\]
The summand is decreasing; its first term and integral are both controlled.
With \(u=\log(n\log2)\), \(dn/(n\log2)=du/\log2\).
There is **no** spurious \(e^\beta\) loss from this substitution.

For fixed suffix and common \(p_1,\ldots,p_{i-1}\), the number of common
largest-prime choices is at most
\[
 \frac{Cx}{\log x}\frac1{v\prod_{j=1}^{i-1}(p_j-1)}.
\]
If nonempty, its upper endpoint is at least \(x^{0.9}\), giving a logarithm
comparable to \(\log x\). The needed bound \(\pi(X)=O(X/\log X)\) is
elementary: primes in \((N,2N]\) divide \(\binom{2N}{N}<4^N\), dyadic summation
bounds \(\sum_{p\le X}\log p=O(X)\), and separating \(p\le\sqrt X\) proves it.
The prime number theorem is not an additional input here.
Restoring the other common primes uses only the projected mass just proved.
Since \(\beta\ge c h\rho^{-h}\), summing \(i\ge1\) yields the tail in (T).
It converges, with terms eventually bounded by \(C h^4e^{-\kappa''h^2}\).
At \(i=0\), \(y=x\), and \(1/G_m\le C\) gives the first term in (T);
\(B/m^4=\alpha\rho^{-m}/m^3\to\infty\).

All witnesses of a fixed tuple have the same \(F(\tau)\). Keeping the
x-dependent definition unchanged therefore gives
\[
 \mathcal G(t)=\{\tau\in\mathcal G(x):F(\tau)\le t\},\qquad K(t)\le K(x).
\]
The normality, slack and **universal-witness** predicate are unchanged, as are
the closed endpoints. Lean proves the generic finite ordered-pair implication;
this membership identity is the source-specific prose argument. Recomputing
parameters from \(t\), or asserting fixed-scale asymptotics from monotonicity
alone, would be a different and unsupported statement.

## Versions, failed routes and what actually improved

| Historical claim | Versions | Assessment |
|---|---|---|
| `C_PREFIX_COLLISIONS` | 1, 2, 3 | Same natural proposition; versions 2 and 3 record Ford and Mertens. The stronger quantitative all-endpoint statement lives in the prose draft. Supported conditionally in that scope. |
| `C_FORD_FIT` | 1, 2, 3, 4 | Ford added at 2, published decimal bracket added at 3 and retired at 4. Current actual restrictions were checked above using the independently proved root bracket. |
| `C_TUPLE_RECOVERY` | 1 | The source-specific injection and both residual multiplicities are supported, using the corrected finite core rather than witness enumeration. |
| `C_PROJECTED_PREFIX` | 1, 2 | Mertens recorded at 2. The required uniform upper bound is supported; no limiting coefficient follows from it. |
| `C_PREFIX_SUMMATION` | 1 | Uniform absorption, first dyadic term, restoration and convergent tail are supported under the named inputs. |

The retired `R_PREFIX_UNSHIFTED_CUTOFF` is genuinely invalid as a transfer
shortcut: for a prime cutoff \(z\), \(z^2\) is squarefree on primes strictly
above \(z\), but not on primes at least \(z\). For example \(z=2,n=4\).
This is a counterexample to that **abstract implication**, not an actual
manuscript tuple or proof that its transcendental cutoff is prime.
Raising \(V_b\) settles the application without any primality claim about \(z\).
The manuscript uses its own comparison with a strictly-above convention, so
failure of this literal Ford substitution does not refute that manuscript
theorem. The old incomplete Lean route was likewise a formalization-version
failure, not a refutation of the recovery mathematics.

Compared with the strongest relevant prior result, Ford Lemma 5.1, the draft
supplies the application: growing comparison depth, actual size/gap checks,
both residual decodings, empty-prefix restoration and a quantitative tail.
This review does **not** improve or repair T into a new research result.
It verifies and limits that existing claim, distinguishes failed substitutions
from source refutations, and sharpens the boundary of the coefficient claim.
No novel theorem or full manuscript refutation is delivered.

## Every historical main-theorem boundary claim

These are reference obligations, not five additional old Argus drafts:

| Historical version-1 claim | Exact source scope | Concrete missing obligation in the listed old work |
|---|---|---|
| `C_BASIC_COVERAGE` | `extraction.tex`, `prop:basic`: for fixed large H, an exceptional set of totient values has size at most \((\varepsilon_H+o_{x;H}(1))V(x)\); **every** preimage of each remaining value has a basic witness. | Counting good-tuple collisions does not cover values with no good tuple or verify this universal preimage assertion. The deterministic cofactor bound used above was derived directly, not the exceptional-set count. |
| `C_DISCARDED_TUPLES` | `prop:discard`: at both common endpoints, tuples with **any** failing basic witness number at most \((\varepsilon_H+o_{x;H}(1))xG_m/\log x\), with \(\varepsilon_H\ll K_HH^{-2}\). | T counts only good tuples. It neither bounds the complement nor proves the boundary/normality/squarefreeness/residual exceptional sums. |
| `C_PREFIX_LIMIT` | `limits.tex`, `prop:tail-limit`: for fixed large H, \(\limsup_{x\to\infty}|M_f(x;H)/G_m-A_H(f;\theta(x))|\le\varepsilon_H\), with \(\varepsilon_H\to0\), independent of \(f:[1,\infty)\to[0,1]\) and phase. | A projected mass **upper bound** does not prove prime-to-volume replacement, witness unions or this coefficient approximation. The historical node's loose “limit” wording must not be strengthened to exact equality for every fixed H: the source retains an H-dependent error. |
| `C_COEFFICIENT_LIMIT` | Uniform convergence of \(A_H(1;s)\), \(s\in[0,1)\), to an everywhere positive bounded \(A(1;s)\); source comparison lemma uses an H-independent counting function and, for positivity, positive lower/upper bounds. | Neither the finite recovery theorem nor T supplies that comparison baseline, uniform Cauchy argument or positive lower bound. No continuity of A is required by the source and none should be imposed here. |
| `C_MAIN_ASYMPTOTIC` | `statements.tex`, `thm:main`: \(V(x)\sim xG_m A(1;\theta)/\log x\) and \(V(cx)/V(x)\to c\) for every fixed real \(c>0\), plus the preceding uniform coefficient assertions. | Requires coverage, negligible discarded tuples, collision control, common largest-prime counting and coefficient comparison. The fixed-scale ratio separately uses common endpoint mass and a positive Ford scale bound; endpoint monotonicity alone is insufficient. |

`C9000024` version 1 is the historical audit disjunction, not a mathematical
draft or a live instruction. All 13 historical claim identifiers and all 20
versions are mapped in the index; the two supporting units handle
`C_ROOT_BOUNDS` and `C_RECOVERY_CORE`.
There is no blanket correctness verdict for the manuscript: the five
boundaries remain **unresolved in the listed old Argus work**, not refuted.

## Evidence reuse and delivery limits

The old `reviewer:copilot-math` support opinions for these five analytic
claims and the four Ford/Mertens assumptions are identified in the index.
Their claim/assumption content matches the historical statements.
The preserved snapshot binds the current prose file, but those prose
judgements record its path, not an embedded reviewed-proof digest.
They are useful corroboration, not stronger source-version receipts than they
actually contain. This assessment therefore supplies the fresh decisive reading
above. The finite core's archived certificate does embed its source and
fidelity, and its unchanged text has now also received a fresh real compile.

The arithmetic replay reproduced all six historical result sections, including
480 diagnostics. One fresh Jacobian operation factored 360 completely.
Lean 4.31.0 compiler and axiom-audit exits were 0 with no proof holes for the
finite source. None of these observations mechanically verifies (1)-(23),
Ford's theorem or the main asymptotic; the analytic assessment is prose.

At the active campaign root
`campaigns/9200024`,
the recorded official math-state check exited 0, while the proof-graph check
exited 2 because no active `research/PROOF_GRAPH.json` existed. That path is
outside this mission's writable ownership. The earlier
`ambiguous_objective` report concerned applying a two-zero-exit campaign gate,
not an analytic counterexample. `OBJECTIVE.md` does not require an active
proof graph for this closed exploratory review, and the cited native Reviewer
accepted the bounded substantive review. The preserved graph failure is
nonblocking here; no graph was manufactured or failed check reported as passing.

The two active citations remain machine-`unchecked`, although their primary
passages were opened and assessed above. The historical records are
judgement-tier opinions, not new literature-tier receipts. The official
`citation_check attribute` writer archives under `research/literature/`,
also outside the owned paths; the Engineer has neither forged a reader identity
nor silently discarded the source identifiers. `OBJECTIVE.md` does not impose
that archival requirement on this bounded substantive review. Native acceptance
does not change the machine statuses or claim new literature-tier evidence;
those preserved diagnostics are nonblocking for the accepted review.
Final project delivery is not claimed, and these corrected statements are
returned to the Host for final disposition.
