#!/bin/sh

# This variable holds the value of ...
exec_command_output=""

#==================================================================================================================
# 
#==================================================================================================================
apache_server_reload()
{
  # Reload apache2 server.
  COMMAND="sudo systemctl reload apache2"
  echo_message $msg_level_info $msg_style_section "Reloading apache server via: [$COMMAND]..."
  eval $COMMAND
}

#==================================================================================================================
# 
#==================================================================================================================
apache_server_start()
{
  # Start apache2 server.
  COMMAND="sudo systemctl start apache2"
  echo_message $msg_level_info $msg_style_section  "Starting apache server via: [$COMMAND]..."
  eval $Starting
}

#==================================================================================================================
# 
#==================================================================================================================
apache_server_stop()
{
  # Stop apache2 server.
  COMMAND="sudo systemctl stop apache2"
  echo_message $msg_level_info $msg_style_section "Stopping apache server via: [$COMMAND]..."
  eval $COMMAND
}

#==================================================================================================================
# 
#==================================================================================================================
apache_get_status()
{
  local command=""
  local parsed_command_output=""
  local command_output_length=0
  local var_reference_apache_installed=$1
  local var_reference_apache_active=$2

  # Default to apache not installed (and therefore inactive)
  eval $var_reference_apache_installed=false
  eval $var_reference_apache_active=false

  # Format apache status command
  command="sudo systemctl status apache2"

  # Check apache status
  exec_command "Checking Apache2 status via:" "$command"

  # Grep for apache2.service in output
  parsed_command_output=$(echo $exec_command_output | grep 'apache2.service')

  # Apache is installed if we find 'apache2.service' string in output
  command_output_length=${#parsed_command_output}

  if [ $command_output_length -eq 0 ]; then
    eval $var_reference_apache_installed=false
  else
    eval $var_reference_apache_installed=true

    # Apache is installed, see if it is active
    parsed_command_output=$(echo $exec_command_output | grep 'running')

    # Apache is active if we find 'running' string
    command_output_length=${#parsed_command_output}
  
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
  # Format apache install command
  local command="sudo apt-get -y install apache2"

  # Install apache2
  exec_command "Installing Apache2 via:" "$command"
}
