# Denominator-profile corollary: Section 7

**Engineer assessment: supported as the two stated norm/support
inequalities.** This is a genuine strengthening of the identified
manuscript bounds, conditional on exactly the local data that the preceding
unit proves. It is not a verification of the full denominator-profile
expansion or any downstream equidistribution argument. Global optimality
and publication originality are not established.

## Source, attribution and exact hypotheses

The source is the unchanged old `research/quartic_shell/theorem.md`,
Section 7, corresponding to `QS_PROFILE@1` and the extra component of
`QS_CERT@2` absent from `QS_CERT@1`. Its preserved-manifest identity is in
the index. This is not a separate proof of every assertion mapped by
`MAP_QUARTIC_PROFILES@1`.

The comparison is OpenAI's same manifest-identified quartic manuscript,
revision `4eaee87548250b2682affda7d05d947c05554bae`,
`build/manuscript/additive.tex`, `lem:add-profile-bounds`,
`eq:add-profile-norm` and `eq:add-profile-support`, particularly the proof
at lines 157-207 and the displayed estimate

```
product_(g_p>0 or p<=5) p^(12(g_p+1)) <= 30^12 G_0^24.
```

Let `F` be a **cubic number field**, with absolute discriminant `D_F`
and different `d_F`; set `E_p=F tensor Q_p`. The identification of the
local algebras with these completions is necessary to evaluate the local
kernels on a global element. Let `S` be a finite set of rational primes,
with the exact local hypotheses and self-dual trace measures of the
local-shell report. Local denominator ideals define a global integral ideal
`h` supported over `S`, with `H=Norm(h)`. Define

```
G_exp = product_(p in S) p^(c_p),
G_0   = product_(p in S) p^(g_p),             G_exp <= G_0.
```

The element `z in F` must be **nonzero**, integral outside `S`, with
`product_(p in S) K_(p,h_p)(z) != 0`. Its absolute field norm is bounded
by `M`. With the Section 7 boundary convention, `T_boundary` is the
product of the norms of the actual boundary primes at all odd `p` with
`c_p=0`. Boundary primes have positive denominator depth and lie in the
one-step outer annulus defined in the local-shell report.

The conclusions are

```
H <= 2^12 M D_F G_exp^3 T_boundary,
Norm(a_h)^(-1) <= 2^12 D_F G_exp^3,
```

where a single fractional ideal `a_h`, independent of `z`, contains all
the supporting elements. The first inequality also holds with
`M=|Norm(z)|`. If the manuscript's boundary convention is kept unchanged,
using only `g_p=0,p>5`, both constants can instead be
`2^12 * 3^3 * 5^3 = 13,824,000`.

The theorem does not assume that `S` contains all ramified primes of `F`;
the use of the full inverse different only enlarges the support outside
`S`. In the manuscript application the prescribed set `S` has further
properties, but those are not needed for this isolated corollary.

## Decisive ideal-norm argument

At odd `p,c_p>0` the support is `p^(-c_p)h_p d_p^(-1)`.
At odd `p,c_p=0`, its local ideal description is
`h_p d_p^(-1) product_boundary q^(-1)`.
At 2 the support is `2^(-N_2)h_2 d_2^(-1)`,
`N_2=max(c_2+3,4)`. Consequently a supporting `z` belongs to

```
b_(h,z) = h d_F^(-1)
          product_(odd p,c_p>0) (p R_F)^(-c_p)
          (2 R_F)^(-N_2)
          product_(odd boundary q) q^(-1).
```

The dyadic factor is omitted when `2 notin S`. Outside `S`, integrality
of `z` implies membership in `d_F^(-1)` even if that different is
nontrivial. Thus this is a valid global fractional ideal containment.
It gives

```
Norm(b_(h,z)) =
 H / (D_F T_boundary 2^(3 N_2) product_(odd p,c_p>0) p^(3 c_p)).
```

