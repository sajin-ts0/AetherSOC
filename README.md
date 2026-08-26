# AetherSOC

**Lightweight SOC Home Lab for Low-End Computers & PCs**

AetherSOC is a free forever, open-source Security Operations Center (SOC) home lab designed specifically for **low-end computers**, **low-end PCs**, and machines with limited RAM (works from ~6–8 GB upward).

It is the only public lab built around a **Living Narrative Campaign Engine** — continuous, timed, multi-stage attack stories that generate realistic telemetry over time so you can practice real SOC analyst and detection engineering skills.

**Keywords this repo targets:** low end computer SOC home lab, low end PC cybersecurity lab, lightweight SOC lab, low resource SOC home lab, free SOC lab for low-end machines.

---

## Why AetherSOC?

Most SOC labs on GitHub require 16–32 GB RAM and give you static “run one attack” scenarios.

AetherSOC is different:

- Built for **low-end computers / low-end PCs**
- One straight path (no complicated modes)
- Living Narrative Campaigns that unfold automatically
- 100% free forever (open-source tools only)
- Single `docker compose` focused workflow

---

## What You Get

| Component              | Purpose                                      |
|------------------------|----------------------------------------------|
| Wazuh (single-node)    | SIEM / XDR – log collection, detection, dashboards |
| Suricata               | Network IDS                                  |
| Vulnerable targets     | DVWA + OWASP Juice Shop                      |
| Narrative Campaign Engine | Timed multi-stage attack stories that generate real telemetry |
| Simple scripts         | Start campaigns, health checks, low-end tips |

---

## Hardware Requirements (Low-End Focus)

| Tier          | RAM     | Expected Experience                     |
|---------------|---------|-----------------------------------------|
| Minimum       | 6–8 GB  | Core lab + light campaigns              |
| Recommended   | 8–12 GB | Comfortable Wazuh + Suricata + campaigns |
| Better        | 12 GB+  | Smoother indexing and longer retention  |

**Tested goal:** Useful on older laptops and low-end PCs that cannot run heavy multi-VM labs.

---

## One Straight Way – Quick Start

### 1. Prerequisites

- Linux (Ubuntu 22.04/24.04 recommended), WSL2, or macOS
- Docker + Docker Compose v2
- At least 6–8 GB free RAM
- 30+ GB free disk

**Important (Linux):** Increase `vm.max_map_count` (required by Wazuh indexer):

```bash
sudo sysctl -w vm.max_map_count=262144
echo "vm.max_map_count=262144" | sudo tee -a /etc/sysctl.conf
```

### 2. Clone this repository

```bash
git clone https://github.com/YOUR-USERNAME/AetherSOC.git
cd AetherSOC
```

### 3. Deploy Wazuh (official single-node – most reliable)

```bash
git clone https://github.com/wazuh/wazuh-docker.git -b v4.14.7
cd wazuh-docker/single-node

# Generate certificates
docker compose -f generate-indexer-certs.yml run --rm generator

# Start Wazuh (this is the core of the lab)
docker compose up -d
```

Wait 2–4 minutes. Access the dashboard:

- URL: `https://localhost`
- Default credentials: `admin` / `SecretPassword`  
  (Change them immediately after first login)

### 4. Start the rest of AetherSOC (targets + Suricata + campaign tools)

From the **AetherSOC** root directory:

```bash
cd ../..   # back to AetherSOC root if you were inside wazuh-docker
docker compose up -d
```

This starts:

- DVWA (port 8080)
- OWASP Juice Shop (port 3000)
- Suricata (network monitoring)
- Campaign runner support

### 5. Run a Living Narrative Campaign

```bash
chmod +x scripts/*.sh
./scripts/start-campaign.sh red-harvest
```

Available campaigns (see `campaigns/` folder):

- `red-harvest` – Initial access → discovery → credential access style activity
- `silent-ledger` – Insider / data staging style activity
- `ghost-protocol` – Longer dwell simulation

The campaign scripts generate realistic traffic and activity against the vulnerable targets so Wazuh and Suricata produce alerts you can investigate.

---

## Living Narrative Campaign Engine (The Unique Part)

Most labs let you run a single Atomic test or Caldera operation once.

AetherSOC campaigns are **timed sequences**:

1. Stage 1 – Reconnaissance / scanning noise
2. Stage 2 – Initial access attempts against DVWA / Juice Shop
3. Stage 3 – Discovery and post-exploitation style actions
4. Stage 4 – Persistence / data staging simulation

Each stage has delays so the timeline feels like a real incident unfolding. You practice:

- Watching alerts appear over time
- Writing or tuning detections
- Building timelines
- Investigating like a real SOC analyst

Campaign scripts live in `campaigns/` and are simple, auditable bash/Python so you can modify or extend them.

---

## Low-End Computer Tips (Critical for Stability)

1. **Always set `vm.max_map_count=262144`** before starting Wazuh.
2. Close heavy browsers and other apps while the lab is running.
3. If the indexer is slow, reduce Wazuh retention or stop Suricata temporarily.
4. Prefer SSD storage.
5. On very low RAM (6 GB), start only Wazuh + one target first, then add the rest.

Common fixes are documented in `docs/troubleshooting.md`.

---

## Repository Structure

```
AetherSOC/
├── README.md                 # This file
├── docker-compose.yml        # Targets + Suricata + helpers
├── campaigns/                # Living Narrative Campaign definitions
├── scripts/                  # start-campaign, health-check, etc.
├── docs/                     # Extra documentation
├── suricata/                 # Suricata config & rules notes
├── targets/                  # Notes about vulnerable apps
└── LICENSE
```

---

## Detection Engineering Practice

1. Start a campaign.
2. Watch alerts in the Wazuh dashboard.
3. Look at Suricata Eve logs.
4. Write or improve a custom rule.
5. Re-run the relevant campaign stage and verify the detection fires.

This closed loop is the main learning path of AetherSOC.

---

## Disclaimer

This lab is for **educational and authorized training purposes only**.  
All attacks run against intentionally vulnerable containers inside your own isolated environment.  
Never point these tools at systems you do not own or have explicit permission to test.

---

## License

MIT License – free to use, modify, and share.

---

## Author

Created for the community of people learning SOC and cybersecurity on low-end computers and PCs.

**LinkedIn:** [https://www.linkedin.com/in/sajin-t-s-1127b4346](https://www.linkedin.com/in/sajin-t-s-1127b4346?utm_source=share_via&utm_content=profile&utm_medium=member_android)

If this lab helps you, a star on the repository is appreciated.

---

**Search terms this project is optimized for:**  
low end computer SOC home lab • low end PC SOC lab • lightweight SOC home lab • low resource cybersecurity lab • free SOC lab for low-end machines • SOC lab for old laptop
