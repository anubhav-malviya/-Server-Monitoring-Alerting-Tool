#!/bin/bash
trap "echo 'Exiting dashboard...'; exit 0" SIGINT

while true; do
    clear
    TIMESTAMP=$(date "+%Y-%m-%d %H:%M:%S")
    CPU_IDLE=$(top -bn1 | awk -F',' '/Cpu\(s\)/ {print $4}' | awk '{print $1}')
    CPU_USAGE=$(awk "BEGIN {printf \"%.2f\", 100 - $CPU_IDLE}")

    read TOTAL_MEM USED_MEM FREE_MEM <<< $(free -m | awk '/Mem:/ {print $2, $3, $4}')
    MEM_PERCENT=$(awk "BEGIN {printf \"%.2f\", ($USED_MEM/$TOTAL_MEM)*100}")

    DISK_USAGE=$(df -h --total | awk '/total/ {print $5}')
    LOAD_AVG=$(uptime | awk -F'load average:' '{print $2}')

    echo "======================================"
    echo "     SERVER PERFORMANCE DASHBOARD"
    echo "======================================"
    echo "Time: $TIMESTAMP"
    echo ""
    echo "CPU Usage     : $CPU_USAGE %"
    echo "Memory Usage  : $MEM_PERCENT %"
    echo "Disk Usage    : $DISK_USAGE"
    echo "Load Average  : $LOAD_AVG"
    echo ""
    echo "Top Processes (CPU):"
    ps -eo pid,cmd,%cpu --sort=-%cpu | head -6
    echo ""
    echo "Top Processes (Memory):"
    ps -eo pid,cmd,%mem --sort=-%mem | head -6
    sleep 10
done
