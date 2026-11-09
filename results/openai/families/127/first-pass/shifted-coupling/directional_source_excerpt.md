# Nutz--Wang source excerpt and scope

Source: Marcel Nutz and Ruodu Wang, *The Directional Optimal Transport*,
arXiv:2002.08717v2, read at
<https://arxiv.org/html/2002.08717v2>.

Section 2 works with probability measures `mu <=_st nu` on the real
line and directional couplings `P` supported on `X<=Y`. In
Theorem 2.2, the integrability hypothesis is marginal integrability
of the reward. The following are the relevant source statements:

> **Theorem 2.2(ii), (v).** "P is optimal for all (mu,nu)-integrable
> and submodular g." ... "P = P_*."

> **Proposition 2.6.** "The optimal coupling P_*(mu,nu) satisfies"
>
> `P_*(mu,nu) = Id(mu wedge nu) + P_*(mu',nu')`
>
> "where" `mu' = mu - mu wedge nu` "and"
> `nu' = nu - mu wedge nu` "are the mutually singular parts".

The full source also states the identity coupling as
`Id(mu wedge nu)=(mu wedge nu) tensor_x delta_x`.
The proposition does not assume atomlessness. In contrast, the
single-crossing discussion in Example 4.5 assumes densities;
it is comparison, not a discrete-law assumption in our proof.

These are background statements, not an external dependency of the
self-contained shifted-potential argument. Their attribution requires
an independent reader, not the Engineer who recorded the assumption.
