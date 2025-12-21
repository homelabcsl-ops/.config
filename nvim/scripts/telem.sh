#!/bin/bash
# DKS v1.6.0 Telemetry Logic
CPU=$(sysctl -n vm.loadavg | awk '{print $2}')
K8S=$(kubectl config current-context 2>/dev/null || echo "None")
echo "󰻠 CPU: $CPU | 󱠔 K8S: $K8S"
