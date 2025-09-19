# Working on the cluster

## Data and Project Storage
### Data
All project data is stored in `/project/logsdon_shared/data`
* Generally for external data

```bash
ls /project/logsdon_shared/data/
```
```
50_diverse_primates  hgsvc3                    ONT_only_assembly
CenRNA_IsoSeq        HiPoreC_platinum_genomes  platinum_genomes
CHM1                 HPRC                      PrimateT2T
CHM13                IndianMuntjac             project8p
FiberSeq             natera                    reference
Globus-Logsdon       neocen_orangutan_Mario    T21_Hakon
HG002                NIST_GIAB_HG008           ucberkeley_data
hg38                 ONeil_neocentromere
```

All PromethION data is stored in `/project/logsdon_shared/long_read_archive`
* Pending update.
* For data produced in our lab.

```bash
tree -L 1 /project/logsdon_shared/long_read_archive
```
```
/project/logsdon_shared/long_read_archive
├── clin
├── nhp
├── pop
├── practice
├── share
└── unsorted
```

### Projects
Projects are stored in `/project/logsdon_shared/projects`
* Organized by user or project.
* Ex. `/project/logsdon_shared/projects/Keith`

Personally, I like to keep things organized by analysis and avoid nesting directories as much as possible.
* Easier to find things later.
* Once some analysis is done, I treat it as read-only and symlink the outputs.

I also don't put any raw data in project directories.
* Avoids chance of deleting or accidentally modifying data.
* Always, symlink to these files.

    ```bash
    # Example: Symlink my project data to a subdirectory in my project.
    # Note: It needs to be an absolute path.
    ln -s /project/logsdon_shared/data/my_project_data /project/logsdon-shared/projects/my_project/data
    ```

## Cluster etiquette
* Keep things clean if in a shared directory.
    * For HGSVC, we've been using `${USER}_working` to separate separate analysis directories.
* If running commands on the head node, watch your resource usage.
    * Use `htop` or `top`
* Be conscious of other users when running many jobs in the epistasis queue. Submitting many jobs on the LPC, can suspend other people's jobs.
    * You can check via `bqueues -l $queue`

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

> [!NOTE]
> When submitting long-running jobs, you should use this with `tmux`, `screen`, or `nohup`.

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
