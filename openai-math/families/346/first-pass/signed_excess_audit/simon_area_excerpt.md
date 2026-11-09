# Area formula actually consulted

Leon Simon, *Introduction to Geometric Measure Theory*, NTU lecture notes,
last updated March 7, 2018, Chapter 3, Section 2, equations (2.4)-(2.5),
printed page 93.

Primary source: https://math.stanford.edu/~lms/ntu-gmt-text.pdf
Local primary PDF: `research/signed_excess_audit/simon_2018.pdf`.
The PDF preface identifies the March 7, 2018 revision.

The section assumes that \(M\) is \(\mathcal H^n\)-measurable,
has locally finite \(\mathcal H^n\) measure, and is countably
\(n\)-rectifiable. The map \(f\) is locally Lipschitz on an open set
containing \(M\), with target dimension at least \(n\).

The text states:

> We note also that if \(h\) is any non-negative
> \(\mathcal H^n\)-measurable function on \(M\), then, by approximation
> of \(h\) by simple functions, 2.4 implies the more general formula

\[
 \int_M hJ_f^M\,d\mathcal H^n
 =
 \int_{\mathbb R^{n+k}}
       \left(\int_{f^{-1}(y)}h\,d\mathcal H^0\right)d\mathcal H^n(y).
 \tag{2.5}
\]

In the present application \(f=\pi\), \(h\) includes integer
multiplicity and a nonnegative test, and the target has dimension
exactly \(m\). Taking the critical set in (2.4) also gives
Lebesgue-null projected image for the deficient-rank set.
