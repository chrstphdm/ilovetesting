process TRIM {
    tag "$meta.id"
    label 'process_low'

    input:
    tuple val(meta), path(reads)

    output:
    tuple val(meta), path("*_trimmed.fastq"), emit: reads
    tuple val(meta), path("*_trim_report.txt"), emit: report

    script:
    def prefix   = meta.id
    def min_len  = params.min_length  ?: 20
    def min_qual = params.min_quality ?: 20
    """
    # Simulation trim : garde les reads dont la longueur de séquence >= min_len
    awk -v min_len=${min_len} '
        NR%4==1 { header=\$0 }
        NR%4==2 { seq=\$0 }
        NR%4==3 { plus=\$0 }
        NR%4==0 {
            if (length(seq) >= min_len) {
                print header; print seq; print plus; print \$0
            }
        }
    ' ${reads} > ${prefix}_trimmed.fastq

    kept=\$(awk 'NR%4==1' ${prefix}_trimmed.fastq | wc -l)
    total=\$(awk 'NR%4==1' ${reads} | wc -l)

    echo "input_reads\t\$total"         > ${prefix}_trim_report.txt
    echo "output_reads\t\$kept"        >> ${prefix}_trim_report.txt
    echo "min_length\t${min_len}"      >> ${prefix}_trim_report.txt
    echo "min_quality\t${min_qual}"    >> ${prefix}_trim_report.txt
    """
}
