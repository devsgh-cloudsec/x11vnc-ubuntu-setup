#!/bin/bash

# Install x11vnc
sudo apt update && sudo apt install x11vnc -y

# Set VNC password
x11vnc -storepasswd

# Allow VNC port in firewall
sudo ufw allow 5900/tcp
sudo ufw reload

# Create systemd service
cat <<EOF | sudo tee /etc/systemd/system/x11vnc.service
[Unit]
Description=x11vnc Remote Desktop Service
After=display-manager.service network.target

[Service]
ExecStart=/usr/bin/x11vnc -display :0 -auth guess -forever -shared -rfbauth /home/$USER/.vnc/passwd -rfbport 5900 -o /home/$USER/x11vnc.log -localhost no
User=$USER
Restart=on-failure
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF

# Enable service
sudo systemctl daemon-reload
sudo systemctl enable --now x11vnc

echo "✅ x11vnc setup complete. Connect via RealVNC at port 5900."
