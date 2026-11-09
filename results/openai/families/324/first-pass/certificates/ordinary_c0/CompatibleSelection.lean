import OAI.Analysis.C0Absorption.Tags

open Set Filter Topology
open scoped NNReal BigOperators ZeroAtInfty
open OAI.C0Absorption

namespace Audit324
noncomputable section

variable {Γ : Type*} {B : CylinderBases Γ}

def PairingNull (m : ℕ → SourceSpace B) : Prop :=
  ∀ f : C0Ball → ℝ, BoundedTest (sourceClasses B) c0Origin f →
    Tendsto (fun i => completedPairing (sourceClasses B) c0Origin f (m i))
      atTop (nhds 0)

def CompatibleSubsequence (m : ℕ → SourceSpace B) : Prop :=
  ∃ φ : ℕ → ℕ, StrictMono φ ∧
    ∃ (h : ℕ) (F : ℕ → C0Ball → ℝ) (δ : ℝ) (K : ℝ≥0),
      0 < δ ∧ (∀ i, F i ∈ sourceClasses B h) ∧
      (∀ i, δ ≤ |completedPairing (sourceClasses B) c0Origin (F i) (m (φ i))|) ∧
      ∀ n (ε : Fin n → ℝ), (∀ i, |ε i| = 1) →
        LipschitzWith K (fun s => ∑ i, ε i * F i s)

def NoCompatible (m : ℕ → SourceSpace B) : Prop :=
  ¬ CompatibleSubsequence m

theorem PairingNull.subsequence {m : ℕ → SourceSpace B} (hm : PairingNull m)
    {φ : ℕ → ℕ} (hφ : StrictMono φ) : PairingNull (m ∘ φ) := by
  intro f hf
  exact (hm f hf).comp hφ.tendsto_atTop

theorem NoCompatible.subsequence {m : ℕ → SourceSpace B} (hn : NoCompatible m)
    {φ : ℕ → ℕ} (hφ : StrictMono φ) : NoCompatible (m ∘ φ) := by
  rintro ⟨ψ, hψ, h, F, δ, K, hδ, hF, hd, hLip⟩
  exact hn ⟨φ ∘ ψ, hφ.comp hψ, h, F, δ, K, hδ, hF, hd, hLip⟩

theorem compatible_detectors_false
    (m : ℕ → SourceSpace B) (_hm : PairingNull m) (hn : NoCompatible m)
    (F : ℕ → C0Ball → ℝ) (h : ℕ) (K : ℝ≥0)
    (hF : ∀ i, F i ∈ sourceClasses B h)
    (hLip : ∀ n (ε : Fin n → ℝ), (∀ i, |ε i| = 1) →
      LipschitzWith K (fun s => ∑ i, ε i * F i s))
    {δ : ℝ} (hδ : 0 < δ)
    (hd : ∀ i, δ ≤ |completedPairing (sourceClasses B) c0Origin (F i) (m i)|) :
    False :=
  hn ⟨id, strictMono_id, h, F, δ, K, hδ, hF, hd, hLip⟩

theorem VClass_compatible_false
    (m : ℕ → SourceSpace B) (hm : PairingNull m) (hn : NoCompatible m)
    (F : ℕ → C0Ball → ℝ) (h : ℕ) (K : ℝ≥0)
    (hF : ∀ i, F i ∈ VClass B h)
    (hLip : ∀ n (ε : Fin n → ℝ), (∀ i, |ε i| = 1) →
      LipschitzWith K (fun s => ∑ i, ε i * F i s))
    {δ : ℝ} (hδ : 0 < δ)
    (hd : ∀ i, δ ≤ |completedPairing (sourceClasses B) c0Origin (F i) (m i)|) :
    False := by
  apply compatible_detectors_false m hm hn F (2*h+1) K ?_ hLip hδ hd
  intro i
  simpa only [sourceClasses_odd] using VClass_mono (Nat.le_succ h) (hF i)

theorem VClass_disjoint_false
    (m : ℕ → SourceSpace B) (hm : PairingNull m) (hn : NoCompatible m)
    (F : ℕ → C0Ball → ℝ) (h : ℕ) (hF : ∀ i, F i ∈ VClass B h)
    (hdisj : Pairwise (fun i j => Disjoint (tsupport (F i)) (tsupport (F j))))
    {δ : ℝ} (hδ : 0 < δ)
    (hd : ∀ i, δ ≤ |completedPairing (sourceClasses B) c0Origin (F i) (m i)|) :
    False := by
  refine VClass_compatible_false m hm hn F h
    (4^h*B.L0+h*4^h*B.A) hF ?_ hδ hd
  intro n ε hε
  apply disjoint_supports_signed_lipschitz (convex_closedBall (0 : C0) 1)
    (fun i : Fin n => F i) (4^h*B.L0+h*4^h*B.A)
    (fun i => VClass_lipschitz B h (hF i)) ?_ ε hε
  intro i j hij
  exact hdisj (show (i : ℕ) ≠ (j : ℕ) from fun he => hij (Fin.ext he))

