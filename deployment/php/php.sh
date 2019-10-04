#!/bin/sh

#==================================================================================================================
# 
#==================================================================================================================
php_get_status()
{
  local var_reference_php_installed=$1
  local var_reference_php_version=$2

  # Default to PHP not installed (and therefore inactive)
  eval $var_reference_php_installed=false
  eval $var_reference_php_version=""

  # Format command.
  COMMAND="sudo which php"

  echo_message $msg_style_section "Detecting PHP via: [$COMMAND]..."

  # Run mariadb status command
  COMMAND_OUTPUT=$(eval $COMMAND)

  # PHP is installed if we get any response (i.e. it would be a path the executable, something like "/usr/bin/php")
  COMMAND_OUTPUT_LENGTH=${#COMMAND_OUTPUT}

  # PHP installed?
  if [ $COMMAND_OUTPUT_LENGTH -eq 0 ]; then  
    eval $var_reference_php_installed=false
  else

    # PHP is installed
    eval $var_reference_php_installed=true

    # Get PHP version (full string)
    exec_command "Acquiring PHP version via" "sudo $COMMAND_OUTPUT -v" COMMAND_OUTPUT

    # Extract the version number (e.g. "7.2.22")
    COMMAND_OUTPUT=$(echo $COMMAND_OUTPUT | perl -pe '($_)=/([0-9]+([.][0-9]+)+)/')

    # Pass PHP version to the caller
    eval $var_reference_php_version=$COMMAND_OUTPUT
  fi
}

#==================================================================================================================
# 
#==================================================================================================================
php_install()
{
  # wget must be installed
  check_package_requirement "wget"

  # Installs:
  # ca-certificates: Certificate authorities (used for SSL connections authentication)
  # apt-transport-https: Enables the usage of 'deb https://foo distro main' lines
  # lsb-release: Linux Standard Base
  install_package ca-certificates apt-transport-https lsb-release

  # Get the GNU Privacy Guard key (from https://packages.sury.org/php) and
  # save it as /etc/apt/trusted.gpg.d/php.gpg
  sudo wget -O /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg

  # Create file /etc/apt/sources.list.d/php7.3.list with something like "deb https://packages.sury.org/php/ stretch main".
  # The apt applicaiton will use this source to provide php 7.3 packages, etc.
  sudo echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" | sudo tee /etc/apt/sources.list.d/php7.3.list

  # Fetch the package list from the new source
  sudo apt update

  # Install main php7.3 and common extensions (and extensions required for drupal/contenta).
  install_package php7.3 php7.3-cli php7.3-common php7.3-opcache php7.3-curl php7.3-mbstring php7.3-mysql php7.3-zip php7.3-xml php7.3-gd
}
