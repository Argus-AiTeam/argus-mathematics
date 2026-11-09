# Coefficient-uniform forest coding

## Scope and source findings

This note addresses only Lemma `q:forest-code` in
`build/quantitative/06-forest.tex` of the staged September 24, 2026
manuscript. It does not establish either correlation theorem, the arithmetic
rank saving, singleton cancellation, or the subsequent analytic transfers.
No false manuscript assertion has been identified in this investigation.

The relevant source statements have been read:

* `04-paths-trace.tex`, Definition `q:prohibited`, defines the deleted positive
  paths; `q:mixed-difference` specifies lit consistency and the hybrids.
* `05-rank-witness.tex`, equations `q:formal-offsets` and `q:rank-pair`, uses
  **joint** independence of both vectors of every selected pair. Replacing
  this by independence of the difference vectors would change the problem.
* `06-forest.tex`, `q:block-intervals`, supplies interval-shaped occurrences
  and nonzero subinterval displacement. The proof below needs only the
  weaker nonzero **run** sum.
* The strongest directly relevant prior result is the manuscript's own
  forest-code argument. The result below gives its coefficient-free
  formulation, a concrete decoder, an explicit finite code bound, and an
  explicit absolute constant in its specialization.

For comparison, Pilatte, arXiv:2310.19357v3, Definition 10.4 and Lemma 10.7,
counts words with bounded multiplicities and few letters with variable
neighbours, up to relabelling. The source was opened at
<https://arxiv.org/html/2310.19357v3#S10.Thmtheorem7>. Its bound is
`n^{O(t^3)}` for `t`-predictable words, not the arbitrary-coefficient theorem
below. We do not use that result as a proof dependency or claim that this
comparison establishes global novelty. An initial search response suggested
other proposition numbers; those suggestions were not verified and are not
used. The project Wiki index contained no relevant forest-coding result.

A fixed-coefficient bound alone is an insufficient route: uniformly bounded
individual fibres can have an arbitrarily large union. This rejected route
is a logical warning, not a purported error in the manuscript.

## The all-length structural theorem

Fix integers `n >= 1`, `r >= 1`, `B >= 0`, and `I >= 0`. A pattern is a
partition of the ordered positions `[0,n)`, or equivalently its
restricted-growth word. Include a pattern in `A(n,r,B,I)` if it has the
following witness.

1. There is a field `K`, a finite label set `Z`, and coefficients `t_a` in
   `K`. In `V = K^Z` put
   `v(i) = sum_{a<i} t_a e_{z_a}`, including the terminal offset `v(n)`.
2. There is a set of lit positions, and at most `B` disjoint nonempty
   consecutive blocks of lit positions. At most `I` positions are outside
   these blocks. The blocks and the lit set are witness data, not fixed
   across the patterns being counted.
3. Within each block, each label's occurrences form an interval. The sum
   of the `t_a` over every maximal constant run in a block is nonzero.
4. There are no `r` lit-occurrence pairs
   `(e_z, v(i)-v(i'))` whose displayed `2r` vectors are jointly independent.

The field, coefficients, block choices, and lit designations may all vary
over the union. There is one numerical-data-free code space with

    |A(n,r,B,I)| <= 2^(10n+3) (2n)^((6r-4)B+I).                 (1)

It has an explicit decoder. A canonical injective encoding of patterns is
obtained by taking the first code decoding to the pattern in the finite
lexicographic ordering specified below. In particular (1) is a union bound,
not a supremum of fixed-coefficient bounds.

### 1. Maximal pairs and quotient saturation

Choose an inclusion-maximal jointly independent collection of `m` pairs.
Then `m < r`. Let `D` be their span; `dim D = d = 2m <= 2r-2`.
Choose a basis of `V/D` from the coordinate images. Its labels are regular;
the other `d` labels are omitted.

