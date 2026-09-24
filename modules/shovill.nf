process SHOVILL_ASSEMBLE {
    tag "${sample_id}_shovill_${depth == 0 ? 'raw' : depth + 'x'}"
    input:
    tuple val(sample_id), path(reads), val(depth)

    output:
    tuple val(sample_id), val("shovill_${label}"), path("shovill_${label}.fasta")

    script:
    label = (depth == 0) ? 'raw' : "${depth}x"
    """
    shovill \\
        --R1 ${reads[0]} --R2 ${reads[1]} \\
        --gsize ${params.genome_size} \\
        --depth ${depth} \\
        --cpus ${task.cpus} \\
        --outdir shovill_out
    cp shovill_out/contigs.fa shovill_${label}.fasta
    """
}