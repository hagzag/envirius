#!/usr/bin/env bats

load test_helper

@test "common: get_cmd_name" {
    run get_cmd_name
    assert_success
    assert_output "nv"
}

@test "common: bold" {
    run bold "test-string"
    assert_success
    assert_output "`tput bold`test-string`tput sgr0`"
}

@test "common: show_usage" {
    run show_usage "test_cmd"
    assert_success
    assert_output "`bold 'Usage'`: `get_cmd_name` test_cmd"

    SUBCOMMAND="test_cmd" run show_usage "--help"
    assert_success
    assert_output "`bold 'Usage'`: `get_cmd_name` test_cmd --help"
}

@test "common: show_desc" {
    run show_desc "testing with bats"
    assert_success
    assert_output "`bold 'Description'`: testing with bats"
}

@test "common: lpad" {
    run lpad "cmd" 5
    assert_success
    assert_output "  cmd"

    run lpad "cmd" 5 "+"
    assert_success
    assert_output "++cmd"
}

@test "common: rpad" {
    run rpad "cmd" 5
    assert_success
    assert_output "cmd  "

    run rpad "cmd" 5 "+"
    assert_success
    assert_output "cmd++"
}

@test "common: get_plugin_name" {
    run get_plugin_name "--rust=0.9"
    assert_success
    assert_output "rust"

    run get_plugin_name "--go=1.2rc4"
    assert_success
    assert_output "go"

    run get_plugin_name "--erlang=17.0-rc1"
    assert_success
    assert_output "erlang"
}

@test "common: get_plugin_version" {
    run get_plugin_version "--rust=0.9"
    assert_success
    assert_output "0.9"

    run get_plugin_version "--go=1.2rc4"
    assert_success
    assert_output "1.2rc4"

    run get_plugin_version "--erlang=17.0-rc1"
    assert_success
    assert_output "17.0-rc1"
}

@test "common: filename" {
    run filename "/some/path/to/file.txt"
    assert_success
    assert_output "file.txt"
}

@test "common: get_cpu_count" {
    run get_cpu_count
    assert_success
    assert_output "`nproc`"
}

@test "common: get_time_diff" {
    local start_dt=$(get_time)
    local timeout=2
    sleep $timeout
    run get_time_diff $start_dt
    assert_success
    assert_output "$timeout"
}

@test "common: get_env_full_path" {
    # see setup in "test_helper.bash"
    local TEST_HOME="$HOME/tmp/envirius-tests/envs"

    run get_env_full_path
    assert_success
    assert_output "$TEST_HOME"

    run get_env_full_path "test-env"
    assert_success
    assert_output "$TEST_HOME/test-env"
}

@test "common: get_plugin_full_path" {
    # see setup in "test_helper.bash"
    local TEST_PATH="$BATS_TEST_DIRNAME/../src/nv-plugins"

    run get_plugin_full_path
    assert_success
    assert_output "$TEST_PATH"

    run get_plugin_full_path "test-plugin"
    assert_success
    assert_output "$TEST_PATH/test-plugin"
}

@test "common: get_command_full_path" {
    # see setup in "test_helper.bash"
    local TEST_PATH="$BATS_TEST_DIRNAME/../src/nv-commands"

    run get_command_full_path
    assert_success
    assert_output "$TEST_PATH"

    run get_command_full_path "test-command"
    assert_success
    assert_output "$TEST_PATH/test-command"
}

@test "common: get_cache_full_path" {
    # see setup in "test_helper.bash"
    local TEST_HOME="$HOME/tmp/envirius-tests/cache"

    run get_cache_full_path
    assert_success
    assert_output "$TEST_HOME"

    run get_cache_full_path "test-cache-entry"
    assert_success
    assert_output "$TEST_HOME/test-cache-entry"
}

@test "common: get_first_non_opt_value" {
    run get_first_non_opt_value "--opt1=v1" "name" "--opt2=v3"
    assert_success
    assert_output "name"

    run get_first_non_opt_value "name" "name2"
    assert_success
    assert_output "name"

    run get_first_non_opt_value "--opt1=v1"
    assert_success
    assert_output ""
}

@test "common: filename" {
    run filename "http://www.haskell.org/ghc/dist/7.6.3/ghc-7.6.3-src.tar.bz2"
    assert_success
    assert_output "ghc-7.6.3-src.tar.bz2"
}

@test "common: nv_get_filename_ext" {
    run nv_get_filename_ext "ghc-7.6.3-src.tar.bz2"
    assert_success
    assert_output "tar.bz2"
}

@test "common: nv_get_system_arch" {
    run nv_get_system_arch "32bit" "64bit"
    assert_success
    if [ "`uname -m`" = "i686" ]; then
        assert_output "32bit"
    else
        assert_output "64bit"
    fi
}

@test "common: nv_get_build_path" {
    run nv_get_build_path "new-plugin" "version1"
    assert_success
    assert_output "`get_cache_full_path "new-plugin-version1-build"`"
}
