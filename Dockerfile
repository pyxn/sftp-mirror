FROM alpine:latest

LABEL "com.github.actions.name"="SFTP Mirror"
LABEL "com.github.actions.description"="Mirror your website with FTP/SFTP"
LABEL "com.github.actions.icon"="upload-cloud"
LABEL "com.github.actions.color"="blue"

RUN apk update
RUN apk add openssh sshpass lftp

COPY entrypoint.sh /entrypoint.sh
RUN chmod 777 entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]