#!/bin/sh

# Define text views
TEXT_VIEW_NORMAL_BLUE="\e[01;34m"
TEXT_VIEW_NORMAL_RED="\e[31m"
TEXT_VIEW_NORMAL_GREEN="\e[32m"
TEXT_VIEW_NORMAL_PURPLE="\e[177m"

TEXT_VIEW_NORMAL='\e[00m'

#==================================================================================================================
# Check the required package is installed.
#==================================================================================================================
check_package_requirement()
{
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

    echo "${TEXT_VIEW_NORMAL_BLUE}Installing package: [$1]...${TEXT_VIEW_NORMAL}"
    sudo apt-get install $1
    shift

  done
}


# php and wget must be installed
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
