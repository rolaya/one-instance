#!/bin/sh

# "Include" scripts which contain (common) functions we are going to use
. $PWD/site-config.sh
. $PWD/../common/messaging/message.sh

#==================================================================================================================
# Helper function - Displays script's supported flags.
#==================================================================================================================
show_help()
{
  echo "Supported flags:"
  echo "   Flag                   Function"
  echo "   -h --help              Displays this help"
  echo "   -v --verbose           Enables verbose mode output"
  echo "   -f --site-config-file  Use site configuration file"
}

# By default, do not use a site configuration file (unless specified in the command line)
use_config_file=false

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
    -f|--site-config-file)

      if [ -z "$2" ]; then
        show_help
        exit 1
      else
        # Get the install directory as passed in command line
        use_config_file=true
        site_config_file="$2"
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

# Used configuration file for deployment (instead of interactive)
if [ $use_config_file = false ]; then
  # Collect drupal/contenta site information. The information acquired from the user and the running system
  # is written to a number of configuration files which the deployment process/scripts utilize.
  sh ./collect-site-information.sh
else
  echo_message $msg_type_error "File driven deployment not supported (yet)!"
  exit 1
fi

# Get (user defined) directory for drupal/contenta site
get_site_config_value SiteDirectory

# Get (user defined) directory for drupal/contenta site
get_site_config_value DatabaseName

# Get (user defined) directory for drupal/contenta site
get_site_config_value DatabaseUser

# Check if directory exists
if [ -d "$SiteDirectory" ]; then
  echo "Warning, directory: [$SiteDirectory] already exists"
else
  echo "Creating directory: [$SiteDirectory]..."
  mkdir -p $SiteDirectory
fi

# Create mariadb database and database user.
echo_message $msg_type_section "Creating MariaDB database [$DatabaseName] and database user: [$DatabaseUser]..."

# Create site database (and grant user permissions to database) rolaya: need to check result of this operation...
python $HOME/proj/www/Drupal/one-instance/tools/mariadb/init-database-for-contenta-deployment.py -d $DatabaseName -u $DatabaseUser

# Generate apache2 site configuration and deploy file to /etc/apache2/sites-available/
#cd ../apache2
#echo "Executing in directory: [$PWD]..."
#sh ./generate-site-available-config.sh


