# Obstruction for the local two-change plat family

## Proposition

The family searched by `search_two_crossing_tangle_mutants.py` cannot
contain a knot whose displayed negative mutant has unknotting number at
least three. For every pair of seed words and for either implemented
half-turn, the same two marked crossing changes also unknot the mutant.

This statement concerns only that explicitly defined local family. It
does not apply after an isotopy which makes either crossing disk meet the
Conway sphere.

## Proof

Write a four-braid word as a word in
\(\sigma_1,\sigma_2,\sigma_3\), and let
\[
c(w)=w\,w^{-1}\,\sigma_3^{-1}.
\]
Each searched tangle is obtained from \(c(w)\) by reversing one letter of
the first copy of \(w\). Its marked crossing change restores \(c(w)\).
Thus the two marked changes restore \(c(w)\) on both sides of the
closure.

For the left-right half-turn, the word action is the automorphism
\[
\alpha(\sigma_i^\epsilon)=\sigma_{4-i}^\epsilon.
\]
Consequently
\[
\alpha(c(w))
=\alpha(w)\alpha(w)^{-1}\sigma_1^{-1}
=\sigma_1^{-1}.
\]

For the top-bottom half-turn, the word action is the
anti-automorphism \(\beta\) which reverses a word. Since
\(\beta(w^{-1})=\beta(w)^{-1}\),
\[
\beta(c(w))
=\sigma_3^{-1}\beta(w^{-1})\beta(w)
=\sigma_3^{-1}.
\]

The right tangle is not mutated and reduces to
\(\sigma_3^{-1}\). Under the closure convention in the program, both
terminal pairs
\[
(\sigma_1^{-1},\sigma_3^{-1})
\quad\text{and}\quad
(\sigma_3^{-1},\sigma_3^{-1})
\]
give the same two-crossing PD code
\[
[(2,3,3,0),(1,0,2,1)].
\]
One Reidemeister-II move removes both crossings. Hence each displayed
mutant has a two-change unknotting replay, so every Alexander-module
fibre has dimension at most two. In particular, increasing the iteration
count or braid-word length cannot make this family pass the required
dimension-three lower-bound gate.
