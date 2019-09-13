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

# php must be installed
check_package_requirement "php"

#==================================================================================================================
# Helper function - Displays script's supported flags.
#==================================================================================================================
show_help()
{
  echo "Supported flags:"
  echo "   Flag               Function"
  echo "   -h --help          Displays this help"
  echo "   -v --verbose       Enables verbose mode output"
  echo "   -d --download-dir  Contenta download directory"
}

# By default, download contenta to current working directory/contenta.
# The download directory must not exist.
download_dir="$PWD/contenta"

# Check all parameters passed in command line (if any)
while [ -n "$1" ]; do

  #echo "Process parameter: [$1]"

  case "$1" in

    # Verbose output requested?
    -v|--verbose)
      verbose=true
      shift
      ;;

    # Install directory specified?
    -d|--download-dir)

      if [ -z "$2" ]; then
        show_help
        exit 1
      else
        # Get the install directory as passed in command line
        download_dir="$2"
        shift 2
      fi
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

REBOOT_INTO_BOOTLOADER_MODE="n"

# The contenta download directoty must not exist
if [ -d "$download_dir" ]; then
  echo "Error: directory: [$download_dir] already exists" >&2
  exit 1
else
  echo "Download Contenta to directory: [${TEXT_VIEW_NORMAL_BLUE}$download_dir${TEXT_VIEW_NORMAL}]"
  # Verify user wants to continue with contenta download
  read -r -p "Continue (Y/N): " input

  case $input in
    [yY][eE][sS]|[yY])
    ;;

    [nN][oO]|[nN])
      echo "Contenta download to directory: [${TEXT_VIEW_NORMAL_BLUE}$download_dir${TEXT_VIEW_NORMAL}] terminated"
      exit 1
      ;;

    *)
      echo "Invalid input, contenta download terminated..."
      exit 1
      ;;
    esac
fi

echo "${TEXT_VIEW_NORMAL_GREEN}Contenta download directory: ${TEXT_VIEW_NORMAL}[${TEXT_VIEW_NORMAL_BLUE}$executable_name${download_dir}${TEXT_VIEW_NORMAL}]"

# Download contenta download script
php -r "readfile('https://raw.githubusercontent.com/contentacms/contenta_jsonapi_project/8.x-2.x/scripts/download.sh');" > download-contentacms.sh

# Make script executable by all
chmod a+x download-contentacms.sh

# Perform contenta download (using just acquired "download.sh" script).
./download-contentacms.sh $download_dir/contenta
