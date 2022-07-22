#!/bin/bash
#Use this config to dump the config.php
set -e

#Location on EFS
APPETC=/shared/magento/app/etc
#Location of the Magnento installation
MAGENTOBIN=/var/www/html/bin/magento

#Config names
CONFPHP=$APPETC/env.php
ENVPHP=$APPETC/config.php

#Unique filenames for backups
ENVBACKUPNAME=$(date '+%Y%m%d%H%M%S')-backup-env.php
CONFIGBACKUPNAME=$(date '+%Y%m%d%H%M%S')-backup-config.php

if [[ -f $CONFPHP && -f $ENVPHP ]] ; then
  echo "Creating config backup..."
  cd $APPETC && \
  cp config.php $CONFIGBACKUPNAME && \
  cp env.php $ENVBACKUPNAME
  echo "Dumping config..."
  php $MAGENTOBIN app:config:dump
  echo "Restoring original configs..."
  cd $APPETC && \
  mv config.php /root/ && \
  mv env.php /root/ && \
  mv $CONFIGBACKUPNAME config.php && \
  mv $ENVBACKUPNAME env.php && \
  echo "Configs restored, reimporting original config file..."
  php $MAGENTOBIN app:config:import
  chown -R nginx:nginx $APPETC
  echo "Done !"
  echo "Config files are in /root/config.php and /root/env.php"
else
  echo "One of the config files are missing. Bye"
  exit 1
fi

