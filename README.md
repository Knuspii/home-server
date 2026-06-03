# 🏠 Home Server Stack – Knuspii
A self-hosted home server setup running on Debian with Docker Compose.

---

## 🚀 Overview
This stack is designed for a home production environment:

- 🧠 Dashboard: Homepage
- 🌐 DNS Adblock: AdGuard Home
- 📁 File Management: Filebrowser
- 💰 Finance Tracking: Wallos
- 📰 RSS Reader: Miniflux + PostgreSQL
- ✅ Task Management: Vikunja
- 📡 Monitoring: Glances
- 🧪 Shell Testing: TTYD

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
