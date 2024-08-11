#!/usr/bin/env bash

function logger() {
    local message="${*}"
    printf '%(%Y-%m-%dT%H:%M:%S%z)T | %s\n' \
	    -1 \
	    "${message}"
}

function get_spacer() {
    #@ Args
    local char="${1}"
    local n="${2}"

    #@ Locals 
    local spacer=''
    
    for ((i=1; i <= "${n}"; i++)); do
	spacer+="${char}"
    done
    
    echo "${spacer}"
}

function test_executor() {
    #@ Args
    local test_name="${1}"

    #@ Locals
    declare -i test_return_code

    logger "TEST (${test_name}): starting ..."
    ("${test_name}")
    logger "TEST (${test_name}): ended with code >>> ${?} <<<."
}

####### Tests
function test::pass::parser() {
    return 0
}

function test::error::parser() {
    return 1
}

######

function main() {
    declare -a capture_tests
    local function_name
    local spacer=$(get_spacer '=' 100)

    # Collect tests
    while IFS=' ' read -r _ _ function_name ;do
	[[ ! "${function_name}" == test::* ]] && continue
	capture_tests+=( "${function_name}" )
    done < <(declare -F)

    for test_case in "${capture_tests}";do
	test_executor "${test_case}"
    done
}

[[ "${BASH_SOURCE[0]}" == "${0}" ]] && main
