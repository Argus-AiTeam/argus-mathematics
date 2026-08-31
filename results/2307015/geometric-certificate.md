# All-strata model-domain certificate at alpha = 2/3

## Exact result

Put

\[
C=C_{2/3}=\{x+iy:0<x<|y|^{2/3}\}
\]

and define the three open sets

\[
\begin{aligned}
U_+&=\{x+iy:1<y<3,\ 0<x<y^{2/3}\},\\
U_-&=\{x+iy:-3<y<-1,\ 0<x<(-y)^{2/3}\},\\
R&=\{x+iy:1/4<x<1/2,\ -2<y<2\}.
\end{aligned}
\]

Let \(D=U_+\cup R\cup U_-\) and \(p=3/8\).  For
\(4/3<u<7/5\), define four boundary arcs

\[
\begin{aligned}
E_{v,+}&=\{iu^3:4/3<u<7/5\},&
E_{c,+}&=\{u^2+iu^3:4/3<u<7/5\},\\
E_{v,-}&=\{-iu^3:4/3<u<7/5\},&
E_{c,-}&=\{u^2-iu^3:4/3<u<7/5\}.
\end{aligned}
\]

Then \(D\) is a connected bounded Jordan domain containing \(p\).  The four
sets are nonempty open subarcs of \(\partial D\), one on each non-origin
vertical or curved boundary stratum of the single untranslated displayed set
\(C\).  For every \(z_0\) in any one of the arcs,

\[
D\cap B(z_0,1/8)=C\cap B(z_0,1/8).
\]

Consequently every relevant local component is contained in the same
translate \(0+C\), with \(z_0\in\partial C\), and each of the four arcs has
positive harmonic measure from \(p\), in fact from every pole of \(D\).

This is an exact strict-interval candidate.  It selects neither the vertical
nor curved part of \(\partial C\), and it selects neither sign of the
imaginary coordinate.

## Cross-sections and connectedness

For a real ordinate \(y\), write
\(D_y=\{x\in\mathbb R:x+iy\in D\}\).  Directly from the definitions,

\[
D_y=
\begin{cases}
(0,|y|^{2/3}),&1<|y|<3,\\
(1/4,1/2),&|y|\le 1,\\
\varnothing,&|y|\ge3.
\end{cases}
\]

Indeed, when \(1<|y|<2\), the rectangle section is already contained in
the cusp section because

\[
0<1/4<1/2<1<|y|^{2/3}.
\]

The sets \(U_+\), \(R\), and \(U_-\) are open and connected, while

\[
\begin{aligned}
U_+\cap R&=\{1<y<2,\ 1/4<x<1/2\},\\
U_-\cap R&=\{-2<y<-1,\ 1/4<x<1/2\}.
\end{aligned}
\]

Both overlaps are nonempty.  Hence \(D\) is open and connected.  Also
\(p=3/8\) lies in \(R\).

## Jordan boundary

Let \(a=3^{2/3}\).  The cross-section formula shows that \(\partial D\)
is the following closed chain, with the curved pieces parametrized
monotonically by \(y\):

\[
\begin{array}{rcl}
(0,1)&\longrightarrow&(0,3),\\
(0,3)&\longrightarrow&(a,3),\\
(a,3)&\longrightarrow&(1,1)
  \quad\text{along }x=y^{2/3},\\
(1,1)&\longrightarrow&(1/2,1),\\
(1/2,1)&\longrightarrow&(1/2,-1),\\
(1/2,-1)&\longrightarrow&(1,-1),\\
(1,-1)&\longrightarrow&(a,-3)
  \quad\text{along }x=(-y)^{2/3},\\
(a,-3)&\longrightarrow&(0,-3),\\
(0,-3)&\longrightarrow&(0,-1),\\
(0,-1)&\longrightarrow&(1/4,-1),\\
(1/4,-1)&\longrightarrow&(1/4,1),\\
(1/4,1)&\longrightarrow&(0,1).
\end{array}
\]

The two curved pieces have \(x\ge1\), the two bridge sides have
\(x=1/4\) and \(x=1/2\), and the lobe sides have \(x=0\).  Together with
their disjoint ordinate ranges, this shows that nonconsecutive pieces do not
meet.  Consecutive pieces meet only at the listed endpoint.  The chain is
therefore a simple closed curve.

Its bounded complementary component has exactly the horizontal sections
displayed above, including the bridge section at \(y=\pm1\).  Thus that
component is \(D\), so \(D\) is a bounded Jordan domain.

The boundary contains the nondegenerate segment
\(\{iy:1\le y\le3\}\), so it has positive logarithmic capacity, as required
in Problem 7.15.

## All four canonical non-origin strata

For every \(u>0\),

\[
(u^2)^3=(u^3)^2=u^6.
\]

It follows that \(u^2\mathbin{\pm}iu^3\) lies on the curved boundary
\(x=|y|^{2/3}\) of \(C\).  The points
\(\mathbin{\pm}iu^3\) lie on its open vertical boundary
\(x=0,\ y\ne0\).  Hence the four \(E\)'s occupy exactly the upper and
lower copies of the two non-origin boundary types.

