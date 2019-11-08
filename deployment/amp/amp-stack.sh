#!/bin/sh

#==================================================================================================================
# Install AMP (Apache2, MariaDB, PHP) stack. 
#==================================================================================================================
install_amp_stack()
{
   # Init debug configuration
  init_debug_configuration GlobalDebugConfig

  if [ $(($GlobalDebugConfig & $gmask_debug_debug)) -eq $(( $gmask_debug_debug )) ]; then
    echo "GlobalDebugConfig $GlobalDebugConfig"
  fi

  # Gererating drupal/contenta site configuration....
  echo_message $msg_style_block "Validating AMP (Apache2, MariaDB, PHP stack)..."
  
  # Check all required packages (e.g. apache2, mariadb, etc)
  check_required_packages
}

#==================================================================================================================
#
#==================================================================================================================
check_package_apache2()
{
  local apache_installed=false
  local apache_active=false
  
  # Check apache status
  apache_get_status apache_installed apache_active

  echo_message $msg_style_info "Apache2 installed: [$apache_installed] active: [$apache_active]"

  # Apache2 not installed?
  if [ $apache_installed = false ]; then

    # Install apache2
    apache2_install
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
  local php_version=""
  
  echo_message $msg_style_info "Checking PHP status..."

  # Get PHP information 
  php_get_status php_installed php_version

  echo_message $msg_style_info "PHP installed: [$php_installed] version: [$php_version]"   

  if [ $php_installed = false ]; then
    
    # Install and secure mariadb
    php_install
  fi   
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