theorem tail_escape_false
    (F : ℕ → C0Ball → ℝ) (m : ℕ → SourceSpace B)
    (h : ℕ) (hF : ∀ i, F i ∈ VClass B h)
    (hm : PairingNull m) (hn : NoCompatible m)
    {δ cstar : ℝ} (hδ : 0 < δ) (hcstar : 0 < cstar)
    (hd : ∀ i, δ ≤ |completedPairing (sourceClasses B) c0Origin (F i) (m i)|)
    (N : ℕ → ℕ) (hN : Tendsto N atTop atTop)
    (hs : ∀ i s, s ∈ tsupport (F i) → cstar ≤ tau (N i) s.val) : False := by
  obtain ⟨H,φ,hφ,G,hG,hdG,hdis⟩ :=
    tail_separation F m hF hδ hcstar hd N hN hs
  exact VClass_disjoint_false (m ∘ φ) (hm.subsequence hφ) (hn.subsequence hφ)
    G H hG hdis (half_pos hδ) hdG

theorem small_remainders_false {Γ : Type*} {B : CylinderBases Γ} {γ : Γ}
    (r : ℕ → GeneratedRepresentation B γ) (ts : ℕ → List TailOperation) (h : ℕ)
    (hr : ∀ i, (r i).operations.length ≤ h) (hj : B.band γ ≤ h)
    (ht : ∀ i, (ts i).length ≤ h) (ha : ∀ i t, t ∈ ts i → t.scaleIndex ≤ h)
    (op : ℕ → CylinderOperation (B.coordinates γ))
    (hsmall : Tendsto (fun i => (op i).scale) atTop (nhds 0))
    (p : Cube (B.coordinates γ) → ℝ) (K : ℝ≥0) (hp : LipschitzWith K p)
    (suf : ℕ → List (CylinderOperation (B.coordinates γ)))
    (hlen : ∀ i, (suf i).length ≤ h)
    (horder : ∀ i t, t ∈ suf i → t.scale ≤ (op i).scale)
    (heq : ∀ i, (r i).cubeValue = applyOperations (suf i) ((op i).remainder.act p))
    (m : ℕ → SourceSpace B) (hm : PairingNull m) (hNo : NoCompatible m)
    {δ : ℝ} (hδ : 0 < δ)
    (hd : ∀ i, δ ≤ |completedPairing (sourceClasses B) c0Origin
      (fun s => (r i).value s*tailProduct (ts i) s) (m i)|) : False := by
  let a (i : ℕ) : ℝ := (h+1)*(op i).scale
  let b (i : ℕ) : ℝ := 2^h*K*(op i).scale
  have haPos (i : ℕ) : 0 < a i := by
    dsimp [a]; have := (op i).scale_pos; positivity
  have ha0 : Tendsto a atTop (nhds 0) := by simpa only [a,mul_zero] using hsmall.const_mul (h+1 : ℝ)
  have hb0 : Tendsto b atTop (nhds 0) := by simpa only [b,mul_zero] using hsmall.const_mul (2^h*(K : ℝ))
  have hsup (i : ℕ) (x : Cube (B.coordinates γ)) : |(r i).cubeValue x| ≤ b i := by
    rw [heq i]
    have hh := applyOperations_sup (suf i) (mul_nonneg (op i).scale_pos.le K.coe_nonneg)
      (fun x => localR_sup_lip (op i).point (op i).scale_pos p hp x) x
    rw [CylinderOperation.remainder_act]
    calc
      _ ≤ 2^(suf i).length*((op i).scale*K) := hh
      _ ≤ 2^h*((op i).scale*K) := mul_le_mul_of_nonneg_right
        (pow_le_pow_right₀ (by norm_num) (hlen i)) (mul_nonneg (op i).scale_pos.le K.coe_nonneg)
      _ = b i := by dsimp [b]; ring
  have hsupp (i : ℕ) (x : Cube (B.coordinates γ)) (hx : x ∈ tsupport (r i).cubeValue) :
      dist x (op i).point ≤ a i := by
    rw [heq i,CylinderOperation.remainder_act] at hx
    have hh := applyOperations_support_bound (suf i) (localR (op i).point (op i).scale p)
      (LipschitzWith.dist_left (op i).point) (fun x hx => localR_support_ball (op i).point (op i).scale_pos p hx) x hx
    have hs : ((suf i).map CylinderOperation.scale).sum ≤ (h : ℝ)*(op i).scale := by
      calc
        _ ≤ ((suf i).map (fun _ => (op i).scale)).sum := List.sum_le_sum (fun t ht => horder i t ht)
        _ = ((suf i).length : ℝ)*(op i).scale := by simp
        _ ≤ (h : ℝ)*(op i).scale := mul_le_mul_of_nonneg_right (by exact_mod_cast hlen i) (op i).scale_pos.le
    dsimp [a]
    linarith
  obtain ⟨φ,hφ,F,hF,hdF,hLip⟩ := small_supports_compatible r ts h hr hj ht ha
    (fun i => (op i).point) a b haPos ha0 hb0 hsup hsupp m hδ hd
  exact VClass_compatible_false (m ∘ φ) (hm.subsequence hφ) (hNo.subsequence hφ) F (h+1) _ hF hLip (half_pos hδ) hdF


theorem constant_detector_false (f : C0Ball → ℝ) (hf : BoundedTest (sourceClasses B) c0Origin f)
    (m : ℕ → SourceSpace B) (hm : PairingNull m) (hNo : NoCompatible m) {δ : ℝ} (hδ : 0 < δ)
    (hd : ∀ i, δ ≤ |completedPairing (sourceClasses B) c0Origin f (m i)|) : False := by
  have hh := (hm f hf).abs
  have he : ∀ᶠ i in atTop, |completedPairing (sourceClasses B) c0Origin f (m i)| < δ :=
    hh.eventually (show ∀ᶠ x in nhds |(0 : ℝ)|, x<δ by simpa only [abs_zero] using eventually_lt_nhds hδ)
  obtain ⟨i,hi⟩ := he.exists
  exact (not_lt_of_ge (hd i)) hi

