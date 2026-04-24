include { FASTQC } from '../modules/fastqc'
include { TRIM   } from '../modules/trim'

workflow QC_TRIM {
    take:
    reads  // channel: [ val(meta), path(fastq) ]

    main:
    FASTQC(reads)
    TRIM(reads)

    emit:
    html   = FASTQC.out.html
    stats  = FASTQC.out.stats
    reads  = TRIM.out.reads
    report = TRIM.out.report
}
