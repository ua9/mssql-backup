FROM anovmari/mssql-client
MAINTAINER Anton Marianov <anovmari@gmail.com>
ADD backup.sh /sh/backup.sh
ADD creds.sh /sh/creds.sh
RUN apt-get -y update && \
  apt-get -y install ftp bzip2 && \
  apt-get -y clean && \
  rm -rf /var/lib/apt/lists/* /tmp/*
ENTRYPOINT ["/sh/backup.sh"]

