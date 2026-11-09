# Characteristic-p line recovery

## Statement and boundary

Let p be prime. Let K and L be fields of characteristic p with finite
p-rank at least two: [K:K^p] and [L:L^p] are finite and at least p^2.
Write H=K^p, C=L^p,
V_F=F^*/(F^*)^p, and
R_F=span_Fp{[f] tensor [1-f] : f != 0,1}.
For every Fp-linear isomorphism Theta:V_K -> V_L satisfying
(Theta tensor Theta)(R_K)=R_L, there is exactly one n in Fp^*
such that n Theta maps every H-projective line onto a C-projective line.

The proof below establishes this statement mathematically. Formal
certification is a separate obligation, not a consequence of this prose
or the finite checks. No counterexample to the manuscript is asserted.
Neither projective lifting nor full field reconstruction follows merely
by recording this milestone.

The reviewed input is precisely `V_CHARP_INTERSECTION`, version 3, with
independent supporting judgement by `reviewer:copilot` and certificate
`research/char-p-intersection/certificates/V_CHARP_INTERSECTION-8ee0aa52ccd7bea2.json`.
Its source and certificate are not modified or replayed here.
We use its nonzero-coefficient conclusion and uniqueness from either
single affine-power inclusion, not just uniqueness of the pair.
No external literature theorem is needed for the remaining proof.
The manuscript mentions Cadoret--Pirutka as methodological precedent;
we do not rely on that reference for a mathematical inference or claim
novelty relative to it.

## 1. Quotients and the zero-symbol implication

For any characteristic-p field F, put B=F^p. The equality
(F^*)^p=B^* identifies V_F with the one-dimensional B-subspaces of F.
Equality [f]=[g] is exactly f/g in B^*. Multiplication of field
representatives is addition in V_F; its zero point is [1].
For integers i, multiplication by i is [f] -> [f^i].

If B <= M <= F and s is outside M, then [M(s):M]=p. Indeed the
minimal polynomial divides T^p-s^p=(T-s)^p. If its degree were e<p,
it would equal (T-s)^e over F and its coefficient -e*s would force
s into M. The nonzero integer e is invertible in characteristic p.
This also proves independence of 1,s,...,s^(p-1).

Successive adjunctions extend every p-independent list to a p-basis
when [F:B] is finite. The tower bases are the monomials with exponents
between 0 and p-1. On this basis, multiplying a monomial by its j-th
exponent defines a B-linear derivation D_j: reduction of an exponent
modulo p removes only a B-factor and leaves its value in Fp unchanged.
This verifies the product rule on basis pairs and hence on all inputs.
No separability assumption is needed.

Suppose s is outside B and t is outside B(s). The pair s,t can be
the first two entries of such a basis. For its Euler derivations D,E,
define, on nonzero representatives,

    beta(f,g) = (D(f)/f)(E(g)/g) - (E(f)/f)(D(g)/g).

Logarithmic derivatives turn products into sums and kill B^*. Thus
beta defines an Fp-bilinear map V_F x V_F -> F, not a pairing on an
unrelated abstract vector space. It kills every actual generator
[f] tensor [1-f] of R_F: D(1-f)=-D(f), E(1-f)=-E(f), so the two
products cancel. By bilinearity its tensor linearization kills R_F.
It therefore factors through the actual W_F=(V_F tensor V_F)/R_F.
Since D(s)=s, E(t)=t, D(t)=E(s)=0, its value on {s,t} is 1.
Consequently

    s not in B and {s,t}=0  ==>  t in B(s).

Only this direction is needed. It is not assumed as extra structure
on Theta, and no injectivity theorem for differential symbols is used.

For c,d in B^*, and t,c+d*t nonzero, {t,c+d*t}=0: take q=-d*t/c.
Then q != 0,1 and [q]=[t], [1-q]=[c+d*t].
When a constant affine coefficient is zero, the projective points
already coincide; no extra assertion about a degenerate symbol is
needed.

Compatibility implies equivalence of symbol vanishing in both
directions, because the induced tensor isomorphism carries precisely
R_K onto R_L. Scalar multiples and the inverse of a compatible
isomorphism remain compatible: the tensor square of scalar n is n^2.

## 2. Source independence and the affine configuration

On nonzero V_K, put an edge between [x] and [y] when C(X) != C(Y),
where [X]=Theta[x] and [Y]=Theta[y]. Nonzero means x not in H
and X not in C; it does not mean merely x != 0.
Changing representatives by H^* or C^* does not change this condition.

