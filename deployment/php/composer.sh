#!/bin/sh

#==================================================================================================================
# Init composer deployment
#==================================================================================================================
init_composer_deployment()
{
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

  if [ "$EXPECTED_SIGNATURE" != "$ACTUAL_SIGNATURE" ]; then
    >&2 echo 'ERROR: Invalid installer signature'
    echo "EXPECTED_SIGNATURE: [$EXPECTED_SIGNATURE]"
    echo "ACTUAL_SIGNATURE:   [$ACTUAL_SIGNATURE]"
    rm composer-setup.php
    exit 1
  fi 
}

#==================================================================================================================
# Deploy composer
#==================================================================================================================
deploy_composer()
{
  # Create bin directory (under user's home), this is where we will deploy composer.
  create_directory $HOME/bin

  # php and wget must be installed
  check_package_requirement "php"
  check_package_requirement "wget"

  # Init composer deployment
  init_composer_deployment

  # Format composer install command
  install_command="php composer-setup.php --install-dir=$install_directory --filename=$executable_name"

  exec_command "Installing composer via:" "$install_command"
}
