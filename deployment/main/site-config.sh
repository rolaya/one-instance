#!/bin/sh

#==================================================================================================================
# Get the value of a configuration item (as defined in file "site-config.txt")
#==================================================================================================================
get_site_config_value()
{
  local var_reference=$1
  local config_value=""

  # For now, we are always using a "generic" file which is re-generated for every deployment.
  local config_file=site-config.txt

  # Set to true to get debug messages
  local debug=true

  if [ $debug = true ]; then
    # Display configuration item we are looking for
    echo "Looking for site configuration item: [$1] in file: [$config_file]"
  fi

  # The file we created has format field=value, set the delimeter
  IFS="="

  # Read all lines from site configuration file
  while read f1 f2
  do
    if [ $debug = true ]; then
      echo "$f1=$f2"
    fi

    case $f1 in

      $1)
        config_value=$f2
        break
        ;;

      *)
      ;;
    esac
  done < $config_file

  if [ $debug = true ]; then
    echo "Item: [$1] value: [$config_value]"
  fi

  # Update variable reference
  eval $var_reference="'$config_value'" 
}


