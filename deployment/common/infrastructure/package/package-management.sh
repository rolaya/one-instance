#!/bin/sh

#==================================================================================================================
# Check the required package is installed.
#==================================================================================================================
check_package_requirement()
{
  # Inform user we are checking for package
  echo_message $msg_style_section "Checking for package [$1]..."

  if ! [ -x "$(command -v $1)" ]; then
    echo "Error: $1 is not installed." >&2
    exit 1
  fi
}