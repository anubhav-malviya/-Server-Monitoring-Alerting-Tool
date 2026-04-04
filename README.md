# 🖥️ Server Monitoring & Alerting Tool
Lightweight Linux server monitoring tool with alerting, logging, and systemd integration


---

## 🚀 Overview

A **lightweight, production-ready server monitoring system** built using Bash that:

* Continuously monitors system performance
* Logs metrics to CSV
* Sends real-time email alerts
* Runs as a background service
* Supports flexible configuration

---

## 🎯 Key Features

✨ Real-time monitoring (CPU, Memory, Disk, Load)  
📊 CSV logging for analysis  
🚨 Email alerting using SMTP (`msmtp`)  
⚙️ Configurable thresholds (no code change required)  
🔄 Runs as systemd service  
📉 Log rotation support  
🖥️ Optional CLI dashboard  

---

## 🧱 Architecture

```id="sm5qeh"
+----------------------+
|   systemd service    |
+----------+-----------+
           |
           v
+----------------------+
| server_monitor.sh    |
| (main script)        |
+----------+-----------+
           |
   +-------+--------+
   |                |
   v                v
CSV Logging      Alert Engine
(/var/log)       (msmtp SMTP)
   |                |
   v                v
Analytics        Email Alerts
```

---

## ⚙️ How It Works

```id="2vowm1"
1. Collect system metrics
2. Store data in CSV
3. Compare with thresholds
4. Trigger alerts if exceeded
5. Repeat every N seconds
```

---

## 📁 Project Structure

```id="cz2h0s"
server-monitor/
├── server_monitor.sh
├── monitor_view.sh
├── server-monitor.service
├── config/
│   └── server-monitor.conf
├── logrotate.d/
│   └── server-monitor
└── README.md
```

---

## 📊 Metrics Collected

* CPU Usage
* Memory Usage
* Disk Usage
* Load Average
* Top CPU Process
* Top Memory Process

---

## 🛠️ Installation Guide

### 1️⃣ Clone Repository

```bash
git clone https://github.com/<your-username>/server-monitor.git
cd server-monitor
```

---

### 2️⃣ Install Dependencies

```bash
sudo apt update
sudo apt install msmtp msmtp-mta bc -y
```

---

### 3️⃣ Configure Email (SMTP)

```bash
sudo nano /etc/msmtprc
```

```id="tgwf0x"
defaults
auth           on
tls            on

account gmail
host smtp.gmail.com
port 587
from your_email@gmail.com
user your_email@gmail.com
password your_app_password

account default : gmail
```

```bash
sudo chmod 600 /etc/msmtprc
```

---

### 4️⃣ Configure Monitoring

```bash
sudo nano /etc/server-monitor.conf
```

```id="k7f2qg"
CPU_THRESHOLD=80
MEM_THRESHOLD=80
DISK_THRESHOLD=90
ALERT_COOLDOWN=300
ALERT_EMAIL="your_email@gmail.com"
INTERVAL=5
CSV_FILE="/var/log/server_stats.csv"
```

---

### 5️⃣ Deploy Scripts

```bash
sudo mv server_monitor.sh /usr/local/bin/
sudo mv monitor_view.sh /usr/local/bin/
chmod +x /usr/local/bin/server_monitor.sh
```

---

### 6️⃣ Setup systemd Service

```bash
sudo cp server-monitor.service /etc/systemd/system/
sudo systemctl daemon-reload
sudo systemctl enable server-monitor
sudo systemctl start server-monitor
```

---

### 7️⃣ Setup Log Rotation

```bash
sudo cp logrotate.d/server-monitor /etc/logrotate.d/
sudo logrotate -f /etc/logrotate.d/server-monitor
```

---

## ▶️ Usage

| Action  | Command                                 |
| ------- | --------------------------------------- |
| Start   | `sudo systemctl start server-monitor`   |
| Stop    | `sudo systemctl stop server-monitor`    |
| Restart | `sudo systemctl restart server-monitor` |
| Status  | `sudo systemctl status server-monitor`  |

---

## 🖥️ Live Dashboard (Optional)

```bash
monitor_view.sh
```

---

## 📊 Logs

| Type    | Location                     |
| ------- | ---------------------------- |
| Metrics | `/var/log/server_stats.csv`  |
| Alerts  | `/var/log/server_alerts.log` |

---

## 🚨 Alert Example

```
⚠️ Server Alert!

CPU Usage: 92%
Memory Usage: 85%
Disk Usage: 91%
```

---

## ⚡ Optimizations Implemented

* ✅ Config-driven architecture
* ✅ Cooldown-based alerting
* ✅ Reduced command overhead
* ✅ Secure SMTP setup
* ✅ systemd integration
* ✅ Log rotation support

---

## 🔮 Future Enhancements

* 📊 Grafana Dashboard Integration
* 🔔 Slack / Telegram Alerts
* 🐳 Docker Support
* ☸️ Kubernetes Deployment
* 📡 Prometheus Metrics Export

---

## 💼 Why This Project Matters

This project demonstrates:

* Real-world DevOps practices
* Linux system monitoring
* Automation using Bash
* Service management with systemd
* Alerting & observability concepts

---

## 🤝 Contributing

Contributions are welcome! Feel free to fork and improve.

---

## 📌 Author

**Anubhav Malviya**
DevOps Enthusiast 🚀

