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

> [!NOTE]
> This is not an absolute rule. There are plenty of data operations that can be achieved with a simple `awk` command that would be difficult in a scripting language.

## Using Snakemake
I use Snakemake a ton because it provides a very simple and intuitive way to organize workflow steps.

### Format
Composed of `rule`s with an `input`, `output`, and `shell` directive. There are many more directives that you can read about [here](https://snakemake.readthedocs.io/en/stable/snakefiles/rules.html#).
```python
rule something:
    # Input files
    input: ""
    # Output files
    output: ""
    # Command to run on files.
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

### Wildcards
Wildcards allow running a given workflow for multiple samples, conditions, etc.
* Specified via python format string, `"{wildcard_name}"`
* Add to input, output, log, etc. that need to be variable.
* ex. `"input/{sm}.fa"`
* Can be expanded via the `expand()` function
    ```python
    SAMPLES=["a", "b", "c"]
    expand("input/{sm}.fa", sm=SAMPLES)
    # ['input/a.fa', 'input/b.fa', 'input/c.fa']
    ```

Here's a small example:
```python
# A list of samples
SAMPLES = ["a", "b", "c"]

# We want to some analysis on multiple samples.
rule analysis:
    input:
        "input/{sample}.fa"
    output:
        "output/{sample}.fa"
    shell:
        ...
    
rule all:
    input:
        expand(rules.analysis.output, sm=SAMPLES)
    default_target:
        True
```

#### Lazy rule evaluation with wildcards
I find a common Snakemake idiom to be the following:
1. Read a configfile/data source.
2. Categorize input files/config by wildcard in a dictionary.
3. Read files within functions.

However, because `Snakemake` doesn't know what the input is at workflow compile time, we need to lazily evaluate it.

Consider the following example:
```python
FILES = {"ont": ["file_1.bam"]}

rule all:
    input:
        # We want our wildcard to be dtype
        expand("results/{dtype}/summary.txt", dtype="ont")

rule analysis:
    # But this immediately fails because we try to use a literal string "{dtype}" to access the value in FILES.
    input: FILES["{dtype}"]
    output: "results/{dtype}/summary.txt"
    shell:
        """
        # Some work...
        """
```

To make this work, we need to delay Snakemake from evaluating `rules.analysis.input` by using a [lambda](https://realpython.com/python-lambda/) function.
```python
FILES = {"ont": ["file_1.bam"]}

rule all:
    input:
        # Again, we want our wildcard to be dtype
        expand("results/{dtype}/summary.txt", dtype="ont")

rule analysis:
    # This works! Snakemake now will now wait to get the input.
    input: lambda wc: FILES[wc.dtype]
    output: "results/{dtype}/summary.txt"
    shell:
        """
        # Some work...
        """
```

This also applies to parameters and other directives.


### Running
Allows parallelization by specifying the number of cores/jobs. 
* For other command-line flags, read [here](https://snakemake.readthedocs.io/en/stable/executing/cli.html).
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

## Dynamic outputs with checkpoints
One strength of Snakemake is that you know exactly what output is produced from a workflow.

However, sometimes you need output to be dynamic.
* ex. I have a list of fasta sequences and I only want to run an analysis on those that pass some condition.

```
                 +-> file_1 -> check (o) -> analysis_a
generate_files --+-> file_2 -> check (o) -> analysis_a
                 +-> file_3 -> check (x) -> analysis_b
```

You can use checkpoints in Snakemake to dynamically change which analysis to run based on some condition. Then you can aggregate the outputs.
* See [here](https://snakemake.readthedocs.io/en/stable/snakefiles/rules.html#data-dependent-conditional-execution) for more information.

```python
# Specify checkpoint with checkpoint label.
checkpoints step_that_produces_var_output:
    input:
        ...
    output:
        ...
    shell:
        ...

rule analysis_a:
    ...

rule analysis_b:
    ...

def final_outputs(wc):
    # We want to get the checkpoint output for all passed wildcards.
    chkpt = checkpoints.step_that_produces_var_output.get(**wc).output

    ... # Read checkpoint output
    # Then, based on checkpoint output, do something else.
    if cond:
        return rules.analysis_a.output
    else:
        return rules.analysis_b.output

# Then aggregate outputs
rule aggregate_outputs:
    input:
        final_outputs
    output:
        touch("all.done")

rule all:
    input:
        rule.aggregate_outputs.output
    default_target:
        True
```

## Example: Checkpoints
Here we'll generate some random fasta files and change what we do to each file based on if it has an `N`s.
```bash
snakemake -p -c 6 -s 6_snakemake/scripts/checkpoints.smk
```

Valid added to header.
```bash
git diff --no-index results/checkpoints/seqs/1.fa results/checkpoints/valid/1.fa
```

Scaffolds removed.
```bash
git diff --no-index results/checkpoints/seqs/0.fa results/checkpoints/scaffold/0.fa
```