Distinct degree-p subfields C(X), C(Y) give
[C(X,Y):C]=p^2: Y is outside C(X), so the adjunction lemma applies.
Every vertex has a neighbor, since [L:C]>=p^2 and Theta is onto.
If two vertices are not adjacent, any vertex in a different part
joins both. Hence the graph is connected, with distance at most two.

Along an edge, 1,x,y are H-linearly independent. Otherwise
y=c+d*x with d != 0. If c=0 then [y]=[x], impossible on an edge.
If c != 0, the affine Steinberg relation gives {x,y}=0, whence
compatibility and zero-symbol detection give Y in C(X), also impossible.
This proves the required source independence without assuming that
Theta preserves any subfield, p-independence, or projective line.

For arbitrary a,b in H^*, put

    u=x+a, v=y+b, z=b*x-a*y=b*u-a*v.

Independence proves u,v,z nonzero. The degree-p monomial basis proves
[u] is outside Fp[x], and [v] is outside Fp[y]: an equality
x+a=h*x^i with h in H^*, 0<=i<p, contradicts independence of
1,x,...,x^(p-1), including i=0 and i=1.

All four symbols

    {x,u}, {y,v}, {y/x,z/x}, {v/u,z/u}

vanish by the affine Steinberg calculation, with nonzero constant
coefficients. In particular the last two affine expressions are
b-a*(y/x) and b-a*(v/u); neither has lost the minus sign.

Choose arbitrary nonzero representatives U,V,Z of their image points.
Detection gives U in C(X), V in C(Y). Injective Fp-linearity gives
[U] outside Fp[X] and [V] outside Fp[Y]. Thus U,V are not scalar
monomials, in the exact sense of the reviewed intersection theorem.
The degree-p fields have intersection C. Therefore Y/X is outside C,
and V/U is outside C: V/U in C would put U in both C(X) and C(Y),
contradicting its nonmonomial condition.

Detection applied to the two quotient symbols now yields

    Z/X in C(Y/X),  Z/U in C(V/U).

These are statements about the chosen representatives themselves:
changing a representative multiplies a ratio by a C-unit, which
does not affect membership. All ratios and Z are nonzero.
Every original hypothesis of the reviewed theorem has now been checked.
It gives n with 1<=n<p, nonzero C-coefficients in

    U^n=A+B*X^n,  V^n=D+E*Y^n,

and says that either of these unqualified affine-power inclusions
determines n uniquely among 1,...,p-1.

## 3. Propagation, including all choices

Choose field representatives for all vertices and all their image
points once. This choice supplies no line-preservation hypothesis.

For a fixed vertex x choose a neighbor y and a nonzero b. As a ranges
over H^*, keep the representative V of Theta[y+b] fixed. The second
affine-power inclusion and its single-inclusion uniqueness force the
same n for all a. To compare a different neighbor, a different b,
or both, set a=1 in each configuration and keep the representative
U of Theta[x+1] fixed. Uniqueness from the first inclusion forces the
same n. Thus a scalar n_x is defined for each vertex, independently
of these choices. Its conclusion holds for every a in H^*.

On an edge x,y, take a=b=1. The local exponent is both n_x and n_y.
Connectedness therefore gives one n for every vertex.

Representative choices do not affect this result. Replacing X or U
by a C-unit multiple leaves AffinePower(X,U,r) unchanged for every
r; its coefficients are just rescaled by nonzero C-elements.
Replacing x by h*x replaces its affine parameter a by a/h and
replaces [x+a] by [x+a/h]. Thus the family used above is the same
projective line. In any event the scalar-line argument below gives
choice-free uniqueness.

Let Psi=n*Theta. The line through [1],[x] consists exactly of [1],
[x], and [x+a] for a in H^*. Indeed a nonzero element c+d*x in
H+H*x has c=0, d=0, or both nonzero, and in the last case divide
by d. The resulting image is contained in the line through [1],[X^n].
These two target points are distinct, since n is nonzero modulo p.

An arbitrary line through distinct points [s],[t] is the translate
by [s] of the line through [1],[t/s]. Multiplication by s is
H-linear on K, and multiplication by any image representative is
C-linear on L. Since Psi is a multiplicative-quotient homomorphism,
Psi maps every line into a line. No surjectivity on individual lines
has yet been used or obtained.

## 4. Scalar rigidity, onto-ness, and uniqueness

