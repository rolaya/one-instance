#!/bin/sh

#==================================================================================================================
# Check the required package is installed.
#==================================================================================================================
check_package_requirement()
{
  # Inform user we are checking for package
  echo_message $msg_level_info $msg_style_section "Checking for package [$1]..."

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
  echo_message $msg_level_info $msg_style_info "Installing package: [$1]..."
  sudo apt-get install $1
}

#==================================================================================================================
# Create directory
#==================================================================================================================
create_directory()
{
  echo_message $msg_level_info $msg_style_info "Creating directory: [$1]..."
  mkdir -p $1
}

#==================================================================================================================
# Configure python
#==================================================================================================================
deploy_python()
{
  local command

  # Install PIP
  install_package python-pip

  # Format command 
  command="pip install mysql-connector-python-rf"

  # Install mysql-connector (for python support)
  exec_command "Installing python mysql connector with:" "$command"
}

#==================================================================================================================
# Deploy MYSQL user
#==================================================================================================================
deploy_mysql_user()
{
  local UserResponse
  local prompt_format=${TEXT_FG_LIGHT_BLUE}${TEXT_SET_ATTR_BOLD}${TEXT_SET_ATTR_ITALIC}

  # Create mysql user? 
  user_input_request_formatted "Creating mysql user (mysql root user password required (and sudo password may be required)), continue (y/n)?" "y" UserResponse $prompt_format

  if [ "$UserResponse" = "y" ] || [ "$UserResponse" = "Y" ]; then

    # Get (new) mysql user name
    user_input_request "MySQL user name" "" mysql_user

    # Get (new) mysql user password
    user_input_request_password "MySQL user password" mysql_user_pass
    
    # Get mysql root user password
    user_input_request_password "MySQL root user password" mysql_root_user_pass

    # Format create user query
    QUERY_CREATE_USER="create user '$mysql_user'@'localhost' identified by '$mysql_user_pass';"

    # Format grant user priviledge query
    QUERY_GRANT_USER="grant all on *.* to '$mysql_user'@'localhost' identified by '$mysql_user_pass' with grant option;"

    # Format flush priviledges query
    QUERY_FLUSH_PRIVILEGES="FLUSH PRIVILEGES;"
    
    # We are going to execute three consecutive queries
    SQL="${QUERY_CREATE_USER}${QUERY_GRANT_USER}${QUERY_FLUSH_PRIVILEGES}"

    # Find mysql executable
    MYSQL=`which mysql`

    # Execute mysql queries
    sudo $MYSQL -uroot -p$mysql_root_user_pass -e "$SQL"

    echo_message $msg_level_info $msg_style_info "Created mysql user: [${mysql_user}]..."
  fi
}
