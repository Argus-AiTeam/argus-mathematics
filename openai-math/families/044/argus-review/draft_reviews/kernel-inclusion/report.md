# ENGINEER source-fidelity assessment: kernel-inclusion

Assessment: the manuscript contains a substantive stable-pair proof of the
stated kernel inclusion. The argument is conditionally supported under its
BFN, Kirwan, and finite equivariant sheaf-theoretic interfaces; the old
inventory contains no independent proof certificate for those interfaces.

## Exact claim and source

C_KERNEL@1 states that stable-pair testing gives a coefficient-compatible
graded surjection \(B_F\to H_F^*(X)\). More precisely, for a finite quiver,
\[
G=\prod_i GL(V_i),\quad
N=\bigoplus_{a:i\to j}\operatorname{Hom}(V_i,V_j)
 \oplus\bigoplus_i\operatorname{Hom}(V_i,W_i),
\]
a commuting flavor torus \(F\), and a character \(\nu\) for which all
semistable points of \(\mu^{-1}(0)\) are stable with free gauge action, put
\[
D=\mu^{-1}(0)^{\nu\text{-stable}},\quad X=D/G,\quad
R=H^*_{G\times F}(\mathrm{pt};\mathbb C),\quad
B_F=A_F/\langle A_F^{(d)}:d\ne0\rangle.
\]
The asserted inclusion is
\[
\ker(R\longrightarrow B_F)\subseteq
\ker(R\longrightarrow H_F^*(X)).
\]
This direction induces the displayed surjection. It is not the reverse
inclusion, a closed-point assertion, or a radical-ideal assertion. Empty
stable loci are allowed.

Attribution: OpenAI, *The equivariant cohomological Hikita conjecture for
arbitrary quivers*, September 24, 2026, revision
`4eaee87548250b2682affda7d05d947c05554bae`, source root
`openai-math/preprints/The-equivariant-cohomological-Hikita-conjecture-for-arbitrary-quivers-September-24-2026`.
The precise source locators are:

- `build/sections/correspondences.tex`:
  `lem:correspondence-factorization`, `eq:neutral-word-relation`,
  `eq:finite-relation-factorization`, `eq:chain-shift`,
  `eq:chain-euler-product`;
- `build/sections/stable-pairs.tex`:
  `prop:kernel-inclusion`, `eq:stable-pair-surjection`,
  `lem:stable-section-degree`, `lem:stable-test-support`,
  `lem:quadratic-test`, `eq:stable-critical-value`,
  `eq:quadratic-restriction`.

The reference manifest is
`campaigns/9100044/MANUSCRIPTS.json`.
Both relevant TeX files match its recorded SHA-256 values:
`c70667136a5c29ce2f6eac366e1679173cae34b36f3edd9d122b6315c467e4e8`
and
`0311b4a4ee05fe673682aeb1bf83abef5228fd4f711a2183034c8186ef203f2e`.
The complete read-only measurement is 10/10 source hashes and 9/9 existing
snapshot digests matching; see the bfn-laurent-generation report for the
tables. The old reference subtree is a symlink to this source, not an
independently frozen source copy.

## Historical disposition

C_KERNEL@1 has no formal statement or filed external assumptions and was
left open in the old proof graph. It is a source-only dependency, not a
consequence of the old cut arithmetic, finite regression, or Lean
certificate. The source itself uses `prop:minuscule`, finite
correspondences, and Kirwan surjectivity. It does not explicitly invoke
`lem:polynomial-monopole-maps`. Thus the separately assigned polynomial
Hall-map interface must not be confused with the finite
correspondence-factorization lemma. Any wider dependency on that interface
remains conditional as assessed in polynomial-hall-maps; no direct
Hall-to-stable-test implication is certified here.

## Decisive source reading

### Transfer a coefficient relation to a finite category

Minuscule generation expresses a homogeneous \(u\in\ker(R\to B_F)\) as a
finite sum of positive-length words in nontrivial dressed positive/negative
subset monopoles. Taking charge zero makes each word neutral.
Commutativity permits reordering before forming the chain.

For a common lattice cutoff, the source works with proper maps
\(f_B:S_B\to L\), where \(S_B\) is the family of section lattices over a
projective lattice parameter space. A coefficient relation becomes
\[
u\rho_Z=\sum_w\Psi_w
\quad\text{in}\quad
\operatorname{Hom}^d_{G\times F,L}
  (\mathcal F_Z,\mathcal F_{\mathrm{pt}}).
\]
Each \(\Psi_w\) factors through the first minuscule lattice-family object.
Intermediate lattices need not be neutral. The shifts are
\[
q_j=2(r_{j-1}-r_j+c_j-a_j)+\deg p_j.
\]
Because a neutral endpoint has \(r_k=r_0\), the rank terms telescope and
\(\sum_jq_j=d\), the BFN degree of the neutral word. This addresses an
actual grading obligation rather than simply matching ungraded operators.

