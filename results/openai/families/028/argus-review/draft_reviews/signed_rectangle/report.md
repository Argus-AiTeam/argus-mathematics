# Signed-rectangle draft review

## Assessment and source identity

**Engineer assessment: the stated quadratic bound is supported by the prose
argument, not by a kernel proof.** The checker replay succeeds in its explicitly
limited algebraic and finite-regression scope. This is a strengthening relative
to the supplied manuscript, not a manuscript refutation or an established
global novelty claim. Native independent Reviewer acceptance remains pending.

The old source is `9000028/research/signed_rectangle/PROOF.md`, theorem (T),
sections 1--6, with `STATEMENT_FIDELITY.md`. Their respective SHA-256 values are
`ea40e38714121560a32f1e5509ed326fc28d553dcc89b66f560416d5b4268e80`
and `28739d68ba026d9c3fd92100215ef51d1165374221ee52d81005f2789e63d099`.
Both match the existing November 6 snapshot manifest. All paths beginning
`9000028/` in this report are relative to the campaigns directory.

The comparison source is OpenAI, *Bounded-Step Walks on Gaussian Primes*,
September 26, 2026, `build/geometry.tex`, `lem:rectangle`, lines 84--230.
The existing manuscript-reference manifest fixes revision
`4eaee87548250b2682affda7d05d947c05554bae`; all eight staged TeX files
match that manifest and the reference-source files. No manifest was rebuilt.
The old Argus draft credits the manuscript's fixed-line and determinant
arguments, and proposes a different aggregation argument. It does not claim
that the concentration inequalities themselves are new.

The versioned identities are `C_RECTANGLE_SHARP` v1,
`e08622009d2d4b8cd2d5bf8b178255e5e1d818690cc8c64edcaca5e4fa5a6dfb`,
and `C_RECTANGLE` v1,
`940b03c4593adcdabf035f287656336e31dbd1713266a7303119832b3941caec`,
in `CTX_RECTANGLE` v1,
`cff530c2681091bb5a4f8e49aca74b70e84cd83ee2d615a50b24c3edf51ea73c`.
The index binds all six supporting claim identities, routes and opinions.
These are eight claims within one argument, not eight independent results.

## Exact theorem and statement fidelity

Fix an integer \(r\ge1\), real \(T\ge5\), distinct rational primes
\(p_1,\ldots,p_r\in[T,2T]\) with \(p_i\equiv1\pmod4\), and Gaussian
integers \(\alpha_i\) with \(N(\alpha_i)=p_i\). Independently choose
\(\pi_i\) fairly from \(\alpha_i,\overline{\alpha_i}\), and put
\(P=\prod_i p_i\). Fix, **before those choices**, a real
origin-centered rectangle \(Q\), with arbitrary orientation and half-lengths
\(R\ge W\ge1\). If \(0<d<1/4\) and \(RW\le P^{1-d}\), the claim is
\[
\Pr\!\left(Q\cap(\textstyle\prod_i\pi_i)\mathbb Z[i]\ne\{0\}\right)
\le \min\{1,\,3\exp(-d^2r/32)\}.                    \tag{T}
\]
The event concerns any nonzero Gaussian-integer multiple of the product,
not only the product. Constants are uniform over all these fixed data.
Associating a Gaussian factor with a unit does not change the product ideal.

This agrees with the supplied fidelity document. The original source asks for
absolute positive \(C,c,C_0\) with a cubic-exponent bound
\(C e^{-cd^3r}\) when \(d^3r\ge C_0\).
The new claim genuinely removes that threshold, rather than silently deleting
it from the original statement. There is no assertion about a rectangle
chosen after seeing the signs, simultaneous avoidance of all rectangles,
biased or dependent signs, repeated rational primes, or widths below one.

## Decisive mathematical argument

The following is a mathematical reading of the whole proof, not an inference
from the checker returning success.

### Arithmetic and the exponential moment

