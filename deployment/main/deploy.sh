#!/bin/sh

# "Include" scripts which contain (common) functionality we are going to use
. $PWD/../infrastructure/infrastructure.sh
. $PWD/../common/user_io/user_io.sh
. $PWD/../common/debug/debug.sh
. $PWD/../common/file_io/file_io.sh
. $PWD/../common/messaging/message.sh
. $PWD/../common/command/command.sh
. $PWD/../php/php.sh
. $PWD/../php/composer.sh
. $PWD/../php/contenta-download.sh
. $PWD/../apache2/apache2.sh
. $PWD/../mariadb/mariadb.sh
. $PWD/../apache2/site-available.sh
. $PWD/../contenta/contenta.sh
. $PWD/../contenta/deploy-site.sh
. $PWD/../contenta/site-config.sh
. $PWD/../amp/amp-stack.sh

# Some global varaibles which drive the deployment
deploy_contenta_site_only=false
deploy_all=true

#==================================================================================================================
# Helper function - Displays script's supported flags.
#==================================================================================================================
deploy_help()
{
  echo "Supported flags:"
  echo "   Flag                     Function"
  echo "   -h --help                Displays this help"
  echo "   -v --verbose             Enables verbose mode output"
  echo "   -s --contenta-site-only  Install contenta site only (assumes deployed infrastructure)"
}

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
        deploy_help
        exit 1
      else
        # Get the install directory as passed in command line
        use_config_file=true
        site_config_file="$2"
        shift 2
      fi
      ;;

    # Install/deploy contenta site only (assumes supporting infrastructure/framework already installed)
    -s|--contenta-site-only)

      deploy_contenta_site_only=true
      deploy_all=false
      shift 1
      ;;        

    # Help requested?
    -h|--help)
      deploy_help
      exit 1
      ;;

    # All other flags are not supported
    -*|--*=) # unsupported flags
      echo "Error: Unsupported flag: [$1]" >&2
      deploy_help
      exit 1
      ;;

    # And anything else is also not supported
    *)
      echo "Error: Unsupported parameter: [$1]" >&2
      deploy_help
      exit 1
      ;;
  esac
done

