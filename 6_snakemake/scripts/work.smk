import os


WD = os.getcwd()


rule work:
    output:
        os.path.join(WD, "6_snakemake", "results", "out_{n}.txt"),
    shell:
        """
        sleep 2
        touch {output}
        """

rule all:
    input:
        expand(rules.work.output, n=range(5)),
    default_target:
        True
