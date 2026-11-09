# Family 019: retrospective analytic and source review

## Assessment and authority

**Assessment:** the five analytic claims in the old collar-root draft are supported by the mathematical arguments below, under the stated hypotheses and inherited external results. I found no substantive gap in this particular collar lemma. This is a conditional, on-paper assessment, not a kernel certification of analytic geometry, a whole-paper endorsement, or independent final Reviewer acceptance.

The governing contract is the current `OBJECTIVE.md`, `PRIOR_DRAFTS.json`, and `research/DRAFT_REVIEW_INDEX.json`. Historical instructions and status labels are evidence, not authority. No old file was changed. No agent or Reviewer was spawned. Writes for this assignment are confined to this report and `verdict.json`.

Abbreviations used below:

- **OLD:** `families/019/first-pass/collar_root_audit`.
- **P:** `openai-math/preprints/The-p-adic-section-conjecture-October-6-2026`.
- **E:** `openai-math/preprints/Etale-covers-with-a-prescribed-exterior-sheet-September-24-2026`.
- Primary-text line locators refer to the supplied `OLD/sources/*.txt` transcriptions, not a newly downloaded or potentially revised document.

I read the complete old `report.md` (375 lines), all six `reviewer/*_excerpt.txt` files, all six `reviewer/literature/*.json` records, the relevant propositions and their hypotheses in all five primary transcriptions, and all 16 manuscript TeX files for coverage. I did **not** read or execute old `verify.py`, `Main.lean`, or any finite/Jacobian/Lean certificate. Their replay and formal statement-fidelity assessments belong to the parent-owned units.

## 1. Exact target, hypotheses, and revision

The target is **P**, `build/sections/04-tame-roots.tex`, `lem:etale-collars`, beginning at line 198; its proof ends before `prop:first-stage` at line 285. The immediate manuscript dependencies are `lem:annular-unit` (line 20), `lem:stable-edge-root` (line 69), and the residue constructions inside that latter proof. The all-sheet capture argument occurs inside the collar proof, rather than as a separately numbered manuscript lemma.

The ground-field convention is in **P**, `build/sections/02-preliminaries.tex`: \(k/\mathbb Q_p\) is finite, \(\bar k\) is an algebraic closure, and \(\Omega=\widehat{\bar k}\) is algebraically closed and complete with \(v=-\log_p|\cdot|\) and \(v(\Omega^\times)=\mathbb Q\). Fix an **odd prime** \(\ell\ne p\). The precise collar assertion is:

