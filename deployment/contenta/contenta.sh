#!/bin/sh

#==================================================================================================================
#
#==================================================================================================================
contenta_install()
{
  # This is the root directory of the contenta deployment
  local site=$1

  # The contenta composer install command (uses information written to .env, .env.local configuration files)
  local command="composer run-script install:with-mysql"

  # Save current working directory
  CWD=$PWD

  # Change directory to site root directory (where contenta was downloaded)
  cd $site

  # Install contenta (via composer)
  echo_message $msg_level_info $msg_style_section "Installing contenta with: [$command]..."
  eval $command
}
