# An explicit theta-compatible arithmetic image and its Runge tower

## Result, provenance and publication boundary

This treatment separates three questions: the arithmetic theorem, its
relationship to published criteria and examples, and its publishable
originality. The theorem below already has independent mathematical
support in handoff `7766881c7ccd` and in the current claim ledger.
The proof in `k8_56_theta_two_power_runge_theorem.md` and every reviewed
certificate are unchanged. This round does not strengthen that theorem.

The focused primary comparison establishes that the arithmetic calculation
is not supplied by Jones--Rouse's full-GSp criterion or their genus-two
example. It also establishes that the affine framework, full-translation
criterion and explicit all-level examples are antecedents, not new
contributions here. Janssen's integral congruence theorem is an antecedent
with hypotheses that must not be inferred just from the residue image.

There is a nontrivial, certified curve-specific arithmetic calculation.
There is not, on the evidence below, a substantiated
`novelty_status=verified_new`, `significance_status=publishable` verdict.
Neither a different dimension nor failure to find this curve in the
compared sources supplies that verdict. This is a research treatment and
an unsuccessful bounded publication assessment, not a new publication
certificate or a claim that the arithmetic theorem is already known.

## 1. Objects and exact theorem

Let C be the smooth projective model of

```text
(T-1)(T-9)(T-25) = 384u(u^2-1)(u^2-4).
```

Its genus is four. Its unique point at infinity is rational, and
`ord_infinity(u)=-3`, `ord_infinity(T)=-5`. Write

```text
J = Jac(C),                 i(P) = [P-P_infinity],
D = [P_(25,2)-P_infinity],  T_2 = T_2(J),  V = T_2/2T_2.
```

The differential `du/F'(T)`, where `F(T)=(T-1)(T-9)(T-25)`,
has divisor `6P_infinity`. Thus `3P_infinity` is a rational even
theta characteristic: its section space is spanned by `1,u`.
The resulting quadratic refinement of the Weil pairing has plus type.
Choose symplectic coordinates with reduction

```text
q(x_1,y_1,...,x_4,y_4) = sum x_i*y_i.
Gamma = {A in GSp_8(Z_2): A mod 2 preserves q}.
```

**Reviewed arithmetic theorem.** Up to the corresponding choices of basis
and compatible division points, the torsion and affine Kummer images are

```text
rho_2(G_Q) = Gamma,
omega_(2,-D)(G_Q) = Z_2^8 semidirect Gamma.
```

For every integer r>=1 define the exact fiber product

```text
Y_r = {(P,Q) in C times J: [2^r]Q = i(P)-D}.
```

It is a smooth geometrically connected projective curve, finite etale of
degree `2^(8r)` over C, with genus `1+3*2^(8r)`. It contains the rational
point `(P_(25,2),0)`. Its transition map is `(P,Q)->(P,[2]Q)`.
The reduced pole support of the pullback of u is

```text
X_r = [2^r]^{-1}(-D);
```

each pole has order three. For every number field K,

```text
#(G_K-orbits on X_r) <= r_1(K)+r_2(K).
```

Consequently, no r and no finite number-field extension restores the strict
direct-Runge condition for this function on this coherent tower. This does
not concern all functions, all twists, or all unramified covers of C.

## 2. Where the curve-specific arithmetic enters

The canonical model, in coordinates `[w:x:y:z]=[1:u:T:u^2]`, is

```text
wz-x^2 = 0,
y^3-35wy^2+259w^2y-225w^3-384xz^2+1920wxz-1536w^2x = 0.
```

The ratios u,T generate the function field, so this is not a
hyperelliptic genus-four example. The arithmetic work is the following
explicit input, not a conclusion of a general Kummer criterion.

| Proposition for this C and D | Exact arithmetic content | Existing evidence |
|---|---|---|
| Full residue image | The 120 odd theta characteristics form one orbit; an actual inertia transvection then forces `rho_2 mod 2 = O_8^+(2)`. | `k8_56_theta_2cover_runge_boundary.md`, odd-theta and full-image sections; `k8_56_theta_2cover_runge_certificate.json`. |
| Primitive integral inertia | At `p=58411` the special fiber is geometrically irreducible with one ordinary node, and the total model is regular with smoothing thickness one. | The same certificate, `one_node_picard_lefschetz_input`; the corrected SGA 7 II source and independent attribution in the two-power theorem and ledger. |
| Rational nondivisibility | D has joint reduction coordinates `(0,1,1,0)` in the reviewed mod-two quotients at 7 and 11. In particular, `D notin 2J(Q)`. | `k8_56_grid_rank_certificate.json`; the globally soluble survivor section of the theta boundary proof. |
| Full integral and affine images | Integral inertia conjugates fill the congruence layers; the nonzero rational Kummer class cannot become divisible over the two-power torsion field. | `k8_56_theta_two_power_runge_theorem.md`, Sections 3--6; the four lemma judgements and main theorem judgement by `reviewer:copilot-2338-two-power`. |

