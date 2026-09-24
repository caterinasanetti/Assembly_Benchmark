process SEQKIT_SUBSAMPLE {
    tag "${sample_id}_${depth}x"
    input:
    tuple val(sample_id), path(reads), val(depth), val(fraction)

    output:
    tuple val(sample_id), val(depth), path("${sample_id}_seqkit_${depth}x_{1,2}.fastq.gz")

    script:
    def (r1, r2) = reads
    """
    seqkit sample -p ${fraction} -s 100 ${r1} -o ${sample_id}_seqkit_${depth}x_1.fastq.gz
    seqkit sample -p ${fraction} -s 100 ${r2} -o ${sample_id}_seqkit_${depth}x_2.fastq.gz
    """
}