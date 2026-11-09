# Statement fidelity: C_LATENT_ALIGNMENT_POLY

## Exact theorem

Let \(r\in\mathbb N\), let \(E\) be any finite type, and let
\(t:E\to(\operatorname{Fin}(r)\to\mathrm{Bool})\) be injective. Assume
each \(t_e\) has at least one true coordinate and \(|E|>3r\).
Write \(t_{ej}\) for its value in \(\{0,1\}\).
The three rows are numbered \(0,1,2\) in Lean (rather than \(1,2,3\)).
Set
\[
 R=\mathbb F_2[T_{ij}:i\in\operatorname{Fin}(3),j\in\operatorname{Fin}(r)],
 \qquad F=\operatorname{Frac}(R),
\]
\[
 L_i(e)=\sum_j T_{ij}t_{ej},\qquad
 z_i(e)=\sum_j T_{ij}^{\,2}t_{ej},\qquad
 M_{e,(i,j)}=t_{ej}z_i(e),\qquad c(e)=L_0(e)L_1(e)L_2(e).
\]
The source proves:

1. \(L_i(e)^2=z_i(e)\) and \(c(e)^2=z_0(e)z_1(e)z_2(e)\).
2. The actual vector \(c\) is **not** in the \(F\)-linear span of the
   \(3r\) actual columns of \(M\).
3. There exists \(P\in R\), \(P\ne0\), with total degree at most \(6r+3\),
   such that for every commutative ring \(S\) of characteristic two and
   every assignment \(T^*: \operatorname{Fin}(3)\times\operatorname{Fin}(r)\to S\),
   \[
   \bigl(\exists a_{ij}\in S:\ \forall e\in E,\ 
      \sum_{i,j}a_{ij}M_{e,(i,j)}(T^*)=c(e)(T^*)\bigr)
       \ \Longrightarrow\ P(T^*)=0.
   \]
   The same \(P\) works for every assignment and target ring in the theorem's
   universe; it is chosen before those quantifiers. The stronger ring-hom
   version covers every \(f:R\to S\) with specialized response in the
   specialized column span.
4. In any characteristic-two field, the specialized \(c(e)\) is the
   **unique** square root of the displayed product of specialized \(z_i(e)\).

Here \(x_{ij}=T_{ij}^2\) is the parameterization from the outset.
Total degree means degree in the \(T\)'s, not degree in the \(x\)'s.

## Main declarations

All declarations below are in namespace `LatentAlignment`:

- `column`, `weighted_pairs_quadratic`, `column_quadratic` implement the
  square-subfield-valued columns and prove their Boolean quadratic-span
  membership, with no quadratic-span hypothesis left to the caller.
- `matrixPolynomial`, `responsePolynomial`, `matrixPolynomial_map`,
  `response_eq_radicalCombination` implement the actual polynomials, identify
  the columns under scalar extension, and prove the cubic expansion, rather
  than assuming these identities.
- `linearPolynomial_sq`, `responsePolynomial_sq`,
  `specialized_response_unique_square_root` certify the square-root meaning.
- `actual_matrix_nonmembership` is the rational-function nonmembership theorem.
- `independent_has_minor` extracts a nonzero square minor from an independent
  family using Mathlib matrix rank, row rank, and determinant invertibility.
- `augmentedDet` is the determinant linear in its extra column;
  `map_augmentedDet` proves compatibility with arbitrary ring homomorphisms.
- `augmentedDet_degree` proves the finer bound \(hD+d\) for \(h\) ordinary
  columns of degree at most \(D\) and one response column of degree at most \(d\).
- `exists_alignment_polynomial` is the uniform ring-hom obstruction theorem.
- `specialize_matrix`, `specialize_response` identify evaluation at an actual
  assignment with the displayed matrix and cubic, explicitly.
- `exists_alignment_polynomial_specialization` proves assertion 3 with
  the coefficients \(a_{ij}\) and all actual polynomial entries spelled out.

## Load-bearing proof and imported prerequisites

The two prerequisite sources are imported without modification:

- `research/latent_separation/genericity/Main.lean` supplies
  `LatentGenericity.cubic_radical_not_in_small_quadratic_column_span`.
- `research/latent_separation/radicals/Main.lean` supplies the actual field
  `LatentRadicals.RootField`, its actual-square subfield
  `LatentRadicals.squareSubfield`, and
  `LatentRadicals.triple_linearIndependent r`.

The scalar field in coefficient extraction is precisely the subfield of
actual squares in \(F\). Its identification with a separately presented
\(\mathbb F_2(x)\) is neither assumed nor required. The radical independence
hypothesis of the genericity theorem is discharged by
`triple_linearIndependent r`, not passed as an assumption of our theorem.

The polynomial construction chooses \(h\le3r\) columns forming a basis of
the generic column span. Adding \(c\) gives an independent family, so
`independent_has_minor` produces a nonzero augmented determinant \(P\).
Each determinant term contains \(h\) entries of degree at most two and
one of degree at most three. Hence
\(\deg P\le2h+3\le6r+3\).

For every original column, replacing the response by that column gives
an identically zero polynomial determinant: its image in \(F\) vanishes,
and \(R\hookrightarrow F\) is injective. These polynomial identities survive
every specialization. The specialized determinant functional therefore
annihilates the span of **all** specialized original columns. This proves
vanishing whenever the response is aligned. There is no assumption that
the chosen generic basis remains a basis after specialization, no division
by a possibly vanishing specialized minor, and no rank-squaring step.

The construction and proof are uniform in \(r\) and \(E\); no fixed-\(r\)
enumeration or finite test is used. Choice of a basis and a minor is
classical/existential; the theorem does not print polynomial coefficients
for an unspecified \(E\).

## Residual hypotheses and compiler boundary

The only geometric/combinatorial hypotheses are finite \(E\), injectivity
of \(t\), a nonzero coordinate in every point, and \(|E|>3r\).
Target specialization requires only a commutative characteristic-two ring;
uniqueness of the square root additionally requires a field.
No radical independence, generic rank, nonmembership, or existence of a
nonzero polynomial is assumed by the final theorems.

"Alignment" in the compiled theorem means exactly the displayed existence
of coefficients \(a_{ij}\). The code does not define the manuscript's
geometric extension maps: applying a manuscript reduction from such maps
to this linear system is outside compiler scope.

Also outside compiler scope are bijectivity of Frobenius on a finite field
as a **sampling/distribution** argument, the passage from uniform \(T\) to
uniform \(x=T^2\), finite-field polynomial root counting, probability bounds,
and any union bound over point sets. None is claimed as compiler-verified
evidence here. In particular, the theorem does not assert that a nonzero
polynomial is a nonzero function on every small finite field.

Only standard Lean axioms (`propext`, `Classical.choice`, `Quot.sound`) are
used by the main declarations. No independent Reviewer acceptance or
literature novelty is asserted.

## Reproducibility

`build.py imports` recompiles each exact prerequisite source with
`lean --root=<campaign root> -o <alignment>/imports/<source path>.olean`.
It prepends this owned imports directory to Mathlib's installed `LEAN_PATH`.
`imports/manifest.json` records the full commands and SHA-256 hashes of
both source files and their output `.olean` files.

`build.py check` compiles this `Main.lean` with the same environment.
`verify.py` rebuilds the imports, invokes the official Lean evidence verifier
using the authorized Python interpreter, and runs both project-local
structural checks after its ledger write. Optional `--revise-claim` first
binds the exact source to the registered claim using the official locked
CLI and runs both structural checks after that mutation too.
Source and fidelity hashes are checked for immutability during verification.
`exact_certificate.json` records the official receipt and both check statuses.
