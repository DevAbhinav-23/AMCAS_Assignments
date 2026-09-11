#!/bin/zsh
# AMCAS Assignment 1 - Part E Task 1/2: O3CPU runs with atomic warmup.
# Usage: ./run_part_e_o3.sh <bfs|sssp> <total_insts_from_TimingSimple>
# The CPU is switched from AtomicSimpleCPU to O3CPU after
# (total - 600M) instructions, so the O3 core measures the last ~600M
# instructions of the program (graph-build tail + the BFS/SSSP kernel),
# matching the assignment's "warm up atomically, then switch to O3" flow.
set -e
BASE="$(cd "$(dirname "$0")" && pwd)"
kernel=$1
total=$2
FF=$(( total > 600000000 ? total - 600000000 : total / 2 ))
GRAPH_SCALE=${GRAPH_SCALE:-14}
OUTROOT=${GEM5_OUTDIR:-m5out}
cd "$BASE/gem5"
for v in SRAM MRAM; do
  if [ "$v" = SRAM ]; then sz=2MB; lat=7; else sz=8MB; lat=14; fi
  out="$OUTROOT/partE_${kernel}_${v}_O3CPU"
  echo "=== $kernel $v (O3, fast-forward $FF) ==="
  mkdir -p "$out"
  env -u LD_LIBRARY_PATH ./build/X86/gem5.opt --outdir="$out" \
    configs/deprecated/example/part_e_se.py \
    --cpu-type=O3CPU --fast-forward=$FF \
    --caches --l2cache \
    --l1d_size=32kB --l1i_size=32kB --l1d_assoc=8 --l1i_assoc=8 \
    --l2_size=$sz --l2_assoc=8 --l2-hit-latency=$lat \
    --mem-type=DDR4_2400_8x8 --mem-size=4GB \
    --cmd="$BASE/gapbs/$kernel" --options="-g $GRAPH_SCALE -n 1" > "$out.stdout" 2>&1
  grep -E "^simSeconds|^simInsts|^sim_IPC|overall_miss_rate::total" "$out/stats.txt" | head -4
done
echo O3_DONE
