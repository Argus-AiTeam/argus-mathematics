# Smooth upgrade of the seven-arrow PL chain

Let \(X_0,\ldots,X_7\) be the eight compact four-dimensional handle
manifolds in the aggregate certificate.  For \(X_1,\ldots,X_6\), the JSON
state shown in the certificate is the movable marked core; \(X_i\) itself
means its closure by the two pinned \(E(1)-\nu F\) caps.  The reviewed
two-port Fintushel--Stern endpoint and arbitrary-gluing results supply those
cap extensions.  Thus the first and seventh arrows are endpoint
diffeomorphisms between closed presentations, not maps obtained by literally
deleting a cap and comparing a closed manifold with a manifold having
boundary.

Let \(\alpha_i\) be the fixed smooth handle-atlas structures, and let

\[
 a_i:X_{i-1}\longrightarrow X_i\qquad(1\leq i\leq 7)
\]

be the exact orientation-preserving PL homeomorphisms certified there.  Each
\(a_i\) has the serialized two-sided inverse \(a_i^{-1}\).

## The smoothing input actually used

Milnor, *Differential Topology Forty-six Years Later*, Theorem 2.2 and
Section 4, records that compatible smoothings are unique up to diffeomorphism
in dimensions below seven and explains the obstruction groups as
\(H^k(M;\Gamma_k)\), with \(\Gamma_k=0\) for \(k<7\).  In particular, the
dimension-four uniqueness obstructions vanish.  Hirsch,
*Obstruction theories for smoothing manifolds and maps*, pp. 352--355,
defines relative concordance, proves the product theorem used for collars, and
in Theorems 4.1 and 4.2 relates concordances and diffeomorphisms.

The local files and their exact digests are recorded in
`smoothing_hypotheses.json`.  The argument below uses the empty relative
subcomplex.  Product collars handle boundaries, and corners are rounded in the
already fixed smooth handle atlases.  Thus it does **not** assert that the
auxiliary smoothing-identification maps fix every marked cell pointwise.

## Seven genuine diffeomorphisms

Define smoothings backwards:

\[
 \beta_7=\alpha_7,\qquad
 \beta_{i-1}=a_i^*(\beta_i).
\]

Then \(a_i:(X_{i-1},\beta_{i-1})\to(X_i,\beta_i)\) is a diffeomorphism by
definition of pullback smoothing.  Since \(\dim X_i=4\), smoothing uniqueness
and the concordance-to-diffeomorphism result give an orientation-preserving
diffeomorphism

\[
 h_i:(X_i,\alpha_i)\longrightarrow(X_i,\beta_i)
\]

concordant to the identity.  Choose \(h_7=\mathrm{id}\), which is possible
because \(\beta_7=\alpha_7\).  Now set

\[
 d_i=h_i^{-1}\circ a_i\circ h_{i-1},\qquad
 d_i^{-1}=h_{i-1}^{-1}\circ a_i^{-1}\circ h_i.
\]

Every \(d_i\) is an orientation-preserving diffeomorphism between the *fixed*
smooth structures \((X_{i-1},\alpha_{i-1})\) and
\((X_i,\alpha_i)\).  Direct cancellation gives

\[
 d_i^{-1}d_i=\mathrm{id}_{X_{i-1}},\qquad
 d_id_i^{-1}=\mathrm{id}_{X_i}.
\]

In the total composition all intermediate \(h_i\) cancel:

\[
 d_7\cdots d_1=h_7^{-1}(a_7\cdots a_1)h_0
                    =(a_7\cdots a_1)h_0.
\]

The displayed formula for the inverse gives both global composites equal to
the appropriate identity.

## Exact scope of the marked statement

The pointwise certificate is the exact PL chain \(a_1,\ldots,a_7\): it carries
the complete \(1/28/5/2\) handle inventory, all 36 signed cocore disks, every
recorded overlap and seam, the endpoint markings, and the two-sided inverse
data.  The maps \(d_i\) are the resulting genuine smooth arrows, concordant to
those PL representatives.  No claim is made that an existentially supplied
\(h_i\) preserves each marked cell pointwise.  This distinction prevents a
PL certificate from being mislabeled as an explicit smooth chart formula
while still proving the required smooth diffeomorphism.
