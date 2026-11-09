# Cyclic exchange traces with ordered real pulses

## Result and scope

The spherical manuscript's **Lemma `lem:trace-zero-free` is valid**, including
arbitrary finite slot and layer counts, admissible distributional limits,
and noncommuting single-slot matrices. Its application to the random traces
in Section 7 also preserves the required order and projections. No false
manuscript assertion is claimed by this report.

The proof below also gives a quantitative strengthening. If there are N slots
and m permutation layers, and each intervening slot matrix maps
`|x| < R` into the open unit disk with a nonzero first coordinate, for a
common R > 1, then

    |Tr K_0 ... K_(m-1)|
      >= |product_r c_r product_(r,i) (M_(r,i))_00|
         (1 - 1/R)^(mN).                                      (1)

Here `K_r = c_r P_r (tensor_i M_(r,i))`, `c_r != 0`, and P_r is
the mean permutation operator of any admissible probability law.
The constant is sharp already for one layer and arbitrary N.

For Section 7 put `h = t Re(z)/k > 0`, and let c > 0 be the scalar
in the exchange representation of `EP_*`. Independently of the sizes
and noncommutation of all real pulses, the unnormalized physical trace obeys

    |Tr_phys product_r [E_phys (P_* U_r(z) P_*)_phys]|
      >= c^k [2 sinh(h/2)]^(kN) > 0.                          (2)

The positive normalization in `eq:random-partition` multiplies this bound.
This is a finite-dimensional, samplewise statement. The bound can deteriorate
as k tends to infinity; no uniform limiting lower bound is asserted.
In particular it does not prove the replicated moment limit, harmonic
selection, the pressure tangent proposition, or any of the four
thermodynamic main theorems.

Classification: a universal verification theorem with a quantitative
refinement, not a counterexample or a finite-exhaustion result.
The qualitative contraction method and partial symmetrization are known
results. A bounded literature lookup found no exact match for (1)-(2), but
absence of a search hit does **not** certify novelty or publishability.
Those questions and independent mathematical acceptance remain with Reviewer.

## Exact source and conventions

The target is `build/sections/02-exchange.tex`, lines 390-403, in the staged
`The-spherical-magnetization-law-for-the-three-dimensional-quantum-Heisenberg-ferromagnet-October-5-2026`
directory. The literal lemma is extracted into `exact_certificate.json`
by its label, rather than replaced by a simplified statement.
The relevant application is `build/sections/07-pressure.tex`,
subsection "Nonvanishing random traces and replicated moments", especially
`eq:random-partition` and the displayed full-slot trace identity.

A permutation pi sends source slot i to output slot pi(i):
`U_pi |b> = |b o pi^(-1)>`. Algebraic covectors `(1,y)` have no
complex conjugation. Throughout a matrix word is the displayed ordered
product `K_0 ... K_(m-1)`; no factors within that word are reordered.
Thus, if `G_r(x_r,y_r)` is the symbol of K_r, the cyclic pairing is
`y_(r,i)` with `x_(r-1 mod m,i)`. Equivalently, writing chronological
operators in the opposite displayed order pairs each output with the next
chronological input. The verifier uses the former convention explicitly.

An admissible law is exactly a distributional limit of finite ordered products
of independent Bernoulli transpositions and deterministic permutations.
There is no assertion here about arbitrary probability measures on the
permutation group, nor about non-strict disk maps.
The empty slot set is harmless: every mean permutation is the scalar 1,
and the trace is the product of the nonzero layer scalars.

## 1. Stable permutation symbols, including limits

For the identity permutation the real multiaffine polynomial

    H(u,v) = product_i (u_i + v_i)

is upper-half-plane stable. A deterministic permutation renames the v
variables. Left or right multiplication by an independent Bernoulli
transposition performs a partial symmetrization in the appropriate one
of the input/output families. Repeatedly applying Borcea--Branden--Liggett,
Theorem 4.20, therefore proves stability for every finite admissible word.
Independence is used in taking each of these conditional averages;
commutation is not used.

