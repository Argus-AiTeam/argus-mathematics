# The uniform missed-prime bridge

## Result and scope

Under precisely the surjectivity and logarithmic-compatibility hypotheses
of `thm:normalized-map`, Proposition `prop:uniform-missed-primes` is valid.
In fact, its proof gives the more precise bound (1) below. This is a
general proof, not an exhaustion of examples. It does **not** prove
`thm:normalized-map`, the logarithm-rank lemma, or the manuscript's main
theorem. Independent review is outstanding.

The comparison point is the manuscript's bound `2[K:Q]`. The improvement
here is an explicit stabilizer formula and a detailed justification of
the completion, injectivity, and ramification steps. These are standard
consequences of Kummer theory and the equivariant unit theorem, not a
claim of a new publishable theorem. This milestone does not finish the
publishable campaign.

Let `B=Q(i)`, let `f=beta_B:G_K -> P_B` be the specified continuous
surjection, and fix any eligible odd prime `ell`. Put
`rho=chi_ell o f` and `epsilon=rho/chi_K,ell`. Equality of logarithms
implies that epsilon takes values in `mu_(ell-1)`, since this is exactly
the kernel of the logarithm on `Z_ell^times` for odd ell. No equality
of the full cyclotomic characters is assumed. Let `F=K'` be the fixed
field of its kernel and `Delta=Gal(F/K)`. Thus epsilon is a faithful
one-dimensional character of Delta, including the case `Delta=1`.

Write `r1_split(F/K)` for the number of real places of K that remain
real in F, and `g_ell_split(F/K)` for the number of primes of K over ell
that split completely in F. Then

    # {missed target primes w : w does not divide ell}
      <= r1_split(F/K) + r2(K) + g_ell_split(F/K) - [epsilon=1].       (1)

In particular this number is at most `2[K:Q]`, and adding the at most
two primes of B over ell proves the stated total bound.

## Precisely which literature is used

1. Uchida, *Homomorphisms of Galois groups of solvably closed Galois
   extensions*, JMSJ 33 (1981), DOI `10.2969/jmsj/03340595`, Section 1,
   pp. 595-596. The assumptions are solvably closed Galois extensions
   of number fields, a continuous map with open image, and a source
   prime away from the auxiliary prime. For odd ell, surviving pro-ell
   inertia forces case (ii): decomposition containment at a unique
   finite target prime away from ell and containment of the surviving
   pro-ell inertia in target inertia. The source here is the algebraic
   closure of K, the target is `Q^s/B`, and the map is open. The
   cofinite-coverage conclusion of Proposition 1 on p. 597 is **not**
   an input to the proof below, so there is no circular use of a
   finiteness statement being proved.
2. Bass, *Generators and relations for cyclotomic units*, Nagoya Math.
   J. 27 (1966), DOI `10.1017/S0027763000026258`, Section 3, Lemma
   (Dirichlet, Artin-Tate), pp. 402-403. For an arbitrary finite Galois
   extension and a finite set of base places containing infinity, the
   rational S-unit representation plus one trivial representation is
   the permutation representation on the places above that set.
   Neither absence of ramification nor total imaginarity is a
   hypothesis. Scalar extension from Q gives the Q_ell statement.
3. Finite-level Kummer theory: Stacks Project, tag `03PK`, Lemma
   59.28.1 (tag `03PL`) and its following H1-to-Picard exact sequence.
   The relevant invertibility hypothesis holds on `Spec F` and on
   `Spec O_(F,S)` because S contains the primes over ell.
4. Finiteness of the class group: Milne, *Algebraic Number Theory*,
   version 3.08, July 19, 2020, Theorem 4.4, p. 70. The S-class group
   is a quotient and is finite as well.

The primary documents, rather than search summaries, were obtained:
`literature/uchida1981-journal.pdf`, `literature/bass1966.pdf`,
`literature/stacks-03PK.html`, and `literature/milne-ant.pdf`.
The first attempted Euclid download was an HTML response, not a paper;
the successful Uchida source is the historical J-STAGE `jmath1948`
archive. The two original manuscript citations needed for the bridge
really do contain the indicated propositions. Their independent
attribution still belongs to the Reviewer.

