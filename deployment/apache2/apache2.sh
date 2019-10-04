#!/bin/sh

#==================================================================================================================
# 
#==================================================================================================================
apache_server_reload()
{
  # Reload apache2 server.
  COMMAND="sudo systemctl reload apache2"
  echo_message $msg_style_section "Reloading apache server with: [$COMMAND]..."
  eval $COMMAND
}

#==================================================================================================================
# 
#==================================================================================================================
apache_server_start()
{
  # Start apache2 server.
  COMMAND="sudo systemctl start apache2"
  echo_message $start "Starting apache server with: [$COMMAND]..."
  eval $Starting
}

#==================================================================================================================
# 
#==================================================================================================================
apache_server_stop()
{
  # Stop apache2 server.
  COMMAND="sudo systemctl stop apache2"
  echo_message $msg_style_section "Stopping apache server with: [$COMMAND]..."
  eval $COMMAND
}

#==================================================================================================================
# 
#==================================================================================================================
apache_get_status()
{
  local command=""
  local command_output=""
  local command_output_length=0
  local var_reference_apache_installed=$1
  local var_reference_apache_active=$2

  # Default to apache not installed (and therefore inactive)
  eval $var_reference_apache_installed=false
  eval $var_reference_apache_active=false

  # Format apache status command
  command="sudo systemctl status apache2"

  # Check apache status
  exec_command "Checking Apache2 status with:" "$command" command_output

  # Grep for apache2.service in output
  command_output=$(echo $command_output | grep 'apache2.service')

  # Apache is installed if we find 'apache2.service' string in output
  command_output_length=${#command_output}

  if [ $command_output_length -eq 0 ]; then
    eval $var_reference_apache_installed=false
  else
    eval $var_reference_apache_installed=true

    # Apache is installed, see if it is active
    command_output=$(echo $command_output | grep 'running')

    # Apache is active if we find 'running' string
    command_output_length=${#command_output}
  
    if [ $command_output_length -eq 0 ]; then
      eval $var_reference_apache_active=false
    else
      eval $var_reference_apache_active=true
    fi
  fi
}

#==================================================================================================================
# 
#==============================================================================================================
apache2_install()
{
  local command=""
  local command_output=""

  # Format apache install command
  command="sudo apt-get -y install apache2"

  # Install apache2
  exec_command "Installing Apache2 via:" "$command" command_output
}
