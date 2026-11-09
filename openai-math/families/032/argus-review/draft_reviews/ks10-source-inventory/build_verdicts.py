#!/usr/bin/env python3
"""Reconcile the four read-only catalogs and emit their scoped review verdicts."""

import collections
import hashlib
import json
import re
from pathlib import Path


ROOT = Path(__file__).resolve().parents[3]
EXPECTED = {"ks10": 40, "ks30": 58, "milne": 44, "weil": 49}
INDEX_PATH = ROOT / "research/DRAFT_REVIEW_INDEX.json"
INDEX = json.loads(INDEX_PATH.read_text())
OLD = Path(INDEX["old_workspace"])
OTHER_REL = "research/actual_group_audit/other_manuscript_claims.json"
TAIL_REL = "research/actual_group_audit/weil_tail_claims.json"
POPULATE_REL = "research/actual_group_audit/populate_source_claims.py"
OTHER = json.loads((OLD / OTHER_REL).read_text())
TAIL = json.loads((OLD / TAIL_REL).read_text())
STATE = json.loads((OLD / "research/MATH_STATE.json").read_text())
GRAPH = json.loads((OLD / "research/PROOF_GRAPH.json").read_text())
REFERENCE_PATH = Path(INDEX["manuscript_reference_manifest"])
REFERENCE = json.loads(REFERENCE_PATH.read_text())
MANUSCRIPTS = {m["namespace"]: m for m in OTHER["manuscripts"]}
SOURCE_BASE = {
    ns: m["source_path_base"] for ns, m in MANUSCRIPTS.items()
}
SOURCE_BASE["weil"] = str(Path(TAIL["source_path"]).parent.parent)

READ_RANGES = {
    "ks10": {
        "build/paper.tex": [[1, 46]],
        "build/sections/introduction.tex": [[1, 75]],
        "build/sections/cycles.tex": [[1, 116]],
        "build/sections/clifford.tex": [[1, 190]],
        "build/sections/generic.tex": [[129, 377]],
        "build/sections/specialization.tex": [[75, 220], [354, 423]],
        "build/sections/special_data.tex": [[1, 243]],
        "build/references/dependency-table.tex": [[1, 163]],
    },
    "ks30": {
        "build/paper.tex": [
            [1, 220], [439, 467], [1293, 1485], [1487, 1506],
            [1625, 1630], [2411, 2419], [2487, 2577], [2699, 2846],
            [3290, 3325], [3417, 3525], [3720, 3985], [4075, 4157],
            [4307, 4615], [4709, 4895], [5047, 5125], [5138, 5255],
        ],
    },
    "milne": {
        "build/main.tex": [[1, 73]],
        "build/sections/00_intro.tex": [[1, 171]],
        "build/sections/01_preliminaries.tex": [[50, 62], [144, 204]],
        "build/sections/02_transport.tex": [
            [35, 150], [229, 308], [404, 574], [620, 793],
        ],
        "build/sections/03_filtration.tex": [
            [38, 155], [160, 241], [315, 463],
        ],
        "build/sections/04_weil.tex": [
            [1, 112], [205, 265], [330, 439],
        ],
        "build/sections/05_reduction.tex": [
            [1, 80], [160, 244], [252, 320], [370, 448],
        ],
    },
    "weil": {
        "build/paper.tex": [
            [1, 116], [280, 334], [558, 620], [900, 1075], [1495, 1502],
            [1611, 1834], [1836, 1949], [2001, 2022], [2055, 2071],
            [2109, 2124], [2162, 2181], [2500, 2582], [2658, 2673],
            [2699, 2724], [2782, 2798], [2889, 3010], [3074, 3119],
            [3221, 3271], [3500, 3525], [3818, 3849], [4218, 4240],
            [4331, 4349], [4477, 4486], [4584, 4587], [4638, 4644],
            [4695, 4815], [4899, 4906],
            [5026, 5040], [5108, 5136], [5258, 5288], [5400, 5465],
            [5560, 5697], [5728, 5820], [5862, 5901], [6000, 6110],
            [6132, 6195], [6380, 6416], [6459, 6484], [6568, 6595],
            [6788, 6824], [6916, 6936], [7044, 7146], [7340, 7341],
            [7520, 7633], [7666, 7680], [7870, 8024], [8053, 8059],
            [8086, 8091], [8108, 8133], [8180, 8184], [8192, 8204],
            [8212, 8223], [8241, 8246], [8259, 8276],
        ],
    },
}

SPECIFIC = {}
EXTRA_SOURCE_RANGES = {
    "ks10:main:generic": [
        ("build/sections/cycles.tex", 54, 116),
        ("build/sections/generic.tex", 129, 377),
    ],
    "ks10:main:specialization": [
        ("build/sections/specialization.tex", 75, 220),
        ("build/sections/specialization.tex", 354, 423),
        ("build/sections/special_data.tex", 1, 243),
    ],
    "ks10:main:all-degrees": [
        ("build/sections/introduction.tex", 57, 75),
        ("build/sections/specialization.tex", 354, 423),
    ],
    "ks30:main:theorem": [
        ("build/paper.tex", 5047, 5125),
        ("build/paper.tex", 5138, 5212),
    ],
    "ks30:ext:criterion": [("build/paper.tex", 439, 467)],
    "milne:thm:main": [
        ("build/sections/02_transport.tex", 35, 87),
        ("build/sections/04_weil.tex", 55, 112),
        ("build/sections/05_reduction.tex", 160, 244),
    ],
    "milne:prop:transport": [
        ("build/sections/02_transport.tex", 620, 793),
    ],
    "milne:thm:filtration": [
        ("build/sections/03_filtration.tex", 87, 155),
        ("build/sections/03_filtration.tex", 160, 241),
        ("build/sections/03_filtration.tex", 315, 442),
    ],
    "milne:cor:all-hodge-specialization": [
        ("build/sections/05_reduction.tex", 252, 320),
    ],
    "milne:cor:algebraic-specialization": [
        ("build/sections/05_reduction.tex", 370, 448),
    ],
    "weil:p3sw:weil-plane": [
        ("build/paper.tex", 900, 920),
        ("build/paper.tex", 7930, 8024),
    ],
}


def assess(ids, argument, obligations):
    for claim_id in ids.split():
        SPECIFIC[claim_id] = (argument, obligations)


