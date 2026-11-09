# Statement fidelity: the finite weighted-match kernel

The declarations in `Main.lean` formalize the algebraic first and second
moments used in October `checksum.tex`, equations
`eq:checksum-sample-weight` and `eq:checksum-conditional-variance`.

All declarations quantify over an arbitrary type `iota` and a finite
support `s : Finset iota`. The function `m : iota -> Real` represents
multiplicity; `z : iota -> Complex` represents the Fourier contribution
J_rho(k). The normalizer P and total number of matches L are real numbers
assumed strictly positive. On the retained support, `hm` assumes
`1 <= m i`. Actual positive integer multiplicities, cast to the reals,
satisfy this condition. The formal statement is slightly more general:
integrality of the multiplicities is not used in the moment algebra.

In namespace `ChecksumCore`, `represented_mass_le_one` proves

    sum_{i in s} m_i / L <= 1

from `sum_{i in s} m_i <= L` and `L > 0`. Its conclusion permits matches
outside the target pattern or beyond the modulus to contribute zero:
the omitted probability mass need not vanish.

`weighted_first_moment` proves exactly

    sum_{i in s} (m_i/L) * ((L/(P*m_i)) * z_i)
      = sum_{i in s} z_i/P.

Here multiplication of a complex value by a real number is represented
by real scalar multiplication. This is the complex expected value,
not the expectation of the absolute value.

`weighted_second_moment` proves the exact identity

    sum_{i in s} (m_i/L) * norm((L/(P*m_i)) * z_i)^2
      = (L/P^2) * sum_{i in s} norm(z_i)^2/m_i.

`weighted_second_moment_le` proves that this is at most

    (L/P^2) * sum_{i in s} norm(z_i)^2.

The support may be empty. The case L=0 is deliberately outside these
declarations: in the algorithm, coverage then implies the pattern is
empty and the zero estimate is exact. Uncovered frequencies cannot be
added to the support of these theorems because they violate `hm`.

The compiler checks this finite algebra, not the table construction's
coverage, the identification of m with actual matches, the independence
of sample draws, the analytic integrals, the finite-circle transfer, or
the algorithm's cost. Those links and their hypotheses are proved
separately in `report.md`; the formal source does not claim to verify
the entire checksum theorem or either manuscript's main theorem.
