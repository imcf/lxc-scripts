#!/bin/bash

set -e

if [ -z "$MYSQL_ROOTPW" ] ; then
    echo "Missing environment variable 'MYSQL_ROOTPW', stopping!"
    exit
fi

mysql --user root --password="$MYSQL_ROOTPW" \
  --execute="CREATE DATABASE testdb CHARACTER SET utf8;
             CREATE USER 'testuser'@'localhost' IDENTIFIED BY 'dbpasswd';
             GRANT ALL ON testdb.* to 'testuser'@'localhost';"
