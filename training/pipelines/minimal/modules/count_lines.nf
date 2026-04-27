process COUNT_LINES {
    tag "$meta.id"
    label 'process_low'

    input:
    tuple val(meta), path(tsv)

    output:
    tuple val(meta), path("*.count"),       emit: count
    tuple val(meta), path("*.summary.txt"), emit: summary

    script:
    def prefix = meta.id
    """
    # Count data rows (excluding header)
    total=\$(tail -n +2 ${tsv} | wc -l)

    [ "\$total" -gt 0 ] || { echo "ERROR: no data rows in ${tsv}"; exit 1; }

    echo "\$total" > ${prefix}.count

    printf "file\\t${tsv}\\nrows\\t\$total\\n" > ${prefix}.summary.txt
    """
}
