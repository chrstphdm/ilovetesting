process SUMMARISE {
    tag "$meta.id"
    label 'process_low'

    input:
    tuple val(meta), path(tsv)

    output:
    tuple val(meta), path("*.stats.tsv"), emit: stats

    script:
    def prefix = meta.id
    """
    # Compute mean and row count per group (column 2, value in column 3)
    printf "group\\tmean\\tn\\n" > ${prefix}.stats.tsv
    awk -F'\\t' '
        NR > 1 { sum[\$2] += \$3; cnt[\$2]++ }
        END { for (g in sum) print g "\\t" sum[g]/cnt[g] "\\t" cnt[g] }
    ' ${tsv} | sort >> ${prefix}.stats.tsv
    """
}
