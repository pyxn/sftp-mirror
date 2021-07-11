# SFTP-Mirror

Github Action: Mirror files between a remote and local server via FTP/SFTP through the LFTP command after a commit is pushed into a remote repository.

Sample GitHub action using the two available modes:
```yaml
name: Github Action - SFTP Mirror
on:
  push:
    branches:    
      - main
jobs:
  SFTP-Mirror:
    name: SFTP Mirror
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@master

    - name: SFTP Mirror (Full)
      uses: pyxn/sftp-mirror@v.2.0.0
      env:
        HOSTNAME: ${{ secrets.HOSTNAME }}
        USERNAME: ${{ secrets.USERNAME }}
        PASSWORD: ${{ secrets.PASSWORD }}
        PATH_LOCAL: "./public_html/"
        PATH_REMOTE: "./website.com/public_html/"
        PROTOCOL: sftp
        PORT: 22
        ARGS: --verbose --delete
        MODE: mirror_full

    - name: SFTP Mirror (File Create)
      uses: pyxn/sftp-mirror@v.2.0.0
      env:
        HOSTNAME: ${{ secrets.HOSTNAME }}
        USERNAME: ${{ secrets.USERNAME }}
        PASSWORD: ${{ secrets.PASSWORD }}
        PATH_REMOTE: "./website.com/"
        PROTOCOL: sftp
        PORT: 22
        MODE: mirror_file_create
        CREATE_FILE_NAME: "config.ini"
        CREATE_FILE_CONTENTS: "Hello, \nWorld!"
```