theorem tail_remainder_false (f : ℕ → C0Ball → ℝ) (ts : ℕ → List TailOperation)
    (t : ℕ → TailOperation) (ht : ∀ i, t i ∈ ts i) (hg : ∀ i, (t i).isBasic=false)
    (a : ℕ) (ha : ∀ i, (t i).scaleIndex=a) (hN : Tendsto (fun i => (t i).tailIndex) atTop atTop)
    (h : ℕ) (hF : ∀ i, (fun s => f i s*tailProduct (ts i) s) ∈ VClass B h)
    (m : ℕ → SourceSpace B) (hm : PairingNull m) (hNo : NoCompatible m) {δ : ℝ} (hδ : 0 < δ)
    (hd : ∀ i, δ ≤ |completedPairing (sourceClasses B) c0Origin
      (fun s => f i s*tailProduct (ts i) s) (m i)|) : False := by
  apply tail_escape_false (fun i s => f i s*tailProduct (ts i) s) m h hF hm hNo hδ (dyadic_pos a) hd
    (fun i => (t i).tailIndex) hN
  intro i s hs
  simpa only [ha i,Set.mem_setOf_eq] using full_tail_support (f i) (ts i) (t i) (ht i) (hg i) hs

theorem fixed_cylinder_tails_false_aux {γ : Γ} (r : GeneratedRepresentation B γ) (h : ℕ)
    (hr : r.operations.length ≤ h) (hj : B.band γ ≤ h) (n : ℕ) :
    ∀ (pre : List TailOperation) (post : ℕ → List TailOperation),
      (∀ i, (post i).length=n) →
      (∀ i, (pre++post i).length ≤ h) →
      (∀ i t, t ∈ pre++post i → t.scaleIndex ≤ h) →
      ∀ (m : ℕ → SourceSpace B) , PairingNull m → NoCompatible m →
      ∀ δ : ℝ, 0 < δ →
      (∀ i, δ ≤ |completedPairing (sourceClasses B) c0Origin
        (fun s => r.value s*tailProduct (pre++post i) s) (m i)|) → False := by
  induction n with
  | zero =>
    intro pre post hn hlen hscale m hm hNo δ hδ hd
    have hz (i : ℕ) : post i=[] := List.length_eq_zero_iff.mp (hn i)
    have hmem : (fun s => r.value s*tailProduct pre s) ∈ VClass B h := by
      refine ⟨γ,r,pre,hr,hj,?_,?_,rfl⟩
      · simpa only [hz 0,List.append_nil] using hlen 0
      · intro t ht
        apply hscale 0 t
        exact List.mem_append.mpr (Or.inl ht)
    apply constant_detector_false _ (VClass_bounded hmem) m hm hNo hδ
    intro i
    simpa only [hz i,List.append_nil] using hd i
  | succ n ih =>
    intro pre post hn hlen hscale m hm hNo δ hδ hd
    have hc (i : ℕ) : ∃ t rest, post i=t::rest ∧ rest.length=n := by
      obtain ⟨t,rest,he⟩ := List.length_pos_iff_exists_cons.mp (show 0<(post i).length by rw [hn]; omega)
      refine ⟨t,rest,he,?_⟩
      have hh := hn i
      rw [he,List.length_cons] at hh
      omega
    choose t rest he hrest using hc
    have ht (i : ℕ) : t i ∈ pre++post i := List.mem_append.mpr (Or.inr (by rw [he]; exact List.mem_cons_self))
    rcases TailOperation.constant_or_escape t h (fun i => hscale i _ (ht i)) with
      ⟨p,ψ,hψ,hp⟩ | ⟨ψ,hψ,a,g,ha,hg,hN⟩
    · have heq (i : ℕ) : (pre++[p])++rest (ψ i)=pre++post (ψ i) := by
        rw [he,hp,List.append_assoc,List.singleton_append]
      apply ih (pre++[p]) (fun i => rest (ψ i)) (fun i => hrest _) (fun i => by rw [heq]; exact hlen _)
        (fun i t ht => hscale (ψ i) t (by rw [← heq]; exact ht)) (m ∘ ψ) (hm.subsequence hψ) (hNo.subsequence hψ) δ hδ
      intro i
      simpa only [heq,Function.comp_def] using hd (ψ i)
    · let ts0 (i : ℕ) := pre++post (ψ i)
      have hmem0 (i : ℕ) : (fun s => r.value s*tailProduct (ts0 i) s) ∈ VClass B h :=
        ⟨γ,r,ts0 i,hr,hj,hlen _,hscale _,rfl⟩
      cases g with
      | false =>
        exact tail_remainder_false (fun _ => r.value) ts0 (t ∘ ψ) (fun i => ht _) hg a ha hN
          h hmem0 (m ∘ ψ) (hm.subsequence hψ) (hNo.subsequence hψ) hδ (fun i => hd (ψ i))
      | true =>
        let tsA (i : ℕ) := pre++rest (ψ i)
        let tsB (i : ℕ) := pre++(t (ψ i)).remainder::rest (ψ i)
        have hlenA (i : ℕ) : (tsA i).length ≤ h := by
          have hh := hlen (ψ i)
          simp only [he,List.length_append,List.length_cons] at hh
          simp only [tsA,List.length_append]
          omega
        have hscaleA (i : ℕ) (q : TailOperation) (hq : q ∈ tsA i) : q.scaleIndex ≤ h := by
          apply hscale (ψ i) q
          rw [he,List.mem_append,List.mem_cons]
          rcases List.mem_append.mp hq with hq | hq
          · exact Or.inl hq
          · exact Or.inr (Or.inr hq)
        have hlenB (i : ℕ) : (tsB i).length ≤ h := by
          simpa only [tsB,he,List.length_append,List.length_cons] using hlen (ψ i)
        have hscaleB (i : ℕ) (q : TailOperation) (hq : q ∈ tsB i) : q.scaleIndex ≤ h := by
          rcases List.mem_append.mp hq with hq | hq
          · exact hscale (ψ i) q (List.mem_append.mpr (Or.inl hq))
          · rcases List.mem_cons.mp hq with rfl | hq
            · exact hscale (ψ i) (t (ψ i)) (ht _)
            · exact hscaleA i q (List.mem_append.mpr (Or.inr hq))
        let FA (i : ℕ) (s : C0Ball) := r.value s*tailProduct (tsA i) s
        let FB (i : ℕ) (s : C0Ball) := r.value s*tailProduct (tsB i) s
        have hmemA (i : ℕ) : FA i ∈ VClass B h := ⟨γ,r,tsA i,hr,hj,hlenA i,hscaleA i,rfl⟩
        have hmemB (i : ℕ) : FB i ∈ VClass B h := ⟨γ,r,tsB i,hr,hj,hlenB i,hscaleB i,rfl⟩
        have hsplit (i : ℕ) : (fun s => r.value s*tailProduct (ts0 i) s)=fun s => FA i s+FB i s := by
          funext s
          simp only [ts0,he,tailProduct_append,tailProduct_cons,FA,FB,tsA,tsB]
          rw [TailOperation.factor_split _ (hg i)]
          ring
        have hdet (i : ℕ) : δ ≤ |completedPairing (sourceClasses B) c0Origin (FA i) (m (ψ i))+
            completedPairing (sourceClasses B) c0Origin (FB i) (m (ψ i))| := by
          rw [← completedPairing_add _ _ _ _ (VClass_bounded (hmemA i)) (VClass_bounded (hmemB i))]
          rw [← hsplit]
          exact hd (ψ i)
        rcases detection_split _ _ hdet with ⟨η,hη,hdA⟩ | ⟨η,hη,hdB⟩
        · exact ih pre (fun i => rest (ψ (η i))) (fun i => hrest _) (fun i => hlenA _)
            (fun i => hscaleA _) (m ∘ ψ ∘ η) (hm.subsequence (hψ.comp hη)) (hNo.subsequence (hψ.comp hη))
            (δ/2) (half_pos hδ) hdA
        · apply tail_remainder_false (fun _ => r.value) (tsB ∘ η) (fun i => (t (ψ (η i))).remainder)
            (fun i => List.mem_append.mpr (Or.inr List.mem_cons_self)) (fun _ => rfl) a
            (fun i => ha _) (hN.comp hη.tendsto_atTop) h (fun i => hmemB _)
            (m ∘ ψ ∘ η) (hm.subsequence (hψ.comp hη)) (hNo.subsequence (hψ.comp hη)) (half_pos hδ) hdB


