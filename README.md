# How to Access Ubuntu 22.04’s Desktop Remotely Using x11vnc and RealVNC from Windows 11

Accessing Ubuntu remotely using VNC can be tricky, especially when the built-in GNOME VNC server (vino) is disabled or unsupported. In this tutorial, we'll walk you through:

* Installing and configuring `x11vnc` when vino fails
* Securing the setup with password authentication
* Starting VNC on boot using `systemd`

This guide includes a **well-tested and validated script to enable hassle-free RealVNC access from Windows 11**.

---

## 🛠️ Step 1: Install x11vnc

### 1.1 Install the VNC Server

```bash
sudo apt update && sudo apt install x11vnc -y
```

**Explanation:** Installs the `x11vnc` package which allows remote desktop access to the active GUI session.

---

### 1.2 Set a Password for Secure Access

```bash
x11vnc -storepasswd
```

**Explanation:** Saves a VNC password to `~/.vnc/passwd` to secure your remote connection.

---

## Step 2: Allow VNC Port Through the Firewall

### 2.1 Open the Port

```bash
sudo ufw allow 5900/tcp
```

**Explanation:** Opens port 5900 used by VNC.

### 2.2 Reload the Firewall

```bash
sudo ufw reload
```

**Explanation:** Applies the new firewall rule.

---

## Step 3: Set Up x11vnc to Start on Boot with systemd

To make VNC available automatically after each reboot, we’ll configure a systemd service.


```ini
[Unit]
Description=x11vnc Remote Desktop Service
After=display-manager.service network.target

[Service]
ExecStart=/usr/bin/x11vnc -display :0 -auth guess -forever -shared -rfbauth /home/devs/.vnc/passwd -rfbport 5900 -o /home/devs/x11vnc.log -localhost no
User=devs
Restart=on-failure
RestartSec=5

[Install]
WantedBy=multi-user.target
```

**Note:** Replace `devs` with your actual Ubuntu username.

---

### 3.1 Create the systemd Service File

```bash
sudo nano /etc/systemd/system/x11vnc.service
```

Paste the script above, then press `Ctrl+O` to save and `Ctrl+X` to exit.

---

### 3.2 Reload systemd and Enable the Service

```bash
sudo systemctl daemon-reload
sudo systemctl enable --now x11vnc
```

**Explanation:** Registers and launches the x11vnc service immediately and automatically at boot.

---

## Step 4: Enable GUI Auto-login (Recommended)

x11vnc requires the GUI (display `:0`) to be active. This ensures it’s ready at boot.

### 4.1 Edit GDM Configuration

```bash
sudo nano /etc/gdm3/custom.conf
```

### 4.2 Modify or Add Under `[daemon]`:

```ini
[daemon]
AutomaticLoginEnable=true
AutomaticLogin=devs
```

> Replace `devs` with your username.

### 4.3 Restart GDM

```bash
sudo systemctl restart gdm
```

---

## Step 5: Verify the Setup

### 5.1 Check if x11vnc Is Listening

```bash
ss -tulnp | grep 5900
```

**Explanation:** Ensures VNC is running and accepting connections.

---

### 5.2 Connect from RealVNC Client on Windows 11

* **Address:** `ubuntu-ip:5900`
* **Password:** Enter the password you saved with `x11vnc -storepasswd`

---

## Troubleshooting

| Issue                   | Fix                                                                     |
| ----------------------- | ----------------------------------------------------------------------- |
| “Connection refused”    | Ensure x11vnc is running, and GUI is logged in or auto-login is enabled |
| “Authentication failed” | Reset password with `x11vnc -storepasswd`                               |
| “Blank screen”          | Set auto-login to load GUI session at boot                              |
| “Service not starting”  | Check logs: `journalctl -u x11vnc` or `/home/devs/x11vnc.log`           |

---

## Optional: Run Everything with a Single Script

If you're a beginner or want to automate everything, here’s how to use the `setup-x11vnc.sh` deployment script.

---

### 💻 How to Run the `setup-x11vnc.sh` Script (For Beginners)

#### 1. Open Terminal

Press `Ctrl + Alt + T` or open “Terminal” from your apps menu.

---

#### 2. Download the Script

```bash
wget https://raw.githubusercontent.com/devsgh-cloudsec/x11vnc-ubuntu-setup/main/setup-x11vnc.sh
```

---

#### 3. Make the Script Executable

```bash
chmod +x setup-x11vnc.sh
```

---

#### 4. Run the Script

```bash
./setup-x11vnc.sh
```

---

#### 5. Reboot the System

```bash
sudo reboot
```

After reboot, RealVNC will be able to connect to your Ubuntu machine automatically.

---

## 📁 What’s Included in the Downloadable .zip

The `.zip` bundle includes:

* `setup-x11vnc.sh` – Full automated installation and config
* `x11vnc.service` – The working systemd service unit
* `README.md` – Usage instructions

---

### ⬇️ Download the Bundle

[Download x11vnc-ubuntu-setup.zip](https://github.com/devsgh-cloudsec/x11vnc-ubuntu-setup/archive/refs/heads/main.zip)

---

### 📂 GitHub Repository

🔗 **Repository:** [https://github.com/devsgh-cloudsec/x11vnc-ubuntu-setup](https://github.com/devsingh-cloud/x11vnc-ubuntu-setup)

---

## 🏁 Final Outcome

You now have:

✅ Secure VNC access on Ubuntu 22.04 LTS  
✅ Verified RealVNC connection from Windows 11  
✅ Auto-start on boot using systemd  
✅ Optional full automation with one shell script

