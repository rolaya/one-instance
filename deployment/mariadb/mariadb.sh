#!/bin/sh

#==================================================================================================================
# 
#==================================================================================================================
mariadb_reload()
{
  COMMAND="sudo systemctl reload mariadb"
  echo_message $msg_style_section "Reloading MariaDB server with: [$COMMAND]..."
  eval $COMMAND
}

#==================================================================================================================
# 
#==================================================================================================================
mariadb_start()
{
  COMMAND="sudo systemctl start mariadb"
  echo_message $start "Starting MariaDB server with: [$COMMAND]..."
  eval $Starting
}

#==================================================================================================================
# 
#==================================================================================================================
mariadb_stop()
{
  COMMAND="sudo systemctl stop mariadb"
  echo_message $msg_style_section "Stopping MariaDB server with: [$COMMAND]..."
  eval $COMMAND
}

#==================================================================================================================
# 
#==================================================================================================================
mariadb_get_status()
{
  local var_reference_mariadb_installed=$1
  local var_reference_mariadb_active=$2

  # Default to mariadb not installed (and therefore inactive)
  eval $var_reference_mariadb_installed=false
  eval $var_reference_mariadb_active=false

  # Check mariadb status.
  COMMAND="sudo systemctl status mariadb"
  
  # Run mariadb status command
  COMMAND_OUTPUT=$(eval $COMMAND)

  #echo $COMMAND_OUTPUT

  # Grep for mariadb.service in output
  COMMAND_OUTPUT=$(echo $COMMAND_OUTPUT | grep 'Status:')

  # MariaDb is installed if we find 'mariadb.service' string in output
  COMMAND_OUTPUT_LENGTH=${#COMMAND_OUTPUT}

  if [ $COMMAND_OUTPUT_LENGTH -eq 0 ]; then
    eval $var_reference_mariadb_installed=false
  else
    eval $var_reference_mariadb_installed=true

    # Check mariadb status.
    COMMAND="pgrep mysqld"
  
    # Run mariadb status command
    COMMAND_OUTPUT=$(eval $COMMAND)

    # MariaDB (mysqld) is active if pgrep returns a PID
    COMMAND_OUTPUT_LENGTH=${#COMMAND_OUTPUT}
  
    if [ $COMMAND_OUTPUT_LENGTH -eq 0 ]; then
      eval $var_reference_mariadb_active=false
    else
      eval $var_reference_mariadb_active=true
    fi
  fi  
}

#==================================================================================================================
# 
#==================================================================================================================
mariadb_install_and_secure()
{
  local UserResponse
  local prompt_format=${TEXT_FG_LIGHT_BLUE}${TEXT_SET_ATTR_BOLD}${TEXT_SET_ATTR_ITALIC}

  # Prompt for MariaDB server/client install
  user_input_request_formatted "Install mariadb-server mariadb-client, continue (y/n)?" "y" UserResponse $prompt_format

  if [ "$UserResponse" = "y" ] || [ "$UserResponse" = "Y" ]; then

    # Format mariadb install command
    COMMAND="sudo apt-get -y install mariadb-server mariadb-client"

    # Install mariadb server/client
    exec_command "Installing mariadb-server mariadb-client via:" "$COMMAND" COMMAND_OUTPUT

    # Secure MariaDB installation (prompt)
    user_input_request_formatted "Securing mariadb install, continue? (y/n)?" "y" UserResponse $prompt_format

    if [ "$UserResponse" = "y" ] || [ "$UserResponse" = "Y" ]; then

      # Secure mariadb installation, this will:
      #   1. Prompt to set user Password
      #   2. Prompt to remove anonymous user
      #   3. Prompt to disallow root login remotely
      #   4. Prompt to remove "test" database
      #   5. Prompt to reload privilege tables
      
      sudo mysql_secure_installation
    fi
  fi

  #rolaya: since mariadb is required, check if installed...
}
