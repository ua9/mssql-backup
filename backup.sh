#!/bin/sh

scriptdir=$(cd `dirname $0` && pwd && cd $OLDPWD)/
. ${scriptdir}/creds.sh

backup_type=DIFFERENTIAL
if [ $(date +%u) -eq 7 ]
then
  backup_type=INIT
fi

file_name=${db_name}-${backup_type}-$(date --iso-8601).bak
sql="BACKUP DATABASE [${db_name}] TO DISK = \
  '${samba_folder_path}/${file_name}' WITH ${backup_type}"

sqlcmd -U $user -P "$pass" -S $server -Q "$sql" && \
bzip2 -z9 /backup/$file_name && \
ftp -n $ftp_host <<EOD && rm /backup/${file_name}.bz2
quote USER $ftp_user
quote PASS $ftp_pass
cd home/data-backup
put /backup/${file_name}.bz2 ${file_name}.bz2
quit
EOD