The parameter interval was chosen with exact slack:

\[
\left(\frac43\right)^3=\frac{64}{27}>\frac94,\qquad
\left(\frac75\right)^3=\frac{343}{125}<\frac{11}{4}.
\]

Thus every selected point has ordinate \(y_0\) satisfying

\[
\frac94<|y_0|<\frac{11}{4}.
\]

If \(z\in B(z_0,1/8)\), then

\[
\frac{17}{8}<|\operatorname{Im}z|<\frac{23}{8},
\]

with the same sign as \(\operatorname{Im}z_0\).  In particular,

\[
2<|\operatorname{Im}z|<3.
\]

On the upper strip \(2<y<3\), only \(U_+\) occurs and it agrees with
\(C\); on the lower strip \(-3<y<-2\), only \(U_-\) occurs and it agrees
with \(C\).  Therefore, for all four arcs,

\[
D\cap B(z_0,1/8)=C\cap B(z_0,1/8).
\]

This equality is stronger than the required componentwise containment.
If connectedness of the local intersection is desired explicitly, the upper
component of \(C\) can be written as

\[
\{(x,y):x>0,\ y>x^{3/2}\},
\]

the strict epigraph of a convex function.  It is convex, as is its lower
reflection, so its intersection with a ball is connected.

Each selected \(z_0\) is on \(\partial C\), and the one fixed translate
\(0+C\) works for every point, every component, every stratum, and both
signs.

## Positive harmonic measure

Let \(\phi:D\to\mathbb D\) be a Riemann map.  Since \(D\) is a Jordan
domain, the Caratheodory boundary theorem extends \(\phi\) to a
homeomorphism \(\overline D\to\overline{\mathbb D}\).

Every \(E_{v,+},E_{c,+},E_{v,-},E_{c,-}\) is a nonempty open subarc of
the Jordan curve.  Its image under the boundary homeomorphism is therefore a
nonempty open circular arc \(J\).  For any pole \(q\in D\), conformal
invariance and the disk Poisson formula give

\[
\omega_D^q(E)
=\frac1{2\pi}\int_J
\frac{1-|\phi(q)|^2}{|\zeta-\phi(q)|^2}\,|d\zeta|.
\]

The integrand is strictly positive and \(J\) has positive arclength.
Therefore

\[
\omega_D^q(E_{v,+})>0,\quad
\omega_D^q(E_{c,+})>0,\quad
\omega_D^q(E_{v,-})>0,\quad
\omega_D^q(E_{c,-})>0
\]

for every \(q\in D\), especially for \(q=p=3/8\).  This is a proof of
strict positivity, not a finite numerical experiment.

## Published-definition scope

The source unquestionably asks that every relevant local component be
contained in a translate of the complete displayed \(C_\alpha\).  The
construction satisfies that printed clause with equality locally and with one
fixed translate.  It also satisfies the reviewed boundary-contact condition.

Unlike the prior disk and fixed-cusp witnesses, which used curved contact, and
the half-plane witness, which used vertical contact, this one simultaneously
realizes all four non-origin canonical strata.  No choice between vertical
and curved contact, or between positive and negative height, is needed.
The origin-only reading is already incompatible with the source's endpoint
disk assertion by the independently reviewed pinned-to-angular obstruction.

There remains one precise statement-fidelity boundary.  The previously
reviewed predicate \(Q(X,Y)\), and similar proper-sublocus rules, can reject
all target-alpha contacts.  Such a predicate is not printed in Problem 7.15:
it is an additional relative-coordinate condition rather than a choice among
the boundary strata of the displayed set.  This certificate does not import
one.  It shows instead that rejecting all four arcs requires adding such an
extra proper-sublocus convention.  Whether the publication permits that
addition, or admits the whole unmarked boundary as displayed, is the sole
independent source-fidelity judgement still needed before promoting `OBJ`.

Thus the exact geometric and harmonic-measure candidate is established here;
the project-final published-set claim is not declared closed by the Engineer.

## Exact replay and Jacobian record

Run from the campaign directory:

```text
/home/argustest/zimo/argus-latest/.venv/bin/python \
  research/routes/all-strata-model-domain/verify_certificate.py
```

The replay uses only integer and `fractions.Fraction` arithmetic.  It checks
the strict alpha range, the bridge overlaps and pole, the arc parameter and
height intervals, the radius-\(1/8\) local strip, the curved-boundary
polynomial identity, and the preserved typed Jacobian response.

After bounded discovery and exact contract inspection, Jacobian operation
`arithmetic.real_quadratic.order.compute` compared \(17/8\) with \(2\).
Jacobian 0.14.0 returned `GT` with exact difference \(1/8\), no adapter
error, and no timeout.  The discovery candidates, exact input and output
schemas, operation id, payload, typed result, protocol, server version,
runtime, and adapter status are preserved in `jacobian-evidence.json`.
The operation checks one exact local-strip inequality; the universal Jordan
and harmonic-measure arguments are the prose proof above.
