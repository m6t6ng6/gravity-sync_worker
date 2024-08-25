#!/usr/bin/bash

echo "gravity-sync_worker.sh started !!" > /dev/kmsg

AUX=$(echo $(date +%b-%d-%Y_%HH%MM)"-ART")
DATE=${AUX^^}
IP=$(hostname -f | column -t -s "." | awk '{print $1}')"-"$(ip -4 -br a | grep -i "eth0\|vmbr0" | awk '{print $3}' | column -t -s "/" | awk '{print $1}')

/etc/gravity-sync/gravity-sync compare
sleep 20
/etc/gravity-sync/gravity-sync

JSON_SUCCESS=$(echo '{ "timestamp": "'"$DATE"'", "target_system": "'"$IP"'", "cli_message": "GRAVITY-SYNC COMPLETED" }')

echo "gravity-sync_worker.sh completed !!" > /dev/kmsg
curl -sS -X POST -H "Content-Type: application/json" -d "$(echo $JSON_SUCCESS)" "https://x.matanga.com.ar/backup_message"