#!/bin/bash
# DKS v1.6.0 Telemetry Script

# 1. Get CPU Load (Mac-native)
CPU=$(sysctl -n vm.loadavg | awk '{print $2}')

# 2. Get K8s Context (Safe check)
K8S=$(kubectl config current-context 2>/dev/null || echo "None")

# 3. Output as a single clean string for Neovim
echo "󰻠 CPU: $CPU | 󱠔 K8S: $K8S"
