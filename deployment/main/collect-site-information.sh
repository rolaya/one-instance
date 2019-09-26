#!/bin/sh

# "Include" scripts which contain functions we are going to use.
. $PWD/../common/messaging/message.sh
. $PWD/../common/user_io/user_io.sh
. $PWD/../common/file_io/file_io.sh

# Gererating drupal/contenta site configuration....
echo_message $msg_type_block "Generating drupal/contenta site configuration information..."

# Acquiring host name and IP address
echo_message $msg_type_section "Acquiring this host's name and IP address (requires sudo)..."

# Get host's IP address (got this from the web... Need to understand better)
Site_ServerName=$(sudo ifconfig | sed -En 's/127.0.0.1//;s/.*inet (addr:)?(([0-9]*\.){3}[0-9]*).*/\2/p')

# Get the name of the host where this script is executing
HOST_NAME=$(cat /proc/sys/kernel/hostname)

# Inform user what we are about to do....
echo_message $msg_type_section "Hostname:   [$HOST_NAME]..."
echo_message $msg_type_section "IP address: [$Site_ServerName]..."

#################################################################################################
# MariaDB and contenta configuration related information.
#################################################################################################

# Get the site name
user_input_request "Enter Site Name" "contenta" SiteName

# Get the database name (to be created).
user_input_request "Enter MariaDB database name" "$SiteName" DatabaseName

# Get the database user (to be created).
user_input_request "Enter MariaDB database user" "$USER" DatabaseUser

# These values and some of the above values are used to generate the .env and .env.local contenta deployment files
user_input_request "Site Email" "admin@$HOST_NAME.com" SiteEmail
user_input_request "Account Email" "$USER@$HOST_NAME.com" UserEmail
user_input_request "Mysql Host Name" "localhost" MysqlHostName
user_input_request "Mysql Port Number" "3306" MysqlPortNumber

# Save current working directory
CURRENT_DIR=$PWD

# Create site specific configuration directory (can be deleted anytime after deployment)
SITE_CONFIG_DIR=$PWD/../config/$HOST_NAME.$Site_ServerName.$SiteName
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
        s/account_name/$DatabaseUser/g;         \
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
#sed -i "s/site_mail/$SiteEmail/g;               \
#        s/account_mail/$UserEmail/g;            \
#        s/site_name/$SiteName/g;                \
#        s/account_name/$DatabaseUser/g;         \
#        s/mysql_database/$DatabaseName/g;       \
#        s/mysql_localhostname/$MysqlHostName/g; \
#        s/mysql_port/$MysqlPortNumber/g;        \
#        s/mysql_user/$DatabaseUser/g;"          \
#        "$SITE_ENV_FILE"

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
echo_message $msg_type_block "Generated contenta site configuration file [$SITE_CONFIG_FILE]..."

# Display site's configured values
file_show_key_value_pairs $SITE_CONFIG_FILE "Site configuration file:"