The statements above are external inputs, separately entered in
`MATH_STATE.json`; they are not conclusions of the symbolic verifier.
The usual identification of finite Galois cohomology with the
cohomology of `Spec F` is included in the finite Kummer input.

## 1. Kummer classes without a finite-support assumption

For any number field F and finite S containing infinity and the primes
over ell, finite Kummer theory gives

    H1(G_F, mu_(ell^n)) = F^times / (F^times)^(ell^n).

Taking inverse limits gives integral continuous H1 with coefficients
`Z_ell(1)`. The possible `lim^1 H0` term vanishes: the degree-zero
groups are finite and their transition images stabilize. Every
continuous rational cocycle has compact, hence bounded, image and
becomes integral after multiplication by a power of ell. If an integral
cocycle is a rational coboundary, multiplying its cobounding element
by a power of ell makes it an integral coboundary. Consequently

    H1(G_F, Q_ell(1)) = H1(G_F, Z_ell(1)) tensor_(Z_ell) Q_ell.

At a finite prime v away from ell, the coefficient module is
unramified. Indeed roots of unity of ell-power order belong to the
maximal unramified local extension. A unit has every ell-power root
in that extension by Hensel's lemma; a uniformizer gives the tame
ell-adic character. Thus restriction of a Kummer cocycle to inertia
is its valuation coordinate times that character. Inertia coboundaries
are zero, and these homomorphisms into `Z_ell(1)` are torsion-free.
An integral class becoming unramified after rationalization therefore
already has zero valuation coordinate there.

Let `U_S=O_(F,S)^times`, `A=Cl_S(F)`, and let H_n be the subgroup of
`F^times/(F^times)^(ell^n)` having all valuations outside S divisible
by `ell^n`. There is an exact sequence

    0 -> U_S/U_S^(ell^n) -> H_n -> A[ell^n] -> 0.                    (2)

Explicitly, write `div_S(a)=ell^n D` and send the class of a to
`[D]`. Changing a by an ell^n-th power changes D by a principal
divisor. Conversely an ell^n-torsion ideal class has such a
representative, and the zero class allows a to be adjusted by an
ell^n-th power to an S-unit.

Crucially the map on the obstruction groups from level `n+1` to n
is **multiplication by ell**, not the identity: the same divisor is
`ell^(n+1) D = ell^n (ell D)`. Choose a with `ell^a A{ell}=0`.
A compatible sequence of obstructions satisfies
`x_n=ell^a x_(n+a)=0` for every n. Hence the inverse limit of the
right-hand groups is zero. Any compatible sequence in the H_n has,
at every level, a unique preimage in the unit quotient, and these
preimages are compatible. This proves that the simultaneous kernel
of *all* outside-S valuations is the completion of U_S.

By the finite generation in the S-unit theorem, its rationalization
is `U_S tensor_Z Q_ell`. All the maps just used commute with field
automorphisms preserving S, with the natural action on the Tate
twist. We have proved `L_KUMMER_COMPLETE`, including equivariance.

For clarity, finite support in the completed multiplicative group
would be false: for distinct rational primes `p_j != ell`, `j>=1`,
the level-n elements

    product_(1 <= j < n) p_j^(ell^j) mod (Q^times)^(ell^n)

are compatible. Their valuation at p_j is `ell^j`, so the inverse
limit has infinitely many nonzero valuation coordinates. It is not
unramified outside any finite S. This invalid shortcut is a retired
route, not a counterexample to the manuscript's lemma.

## 2. Independence, restriction, and the inverse twist

Take an arbitrary finite set J of missed primes away from ell.
For each w choose `(a_w)=w^(h_w)` with `h_w>0`. Finite class number
permits this (and B even has class number one). The compatible
radicals and roots of unity lie in `Q^s`, so their Kummer cocycles
factor through `P_B`. To see this directly, their finite Galois
closures over Q are obtained from solvable extensions by cyclotomic
and radical extensions and remain solvable. Compatible choices of
radicals can be made successively.