`C_SPLIT_ARITH` (section 1) is justified for the supplied factors. Rounding
both coordinates of a Gaussian quotient gives a remainder of norm at most
half the divisor norm. Euclidean division gives Bezout, hence irreducibles
are prime. A norm-\(p_i\) element is irreducible; factors with distinct prime
norms are nonassociate. The two conjugates over one odd split prime cannot
be associates: association would force a coordinate to vanish or
\(p_i=2a^2\). Thus a primitive integer vector \(v=(x,y)\) cannot contain
both conjugates, since their product would divide both coordinates by \(p_i\).
Its eligible factors have product dividing \(v\), so
\(\prod_{i\in I(v)}p_i\le N(v)\).

For an ordinary integer \(a\), \(\pi_i\mid a\) implies \(p_i\mid a^2\),
hence \(p_i\mid a\); the converse follows from \(\pi_i\mid p_i\).
If a chosen factor does not divide \(v\) but divides \(av\), primality
therefore forces \(p_i\mid a\). Pairwise distinctness is needed when
multiplying these missing rational factors.

`C_BERNOULLI_MGF` (section 2) is not an unexamined Hoeffding citation.
The induction \((2k)!\ge2^k k!\), using slack \(4k(k+1)\ge0\), and
the convergent nonnegative power series give
\(\cosh x\le e^{x^2/2}\) for all real \(x\).
Independence gives
\[
\mathbb E e^{\lambda\sum a_i(B_i-1/2)}
\le e^{\lambda^2\sum a_i^2/8}.
\]
Markov's inequality at \(\lambda=4t/(rL^2)\), when
\(\sum a_i^2\le rL^2\), gives the tail \(e^{-2t^2/(rL^2)}\).
The induction is universal; checking a factorial table would not replace it.

### Fixed-line bound and geometric separation

Set \(q=d^2r\) and first assume \(q\ge1\). Then \(dr\ge1/d>4\).
For a fixed primitive \(v\), let
\(L_\sigma(v)=\sum_{\pi_i\mid v}\log p_i\). Eligibility and fair signs give
\[
\mathbb E L_\sigma(v)=\tfrac12\sum_{i\in I(v)}\log p_i
\le\log|v|.
\]
The missing-factor argument bounds any nonzero witness on that line below by
\(|v|P e^{-L_\sigma(v)}\). Its length is at most \(\sqrt2R\), while
\(W\ge1\) gives \(R\le P^{1-d}\). A witness therefore requires
\[
L_\sigma(v)\ge\log|v|+d\log P-\tfrac12\log2.
\]
Since \(d\log P\ge dr\log T>\log2\), this exceeds its mean by at least
\(t=d\log P/2\). Taking \(L=\log(2T)\le2\log T\) in the preceding
tail yields
\[
\Pr(\text{witness on }\mathbb Rv)\le e^{-q/8}.
\]
This proves `C_FIXED_LINE` (section 3), uniformly for each fixed line;
it has not yet bounded the union over lines.

