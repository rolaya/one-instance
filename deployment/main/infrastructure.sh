#!/bin/sh

#==================================================================================================================
#
#==================================================================================================================
check_package_apache2()
{
  local apache_installed=false
  local apache_active=false
  
  echo_message $msg_style_info "Checking Apache2 status..."

  # Check apache status
  apache_get_status apache_installed apache_active

  echo_message $msg_style_info "Apache2 installed: [$apache_installed] active: [$apache_active]"

  # Apache2 not installed?
  if [ $apache_installed = false ]; then

    # Format apache install command
    COMMAND="sudo apt-get install apache2"
    
    echo_message $msg_style_info "Installing apache2 via: [$COMMAND], please wait..."
  
    # Run command
    COMMAND_OUTPUT=$(eval $COMMAND)

    #echo $COMMAND_OUTPUT
  fi
}

#==================================================================================================================
#
#==================================================================================================================
check_package_mariadb()
{
  local mariadb_installed=false
  local mariadb_active=false
  
  echo_message $msg_style_info "Checking MariaDB status..."

   # Check mariadb status
  mariadb_get_status mariadb_installed mariadb_active

  echo_message $msg_style_info "MariaDB installed: [$mariadb_installed] active: [$mariadb_active]" 

  if [ $mariadb_installed = false ]; then
    
    # Install and secure mariadb
    mariadb_install_and_secure
  fi 
}

#==================================================================================================================
#
#==================================================================================================================
check_package_php()
{
  local php_installed=false
  local php_active=false
  
  echo_message $msg_style_info "Checking PHP status..."
}

#==================================================================================================================
#
#==================================================================================================================
check_required_packages()
{
  check_package_apache2
  check_package_mariadb
  check_package_php
}
