# Fixed-level homology in the congruence tower

## Result and boundaries

Let k be a finite field of odd characteristic p, R=k[t], and, for all
integers a,m>=1, let

    Gamma_a(m) = ker(SL_a(R) -> SL_a(R/(t^m))).

All homology below is ordinary group homology with trivial coefficients.
The following verifies precisely the connected core asked for:

**Theorem.** For every h>=0, a>=2h+1, m>=1, and 0<=j<=h,

    H_j(Gamma_a(m);F_2) -> H_j(Gamma_(a+1)(m);F_2)

is surjective. For every d>=3, N=2d+1, m>=1, and 1<=j<=d-1,
the conjugation action of SL_N(R) on H_j(Gamma_N(m);F_2) is trivial.
In particular this covers every odd prime field in the manuscript;
no lower bound on its size is needed for these two lemmas.

This is a universal mathematical proof, conditional only on the two
explicit external theorems below and standard foundational homological
algebra explained in Section 3. It is not a finite search, and its
complete application to groups is not claimed to be a Lean theorem.
The Lean file checks the delicate diagram, promotion, and action
inferences with the exact scope in `statement_fidelity.md`.
No false assertion was found in the two target lemmas.

Neither the manuscript's main existence theorem nor geometric acyclicity
is established here. Section 6 gives only the conditional implication
for `prop:quotient-homology`. Independent Reviewer acceptance and
independent citation attribution remain outstanding. No mathematical
novelty is claimed for a reconstruction of the manuscript's argument.

## 1. Sources and conventions

The primary-source reader checked the published versions/locators:

* Morrow, arXiv:1404.4179v2, Definition 0.1 and Theorem 0.3:
  powers of an ideal in a commutative Noetherian ring are pro Tor-unital,
  meaning pro-vanishing of Tor_i^(Z ltimes I^m)(Z,Z), i>0.
* Iwasa, DOI 10.4310/HHA.2020.v22.n1.a20, published Theorem 5.13,
  p.372: for a commutative Tor-unital pro ring A and
  r=max(2,sup_m sr(A_m)), integral stabilization is a pro-isomorphism
  for a>=2j+r-1. The theorem also gives a pro-epimorphism at
  a>=2j+r-2, but the proof below does not need that stronger part.
* Vaserstein, DOI 10.1070/SM1969v008n03ABEH001279, Section 2,
  pp.384-385, condition (2.2)_n: stable range <=s reduces every
  relative unimodular vector of length n+1 for every n>=s, by
  coefficients in the ideal. His columns transpose to the manuscript's
  rows because the present rings are commutative.

Short source excerpts and exact URLs are in
`literature/source_excerpts.txt`. The sources were read by
`homology-source-reader`, not by an independent Reviewer.
Their source attributions have not been laundered into Reviewer
judgements. The official `citation_check attribute` command archives
under `research/literature/`, outside this mission's writable paths;
it has deliberately not been invoked with an unauthorized destination.

A targeted literature search for the fixed-level implication produced
leads to Charney, Putman, and Calegari--Emerton, not an opened proposition
establishing novelty of this exact bound. Those leads are not assumptions,
citations supporting the proof, or evidence of novelty.

## 2. Concrete applicability: integer unitization and stable range

Put A_m=t^m R and B_m=Z ltimes A_m, with multiplication
(u,x)(v,y)=(uv,uy+vx+xy). There are maps

    epsilon:B_m -> Z,       (u,x) |-> u,
    phi:B_m -> R,           (u,x) |-> (u mod p)+x.

The map phi is NOT injective: (p,0) is in its kernel. But on
ker(epsilon)=A_m it is injective, so the two kernels have zero
intersection. This is precisely all the argument requires.

A matrix in ker(GL_a(B_m)->GL_a(Z)) has the unique form I+X with
X in M_a(A_m). Its inverse is I+Y with Y in M_a(A_m). Applying phi
gives inverse polynomial matrices congruent to I mod t^m. Conversely,
if M in GL_a(R) is congruent to I mod t^m, its polynomial inverse is
also congruent to I (reduce the inverse equation). Lift them uniquely
with integer augmentations I. Both products have augmentation I and
polynomial image I. Subtracting I gives a matrix over A_m on which
phi is injective, hence both products are I in B_m.

