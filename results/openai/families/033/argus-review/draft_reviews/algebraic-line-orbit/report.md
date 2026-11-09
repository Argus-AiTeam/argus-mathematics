# Algebraicity, restricted monodromy, and orbit filling

**Assessment:** the recorded orbit-filling argument supports its stated
algebraic, Hodge-generic scope under the explicitly identified external
inputs. It does not justify replacing an algebraic line by an arbitrary
local analytic one or identifying a single-vector kernel with a
whole-highest-space kernel without further work.

## Statement, source, and historical versions

`C_LINE_ORBIT` versions 1-5 all have the same mathematical statement.
Versions 2-5 successively add Andre normality, Schmid fixed part,
regular-singular algebraicity, and tensor-stabilizer inputs.

In the full marked-data setting, take a constant-rank local fiber \(T\)
of the **projective flat-coordinate map of an algebraic line**, through
a Hodge-generic point, and let \(Z\) be its irreducible algebraic closure.
After a finite level on a smooth open of \(Z\), its connected restricted
monodromy is a rational normal factor \(H\) of the ambient semisimple
adjoint group \(G=H\times Q\). The whole rational Lie \(Q\)-period is
constant there. At suitable smooth points of \(T\),
\[
 \dim Z-\dim T=\dim(H_{\mathbb C}\ell),\qquad
 d\ell(T_zZ)=T_{\ell(z)}(H_{\mathbb C}\ell(z)).
\]
The statement is about suitable points, not every point of the variation
locus. It retains the dominant connected-generic-fiber pullbacks and
connected finite levels specified in the strongest tail theorem.

The proof is the old Argus report, Sections 3-4, building on
`lem:connection-dimension` and the line case of `lem:orbit-rank` in
OpenAI's September 26, 2026 reverse-logarithmic manuscript,
`build/sections/boundary-rank.tex`, at manifest revision
`4eaee87548250b2682affda7d05d947c05554bae`. Its connection argument is a
reconstruction, not a newly established original Ax--Schanuel theorem.
The manuscript attributes the framework to Blazquez-Sanz, Casale,
Freitag and Nagloo, *A differential approach to Ax--Schanuel, I*,
`arxiv:2102.03384v5`, Theorem A, Theorem 3.6, Remark 3.7 and Section 3.1.
That bibliography's publication claims are not independently verified
here, and the proof is not taken on faith from that reference.

## Connection-dimension argument

For an algebraic flat principal \(H\)-connection with dense monodromy,
let \(R\) be the algebraic closure of a horizontal lift of a dense
analytic germ \(T\). On a smooth constant-rank locus, the connection
form \(\xi\) gives an algebraic Grassmann map
\(r\mapsto\xi(T_rR)\). Cartan's formula and the flat
Maurer--Cartan equation show that this map is constant along horizontal
tangent fields. It is constant along the lifted germ, hence on \(R\).
Its value \(\mathfrak b\) is a Lie subalgebra, by lifting constant
elements and applying the same equation.

If \(\mathfrak b\ne\mathfrak h\), its connected analytic subgroup has
proper algebraic closure \(B<H\). Otherwise its adjoint stabilizer would
make \(\mathfrak b\) an ideal; an ideal of a semisimple Lie algebra
integrates to a closed algebraic subgroup, contradicting density.
The saturation \(\overline{R B}\) dominates the base and has dimension
\(\dim Z+\dim B\): fiber orbits give the lower bound and connection
rank-nullity the upper bound. Its entire horizontal distribution is
tangent. Algebraic tangency preserves its ideal, so horizontal transport
preserves a nonempty closed fiber of dimension \(\dim B\). This is
impossible for dense monodromy acting on an \(H\)-torsor. Thus
\(\mathfrak b=\mathfrak h\), and
\(\dim R\ge\dim T+\dim H\).
The argument needs semisimplicity, not the false general assertion that
every proper analytic subgroup of an algebraic group has proper closure.

## Applying that estimate without losing hypotheses

At the chosen Hodge-generic point the generic Mumford--Tate group on
\(Z\) is the ambient one. Andre normality therefore makes the restricted
connected monodromy normal in \(G\). Adjoint semisimplicity supplies
the rational product decomposition. Killing finite complementary
monodromy and applying fixed part to the **rational Lie variation**
makes the whole \(Q\)-period constant. Applying this merely to an
arbitrary nonrational subsystem would not establish the needed claim.

Regular singularity makes invariant tensor sections and trivial flat
frames algebraic. Milne's tensor/stabilizer results give the algebraic
frame reduction; connected semisimple groups have no nontrivial line
characters, and characteristic-zero reductivity splits the required
tensor subquotients. This is where algebraicity, rather than only local
flatness, is used.

The incidence of frames sending \(\ell\) to its fixed value on \(T\)
has fibers of dimension \(\dim H-d\), where \(d=\dim H_{\mathbb C}\ell\).
Its constructible image contains a dense open of \(Z\), and it contains
the horizontal lift. The estimate gives \(\dim Z-\dim T\ge d\).
Conversely the line map on that open has values in the same orbit and
kernel exactly \(T_zT\), giving the reverse inequality. Equality yields
orbit filling. Every nonempty subgerm of \(T\) stays algebraically dense,
so suitable smooth points may be chosen while preserving the finitely
many maximum-rank opens needed for each weighted comparison.

For a dominant projective \(h\) with connected generic fiber, shrinking
to its smooth proper connected-fiber locus preserves surjectivity on
fundamental groups. Removing further algebraic subsets and passing to
a connected finite level do not remove the connected dense monodromy.
This accounts for **every** permitted \(h\), rather than only the
original marked vector's base.

## Sources, receipts, and actual limits

Andre: Compositio 82 (1992), Section 5 Theorem 1 p. 10,
`url:https://www.numdam.org/item/CM_1992__82_1_1_0/`.
Schmid: `doi:10.1007/BF01389674`, Theorem 7.22 p. 274.
Their retained independent excerpts include the good polarizable
variation, Hodge-generic and compactifiable-base hypotheses.
Milne (2017), `isbn:9781107167483`, Theorems 4.14 and 4.27,
supplies the tensor assertions.

The original report could not obtain Deligne's original scan. The later
reviewer packet **did** read the source-linked Hosgood translation of
*Equations differentielles a points singuliers reguliers*, Chapter II,
Theorem 5.9 and proof, pp. 97-98, and explains the degree-zero use of
II.6/Theorem 6.2. It establishes the required horizontal-section
algebraicity, not a new inference from an HTTP failure. No reading of the
unavailable original scan is claimed. The historical ledger still calls
this dependency uncited; the later support is a judgement/excerpt, not
a `citation_check attribute` record.

`judgement-C_LINE_ORBIT-36bd2f4916f6` and the four assumption receipts
match their historical subject hashes. The report matches the preserved
snapshot; the excerpt packet is not snapshot-bound. The Python and
Jacobian computations do not check this geometric argument.
No specific internal mathematical gap was identified under the stated
inputs. The result remains a classical argument with external theorems,
not a machine-checked global theorem or a current family acceptance.