The precise primary proposition is recorded in `bbl_theorem_4_20.md`;
`bbl_primary.html` retains the source actually read. The theorem covers
complex stable multiaffine polynomials, so it covers the real exchange
symbols without an extra positivity or reversibility hypothesis.
Its DOI is `10.1090/S0894-0347-08-00618-8`.
The existence lookup is not an independent attribution verdict.

On the finite permutation group distributional convergence is
coefficientwise convergence of H. A locally uniform limit of zero-free
polynomials on a polydomain is either zero-free or identically zero:
if a nonzero limit vanished at a point, restrict to a complex line through
that point on which its first nonzero Taylor term is nonzero, and apply
the one-variable small-circle Rouche argument. The approximants would
then have a zero inside that circle, a contradiction.
The identically-zero alternative is excluded here by

    H(i,...,i; i,...,i) = (2i)^N.

Thus all admissible limits, not just finite Bernoulli words, are covered.
The Cayley substitutions

    u_i = i(1+x_i)/(1-x_i),  v_j = i(1-y_j)/(1+y_j)

give

    u_i + v_pi(i)
      = 2i(1+x_i y_pi(i))/[(1-x_i)(1+y_pi(i))].

The denominator product does not depend on pi. Consequently

    F_mu(x,y) = E_mu product_i(1+x_i y_pi(i))

does not vanish when every input and output coordinate has modulus < 1.

## 2. A complete quantitative contraction theorem

Let P be any complex multiaffine polynomial in n disjoint pairs
`(x_j,y_j)`, zero-free for `|x_j|<r_j`, `|y_j|<s_j`, where
`r_j,s_j>0` and `r_j s_j>1`. Contracting a pair keeps the coefficients
of 1 and xy and discards those of x and y:

    A + Bx + Cy + Dxy  ->  A + D.                            (3)

For every fixed value of the remaining coordinates, A is nonzero.
The polynomial obtained by substituting `x=r_j z`, `y=s_j z`
has no root in `|z|<1`. If D is nonzero it has two complex roots,
each of modulus at least 1, whose product is
`A/(D r_j s_j)`. Therefore

    |D| r_j s_j <= |A|,
    |A+D| >= (1 - 1/(r_j s_j)) |A| > 0.                    (4)

When D is zero the same inequalities follow immediately. This reasoning
also covers repeated roots and vanishing linear coefficients.

It proves preservation of zero-freeness **as a function of all remaining
variables**, not just nonzero values at the origin. Hence it can be
iterated until every pair is contracted, including pairs coupling
different original factors. At each step set all still-uncontracted
coordinates to zero in (4). Induction gives

    |complete_contract(P)|
      >= |P(0)| product_j (1 - 1/(r_j s_j)).                 (5)

This is a theorem for every finite n, not an enumeration of a bounded
number of tensor layers. Its common-radius specialization
`r_j=R>1, s_j=1`, including the full induction and coefficient estimate,
is proved in `Main.lean`. Sharpness follows from

    P = product_j (1 - x_j y_j/(r_j s_j)),

which is zero-free in the stated open polydisk and has contraction
exactly the right side of (5). For (1), take one deterministic identity
permutation layer and `M_i = diag(1,-1/R)`.

## 3. Complete cyclic traces

Write a slot matrix as

    M_i (1,x)^T = (a_i(x), b_i(x))^T.

The source's hypotheses say `a_i(x)!=0` and `|b_i(x)|<|a_i(x)|`
on the entire closed unit disk. These are strict continuous inequalities
on a compact set. For the finitely many matrices there is therefore a
common R > 1 on whose open disk both inequalities still hold.
This argument includes singular slot matrices; invertibility is not
silently added to the lemma.

The symbol of the permutation layer after these matrices is

    G_r(x,y)
      = c_r product_i a_(r,i)(x_i)
          F_(mu_r)((b_(r,i)(x_i)/a_(r,i)(x_i))_i, y).

It is a multiaffine polynomial and is zero-free for `|x_i|<R`,
`|y_i|<1`. Multiply these symbols in disjoint layer variables.
The product P is zero-free on the full product domain.