Finally det(M) is in R^*=k^*, and det(M) is congruent to 1 mod t^m.
As m>=1, the constant det(M) must be 1. Thus the relative GL group is
exactly Gamma_a(m). This identification commutes with every deeper-level
inclusion, rank stabilization, and coordinate permutation.
It does not identify B_m with a subring of R.

We now check sr(A_m)<=2 in the specified relative convention.
Start with a B_m-row b of length ell>=3 congruent to e_1 modulo A_m,
and a relative witness c with b dot c=1. Its polynomial image is
unimodular, b_1=1 mod t^m, and b_i=0 mod t^m for i>1.
In particular b_1 is nonzero and is coprime to t.

For each distinct monic irreducible P dividing b_1:

* If b_ell is nonzero mod P, choose v mod P different from
  -b_2/b_ell. The residue field has at least two elements, so such
  a choice exists.
* If b_ell=0 mod P, unimodularity of the original row already
  guarantees a nonzero entry among b_2,...,b_(ell-1) mod P.

The pairwise coprime moduli t^m and all these P permit CRT with
v=0 mod t^m and the chosen residues. Consequently

    (b_1, b_2+v b_ell, b_3,...,b_(ell-1))

has no common irreducible divisor, hence is unimodular over k[t].
If b_1 is a unit the list of P is empty and v=0 suffices.
This construction uses v_2=v and all other reduction coefficients
zero, exactly as Vaserstein requires.

It remains to check RELATIVE unimodularity, not just ordinary
unimodularity. If a polynomial row beta congruent to e_1 has
beta dot gamma=1, put

    gamma' = e_1+(1-beta_1) gamma.

Then beta dot gamma'=beta_1+(1-beta_1)*1=1 and gamma'=e_1 mod t^m.
Lift beta and gamma' with augmentations e_1. Their dot product has
augmentation 1 and image 1 under phi; subtracting 1 lies in A_m,
where phi is injective. This is a relative witness in B_m.
Thus sr(A_m)<=2 for every m, with no row-length indexing shift.

The ring R is commutative Noetherian (indeed Euclidean). Morrow
applies to I=(t), giving exactly the integer-unitization Tor-unitality
Iwasa requires. The preceding calculation gives r=2. Iwasa therefore
gives, for every j>=0 and a>=2j+1,

    (H_j(Gamma_a(m);Z))_m -> (H_j(Gamma_(a+1)(m);Z))_m

as a pro-isomorphism. The index set is all m>=1, not a restriction
to a chosen finite set of levels.

## 3. Coefficient change without a natural splitting

For a free integral chain complex computing group homology there is
the natural exact sequence

    0 -> H_j(G;Z) tensor F_2 -> H_j(G;F_2)
      -> Tor_1^Z(H_(j-1)(G;Z),F_2) -> 0.

One obtains it by tensoring the cycle/boundary short exact sequences:
boundaries and cycles are subgroups of free abelian chain groups,
hence free; the possible failure of tensor exactness is precisely
the displayed Tor term. This construction is natural in chain maps.
The sequence splits as groups but no natural splitting is used.
The same applies to the inclusion/stabilization maps here.

Any functor on abelian groups, in particular - tensor F_2 and
Tor_1^Z(-,F_2), induces a functor on inverse systems/pro morphisms:
apply it to representative maps, which preserves equality after
passing to a later index. It therefore preserves pro-isomorphisms.
This does NOT assert that tensor or Tor is exact.

For j>=1 and a>=2h+1 with j<=h, both integral degrees j and j-1
are in Iwasa's isomorphism range. Both ends of the natural
universal-coefficient diagram are consequently pro-isomorphisms.
The short exact sequences are exact in the abelian category of pro
abelian groups, so the middle map is a pro-isomorphism as well.
For completeness, only its pro-epimorphic part is needed, and the
following direct chase avoids any reliance on a natural splitting
or on an unexplained categorical five lemma.

Write the two universal-coefficient rows as A -> B -> C and
A' -> B' -> C', and their vertical maps as f,g,h. Fix a target
index m. Choose n>=m for which the transition A'_n -> A'_m
lands in im(f_m). Choose l>=n for which C'_l -> C'_n lands
in im(h_n). Given y in B'_l, lift its projected image in C'_n
to c in C_n, and lift c to b in B_n. Naturality makes

    y_n - g_n(b) = i'_n(z),       z in A'_n.

