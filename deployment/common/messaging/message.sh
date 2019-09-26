#!/bin/sh

# Define text views
TEXT_VIEW_NORMAL_BLUE="\e[01;34m"
TEXT_VIEW_NORMAL_RED="\e[31m"
TEXT_VIEW_NORMAL_GREEN="\e[32m"
TEXT_VIEW_NORMAL_PURPLE="\e[177m"
TEXT_VIEW_NORMAL='\e[00m'

TEXT_VIEW_UNDERLINE_GREEN="\e[4m\e[32m"
TEXT_VIEW_ITALIC_GREEN="\e[3m\e[32m"
TEXT_VIEW_ITALIC_BLUE="\e[3m\e[34m"
TEXT_VIEW_ITALIC_BOLD_GREEN="\e[3m\e[1m\e[32m"
TEXT_VIEW_ITALIC_BOLD_BLUE="\e[3m\e[1m\e[34m"

# Possible message types
msg_type_default="0"
msg_type_block="1"
msg_type_section="2"
msg_type_warning="3"
msg_type_error="4"
msg_type_fatal="5"


#==================================================================================================================
# Echo ("specially formatted") message.
#==================================================================================================================
echo_message_type_default()
{
  echo "$1"
}

#==================================================================================================================
# Echo ("specially formatted") message.
#==================================================================================================================
echo_message_type_block()
{
  echo ""
  echo "${TEXT_VIEW_NORMAL_RED}=====================================================================================================================================================${TEXT_VIEW_NORMAL}"
  echo "${TEXT_VIEW_NORMAL_RED}$1${TEXT_VIEW_NORMAL}"
  echo "${TEXT_VIEW_NORMAL_RED}=====================================================================================================================================================${TEXT_VIEW_NORMAL}"
  echo ""
}

#==================================================================================================================
# Echo ("specially formatted") message.
#==================================================================================================================
echo_message_type_section()
{
  echo "${TEXT_VIEW_NORMAL_BLUE}$1${TEXT_VIEW_NORMAL}"
}

#==================================================================================================================
# Echo ("specially formatted") message.
#==================================================================================================================
echo_message_type_error()
{
  echo ""
  echo "${TEXT_VIEW_NORMAL_RED}=====================================================================================================================================================${TEXT_VIEW_NORMAL}"
  echo "${TEXT_VIEW_NORMAL_RED}$1${TEXT_VIEW_NORMAL}"
  echo "${TEXT_VIEW_NORMAL_RED}=====================================================================================================================================================${TEXT_VIEW_NORMAL}"
  echo ""
}

#==================================================================================================================
# Echo ("specially formatted") message.
#==================================================================================================================
echo_message()
{
  local typ=$1
  local msg="$2"

  case $typ in

      $msg_type_block)
        echo_message_type_block "$msg"
        break
        ;;
      
      $msg_type_section)
        echo_message_type_section "$msg"
        break
        ;;

      $msg_type_error)
        echo_message_type_error "$msg"
        break
        ;;

      *)
        echo_message_type_default "$msg"
        break
      ;;
  esac
}
