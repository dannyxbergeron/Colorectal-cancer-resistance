rule download_annotation:
    """ Downloads the gtf annotation from Ensembl FTP servers """
    output:
        gtf = config['path']['annotation']
    params:
        link = config['download']['annotation']
    shell:
        "wget --quiet -O {output.gtf}.gz {params.link} && "
        "gzip -d {output.gtf}.gz"

rule download_genome:
    """ Downloads the genome from Ensembl FTP servers """
    output:
        genome = config['path']['genome']
    params:
        link = config['download']['genome']
    shell:
        "wget --quiet -O {output.genome}.gz {params.link} && "
        "gzip -d {output.genome}.gz "

rule create_transcriptome:
    """ Uses gffread to generate a transcriptome """
    input:
        genome = config['path']['genome'],
        gtf = config['path']['annotation']
    output:
        seqs = config['path']['transcriptome']
    conda:
        "../envs/gffread.yaml"
    shell:
        "gffread {input.gtf} -g {input.genome} -w {output.seqs}"

rule generate_transcriptID_geneName:
    """
    Generating a two-column text file containing the gene -> transcript
    relationship
    """
    input:
        gtf = config['path']['annotation']
    output:
        map = config['path']['gene_name']
    conda:
        "../envs/python.yaml"
    script:
        "../scripts/generate_transcriptID_geneName.py"
