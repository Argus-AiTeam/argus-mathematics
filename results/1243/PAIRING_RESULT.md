# Cassels--Tate pairing for residual classes 936 and 1304

**Status: exact nonzero pairing, pending independent Reviewer replay.**

The order-012 norm equation now has an explicit global preimage. PARI 2.17.4
returned concrete degree-18 `t_POLMOD` coefficients \(C,D\) with residual
factor \(1\). A fresh process then verified

\[
C^2-yD^2=b
\]

exactly, replayed every archived branch-483 reduction and field map, and
verified the original order-012 norm identity. The positive-witness BNF used to
find \(C,D\) does not need to certify a class group: the final identity is
checked independently. The source and transport certificates are

- `full-hi-isotropy/relative-class-unit-solve-v2/branch483_cached_rnfisnorm_solution_nofilter-c1-015.gp`;
- `full-hi-isotropy/relative-class-unit-solve-v2/branch483_order012_transport_from_cached.json`.

The transported norm point gives an exact nonzero point on the Cassels conic.
Its \(T\)-coordinate is nonzero and was normalized to \(T=1\). Exact replay
reconstructs the audited \(H_i\), verifies \(H_i=0\), proves that the gradient
is nonzero, and verifies that the displayed tangent contains the point:

- `full-hi-isotropy/relative-class-unit-solve-v2/order012_conic_point_from_cached.json`;
- `full-hi-isotropy/relative-class-unit-solve-v2/order012_tangent_from_cached.json`.

Using the independently prepared local cover points for the ordered classes
\((2759,936)\), all six required finite places were replayed. Every local
precision and square-class stability threshold passes, omitted finite places
are covered by the audited support criterion, and all infinite contributions
are trivial. The product of the local Hilbert symbols is \(-1\), so

\[
\langle 2759,936\rangle_{\mathrm{CT}}=\frac12.
\]

Here \(2759=1304+4063\) in the recorded \(\mathbf F_2\)-Selmer coordinates,
and 4063 is the exact Kummer class of the known Mordell--Weil point \(Q\).
The Mordell--Weil image is in the radical of the Cassels--Tate pairing.
Therefore, using bilinearity and the fact that reversing arguments does not
change a pairing valued in \(\{0,\tfrac12\}\),

\[
\boxed{\langle 936,1304\rangle_{\mathrm{CT}}=\frac12}.
\]

The exact local table, support check, product formula, and final value are in
`full-hi-isotropy/relative-class-unit-solve-v2/order012_pairing_from_cached.json`.
This makes the residual two-dimensional pairing nondegenerate. Conditional on
the separately pending proof that the displayed three-dimensional local
intersection is the complete global \(2\)-Selmer group, it forces
\(E(K)=\mathbf ZQ\), after which the reviewed \(p=23\) certificate classifies
\(C_1(\mathbf Q)\). That global \(2\)-Selmer completeness certificate is not
supplied here, so no unconditional rank-one conclusion and no magic-square
counterexample are claimed in this mission.
