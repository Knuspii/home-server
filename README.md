# **🏠 Home-Server Stack**

[![OS](https://img.shields.io/badge/OS-Debian-C51A4A?logo=debian&logoColor=white&style=flat-square)](https://www.debian.org)
[![Docker](https://img.shields.io/badge/Docker_Compose-11_Services-2496ED?logo=docker&logoColor=white&style=flat-square)](./stack/)

**[Selfhosted Apps](#selfhosted-apps)** • **[Scripts](#scripts)**

A self-hosted home server setup running on Debian with Docker Compose. \
I mainly use this for Taskmanagement, Backups and DNS Adblock.

---

<div align="center">
<img src="assets/HomeLab.drawio.png" width="600" height="600" alt="Preview">
</div>

---

## Selfhosted Apps
| Service | Description |
|--------|-------------|
| 🧠 Glance | Dashboard |
| 🌐 AdGuard Home | DNS Adblock |
| 📁 Filebrowser Quantum | File Management |
| 💰 Wallos | Finance Tracking |
| ✅ Vikunja | Task Management |
| 📡 Glances | Monitoring |
| 🧪 n8n | Automation |
| 📦 Dozzle | Docker Logs |
| 🖥️ It-Tools | Tools |
| 📊 Uptime-Kuma | Status-Page |

## Scripts
| Script | Purpose |
|--------|---------|
| cleanup.sh | System cleanup |
| backup.sh | Backups (private) |
| check_smartctl.sh | Disk health check |
| check_docker.sh | Containers uptime check |
| send_pushover.sh | Send messages to myself via Pushover (private) |

I also use [HomeLab-Doctor](https://github.com/Knuspii/HomeLab-Doctor)

---

## ⚙️ System Setup (Debian)
### Base packages I use
```bash
sudo apt install htop ssh rsync ncdu curl tree jq smartmontools fastfetch at mdadm
```

## 📊 Notes
- Designed for local network use
- Secrets are stored in `.env` (not committed obviously)

---

## 🧠 Author
Home server stack by Knuspii
