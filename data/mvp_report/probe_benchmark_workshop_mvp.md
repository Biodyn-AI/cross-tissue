# Workshop MVP: Multi-Tissue Probe Benchmark for scGPT

## Summary
We benchmarked attention, grad_input, integrated_gradients, and perturbation probes against TRRUST, DoRothEA, and DoRothEA ChIP-seq across kidney, lung, and immune tissues on 30-cell random subsamples (MPS). A coexpression baseline (absolute and signed) is included for context. Results show tissue-specific probe rankings: kidney favors coexpression_signed, lung favors coexpression, and immune favors grad_input (especially on DoRothEA). TRRUST performance remains low across probes, highlighting candidate-set mismatch and limited recall at this scale. Scaling to 100 cells across tissues and to 200 cells for kidney shows modest AUPR gains for kidney/lung but a drop for immune.

## Data and Preprocessing
- Kidney: `single_cell_mechinterp/outputs/tabula_sapiens_processed.h5ad` (HVG=5000).
- Lung: `single_cell_mechinterp/outputs/probe_benchmark/lung_hvg5000_processed.h5ad` (HVG=5000).
- Immune: `single_cell_mechinterp/outputs/atlas/immune/tabula_sapiens_immune_processed.h5ad` (HVG=5000).

## Methods
- Probes: attention, grad_input, integrated_gradients, perturbation.
- Baselines: coexpression (absolute) and coexpression_signed.
- Candidate sets: union TF sources and targets (`single_cell_mechinterp/outputs/probe_benchmark/candidate_sources_union.txt`, `candidate_targets_union.txt`).
- References: TRRUST, DoRothEA, DoRothEA ChIP-seq (A–D confidence).
- Thresholding: shared top_k/percentile sweep with masked/unmasked variants.
- Device: MPS on Mac M2 with PyTorch CPU fallback for nested tensor masking.

## Results
### Mean AUPR Across References (30-cell, MPS)
|  | attention | coexpression | coexpression_signed | consensus | grad_input | integrated_gradients | perturbation |
| --- | --- | --- | --- | --- | --- | --- | --- |
| immune | 0.0152 | 0.0165 | 0.0127 | 0.0159 | 0.0333 | 0.0106 | 0.0128 |
| kidney | 0.0277 | 0.0335 | 0.0352 | 0.0277 | 0.0180 | 0.0246 | 0.0223 |
| lung | 0.0314 | 0.0354 | 0.0252 | 0.0308 | 0.0238 | 0.0163 | 0.0284 |

### Mean AUPR Across References (100-cell, MPS)
|  | attention | coexpression | coexpression_signed | consensus | grad_input | integrated_gradients | perturbation |
| --- | --- | --- | --- | --- | --- | --- | --- |
| immune | 0.0026 | 0.0085 | 0.0080 | 0.0010 | 0.0008 | 0.0050 | 0.0014 |
| kidney | 0.0297 | 0.0366 | 0.0395 | 0.0300 | 0.0195 | 0.0282 | 0.0252 |
| lung | 0.0324 | 0.0361 | 0.0269 | 0.0326 | 0.0232 | 0.0164 | 0.0220 |

### Best AUPR per Reference
| tissue | reference | best_probe | aupr_mean |
| --- | --- | --- | --- |
| immune | dorothea | grad_input | 0.0921 |
| immune | dorothea_chipseq | attention | 0.0066 |
| immune | trrust | coexpression | 0.0048 |
| kidney | dorothea | coexpression_signed | 0.0637 |
| kidney | dorothea_chipseq | coexpression_signed | 0.0397 |
| kidney | trrust | coexpression_signed | 0.0022 |
| lung | dorothea | coexpression | 0.0689 |
| lung | dorothea_chipseq | coexpression | 0.0337 |
| lung | trrust | coexpression | 0.0036 |

### Stability (Mean Jaccard@Top-k)
|  | attention | coexpression | coexpression_signed | consensus | grad_input | integrated_gradients | perturbation |
| --- | --- | --- | --- | --- | --- | --- | --- |
| immune | 0.6854 | 0.6807 | 0.6854 | 0.6870 | 0.9800 | 0.9692 | 0.9758 |
| kidney | 0.6025 | 0.5559 | 0.5667 | 0.6022 | 0.9916 | 0.9806 | 0.9912 |
| lung | 0.5180 | 0.1805 | 0.1819 | 0.1810 | 0.9888 | 0.8887 | 0.9023 |

### Scaling to 100 Cells (All Tissues)
- Best mean AUPR per tissue: kidney = coexpression_signed 0.0395; lung = coexpression 0.0361; immune = coexpression 0.0085.
- Immune 100-cell AUPR drops vs 30-cell runs, while kidney/lung show modest gains over 30-cell baselines.
- Stability ranges: attention/consensus ~0.45–0.67 Jaccard; coexpression/coexpression_signed ~0.49–0.56; grad_input/IG/perturbation ~0.91–0.98.

### Scaling to 200 Cells (Kidney)
- Mean AUPR across references: coexpression_signed 0.0430 > coexpression 0.0387 > consensus 0.0294.
- Best AUPR per reference: DoRothEA = coexpression_signed 0.0771, DoRothEA ChIP-seq = coexpression_signed 0.0494, TRRUST = coexpression_signed 0.0025.
- Stability: attention/consensus ~0.39 Jaccard, coexpression_signed 0.44, grad_input/IG/perturbation ~0.96–0.98.

