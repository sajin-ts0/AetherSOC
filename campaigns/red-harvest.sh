#!/usr/bin/env bash
# Living Narrative Campaign: Red Harvest
# Multi-stage story that generates realistic SOC telemetry over time
# Designed to be simple, reliable, and safe (only hits local containers)

set -euo pipefail

TARGET_DVWA="http://localhost:8080"
TARGET_JUICE="http://localhost:3000"
DELAY_SHORT=15
DELAY_MEDIUM=30
DELAY_LONG=45

echo "=============================================="
echo "  AetherSOC Campaign: RED HARVEST"
echo "  Theme: External attacker → web app compromise"
echo "=============================================="
echo ""

stage() {
  local num="$1"
  local title="$2"
  echo ""
  echo ">>> STAGE ${num}: ${title}"
  echo "    $(date '+%Y-%m-%d %H:%M:%S')"
}

pause() {
  local sec="$1"
  echo "    Waiting ${sec}s before next stage..."
  sleep "$sec"
}

# ---------- STAGE 1: Reconnaissance ----------
stage 1 "Reconnaissance & Noise"
echo "    Generating scanning-style requests against targets..."

# Simple recon traffic that Suricata/Wazuh can observe
for i in {1..8}; do
  curl -s -o /dev/null -w "%{http_code}" "${TARGET_DVWA}/" || true
  curl -s -o /dev/null "${TARGET_JUICE}/" || true
  curl -s -o /dev/null "${TARGET_DVWA}/login.php" || true
  sleep 2
done

pause $DELAY_SHORT

# ---------- STAGE 2: Initial Access Attempts ----------
stage 2 "Initial Access Attempts (DVWA)"
echo "    Simulating common web attack patterns..."

# These are safe, non-destructive probes that still generate interesting logs
curl -s -o /dev/null "${TARGET_DVWA}/vulnerabilities/sqli/?id=1' OR '1'='1&Submit=Submit" || true
curl -s -o /dev/null "${TARGET_DVWA}/vulnerabilities/xss_r/?name=<script>alert(1)</script>" || true
curl -s -o /dev/null -X POST "${TARGET_DVWA}/login.php" \
  -d "username=admin&password=password&Login=Login" || true

pause $DELAY_MEDIUM

# ---------- STAGE 3: Juice Shop Activity ----------
stage 3 "Juice Shop Exploration & Abuse Patterns"
echo "    Hitting common Juice Shop endpoints..."

curl -s -o /dev/null "${TARGET_JUICE}/rest/products/search?q=qwert'" || true
curl -s -o /dev/null "${TARGET_JUICE}/api/Users" || true
curl -s -o /dev/null "${TARGET_JUICE}/ftp" || true
curl -s -o /dev/null "${TARGET_JUICE}/rest/user/login" || true

pause $DELAY_MEDIUM

# ---------- STAGE 4: Persistence / Staging Simulation ----------
stage 4 "Post-Exploitation Style Noise"
echo "    Generating additional mixed traffic to simulate dwell..."

for i in {1..5}; do
  curl -s -o /dev/null "${TARGET_DVWA}/" || true
  curl -s -o /dev/null "${TARGET_JUICE}/" || true
  sleep 3
done

echo ""
echo "=============================================="
echo "  RED HARVEST campaign stages completed."
echo "  Check Wazuh dashboard and Suricata logs now."
echo "=============================================="
