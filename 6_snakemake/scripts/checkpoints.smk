import os, random


checkpoint generate_random_seq:
    output:
        fofn="results/checkpoints/seqs/seq.fofn"
    params:
        seed=42,
        max_num_files=50,
        seq_length=100,
        output_dir=lambda wc, output: os.path.dirname(output.fofn)
    run:
        random.seed(params.seed)
        nts = ["A", "T", "G", "C", "N"]
        weights = [5, 5, 5, 5, 0.1]
        os.makedirs(params.output_dir, exist_ok=True)
        # Variable number of outputs not known during workflow build.
        num_files = random.choice(range(params.max_num_files))

        with open(output.fofn, "wt") as fofn_fh:
            for choice in range(num_files):
                outfile = os.path.join(params.output_dir, f"{choice}.fa")
                seq_nts = random.choices(nts, k=params.seq_length, weights=weights)
                with open(outfile, "wt") as fh:
                    # Random sequence.
                    fh.write(f">{choice}\n")
                    fh.write("".join(seq_nts) + "\n")
                
                # Add file to fofn.
                fofn_fh.write(f"{outfile}\n")

# If valid, just append valid to header.
rule label_valid:
    input:
        "results/checkpoints/seqs/{name}.fa"
    output:
        "results/checkpoints/valid/{name}.fa"
    shell:
        """
        sed "s/>/>valid_/" {input} > {output}
        """

# Remove scaffold.
rule remove_scaffold:
    input:
        "results/checkpoints/seqs/{name}.fa"
    output:
        "results/checkpoints/scaffold/{name}.fa"
    shell:
        """
        sed 's/N//g' {input} > {output}
        """

def clean_fa(wc):
    fofn = checkpoints.generate_random_seq.get(*wc).output.fofn
    outputs = []
    for file in open(fofn):
        file = file.strip()
        name, _ = os.path.splitext(os.path.basename(file))
        with open(file) as fh:
            # If contains scaffold, remove it. 
            if "N" in fh.read():
                outputs.extend(expand(rules.remove_scaffold.output, name=name))
            # Otherwise, add valid label. 
            else:
                outputs.extend(expand(rules.label_valid.output, name=name))
    return outputs

rule agg_outputs:
    input:
        clean_fa
    output:
        touch("results/checkpoints/all.done")

rule all:
    input:
        rules.agg_outputs.output
    default_target:
        True
