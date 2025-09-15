import os


WD = os.getcwd()


rule hello_hello_world:
    output:
        os.path.join(WD, "2_working_on_the_cluster", "results", "hello_world.txt")
    threads:
        1
    resources:
        mem="8GB",
        lsf_queue="epistasis_normal",
        lsf_project="default", 
    shell:
        """
        sleep 5
        echo "I did some work on the cluster." >> {output}
        """

rule all:
    input:
        rules.hello_hello_world.output
    default_target:
        True