Choose a in A_m with f_m(a)=z_m. Then the transition of y to B'_m is

    g_m(b_m+i_m(a)).

Thus the cokernel transition from l to m is zero. This argument
is the universally quantified theorem `twoLayerEventuallyInImage`
in the Lean source. Indices may depend on m, and there is no
claim of a uniform bound on the later index.

Degree zero is immediate: all groups have H_0(-;F_2)=F_2 and
inclusions induce its identity, including Gamma_1(m)=1.

## 4. Transfer, its direction, and promotion

For s>=r>=1, the reduction map modulo t^s embeds
Gamma_b(r)/Gamma_b(s) into a finite matrix group over R/(t^s).
The congruence filtration has additive successive subquotients:

    I+t^i X |-> X mod t,       r<=i<s.

This is a group homomorphism on the i-th quotient since 2i>=i+1;
its kernel is the next congruence subgroup. Its image is a subgroup
of the additive finite matrix space over k (in fact trace zero).
Consequently [Gamma_b(r):Gamma_b(s)] is a finite power of p,
and is odd. This also covers b=1 and s=r, with index 1.

For any subgroup H of finite index c in G and trivial F_2
coefficients there is homology transfer

    tr:H_j(G;F_2) -> H_j(H;F_2),
    inclusion_* tr = c id.

The direction is from the larger group to its subgroup. One
construction takes a free contractible G-complex EG. The covering
EG/H -> EG/G has c sheets. Lift each singular simplex to all its
sheets and sum the lifts. Boundary commutes with this sum and
projection of it is c times the original chain. This proves the
identity in every degree, and both spaces compute the asserted
group homology. Normality is not needed for this identity.

Here c is odd, so c id=id over F_2. Therefore EVERY homology
transition H_j(Gamma_b(s);F_2)->H_j(Gamma_b(r);F_2) is split
surjective. The retraction is in the direction required for an
inverse sequence; the argument does not assert injectivity.

Let f_m be a stabilization map. For each r, Section 3 supplies
s>=r such that every element transitioning from the target of f_s
to the target of f_r is in im(f_r). But that target transition
is surjective by transfer. Hence every element at level r is in
im(f_r). This proves fixed-level surjectivity for every r.
Equivalently, the cokernel tower is pro-zero and has surjective
transitions, so every cokernel is zero.

`levelwiseSurjective` formally checks precisely this implication;
`surjectiveOfTransfer` checks the split-surjectivity inference.
The source transitions need not be surjective for the abstract
promotion, though here they are.

A discarded shortcut would infer levelwise zero just from pro-zero.
It is false: the tower with F_2 at every index and every strict
transition zero is pro-zero but has no zero term. This is a
counterexample to the DISCARDED shortcut, not to the manuscript,
which explicitly supplies the additional transfer argument.

Combining Sections 2-4 proves `lem:stabilization` for every stated
h,a,j,m. No fixed-level homology computation or finite-rank
experiment has been substituted for this proof.

## 5. Coordinate centralizers and the complete ambient action

Let d>=3, N=2d+1, and 1<=j<=d-1. Put h=d-1. Then

    N-2=2h+1,       N-1>=2h+1.

The two consecutive stabilizations, of ranks N-2 and N-1, are
both surjective by the theorem just proved. Their composite
from the first N-2 coordinates to Gamma_N(m) is surjective
on H_j for every m>=1.

For any subset C of N-2 coordinates choose a permutation matrix
P carrying the first N-2 coordinates to C. Although det(P) may
be -1, that is harmless: conjugation by every P in GL_N(R)
normalizes Gamma_N(m). Indeed, reduce P M P^(-1) modulo t^m.
It is I whenever M is I. Conjugation induces an automorphism
of homology, so applying it to the preceding surjective image
gives the same surjectivity from the subgroup on C.
The argument does not assume the ambient SL action already trivial.

For an elementary matrix e_ab(f)=I+f E_ab, a!=b, take C to
be the complement of {a,b}. If M=I+Y is in the congruence
subgroup on C, then Y has support only in C x C. Thus

    (E_ab Y)_ij = delta_(i,a) Y_bj = 0,
    (Y E_ab)_ij = Y_ia delta_(b,j) = 0.

