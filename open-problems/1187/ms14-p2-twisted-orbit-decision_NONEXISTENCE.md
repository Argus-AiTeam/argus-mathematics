# Complete nonexistence of the P2 current-donor bridge

**Theorem.** In the free group \(F(p,q,r)\), let
\[
\beta(p)=r^{-1}p,\qquad \beta(q)=pq^{-1},\qquad \beta(r)=q.
\]
There are no finite words \(z\) and integers \(k\) satisfying
\[
z r^k\beta(z)^{-1}=p r^{-1}p^{-1}.                    \tag{1}
\]
The certificate below is a computer-assisted exact proof, not a bounded
search over conjugators. Independent Reviewer acceptance remains required.
It closes only this bridge mechanism, not the full Andrews--Curtis orbit.

## 1. A finite characteristic quotient, without a word-length bound

Let
\[
A=\mathbb F_2\langle P,Q,R\rangle/
       \langle\text{all monomials of length }5\rangle,
\qquad J=(P,Q,R).
\]
The monomials of lengths zero through four are a basis: \(\dim A=121\),
\(\dim J=120\), and \(J^5=0\). Multiplication is concatenation, dropping
terms of length greater than four. Every element of \(1+J\) is a unit:
\((1+u)^{-1}=1+u+u^2+u^3+u^4\).
Thus \(U=1+J\) is a finite group of order \(2^{120}\).

Define the homomorphism
\[
\mu:F(p,q,r)\longrightarrow U,\quad
\mu(p)=1+P,\quad\mu(q)=1+Q,\quad\mu(r)=1+R.
\]
This maps **every** finite word, with no bound on its length.
For any free-group endomorphism \(\phi\), substitution
\[
P\mapsto\mu(\phi(p))-1,\quad
Q\mapsto\mu(\phi(q))-1,\quad
R\mapsto\mu(\phi(r))-1
\]
defines an algebra endomorphism \(\widehat\phi\): each substituted
polynomial is in \(J\), so all length-five products remain zero.
On generators, hence all free words,
\(\widehat\phi\mu=\mu\phi\).
Consequently \(\ker\mu\) is fully invariant and in particular
characteristic. The image \(G=\mu(F)\) is a finite characteristic
quotient. We need not enumerate \(G\): the certificate excludes solutions
even in the larger group \(U\).

Write \(s=1+R\), \(t=\mu(pr^{-1}p^{-1})\), and \(B=\widehat\beta\).
Explicitly,
\[
B(P)=s^{-1}(1+P)+1,\quad
B(Q)=(1+P)(1+Q)^{-1}+1,\quad B(R)=Q.
\]
The inverse free-group map is
\(\alpha(p)=qr,\ \alpha(q)=r,\ \alpha(r)=qrp^{-1}\).
Both free-group compositions are identities; its induced substitution
is therefore inverse to \(B\). The replay also verifies both compositions
on all 121 algebra basis elements.

In this ring \(s^4=1+R^4\ne1\) and \(s^8=1\). Its exact order is eight,
so positive and negative integer \(k\) are covered by the eight residues.

## 2. Eight dual certificates exclude every element of \(U\)

For \(j=0,\ldots,7\), define the linear map on \(A\)
\[
L_j(x)=x s^j+t B(x).
\]
Applying \(\mu\) to (1), and multiplying on the right by \(B(\mu(z))\),
would give \(L_j(\mu(z))=0\), where \(j\equiv k\pmod8\).

`certificate.json` gives a linear functional \(\lambda_j:A\to\mathbb F_2\)
for each residue. A `dual_support` list specifies the monomials whose
coefficients are summed modulo two; lowercase `p,q,r` in these lists
mean the algebra variables \(P,Q,R\), not the group units.
The exact finite identities certified are
\[
\lambda_j(L_j(1))=1,\qquad
\lambda_j(L_j(w))=0
\quad\text{for every monomial }w\text{ with }1\le |w|\le4.       \tag{2}
\]
There are \(8\cdot121=968\) such identities, all checked directly by
`replay.py`, independently of the Gaussian-elimination generator.
The support sizes for residues \(0,\ldots,7\) are respectively
\(16,15,46,16,16,15,46,16\).

Every \(x\in U\) has the unique form \(x=1+\sum_{1\le|w|\le4}a_w w\).
Linearity and (2) give \(\lambda_j(L_j(x))=1\), whereas
\(\lambda_j(0)=0\). Thus \(L_j(x)\ne0\) for **every** \(x\in U\) and
every residue \(j\). This proves the theorem for every finite \(z\) and
every integer \(k\).

## 3. Binding to the unchanged current-donor problem

The existing `../ms14-twofold-kernel-defect-elimination/P2_TRAIN_TRACK.md`,
`p2-exact/ATTEMPT.md`, and `CURRENT_DONOR.md` are reused, not rebuilt.
Their marking is \(p=ab,q=b,r=c\), with inverse \(a=pq^{-1}\).
It takes \(\beta(a)=c^{-1}aba^{-1},\beta(b)=a,\beta(c)=b\) to the
automorphism above, and \(abc^{-1}b^{-1}a^{-1}\) to \(pr^{-1}p^{-1}\).
The lifts in the original \(F(x,y)\) are
\[
p=x^{-1}y^2x^{-1},\quad q=yx^{-1},\quad r=xyx^{-2}.
\]
The replay checks these data against the existing `p2-train-track.json`.

For every integer \(k\), the bijection \(v=z r^kq^k\) gives
\[
v a^k\beta(v)^{-1}
=z r^kq^ka^ka^{-k}q^{-k}\beta(z)^{-1}
=z r^k\beta(z)^{-1}.
\]
Its inverse is \(z=vq^{-k}r^{-k}\); no commutations are used.
The exclusion therefore also covers the entire original P2
current-donor equation, rather than only selected conjugator families.

The strongest prior result excluded natural block truncations on two
boundary rays and left internal cuts and terminal branches unresolved.
The present quotient certificate excludes all conjugators at once.
It does not assert nonexistence of other donor changes, an all-AC
invariant, an Andrews--Curtis counterexample, or novelty beyond this task.

## Replay and supporting calculation

From the campaign root:

```sh
"${ARGUS_SKILL_PYTHON:-python3}" -B \
  research/experiments/ms14-p2-twisted-orbit-decision/replay.py
```

Only the Python standard library is needed. The replay uses sparse
monomial sets and direct coefficient pairing, does not import `magnus.py`,
does not search for conjugators, and fails if a residue or coefficient
identity is missing. `magnus.py --certificate <path>` can reconstruct the
dual data, but is unnecessary for acceptance.

Jacobian was used only for the supporting abelian calculation:
`matrix.normal_form.smith.certified.compute`, exact request in
`jacobian-payload.json`, typed response in `jacobian-output.json`.
It certifies \(I-\beta_{\rm ab}\) as unimodular, so abelianization alone
cannot separate the equation. It is not the nonexistence proof.
The pinned adapter reported server version `0.14.0`, protocol
`2025-11-25`, transport `mcp-stdio`, adapter exit status zero, no timeout,
and no error; its execution metadata is in `jacobian-status.json`.
No external theorem or literature assumption is used in the proof.
