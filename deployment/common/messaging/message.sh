#!/bin/sh

# Foreground text colors
TEXT_FG_DEFAULT="\e[39m"
TEXT_FG_BLACK="\e[30m"
TEXT_FG_RED="\e[31m"
TEXT_FG_GREEN="\e[32m"
TEXT_FG_YELLOW="\e[33m"
TEXT_FG_BLUE="\e[34m"
TEXT_FG_MAGENTA="\e[35m"
TEXT_FG_CYAN="\e[36m"
TEXT_FG_LIGHT_GRAY="\e[37m"
TEXT_FG_DARK_GRAY="\e[90m"
TEXT_FG_LIGHT_RED="\e[91m"
TEXT_FG_LIGHT_GREEN="\e[92m"
TEXT_FG_LIGHT_YELLOW="\e[93m"
TEXT_FG_LIGHT_BLUE="\e[94m"
TEXT_FG_LIGHT_MAGENTA="\e[95m"
TEXT_FG_LIGHT_CYAN="\e[96m"
TEXT_FG_WHITE="\e[96m"

# Reset all attributes and colors to normal
TEXT_VIEW_RESET='\e[00m'

TEXT_SET_ATTR_BOLD="\e[01m"
TEXT_SET_ATTR_DIM="\e[02m"
TEXT_SET_ATTR_ITALIC="\e[03m"
TEXT_SET_ATTR_UNDERLINE="\e[04m"
TEXT_SET_ATTR_BLINK="\e[05m"
TEXT_SET_ATTR_REVERSE="\e[07m"
TEXT_SET_ATTR_HIDDEN="\e[08m"

TEXT_RESET_ATTR_BOLD="\e[21m"
TEXT_RESET_ATTR_DIM="\e[22m"
TEXT_RESET_ATTR_ITALIC="\e[23m"
TEXT_RESET_ATTR_UNDERLINE="\e[24m"
TEXT_RESET_ATTR_BLINK="\e[25m"
TEXT_RESET_ATTR_REVERSE="\e[27m"
TEXT_RESET_ATTR_HIDDEN="\e[28m"

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
  echo "${TEXT_FG_MAGENTA}=====================================================================================================================================================${TEXT_VIEW_RESET}"
  echo "${TEXT_FG_MAGENTA}${TEXT_SET_ATTR_ITALIC}$1${TEXT_VIEW_RESET}"
  echo "${TEXT_FG_MAGENTA}=====================================================================================================================================================${TEXT_VIEW_RESET}"
  echo ""
}

#==================================================================================================================
# Echo ("specially formatted") message.
#==================================================================================================================
echo_message_style_section()
{
  echo "${TEXT_FG_BLUE}$1${TEXT_VIEW_RESET}"
}

#==================================================================================================================
# Echo ("specially formatted") message.
#==================================================================================================================
echo_message_style_error()
{
  echo ""
  echo "${TEXT_FG_RED}=====================================================================================================================================================${TEXT_VIEW_RESET}"
  echo "${TEXT_FG_RED}$1${TEXT_VIEW_RESET}"
  echo "${TEXT_FG_RED}=====================================================================================================================================================${TEXT_VIEW_RESET}"
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
