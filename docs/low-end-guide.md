# Low-End Computer / Low-End PC Guide for AetherSOC

This lab was built specifically so people with older or low-spec machines can still practice real SOC skills.

## Recommended Minimum

- 8 GB RAM (6 GB can work with reduced components)
- Dual-core or better CPU
- 30+ GB free disk (SSD strongly preferred)
- Linux (Ubuntu 22.04/24.04) or WSL2

## How to Run on Very Limited Hardware

1. Set `vm.max_map_count=262144`
2. Start **only** the official Wazuh single-node stack first
3. Wait until the dashboard is fully green/healthy
4. Then start only DVWA (or only Juice Shop)
5. Run short campaigns
6. Add Suricata only if you still have free memory

## What to Expect

On 8 GB:
- Wazuh dashboard will be usable
- Campaigns will generate detectable activity
- Indexing will be slower than on high-end machines
- You may need to clear old indices occasionally

On 6 GB:
- Possible but tight
- Prefer stopping Suricata
- Keep browser usage minimal while investigating

## Why This Lab Exists

Many excellent SOC labs require 16–32 GB RAM and multiple VMs.  
AetherSOC exists so students and career changers using low-end computers or low-end PCs are not left behind.
