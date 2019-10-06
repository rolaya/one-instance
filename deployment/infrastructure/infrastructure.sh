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

#==================================================================================================================
# Install package(s).
#==================================================================================================================
install_package()
{
  # Check all parameters passed in command line (if any)
  while [ -n "$1" ]; do

    echo_message $msg_style_info "Installing package: [$1]..."
    sudo apt-get install $1
    shift

  done
}