For a regular label `z`, its image `u_z` is nonzero. If two lit starts had
difference outside `D + K e_z`, adjoining their pair would increase the
independent list by two, contrary to maximality. Thus all its lit starts
belong to one affine line

    ell_z = bar(v(i)) + K u_z.

The regular directions are jointly independent, so lines belonging to
different regular labels are distinct. This argument uses neither the size
nor the sign of a coefficient. It also works in positive characteristic;
the nonzero-run hypothesis must, of course, hold in that field.

### 2. Segments and an incidence forest

Compress each block into runs. Each omitted label has at most one run in
each block. Consequently the number `O` of omitted runs and the number `S`
of nonempty regular segments satisfy

    O <= d B,                 S <= (d+1) B.                  (2)

A regular run of label `z` begins and ends on `ell_z`, and its endpoints
are distinct because its total quotient increment is
`(sum_run t_a) u_z != 0`. Each transition between consecutive regular runs
is therefore an intersection point of their two lines.

Form a simple bipartite graph with one vertex for each regular line used
in a segment and one vertex for each distinct transition point. Include
the edges actually used by transitions, identifying repeated lines and
points. Include isolated line vertices needed for one-run segments.
There are at most `n` line vertices and at most `n` point vertices.

This graph has no cycle. Indeed a simple cycle visits distinct lines,
with independent directions. The difference between the two distinct
adjacent points on each visited line is a nonzero multiple of its
direction. Summing these differences around the cycle gives zero,
contradicting independence. This proof includes cycles of length four.

A segment gives an alternating walk in this forest. A reversal at a point
would repeat an adjacent run label. A reversal at a line would make that
run's two endpoints equal. Neither can occur. A nonbacktracking walk in a
forest is its unique simple endpoint path: if it revisited a vertex, the
shortest closed subwalk would either be a cycle or an immediate reversal.
It follows that the ordered pair of endpoint line vertices recovers the
entire segment. Equal endpoints recover precisely a one-run segment.

### 3. Concrete code and decoder

The parameters `n,r,B,I` are public and are not part of a code.

* Four length-`n` bit masks specify outside-block positions, block starts,
  run starts, and omitted/regular run status. Status bits are repeated
  across a run; invalid mask combinations are rejected.
* Give a rooted ordered version of the incidence forest, with line/point
  type bits, numbering vertices in preorder. Any choice of roots and child
  orders works. A deterministic witness encoder chooses the least
  first-occurrence vertex in each component as root and orders neighbours
  by first occurrence.
* In segment order, give the two endpoint preorder numbers for every
  regular segment.
* For every omitted run, give the position of its first omitted run with
  the same label.
* For every outside-block position, give a representative **position**:
  the first perfect occurrence of its label, if any, and otherwise its
  first outside-block occurrence. A representative may occur later than
  the position being encoded.

The decoder first parses the masks and forest and recovers each segment
by the unique forest path between its endpoint line vertices. It checks
that the number of line vertices on the path equals the segment's number
of runs, then repeats the decoded label for each run's recorded length.
Omitted representatives recover all omitted perfect equalities. These
labels occupy a namespace disjoint from the forest's line vertices.
Finally the positional representatives recover outside-block equalities.
A self-representative creates a new label; a non-self representative
points either to a perfect position or to such a new label. Invalid
references, nontrivial reference cycles, or conflicting data are rejected.
The output is canonically renumbered in order of first occurrence.

This gives `decode(encode_witness(w)) = pattern(w)` for every witness.
All decoder inputs are discrete; no coordinates, coefficients, primes,
signs, or padding values occur in them.

For completeness, a canonical encoder whose input is just a pattern is
also explicit (though not intended to be efficient): enumerate the finite
code space in lexicographic order and return its first code decoding to
that pattern. Existence follows from the witness encoder. If two patterns
receive one code, decoding gives their equality. This is the injective map
required to count the union over every field and every coefficient array.

### 4. Counting the very same code space

