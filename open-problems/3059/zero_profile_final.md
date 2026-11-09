# The final zero-profile obstruction

This note gives an unconditional proof candidate for NS3059, with an
exact, rerunnable finite certificate for the final zero-profile class.
The new proof and certificate have passed the Engineer's literal
arithmetic checks, not the Host-invoked independent Reviewer. Originality
and publishable significance remain unverified. A singleton column of a
cofactor transform is never identified with an actual column of A.

**Theorem (NS3059).** Every A in GL_9(F5) of permanent rank five has
a column with at most three nonzero entries in A or A^-1. Permanent
rank means the maximum order of a square submatrix having nonzero
permanent over F5.

## Accepted-case assembly (FA3059)

Let A be invertible of order nine over F5, with permanent rank five.
Fix five column indices admitting a nonzero order-five permanent. Among
all nonzero permanent row pivots on these same columns choose one for
which the normal of the other four columns has minimum support.
After row and column permutations write

    A = [[B,X],[Y,Z]],  c = per(B) != 0,
    P = padj(B)/c,  T = YP,  Z = -TX,
    ker(X^T) = <w>,  S = supp(w),  s = |S|.

Here X has rank four: the four actual complementary columns are
N=[X;-TX], and are independent. Consequently w is nonzero. Only row
or column permutations and nonzero row or column scalings are applied
to actual matrices. General basis changes below describe coordinates
and are not operations on the actual columns.

CF3059 and PF3059 give the common off-diagonal pair-product profile
of T[:,i]/w_i for i in S. A column outside S is singleton or zero.
MN3059 applies with exactly the fixed-column minimum just specified.
For s>=3 it excludes profiles involving at least three bottom rows;
the remaining nonzero profiles have two occupied bottom rows.

If T[r,j]!=0 and j is in S, replacing pivot row j by bottom row r
gives a nonzero permanent pivot, with permanent c*T[r,j]. Its
normal, in the new ordered row coordinates, is

    w'_j = 1,
    w'_i = T[r,i] - (T[r,j]/w_j)*w_i,  i != j.             (1)

Indeed, substituting the new row -T[r,:]X into the relation for X
gives these coefficients. The retained four X rows are independent
because w_j!=0. This verifies the normal directly, including every
zero coordinate.

In a two-bottom-row nonzero profile put w_i=1 on S by actual row
scalings. The normalized columns are (u_i,k/u_i) on those two rows,
where k and every u_i are nonzero. Let m_r count outside-S singleton
columns in bottom row r. Replacing at a value of multiplicity h
has normal support

    1 + s - h + m_r.

Minimum support therefore forces m_r>=h-1 in BOTH occupied rows.

The resulting exhaustive assembly is:

* s=1: W1_3059 gives an actual sparse A column.
* s=2: N2_3059 gives an actual sparse A column for every profile.
* s=3, zero profile: ZP3_3059 gives an actual sparse A column.
* s=3, nonzero profile: three equal values would require four
  outside singleton columns although only two exist. For multiplicity
  2+1, both occupied bottom rows have exactly one of the two outside
  singleton columns; this is FN3059's accepted fan code. Three distinct
  values are exactly DV3_3059's accepted distinct-value code family.
* s=4, nonzero profile: any repeated value would require two outside
  singleton columns although only one exists. Thus the four u_i are
  all of F5*. The remaining outside T column is zero, occupies one of
  the two main rows, or occupies a third row. These are respectively
  LC3059's single, LC3059's hook, and CC3059's conic-plus-pair cases.
* s=5: a nonzero profile would repeat one of the four nonzero values,
  contradicting m_r=0. Its profile is therefore zero.

Thus either A already has a column of support at most three, or the
chosen minimum-normal pivot has s=4 or 5 and zero common profile.
In particular singleton T columns at s=5 do NOT invoke W1_3059:
W1_3059 concerns support one of w, a different hypothesis.

This is a reduction to ZF3059, not a proof of ZF3059 or NS3059.
The references above are the existing independently reviewed project
theorems; their certificates have not been rerun or modified here.
The dimension-eight AJT premise in SP3059 and the separate
permanent-rank-at-least-six AJT case remain outside this assembly.

## Zero-profile pivot algebra (ZE3059)

Assume now s=4 or 5 and the profile is zero. Every column of T,
including the columns outside S, is singleton or zero. Partition
the five top indices into disjoint groups G_r according to the
bottom row supporting their T column, with unassigned indices
for zero T columns.

