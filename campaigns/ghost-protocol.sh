#!/usr/bin/env bash
# Living Narrative Campaign: Ghost Protocol
# Longer, spaced-out activity to simulate dwell time

set -euo pipefail

TARGET_DVWA="http://localhost:8080"
TARGET_JUICE="http://localhost:3000"

echo "=============================================="
echo "  AetherSOC Campaign: GHOST PROTOCOL"
echo "  Theme: Longer dwell / multi-hour style simulation"
echo "  (Shortened version for practical lab use)"
echo "=============================================="
echo ""

echo ">>> Beacon 1 – Initial foothold check"
curl -s -o /dev/null "${TARGET_DVWA}/" || true
curl -s -o /dev/null "${TARGET_JUICE}/" || true
sleep 20

echo ">>> Beacon 2 – Light discovery"
curl -s -o /dev/null "${TARGET_DVWA}/vulnerabilities/fi/?page=include.php" || true
sleep 25

echo ">>> Beacon 3 – Credential testing"
curl -s -o /dev/null -X POST "${TARGET_DVWA}/login.php" \
  -d "username=admin&password=password&Login=Login" || true
sleep 20

echo ">>> Beacon 4 – Final staging noise"
for i in {1..3}; do
  curl -s -o /dev/null "${TARGET_JUICE}/rest/products/search?q=test" || true
  sleep 8
done

echo ""
echo "GHOST PROTOCOL completed. Investigate the spaced-out timeline."
