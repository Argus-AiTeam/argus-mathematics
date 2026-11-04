# Complete global squareclasses for the branch-483 cover

This is an Engineer proof with exact rerunnable arithmetic, awaiting
independent Reviewer replay. It supersedes the earlier *conditional*
global-basis bound, not the previously reviewed norm or pairing identities.
It does not certify complete integral class or unit groups.

## Fields and elliptic curve

To avoid the conflicting uses of K in earlier files, write k for the
degree-six elliptic base field and K for its degree-eighteen two-division
field. Put

```text
k = Q(z),  z^6-2z^5+3z^4-36z^3+60z^2+32z-56 = 0,
E/k: v^2 = u^3 + a2*u^2 + a4*u + a6,
a2 = -7/3*z^5 + 4/3*z^4 - 5*z^3 + 250/3*z^2 - 38/3*z - 31,
a4 = -218/3*z^5 + 96*z^4 - 10/3*z^3
     + 9404/3*z^2 - 1508/3*z - 6463/3,
a6 = 539*z^5 + 1236*z^4 + 4547*z^3 - 4402*z^2 - 7666*z + 6899,
K = k(alpha),  alpha^3+a2*alpha^2+a4*alpha+a6 = 0.
```

`export_descent_input.py` reads these exact coefficients and the twelve
generators from the original `d1_cover_selmer_local_sieve.json`, and reads
the chosen exact generator image from the reviewed
`d1_global_and_order012_field_relation.json`. No generator is replaced by a
numerically nearby element. `descent_support_preflight.gp` verifies the
absolute equation, the embedded sextic equation, the cubic equation, and
the full rank-eighteen cubic-over-sextic basis.

Let S_K be *all* prime ideals occurring in the principal ideal of
`3*alpha^2+2*a2*alpha+a4`, and S_k all prime ideals occurring in
`6*Delta(E)`. These are precisely the support rules in the existing Simon
generator extraction. Define K(S_K,2) by even valuations outside S_K,
modulo K-squares, and similarly for k.

## Completeness theorem

The twelve archived generators form a basis of

```text
ker(N_K/k : K(S_K,2) -> k(S_k,2)).
```

The dimensions of the domain, target, image, and kernel are respectively
23, 12, 11, and 12. This conclusion is unconditional.

### Proof

1. `relative_parity_criterion.md` proves and instantiates the ambiguous
   class criterion: h(F)=1 for the degree-nine subfield, exactly three
   finite ramified places and no infinite ones, and field-element
   norm-unit index four. Consequently h(K) is odd. Actual K-units with
   integral inverses have twelve independent residue characters, so they
   form all of E_K/E_K^2, by the signature (6,6).

2. There are eleven primes in S_K. Candidate S-units are used only after
   exact principal-ideal identities account for their *entire* finite
   support. Their valuation matrix has rank eleven modulo two. Since
   h(K) is odd, the S-class group has no two-torsion. The valuation
   sequence therefore gives a complete 23-dimensional basis of
   K(S_K,2). There is no assumption that the candidate units form an
   integral fundamental-unit basis.

3. For k, pristine quotient certification at the inspected and actual
   bound 88 proves h(k)=1. Its signature is (4,1), and there are seven
   primes in S_k. The exact support identities have valuation rank seven.
   The combined support and residue characters have rank twelve; hence
   the five unit classes and seven support classes form all of k(S_k,2).

4. The explicit rank-eighteen basis expresses each of the 23 domain
   generators as a quadratic polynomial in alpha with k-coefficients.
   Its exact cubic norm is expressed in the target basis with a checked
   square witness:

   ```text
   N(b_j) = product_a c_a^(N[a,j]) * w_j^2.
   ```

   Here N is a 12-by-23 binary matrix, of rank eleven. In particular every
   basis norm belongs to the asserted target squareclass space, so the
   norm map on the complete domain really takes values there.

5. A rank-23 character matrix gives coordinates C for the twelve original
   archived elements beta_j. For each one an exact root is then found and
   squared, proving an identity, not merely agreement of sampled signs:

   ```text
   beta_j = product_i b_i^(C[i,j]) * r_j^2.
   ```

   The 23-by-12 matrix C has rank twelve and N*C=0 over F_2. Thus the
   archived classes are twelve independent elements in a kernel of
   dimension twelve and are the complete kernel.

