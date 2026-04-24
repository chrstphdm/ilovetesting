#!/usr/bin/env bats

SCRIPT="${BATS_TEST_DIRNAME}/../../pipelines/minimal/scripts/validate_fastq.sh"
DATA="${BATS_TEST_DIRNAME}/../../data"

@test "fichier valide → exit 0" {
    run bash "$SCRIPT" "$DATA/sample.fastq"
    [ "$status" -eq 0 ]
    [[ "$output" == *"OK"* ]]
    [[ "$output" == *"100 reads"* ]]
}

@test "fichier vide → exit 1" {
    run bash "$SCRIPT" "$DATA/empty.fastq"
    [ "$status" -eq 1 ]
    [[ "$output" == *"empty"* ]]
}

@test "format invalide → exit 2" {
    run bash "$SCRIPT" "$DATA/bad.fastq"
    [ "$status" -eq 2 ]
    [[ "$output" == *"not a valid FASTQ"* ]]
}

@test "fichier inexistant → exit 1" {
    run bash "$SCRIPT" "/tmp/does_not_exist_xyz.fastq"
    [ "$status" -eq 1 ]
    [[ "$output" == *"not found"* ]]
}

@test "aucun argument → exit 1" {
    run bash "$SCRIPT"
    [ "$status" -eq 1 ]
    [[ "$output" == *"usage"* ]]
}