#==================================================================================================================
# Full deployment (AMP, infrastructure, site, etc)
#==================================================================================================================
deployment_full_show_guide()
{
  local guide_item
  local UserResponse
  local prompt_format=${TEXT_FG_LIGHT_BLUE}${TEXT_SET_ATTR_BOLD}${TEXT_SET_ATTR_ITALIC}

  echo "${TEXT_FG_MAGENTA}=====================================================================================================================================================${TEXT_VIEW_RESET}"

  guide_item="Contenta deployment "
  echo "${TEXT_FG_MAGENTA}${TEXT_SET_ATTR_ITALIC}$guide_item${TEXT_VIEW_RESET}"
  echo ""
  guide_item="This process installs infrastructure required for Contenta deployment,"
  echo "${TEXT_FG_MAGENTA}${TEXT_SET_ATTR_ITALIC}$guide_item${TEXT_VIEW_RESET}"
  guide_item="collects site configuration information from the user and deploys Contenta site"
  echo "${TEXT_FG_MAGENTA}${TEXT_SET_ATTR_ITALIC}$guide_item${TEXT_VIEW_RESET}"
  guide_item="using user defined information."
  echo "${TEXT_FG_MAGENTA}${TEXT_SET_ATTR_ITALIC}$guide_item${TEXT_VIEW_RESET}"
  echo ""
  guide_item="sudo password is required."
  echo "${TEXT_FG_MAGENTA}${TEXT_SET_ATTR_ITALIC}$guide_item${TEXT_VIEW_RESET}"
  echo ""

	guide_item="1. Installs AMP (Apache, MariaDB PHP) stack"
  echo "${TEXT_FG_MAGENTA}${TEXT_SET_ATTR_ITALIC}$guide_item${TEXT_VIEW_RESET}"

  guide_item="   1.1. Apache2 (latest release version)"
  echo "${TEXT_FG_MAGENTA}${TEXT_SET_ATTR_ITALIC}$guide_item${TEXT_VIEW_RESET}"

  guide_item="   1.2. MariaDB server, client (latest release version)"
  echo "${TEXT_FG_MAGENTA}${TEXT_SET_ATTR_ITALIC}$guide_item${TEXT_VIEW_RESET}"

  guide_item="        1.2.1. Secures MariaDB installation (requires MariaDB root user password definition) "
  echo "${TEXT_FG_MAGENTA}${TEXT_SET_ATTR_ITALIC}$guide_item${TEXT_VIEW_RESET}"

  guide_item="   1.3. PHP (version $PHP_VERSION)"
  echo "${TEXT_FG_MAGENTA}${TEXT_SET_ATTR_ITALIC}$guide_item${TEXT_VIEW_RESET}"

  guide_item="2. Installs Composer (dependency manager for PHP)"
  echo "${TEXT_FG_MAGENTA}${TEXT_SET_ATTR_ITALIC}$guide_item${TEXT_VIEW_RESET}"

  guide_item="3. Installs Python"
  echo "${TEXT_FG_MAGENTA}${TEXT_SET_ATTR_ITALIC}$guide_item${TEXT_VIEW_RESET}"  

  guide_item="4. Creates MariaDB user with privileges to create contenta site user and database"
  echo "${TEXT_FG_MAGENTA}${TEXT_SET_ATTR_ITALIC}$guide_item${TEXT_VIEW_RESET}" 

  guide_item="5. Collects Contenta site information"
  echo "${TEXT_FG_MAGENTA}${TEXT_SET_ATTR_ITALIC}$guide_item${TEXT_VIEW_RESET}"  

  guide_item="   5.1. Contenta site name"
  echo "${TEXT_FG_MAGENTA}${TEXT_SET_ATTR_ITALIC}$guide_item${TEXT_VIEW_RESET}"  

  guide_item="   5.2. Contenta site email"
  echo "${TEXT_FG_MAGENTA}${TEXT_SET_ATTR_ITALIC}$guide_item${TEXT_VIEW_RESET}" 

  guide_item="   5.3. Contenta site account name"
  echo "${TEXT_FG_MAGENTA}${TEXT_SET_ATTR_ITALIC}$guide_item${TEXT_VIEW_RESET}"

  guide_item="   5.4. Contenta site account password"
  echo "${TEXT_FG_MAGENTA}${TEXT_SET_ATTR_ITALIC}$guide_item${TEXT_VIEW_RESET}"

  guide_item="   5.5. Contenta site account email"
  echo "${TEXT_FG_MAGENTA}${TEXT_SET_ATTR_ITALIC}$guide_item${TEXT_VIEW_RESET}"

  guide_item="   5.6. Contenta site database name"
  echo "${TEXT_FG_MAGENTA}${TEXT_SET_ATTR_ITALIC}$guide_item${TEXT_VIEW_RESET}"

  guide_item="   5.7. MariaDB user (see **)"
  echo "${TEXT_FG_MAGENTA}${TEXT_SET_ATTR_ITALIC}$guide_item${TEXT_VIEW_RESET}"

  guide_item="   5.8. Collects Apache2 related configuration"
  echo "${TEXT_FG_MAGENTA}${TEXT_SET_ATTR_ITALIC}$guide_item${TEXT_VIEW_RESET}" 

  guide_item="        5.8.1. Document root"
  echo "${TEXT_FG_MAGENTA}${TEXT_SET_ATTR_ITALIC}$guide_item${TEXT_VIEW_RESET}" 

  guide_item="        5.8.2. Server Name"
  echo "${TEXT_FG_MAGENTA}${TEXT_SET_ATTR_ITALIC}$guide_item${TEXT_VIEW_RESET}" 

  guide_item="        5.8.3. Server Alias"
  echo "${TEXT_FG_MAGENTA}${TEXT_SET_ATTR_ITALIC}$guide_item${TEXT_VIEW_RESET}" 

  guide_item="        5.8.4. Site directory"
  echo "${TEXT_FG_MAGENTA}${TEXT_SET_ATTR_ITALIC}$guide_item${TEXT_VIEW_RESET}"

  echo "${TEXT_FG_MAGENTA}=====================================================================================================================================================${TEXT_VIEW_RESET}"

  # Continue?
  user_input_request_formatted "Continue (y/n)?" "y" UserResponse $prompt_format

  if [ "$UserResponse" != "y" ] && [ "$UserResponse" != "Y" ]; then
      exit 1
  fi  
}

