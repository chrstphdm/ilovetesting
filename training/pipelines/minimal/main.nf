#!/usr/bin/env nextflow
nextflow.enable.dsl=2

include { QC_TRIM } from './workflows/qc_trim'

workflow {
    reads = Channel
        .fromPath(params.input)
        .map { f -> [[id: f.simpleName, single_end: true], f] }

    QC_TRIM(reads)
}
