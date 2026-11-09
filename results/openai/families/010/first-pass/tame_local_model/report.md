# Tame matrix components and their nilpotent thickening

## Scope and source

This is a universal local algebra and component theorem, not a proof of
global pro-modularity. The target is `prop:local-geometry`, specifically
`eq:tame-model` through the following remark, in the staged
`Fontaine-Mazur-modularity-at-the-prime-2-October-6-2026/build/sections/deformation.tex`,
lines 658-924. The arithmetic Frobenius convention is
`phi tau phi^{-1} = tau^q`. There is **no** fixed determinant for `phi`.
The raw quotient is retained. The manuscript already acknowledges the
nonzero square-zero element considered below.

The tame theorem is conditional on the coefficient base: let V be a complete
characteristic-zero DVR, with uniformizer pi, residue field K of characteristic
two, and an element i with i^2=-1. Let A be a complete Noetherian local
V-algebra such that A and B=A/pi A are nonzero domains, pi is nonzero in A,
and the residue field of A is K. In particular 2 is nonzero in A.
Write D=dim A. No normality of A is needed here. Establishing these
hypotheses for the real/dyadic deformation base is a separate task;
neither BIP's dyadic theorem nor the global propagation argument is verified
by the present theorem.

The scope lookup found no exact prior source for the primary decomposition
and simultaneous nilpotent filtration stated below. This is a limited
negative retrieval result, **not** a proof of novelty. A search result
identified Shotton, *Local deformation rings for GL2 and a Breuil--Mezard
conjecture when l != p*, DOI 10.2140/ant.2016.10.1437, as adjacent literature.
Its publisher metadata were opened; no proposition from that article is
used here. In particular no odd-residue-characteristic theorem is silently
applied at two. No supplied source-checked BIP/Tabaa assumptions were present
in the initial claim ledger. The base hypotheses above are explicit instead.

The foundational completion/properness inputs actually used are Stacks
Tags 00MB, 00MC, 01WC, and 01W4. Their statements were opened during scope;
the passages are in `sources/`. Independent citation attribution is left to
the Reviewer, not self-certified by the filer. Finite tests, reductions
after inverting a formal variable, and observing the already acknowledged
nilpotent cannot replace the completion/component proof.

## The theorem

For any field k of characteristic two, set

    S = k[a,b,c,t,e,f,d],
    F = a^2+bc,  G = bf+ce,
    I = (F,bt,ct,G),  n = at,
    Q_U = (a^2,b,c),  P_U = (a,b,c),  P_R = (t,F,G).

The following statements hold over k, over any domain coefficient
k-algebra B, and in B[[a,b,c,t,e,f,d]] when B is complete Noetherian local.

1. `I = Q_U intersect P_R` is an irredundant primary decomposition.
   `Q_U` is `P_U`-primary and `P_R` is prime. There are no embedded
   associated primes. Both reduced components have relative dimension four.
2. `rad(I) = I+(at) = P_U intersect P_R`, `(I:at)=P_U`, and
   `n != 0`, `n^2=0` in S/I. Thus the nilradical is exactly the cyclic
   module `(n)`, isomorphic to `(S/P_U)n`, not merely a detected submodule.
3. For any finite number u of independent places, put
   `I_u = sum_j I_j`. For a pattern sigma in `{U,R}^u` put
   `Q_sigma = sum_j Q_{sigma_j,j}`, using `Q_R=P_R`, and similarly
   `P_sigma = sum_j P_{sigma_j,j}`. Then

       I_u = intersection_sigma Q_sigma,
       rad(I_u) = I_u+(a_1 t_1,...,a_u t_u)
                = intersection_sigma P_sigma.

   This is an irredundant primary decomposition, with exactly `2^u`
   associated/minimal primes and no embedded primes. These conclusions
   persist in the simultaneous completed ring over B.
4. Its nilradical `N=(a_j t_j)_j` has **ideal** nilpotence index exactly
   `u+1`: `N^{u+1}=0`, and `N^u != 0` for `u>0`. Every individual
   element of N nevertheless has square zero. On the component with
   r unramified factors, the length of the generic local ring is
   exactly `2^r`, and its nilradical has index `r+1`.