The classes `kappa_w` are independent: inflate them to G_B and apply
the valuation at each w. The matrix of these evaluations is diagonal
with nonzero diagonal `h_w` in Q_ell. Divisibility of h_w by ell is
irrelevant over this field.

Pullback by the surjection f is injective on H1 with its pulled-back
coefficient module `Q_ell(rho)`: if the inflated cocycle is the
coboundary of m, surjectivity gives the same coboundary identity
for every element of the target.

Restriction to `H=G_F` is also injective. For a class whose
restriction is zero, subtract a coboundary so its cocycle vanishes
on H. The cocycle then descends to Delta with values in `M^H`.
If z is this finite-group cocycle, put
`b=|Delta|^(-1) sum_(d in Delta) z(d)`. Reindexing the sum in the
cocycle relation gives `z(g)=b-gb`, the coboundary of `-b`.
This argument works in characteristic zero without any assumption
of unramifiedness of F/K. The independent restricted classes c_w
therefore remain independent.

Here is the action convention explicitly. For g lifting d in Delta,
the natural action on a Q_ell(1)-cocycle on H is

    (d.c)(h) = chi_K,ell(g) c(g^(-1) h g).

Let z be an original rho-cocycle, and identify its restriction to H
with c. The cocycle identity yields

    rho(g) z(g^(-1) h g) = z(h) + (rho(h)-1) z(g).

Since `rho(h)=chi_K,ell(h)` and `rho(g)=epsilon(d)chi_K,ell(g)`,

    (d.c)(h)
      = epsilon(d)^(-1)c(h)
        + (chi_K,ell(h)-1)epsilon(d)^(-1)z(g).                       (3)

The last term is a coboundary on H. Thus `[d.c]=epsilon(d)^(-1)[c]`.
This proves `L_TWIST_INJECT`; the orientation is the inverse even
when the twist is nonquadratic. No full cyclotomic compatibility
has been slipped in.

## 3. Ramification, including ramified twist extensions

Use the cocycles inherited from pullback and restriction. Suppose
c_w ramifies at `u` of F above `v` of K, where `u` is away from ell.
On I_u the Tate module is trivial, so its restriction is a
nonzero continuous homomorphism to the additive Q_ell. Its compact
image is pro-ell. The image of a pro-ell Sylow subgroup J_u of I_u
surjects onto that image (finite Sylow theory followed by inverse
limits), hence the homomorphism is nonzero on J_u.

Choose a pro-ell Sylow J_v of I_v containing J_u. In fact
`[I_v:I_u]` divides `[F:K]`, which divides `ell-1`, so every
pro-ell subgroup of I_v already lies in I_u. This explains explicitly
why ramification of the *twist extension* causes no problem.
Nonzero Kummer evaluation on J_u implies `f(J_v) != 1`, since the
pulled-back cocycle vanishes on the kernel of f.

The prime v is active. Uchida's odd-prime case (ii) supplies a prime
`t` of B away from ell with `f(J_v) subset I_t`. The finite target
prime t is not missed, so `t != w`. The original kappa_w is
unramified at t. Since I_t acts trivially on Q_ell(1), saying its
restriction class is zero says that the cocycle itself is zero on
I_t, not merely cohomologous to zero there. Its pullback is
therefore zero on J_u, a contradiction.

This proves `L_RAMIFICATION` at every finite u away from ell. There
was no assertion that F/K itself is unramified away from ell, or
that all of I_v maps into target inertia.

## 4. Exact character multiplicity and the uniform bound

Let S contain the infinite places of F and all its primes above ell.
Section 1 places the independent c_w in
`(U_S tensor Q_ell)^(epsilon^(-1))`.
Bass's lemma gives, as semisimple representations,

    [U_S tensor Q_ell] = [Q_ell[S]] - [Q_ell].                       (4)