#==================================================================================================================
# Contenta site only deployment.
#==================================================================================================================
deployment_contenta_site_show_guide()
{
  local guide_item
  local UserResponse
  local prompt_format=${TEXT_FG_LIGHT_BLUE}${TEXT_SET_ATTR_BOLD}${TEXT_SET_ATTR_ITALIC}

  echo "${TEXT_FG_MAGENTA}=====================================================================================================================================================${TEXT_VIEW_RESET}"

  guide_item="Contenta deployment "
  echo "${TEXT_FG_MAGENTA}${TEXT_SET_ATTR_ITALIC}$guide_item${TEXT_VIEW_RESET}"
  echo ""
  guide_item="This process collects deployment information from the user and installs Contenta site"
  echo "${TEXT_FG_MAGENTA}${TEXT_SET_ATTR_ITALIC}$guide_item${TEXT_VIEW_RESET}"
  echo ""

  guide_item="1. Collects Contenta site (to be created) information"
  echo "${TEXT_FG_MAGENTA}${TEXT_SET_ATTR_ITALIC}$guide_item${TEXT_VIEW_RESET}"  

  guide_item="   1.2. Contenta site name"
  echo "${TEXT_FG_MAGENTA}${TEXT_SET_ATTR_ITALIC}$guide_item${TEXT_VIEW_RESET}"  

  guide_item="   1.2. Contenta site email"
  echo "${TEXT_FG_MAGENTA}${TEXT_SET_ATTR_ITALIC}$guide_item${TEXT_VIEW_RESET}" 

  guide_item="   1.3. Contenta site account name"
  echo "${TEXT_FG_MAGENTA}${TEXT_SET_ATTR_ITALIC}$guide_item${TEXT_VIEW_RESET}"

  guide_item="   1.4. Contenta site account password"
  echo "${TEXT_FG_MAGENTA}${TEXT_SET_ATTR_ITALIC}$guide_item${TEXT_VIEW_RESET}"

  guide_item="   1.5. Contenta site account email"
  echo "${TEXT_FG_MAGENTA}${TEXT_SET_ATTR_ITALIC}$guide_item${TEXT_VIEW_RESET}"

  guide_item="   1.6. Contenta site MariaDB database name"
  echo "${TEXT_FG_MAGENTA}${TEXT_SET_ATTR_ITALIC}$guide_item${TEXT_VIEW_RESET}"

  guide_item="   1.7. MariaDB user (see **)"
  echo "${TEXT_FG_MAGENTA}${TEXT_SET_ATTR_ITALIC}$guide_item${TEXT_VIEW_RESET}"

  guide_item="   1.8. Collects Apache2 related configuration"
  echo "${TEXT_FG_MAGENTA}${TEXT_SET_ATTR_ITALIC}$guide_item${TEXT_VIEW_RESET}" 

  guide_item="        1.8.1. Document root"
  echo "${TEXT_FG_MAGENTA}${TEXT_SET_ATTR_ITALIC}$guide_item${TEXT_VIEW_RESET}" 

  guide_item="        1.8.2. Server Name"
  echo "${TEXT_FG_MAGENTA}${TEXT_SET_ATTR_ITALIC}$guide_item${TEXT_VIEW_RESET}" 

  guide_item="        1.8.3. Server Alias"
  echo "${TEXT_FG_MAGENTA}${TEXT_SET_ATTR_ITALIC}$guide_item${TEXT_VIEW_RESET}" 

  guide_item="        1.8.4. Site directory"
  echo "${TEXT_FG_MAGENTA}${TEXT_SET_ATTR_ITALIC}$guide_item${TEXT_VIEW_RESET}"

  echo "${TEXT_FG_MAGENTA}=====================================================================================================================================================${TEXT_VIEW_RESET}"

  # Continue?
  user_input_request_formatted "Continue (y/n)?" "y" UserResponse $prompt_format

  if [ "$UserResponse" != "y" ] && [ "$UserResponse" != "Y" ]; then
      exit 1
  fi  
}

#==================================================================================================================
# 
#==================================================================================================================
deployment_show_guide()
{
  if [ $deploy_all = true ]; then
    deployment_full_show_guide
  else
    deployment_contenta_site_show_guide
  fi
}

# Show contenta deployment guide
deployment_show_guide

# Install/deploy AMP stack...
deploy_amp_stack

# Deploy composer
deploy_composer

# Deploy python
deploy_python

# Deploy new mysql user (and grant misc. priviledges)
deploy_mysql_user

# Deploy contenta site
deploy_contenta_site

