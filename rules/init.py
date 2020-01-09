def inputLong(config, wildcards):
    """ Input function used to get the initial long name of bam files """
    fname = config['TEST_datasets'][wildcards['id']]
    path = 'data/reads_test/{}.bam'.format(fname)
    return path
