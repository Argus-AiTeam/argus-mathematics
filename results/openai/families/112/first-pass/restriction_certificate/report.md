# Independent restriction-transfer certificate

## Exact target and scope

The target is Lemma `lem:restriction` of the staged OpenAI manuscript,
`sections/02_restriction.tex`. For every finite width-at-most-k CNF H, every
integer b >= 1, and every 0 < p < 1 with

    theta = sum_{ell=b+1}^k binom(k,ell) (2p/(1-p))^ell < 1,

the lemma asks for a nonnegative restriction-dependent W, chosen independently
of G, with E W <= 1/(1-theta), such that

    |E_z G(z) H_restricted(z)| <= W corr_b(G)

simultaneously for all real-valued G. The finite clause list has no size bound.
False clauses, repeated clauses, overlapping scopes, empty formulas, empty
live sets, and k <= b are included.

## Constructive clause insertion

The expected-mass bound and clause-insertion argument are already known:
Li and Zhong, *Short Point Lists for CNFs and Stronger Constant-Depth Circuit
Hardness*, arXiv:2610.27127v1, Lemma 3.1, attribute the result to Chukhin.
The exact proposition and proof read for this comparison are retained in
`li_zhong_lemma_3_1.txt`; the primary HTML is `li_zhong.html`. The local
formalization does not import that proof or assume its conclusion.

A clause is represented by its scope S and its unique falsifying pattern a.
True and tautological clauses are discarded without changing the function.
For a restriction r, process the finite list of clauses recursively. Expansions
are finite signed lists of width-b CNFs; a repeated summand remains a separate
object. Their mass is the number of signed summands before cancellation.

For insertion of a clause C into a prefix F:

* If a frozen coordinate satisfies C, retain the expansion of F.
* If no coordinate satisfies C and no coordinate of S is live, use the empty
  expansion, representing zero.
* If the remaining live scope D has size between 1 and b, conjoin the reduced
  clause to every summand of the expansion of F.
* If |D| > b, use the expansion of F minus the expansion of F under the
  further restriction D=a, conjoined with the unit clauses D=a.

The last rule is the pointwise identity F C = F - 1[D=a] F|[D=a].
It preserves width because b >= 1. It is an identity of functions, not just
an identity tested against one G.

Write m_F(r) for the resulting mass. Set q=(1-p)/2. For each fixed restriction
outside S, let r_a be its extension fixing all of S to a. The mass difference
between F C and F, averaged over restrictions on S, is exactly

    q^|S| (sum_{D subset S, |D|>b} (p/q)^|D| - 1) m_F(r_a).

Indeed, the false-clause case removes q^|S| m_F(r_a); every hard case adds
p^|D| q^(|S|-|D|) m_F(r_a); all other cases leave the mass unchanged.
This keeps every dependence of the prefix mass on the frozen assignment.
If the parenthesized subset sum is at most one, the average cannot increase.
Induction on the arbitrary finite clause list therefore gives E m_H <= 1.
The same expansion works for every G, and the triangle inequality gives the
correlation bound with W=m_H. Thus the manuscript's existential lemma follows
with the stronger expectation bound 1 whenever theta <= 1.

This cost is not the path-defined W in equation `eq:restriction-W`; no improved
estimate for that particular W is asserted. No verification of the full
depth-three circuit theorem is implied.

## General formal theorem and manuscript corollary

`Main.lean` proves the actual construction for an arbitrary finite coordinate
type and arbitrary finite clause list, not an abstract recurrence with the CNF
steps supplied as hypotheses. `expand_correct` and `expand_width` certify the
finite pointwise signed expansion. `expected_mass_step` proves the exact
weighted insertion identity by a bijection of restriction events, and
`expected_mass_uniform` concludes the expectation bound.

The correlation maximum in the formalization explicitly ranges over supported
width-b CNFs: their clause scopes contain only live coordinates.
`restrictCNF_value`, `restrictCNF_width` and `restrictCNF_supported` construct
the restriction of any narrow test. `average_live` proves that averaging on
the full cube after ignoring frozen coordinates equals normalized averaging on
the live-coordinate cube, even when it is empty.

`independent_restriction` combines the expansion and expectation theorem with
simultaneous correlation control. `manuscript_corollary` returns one
restriction-only W before quantifying over every real-valued G and gives the
literal manuscript bound 1/(1-theta). The stronger theorem includes theta=1,
which the manuscript's stated lemma does not need.

No product of expectations or independence assumption is hidden in the
transfer. In particular, if a good event controls every narrow correlation
by epsilon and its complement has probability delta, for a test bounded
in absolute value by one the usual transfer bound is epsilon+delta:
the good contribution is at most epsilon E[W 1_good] <= epsilon E W,
and the bad contribution is bounded directly by delta.

## Exact evidence and replay

The official Lean 4.31.0 run returned **exit_code=0, proof_holes=[]**, and its
axiom audit also returned zero. It recorded mechanical evidence on
`C_RESTRICTION_INDEPENDENT`, with no external assumptions, in:

    certificates/C_RESTRICTION_INDEPENDENT-0bb9da8c1d84b528.json

The archived source and statement-fidelity document match the current files.
The only reported foundational axioms of the two main declarations are
`propext`, `Classical.choice`, and `Quot.sound`. Compiler output and the
official result are retained in `compile.log`, `lean_check.json`, and
`lean_verification.json`.

The executable replay checks 50,152 pointwise identities and 1,698 exact
mass-difference identities on 868 finite formula instances, plus explicit
theta=1 and k<=b boundary cases and normalization of tautologies and repeated
literals. These are finite checks; the arbitrary-size guarantee comes from
the general Lean proof, not enumeration.

A separate bounded Jacobian `sat.solve` check negates an overlapping-scope
insertion identity. The exact typed output is UNSAT, independently replayed
over all 1,024 total assignments with the Tseitin reduction checked against
its Boolean circuit. The first request's noncanonical-order rejection is
preserved separately as a non-conclusion; canonicalization and the successful
request each retain their exact payload, operation id, output, server version,
protocol and adapter status.

Run the standalone exact replay from the campaign root:

```bash
$WORKSPACE/argus-live-update/.venv/bin/python research/restriction_certificate/verify.py
```

It also checks the actual compiler certificate, its source/fidelity binding,
the archived proof text, and the current claim reference. To obtain a fresh
compiler run, without editing either formal file while it runs:

```bash
$WORKSPACE/argus-live-update/.venv/bin/python -m argus_skill.verticals.math.lean_evidence verify research/restriction_certificate/Main.lean --project-root . --claim C_RESTRICTION_INDEPENDENT --statement-fidelity research/restriction_certificate/statement_fidelity.md
```

## Comparison and remaining review

Compared with the staged manuscript, the independent cost has expectation at
most one rather than 1/(1-theta), with the same arbitrary-clause and
simultaneous-test quantifiers. Compared with the stronger known Li-Zhong
Lemma 3.1, the improvement delivered here is an independent, complete
machine-checked construction and faithful live-cube corollary, not a newly
discovered mathematical mass bound or a wrapper importing their conclusion.

No false manuscript assertion was found on this route. The evidence does not
refute anything merely because the constructed mass can exceed one when
theta>1; that experiment lies outside the theorem's hypothesis.

Independent Reviewer replay and statement-fidelity approval remain a separate
Host action. The prior-source comparison claim `C_LZ_COMPARATOR` also awaits
independent citation attribution of `A_LZ_3_1`; its exact read excerpt is
provided, and the certified theorem itself has no such dependency.
Publishability and novelty are not self-certified, and the whole circuit
theorem remains outside this mission's certification.
