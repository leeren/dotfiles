#!/bin/bash
#
# Utility module for comprehensive logging support.

# Logs a message of type INFO and returns a zero exit code.
function util::info() {
  util::log INFO "${1}"
}

# Logs a message of type WARNING and returns a non-zero exit code.
function util::warn() {
  util::log WARNING "${1}"
}

# Logs a message of type ERROR and returns a non-zero exit code.
function util::error() {
  util::log ERROR "${1}"
}

# Logs a message of type FATAL and aborts the program with a stack trace.
function util::fatal() {
  util::log FATAL "${1}" 1
}

# Logs a message of type FATAL and aborts the program without a stack trace.
function util::exit() {
  util::log FATAL "${1}"
}

################################################################################
# Logs a message to stderr.
# @param {string} severity Log severity level (INFO / WARNING / ERROR / FATAL).
# @optparam {string} message The log message to be printed.
# @optparam {int} trace Whether or not to include a stack trace (0 / 1).
# @print a log message contextualized based on severity.
################################################################################
function util::log() {
  local -i exit_code=$?
  local severity="${1}"
  local message="${2}"
  local -i trace=${3:-0}

  local prefix timestamp trace_msg

  # TODO: # For bash >= 4.2, printf is preferred for efficiency reasons.
  # printf -v timestamp '%(%Y-%m-%d %H:%M:%S)T' -1
  timestamp=$(date +"%T")

  case "${severity}" in
    INFO)  prefix="INFO"  ;;
    WARNING)  prefix="WARNING"  ;;
    ERROR)   prefix="ERROR"   ;;
    FATAL) prefix="FATAL" ;;
  esac

  if (( trace == 1 )); then
    local -a frame
    local IFS='	 ' # Split on tab and space chars to interpret frame as array.

    read -r -a frame <<< "$(caller 0)"
    local line="${frame[0]}"
    local func="${frame[1]}"
    local filepath="${frame[2]}"
    local filename="${filepath##*/}"

    trace_msg="${filename}:${func}:${line}:"
  fi

  echo >&2 "(${prefix}) [${timestamp}]${trace_msg} ${message}"

  # Except for INFO, all severity levels should return a non-zero exit code.
  if (( exit_code <= 0 )) && [[ "${severity}" != "INFO" ]]; then
    exit_code=1
  fi

  # For FATAL messages, we abort the program.
  if [[ "${severity}" == "FATAL" ]]; then
    exit ${exit_code}
  fi

  return ${exit_code}
}