For precision, the odd-theta computation is not a computation of a
degree-256 division polynomial. Its planes are normalized as
`aw+bx+y+dz=0`. Substitution gives `P(u)=sum p_i*u^i`, with

```text
p0=(a+1)(a+9)(a+25)
p1=3a^2b+70ab+259b+1536
p2=3a^2d+3ab^2+70ad+35b^2+259d
p3=6abd+b^3+70bd-1920
p4=d(3ad+3b^2+35d)
p5=3(bd^2+128)
p6=d^3.
```

The seven coefficient equations
`P(u)=(q0+q1*u+q2*u^2+q3*u^3)^2` define the signed contact algebra.
The retained exact elimination gives dimension 240, with 120 planes
after forgetting the sign, and an irreducible degree-120 d-eliminant.
The defining source and full coefficients are, respectively,
`k8_56_theta_2cover_runge_tritangents.sing` and
`k8_56_theta_2cover_runge_tritangents_eliminant.txt`.
The four complete modular factorizations are reconstruction controls,
not replacements for the characteristic-zero irreducibility computation.

At `p=58411` the unique singular point is `(T,u)=(47817,24115)`.
Both second derivatives are nonzero, and evaluating the integral
equation at those representatives and dividing by p gives
`22157 mod 58411`, nonzero. These are explicit arithmetic checks of a
thickness-one nonseparating node, not an assumption of generic monodromy.
Conjugating its nontrivial orthogonal transvection through the transitive
odd-theta action supplies all nonsingular centers. The reviewed exact
generation order is `348364800=|O_8^+(2)|`.

These calculations determine hypotheses for the general arguments on a
specified nonhyperelliptic Jacobian and a specified rational point class.
They cannot be replaced by asserting that the maximal allowable group is
the expected group. Conversely, their existence does not make the general
arguments that use them original.

## 3. Proof of the arithmetic and tower conclusions

Here the finite arithmetic inputs are exactly those in Section 2; their
accepted certificates are reused, not rerun. The following implications
are the already reviewed proof, with its antecedents made explicit.

**Torsion.** Integral Picard--Lefschetz at the regular node supplies
`1+cN_v`, with c an odd 2-adic unit, v primitive and
`N_v(x)=<v,x>v`. Its residue center is nonsingular for q.
The full residue image supplies all 120 nonsingular conjugate centers.
The tensors at those centers span the 36-dimensional symplectic Lie
algebra. Squaring these transvections, then taking successive powers,
fills each layer

```text
ker(Sp_8(Z_2)->Sp_8(Z/2^n)) /
ker(Sp_8(Z_2)->Sp_8(Z/2^(n+1))).
```

Closedness gives the full principal level-two symplectic subgroup.
Residue transvection generation gives the full symplectic theta
preimage. The cyclotomic multiplier is onto `Z_2^*`, proving
`rho_2(G_Q)=Gamma`. This is not an inference that residue surjectivity
alone always lifts.

**Kummer.** The already established general inputs imply
`H^1_cont(Gamma,V)=0`: the positive extraspecial nonsplitting theorem
of Griess, Sato's congruence abelianization and BCCR's mod-four
identification give the required nonzero transgression, using the
reviewed finite `H^1(O_8^+(2),V)=0`. The precise theta restriction and
dense-subgroup argument are in `k8_56_theta_two_power_runge_originality.md`,
Sections 2--3; this reduction also has independent support.

Inflation--restriction therefore makes

```text
H^1(Q,V) -> H^1(Q(J[2^infinity]),V)
```

injective. Since the Kummer class of -D is nonzero, -D has no half in
that torsion field, and hence none in any finite two-power torsion field.
The irreducible natural residue module and Jones--Rouse Theorem 3.4
give the full translation subgroup at every level. Passing to the
compatible closed inverse limit gives the asserted affine image.
Equivalently, the reviewed proof obtains the same conclusion directly
from the closed invariant translation submodule and Nakayama's lemma.

