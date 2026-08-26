#!/usr/bin/env bash
# Living Narrative Campaign: Silent Ledger
# Theme: Insider-style / low-and-slow activity

set -euo pipefail

TARGET_DVWA="http://localhost:8080"
TARGET_JUICE="http://localhost:3000"

echo "=============================================="
echo "  AetherSOC Campaign: SILENT LEDGER"
echo "  Theme: Low-and-slow / insider-style activity"
echo "=============================================="
echo ""

echo ">>> STAGE 1: Quiet authentication attempts"
for i in {1..6}; do
  curl -s -o /dev/null -X POST "${TARGET_DVWA}/login.php" \
    -d "username=admin&password=wrongpass${i}&Login=Login" || true
  sleep 4
done

echo ">>> STAGE 2: Data access patterns"
curl -s -o /dev/null "${TARGET_DVWA}/vulnerabilities/sqli/?id=1&Submit=Submit" || true
sleep 10
curl -s -o /dev/null "${TARGET_JUICE}/rest/products/search?q=apple" || true
sleep 8

echo ">>> STAGE 3: Repeated low-volume access"
for i in {1..4}; do
  curl -s -o /dev/null "${TARGET_DVWA}/" || true
  curl -s -o /dev/null "${TARGET_JUICE}/" || true
  sleep 6
done

echo ""
echo "SILENT LEDGER finished. Review slow, repeated patterns in your SIEM."