assess(
    "ks10:main:generic ks10:gen:generation",
    "The source explicitly assumes Hg(V)=SO(V,q) and an actual nonzero "
    "codimension-two cycle on S x B. generic.tex:254-377 uses addition, "
    "one vector multiplicity, independent weight-one slot maps, and rational "
    "descent to recover every prescribed map on the full parity spaces. "
    "This is an attributed conditional recovery argument, not an Argus "
    "construction of the initial cycle.",
    [
        "Supply the actual nonzero correspondence (or the trace-nonzero cover); "
        "an absolute-Hodge or motivated tensor does not discharge this premise.",
        "An independent proof audit would have to justify the joint-group "
        "width/Hodge-Hom identification, full multiplicities, rational cycle "
        "span, prescribed duality, and ordered tensor-slot operations.",
    ],
)
assess(
    "ks10:main:specialization ks10:main:all-degrees ks10:spec:primitive",
    "introduction.tex:57-75 retains very-general existence component by "
    "component; specialization.tex:354-423 constructs the whole flat class "
    "theta by primitive and target projectors before specializing it. "
    "The all-degrees corollary adds existence in the required components "
    "in every degree; it is not an unconditional K3 theorem of this inventory.",
    [
        "Establish very-general actual algebraic input in each component used "
        "(in every needed degree for main:all-degrees).",
        "Audit whole-class specialization and subsequent restriction from "
        "primitive V to the actual T at a Picard jump, then exact-data transport.",
    ],
)
assess(
    "ks10:spec:hilbert-map ks10:spec:flat-cycle ks10:spec:specialization",
    "specialization.tex:75-220 makes the flat-subscheme assertion over a "
    "smooth algebraic parameter, resolves reduced Hilbert components, and "
    "pulls the marked classes to possibly singular/nonreduced analytic "
    "parameters. A finite chosen rational combination retains its coefficients. "
    "The catalog reproduces these assertions rather than certifying them.",
    [
        "Check the embedded-family classifying map, proper resolved parameters, "
        "Cartier multiplicities for nonpure/nonreduced fibers, and the Baire/"
        "proper-image passage to an actual cycle at every target.",
        "The premise is algebraicity of the entire prescribed flat rational "
        "class, not simply that it stays Hodge or has generic transcendental action.",
    ],
)
assess(
    "ks10:cliff:construction ks10:cliff:slots ks10:data:restriction "
    "ks10:data:polarization",
    "clifford.tex:10-190 fixes v^2=Q(v,v), the oriented signed circle, full "
    "parity spaces, odd right multiplier, duality and slot ordering. "
    "special_data.tex:15-243 uses Hodge inclusions/retractions and connected "
    "spin lifts of signed square-root isometries, then sign averaging and "
    "rational descent. It explicitly does not require the quadratic-change "
    "endomorphism to be scalar or algebraic on the K3 factor.",
    [
        "Independently verify the Hodge intertwining of every signed lift, "
        "opposite-sign and low-rank cases, full parity multiplicities, and "
        "the exact ordered tensor formula after duality/isogeny changes.",
        "Do not replace exact prescribed-map recovery by an arbitrary "
        "nonzero embedding or a simple spin factor.",
    ],
)
assess(
    "ks10:cyc:equivalence",
    "cycles.tex:54-116 distinguishes the two directions: the traced wedge "
    "gives a correspondence without the full-group assumption; the reverse "
    "direction uses injectivity on V under Hg(V)=SO(V,q). Its degree "
    "adjustment is the square of an explicit divisor on an abelian variety. "
    "The inventory does not produce either witness.",
    [
        "Retain dominance/generic finiteness, nonzero trace on holomorphic "
        "two-forms, and the nonzero action on V rather than merely a divisor.",
        "The degree adjustment, Hodge-Riemann nonvanishing and resolved "
        "surface construction are source arguments, not submitted Argus proofs.",
    ],
)
assess(
    "ks30:main:theorem ks30:transfer:tensor ks30:transfer:ample",
    "paper.tex:179-198 and 5047-5212 require a rational isometric embedding "
    "of the actual transcendental cup form in V_P, then recover exactly "
    "iota_(w,E) for every stipulated nonisotropic w, polarization and full "
    "isogenous realization. The source obtains HC/GHC by its separate "
    "exact-tensor criterion. The catalog supplies no independent geometric "
    "construction or proof of that chain.",
    [
        "The rational quadratic embedding is essential; rank <=8 or "
        "signature (2,n) alone is not the stated locus.",
        "Verify the abelian-cover/pencil and two-square correspondence, "
        "full half-spin recovery, whole rank-eight specialization including "
        "Picard jumps, ordered compression, and rational isometry transfer.",
        "For HC/GHC also discharge the general criterion's exterior-power "
        "carriers, all-degree invariant generation and geometric coniveau steps.",
    ],
)
assess(
    "ks30:ext:criterion ks30:ext:conditional "
    "ks30:ghc:prop:exterior-coniveau ks30:ghc:lem:k3-carriers",
    "paper.tex:151-158 and 439-467 distinguish an assumed exact cycle for "
    "j_w(v)(a)=vaw on full C^+(T,q) from a nonzero embedding. The criterion "
    "is for any projective K3, not just rank eight; its source proof route "
    "uses algebraic exterior-power maps with cohomological left inverses, "
    "rational Hodge-group carriers and support/coniveau operations. "
    "These are inventoried assertions, not a proof supplied by Argus.",
    [
        "Produce the one exact tensor where it is being assumed; an "
        "absolutely Hodge/motivated class or arbitrary embedding does not suffice.",
        "Audit the exterior correspondences, rational nonsplit and CM/totally "
        "real carrier cases, algebraic left inverses and coniveau shifts; "
        "catalog equation/section links are not proofs of these steps.",
    ],
)
assess(
    "ks30:comp:twosquares ks30:comp:surface",
    "paper.tex:3290-3325 states three substantive VHS/projector/uniruledness "
    "premises. Lines 3720-3860 fix G, the first models and relative C before "
    "b, and compute the difference-cylinder self-composition -4. "
    "Lines 4075-4157 kill the fixed-Hodge boundary error and use "
    "Theta_b=-(1/4)e_b (transpose D_X) C_hat D_S. This explains the "
    "source's exact-map assertion, not an independent certificate of it.",
    [
        "Check the preserved opens, affine-derived coefficient comparison, "
        "Thom/localization compatibility, signed -4 identity, and fixed-boundary "
        "Hodge exclusion with this order of quantifiers.",
        "Nonconstant period, simple fibers outside a countable set, "
        "uniruled models and a specified VHS comparison must all be supplied.",
    ],
)
assess(
    "ks30:final:spin ks30:final:generic",
    "paper.tex:4307-4615 recovers both ordered half-spin tensor orientations "
    "in the full rational Hom space (complex multiplicities eight and eight); "
    "the ordinary flip is implemented by minus the geometric interchange "
    "on H^1 tensor H^1. Transfer also invokes Buskin after Witt extension. "
    "The catalog is a faithful scope record, not a new representation-theory audit.",
    [
        "Verify full rational Hodge-Hom surjectivity and descent without "
        "assuming individually rational half-spins; one spin copy is insufficient.",
        "Check the geometric-flip sign and exact specified tensor under "
        "full H^2 rational Hodge isometry transfer.",
    ],
)
assess(
    "ks30:specialization:ambient ks30:final:hilbert "
    "ks30:transfer:compression",
    "paper.tex:4709-4895 explicitly retains the whole U_P, including new "
    "rational (1,1) directions at Picard jumps, and singular/nonreduced "
    "Hilbert parameters via leading Chern characters. Lines 5047-5125 "
    "use the second-slot map (E_T^flat)^-1 i^vee(-1) E_U^flat, not simply "
    "p tensor p; the prescribed right multiplier is changed before "
    "compression. This is stronger source scope than generic action on T.",
    [
        "Audit universal sheaf perfectness, ordinary fiber restriction, "
        "leading cycle multiplicities and successful proper images.",
        "Preserve exact duality/slot order and the full U_P class before "
        "restricting to T; the initial right multiplier need not lie in T.",
    ],
)
assess(
    "ks30:transfer:period",
    "paper.tex:5138-5169 uses rational orthogonal density only to enter an "
    "ample period patch, then an exact realized period, Witt extension and "
    "Buskin's rational Hodge-isometry theorem. It does not import an "
    "arbitrary rational Hodge map as algebraic.",
    [
        "Check the exact cup-form embedding, ample patch realization, "
        "Hodge nature of the full extension and applicability of the "
        "cited rational (not necessarily integral) isometry theorem.",
    ],
)
assess(
    "ks30:transfer:moduli",
    "paper.tex:5216-5255 passes from the stated K3 locus through Tate-twisted "
    "split Chow-motive correspondences. Smooth projectivity, twisted "
    "Gieseker/generic Bridgeland stability and the hyperkahler hypothesis "
    "for the birational clause are part of the scope. The inventory "
    "neither proves those imported decompositions nor extends the locus.",
    [
        "First establish the K3 all-powers HC/GHC premise and then verify "
        "the de Cataldo-Migliorini, Bulles, Arapura and Riess hypotheses, "
        "self-power splittings and geometric-coniveau Tate shifts.",
    ],
)
assess(
    "milne:thm:main milne:cor:cm-pairing",
    "00_intro.tex:29-56 fixes p,w and asserts one rational complementary "
    "divisor-pairing value in all ell!=p and C_w-extended crystalline "
    "realizations, including p=2 and nonlifting divisors. "
    "05_reduction.tex:207-244 routes the proof through CM transport, "
    "balanced-Weil rationality and rational pullback. This is not a claim "
    "of characteristic-zero algebraicity or of a unique Chow representative.",
    [
        "Verify all-prime tensor-preserving transport, the balanced-Weil "
        "dichotomy and rational CM reduction with the same coefficients "
        "in every realization.",
        "The separate October 6 CM Hodge theorem is not a premise of "
        "main rationality; its applicability cannot replace the local "
        "transport/filtration obligations.",
    ],
)
assess(
    "milne:prop:transport milne:cor:cm-transport",
    "02_transport.tex:35-87 and 620-793 distinguish a CM auxiliary over "
    "Qbar from a separately prescribed-filtration local auxiliary that "
    "need not be CM. One actual special-fiber quasi-isogeny preserves "
    "the tensors. The ratio of rational divisor intersections makes "
    "all local similitudes one lambda in Q^x, and "
    "kappa=lambda^(-r) eta_B/[P:Q]. No generic-fiber isogeny is claimed.",
    [
        "Check applicability of the adapted strongly admissible integral "
        "models at all p, canonical tensors and their common marking.",
        "Check the common rational normalization and absolute-Hodge/"
        "crystalline comparison for both kinds of auxiliary, rather "
        "than constructing unrelated maps in separate realizations.",
    ],
)
assess(
    "milne:lem:auxiliary-datum milne:lem:admissible-realization "
    "milne:input:uniformization-condition milne:import:adapted-embedding "
    "milne:import:integral-uniformization milne:import:marked-specialization",
    "02_transport.tex:101-150, 229-308 and 404-574 state the strong-"
    "admissibility and copy-preservation conditions and the actual framed "
    "local-Shimura/uniformization route. (U_x) is a cited prerequisite; "
    "the center condition, cohomological Frobenius convention and the "
    "single abelian marking are explicit. This review reads the source "
    "applications, not the cited external theorems.",
    [
        "Check the exact cited versions of Kisin-Zhou (including reduced "
        "relative roots at p=2), Pappas-Rapoport and Gleason-Lim-Xu, "
        "the adapted self-dual representation, center condition and (U_x).",
        "Justify that the admissible flag gives a finite-extension "
        "framed point whose uniformization retains the prescribed "
        "crystalline and every prime-to-p tensor marking.",
    ],
)
assess(
    "milne:lem:avoidance milne:lem:lagrangian-intersection "
    "milne:thm:filtration milne:cor:filtration-admissible",
    "03_filtration.tex:38-155 chooses bounded-degree minors over fixed K_1, "
    "using x_i=theta^(N^i); it expressly excludes coefficients in "
    "K_1(theta). Lines 160-241 reduce all subobjects to the unique "
    "largest defect maximizer, while 315-442 supplies uniform block "
    "bounds, finite local-field descent and then the cited "
    "Colmez-Fontaine admissibility implication. None is independently "
    "proved by the catalog.",
    [
        "Retain the invertible Rosati-symmetric E-antilinear u hypothesis "
        "and the fixed pre-extension coefficient field for avoidance.",
        "Check reduction to stable subobjects, uniform minor bounds "
        "for all K_0-subisocrystals, descent of all tensors to a finite "
        "local field and the balanced cocharacter orbit before "
        "applying weakly-admissible-implies-admissible.",
    ],
)
assess(
    "milne:prop:weil milne:lem:weil-orthogonality "
    "milne:lem:weil-divisor-span milne:lem:cm-reduction",
    "04_weil.tex:1-112, 205-265 and 330-439 separates the no-invertible-u "
    "zero-pairing branch from the invertible-u simultaneous rational "
    "Lefschetz branch. It descends the whole Galois-stable determinant "
    "sum, not each embedding line. 05_reduction.tex:18-80,160-205 "
    "uses actual rational-idempotent abelian factors of powers and "
    "balanced signatures, not an assumed split-Weil algebraicity theorem.",
    [
        "Check rational descent of the full determinant space and "
        "rational projector/field-action/divisor lifts on one local "
        "auxiliary, with compatible realization and specialization.",
        "Do not infer arbitrary-dimensional characteristic-zero Weil "
        "algebraicity or a direct dependency on the standalone Weil "
        "geometric tail from this internal section.",
    ],
)
assess(
    "milne:lem:lift-hom",
    "01_preliminaries.tex:144-204 starts with a specified rational "
    "algebraic special-fiber homomorphism over a complete mixed-"
    "characteristic DVR finite over W(F). Filtration preservation "
    "is then used with filtered Dieudonne, Tate, specified-map "
    "Serre-Tate and formal existence. Arbitrary Q_p-linear maps are "
    "not asserted algebraic.",
    [
        "Check compatibility of the prescribed algebraic f_0, "
        "denominator clearing and integral p-divisible-group lift, "
        "algebraization and uniqueness preserving the rational identities.",
    ],
)
assess(
    "milne:cor:all-hodge-specialization",
    "05_reduction.tex:252-320 fixes one good rational Tate-class theory "
    "R before A and gamma vary. CM rationality supplies its existence "
    "through Milne2009 Theorem 4.5; CM transport and injective pullback "
    "give uniqueness in R, with the crystalline equality after extension "
    "from K_0 to C_w. This is cohomological membership, not algebraicity.",
    [
        "Establish CM rationality and transport, and check the cited "
        "theory's (R1), (R4), goodness (R3) and injectivity hypotheses.",
        "Neither uniqueness modulo rational equivalence nor a "
        "representing algebraic cycle follows from this statement alone.",
    ],
)
assess(
    "milne:cor:algebraic-specialization milne:import:cm-hodge-theorem",
    "05_reduction.tex:370-448 explicitly adds OpenAI's October 6 CM "
    "Hodge Theorem 1.1. A CM auxiliary cycle is spread to Qbar, "
    "specialized, and pulled back as N^(-2r)(Nb)^*Z_0. This "
    "additional-manuscript input belongs to the algebraicity "
    "consequence only, not the main rationality proof.",
    [
        "Verify the external CM theorem and its exact applicability "
        "separately; this inventory does not adopt it or certify its "
        "formalization/application boundary.",
        "Check spreading, good-reduction cycle specialization and "
        "rational Chow pullback simultaneously in all realizations; "
        "no unique Chow representative or generic-fiber lift is asserted.",
    ],
)
assess(
    "weil:p3ab:quadratic-five weil:p3ab:split-sixfolds",
    "The declarations are at paper.tex:79-94 and their detached proofs "
    "at 1672-1834 after common setup 1611-1670. The source separately "
    "supplies (a)-(c) by actual columns/independence and checks (d) "
    "for arbitrary integer net exponents and the same fixed CM line "
    "list. It then invokes the tensor criterion and the companion "
    "CM Hodge theorem. The inventory is not a second proof of those "
    "theorems or of the geometric algebraicity input.",
    [
        "Retain the unital imaginary-quadratic action; for dimension "
        "six require the actual compatible rational Hermitian form "
        "to be hyperbolic of signature (3,3), not signature alone.",
        "Both condition (c) and all-degree determinant supply (d), "
        "the tensor criterion and CM-Hodge input remain separate "
        "dependencies; a proper hyperbolic summand is not assumed "
        "hyperbolic in the source proof.",
    ],
)
assess(
    "weil:p3:tensor-criterion",
    "paper.tex:558-620 assumes toric H_0 with a chosen finite CM line "
    "list, admissible classical blocks, actual derived-group product "
    "containment (c), and CM supply for every balanced determinant "
    "list with arbitrary repetitions (d). Saturation is the stronger "
    "singleton-supply condition used for adjoining arbitrary CM "
    "factors. The catalog records this criterion, not its proof.",
    [
        "Verify all-degree invariant spanning, scalar-conjugate balance "
        "and rational Hodge lifts/algebraicity through the companion "
        "CM theorem before concluding HC on all powers.",
        "Condition (c) is not central-character independence and "
        "does not imply (d); unsaturated data do not automatically "
        "give the additional arbitrary CM-product clause.",
    ],
)
assess(
    "weil:p3:cm-operations",
    "paper.tex:280-334 defines CM supply using images of full CM-source "
    "cohomology. Closure operations alone do not turn every source "
    "cohomology vector into an algebraic class: the final rational "
    "Hodge-class assertion uses a rational Hodge lift and explicitly "
    "imports OpenAICM2026 Theorem 1.1.",
    [
        "Separate closure of the supply subspaces from algebraicity "
        "of their rational Hodge classes; the latter requires the "
        "additional CM theorem, unverified by this catalog.",
    ],
)
assess(
    "weil:p3sw:seed weil:p3sw:relative-kernel weil:p3sw:coherent-sheaf "
    "weil:p3sw:coherent-action",
    "paper.tex:2001-2022 and 2500-2582 state two separately disjoint "
    "Abel orbits and uniform vanishing for every Picard twist; they "
    "do not assert cross-orbit disjointness. Lines 2699-2798 require "
    "ordinary product ideals, arbitrary base change and an actual "
    "positive-rank perfect sheaf E, not merely a K-class. "
    "Lines 2889-3010 transport associative line-kernel compositors "
    "rather than inferring them from simplicity.",
    [
        "Audit compact-type smoothing, polarized Picard/theta "
        "determinants, proper uniform vanishing, finite-intersection "
        "Tor and flatness, the two-term transform and positive rank.",
        "Retain the coherent (unital associative) action and free "
        "finite translation quotient, not just individual "
        "isomorphisms or a numerical Chern character.",
    ],
)
assess(
    "weil:p3sw:support-trilinear weil:p3sw:support-elliptic-star",
    "paper.tex:2055-2124 records the trilinear marked-index bound and "
    "the elliptic-star vanishing used by the seed. The former counts "
    "indices, not distinct triples, under a bound on every coordinate "
    "fiber; the latter assumes a finite subgroup of order at least "
    "four injective on each elliptic coordinate and degree-two line "
    "bundles. Neither catalog entry is a new finite or geometric proof.",
    [
        "Check the marked-index counting argument, coordinate-injectivity "
        "hypotheses and the source's passage from support to the "
        "stated ideal-sheaf vanishing before using the smoothing argument.",
    ],
)
assess(
    "weil:p3sw:support-finite-model weil:p3sw:support-local-tor",
    "paper.tex:2162-2181 requires a regular finite-dimensional Noetherian "
    "base, a projective morphism and a flat coherent sheaf for its "
    "arbitrary derived base-change statement; paper.tex:2658-2673 "
    "requires smooth curves in a smooth threefold with finite "
    "intersection for ordinary product ideals and higher-Tor vanishing. "
    "These hypotheses matter to the relative kernel; the inventory "
    "does not establish the underlying local algebra.",
    [
        "Audit the bounded locally free model, ordinary restriction "
        "under arbitrary base change and fiberwise amplitude claim.",
        "Check the regular-local Tor argument, injectivity of ideal "
        "multiplication and zero-dimensional correction; do not "
        "replace product ideals by reduced-union ideals without it.",
    ],
)
assess(
    "weil:p3sw:abel-character weil:p3sw:invariant-orbit-ext "
    "weil:p3sw:invariant-ext weil:p3sw:invariant-one-factor-rank "
    "weil:p3sw:invariant-product-rank",
    "paper.tex:4218-4240 fixes the full normalized Abel-ideal Betti "
    "character. Lines 4331-4349 uses a transitive orbit of disjoint "
    "Abel curves with its canonical linearization; 4477-4486 asserts "
    "6+36+6=48 for invariant full derived Ext^2 of the product. "
    "Lines 4584-4644 supplies one-factor rank six and product rank 48. "
    "These are source calculations needed by the injectivity sandwich, "
    "not computations independently replayed by this inventory.",
    [
        "Check the normal-deformation and full derived Ext calculation, "
        "finite-group invariants, Kunneth decomposition, normalized "
        "character and both contraction-rank assertions with the "
        "specified coherent linearizations.",
        "H^2(End) alone is insufficient; an asserted dimension or "
        "cataloged matrix formula is not an exact-rank certificate.",
    ],
)
assess(
    "weil:p3sw:hh-triangle weil:p3sw:hh-transport "
    "weil:p3sw:invariant-injectivity",
    "paper.tex:3074-3119,3221-3271 fixes the raw jet, divided powers "
    "and left-interior convention for sigma ob=c. Lines 4695-4815 "
    "use the full invariant derived Ext^2 dimension 48 and "
    "rank(c)=48, then enhanced Fourier-Mukai evaluation/character "
    "transport with the [-3] sign. The transported map is not "
    "identified with a separately normalized Betti transform.",
    [
        "Independently justify the raw Hochschild-Atiyah identity, "
        "full invariant Ext calculation, contraction ranks and "
        "enhanced coherent transport; the rank sandwich is only "
        "conditional on these premises.",
        "Do not replace full derived Ext^2 by H^2(End), or "
        "assume naturality of sigma on arbitrary Ext classes.",
    ],
)
assess(
    "weil:p3sw:fourier-matrix weil:p3sw:spin-identity "
    "weil:p3sw:polarized-seed weil:p3sw:ordered-stabilizer "
    "weil:p3sw:exceptional-character weil:p3sw:hodge-circle",
    "paper.tex:5026-5040,5108-5136 separates the finite Clifford "
    "contraction convention from Hochschild left interior. "
    "Lines 5258-5465 uses the actual polarized seed and its "
    "homological Hermitian Gram blocks and distinguishes the "
    "ordered line stabilizer from the pointwise spinor stabilizer. "
    "Lines 5560-5697 asserts a nonzero rational Weil component "
    "and Hodge type throughout the compatible domain. The geometric "
    "spin stabilizer J is not the actual-group independence result.",
    [
        "Verify the fixed transform for all algebraic spin elements, "
        "normalization, polarization/Hermitian dictionary and nonzero "
        "exceptional component of the actual sheaf.",
        "Check rational descent of the two conjugate Weil lines and "
        "the polarized Hodge-circle containment without assuming "
        "rational square roots of all determinants or geometric "
        "autoequivalences for arbitrary spin elements.",
    ],
)
assess(
    "weil:p3sw:descent-duality weil:p3sw:twisted-descent "
    "weil:p3sw:ordinary-conversion",
    "paper.tex:5728-6195 keeps a=-At_BF, form-degree (2pi i) "
    "normalizations and full derived Ext throughout duality, "
    "determinant-normalized mu_r descent and ordinary projective-"
    "bundle conversion. Rationality of the twisted Betti character "
    "uses finite trace, not an unsupported rationality assertion "
    "for an individual embedding line.",
    [
        "Check the even-transpose sign, associative gerbe cocycle, "
        "perfect determinant/unit/trace splitting and exponential "
        "semiregularity comparison on full obstruction groups.",
        "Check the exact finite-band class, lines convention, "
        "relative ample/anticanonical line and algebraic extraction "
        "after projective-bundle conversion.",
    ],
)
assess(
    "weil:p3sw:projective-germ weil:p3sw:bf-coefficients "
    "weil:p3sw:bf-one-step weil:p3sw:bf-artin-character",
    "paper.tex:6380-6416 is restricted to ordinary coherent sheaves "
    "on a smooth analytic projective germ, injective full central "
    "semiregularity, and flat de Rham classes themselves in F^k. "
    "Lines 6459-6936 concerns the specified successive thickenings "
    "A_(nu+1)->A_nu with central coefficient modules. "
    "Lines 7044-7146 invokes analytic Quot and Artin approximation "
    "preserving the central quotient, not the entire formal tower.",
    [
        "Verify absolute perfectness and full coefficient Ext "
        "base change, the raw obstruction/conormal signs and "
        "restricted Gauss-Manin square, plus relative character "
        "identification needed for induction.",
        "Check analytic Quot/Artin hypotheses, actual flat-sheaf "
        "effectivity and algebraic fiber characters. This is not "
        "a theorem about arbitrary perfect complexes, arbitrary "
        "Artinian extensions or nonprojective deformations.",
    ],
)
assess(
    "weil:p3sw:local-algebraicity weil:p3sw:endpoint-two-generators "
    "weil:p3sw:spread weil:p3sw:endpoint-all-lattices "
    "weil:p3sw:weil-plane",
    "paper.tex:7520-7633 obtains local algebraicity by ordinary-sheaf "
    "deformation and projective extraction, then uses a nonzero "
    "rational vector and an algebraic quadratic endomorphism to "
    "span the whole Weil plane. Lines 7666-7680,7870-8024 invokes "
    "analytic Hilbert spread, the elementary hyperbolic-basis "
    "assertion, a lattice-clearing algebraic isogeny and u=2u_0 "
    "to remove the seed d>=3 restriction. None is supplied by "
    "the actual-group or determinant-supply audits.",
    [
        "Discharge the seed, full semiregularity/descent and "
        "projective-germ premises before local algebraicity.",
        "Verify flat subsystem/Hilbert-class constancy on singular "
        "and nonreduced parameters, proper good images and the "
        "Baire passage to every compatible marked period.",
        "Retain the actual hyperbolic homological Hermitian form; "
        "a rational K-isometry and lattice denominator suffice "
        "for the source's final isogeny, without a rational spin lift.",
    ],
)