It follows that (I+f E_ab)M=M(I+f E_ab), for all f in R
and all such M. The induced conjugation map fixes the entire
surjective homology image from the subgroup on C. Hence it
fixes every element of H_j(Gamma_N(m);F_2).

Elementary matrices generate SL_N(k[t]). Here is why the ring
hypothesis suffices. Polynomial division gives the Euclidean
row-reduction algorithm for a unimodular first column; signed
row interchanges are elementary products. Clear the first row
and column and induct. Residual determinant-one diagonal
matrices are products of two-coordinate blocks
diag(u,u^(-1)), with u in k^*. Such a block is

    w(u) w(-1),
    w(u)=e_12(u)e_21(-u^(-1))e_12(u)
        = [[0,u],[-u^(-1),0]].

The exact two-by-two identity is independently checked over
Z[u,u^(-1)] in `verify.py`. Thus all ambient conjugations
are products of those already proved trivial.
`trivialActionOfSurjectiveFixedImages` formalizes the generating-set
inference without assuming triviality of the whole action.
This proves `lem:trivial-action` for every stated level and rank.

## 6. Exactly what follows for the quotient homology

Use the manuscript's U, the inverse image of the upper unitriangular
subgroup under evaluation at zero, and N=2d+1. Gamma_N(m) is
normal in U, and G_m=U/Gamma_N(m) is finite of odd order:
its image modulo t is a subgroup of the upper unitriangular
p-group, and the remaining congruence filtration has additive
p-group factors as in Section 4.

For completeness, take a free F_2[U]-resolution P of F_2.
Restriction is a free F_2[Gamma_N(m)]-resolution, since the larger
group ring is free over the subgroup ring. The chain complex
P_(Gamma_N(m)) computes its homology and carries the quotient
action. This is the conjugation action on homology; changing a
coset representative changes the chain map by an inner action,
which is chain homotopic to the identity.

For an odd-order finite group Q, averaging is a projection onto
invariants and identifies invariants with coinvariants. It makes
coinvariants exact: lift an invariant element along an epimorphism
and average any lift. Thus taking homology commutes with Q
coinvariants. Apply this to Q=G_m to get

    H_j(U;F_2) = H_j(Gamma_N(m);F_2)_(G_m).

By Section 5 the action is trivial in 1<=j<=d-1, so the right-hand
side is H_j(Gamma_N(m);F_2).

**Conditional implication only.** If the manuscript's geometric
acyclicity and `prop:homology-comparisons` are correct, they give
H_j(U;F_2)=0 and H_j(T_m;F_2)=H_j(Gamma_N(m);F_2) in
0<j<n-1. Since d-1<n-1, the three groups in
`prop:quotient-homology` vanish for every m>=2; cohomology is
the dual of homology over the field F_2.
This leaves all the geometric hypotheses, recognition of the
finite complexes, and the cosystolic application unverified.

## 7. Exact evidence and classification

`exact_certificate.json` records the universal assertions, external
dependencies, and coverage boundary. `verify.py` replays the
integer/Laurent polynomial identities, rejects a failed/incomplete
Jacobian outcome, checks the exact Lean statement/certificate
binding, and invokes a fresh real Lean compiler unless explicitly
asked for the narrower algebra-only check. Its finite adversarial
examples are labelled as such, never as the proof of all levels.

The Jacobian operation `polynomial.ideal.normal_form.compute`
checked b+(1-b)s-1 modulo (s-1), over QQ, with outcome COMPUTED
and zero remainder. The stored integer factorization

    b+(1-b)s-1 = (1-b)(s-1)

independently shows why that identity specializes to characteristic p;
the QQ computation alone would not justify reduction modulo p.
Exact payload, typed output, server/protocol versions, and adapter
exit status are preserved in the adjacent JSON files.

The strongest prior recorded result was the manuscript's unverified
bridge and a one-node audit graph. The present contribution is a
source-checked universal proof of that bridge with separately
machine-checked inference lemmas, not a new bounded search and
not a refutation. Independent review, official citation attribution,
and any publishability/novelty determination are pending. It is not
a terminal result for the overall continuous counterexample campaign.
