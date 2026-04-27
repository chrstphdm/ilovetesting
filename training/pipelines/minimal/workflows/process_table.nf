include { COUNT_LINES } from '../modules/count_lines'
include { SUMMARISE   } from '../modules/summarise'

workflow PROCESS_TABLE {
    take:
    table  // channel: [ val(meta), path(tsv) ]

    main:
    COUNT_LINES(table)
    SUMMARISE(table)

    emit:
    count   = COUNT_LINES.out.count
    summary = COUNT_LINES.out.summary
    stats   = SUMMARISE.out.stats
}
