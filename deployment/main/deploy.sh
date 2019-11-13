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
deploy_via_config_file=false

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
        deploy_via_config_file=true
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

level1_item_index=0
level2_item_index=0
level3_item_index=0

#==================================================================================================================
# Generate index for new level1 item
#==================================================================================================================
new_level1_item()
{
  level1_item_index=$((level1_item_index+1))
  level2_item_index=0
}

#==================================================================================================================
# Generate index for new level2 item
#==================================================================================================================
new_level2_item()
{
  level2_item_index=$((level2_item_index+1))
  level3_item_index=0
}

#==================================================================================================================
# Generate index for new level3 item
#==================================================================================================================
new_level3_item()
{
  level3_item_index=$((level3_item_index+1))
}

#==================================================================================================================
# Full deployment (AMP, infrastructure, site, etc)
#==================================================================================================================
deployment_site_guide()
{
  local guide_item
  local UserResponse
  local prompt_format=${TEXT_FG_LIGHT_BLUE}${TEXT_SET_ATTR_BOLD}${TEXT_SET_ATTR_ITALIC}

  new_level1_item
  guide_item="$level1_item_index. Collects Contenta site information"
  echo "${TEXT_FG_MAGENTA}${TEXT_SET_ATTR_ITALIC}$guide_item${TEXT_VIEW_RESET}"  

  new_level2_item
  guide_item="   $level1_item_index.$level2_item_index. Contenta site name"
  echo "${TEXT_FG_MAGENTA}${TEXT_SET_ATTR_ITALIC}$guide_item${TEXT_VIEW_RESET}"  

  new_level2_item
  guide_item="   $level1_item_index.$level2_item_index. Contenta site email"
  echo "${TEXT_FG_MAGENTA}${TEXT_SET_ATTR_ITALIC}$guide_item${TEXT_VIEW_RESET}" 

  new_level2_item
  guide_item="   $level1_item_index.$level2_item_index. Contenta site account name"
  echo "${TEXT_FG_MAGENTA}${TEXT_SET_ATTR_ITALIC}$guide_item${TEXT_VIEW_RESET}"

  new_level2_item
  guide_item="   $level1_item_index.$level2_item_index. Contenta site account password"
  echo "${TEXT_FG_MAGENTA}${TEXT_SET_ATTR_ITALIC}$guide_item${TEXT_VIEW_RESET}"

  new_level2_item
  guide_item="   $level1_item_index.$level2_item_index. Contenta site account email"
  echo "${TEXT_FG_MAGENTA}${TEXT_SET_ATTR_ITALIC}$guide_item${TEXT_VIEW_RESET}"

  new_level2_item
  guide_item="   $level1_item_index.$level2_item_index. Contenta site database name"
  echo "${TEXT_FG_MAGENTA}${TEXT_SET_ATTR_ITALIC}$guide_item${TEXT_VIEW_RESET}"

  new_level2_item
  guide_item="   $level1_item_index.$level2_item_index. MariaDB user (see **)"
  echo "${TEXT_FG_MAGENTA}${TEXT_SET_ATTR_ITALIC}$guide_item${TEXT_VIEW_RESET}"

  new_level2_item
  guide_item="   $level1_item_index.$level2_item_index. Collects Apache2 site configuration information"
  echo "${TEXT_FG_MAGENTA}${TEXT_SET_ATTR_ITALIC}$guide_item${TEXT_VIEW_RESET}" 

  new_level3_item
  guide_item="        $level1_item_index.$level2_item_index.$level3_item_index. Document root"
  echo "${TEXT_FG_MAGENTA}${TEXT_SET_ATTR_ITALIC}$guide_item${TEXT_VIEW_RESET}" 

  new_level3_item
  guide_item="        $level1_item_index.$level2_item_index.$level3_item_index. Server Name"
  echo "${TEXT_FG_MAGENTA}${TEXT_SET_ATTR_ITALIC}$guide_item${TEXT_VIEW_RESET}" 

  new_level3_item
  guide_item="        $level1_item_index.$level2_item_index.$level3_item_index. Server Alias"
  echo "${TEXT_FG_MAGENTA}${TEXT_SET_ATTR_ITALIC}$guide_item${TEXT_VIEW_RESET}" 

  new_level3_item
  guide_item="        $level1_item_index.$level2_item_index.$level3_item_index. Site directory"
  echo "${TEXT_FG_MAGENTA}${TEXT_SET_ATTR_ITALIC}$guide_item${TEXT_VIEW_RESET}"
}

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

  new_level1_item
	guide_item="$level1_item_index. Installs AMP (Apache, MariaDB PHP) stack"
  echo "${TEXT_FG_MAGENTA}${TEXT_SET_ATTR_ITALIC}$guide_item${TEXT_VIEW_RESET}"

  new_level2_item
  guide_item="   $level1_item_index.$level2_item_index. Apache2 (latest release version)"
  echo "${TEXT_FG_MAGENTA}${TEXT_SET_ATTR_ITALIC}$guide_item${TEXT_VIEW_RESET}"

  new_level2_item
  guide_item="   $level1_item_index.$level2_item_index. MariaDB server, client (latest release version)"
  echo "${TEXT_FG_MAGENTA}${TEXT_SET_ATTR_ITALIC}$guide_item${TEXT_VIEW_RESET}"

  new_level3_item
  guide_item="        $level1_item_index.$level2_item_index.$level3_item_index. Secures MariaDB installation (requires MariaDB root user password definition) "
  echo "${TEXT_FG_MAGENTA}${TEXT_SET_ATTR_ITALIC}$guide_item${TEXT_VIEW_RESET}"

  new_level2_item
  guide_item="   $level1_item_index.$level2_item_index. PHP (version $PHP_VERSION)"
  echo "${TEXT_FG_MAGENTA}${TEXT_SET_ATTR_ITALIC}$guide_item${TEXT_VIEW_RESET}"

  new_level1_item
  guide_item="$level1_item_index. Installs Composer (dependency manager for PHP)"
  echo "${TEXT_FG_MAGENTA}${TEXT_SET_ATTR_ITALIC}$guide_item${TEXT_VIEW_RESET}"

  new_level1_item
  guide_item="$level1_item_index. Installs Python"
  echo "${TEXT_FG_MAGENTA}${TEXT_SET_ATTR_ITALIC}$guide_item${TEXT_VIEW_RESET}"  

  new_level1_item
  guide_item="$level1_item_index. Creates MariaDB user with privileges to create contenta site user and database"
  echo "${TEXT_FG_MAGENTA}${TEXT_SET_ATTR_ITALIC}$guide_item${TEXT_VIEW_RESET}" 

  # Show contenta site deployment guide
  deployment_site_guide

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
  guide_item="This process collects site configuration information from the user"
  echo "${TEXT_FG_MAGENTA}${TEXT_SET_ATTR_ITALIC}$guide_item${TEXT_VIEW_RESET}"
  guide_item="and deploys Contenta site using user defined information."
  echo "${TEXT_FG_MAGENTA}${TEXT_SET_ATTR_ITALIC}$guide_item${TEXT_VIEW_RESET}"
  echo ""
  guide_item="sudo password is required."
  echo "${TEXT_FG_MAGENTA}${TEXT_SET_ATTR_ITALIC}$guide_item${TEXT_VIEW_RESET}"
  echo ""

  # Show contenta site deployment guide
  deployment_site_guide

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
deploy_contenta()
{
  # Init debug configuration
  init_debug_configuration GlobalDebugConfig

  if [ $(($GlobalDebugConfig & $gmask_debug_debug)) -eq $(( $gmask_debug_debug )) ]; then
    echo "GlobalDebugConfig $GlobalDebugConfig"
  fi

  if [ $deploy_all = true ]; then
    
    # Show full (AMP stack, infrastructure, contenta site) deployment guide
    deployment_full_show_guide

    # Install/deploy AMP stack...
    deploy_amp_stack

    # Deploy composer
    deploy_composer

    # Deploy python
    deploy_python

    # Deploy new mysql user (and grant misc. priviledges)
    deploy_mysql_user

  else

    # Show contenta site deployment guide
    deployment_contenta_site_show_guide
  fi

  # Deploy contenta site
  deploy_contenta_site  
}

# Start contenta deployment
deploy_contenta