All one-through-four bottom-row replacement permanents satisfy

    per(B with rows J replaced by bottom rows R)/c
        = per(T[R,J]).                                    (2)

For one replacement this is the definition of T. For two it is
CF3059's full second-replacement identity with all k_rs=0.
For three, use TC3_3059's full vector equation V=mu*w for a pair
of removed top indices. At least two of every triple belong to S.
For such a pair, TC3_3059 gives mu=0, and its ordinary coordinates
give the third replacement permanent as the permanent of T[R,J].
The terms involving two nonzero entries in the same T column are
zero, since that column is singleton.

For four replacements, fix three removed top indices J, and take
the six rows consisting of all four bottom rows and the two top
rows outside J. Expand a six-permanent on the five B columns and
one X column. The resulting vector W obeys W^T X=0. Its coordinates
are

    W_i = D4[J union {i}] - sum_r T[r,i]*D3[other rows,J],
                                                      i not in J,
    W_i =                 - sum_r T[r,i]*D3[other rows,J],
                                                      i in J.

The established third-replacement identity makes each exceptional
coordinate W_i, i in J, zero: the unique row that could support
T[:,i] has been removed from the competing three-row permanent.
Some index in J belongs to S, so W=mu*w implies mu=0.
The remaining coordinates give (2) for four replacements.
All equations used are full six-permanent equations, not merely
their pair-product consequences.

Because T has singleton columns, the right side of (2) is nonzero
exactly when the removed top indices choose one index in each
of the chosen bottom groups. Its value is the product of those
nonzero T entries; there is only one matching. This describes
EVERY nonzero five-row pivot on the fixed five columns.

A single admissible swap at (r,j) preserves the zero profile.
For each remaining old bottom row q!=r, its new T row is unchanged
(with zero in the new j position), since T[q,j]=0. The old top
row j, which becomes a bottom row, has T entries

    T'[old j,j] = 1/T[r,j],
    T'[old j,i] = T[r,i]/T[r,j],  i!=j.

These follow from the two-replacement formula, or from moving
the original top row inside the permanent. All new T columns
are again singleton or zero. Disjoint-group swaps can therefore
be performed successively without a zero intermediate pivot.

Equivalently, in F5[x_1,...,x_9]/(x_i^2) the product of the five
actual B-column forms is

    c * product_{i=1}^5 (x_i + sum_r T[r,i]*x_{5+r}).       (4)

All coefficients of this identity are precisely the row replacement
permanents in (2). The singleton-column condition makes each summand
inside a factor have support at most two. Identity (4) is about the
product, not about its five actual linear factors: it does not imply
that those actual columns themselves have support two.

## A finite catalogue of actual row spaces (ZC45_3059)

Normalize w to (1,...,1,0,...,0), with s initial nonzero entries.
This is achieved by scaling top row i by w_i on S, not by taking
linear combinations of actual columns. Describe its top row space
by four coordinate forms:

    s=5: e1,e2,e3,e4,-e1-e2-e3-e4;
    s=4: e1,e2,e3,-e1-e2-e3,e4.

The bottom row r of N is minus the T-weighted sum of the top rows
in G_r. If a value a!=0 occurs h times among T[r,i], i in S,
equation (1) and minimum support give

    h <= 1 + number of nonzero outside-S entries in row r. (3)

For s=5, every group's nonzero coefficients are pairwise distinct.
For s=4, the same holds except in the one group that might contain
index 5. In that exceptional group each nonzero value may occur
at most twice. If index 5 is unassigned there is no exceptional
group. Empty bottom groups give actual zero N rows.

The ordinary group types are multisets of distinct elements of
F5*, modulo common nonzero scaling. They have sizes one through
four. Exceptional groups consist of index 5 with coefficient one
and a multiset of at most four F5* elements with multiplicity at
most two, again modulo common scaling on the S coefficients.
The coefficient at index 5 can be normalized independently
because w_5=0, by scaling that actual top row.
Permuting S indices and bottom rows makes the order of ordinary
groups immaterial. Unassigned S indices complete the count to s.

These finite rules cover EVERY actual minimum-normal zero-profile
pivot under consideration. They are necessary conditions, not an
assertion that every catalogue code extends to a matrix A. The
catalogue deliberately retains any extra codes satisfying only
the single-swap inequality; eliminating such an over-approximation
would still prove the requested implication.

