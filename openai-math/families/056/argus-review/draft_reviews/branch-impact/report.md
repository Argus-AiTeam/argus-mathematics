# Conditional branch and junction consequence

**Assessment: supported as a conditional implication only.** CP_BRANCH_IMPACT
version 1 does not claim to prove its separate topology and weight
antecedents. A07 Section 6 must not be read as a termination certificate.

## Exact objects and sources

In the October 7 branch setup, p:Y->X is a projective bimeromorphic map of
normal irreducible compact Kahler fourfolds, Y is ordinary terminal, and
Q is a reduced union of distinct irreducible divisors with dim p(Q)<=1.
The branch excess beta(Q) counts normalization primes over surfaces,
subtracting one per surface. A prime of normalization mapping with degree
greater than one still counts once. The number c_2(Q_j^nu) here is the
rational rank spanned in H_4 by compact analytic surface classes: it is
**not a second Chern number**. The quantity tau_Y(Q) counts distinct
global ordinary-log-discrepancy-two places centered at singular curves
contained in Q.

These definitions and hypotheses are explicitly in the staged
`05-branch-topology.tex:12-66`. The manifest's source revision is
`4eaee87548250b2682affda7d05d947c05554bae`. The relevant separate inequality
is `eq:branch-topological-bound`, lines 706-720. For the further consequence,
`07-difficulty.tex`, `prop:difficulty-lower`, lines 327-376, uses local
bracket and weight assertions. The review reads these exact statements
and their dependency placement, not the whole topology or MMP program.

## What the curve result actually contributes

Assume the reviewed curve bound for each singular curve T contained in Q.
There are finitely many such curve components by compactness and terminal
codimension-two smoothness. Use the same specified global resolution and
choose the allowed punctures separately on each curve. For distinct T,
the sets of global prime divisors with image T are disjoint, since one
prime has only one irreducible center. Each counted prime is a place
included in tau_Y(Q). Thus

    sum_T b_T <= sum_T N_T <= tau_Y(Q).

This uses global divisors, not a sum of germwise branches. If finiteness of
tau itself is required, the inequality alone does not prove it: the
all-place representation argument of Section 4 puts every such place
on the one fixed resolution and supplies finiteness. That argument is
available in the draft and is reviewed in the globalization unit.

Assume in addition the separate topological estimate

    beta(Q) - sum_j c_2(Q_j^nu) <= sum_T b_T.

Adding the inequalities gives the branch inequality with tau_Y(Q).
This combination is valid. It does not establish the topological estimate.
That estimate is expressly derived from Hodge/purity and normalization
arguments in Section 05, outside this unit's verification claim.

## What is needed for junction nonnegativity

At a crepant junction Q is the reduced union of varying labels. The
separate Section 07 inputs are: its image has dimension at most one;
each surface bracket has deficit at most its varying branch excess;
each varying default d_h is at least one; and every distinct global place
counted by tau supplies a distinct codimension-at-least-three weight of
at least one, not a place already counted in a surface bracket.

The weight assertion uses effectivity and a positive Q-Cartier varying
label through the curve, so that

    a(E;Y,Theta+M) = 2 - ord_E(Theta) - coeff_E(J) < 2,
    J >= 0.

Ordinary log discrepancy two alone does not make that weight positive.
Given the stated rounding/weight rules, the argument then has the form

    difficulty >= -beta(Q) + sum_h d_h c_2(S_h^nu)
                              + sum_{codim center >=3} w(E)
               >= -beta(Q) + sum_{varying h} c_2(S_h^nu) + tau_Y(Q)
               >= 0.

This is a valid conditional use of the branch bound. The proof of the
local bracket estimate, its finite-support assertions, coefficient
descent, and the relative programs needed later are not supplied by
this review. Nonnegativity alone is also not a termination argument.

## Supported scope and non-conclusions

The summation and the two conditional implications are supported;
the separate topology/weight antecedents remain explicit unverified
dependencies, not new results. They are recorded as source-only
assumptions in the current review ledger with these exact manuscript
locators. No finite computation or Lean run certifies them.
In particular, extending the curve bound to compact complex Y does not
remove the Kahler hypothesis from the Section 05 purity estimate.
No error in an Argus shortcut refutes the original manuscripts, and
no acceptance of the curve argument certifies their full conclusions.
Native independent review is pending.
