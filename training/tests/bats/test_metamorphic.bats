#!/usr/bin/env bats

DATA="${BATS_TEST_DIRNAME}/../../data"

count_reads() {
    awk 'NR%4==1' "$1" | wc -l
}

@test "MR1 — permutation : reads réordonnés → même nombre de reads" {
    original=$(count_reads "$DATA/sample.fastq")
    shuffled=$(count_reads "$DATA/sample_shuffled.fastq")
    [ "$original" -eq "$shuffled" ]
}

@test "MR2 — duplication : 2× l'input → exactement 2× les reads" {
    original=$(count_reads "$DATA/sample.fastq")
    doubled=$(count_reads "$DATA/sample_doubled.fastq")
    [ "$doubled" -eq $(( original * 2 )) ]
}

@test "MR3 — sous-ensemble : validate_fastq valide original ET shuffled" {
    SCRIPT="${BATS_TEST_DIRNAME}/../../pipelines/minimal/scripts/validate_fastq.sh"
    run bash "$SCRIPT" "$DATA/sample.fastq"
    [ "$status" -eq 0 ]
    run bash "$SCRIPT" "$DATA/sample_shuffled.fastq"
    [ "$status" -eq 0 ]
}
