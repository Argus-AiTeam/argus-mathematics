# Effective graph-subgroup obstruction and profinite rigidity

## Scope and status

The object audited is `thm:procyclic` in the staged manuscript
`build/sections/05-profinite.tex`, especially `lem:kernel-abelianization`
and equation `eq:graph-subgroup-count`. All groups and homomorphisms below
are profinite and continuous when appropriate. Subgroups in a counting
sum are actual subgroups, not conjugacy classes.

The graph count in the manuscript is correct. The result proved below
replaces its qualitative nonzero-limit contradiction by a uniform finite
index and an exact valuation. It verifies the purely profinite theorem;
it does not verify `thm:pro-characters`, `lem:hom-integrality`,
`thm:subgroup-congruence`, the rational gluing corollary, or `thm:main`.
No false manuscript assertion is claimed on the basis of a failed
strengthening or a finite search.

Prior to this work the campaign ledger contained only the overall audit
objective and no mathematical evidence. The manuscript already proves a
qualitative obstruction. The mathematical improvement here is the
explicit formula (4), its uniform index (5), and the specified integral
virtual-set detector, not a claim to have originated lattice enumeration,
finite-abelian duality, or the manuscript's rigidity theorem.

The classical lattice generating function is attributed in the manuscript
to H. Tamanoi, *Generalized orbifold Euler characteristic of symmetric
products and equivariant Morava K-theory*, AGT 1 (2001), 115--141,
doi:10.2140/agt.2001.1.115, Lemma 5-5. We prove the needed formula below;
the citation is attribution, not an unproved input. Literature retrieval
and novelty findings are recorded separately below. The elementary
finite-group, compactness, module, and duality facts used in the proof
are also justified here rather than assumed from an unopened reference.

## 1. Exact graph bijection

Let \(K\) be any finitely generated pro-\(p\) group and
\(L=\mathbb Z_p^d\), where \(d\geq1\). Let \(c_h\) count the open
subgroups of \(K\times L\) of index \(p^h\) whose projection to \(K\)
is onto. Write \(a_j(d)\) for the number of index-\(p^j\) open
subgroups of \(L\).

For such a subgroup \(H\), define
\[
 V=\{k:(k,0)\in H\},\qquad W=\operatorname{pr}_L H .
\]
The intersections with the embedded factors are open, so \(V\) and
\(W\) are open. Compactness makes their projections closed. Lifting
each \(k\in K\) to \(H\), and using that the second factor is central,
shows that \(V\) is normal in \(K\). For \(w\in W\), the coset \(kV\)
of a lift \((k,w)\in H\) is unique. Thus
\[
 H=\{(k,w):w\in W,\ kV=f(w)\}
\]
for a unique surjective continuous homomorphism
\(f:W\to K/V\). Conversely, this formula constructs one subgroup for
each such \((V,W,f)\), and recovers precisely its \(V,W,f\).
In particular \(K/V\) must be abelian.
Continuity follows also from the compact-to-Hausdorff isomorphism
\(H/V\to W\).

The graph has index \(|K/V|\) in \((K/V)\times W\). Hence
\[
 [K\times L:H]=[K:V][L:W],\qquad
 c_h=\sum_{\substack{V\trianglelefteq_o K\\ [K:V]=p^i,\ i\leq h}}
 a_{h-i}(d)\,|\operatorname{Sur}(\mathbb Z_p^d,K/V)|.       \tag{1}
\]
Every open \(W\leq L\) is a free \(\mathbb Z_p\)-module of rank \(d\);
an isomorphism with \(L\) gives the displayed number of maps.
There is **no automorphism divisor** in (1). Postcomposing \(f\) with
a nonidentity automorphism changes its graph unless it fixes every
value, which surjectivity excludes.

For clarity, the alternative parametrization uses
\(W'=H\cap L\), not \(\operatorname{pr}_L H\): it gives a graph
\(K\to L/W'\) with no surjectivity requirement and index \([L:W']\).
Confusing these two meanings of \(W\) would give a false formula;
the manuscript does not make that confusion.

## 2. Finite-abelian quotient sum

