#!/bin/sh

#==================================================================================================================
# 
#==================================================================================================================
exec_command()
{
  local message="$1"
  local command="$2"
  local exec_command_output
  local var_reference_command_output=$3

  # Init command output
  eval $var_reference_command_output=""

  # Inform user what we are about to do...
  echo_message $msg_style_info "$message [$command]..."

  # Execute the command
  exec_command_output=$(eval $command)

  # Return command output to caller
  eval $var_reference_command_output="'$exec_command_output'"

  # Debug messages enabled?
  if [ $(($GlobalDebugConfig & $gmask_debug_debug)) -eq $(( $gmask_debug_debug )) ]; then
    
    # Display the name of the variable (passed by caller) updated by this function
    echo_message $msg_style_debug "Updated caller's variable: [${var_reference_command_output}]..."
  fi
}