To check the cyclic contraction exactly, expand

    G_r = sum_(a,b in {0,1}^N) (K_r)_(b,a) x_r^a y_r^b.

Contracting `y_r` with `x_(r-1)` retains precisely the terms with
`b_r=a_(r-1)` on each slot. The retained scalar is

    sum_(b_0,...,b_(m-1)) product_r (K_r)_(b_r,b_(r+1))
      = Tr(K_0 ... K_(m-1)).                                (6)

This handles self-pairings when m=1, nontrivial directed permutation
cycles, every finite m,N, and all operation orders. No unjustified
factorization into traces of individual layers occurs.
Now (5) with n=mN proves nonvanishing. Since
`P(0)=product_r c_r product_(r,i) (M_(r,i))_00`, it also proves (1).

The Lean source proves the entire contraction induction for a general
coupled multiaffine polynomial and proves that closing the symbol of an
arbitrary qubit matrix is its actual matrix trace, for every slot count.
The general many-layer index identification (6) is the explicit finite-sum
proof above; its orientation is independently exercised by the exact verifier.
This translation is not represented as a Lean theorem about admissible laws.

## 4. Noncommuting pulses: the order matters, but is correct

In the original s^3 coordinates, each generator on a slot is a real
trace-zero matrix: a real multiple of `i s^2`, `s^1`, or `s^3`.
Consequently each real-coefficient exponential is in SL(2,R).
Within a single exponential, generators on distinct slots commute,
so that exponential is a tensor product. Regrouping the full ordered
product by slot does not change the order of factors on a given slot.
It produces one `g_(r,i) in SL(2,R)` per slot, without claiming that
overlapping pulses commute.

Let

    B = [[1,1],[i,-i]],
    B^(-1) g B = [[alpha,beta],[conj(beta),conj(alpha)]].

The omitted common factor 1/sqrt(2) in the eigenbasis cancels in
the conjugation. For `g=[[a,b],[c,d]]` real,

    alpha=(a+d+i(b-c))/2, beta=(a-d-i(b+c))/2,
    |alpha|^2 - |beta|^2 = ad-bc = 1.                        (7)

Direct expansion gives

    |alpha+beta x|^2 - |conj(beta)+conj(alpha)x|^2
      = 1-|x|^2.                                          (8)

For `|x|<1` this proves both nonvanishing of the denominator and
strict containment of the projective image in the disk.
For `|x|<=1` the denominator is still nonzero because
`|alpha|>|beta|`. Thus these are disk automorphisms, with the
inverse obtained from `g^(-1)`.

In the source's actual word

    U_r(z) = (ordered product of real pulses) e^((tz/k) sum_i s_i^2),

the rightmost field acts **first** on kets. On every slot it is

    e^(tz/(2k)) diag(1,rho),  rho=e^(-tz/k),  |rho|=e^(-h)<1.

Replace x by rho x in (8). This gives a strict positive margin
`1-|rho|^2|x|^2`, and a defined denominator, for **every** `|x|<e^h`.
Therefore the lemma applies with the sample-independent radius `R=e^h`.
No bound on any Gaussian realization is needed. The all-up entry has
modulus `e^(h/2)|alpha| >= e^(h/2)` by (7). Substituting these facts
in (1) gives (2).

`Main.lean` verifies (7), the general SU(1,1) identity (8), and strict
mapping after a field for all complex parameters satisfying their stated
norm-square conditions, not just rational sample matrices.

## 5. Symmetric-slot projections

Let P=P_* and let E be the full-slot static ferromagnetic exponential for
one step. The all-slot bond sum commutes with independent permutations
within each site's slots. Hence `EP=PE`; also `P^2=P`.
Its restriction to Ran(P) is the physical exponential.
Indeed, the symmetric tensor power of ell qubits has dimension ell+1:
its basis has one symmetric vector for each down-spin count. The sum of
the qubit spins acts on this basis as the spin-ell/2 representation, as
is seen directly by applying the raising and lowering sums. Taking
`ell=2S` gives the physical site space. Summing all ell^2 slot pairs over
a site bond gives exactly the product of the two total site spins.
On the full slot space the physical product is represented by

    (E P U_0 P) ... (E P U_(k-1) P).