Suppose \(K^{ab}=A\) is finite, with \(|A|=p^b\).
Only \(V\) containing the closed commutator subgroup contribute to (1).
They correspond to the actual subgroups \(B\leq A\).
Set
\[
 s_i=\sum_{\substack{B\leq A\\|A/B|=p^i}}
       |\operatorname{Sur}(\mathbb Z_p^d,A/B)| \quad(0\leq i\leq b).
\]
Then
\[
 \sum_{i=0}^b s_i=|A|^d=p^{bd}.                           \tag{2}
\]

Here is a proof including the duality step sometimes hidden in this
identity. Decompose a finite abelian \(p\)-group \(Q\) into cyclic
factors. The pairings on these factors
\((x,y)\mapsto xy/p^e\pmod{\mathbb Z}\) identify \(Q\) with its
character group \(Q^*=\operatorname{Hom}(Q,\mathbb Q/\mathbb Z)\).
They separate points and have exactly \(|Q|\) characters.
Every character of a subgroup extends: adjoining an element \(x\)
with least \(n>0\) such that \(nx\) lies in the existing subgroup,
choose an \(n\)-th root of the prescribed value at \(nx\) in
\(\mathbb Q/\mathbb Z\). Iterate over the finite group.
Consequently duality is exact. A surjection to \(Q\) dualizes to
an injection \(Q^*\to(\mathbb Q_p/\mathbb Z_p)^d\), and conversely.

Choose \(e\) annihilating \(A\). All these injections land in
\((C_{p^e})^d\). Thus the left side of (2) also counts
homomorphisms \(A\to(C_{p^e})^d\), partitioned by their exact kernel
\(B\). There are \(|A|^d\) such maps by the cyclic decomposition.
Self-duality is used for each quotient; an arbitrary nonabelian
quotient cannot be substituted here.

## 3. Integral stabilization and effective obstruction

Lifting one generator of the first-coordinate image of a sublattice
in \(\mathbb Z_p\times\mathbb Z_p^{d-1}\), modulo its intersection
with the other coordinates, gives
\[
 a_j(d)=\sum_{a+m=j}p^m a_m(d-1),\qquad
 \sum_{j\geq0}a_j(d)t^j=\prod_{u=0}^{d-1}(1-p^u t)^{-1}.
\]
The initial rank-one coefficients are all \(1\).
Put
\[
 D_d=\prod_{u=1}^{d-1}(1-p^u)\in\mathbb Z,\qquad p\nmid D_d .
\]
The empty product is \(1\). The coefficients \(b_m\) of
\(\prod_{u=1}^{d-1}(1-p^u t)^{-1}\) are divisible by \(p^m\);
also \(a_j(d)=\sum_{m=0}^j b_m\). Reducing this identity and the
product identity modulo \(p^{j+1}\) allows evaluation at \(t=1\)
because every omitted coefficient is zero in that quotient ring.
Therefore
\[
             D_da_j(d)\equiv1\pmod{p^{j+1}}.              \tag{3}
\]
An equivalent finite induction, used by the Lean development, adjoins
the factor \((1-p^d t)^{-1}\). Each summand error is divisible by
\(p^{dk+j-k+1}\), hence by \(p^{j+1}\), and the finite
geometric-series remainder is \(p^{d(j+1)}\).

For every \(h\geq b\), combine (1)--(3), noting that \(i\leq b\):
\[
 D_dc_h-p^{bd}
   =\sum_{i=0}^b s_i\bigl(D_da_{h-i}(d)-1\bigr)
       \ \in\ p^{h-b+1}\mathbb Z.                       \tag{4}
\]
This is a universal integer congruence, not a numerical experiment.
In particular, at every
\[
                    h\geq b(d+1)
 \quad\text{one has}\quad v_p(c_h)=bd.                   \tag{5}
\]
Indeed, (4) says \(D_dc_h=p^{bd}(1+pz)\). Both \(D_d\) and
\(1+pz\) are \(p\)-adic units. Formula (5) also applies to the
formal case \(A=1\), although a nontrivial finitely generated pro-\(p\)
group cannot have trivial abelianization.

## 4. An explicit integral detector

For nontrivial finitely generated \(K\), let
\(F=K/\Phi(K)\cong(C_p)^r\), where \(\Phi(K)\) is the intersection
of the kernels of maps to \(C_p\). This is finite and \(r\geq1\).
If \(K^{ab}=A\) is finite, \(r\leq b\).

