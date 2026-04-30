# SOC Home Lab: Suricata IDS & ELK Stack Integration

## Project Overview
This project demonstrates the deployment and configuration of a high-fidelity Security Operations Center (SOC) home lab. The environment monitors a containerized network bridge to detect and visualize real-time cyber attacks using **Suricata IDS**, **Logstash**, **Elasticsearch**, and **Kibana**.

## Lab Architecture
- **IDS:** Suricata 8.0.4
- **SIEM:** Elastic Stack (ELK) 8.13.0
- **Monitoring Interface:** `br-d8c7ffa00a1c`
- **Target App:** Damn Vulnerable Web App (DVWA) @ `172.18.0.2`
- **Attacker Host:** Kali Linux @ `172.18.0.1`

---

## Incident Report: IR-2026-001

**Date:** April 30, 2026  
**Analyst:** Islam Mohamed Taher (Senior Electronics & Communication Engineering Student, AAST)  
**Severity:** High  
**Status:** Closed (Simulated Exercise)

### 1. Executive Summary
During a controlled lab exercise, multiple attack techniques were simulated against a deliberately vulnerable web application (DVWA). Suricata IDS successfully detected 100% of the simulated attacks. All telemetry was ingested into the ELK SIEM and visualized via a custom Kibana dashboard, capturing a total of **4,021 alerts** during the session.

### 2. Timeline of Events (UTC)
| Time | Event | Source IP | Destination | Alert Signature |
| :--- | :--- | :--- | :--- | :--- |
| 13:00:30 | Nmap SYN scan initiated | 172.18.0.1 | 172.18.0.2 | [SOC-LAB] Nmap SYN Scan Detected |
| 13:03:40 | Nikto web scan started | 172.18.0.1 | 172.18.0.2 | [SOC-LAB] Nikto Web Scanner Detected |
| 13:06:16 | SQL Injection attempt | 172.18.0.1 | 172.18.0.2 | [SOC-LAB] SQL Injection Attempt |
| 13:06:56 | Brute force attempts | 172.18.0.1 | 172.18.0.2 | [SOC-LAB] Brute Force Detected |
| 13:07:06 | Directory traversal | 172.18.0.1 | 172.18.0.2 | [SOC-LAB] Directory Traversal Attempt |

### 3. Indicators of Compromise (IOCs)
*   **Attacker IP:** `172.18.0.1`
*   **User-Agent Detected:** `Nikto/2.x`
*   **Payload Patterns:** `UNION SELECT`, `../../../../etc/passwd`
*   **Anomaly:** 50+ login attempts in under 2 minutes.

### 4. MITRE ATT&CK® Mapping
| Technique ID | Name | Observed Behavior |
| :--- | :--- | :--- |
| **T1595.001** | Active Scanning | Nmap ping sweep of `172.18.0.0/24` |
| **T1595.002** | Vulnerability Scanning | Nikto full web vulnerability scan |
| **T1110.001** | Password Guessing | Hydra HTTP POST attack on login page |
| **T1190** | Exploit Public-Facing App | SQL injection against DVWA database |
| **T1083** | File/Directory Discovery | Directory traversal via URI manipulation |

### 5. Recommended Remediations
1.  **Network Level:** Block source IP `172.18.0.1` at the edge firewall.
2.  **Application Level:** Implement account lockout policies after 5 failed login attempts.
3.  **Security Layers:** Deploy a Web Application Firewall (WAF) to filter SQLi and Traversal payloads.
4.  **Hardening:** Disable directory listing and patch known vulnerabilities in the web server configuration.

---

## Future Improvements
- Automate IP blacklisting via Suricata-IPS mode.
- Integrate Telegram/Slack alerts for Critical (Severity 1) events.
- Deploy a honeypot to capture and analyze external threat intelligence.
