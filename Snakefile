configfile: "config.json"

simple_id = list(config['datasets'].keys())

rule all:
    input:
        expand("data/reads/{id}_1.fastq",
               id=simple_id),
        expand("data/reads/{id}_2.fastq",
               id=simple_id),
        tpm = "results/kallisto/tpm.tsv"

rule all_downloads:
    input:
        config['path']['annotation'],
        config['path']['genome'],
        config['path']['transcriptome']

# Adding rules to download the references files
include: "rules/downloads.smk"

# Adding rules init to prepare the fastq files
include: "rules/init.smk"

# Adding rules for the RNA-seq pipeline
include: "rules/rnaseq.smk"