theorem fixed_cylinder_tails_false {Γ : Type*} {B : CylinderBases Γ} {γ : Γ}
    (r : GeneratedRepresentation B γ) (ts : ℕ → List TailOperation) (h : ℕ)
    (hr : r.operations.length ≤ h) (hj : B.band γ ≤ h)
    (ht : ∀ i, (ts i).length ≤ h) (ha : ∀ i t, t ∈ ts i → t.scaleIndex ≤ h)
    (m : ℕ → SourceSpace B) (hm : PairingNull m) (hNo : NoCompatible m)
    {δ : ℝ} (hδ : 0 < δ)
    (hd : ∀ i, δ ≤ |completedPairing (sourceClasses B) c0Origin
      (fun s => r.value s*tailProduct (ts i) s) (m i)|) : False := by
  obtain ⟨n,φ,hφ,hn⟩ := finite_constant_subsequence
    (fun i => (⟨(ts i).length,Nat.lt_succ_of_le (ht i)⟩ : Fin (h+1)))
  apply fixed_cylinder_tails_false_aux r h hr hj n.val [] (ts ∘ φ)
    (fun i => congrArg Fin.val (hn i)) (fun i => ht _) (fun i => ha _)
    (m ∘ φ) (hm.subsequence hφ) (hNo.subsequence hφ) δ hδ (fun i => hd (φ i))


variable {γ : Γ}

