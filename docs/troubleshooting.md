# AetherSOC Troubleshooting (Low-End Focus)

## 1. Wazuh indexer fails to start / yellow cluster

**Most common cause on Linux:** `vm.max_map_count` is too low.

```bash
sudo sysctl -w vm.max_map_count=262144
echo "vm.max_map_count=262144" | sudo tee -a /etc/sysctl.conf
```

Then restart the Wazuh stack:

```bash
cd wazuh-docker/single-node
docker compose down
docker compose up -d
```

## 2. Not enough memory

Symptoms: containers keep restarting, OOM kills, very slow dashboard.

Actions:
- Close browsers and heavy applications
- Start only Wazuh first, then add targets one by one
- Reduce Suricata if needed (comment it out in docker-compose.yml)
- Prefer an 8 GB+ machine for comfortable use

## 3. Suricata fails or shows wrong interface

Suricata is started with `-i eth0`. On many systems the interface is different (`ens33`, `enp0s3`, `wlan0`, etc.).

Fix options:
1. Edit `docker-compose.yml` and change the interface name
2. Or temporarily disable the Suricata service and run it manually later
3. On Docker Desktop (Mac/Windows) host networking behaves differently – Suricata may need extra configuration

If Suricata keeps failing, the rest of the lab (Wazuh + targets + campaigns) still works.

## 4. Certificates / Wazuh dashboard not loading

Always generate certificates before the first `docker compose up`:

```bash
cd wazuh-docker/single-node
docker compose -f generate-indexer-certs.yml run --rm generator
docker compose up -d
```

Access via `https://localhost` (accept the self-signed certificate warning).

Default login: `admin` / `SecretPassword` — change it immediately.

## 5. Campaign scripts do nothing visible

- Confirm DVWA is reachable: http://localhost:8080
- Confirm Juice Shop: http://localhost:3000
- Run the health check: `./scripts/health-check.sh`
- Campaigns only generate HTTP traffic against local containers. Check Wazuh alerts and Suricata logs after running a campaign.

## 6. Port conflicts

If ports 8080, 3000, or 443/5601 are already in use, stop the conflicting service or change the published ports in the respective compose files.

## 7. General advice for low-end PCs

- Use an SSD if possible
- Give Docker enough resources in Docker Desktop settings (if using Desktop)
- Prefer Ubuntu Server or a lightweight desktop environment
- Take snapshots / backups of your working state

If you hit a new issue, open a GitHub issue with:
- Your OS and RAM amount
- Output of `./scripts/health-check.sh`
- Relevant `docker compose logs` lines
