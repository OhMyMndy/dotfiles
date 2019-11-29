#!/usr/bin/env bats

@test "test fail function" {
    run "$BATS_TEST_DIRNAME/../../installers/ubuntu.sh" --fail
     [ $status -eq 233 ]
     # echo $output
}
