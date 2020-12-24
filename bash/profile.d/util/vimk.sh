#!/bin/bash
#
# External commands are not executed in an interactive
# shell in Vim hence reliance on shell scripts are needed.
#
# This command queries for a search term.
open "https://golang.org/search?q=$1"
