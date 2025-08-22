#!/bin/bash

# Pastikan skrip dijalankan sebagai root atau dengan sudo
if [[ $EUID -ne 0 ]]; then
   echo "Skrip ini harus dijalankan sebagai root atau dengan sudo."
   exit 1
fi

echo "========== Auto-Setup VPS untuk Airdrop (Versi Terbaru) =========="
echo "Skrip ini akan melakukan hal-hal berikut:"
echo "1. Memperbaiki proses apt/dpkg yang terhenti."
echo "2. Memperbarui dan meng-upgrade sistem."
echo "3. Mengaktifkan dan mengkonfigurasi Firewall (UFW) untuk port 22."
echo "4. Menginstal Docker dan Docker-Compose."
echo "5. Menginstal Python3 dan pip."
echo "6. Menginstal Node.js 20 LTS dan npm."
echo "----------------------------------------------------"

read -p "Apakah Anda yakin ingin melanjutkan? (y/n) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]
then
    echo "Operasi dibatalkan."
    exit 1
fi

# 1. Perbaiki proses apt/dpkg yang terhenti
echo ">>> Memperbaiki proses apt/dpkg yang terhenti..."
dpkg --configure -a
apt-get update --fix-missing
echo "Perbaikan selesai."
echo ""

# 2. Update & Upgrade Sistem
echo ">>> Memperbarui dan meng-upgrade sistem..."
apt-get update && apt-get upgrade -y
echo "Sistem berhasil diperbarui dan di-upgrade."
echo ""

# 3. Setup Firewall (UFW)
echo ">>> Mengatur Firewall (UFW)..."
apt-get install -y ufw
ufw default deny incoming
ufw default allow outgoing
ufw allow 22/tcp  # Izinkan port SSH
ufw --force enable
echo "Firewall (UFW) berhasil diatur dan diaktifkan."
echo ""

# 4. Instal Docker & Docker-Compose
echo ">>> Menginstal Docker dan Docker-Compose..."
apt-get install -y apt-transport-https ca-certificates curl gnupg lsb-release
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null
apt-get update
apt-get install -y docker-ce docker-ce-cli containerd.io
curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
echo "Docker dan Docker-Compose berhasil diinstal."
echo ""

# 5. Instal Python3
echo ">>> Menginstal Python3..."
apt-get install -y python3 python3-pip
echo "Python3 dan pip berhasil diinstal."
echo ""

# 6. Instal Node.js (Versi 20 LTS - Direkomendasikan)
echo ">>> Menginstal Node.js versi 20 LTS..."
curl -fsSL https://deb.nodesource.com/setup_20.x | bash -
apt-get install -y nodejs
echo "Node.js 20 LTS dan npm berhasil diinstal."
echo ""

echo "==================================================="
echo "Setup VPS selesai! Pastikan untuk memeriksa kembali konfigurasi Anda."
echo "==================================================="