5. In the mixed-characteristic raw tame models over A, for any odd
   `q_j=1 mod 4`, the i-type has one horizontal component. The
   unipotent type has exactly `2^u` horizontal components, indexed by
   the same patterns. They all have dimension `D+4u`. The common raw
   special fiber is the ring in (3), of dimension `D-1+4u`. The
   underlying specialization of each unipotent horizontal component
   is exactly its corresponding `P_sigma` component. No generic point
   of a special component is contained in another horizontal component.

Here a product means an arbitrary **finite** number of tame places, not an
infinite tensor product. For u=0 the ring is the base, N=0, and the index
convention is one. Statements about arbitrary coefficient/curve extensions
are conditional on the new base satisfying the stated domain hypotheses;
we do not assume that a non-geometrically-integral base remains a domain
under every extension.

## Proof

### 1. Derivation from the matrices

Cayley--Hamilton and the prescribed inertia trace and determinant give
`tau^2=-1` for the i-type. Thus `tau^q=tau` when `q=1 mod 4`.
For the unipotent type write `tau=1+N`. Then `tr N=det N=0`,
`N^2=0`, and the binomial identity, valid in every commutative
coefficient ring, gives `(1+N)^q=1+qN`. Its relation is therefore
`phi N=q N phi`, with this order and not its inverse.

In characteristic two both types have

    tau = [1+a, b; c, 1+a],
    phi = [1+d, e; f, 1+g].

The determinant condition is F=0. The entries of `phi tau-tau phi`
are `ce+bf`, `b(d+g)`, `c(d+g)`, `bf+ce`.
Set `t=d+g`, so `g=t+d`. This is an invertible linear change over
any characteristic-two ring. The four generators are precisely I.
Invertibility of both matrices introduces no extra equation in the
completion at the identity: their determinants have unit constant term.

These are universal matrix identities, not a finite-field sampling claim.
`verify.py` checks them by exact polynomial arithmetic, including the
mixed-characteristic incidence equations and Frobenius orientation.

### 2. Intersections and the one-place nilradical

Work first polynomially, suppressing the spectator d. Put
`J=(F,G)` in `k[a,b,c,e,f]`. Since `J` is contained in `(b,c,a^2)`,
one has

    Q_U = J+(b,c),  P_R=J+(t),  I=J+t(b,c).

In `(k[a,b,c,e,f]/J)[t]`, the intersection of an extended ideal L
with `(t)` is `tL`: compare coefficients of powers of t. Taking
`L=(b,c)` proves the claimed intersection. Taking
`L=(a,b,c)` proves `P_U intersect P_R=I+(at)`.
This coefficient argument does not presuppose reducedness or primality.

The quotient by Q_U is `k[t,e,f,d][a]/(a^2)`. Its zero divisors are
exactly the multiples of a: a polynomial with nonzero constant
coefficient in a becomes a unit over the fraction field, and the
quotient is free over the domain `k[t,e,f,d]`. Consequently Q_U is
P_U-primary.

For completeness, P_R is prime without an appeal to an unspecified
complete-intersection criterion. The two monic polynomials F,G have
relatively prime leading monomials `a^2,bf` for lexicographic order
`a>b>c>e>f`. They are a Groebner basis over every coefficient ring.
Their standard monomials have the form

    a^epsilon b^j c^k e^l f^m,
    epsilon in {0,1},  j*m=0.

Map the polynomial quotient into the Laurent polynomial domain by

    c |-> a^2/b,  f |-> a^2 e/b^2.

A standard monomial maps to

    a^{epsilon+2(k+m)} b^{j-k-2m} e^{l+m}.

These exponents recover the input uniquely. The parity of the first
exponent gives epsilon. Put H=(first-epsilon)/2=k+m and
Z=second+H=j-m. If Z>=0, then m=0 and j=Z; if Z<0, then
j=0 and m=-Z. Now k=H-m and l=third-m.
Distinct standard monomials therefore have distinct Laurent monomial
images. This proves injectivity and primality over every domain
coefficient ring. The exponent injectivity, for all natural input
exponents with an integer Laurent b-exponent, is one of the Lean
theorems. **This substitution is used only for polynomials.**

