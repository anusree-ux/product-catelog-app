# Product Catalog Platform
A cloud-native **Product Catalog Platform** built using **React**, **Flask**, and **PostgreSQL**, containerized with **Docker**, orchestrated using **Kubernetes (Kind)**, and automated with a **Jenkins CI/CD Pipeline**. The project also includes **NGINX Ingress**, **Network Policies**, **Prometheus**, **Grafana**, **Loki**, and **Promtail** for monitoring, logging, and secure networking.
<img width="1462" height="776" alt="App-screenshot" src="https://github.com/user-attachments/assets/7a90f5b1-683f-4eb3-be41-da9a5f0b164c" />

---
## 🚀 Features
- React frontend served with NGINX
- Flask REST API backend
- PostgreSQL database
- Dockerized frontend and backend
- Kubernetes Deployments and Services
- NGINX Ingress Controller
- Persistent Volume for PostgreSQL
- ConfigMaps and Secrets
- Kubernetes Network Policies
- Jenkins CI/CD Pipeline
- Trivy Security Scanning
- Docker Hub Image Publishing
- Prometheus Monitoring
- Grafana Dashboards
- Loki + Promtail Centralized Logging
- Rolling Updates
- Health Checks (Liveness & Readiness Probes)

---

# 📥 Clone the Repository
```bash
git clone https://github.com/anusree-ux/product-catelog-app.git
cd product-catelog-app
```
---

# 🏗️ Architecture
```mermaid
%%{init: {'theme': 'base', 'themeVariables': { 'primaryColor': '#E3F2FD', 'edgeLabelBackground':'#FFFFFF', 'tertiaryColor': '#fff'}}}%%
graph TD
    %% Define external elements %%
    User[<i class='fa fa-user'></i> User]
    GitHub(GitHub Repo)
    DockerHub[Docker Hub Registry]

    %% Define Ingress & Network Layer %%
    subgraph K8s_Cluster [Kubernetes Cluster / Namespace: product-catalog]
        Ingress[<i class='fa fa-globe'></i> NGINX Ingress Controller]
        NetPol1[NetPol: Ingress Rules]

        %% Define Application Components %%
        subgraph Frontend_Tier [Frontend Tier]
            FE_Pod(Frontend Pod: React + NGINX)
        end

        subgraph Backend_Tier [Backend Tier]
            BE_Pod(Backend Pod: Flask REST API)
            NetPol2[NetPol: Backend Access]
        end

        subgraph Database_Tier [Database Tier]
            DB_Pod(Database Pod: PostgreSQL 16)
            PVC[Persistent Volume Claim / Storage]
            NetPol3[NetPol: DB Access Control]
        end

        %% Define Logging & Monitoring %%
        subgraph Monitoring_Log_Tier [Observability Stack / Namespace: monitoring]
            Promtail_Pod(Promtail Pod / DaemonSet)
            Loki_Pod(Loki Pod)
            Prometheus_Pod(Prometheus Pod)
            Grafana_Pod(Grafana Pod)
        end

    end

    %% Define Automation & Dev Layer %%
    subgraph DevOps_Automation [DevOps Pipeline]
        Jenkins(Jenkins Server)
        Trivy[Trivy Scanner]
    end

    %% Define Traffic & Data Flows %%
    User -- "Traffic via domain product-catalog.local" --> Ingress
    Ingress -- "Routes based on path: /" --> FE_Pod
    Ingress -- "Routes based on path: /api" --> BE_Pod
    FE_Pod -- "Calls API endpoint" --> Ingress

    BE_Pod -- "Stores/Retrieves Data" --> DB_Pod
    DB_Pod -- "Persists Data" --> PVC

    %% Logging Workflow %%
    Promtail_Pod -- "Scrapes logs from Pods" --> Loki_Pod
    Loki_Pod -- "Indexes logs" --> Grafana_Pod

    %% Monitoring Workflow %%
    Prometheus_Pod -- "Scrapes metrics from Nodes/Pods" --> Grafana_Pod
    User -- "Views Dashboards" --> Grafana_Pod

    %% Network Security Interactions %%
    NetPol1 -. Enforces Ingress flow .-> Ingress
    NetPol2 -. Locks down traffic .-> BE_Pod
    NetPol3 -. Isolates DB access .-> DB_Pod

    %% CI/CD Workflow %%
    Jenkins -- "Webhook triggered" --> GitHub
    GitHub -- "Pull source code" --> Jenkins
    Jenkins -- "1. Lint, Test, Build" --> Jenkins
    Jenkins -- "2. Vulnerability Scan" --> Trivy
    Jenkins -- "3. Push Images" --> DockerHub
    Jenkins -- "4. Trigger K8s Deploy" --> K8s_Cluster
```
---

