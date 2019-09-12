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
check_package_requirement()
{
  if ! [ -x "$(command -v $1)" ]; then
    echo "Error: $1 is not installed." >&2
    exit 1
  fi
}

# php and wget must be installed
check_package_requirement "php"
check_package_requirement "wget"

#==================================================================================================================
# Helper function - Displays script's supported flags.
#==================================================================================================================
show_help()
{
  echo "Supported flags:"
  echo "   Flag           Function"
  echo "   -h --help      Displays this help"
  echo "   -v --verbose   Enables verbose mode output"
}

# Get composer installer expected signature
EXPECTED_SIGNATURE="$(wget -q -O - https://composer.github.io/installer.sig)"

# Get composer installer and rename to composer-setup.php
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"

# Generate composer installer signature
ACTUAL_SIGNATURE="$(php -r "echo hash_file('sha384', 'composer-setup.php');")"

# Default to quite mode
verbose=false

# By default, use "composer" as the name of the executable to be installed
executable_name="composer"

# By default, intall composer to user's bin directory
install_directory="$HOME/bin"

# Check all parameters passed in command line (if any)
while [ -n "$1" ]; do

  #echo "Process parameter: [$1]"

  case "$1" in

    # Verbose output requested?
    -v|--verbose)
      verbose=true
      shift
      ;;

    # Help requested?
    -h|--help)
      show_help
      exit 1
      ;;

    # All other flags are not supported
    -*|--*=) # unsupported flags
      echo "Error: Unsupported flag: [$1]" >&2
      show_help
      exit 1
      ;;

    # And anything else is also not supported
    *)
      echo "Error: Unsupported parameter: [$1]" >&2
      show_help
      exit 1
      ;;
  esac
done

if [ "$EXPECTED_SIGNATURE" != "$ACTUAL_SIGNATURE" ]
then
    >&2 echo 'ERROR: Invalid installer signature'
    echo "EXPECTED_SIGNATURE: [$EXPECTED_SIGNATURE]"
    echo "ACTUAL_SIGNATURE:   [$ACTUAL_SIGNATURE]"
    rm composer-setup.php
    exit 1
fi

install_command="php composer-setup.php --install-dir=$install_directory --filename=$executable_name"

if $verbose
then
  echo "${TEXT_VIEW_NORMAL_GREEN}Installing composer executable as:${TEXT_VIEW_NORMAL}[${TEXT_VIEW_NORMAL_BLUE}$executable_name${TEXT_VIEW_NORMAL}]"
  echo "${TEXT_VIEW_NORMAL_GREEN}Installing composer to directory:${TEXT_VIEW_NORMAL} [${TEXT_VIEW_NORMAL_BLUE}$install_directory${TEXT_VIEW_NORMAL}]"
  echo "${TEXT_VIEW_NORMAL_GREEN}Composer install command:${TEXT_VIEW_NORMAL}         [${TEXT_VIEW_NORMAL_BLUE}$install_command${TEXT_VIEW_NORMAL}]"
  echo ""
fi

# Install composer
$install_command

# Cleanup
RESULT=$?
rm composer-setup.php
exit $RESULT
