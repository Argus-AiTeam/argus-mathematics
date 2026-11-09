# Primary-source passages used in the conditional proof

Source: L. Ambrosio and S. Honda, *Local spectral convergence in
RCD*(K,N) spaces*, **arXiv:1703.04939v1**, 15 March 2017.
Primary HTML: https://arxiv.org/html/1703.04939v1 .

The notation below is transcribed into ASCII/TeX. Section 4 starts with
a pointed measured-GH convergent sequence of RCD*(K,N) spaces, N > 1:
`(X_i,x_i,d_i,m_i) -> (X,x,d,m)`. This ambient hypothesis applies to
all the following statements.

## Theorem 4.2 (Compactness of local Sobolev functions)

> Let R > 0 and let f_i in H^{1,2}(B_R(x_i),d_i,m_i) with
> sup_i ||f_i||_{H^{1,2}} < infinity. Then there exist
> f in H^{1,2}(B_R(x),d,m) and a subsequence f_{i(j)} such that
> f_{i(j)} L^2-strongly converge to f on B_R(x) and
>
> liminf_j int_{B_R(x_{i(j)})} Gamma_{i(j)}(f_{i(j)}) dm_{i(j)}
> >= int_{B_R(x)} Gamma(f) dm.

Locator: https://arxiv.org/html/1703.04939v1#S4.Thmtheorem2 .

## Theorem 4.4 (Stability of Laplacian on balls)

> Let f_i in D(Delta,B_R(x_i)) with
>
> sup_i (||f_i||_{H^{1,2}(B_R(x_i))}
>        + ||Delta f_i||_{L^2(B_R(x))}) < infinity,
>
> and let f be the L^2-strong limit function of f [sic] on B_R(x).
> Then:
> (1) f in D(Delta,B_R(x));
> (2) Delta_{x,R} f_i L^2-weakly converge to Delta_{x,R} f on B_R(x);
> (3) Gamma_i(f_i) L^1-strongly converge to Gamma(f) on B_r(x)
>     for any r < R.

The occurrence of `B_R(x)` rather than `B_R(x_i)` in the displayed
Laplacian bound, and the second `f` rather than `f_i`, are in the
displayed primary HTML. They have no bearing on the use here: all
Laplacians are uniformly bounded on the corresponding moving balls.

> **Corollary 4.5 (Stability of harmonic functions).**
> Let f_i in H^{1,2}(B_R(x_i),d_i,m_i) be harmonic functions on
> B_R(x_i), i.e. f_i in D(Delta,B_R(x_i)) with Delta_{x_i,R} f_i = 0.
> If f_i L^2-strongly converge to f on B_R(x) with
> sup_i ||f_i||_{H^{1,2}} < infinity, then f is also harmonic on B_R(x).

Locators:
https://arxiv.org/html/1703.04939v1#S4.Thmtheorem4 and
https://arxiv.org/html/1703.04939v1#S4.Thmtheorem5 .

## Theorem 4.6 (Continuity of the local gradient operators), part (2)

> Let f_i in H^{1,2}(B_R(x_i),d_i,m_i) be an H^{1,2}-strong
> convergent sequence to f in H^{1,2}(B_R(x),d,m) on B_R(x).
>
> If g_i in H^{1,2}(B_R(x_i),d_i,m_i) converge weakly to
> g in H^{1,2}(B_R(x),d,m) in H^{1,2} on B_R(x), and if
> Gamma_i(f_i,g_i) is uniformly L^p-bounded for some p in (1,infinity),
> then Gamma_i(f_i,g_i) L^p-weakly converge to Gamma(f,g) on B_R(x).

Locator: https://arxiv.org/html/1703.04939v1#S4.Thmtheorem6 .

## Application and independent-reading boundary

The proof uses Theorems 4.2 and 4.4 on smaller concentric balls after
Caccioppoli supplies the required H1,2 bounds. It uses Theorem 4.6(2)
with p = 2, for which the local gradient bounds supply even an L-infinity
bound on the pairings. No assertion about convergence of a Dirichlet
boundary-value problem on an arbitrary ball is used.

These are passages opened by the Engineer, not an independent
attribution verdict. The three cited assumptions on C_SP still require
the Host's independent Reviewer to read and attribute them.
