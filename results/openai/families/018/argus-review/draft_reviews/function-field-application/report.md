# Function-field manuscript application

**Assessment:** The selected supported-shear/transitivity application is
supported under all its original hypotheses, conditional on the
separately assessed arithmetic inputs. The full unit inventory is only
**partially supported**: no evidence here establishes the complete
function-field MP theorem. No manuscript refutation or native independent
acceptance is claimed.

## Source and claims

The original is OpenAI, *The Margulis--Platonov conjecture over global
function fields*, October 5, 2026. Its read-only staged tree matches
`MANUSCRIPTS.json` revision
`4eaee87548250b2682affda7d05d947c05554bae`, all 15 listed TeX entries.
The README supplies author/date. The relevant source is
`build/paper/08-characters.tex`, especially lines 1-180, 251-440,
and the main statement in `build/paper/01-introduction.tex` lines 1-27.
The old Argus application is `exact_transitivity/report.md` Section 6.

Here k is a global function field of any positive characteristic,
L/k is separable quadratic, D is a central division L-algebra of odd
degree n>=3 with unitary involution, and E=LF is the constructed
*-stable maximal field, with F/k cyclic of degree n. The conjugate
parameters t_i of d are distinct and disjoint from their conjugates,
and the additional condition **d bar(d) not in k** is retained.

`char:supported-shears` asserts actual supported upper and lower
unipotents. `char:transitivity` asserts exact transitivity on nonzero
pairs and the consequent difference identity for every b,bd in the
Hermitian-norm domain:

    f(bd)-f(b)=chi(bar(d)/d).

The full `thm:main` instead quantifies over every absolutely almost
simple simply connected k-group G and abstract noncentral normal
N in G(k), asserting N=delta_A^-1(W) for open normal W in the
product at anisotropic places, in every positive characteristic.

## Hypothesis matching, especially characteristic two

Oddness of n makes F and L linearly disjoint, and the cyclic action
on F commutes with the quadratic involution on L in LF.
For each conjugation sigma_i,
t_i bar(t_i)=sigma_i(d bar(d)). If this were 1, then d bar(d)=1
would lie in k, contrary to the original condition. Hence every
characteristic-two hypothesis t_i bar(t_i)!=1 in Theorem A is met.
The review does not replace the stronger original condition by this
weaker consequence.

The global extension for Theorem A is E/F. In characteristic two
it remains separable quadratic; an inseparable quadratic extension
would not have the stated nontrivial involution. No division by 2
is used in the phase-ring proof or affine extraction. The branch
polynomial becomes (ab+1)(z+1), and the ab!=1 condition supplies
the required nonzero polynomial. This is an explicit algebraic
boundary, not a characteristic-zero computation relabeled as
characteristic-free.

As in the number-field case, D is the direct sum of E w_i,
w_i d=t_i w_i. The pair move followed by a sign on the second
output gives B_{-1}; in characteristic two this is simply B_1.
Diagonal phases still conjugate it to every B_h. The determinants
1-t_i are nonzero, and phases in E^1 are actual unitaries.
Thus the assessed Theorem A specializes to `C_FF_SHEARS` v1.

The w_i decomposition uses the same standard Skolem--Noether proposition
as the number-field application: KMRT Section 1 Theorem (1.4), printed
p.5, actually read in the already retrieved author-hosted text.
The distinct right-d eigenvalues and dim_E(D)=n then give a basis.
This is the source-only structural assumption A_SKOLEM_NOETHER on
current claim R_FF, not a result compiled by the formal core; the
hosted canonical revision remains unverified.

The source already interposes normal-subgroup extraction after its
density preparation. The Argus explicit-word argument is an
alternative/generalization, not evidence that the source confused
density with exact membership.

## Pair construction, invariance, and evaluation

The local algebra shared by the two manuscripts was checked in the
number-field application report, under "Inspecting the application
bridge." That calculation has no characteristic-zero step: it uses
ordered products, adjoints, and inverses of proved nonzero elements,
not division by 2 or a split-matrix counterexample. It therefore
applies here with the following explicit boundaries.

The source definition of f includes skew elements and uses chi into
a finite abelian group. Division makes a*a=0 force a=0.
The Sylvester operator T(e)=ed-d*e is invertible because its
eigenvalues t_i-bar(t_j) are nonzero. This still means nonzero
differences in characteristic two. Taking adjoints makes C-e*
a second solution, yielding the two Hermitian equations.

For b=ed and z=b*+e-a*c, the ordered calculations give the
transformed Hermitian equations and the three-unitaries identity
1-PQ^-1P*=m_b m_z m_e*. The exact source P and Q, and the
nonzero conditions for e,b,z,Q, are retained. The source does
not obtain this identity by commuting division-algebra entries,
and Lean does not prove it. The shared handwritten expansion is
support for this local bridge, distinct from machine evidence.

The additive-generation assessment supplies exact Z U(k)=D,
not just density at finite places. Supported upper and lower
roots then meet the uniform-slice hypotheses of the conditional
transitivity unit and give an actual transitive action.

For e=(d-bar(d))^-1, e*=-e. In characteristic two the equality
also says e*=e, but e+e*=0 and
ed+d*e*=e(d-bar(d))=1 still hold. Thus a=1,c=0 evaluates the
constant to chi(bar(d)/d), with m_e=1 and
m_ed=1-(ed)^-1. For arbitrary b,bd in the stated domain their
defining vectors give a nonzero pair with unique Sylvester solution
b; injectivity of T rules out the zero pair. This checks the
quantifier in `char:difference`, not just one evaluation example.

## Dispositions and unresolved scope

| Old claim | Disposition |
| --- | --- |
| C_FF_SHEARS v1 | Supported with every original parameter condition retained. |
| C_FF_TRANSITIVITY v1 | Supported selected application, conditional on the separately recorded arithmetic inputs and with the local bridge inspected in prose. |
| C_FF_PAIR v1 | Correctly outside the inherited Lean certificate; ordered local identities are supported by the characteristic-free handwritten inspection. |
| C_FF_MAIN v1 | Not established by this draft evidence, including in characteristic two. |
| C_FF_REMAINING v1 | Explicit open source-manuscript obligations. |
| C9000018 v1 | Historical family assignment shared with the number-field unit, not a separate theorem. |

The concrete full-theorem gap is not "we tried and found no error."
No old-core certificate verifies `char:normalization` and the global
existence of the cyclic *-stable field, its Harder/Conrad and cyclic
approximation inputs, the later passage from the difference identity
to continuity and `char:trivial`, or the recurrence, finite-quotient,
unitary-induction and structural reductions from arbitrary (G,N).
These are named obligations on the old proof graph's main-theorem
path. Their absence from this certification is not a claim that the
source arguments are false.

The finite-constant-field distinction in the additive proof's
Chebotarev input is assessed in that unit, not silently inherited
from a geometric-only count. Its source-only hosted-version limits
and its lack of Lean certification carry through this application.

The review reproduces and clarifies the strongest old supported
application; it does not extend its hypotheses, prove new mathematics,
infer novelty, or certify the entire paper. Compiler success, local
symbolic identities, handwritten scope, and native independent
acceptance remain separate.
