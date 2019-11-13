#!/bin/sh

# "Include" scripts which contain (common) functionality we are going to use
. $PWD/../infrastructure/infrastructure.sh
. $PWD/../common/user_io/user_io.sh
. $PWD/../common/debug/debug.sh
. $PWD/../common/file_io/file_io.sh
. $PWD/../common/messaging/message.sh
. $PWD/../common/command/command.sh
. $PWD/../php/php.sh
. $PWD/../php/contenta-download.sh
. $PWD/../apache2/apache2.sh
. $PWD/../mariadb/mariadb.sh
. $PWD/../apache2/site-available.sh
. $PWD/../contenta/contenta.sh
. $PWD/../contenta/site-config.sh

#==================================================================================================================
# Deploy contenta site
#==================================================================================================================
deploy_contenta_site()
{
  # Gererating drupal/contenta site configuration....
  echo_message $msg_level_info $msg_style_block "Generating contenta site configuration information..."

  # Used configuration file for deployment (instead of interactive)
  if [ $deploy_via_config_file = false ]; then
    # Collect drupal/contenta site information. The information acquired from the user and the running system
    # is written to a number of configuration files which the deployment process/scripts utilize.
    collect_site_information
  else
    echo_message $msg_level_info $msg_style_error "File driven deployment not supported (yet)!"
    exit 1
  fi

  # Get site directory
  get_site_config_value SiteDirectory

  # Get database name
  get_site_config_value DatabaseName

  # Get database user
  get_site_config_value DatabaseUser

  # rolaya: the site directoty is created by the contenta download process... check here if it already exists
  # Check if directory exists
  #if [ -d "$SiteDirectory" ]; then
  #  echo "Warning, directory: [$SiteDirectory] already exists"
  #else
  #  echo "Creating directory: [$SiteDirectory]..."
  #  mkdir -p $SiteDirectory
  #fi

  # Get database user
  get_site_config_value SiteDirectory

  # Create mariadb database and database user.
  echo_message $msg_level_info $msg_style_block "Creating Contenta MariaDB database: [$DatabaseName] and database user: [$DatabaseUser]..."

  # Create site database (and grant user permissions to database) rolaya: need to check result of this operation...
  python ../mariadb/init-database-for-contenta-deployment.py -d $DatabaseName -u $DatabaseUser

  # Download contenta
  download_contenta -d $SiteDirectory

  # Now copy the .env and .env.local configuration files we have generated in the background to the "final" location
  # required by the contenta install.
  deploy_contenta_installation_configuration

  # Generate apache2 sites-available site specific configuration file
  apache_generate_site_available_config

  # Reload apache server
  apache_server_reload

  # Install contenta (using composer)
  contenta_install $SiteDirectory

  # Update site owner to www-data
  apache_update_site_owner $SiteDirectory
}

