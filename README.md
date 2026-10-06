# Cross-tissue transfer of probes and thresholds for gene regulatory network evaluation with scGPT and Geneformer

Author: Ihor Kendiukhov, University of Tübingen.

The rebuilt benchmark evaluates scGPT whole-human and Geneformer V2-104M on fixed kidney, lung and pooled immune contexts from Tabula Sapiens. It compares two model-free expression statistics and five model-derived probes across nested budgets of 30, 50, 100, 200, 500 and 1,000 cells, with independent cell-resampling chains conditional on the stored atlas pools. The complete design comprises 57 model jobs and 312 budget snapshots; it also includes corrected continuous scGPT encoding and immune-organ strata.

The original two-budget phase-transition claim is not supported by the rebuilt, replicated analysis. Native context-specific candidate universes exhibit transfer losses, but the strict common-candidate comparison changes the loss and its uncertainty. The benchmark therefore measures operational selection and calibration under a specified evaluation design; it does not isolate a causal tissue effect or model architecture.

## Rebuild package

The proposed release `plos-one-rebuild-v2.0.0` contains the verified analysis code, seven statistical data archives, exact frozen expression arrays and candidate-score matrices. The release notes and asset checksums identify the files and validated reproduction scope. This local candidate has not yet been published.

- `S1_Code.zip`: scripts, configurations, tests, pinned table dependencies, model-rerun instructions and the exact scGPT implementation with its original licence.
- `S1_Data.zip` through `S7_Data_Geneformer_Null_Draws.zip`: per-chain measurements, individual null draws, diagnostic observations, figure source points, feature/input identities and provenance. See the supporting package's combined manifest for the actual filenames and mapping.
- `LOCAL_Frozen_Model_Inputs.zip`: stored sparse expression, raw-count and ambient-corrected count components, with exact ordered identities and metadata. These arrays retain Tabula Sapiens/CELLxGENE CC BY 4.0 terms and attribution.
- `LOCAL_Candidate_Matrices.zip`: saved model-derived candidate scores and shared expression-baseline scores. The original provider network files and model weights are obtained separately under their provider terms.

Extract S1 Code and all seven small data archives into the same directory. Follow the supplied README for the tested table/figure/registry reproduction. That check processes the supplied model and diagnostic measurements; it does not rerun pretrained models. Full model execution additionally requires the frozen inputs, separately acquired matching checkpoints/reference resources and the production runtime documented in `MODEL_RERUN.md`. Restored H5AD serialization is not claimed to match the original file-byte hash.

## Earlier files

The existing `src/`, `data/`, `results/`, `paper/` and Makefile belong to the earlier two-budget exploratory package. They are retained for historical provenance and are superseded for the rebuilt study. Their `make all` target reproduces those earlier derived tables, not the 57-job benchmark. The original root README is retained as `LEGACY_ROOT_README.md`; its phase-transition and preregistration statements are not current findings.

## Terms and citation

Cite the evaluated models, Tabula Sapiens and the original regulatory resources alongside this benchmark. The root MIT licence applies to author code, not all third-party data or components. `COMPONENT_LICENCES.json` and `DATA_ATTRIBUTION.md` in S1 Code describe the exact source and resource terms. No manuscript submission, peer-review correspondence or related unpublished manuscript copy is included in the proposed data/code release.