The masks cost `2^(4n)`. An ordered rooted forest with `v` vertices can be
encoded by a balanced parenthesis traversal and `v` type bits, hence by
`3v` bits. Prefix the bit string by a leading one and interpret it as a
binary integer. Since `v <= 2n`, this integer is less than `2^(6n+1)`,
and therefore belongs to a fixed space of size `2^(6n+3)`. Leading-one
framing preserves the length and makes decoding unambiguous. Unused
integers are simply invalid forest codes.

The masks determine the actual numbers `S,O,I_actual`. Record the
endpoint, omitted, and outside-block numbers consecutively and pad by
zeros to length

    E = (6r-4) B + I.

Equation (2) and `d <= 2r-2` imply

    2S + O + I_actual <= (3d+2)B + I <= E.

Each entry has at most `2n` possibilities: forest vertex numbers are
less than `2n`, and positional representatives are less than `n`.
Padding is injective because the masks determine every used length.
Multiplying the two bit-space sizes and `(2n)^E` proves (1).
This argument includes `B=0`, `I=0`, empty forests, and one-run segments.

## Specialization to the literal manuscript lemma

Take `n=2k`, `k=floor L`, `r=floor L^(1/50)` and
`s=floor L^(1/10)`. If the designated term has nonzero integrand,
the manuscript's hybrid argument produces one common configuration with
all perfect steps positive and all main vertices surviving deletion.
Every perfect position is lit in each column. The number of imperfect
positions is

    I_actual <= S_1+U <= L^(1/4)+L^(1/50).

Here a singleton column occurrence makes a position imperfect, and every
other imperfect position contains an unlit nonsingleton occurrence, so
the first inequality does not use independence of translated residues.

We spell out the geometric reduction rather than assuming it. If a
column label returns within a perfect block, choose a shortest gap across
all columns. The substring from the earlier occurrence to just before
its return has interval-shaped occurrences in every column. Positivity
at the two occurrences makes its suffix displacement divisible by that
prime. A two-step substring is impossible because the other displacement,
including its padding, omits the prime and `p` does not divide `h`.
A longer one is prohibited. Minimal contiguous descent, allowing reversal,
gives a positive deleted witness at a main vertex, a contradiction.

For a zero-displacement nonempty subinterval, length one is impossible.
In greater length its first and last tuples differ: otherwise the
interval property would make every tuple equal, violating the within-half
nonbacktracking condition. Choose a first-tuple prime absent from the last.
Deleting the first step leaves a suffix divisible by this prime. Length
two is again impossible, and greater length is prohibited. The reversed
minimal witness can start at the block's terminal vertex, which is also
a main vertex, including the initial vertex at the closed-word join.
Thus every run has nonzero displacement.

For a run of a fixed column label `z`, `D_a=p_z t_a`, with `p_z != 0`;
nonzero run displacement implies `sum_run t_a != 0`. The joint-pair
hypothesis is exactly the one in (1). All numerical restrictions on
primes and padding only shrink the witness family: no admissible word
has been replaced by an unjustified relaxation in the deduction.

Splitting the maximal perfect intervals within the two halves gives

    B_actual <= 2k/s + I_actual + 2.                         (3)

For `L >= 1024`, `s >= L^(1/10)/2`, and hence

    B_actual <= 8 L^(9/10),     I_actual <= 2 L^(1/4).

The precise bound (1) is no larger than

    2^(16n+8) (2n)^((6r+2) B_actual + I_actual).

Its power of `2n` is at most `66 L^(23/25)`. For `L>=1`,
the elementary inequality `log x <= x-1`, applied to `x=L^(2/25)`,
gives

    log(4L) <= (25/2) L^(2/25).

Indeed `log 4 < 2 < 25/2`. Also `(16n+8) log 2 <= 40L`.
Thus the log code count is at most `865L <= 1730k < 2048k`, using
`k>=L/2`. Lemma `q:forest-code` follows with the explicit absolute
constant `C=2048` for `L>=1024` (and hence throughout its stated
sufficiently-large-`L` range). Applying the same universal code in each
column gives at most `exp(2048 Jk)` combined patterns. No independence
among columns, translated residues, or padding choices is used.

