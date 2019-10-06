#!/bin/sh

# "Include" scripts which contain (common) functionality we are going to use
. $PWD/./amp-stack.sh
. $PWD/../infrastructure/infrastructure.sh
. $PWD/../infrastructure/infrastructure.sh
. $PWD/../common/user_io/user_io.sh
. $PWD/../common/debug/debug.sh
. $PWD/../common/file_io/file_io.sh
. $PWD/../common/messaging/message.sh
. $PWD/../common/command/command.sh
. $PWD/../php/php.sh
. $PWD/../apache2/apache2.sh
. $PWD/../mariadb/mariadb.sh
. $PWD/../apache2/site-available.sh

# Install AMP (Apache2, MariaDB, PHP) stack.
install_amp_stack

