#!/bin/sh

. $PWD/../common/messaging/message.sh

#==================================================================================================================
#
#==================================================================================================================
file_get_key_value()
{
  # For clarity, we use some local variables
  local var_reference=$3
  local file_name=$1
  local key_name=$2
  local key_value=""
  
  # Display configuration item we are looking for
  echo "Looking for item: [$key_name] in file: [$file_name]"

  # The file we created has format field=value, set the delimeter
  IFS="="

  # Read all lines from site configuration file 
  while read f1 f2
  do
    echo "$f1=$f2"

    case $f1 in

      $key_name)
        key_value=$f2
        break
        ;;

      *)
      ;;
    esac
  done < $file_name

  echo "Item: [$key_name] value: [$key_value]"

  # Update variable reference
  eval $var_reference="'$key_value'" 
}

#==================================================================================================================
#
#==================================================================================================================
file_show_key_value_pairs()
{
  local file_name=$1
  local file_info_msg="$2"

  # The site configuration contains key=value pairs
  IFS="="

  #echo "$file_info_msg [$file_name]"
  echo_message $msg_style_section "$file_info_msg [$file_name]"

  # Process all non-comment lines
  grep -v '^#' $file_name | while read f1 f2
  do
    echo "$f1: $f2"
  done < "$file_name"
  echo ""
}





