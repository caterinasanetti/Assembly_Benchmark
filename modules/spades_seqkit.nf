process SPADES_ASSEMBLE_S {
    tag "${sample_id}_seqkit_${depth}x"
    input:
    tuple val(sample_id), val(depth), path(reads)

    output:
    tuple val(sample_id), val("seqkit_${depth}x"), path("${sample_id}_seqkit_${depth}x.fasta")

    script:
    def (r1, r2) = reads
    """
    spades.py -1 ${r1} -2 ${r2} -o spades_out --isolate -t ${task.cpus} -m ${task.memory.toGiga()}
    cp spades_out/contigs.fasta ${sample_id}_seqkit_${depth}x.fasta
    """
}