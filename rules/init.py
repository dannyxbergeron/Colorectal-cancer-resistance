def inputLong(config, wildcards):
    """ Input function used to get the initial long name of bam files """
    fname = config['datasets'][wildcards['id']]
    path = 'data/reads/{}.bam'.format(fname)
    return path
