#!/usr/bin/env bats

SCRIPT="${BATS_TEST_DIRNAME}/../../pipelines/minimal/scripts/validate_records.sh"
DATA="${BATS_TEST_DIRNAME}/../../data"

@test "fichier valide → exit 0 et 20 records" {
    run bash "$SCRIPT" "$DATA/records.tsv"
    [ "$status" -eq 0 ]
    [[ "$output" == *"OK"* ]]
    [[ "$output" == *"20 records"* ]]
}

@test "fichier vide (en-tête seul) → exit 1" {
    run bash "$SCRIPT" "$DATA/empty.tsv"
    [ "$status" -eq 1 ]
    [[ "$output" == *"empty"* ]]
}

@test "valeur non numérique → exit 1" {
    run bash "$SCRIPT" "$DATA/invalid_records.tsv"
    [ "$status" -eq 1 ]
}

@test "fichier inexistant → exit 1 et message" {
    run bash "$SCRIPT" "/tmp/does_not_exist_xyz.tsv"
    [ "$status" -eq 1 ]
    [[ "$output" == *"not found"* ]]
}

@test "aucun argument → exit 1 et usage" {
    run bash "$SCRIPT"
    [ "$status" -eq 1 ]
    [[ "$output" == *"usage"* ]]
}
