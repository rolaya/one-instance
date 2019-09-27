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

# Possible message "styles"
msg_style_default="0"
msg_style_block="1"
msg_style_section="2"
msg_style_warning="3"
msg_style_error="4"
msg_style_critical="5"

#==================================================================================================================
# Echo ("specially formatted") message.
#==================================================================================================================
echo_message_style_default()
{
  echo "$1"
}

#==================================================================================================================
# Echo ("specially formatted") message.
#==================================================================================================================
echo_message_style_block()
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
echo_message_style_section()
{
  echo "${TEXT_VIEW_NORMAL_BLUE}$1${TEXT_VIEW_NORMAL}"
}

#==================================================================================================================
# Echo ("specially formatted") message.
#==================================================================================================================
echo_message_style_error()
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
  local msg_style=$1
  local msg="$2"

  case $msg_style in

      $msg_style_block)
        echo_message_style_block "$msg"
        break
        ;;
      
      $msg_style_section)
        echo_message_style_section "$msg"
        break
        ;;

      $msg_style_error)
        echo_message_style_error "$msg"
        break
        ;;

      *)
        echo_message_style_default "$msg"
        break
      ;;
  esac
}
