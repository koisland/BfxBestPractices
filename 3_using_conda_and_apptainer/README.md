# Using conda and apptainer
At this point you should have an environment ready with the requirements in `environment.yaml`.
```bash
conda activate workshop
```

## Conda
Installing tools with conda is simple.
* If we want to install a software from a specific channel, we use the syntax `conda install {channel}::{tool}`.

### Bioconda
Bioconda is the channel for bioinformatics software.

Try installing `samtools`.
```bash
conda install bioconda::samtools -y
```

### PyPi
We also have `python==3.12` installed in this environment.

We can `pip` (Python's package manager) install things too. 
```bash
pip install nucflag --no-binary pysam
```

> [!NOTE]
> I use `--no-binary` here because pip installs an [incompatible version of `openssl`](https://access.redhat.com/solutions/7035895) library with the RHEL9 OS. This means all the underlying dependencies for `pysam`'s compilation must exist.

Try running `nucflag`'s help command.
```bash
# What happens when we run this on a separate compute node?
ibash
conda run --name workshop nucflag -h 
```

# Apptainer
While conda helps in reproducibility, many packages still depend on shared/system libraries being available. Also complicating things is the fact that if we compile/install our code in one environment, but try to run it in another, things might break.

Using containerization tools like `apptainer` or `docker`, can help alleviate this pain.

We'll load the apptainer module.
```bash
module load DEV/singularity
```

And use a [singularity](https://github.com/koisland/LPCDockerfiles) file I created prior to this workshop.
```bash
singularity exec /project/logsdon_shared/tools/containers/nucflag.sif nucflag -h
```