For `C_LINE_SEPARATION` (section 4), two sign vectors differing at
\(h\le dr/4\) coordinates have common Gaussian factor product \(c_*\)
with \(N(c_*)\ge P/(2T)^h\). For any two respective witnesses,
\(\det(w,w')\) is an integer multiple of \(N(c_*)\).
Rotation preserves the absolute determinant, and the same centered rectangle
gives \(|\det(w,w')|\le2RW\). The strict divisor margin is
\[
\frac{N(c_*)}{2P^{1-d}}
\ge\tfrac12T^{dr-2h}
\ge\tfrac12T^{dr/2}>25/2>1.
\]
Thus the determinant vanishes. The case \(h=0\) also proves uniqueness
of each bad vector's witness line. Bad vectors partition into finitely many
line classes, each of mass at most \(e^{-q/8}\), with different classes
at distance strictly greater than \(dr/4\).

### Aggregation, including the number-of-lines issue

`C_CUBE_MGF` (section 5) uses the Doob martingale of a 1-Lipschitz
function on the uniform \(r\)-cube. At a fixed prefix, its next increment
is a fair choice between \(a/2\) and \(-a/2\), with \(|a|\le1\),
by coupling identical suffixes. Conditional exponential moments and the
tower property give \(e^{r\lambda^2/8}\). The increments are not assumed
independent.

For nonempty sets \(A,B\) separated by \(s>0\), apply this bound to
\(f(x)=\operatorname{dist}_H(x,A)\) with both signs of \(\lambda\).
Since \(f=0\) on \(A\) and \(f\ge s\) on \(B\),
\[
\mu(A)\mu(B)\le
\exp(r\lambda^2/4-\lambda s)
\le e^{-s^2/r}
\]
at \(\lambda=2s/r\).

For disjoint separated classes of masses at most \(m\), let their total mass
be \(b\). If one class has mass at least \(b/3\), then \(b\le3m\).
Otherwise accumulate whole classes until their union has mass in
\([b/3,2b/3)\); the remaining union has mass greater than \(b/3\).
Separation is preserved across these two unions, so
\(b^2/9\le e^{-s^2/r}\). This proves `C_SEPARATED_CLASSES`:
\[
b\le3\max\{m,e^{-s^2/(2r)}\}.
\]
No count of directions or restriction on the number of classes has slipped
into this argument.

Applying it with \(m=e^{-q/8}\) and \(s=dr/4\) gives \(3e^{-q/32}\).
For \(0<q<1\), this exceeds one (for instance
\(e^{1/32}\le32/31<3\)), so the trivial probability bound handles that
branch. Intersecting with the trivial bound one proves (T).
Since \(d^2r\ge d^3r\), it implies the original rectangle statement with
\((C,c,C_0)=(3,1/32,1)\). No unresolved mathematical step was identified
inside these stated hypotheses by this Engineer reading.

## Improvement, failed approach and attribution limits

The strongest relevant prior result is already the old Argus quadratic bound;
this review does **not** improve it further. Relative to the supplied
manuscript, the improvement is from a cubic to a quadratic power of \(d\)
in the exponential decay, with explicit constants and no size threshold.
The original edge-boundary argument grows neighborhoods by
\(1+\Theta(d^2)\) for \(\Theta(dr)\) steps. Its exponent is consequently
of order \(d^3r\). The two-union concentration argument instead uses
separation squared over dimension, \((dr/4)^2/(2r)=d^2r/32\).
This explains the improvement without declaring the weaker original lemma
false or its expansion method invalid.

The retired `R_FIXED_LINE_UNION_ONLY` is genuinely insufficient: a bound for
each fixed line supplies no parameter-uniform bound on how many line classes
must be summed. Its failure refutes that Argus proof route, not the manuscript.
The completed proof uses separation and two unions instead.

The draft also supplies a valid construction for a **different** quantifier
order. After seeing an outcome, orient a rectangle along the product, with
\(R=\sqrt P,W=1\). It is admissible because \(d<1/4\) and contains the
product itself. Thus avoidance of all admissible rectangles simultaneously is
false. That construction does not refute (T), whose rectangle is fixed first.

No present global novelty claim is made. The old preliminary search is not
a priority certificate. Standard Gaussian arithmetic and bounded-difference
concentration are not original contributions; only the strengthening relative
to the particular supplied source is established here.

## Exact evidence replay and what it does not prove

The inspected `verify.py` reads adjacent JSON and checks proof/fidelity file
existence, uses SymPy and integer arithmetic, and prints JSON. It has no
file-write call, subprocess or network operation. It was executed directly
with `PYTHONDONTWRITEBYTECODE=1`, not imported into Argus or run through a
ledger-writing command. All thirteen old files retain their indexed contents,
sizes and modification times after execution.

[`replay.json`](replay.json) records the exact command, stdout, stderr,
toolchain and exit status: Python 3.13.5 at
`$WORKSPACE/miniconda3/bin/python`, SymPy 1.14.0, exit 0, empty stderr,
approximately 0.319 seconds. Its parsed output equals the historical
`verification_output.json`. No dependencies were installed into the shared
Argus environment; Argus modules themselves use the required
`argus-latest/.venv/bin/python`.

The successful replay covers ten symbolic identities, five nonnegative
coefficient certificates, exact rational margins, and a multi-affine
interpolation identity proving the normalized determinant's real-box range
\([-2,2]\). The vertex checks alone would not have established the last fact;
the interpolation identity is important.

It also reconstructs the archived Jacobian rational functions over
\(\mathbb Q(r,s,\lambda)\). The operation is
`matrix.symbolic.multiply.compute`, multiplying two 1-by-1 matrices whose
entries are \(r\lambda-2s\). The preserved typed result is
\(r^2\lambda^2-4rs\lambda+4s^2\), server 0.14.0, protocol
2025-11-25, transport `mcp-stdio`; the historical status says `completed`,
exit 0, empty stderr, and the reported server runtime is 22 ms.
Payload equality, operation identifiers, variable order, shape and output
polynomial are checked. The three dedicated old JSON files remain the exact
payload/output/status evidence; no new adapter call or present service-health
claim is needed to review this archived multiplication. This is not a
probabilistic oracle or a kernel certificate.

The Gaussian regression uses \(T=29\), primes \(29,37,41,53\), factors
\((5,2),(6,1),(5,4),(7,2)\), and \(d=1/5\). It obtains one bad sign vector
out of sixteen, probability exactly \(1/16\). The additional 176 primitive
integer vectors in \([-8,8]^2\) include both signs of a direction; they
are not 176 different unoriented lines. Each is tested with sixteen sign
choices and seven integer multipliers from \(-3\) to \(3\).
The rectangle is fixed along the all-unconjugated product before sampling.
Here \(q=4/25<1\), so (T)'s upper bound is the trivial one. This regression
does not test the nontrivial asymptotic exponent or establish a universal
geometric theorem.

The code does not prove Euclidean-domain arithmetic, infinite power-series
comparison, Markov's inequality, conditional expectation, the two-union
argument, or the surrounding manuscript. In particular its existence checks
do not bind the proof's bytes: that binding is supplied by the reviewed source
and snapshot hashes in the index, not by checker success.
There is no listed Lean source or compiler evidence. Accordingly no Lean
compile was necessary, and no `closed_kernel` verdict is asserted.

## Background sources and historical review

Conrad's *The Gaussian Integers* is a background comparator, not another
Argus draft. The local PDF and text are indexed independently of the snapshot
(which does not list them). A read-only `pdftotext -layout` extraction,
Poppler 22.02.0, equals the archived text byte for byte (112,927 bytes).
The inspected statements are Theorem 3.1 (Euclidean division, remainder norm
at most half), Corollary 7.9 (nonzero residues modulo a Gaussian prime
invert), Theorem 7.14 (quotient cardinality \(N(\alpha)\) for nonzero
\(\alpha\)), Theorem 9.7(ii) (an ordinary prime \(1\bmod4\) splits into
two nonassociate conjugate primes), and Theorem 9.9 (classification).
Their local text locations are lines 143--145, 807--815, 875--876,
1378--1389 and 1394--1400 respectively. These support the stated arithmetic
background; quotient cardinality/classification are not needed in the decisive
probabilistic aggregation. The theorem explicitly supplies norm-\(p_i\)
factors; their existence for the allowed rational primes is the standard
split-prime background, not something the checker proves. The mutable notes
have no asserted canonical publication-version identifier.

Ordinary finite-probability rules, Bezout/Euclidean reasoning, and real
exponential power-series calculus are trusted prose background, not
kernel-verified facts. The old Hoeffding landing-page failure is a historical
access report only. No unread Hoeffding theorem is used: the required fair-bit
and cube bounds are proved in sections 2 and 5. Nor is the uninspected,
reported public Lean comparator used.

The old ledger contains eight Engineer and eight Reviewer `supports`
opinions for exactly these eight rectangle claims. Specifically,
`judgement-C_RECTANGLE_SHARP-bd2aa0e8377c`, produced by
`reviewer:gpt-6.1-sol:f6e168660574`, cites the sharp claim hash above and
the path `research/signed_rectangle/STATEMENT_FIDELITY.md`.
Its context binding follows through that exact claim version. The six
supporting claims and the original consequence have Reviewer opinions on
their matching hashes and `PROOF.md`. The route references match those
same dependency hashes, with no external assumptions recorded in the old
ledger.

These are relevant historical opinions and are retained, not discarded.
They have no artifact-content hashes or timestamps in their own records,
however; present snapshot equality cannot prove which bytes the historical
reviewer read. All 23 old graph nodes remain `open` and
`reviewer_confirmed=false`, while the certificate and stdout say review
`pending`. The honest resolution is historical support plus current Engineer
source reading/replay, **not** historical family acceptance, a kernel result,
or present independent acceptance. The native Reviewer must decide the
mathematics and the complete two-unit coverage.
