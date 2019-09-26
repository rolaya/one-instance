#!/bin/sh

# Define text views
TEXT_VIEW_NORMAL_BLUE="\e[01;34m"
TEXT_VIEW_NORMAL_RED="\e[31m"
TEXT_VIEW_NORMAL_GREEN="\e[32m"
TEXT_VIEW_NORMAL_PURPLE="\e[177m"

TEXT_VIEW_NORMAL='\e[00m'

#==================================================================================================================
# Check the required package is installed.
#==================================================================================================================
prompt_user()
{
  message=$1
  color=$2

  echo "${color}$message${TEXT_VIEW_NORMAL}"

  # Read user input
  read -p "Continue? (Y/N): " CONTINUE

  # Continue as per user input
  if [ "$CONTINUE" != "y" ] && [ "$CONTINUE" != "Y" ]; then
    echo "Processing aborted by user..."
    exit 1
    echo
  fi
}

prompt_user "Installing mariadb-server mariadb-client ..." $TEXT_VIEW_NORMAL_GREEN

# Installs mariadb server/client
sudo apt install mariadb-server mariadb-client

prompt_user "Securing mariadb install..." $TEXT_VIEW_NORMAL_GREEN

# Secure mariadb installation, this will:
#   1. Prompt to set user Password
#   2. Prompt to remove anonymous user
#   3. Prompt to disallow root login remotely
#   4. Prompt to remove "test" database
#   5. Prompt to reload privilege tables
sudo mysql_secure_installation
