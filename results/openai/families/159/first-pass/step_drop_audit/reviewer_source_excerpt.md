# Primary-source passages inspected by the independent Reviewer

Source: OpenAI, *Quasipolynomial Bounds for Arithmetic Progressions*,
September 23, 2026, staged under
`research/openai_manuscript/Quasipolynomial-Bounds-for-Arithmetic-Progressions-September-23-2026/build/`.
These excerpts establish what the source asserts and which hypotheses
the audit must retain. They do not assume the manuscript's conclusions.

## SRC_CONVENTIONS

`foundations/02-symbols.tex`, quantitative conventions and Symbols and
separation:

```tex
For $T=(T_1,\ldots,T_n)$ and a multi-index $\alpha$, put
$T^\alpha=\prod_iT_i^{\alpha_i}$.  Every coefficient estimate below uses
these actual side lengths.  No bound on $\max T_i/\min T_i$ is assumed.
The height of a rational array bounds its numerators and positive
denominators.  A \emph{denominator bound} does not bound numerators.
```

```tex
A symbol is \emph{slow} if its coefficient of $t^\alpha$ has size at
most $\mathcal B(p)T^{-\alpha}$.  A symbol is \emph{rational} if all
its logarithmic coefficients have a common denominator at most
$\mathcal B(p)$; their numerators are unrestricted.  Both classes
are closed under products and inverses at bounded depth.
```

## SRC_NILTEST

`foundations/02-symbols.tex`, Definition `prelim:niltest`:

```tex
Its complexity is at most $p$ if the dimension, logarithmic heights of
the structural constants and filtered bases, and
$\log(2+\|F\|_\infty+\Lip F)$ are at most $p$, and if
\begin{equation}\label{prelim:grids}
 l\Z^d\subseteq\log\Gamma\subseteq l^{-1}\Z^d
 \quad\text{for some integer }1\leq l\leq e^p.
\end{equation}
There is no coefficient bound on $g$.
```

## SRC_LATTICE

`foundations/02-symbols.tex`, Lemma `prelim:lattice`, hypotheses:

```tex
Let $1\leq n,m\leq\mathcal P(p)$, $0\leq a\leq m$,
$T_i>0$, and $l,R,\delta^{-1}\leq\mathcal B(p)$,
where $l$ is a positive integer, $R\geq1$ and $0<\delta\leq1$.
Put $D_T=\operatorname{diag}(T_1,\ldots,T_n)$, and let $L$ be a
positive diagonal $m\times m$ matrix.  Its first $a$ entries equal
$1$, and every remaining entry is at least $T_*:=\min_iT_i$.
Let $M$ be lower unitriangular, with identity on its first
$a\times a$ block, and let $Y:\R^n\to\R^m$ be any linear map.
Suppose the lattice
\begin{equation}\label{prelim:lattice-definition}
 \Lambda=\{(D_T^{-1}h,L(Yh-Mr)):
             h\in\Z^n,\ r\in l^{-1}\Z^m\}
\end{equation}
contains at least $\delta\prod_iT_i$ vectors of norm at most $R$
with distinct $h$-coordinates.  No size bound is imposed on $M$ or
$Y$.
```

## SRC_COMMON_DERIVATIVE

`foundations/02-symbols.tex`, equation `prelim:common-derivative`
and its immediately following bounds:

```tex
 Y_h(B)=s_h+\Ad_Br_h+Z_B\pmod V.
```

```tex
The coefficients of $s_h$ in original layer $j$, parameter degree
$j-1$, satisfy $\mathcal B(p)T^{-\alpha}$ bounds.  This uses
$|h_i|\leq T_i$ when differentiating the slow symbol $A$.
The coefficients of $r_h$ have bounded denominator; integrality
of $h$ is used for $Y_h(D)$.  These claims include the horizontal
constant terms.  Pigeonhole the denominators and subtract one
retained instance of \eqref{prelim:common-derivative} from every
other instance.  The term $Z_B$ disappears, the number of distinct
shift differences is unchanged up to one, and the side and
coefficient bounds only change by controlled factors.
```

`foundations/02-symbols.tex`, Extraction of a horizontal kernel:

```tex
The subtracted identities supply the bounded lattice vectors
required by Lemma~\ref{prelim:lattice}, with a common grid for
the $r_h$; changing from the chosen rational coordinates to a
rectangular grid merely enlarges its denominator.
```

## SRC_MAIN_DEPENDENCY

`sections/00-introduction.tex`, Theorem `ap:main`:

```tex
For each fixed integer $k\ge3$ there are constants
$C_k,c_k,\varepsilon_k>0$ such that, for every $N\ge2$,
\begin{equation}\label{ap:density-bound}
 r_k(N)\le C_kN\exp\bigl(-c_k(\log N)^{\varepsilon_k}\bigr).
\end{equation}
```

`sections/03-relative-detection.tex`, relative cube argument:

```tex
If a nontrivial character had nonnegligible bias,
Lemma~\ref{prelim:step-drop} on a last-layer torus, followed by
the coefficient extraction just given and restoration of the box
scales, would contradict rank $R_j$.
```

`sections/06-active.tex`, active partner selection:

```tex
Freeze further axes that are too short for
Lemma~\ref{prelim:step-drop}.  That Lemma gives a splitting of the
pair's pure-long symbol into a rational fast algebra annihilated by
the joint top frequency.
```

`sections/08-iteration.tex`, closing the triangular increment:

```tex
Apply Lemma~\ref{ap:absolute} on a productive terminal box.
```

```tex
The dimension assertion of
Theorem~\ref{ap:increment} is
Proposition~\ref{ap:iteration:dimensions}; its width assertion and
root-cost assertion are Proposition~\ref{ap:iteration:widths}.
```

`sections/08-iteration.tex`, proof of Theorem `ap:main`:

```tex
For $\alpha=r_k(N)/N>0$, the contrapositive of
Proposition~\ref{ap:iteration:closure} gives
```
