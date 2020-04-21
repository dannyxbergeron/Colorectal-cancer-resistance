

rule DESeq2:
    """ Differential expression for the different conditions """
    input:
        counts = rules.combine_gene_quantification.output.est_counts,
        samples = "data/references/design.tsv"
    output:
        results = directory("results/DESeq2")
    log:
        "logs/DESeq2.log"
    conda:
        "../envs/R.yaml"
    script:
        "../scripts/DESeq2.R" # normal DE
        # "../scripts/DESeq2_cell_line.R"  # cell line DE
