#!/bin/bash 
#BSUB -n 1
#BSUB -q epistasis_normal
#BSUB -R span[hosts=1]
#BSUB -R rusage[mem=8GB]
#BSUB -o out.%J
#BSUB -e err.%J
#BSUB -J hello_hello_world
#BSUB -x

# https://hpc.ncsu.edu/Documents/lsf_template.php

WD=$(dirname $0)
WD="$WD/../results"

sleep 5
echo "I did some work on the cluster." >> "$WD/hello_world.txt"
