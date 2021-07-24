#!/bin/sh

# ---------------------------------------------------------------------------------------------------------------------
# FUNCTIONS
# ---------------------------------------------------------------------------------------------------------------------

# Mirror entire contents of local directory to remote directory
function mirror_upload_full() {
  echo "Initializing LFTP file transfer: Full Mirror Mode..."
  lftp ${PROTOCOL}://${HOSTNAME}:${PORT} -u ${USERNAME},${PASSWORD} -e "mirror ${ARGS} -R ${PATH_LOCAL} ${PATH_REMOTE}"
  echo "SFTP Mirror operation completed. Please verify the status of your files."
}

# Mirror a single file created in local directory to remote directory
function mirror_upload_file_create() {

  # Create a new file with specified filename and extension and contents
  echo "${CREATE_FILE_CONTENTS}" >${FILE_NAME}
  echo "Successfully created new file with filename ${FILE_NAME}."

  # Start LFTP Transfer of single file
  # main command option: -f FILE mirror a single file to the directory
  echo "Initializing LFTP file transfer: Single File Create Mirror Mode..."
  lftp ${PROTOCOL}://${HOSTNAME}:${PORT} -u ${USERNAME},${PASSWORD} -e "mirror -f ${FILE_NAME} ${ARGS} -R ${PATH_LOCAL} ${PATH_REMOTE}"
  echo "Successfully transferred ${FILE_NAME} to specified directory."
  echo "SFTP Mirror operation completed. Please verify the status of your files."
}

# ---------------------------------------------------------------------------------------------------------------------
# MAIN SCRIPT
# ---------------------------------------------------------------------------------------------------------------------
set -eu
echo "SFTP Mirror"

# Connect using SFTP if specified, else use FTP
if [ ${PROTOCOL} = "sftp" ]; then
  echo "Establishing SFTP connection..."
  sshpass -p ${PASSWORD} sftp -o StrictHOSTKeyChecking=no -P ${PORT} ${USERNAME}@${HOSTNAME}
  echo "Connecting to PORT ${PORT} via SFTP..."
else
  echo "Establishing FTP connection..."
  PORT=${PORT:-"21"}
  echo "Connecting to PORT ${PORT} via FTP..."
fi

# Use a different function depending on specified mode
case ${MODE} in
mirror_upload_full)
  mirror_upload_full
  ;;
mirror_upload_file_create)
  mirror_upload_file_create
  ;;
*)
  echo "No mode specified. Mirror operation aborted."
  echo "  Please select between: "
  echo "    - mirror_upload_full"
  echo "    - mirror_upload_file_create"
  ;;
esac

exit 0
