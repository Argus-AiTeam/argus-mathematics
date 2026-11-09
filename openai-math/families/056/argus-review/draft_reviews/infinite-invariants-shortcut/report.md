# Retired averaging without finite monodromy

**Assessment: the shortcut is invalid; the displayed linear-algebra
counterexample is exact.** The rejected inference is not the curve bound.
This reviews CP_R_UNPROVED_AVERAGING, A07 Section 6, and the corresponding
A04/A29 negative control.

## Exact counterexample to the inference

Let Z act on W=Q^2 by U=[[1,1],[0,1]] and on V=Q trivially.
The quotient q(x,y)=y is surjective and satisfies qU=q, so it is equivariant.
But U(x,y)=(x,y) forces y=0. Thus W^Z=Q*(1,0), whose image under q is
zero, whereas V^Z=Q. Invariant lifts do not exist for a nonzero quotient
class. U has infinite order, since U^n=[[1,n],[0,1]] in characteristic
zero.

This is a counterexample to exactness of invariants for the stated
infinite-group representation. It is not a construction of R^2g_*Q or
R^2j_*Q for a terminal fourfold. No geometric realization is needed to
show that surjectivity of local systems alone is an insufficient proof.

## Replay and the actual repaired argument

A29 checks qU=q, rank(U-I)=1, (U-I)(1,0)=0, and q(1,0)=0 exactly over Q.
The unchanged replay passed and matches A04's invariant-lift image
dimension zero for quotient dimension one. These computations support
the control at precisely that scope.

For a finite image G over Q, the correct general argument is

    P_W = (1/|G|) sum_g g,
    q(P_W w) = P_V q(w).

If q(w) is invariant, the right side is q(w), giving an invariant lift.
The curve proof therefore first proves finite monodromy through actual
line bundles, countable Quot parameter spaces, paths and finite
multisections. It does not just declare that invariants are exact.
The S3 computation is one finite example of this averaging formula,
not the proof of finite monodromy of the geometric W.

The current ledger records retirement RV_UNPROVED_AVERAGING with this
obstruction. It is not silently reopened as another search route.
The control rejects an Argus proof shortcut and supports the need for
CP_MONODROMY; it refutes neither the original curve proposition nor a
termination theorem. Native independent review is pending.
