#!/bin/sh

#==================================================================================================================
# Request user input (to a prompt). 
# Parameters:
# $1: The prompt
# $2: Default value (selected by pressing return)
# $3: Variable reference (response to user input). 
#==================================================================================================================
user_input_request()
{
  # The third passed parameter is the name of the variable we want to update
  local var_reference=$3
  local var_default_setting=$2 
  
  # This implies default
  local user_input=""
  local user_input_length

  # Set prompt message as per user input
  message="$1 [$var_default_setting]: "

  # Read user input
  read -p "$message" user_input

  # Get length of user input (if user selected default (entered return) lengh will be 0)
  user_input_length=${#user_input}

  # Use default setting?
  if [ $user_input_length -eq 0 ]; then
    user_input=$var_default_setting
  fi
  
  # Update variable reference
  eval $var_reference="'$user_input'"
}

#==================================================================================================================
# Request user input (password). 
# Parameters:
# $1: The prompt
# $2: Variable reference (response to user input). 
#==================================================================================================================
user_input_request_password()
{
  # The second passed parameter is the name of the variable we want to update
  local var_reference=$2
  
  # This implies default
  local user_input=""
  local user_input_length

  # Set prompt message as per user input
  message="$1: "

  # Prevent echoing user entered password
  stty -echo

  # Read user input
  read -p "$message" user_input

  # Turn back echo
  stty echo
  
  # Get length of user input (if user selected default (entered return) lengh will be 0)
  user_input_length=${#user_input}

  # Use default setting?
  if [ $user_input_length -eq 0 ]; then
    echo ""
    echo "Warning: no password entered"
  else
    # Show "something" for user entered password
    echo "*****"
  fi

  # Update variable reference
  eval $var_reference="'$user_input'"
}
