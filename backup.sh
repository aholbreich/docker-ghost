#!/bin/bash
#
# BAckup of ghost
#
tar czvf /backups/ghost_backup_$(date +%F_%H:%M).tar.gz /var/lib/ghost