It uses the ordinary archimedean logarithmic lattice; it is not a
statement about the rank of the ell-adic unit-logarithm image.
No Leopoldt assumption occurs.

More generally, for any one-dimensional Q_ell-valued character theta
of Delta and an orbit with stabilizer D, its multiplicity in
`Q_ell[Delta/D]` is

    1 if theta restricted to D is trivial, and 0 otherwise.          (5)

For an elementary proof, on an orbit of length m let the cyclic
generator shift the basis e_j to e_(j+1), and put
`z=theta(generator)`. An eigenvector with coefficient a_0 has
coefficients `a_j=z^(-j)a_0`. The last equation is exactly
`(z^m-1)a_0=0`. Thus there is at most one free coefficient, and it
is free precisely when theta kills the stabilizer. This is a proof
for every m, not a check up to a maximum group order.

Equations (4)-(5) prove the exact formula

    dim (U_S tensor Q_ell)^theta
      = sum_(v in S/Delta) [theta restricted to D_v = 1] - [theta=1]. (6)

For the faithful character `theta=epsilon^(-1)`, a stabilizer is
killed exactly when it is trivial. Every complex place of K has
trivial stabilizer. A real place contributes only if it remains
real; a real place becoming complex has stabilizer of order two
and contributes zero. A finite prime above ell contributes only
when it splits completely, not merely when it is unramified.
Consequently (6) is the right side of (1). When the twist is
trivial this is `r1(K)+r2(K)+g_ell(K)-1`, so the augmentation
correction must not be dropped.

Put `d=[K:Q]`, `rs=r1_split`, `gs=g_ell_split`, `g=g_ell(K)`,
and `delta=[epsilon=1]`. We have `d=r1+2r2`, `rs<=r1`,
`gs<=g<=d`, and all counts are nonnegative. The exact identity

    2d - (rs+r2+gs-delta)
      = (d-r1-2r2) + (d-g) + (r1-rs) + (g-gs) + r2 + delta          (7)

is a nonnegative certificate for the required uniform bound.
It is independent of ell and `[F:K]`. Independence of the c_w
bounds every finite J by (6), and a set all of whose finite
subsets have size at most this integer has that size bound itself.
This proves (1) and the proposition.

The same proof works for a finite target `N subset Q^s`: replace
the final `+2` by the number of primes of N above ell. It even
works for an open map rather than a surjection. Restriction to its
open image is injective on characteristic-zero H1, by passing to
the finite-index normal core and the same averaging argument.
This is a routine scope extension, not a novelty claim.

## Exact replay: what is and is not checked

Run, from the campaign root:

    $WORKSPACE/argus-live-update/.venv/bin/python research/verify.py

`exact_certificate.json` supplies exact symbolic data for (3), the
finite-group averaging identity, the multiplication-by-ell transition
in (2), universal cycle/finite-sum recurrences, the formula (6), and
the nonnegative identity (7). The verifier derives the residual
identities rather than accepting theorem-status flags. Inductive
base and step identities concern arbitrary cycle lengths, not a
bounded list of primes or group orders.

Quadratic arithmetic fixtures additionally test a trivial twist,
real-to-complex places, splitting and nonsplitting above ell, and
a twist ramified at a prime different from ell. These are tests of
the unit formula, **not** arithmetic counterexamples to the
manuscript, nor evidence that a map beta with those particular
fixtures exists. Deliberately corrupted certificates must be rejected.

One bounded Jacobian operation checks the universal geometric-sum
induction step by exact matrix multiplication. Its operation,
protocol, server version, payload, output, and adapter status are
preserved under `jacobian/`. This is a supplementary algebraic
check, not an oracle for arithmetic validity. Failure or timeout
would be a non-conclusion.

The arithmetic reasoning in Sections 1-4 is a written proof using
the separately listed classical inputs. The program does not check
the global Galois hypotheses, the local-correspondence theorem, or
the S-unit theorem in a proof assistant. It must not be described as
a kernel verification of the full proposition. The Reviewer must
read those parts and independently replay the exact certificate.
