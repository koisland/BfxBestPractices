#!/bin/bash

set -euo pipefail

OUTDIR="6_snakemake/results"
mkdir -p "${OUTDIR}"

for i in $(seq 0 4); do
    sleep 2
    echo "On ${i}"
    touch "${OUTDIR}/out_${i}_bash.txt"
done
