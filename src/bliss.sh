#!/usr/bin/env bash

# set -euo pipefail

function bliss::parse() {
    #@ args
    local program="${*}"

    #@ locals
    local char
    local _atom

    # # Lets adding an extra enclosing parens
    # # to allow evaluation without parens
    # program="(${program})"
    
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


function bliss::add() {
    local a="${1}"; shift
    local b="${1}"; shift

    echo "$(( a + b ))"
}

function bliss::map() {
    #@ args
    local callable="${1}"; shift

    #@ locals
    local _item

    for _item in "${@}";do
	# TODO (Hugo Ávila): I don't like this eval implementation
	# It allows some ugly arbritary code execution. Meybe add
	# a type check or something here.
	eval "${callable}"  "${_item}"
    done
}

function bliss::get_base_context() {
    #@ args
    local -n array_ref="${1}"; shift

    # Add primitive function here 
    array_ref['add']='bliss::add'
    array_ref['+']='bliss::add'

    
}

function bliss::eval() {
    local token="${1}"
    local environment="${2}"
}

function bliss::zip() {
    #@ locals
    local _refs
    declare -a row
    declare -i length

    # Here we are looping every ref name
    # and creating a inside ref so zip
    # will work for any size of arrays not only two.
    for _refs in "${@}";do
	local -n "in_${_refs}=${_refs}"
    done

    eval length='${#in_'"${1}"'[@]}'

    for ((i=0; i<"${length}"; i++));do
	row=()
	for _refs in "${@}";do
	    eval row+=('"${in_'"${_refs}"'['"${i}"']}"')
	done
	echo "${row[@]}"
    done
}

function bliss::enumerate() {
    #@ Args
    declare -r -n _ref="${1}"; shift
    declare -r -i start_from="${1:-0}"; shift

    #@ locals
    for ((i=start_from; i<"${#_ref[@]}"; i++));do
	echo "${i}" "${_ref[${i}]}"
    done
    
}

declare -A stack
# program=($(bliss::parse '(+ 1 2 (- 2 1) (+ 1 1))'))
program=($(bliss::parse '(+ 1 2 (- 2 1 ()) (+ 1 1))'))

printf '%s\n' "${parens_loc[@]}"

declare -i curr_level=0

# for ((i=0; i<"${#program[@]}"; i++));do
#     char="${program[$i]}"
    
#     [[ "${char}" == '(' ]] && {
# 	echo "${curr_level}" "${char}" oi
# 	curr_level=$((curr_level + 1))
#     }

#     [[ "${char}" == ')' ]] && {
# 	curr_level=$((curr_level - 1))
# 	echo "${curr_level}" "${char}"
#     }
# done

