# Complete nonexistence of the P0 current-donor bridge

**Theorem.** Let \(F=F(a,b,c,d,e)\) and let
\[
\beta(a)=a^{-1}eba,\qquad
\beta(b)=a,\quad\beta(c)=b,\quad\beta(d)=c,\quad\beta(e)=d.
\]
There is no finite word \(v\in F\) and no integer \(k\) satisfying
\[
v d^k\beta(v)^{-1}=ce^{-1}.                         \tag{1}
\]

This is an exact computer-assisted nonexistence proof for the complete
specified equation, not a length-bounded search. Independent Reviewer
acceptance is pending. It is not an Andrews--Curtis counterexample or a
decision of the full P0 orbit. No publication-level novelty is asserted.

## 1. Quotient descent for every word

Work in the finite associative noncommutative algebra
\[
\mathcal A=\mathbb F_2\langle A,B,C,D,E\rangle/
             \langle\text{all monomials of length }6\rangle,
\qquad J=(A,B,C,D,E).
\]
Its basis consists of the \(1+5+25+125+625+3125=3906\)
monomials of lengths zero through five. Multiplication concatenates
monomials and discards terms of length greater than five. Thus \(J^6=0\).
Every \(1+u\), \(u\in J\), has two-sided inverse
\[
(1+u)^{-1}=1+u+u^2+u^3+u^4+u^5.
\]
The set \(U=1+J\) is therefore a finite group of order \(2^{3905}\).

Define the free-group homomorphism
\[
\mu:F\longrightarrow U,\qquad
(a,b,c,d,e)\longmapsto(1+A,1+B,1+C,1+D,1+E).
\]
This is defined on **every finite word**, irrespective of length.
For any free-group endomorphism \(\phi\), substitute
\[
X\longmapsto\mu(\phi(x))-1
\quad\text{for }(x,X)\in\{(a,A),(b,B),(c,C),(d,D),(e,E)\}.
\]
Every substituted polynomial lies in \(J\). Products of six of them
vanish, so substitution defines an algebra endomorphism
\(\widehat\phi:\mathcal A\to\mathcal A\).
The identity
\(\widehat\phi\circ\mu=\mu\circ\phi\)
holds on free generators and hence on all words. If \(\mu(w)=1\),
then \(\mu(\phi(w))=\widehat\phi(1)=1\).
Consequently \(\ker\mu\) is fully invariant, in particular characteristic.
The image \(\mu(F)\) is a finite characteristic quotient; no assumption
that it equals the larger group \(U\) is needed.

The explicit inverse to \(\beta\) is
\[
\alpha(a)=b,\quad\alpha(b)=c,\quad\alpha(c)=d,\quad
\alpha(d)=e,\quad\alpha(e)=bab^{-1}c^{-1}.
\]
Both free-group compositions are identities on all five generators.
The induced algebra substitutions are therefore mutually inverse.
Writing \(\mathcal B=\widehat\beta\), the actual substitutions used are
\[
\begin{aligned}
\mathcal B(A)&=(1+A)^{-1}(1+E)(1+B)(1+A)+1,\\
\mathcal B(B)&=A,\quad\mathcal B(C)=B,\quad
\mathcal B(D)=C,\quad\mathcal B(E)=D.
\end{aligned}
\]
The separate replay checks both inverse compositions on every algebra
basis monomial, for \(2\cdot3906=7812\) identities.

Set
\[
s=1+D,\qquad T=(1+C)(1+E)^{-1}=\mu(ce^{-1}).
\]
In characteristic two, \(s^4=1+D^4\ne1\) and \(s^8=1\).
Thus \(s\) has exact order eight. Every integer \(k\), including negative
integers, is covered by its residue \(j\) modulo eight.

## 2. Eight exact affine obstructions

For \(j=0,\ldots,7\), define the \(\mathbb F_2\)-linear map
\[
L_j(x)=x s^j+T\mathcal B(x).
\]
If (1) held, applying \(\mu\) and multiplying on the right by
\(\mathcal B(\mu(v))\) would give
\[
\mu(v)s^j=T\mathcal B(\mu(v)),\qquad L_j(\mu(v))=0.   \tag{2}
\]

For each residue, `certificate.json` supplies a linear functional
\(\lambda_j:\mathcal A\to\mathbb F_2\). Its `dual_support` lists the
monomials whose coefficients are summed modulo two. In these lists,
lowercase `a,b,c,d,e` denote the algebra variables \(A,B,C,D,E\),
not group units; the empty string denotes the constant monomial.
The support sizes for residues zero through seven are
\[
445,\ 412,\ 348,\ 430,\ 445,\ 412,\ 348,\ 430.
\]
The certified identities are exactly
\[
\lambda_j(L_j(1))=1,\qquad
\lambda_j(L_j(w))=0
\quad(1\leq |w|\leq5).                             \tag{3}
\]
The set-based `replay.py` recomputes every coefficient pairing directly.
It checks \(8\cdot3906=31248\) identities, without importing the
bit-vector generator `magnus.py` or performing Gaussian elimination.
It rejects a missing residue, repeated or out-of-range support term,
changed automorphism, changed target, or failed coefficient identity.

