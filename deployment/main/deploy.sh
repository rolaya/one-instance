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
