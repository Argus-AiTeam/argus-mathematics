# Curve positivity to weighted coefficient packets

**Assessment:** section 6 supplies the necessary scheme-theoretic bridge in prose. The ordinary-power, ideal-inclusion and high-degree-section steps have the right direction and hypotheses. Neither the finite checker nor the Lean source certifies this bridge.

## Exact claim and provenance

The old assertion is `C_GEOM_JET_BRIDGE` in A01; its successive versions make the blowup, Rees, Serre and ample-plus-nef inputs explicit. The written argument is A04 section 6. Its reference is OpenAI's September 24, 2026 `geom:interpolation` proof, interpolation.tex from line 476 onward, revision `4eaee87548250b2682affda7d05d947c05554bae`.

Fix positive rational weights `W=(w0,...,wm)`, `V=(v0,w1/theta,...,wm/theta)` and distinct centers `(bj,cj)` with `bj!=0`. Assume that every irreducible affine curve satisfies `D >= (1+sigma)S` for some fixed `sigma>0`, using the weighted pole degree and the sum of all local branch contacts defined in the curve unit. The conclusion is surjectivity

    {P: deg_W P <= H} -> product_j {coefficients of V-weight < H}

under `Y=bj(1+t)`, `Xi=cji+ui+log(1+t)`, for `H=nR` and every sufficiently large integer `n`. The integer `R` depends only on the weights. The later threshold can depend on the fixed centers. Normality and smoothness of the projective closure are not hypotheses.

## Projective and local constructions

Choose an integer `R` for which all `R/wa` and `R/va` are positive integers. The monomials of `W`-degree at most `R` embed affine space; the constant monomial chart is its closed graph and contains every coordinate. Let `X` be the integral projective closure and `L=O_X(1)`.

On a complete curve model, every monomial has pole order at most `R` times the maximum weighted coordinate pole order. A pure coordinate power, or the constant monomial if there is no pole, attains that maximum at each point. This proves `deg L|C = RD`. It avoids both cancellation among sections and any assumption that the closure is normal.

Put `tj=Y/bj-1`. Choose a polynomial truncation `Gi(tj)` of the logarithm whose first omitted term has weight strictly greater than `vi`. The formal changes `ui'=Xi-cji-Gi(tj)` and their inverses preserve the weighted filtration: the added tail terms have weight greater than the replaced variable. They also preserve branch contact, since the tail's order divided by `vi` exceeds `ord(tj)/v0`; an identically zero `tj` gives zero tail.

At each center use the finite-colength ideal

    Ij=(tj^(R/v0), (u1')^(R/v1), ..., (um')^(R/vm)),

and the unit ideal off those distinct centers. This gives a coherent nonzero ideal `I` on `X`. On the **ordinary** blowup `p:X'->X`, write `I O_X'=O(-E)` and `A=p*L`.

For a noncontracted curve meeting the affine chart, the blowup is generically an isomorphism along its image; the complete normalizations give `deg A=RD`, `deg E=RS`. The ideal valuation is precisely the minimum of the generator orders, `R hP`, with every branch included. Curves whose images lie at infinity miss `E`. On a contracted curve, `A` has degree zero and `-E` has strictly positive degree by relative ampleness. Thus `A-(1+sigma)E` is nef on **all** integral curves upstairs, not merely the curves used in the finite examples.

## Ampleness and actual powers

For a sufficiently large `b`, `I L^b` is globally generated. The resulting Rees closed immersion into `X` times a projective space identifies the two hyperplane classes with `A` and `bA-E`. Their sum `(b+1)A-E` is ample. Write `a=b+1>1`. The identity

    A-E = (a-1)/(a(1+sigma)-1) [A-(1+sigma)E]
          + sigma/(a(1+sigma)-1) [aA-E]

has both coefficients positive. The first bracket is nef and the second ample, so `A-E` is ample. Lazarsfeld Corollary 1.4.10 explicitly includes projective schemes and real divisors; no unjustified smooth-variety restriction is being applied to this possibly singular blowup.

On a finite affine cover of `X`, the ordinary Rees algebra is Noetherian and finitely generated in degree one. The eventual graded-piece and coherent-twist theorems give

    p_* O(-nE)=I^n,  R^q p_* O(-nE)=0 (q>0)

for all sufficiently large `n`. The claim is **eventual**, not an equality for every small `n`, and the right side is the ordinary power, not its integral closure. Projection formula and Leray transfer Serre vanishing for the ample `A-E` to `H^1(X,I^n L^n)=0`.

Consequently sections of `L^n` supply all classes modulo `I^n`. Every generator of `I` has weight `R`, so `I^n` is **contained in** the ideal of terms of weight at least `nR`. Therefore the quotient modulo `I^n` maps onto the desired strict packet. Reversing this inclusion would invalidate the bridge; the report has it right and does not assert equality.

Finally, for sufficiently large `n`, sections of `L^n` come from degree-`n` homogeneous polynomials in the embedding coordinates, by vanishing of the homogeneous ideal sheaf. Their restrictions have `W`-degree at most `nR`. Projective normality in small degrees is not required. Undoing the filtered changes gives exactly `H=nR` in the conclusion.

## External propositions and verdict boundary

The inputs registered on the current claim are:

| Input | Actual source and hypotheses used |
|---|---|
| `A_BLOWUP` | Stacks `02OS`, `02ND`, `02NS` (A18-A20): effective Cartier exceptional divisor; integral base and nonzero ideal for integrality; finite-type ideal for projectivity and relative ampleness. |
| `A_REES_EVENTUAL` | Stacks `0AG7`, `0AG6` (A21-A22): Noetherian degree-zero ring, finite degree-one generation, finite graded module/coherent sheaf; eventuality is essential. |
| `A_SERRE_VANISHING` | Stacks `0B5U` (A26), Lemma 30.17.1 (1)->(2): proper scheme over Noetherian affine base and an ample invertible sheaf. |
| `A_AMPLE_PLUS_NEF` | Lazarsfeld, *Positivity I* (2004), DOI `10.1007/978-3-642-18808-4`, Corollary 1.4.10, p.53; A16 lines 2414-2432. |

Curve-model degree facts are inherited from the curve unit. All uses have the requisite hypotheses: `X` and `X'` are projective Noetherian integral schemes over `C`, the ideal is coherent and nonzero, and the twist is an ample invertible sheaf. Demailly's previously unsuccessful section-6 lookup is not used.

No specific missing mathematical step was found in this scoped written bridge. This is an Engineer reading of a proof using named external theorems, not a kernel proof. Independent geometric review and citation attribution are still outstanding; the citations' existence alone would not settle their applications.
