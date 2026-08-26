#!/usr/bin/env bash
# AetherSOC Living Narrative Campaign Runner
# Simple, reliable, no external dependencies beyond bash + curl/wget if needed

set -euo pipefail

CAMPAIGN="${1:-}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"
CAMPAIGNS_DIR="${ROOT_DIR}/campaigns"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

usage() {
  echo "Usage: $0 <campaign-name>"
  echo ""
  echo "Available campaigns:"
  for f in "${CAMPAIGNS_DIR}"/*.sh; do
    [[ -f "$f" ]] && basename "$f" .sh
  done
  echo ""
  echo "Example: $0 red-harvest"
  exit 1
}

if [[ -z "$CAMPAIGN" ]]; then
  usage
fi

CAMPAIGN_FILE="${CAMPAIGNS_DIR}/${CAMPAIGN}.sh"

if [[ ! -f "$CAMPAIGN_FILE" ]]; then
  echo -e "${RED}[!] Campaign not found: ${CAMPAIGN}${NC}"
  usage
fi

echo -e "${GREEN}[*] Starting Living Narrative Campaign: ${CAMPAIGN}${NC}"
echo -e "${YELLOW}[*] Make sure DVWA (http://localhost:8080) and Juice Shop (http://localhost:3000) are running.${NC}"
echo -e "${YELLOW}[*] Wazuh dashboard should be available at https://localhost${NC}"
echo ""

# shellcheck source=/dev/null
source "$CAMPAIGN_FILE"

echo -e "${GREEN}[*] Campaign '${CAMPAIGN}' finished.${NC}"
echo -e "${GREEN}[*] Now investigate the alerts in Wazuh and Suricata logs.${NC}"
