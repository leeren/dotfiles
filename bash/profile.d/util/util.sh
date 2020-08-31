#!/bin/bash
#
# Utility functions for more convenient script processing.

UTIL_DIR="${UTIL_DIR:-${HOME}/profile.d/util}"

# shellcheck source=./profile.d/util/log.sh
. "$UTIL_DIR/log.sh"  || { echo "Source $UTIL_PATH failed!" >&2; exit 1; }

# Checks whether a program exists and is executable.
function util::binary_exists() {
  command -v "$1" &>/dev/null
}

################################################################################
# Joins a list of strings by a specified delimiter.
# @param {string} delim The delimiter to join the string list with.
# @param {list} joined A list of 1+ strings to join together.
################################################################################
function util::join_args() {
	if (( $# < 2 )); then
		 util::exit "A delimiter and join argument list must be provided."
	fi

	local delim="${1}"
	shift
	if (( $# == 0 )); then
		return
	fi

	local joined=""
	local first=1
	for e in "$@"; do
		if (( first )); then
			first=0
			joined+="${e}"
		else
			joined+="${delim}${e}"
		fi
	done
	echo "${joined}"
}
