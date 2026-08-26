#!/usr/bin/env bash
# Quick health check for AetherSOC components

set -euo pipefail

GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

ok()   { echo -e "${GREEN}[OK]${NC} $1"; }
fail() { echo -e "${RED}[FAIL]${NC} $1"; }
warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }

echo "=== AetherSOC Health Check ==="
echo ""

# Docker
if command -v docker >/dev/null 2>&1; then
  ok "Docker is installed"
else
  fail "Docker is not installed"
fi

# Containers from this compose
if docker ps --format '{{.Names}}' | grep -q "aether-dvwa"; then
  ok "DVWA container is running (port 8080)"
else
  warn "DVWA container is not running"
fi

if docker ps --format '{{.Names}}' | grep -q "aether-juice"; then
  ok "Juice Shop container is running (port 3000)"
else
  warn "Juice Shop container is not running"
fi

if docker ps --format '{{.Names}}' | grep -q "aether-suricata"; then
  ok "Suricata container is running"
else
  warn "Suricata container is not running (common on some hosts – see docs)"
fi

# Wazuh (official stack – names may vary)
if docker ps --format '{{.Names}}' | grep -qi "wazuh"; then
  ok "Wazuh-related containers are running"
else
  warn "No Wazuh containers detected – did you start the official single-node stack?"
fi

# vm.max_map_count
if [[ "$(uname)" == "Linux" ]]; then
  MAP_COUNT=$(sysctl -n vm.max_map_count 2>/dev/null || echo "0")
  if [[ "$MAP_COUNT" -ge 262144 ]]; then
    ok "vm.max_map_count is set correctly ($MAP_COUNT)"
  else
    fail "vm.max_map_count is too low ($MAP_COUNT). Run: sudo sysctl -w vm.max_map_count=262144"
  fi
fi

echo ""
echo "Health check finished."
