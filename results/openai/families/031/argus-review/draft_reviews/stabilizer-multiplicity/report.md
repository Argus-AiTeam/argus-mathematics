# Exact stabilizer multiplicity

**Assessment: the strongest stated formula is supported by the equivariant S-unit theorem and a written character calculation.** This covers `L_MULTIPLICITY@v1` and `@v2`; the latter discloses `A_EQUIVARIANT_DIRICHLET` and is the version supported by the old engineer/reviewer judgements.

## Exact formula, hypotheses and attribution

Let \(F/K\) be finite cyclic with group \(\Delta\), let \(S\) be finite, \(\Delta\)-stable and contain infinity, and let \(\theta:\Delta\to\mathbb Q_\ell^\times\) be one-dimensional. If \(D_v\) is the stabilizer of a place above \(v\), then
\[
 \dim(\mathcal O_{F,S}^{\times}\otimes\mathbb Q_\ell)^\theta
 =\sum_{v\in S/\Delta}[\theta|_{D_v}=1]-[\theta=1].                 \tag{*}
\]
The superscript denotes the \(\theta\)-eigenspace, not invariants unless \(\theta=1\). For the faithful \(\theta=\epsilon^{-1}\) and \(S\) consisting exactly of infinity and the primes above \(\ell\), this is
\[
 r_{1,\mathrm{split}}(F/K)+r_2(K)
       +g_{\ell,\mathrm{split}}(F/K)-[\epsilon=1].
\]

The Argus argument is old `uniform_kummer_bridge.md`, Section 4, equations (4)-(6). The reference manuscript is OpenAI, October 5, 2026, revision `4eaee87548250b2682affda7d05d947c05554bae`, `build/sections/matching.tex`, proof of `prop:uniform-missed-primes`. This is a classical representation-theoretic calculation, not an independently established novelty claim.

## Decisive argument

Bass, DOI `10.1017/S0027763000026258`, Section 3, Lemma (Dirichlet, Artin--Tate), pp. 402-403, states that the rational S-unit representation plus one trivial representation is the permutation representation on the places over the finite base set containing infinity. Scalar extension to \(\mathbb Q_\ell\) and semisimplicity in characteristic zero give
\[
 [U_S\otimes\mathbb Q_\ell]=[\mathbb Q_\ell[S]]-[\mathbb Q_\ell].
\]
This remains true for ramified extensions and for fields with real places. The archived `bass1966.txt`, page-402 image and `reviewer-bass-units.txt` support precisely these hypotheses. It is an ordinary unit-representation theorem, not an assertion about the image of an \(\ell\)-adic logarithm, so it introduces no Leopoldt hypothesis.

For an orbit \(\Delta/D\) of length \(m\), let a cyclic generator shift \(e_j\) to \(e_{j+1}\) and let \(z\) be its \(\theta\)-value. The eigenvector equation forces coefficients \(a_j=z^{-j}a_0\). Closing the cycle gives \((z^m-1)a_0=0\). It has one free coefficient exactly when \(\theta\) is trivial on \(D\), and otherwise none. This proves the orbit contribution for arbitrary \(m\), not only the orders appearing in examples. Removing the added trivial representation gives the final subtraction in (*).

For faithful \(\theta\), a stabilizer is killed exactly when it is trivial. A complex place of \(K\) has trivial stabilizer; a real place remaining real also does, while a real place becoming complex has order-two stabilizer and contributes zero. At a finite place above \(\ell\), trivial stabilizer means **complete splitting**, including both inertia and residue degree, not merely unramifiedness. When \(\epsilon=1\), \(F=K\), and the formula is the usual \(r_1+r_2+g_\ell-1\). Omitting the trivial-character correction would therefore be a genuine error.

## Archived replay versus fresh Jacobian execution

The existing verifier was inspected before use. Its local replay validates the archived typed matrix output and universal recurrence identities; `../uniform-missed-primes/replay.json` records that run. It does not contact Jacobian.

Separately, this review discovered a small candidate list through the mandated adapter, inspected `matrix.symbolic.multiply.compute`'s exact request/output schemas, and executed that operation once with a 45-second bound. The saved files here are `jacobian_find.json`, `jacobian_inspect.json`, `jacobian_payload.json`, `jacobian_output.json` and `jacobian_status.json`. The payload equals the archived request, and the fresh canonical output equals the archived output.

The operation multiplies \([x-1,-1,1]\) by \([s+t,xt,1]^T\) over the declared ordered field \(\mathbb Q(x,s,t)\), obtaining
\[
 xs-s-t+1=(x-1)s-(t-1).
\]
This is the geometric-sum induction residual after a successor step. It is supplementary exact algebra, not a proof of Bass's theorem, of the place classification, or of (*).

The fresh server is Jacobian **0.14.0**, protocol **2025-11-25**, transport `mcp-stdio`, tool `math.run`. Adapter exit is **0**, timeout is **false**, structured error is **null**, and the typed result is complete (server runtime 26 ms). The adapter interpreter is `$WORKSPACE/argus-live-update/.venv/bin/python`; Jacobian was not imported into Argus. Discovery, inspection and exact payload/result/status are retained separately, not substituted for this assessment. There is no Lean compilation or kernel certificate. No gap was identified in the scoped formula.
