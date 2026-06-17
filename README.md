# 🏠 Home Server Stack – Knuspii
A self-hosted home server setup running on Debian with Docker Compose.

---

## ⚙️ Overview
This stack is designed for a home production environment:

## HP EliteDesk 800 G3 DM 35W
- OS: Debian GNU/Linux 13
- CPU: Intel(R) Core(TM) i5-6500T (4) @ 3.10 GHz
- RAM: 8GB DDR4
- Disk1: SSD 128GB 
- Disk2: SSD 128GB
- Disk3: SSD 128GB

Disk1 & Disk2 = RAID1

## Selfhosted Apps
| Service | Description |
|--------|-------------|
| 🧠 Glance | Dashboard |
| 🌐 AdGuard Home | DNS Adblock |
| 📁 Filebrowser | File Management |
| 💰 Wallos | Finance Tracking |
| ✅ Vikunja | Task Management |
| 📧 Mailrise | Get Mails |
| 📡 Glances | Monitoring |
| 🧪 TTYD | Shell Testing |
| 📦 mc-server | Minecraft Server |

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
sudo apt install htop ssh rsync ncdu curl tree jq smartmontools fastfetch at mdadm
```

## 📊 Notes
- Designed for local network use
- Exposed services should be secured via reverse proxy or VPN
- Secrets are stored in `.env` (not committed obviously)

---

## 🧠 Author
Home server stack by Knuspii
