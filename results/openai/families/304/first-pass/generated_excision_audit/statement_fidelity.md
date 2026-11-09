# Statement fidelity: the integral transfer core

Claim `C304_TRANSFER` is formalized by the declarations in namespace
`GeneratedExcision` in `Main.lean`. The objects are arbitrary abelian
groups, and all arrows are additive homomorphisms. No group is assumed
finite, finitely generated, divisible, or torsion-free. Natural-number
scalar multiplication is repeated addition, not multiplication in a
field. In particular the proof does not invert 2 or the integer `q`.

`BiTransfer f q` means that an additive map `backward` satisfies both
`f(backward(y)) = q*y` and `backward(f(x)) = q*x`, for every element.

`doubleTransfer` quantifies over four abelian groups, all six arrows
`f,g,iA,iB,dA,dB`, every natural number `q`, and a `BiTransfer f q`.
Its hypotheses are exactly

    g iA = iB f,    dB g = f dA,
    iA dA = 2 id,   iB dB = 2 id.

Its conclusion is a `BiTransfer g (2*q)` whose reverse map is
`iA backward dB`. The unused reverse identities `dA iA = 2 id`
and `dB iB = 2 id` are deliberately not hypotheses. They hold in the
intended dense-doubling application, but are unnecessary for this
algebraic implication.

`transfer_bounds` proves, for every `BiTransfer f q`, that `q` annihilates
the kernel and that every `q*y` is in the image. The latter is precisely
annihilation of the cokernel; no quotient object or extra surjectivity
hypothesis is silently inserted.

`DoublingTower` is an abstract sequence of such squares, with a
two-sided 1-transfer in degree zero. `transferAt` constructs, for every
natural number `j`, a two-sided `2^j`-transfer. `tower_bounds` proves the
kernel and cokernel assertions for all `j`, not just tested dimensions.

The geometric interpretation is conditional: after the natural relative
Witt-group identifications proved in `proof.md`, the reduced sphere
comparisons, with the Witt degree shifted at each step, form this tower.
The compiler does NOT construct these sheaf categories, verify Verdier
duality, prove cutoff or the germ equivalence, check Witt localization,
establish naturality of dense doubling, or prove Hilbert-Smith. Those
mathematical obligations are separately stated and argued in `proof.md`
and recorded in the ledger. A kernel certificate for `C304_TRANSFER`
must not be attached as a formal proof of `C304_LOCALIZATION` or
`C9000304`.
