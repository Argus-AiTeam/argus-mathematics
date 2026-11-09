# Conditional weighted inverse

**Assessment:** supported as a conditional analytic lemma, by mathematical
reading, not by a global formal certificate. Native independent acceptance of
this review remains pending.

## Exact claim, source and attribution

The old claim is `C_SWI@1`, subject hash
`44f762894af9f1db58187fcbc93b9902711fb0296c7805ba1b80ca34f94d6872`.
Its source is old `research/spectral_weighted_inverse/proof.md`, especially
the result/scope and Sections 1--6. It verifies Lemma `sp:weighted-inverse`
of OpenAI's *The abelianity conjecture for special compact Kahler manifolds*,
dated September 23, 2026, `build/sections/spectral.tex:414-501`.
The original lemma already contains the inverse bound and spectral quadratic.
This is a reproduction/alternative proof, not an original abelianity theorem
or a discovered manuscript error.

The staged source agrees byte-for-byte with the existing reference manifest
at revision `4eaee87548250b2682affda7d05d947c05554bae`. In particular,
`spectral.tex` has the manifest's hash
`fa7d0ce79918e504451f2f9cfdd1e72428cda1c78dd22a180ee9c1e41bd2069c`.
The old proof and ledger also match their existing snapshot-manifest records.
These comparisons establish the versions read; they do not prove the lemma.

The hypotheses are:

- A fixed connected compact Kahler orbifold `(M,omega)`, of complex dimension
  `n`, and its specified connected normal orbifold covering `U`, with diagonal
  deck action by `P`; the lifted metrics are complete.
- The simultaneous positive scalar `(p,0)` Dolbeault gaps on `U`, for every
  `0<=p<=n`, assumed in `spectral.tex:99-112`. A single fixed `delta>0`
  can be decreased by fixed normalizations. This is the manuscript's
  contradiction hypothesis, not a result established by the old draft.
- `D=(U x U)/P`, `Omega_S=omega_x+S*omega_y`, `S>=1`, `m=2n`,
  and `E=p_y^*K_M` with its coefficient metric from the original **unscaled**
  metric. Write `L=E^*`.
- A smooth positive scalar multiplier `h` on `L`, with `1<=h<=exp(b)`,
  `b,t>=0`, and `i*Theta_(L,h)>=-C0*t*Omega_S`, for fixed `C0>=0`.
  Taking `max(C0,0)` if necessary only weakens the lower bound.

The conclusion is exactness and closed ranges for the complete `E`-valued
`(0,*)` complex with multiplier `h^(-1)`, zero kernel in degree zero, and,
for every closed positive-degree `F`, a primitive with

\[
 \|v\|_{S,h^{-1}}\le
 C(e^{b/4}+\sqrt{t}\,e^{b/2})\|F\|_{S,h^{-1}},
\]

where `C` is independent of `S,b,t` and of derivatives of `h`.
The old draft's explicit positive-degree wording and zero-degree assertion
are faithful endpoint interpretations of the manuscript's exact complex.
They do not demand a nonzero negative-degree primitive.

## Decisive argument and dependency assessment

The separate unit reports supply substantive checks of the dependencies,
not just citations to their old status labels.

1. The scalar gaps imply the two needed unweighted estimates, uniformly
   in `S`: the `L`-valued `(m,*)` gap and the `(p,0)` differential gap.
   The Kahler Lefschetz identification supplies the scalar `(n,q)` gap.
   Splitting the product energy leaves a nonnegative `y` part, while the
   `x` part has the assumed fixed gap. Integration over all `x` with `y`
   in a measurable fundamental region gives the quotient estimate.
   See `../bochner_estimate/report.md`.
2. With `B=exp(b)`, bounded norm equivalence identifies **differential**
   domains and inherits exactness and closed ranges from the unweighted
   complex. Completeness supplies the needed form cores, without equating
   weighted and unweighted adjoint domains. A weighted minimal inverse
   already exists with norm at most `sqrt(B/delta)`.
   See `../complete_domains/report.md`.
