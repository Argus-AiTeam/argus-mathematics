# Lean 4.31.0 Formal Refutations of Flawed Claims in OpenAI's `openai/math` Corpus

This directory contains **`OpenAIRefutations.lean`**, a unified, self-contained **Lean 4.31.0 + Mathlib4** formalization proving explicit counterexample witnesses and negations (`¬ ...`) for **all 21 active OpenAI `openai/math` problem families containing refuted claims (`42` active manuscripts)** plus `#342`'s refutation of Li–Zhang (*arXiv:0708.2520v4*):

- **Zero `sorry` / `admit`** (`exit_code = 0`)
- **Zero custom `axiom`s** (`lean_axiom_audit.lean` `audit_exit_code = 0`)

## Verification Command

```bash
lake env lean results/openai-audit-theorems/lean-refutations/OpenAIRefutations.lean
lake env lean --run lean_axiom_audit.lean results/openai-audit-theorems/lean-refutations/OpenAIRefutations.lean
```

## Summary of Machine-Checked Refutation Theorems (`OpenAIRefutations.lean`)

| Family | Refuted OpenAI Claim / Lemma | Lean 4.31.0 Refutation Theorem (`OpenAIRefutations.lean` & Campaign `Main.lean`) |
| :--- | :--- | :--- |
| **`#318`** | `C318LEVEL3`, `C318FORGETACTION`, `C318FULLSPLITTING`, small-$q$ character positivity | `refute_318_degree_five_nonvanishing`, `refute_318_bicomplex_column_zero_detection`, `refute_318_character_sum_real_part_positive` + [`results/openai-audit-theorems/9000318/Main.lean`](../9000318/Main.lean) |
| **`#376`** | `F_COR_TRACIAL_EXTENSION` (`cor:tracial-extension`) | `refute_376_block_cutoff_moment_homomorphism` |
| **`#180`** | `C180_INTEGRAL` (`bipyramid_4` leading-order non-cancellation) | `refute_180_minimum_order_noncancellation` + [`results/openai-audit-theorems/9000180/Main.lean`](../9000180/Main.lean) |
| **`#274`** | `F_RANK2_PROJECTOR_ZERO_MEAN_INDEPENDENCE` (Lemma 5.3) | `refute_274_zero_mean_projector_full_rank` + [`results/openai-audit-theorems/9000274/Main.lean`](../9000274/Main.lean) |
| **`#209`** | `F209_DYADIC_Y0_EISENSTEIN_SUBSTITUTION` ($y=0$ dyadic slice) | `refute_209_dyadic_y0_slice_nonvanishing` |
| **`#001`** | `F001_RESIDUAL_CENTRALIZER_QUOTIENT_EMBEDDING` | `refute_001_normalizer_implies_centralizer` |
| **`#341`** | `F341_WEAK_CONVERGENCE_TO_ZERO` (`claim_c3`) | `refute_341_invariant_vector_weak_decay` |
| **`#053`** | `F_THM_PIXTON_FAILS` ($\lambda = -1$ projector invertibility) | `refute_053_lambda_minus_one_invertibility` + [`results/openai-audit-theorems/9000053/Main.lean`](../9000053/Main.lean) |
| **`#321`** | `F321_BAD_T_INVARIANCE` (nonlinear shift degree invariance) | `refute_321_nonlinear_shift_preserves_quadratic_degree` + [`results/openai-audit-theorems/9000321/Main.lean`](../9000321/Main.lean) |
| **`#342`** | `F_EXTERNAL_THM13` / `F_EXTERNAL_COR14` (Li–Zhang *arXiv:0708.2520v4*) | `refute_342_li_zhang_cone_disjointness` + [`results/openai-audit-theorems/9000342/Main.lean`](../9000342/Main.lean) |
| **`#004`** | `F004_LINEAR_DESCENT_CLEARING_FACTOR` ($\mathbb{Z}/9\mathbb{Z}$ linear vs quadratic clearing) | `refute_004_linear_clearing_factor` + [`results/openai-audit-theorems/9000004/Main.lean`](../9000004/Main.lean) |
| **`#201`** | `F201_POINTWISE_ISOSPECTRAL_JACOBIAN_RANK` (pointwise rank 1 vs collective rank 2) | `refute_201_pointwise_rank_forces_collective_rank_one` + [`results/openai-audit-theorems/9000201/Main.lean`](../9000201/Main.lean) |
| **`#247`** | `F_BOUNDARY_CURSOR_ROLLBACK_WITHOUT_LEFT_ENDPOINT` (`fr:rollback`) | `refute_247_boundary_cursor_rollback` + [`results/openai-audit-theorems/9000247/Main.lean`](../9000247/Main.lean) (`no_step`, `trace_fixed`, `no_contains_zero`) |
| **`#316`** | `F316_MONOMIAL_SINGLE_PRIMITIVE_QUOTIENT_TEST` (`x ↦ x^3` mod 9) | `refute_316_cubing_injective_mod_nine` + [`results/openai-audit-theorems/9000316/Main.lean`](../9000316/Main.lean) |
| **`#331`** | `C_BAD_SCALAR` (midpoint-convexity scalar inequality) | `refute_331_scalar_inequality` |
| **`#046`** | `F046_CYLINDRICAL_SELF_ADJOINT_RADIAL_ODE` | `refute_046_cylindrical_first_derivative_vanishes` |
| **`#067`** | `F067_INVERSES_FROM_HOMOTOPY_ASSOCIATIVITY` (`lem:pi0-group`) | `refute_067_associative_unital_implies_inverses` |
| **`#320`** | `F320_KUNNETH_SPLITTING` (`prop:kunneth`) | `refute_320_torsion_free_kunneth_kernel` |
| **`#340`** | `F340_TRACE_FREENESS_OF_TRANSVERSAL_VARIATION` | `refute_340_square_of_traceless_is_traceless` |
| **`#375`** | `F375_RAW_TRACE_IDENTIFICATION` | `refute_375_raw_vs_nonbacktracking_trace` |
| **`#378`** | `F378_BOUNDARY_TRUNCATION_PARITY` | `refute_378_sharp_cutoff_boundary_vanishes` |
