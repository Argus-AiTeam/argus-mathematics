# Statement fidelity: weighted genus reduction

**Claim:** `V_WEIGHTED_GENUS_IDENTITY`.

**Source:** density manuscript, October 7, 2026,
`build/sections/05-coefficients.tex`, lines 240--665, equation
`cs:weighted-trace-identity`. The definition of the character sum is in
`01-arithmetic-transfer.tex`, "Transfer of a Heegner point".

The assertion is universally quantified over the source-admissible fixed
curve and filter, auxiliary odd fundamental discriminant `h_star`,
squarefree index `D`, detecting prime `ell`, and working precision `M`.
It uses `h=sigma D`, `k=h h_star< -4`, coprime discriminants, the same
unit squareclasses at `2N`, both inert-prime orientations, the source's
local weights, and an **unnormalized** character sum `P_D`.

The coefficient is the extracted and projected coefficient
`H_M(|h_star|D)`; projection does not change it at an admitted index.
The parametrization values include the already chosen integer `L`.
The statement permits the phase `zeta_M(D)` to depend on the index,
orientation/basis choices, and the chosen detecting precision and prime.
It does not permit any additional nonunit factor depending on `D,ell,M`.
The formula's fixed integer factor is `c_0 2^omega(N)`.

The report proves the stronger integral weighted transport identity for
an arbitrary coefficient module, with the same arithmetic data and
transformation laws. Its specialization modulo `2^M` is the exact source
formula. This is not a reduction to a residue field and makes no
flatness assumption. Unit denominators are cleared first; no inverse
of two is used.

The arithmetic input is the oriented, ideal-action-equivariant CM
reduction theorem at conductor one, with multiplicity one. The other
input is the upstream definition and Atkin--Lehner/Frobenius covariance
of the reduced parametrization. These inputs are named assumptions in
the ledger, not conclusions of the standalone script.

`verify.py` certifies exact local and quaternion computations and a
nonzero integral free-module comparison. It does not machine-check
the entire adelic proof or the cited CM theorem. The general
correspondence is proved in the report and requires independent human
review. The fixture at `N=1` is not an elliptic-curve instance of the
full proposition. No numerical experiment is described as a universal
proof, and no negative control is described as a manuscript refutation.

There is no new Lean declaration or compiler certificate for this claim.
The existing reviewed `V_TRACE_CHARACTER` evidence is preserved, not
recompiled, and is not evidence for the arithmetic input here.

Still unverified by this work: detecting-prime existence, theta
modularity and recurrence, genus-index estimates, analytic-rank
detection, the pointwise 2-converse, both Goldfeld theorems, literature
novelty, and publishable significance.
