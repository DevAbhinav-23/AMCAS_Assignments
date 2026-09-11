#!/bin/zsh
# AMCAS Assignment 1 - Part E (gem5)
# Runs GAPBS bfs/sssp on the two L2 configurations from Parts B/C:
#   SRAM (CACTI): 2 MB, 8-way, 7-cycle hit
#   STT-MRAM (NVSim, same area): 8 MB, 8-way, 14-cycle hit
# Task 3 re-runs the winning config with TimingSimpleCPU (no OoO).
# Requires build/X86/gem5.opt (see build_gem5.sh).
set -e
BASE="$(cd "$(dirname "$0")" && pwd)"
cd "$BASE/gem5"
PY=../.venv-gem5/bin/python3

run() {
  local kernel=$1 variant=$2 cpu=$3 l2size=$4 lat=$5
  local out="m5out/partE_${kernel}_${variant}_${cpu}"
  echo "=== $kernel / $variant / $cpu -> $out"
  mkdir -p "$out"
  env -u LD_LIBRARY_PATH $PY build/X86/gem5.opt --outdir="$out" \
    configs/deprecated/example/part_e_se.py \
    --cpu-type=$cpu --caches --l2cache \
    --l1d_size=32kB --l1i_size=32kB --l1d_assoc=8 --l1i_assoc=8 \
    --l2_size=$l2size --l2_assoc=8 --l2-hit-latency=$lat \
    --mem-type=DDR4_2400_8x8 --mem-size=4GB \
    --cmd="$BASE/gapbs/$kernel" --options="-g 18 -n 1" \
    > "$out.stdout" 2>&1
  grep -E "simSeconds|simInsts|sim_IPC|l2cache.overall_miss_rate::total|l2cache.overall_hits::total|l2cache.overall_misses::total" \
    "$out/stats.txt" | sed "s|^|  |"
}

for k in bfs sssp; do
  run $k SRAM O3CPU        2MB 7
  run $k MRAM O3CPU        8MB 14
done
# Task 3: winning config re-run with TimingSimpleCPU (filled after Task 1/2 verdict)
run bfs SRAM TimingSimpleCPU 2MB 7
run sssp SRAM TimingSimpleCPU 2MB 7
echo "All Part E runs complete."