Every nontrivial finite \(p\)-group has a quotient \(C_p\).
One elementary proof uses the nontrivial center (from the class
equation), induction on the order after quotienting a central subgroup
of order \(p\), and the abelian case. A maximal subgroup of a finite
\(p\)-group is normal of index \(p\): induction through a central
order-\(p\) subgroup either reduces to a quotient, or the group is
the product of that central subgroup with the maximal subgroup.
If a proper closed \(J<K\) surjected onto \(F\), separate a point
of \(K\setminus J\) in a finite quotient, and contain the image of
\(J\) in a maximal subgroup there. Its inverse image is an
index-\(p\) kernel containing \(J\), a contradiction. Thus
\[
                  J\to F\text{ onto}\ \Longrightarrow\ J=K.
\]

Let \(\mu(S,F)\) be the Mobius function of the finite subgroup lattice,
defined by
\(\sum_{S\geq T}\mu(S,F)=1\) if \(T=F\), and \(0\) otherwise.
The following is an integral virtual \(F\)-set:
\[
       Y=\sum_{S\leq F}|S|\mu(S,F)[F/S]=|F|e_F^F .
\]
Since \(F\) is abelian, its mark at \(T\) is
\(|F|\sum_{S\geq T}\mu(S,F)\). Hence its underlying cardinality
is zero and its only nonzero mark is \(|F|=p^r\) at \(F\).
Inflate it to \(E=K\times\mathbb Z_p^d\).
The detector property and closedness of the projection of a compact
subgroup show that its mark at \(H\) is \(p^r\) exactly when
\(\operatorname{pr}_K H=K\).

The manuscript congruences are additive, so apply to this integral
virtual set if they apply to all finite sets. At the explicit index
\(h=b(d+1)\), they would require
\[
 p^{h+1}\mid p^r c_h,\qquad
 v_p(p^r c_h)=r+bd\leq b+bd=h,
\]
which is impossible by (5). For integers, membership in
\(p^{h+1}\mathbb Z_{(p)}\) is exactly this divisibility.
Thus finite abelianization is impossible under the actual hypotheses
of `lem:kernel-abelianization`. Using a virtual set is legitimate:
if every actual finite set had divisible sum, every integral
linear combination would too.

## 5. The shrinking-action bridge

Suppose \(K\times\mathbb Z_p^d\) has all the subgroup congruences
and the finite-section generator bound \(l\), and let
\(K\to\mathbb Z_p\) have kernel \(N\).
Every closed subgroup is generated by at most \(l\) elements:
each finite quotient of a closed subgroup is a section of a finite
quotient of the original group (choose an open normal subgroup whose
intersection is contained in the prescribed kernel). The nonempty
closed subsets of \(H^l\) consisting of generating tuples for each
finite quotient have the finite intersection property. Compactness
gives a tuple generating \(H\). In particular \(N\) is finitely
generated.

Choosing a preimage \(x\) of \(1\in\mathbb Z_p\) splits the
epimorphism. Indeed the closure of \(\langle x\rangle\) is a
procyclic pro-\(p\) group, hence a quotient of \(\mathbb Z_p\);
its nonzero closed kernels are \(p^a\mathbb Z_p\) and give finite
quotients. A procyclic group mapping onto \(\mathbb Z_p\) is
therefore \(\mathbb Z_p\), and this map is an isomorphism.
Write \(K=N\rtimes_\alpha\mathbb Z_p\).

For an action degree \(M\geq1\), let
\[
 O_M=\bigcap_{\rho:N\to\Sigma_M}\ker\rho .
\]
Finite generation makes the intersection finite, open, and
characteristic. Choose \(p^a\geq M\). A \(p\)-element of
\(\Sigma_M\) has order at most \(p^a\), because the order is the
largest of its \(p\)-power cycle lengths. The action on \(N/O_M\)
becomes trivial on \(p^s\mathbb Z_p\) for all sufficiently large \(s\):
the action is continuous and its target is finite.

For these \(s\), both
\[
 E_s=(N\rtimes_{\alpha(p^s-)}\mathbb Z_p)\times\mathbb Z_p^d,
 \qquad E_\infty=N\times\mathbb Z_p^{d+1}
\]
have the same quotient
\[
 Q_M=(N/O_M)\times(C_{p^a})^{d+1}.
\]
Every map from either group to every symmetric group of degree
at most \(M\) factors through this *specified* quotient. Its
restriction to \(N\) kills \(O_M\); each cyclic coordinate kills
\(p^a\mathbb Z_p\). Padding by fixed points covers smaller degrees.
Each \(E_s\) is isomorphic to an open subgroup of the original
group, so has both inherited properties.

