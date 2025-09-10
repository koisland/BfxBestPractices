# Working on the cluster

## Storage
All project data is stored in `/project/logsdon_shared/data`

All PromethION data is stored in `/project/logsdon_shared/long_read_archive`
* Pending update.

Projects are stored in `/project/logsdon_shared/projects`
* Organized by user.
* Ex. `/project/logsdon_shared/projects/Keith`

## Cluster etiquette
* Keep things clean if in a shared directory.
* If running commands on the head node, watch your resource usage.
* Be conscious of other users when running many jobs in the epistasis queue. Submitting many jobs on the LPC, can suspend other people's jobs.

## Submitting LSF jobs

### Manually
To submit LSF jobs you can create batch scripts.
```bash
bsub < 2_working_on_the_cluster/scripts/cluster.sh
```

I find this pretty tedious and limiting so I don't use this at all.
```bash
# https://hpc.ncsu.edu/Documents/lsf_template.php
#!/bin/bash
#BSUB -n 1
#BSUB -q epistasis_normal
#BSUB -R span[hosts=1]
#BSUB -R rusage[mem=8GB]
#BSUB -o out.%J
#BSUB -e err.%J
#BSUB -J hello_hello_world
#BSUB -x

# Do some work here.
...
```

### Snakemake
Or you can use `snakemake` and the LSF executor.
```bash
pip install snakemake-executor-plugin-lsf
```

```bash
snakemake -np --executor lsf -s 2_working_on_the_cluster/scripts/cluster.smk
```

```
rule name:
    input: ""
    output: ""
    threads: 1
    resources:
        # Memory
        mem="8GB",
        # Queue
        lsf_queue="epistasis_normal",
        # Project
        lsf_project="default", 
    shell:
        """
        # Do some work here
        """
```

### Tracking jobs
To see what's running in a queue.
```bash
bqueues -l epistasis_long
```

For detailed job descriptions.
```bash
bjobs -l
```

To kill specific jobs.
```bash
bkill $JOB_ID
```