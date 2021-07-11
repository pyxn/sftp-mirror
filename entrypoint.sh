#!/bin/sh

# ---------------------------------------------------------------------------------------------------------------------
# FUNCTIONS
# ---------------------------------------------------------------------------------------------------------------------

# Mirror entire contents of local directory to remote directory
function sftp_mirror_full() {
  echo "Initializing LFTP file transfer: Full Mirror Mode..."
  lftp ${PROTOCOL}://${HOSTNAME}:${PORT} -u ${USERNAME},${PASSWORD} -e "mirror ${ARGS} -R ${PATH_LOCAL} ${PATH_REMOTE}"
  echo "SFTP Mirror operation completed. Please verify the status of your files."
}

# Mirror a single file created in local directory to remote directory
function sftp_mirror_file_create() {

  # Create a new file with specified filename and extension
  touch "${CREATE_FILE_NAME}"
  echo "Successfully created new file with filename ${CREATE_FILE_NAME}."

  # Place specified contents into the new file
  echo "${CREATE_FILE_CONTENTS}" >${CREATE_FILE_NAME}
  echo "Successfully filled ${CREATE_FILE_NAME} with specified file contents."

  # Start LFTP Transfer of single file
  # main command option: put
  # -e          delete target file before the transfer
  # -E          delete source files after successful transfer (dangerous)
  # -a          use ascii mode (binary is the default)
  echo "Initializing LFTP file transfer: Single File Create Mirror Mode..."
  lftp ${PROTOCOL}://${HOSTNAME}:${PORT} -u ${USERNAME},${PASSWORD} -e "put -E -e -a ${CREATE_FILE_NAME} -o ${PATH_REMOTE}${CREATE_FILE_NAME}"
  echo "Successfully transferred ${CREATE_FILE_NAME} to specified directory."
  echo "SFTP Mirror operation completed. Please verify the status of your files."
}

# ---------------------------------------------------------------------------------------------------------------------
# MAIN SCRIPT
# ---------------------------------------------------------------------------------------------------------------------
set -eu
echo "SFTP Mirror"

if [ ${PROTOCOL} = "sftp" ]; then
  echo "Establishing SFTP connection..."
  sshpass -p ${PASSWORD} sftp -o StrictHOSTKeyChecking=no -P ${PORT} ${USERNAME}@${HOSTNAME}
  echo "Connecting to PORT ${PORT} via SFTP..."
else
  echo "Establishing FTP connection..."
  PORT=${PORT:-"21"}
  echo "Connecting to PORT ${PORT} via FTP..."
fi

case ${MODE} in
mirror_full)
  sftp_mirror_full
  ;;
mirror_file_create)
  sftp_mirror_file_create
  ;;
*)
  sftp_mirror_full
  ;;
esac

exit 0