theorem repeated_label_false_aux (h : ℕ) (hj : B.band γ ≤ h) (n : ℕ) :
    ∀ (pre : List (CylinderOperation (B.coordinates γ)))
      (post : ℕ → List (CylinderOperation (B.coordinates γ)))
      (r : ℕ → GeneratedRepresentation B γ) (ts : ℕ → List TailOperation),
    (∀ i, (post i).length=n) → (∀ i, (r i).operations=pre++post i) →
    (∀ i, (r i).operations.length ≤ h) →
    (∀ i, (ts i).length ≤ h) → (∀ i t, t ∈ ts i → t.scaleIndex ≤ h) →
    ∀ (m : ℕ → SourceSpace B) , PairingNull m → NoCompatible m →
    ∀ δ : ℝ, 0<δ →
    (∀ i, δ ≤ |completedPairing (sourceClasses B) c0Origin
      (fun s => (r i).value s*tailProduct (ts i) s) (m i)|) → False := by
  induction n with
  | zero =>
    intro pre post r ts hn he hr ht ha m hm hNo δ hδ hd
    have hz (i : ℕ) : post i=[] := List.length_eq_zero_iff.mp (hn i)
    have hval (i : ℕ) : (r i).value=(r 0).value := by
      simp only [GeneratedRepresentation.value,GeneratedRepresentation.cubeValue,he,hz,List.append_nil]
    apply fixed_cylinder_tails_false (r 0) ts h (hr 0) hj ht ha m hm hNo hδ
    intro i
    simpa only [hval i] using hd i
  | succ n ih =>
    intro pre post r ts hn he hr ht ha m hm hNo δ hδ hd
    have hc (i : ℕ) : ∃ t rest, post i=t::rest ∧ rest.length=n := by
      obtain ⟨t,rest,heq⟩ := List.length_pos_iff_exists_cons.mp (show 0<(post i).length by rw [hn]; omega)
      refine ⟨t,rest,heq,?_⟩
      have hh := hn i
      rw [heq,List.length_cons] at hh
      omega
    choose op suf hop hsuf using hc
    have hops (i : ℕ) : (r i).operations=pre++op i::suf i := (he i).trans (congrArg (pre++·) (hop i))
    have hsuflen (i : ℕ) : (suf i).length ≤ h := by
      have hh := hr i
      rw [hops,List.length_append,List.length_cons] at hh
      omega
    have horder (i : ℕ) (t : CylinderOperation (B.coordinates γ)) (ht : t ∈ suf i) : t.scale ≤ (op i).scale := by
      have hh := (r i).ordered
      rw [hops] at hh
      exact (List.pairwise_cons.mp (List.pairwise_append.mp hh).2.1).1 t ht
    rcases CylinderOperation.constant_or_small op with ⟨p,ψ,hψ,hp⟩ | ⟨ψ,hψ,hsmall,g,hg⟩
    · have heq (i : ℕ) : (r (ψ i)).operations=(pre++[p])++suf (ψ i) := by
        rw [hops,hp,List.append_assoc,List.singleton_append]
      exact ih (pre++[p]) (suf ∘ ψ) (r ∘ ψ) (ts ∘ ψ) (fun i => hsuf _) heq
        (fun i => hr _) (fun i => ht _) (fun i => ha _) (m ∘ ψ) (hm.subsequence hψ) (hNo.subsequence hψ) δ hδ (fun i => hd (ψ i))
    · let p : Cube (B.coordinates γ) → ℝ := applyOperations pre (B.base γ)
      have hp : LipschitzWith (4^pre.length*B.L0) p := applyOperations_lipschitz pre (B.base_lipschitz γ)
      cases g with
      | false =>
        apply small_remainders_false (r ∘ ψ) (ts ∘ ψ) h (fun i => hr _) hj (fun i => ht _) (fun i => ha _)
          (op ∘ ψ) hsmall p (4^pre.length*B.L0) hp (suf ∘ ψ) (fun i => hsuflen _) (fun i => horder _) _
          (m ∘ ψ) (hm.subsequence hψ) (hNo.subsequence hψ) hδ (fun i => hd (ψ i))
        intro i
        simp only [Function.comp_def,GeneratedRepresentation.cubeValue,hops,applyOperations_append,applyOperations_cons,p]
        have he' : (op (ψ i)).act p=(op (ψ i)).remainder.act p := by
          simp only [CylinderOperation.act,localOp,hg i,Bool.false_eq_true,↓reduceIte]
          rfl
        exact congrArg (applyOperations (suf (ψ i))) he'
      | true =>
        have hsub (i : ℕ) : (pre++suf (ψ i)).Sublist (r (ψ i)).operations := by
          rw [hops]
          exact (List.sublist_cons_self _ _).append_left pre
        let rA (i : ℕ) := (r (ψ i)).subrepresentation (pre++suf (ψ i)) (hsub i)
        have hsame (i : ℕ) : (pre++(op (ψ i)).remainder::suf (ψ i)).map CylinderOperation.scale =
            (r (ψ i)).operations.map CylinderOperation.scale := by
          simp only [hops,List.map_append,List.map_cons,CylinderOperation.remainder_scale]
        let rB (i : ℕ) := (r (ψ i)).sameScales (pre++(op (ψ i)).remainder::suf (ψ i)) (hsame i)
        have hlenA (i : ℕ) : (rA i).operations.length ≤ h := (hsub i).length_le.trans (hr _)
        have hlenB (i : ℕ) : (rB i).operations.length ≤ h := by
          simpa only [rB,GeneratedRepresentation.sameScales,hops,List.length_append,List.length_cons] using hr (ψ i)
        have hcubeB (i : ℕ) : (rB i).cubeValue=applyOperations (suf (ψ i)) ((op (ψ i)).remainder.act p) := by
          simp only [rB,GeneratedRepresentation.sameScales,GeneratedRepresentation.cubeValue,
            applyOperations_append,applyOperations_cons,p]
        let FA (i : ℕ) (s : C0Ball) := (rA i).value s*tailProduct (ts (ψ i)) s
        let FB (i : ℕ) (s : C0Ball) := (rB i).value s*tailProduct (ts (ψ i)) s
        have hmemA (i : ℕ) : FA i ∈ VClass B h := ⟨γ,rA i,ts (ψ i),hlenA i,hj,ht _,ha _,rfl⟩
        have hmemB (i : ℕ) : FB i ∈ VClass B h := ⟨γ,rB i,ts (ψ i),hlenB i,hj,ht _,ha _,rfl⟩
        have hcube (i : ℕ) : (r (ψ i)).cubeValue=(rA i).cubeValue+(rB i).cubeValue := by
          rw [hcubeB]
          change applyOperations (r (ψ i)).operations (B.base γ)=applyOperations (pre++suf (ψ i)) (B.base γ)+_
          rw [hops,applyOperations_append,applyOperations_cons,applyOperations_append]
          rw [CylinderOperation.act_split _ (hg i),map_add]
        have hsplit (i : ℕ) : (fun s => (r (ψ i)).value s*tailProduct (ts (ψ i)) s)=fun s => FA i s+FB i s := by
          funext s
          simp only [GeneratedRepresentation.value,Function.comp_def,hcube,Pi.add_apply,FA,FB]
          ring
        have hdet (i : ℕ) : δ ≤ |completedPairing (sourceClasses B) c0Origin (FA i) (m (ψ i))+
            completedPairing (sourceClasses B) c0Origin (FB i) (m (ψ i))| := by
          rw [← completedPairing_add _ _ _ _ (VClass_bounded (hmemA i)) (VClass_bounded (hmemB i)),← hsplit]
          exact hd (ψ i)
        rcases detection_split _ _ hdet with ⟨η,hη,hdA⟩ | ⟨η,hη,hdB⟩
        · exact ih pre (suf ∘ ψ ∘ η) (rA ∘ η) (ts ∘ ψ ∘ η) (fun i => hsuf _)
            (fun i => rfl) (fun i => hlenA _) (fun i => ht _) (fun i => ha _)
            (m ∘ ψ ∘ η) (hm.subsequence (hψ.comp hη)) (hNo.subsequence (hψ.comp hη)) (δ/2) (half_pos hδ) hdA
        · exact small_remainders_false (rB ∘ η) (ts ∘ ψ ∘ η) h (fun i => hlenB _) hj
            (fun i => ht _) (fun i => ha _) (op ∘ ψ ∘ η) (hsmall.comp hη.tendsto_atTop) p
            (4^pre.length*B.L0) hp (suf ∘ ψ ∘ η) (fun i => hsuflen _) (fun i => horder _)
            (fun i => hcubeB _) (m ∘ ψ ∘ η) (hm.subsequence (hψ.comp hη)) (hNo.subsequence (hψ.comp hη))
            (half_pos hδ) hdB

