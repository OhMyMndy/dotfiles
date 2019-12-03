#!/usr/bin/env bats

@test "test fail function" {
    [ -f "$BATS_TEST_DIRNAME/../../installers/ubuntu.sh" ]
    run "$BATS_TEST_DIRNAME/../../installers/ubuntu.sh" --fail
    # echo $output
    [ $status -eq 233 ]
}
