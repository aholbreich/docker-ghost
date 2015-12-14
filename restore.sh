#!/bin/bash
# Restore script
#  
# Provide backup file
#
cd /var/lib/ghost 
echo "Trying to Restore from $1"
tar xzvf /backups/$1