#!/bin/bash
#
# Backup of ghost
#
filename="ghost_backup_"$(date +%F_%H:%M)".tar.gz"
echo "backup to $filename"
tar czvf /backups/$filename /var/lib/ghost
chown -R user:user /backups/$filename