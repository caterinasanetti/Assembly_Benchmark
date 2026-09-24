process QUAST_COMPARE {
    tag "$sample_id"
    publishDir { "${params.output_dir}/quast/${sample_id}" }, mode: 'copy'

    input:
    tuple val(sample_id), val(labels), path(fastas)
    path reference

    output:
    tuple val(sample_id), path("${sample_id}_quast/report.tsv")

    script:
    def label_str = labels.join(',')
    """
    quast.py \\
        ${fastas.join(' ')} \\
        -R ${reference} \\
        -l ${label_str} \\
        -o ${sample_id}_quast \\
        -t ${task.cpus}
    """
}