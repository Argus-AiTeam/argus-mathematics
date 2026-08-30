# External Review Package: Bigelow Question 6 under two well-typed repairs

**Result ID:** 11000263  
**Prepared:** 2026-08-28  
**Reviewed claim:** a Burau nonvanishing theorem for two explicit repaired presentations  
**Question 6 status:** negative under both natural well-typed readings  
**Novelty status:** targeted searches found no prior equivalent result; priority is not certified

## Precise status

Bigelow writes that \(Z_n\) is a quotient of \(RB_n\), but the terminal
displayed relation uses \(\sigma_n\). The standard generators of \(B_n\) are
only \(\sigma_1,\ldots,\sigma_{n-1}\). Thus the literal printed display does
not define a well-typed quotient \(Z_n\).

The present work proves \(X_3\neq0\) for each of the following natural repairs:

1. \(Z_n^{\mathrm{wt}}=RB_n/\langle R_2,\ldots,R_{n-1}\rangle\), obtained by
   retaining every displayed relation whose generators exist in \(B_n\);
2. the presentation obtained by placing the terminal row \(R_n\) in
   \(RB_{n+1}\), equivalently in the compatible direct-limit scheme.

No equality between these two quotients is needed or claimed. Nonvanishing in
the larger truncation alone would not imply nonvanishing after adding
relations; the result is stronger than that shortcut because the
representation separately satisfies every relation in each repaired
presentation. Thus both natural readings give the same negative answer.

## Repaired-presentation theorem

Over \(K=\mathbb Q(q,t,u)\), the unreduced Burau representation satisfies

\[
\rho(X_k)=\left(\prod_{j=1}^{k-1}(q^j-u)\right)E_{k-1},
\]

where \(E_{k-1}\) is a nonzero rank-one matrix. Consequently,

\[
\boxed{\rho(X_3)=(q-u)(q^2-u)E_2\neq0.}
\]

The representation factors through each repaired presentation listed above;
hence \(X_3\neq0\) in each of them for every \(n\ge3\).

## Source question

Stephen Bigelow asks whether \(X_3\) equals zero in the presentation called
\(Z_n\) in Section 8 of *Braid groups and Iwahori-Hecke algebras*,
arXiv:math/0505064v1, Proc. Sympos. Pure Math. 74 (2006), 285–299,
DOI 10.1090/pspum/074/2264547.

His notation is

\[
\bar\sigma_{i_1\cdots i_k}=\sigma_{i_1\cdots i_k}^{-1},
\]

and

\[
X_2=q\bar\sigma_1+1-q-\sigma_1,
\qquad
X_k=\left(q^{k-1}\bar\sigma_{(k-1)\cdots1}
-\sigma_{1\cdots(k-1)}\right)X_{k-1}.
\]

## Burau witness

Let \(V=K^n\). Send \(\sigma_i\) to the identity except for the block

\[
B_i=\begin{pmatrix}1-u&u\\1&0\end{pmatrix}
\]

on coordinates \(i,i+1\). For \(1\le r<n\), put

\[
a_r=u^{1-r}e_r-u^{-r}e_{r+1},\qquad
b^T=-e_1^T+e_2^T,\qquad E_r=a_rb^T.
\]

Direct block calculation gives

\[
\rho(X_2)=(q-u)E_1
\]

and, for every admissible index,

\[
\begin{aligned}
(B_1\cdots B_r)a_{r-1}&=ua_r,&
(B_r\cdots B_1)^{-1}a_{r-1}&=a_r,\\
(B_2\cdots B_{r+1})a_r&=ua_{r+1},&
(B_{r+1}\cdots B_2)^{-1}a_r&=a_{r+1}.
\end{aligned}
\]

These identities prove the closed formula by induction. They also show that
both sides of every legal relation \(R_k\) have the same image. The same local
calculation separately verifies the terminal relation when it is placed in
\(RB_{n+1}\) or the direct limit.

Since \(q-u\), \(q^2-u\), and \(E_2\) are nonzero over \(K\), the claimed
nonvanishing follows.

## Structural consequence and boundary

For either repaired presentation, the relation \(X_3=0\) is not implied by its
defining relations. A corresponding quotient obtained by imposing \(X_3=0\)
therefore has nonzero kernel. This statement is conditional on the explicitly
chosen repaired presentation and is not an unconditional assertion about an
undefined literal \(Z_n\).

## Reproducibility

Run:

```bash
python verify_burau.py
```

The verifier reconstructs the matrices for \(n=3,\ldots,8\), checks the closed
form, every admissible relation, the second repair's terminal-row calculation,
and rank-one nonvanishing. Its final line is:

```text
bounded_independent_replay=passed
```

The finite replay is a regression check; the all-\(n\) proof is the local block
calculation and induction above.

## External review checklist

1. Confirm the whole-word inverse convention from Bigelow's TeX source.
2. Confirm that the printed terminal relation is not an element of \(RB_n\).
3. Check the two repaired presentations are stated exactly as intended.
4. Recompute the Burau block, inverse, braid relation, and four local identities.
5. Verify the closed-form induction and relation checks separately for each repair.
6. Confirm that no equality between the repairs is being inferred.
7. Search independently for equivalent presentations and prior results.

## Recommended public wording

> Bigelow's printed presentation has a terminal-index error. The unreduced
> Burau representation separately satisfies both natural well-typed readings
> of the displayed relation scheme and proves \(X_3\neq0\) in each. Therefore
> Question 6 has the same negative answer under both natural interpretations.