In any imperfect characteristic-p field F, scalar r in Fp^* cannot
map every projective line into a line unless r=1. Choose x outside
F^p and represent r by 1<=r<p. The images of [1],[x] are distinct,
so containment of the line containing [1],[x],[x+1] forces
(x+1)^r in F^p+F^p*x^r. If 1<r<p, its coefficient r at x^(r-1)
is nonzero, and r-1 differs from 0 and r. This contradicts the
degree-p monomial basis. If p=2, already 1<=r<p forces r=1;
the coefficient argument is not applied with r=1.

Apply the containment construction, which used only compatibility
and the finite-p-rank hypotheses, to the ORIGINAL Theta^{-1}.
It yields m such that Phi=m*Theta^{-1} has the endpoint-normalized
containment property. The composite Phi o Psi is scalar m*n on V_K.
It preserves normalized lines, so rigidity gives m*n=1.
Consequently Phi=Psi^{-1}. This is not an application of an onto-line
theorem to the inverse, and it does not require a separate scalar
compatibility argument.

For every distinct a,b, the two containments are now

    Psi(line(a,b)) subset line(Psi(a),Psi(b)),
    Psi^{-1}(line(Psi(a),Psi(b))) subset line(a,b).

They give equality directly. This proves onto-ness, not just
containment. A line containing two distinct points is their
endpoint-normalized line: the spans of their representatives
are nested two-dimensional subspaces and hence equal.
The formal source proves this fact too, so no competing scalar
is required to assume endpoint normalization.

If m*Theta also maps lines onto lines, then
(m*Theta) o Psi^{-1} is scalar m*n^{-1} on V_L and maps lines
into lines. Rigidity gives m=n. This includes p=2, for which
Fp^* has exactly one element.

## 5. Specialization to the manuscript

For a finitely generated F/kappa with kappa algebraically closed
of characteristic p and transcendence degree d, choose a
transcendence basis and F_0=kappa(t_1,...,t_d). Perfectness of
kappa gives [F_0:F_0^p]=p^d by grouping monomial exponents modulo p
and clearing denominators. Frobenius identifies F/F_0 with
F^p/F_0^p. Both finite-tower calculations give

    [F:F_0]*p^d = [F:F^p]*[F:F_0].

Cancel the positive finite factor. Thus [F:F^p]=p^d, finite and
at least p^2 for d>=2, even if F/F_0 is inseparable.
All hypotheses of the theorem at the start therefore hold.
The Theta and R in this proof are exactly those defined in the
manuscript, not stronger subfield- or line-preserving replacements.

The strongest prior result in this campaign was the independently
reviewed two-variable intersection theorem. The mathematical
improvement here is the derivation of its witnesses from Steinberg
compatibility and the universal local-to-global, inverse, and
uniqueness arguments. A computational certificate must not label
finite tests, this prose proof, or a conditional formal statement
as a kernel certification of this full improvement.

## 6. Formal theorem and replay

`Main.lean` constructs the actual quotient and Steinberg subspace,
proves zero-symbol detection, generates the affine configuration,
propagates the exponent, and proves exact line images and uniqueness.
Its root declaration `CharPLineRecovery.prop_lines_source` quantifies
over every scalar sending each source line onto SOME target line,
not only those assumed to respect an endpoint normalization.
`lineOnto_iff_sendsLinesOnto` proves the normalization equivalence
using actual two-dimensional spans. The specialization in Section 5
is a prose algebraic proof; it is not mislabelled a Lean theorem
about transcendence degree.

The local `ReviewedIntersection.lean` import has exactly the reviewed
source bytes. It is not a new unproved axiom or a substitute hypothesis.
Its original certificate and independent judgement are bound by
`verify.py`, not regenerated. The formal theorem's axiom closure is
the standard propext, Classical.choice, and Quot.sound.

Run the standalone replay from the campaign root:

    $WORKSPACE/argus-live-update/.venv/bin/python research/char-p-line-recovery/verify.py

The Engineer's initial `--record` run invokes the authorized
`lean_evidence verify --claim V_CHARP_LINE_RECOVERY`, then records
`exact_certificate.json` from the real compiler output. Subsequent
replay recompiles through the same official adapter without changing
the claim ledger. Both modes check the campaign-local ledger and
proof graph. Finite modular sign and binomial-coefficient checks,
including p=2, are diagnostics only; the universal evidence is Lean.
No manuscript assertion has been refuted in this mission.

Independent statement-fidelity review, novelty assessment, and
acceptance remain for the host's Reviewer. Full reconstruction
remains open regardless of this line-recovery certificate.