def digest(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def locate(path, first=None, last=None):
    value = str(path)
    if first is not None:
        value += f"#L{first}-L{last if last is not None else first}"
    return value


def text_statement(value):
    return value if isinstance(value, str) else json.dumps(value, ensure_ascii=True)


def source_relative(ns, record):
    if ns == "weil":
        return TAIL["source_path"]
    return str(Path(SOURCE_BASE[ns]) / record["source_path"])


def direct_proof(source, end_line):
    lines = source.splitlines(keepends=True)
    offset = sum(map(len, lines[:end_line]))
    rest = source[offset:]
    proof = re.search(r"\\begin\{proof\}", rest)
    formal = re.search(r"\\begin\{(?:theorem|lemma|proposition|corollary)\}", rest)
    if not proof or (formal and formal.start() < proof.start()):
        return []
    stop = rest.index(r"\end{proof}", proof.end())
    return [[
        end_line + rest.count("\n", 0, proof.start()) + 1,
        end_line + rest.count("\n", 0, stop) + 1,
    ]]


def old_evidence_for(claim):
    wanted = set(claim["old_evidence_ids"])
    result = [e for e in INDEX["old_evidence"] if e["old_evidence_id"] in wanted]
    assert len(result) == len(wanted)
    for e in result:
        assert e["subject"]["subject_id"] == claim["old_claim_id"]
        assert e["subject"]["content_hash"] == claim["old_content_hash"]
    return result


def historical_source_evidence():
    return [
        {
            "path": str(OLD / rel),
            "sha256": digest(OLD / rel),
            "role": role,
        }
        for rel, role in (
            (OTHER_REL, "source catalog; not a proof"),
            (TAIL_REL, "source catalog including detached proofs; not a proof"),
            (POPULATE_REL, "population code inspected, not executed"),
            ("research/MATH_STATE.json", "old claim/hash/evidence bindings only"),
            ("research/PROOF_GRAPH.json", "historical source dependency projection"),
        )
    ]


def main():
    assert Path.cwd().resolve() == ROOT
    prior = json.loads((ROOT / "PRIOR_DRAFTS.json").read_text())
    prior_artifacts = {x["path"]: x for x in prior["artifacts"]}
    source_evidence = historical_source_evidence()
    for item in source_evidence:
        relative = str(Path(item["path"]).relative_to(OLD))
        assert (OLD / relative).stat().st_size == prior_artifacts[relative]["bytes"]
        indexed_artifact = next(x for x in INDEX["artifacts"] if x["path"] == relative)
        preserved = indexed_artifact.get("preserved_version")
        if preserved:
            assert item["sha256"] == preserved["sha256"]
            assert (OLD / relative).stat().st_size == preserved["bytes"]

    all_records = {}
    texts = {}
    formal_counts = collections.Counter()
    for ns, m in MANUSCRIPTS.items():
        for c in m["claims"]:
            assert c["id"] not in all_records
            all_records[c["id"]] = c
            rel = source_relative(ns, c)
            source = texts.setdefault(rel, (OLD / rel).read_text())
            if c["environment"] in {"theorem", "lemma", "proposition", "corollary"}:
                declaration = source.splitlines()[c["start_line"] - 1:c["end_line"]]
                assert r"\begin{" + c["environment"] + "}" in declaration[0]
                assert r"\end{" + c["environment"] + "}" in declaration[-1]
                assert r"\label{" + c["label"] + "}" in "\n".join(declaration)
                formal_counts[ns] += 1

    weil_source = (OLD / TAIL["source_path"]).read_text()
    texts[TAIL["source_path"]] = weil_source
    detached = {c["id"]: c for c in TAIL["earlier_claims_with_tail_proofs"]}
    for c in TAIL["claims"]:
        assert c["id"] not in all_records
        all_records[c["id"]] = c
        declaration = weil_source.splitlines()[c["start_line"] - 1:c["end_line"]]
        assert r"\begin{" + c["kind"] + "}" in declaration[0]
        assert r"\end{" + c["kind"] + "}" in declaration[-1]
        assert r"\label{" + c["label"] + "}" in "\n".join(declaration)
        for a, b in c["proof_ranges"]:
            proof = weil_source.splitlines()[a - 1:b]
            assert r"\begin{proof}" in proof[0] and r"\end{proof}" in proof[-1]
    pattern = re.compile(
        r"\\begin\{(theorem|lemma|proposition|corollary)\}(?:\[[^\]]*\])?"
    )
    head_ids = set()
    for match in pattern.finditer(weil_source):
        first = weil_source.count("\n", 0, match.start()) + 1
        if first > 1610:
            break
        end = weil_source.index(r"\end{" + match.group(1) + "}", match.end())
        body = weil_source[match.end():end].strip()
        label = re.search(r"\\label\{([^}]+)\}", body).group(1)
        claim_id = "weil:" + label
        head_ids.add(claim_id)
        assert claim_id not in all_records
        all_records[claim_id] = {
            "id": claim_id,
            "label": label,
            "kind": match.group(1),
            "source_path": TAIL["source_path"],
            "start_line": first,
            "end_line": weil_source.count("\n", 0, end) + 1,
            "statement": body,
        }
    assert len(head_ids) == 16 and len(TAIL["claims"]) == 33
    assert set(detached) <= head_ids
    assert collections.Counter(c["kind"] for c in TAIL["claims"]) == {
        "theorem": 1, "lemma": 14, "proposition": 18,
    }
    assert len(re.findall(r"\\begin\{proof\}", "\n".join(
        weil_source.splitlines()[1610:]
    ))) == 36
    for c in detached.values():
        proof = weil_source.splitlines()[c["start_line"] - 1:c["end_line"]]
        assert r"\begin{proof}" in proof[0] and r"\end{proof}" in proof[-1]
    assert hashlib.sha256(
        "".join(weil_source.splitlines(keepends=True)[1610:]).encode()
    ).hexdigest() == TAIL["read_coverage"]["tail_utf8_sha256"]

    source_files = {}
    for ns in EXPECTED:
        if ns == "weil":
            paths = [TAIL["source_path"]]
        else:
            paths = [c["path"] for c in OTHER["coverage"] if c["namespace"] == ns]
        reference = next(
            (m for m in REFERENCE["manuscripts"]
             if Path(m["source_directory"]).name == Path(SOURCE_BASE[ns]).name),
            None,
        )
        files = []
        for rel in paths:
            path = OLD / rel
            family_rel = str(Path(rel).relative_to(SOURCE_BASE[ns]))
            expected = next(
                (x for x in reference["tex_sources"] if x["path"] == family_rel),
                None,
            ) if reference else None
            item = {
                "path": str(path),
                "sha256": digest(path),
                "lines": len(path.read_text().splitlines()),
                "directly_read_ranges_this_review": READ_RANGES[ns].get(family_rel, []),
                "remaining_access": "structural extraction and catalog metadata only",
                "pinned_manifest_sha256": expected["sha256"] if expected else None,
                "matches_pinned_manifest": digest(path) == expected["sha256"] if expected else None,
            }
            if expected:
                assert item["matches_pinned_manifest"]
                ref_path = Path(reference["source_directory"]) / family_rel
                assert ref_path.exists() and digest(ref_path) == expected["sha256"]
                item["reference_copy_path"] = str(ref_path)
                item["reference_copy_matches_manifest"] = True
            files.append(item)
        source_files[ns] = (reference, files)

    for ns, count in EXPECTED.items():
        unit = ns + "-source-inventory"
        u = next(x for x in INDEX["units"] if x["unit_id"] == unit)
        claims = [c for c in INDEX["claim_versions"] if c.get("unit") == unit]
        ids = {c["old_claim_id"] for c in claims}
        records = {k: v for k, v in all_records.items() if k.startswith(ns + ":")}
        ledger = [c for c in STATE["claims"] if c["claim_id"] in ids]
        graph_nodes = [c for c in INDEX["old_graph_nodes"] if c.get("unit") == unit]
        assert len(claims) == len(ids) == len(records) == len(ledger) == count
        assert ids == set(u["old_claim_ids"]) == set(records)
        assert ids == {c["old_node_id"] for c in graph_nodes}
        assert len(graph_nodes) == count
        for c in claims:
            r = records[c["old_claim_id"]]
            assert c["old_version"] == c["latest_old_version"] == 1
            assert not c["duplicate_or_superseded_version"]
            assert c["statement"] == text_statement(r["statement"])
            assert c["source_lines"] == [r["start_line"], r["end_line"]]
            old_claim = next(x for x in ledger if x["claim_id"] == c["old_claim_id"])
            assert old_claim["version"] == 1
            assert old_claim["content_hash"] == c["old_content_hash"]
            assert old_claim["natural_statement"] == c["statement"]
            assert not old_claim["formal_statement"]
            context = next(x for x in STATE["contexts"]
                           if x["content_hash"] == old_claim["context"]["content_hash"])
            assert context["context_id"] == c["old_context_id"]
            assert context["context_id"] == old_claim["context"]["subject_id"]
            assert old_claim["context"]["kind"] == "context"
            assert old_claim["external_assumptions"] == c["external_assumptions"]
            node = GRAPH["nodes"][c["old_claim_id"]]
            assert node["statement"] == c["statement"]
            assert sorted(node["depends_on"]) == sorted(c["dependencies"])
            assert node["source_lines"] == c["source_lines"]
            assert node["evidence"] == c["proof_or_source_artifacts"]
            graph_metadata = next(x for x in graph_nodes
                                  if x["old_node_id"] == c["old_claim_id"])
            assert graph_metadata["statement"] == node["statement"]
            assert graph_metadata["dependencies"] == node["depends_on"]
            assert graph_metadata["source_lines"] == node["source_lines"]
            assert graph_metadata["evidence"] == node["evidence"]
            assert graph_metadata["historical_status"] == node["status"]
            assert graph_metadata["historical_reviewer_flag"] == node["reviewer_confirmed"]
            for entry in old_evidence_for(c):
                actual = next(x for x in STATE["evidence"]
                              if x["evidence_id"] == entry["old_evidence_id"])
                for field in ("subject", "tier", "verdict", "produced_by", "artifact"):
                    assert entry[field] == actual[field]

        classification_counts = collections.Counter()
        assessments = []
        bibliography = {
            b["key"]: b for b in (
                TAIL["bibliography"] if ns == "weil"
                else MANUSCRIPTS[ns]["bibliography"]
            )
        }
        citation_occurrences = {c["id"]: c for c in TAIL["external_citation_occurrences"]}
        flags = [
            f for f in OTHER["unverified_possible_gaps"]
            if any(i.startswith(ns + ":") for i in f["claim_ids"])
        ] if ns != "weil" else []
        for c in claims:
            claim_id = c["old_claim_id"]
            r = records[claim_id]
            classification = r.get("classification", "manuscript_assertion")
            classification_counts[classification] += 1
            source_rel = source_relative(ns, r)
            proof_ranges = r.get("proof_ranges")
            if proof_ranges is None:
                proof_ranges = (
                    [[detached[claim_id]["start_line"], detached[claim_id]["end_line"]]]
                    if claim_id in detached
                    else direct_proof(texts[source_rel], r["end_line"])
                    if r.get("environment", r.get("kind")) in {
                        "theorem", "lemma", "proposition", "corollary"
                    } else []
                )
            evidence = [
                f"research/DRAFT_REVIEW_INDEX.json#claim_versions[old_claim_id={claim_id},old_version=1]",
                f"{OLD / 'research/MATH_STATE.json'}#claims[claim_id={claim_id},version=1]",
                f"{OLD / 'research/PROOF_GRAPH.json'}#nodes/{claim_id}",
                locate(OLD / source_rel, r["start_line"], r["end_line"]),
            ]
            catalog_rel = TAIL_REL if ns == "weil" else OTHER_REL
            section = (
                "claims" if ns == "weil" and claim_id not in head_ids
                else "earlier_claims_with_tail_proofs" if ns == "weil" and claim_id in detached
                else f"manuscripts[namespace={ns}]/claims"
            )
            if ns != "weil" or claim_id not in head_ids or claim_id in detached:
                evidence.append(f"{OLD / catalog_rel}#{section}[id={claim_id}]")
            else:
                evidence.append(
                    f"{OLD / POPULATE_REL}#inventory:head declaration extraction before line 1611"
                )
            evidence.extend(locate(OLD / source_rel, a, b) for a, b in proof_ranges)
            evidence.extend(
                locate(OLD / SOURCE_BASE[ns] / path, a, b)
                for path, a, b in EXTRA_SOURCE_RANGES.get(claim_id, [])
            )
            for loc in r.get("additional_source_locators", []):
                evidence.append(locate(
                    OLD / SOURCE_BASE[ns] / loc["source_path"],
                    loc["start_line"], loc["end_line"],
                ))

            external = []
            if ns != "weil":
                citations = r["external_citations"]
                for cite in citations:
                    b = bibliography[cite["key"]]
                    external.append({
                        "status": "catalogued_not_adopted_or_externally_verified",
                        "kind": classification if classification in {
                            "established_import_as_cited", "additional_manuscript_input", "conjecture"
                        } else "source_citation",
                        "key": cite["key"], "locator": cite["locator"],
                        "bibliography_metadata_as_catalogued": b["metadata"],
                        "bibliography_evidence": locate(
                            OLD / SOURCE_BASE[ns] / b["source_path"],
                            b["start_line"], b["end_line"],
                        ),
                        "role": "Source attribution/applicability input, not an accepted assumption of this review.",
                    })
            elif claim_id not in head_ids:
                deps = r["proof_dependencies"]
                for cite_id in deps["external_citation_ids"]:
                    cite = citation_occurrences[cite_id]
                    external.append({
                        "status": "catalogued_not_adopted_or_externally_verified",
                        "kind": "source_citation_or_context_as_printed",
                        "keys": cite["keys"],
                        "locator": cite.get("locator") or cite.get("prose_locator"),
                        "role": cite["role"],
                        "evidence": locate(OLD / source_rel, *cite["source_lines"]),
                    })
                for uncited in deps.get("uncited_inputs", []):
                    external.append({
                        "status": "inventoried_uncited_source_input_not_independently_verified",
                        "kind": "uncited_standard_or_connecting_input_as_catalogued",
                        "statement": uncited,
                    })
            else:
                source_lines = texts[source_rel].splitlines()
                ranges = [[max(1, r["start_line"] - 12), r["end_line"]]] + proof_ranges
                cite_keys = set()
                for a, b in ranges:
                    for match in re.finditer(
                        r"\\cite(?:\[[^\]]*\])?\{([^}]+)\}",
                        "\n".join(source_lines[a - 1:b]),
                    ):
                        cite_keys.update(x.strip() for x in match.group(1).split(","))
                for key in sorted(cite_keys):
                    b = bibliography.get(key)
                    external.append({
                        "status": "source_reference_only_not_adopted_or_externally_verified",
                        "kind": "source_citation",
                        "key": key,
                        "role": "Printed citation in declaration/prelude or its source proof; no external applicability audit.",
                        "bibliography_evidence": locate(
                            OLD / source_rel, b["start_line"], b["end_line"]
                        ) if b else "No bibliography record resolved in the tail catalog.",
                    })

            if claim_id in {
                "weil:p3:cm-operations", "weil:p3:tensor-criterion",
                "weil:p3ab:quadratic-five", "weil:p3ab:split-sixfolds",
            }:
                external.append({
                    "status": "additional_manuscript_input_not_adopted",
                    "kind": "additional_manuscript_input",
                    "statement": "OpenAICM2026 Theorem 1.1: rational HC for all complex CM abelian varieties, "
                    "used in cm-operations to algebraize rational Hodge lifts.",
                    "evidence": locate(OLD / source_rel, 280, 334),
                    "limitation": "No CM source proof/formalization is audited or accepted by this source-inventory unit.",
                })

            roles = {
                "manuscript_assertion": (
                    "manuscript_assertion_as_attributed_not_an_independent_Argus_proof",
                    "The catalog reproduces/decomposes a source assertion presented there as proved. "
                    "Its printed hypotheses and conventions remain in force; parsing and ledger "
                    "registration establish neither its mathematical truth nor its negation.",
                    "No independent proof is submitted by this catalog; audit the cited source "
                    "argument and its concrete prerequisites before adopting the conclusion.",
                ),
                "conditional_conclusion": (
                    "conditional_conclusion_with_explicit_premises_not_independently_proved",
                    "The catalog retains a source conditional deduction, not an unconditional "
                    "existence or algebraicity theorem. Its antecedents must be supplied in the "
                    "specified scope and its source proof remains unaudited by the catalog.",
                    "Discharge the exact antecedents, including their quantifiers, and independently "
                    "justify the source's deduction; registration is not premise discharge.",
                ),
                "assumption": (
                    "explicit_source_premise_not_established_by_the_inventory",
                    "This is an input/hypothesis, not a result constructed or proved by Argus. "
                    "Its role is to delimit the conditional conclusions that use it.",
                    "Provide this precise input in every application; do not silently weaken "
                    "it or infer existence from a downstream conditional statement.",
                ),
                "conjecture": (
                    "conjecture_or_historical_question_as_attributed_not_an_adopted_premise",
                    "This record identifies an open/general conjecture or a historical question "
                    "as described in the manuscript. A special/conditional manuscript conclusion "
                    "does not establish the unrestricted conjecture by catalog registration.",
                    "No general proof or external exact-formulation check is submitted here; "
                    "retain the source-limited historical formulation and stated restricted scope.",
                ),
                "established_import_as_cited": (
                    "import_as_cited_not_externally_verified_or_adopted_by_this_review",
                    "The source treats this as an imported theorem. The inventory records its "
                    "printed statement, version-dependent locator and role; it does not verify "
                    "the external source or the application's hypotheses.",
                    "If used as a proof input, check the exact external version, hypotheses, "
                    "coefficient/convention dictionary and applicability at the cited step.",
                ),
                "additional_manuscript_input": (
                    "additional_manuscript_theorem_not_verified_or_adopted",
                    "A separate manuscript's theorem is explicitly invoked, not proved by this "
                    "catalog or by recording its citation.",
                    "Assess that manuscript and its applicability separately; no correctness, "
                    "formal applicability or acceptance is inherited here.",
                ),
            }
            assessment, argument, default_gap = roles[classification]
            gaps = [default_gap]
            if claim_id in SPECIFIC:
                argument, specific_gaps = SPECIFIC[claim_id]
                gaps.extend(specific_gaps)
            deps = c["dependencies"]
            if deps:
                gaps.append(
                    "Historical graph source-claim prerequisites (not accepted premises): "
                    + ", ".join(deps) + "."
                )
            if ns != "weil":
                for flag in flags:
                    if claim_id in flag["claim_ids"]:
                        gaps.append(
                            f"Existing {flag['id']} ({flag['kind']}), still unverified: "
                            + flag["statement"]
                        )
                        evidence.append(f"{OLD / OTHER_REL}#unverified_possible_gaps[id={flag['id']}]")
            else:
                detail = r.get("proof_dependencies", {})
                contextual = detail.get("contextual_claim_labels", [])
                if contextual:
                    gaps.append(
                        "Additional contextual source prerequisites, not retained as graph "
                        "depends_on edges by the old population code: "
                        + ", ".join("weil:" + x for x in contextual) + "."
                    )
                if detail:
                    argument += (
                        " The catalog separately records explicit claim links, contextual "
                        "links, equations/sections, citations and uncited inputs; these "
                        "links are not independent mathematical evidence."
                    )
                if claim_id in detached:
                    evidence.append(
                        f"{OLD / TAIL_REL}#earlier_claims_with_tail_proofs[id={claim_id}]"
                    )
                    argument += (
                        " The old tail reader expressly did not read the earlier declaration; "
                        "this assessment cross-checks its indexed declaration against the "
                        "accessible full source and does not count the detached proof twice."
                    )
                if claim_id in head_ids:
                    gaps.append(
                        "This earlier declaration is outside the tail reader's assigned "
                        "1611-8285 range; its inventory/graph provenance is the population "
                        "script's head extraction, not a claim of tail-source coverage."
                    )

            historical = old_evidence_for(c)
            if historical:
                assessment = "source_assertion_with_hash_bound_separate_old_audit_judgement_not_inherited"
                argument += (
                    " There is also a hash-bound historical supporting judgement from a "
                    "separate actual-group or determinant-supply audit; that evidence "
                    "is not created by this source catalog and is not current acceptance."
                )
                for e in historical:
                    evidence.append(
                        f"research/DRAFT_REVIEW_INDEX.json#old_evidence[old_evidence_id={e['old_evidence_id']}]"
                    )
                    evidence.append(str(OLD / e["artifact"]))
                    gaps.append(
                        f"Historical {e['tier']} supports entry {e['old_evidence_id']} "
                        f"by {e['produced_by']} is bound to this exact old hash; its "
                        "separate audit scope and pending current review must not be "
                        "extended to the geometric tail, KS or Milne statements."
                    )
                if claim_id in {"weil:p3ab:hyperbolic", "weil:p3ab:determinant-supply"}:
                    argument += (
                        " The separate determinant audit imports Markman's Weil-plane "
                        "theorem and does not verify the manuscript's geometric proof "
                        "(determinant_supply_audit/report.tex:91-173)."
                    )
                    gaps.append(
                        "Separate DS support is conditional on its geometric import/"
                        "invariant-theory inputs; it is not a proof of p3sw:seed through "
                        "p3sw:weil-plane or of the external CM theorem."
                    )
                else:
                    argument += (
                        " The separate actual-group report limits itself to actual "
                        "column classification/independence, condition (c), not (d), "
                        "central-character independence or HC "
                        "(actual_group_audit/report.tex:787-819)."
                    )
            attribution = (
                f"OpenAI, {MANUSCRIPTS[ns]['title']}, "
                f"{MANUSCRIPTS[ns]['date_as_printed']}; prior Argus source-inventory "
                "reproduction/decomposition, version 1. No novelty or independent "
                "mathematical proof is attributed to the catalog."
                if ns != "weil" else
                "OpenAI, Weil classes and Hodge classes on abelian powers, October 6, 2026; "
                "prior Argus source inventory, version 1. The source credits Markman's "
                "secant-sheaf/spin construction and Weil-plane theorem "
                "(paper.tex:915-920,1836-1877); exact external attribution is not "
                "independently verified. Separate old audit judgements, where listed, "
                "are not catalog contributions or current acceptance. No novelty claim."
            )
            assessments.append({
                "old_claim_id": claim_id,
                "versions": [1],
                "assessment": assessment,
                "exact_scope": c["statement"],
                "decisive_argument": argument,
                "evidence": list(dict.fromkeys(evidence)),
                "external_assumptions": external,
                "gaps": gaps,
                "attribution": attribution,
            })

        reference, files = source_files[ns]
        catalog_coverage = (
            [c for c in OTHER["coverage"] if c["namespace"] == ns]
            if ns != "weil" else TAIL["read_coverage"]
        )
        if ns != "weil":
            for coverage in catalog_coverage:
                line_count = len((OLD / coverage["path"]).read_text().splitlines())
                covered = set()
                for a, b in coverage["read_ranges"]:
                    covered.update(range(a, b + 1))
                assert covered == set(range(1, line_count + 1))
                assert line_count == coverage["lines"]
                assert sum(b - a + 1 for a, b in coverage["read_ranges"]) == line_count
        else:
            covered = set()
            for a, b in catalog_coverage["inclusive_ranges"]:
                covered.update(range(a, b + 1))
            assert covered == set(range(1611, 8286))
            assert sum(b - a + 1 for a, b in catalog_coverage["inclusive_ranges"]) == 6675

        source_versions = {
            "old_workspace": str(OLD),
            "review_unit_dependencies_from_index": u["dependencies"],
            "old_snapshot_label": INDEX["snapshot"],
            "snapshot_access": "Snapshot manifest/archive not opened or modified. "
            "Old ledger, graph and population-script digests agree with preserved-version "
            "digests recorded in the complete read-only index; catalogs match manifest byte "
            "counts and their observed digests are recorded here, without inventing snapshot hashes.",
            "author_as_printed": "OpenAI",
            "title": MANUSCRIPTS[ns]["title"] if ns != "weil"
            else "Weil classes and Hodge classes on abelian powers",
            "date_as_printed": MANUSCRIPTS[ns]["date_as_printed"] if ns != "weil"
            else "October 6, 2026",
            "reference_manifest": str(REFERENCE_PATH),
            "reference_manifest_upstream_commit": REFERENCE["upstream_commit"],
            "manuscript_in_five_reference_manifest": reference is not None,
            "source_revision": reference["source_revision"] if reference else None,
            "version_access_limit": (
                "Accessible old and reference TeX copies match every listed source hash "
                "for this paper. This is content identity to the manifest, not an "
                "independent Git/revision-history or theorem verification."
                if reference else
                "Milne is an explicit old inventory input and its nine TeX files are "
                "accessible, but it is absent from the five-paper reference manifest. "
                "Observed file hashes do not establish an upstream revision; do not "
                "assign the manifest's commit to this manuscript."
            ),
            "files": files,
            "inventory_artifacts": source_evidence,
            "index_sha256_observed": digest(INDEX_PATH),
            "old_catalog_documented_read_coverage": catalog_coverage,
            "coverage_interpretation": "Old logged coverage is checked for file/range/line-count "
            "consistency, not independently certified as a historical reading event or proof audit. "
            "Current direct reading is bounded to the explicit ranges above; other source "
            "declarations are structurally matched and catalog records reconciled.",
            "reconciliation": {
                "distinct_claim_ids": count,
                "version_1_index_records": len(claims),
                "old_ledger_records": len(ledger),
                "old_graph_nodes": len(graph_nodes),
                "catalog_or_extracted_source_declarations": len(records),
                "id_statement_hash_span_and_graph_bindings_match": True,
                "old_context_and_evidence_bindings_match": True,
                "logged_source_coverage_matches_available_files": True,
                "duplicate_logged_coverage_lines": 0,
                "duplicate_or_superseded_claim_versions": 0,
                "old_formal_statements_empty": count,
                "source_classification_counts": dict(classification_counts),
                "old_evidence_links": sum(len(c["old_evidence_ids"]) for c in claims),
                "old_graph_statuses": dict(collections.Counter(
                    GRAPH["nodes"][c["old_claim_id"]]["status"] for c in claims
                )),
                "old_graph_reviewer_confirmed": sum(bool(
                    GRAPH["nodes"][c["old_claim_id"]].get("reviewer_confirmed")
                ) for c in claims),
                "mathematical_meaning": "Binding/coverage checks only; graph status, "
                "empty external_assumptions arrays, prose imports and acyclicity "
                "are not mathematical certificates.",
            },
            "external_literature_access": {
                "retrieved_for_this_review": False,
                "catalog_external_sources_read": False,
                "adopted_as_verified_assumptions": [],
                "unused_bibliographic_assertions": "Retained only as source inventory inputs. "
                "No unexamined theorem, publication date, URL or citation numbering is "
                "promoted to an externally verified assumption.",
                "separate_AG_DS_imports": "Their recorded provenance/scopes are distinguished "
                "below; no external import or acceptance is inherited by this inventory.",
            },
            "old_populate_script_assessment": {
                "executed": False,
                "contribution": "Namespace/statement/context registration and filtered claim "
                "dependencies; no mathematical proof or independent evidence submission.",
                "projection_limits": "INPUT_CLASSIFICATIONS have empty dependencies; context "
                "references, nonclaim equations/sections and unknown references are filtered. "
                "For Weil tail records only explicit claim_labels enter the graph, not "
                "contextual_claim_labels or external citations/uncited inputs.",
                "validation_limit": "Old math_state/proof_graph checks validate ledger/graph "
                "structure, not theorem correctness or faithful translation of every premise.",
            },
        }
        if ns != "weil":
            source_versions["contexts_and_definitions"] = MANUSCRIPTS[ns]["contexts_and_definitions"]
            source_versions["substantive_existing_flags"] = flags
            source_versions["declared_dependency_map"] = [
                x for x in OTHER["dependency_map"]
                if ns in json.dumps(x)
            ]
            source_versions["source_parsing_notes"] = OTHER["source_parsing_notes"]
            source_versions["bibliography_entry_count"] = len(MANUSCRIPTS[ns]["bibliography"])
            source_versions["formal_source_declaration_count"] = formal_counts[ns]
        else:
            source_versions["reconciliation"].update({
                "earlier_declarations": 16,
                "tail_declarations": 33,
                "detached_proofs_of_existing_ids": sorted(detached),
                "detached_proofs_are_not_additional_claim_ids": True,
                "tail_context_definition_records": 28,
                "tail_proof_environments": 36,
            })
            source_versions["substantive_existing_ambiguities"] = TAIL["source_ambiguities"]
            source_versions["contexts_and_definitions"] = TAIL["definitions"]
            source_versions["declared_dependency_paths"] = TAIL["main_theorem_dependency_paths"]
            source_versions["geometric_dependency_separation"] = TAIL["geometric_independence"]
            source_versions["tail_counts"] = TAIL["counts"]
            source_versions["classification_basis"] = (
                "The Weil source records do not supply the other catalog's explicit "
                "classification field. Here manuscript_assertion means an attributed "
                "source declaration with its exact hypotheses, not unconditional "
                "truth or an independently proved Argus theorem. External imports "
                "and the companion CM theorem are assessed separately."
            )
            source_versions["separate_old_judgements"] = [
                e for c in claims for e in old_evidence_for(c)
            ]
            source_versions["separate_audit_scope_passages_read"] = [
                locate(OLD / "research/actual_group_audit/report.tex", 59, 109),
                locate(OLD / "research/actual_group_audit/report.tex", 787, 819),
                locate(OLD / "research/determinant_supply_audit/report.tex", 71, 173),
            ]

        verdict = {
            "schema_version": 1,
            "unit_id": unit,
            "assessment": (
                f"{count} exact version-1 source records reconciled and principal attribution/"
                "dependency scope checked against bounded original-source reading. "
                "Source-only reproduction/decomposition, not a submitted independent "
                "mathematical proof, blanket correctness verdict, or refutation. "
                + ("Seven separate hash-bound old audit judgements are disclosed, not inherited. "
                   if ns == "weil" else "")
                + "Concrete obligations remain; native Host Reviewer acceptance pending."
            ),
            "result_class": "source_inventory",
            "source_versions": source_versions,
            "claim_assessments": assessments,
            "evidence": [
                str(ROOT / "OBJECTIVE.md"),
                str(ROOT / "PRIOR_DRAFTS.json"),
                str(INDEX_PATH) + f"#units[unit_id={unit}]",
                str(OLD / catalog_rel),
                str(OLD / POPULATE_REL),
                str(OLD / "research/MATH_STATE.json"),
                str(OLD / "research/PROOF_GRAPH.json"),
                str(REFERENCE_PATH),
            ],
            "independent_review": {
                "required": True,
                "status": "pending_host_reviewer",
            },
        }
        destination = ROOT / "research/draft_reviews" / unit / "verdict.json"
        assert destination.parent.name in {x + "-source-inventory" for x in EXPECTED}
        destination.parent.mkdir(parents=True, exist_ok=True)
        destination.write_text(json.dumps(verdict, ensure_ascii=False, indent=2) + "\n")
        print(f"{unit}: {count} distinct assessments; schema and source bindings checked")
    assert sum(EXPECTED.values()) == 191


if __name__ == "__main__":
    main()
