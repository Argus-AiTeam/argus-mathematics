# Exact scope of C_ALGEBRA_CORE

`Main.lean` proves six algebraic statements, uniformly over the indicated
types. It does not formalize Lemma `prelim:step-drop` as a whole.

The declaration names are `common_fiber`, `common_derivative`,
`transformed_derivative`, `transformed_lift`, `absorption`, and
`bracket_correction`, all in namespace `StepDropAudit`.

`StepDropAudit.common_fiber` quantifies over arbitrary groups H and G, a
group homomorphism pi:H->G, a subgroup U of H, and x,y in U. If pi(x)=pi(y),
then x*y^(-1) belongs to U intersect ker(pi). For the relative/diagonal
semidirect product in the manuscript this is the uniqueness of a relative
coordinate modulo the vertical kernel. Identifying that kernel with V is
the mathematical application, not an additional compiler-checked fact.

The next three declarations quantify over an arbitrary group G, an
arbitrary abelian additive group A with a distributive G-action, and a
function Y:G->A satisfying the explicit right-cocycle identity
Y(x*y)=Y(x)+x acting on Y(y). There is no commutativity assumption on G.
In the application the action is the adjoint representation on coefficient
arrays modulo the U-invariant spaces V, and Y is a right logarithmic
derivative. The existence of this representation and the cocycle identity
for those derivatives are justified in `proof.md`, not encoded here.

`StepDropAudit.common_derivative` takes the raw relative-coordinate
equation, with the left insertion e and right insertion m in precisely
their manuscript order, and proves
Y(b)=a^(-1)(e+u-Y(a))+b(v+d(m)-Y(d))+z.
This is equation `prelim:common-derivative` and its displayed formulas for
s_h and r_h, abstracted to a group representation. No sign or side of the
group action is changed.

`StepDropAudit.transformed_derivative` takes
Y(a*c*b)=s+(a*c*b)(r)+z and solves for Y(c). Its conclusion is
a^(-1)(s-Y(a))+c(b(r)-Y(b))+a^(-1)(z). This is
`prelim:transformation` with c=B' and z=S(k).
`StepDropAudit.transformed_lift` proves the accompanying relation
a^(-1)(s)=c(b(r)) from s=(a*c*b)(r), pointwise in k.

`StepDropAudit.absorption` additionally quantifies over an arbitrary
abelian additive group K and additive maps S,R:K->A satisfying
S(k)=B(R(k)) for every k. It proves exactly that replacing
s by s-S(ks), r by r-R(kr), and k by k+ks+kr preserves
y=s+B(r)+S(k). It assumes no bounds on ks or kr; bounds needed in the
application are handled separately in the proof.

`StepDropAudit.bracket_correction` quantifies over abelian additive
groups E,A and an additive map Q:E->A. From Q(p)=s-r, Q(a)=s,
Q(b)=-r it proves Q(p-a-b)=0. It checks the signs in the simultaneous
slow/rational removal, not the existence or bounds of a rational section.

All six statements are universal implications with their hypotheses
visible in the Lean source. They use no `sorry`, `admit`, custom axiom,
finite-dimension cutoff, coefficient-height bound, or comparable-side
assumption. The lattice geometry, quantitative separation, graded
induction, passage from biased squares to a common subgroup, and the
Szemeredi/reciprocal-sum conclusions are explicitly outside this formal
certificate. Their statuses must not be inferred from its compiler exit
code. The all-dimensional reduction theorem is a prose proof supported,
not wholly formalized, by this certificate.
