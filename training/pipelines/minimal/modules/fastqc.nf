process FASTQC {
    tag "$meta.id"
    label 'process_low'

    input:
    tuple val(meta), path(reads)

    output:
    tuple val(meta), path("*.html"), emit: html
    tuple val(meta), path("*.txt"),  emit: stats

    script:
    def prefix = meta.id
    """
    # Simulation FastQC : compte les reads et génère un rapport HTML minimal
    total_reads=\$(awk 'NR%4==1' ${reads} | wc -l)

    [ "\$total_reads" -gt 0 ] || { echo "ERROR: empty FASTQ"; exit 1; }

    cat > ${prefix}_fastqc.html << HTMLEOF
    <html><body>
    <h1>FastQC Report — ${prefix}</h1>
    <p>Total reads: \$total_reads</p>
    <p>Status: PASS</p>
    </body></html>
    HTMLEOF

    echo "total_reads\t\$total_reads" > ${prefix}_fastqc_stats.txt
    echo "file\t${reads}"            >> ${prefix}_fastqc_stats.txt
    """
}