The two components are incomparable: `t` is in P_R but not P_U,
and `b` is in P_U but not P_R. The decomposition is irredundant.
In particular there are no embedded primes.

Modulo Q_U, multiplying at by an element kills it exactly when the
element is divisible by a, since t is a nonzerodivisor in the domain
of constant coefficients. Modulo P_R, at is already zero.
Taking the colon of the intersection gives `(I:at)=P_U`.
Furthermore `(at)^2=t^2 F-(bt)(ct)` is in I, and at is not in Q_U.
This proves every assertion in (1)-(2). The explicit formal witness
`a |-> epsilon`, `b,c,e,f,d |-> 0`, `t |-> T` takes n to
`epsilon T != 0` in `k[[T]][epsilon]/(epsilon^2)`. It is continuous
and local; setting a formal parameter to one is not used.

### 3. Arbitrarily many factors and completion

Over k, the one-place injection

    S/I --> S/Q_U direct_sum S/P_R

can be tensored with any k-vector space without losing injectivity.
Tensor it place by place. The resulting kernel statement is exactly
`I_u=intersection Q_sigma`. Tensoring the analogous reduced
injection proves the formula for the intersection of the P_sigma.
Extending coefficients from k to B is exact for the same reason.

For any pattern, its polynomial reduced quotient is a domain.
Indeed the standard-monomial Laurent embeddings just proved tensor
in disjoint variables and remain injective into a Laurent polynomial
domain over B. Unramified factors just add four polynomial variables.
The quotient by Q_sigma is a finite free algebra

    T[epsilon_1,...,epsilon_r]/(epsilon_1^2,...,epsilon_r^2)

over this reduced domain T, where the epsilon variables are the a's
at unramified places. An element with nonzero image in T becomes a
unit over Frac(T), so is a nonzerodivisor on this free T-module.
An element with zero image in T is nilpotent. Thus Q_sigma is
P_sigma-primary, including when r>1.

All the ideals are homogeneous in the new variables. Completion
does not merely mean checking finite truncations. The completion
of a polynomial quotient with homogeneous relations is the product
of its homogeneous pieces with coefficients in the complete base.
Every piece is a finite free B-module, with the displayed standard
monomial basis. A nonzero series has a least new-variable degree;
the initial homogeneous parts of two nonzero series multiply
nontrivially in the polynomial domain. Therefore each completed
reduced pattern ring is a domain.

More formally, complete `B[all new variables]` for the ideal generated
by `m_B` and the new variables. This is a Noetherian ring, so
Stacks 00MB gives exactness on finite modules. Applying it to the
finite kernel/intersection sequences above carries **all** the
displayed equalities, including the colon equality, into
`B[[all new variables]]`. The completed Q_sigma quotient is again
the finite free square-zero-variable algebra over its completed
reduced domain. Its primary property follows by the same
fraction-field argument. This does not claim that completion
preserves prime or primary ideals in general.

Each pattern has a nonzero open set on which all its U traces t
and all its R coordinates b are nonzero. A different pattern
excludes that open set at a place where it differs. Thus all
`2^u` primary components remain necessary.

### 4. Exact nilpotent filtration and multiplicities

The intersection of the reduced pattern primes gives
`N=rad(I_u)/I_u=(n_1,...,n_u)`, where `n_j=a_j t_j`.
Every `n_j^2=0`. A product of u+1 of these generators repeats one,
so `N^{u+1}=0` over any commutative coefficient ring.
The product of all u generators is nonzero: the continuous local
specialization

    a_j |-> epsilon_j,  t_j |-> T_j,
    b_j,c_j,e_j,f_j,d_j |-> 0

maps it to the nonzero basis monomial
`epsilon_1 ... epsilon_u T_1 ... T_u` in
`B[[T_1,...,T_u]][epsilon_1,...,epsilon_u]/(epsilon_j^2)_j`.
In characteristic two a sum of square-zero commuting elements
also has square zero, proving the distinction between element and
ideal nilpotence.