3. For closed `eta` in the weighted adjoint domain, put
   `H=||eta||_h^2`, `N=||eta||_0^2`, `Q=||d_h^*eta||_h^2` and take
   an unweighted minimal primitive `u`. The domain-correct adjoint pairing,
   norm comparison and Bochner estimate give

   \[
   H^2\le Q\|u\|_h^2,\qquad
   \delta\|u\|_h^2\le BN,\qquad
   \delta N\le Q+aH,\quad a=mC_0t.
   \]

   Multiplying these inequalities yields
   `delta^2 H^2 <= B Q(Q+aH)`. Thus the Rayleigh quotient `x=Q/H`
   satisfies `x(x+a)>=delta^2/B`. This is a legitimate all-form alternative
   to the manuscript's spectral-band proof. The latter is also sound:
   minimal weighted lifts give `N>=delta H/(B*mu)` on each nonzero band
   up to `mu`. See `../minimal_lifts/report.md`.
4. The positive root
   `r=(sqrt(a^2+4*delta^2/B)-a)/2` gives coercivity and inverse norm
   at most `r^(-1/2)`. The reciprocal calculation gives the explicit bound

   \[
   \|V\|^2\le e^{b/2}/\delta+
             mC_0t e^b/\delta^2.
   \]

   Taking square roots permits
   `C=max(delta^(-1/2),sqrt(m*C0)/delta)`. Its fixed dependencies are
   exactly permitted. See `../quantitative_refinements/report.md`.
5. The conjugate-linear bundle-dual star is an isometry between the full
   metric on `L` and the reciprocal metric on `E`. Complete-domain
   identities reverse the adjoint complex; exactness, closed ranges and
   reduced inverse norms transfer, including the zero-degree endpoint.
   See `../serre_duality/report.md`.

The chain is not circular: the coarse inverse and closed ranges precede
spectral calculus and improved coercivity. No global bound on derivatives of
`h` is inserted at a domain step. The curvature lower bound is used with the
correct sign. No substantive invalid inference in this conditional chain was
identified.

## Evidence, prior review and limits

The old ledger has a Reviewer-support judgement
`judgement-C_SWI-84f7f2f9c48e`, by
`reviewer:gpt-6.1-sol:36cf1beb21ae`, on precisely the subject hash above and
the shared `proof.md` path. Its graph still says review pending. These are
inconsistent administrative labels, not two different mathematical results.
The subject and listed artifact match; the prose judgement itself does not
archive the bytes it originally read. Current support here comes from the
argument just checked, not from adopting either label. The family summary
reconciles all seven such judgements.

The strongest prior result already claimed this conditional verification,
with a scalar Lean certificate and Reviewer-support records. This review adds
complete coverage, scope/version reconciliation, a fresh scalar replay and a
source-accurate duality reading. It does **not** improve the analytic theorem.

The actual executable replays used Python 3.13.5 through the prescribed Argus
interpreters; the dedicated scalar replay used Lean 4.31.0, Lake
5.0.0-src+68218e8 and the installed Mathlib workspace. The exact Python
checker passed six rational examples; the compiler and axiom audit exited
0 with no proof holes; the current Jacobian operation checked an exact
polynomial identity. None is a mechanical check of this analytic claim.

The needed domain-duality source was independently read at
`arxiv:1006.3117v2`; the historical Demailly-2012 locators remain unverified,
but the local derivation is assessed separately and is not assumed true
because a dependency was retired.

No unresolved obligation **inside this conditional lemma** was identified by
this assessment. Simultaneous gap existence, the zero-spectrum theorem,
potentials, localization, Hilbert-coefficient positivity, descent, abelianity,
the other two manuscripts and geometric sharpness remain unassessed here.
They are exclusions or assumed hypotheses, not evidence that these other
claims are either correct or false. Novelty is not claimed for the old result;
the review result has `novelty_status=not_applicable`.
