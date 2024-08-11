#!/usr/bin/env bash

function bliss::parse() {
    #@ args
    local program="${*}"

    #@ locals
    local char
    local _atom

    # Padding parens
    program="${program//\(/' ( '}"
    program="${program//\)/' ) '}"

    # removing non printable chars and
    # spaces.
    while IFS='' read -r -d ' ' _atom;do
	[[ ! "${_atom}" =~ [[:print:]] ]] && continue
	echo "${_atom}"
    done <<< "${program}"
}

function bliss::stack() {
    #@ Args
    local -n tokens="${1}"

    #@ Locals
    declare -A _stack
    declare -i curr_level=0
    
    while read -r symbol;do
	echo "${symbol}"
    done < <(printf '%s\n' "${tokens[@]}")
    
}

function bliss::eval() {
    local token="${1}"
    local environment="${2}"

    # Lets check if is num: [1, 0.1, -1, ]
    [[ "${token}" ]] &&
}

function bliss::Env() {
    declare -A env_vars

    # Basic math
    env_vars['+']='bliss::bc::add'
    env_vars['-']='bliss::bc::sub'
    env_vars['/']='bliss::bc::div'
    env_vars['*']='bliss::bc::mult'
    env_vars['add']='bliss::bc::add'
    env_vars['sub']='bliss::bc::sub'
    env_vars['div']='bliss::bc::div'
    env_vars['mult']='bliss::bc::mult'    
    
}

function bliss::bc::add() {
    local a="${1}"
    local b="${2}"
    bc "${a} + ${b}"
}

function bliss::bc::sub() {
    local a="${1}"
    local b="${2}"
    bc "${a} - ${b}"
}

function bliss::bc::div() {
    local a="${1}"
    local b="${2}"
    bc "${a} / ${b}"
}

function bliss::bc::mult() {
    local a="${1}"
    local b="${2}"
    bc "${a} * ${b}"
}
