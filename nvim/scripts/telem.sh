#!/bin/bash

# DKS Telemetry
# Context: Mac Mini 2025 // DevOps Training

# 1. Get Uptime
UPTIME=$(uptime | awk -F'( |,|:)+' '{print $6 "h " $7 "m"}')

# 2. Get Date/Time (for 11pm check)
NOW=$(date +"%H:%M")

# 3. Simple Countdown (Adjust date to your exam target)
TARGET_DATE="2026-06-01"
DAYS_LEFT=$((($(date -d "$TARGET_DATE" +%s) - $(date +%s)) / 86400))

echo "  ----------------------------------------"
echo "  🕒 TIME: $NOW   |   ⚡ UPTIME: $UPTIME"
echo "  🎯 FOCUS: LFCS & Cloud Resume Challenge"
echo "  📅 EXAM TARGET: $DAYS_LEFT Days Remaining"
echo "  ----------------------------------------"
