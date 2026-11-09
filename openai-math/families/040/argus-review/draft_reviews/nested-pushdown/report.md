# nested-pushdown

**Assessment: supported, with the quotient convention and signs stated.**
This reproduces a known geometric construction and verifies its sign
derivation; it is not a novel Hilbert-scheme theorem.

## Exact claim and sources

`C40_NESTED`, versions 1-2:

> The consecutive nested Hilbert geometry, flat-family ideal sequence, and
> quotient-projectivization pushdown have the signs in rel:hilbert-recursion.

The source claim is OpenAI's September 24, 2026 `relation.tex`,
`rel:hilbert-recursion`, at manifest revision
`4eaee87548250b2682affda7d05d947c05554bae`. The Argus argument is old
`REPORT.md`, Sections 3 and 5. Version 2 records `A_EGL_NESTED`; version 1
has the same assertion without that explicit assumption.

For a smooth connected projective complex surface and \(r>0\),
\(N_r=X^{[r-1,r]}\) is smooth, projective, irreducible of dimension \(2r\),
and \(\sigma=(\phi,\rho):N_r=\mathbb P(\mathcal I_{r-1})\) is quotient
projectivization. EGL, `arxiv:math/9904095v1`, Section 1 and Lemma 1.1,
supplies this construction and the universal sequence. Smooth connectedness
implies irreducibility here; the assertion must not be extended to an
arbitrary disconnected surface.

## Decisive argument

Over the distinct-point locus, forgetting the distinguished residual point
has degree \(r\), giving \(\psi_*[N_r]=r[X^{[r]}]\). The family sequence is
\[
0\to(\psi\times1)^*\mathcal I_r
\to(\phi\times1)^*\mathcal I_{r-1}\to j_*\mathcal L\to0.
\]
Its base-family pullbacks have no higher Tor. Restriction of an ideal to the
residual point is a different operation and remains derived.

For a resolution \(0\to U_1\to U_0\to\mathcal I_{r-1}\to0\), with ranks
\(a,a+1\), the nested scheme is a regular zero locus in \(\mathbb P(U_0)\)
of class \(c_a(U_1^\vee(1))\). The quotient projective-bundle formula gives
\[
\sigma_*(\zeta^k)
=\sum_{b=0}^{\min(a,k)}c_b(U_1^\vee)
 [c(U_0^\vee)^{-1}]_{k-b}
=c_k(-\mathcal I_{r-1}^\vee)
=(-1)^k c_k(-\mathcal I_{r-1}).
\]
The truncation of the sum follows from pushdown vanishing below fiber
degree \(a\), not from a bounded Hilbert length. At \(r=1\), only \(k=0\)
survives. At \(r=2\), the blowup convention \(\zeta=-E\) gives
\(\sigma_*(\zeta^2)=-[\Delta_X]\), not the unsigned incidence class.

The logarithmic Chern-class identity yields the all-degree rule
\[
g_0=1,\qquad k g_k=\sum_{j=1}^k j!\operatorname{ch}_j(\mathcal I)g_{k-j},
\quad g_k=c_k(-\mathcal I^\vee).
\]
This is a formal generating-series proof for every \(k\), not inference
from the nine scalar inverse coefficients.

The residual graph is a closed regular codimension-two embedding, with
normal bundle \(\rho^*T_X\). GRR gives its inverse Todd factor. Derived
duality gives \(j_*(\mathcal L^{-1}\otimes\rho^*K^{-1})[-2]\); the even shift
adds no minus sign. These facts explain both the ideal-sequence subtraction
and the canonical twist later used by the ordered Ext rules.

## Evidence limits

The source reader independently confirmed EGL's quotient convention,
family flatness, and signed lemma. The source says the family is flat,
not that \(\sigma\) is flat. The old Engineer and Reviewer judgements both
support the claim. The current exact replay agrees with the saved local
sign checks and finite integrand examples, but does not prove nested
smoothness or the all-degree geometric identity.

The archived and current Jacobian scalar inverse requests were both
refused at validation. Neither refusal changes this assessment: the
projective pushdown is justified by the displayed argument and external
geometric inputs, not by an adapter outcome.