- \(C/\bar k\) is smooth, proper, connected, of genus at least two.
- The \(b_i\) are finitely many distinct points in \(C(\bar k)\).
- The \(B_i\) are disjoint sufficiently small coordinate disks about the \(b_i\); the coordinates \(t_i\), defined over \(\bar k\), vanish simply at their centers.
- There exist **one connected finite étale cover** \(Y\to C_\Omega\) and concentric open annuli
  \[
  A_i'=\{r_i<|t_i|<R_i\}\subset B_i,\qquad
  0<r_i<R_i,\quad r_i,R_i\in|\Omega^\times|,
  \]
  such that a function \(z_i\in\mathcal O((Y^{\rm an})|_{A_i'})\) satisfies \(z_i^\ell=t_i|_Y\) on the **entire inverse image** of each \(A_i'\).

The disks may be shrunk when making the construction; a collar is required inside each original disk, not at a prescribed pair of radii. Neither a Galois conclusion for the final cover nor a root on the original whole disk is asserted. The cover is over \(\Omega\); descent of the resulting analytic roots is not required.

The manuscript source manifest is `campaigns/9100019/MANUSCRIPTS.json`. Its advertised revision is `4eaee87548250b2682affda7d05d947c05554bae`. Direct SHA-256 comparison of the actual bytes of **every one of its 16 TeX entries** with the existing manifest values gives **16 matches, zero mismatches**. No Git operation was used. This establishes byte identity with the supplied revision manifest; it does not independently reconstruct the repository's commit history. Expected and actual digests, paths, read coverage, and roles are recorded in `verdict.json`.

The old analytic report's actual file SHA-256 is `5e267dc50bfb97fb98cb8794b0f179bf20d4a2239fd3672a11444feee0686db1`. This file digest is not a claim-content hash.

## 2. Primary-source attribution and hypothesis matching

All six archived source records were read, but their earlier favorable assessments were not treated as proofs. The following conclusions follow from the supplied primary texts and the actual uses in the argument. These are six inherited inputs, not six sources each asserting the collar lemma.

### MT-RNS-DOMINATION — correct and applicable

**Source/revision:** Shinichi Mochizuki and Shota Tsujimura, *Resolution of Nonsingularities, Point-theoreticity, and Metric-admissibility for p-adic Hyperbolic Curves*, inherited RIMS Preprint 1974 identification, author revision **March 30, 2024**. The transcription's title page confirms the authors, title, and date (`mochizuki_tsujimura.txt:1–5`).

**Exact text locations:** Theorem A, printed p. 4 (`:172–178`); Definition 2.1(i), (ii), (iv), printed p. 26 (`:1374–1414`); Proposition 2.4(iv), printed p. 50 (`:2688–2724`).

Theorem A requires a set \(\Sigma\) containing \(p\) with at least two primes, a \(p\)-adic local field \(K\), a hyperbolic \(K\)-curve, and a mixed-characteristic complete discretely valued extension \(L\) containing \(K\) topologically. Its RNS conclusion holds precisely when the residue field of \(L\) is algebraic over \(\mathbb F_p\). Proposition 2.4(iv), assuming RNS, gives after finite ground extension a connected geometrically pro-\(\Sigma\) finite étale Galois cover with a stable source model mapping to **the specified compactified target model**.

Here one descends the algebraic curve, points, and finite model modifications to a finite local field, takes \(L=K\), and takes \(\Sigma\) to be all primes. Genus at least two supplies hyperbolicity; the residue field is finite. The modified target is proper, flat, normal, and of finite presentation, as Definition 2.1 requires. The theorem is **not** being applied directly to the nondiscretely valued field \(\Omega\).

The conclusion is a morphism of models, not necessarily a finite morphism. Nothing in the capture argument needs model finiteness or tame reduction of this cover. The stronger positive-genus-component assertion used in the companion exterior-sheet manuscript is not needed here.

**Archived record:** `OLD/reviewer/literature/9e7394b6427afb832621545f170fa12c.json`; accompanying `mt_excerpt.txt`.

### ABBR-TAME-LIFT — correct and applicable, including loops

**Source/revision:** Omid Amini, Matthew Baker, Erwan Brugallé, Joseph Rabinoff, *Lifting harmonic morphisms I: metrized complexes and Berkovich skeleta*, **arXiv:1303.4812v3**, April 15, 2014 (`abbr_v3.txt:1–31`).

**Exact locations:** Theorem 7.7, printed p. 45 (`:2583–2604`); Definitions 2.19 and 2.21 (`:495–537`); Definition 4.25 (`:1409–1412`); §4.27 (`:1424–1434`); Definition 4.31 (`:1451–1461`).

The ground field must be complete, algebraically closed, and nontrivially valued. The input is a **tame covering of \(\Lambda\)-metrized complexes**, not just a graph with convenient edge multiplicities. Definition 2.19 requires compatible finite residue maps, correct ramification indices at edge ends, the **whole fibre over every marked point**, and equality of residue and graph local degrees. Definition 2.21 requires tame residue maps and generically étale augmented graph ramification. Theorem 7.7 explicitly permits loops; the no-loop hypothesis of Theorem 7.4 is not silently discarded.

The constructed data meet these conditions: the residue maps are actual Kummer or étale maps; all marked fibres are represented; factors are \(1\) or \(\ell\); lengths divided by \(\ell\) remain in \(\Lambda=\mathbb Q\); Riemann–Hurwitz gives zero augmented ramification. There are **no punctures**. Definition 4.31 then makes the lifted algebraic map étale, because the empty puncture set must contain its branch locus. Definition 4.25 gives equality of the whole inverse vertex set and skeleton, and §4.27 relates edge factors to annular slopes.

This input applies to the newly built tame covers, **not** to the potentially wild RNS cover.

**Archived record:** `OLD/reviewer/literature/dd7ddf29e10ac8ff306d3a5d7595ea27.json`; accompanying `abbr_lifting_excerpt.txt`.

### ABBR-TUBES-REDUCTION — correct, with the local-model bridge explicit

**Source/revision:** the same **arXiv:1303.4812v3**.

**Inherited locations:** Definition 3.8 (`abbr_v3.txt:707–710`), §3.11 (`:720–759`), Lemma 5.17 and its proof (`:1747–1760`), and functorial reduction preceding Proposition 5.12 (`:1685–1703`). The commuting reduction square also appears in the proof of Theorem 5.13 (`:1776–1790`).

These concern semistable vertex sets/formal models of smooth proper curves over the specified complete algebraically closed field. The complement has finitely many annuli but generally infinitely many disks. Lemma 5.17's proof identifies component-generic fibres with individual vertices and closed-point fibres with complementary components. The **explicit** generic/smooth/node classification is also stated nearby in Theorem 5.7(1)–(3), printed p. 29; §5.9 gives the local node equation. Lemma 5.1 explains passage between algebraic and formal semistable models. These neighboring statements corroborate the local-equation bridge already acknowledged by the old report; they are useful locator refinements, not a new specialized assumption.

For an existing model morphism, base change and completion preserve the commuting reduction square. If a source reduction point maps to a target node, its **entire** tube maps into that node tube. Thus a source smooth disk meeting the chosen target node annulus maps wholly into it. No finite collection of smooth disk tubes is assumed, and no finite model morphism is required.

**Archived record:** `OLD/reviewer/literature/45259f123abed687399b14752990229e.json`; accompanying `abbr_tubes_excerpt.txt`.

### TEMKIN-COMPACT-TYPE2 — correct, with rationality derived rather than quoted

**Source/revision:** Michael Temkin, *Introduction to Berkovich analytic spaces*, **Jussieu 2010 preliminary lecture notes** (`temkin_notes.txt:1–12`), not a later differently numbered edition.

**Exact locations:** Fact 2.2.6(i) (`:293–296`); Definition 2.3.7, Exercise 2.3.8, Definition/Exercise 2.3.9(2) (`:376–398`); Definition 4.2.13(ii), Example/Exercise 4.2.14(iv) (`:1257–1282`); Fact 5.1.5 (`:1462–1465`). Definition 6.1.1(ii) (`:1834–1838`) explicitly extends the point classification to curves.

The compactness assertions apply to affinoids and to proper algebraic analytifications; proper separated curves here are compact Hausdorff. The proof uses a closed annular window, not compactness of an open annulus. On a type-2 curve point, residue transcendence degree \(F=1\) and Abhyankar's inequality \(E+F\leq1\) imply relative value-group rational rank \(E=0\). Consequently the quotient of value groups is torsion. Since the ground additive group is \(\mathbb Q\), any real value \(\gamma\) with \(n\gamma\in\mathbb Q\) is itself rational. This additional elementary inference is essential: the word “vertex” alone is not the rationality argument.

No assertion about arbitrary non-good/non-boundaryless analytic spaces or spherical completeness is needed.

**Archived record:** `OLD/reviewer/literature/0acf4c4a11ffce81fb39b89992d7c4d1.json`; accompanying `temkin_excerpt.txt`.

### MILNE-DIVISIBILITY-TORSION — correct for both residue constructions

**Source/revision:** J. S. Milne, *Abelian Varieties*, author notes **January 2, 2022** (`milne_av.txt:1–12`).

**Exact locations:** Proposition 8.1, printed p. 12 (`:624–634`); Theorem 8.2, printed pp. 13–14 (`:651–653`, with the proof continuing through `:722`); Remark 8.4, printed p. 14 (`:724–732`).

Multiplication by \(n>0\) on a \(g\)-dimensional abelian variety is a surjective isogeny of degree \(n^{2g}\), étale when \(n\) is prime to the characteristic. Over a separably algebraically closed field, prime-to-characteristic \(n\)-torsion has rank \(2g\) over \(\mathbb Z/n\mathbb Z\).

The residue field is algebraically closed of characteristic \(p\). Applied to \(J_D=\operatorname{Pic}^0(D)\), surjectivity supplies the required divisor class even for genus zero. Nonzero \(\ell\)-torsion is invoked **only for positive genus**. Identifying Jacobians with degree-zero line bundles, forming Kummer covers, and applying Riemann–Hurwitz are the standard additional bridges, not statements being misattributed to Theorem 8.2.

**Archived record:** `OLD/reviewer/literature/c0ce2f042c412e15d9cc84413cf692b2.json`; accompanying `milne_excerpt.txt`.

### BPR-ANNULAR-FACTORIZATION — correct; the open-domain extension is proved

**Source/revision:** Matthew Baker, Sam Payne, Joseph Rabinoff, *On the structure of nonarchimedean analytic curves*, **arXiv:1404.0279v1**, April 1, 2014 (`bpr_v1.txt:1–25`).

**Exact locations:** Proposition 2.2(1), printed p. 4 (`:208–214`); Lemmas 2.12–2.13, printed p. 7 (`:350–368`). The closed-ball/annulus algebras and their reductions are described in §2.1 (`:139–206`).

Proposition 2.2(1) is for a **strict closed annulus**, over a complete algebraically closed nontrivially valued field. It supplies monomial times a principal unit, with a strict supremum bound on that closed domain. It is not itself an open-annulus theorem. The old report supplies the exhaustion/dominant-term argument below to obtain the required open-domain statement.

Lemma 2.13 makes a unit's norm factor through annular retraction; its proof uses the disk-unit constant-norm fact. Lemma 2.12 supplies the unique attachment points of complementary balls. These uses are precisely the disk norm, annular factorization, and full-annulus attachment arguments actually needed.

**Archived record:** `OLD/reviewer/literature/5606718796591126b4c6b48c045b310f.json`; accompanying `bpr_excerpt.txt`.

## 3. Substantive assessment of the five analytic claims

### 3.1 C9000019-UNITS

**Locations:** OLD `report.md:85–122`; **P** `lem:annular-unit`.

**Claim.** An analytic unit on an open disk has constant norm in \(|\Omega^\times|\). On a whole open annulus with coordinate \(S\),
\[
u=cS^d(1+h),\quad c\ne0,\quad d\in\mathbb Z,\quad |h|<1
\]
pointwise throughout the annulus. A root of \(S\) gives an \(\ell\)-th root of \(u\). The old report also correctly identifies \(\ell\mid d\) as the necessary and sufficient condition for a root on the annulus itself.

**Decisive argument.** On a rational-radius circle the multiplicative Laurent Gauss norm and the reductions of \(u\) and \(u^{-1}\) give inverse units in \(\widetilde\Omega[s,s^{-1}]\). Its units are monomials, so exactly one Laurent coefficient term dominates. A change of dominating exponent on a compact subannulus involves only finitely many competitors and forces a tie. Equality between distinct coefficient-term norms occurs at a rational additive radius, contradicting uniqueness there. Convergence on slightly larger compact subannuli makes the maximum attained at irrational radii as well. Thus one actual Laurent term \(cS^d\) works globally. Laurent norm bounds give the strict inequality for every analytic point, not just for skeletal points.

On nested closed disks the same reduction argument uses the fact that polynomial-ring units are constants. Evaluation at an \(\Omega\)-point supplies the constant disk norm in the ground value group.

Since \(\ell\ne p\), \(1/\ell\in\mathbb Z_p\) and the coefficients \(\binom{1/\ell}{n}\) are \(p\)-adically integral. On every compact subannulus, continuity and \(|h|<1\) give a uniform bound strictly below one, so the binomial series converges uniformly and its restrictions agree. A single uniform bound on the entire noncompact open annulus is **not** required. Algebraic closedness roots \(c\); a chosen root of \(S\) roots \(S^d\) even for negative \(d\). Conversely, factoring a proposed root multiplies its integral slope by \(\ell\), proving necessity of \(\ell\mid d\).

**Assessment:** supported. Dependencies are BPR plus the explicit analytic and binomial arguments, not an improperly generalized closed-annulus citation. The assertion gives no analogous unrestricted binomial extraction when \(p\mid\ell\).

### 3.2 C9000019-RESIDUE

**Locations:** OLD `report.md:123–147`; the two residue-cover constructions within **P** `lem:stable-edge-root`.

**Claim.** Over the algebraically closed residue field, one can construct (a) a connected degree-\(\ell\) cyclic cover of a smooth proper connected residue curve \(D\), tamely ramified precisely over two distinct marks \(P,Q\), and (b), when \(g(D)>0\), a connected degree-\(\ell\) étale cyclic cover. Every other marked fibre is fully present.

**Decisive argument.** Surjectivity of \([\ell]\) on \(\operatorname{Pic}^0(D)\) supplies a degree-zero divisor \(E\) with \(P-Q+\ell E=\operatorname{div}(f)\). The orders at \(P,Q\) are respectively \(1,-1\) modulo \(\ell\), even if \(E\) has support there. Thus \(f\) is not an \(\ell\)-th power. Normalizing \(z^\ell=f\) gives a connected cyclic degree-\(\ell\) cover, with total tame ramification at those two marks and no ramification elsewhere. Each other marked point has \(\ell\) distinct preimages. Riemann–Hurwitz gives
\[
2g(D')-2=\ell(2g(D)-2)+2(\ell-1),\qquad g(D')=\ell g(D).
\]
This works in genus zero too; no nonzero Jacobian torsion is needed for it.

For positive genus, a nonzero \(\ell\)-torsion line bundle has exact order \(\ell\). A trivialization of \(L^\ell\) defines the cyclic algebra \(\bigoplus_{j=0}^{\ell-1}L^j\), which is étale because \(\ell\) is invertible. Every nontrivial power \(L^j\) is a nontrivial degree-zero line bundle and has no global section. The proper cover consequently has only the ground field as global functions and is connected. Here \(g(D')=\ell(g(D)-1)+1\), and all marked fibres split into \(\ell\) distinct points.

**Assessment:** supported. These are actual residue maps with complete marked fibres, not ramification numbers awaiting an unproved Hurwitz-realizability assertion. Milne supplies divisibility and torsion; elementary Picard/Kummer theory and Riemann–Hurwitz supply the stated bridges.

### 3.3 C9000019-STABLE-ROOT

**Locations:** OLD `report.md:148–224`; **P** `lem:stable-edge-root`.

**Claim.** For a smooth proper connected genus-at-least-two curve over \(\Omega\) with its stable skeleton, the coordinate on any node annulus acquires an analytic \(\ell\)-th root on its entire inverse image in one connected finite étale cover. A single cover works for any finite collection of node annuli.

**Nonseparating edges.** Choose a simple circuit containing the chosen edge. At each circuit vertex use the two-mark ramified residue cover of §3.2, with local degree \(\ell\). Put one factor-\(\ell\) edge over each circuit edge, of length divided by \(\ell\). All other marked fibres have \(\ell\) unramified preimages; use \(\ell\) factor-one edges over every other edge and \(\ell\) identity-copy vertices off the circuit. Matching all edge ends is possible because both ends supply exactly the prescribed fibres. This includes chords, noncircuit loops, and a circuit consisting of a self-loop: the latter has two distinct marks on the normalization.

At circuit vertices every base direction has total degree \(\ell\). The ramification \(2(\ell-1)\) of the residue cover is exactly the sum from the two circuit edge ends, so augmented ramification is zero. If the original valence is \(n\), the new valence is \(2+\ell(n-2)\), and
\[
2g'-2+\operatorname{val}'=\ell(2g-2+n)>0.
\]
Identity-copy vertices retain stability. Every off-circuit vertex has a lifted path to a circuit vertex, whose lift is a single vertex; hence the entire constructed complex is connected. ABBR Theorem 7.7 applies to these full data over the **fixed base curve**, with no punctures, and yields a finite étale cover.

**Separating edges.** Cut the bridge and retain one boundary mark on each side. Each side contains a circuit or a positive-genus vertex. Otherwise it would be a genus-zero tree with \(N\ge1\) vertices, total valence \(2N-1\) including the boundary half-edge, whereas stability demands at least \(3N\).

Make a connected unramified degree-\(\ell\) covering of each side. For a side with a circuit use a cyclic graph cover from a surjection of its graph fundamental group onto \(\mathbb Z/\ell\mathbb Z\), with identity residue maps. For a positive-genus side use the connected étale residue cover at one such vertex, identity copies elsewhere, and all marked fibres. Lifted paths to that vertex prove connectedness. Each covered side has exactly \(\ell\) boundary preimages. Gluing them pairwise gives \(\ell\) factor-one bridge edges. After deleting **any** one, the connected covered sides remain joined by another because \(\ell>1\). Every lift of the old bridge is therefore nonseparating.

All residue maps in this precover are unramified, all factors are one, and the stability weight at a vertex of local degree \(d\) is multiplied by \(d\). Thus the lifted triangulation remains stable. Apply the nonseparating construction to each edge over the bridge. A nonempty connected component of a finite fibre product dominates each connected factor: its projection is finite étale with nonempty open-and-closed image. Pulling back the roots therefore retains all previous roots. The same argument handles finitely many original annuli.

**Entire annuli, not selected skeletal sheets.** For an ABBR lift, \(\phi^{-1}(\Sigma)=\Sigma'\). Every complementary upstairs ball consequently maps into one complementary downstairs ball. Its end maps to that ball's unique skeletal attachment point by continuity. Retractions commute on all these balls and on the graph. The entire inverse of \(\tau^{-1}(e)\) is therefore the union of the node annuli over \(e\), not that union plus unidentified inverse disks. On a factor-\(\ell\) annulus the pulled-back coordinate has exponent \(+\ell\) or \(-\ell\), so §3.1 gives a root everywhere on it. In the bridge precover the original coordinate is just an analytic unit on each factor-one annulus; rooting that source coordinate in the subsequent cover roots the original unit as well.

**Assessment:** supported for arbitrary finite stable graphs with the indicated residue curves, including bridges and loops. The proof is the general construction and deletion argument above. The old finite \(\ell=3\) parallel-edge illustration is not a proof of this universal claim.

### 3.4 C9000019-CAPTURE

**Locations:** OLD `report.md:225–284`; the irrational-level/compact-window part of **P** `lem:etale-collars`.

**Claim and hypotheses.** Suppose a finite curve cover \(f:Y_0\to C_\Omega\) extends to a morphism from a stable source model to a semistable target model. It may have wild reduction, and the model morphism need not be finite. For a target node annulus \(A\), let \(N\) be the union of **all** source node tubes whose nodes map to the target node. There is a rational-endpoint concentric subcollar \(A'\subset A\) for which
\[
f^{-1}(A')\subset N
\]
on the whole analytic curve. This is an inclusion, not an asserted inverse-skeleton equality for the RNS cover.

**Decisive argument.** Select an irrational additive level \(a\) inside \(A\), and rational \(\alpha<a<\beta\) strictly inside its endpoint interval. The closed annular window \(K=\{\alpha\le v(t)\le\beta\}\) is compact. Its inverse \(X=f^{-1}(K)\) is compact, and \(w=v(f^*t)\) is a finite continuous real function there. The finite union \(N\) of source node tubes is open.

Every point of \(X\setminus N\) has rational \(w\):

1. A point reducing to a component generic point is its unique type-2 vertex. The type-2 value-group argument in §2 gives rational values for its nonzero analytic function germs.
2. A point reducing to a smooth closed point \(q\) belongs to its whole open disk tube. Reduction compatibility sends \(q\) to the target node, and hence sends **every point of that disk** into \(A\). Thus \(f^*t\) is a unit on that entire disk. Its constant norm lies in the ground value group by §3.1.
3. If the reduction is a node, reduction compatibility makes it a node mapping to the target node, so the point was in \(N\), contrary to its selection.

These possibilities exhaust reductions on the semistable special fibre, including points off the skeleton and points of types 1, 3, or 4 in its tubes.

The bad set \(X\setminus N\) is closed in a compact space. Its image \(F=w(X\setminus N)\) is compact, hence closed in \(\mathbb R\), and is contained in \(\mathbb Q\). Since \(a\notin F\), there are rational \(q_-<a<q_+\), inside \((\alpha,\beta)\), with \((q_-,q_+)\cap F=\varnothing\). Any point over that entire interval first lies in \(X\), and then cannot lie in its bad set. The collar radii are
\[
r=p^{-q_+}<R=p^{-q_-},
\]
with the necessary reversal of order. Both are in \(|\Omega^\times|\).

**Assessment:** supported. No finiteness of the family of disk tubes, no tameness of \(f\), and no finiteness of the model morphism has entered the argument. Compactness is indispensable: rationality of many exceptional levels by itself would not give an interval. Irrationality is indispensable too. The universal formal core can certify the final compact-image exclusion after its hypotheses are supplied; it cannot establish the reduction and rationality hypotheses. Those analytic hypotheses are justified above from the inherited inputs.

### 3.5 C9000019-COLLARS

**Locations:** OLD `report.md:285–328`; **P** `lem:etale-collars`.

**Decisive assembly.**

1. Descend \(C\), the finitely many \(b_i\), integral local parameters, and finite modifications to a finite extension of the local field. Semistable reduction with the sections separated and smooth is the usual marked-model input. Blowups at a section with integral parameter \(u_i\) produce node annuli
   \[
   |\pi|^{j+1}<|u_i|<|\pi|^j.
   \]
   On a sufficiently small disk \(t_i/u_i\) is a unit because both functions vanish simply. Its constant norm \(c_i\in|\Omega^\times|\) changes these bounds into concentric \(t_i\)-bounds. Taking \(j\) large puts a node annulus inside every original \(B_i\). There is no need to descend an arbitrary infinite analytic power-series expression for the chosen coordinate: its ratio with \(u_i\) is handled analytically over \(\Omega\).
2. The modified model is proper, flat, normal, and of finite presentation; the semistable local node equation \(xy=\pi^m\) remains normal even if it is not regular. Forget the sections as markings. It is a permitted target for MT Proposition 2.4(iv).
3. Apply MT with all primes after finite extension. Split reduction and select a geometric connected component; the model morphism persists under base change and restriction. This gives a connected finite étale \(f:Y_0\to C_\Omega\) with a stable source model mapping to the chosen target. Its genus is at least two by \(2g(Y_0)-2=\deg(f)(2g(C)-2)>0\).
4. Apply §3.4 to each of the finitely many target node annuli. It supplies smaller collars \(A_i'\) and finite unions \(N_i\) of stable source node annuli with \(f^{-1}(A_i')\subset N_i\). Every annulus in \(N_i\) maps wholly into the corresponding target node tube; \(f^*t_i\) is a unit on it. No monomial, finite-model-map, or tame hypothesis on this restriction of \(f\) is needed.
5. Apply §3.3 simultaneously to all source node annuli in all the \(N_i\), obtaining a connected finite étale \(g:Y\to Y_0\) rooting their coordinates on their full inverse images. By §3.1 it also roots every corresponding unit \(f^*t_i\), whatever its integral Laurent exponent. Restrict those functions to
   \[
   (f\circ g)^{-1}(A_i')\subset g^{-1}(N_i).
   \]
   Distinct node tubes are disjoint, so the functions chosen on their inverse images require no compatibility gluing. The composite is the single connected finite étale cover required for every \(i\).

**Assessment:** supported under the exact target hypotheses. In particular, capture on **all** sheets is what makes the last restriction valid; one chosen lifted annulus, or only skeletal control for \(f\), would be insufficient. This does not prove a fixed-radius or whole-disk assertion, arbitrary-order roots, patching, or any section conjecture.

## 4. Foundational inputs and remaining gaps

There is **no additional specialized inherited theorem or extra target hypothesis** needed beyond the six audited inputs. Several ordinary bridges remain mathematical rather than formalized inputs, as they already were in the old report:

- finite descent of algebraic data; stable/semistable reduction with finitely many smooth disjoint sections; splitting reduction after finite extension; completion/base change of model morphisms;
- semistable local tube descriptions, node equations, and the correspondence between stable models and stable weighted skeleta (explicitly corroborated by ABBR §5);
- the identification \(J_D=\operatorname{Pic}^0(D)\), divisors representing its points, Kummer theory, normalization, and tame Riemann–Hurwitz;
- Laurent/Tate algebra reductions, integral binomial coefficients and locally uniform analytic convergence;
- finite étale base change and fibre products, open-and-closed component images, and restriction/pullback of analytic roots.

These are not new independent assertions of RNS or wild lifting. They must not be hidden behind a claim that Lean formalizes the geometry. The suggested source-locator additions, ABBR Theorem 5.7 and Temkin Definition 6.1.1(ii), clarify nearby foundational statements; they do not repair a substantive mathematical gap.

**Substantive gaps found in the five assigned claims: none.** The conclusion is conditional on the cited mathematical results; I checked their statements, hypotheses, and applications, not the full proofs of the RNS and lifting theorems. Independent acceptance of this review and parent-owned certificate/formal-unit reviews remain outstanding, rather than being disguised as mathematical counterexamples or resolved downstream obligations.

## 5. Coverage of all 16 manuscript reference files

Every listed source was read completely for its role. “Context” and “downstream” are explicit exclusions from mathematical certification, not unread omissions. Every identity check in the last column compares actual bytes to that file's existing manifest digest.

| Manuscript | File under its source root | Lines read | Role in this review | Identity |
|---|---|---:|---|---|
| E | `build/figures/path-to-cycle.tex` | 1–16 | Companion illustration of a path becoming parallel edges; not a general graph proof or collar dependency. | match |
| E | `build/main.tex` | 1–46 | Companion title, abstract, and inclusion structure; exterior-sheet theorem is a different result. | match |
| E | `build/sections/01-statement.tex` | 1–83 | Context-only fixed-disk exterior-sheet statement, including a \(p\)-divisibility conclusion; not inferred from the collar lemma. | match |
| E | `build/sections/02-cycles.tex` | 1–195 | Context-only positive-genus RNS/torsor/cycle construction; overlaps some inputs but is not used in the five-claim proof. | match |
| E | `build/sections/03-characters.tex` | 1–65 | Context-only degree-\(p\) graph-character covers splitting over an exterior; not used or certified. | match |
| E | `build/sections/04-quotient.tex` | 1–81 | Context-only companion stabilizer quotient assembling exterior and disk conditions; not used or certified. | match |
| P | `build/figures/parallel-edges.tex` | 1–52 | Downstream illustration for arbitrary-order roots and Jacobian characters, not the stable-bridge proof. | match |
| P | `build/main.tex` | 1–55 | Context-only title, abstract, and section inclusion structure; broad claimed consequences not certified. | match |
| P | `build/sections/01-introduction.tex` | 1–272 | Context-only claims and dependency roadmap; distinguishes first-stage collars from arbitrary roots, completion, and sections. | match |
| P | `build/sections/02-preliminaries.tex` | 1–68 | Used hypotheses: ground field, \(\Omega\), rational value group, \(\ell\ne p\). Remaining valued-field setup is context, not a separate reviewed theorem. | match |
| P | `build/sections/03-patching.tex` | 1–220 | Downstream consumer explaining the all-sheet requirement; patching, point transfer, and horizontal-closure lemmas are not certified here. | match |
| P | `build/sections/04-tame-roots.tex` | 1–314 | Exact target and used unit/residue/stable-root/capture proofs. `prop:first-stage` at lines 285–314 is downstream and not certified by this review. | match |
| P | `build/sections/05-arbitrary-roots.tex` | 1–201 | Downstream arbitrary-\(m\) roots using totally degenerate Jacobian uniformization and a different auxiliary branched cover; not certified. | match |
| P | `build/sections/06-realization.tex` | 1–90 | Downstream completion theorem using patching, arbitrary roots, and point transfer; not certified. | match |
| P | `build/sections/07-sections.tex` | 1–218 | Downstream decomposition groups, valuations, and local section theorem; not certified. | match |
| P | `build/sections/08-global-sections.tex` | 1–276 | Downstream global descent/localization consequences and additional arithmetic inputs; not certified. | match |

Thus the related exterior-sheet manuscript is not silently omitted, but neither is it counted as another old Argus draft or used as circular evidence for the collar lemma.

## 6. Provenance, formal/finite boundaries, and originality

The parent furnished the following old ledger bindings; full ledger reconciliation is parent-owned and was not repeated by reading old ledgers:

| Analytic claim | Old versions; latest | Natural/formal content hash |
|---|---|---|
| C9000019-COLLARS | 1, 2; 2 | `b84c463a0ae848e46eeb57c995b4708fee410986524166a355c9426e514366c4` |
| C9000019-CAPTURE | 1–5; 5 | `978423c8656fb393abba15c7848db1fc14f73d7fcc294a968cbfc57f842b1d5f` |
| C9000019-STABLE-ROOT | 1, 2; 2 | `4ba2a3f8961faec7eb6f678b8a0834e04c83de5f377b62d1a76053f15ed73884` |
| C9000019-UNITS | 1, 2; 2 | `ab3c4abbe5bc5b1524d37a8afc44b36824acaf29862c45181d5e77f1594cd32a` |
| C9000019-RESIDUE | 1, 2; 2 | `e3abd9a4dc873b6b1d7dd41085732c651ed387ee1d13a804cc2e8dc3b7f77bad` |

The six final historical supports by `reviewer:copilot-f14a5035706f` bind those five hashes and C9000019-COLLAR-CORE v2, hash `cf05e2e0bad955e3deaf479626e555c7d8c02d694f66cce9e40aef23a9a5ca0e`. They are distinct from six earlier source supports and five Engineer self-supports. Stale open/pending graph labels are not a mathematical verdict, and historical supports do not accept this new review. C9000019 v1 is a ledger-only superseded complete-family objective, not another proof.

The parent also reports that the supplied snapshot manifest matches all nine family entries, including the report, ledger, and graph; the other 26 old inventory artifacts have no snapshot-manifest entry. That furnished snapshot comparison is separate from my independent 16-file manuscript byte comparison. The actual primary-transcription digests in `verdict.json` identify what was read, but no unavailable snapshot identity is asserted for them.

Three evidence levels must remain separate:

1. The **universal Lean core**, as described in the old report, concerns compact-space exclusion and integer identities after their hypotheses are supplied. Its compilation and exact declarations are reviewed elsewhere by the parent. This assignment makes no fresh compiler claim and does not infer a curve cover from formal labels.
2. The **finite arithmetic/graph example**, described there for \(\ell=3\) after contracting the connected sides, illustrates the separating-edge mechanism. It does not check arbitrary graphs, arbitrary residue curves, analytic tubes, or all-sheet geometry.
3. The **analytic assembly** reviewed here supplies those geometric bridges using the six external inputs and the explicit arguments above. It ends at `lem:etale-collars`. Even \(L_\ell\subset H\) additionally needs patching, point transfer, and étale descent; the full completion and section results need still more mathematics.

The old draft expressly presents itself as verification and expanded explanation, not a novel analytic theorem or refutation. Its entire-inverse-image requirement is already literal in the manuscript statement and proof, not an original strengthening introduced by Argus. Accordingly the analytic work is classified as **reproduction/exposition and assembly of cited results**. The formalization and finite illustration are supporting artifacts, not independent analytic discoveries. No novelty search was undertaken. Contribution claims made by the context-only companion manuscript are not adjudicated here.

## 7. Citation-ledger and acceptance constraints

The parent states that current CTX-DR019/DR019-COLLAR already records the exact setting, all six inherited assumptions, and the formal/finite/skeleton boundaries. This assignment neither read nor changed current `MATH_STATE`, `PROOF_GRAPH`, summary, or index, and did not invoke `citation_check attribute` or rebuild citation infrastructure. The six old literature records are reused by reference. Their source statements and applications have been mathematically reviewed here, but no new current citation-ledger write or official support event is claimed.

The assigned analytic/source review is complete. **Native independent Reviewer acceptance of this new review has not occurred.** `verdict.json` therefore sets `independent_review_required=true` and `independent_review_accepted=false`. Family completion, other review units, and any downstream theorem remain outside this assessment.