The equality of finite morphisms is not inferred just from generic
localization. The Hom group is identified with equivariant Borel--Moore
homology of \(C_Z=S_{\mathrm{pt}}\times_LS_Z\). Its orbit strata are
section bundles over affine-space bundles over partial flag varieties.
Evenness and free successive quotients imply torsion-freeness over the
torus coefficient ring. Pushforward \(C_Z\to S_Z\) identifies fixed loci;
its localized test is therefore faithful on the original homology.
Localization of chains gives precisely the product of the minuscule
Euler-numerator/tangent-denominator expressions, with translated dressings.
No loop rotation means translating a lattice introduces no coefficient
shift. This is the decisive bridge from a BFN relation to the tested
finite morphism.

### Stability kills a first step, including character-degree zero

For a global cotangent pair on a principal bundle on \(\mathbb P^1\),
stable and free at infinity, evaluating a nonvanishing positive
semi-invariant gives \(\deg\mathcal L_\nu\geq0\). If its degree is zero,
the section is everywhere semistable. Its quotient map from
\(\mathbb P^1\) is constant: invariant polynomials are constant, and a
relatively ample GIT line bundle has degree zero. The stable quotient
fiber is a single free orbit, so the pair trivializes the principal bundle
uniquely. In particular its entire topological class is zero. This last
point is needed when a regular character lies on a dimension hyperplane.

A neutral positive-length word has a step of nonpositive
character-line degree. Put that step first; its topological charge is
nonzero. For the finite test function
\[
W(n,s,p,y)=\operatorname{Res}
       \bigl(\langle p+y,n\rangle-\langle y,s\rangle\bigr),
\]
the \(y\)- and section-fiber derivatives impose
\(n\in s+L_-\) and dual-lattice membership of \(p+y\).
These conditions give a global pair on the modified bundle with value
\((s,p)\in D\) at infinity. Negative degree is impossible; degree zero
would force topological class zero. Thus the first-step test vanishes.
The source also explains support off the derivative locus on a singular
base: an invertible fiber derivative gives a product chart and zero
vanishing cycles. Smoothness of the entire Schubert union is not assumed.

### The neutral test detects the coefficient itself

On the neutral open \(U\), the section lattice is the graph of
\(A_b:L_+\to L_-\). The critical graph is \(U\times D\).
Writing its based trivialization as
\(h=1+\xi t^{-1}+\cdots\), the critical value is
\[
W_{\mathrm{crit}}
  =-\langle\xi p,s\rangle
  =\langle p,\xi s\rangle
  =\langle\mu(s,p),\xi\rangle=0.
\]
Equivariant translations turn \(W\) into the same split quadratic
\(\langle y',a'\rangle\) on both the neutral family and the identity
lattice. With the source's shifted vanishing-cycle normalization, each
test has the uniform shift \([-2r]\).
The tested identity-lattice restriction is
\[
j^*:H^*_{G\times F}(U\times D)\longrightarrow H^*_{G\times F}(D).
\]
It is \(R\)-linear and split by projection, since \(j^*\pi^*=1\).
Naturality is checked for a sheaf morphism and proper direct image, not
asserted for an arbitrary nonsmooth pullback.

All first-step tests vanish, so
\((u|_D)\smile j^*=0\). Applying this map to \(\pi^*(1)\) yields
\(u|_D=0\). Freeness identifies \(H^*_{G\times F}(D)\) with \(H_F^*(X)\)
under the original coefficient map. Kirwan surjectivity and coefficient
generation of \(B_F\) then give the claimed graded algebra surjection.

## Supported scope and concrete remaining obligations

The source addresses neutral-word grading, the degree-zero stability
case, faithfulness before localization, equivariance, the quadratic
critical value, and the actual restriction morphism. Under its stated
interfaces the argument appears sound. It proves only this inclusion;
dimension equality is a separate input.

Independently establishing the following is outside the old certificate:

1. The coefficient-preserving, arbitrary-flavor BFN minuscule formula and
   generation used to form every neutral word.
2. The finite Hom/Borel--Moore correspondence comparison, including the
   faithful localization test and compatibility of convolution,
   proper pushforward, and the stated degree shifts.
3. The equivariant proper-base-change/vanishing-cycle external-product
   formalism and its \(R\)-linear naturality used on the singular neutral
   family; these are detailed source arguments, not Lean results.
4. Ordinary and equivariant Kirwan surjectivity in this regular
   arbitrary-quiver setting. The source cites McGerty--Nevins,
   Theorem 1.2 and Corollary 1.5, and explains perturbation and
   Leray--Hirsch; this review did not independently replay that theorem.

These are specific conditional interfaces, not an allegation that a
localization-only proof proves the full result, and not a claim that the
source is automatically correct. No contradiction in C_KERNEL@1 was
found in this bounded reading.

Classification: source-only proposed argument, reconstructing established
BFN/GIT/sheaf tools; originality unverified. Native Host-invoked independent
review is required and pending. No engineer self-acceptance is made.
