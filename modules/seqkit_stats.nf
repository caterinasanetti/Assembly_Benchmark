process SEQKIT_STATS {
    tag "$sample_id"
    input:
    tuple val(sample_id), path(reads)

    output:
    tuple val(sample_id), path(reads), path("${sample_id}.total_bases.txt")

    script:
    """
    seqkit stats -T ${reads.join(' ')} > ${sample_id}.stats.tsv
    awk 'NR>1{sum+=\$5} END{print sum}' ${sample_id}.stats.tsv > ${sample_id}.total_bases.txt
    """
}