**Geometry.** Pulling back multiplication by the Abel--Jacobi map
gives the stated etale degree. The induced map on integral first
homology is onto, proving geometric connectedness of every pullback.
Riemann--Hurwitz gives the genus. The rational point and transition
maps follow from their defining equations. Etaleness preserves the
order-three pole of u, so its pole fiber is exactly X_r.

**Every extension.** Put `M=(Z/2^r)^8`, `B=Gamma mod 2^r`, and
`A=M semidirect B`. For any proper subgroup H of A, double cosets
identify its orbits on M with the right B-orbits on `H\A`.
If none is a singleton, there are at most `[A:H]/2`.
Otherwise conjugate so that `B<=H`; then `H=W semidirect B`.
Irreducibility and finite Nakayama give `W=2^k M`, with k>=1.
The quotient M/W has even size, and its only B-fixed vector is zero:
the leading nonzero residue of any other fixed vector would be fixed
by the nontrivial irreducible residue group. Counting the remaining
orbits, each of size at least two, gives the same half-index bound.
No new orthogonal minimum is needed.

Let E_r be the splitting field of X_r, let `F=E_r intersect K`,
and let `d=[F:Q]`. Restriction gives the action of
`H=Gal(E_r/F)` on X_r, even when K/Q is not Galois. If d=1,
there is one orbit. Otherwise

```text
#(G_K-orbits on X_r) <= d/2 <= [K:Q]/2 <= r_1(K)+r_2(K).
```

This proves the all-level, all-number-field assertion. It is an
unconditional obstruction to this direct-Runge strategy, not an
integral-point classification or a conditional Selmer computation.

## 4. Exact comparison with Jones--Rouse

The primary version is *Galois theory of iterated endomorphisms*,
`arxiv:0706.2384v4` (7 November 2009), DOI `10.1112/plms/pdp051`.
Its retained text is `k8_56_theta_two_power_runge_jones_rouse.txt`.
The statements read are transcribed in
`k8_56_theta_two_power_runge_publication_sources.txt`.

| Primary proposition | Hypotheses and conclusion actually read | Consequence for this application |
|---|---|---|
| Proposition 3.1, pp. 7--8 | For the division field `K_n=T_n F(beta_n)`, the map `sigma -> (sigma(beta_n)-beta_n, sigma on A[ell^n])` is an injective homomorphism. | The affine embedding and its compatible inverse limit are established framework. The proposition does not identify this curve's image. |
| Theorem 3.4, pp. 11--13 | For some m, `A[ell^m]/A[ell^(m-1)]` is irreducible under the torsion image and alpha is not in `A(F) intersect ell A(T_n)` for every n>=m. Then every corresponding finite affine image is the full semidirect product. | It applies with `A=J`, `F=Q`, `ell=2`, `m=1`, `alpha=-D`, after the reviewed inputs and cohomology argument discharge its hypotheses. Full translation after those inputs is not a new Kummer theorem. |
| Theorem 6.2, pp. 29--30 | The polarization has degree prime to ell and the torsion representation is onto the full `GSp_(2d)(Z_ell)`. Full translation is equivalent to rational nondivisibility and, at ell=2, a chosen half not lying in the first torsion field. | Principal polarization holds, but full GSp does not. This theorem cannot simply be specialized by replacing its group with Gamma. Its failure to apply is a hypothesis distinction, not a novelty certificate. |
| Example 6.4 and Proposition 6.5, pp. 30--32 | For the explicit genus-two hyperelliptic Jacobian of `y^2=4x^6-8x^5+4x^4+4x^2-8x+5` and its specified divisor alpha, the affine image is `Z_ell^4 semidirect GSp_4(Z_ell)` for every prime ell. The proof checks rational indivisibility, the torsion image and an explicit degree-16 half-field. | Explicit higher-dimensional all-level arithmetic images were already computed. The present theorem has dimension four and a proper theta image, but concerns only ell=2. It does not improve the all-prime conclusion of that example. The source does not compute C or D here; that observation alone proves no priority claim. |

The proper-image distinction is exact, not terminology. In the above
coordinates the symplectic transvection at e1 sends f1 to `e1+f1`;
`q(f1)=0`, while `q(e1+f1)=1`. Thus it is not in the orthogonal
stabilizer. In fact the stabilizer index is 136: the refinements are
`q+b(v,-)`, and their even subset has
`2^3*(2^4+1)=136` elements; symplectic hyperbolic bases show transitivity
on that subset. Reduction gives the same index for Gamma in GSp.

