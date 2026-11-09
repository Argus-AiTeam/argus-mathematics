# Statement fidelity: universal exponent feasibility

The declarations below are in namespace `AveragedHolonomy` in `Main.lean`.
The source is intended for Lean 4.31.0 with the host Mathlib workspace.

`Feasible p q sigma` means that there exist **real** numbers a and b
such that a>0, p*b>1, 1-b-a>sigma, and q*a>sigma. It is precisely
the strict power-law system for vanishing exceptional measure and
curvature smaller than the signal r^sigma in report.md. Here q is
the remainder exponent N-2, not a momentum variable.

`feasible_iff` universally quantifies real p,q,sigma and assumes each
is strictly positive. Its conclusion is the equivalence between
`Feasible p q sigma` and 1/p+sigma/q<1-sigma. Both directions are
proved, including explicit real witnesses in the sufficient direction.
There is no unstated upper bound on sigma and no discretization of p.

`quarter_polynomial_iff` specializes sigma=1/4 for arbitrary positive
real p,q and gives the equivalent polynomial inequality
4*q<p*(3*q-1). This theorem does not require q to be integral.

`fixed_order_iff` quantifies a positive real p and a natural number
N>=3. It substitutes the **real subtraction** (N:Real)-2 for q
and proves that feasibility is equivalent to
p>4*((N:Real)-2)/(3*(N:Real)-7). These denominators are positive
under its hypotheses.

`finite_order_iff` quantifies every positive real p. It proves that
there exists a natural N>=3 for which the strict exponent system
is feasible if and only if p>4/3. The existential order is unbounded;
this is not a finite list of tested orders. The proof uses the
Archimedean property to choose a natural N after p is fixed.

`original_constants` is the conjunction of the four exact rational
exponent identities for p=2, N=18, a=1/16, b=17/32.
`original_feasible` proves that these particular values satisfy
all four strict feasibility conditions with sigma=1/4.

These are the formalized assertions of ledger claim `C_EXPONENTS`.
The compiler checks their encoded real arithmetic and quantifiers.
It does NOT check that the geometric hypotheses of Theorem 1 hold
in a spacetime, or formalize Fubini, weak representatives,
stopped frame transport, interpolation of matrix-valued holonomy,
weak exits, packet construction, canonical measure matching,
category transfer, or the companion Kerr PDE theorems.

In particular, infeasibility for p<=4/3 is only infeasibility of
this specified strict exponent system. It is not a counterexample
to extendibility/inextendibility at those exponents. The formalized
finite-order theorem requires whatever higher finite jet budget
its selected N needs; it does not assert that 30 fixed derivatives
suffice for all p>4/3. Mathematical statement fidelity and the
analytic proof remain independent Reviewer obligations.
