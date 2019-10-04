#!/bin/sh

#==================================================================================================================
#==================================================================================================================
init_debug_configuration()
{
  local var_reference=$1

  # Here, we set the global debug mask
  #local config_value=$((${gmask_debug_deployment} | ${gmask_debug_file_io}))
  local config_value=$((${gmask_debug_deployment} | ${gmask_debug_debug}))

  # Set to true to get debug messages
  local debug=false

  if [ $debug = true ]; then
    echo "Debug configuration: [$config_value]"
  fi

  # Update variable reference
  eval $var_reference="'$config_value'" 
}