## Interpretation
- Kidney: coexpression_signed leads mean AUPR, suggesting baseline correlations still dominate at this scale.
- Lung: coexpression overtakes attention/consensus, while gradient-based probes remain stable but lower AUPR.
- Immune: grad_input shows the highest mean AUPR at 30 cells, but coexpression becomes best at 100 cells with lower overall AUPR.
- TRRUST remains the hardest reference; 30-cell best AUPR stays <= 0.0048, while 100-cell immune reaches 0.0148 but remains low.

## Limitations
- Immune uses atlas-processed H5ADs; kidney and lung are locally processed. Pipeline differences may still shift candidate coverage.
- Subsampling to 30 cells limits recall and stability for attention/consensus.
- MPS fallback to CPU for some ops may affect timing and comparability with full GPU runs.

## Evidence and Artifacts
- Kidney aggregate metrics: `single_cell_mechinterp/outputs/probe_benchmark/research_grade/aggregate_metrics.csv`.
- Lung aggregate metrics: `single_cell_mechinterp/outputs/probe_benchmark/research_grade_lung_hvg5000/aggregate_metrics.csv`.
- Immune aggregate metrics: `single_cell_mechinterp/outputs/probe_benchmark/research_grade_immune/aggregate_metrics.csv`.
- Kidney 100-cell aggregate metrics: `single_cell_mechinterp/outputs/probe_benchmark/research_grade_100/aggregate_metrics.csv`.
- Lung 100-cell aggregate metrics: `single_cell_mechinterp/outputs/probe_benchmark/research_grade_lung_hvg5000_100/aggregate_metrics.csv`.
- Immune 100-cell aggregate metrics: `single_cell_mechinterp/outputs/probe_benchmark/research_grade_immune_100/aggregate_metrics.csv`.
- Kidney 200-cell aggregate metrics: `single_cell_mechinterp/outputs/probe_benchmark/research_grade_200/aggregate_metrics.csv`.
- Cross-tissue summary (100-cell): `single_cell_mechinterp/outputs/probe_benchmark/research_grade_100_cross_tissue_summary.csv`.
- Cross-tissue summary: `single_cell_mechinterp/outputs/probe_benchmark/research_grade_cross_tissue_summary.csv`.
- Threshold bests (100-cell cross-tissue): `single_cell_mechinterp/outputs/probe_benchmark/research_grade_100_cross_tissue_threshold_best.csv`.
- Threshold bests (cross-tissue): `single_cell_mechinterp/outputs/probe_benchmark/research_grade_cross_tissue_threshold_best.csv`.
- Stability summaries: `single_cell_mechinterp/outputs/probe_benchmark/research_grade/probe_stability_summary.csv`, `single_cell_mechinterp/outputs/probe_benchmark/research_grade_lung_hvg5000/probe_stability_summary.csv`, `single_cell_mechinterp/outputs/probe_benchmark/research_grade_immune/probe_stability_summary.csv`, `single_cell_mechinterp/outputs/probe_benchmark/research_grade_100/probe_stability_summary.csv`, `single_cell_mechinterp/outputs/probe_benchmark/research_grade_lung_hvg5000_100/probe_stability_summary.csv`, `single_cell_mechinterp/outputs/probe_benchmark/research_grade_immune_100/probe_stability_summary.csv`, `single_cell_mechinterp/outputs/probe_benchmark/research_grade_200/probe_stability_summary.csv`.

## Reproducibility (key commands)
- Kidney runs: `python scripts/run_probe_benchmark.py --config configs/probe_benchmark_cpu_large_seed42.yaml --device mps` (repeat for seeds 43/44).
- Lung runs: `python scripts/run_probe_benchmark.py --config configs/probe_benchmark_cpu_large_lung_hvg5000_seed42.yaml --device mps` (repeat for seeds 43/44).
- Immune runs: `python scripts/run_probe_benchmark.py --config configs/probe_benchmark_cpu_large_immune_seed42.yaml --device mps` (repeat for seeds 43/44).
- Kidney 100-cell runs: `python scripts/run_probe_benchmark.py --config configs/probe_benchmark_cpu_xlarge_seed42.yaml --device mps` (repeat for seeds 43/44).
- Lung 100-cell runs: `python scripts/run_probe_benchmark.py --config configs/probe_benchmark_cpu_xlarge_lung_hvg5000_seed42.yaml --device mps` (repeat for seeds 43/44).
- Immune 100-cell runs: `python scripts/run_probe_benchmark.py --config configs/probe_benchmark_cpu_xlarge_immune_seed42.yaml --device mps` (repeat for seeds 43/44).
- Kidney 200-cell runs: `python scripts/run_probe_benchmark.py --config configs/probe_benchmark_cpu_xxlarge_seed42.yaml --device mps` (repeat for seeds 43/44).
- Baselines: `python scripts/build_correlation_baseline.py --config <config>` plus `--no-abs --output .../coexpression_signed.npy`.
- Evaluation: `python scripts/evaluate_probe_matrices.py --config <config> --probes attention grad_input integrated_gradients perturbation coexpression coexpression_signed`.
- Threshold sweeps: `python scripts/sweep_probe_thresholds.py --config <config> --probes attention grad_input integrated_gradients perturbation consensus coexpression coexpression_signed`.
- Aggregation: `python scripts/aggregate_probe_metrics.py --inputs ...` and `python scripts/aggregate_threshold_sweeps.py --inputs ...`.
- Cross-tissue summary: `python scripts/aggregate_probe_metrics_tissues.py --inputs kidney=... lung=... immune=...`.

## Next Steps
- Investigate why immune 100-cell AUPR drops (candidate mismatch, TF coverage, or preprocessing differences).
- Increase max_cells beyond 200 if MPS throughput is acceptable.
- Add a held-out tissue for threshold calibration and report transfer performance.