6. If B is the independently computed kernel matrix, the certificate
   gives an invertible 12-by-12 binary matrix T with B*T=C modulo two.
   It also records the *integer* matrix `(C-B*T)/2`. Together with r_j
   this is an explicit factored square witness for the change of basis:
   its j-th root is `r_j * product_i b_i^((C-B*T)[i,j]/2)`.
   Finally, explicit k-valued square roots of all twelve archived norms
   are constructed and squared exactly. This binds the norm map and the
   archived basis simultaneously.

The exact matrices, elements, prime ideals, and square witnesses are in
`complete_squareclass_data.gp`. The producer
`certify_descent_squareclasses.gp` terminates with
`COMPLETE_GLOBAL_NORM_SQUARECLASSES_CERTIFIED`; its native output is
`complete_squareclasses.txt`. None of its exact checks relies on a
conditional BNF class-number assertion for K. BNF and S-unit routines are
used only to discover candidate elements whose identities and
squareclass ranks are subsequently checked.

## Rank consequence, separate from saturation

The reviewed complete local images, in this very archived basis, leave
the three-dimensional space

```text
{0,936,1304,1712,2415,2759,3191,4063}.
```

The full cubic-over-sextic basis proves that the cubic is irreducible
over k, so E(k)[2]=0. The Kummer exact sequence is
`0 -> E(k)/2E(k) -> Sel_2(E/k) -> Sha(E/k)[2] -> 0`.
The pairing used here is the pullback of the bilinear Cassels--Tate
pairing on Sha, so it annihilates the Mordell--Weil image.

The reviewed exact point Q has Kummer vector 4063. The independently
reviewed global norm preimage and tangent give
`<936,1304>_CT = 1/2`. The new completeness theorem removes the
global-basis condition from this local intersection. Thus
`dim Sel_2(E/k)=3`, and the pairing has rank two with the known
Mordell-Weil line in its radical. Since Q has infinite order,
the rank of E(k) is exactly one. This argument assumes neither GRH nor
finiteness of Sha.

Moreover Sha(E/k)[2] has dimension two and its induced pairing is
nondegenerate. An element x of order four would give a nonzero 2x in
Sha[2] pairing trivially with every y in Sha[2], because
`<2x,y>=<x,2y>=0`. Hence no such element exists, nor one of larger
2-power order, and

```text
Sha(E/k)[2^infinity] = (Z/2Z)^2.
```

This does **not** by itself prove E(k)=ZQ. Odd index and odd torsion are
invisible to the preceding 2-descent. Full all-prime saturation of Q and
trivial torsion are a separate obligation in
`certify_cover_saturation.py`; the previously written p=23 theorem
explicitly uses this sufficient premise. A new alternative,
`p23_closure_lemma.md`, proves that nondivisibility only at primes dividing
23 times the *full* finite reduction-group orders is sufficient for its
complete analytic disks. Its finite witnesses and exact model binding are
produced by `certify_p23_index.py`. This route can classify rational points
without asserting the stronger all-prime conclusion E(k)=ZQ.

## Comparison and novelty

The strongest prior result for this dependency was an exact abstract
degree-eighteen field isomorphism, with the global squareclass basis still
uncertified. The improvement here is unconditional parity, complete
unit and support squareclasses, and an exact basis binding, not another
finite search or an extension of a prime bound. No degree-thirty-six
class/unit certificate or non-preflight v6 output is claimed.

A targeted literature lookup found no exact indexed match for the
displayed genus-two sextic. Its generic database links do not establish
absence of an isomorphic model or a prior classification. In particular
the search tool's unsupported claim of "verified novelty" is not adopted:
novelty and publishable significance remain unverified pending independent
comparison with primary literature.

## Reproduction

Run the GP sources with the campaign's pristine
`d1-cassels-tate/toolchain/pari-2.17.4-clean-install/bin/gp-2.17`
from the campaign root, in this order:
`field_preflight.gp`, `certify_relative_parity.gp`,
`certify_unit_squareclasses.gp`, then `export_descent_input.py` with the
pinned Argus Python, `descent_support_preflight.gp`, and
`certify_descent_squareclasses.gp`.

For the Sage saturation source use the probed native interpreter
`research/r2-generic-section-difference/toolchain/sage-10.9/bin/python`,
with HOME and DOT_SAGE below this directory and
`PYTHONDONTWRITEBYTECODE=1`. This installed Python Sage launcher neither
accepts `-python` nor binds `__file__` to a loaded `.py` source; native
Python execution is necessary for the source-relative input paths.
