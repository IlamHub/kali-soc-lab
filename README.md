# Kali SOC Lab: Integrated IDS & SIEM Monitoring

A fully functional Security Operations Center (SOC) home lab built on Kali Linux. This project simulates real-world attack detection and response by integrating **Suricata IDS** with the **ELK (Elasticsearch, Logstash, Kibana) SIEM stack**.

##  Architecture
The lab monitors a containerized network bridge, capturing traffic as it moves between the attacker host and the vulnerable target.

`[Kali Attack Tools]` → `[DVWA Target]` → `[Suricata IDS]` → `[Filebeat]` → `[ELK Stack]` → `[Kibana Dashboard]`

---

## 🛠️ Technical Stack
| Tool | Role | Version |
| :--- | :--- | :--- |
| **Suricata** | IDS — Network traffic analysis & alerting | 8.0.4 |
| **Elasticsearch** | SIEM — Centralized log storage & indexing | 8.13.0 |
| **Logstash** | Log parsing, filtering, and enrichment | 8.13.0 |
| **Kibana** | Data visualization & incident response dashboard | 8.13.0 |
| **Filebeat** | Lightweight log shipper (Suricata → Logstash) | 8.13.0 |
| **DVWA** | Damn Vulnerable Web Application (Target) | Latest |

---

## Incident Report — IR-2026-001
**Date:** April 30, 2026  
**Analyst:** Islam Mohamed Taher  
**Severity:** High  
**Status:** Closed (Simulated Exercise)

### 1. Executive Summary
Multiple attack techniques were simulated against a deliberately vulnerable web application (DVWA). Suricata IDS successfully detected **100%** of the simulated attacks. All telemetry was ingested into the ELK SIEM and visualized via a custom Kibana dashboard, capturing **4,021 alerts**.

### 2. Timeline of Events (UTC)
| Time | Event | Source IP | Destination | Alert Signature |
| :--- | :--- | :--- | :--- | :--- |
| 13:00:30 | Nmap SYN scan initiated | 172.18.0.1 | 172.18.0.2 | [SOC-LAB] Nmap SYN Scan Detected |
| 13:03:40 | Nikto web scan started | 172.18.0.1 | 172.18.0.2 | [SOC-LAB] Nikto Web Scanner Detected |
| 13:06:16 | SQL Injection attempt | 172.18.0.1 | 172.18.0.2 | [SOC-LAB] SQL Injection Attempt |
| 13:06:56 | Brute force attempts | 172.18.0.1 | 172.18.0.2 | [SOC-LAB] Brute Force Detected |
| 13:07:06 | Directory traversal | 172.18.0.1 | 172.18.0.2 | [SOC-LAB] Directory Traversal Attempt |

### 3. MITRE ATT&CK® Mapping
| ID | Technique | Observed Behavior |
| :--- | :--- | :--- |
| **T1595.001** | Active Scanning | Nmap ping sweep of `172.18.0.0/24` |
| **T1595.002** | Vulnerability Scanning | Nikto full web vulnerability scan |
| **T1110.001** | Brute Force | Hydra HTTP POST attack on login page |
| **T1190** | Exploit Public-Facing App | SQL injection against DVWA database |
| **T1083** | File/Directory Discovery | Directory traversal via URI manipulation |

---

## Quick Start

### Security Warning
This lab installs **deliberately vulnerable software**. Do **NOT** run this script on a machine exposed to the public internet. It is intended for isolated Virtual Machines (VMs) or host-only network environments.

### Installation
```bash
# Clone the repository
git clone [https://github.com/YOUR_USERNAME/kali-soc-lab.git](https://github.com/YOUR_USERNAME/kali-soc-lab.git)
cd kali-soc-lab

# Run the automated setup script
chmod +x scripts/setup.sh
./scripts/setup.sh


## Project Structure
kali-soc-lab/
├── docker-compose.yml       # ELK Stack + DVWA Container Definitions
├── suricata/rules/          # Custom IDS Detection Rules (local.rules)
├── filebeat/                # Log Shipper Configuration
├── logstash/pipeline/       # Logstash Parsing & Elasticsearch Output
├── scripts/                 # Automated Setup & Attack Simulation
├── reports/                 # Incident Reports (Markdown)
└── docs/screenshots/        # Kibana Dashboard Evidence

## Skills Demonstrated
SIEM Management: End-to-end log ingestion and visualization.

IDS Rule Development: Writing custom Suricata signatures for specific threats.

Attack Simulation: Performing controlled reconnaissance and exploitation.

Incident Response: Analyzing logs and writing professional IR reports.

Automation: Bash scripting for complex software deployments.

## Accessing the Stack
Kibana Dashboard: http://localhost:5601

DVWA Target: http://localhost:8080

    Default Credentials: admin / password

    Setup: Click "Create / Reset Database" and set security to Low.
