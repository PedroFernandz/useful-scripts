#!/bin/bash

# Check if 2 arguments have been passed
if [ "${#}" -ne 2 ]; then
    echo "Usage: ${0} <file_name> <container_value>" >&2
    exit 1
fi

# Assign the argument values to variables
file_name="${1}"
containers="${2}"

# Define the path and filename for the Logrotate configuration
logrotate_conf="./${file_name}"

# Create the Logrotate configuration file
cat << EOF > "${logrotate_conf}"
/media/efs/directory/logs/${file_name}/mail/*${containers}*/*log
/media/efs/directory/logs/${file_name}/tomcat/*${containers}*/*log
/media/efs/directory/logs/${file_name}/zabbix/*${containers}*/*log
/media/efs/directory/logs/${file_name}/elasticsearch/*${containers}*/*log
/media/efs/directory/logs/${file_name}/mongodb/*${containers}*/*log
/media/efs/directory/logs/${file_name}/samba/*${containers}*/*log
/media/efs/directory/logs/${file_name}/redis/*${containers}*/*log
/media/efs/directory/logs/${file_name}/proftpd/*${containers}*/*log
/media/efs/directory/logs/${file_name}/httpd/*${containers}*/*log
/media/efs/directory/logs/${file_name}/fpm/*${containers}*/*log
/media/efs/directory/logs/${file_name}/maribadb/*${containers}*/*log
/media/efs/directory/logs/${file_name}/laravel/*${containers}*/*log
/media/efs/directory/logs/${file_name}/ssh/*${containers}*/*log
/media/efs/directory/logs/${file_name}/zabbix/*${containers}*/*log {
    daily
    rotate 520
    dateext
    missingok
    sharedscripts
    compress
    delaycompress
    postrotate
        #send logrotate
        /media/efs/directory/${file_name}/tools/tomcat-rotate-logs.sh > /dev/null
        #archive tomcat logs
        /media/efs/directory/${file_name}/tools/tomcat-archive-logs.sh > /dev/null
        #todo: archive mail,zabbix and api logs
        rm -f /media/efs/directory/logs/${file_name}/logrotate*-20*
        date >> /media/efs/directory/logs/${file_name}/logrotate.log
    endscript
}
EOF

# Inform the user that the file has been created successfully
echo "The file ${logrotate_conf} has been created successfully."
