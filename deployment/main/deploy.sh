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

#==================================================================================================================
# 
#==================================================================================================================
deployment_show_guide()
{
  local guide_item

  echo "${TEXT_FG_MAGENTA}=====================================================================================================================================================${TEXT_VIEW_RESET}"

  guide_item="Contenta deployment "
  echo "${TEXT_FG_MAGENTA}${TEXT_SET_ATTR_ITALIC}$guide_item${TEXT_VIEW_RESET}"
  echo ""
  guide_item="This process installs infrastructure required for Contenta"
  echo "${TEXT_FG_MAGENTA}${TEXT_SET_ATTR_ITALIC}$guide_item${TEXT_VIEW_RESET}"
  guide_item="and gathers information from the user for deploying Contenta site"
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

  guide_item="4. Creates MariaDB user with privileges to create users and databases"
  echo "${TEXT_FG_MAGENTA}${TEXT_SET_ATTR_ITALIC}$guide_item${TEXT_VIEW_RESET}" 

  guide_item="5. Collects Contenta site (to be created) information"
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

  guide_item="   5.6. Contenta site MariaDB database name"
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
