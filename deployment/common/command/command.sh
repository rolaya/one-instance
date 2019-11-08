#!/bin/sh

#==================================================================================================================
# 
#==================================================================================================================
exec_command()
{
  local message="$1"
  local command="$2"
  exec_command_output=""

  # Inform user what we are about to do...
  echo_message $msg_style_info "$message [$command]..."

  # Execute the command (and capture command output on global variable)
  exec_command_output=$(eval $command)

  # Debug messages enabled?
  if [ $(($GlobalDebugConfig & $gmask_debug_debug)) -eq $(( $gmask_debug_debug )) ]; then

    # Display the command output
    echo_message $msg_style_debug "command output: [${exec_command_output}]..."
  fi
}

