#!/usr/bin/env bats

@test "test themes" {
    run  "$BATS_TEST_DIRNAME/../../installers/ubuntu.sh" --themes
}
