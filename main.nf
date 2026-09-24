nextflow.enable.dsl = 2

include { ASSEMBLY_BENCHMARK } from './subworkflows/assembly_benchmark'

workflow {
    reads_pattern = params.reads ?: "${params.input_dir}/${params.read_pattern}"
    reads_ch = channel.fromFilePairs(reads_pattern, checkIfExists: true)

    ASSEMBLY_BENCHMARK(reads_ch)
}