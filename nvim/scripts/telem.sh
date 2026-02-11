#!/bin/bash
# DKS v1.6.1 - Telemetry Persistence Patch

CPU=$(sysctl -n vm.loadavg | awk '{print $2}')
K8S=$(kubectl config current-context 2>/dev/null || echo "None")

# Clear the line and print
echo -e "\r󰻠 CPU: $CPU | 󱠔 K8S: $K8S"

# Optional: keep the process open for 2 seconds to ensure
# the dashboard renders the output before the buffer closes
sleep 2
