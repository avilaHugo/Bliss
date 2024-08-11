#!/usr/bin/env bash

function logger() {
    local message="${*}"
    printf '%(%Y-%m-%dT%H:%M:%S%z)T | %s\n' \
	    -1 \
	    "${message}"
}

function flag_test_pass_or_fail() {
    #@ Locals 
    declare -I test_name
    declare -I test_return_code
    local passed_massage="PASSED: ${test_name}"
    local failed_massage="FAILED: ${test_name}"

    [[ "${test_name}" == *\:\:pass\:\:* ]] \
	&& [[ "${test_return_code}" -eq 0 ]] \
	&& { echo "${passed_massage}"; return 0; }

    [[ "${test_name}" == *\:\:fail\:\:* ]] \
	&& [[ ! "${test_return_code}" -eq 0 ]] \
	&& { echo "${passed_massage}"; return 0; }

    echo "${failed_massage}"
    return 1
}

function test_executor() {
    #@ Args
    local test_name="${1}"
    local test_code

    #@ Locals
    declare -i test_return_code=$("${test_name}"; echo "${?}")

    flag_test_pass_or_fail
}

####### Tests
function test::pass::pass() {
    return 0
}

function test::fail::pass() {
    return 1
}

######

function main() {
    #@ locals 
    declare -a capture_tests
    local spacer=$(spacer=''; for _ in {1..100}; do spacer+='='; done; echo "${spacer}")
    declare -i all_return_codes

    #@ loop
    local function_name
    local test_case

    # Collect tests
    while IFS=' ' read -r _ _ function_name ;do
	[[ ! "${function_name}" == test::* ]] && continue
	capture_tests+=( "${function_name}" )
    done < <(declare -F)

    echo "${spacer}"
    for test_case in "${capture_tests[@]}";do
	test_executor "${test_case}"
	all_return_codes+=${?}
    done 
    echo "${spacer}"

    (( all_return_codes > 0 )) && {
	logger 'No BUENO, some tests failed :('
	return 1
    }

    logger 'All cool bro all test passed !'
    return 0
}

[[ "${BASH_SOURCE[0]}" == "${0}" ]] && main