To transfer a congruence, fix \(U\leq_o E_\infty\), a nonempty
finite \(U\)-set \(X\), and \(h\geq0\). Set \(m=[E_\infty:U]\)
and choose \(M\geq\max(m,m|X|,mp^h)\).
The coset action of \(U\), the induced action on
\(E_\infty\times_U X\), and the coset actions of *all* its
index-\(p^h\) subgroups factor through \(Q_M\). Thus \(U\) and
each such subgroup contain the quotient kernel, and that kernel
acts trivially on \(X\). Both the \(U\) subgroups and those of
the corresponding \(U_s\leq E_s\) biject with the same actual
subgroups of \(\overline U\leq Q_M\). Fixed-point counts on
the same \(\overline U\)-set \(X\) agree term by term.
This proves the congruence for \(U\). Empty \(X\) is immediate.

Finally every finite quotient of \(E_\infty\), using its regular
action, is a quotient of \(Q_M\) for \(M\) sufficiently large,
and therefore of \(E_s\). Every finite section is a section of
one of these finite quotients, so the generator bound transfers too.
This verifies the full shrinking-action lemma, not merely transfer
of tests on the whole group.

## 6. Universal proof of `thm:procyclic`

The trivial-group conclusion is immediate if its hypotheses are
given. For nontrivial \(\Gamma\), finite abelianization of order
\(p^b\) would give
\(|\operatorname{Hom}(\Gamma,C_{p^q})|=p^b\) for all sufficiently
large \(q\), contradicting the assumed integrality after division
by \(p^q\). Only cyclic target groups are needed for this step.

A finitely generated abelian pro-\(p\) group is a quotient of
\(\mathbb Z_p^m\) by a closed submodule. The diagonal-basis
argument over \(\mathbb Z_p\) gives a finite torsion part and
a free part: choose an entry of least valuation in a matrix of
submodule generators, use row and column elimination, and induct;
submodules are finitely generated by the same least-valuation
induction on \(m\). A nonzero free part therefore follows from
infinite cardinality. Thus \(\Gamma\) maps onto \(\mathbb Z_p\).
Extract this quotient and use Section 5.

After \(d\geq1\) steps there is a closed subnormal kernel \(K_d\)
such that \(K_d\times\mathbb Z_p^d\) has both transferred
properties. It is finitely generated by the section bound. If
\(K_d\ne1\), Sections 1--4 force infinite abelianization, and
the preceding module argument supplies another split
\(\mathbb Z_p\) quotient. Continue using Section 5.

Whenever \(K_d\ne1\), it has a quotient \(C_p\), so the product
has a quotient \((C_p)^{d+1}\). Its generator number is exactly
\(d+1\), by elementary linear algebra. The bound forces
\(d+1\leq l\). Consequently the construction ends with \(K_t=1\)
for \(t\leq l\). The successive quotients are \(\mathbb Z_p\).
In a finite quotient their images give cyclic successive quotients,
possibly trivial; delete repetitions. This proves precisely the
claimed \(\ell(P,1)\leq l\).

The kernel argument is universal. Finite computations below test its
identities and implementations but are not the proof of this theorem.

## 7. Certification boundary

The standalone verifier and exact certificate are in this directory.
The Lean source formalizes universal lattice stabilization, weighted
graph-count stabilization, and the explicit divisibility obstruction;
its exact hypotheses and omissions are specified in
`statement_fidelity.md`. In particular a Lean arithmetic theorem
is not a formalization of arbitrary topological groups or of the
character construction. The topology, duality interpretation of the
weights, and detector interpretation are proved in Sections 1--6.

Independent Reviewer replay and judgement are required. No Engineer
judgement in the ledger is independent acceptance. Novelty of the
effective bound, and publishable significance of this refinement
rather than of the already-stated rigidity theorem, remain for
independent assessment; they are not established by a compiler.

## 8. Exact experiments and literature scope