`zero_profile_final.py` constructs this catalogue, retains actual
nine-row support data, and uses explicit row-space isometries only.
An isometry means a coordinate matrix H in GL4 and a generalized
row permutation R with C*H=R*C'. For actual N=C*G this merely
rewrites the description as R*C'*(H^-1*G); no operation is performed
on its four actual columns. Codes already covered by independent
actual-row-space theorems are cited, not recomputed.

The new full-replacement certificates, if completed, must settle
every remaining code, including invertible choices of its actual
four-column basis and actual complementary columns. A census
prefix, a surviving coordinate model or a failed completion search
does not certify ZF3059.

The first exact catalogue contains 97 disjoint-group signatures.
Explicit actual-row isometries, rather than numerical rank or support
histograms alone, identify equivalent codes and previously accepted
codes. Counts after adding all accepted conic interfaces are recorded
in `zero_profile_final_codes.json`. Full native censuses are restricted
to the genuinely new domains.

The first inspected Jacobian table contract was unsuitable for F5:
its validator requires a proper-extension field presentation although
the advertised schema did not expose that modulus-length bound.
`jacobian_zero_profile_table_payload.json` and its structured
INVALID_REQUEST response are preserved. They supply no mathematical
conclusion. A separately discovered and inspected prime-field rank
operation checks one literal new nine-row code only.

## A stronger physical-zero pair bound (Z1Q3059)

Let four independent actual columns N of an invertible nine-by-nine
F5 matrix vanish in one row. Suppose all six-permanents vanish.
On the other eight rows let F be their squarefree quartic, let
C be multiplication by F into degree five, and put K=ker(C).
Let Phi be the symmetric pair map on K whose components are the
five-row permanents using three of the four N columns and two
variable columns in K. Then

    dim ker(Phi) >= 3.                                    (5)

No hypothesis on rank(CN), rank(YP), or density of N is required.
This strengthens the previously accepted physical-zero injective-map
obstruction: nullities one and two are excluded as well.

Write m for the omitted row of the five complementary actual
columns M. It is nonzero. The four-N/two-M six-permanents give

    m_a (CM_0)_b + m_b (CM_0)_a = 0,  a!=b.

If m has support at most two, at least three actual M columns
have zero omitted entry and lie in K. They are independent modulo
N, hence linearly independent in K. Taking a nonzero omitted
entry from another M column, the three-N/three-M six-permanents
force Phi to vanish on all three pair products of those independent
columns. These three symmetric tensors are independent, proving (5).

If m has support at least three, the displayed equations force
CM_0=0. The five M_0 columns p_a therefore lie in K and span a
space U of dimension at least four: deleting one row lowers
rank(M)=5 by at most one. The off-diagonal tensors p_a*p_b, a<b,
span a space E of dimension at least

    dim Sym^2(U) - 5 >= 10 - 5 = 5.

Indeed, the induced symmetric-square map from a five-dimensional
coefficient space onto Sym^2(U) is surjective, and discarding the
five diagonal basis tensors lowers its image dimension by at most
five. This argument uses actual columns, not a changed actual basis.

For every component of Phi, the three-N/three-M six-permanents
say its off-diagonal quadratic coefficients q_ab satisfy

    m_a q_bc + m_b q_ac + m_c q_ab = 0

for every distinct triple. The squarefree-quadratic annihilator
of such a supported m has dimension at most two, as in the
accepted scalar cubic bound used in ZP3L3059. Here is a direct
verification. Rescale its nonzero coefficients to one. Coefficients
q_ab involving an index outside its support vanish: equations on
two supported indices and that index force all incident
coefficients to zero, since there are at least three supported
indices and 2 is invertible. Equations on one supported index
then kill coefficients with both indices outside the support.
For support three the only remaining condition is the sum of
three coefficients, giving dimension two. For support four the
opposite-edge coefficients agree, with their three values summing
to zero, again giving dimension two. For support five apply
the four-index conclusion to every four-set: all ten coefficients
agree, and a triple gives 3q=0, hence q=0 in F5.
Consequently dim Phi(E)<=2.
Since dim E>=5, ker(Phi) has dimension at least three. QED.

Thus a literal rank minor of order dim Sym^2(K)-2 excludes an
entire physical-zero completion, even in the defect-zero branch.
The realizable four-pairs-plus-singleton control has pair nullity
six, so it is correctly retained rather than incorrectly excluded.

## Full row-code completion certificate (ZK45_3059)

