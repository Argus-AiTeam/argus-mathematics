# Stabilization counterexample certificate

## Witness

Let

```text
Y = E(2),                         F = a regular elliptic fiber in Y,
Z = S^2 x S^2,                   X = Y # Z,
K1 = T(2,3),                     K2 = T(2,5).
```

Choose the connected-sum balls defining X inside `Y \ nu(F)` and Z.
The torus in the fixed pair `(X,F)` is the copy of F in the Y summand.
All connected sums and diffeomorphisms below are oriented.

## 1. The fixed pair satisfies the ambient hypotheses

The standard elliptic surface E(2) is the simply connected K3 surface.
A regular fiber F is a smoothly embedded torus with product
neighborhood `F x D^2`, so `F.F=0`.

For completeness, the complement group can be computed directly.
Deleting a regular fiber turns the elliptic Lefschetz fibration into a
fibration over a disk.  E(2) has a section, and its monodromy
factorization is

```text
(alpha beta)^12,
```

where the vanishing cycles alpha and beta are parallel to the standard
generators a and b of the fiber.  The section removes any base-loop
generator, and the two corresponding Lefschetz thimbles normally kill
a and b.  Hence

```text
pi_1(Y \ int(nu(F)))
  = <a,b | [a,b]=1> / <<a,b>>
  = 1.
```

Now form the connected sum away from F.  Van Kampen gives

```text
pi_1(X) = pi_1(Y) * pi_1(Z) = 1,
pi_1(X \ int(nu(F)))
  = pi_1(Y \ int(nu(F))) * pi_1(Z)
  = 1.
```

The punctured tubular neighborhood retracts radially to its boundary,
so `X-F` and `X \ int(nu(F))` have the same fundamental group.  The
connected sum changes neither the embedding nor the normal framing of
F.  Thus X is closed, simply connected, and smooth, while F is
square-zero and has simply connected complement.

## 2. The knot pair meets the exact prime and non-mirror condition

Both pairs `(2,3)` and `(2,5)` are coprime, so they define nontrivial
torus knots.  Schultens' torus-knot theorem gives

```text
b(K1) = b(K2) = 2.
```

If either knot decomposed as `J#L` with J and L nontrivial, bridge
additivity and the fact that every nontrivial knot has bridge number at
least two would give

```text
b(J#L) = b(J)+b(L)-1 >= 3,
```

a contradiction.  Thus K1 and K2 are prime.

Their symmetrically normalized Alexander polynomials are obtained from
the torus-knot formula:

```text
Delta_K1(t) = t - 1 + t^(-1),
Delta_K2(t) = t^2 - t + 1 - t^(-1) + t^(-2).
```

Their breadths are respectively 2 and 4.  Alexander breadth is
preserved by knot equivalence and by mirroring
`Delta_mirror(K)(t)=Delta_K(t^(-1))`.  Therefore K1 is neither K2 nor
the mirror of K2.  The exact polynomial calculation is replayed by
`verify_certificate.py`; the bounded Jacobian transcript independently
reconstructs the two distinct polynomial factors.

## 3. Fixed knot-surgery convention

Put `E_K=S^3 \ int(nu(K))`.  On the boundary of `nu(F)=F x D^2`, use
the ordered curves `(a,b,mu_F)`.  On `S^1 x boundary(E_K)`, use s for
the first factor and `(mu_K,lambda_K)` for the meridian and preferred
longitude.  We use the Fintushel--Stern zero-surgery convention

```text
Y_K = (Y \ int(nu(F))) union_phi_K (S^1 x E_K),
```

where the orientation-reversing boundary identification is fixed by

```text
phi_K(s)=a,  phi_K(mu_K)=b,  phi_K(lambda_K)=-mu_F.
```

This is the `M_K x S^1` presentation in Fintushel--Stern, pp. 3--4,
written after deleting the core torus of the zero-surgery solid torus.
It is also Baykur's equivalent presentation in Remark 2.  The locality
argument below works for this fixed map without changing any boundary
coordinate.

## 4. Knot surgery commutes with the disjoint connected sum

Let B be the ball removed from `Y \ int(nu(F))` and let B' be the ball
removed from Z.  The knot-surgery replacement is disjoint from the
connected-sum neck.  Merely regrouping the same four glued pieces gives

```text
X_K
 = (((Y \ int(B)) \ int(nu(F))) union_phi_K (S^1 x E_K))
     union_boundary(B) (Z \ int(B'))
 = ((Y \ int(nu(F))) union_phi_K (S^1 x E_K)) # Z
 = Y_K # Z.
```

The equality is realized by the identity on every displayed piece and
the collars used to associate the gluings.  Denote this
orientation-preserving locality diffeomorphism by

```text
lambda_K : X_K -> Y_K # Z.
```

No invariant comparison is used here; this is an actual diffeomorphism
of the cut-and-paste constructions.

## 5. Baykur stabilization and the explicit composition

The pair `(Y,F)` satisfies every hypothesis of Baykur's Theorem 1.
For each `i in {1,2}`, apply that theorem to obtain an
orientation-preserving diffeomorphism

```text
beta_i : Y_Ki # Z -> Y # Z = X.
```

Set `d_i=beta_i o lambda_Ki`.  Then `d_i:X_Ki -> X`, and therefore

```text
Phi
 = d_2^(-1) o d_1
 = lambda_K2^(-1) o beta_2^(-1) o beta_1 o lambda_K1
 : X_K1 -> X_K2
```

is the required orientation-preserving diffeomorphism.  Every domain
and codomain in this composition is checked in the structured
certificate.

Thus the literal general statement in K3 Problem 4.8 and
`OBJECTIVE.md` has the exact fixed-pair counterexample

```text
(X,F)=(E(2)#(S^2 x S^2), regular elliptic fiber),
(K1,K2)=(T(2,3),T(2,5)).
```

The construction uses a reducible ambient manifold and makes no claim
about the separate case `X=E(2)` itself.

## Replay

From the campaign directory run:

```text
/home/argustest/zimo/argus-latest/.venv/bin/python \
  research/stabilization-counterexample/verify_certificate.py
```

The replay checks the witness data, the source transcriptions needed by
the theorem applications, exact knot-polynomial arithmetic, the
Jacobian typed output, and all domains in the displayed composition.
It does not replace independent reading of the cited topology
theorems.