`verify.py` reconstructs the certificate with standard-library integer
arithmetic. It enumerates actual subgroups independently of the graph
construction in six finite products, including \(D_8\times C_4\),
\(Q_8\times C_4\), and \((C_2)^2\times(C_2)^2\).
In the last example the graphs with trivial \(V\) and full \(W\)
number **six**, not one; this is a direct check of the no-denominator
assertion. Finite truncations are compared with the infinite-lattice
formula only through indices they capture. It also checks 195 lattice
congruences, 80 finite-abelian effective obstructions, and the complete
marks of four integral elementary-abelian detectors. These are bounded
experiments; the universal statements are proved in Sections 1--6
and in the formal arithmetic core.

For a concrete actual-set obstruction, take
\(E=(C_2)^2\times\mathbb Z_2^2\), \(h=6\), and the regular four-point
\((C_2)^2\)-set inflated through \(E\to(C_2)^2\).
The congruence sum is \(-5392\equiv112\pmod{128}\).
The virtual detector sum is \(3520=4c_6\), where \(c_6=880\)
and \(v_2(c_6)=4\). This group fails the **hypothesis** of
`thm:procyclic`; it is not a refutation of that theorem.

The Jacobian adapter executed exactly one bounded operation,
`modular.polynomial_identity.compute`, on the polynomial obtained by
multiplying the degree-six truncation of
\(\prod_{u=1}^3(1-2^u t)^{-1}\) by its denominator, modulo \(128\).
`jacobian_payload.json` is the exact input and `jacobian_output.json`
is the full typed response, including server version `0.14.0`,
protocol `2025-11-25`, and transport `mcp-stdio`. The adapter exited
zero, returned `identical: true`, and had empty residual and no
structured error. The verifier independently checks the polynomial
and binds the stored response to that exact input. This one modular
calculation is corroboration, not a universal proof.

The primary Tamanoi paper was obtained from
<https://arxiv.org/pdf/math/0103177> and retained as
`tamanoi_2001.pdf`, with extracted text `tamanoi_2001.txt`.
Its actual Lemma 5-5, equation (5-9), journal page 140, states the
weighted lattice enumeration and recurrence used here. This confirms
the manuscript's attribution. An AI web-search summary instead
reported an incompatible finite-abelian formula; inspection of the
primary text rejected that summary. It is not evidence of a manuscript
error. The focused lookup produced no verified prior source for the
specific uniform bound (5); this is not a proof of novelty.

All nonfoundational inputs used in the theorem are proved in this
report or the Lean source. No external proposition is left as an
unproved ledger assumption; the Tamanoi reference is corroborative.

## Reproduction

From the campaign root:

```sh
python3 research/profinite_rigidity/verify.py
$WORKSPACE/argus-live-update/.venv/bin/python -m argus_skill.verticals.math.lean_evidence verify research/profinite_rigidity/Main.lean --statement-fidelity research/profinite_rigidity/statement_fidelity.md --claim P_LEAN_CORE --project-root .
$WORKSPACE/argus-live-update/.venv/bin/python -m argus_skill.verticals.math.math_state check --project-root .
$WORKSPACE/argus-live-update/.venv/bin/python -m argus_skill.verticals.math.proof_graph_check check --project-root .
```

Compiler-created evidence beside `Main.lean` and its archived certificate
are authoritative for the Lean run. The exact JSON computation is
compared in full, not merely by its summary or a hash.

## Recorded certification outcome

The official `lean_evidence verify --claim P_LEAN_CORE` run succeeded
with Lean **4.31.0**, `exit_code=0`, `proof_holes=[]`, and axiom-audit
exit code zero. Compiler stdout and stderr were empty.
`lean_evidence check` subsequently recognized the source as verified
and reported no issues. The immutable compiler certificate is
`certificates/P_LEAN_CORE-816b45e413d08ebc.json`; `lean_check.json`
and `compile.log` carry the adjacent run record. The claim ledger
derives `closed_kernel` for **P_LEAN_CORE only**, with no
undischarged assumptions. This is not a kernel closure of
`P_PROCYCLIC` or of any chromatic claim.

The standalone verifier reproduced `exact_certificate.json`
byte-for-byte, including the saved Jacobian request and typed-result
checks. Both official campaign-local structural checks passed at
`campaigns/9000314` with
exit codes zero.

The result submitted for independent review is a universal prose
verification of `thm:procyclic` together with an effectively indexed,
formally certified arithmetic strengthening of its kernel argument.
The manuscript assertions in scope were not refuted. Independent
mathematical and statement-fidelity review, and verified novelty and
publishable significance, are still outstanding. Accordingly this
is an Engineer milestone, **not final campaign acceptance**.
