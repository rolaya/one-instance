#!/bin/sh

#==================================================================================================================
# Get the value of a configuration item (as defined in file "site-config.txt").
#==================================================================================================================
get_site_config_value()
{
  local var_reference=$1
  local config_value=""

  # For now, we are always using a "generic" file which is re-generated for every deployment.
  local config_file=site-config.txt

  # Set to true to get debug messages
  local debug=true

  if [ $debug = true ]; then
    # Display configuration item we are looking for
    echo "Looking for site configuration item: [$1] in file: [$config_file]"
  fi

  # The file we created has format field=value, set the delimeter
  IFS="="

  # Read all lines from site configuration file
  while read f1 f2
  do
    if [ $debug = true ]; then
      echo "$f1=$f2"
    fi

    case $f1 in

      $1)
        config_value=$f2
        break
        ;;

      *)
      ;;
    esac
  done < $config_file

  if [ $debug = true ]; then
    echo "Item: [$1] value: [$config_value]"
  fi

  # Update variable reference
  eval $var_reference="'$config_value'" 
}

#==================================================================================================================
# Deploy contenta installation environment (.env*) configuration files.
#==================================================================================================================
deploy_contenta_installation_configuration()
{
  echo_message $msg_style_block "Deploying contenta \".env\",  \".env.local\" configuration files to: [$SiteDirectory]"
  cp $SITE_CONFIG_DIR/.env $SiteDirectory
  cp $SITE_CONFIG_DIR/.env.local $SiteDirectory
}

#==================================================================================================================
# Collect site configuration information.
#==================================================================================================================
collect_site_information()
{
  # Acquiring host name and IP address
  echo_message $msg_style_section "Acquiring this host's name and IP address (requires sudo)..."

  # Get host's IP address (got this from the web... Need to understand better)
  Site_ServerName=$(sudo ifconfig | sed -En 's/127.0.0.1//;s/.*inet (addr:)?(([0-9]*\.){3}[0-9]*).*/\2/p')

  # Get the name of the host where this script is executing
  HOST_NAME=$(cat /proc/sys/kernel/hostname)

  # Inform user what we are about to do....
  echo_message $msg_style_section "Hostname:   [$HOST_NAME]..."
  echo_message $msg_style_section "IP address: [$Site_ServerName]..."

  #################################################################################################
  # MariaDB and contenta configuration related information.
  #################################################################################################

  # These values are used to generate the .env and .env.local contenta deployment files
  user_input_request "Site Name" "contenta" SiteName
  user_input_request "Site Email" "admin@$HOST_NAME.com" SiteEmail
  user_input_request "Site Account Name" "$USER" AccountName
  user_input_request_password "Site Account Password" AccountPassword
  user_input_request "Account Email" "$USER@$HOST_NAME.com" UserEmail
  user_input_request "Mysql Host Name" "localhost" MysqlHostName
  user_input_request "Mysql Port Number" "3306" MysqlPortNumber

  # Get the database name (to be created).
  user_input_request "MariaDB Database Name" "$SiteName" DatabaseName

  # Get the database user (to be created).
  user_input_request "MariaDB Database User" "$USER" DatabaseUser
  user_input_request_password "MariaDB Database User Password" DatabaseUserPassword

  # Save current working directory
  CURRENT_DIR=$PWD

  # Create site specific configuration directory (can be deleted anytime after deployment)
  SITE_CONFIG_DIR=$PWD/../config/generated-site/$HOST_NAME.$Site_ServerName.$SiteName
  mkdir -p $SITE_CONFIG_DIR
  cd $SITE_CONFIG_DIR

  # The site config directory is "cleaner" (i.e. removed ../)
  SITE_CONFIG_DIR="$PWD"

  # Return to previous working directory
  cd $CURRENT_DIR

  # This is where we expect the .env template file
  SITE_ENV_TEMPLATE="../contenta/.env"

  # Create a temp .env configuration file
  SITE_ENV_FILE="$SITE_CONFIG_DIR/.env"
  cp $SITE_ENV_TEMPLATE $SITE_ENV_FILE

  # Update .env file
  sed -i "s/site_mail/$SiteEmail/g;               \
          s/account_mail/$UserEmail/g;            \
          s/site_name/$SiteName/g;                \
          s/account_name/$AccountName/g;         \
          s/mysql_database/$DatabaseName/g;       \
          s/mysql_localhostname/$MysqlHostName/g; \
          s/mysql_port/$MysqlPortNumber/g;        \
          s/mysql_user/$DatabaseUser/g;"          \
          "$SITE_ENV_FILE"

  # This is where we expect the .env.local template file
  SITE_ENV_LOCAL_TEMPLATE="../contenta/.env.local"

  # Create a temp .env.local configuration file
  SITE_ENV_LOCAL_FILE="$SITE_CONFIG_DIR/.env.local"
  cp $SITE_ENV_LOCAL_TEMPLATE $SITE_ENV_LOCAL_FILE

  # Update .env.local file
  sed -i "s/account_password/$AccountPassword/g; s/mysql_password/$DatabaseUserPassword/g;" "$SITE_ENV_LOCAL_FILE"

  #################################################################################################
  # /etc/apache2/sites-available configuration file related information.
  #################################################################################################

  # Get the document root
  user_input_request "Enter DocumentRoot" "$HOME/proj/www/drupal/contenta/$SiteName" DocumentRoot

  # Get the server alias
  user_input_request "Enter ServerAlias" "${HOST_NAME}.${SiteName}" ServerAlias

  # Get the directory
  user_input_request "Enter Site Directory" "$HOME/proj/www/drupal/contenta/$SiteName" SiteDirectory

  # Generate deployment configuration file (with information acquired from user)
  SITE_CONFIG_FILE="$SITE_CONFIG_DIR/$SiteName.txt"
  cp site-config-template.txt $SITE_CONFIG_FILE

  # Update deployment configuration file with user entered input (and information gleaned from the running system)
  sed -i "s/site_name/$SiteName/g;             \
          s#document_root#${DocumentRoot}#g;   \
          s/server_name/$Site_ServerName/g;    \
          s/server_alias/$ServerAlias/g;       \
          s#site_directory#${SiteDirectory}#g; \
          s/database_name/$DatabaseName/g;     \
          s/database_user/$DatabaseUser/g;"    \
          "$SITE_CONFIG_FILE"

  # Make a backup of the configuration file
  GENERIC_SITE_CONFIG_FILE=site-config.txt
  cp $SITE_CONFIG_FILE $GENERIC_SITE_CONFIG_FILE 

  # Inform user what have done....
  echo_message $msg_style_block "Generated contenta site configuration file [$SITE_CONFIG_FILE]..."

  # Display site's configured values (this is informational only)
  file_show_key_value_pairs $SITE_CONFIG_FILE "Site configuration file:"
}
