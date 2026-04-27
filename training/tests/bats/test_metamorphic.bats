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

@test "MR3 — composition : count(doubled) == count(original) + count(shuffled)" {
    # Relation métamorphique composite : on vérifie une RELATION entre trois exécutions
    # indépendantes de count_reads. Si MR1 garantit shuffled == original et MR2 garantit
    # doubled == 2×original, alors doubled == original + shuffled doit aussi tenir.
    # Un échec ici signale une incohérence entre les trois invariants, pas juste un crash.
    original=$(count_reads "$DATA/sample.fastq")
    shuffled=$(count_reads "$DATA/sample_shuffled.fastq")
    doubled=$(count_reads "$DATA/sample_doubled.fastq")
    [ "$doubled" -eq $(( original + shuffled )) ]
}