theorem repeated_label_false (r : ℕ → GeneratedRepresentation B γ)
    (ts : ℕ → List TailOperation) (h : ℕ)
    (hr : ∀ i, (r i).operations.length ≤ h) (hj : B.band γ ≤ h)
    (ht : ∀ i, (ts i).length ≤ h) (ha : ∀ i t, t ∈ ts i → t.scaleIndex ≤ h)
    (m : ℕ → SourceSpace B) (hm : PairingNull m) (hNo : NoCompatible m)
    {δ : ℝ} (hδ : 0 < δ)
    (hd : ∀ i, δ ≤ |completedPairing (sourceClasses B) c0Origin
      (fun s => (r i).value s*tailProduct (ts i) s) (m i)|) : False := by
  obtain ⟨n,φ,hφ,hn⟩ := finite_constant_subsequence
    (fun i => (⟨(r i).operations.length,Nat.lt_succ_of_le (hr i)⟩ : Fin (h+1)))
  exact repeated_label_false_aux h hj n.val [] (fun i => (r (φ i)).operations) (r ∘ φ) (ts ∘ φ)
    (fun i => congrArg Fin.val (hn i)) (fun i => rfl) (fun i => hr _) (fun i => ht _) (fun i => ha _)
    (m ∘ φ) (hm.subsequence hφ) (hNo.subsequence hφ) δ hδ (fun i => hd (φ i))