One can specify the entire filtration, not just its extremal powers.
Let `H_j=S_j/(I_j+(n_j))` and `M_j=S_j/P_{U,j}`, with its generator
placed in new-variable degree two. For `0<=m<=u`,

    N^m/N^{m+1}
      = direct_sum_{T subset {1,...,u}, |T|=m}
          (tensor_{j in T} M_j) tensor
          (tensor_{j not in T} H_j).

This is an isomorphism of modules over the reduced product, with
internal degree shift 2m. Tensor products and sums are over k and
then extended to B; in the formal case they are completed. To prove
it, split the single-place exact sequence
`0 -> (n_j) -> S_j/I_j -> H_j -> 0` as graded k-vector spaces.
In their tensor product, `N^m` is the sum of the tensor summands
having at least m nilradical factors. Quotienting by `N^{m+1}`
leaves exactly the indicated summands, canonically via
multiplication. Exactness of Noetherian completion preserves this
finite filtration and its subquotients.

At the generic point of P_sigma all other primary components
disappear. The localization is exactly

    Frac(T)[epsilon_1,...,epsilon_r]/(epsilon_j^2)_j.

Its square-free epsilon monomials form a basis, of cardinality
`2^r`. The top product is nonzero and any product of r+1
nilradical generators vanishes. This proves both the generic
multiplicity and its precise nilpotence index.

### 5. Horizontal components, without altering the raw ring

Use the proper line incidences, not their presumed normalizations.
For the i-type, a stable i-eigenline gives, in an adapted basis,

    tau = [i,n;0,-i],   phi = [v+x,h;0,v],   v=1+d,
    xn=2ih.

The commutator has just this upper-right entry. For the unipotent
ramified choice the incidence has

    tau = [1,n;0,1],   phi = [qv,h;0,v].

There is no further equation. For the unramified choice tau=1
and phi is arbitrary. Each chosen ramified place contributes its
line slope. Both kinds therefore have relative dimension four.
These equations hold over A, not just over a field.

Here are the needed completion and integrality details. On a
product slope chart with s slopes, the coefficient ring is
`C=completion_{m_A}(A[s_1,...,s_s])`. It embeds by coefficients in
`A[[s_1,...,s_s]]`, and is a domain. A unipotent pattern incidence
has free completed matrix coordinates over C. For the i-type its
completed chart is

    C[[x_j,n_j,h_j,d_j]]/(x_j n_j-2i h_j)_j.

Reduce paired powers of x_j,n_j into 2i h_j, using weights
`wt(x)=wt(n)=1`, `wt(h)=2` and positive weights on base
parameters. This converges in the full maximal-ideal topology:
replacement loses one matrix degree but gains at least one base
degree. Differences are convergent multiples of the relations.
In a reduced monomial at least one of the x_j,n_j exponents is
zero. The substitution `h_j -> x_j n_j/(2i)` then maps it
injectively into `Frac(C)[[x_j,n_j,d_j]]`: the minimum of the two
output exponents recovers the h_j exponent. At each output
monomial only finitely many reduced input terms contribute.
There is no bounded-denominator assertion here. This proves the
completed chart is a domain and that 2 remains nonzero.

The incidences are Noetherian and proper over their raw complete
local rings: they are closed in products of projective lines
(Stacks 01WC). Completion is flat and is faithfully flat after
localization at a closed-fiber point (00MB, 00MC). Hence their
local rings are domains along the closed fiber. The non-locally-
integral locus is closed here: use finitely many components and
the support of the coherent nilradical. Its image under the
proper map would be a nonempty closed subset of a local spectrum,
and so would contain the closed point. Consequently that locus
is empty. Components are disjoint, and the closed fiber is
`(P^1_K)^s`, which is connected. Every component meets this fiber,
so the incidence is integral. Its domain charts make it
horizontal. The same argument modulo pi proves that the
unipotent pattern incidence has an integral special fiber.

