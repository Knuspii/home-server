# 🏠 Home Server Stack – Knuspii
A self-hosted home server setup running on Debian with Docker Compose.

---

## 🚀 Overview
This stack is designed for a home production environment:

| Service | Description |
|--------|-------------|
| 🧠 Homepage | Dashboard |
| 🌐 AdGuard Home | DNS Adblock |
| 📁 Filebrowser | File Management |
| 💰 Wallos | Finance Tracking |
| 📰 Miniflux + PostgreSQL | RSS Reader |
| ✅ Vikunja | Task Management |
| 📡 Glances | Monitoring |
| 🧪 TTYD | Shell Testing |

## Scripts
| Script | Purpose |
|--------|---------|
| cleanup.sh | System cleanup |
| backup.sh | Backups (private) |
| check_smartctl.sh | Disk health check |
| check_docker.sh | Docker health check (private) |

---

## ⚙️ System Setup (Debian)
### Base tools
```bash
sudo apt install htop ssh rsync ncdu curl tree jq smartmontools
```

## 📊 Notes
- Designed for local network use
- Exposed services should be secured via reverse proxy or VPN
- Secrets are stored in `.env` (not committed)

---

## 🧠 Author
Home server stack by Knuspii