theorem bounded_band_detectors_false (loc : RadiusLocalization B)
    (γ : ℕ → Γ) (r : ∀ i, GeneratedRepresentation B (γ i))
    (ts : ℕ → List TailOperation) (h : ℕ)
    (hr : ∀ i, (r i).operations.length ≤ h) (hj : ∀ i, B.band (γ i) ≤ h)
    (ht : ∀ i, (ts i).length ≤ h) (ha : ∀ i t, t ∈ ts i → t.scaleIndex ≤ h)
    (m : ℕ → SourceSpace B) (hm : PairingNull m) (hNo : NoCompatible m)
    {δ : ℝ} (hδ : 0 < δ)
    (hd : ∀ i, δ ≤ |completedPairing (sourceClasses B) c0Origin
      (fun s => (r i).value s*tailProduct (ts i) s) (m i)|) : False := by
  rcases constant_or_injective_subsequence γ with ⟨γ0,ψ,hψ,hγ⟩ | ⟨ψ,hψ,hγ⟩
  · let rr (i : ℕ) := (r (ψ i)).relabel (hγ i)
    apply repeated_label_false rr (ts ∘ ψ) h (fun i => by simpa only [rr,GeneratedRepresentation.relabel_length] using hr (ψ i))
      (by rw [← hγ 0]; exact hj _) (fun i => ht _) (fun i => ha _) (m ∘ ψ) (hm.subsequence hψ) (hNo.subsequence hψ) hδ
    intro i
    simpa only [rr,GeneratedRepresentation.relabel_value,Function.comp_def] using hd (ψ i)
  · obtain ⟨j,η,hη,hjη⟩ := finite_constant_subsequence
      (fun i => (⟨B.band (γ (ψ i)),Nat.lt_succ_of_le (hj _)⟩ : Fin (h+1)))
    obtain ⟨H,φ,hφ,F,hF,hdF,hdis⟩ := loc.low_bands_disjoint (γ ∘ ψ ∘ η) (fun i => r (ψ (η i)))
      (ts ∘ ψ ∘ η) h j.val (fun i => hr _) (fun i => congrArg Fin.val (hjη i))
      (Nat.le_of_lt_succ j.isLt) (fun i => ht _) (fun i => ha _) (hγ.comp hη.injective)
      (m ∘ ψ ∘ η) hδ (fun i => hd (ψ (η i)))
    exact VClass_disjoint_false (m ∘ ψ ∘ η ∘ φ) (hm.subsequence ((hψ.comp hη).comp hφ)) (hNo.subsequence ((hψ.comp hη).comp hφ))
      F H hF hdis (half_pos hδ) hdF

theorem source_detectors_false (locT : TagLocalization B) (locR : RadiusLocalization B)
    (m : ℕ → SourceSpace B) (hm : PairingNull m) (hNo : NoCompatible m)
    (F : ℕ → C0Ball → ℝ) (d : ℕ) (hF : ∀ i, F i ∈ sourceClasses B d)
    {δ : ℝ} (hδ : 0 < δ)
    (hd : ∀ i, δ ≤ |completedPairing (sourceClasses B) c0Origin (F i) (m i)|) : False := by
  let h := d/2+1
  by_cases hdEven : d%2=0
  · have ht (i : ℕ) : F i ∈ TClass B h := by simpa only [sourceClasses,hdEven,↓reduceIte,h] using hF i
    choose γ r hr he using ht
    have hdet (i : ℕ) : δ ≤ |completedPairing (sourceClasses B) c0Origin (r i).value (m i)| := by
      simpa only [he i] using hd i
    rcases nat_constant_or_tendsto (fun i => B.band (γ i)) with ⟨j,ψ,hψ,hj⟩ | hj
    · apply bounded_band_detectors_false locR (γ ∘ ψ) (fun i => r (ψ i)) (fun _ => []) (h+j)
        (fun i => (hr _).trans (Nat.le_add_right h j)) (fun i => by change B.band (γ (ψ i)) ≤ h+j; rw [hj]; omega)
        (by simp) (by simp) (m ∘ ψ) (hm.subsequence hψ) (hNo.subsequence hψ) hδ
      intro i
      simpa only [tailProduct_nil,mul_one,Function.comp_def] using hdet (ψ i)
    · obtain ⟨φ,hφ,G,hG,hdG,hLip⟩ := high_bands_compatible locT γ r h hr hj m hδ hdet
      apply compatible_detectors_false (m ∘ φ) (hm.subsequence hφ) (hNo.subsequence hφ)
        G (2*h) (4^(h+1)*B.L0+1) _ hLip (half_pos hδ) hdG
      intro i
      simpa only [sourceClasses_even] using hG i
  · have ht (i : ℕ) : F i ∈ VClass B h := by simpa only [sourceClasses,hdEven,↓reduceIte,h] using hF i
    choose γ r ts hr hj hts ha he using ht
    apply bounded_band_detectors_false locR γ r ts h hr hj hts ha m hm hNo hδ
    intro i
    simpa only [he i] using hd i


theorem compatible_selection (locT : TagLocalization B) (locR : RadiusLocalization B)
    (m : ℕ → SourceSpace B) (hm : PairingNull m)
    (F : ℕ → C0Ball → ℝ) (d : ℕ) (hF : ∀ i, F i ∈ sourceClasses B d)
    {δ : ℝ} (hδ : 0 < δ)
    (hd : ∀ i, δ ≤ |completedPairing (sourceClasses B) c0Origin (F i) (m i)|) :
    CompatibleSubsequence m := by
  by_contra hn
  exact source_detectors_false locT locR m hm hn F d hF hδ hd

def WeaklyNull (m : ℕ → SourceSpace B) : Prop :=
  ∀ u : SourceSpace B →L[ℝ] ℝ, Tendsto (fun i => u (m i)) atTop (nhds 0)

theorem weaklyNull_pairingNull {m : ℕ → SourceSpace B} (hm : WeaklyNull m) :
    PairingNull m := by
  intro f hf
  obtain ⟨A,hA⟩ := hf
  have hh := hm (completedTest (sourceClasses B) c0Origin f A hA)
  simpa only [completedTest_eq] using hh

theorem weakly_null_compatible_selection
    (locT : TagLocalization B) (locR : RadiusLocalization B)
    (m : ℕ → SourceSpace B) (hm : WeaklyNull m)
    (F : ℕ → C0Ball → ℝ) (d : ℕ) (hF : ∀ i, F i ∈ sourceClasses B d)
    {δ : ℝ} (hδ : 0 < δ)
    (hd : ∀ i, δ ≤ |completedPairing (sourceClasses B) c0Origin (F i) (m i)|) :
    CompatibleSubsequence m :=
  compatible_selection locT locR m (weaklyNull_pairingNull hm) F d hF hδ hd