There are 60 exact actual-row isometry classes in the 97-signature
catalogue. Ten classes map by literal isometries to accepted row-space
theorems: four to ZP3K3059, three to TP3K3059 and three to ZQ3059.
The other 50 classes have six codes with three physical zero rows,
23 with two, 15 with one, and six with none. The independent exhaustive
check visits every one of the 17^5 singleton-or-zero T assignments
for both normal supports and recovers exactly the catalogue.

For each new code, the native census enumerates every independent
unordered projective basis of its four-dimensional coordinate space
whose four actual columns have support at least four. Normalizing and
permuting the four actual columns is safe: these operations preserve
all permanent vanishing and both actual support conclusions. No
general invertible operation on actual columns is used.

The necessary filters and completion implications are:

* Three zero N rows: Z3_3059 forces the squarefree quartic to be zero.
  The census exports every such dense independent basis, not merely
  witnesses of low rank.
* Two zero N rows: their two M rows are independent. Applying the
  four-N/two-M equations to each forces CM_0=0. Each nonzero
  solution space is a line uniquely determining its row form,
  so the solution spaces for two independent row forms have zero
  intersection. Thus rank(C)=rank(CN) on the other seven rows.
  When the N quartic is nonzero, the six-minors with both zero rows
  force every order-two permanent of those M rows to be zero.
  Their support is one common pair: an independent column pair
  makes its two symmetric linear conditions nonsingular, forcing
    every other column to vanish in both rows. This leaves three actual M columns
  zero in both rows. These three columns lie in K=ker(C), are
  independent modulo N, and retain their full actual supports.
  A zero N quartic would require a separate completion argument;
  the program explicitly leaves that case unresolved.
* One zero N row: the four-N/two-M equations give rank(CM_0)<=1,
  hence rank(C)-rank(CN)<=1. Z1Q3059 excludes pair-map nullity
  at most two even in the defect-zero case. For defect one the
  omitted M row has support at most two, leaving three actual M
  columns in K with full actual supports. A defect-zero case of
  larger pair nullity is explicitly unresolved, not passed to an
  unjustified dense-retained-column test.
* No zero N row: each proportional row pair gives the accepted
  DP3059 quotient bound after deleting that pair. Choose a filter
  of defect one when one exists: the M-row difference then has
  support at most two, and three actual M columns lie in the
  retained kernel lifted with equal entries at the omitted pair.
  If all defects are zero, a retained kernel with two free omitted
  entries still contains at least three actual M columns. The
  projection and actual support checks use all nine rows. No
  rank-four assumption on the seven-row N block is used.

Three independent vectors give three independent pair tensors.
Thus in any branch actually supplying three such M columns, a
pair-map rank minor of order dim Sym^2(K)-2 contradicts their pair
equations. Otherwise the full cubic certificate tests every dense
actual projected-independent compatible pair and every compatible
third-column kernel. The five-minor systems are retained whenever
required by a deleted row pair or a physical-zero row; they are
not replaced by second-cofactor equations.

For a six-row zero quartic, the cubic map D consists of multiplication
by each three-N-column product into degree four. If D is nonzero,
the six-minors on all three zero rows force their rank-three M block
L to have every three-column permanent zero. If L has no zero
column, ZL3059 makes its common row-pair cubic annihilator zero,
so the full six-minors force every active M column into ker(D).
If rank[N,ker(D)]<6, this contradicts invertibility. If L has a
zero column, some nonzero order-two permanent of L and the full
six-minors force that actual M column into ker(D). Such a permanent
exists because L has rank three. Indeed, otherwise take an
invertible three-by-three submatrix and put an invertible two-by-two
minor in its upper left corner. Its four entries are nonzero.
The two symmetric equations with the third column force that column to vanish in
the first two rows, and similarly for the third row in the first
two columns. Invertibility makes the remaining diagonal entry
nonzero, contradicting a vanishing order-two permanent against
either diagonal entry of the two-by-two minor.
The actual M column lies outside
the span of N by invertibility. If ker(D) has no dense vector
outside N, that actual column is sparse. This is exactly the
rank/support criterion recorded in each zero-quartic certificate.

`zero_profile_final_completion.py` records disjoint actual-row orbits,
literal nonzero rank minors and complete full-cubic obstructions.
Its explicit unresolved labels are mathematical gaps, not errors
or full-matrix witnesses. The complete primary census covers all 50 new domains and
798,245,851 independent unordered projective dense-column bases.
It retains 11,807 models, including 41 zero quartics, and their
full completion certificates cover 1,125 disjoint actual-row orbits.
There are no unresolved completion records:

