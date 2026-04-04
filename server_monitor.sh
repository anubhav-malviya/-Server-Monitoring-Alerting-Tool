#!/bin/bash

# ============================
# Server Monitoring Script
# ============================

# ============================
# DEFAULT CONFIG (fallback)
# ============================
CSV_FILE="/var/log/server_stats.csv"
ALERT_EMAIL="<youremail>@gmail.com"
CPU_THRESHOLD=80
MEM_THRESHOLD=80
DISK_THRESHOLD=90
ALERT_COOLDOWN=300
INTERVAL=5

# ============================
# LOAD EXTERNAL CONFIG
# ============================
CONFIG_FILE="/etc/server-monitor.conf"

if [ -f "$CONFIG_FILE" ]; then
    source "$CONFIG_FILE"
fi

# ============================
# CREATE CSV FILE IF NOT EXISTS
# ============================
if [ ! -f "$CSV_FILE" ]; then
    echo "Timestamp,CPU_Usage,Memory_Usage,Disk_Usage,Load_Average,Top_CPU_Process,Top_MEM_Process" > "$CSV_FILE"
fi

# ============================
# FUNCTION: GET METRICS
# ============================
get_metrics() {
    TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

    CPU_USAGE=$(top -bn1 | grep "Cpu(s)" | awk '{print 100 - $8}' | awk '{printf("%.2f",$1)}')

    MEM_PERCENT=$(free | awk '/Mem:/ {printf("%.2f"), $3/$2 * 100}')

    DISK_USAGE=$(df / --total | awk '/total/ {print $5}' | tr -d '%')

    LOAD_AVG=$(uptime | awk -F'load average:' '{print $2}' | awk '{$1=$1;print}')

    TOP_CPU_PROC=$(ps -eo cmd,%cpu --sort=-%cpu | sed -n '2p')

    TOP_MEM_PROC=$(ps -eo cmd,%mem --sort=-%mem | sed -n '2p')
}

# ============================
# FUNCTION: SEND ALERT
# ============================
send_alert() {
    CURRENT_TIME=$(date +%s)
    LAST_ALERT_TIME=0
    [ -f "/tmp/server_monitor_last_alert" ] && LAST_ALERT_TIME=$(cat /tmp/server_monitor_last_alert)

    if (( CURRENT_TIME - LAST_ALERT_TIME < ALERT_COOLDOWN )); then
        return
    fi

    MESSAGE="Subject: ⚠️ Server Alert - High Resource Usage
To: $ALERT_EMAIL

⚠️ Server Alert!

Time: $TIMESTAMP
CPU Usage: $CPU_USAGE%
Memory Usage: $MEM_PERCENT%
Disk Usage: $DISK_USAGE%
Load Average: $LOAD_AVG
Top CPU Process: $TOP_CPU_PROC
Top MEM Process: $TOP_MEM_PROC
"

    echo "$MESSAGE" | sudo msmtp --from=default -t "$ALERT_EMAIL"

    echo "$CURRENT_TIME" > /tmp/server_monitor_last_alert
    echo "$TIMESTAMP ALERT: CPU=$CPU_USAGE MEM=$MEM_PERCENT DISK=$DISK_USAGE" >> /var/log/server_alerts.log
}

# ============================
# MAIN LOOP
# ============================
while true; do
    get_metrics

    echo "$TIMESTAMP,$CPU_USAGE,$MEM_PERCENT,$DISK_USAGE,\"$LOAD_AVG\",\"$TOP_CPU_PROC\",\"$TOP_MEM_PROC\"" >> "$CSV_FILE"

    (( $(echo "$CPU_USAGE > $CPU_THRESHOLD" | bc -l) )) && send_alert
    (( $(echo "$MEM_PERCENT > $MEM_THRESHOLD" | bc -l) )) && send_alert
    (( $(echo "$DISK_USAGE > $DISK_THRESHOLD" | bc -l) )) && send_alert

    sleep "$INTERVAL"
done
