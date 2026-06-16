.PHONY: all artifacts figures confound clean help

PYTHON ?= python

help:
	@echo "Targets:"
	@echo "  make artifacts  - re-derive result tables into results/artifacts/"
	@echo "  make figures    - regenerate results/figures/fig01-fig11.png"
	@echo "  make all        - artifacts + figures"
	@echo "  make confound   - donor/composition sensitivity (needs raw .h5ad; see data/README.md)"

all: artifacts figures

artifacts:
	$(PYTHON) src/analyze_transfer_artifacts.py
	$(PYTHON) src/analyze_iterator_stress_tests.py

figures: artifacts
	$(PYTHON) src/make_paper_figures.py

confound:
	$(PYTHON) src/analyze_confound_uncertainty.py

clean:
	rm -f results/figures/*.png
