# Structured data
Structured data is data that is easily machine-readable and tidy. Tidy data allows us to easily parse data and actually analyze data.
* See https://vita.had.co.nz/papers/tidy-data.pdf

Common formats like `JSON`, `YAML`, `TOML`, or `TSV`/`CSV` are examples of machine-readable, tidy, structured data.

Similar concept to "tidy" data where data is structured to make analysis easy.
* Wickham, Hadley (2014). "Tidy Data" (PDF). Journal of Statistical Software. 59 (10). doi:10.18637/jss.v059.i10.
* ^^^ Author of R tidyverse

## Example: Inspector
[`Inspector`](https://github.com/Maggi-Chen/Inspector)'s is an example of what you should __avoid__. Looking at its summary output:
* It is not easily serializable.
* Everyone who wants to use this output must build their own script to parse it.
* Mixed tabs and headers on multiple lines.

```
Statics of contigs:
Number of contigs	47
Number of contigs > 10000 bp	47
Number of contigs >1000000 bp	46
Total length	5999434118
Total length of contigs > 10000 bp	5999434118
Total length of contigs >1000000bp	5999417348
Longest contig	252060941
Second longest contig length	244022267
N50	146787023
N50 of contigs >1Mbp	146787023
```

## Example: pggb
[`pggb`](https://github.com/pangenome/pggb) is a __good__ example of what you should do.

At the start of it's run, it outputs the parameters and version it uses for a run.
* Easy serializable as `YAML`
* Can use existing tools to get the values.

```yaml
general:
  input-fasta:        merged/subset_renamed.fa
  output-dir:         pggb/
  temp-dir:           pggb/
  resume:             false
  compress:           false
  threads:            65
  poa_threads:        65
pggb:
  version:            v0.7.2
# ...
```

## Demonstration: Inspector
To run the script:
```bash
python 4_structured_data/scripts/parse_summary_statistics.py 
```

## Demonstration: pggb
```bash
module load yq
yq .pggb.version 4_structured_data/data/pggb.params.yml
```