# 🛠️ Tech Stack
| Category | Technologies |
|----------|--------------|
| Frontend | React, Vite, NGINX |
| Backend | Flask, SQLAlchemy |
| Database | PostgreSQL |
| Containers | Docker |
| Container Orchestration | Kubernetes (Kind) |
| CI/CD | Jenkins |
| Monitoring | Prometheus |
| Visualization | Grafana |
| Logging | Loki, Promtail |
| Security | Kubernetes Network Policies, Trivy |

---

# ☸️ Kubernetes Resources
The application is deployed using the following Kubernetes resources:

- Namespace
- Deployments
- Services
- Ingress
- ConfigMaps
- Secrets
- Persistent Volume Claim (PVC)
- Network Policies
<img width="1163" height="590" alt="Kubernetes" src="https://github.com/user-attachments/assets/e36983d9-c4d0-4f88-8487-f6f767c08e48" />

---

# 📊 Monitoring
Monitoring is implemented using:
- Prometheus
- Grafana
- kube-state-metrics
- Node Exporter

Monitored metrics include:
- CPU Usage
- Memory Usage
- Pod Status
- Kubernetes Cluster Health
- Application Metrics
<img width="1912" height="905" alt="Grafana-Dashboard" src="https://github.com/user-attachments/assets/04af4f60-20ae-485f-92c4-151a83840418" />
<img width="1886" height="960" alt="Promethus-Targets" src="https://github.com/user-attachments/assets/7910299c-948d-4c06-a2df-8ddbfae33517" />

---

# 📝 Centralized Logging
The logging stack consists of:

- Promtail
- Loki
- Grafana

Logs from Kubernetes pods are collected by Promtail, stored in Loki, and visualized using Grafana.
<img width="1910" height="903" alt="LOKI" src="https://github.com/user-attachments/assets/6ce7e6cb-40f2-4642-a4f8-6dba99805b7f" />

---

# 🔄 Jenkins CI/CD Pipeline
The Jenkins pipeline automates the entire deployment process.

Pipeline stages:
1. Checkout Source Code
2. Install Dependencies
3. Lint Frontend
4. Run Unit Tests
5. Build Docker Images
6. Scan Images with Trivy
7. Push Images to Docker Hub
8. Deploy Updated Images to Kubernetes
9. Validate Deployment
<img width="1882" height="895" alt="Jenkins- Stage" src="https://github.com/user-attachments/assets/90a963b7-d25b-480c-84a9-0ddeb6f10c3c" />
<img width="1906" height="775" alt="DockerHub" src="https://github.com/user-attachments/assets/a936b38d-3c03-4043-af0b-ef7b5fb60074" />

---
# 🐳 Docker Compose
Run the application locally using the helper script.

Start the application:
```bash
./deploy.sh start
```
Stop the application:
```bash
./deploy.sh stop
```
Restart the application:
```bash
./deploy.sh restart
```
Check the status:
```bash
./deploy.sh status
```
---

# ☸️ Kubernetes Deployment
Deploy the application to a Kind cluster:

```bash
./scripts/bootstrap-kind.sh
```

Verify the deployment:

```bash
kubectl get pods -n product-catalog
kubectl get svc -n product-catalog
kubectl get ingress -n product-catalog
```

Access the application:

```
http://product-catalog.local
```
---
# 📄 License
This project is intended for learning and portfolio purposes.
