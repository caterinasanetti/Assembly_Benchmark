include { SEQKIT_STATS } from '../modules/seqkit_stats'
include { SEQKIT_SUBSAMPLE } from '../modules/seqkit_subsample'
include { SPADES_ASSEMBLE_S } from '../modules/spades_seqkit'
include { BBNORM } from '../modules/bbnorm'
include { SPADES_ASSEMBLE_B } from '../modules/spades_bbnorm'
include { MEGAHIT_ASSEMBLE } from '../modules/megahit'
include { SHOVILL_ASSEMBLE } from '../modules/shovill'
include { QUAST_COMPARE } from '../modules/quast'

workflow ASSEMBLY_BENCHMARK {

    take:
    reads_ch 

    main:

    stats_ch = SEQKIT_STATS(reads_ch)

    depths_ch = Channel.from(params.depths)
    depths_shovill_ch = Channel.from(params.depths_shovill)

    fraction_ch = stats_ch
        .combine(depths_ch)
        .map { sample_id, reads, bases_file, depth ->
            def total_bases = bases_file.text.trim().toLong()
            def fraction = Math.min(1.0d, (depth.toDouble() * params.genome_size) / total_bases)
            tuple(sample_id, reads, depth, fraction)
        }

    seqkit_reads_ch  = SEQKIT_SUBSAMPLE(fraction_ch)
    seqkit_spades_ch = SPADES_ASSEMBLE_S(seqkit_reads_ch)

    bbnorm_input_ch = reads_ch
        .combine(depths_ch)
        .map { sample_id, reads, depth -> tuple(sample_id, reads, depth) }
    bbnorm_reads_ch  = BBNORM(bbnorm_input_ch)
    bbnorm_spades_ch = SPADES_ASSEMBLE_B(bbnorm_reads_ch)

    megahit_ch = MEGAHIT_ASSEMBLE(reads_ch)

    shovill_input_ch = reads_ch
        .combine(depths_shovill_ch)
        .map { sample_id, reads, depth -> tuple(sample_id, reads, depth) }
    shovill_ch = SHOVILL_ASSEMBLE(shovill_input_ch)

    all_assemblies_ch = seqkit_spades_ch
        .mix(bbnorm_spades_ch, megahit_ch, shovill_ch)
        .groupTuple()                       // -> (sample_id, [labels], [fastas])
        .map { sample_id, labels, fastas -> tuple(sample_id, labels, fastas) }

    quast_ch = QUAST_COMPARE(all_assemblies_ch, Channel.fromPath(params.reference_genome))

    emit:
    seqkit_assemblies  = seqkit_spades_ch
    bbnorm_assemblies  = bbnorm_spades_ch
    megahit_assemblies = megahit_ch
    shovill_assemblies = shovill_ch
    quast_reports      = quast_ch
}