Here "maximal theta-compatible image" means the whole subgroup permitted
by the rational even characteristic, not an independently claimed
classification of maximal subgroups. The result is a positive exact
image determination, not merely failure to attain full GSp.

As one bounded adapter calculation, `quadratic_form.evaluate.compute`
evaluates the integral polynomial `sum x_i*y_i` at `e1+f1` and returns
the rational value `1/1`. Reduction modulo two gives the displayed
witness. The dedicated `publication_jacobian_{payload,result,execution}.json`
files retain the exact request, typed output, server 0.14.0, protocol
2025-11-25, adapter exit 0 and no timeout/error. This elementary witness
has no novelty or significance weight. The initially inspected
`group.order.compute` admits degree at most 64, so it was not run on
the actual 120-, 136- or 256-point actions or on a substitute action.

## 5. Janssen: what the verified primary passage permits

The original printed pp. 115--116 of *Skew-symmetric vanishing lattices
and their monodromy groups*, DOI `10.1007/BF01458708`, were read directly
in the GDZ scans retained as
`k8_56_theta_two_power_runge_publication_janssen_p115.jpg` and `_p116.jpg`.
EuDML's article record points to that scan; it is not itself the
mathematical source. The image URLs are recorded in the source excerpt.

On p. 115 a vanishing lattice has a generating set Delta which is one
orbit under its transvection-generated group and contains two elements
with integral pairing one (in rank greater than one). On p. 116,
(2.4) identifies a group G_V by its action on `V^*/2V'` and states
generation by transvection squares. Theorem (2.5) says that the
monodromy group of a vanishing lattice over Z contains G_V.
For a unimodular symplectic lattice, this is the principal level-two
symplectic congruence subgroup.

These are strong positive antecedents for the congruence-generation
mechanism. They are not an arithmetic image calculation for this C.
The inspected statements do not turn a transitive mod-two Galois
action into a single integral vanishing-lattice orbit with pairing
exactly one. Nor do they identify a fixed Jacobian's arithmetic image
with the geometric monodromy group of a family. The reviewed proof
instead uses the actual primitive 2-adic inertia element and closed
congruence-layer generation. Its applicability to this curve is real;
the underlying transvection mechanism is not presented as new.

## 6. Substantive publication assessment

The exact arithmetic core is the characteristic-zero odd-theta algebra,
the regular nodal model and the rational nondivisibility witness, followed
by their application to the exact integral and affine images. These
are not consequences of simply naming a general criterion, nor a
bounded search for absent binomial solutions. Their existing certificates
make the image calculation reproducible. No explicit higher-level
division polynomial or complete Selmer group is being claimed.

The all-level conclusion also has genuine mathematical force: the covers
are globally soluble, their number of geometric poles grows as `2^(8r)`,
and arbitrary division depth and field extension still cannot repair
the strict pole-versus-place inequality. Thus the obstruction is neither
vacuous nor merely finite. A structural method obstruction is an
authorized kind of campaign result; point classification is not being
imposed as an extra acceptance condition.

Nevertheless the comparison has the following precise limit.
Jones--Rouse already supply the affine framework, the irreducibility
criterion and a fully explicit higher-dimensional all-level example.
Janssen supplies the transvection/congruence antecedent. The
Griess--Sato--BCCR reduction already accounts for the proposed
cohomological core, and elementary double-coset counting accounts for
the extension obstruction once the image is known. The remaining
candidate originality is therefore the exact arithmetic determination
for this particular C and D and its concrete tower application.

Nothing in this comparison proves that the determination was previously
published. Equally, a distinct curve and a proper theta-compatible group
do not establish verified priority or field-level publishable
significance. The nontrivial arithmetic inputs were already accepted
before this round; this round supplies no additional arithmetic
proposition strengthening them. The comparison gives no independent
publication assessment establishing that this explicit calculation,
beyond the established general machinery and existing explicit examples,
meets the required bar. It would be unjustified to turn its valid
all-level quantifiers into that missing verdict.

Accordingly the bounded publication route remains unsuccessful.
The publication obligation receives an inconclusive Engineer judgement,
not a refutation of the arithmetic theorem. The exact reason for retiring
this attempted publication case is recorded in MATH_STATE; the actual
mathematical tower route is preserved. Normal independent Reviewer
review must assess the source comparison and this limitation, then return
the unmet publication goal for mathematical replanning rather than
repeat the same comparison or rename its known ingredients.

There is no new exclusion of either surviving K(a)=8 system, no
`m(a)=5 => K(a)>=9`, no new global multiplicity bound and no terminal
campaign completion.
