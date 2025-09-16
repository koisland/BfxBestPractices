# Workflows and Snakemake
Building workflows is a common practice in bioinformatics.
* Code that executes a series of programs in serial/parallel to achieve some goal. 

Typically, this is done in a scripting language like Python, Perl, or bash.

## Examples
* [`pggb`](https://github.com/pangenome/pggb)
    * Pangenome graph builder. Combines wfmash, odgi, seqwish, and other tools in bash.
* [`RepeatMasker`](https://www.repeatmasker.org/)
    * Repeat annotation workflow using a sequence library, sequence search engine like rmblast, trf, and other tools glued together with perl.
* [`Verkko`](https://github.com/marbl/verkko)
    * Long-read genome assembler. Combines graphaligner, winnowmap, and bunch of other scripts in Snakemake/bash.

## Using bash
I would advocate against building larger workflows in bash as there are many ["foot-guns"](https://www.pixelbeat.org/programming/shell_script_mistakes.html) that making building robust workflows difficult.

Here are a few:
* Not using common idioms (`set -eu`) causing programs to continue running despite failures and unset variables.
    * How it deleted someone's hard drive.
        * https://www.youtube.com/watch?v=qzZLvw2AdvM
* Variable expansion and braces. (`"${VAR}" or ${VAR} or $VAR`)
    * See https://stackoverflow.com/a/8748880
* Complicated and confusing syntax.
    * See https://devhints.io/bash

You should use a workflow framework like [`Snakemake`](https://snakemake.readthedocs.io/en/stable/), [`Nextflow`](https://www.nextflow.io/docs/latest/index.html), or [`cromwell`](https://github.com/broadinstitute/cromwell).

>![NOTE]
> This is not an absolute rule. There are plenty of data operations that can be achieved with a simple `awk` command that would be difficult in a scripting language.

## Using Snakemake
I use Snakemake a ton because it provides a very simple and intuitive way to organize workflow steps.

Composed of `rule`s with an `input`, `output`, and `shell` directive:
```
rule something:
    input: ""
    output: ""
    shell: ""
```

__Different from other workflow engines because you specify the end of the workflow first.__
* Typically with a `rule all`.
* Snakemake generates a directed acyclic (no cycles or loops) graph of your steps and executes non-dependent steps in parallel.

```
rule all:
    input: []
    default_target: True
```
> I add `default_target: True` so I can place this at the end of the file and my rules are ordered.

![](https://www.hpc-carpentry.org/hpc-python/fig/05-final-dag.svg)
> Source: https://www.hpc-carpentry.org/hpc-python/14-final-notes/index.html

Allows parallelization by specifying the number of cores/jobs.
```bash
snakemake -np -c 12 -s 6_snakemake/scripts/work.smk
```

## Example: Parallelization with Snakemake vs. bash
```bash
time bash 6_snakemake/scripts/work.sh
```

```bash
time snakemake -p -c 6 -s 6_snakemake/scripts/work.smk
```
