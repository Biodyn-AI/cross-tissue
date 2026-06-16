# Cross-Tissue Probe Threshold Transfer for Mechanistic GRN Evaluation in Single-Cell Foundation Models

This repository contains the code, derived result tables, figures, and
configuration files accompanying the paper:

> **Cross-Tissue Probe Threshold Transfer for Mechanistic Gene Regulatory
> Network Evaluation in Single-Cell Foundation Models.**
> Ihor Kendiukhov, University of Tübingen.

The study asks a question that within-tissue benchmark leaderboards do not
answer: **do the probe and threshold choices that work best for gene
regulatory network (GRN) inference in one tissue transfer to a held-out
tissue?** We quantify the **cross-tissue transfer regret** of probe selections
derived from scGPT embeddings across three tissues (kidney, lung, immune),
three reference networks (TRRUST, DoRothEA, DoRothEA ChIP-seq), seven probe
families, and two cell budgets (30 and 100 cells).

## Key findings

- **Transfer regret has a sharp cell-budget phase transition.** Mean relative
  regret falls 4.9-fold from 0.379 (95% bootstrap CI 0.221–0.521) at 30 cells
  to 0.077 (CI 0.022–0.152) at 100 cells (Cliff's δ = 0.778; exact permutation
  Δ = 0.303, p = 0.011, BH q = 0.027).
- **Optimization only helps when data is sufficient.** Source-best probe
  selection slightly *underperforms* random selection at 30 cells but massively
  outperforms it at 100 cells.
- **Variance structure flips with budget.** The tissue×probe interaction
  dominates variance at 30 cells (43.6%); tissue identity dominates at 100
  cells (81.8%).
- **Coexpression probes generalize best**, winning 7/9 tissue–reference
  contests vs. 2/9 for attribution-based probes.
- **Multiple-testing discipline:** of 5 preregistered hypotheses, only 2
  survive Benjamini–Hochberg correction at FDR = 0.1.

## Repository layout

```
cross-tissue/
├── README.md                  # this file
├── LICENSE                    # MIT
├── CITATION.cff               # how to cite
├── requirements.txt           # Python dependencies
├── Makefile                   # one-command reproduction of artifacts + figures
├── src/                       # analysis code
│   ├── analyze_transfer_artifacts.py     # sweep outputs + MVP tables -> result CSVs
│   ├── analyze_confound_uncertainty.py   # donor/composition sensitivity + bootstrap CIs
│   ├── analyze_iterator_stress_tests.py  # permutation, leave-one-out, policy-uplift CIs
│   └── make_paper_figures.py             # regenerates Fig 1–11 from result CSVs
├── configs/                   # YAML configs for the upstream probe/threshold sweeps
├── data/
│   ├── README.md              # dataset access + provenance (see below)
│   ├── mvp_report/            # workshop MVP benchmark tables (analysis input)
│   ├── sweep_outputs/         # committed probe/threshold sweep results (JSON/CSV)
│   └── raw/                   # (not committed) large .h5ad single-cell matrices
├── results/
│   ├── artifacts/             # derived result tables cited in the paper
│   └── figures/               # fig01–fig11 (PNG, 300 DPI)
└── paper/
    ├── cross_tissue_transfer_plos_one.pdf
    └── supporting_information.pdf
```

## Reproducing the results

### 1. Environment

```bash
python -m venv .venv && source .venv/bin/activate
pip install -r requirements.txt
```

### 2. Derived tables and figures (no large downloads needed)

The committed sweep outputs in `data/sweep_outputs/` and the MVP tables in
`data/mvp_report/` are sufficient to regenerate every result table and figure:

```bash
make artifacts   # re-derive result CSVs into results/artifacts/
make figures     # regenerate results/figures/fig01–fig11.png
make all         # both
```

or directly:

```bash
python src/analyze_transfer_artifacts.py
python src/analyze_iterator_stress_tests.py
python src/make_paper_figures.py
```

All scripts default to repository-relative paths; run them from the repo root.
Random-seeded steps (bootstrap, permutation) use `--seed 42` by default.
Tested with Python 3.9–3.11.

### 3. Confound / donor-composition sensitivity (optional, needs raw data)

`src/analyze_confound_uncertainty.py` additionally reads the raw Tabula Sapiens
`.h5ad` matrices to assess donor/sample-composition confounds. These files are
large and are **not** committed; see [`data/README.md`](data/README.md) for
download instructions, then place them under `data/raw/` (or pass
`--kidney-h5ad/--lung-h5ad/--immune-h5ad`).

## Data and provenance

All underlying data are public. See [`data/README.md`](data/README.md) for full
provenance and access instructions for Tabula Sapiens, TRRUST, DoRothEA,
SCENIC, and the BEELINE/HPN-DREAM evaluation scaffolds. scGPT model weights are
from the official scGPT release.

## Citation

If you use this code or data, please cite the paper (see `CITATION.cff`).

## License

Code is released under the MIT License (`LICENSE`). Third-party datasets retain
their original licenses as described in `data/README.md`.