theorem finite_signed_lipschitz {X : Type*} [PseudoMetricSpace X]
    (F : ℕ → X → ℝ) (K : ℝ≥0)
    (h : ∀ n (ε : Fin n → ℝ), (∀ i, |ε i| = 1) →
      LipschitzWith K (fun x => ∑ i, ε i * F i x))
    (H : Finset ℕ) (ε : ℕ → ℝ) (hε : ∀ i ∈ H, |ε i| = 1) :
    LipschitzWith K (fun x => ∑ i ∈ H, ε i * F i x) := by
  classical
  let n := H.sup id + 1
  have hH : H ⊆ Finset.range n := by
    intro i hi
    apply Finset.mem_range.mpr
    exact Nat.lt_succ_of_le (Finset.le_sup (f := id) hi)
  let a (i : Fin n) : ℝ := if (i : ℕ) ∈ H then ε i else 1
  let b (i : Fin n) : ℝ := if (i : ℕ) ∈ H then ε i else -1
  have ha : ∀ i, |a i| = 1 := by
    intro i
    dsimp [a]
    split_ifs with hi
    · exact hε i hi
    · norm_num
  have hb : ∀ i, |b i| = 1 := by
    intro i
    dsimp [b]
    split_ifs with hi
    · exact hε i hi
    · norm_num
  let A (x : X) := ∑ i : Fin n, a i * F i x
  let D (x : X) := ∑ i : Fin n, b i * F i x
  let S (x : X) := ∑ i ∈ H, ε i * F i x
  have he (x : X) : A x + D x = 2 * S x := by
    calc
      _ = ∑ i : Fin n, (if (i : ℕ) ∈ H then 2 * (ε i * F i x) else 0) := by
        rw [← Finset.sum_add_distrib]
        apply Finset.sum_congr rfl
        intro i _
        dsimp [a, b]
        split_ifs <;> ring
      _ = ∑ i ∈ Finset.range n, (if i ∈ H then 2 * (ε i * F i x) else 0) :=
        (Finset.sum_range
          (fun i : ℕ => if i ∈ H then 2 * (ε i * F i x) else 0)).symm
      _ = ∑ i ∈ H, 2 * (ε i * F i x) := by
        calc
          _ = ∑ i ∈ H, (if i ∈ H then 2 * (ε i * F i x) else 0) :=
            (Finset.sum_subset hH (by intro i _ hi; simp only [hi, ↓reduceIte])).symm
          _ = _ := Finset.sum_congr rfl (by intro i hi; simp only [hi, ↓reduceIte])
      _ = _ := (Finset.mul_sum H (fun i => ε i * F i x) 2).symm
  apply LipschitzWith.of_dist_le_mul
  intro x y
  have hA := (h n a ha).dist_le_mul x y
  have hD := (h n b hb).dist_le_mul x y
  change |A x - A y| ≤ (K : ℝ) * dist x y at hA
  change |D x - D y| ≤ (K : ℝ) * dist x y at hD
  have hid : (A x - A y) + (D x - D y) = 2 * (S x - S y) := by
    linarith [he x, he y]
  have hab := abs_add_le (A x - A y) (D x - D y)
  rw [hid, abs_mul, abs_of_pos (by norm_num : (0 : ℝ) < 2)] at hab
  change |S x - S y| ≤ (K : ℝ) * dist x y
  linarith

theorem full_compatible_selection
    (locT : TagLocalization B) (locR : RadiusLocalization B)
    (m : ℕ → SourceSpace B) (hm : WeaklyNull m)
    (F : ℕ → C0Ball → ℝ) (d : ℕ) (hF : ∀ i, F i ∈ sourceClasses B d)
    {δ : ℝ} (hδ : 0 < δ)
    (hd : ∀ i, δ ≤ |completedPairing (sourceClasses B) c0Origin (F i) (m i)|) :
    ∃ φ : ℕ → ℕ, StrictMono φ ∧
      ∃ (h : ℕ) (G : ℕ → C0Ball → ℝ) (δ₁ : ℝ) (C : ℕ),
        0 < δ₁ ∧ 1 ≤ C ∧ (∀ i, G i ∈ sourceClasses B h) ∧
        (∀ i, δ₁ ≤ |completedPairing (sourceClasses B) c0Origin (G i) (m (φ i))|) ∧
        ∀ (H : Finset ℕ) (ε : ℕ → ℝ), (∀ i ∈ H, |ε i| = 1) →
          LipschitzWith C (fun s => ∑ i ∈ H, ε i * G i s) := by
  obtain ⟨φ,hφ,h,G,δ₁,K,hδ₁,hG,hdG,hLip⟩ :=
    weakly_null_compatible_selection locT locR m hm F d hF hδ hd
  obtain ⟨C,hC⟩ := exists_nat_gt (K : ℝ)
  have hCpos : 0 < (C : ℝ) := lt_of_le_of_lt K.coe_nonneg hC
  have hCN : 1 ≤ C := by exact_mod_cast hCpos
  have hKC : K ≤ (C : ℝ≥0) := by exact_mod_cast hC.le
  refine ⟨φ,hφ,h,G,δ₁,C,hδ₁,hCN,hG,hdG,?_⟩
  intro H ε hε
  exact (finite_signed_lipschitz G K hLip H ε hε).weaken hKC

end
end Audit324
