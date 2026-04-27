#!/usr/bin/env bats
# Tests for the FastQC Apptainer container.
#
# These tests run LOCALLY or on HPC — they require Apptainer and the .sif image.
# They are NOT executed automatically in CI (see .github/workflows/container-tests.yml
# for the optional manual workflow_dispatch job).
#
# Prerequisites:
#   apptainer pull containers/fastqc_0.12.1.sif \
#     docker://biocontainers/fastqc:0.12.1--hdfd78af_0
#
# Run:
#   bats training/exercises/06_testing_containers/tests/container_fastqc.bats

CONTAINER_DIR="${BATS_TEST_DIRNAME}/../containers"
IMAGE="${CONTAINER_DIR}/fastqc_0.12.1.sif"
EXPECTED_VERSION="FastQC v0.12.1"

# ---------------------------------------------------------------------------
# Helper: skip if the SIF file is not present
# ---------------------------------------------------------------------------
require_image() {
    if [ ! -f "${IMAGE}" ]; then
        skip "SIF not found at ${IMAGE}. Pull with: apptainer pull ${IMAGE} docker://biocontainers/fastqc:0.12.1--hdfd78af_0"
    fi
}

# ---------------------------------------------------------------------------
# Tests
# ---------------------------------------------------------------------------

@test "SIF image file exists" {
    if [ ! -f "${IMAGE}" ]; then
        skip "SIF not found — run: apptainer pull ${IMAGE} docker://biocontainers/fastqc:0.12.1--hdfd78af_0"
    fi
    [ -f "${IMAGE}" ]
}

@test "fastqc --version exits cleanly and reports expected version" {
    require_image
    run apptainer exec "${IMAGE}" fastqc --version
    [ "$status" -eq 0 ]
    [[ "$output" =~ "${EXPECTED_VERSION}" ]]
}

@test "which fastqc returns a path inside /usr or /opt" {
    require_image
    run apptainer exec "${IMAGE}" which fastqc
    [ "$status" -eq 0 ]
    [[ "$output" == /usr/* || "$output" == /opt/* ]]
}

@test "fastqc is accessible without mounting /home (--no-home flag)" {
    require_image
    # Verifies the tool does not depend on home directory state.
    run apptainer exec --no-home "${IMAGE}" fastqc --version
    [ "$status" -eq 0 ]
    [[ "$output" =~ "${EXPECTED_VERSION}" ]]
}

@test "container is writable only in expected locations" {
    require_image
    # The container root filesystem must be read-only.
    # Writing to /tmp (auto-mounted) must work; writing to /usr must fail.
    run apptainer exec "${IMAGE}" bash -c "echo test > /tmp/writable_test && echo OK"
    [ "$status" -eq 0 ]
    [[ "$output" == "OK" ]]

    run apptainer exec "${IMAGE}" bash -c "echo test > /usr/bin/forbidden 2>&1; echo exit:$?"
    [[ "$output" == *"Read-only"* || "$output" == *"exit:1"* || "$output" == *"Permission denied"* ]]
}

@test "apptainer exec fails clearly if image is missing" {
    run apptainer exec "/tmp/does_not_exist_xyz.sif" fastqc --version 2>&1
    [ "$status" -ne 0 ]
    [[ "$output" =~ "does_not_exist_xyz.sif" ]]
}
