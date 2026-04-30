#!/bin/bash
# ===========================
# Kali SOC Lab — Setup Script
# ===========================

set -e  # stop on any error

echo "[*] Kali SOC Lab Setup Starting..."

# Install dependencies
echo "[*] Installing dependencies..."
sudo apt update -qq
sudo apt install -y docker.io docker-compose suricata filebeat curl jq git

# Start Docker
echo "[*] Starting Docker..."
sudo systemctl enable docker --quiet
sudo systemctl start docker

# Copy Suricata rules
echo "[*] Copying Suricata custom rules..."
sudo cp suricata/rules/local.rules /etc/suricata/rules/local.rules

# Copy Filebeat config
echo "[*] Applying Filebeat config..."
sudo cp filebeat/filebeat.yml /etc/filebeat/filebeat.yml
sudo chmod 600 /etc/filebeat/filebeat.yml

# Start ELK + DVWA
echo "[*] Starting Docker containers (ELK + DVWA)..."
docker-compose up -d

echo "[*] Waiting for Elasticsearch to be ready..."
until curl -s http://localhost:9200 > /dev/null 2>&1; do
  echo "    Still waiting..."
  sleep 5
done

echo "[*] Elasticsearch is up!"

# Start Suricata
echo "[*] Starting Suricata on docker0 interface..."
sudo suricata -c /etc/suricata/suricata.yaml -i docker0 -D

# Start Filebeat
echo "[*] Starting Filebeat..."
sudo systemctl enable filebeat --quiet
sudo systemctl start filebeat

echo ""
echo "=============================="
echo "  SOC Lab is ready!"
echo "=============================="
echo "  Kibana:  http://localhost:5601"
echo "  DVWA:    http://localhost:8080"
echo "  Elastic: http://localhost:9200"
echo ""
echo "  DVWA Login: admin / password"
echo "  Set DVWA security to: Low"
echo "=============================="