Every \(x\in U\) has a unique expression
\[
x=1+\sum_{1\leq|w|\leq5}x_w w.
\]
By linearity and (3), \(\lambda_j(L_j(x))=1\) for **every** \(x\in U\).
Hence \(L_j(x)\ne0\) for every augmentation-one polynomial and every
residue \(j\). In particular (2) is impossible for any word image
\(\mu(v)\). This proves (1) has no solution for any finite \(v\)
and any integer \(k\). The finite algebra bounds neither word length
nor parameter magnitude: it obstructs all possible images at once.

## 3. Exact binding to the unchanged P0 donor

The coordinates are the ones in the existing
`../ms14-twofold-kernel-defect-elimination/CURRENT_DONOR.md`, sections
2 and 5, and `current-donor.json`, entry `P0`. Neither artifact is edited.
In their original \(F(x,y)\), put
\[
R=x^{-1}y^2xy^{-3},\quad
S_{-1}=x^{-1}yx^2y^{-1}x^{-2},\quad
Q_{-1}=xS_{-1}x^{-1},\quad D_{-1}=RQ_{-1}.
\]
Write \(t=x,h=xy\), and
\[
g_i=x^{i-3}h x^{3-i}\quad(0\leq i\leq4),\qquad
g_5=xg_4x^{-1}.
\]
The exact free-word identity
\[
D_{-1}=g_1g_0g_1^{-1}g_2^{-1}g_5^{-1}
\]
gives \(tg_4t^{-1}=g_1g_0g_1^{-1}g_2^{-1}\) in the donor quotient.
For \(i<4\), \(tg_it^{-1}=g_{i+1}\) holds already in \(F(x,y)\).
With
\[
(a,b,c,d,e)=(g_0,g_1,g_2,g_3,g_4),
\]
these are exactly the automorphism \(\alpha\) above and its inverse
\(\beta\), not the P2 monodromy.

For completeness, this describes an isomorphism with
\(F_5\rtimes_\alpha\mathbb Z\), not merely a quotient approximation.
The semidirect product can be constructed directly on pairs
\((u,m)\in F_5\times\mathbb Z\), with
\((u,m)(w,n)=(u\alpha^m(w),m+n)\).
Its displayed shift relations are satisfied. In the converse direction
send \(x\) to \(t\), \(y\) to \(t^{-1}g_3\); the donor identity becomes
the last shift relation. The shifts identify
\(t^{i-3}g_3t^{3-i}\) with \(g_i\), so the maps are mutually inverse
on all generators. The free kernel is therefore exactly \(F_5\).

The target normalization is the free-word equality
\[
Q_{-1}=g_2g_4^{-1}t^{-1}=ce^{-1}t^{-1}.
\]
Also \(h=g_3=d\). Therefore the unchanged equation (8) in
`CURRENT_DONOR.md`,
\[
v g_3^k\beta(v)^{-1}=g_2g_4^{-1},
\]
is literally (1); no change of conjugator, parameter, or marking is made.
The replay checks the original lifts, both original monodromies, the
literal donor identity, all ten saved forward/backward current-donor
factor identities, and the original target normalization. It does not
rebuild or alter any old strict program.

This excludes the entire specified primitive-reference bridge
\(h^kt^{-1}\) with kernel conjugator \(v\). It does not exclude other
primitive-reference families, donor changes, or arbitrary AC programs.

## 4. Improvement and the failed lower-degree relaxation

The strongest prior P0 result in
`p0-twisted/FREE_FACTOR_OBSTRUCTIONS.md` excluded words omitting a
generator and one Nielsen free factor. The subsequent
`p0-full-support/CANCELLATION.md` controlled local cancellation but left
proper-overlap recursion open. The present theorem removes all support,
free-factor, length, and cancellation-shape restrictions on \(v\).

The accepted P2 degree-four theorem is not a hypothesis of this proof.
The P0 degree-four affine calculation actually has rank 780 on 780
nonconstant unknowns for all eight parameter residues, as recorded in
`degree4.json`. Thus that lower-degree linear relaxation has a unique
augmentation-one solution in every fiber and cannot supply (3).
Those relaxed solutions are not certified free-group word images.
The proof above instead uses the degree-five P0 identities themselves.

No external theorem or literature assumption is used, and no claim of
global AC invariance, campaign completion, or verified originality follows.

## Replay

From the campaign directory:

```sh
"${ARGUS_SKILL_PYTHON:-python3}" -B \
  research/experiments/ms14-p0-twisted-orbit-decision/replay.py
```

Only the Python standard library is needed. The replay writes
`replay.json` and reports the exact check counts.
The optional generator command is
`magnus.py --degree 5 --certificate <output.json>`.

Jacobian supplied only the supporting exact Smith calculation for
\(I-\beta_{\rm ab}\), whose diagonal is \(I_5\). Its exact request,
typed response, and adapter status are saved separately as
`jacobian-payload.json`, `jacobian-output.json`, and
`jacobian-status.json`. The adapter used server `0.14.0`, protocol
`2025-11-25`, and transport `mcp-stdio`, with exit zero, no timeout,
and no error. The replay checks the matrix directly against \(\beta\)
and verifies the two unimodular transformations. This confirms only
that abelianization cannot obstruct the equation; it is not the
nonexistence argument. The unique necessary abelian vector is
\((k,k,0,-1,k-1)\), consistent with the original donor note.
