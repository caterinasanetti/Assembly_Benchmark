process MEGAHIT_ASSEMBLE {
    tag "$sample_id"
    input:
    tuple val(sample_id), path(reads)

    output:
    tuple val(sample_id), val("megahit"), path("${sample_id}_megahit.fasta")

    script:
    def (r1, r2) = reads
    """
    megahit -1 ${r1} -2 ${r2} -o megahit_out -t ${task.cpus}
    cp megahit_out/final.contigs.fa ${sample_id}_megahit.fasta
    """
}