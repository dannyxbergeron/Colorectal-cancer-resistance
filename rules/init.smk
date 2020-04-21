from rules.init import inputLong

from functools import partial

rule change_names:
    """ Change the names to make it more easy to know who's who """
    input:
        long_id_files = partial(inputLong, config)
    output:
        simple_id_files = "data/reads/{id}_.bam"
    shell:
        "mv {input.long_id_files} {output.simple_id_files}"

rule sort_bam:
    """ Sort the bam file by query name as suggested by mugqic """
    input:
        bam_files = "data/reads/{id}_.bam"
    output:
        sorted_bam_files = temp("data/reads/{id}_sorted.bam")
    conda:
        "../envs/picard.yaml"
    shell:
        "picard SortSam VALIDATION_STRINGENCY=SILENT "
        "INPUT={input.bam_files} "
        "OUTPUT={output.sorted_bam_files} "
        "SORT_ORDER=queryname"

rule bam2FastQ:
    """ Convert the bam file to the original fastq format """
    input:
        sorted_bam_files = "data/reads/{id}_sorted.bam"
    output:
        fq1 = "data/reads/{id}_1.fastq",
        fq2 = "data/reads/{id}_2.fastq"
    conda:
        "../envs/picard.yaml"
    shell:
        "picard SamToFastq VALIDATION_STRINGENCY=SILENT "
        "INPUT={input.sorted_bam_files} "
        "FASTQ={output.fq1} "
        "SECOND_END_FASTQ={output.fq2}"
