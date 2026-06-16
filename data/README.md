# Data and provenance

All data used in this study are publicly available. This document records the
provenance, versions, and access routes for every input, and explains what is
committed to the repository versus what must be downloaded separately.

## What is in this repository

| Path | Description | Size |
|------|-------------|------|
| `data/sweep_outputs/` | Committed probe/threshold sweep results (JSON/CSV) produced by the upstream evaluation pipeline. Direct inputs to `src/analyze_transfer_artifacts.py`. | ~0.9 MB |
| `data/mvp_report/probe_benchmark_workshop_mvp.md` | Workshop MVP benchmark tables (per-tissue AUPR, stability) parsed by the analysis scripts. | ~9 KB |
| `results/artifacts/` | Derived result tables cited in the paper, regenerable from the above. | ~0.14 MB |
| `results/figures/` | Figures 1–11 (PNG, 300 DPI). | ~2.2 MB |

These are sufficient to reproduce **every table and figure** in the paper
without any external download (`make all`).

## What must be downloaded separately (raw single-cell matrices)

The optional confound/donor-composition analysis
(`src/analyze_confound_uncertainty.py`) reads the raw expression matrices.
These are large (hundreds of MB to tens of GB) and are **not** committed.
Place them under `data/raw/` with the filenames below, or pass explicit
`--kidney-h5ad` / `--lung-h5ad` / `--immune-h5ad` arguments.

| Expected file (`data/raw/`) | Source |
|------|--------|
| `tabula_sapiens_kidney.h5ad` | Tabula Sapiens (kidney) |
| `tabula_sapiens_lung.h5ad`   | Tabula Sapiens (lung) |
| `tabula_sapiens_immune.h5ad` | Tabula Sapiens (immune) |

## Primary data sources

### Single-cell expression — Tabula Sapiens
A multiple-organ, single-cell transcriptomic atlas of humans.
- Portal: https://tabula-sapiens.sf.czbiohub.org/
- CELLxGENE collection: https://cellxgene.cziscience.com/collections/e5f58829-1a66-40b5-a624-9046778e74f5
- Reference: The Tabula Sapiens Consortium. *Science* 376, eabl4896 (2022).
  doi:10.1126/science.abl4896
- License: CC BY 4.0.

### Reference gene regulatory networks (evaluation ground truth)
- **TRRUST v2** — literature-curated TF–target interactions.
  https://www.grnpedia.org/trrust/ — Han et al., *Nucleic Acids Res.* 46, D260–D266 (2018).
- **DoRothEA** (incl. ChIP-seq–supported confidence levels) — consensus
  TF regulons. https://saezlab.github.io/dorothea/ —
  Garcia-Alonso et al., *Genome Res.* 29, 1363–1375 (2019).
- **SCENIC / cisTarget** resources used for regulon context.
  https://scenic.aertslab.org/ — Aibar et al., *Nat. Methods* 14, 1083–1086 (2017).
- **OmniPath** intercellular/prior resources referenced by some sweep configs.
  https://omnipathdb.org/

### Evaluation scaffolds
- **BEELINE** GRN-inference benchmarking framework (GSD and related synthetic
  references). https://github.com/Murali-group/Beeline —
  Pratapa et al., *Nat. Methods* 17, 147–154 (2020).
- **HPN-DREAM** network-inference challenge scaffolds (used as a timeseries
  evaluation reference in `configs/`).

### Foundation model — scGPT
- Code/weights: https://github.com/bowang-lab/scGPT
- Reference: Cui et al. scGPT. *Nat. Methods* (2024); bioRxiv 2023.04.30.538439.

## Reference network versions

The exact reference-network subsets, gene-ID crosswalks, and intersection/union
variants used in each sweep are defined by the YAML files in `configs/` and the
companion `*_missing_report.json` / `*_crosswalk.*` files in
`data/sweep_outputs/`, which record gene-ID mapping coverage for full
reproducibility.

## Licensing note

Each third-party dataset retains its original license (Tabula Sapiens: CC BY
4.0; TRRUST, DoRothEA, SCENIC, OmniPath, BEELINE: see their respective sites).
The code and derived result tables in this repository are released under the
MIT License (see `LICENSE`).