| Obstruction | Orbits |
|---|---:|
| Independent-actual-triple pair rank | 989 |
| Physical-zero pair nullity at most two | 120 |
| No compatible dense actual triple under the full cubic systems | 13 |
| Zero-quartic cubic rank and actual-support criterion | 3 |

In particular there is no two-zero-row zero quartic and no unclosed
one-zero-row defect-zero model of larger pair nullity. The corresponding
guards in the source remain explicit; they are not silently treated as
successful obstructions.

The separate coefficient algorithms are pair-product convolution and
Ryser's formula. Their per-domain outputs and complete model exports
are compared byte-for-byte, apart from the declared algorithm name,
by `test_all_complete_censuses_and_exports_agree`. The first timed-out
independent job is not an exhaustion certificate; completed domains
are preserved and only unfinished domains are continued.

The independent arithmetic verifier reconstructs each row action as
an actual-row monomial isometry, proves exact disjoint orbit coverage,
recomputes the actual kernel lifts and their quotient defects, checks
the precise five/six-minor systems, and evaluates every displayed
nonzero minor by integer determinants reduced modulo five. For the
13 remaining full-cubic records it recomputes every coefficient and
every compatible actual third-column kernel, including the full
nine-row support and quotient-independence tests. For zero quartics
it recomputes D, its kernel, and every possible dense vector outside N.
Its use of independent arithmetic is not independent Reviewer approval.

The certificate can be checked from this campaign directory with

```bash
PYTHONPATH=research /home/argustest/zimo/argus-live-update/.venv/bin/python \
  -m unittest test_zero_profile_final test_zero_profile_final_certificates
```

The generator, both native coefficient methods, all fifty domain
outputs and exports, and every orbit certificate are retained beside
the verifier. This is a universal finite certificate for the stated
row-code families, not a random search or a bounded prefix.

## Assembly of the universal sparsity assertion

Suppose NS3059 is false for A. Then every column of both A and A^-1
has support at least four. Permanent rank five supplies a nonzero
order-five pivot. Choose a minimum-normal row pivot over all nonzero
row pivots on its fixed five column indices. FA3059 reduces it to
normal support four or five with zero common profile.

ZE3059 and ZC45_3059 place the four actual complementary columns
in the 97-signature catalogue. The ten accepted row-space classes
give the required sparse column by ZP3K3059, TP3K3059 or ZQ3059.
In every other class, actual column normalization and permutation
put their independent dense basis in the complete new census.
The necessary full-permanent filters place it in the retained
model export. A recorded actual-row monomial isometry transfers
it to one of the 1,125 certified representatives, without changing
invertibility, permanent rank or either actual support conclusion.
The preceding full completion obstructions then either contradict
invertibility or force an actual sparse column. This proves ZK45_3059,
then ZF3059, and contradicts the assumed failure of NS3059. QED.

The improvement over the strongest prior result is the removal of
the entire minimum-normal support-four/five zero-profile complement,
not another named-pivot case or a finite exclusion inside that
complement. The accepted support-three and nonzero-profile results
now combine into the universal permanent-rank-five sparsity theorem.
This does not prove AJT in dimension eight, the permanent-rank-at-least-six
case in dimension nine, or unrestricted AJT in dimension nine.

## Literature boundary

The separate bounded primary-source lookup found no readable theorem
implying NS3059. Kisley--Shader, DOI 10.23952/cot.2025.49,
Theorems 1.3 and 4.8, prove the half-rank lower bound and the
even-rank exact-equality classification, respectively; Section 5
explicitly leaves the odd near-equality classification open.
The target rank nine and permanent rank five is not their even
equality case.

Nagy--Pach, arXiv:2107.03956v1, reports Yu's bound n<2^(p-2);
at p=5 this does not cover dimensions eight or nine. The 2026
Nagy--Pach paper arXiv:2604.26320v1 supplies a conditional
group-ring implication, not this sparsity theorem. The relevant
2026 preprint DOI 10.20944/preprints202608.1194.v1 remains
unobtainable from its primary version and download endpoints
(HTTP 403 in the independent lookup). No result from it is
adopted.

This was a bounded lookup, not an exhaustive survey. Absence of
a matching readable theorem does not verify novelty. Originality,
publishable significance and final proof correctness still require
the normal Host-invoked independent Reviewer.