For the i-type, after inverting 2 the i-eigenline is uniquely
selected by `(tau+i)/(2i)`; the proper incidence is an
isomorphism there. In characteristic two, at every geometric
point the two commuting matrices have a common eigenline:
if tau is nontrivial unipotent its kernel line works, and if
tau=1 choose an eigenline of phi. Thus its integral horizontal
image covers the raw spectrum. There is just one component;
this makes no claim that the raw i-type ring is reduced.

For the unipotent type, at every field point N is either zero
or has `im N=ker N`, a unique line stable under phi. In the
latter case `phi N=q N phi` forces the displayed diagonal
ratio. The `2^u` proper pattern images therefore cover every
geometric point. They are integral horizontal closed subsets.

Modulo pi, a ramified pattern incidence maps onto P_R: a
nonzero nilpotent N supplies its unique line, while at N=0
the condition `tr phi=0` makes phi have a repeated eigenvalue
over an algebraic closure, so the same incidence has a lift.
The unramified image is P_U. Applying this independently at
every place identifies each entire special image, not just
its dense open set. A proper surjection onto an image stays
surjective after base change (01W4 supplies properness and
closedness); thus its support is exactly the specialization
of that horizontal component. Surjectivity under base change
can also be checked directly: tensoring the residue field of
a point above a base point with an extension of the base
residue field is a nonzero ring and has a prime.

At a generic U point t is nonzero, while a ramified image
forces t=0. At a generic R point b is nonzero, while an
unramified image forces a=b=c=0. Distinct patterns therefore
give incomparable horizontal images, and each special
generic point lies on just its assigned image. Since these
images cover the spectrum, they are all the components.
Each special pattern has dimension `dim B+4u`; its horizontal
image is a complete local domain in which pi is a nonzero
nonunit. Quotienting by such an element lowers local
dimension by one: a chain of primes in the quotient can
be extended below its first term by the zero prime of
the domain, and a lifted system of parameters of the
quotient, supplemented by pi, is a system of parameters.
Thus its dimension is `D+4u`. The same
argument for the i-type uses the now identified special
support. This proves (5).

For the manuscript's asserted base dimension `D=1+8d+g`,
these are exactly `e` and `e-1`. The previously strongest
staged statement identified reduced supports and one possible
nilpotent. The strengthening here determines every primary
component, the entire nilradical and its filtration, exact
nilpotence indices, and all generic multiplicities for
arbitrarily many simultaneous completed factors.

## Evidence and limits

`verify.py` and `exact_certificate.json` check exact ideal
equalities and colons in characteristic two, matrix equations,
explicit nonvanishing witnesses, and selected simultaneous
instances. The all-u and completion claims are proved above;
finite checks are not substituted for those proofs.

`Main.lean` formalizes the injectivity of the standard-monomial
exponent map, a general saturated-principal-ideal intersection
lemma, and the universal square-zero/annihilation identities.
`statement_fidelity.md` separates exactly those statements from
the larger theorem. The actual Lean 4.31.0 run exited zero
with `proof_holes=[]` and an axiom-audit exit of zero. It is
archived as `certificates/L_TAME_LEAN-bf7a3e4dfa3d3402.json`;
its source and statement-fidelity hashes are checked by
`verify.py`. The source and reading have not been edited
since that run. This certifies only the three stated
algebraic declarations, not the entire geometric proof.

The final exact replay passed 601 checks. The independent
Reviewer must rerun the script, assess the all-u and formal
completion arguments and horizontal incidence proof, check
the statement-fidelity document, and independently attribute
the four foundational citations already recorded in the
ledger. Source excerpts are under `sources/`. The official
citation tool archives outside this mission's writable paths
(`research/literature/`), so the Engineer has not invoked an
out-of-scope archive write or impersonated an independent
reader. Host authorization of that tool's archive output
is needed if the same write boundary is retained for review.

No false literal tame assertion has been established, so no
manufactured `F_` refutation claim is warranted. Novelty,
significance, citation attribution, and the unformalized
geometric proof require independent Reviewer assessment.
