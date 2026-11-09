# Independent primary-source excerpts

Reviewer: `reviewer:dccb8f343ba8`. Read on 2026-11-06.
These are new review excerpts, not a reconstruction of an earlier command log.
Mathematical typography from the primary PDF statements is normalized below.

## A_JM_RETRACTION

Jonsson--Mustata, *Valuations and asymptotic invariants for sequences of ideals*,
Lemma 4.7, Corollary 4.8, Proposition 5.1, Corollary 5.4:
<https://aif.centre-mersenne.org/item/10.5802/aif.2746.pdf>.

> Let (Y,D) be a log-smooth pair and v in Val_X. If w=r_(Y,D)(v)
> and eta=c_Y(v), then w(f)<=v(f) for any f in O_(Y,eta).
> Equality holds if the support of V(f) is locally contained in
> the support of D at eta.

> For any log-smooth pair (Y,D) over X and any valuation v in Val_X
> we have A(r_(Y,D)(v))<=A(v) with equality if and only if
> v in QM(Y,D).

Proposition 5.1 also states integral linearity on each monomial cone and
the birational discrepancy transformation formula. The audit applies these
smooth-model results on the smooth resolution, not by treating the original
singular germ as regular.

## A_LI_IZUMI and A_LI_PROPERNESS

Li, *Minimizing normalized volumes of valuations*, version 4,
Theorems 1.1 and 3.1, Corollary 4.3:
<https://arxiv.org/pdf/1511.08164v4>.

> Assume (X,o) is a Q-Gorenstein klt singularity. There exists a positive
> constant K=K(X,o)>0 such that for any valuation v centered at o in X
> with A_X(v)<+infinity, the following inequality holds:
> A_X(v)^n vol(v)>=K A_X(v)/v(m).

> Assume (X,o) is a Q-Gorenstein klt singularity. There exists a constant
> c_1=c_1(X,o)>0 such that
> v(m) ord_o<=v<=c_1 A_X(v) ord_o,
> for any valuation centered at 0.

The audit uses the bare discrepancy A_X in both bounds. Normalizing A_X=1
gives the bounds needed in its sublevel argument; no signed-boundary
properness statement is imported.

## A_BLUM_EXISTENCE

Blum, *Existence of valuations with smallest normalized volume*, version 3,
Main Theorem and Section 7.3:
<https://arxiv.org/pdf/1606.08894v3>.

> If x in X is a closed point on a klt variety, then there exists a valuation
> v* in Val_(X,x) that is a minimizer of normalized volume.

> We claim that if (X,Delta) is a klt pair and x in X is a closed point,
> then there exists a minimizer of normalized volume over (X,Delta).

Section 7.3 explains the extension to pairs through the log-pair
subadditivity theorem and Theorem 7.2. The audit is over C and uses effective
rational klt boundaries, within this input's field and boundary restrictions.

## A_XU_QM

Xu, *A minimizing valuation is quasi-monomial*, version 2, Theorem 1.2:
<https://arxiv.org/pdf/1907.01114v2>.

> Let x in (X,Delta) be a klt singularity. Any minimizer v^m of the
> normalized volume function is quasi-monomial.

The introduction specifies an algebraically closed field of characteristic
zero. The input applies to the actual ordinary minimizer, not to an arbitrary
valuation computing a different invariant.

## A_XZ_UNIQUE

Xu--Zhuang, *Uniqueness of the minimizer of the normalized volume function*,
version 1, Theorem 1.1:
<https://arxiv.org/pdf/2005.08303v1>.

> Let x in (X,Delta) be a klt singularity, then up to rescaling, there is
> a unique minimizer v_0 of the normalized volume function.

The introduction specifies an algebraically closed field of characteristic
zero. Constrained uniqueness follows only after the audit identifies a
constrained minimizer with an actual ordinary klt minimizer.

## A_XZ_FG

Xu--Zhuang, *Stable degenerations of singularities*, version 2,
Theorems 1.1--1.2 and the opening of Section 2:
<https://arxiv.org/pdf/2205.10915v2>.

> Let x in (X=Spec(R),Delta) be a klt singularity. Let v be a minimizer
> of normalized volume on Val_(X,x). Then the associated graded algebra
> gr_v R is finitely generated.

> A singularity x in (X,Delta) consists of a normal affine variety X,
> an effective Q-divisor Delta (could be 0) on X and a closed point x in X.

Theorem 1.2(1) states quasi-monomiality, uniqueness up to rescaling, and the
induced degeneration to a K-semistable log Fano cone singularity. The audit
establishes effectivity and rationality before invoking this result.

## A_VOLUME_LIMIT

Cutkosky, *Asymptotic multiplicities of graded families of ideals and linear
series*, version 1, Theorem 1.1 (= Theorem 5.5):
<https://arxiv.org/html/1508.01938v1>.

> Suppose that R is a (Noetherian) local ring of dimension d, and N(R-hat)
> is the nilradical of the m_R-adic completion R-hat of R. Then the limit
> length_R(R/I_n)/n^d exists for any graded family {I_n} of m_R-primary
> ideals, if and only if dim N(R-hat)<d.

The excellent normal local rings used in the audit have reduced completion,
so the nilradical condition holds. The valuation ideals are graded and
maximal-ideal-primary. Squeezing adjacent integer thresholds handles real
thresholds.

## Review boundary

These passages support the stated imported inputs and their applications in
`verification.md`. They do not establish originality or the manuscripts'
remaining geometric theorems. The native `citation_check attribute` command
would additionally write its automatic archive under `research/literature/`,
outside this mission's authoritative write boundary; no such write or formal
attribution status is claimed here.
