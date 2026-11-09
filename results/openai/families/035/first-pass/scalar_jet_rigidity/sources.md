# Primary inputs read for the jet argument

Retrieved on 2026-11-05. The Stacks Project pages below are primary,
public source statements; this note gives their actual tags rather than
unverified search-result theorem numbers. They are live, unversioned
pages, not an asserted immutable revision.

## Duality

https://stacks.math.columbia.edu/tag/0FVV, Lemma 48.27.1:

> Let X be a proper scheme over a field k. There exists a dualizing
> complex omega_X^bullet with the following properties.
>
> (5) For K in D_QCoh(O_X) there are functorial isomorphisms
> Ext_X^i(K, omega_X^bullet) = Hom_k(H^(-i)(X,K),k),
> compatible with shifts and distinguished triangles.
>
> (7) If X -> Spec(k) is smooth of relative dimension d, then
> omega_X^bullet is isomorphic to wedge^d Omega_(X/k)[d] and
> omega_X is isomorphic to wedge^d Omega_(X/k).

Also read https://stacks.math.columbia.edu/tag/0FVZ,
Lemma 48.27.5(4): for a proper, Cohen--Macaulay, equidimensional
scheme of dimension d over k, there are functorial isomorphisms
Ext_X^(d-i)(F,omega_X) = Hom_k(H^i(X,F),k).

Application: V is smooth projective of dimension three. The two-term
locally free presentation of P_j^s(E) computes its sheaf Ext:
only sheaf Ext^1 is nonzero and it is P_(s-j)^s(E^!).
Consequently H^2(P_j^s(E))^dual = H^0(P_(s-j)^s(E^!)).
Functoriality, not a claim that P_j^s(E) is locally free, determines
the endpoint projection. This is valid for nonreduced sD.

## Riemann--Roch

https://stacks.math.columbia.edu/tag/02UO, Section 42.66:

> Let E be a finite locally free sheaf on X. Let f:X -> Y be a proper
> smooth morphism. Assume that R^i f_* E are locally free sheaves on Y
> of finite rank. The Grothendieck--Riemann--Roch theorem says in this
> case that f_*(Todd(T_(X/Y)) ch(E)) = sum (-1)^i ch(R^i f_* E).
> If Y=Spec(k), where k is a field, this is
> chi(X,E) = deg(Todd(T_(X/k)) ch(E)).

The page states this theorem and explicitly defers its proof.
It is being used as a standard external theorem, not as a proof supplied
by this campaign.

https://stacks.math.columbia.edu/tag/02UN, Section 42.65, gives

    Todd(E) = 1 + c1/2 + (c1^2+c2)/12 + c1*c2/24 + higher terms.

For E=O(iD), use ch(E)=exp(iD) and c1(T_V)=-K_V. The degree-three
part is

    i^3 D^3/6 - i^2 K_V D^2/4
      + i (K_V^2+c2(V))D/12 - K_V*c2(V)/24.

Subtracting the value at i-1, and using D^2 A=0 and K_V^2 D=0,
gives chi(P_i^1)=D*c2(V)/12. The field has no characteristic
restriction in the quoted theorem; rational coefficients are in the
Chow calculation, not inversion of 12 inside k.

## Manuscript inputs and scope of retrieval

The staged September 24, 2026 source `build/sections/jets.tex` was read
in full. The exact upstream inputs are its opening paragraph, the
prepared-cycle Proposition in `preparation.tex`, and the
no-scalar-poles Corollary in `slopes.tex`. The October 5, 2026
`build/sections/foundations.tex`, Theorem `thm:obstruction`, explicitly
uses the companion's Sections 3--6 for the prepared-cycle obstruction.

The present result does not assume the truth of abundance, the
prepared-cycle construction, or the absence-of-poles proof: those are
outside its scope and remain open nodes in the project graph. It uses
the listed jet hypotheses as hypotheses.

The September source cites Totaro, arXiv:0712.2049v1, as motivation for
finite thickenings, and expressly not as an input to its rank argument.
No proposition from Totaro is used here. No prior independent
verification of this jet calculation was present in the initial ledger
or the project Wiki index. Novelty of the strengthened exact-tail
statement has not been established by a literature survey.
