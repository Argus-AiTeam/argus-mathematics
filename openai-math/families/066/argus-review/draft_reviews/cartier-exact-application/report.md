# Application to the rational common-slice minimizer

**Assessment:** `C_CART_EXACT` v1 is supported as the rational
exact-realization assertion it actually names. It is a proper part
of `thm:E-exact-minimizer`, not a verification of that entire theorem
or the uniform Cartier-section theorem.

## Exact statement and source alignment

The source is Cartier `E-lc-slices.tex:576-609`, revision
`4eaee87548250b2682affda7d05d947c05554bae`, section SHA-256
`09569a08e0ca3f93ee4ee96cd06878005545a40d7600c30ae59645061f7387ea`.
The old application is `verification.md:436-460`.

Fix a normal complex positive-dimensional Q-Gorenstein klt germ,
nonzero `h` with `(X,div(h))` lc, nonzero `F_j`, and positive integers
`m_j`. The normalized common slice consists of nontrivial
quasi-monomial valuations over the germ with

```
A_X(v)=v(h)=1,    v(F_j)>=m_j,
```

and contains a centred valuation. “Over the germ” includes
noncentred generizations. An allowed height is

```
b(v)=b0*v(h)-sum b_l*v(G_l),   b_l>=0,   G_l!=0,
b>0 on the entire normalized common slice.
```

For **rational coefficients** the old claim is that a fixed effective
rational lc Cartier boundary encodes exactly the common rays and one
small positive rational `lambda`, independent of every competitor,
produces an effective rational klt pair whose actual normalized-volume
minimizer is the unique constrained height minimizer.

This is a reproduction of the rational part of the manuscript
theorem. The manuscript also asserts real-height uniqueness and
continuity and a collection of central-slice/degeneration properties.
Those are not included in the old claim being assessed.

## Decisive application

The encoding unit checks the boundary

```
Psi=(1-sum theta_j)*div(h)
       +sum (theta_j/m_j)*div(h^m_j+a_j*F_j)
```

for rational positive `theta_j` of sum below one and sufficiently
general pencil members. Its zero cone is exactly the common slice
cone, not a larger collection of lc places.

Write the height in the bridge's equation-linear form, using
`alpha=0`, coefficient `b0` for `h`, and coefficients `-b_l` for
`G_l`. The bridge boundary becomes precisely

```
Psi_lambda=Psi-lambda*b0*div(h)
                    +lambda*sum b_l*div(G_l).
```

The initial `div(h)` coefficient is positive; choosing
`lambda*b0<1-sum theta_j` preserves effectivity. Added `G_l`
coefficients are nonnegative. The normalized zero cone is the
entire common slice, so the manuscript's height positivity
includes the noncentred faces required by the bridge.

The bridge gives one threshold independent of competitors and
functions, and works for every smaller rational parameter. Its
actual ordinary minimizer lies on the cone. There its discrepancy
is `lambda*b`, so constrained and ordinary minimizers coincide.
Ordinary uniqueness supplies the unique constrained ray without
needing to invoke the manuscript's preceding convex-domination
or strict-gap arguments. Thus the rational realization is not
deduced merely from convergence or from an assumed constrained
minimum.

The resulting actual effective rational klt minimizer also meets
the ordinary finite-generation input. That does not, by itself,
verify the theorem's claims that the central `h`-boundary is lc,
the central height is positive, or the grading minimizes the
central constrained problem. Those require additional transfer
arguments.

## Evidence, novelty and concrete boundary

The exact claim hash is
`ccdae4246afc70267ec0d63f43dc15d1f301ed0c58a0a55a779576936df14df8`.
Prior support `judgement-C_CART_EXACT-b2a8ed0f6efa` by
`reviewer:dccb8f343ba8` reads the unchanged proof note and is
applicable to this rational claim. The old graph's open node
does not erase that evidence; neither is current acceptance.

External inputs and real toolchain limitations are those of the
bridge and ordinary-input units. There is no geometric Lean
encoding of this theorem. The arithmetic replay does not test
the pencil construction or central geometry.

No missing step was found in the named rational realization.
Real-height continuity, normality and detailed discrepancy
transfer on the central slice, the later character/pinning
obstruction, and the final reduction to uniform Cartier sections
are unreviewed obligations of the old audit. This bounded review
does not open new research to settle them or claim them false.
Reproducing the source's rational statement establishes no new
novelty.