The dyadic denominator is again omitted when absent. The factors 3 in
these scalar ideal norms come from `[F:Q]=3`, not from a ramification
assumption: `Norm(p R_F)=p^3`.

Since `z!=0`, `(z)` is a full sublattice of `b_(h,z)`. Its positive
integer index satisfies

```
|Norm(z)| = Norm(b_(h,z)) [b_(h,z):(z)] >= Norm(b_(h,z)).
```

This step would not be available for `z=0`; it cannot be replaced by a
claim about an arbitrary element of a product algebra with zero components.
The simple inequality `N_2<=c_2+4` yields
`2^(3N_2)<=2^12 2^(3c_2)`. Rearranging proves the first conclusion.
No finite search bound is used.

For the common support ideal, group the boundary exponents **before**
dropping the denominator ideal: each is `h_nu-1>=0`, since a boundary
requires `h_nu>0`. All other exponents at odd `c_p=0` are also
nonnegative. They can all be dropped together. At odd `c_p>0` and at 2,
dropping `h_p` enlarges support. One can therefore take

```
a_h = d_F^(-1)
      product_(odd p,c_p>0) (p R_F)^(-c_p)
      (2 R_F)^(-N_2).
```

It is independent of the actual boundary set and of `z`. Taking its
norm gives the second conclusion. In particular one must not first discard
all `h` while leaving arbitrary boundary factors `q^(-1)` behind; that
would lose the reason those factors cause no extra denominator in `a_h`.
The draft's intended grouped-exponent argument is valid.

## Exact comparison with the manuscript

The manuscript's boundary set uses `g_p=0,p>5`. Since `c_p=0` if and
only if `g_p=0`, the only differences in the boundary product are at 3
and 5. At each of these with `c_p=0`, the componentwise one-step support
is contained in `p^(-1)h_p d_p^(-1)`. Its scalar ideal norm costs at
most `p^3`. This accounts for precisely the extra factor `3^3 5^3`,
not a change of boundary definitions concealed in a comparison.

Thus, with the original boundary product, the two manuscript inequalities
can use `13,824,000 D_F G_exp^3` in place of
`30^12 D_F G_0^24`, with the norm bound also carrying `M T_boundary`.
Replacing `G_exp` by the larger `G_0` proves the claimed exponent
improvement **24 to 3** under the manuscript's original convention.
For a fixed real region, `M` is bounded by the supremum of the absolute
field norm there, exactly the dependence allowed in the original norm
estimate. The source's trace condition excludes zero; Section 7 explicitly
replaces that interface by `z!=0`.

The original lemma also asserts index comparisons, a finite pointwise
density expansion, cutoff `H<=X^371`, and a subpower profile count.
Section 7 does not independently prove these, nor recompute the
subsequent nonscalar, sieve or equidistribution exponents. Improving the two
inequalities does not by itself certify that larger package.

## Replay, assumptions and unresolved scope

The unchanged checker passed in the shared replay recorded in
`../local-shell/verdict.json`, using Python 3.13.5 and standard-library
exact arithmetic. Its `profile_improvement` JSON records the exponents and
constants, but is descriptive metadata, **not** an independent global
profile computation or proof. No global numerical experiment was substituted
for the ideal argument. The local finite tests have the limits described
in the local-shell assessment.

The mathematical dependency is the proved local support theorem, not an
external quoted result. The remaining norm/index statements are the
defining lattice-index identities for fractional ideals, applied explicitly
above. No unread Weil or ELMV theorem is used. There is no Lean source or
kernel evidence. Local sharpness alone does not establish that exponent 3
is globally optimal for elements and data realizable from the packet problem.

Relative to the old local-only `QS_CERT@1`, Section 7 is the genuine extra
result incorporated in `QS_CERT@2`; this review adds no further exponent
improvement. No mathematical gap was found in the corollary as precisely
stated. Novelty and the native family-wide independent verdict remain open.
