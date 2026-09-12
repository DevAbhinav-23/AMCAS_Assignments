# AMCAS Assignment 1

Assignment 1 for **ECE2.414 – Advanced Memory Circuits and Systems** at IIIT Hyderabad, Monsoon 2026.

The assignment studies memory behavior from the device level through whole-program simulation. The complete analysis is available in [`Assign-1/Report/Assign_1-Report.pdf`](Assign-1/Report/Assign_1-Report.pdf).

## Repository layout

```text
Assign-1/
├── code_ngspice/        Part A: 6T SRAM read-margin simulations
├── cacti/               Part B: 2 MB SRAM L2 cache modeling
├── NVSim/               Part C: SRAM and STT-MRAM modeling
├── ramulator2/          Part D: DDR4 scheduling and mapping experiments
├── gem5/                Part E: whole-program cache simulations
├── gapbs/               BFS/SSSP benchmark source used by gem5
├── DRAMsim3/            DRAM simulator source and supporting experiments
├── Report/              LaTeX source and compiled report
├── *.cir, *.cfg, *.py   Experiment drivers and configurations
├── *_out.csv, *.png     Simulator outputs and plots
└── *.trace, *.json, *.txt  Trace inputs and recorded statistics
```

Build directories, virtual environments, compiled binaries, object files, and LaTeX temporary files are excluded by [`.gitignore`](.gitignore). Source code, configurations, reports, plots, traces, and recorded results are kept.

## Part-to-file mapping

| Part | Main code and configuration | Results |
| --- | --- | --- |
| **A – ngspice** | [`code_ngspice/Task-1.cir`](Assign-1/code_ngspice/Task-1.cir) through `Task-4.cir`, using [`45nm_HP.pm`](Assign-1/code_ngspice/45nm_HP.pm) | `Task-*_out.csv`, `Task-2_vq.png`, and `Task-3_dv_vs_vdd.png` in `code_ngspice/` |
| **B – CACTI** | CACTI source in [`cacti/`](Assign-1/cacti/); task inputs and sweep scripts in [`cacti/code_cacti/`](Assign-1/cacti/code_cacti/) | `Task-*.cfg.out` files in `cacti/code_cacti/` and the CACTI values summarized in the report |
| **C – NVSim** | C++ implementation and headers in [`NVSim/`](Assign-1/NVSim/); SRAM, STT-MRAM, TMR, and reset-current configurations in the same directory | Device-level comparisons and sensitivity results are recorded in the report |
| **D – Ramulator 2** | [`part_d_runner.py`](Assign-1/ramulator2/part_d_runner.py) and [`part_d_t4_sensitivity.py`](Assign-1/ramulator2/part_d_t4_sensitivity.py), using the `l2miss_*.trace` inputs | `plots/`, [`plots_data/data.json`](Assign-1/ramulator2/plots_data/data.json), and the trace inputs in `ramulator2/` |
| **E – gem5** | [`run_part_e_o3.sh`](Assign-1/run_part_e_o3.sh), [`run_part_e.sh`](Assign-1/run_part_e.sh), and [`gem5/configs/deprecated/example/part_e_se.py`](Assign-1/gem5/configs/deprecated/example/part_e_se.py) | Runtime statistics are generated under `gem5/m5out/`; the recorded comparison is preserved in the report PDFs |

The [`gapbs/`](Assign-1/gapbs/) directory supplies the BFS and SSSP benchmark programs used by Part E. The [`DRAMsim3/`](Assign-1/DRAMsim3/) directory and the top-level [`dramsim3.json`](Assign-1/dramsim3.json), [`dramsim3.txt`](Assign-1/dramsim3.txt) files contain supporting DRAM simulator material.

## Report takeaways

- **SRAM read margin:** The nominal bitline differential is 729.86 mV; the 25 mV sensing threshold is reached near 0.448 V, below the requested 0.6–1.1 V operating range.
- **CACTI:** The 2 MB, 45 nm SRAM L2 baseline has 2.90184 ns access time, 0.792885 nJ read energy, 562.632 mW leakage, and 11.4742 mm² area.
- **NVSim:** STT-MRAM uses 0.56× the SRAM area and 0.13× the leakage, at the cost of 1.87× read latency and 20.4× write latency.
- **Ramulator:** FRFCFS with RoBaRaCoCh completes the baseline stream in 9,594 cycles; two channels reduce this to 4,889 cycles, while `tCCD` is the most influential timing parameter in the sensitivity sweep.
- **gem5:** The reported 8 MB STT-MRAM L2 configuration outperforms the 2 MB SRAM configuration by 1.7% on BFS and 4.9% on SSSP because its lower miss rate offsets the slower cache hit.

## Reference files

- [Final assignment report](Assign-1/Report/Assign_1-Report.pdf) (LaTeX source: [`Assign_1-Report.tex`](Assign-1/Report/Assign_1-Report.tex))
