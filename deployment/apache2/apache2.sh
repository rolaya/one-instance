#!/bin/sh

#==================================================================================================================
# 
#==================================================================================================================
apache_server_reload()
{
  # Reload apache2 server.
  COMMAND="sudo systemctl reload apache2"
  echo_message $msg_style_section "Reloading apache server with: [$COMMAND]..."
  eval $COMMAND
}
