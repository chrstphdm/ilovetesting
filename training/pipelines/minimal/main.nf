#!/usr/bin/env nextflow
nextflow.enable.dsl=2

include { PROCESS_TABLE } from './workflows/process_table'

workflow {
    table = Channel
        .fromPath(params.input)
        .map { f -> [[id: f.simpleName], f] }

    PROCESS_TABLE(table)
}
