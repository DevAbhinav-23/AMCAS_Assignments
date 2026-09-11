#!/bin/bash
# Task 2: Sweep capacity from 256kB to 16MB

SIZES=(262144 524288 1048576 2097152 4194304 8388608 16777216)
LABELS=("256kB" "512kB" "1MB" "2MB" "4MB" "8MB" "16MB")

for i in "${!SIZES[@]}"; do
    SIZE=${SIZES[$i]}
    LABEL=${LABELS[$i]}
    CFG="Task-2_${LABEL}.cfg"
    OUT="Task-2_${LABEL}.out"

    cat > "$CFG" <<EOF
# Task 2: Capacity sweep - ${LABEL}
-size (bytes) ${SIZE}
-Array Power Gating - "false"
-WL Power Gating - "false"
-CL Power Gating - "false"
-Bitline floating - "false"
-Interconnect Power Gating - "false"
-Power Gating Performance Loss 0.01
-block size (bytes) 64
-associativity 8
-read-write port 1
-exclusive read port 0
-exclusive write port 0
-single ended read ports 0
-UCA bank count 4
-technology (u) 0.045
-page size (bits) 8192
-burst length 8
-internal prefetch width 8
-Data array cell type - "itrs-hp"
-Data array peripheral type - "itrs-hp"
-Tag array cell type - "itrs-hp"
-Tag array peripheral type - "itrs-hp"
-output/input bus width 512
-operating temperature (K) 350
-cache type "cache"
-tag size (b) "default"
-access mode (normal, sequential, fast) - "normal"
-design objective (weight delay, dynamic power, leakage power, cycle time, area) 0:0:0:100:0
-deviate (delay, dynamic power, leakage power, cycle time, area) 20:100000:100000:100000:100000
-NUCAdesign objective (weight delay, dynamic power, leakage power, cycle time, area) 100:100:0:0:100
-NUCAdeviate (delay, dynamic power, leakage power, cycle time, area) 10:10000:10000:10000:10000
-Optimize ED or ED^2 (ED, ED^2, NONE): "ED^2"
-Cache model (NUCA, UCA)  - "UCA"
-NUCA bank count 0
-Wire signaling (fullswing, lowswing, default) - "Global_30"
-Wire inside mat - "semi-global"
-Wire outside mat - "semi-global"
-Interconnect projection - "conservative"
-Core count 8
-Cache level (L2/L3) - "L2"
-Add ECC - "true"
-Print level (DETAILED, CONCISE) - "DETAILED"
-Print input parameters - "false"
-Force cache config - "false"
-Ndwl 1
-Ndbl 1
-Nspd 0
-Ndcm 1
-Ndsam1 0
-Ndsam2 0
-dram_type "D"
-iostate "W"
-dram_ecc "Y"
-addr_timing 1.0
-bus_bw 12.8 GBps
-mem_density 4 Gb
-bus_freq 800 MHz
-duty_cycle 1.0
-activity_dq 1.0
-activity_ca 0.5
-num_dq 72
-num_dqs 18
-num_ca 25
-num_clk 2
-num_mem_dq 2
-mem_data_width 8
-rtt_value 10000
-ron_value 34
-tflight_value
-num_bobs 1
-capacity 80
-num_channels_per_bob 1
-first metric "Cost"
-second metric "Bandwidth"
-third metric "Energy"
-DIMM model "ALL"
-mirror_in_bob "F"
EOF

    echo "Running CACTI for ${LABEL} (${SIZE} bytes)..."
    ./cacti -infile "$CFG" > "$OUT" 2>&1
    echo "Done: ${LABEL}"
done

echo "=== All Task 2 simulations complete ==="