It is supported in Ran(P), so its full-space trace is its physical trace.
Use `P E P=EP` at interior joins and cyclicity at the final join:

    Tr_slots product_r (E P U_r P)
      = Tr_slots product_r ((E P) U_r).                     (9)

This identity does not assert `P U_r=U_r P`, does not replace
`P G^2 P` by `(P G P)^2`, and works for every positive finite k.
`projected_trace_eq_slot_trace` in Lean proves (9) for arbitrary finite
complex matrices E,P,U_r, assuming only idempotence and `PE=EP`.

For the reduced coupling, the source chooses t so that
`beta-2t c_B(B-1)B^2 >= 0`. The Poisson representation of E has
nonnegative edge rates; its scalar factor is strictly positive.
Explicitly, on slot edges with weights J_e>=0,
`s_i dot s_j = U_e/2-I/4`. The mean chronological Poisson product
with rates J_e/2 solves the finite matrix differential equation with
generator `sum_e J_e(U_e-I)/2`. Multiplication by
`exp(tau sum_e J_e/4)` therefore gives precisely
`exp(tau sum_e J_e(s_i dot s_j))`. This proves the claimed exchange
identity without an additional representation-theorem assumption.
P is the average of independent uniform permutations of the slots at
each site. Such a law is admissible: independent positive-rate pair
exchanges on a finite symmetric group converge to its uniform law.
Finite-time Poisson laws are limits of Bernoulli transposition words.
The product with the seam is therefore an admissible layer.
The law need not be reversible after ordered composition.
There is one such layer between successive U_r, so no projection-only
layer with a missing strict contraction has been inserted.

The samplewise nonvanishing in `eq:sample-harmonic` consequently follows.
The subsequent moment and thermodynamic arguments remain separate obligations
in the four-manuscript proof graph.

## Reproducible evidence and limitations

Run `python3 research/zero_free_traces/verify.py` from the campaign root
(SymPy 1.14.0 was available on this host). It compares its exact output
with `exact_certificate.json` and refuses stale Lean source or fidelity.
All finite matrix calculations use rational real/imaginary parts, never
floating-point determinants or sampled disk points.

The verifier checks symbolic Cayley and SU(1,1) identities, seven cyclic
networks with independent ordered admissible words, complex scalar layers,
and an exact spin-1 two-site projection example with pulses that do not
preserve the symmetric subspace. In that example the full static generator
H has spectrum in {-2,-1,0,1}; spectral interpolation constructs exactly
`E=exp((log 2)H)` over the rationals. A rational basis and its dual check
the physical trace against the full-slot trace. A same-sample conjugation
check uses the negative-field argument, as the source requires.
The non-strict boundary example `diag(1,-1)` has zero trace and is correctly
excluded, not reported as a manuscript counterexample.

These finite checks test the translation and implementation; they are not
the proof of the unbounded quantifiers. That proof is Sections 1-5, with
the fully iterated contraction and load-bearing linear algebra kernel-checked
in Lean 4.31.0. `statement_fidelity.md` separates exactly what Lean proves
from the analytic, representation-theoretic, and literature reading.
The official result in `lean_verification.json` has `exit_code=0` and
`proof_holes=[]`; its claim-bound archive is
`certificates/C_ZERO_FREE_CYCLIC_TRACES-d6dedcbbc6cb83ea.json`.

Jacobian was used only through the authorized Argus adapter. The discovery,
inspected contracts, exact payload, and typed output are retained as separate
JSON files. The executed operation was `polynomial.box.enclosure.compute`,
server 0.14.0, protocol 2025-11-25: it proves the bounded real polynomial
margin `1-r^2(u^2+v^2)` lies in [1/2,1] on
`[-1,1]^2 x [0,1/2]`. This is a useful exact check, not a substitute for
the universal argument at all `|rho|<1`.

Independent Reviewer has not yet accepted the proof, attribution, novelty,
or significance. No Reviewer verdict is imputed to a compiler or script.
