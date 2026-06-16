# Iterator Stress-Test Summary

## Transfer shift significance
- Exact permutation delta (30 minus 100): 0.3026 (p=0.0108).

## Leave-one-target-out robustness
- Drop immune: delta=0.1878 (30=0.2882, 100=0.1004).
- Drop kidney: delta=0.3563 (30=0.4347, 100=0.0784).
- Drop lung: delta=0.3636 (30=0.4150, 100=0.0514).

## Leave-one-source-out robustness
- Drop source immune: delta=0.2681 (30=0.3649, 100=0.0968).
- Drop source kidney: delta=0.3056 (30=0.3423, 100=0.0367).
- Drop source lung: delta=0.3340 (30=0.4308, 100=0.0968).

## Weight-scheme sensitivity
- celltype_entropy: 30=0.3977, 100=0.0798, delta=0.3180.
- combined_diversity: 30=0.4160, 100=0.0755, delta=0.3405.
- donor_diversity: 30=0.4484, 100=0.0731, delta=0.3753.
- sample_diversity: 30=0.4099, 100=0.0738, delta=0.3361.
- uniform: 30=0.3793, 100=0.0768, delta=0.3026.

## Interpretability validity checks
- Best-probe winners: coexpression-family=7/9, attribution-family=2/9.
- immune: rho(AUPR, stability)=0.036, exact p=0.9508.
- kidney: rho(AUPR, stability)=-0.955, exact p=0.0032.
- lung: rho(AUPR, stability)=-0.679, exact p=0.1095.

## Threshold default stress test
- P95 improves over P90 in 10/14 paired sweeps; mean improvement=0.000241; one-sided sign-test p=0.0898.
