# Statement fidelity: algebraic core of linear alignment

The claim `C_LA_CORE` is only the following universally quantified algebraic
core, not the whole conditional alignment theorem `C_LA_UNIFORM`.

* `LinearAlignment.perturbed_rayleigh_polynomial`: for real `r,R,e`, if
  `0 <= e <= 1/4`, `r <= R`, and `0 <= R`, then
  `r + R(2e+e^2) <= (r+8Re)(1-e)^2`. In the report, division by the positive
  `(1-e)^2` bounds the perturbed Rayleigh quotient. This declaration alone
  does not establish that a given matrix has that quotient bound.
* `LinearAlignment.projection_energy`: for real `r,R,delta,p`, if
  `delta > 0`, `r <= R`, `delta <= R`, `p >= 0`, and
  `(r+delta)(1-p) <= r+delta/2`, then `delta/(4R) <= p`. Here `p` represents
  squared projection norm, not projection norm. No square-root estimate
  is silently built into the formal statement.
* `LinearAlignment.bootstrap_tail`: for real `n,A,d,j`, if `A,d,j` are
  positive and `256 n^3 A^2 <= d^2 j`, the displayed rational tail estimate
  holds. The proof does not formalize the exponential Taylor lower bounds,
  identify `d` with `c0 h^4/1536`, or require `n` to be a natural number.
  The alignment application imposes those additional conditions.
* `graphExtension_projection`, `graphExtension_contains`, and
  `graphExtension_nested`: `E,V` are arbitrary complex modules.
  `R,S : E -> V` and `Y : E -> E` are complex linear maps, and
  `graphExtension R S Y = R + S (id-Y)`. A projection `P : V -> E` with
  `P R=Y` and `P S=id` gives `P T=id`. If also `Y^2=Y` and `R Y=R`,
  then `T Y=R`, so the new graph contains the required lifted image.
  If both summands take values in a submodule `Z`, their sum takes values
  in `Z`. In the report `R=R_A P_Y` and `S=T_+|_E`; the latter restriction
  is justified by `E` being a coordinate subspace of `E_+`.

The scalar declarations are over the real numbers; the graph declarations
are over the complex numbers, as required for the manuscript. There are no
extra axioms, placeholders, or theorem-specific typeclass hypotheses.
Finite dimensionality, orthogonal projections, their norm estimates,
the propagated-weight argument, and compactness of bounded finite-dimensional
families are proved or explained in the report, not formalized here.
Compiler acceptance therefore certifies these six declarations and does not
by itself certify the entire manuscript lemma or the uniformization theorem.
