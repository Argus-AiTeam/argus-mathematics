# Sharpness construction: Theorem C

**Engineer assessment: supported.** The construction realizes every stated
hypothesis and yields the claimed positive kernel value at unbounded
parameters. It proves sharpness of the odd-prime local support exponent,
not a counterexample to the manuscript, not optimal dyadic constants, and
not global or publication-level novelty.

## Source, versions and exact claim

The source is the unchanged old `research/quartic_shell/theorem.md`,
Sections 1 and 6, Theorem C; its preserved-manifest identity is in the index.
The earlier `QS_SHARPNESS@1` uses third output coordinate zero.
`QS_SHARPNESS@2` strengthens this to every `epsilon in Z_p`, so that
`epsilon=1` gives an output with all components nonzero. The current proof
establishes both versions, not two independent results.

For **every prime** `p`, every `k>=1`, and every `c>=2`, put `m=k+c`.
The claim is the existence of the Section 1 quadratic data with

```
E = Q_p^3,
C = {(a1,a2,a3) in Z_p^3 : a1-a2 in p^m Z_p},
h = (p^k Z_p, p^k Z_p, Z_p),       g=c,
K_h(p^(k-c), -p^(k-c), epsilon) = (1-p^(-1))^2 p^(-c) > 0
                                                     (epsilon in Z_p).
```

All pairings and measures are the Section 1 self-dual ones. For this split
algebra the different is trivial and `vol(Z_p^3)=1`. The construction
satisfies even the manuscript's stronger signed split scalar form, although
the local shell theorem does not require that form.

## Construction and hypotheses checked

Let

```
T = [[1,0,0], [1,p^m,0], [0,0,1]],
M = T Z_p^3 = {(x1,x2,x3) in Z_p^3 : x1-x2 in p^m Z_p},
M^* = T^(-transpose) Z_p^3,
W = E + E,            L = M + M^*,
B((x,y),(x',y')) = x dot y' + x' dot y.
```

The action is componentwise multiplication on both copies of `E`.
It is faithful, unital and self-adjoint for the nondegenerate symmetric
form `B`; `W` has rank two over `E`. In coordinates `x=T a`,
`y=T^(-transpose)b`, the lattice form is the standard hyperbolic form,
`Q_1=a dot b`. Thus `L` is self-dual and `Q_1` is integral even at 2.
Changing the sign of the second pair gives the manuscript expression
`a1 b1-a2 b2+a3 b3` by an integral unit change of coordinates.

The set `M` is a ring containing `(1,1,1)`. A multiplier preserving `M`
belongs to `M`, by applying it to 1; conversely a member of this ring
preserves `M`. The dot pairing is self-adjoint for multiplication, so
preservation of `M` is equivalent to preservation of its dual. Consequently
the stabilizer of the **constructed** `L` is exactly the displayed `C`.
This verifies the actual-order requirement rather than postulating it.

Inside `h`, the only congruence for membership in `C` is
`a1-a2=0 mod p^c` after removing the common factor `p^k`.
The quotient is cyclic of order and exponent `p^c`. Hence `g=c`,
and its exponent parameter is also exactly `c`.

## Exact kernel evaluation

On the shell write `A=(p^(-k)a,p^(-k)b,A3)` with `a,b` units and
`A3` integral. The multiplication matrix on `M` is

```
[[p^(-k)a,                 0,       0],
 [p^(-m-k)(b-a),  p^(-k)b,       0],
 [0,                         0,      A3]].
```

Put `w=v_p(a-b)`, including `w=infinity`, and `d=max(0,m-w)`.
The least valuation of an entry in the first block is `-k-d`, while its
determinant has valuation `-2k`; its Smith exponents are therefore
`-k-d,-k+d`. Integration in the dual hyperbolic variable is exactly
the indicator that this matrix sends the first lattice variable into
`Z_p^3`. Its mass is

```
gamma(A) = p^(-2k) F_c(a-b),
F_c(t) = p^(-max(0,c-v_p(t))),       F_c(0)=1.
```

This calculation works at 2 and is independent of the unit being averaged.
The third coordinate contributes 1. In the inverse transform, the
`p^(2k)` frequency Jacobian cancels `p^(-2k)`. At the specified output
the remaining integral is

```
integral_(a,b in Z_p^times) F_c(a-b) psi(-(a-b)/p^c) da db.
```

For a fixed difference `t`, the permitted `b` have mass `1-1/p` if
`p|t` and `1-2/p` otherwise. On each valuation shell `r<c-1` the
additive-character integral vanishes. It is `-p^(-c)` at `r=c-1`,
and `p^(-c)` on `p^c Z_p`. Since **c>=2**, both surviving terms have
difference mass `1-1/p`. Their `F_c` values are `p^(-1)` and 1.
The answer is therefore

```
(1-1/p) (-p^(-1)p^(-c)+p^(-c)) = (1-1/p)^2 p^(-c).
```

The integral over `A3 in Z_p` is one for every integral `epsilon`.
No step takes a finite parameter cutoff or a limit of computer experiments.
The constraints `k>=1` and `c>=2` are retained; in particular the last
two-shell argument is not silently extended to `c=1`.

## What sharpness means

The first output valuation is `k-c`, less than the required `k-c+1`
in `p^(-(c-1))h`. Since the kernel is nonzero there, that smaller support
cannot contain it. For every odd prime this proves that the exponent `c`
in Theorem B cannot be reduced, even on outputs with all components nonzero.
The construction also exists at 2, but it does not close the gap between
the lower obstruction `c` and the proved upper exponent `max(c+3,4)`.

This is not a flaw in the manuscript: its support exponent `4(g+1)` is
larger, with `g=c`. Nor does this local split example establish optimality
of a global cubic norm exponent or arise automatically from a global
quartic packet. There is no such global realization claim in the proof.

## Replay, attribution and outstanding review

The single default replay shared with the local-shell unit passed:
seven exact finite Fourier sums and 48 family instances, the latter with
`p=2,3,5,7`, `k=1,2,7`, `c=2,3,12,25`. The script proves its
finite identities with rational arithmetic and exact cyclotomic
remainders, not floating-point agreement. Some family instances evaluate
the displayed formula and Smith data rather than enumerating all
`p^(2c)` pairs; these must not be called exhaustive large finite Fourier
sums. The seven separately listed Fourier tests actually enumerate their
unit pairs. Neither collection establishes the universal quantifiers;
the valuation-shell proof does.

Command, durable receipt, stdout and Python 3.13.5 toolchain are recorded in
`../local-shell/verdict.json`; the checker and certificate were not modified.
There is no Lean source, compiler result or imported external theorem.
The normalized measures, elementary additive orthogonality and actual
stabilizer verification are part of the argument, not untested geometric
assumptions.

Relative to the strongest prior version this review claims no new
construction. The old v2 improvement over v1 is precisely the arbitrary
integral third coordinate, removing the zero-component limitation without
changing the value. No decisive mathematical gap was found. Originality
and native independent acceptance remain unverified.
