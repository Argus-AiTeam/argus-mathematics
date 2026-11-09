# Twenty-one source-action polynomial identities

**Engineer assessment: supported as exact symbolic identity verification,
not as certification of the target geometry or the entire leading relation.**

## Exact algebraic claim

The relevant part of `lem:action-tables` in Section 3 of the pinned
September 23, 2026 manuscript is the **source** table. The old Argus checker
`source_action_checks` models it in the free associative algebra
`F2<X,Ui,Uj,Uk>`, for distinct incident/nonincident index types. Brackets
are commutators. Define

    H=X^2, Vh=[X,Uh], Rh=[H,Uh],
    Q=[H+Vi,Ui], D=[Vi,Uj]+[Ui,Vj].

The derivation `delta` sends `X` and `Ui` to `Vi`, and `Uj,Uk` to zero.
The derivation `epsilon` sends `Ui,Uj` to `[Ui,Uj]`, and `X,Uk` to zero.
The three actions are

    a=delta^2, u=epsilon, v=delta*epsilon+epsilon*delta.

The exact claims checked are:

| Input | a | u | v |
|---|---|---|---|
| H | [H,Vi]+[Ri,Ui] | 0 | [H,[Ui,Uj]] |
| Ui | Q | [Ui,Uj] | [Ui,Vj] |
| Uj | 0 | [Ui,Uj] | [Uj,Vi] |
| Uk | 0 | 0 | 0 |
| Vi | [H,Vi]+[[Vi,Ui],Ui] | D | [Vi,Vj]+[D,Ui]+[Ui,Rj] |
| Vj | [Q,Uj] | D | [Vi,Vj]+[D,Uj]+[Uj,Ri] |
| Vk | [Q,Uk] | 0 | [D,Uk] |

This is a universal polynomial identity assertion with explicit
characteristic two, not a numerical experiment at selected weights.

## Decisive computation

The old checker separately builds the derivations by the Leibniz rule,
composes them, expands every commutator into associative words, subtracts
each displayed expected expression, and reduces every coefficient modulo
two. Distinct free-associative words are linearly independent; a zero
coefficient dictionary proves the asserted polynomial equality. In
characteristic two `delta^2` and the derivation commutator
`delta*epsilon+epsilon*delta` are derivations, which is consistent with
these source actions.

Current `replay.py` executes only the old pure algebra routines using
`runpy.run_path` under a non-main name. It never calls the old build,
restoration, compiler, or ledger-writing entry points. The resulting
`algebra_replay.json` records all 21 identity names and a successful
execution. No saved success label was used as the computation itself.
The replay also supplies the separate base-case and boundary outputs
assessed in their own units; nesting them in one JSON does not merge
their mathematical roles.

## Attribution and limits

The mathematical formulas are from the manuscript at revision
`4eaee87548250b2682affda7d05d947c05554bae`. The old Argus contribution is
a small exact expansion checker and auxiliary evidence, not a claimed new
theorem. The current work replays that checker; it does not pretend to be
a second implementation or a Lean-verified proof of the Python algorithm.

The supported assertion is exactly the displayed source formulas under
these derivation definitions. Connecting those actions to every required
source-algebra relation, checking the target action table, proving count
monotonicity, and verifying the deletion representation are separate
obligations in the neighboring units. Equality of these 21 polynomials
cannot establish them by itself. There is no unresolved residual in this
specified algebraic check and no manuscript error identified by it.
Native independent review of the overall assessment is still required.
