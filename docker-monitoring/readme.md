 
---
 
## Table of Contents
 
- [Overview](#overview)
- [Repository Structure](#repository-structure)
- [Objective 2 – Docker + Monitoring Stack](#objective-2--docker--monitoring-stack)
  - [Architecture](#architecture)
  - [Prerequisites](#prerequisites)
  - [Quick Start](#quick-start)
  - [Accessing Services](#accessing-services)
  - [Grafana Dashboard](#grafana-dashboard)
  - [Teardown](#teardown)
- [Keypoints](#keypoints)
 
---
 
## Overview
 
This repository contains the completed DevOps technical assessment consisting of two objectives:
 
| Objective | Description | Stack |
|-----------|-------------|-------|
| **1** | Containerise an application and visualise container metrics | Docker, Prometheus, cAdvisor, Grafana |
 
---
 
## Repository Structure
 
```
devops-assessment/
│
│
└── docker-monitoring/                # Objective 2 – Containerised App + Monitoring
    ├── docker-compose.yml            # Defining all 4 services
    ├── .env                          # Port config (environment variables)
    ├── app/
    │   ├── server.js                 # Express.js app with /health and /load endpoints
    │   ├── Dockerfile                # Multi-layer Alpine image
    │   └── package.json              # Dependencies
    ├── prometheus/
    │   └── prometheus.yml            # Scrape config with cAdvisor target
    ├── grafana/
    │   ├── datasource.yml            # declaring Prometheus as data source
    │   ├── dashboard.yml             # providing dashboard
    │   └── docker-dashboard.json     # in-built dashboard with CPU, Memory, container Status
    └── scripts/
        ├── start.sh                  # docker-compose up -d --build for reference
        └── stop.sh                   # docker-compose down for reference
```
 
 
## Objective 2 – Docker + Monitoring Stack
 
### Architecture
 
```
┌─────────────────────────────────────────────────────┐
│                   Docker Network                    │
│                                                     │
│  ┌──────────────┐      ┌──────────────────────┐     │
│  │  sample-app  │      │      cAdvisor        │     │
│  │  Node/Express│      │  Container Metrics   │     │
│  │  :3000       │      │  :8080               │     │
│  └──────────────┘      └──────────┬───────────┘     │
│                                   │ scrapes         │
│                         ┌──────────▼───────────┐    │
│                         │      Prometheus      │    │
│                         │  Metrics Storage     │    │
│                         │  :9090               │    │
│                         └──────────┬───────────┘    │
│                                    │ queries        │
│                         ┌──────────▼───────────┐    │
│                         │       Grafana        │    │
│                         │  Dashboards & Alerts │    │
│                         │  :3001               │    │
│                         └──────────────────────┘    │
└─────────────────────────────────────────────────────┘
```
 
### Prerequisites
 
| Requirement | Notes |
|-------------|-------|
| Docker Engine | [Install guide](https://docs.docker.com/get-docker/) |
| Docker Compose | Included with Docker Desktop |
 
### Quick Start
 
```bash
# 1. Navigate to docker-monitoring
cd devops-assessment/docker-monitoring
 
# 2. Run the start script
bash scripts/start.sh
 
# OR manually:
docker-compose up -d --build
 
# 3. Verify all containers are running
docker ps
```
 
### Accessing Services
 
| Service | URL | Credentials | Purpose |
|---------|-----|-------------|---------|
| **Application** | http://localhost:3000 | – | Node.js Express app |
| **cAdvisor** | http://localhost:8080 | – | Raw container metrics |
| **Prometheus** | http://localhost:9090 | – | Metrics query interface |
| **Grafana** | http://localhost:3001 | `admin` / `admin` | Visualisation dashboard |
 
### Grafana Dashboard
 
The dashboard is **pre-provisioned automatically** — no manual setup required.
 
1. Open **http://localhost:3001**
2. Log in with `admin` / `admin`
3. Navigate to **Dashboards → Docker Monitoring**
4. The dashboard displays:
   -  **CPU Usage** – per container CPU consumption over time
   -  **Memory Usage** – per container memory consumption over time
   -  **Container Status** – running state of all containers
 
>  **Note:** Hit `http://localhost:3000/load` a few times to generate CPU activity and watch the Grafana graphs update in real time.
 
### teardown
 
```bash
bash scripts/stop.sh
 
# OR manually run:
docker-compose down
```
 
---
 
## Keypoints
 
### objective1 - keypoints
 
- The `ec2` module is fully reusable, any project can import it with different variable values. Root module handles project-specific configuration only.
- I have included validations in variable definitions to prevent accidental deployment to unsupported regions or instance types.
- Using `data "aws_ami"` block ensures the latest patched Amazon Linux 2 AMI is always used rather than a hardcoded, potentially outdated AMI.
- Fully automated provisioning, no manual SSH required after `terraform apply`.
 
### objective2 - keypoints
 
- The chosen node 18 alpine image is significantly smaller than the standard Node image, image pull time, and storage cost.
- .env centralises all port config. Engineers can change ports without touching `docker-compose.yml`.
- Datasources and dashboards are provisioned via mounted config files — no manual intervention required after startup. Fully reproducible.
- Provides near-real-time metrics in Grafana without excessive storage overhead.
 
---