## Exact and formal certification

The standalone command, run from the campaign root, is:

```sh
$WORKSPACE/argus-live-update/.venv/bin/python research/forest_coding/verify.py
```

`verify.py` uses only the Python standard library. It implements rational
row reduction, inclusion-maximal pair extraction, coordinate-image quotient
bases, the numerical-witness encoder, typed-forest framing, and the complete
coefficient-free decoder. It tests all 278 restricted-growth patterns of
length 1 through 6 with three exact coefficient arrays and three lit masks,
using the same public bounds at each length across the entire union.
The 2,502 witnesses give 1,119 distinct codes and no cross-pattern code
collision. Seven explicit fixtures cover a path and its reversal, three
concurrent independent-direction lines, imperfect-only labels, omitted
labels, zero-dimensional quotients, empty perfect sets, and a one-run block.
Five rejection checks cover missing hypotheses and invalid references.
In particular, the zero-run example is **not** a manuscript counterexample:
it violates the nonzero-run consequence of `q:block-intervals`.

The exact output is `exact_certificate.json`. The script also replays the
preserved Jacobian rational matrix rank and checks the current Lean source
and fidelity text against the successful archived certificate. The one
Jacobian operation was `matrix.rank.compute`, with its exact typed payload,
contract and output under `jacobian/`; it returned rank 2, adapter exit 0,
no structured error, protocol `2025-11-25`, server version `0.14.0`.
The portable rational implementation does not require the Jacobian service.

The Lean 4.31.0 command actually executed was:

```sh
$WORKSPACE/argus-live-update/.venv/bin/python -m argus_skill.verticals.math.lean_evidence verify research/forest_coding/Main.lean --statement-fidelity research/forest_coding/statement_fidelity.md --claim C_FOREST_FORMAL_CORE --project-root .
```

It returned `exit_code=0`, `proof_holes=[]`, and axiom-audit exit 0.
The claim-bound archive is
`certificates/C_FOREST_FORMAL_CORE-3c1ca974c1f2bf14.json`. The source and
fidelity have not been edited since that run. The kernel checks arbitrary-field
maximal-pair quotient saturation, nonzero increments and independent-vector
cycle exclusion, a universal forest endpoint decoder, the exact slot and
code-cardinality bounds, and the injection/cardinality theorem for an
arbitrary (possibly infinite) union of witnesses into one shared code
space. It does **not** assume that bounds on individual coefficient fibres
bound their union.

`statement_fidelity.md` identifies the precise remaining prose interfaces.
In particular, the whole numerical-witness encoder and its global decode
identity are not claimed to be formalized end to end; the report proves
them by the construction above. Only `C_FOREST_FORMAL_CORE` is
`closed_kernel`. The full structural theorem and manuscript specialization
are submitted as mathematical proofs for independent review, not relabelled
as kernel-closed claims.

The all-length proof is the argument above, not the finite replay. Finite
adversarial tests cannot by themselves establish (1), verify all real
coefficients, or rule out an unspecified asymptotic constant.

The mathematical improvement over the prior manuscript proof is the
field- and coefficient-uniform formulation, fully framed code with its
decoder, the bound (1), and the explicit manuscript constant. This is an
independent verification/generalization of a combinatorial step, not a
new proof of either correlation conjecture or a verified-global-novelty
claim. Independent Reviewer replay is still required.

The independent Reviewer should replay `verify.py`, read the global decoder
identity and parameter specialization, and judge `C_FOREST_UNIFORM` and
`C_FOREST_SPECIALIZATION`. The source comparison has an outstanding
independent attribution of Pilatte's Lemma 10.7; the primary passage read
is in `literature/pilatte-10.7.txt`. It is not an assumption of either
mathematical goal. No `F_` refutation claim is called for unless review finds
a false literal manuscript assertion.
