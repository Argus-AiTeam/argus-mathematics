# Statement fidelity: nilpotent sections and the height-two Koszul map

The new source is `finiteness/Main.lean`, namespace `OrdinaryFiniteness`.
It does not replace or recompile either previously reviewed formal source.

`power_eq_of_equal_image` concerns arbitrary commutative characteristic-five
rings E,S and a ring homomorphism pi:E->S. It assumes one common exponent
5^r kills every element of ker(pi). Equal residue classes then have equal
5^r-th powers. No finite-dimensionality or flatness is assumed.

`liftedSection` constructs the manuscript's actual formula
sigma(z)=lift(root(z))^(5^r), given any set-theoretic lift and a ring
homomorphism root:S->S whose 5^r-th power is the identity on elements.
The root hypothesis is the inverse Frobenius supplied by perfectness;
it is not a freely chosen replacement geometric action.
The declaration proves all ring-homomorphism laws.
`liftedSection_splits` proves pi sigma=id.
`section_unique` proves equality of any two ring sections with these
hypotheses. `exists_unique_section` replaces the chosen lifts by
surjectivity of pi and proves existence and uniqueness.

Thus the canonical perfect-fiber section, its independence of lifts
and of a sufficiently large exponent, and its functorial uniqueness
have a universal algebraic proof. In the application the kernel is
v E_N with v^N=0, and a power 5^r>=N supplies the uniform nilpotence
hypothesis. Perfectness of the special fiber supplies root. An
exponent fixing the finite ground field makes the section k-linear.
Those identifications and the last k-linearity consequence are prose
arguments in `../finiteness.md`, not extra formal declarations.

`koszul_comparison` and `koszul_top_is_identity` prove the one-variable
resolution square with multipliers D^(q-s) in degree zero and 1 in
degree one, for every s<=q, in any commutative semiring.
`top_augmentation_unit` and `wrong_top_augmentation_zero` distinguish
its actual degree-one coefficient from the incorrect extra-D map.
`root_corestriction_on_trivial_row` proves that after augmentation,
an actual upward root comparison with s<q is zero in degree zero
and identity in degree one.

These are identities for the actual Koszul comparison. Lean does not
construct a Yoneda or derived category, and therefore does not itself
identify these identities with continuous translation Ext.
The finite free resolution and that identification are proved in prose.

In particular this source does not prove flatness of E_N over R_N,
the tensor-product Artin splitting, finiteness of ordinary coefficient
cohomology, geometric support comparison, group duality, the Honda
tame-character calculation, or the specified xi_i transport.
Claim C318FIN2ALG is only the universal algebra described above.
