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
  local var_reference_apache_installed=$1
  local var_reference_apache_active=$2

  # Default to apache not installed (and therefore inactive)
  eval $var_reference_apache_installed=false
  eval $var_reference_apache_active=false

  # Check apache status.
  COMMAND="sudo systemctl status apache2"
  
  # Run apache status command
  COMMAND_OUTPUT=$(eval $COMMAND)

  # Grep for apache2.service in output
  COMMAND_OUTPUT=$(echo $COMMAND_OUTPUT | grep 'apache2.service')

  # Apache is installed if we find 'apache2.service' string in output
  COMMAND_OUTPUT_LENGTH=${#COMMAND_OUTPUT}

  if [ $COMMAND_OUTPUT_LENGTH -eq 0 ]; then
    eval $var_reference_apache_installed=false
  else
    eval $var_reference_apache_installed=true

    # Apache is installed, see if it is active
    COMMAND_OUTPUT=$(echo $COMMAND_OUTPUT | grep 'running')

    # Apache is active if we find 'running' string
    COMMAND_OUTPUT_LENGTH=${#COMMAND_OUTPUT}
  
    if [ $COMMAND_OUTPUT_LENGTH -eq 0 ]; then
      eval $var_reference_apache_active=false
    else
      eval $var_reference_apache_active=true
    fi
  fi
}
