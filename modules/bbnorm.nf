process BBNORM {
    tag "${sample_id}_${depth}x"
    input:
    tuple val(sample_id), path(reads), val(depth)

    output:
    tuple val(sample_id), val(depth), path("${sample_id}_bbnorm_${depth}x_{1,2}.fastq.gz")

    script:
    def (r1, r2) = reads
    """
    bbnorm.sh \\
        in=${r1} in2=${r2} \\
        out=${sample_id}_bbnorm_${depth}x_1.fastq.gz \\
        out2=${sample_id}_bbnorm_${depth}x_2.fastq.gz \\
        target=${depth} mindepth=2 \\
        threads=${task.cpus}
    """
}