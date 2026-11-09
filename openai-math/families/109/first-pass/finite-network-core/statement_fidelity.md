# Statement fidelity: finite-network structural core

`Main.lean` uses Lean 4.31.0 and Mathlib. It proves structural ingredients of
section 03 of the staged September 23, 2026 manuscript, not its main
complexity theorem. The claim bound to this file is `C_STRUCTURAL_LEAN`.

All declarations are in `FiniteNetworkCore`.

* `forward` is exactly the eight forward rows of `eq:motif-schedule`, in order.
  `transparent_restoration` quantifies over arbitrary additive commutative
  groups X,Y,A,C, arbitrary additive maps V,G,J,R of the indicated types, and
  arbitrary x,y,a,c. It proves the final tuple is
  (x, y+J(V(x))+R(G(x)), a, c). Thus it does not assume zero scratch, commuting
  maps, a field, or a particular dimension. The separate incidence calculation
  in the report identifies JV+RG with identity for the two triple networks.
* `signed_exchange` quantifies over every additive commutative group and every
  x,y, proving the three shears (y+=x, x-=y, y+=x) give (-y,x). It is not a
  theorem with the second shear pointing in the wrong direction.
* `common_frame_gate` applies to every semiring, module, finite input index
  type, linear map D, scalar coefficient family, and vector family. Its
  conclusion is commutation of a common address frame with the weighted gate
  sum. `edge_frame_change` states cancellation of an invertible old frame
  followed by a new frame. These justify the all-input invariant; the file
  does not encode the entire network graph or claim to have checked its
  incidence enumeration.
* `nested_projection_difference` holds in any possibly noncommutative ring.
  Given idempotents p,q with pq=qp=p, q-p is idempotent, annihilates p in both
  orders, and adds to p to give q. `orthogonal_sum_projector` proves the
  analogous sum statement from pq=qp=0. For the manuscript these are
  endomorphisms of a bilinear space and orthogonal projections.
* `residual_image` quantifies over every additive commutative group, two
  additive idempotents p,q with both nesting identities, and every z. It
  identifies the image of q-p with image(q) intersect kernel(p), pointwise:
  existence of x with q(x)-p(x)=z iff z is in image(q) and p(z)=0. It is not
  merely an equality of formal dimension counts. Orthogonality, finite
  dimension, and the rank interpretation are supplied in the mathematical
  report.
* `nonzero_scalar_image` quantifies over every field, module, linear map p,
  nonzero scalar c and vector z, proving image(c p)=image(p), pointwise. With
  c=2 in Q, it certifies the image claim required for the N negative-source
  edges. It does not assert this for c=2 in characteristic two.
* `bit`, `weight`, `overlap`, and `xorVector` use Bool coordinates indexed by
  any finite type and integer (not modulo-two) sums. `bit_xor` and
  `weight_xor` prove the exact Hamming-weight identity. In
  `orthogonal_weight_additivity`, the hypothesis that integer overlap is
  twice an integer is exactly zero binary dot product. The existential
  multiple of four in the conclusion is equality modulo four. No bound on
  dimension or Hamming weight is imposed. Induction over an orthogonal
  basis in the report supplies the residual phase formula.
* `odd_line_endpoint_phase` quantifies over arbitrary integers w,r,b, with r
  odd, and proves w-2rb is congruent to w+2b modulo four. The intended b is
  the integer representative of u dot x, w is wt(x), and r=wt(u)=27. Its
  slightly stronger unrestricted b does not weaken the application.

Not formalized here: construction and classification of binary bilinear
spaces, the tensor-label incidence list, finite-dimensional ranks, Walsh
conjugation, the Gaussian 2-by-2 matrices, or tape/analytic/complexity claims.
The report and exact Python replay cover the first five items in this list
of omissions. Compiler success alone does not establish those assertions,
statement fidelity, independent review, or novelty.
