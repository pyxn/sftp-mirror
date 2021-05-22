#!/bin/sh

set -eu
echo "SFTP Mirror"

SELECTED_PROTOCOL=${PROTOCOL:-"ftp"}
SELECTED_ARGS=${ARGS:-""}

SELECTED_PATH_LOCAL=${PATH_LOCAL:-"."}
SELECTED_PATH_REMOTE=${PATH_REMOTE:-"."}

if [ $SELECTED_PROTOCOL = "sftp" ]
then
  SELECTED_PORT=${PORT:-"22"}
  echo "Establishing SFTP connection..."
  sshpass -p $PASSWORD sftp -o StrictHOSTKeyChecking=no -P $SELECTED_PORT $USERNAME@$HOSTNAME
  echo "Connecting to PORT $SELECTED_PORT via SFTP..."
else
  echo "Establishing FTP connection..."
  SELECTED_PORT=${PORT:-"21"}
  echo "Connecting to PORT $SELECTED_PORT via FTP..."
fi;

echo "Initializing LFTP file transfer..."
lftp $SELECTED_PROTOCOL://$HOSTNAME:$SELECTED_PORT -u $USERNAME,$PASSWORD -e "mirror $SELECTED_ARGS -R $SELECTED_PATH_LOCAL $SELECTED_PATH_REMOTE; quit"

echo "SFTP Mirror operation completed. Please verify the status of your files."
exit 0