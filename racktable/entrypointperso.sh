#!/bin/sh -e

: "${DBNAME:=racktables}"
: "${DBHOST:=mariadb}"
: "${DBUSER:=racktables}"

if [ ! -e /opt/racktables/wwwroot/inc/secret.php ]; then
    cat > /opt/racktables/wwwroot/inc/secret.php <<EOF
<?php
\$pdo_dsn = 'mysql:host=${DBHOST};dbname=${DBNAME}';
\$db_username = '${DBUSER}';
\$db_password = '${DBPASS}';
\$user_auth_src = 'database';
\$require_local_account = TRUE;
# See https://wiki.racktables.org/index.php/RackTablesAdminGuide
function terminal_settings (\$cell, \$params)
{
	\$params[0]['protocol'] = 'telnet';
       	\$params[0]['username'] = 'root';
	\$params[0]['password'] = '${TELNETPW}';
       	\$params[0]['connect_timeout'] = 5;
}
?>
EOF
fi

chmod 0400 /opt/racktables/wwwroot/inc/secret.php
chown nobody:nogroup /opt/racktables/wwwroot/inc/secret.php

echo 'To initialize the db, first go to /?module=installer&step=5'

exec "$@"
