#!/bin/sh

#==================================================================================================================
# Generate a site specific .conf configuration in /etc/apache2/sites-available directory.
#==================================================================================================================
apache_generate_site_available_config()
{
  # Display configuration information acquired from user (and previously saved to configuration file).
  FILE="site-config.txt"

  # Get relevant information from configuration file and save to misc. variables
  file_get_key_value $FILE "SiteName" SiteName
  file_get_key_value $FILE "DocumentRoot" DocumentRoot
  file_get_key_value $FILE "ServerName" ServerName
  file_get_key_value $FILE "ServerAlias" ServerAlias
  file_get_key_value $FILE "SiteDirectory" SiteDirectory

  # Append /web to DocumentRoot and SiteDirectory
  DocumentRootWeb=$DocumentRoot"/web"
  SiteDirectoryWeb=$SiteDirectory"/web"

  # New apache site config file.
  APACHE2_SITE=$SiteName.conf

  # We use this template file to generate apache2 site configuration files.
  APACHE_SITE_TEMPLATE="../apache2/site-config-template.conf"
  cp $APACHE_SITE_TEMPLATE $APACHE2_SITE

  # Update site configuration file with information acquired from user and gleaned from system
  # These fields will be updated:
  #   DocumentRoot
  #   ServerName
  #   ServerAlias
  #   Directory
  sed -i "s#document_root#$DocumentRootWeb#g; s/server_name/$ServerName/g; s/server_alias/$ServerAlias/g; s#site_directory#$SiteDirectoryWeb#g" "$APACHE2_SITE"

  #echo_message msg_style_section "Configuration for apache2 sites-available configuration file: [$FILE]"

  # Apache sites-available directory
  APACHE2_SITES_AVAILABLE_DIR="/etc/apache2/sites-available"

  # Add the apache site configuration file to the "/etc/apache2/sites-available/" directory.
  echo_message $msg_style_section "Creating apache2 sites-available configuration file: [$APACHE2_SITES_AVAILABLE_DIR/$APACHE2_SITE]..."
  sudo cp $APACHE2_SITE $APACHE2_SITES_AVAILABLE_DIR/$APACHE2_SITE

  # Save CWD (we will return to it...)
  CWD=$PWD

  # Change to /etc/apache2/sites-available directory
  cd $APACHE2_SITES_AVAILABLE_DIR

  # Enable site.
  COMMAND="sudo a2ensite $APACHE2_SITE"
  echo_message $msg_style_section "Enabling site with: [$COMMAND]..."
  eval $COMMAND
  cd $CWD

  # This is for debugging purposes
  meld $APACHE2_SITES_AVAILABLE_DIR/$APACHE2_SITE $APACHE_SITE_TEMPLATE
}

#==================================================================================================================
# Update site ownership (i.e. to www-data). This must be done after installing contenta since the contenta 
# install process updates at the very least file "settings.php" with the user entered information for the MySQL 
# database.
#
# Warning: the contenta site account password entered by the user during the contenta deployment process is
# written in the clear to "settings.php".
#==================================================================================================================
apache_update_site_owner()
{
  local site=$1
  local command="sudo chown -R www-data:www-data $site"
  echo_message $msg_style_section "Updating site ownership with: [$command]..."
  eval $command
}
