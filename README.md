# 🚀 Data Engineering Zoomcamp 2026 — NYC Taxi Project

> A comprehensive data engineering portfolio demonstrating modern data stack tools and best practices for building production-grade data pipelines.

![Python](https://img.shields.io/badge/Python-3.13-blue?logo=python) ![Docker](https://img.shields.io/badge/Docker-Compose-2496ED?logo=docker) ![Terraform](https://img.shields.io/badge/Terraform-7.16-623CE4?logo=terraform) ![PostgreSQL](https://img.shields.io/badge/PostgreSQL-Database-336791?logo=postgresql) ![BigQuery](https://img.shields.io/badge/BigQuery-Google%20Cloud-4285F4?logo=google-cloud) ![dbt](https://img.shields.io/badge/dbt-Analytics-FF6849?logo=dbt)

---

## 📋 Table of Contents

- [Overview](#overview)
- [Project Modules](#project-modules)
- [Architecture](#architecture)
- [Tech Stack](#tech-stack)
- [Quick Start](#quick-start)
- [Folder Structure](#folder-structure)
- [Key Features](#key-features)
- [Setup Instructions](#setup-instructions)

---

## 📌 Overview

This project is a **10-week Data Engineering bootcamp journey** showcasing how to build **production-grade data pipelines** from scratch. It follows the DataTalks.Club Data Engineering Zoomcamp curriculum and implements **real-world NYC taxi data workflows** using industry-standard tools.

The course covers:
- ✅ **7 weeks** of core modules (containerization, orchestration, warehousing, analytics)
- ✅ **3 weeks** for final project implementation
- ✅ **End-to-end pipeline** from data ingestion → transformation → analytics

---

## 🏗️ Project Modules

### **Module 1: Docker & Terraform** 📦
*Location: `01-docker-terraform/`*

Build containerized data ingestion pipelines with infrastructure-as-code.

**Key Components:**
- **Pipeline**: Docker containerized Python scripts for NYC taxi data ingestion
  - Download & parse CSV data from GitHub
  - Ingest into PostgreSQL using pandas + SQLAlchemy
  - Parameterized CLI with Click framework
- **Terraform**: Infrastructure provisioning for Google Cloud
  - GCS buckets for data storage
  - BigQuery datasets for analytics
  - Service account management

**Technologies**: Docker, Docker Compose, Terraform, PostgreSQL, Python, Click, pandas, SQLAlchemy

---

### **Module 2: Workflow Orchestration** 🎯
*Location: `02-Workflow-Orchestration/`*

Schedule and orchestrate complex data workflows with Kestra.

**Key Components:**
- **Kestra Server**: Open-source workflow orchestration engine
- **Example Flows**: 
  - Hello World workflows
  - Python task execution
  - PostgreSQL integration
  - GCP service integration
- **Database**: Postgres backend for Kestra state management

**Technologies**: Kestra, Docker, PostgreSQL, YAML, Bash/Python tasks

---

### **Module 3: Data Warehouse** 🏢
*Location: `03-DataWarehouse/`*

Build scalable data warehouse solutions with BigQuery & BigQuery ML.

**Key Components:**
- **Ingestion Flows**: Kestra workflows to download TLC taxi files and upload to GCS
- **Warehouse Design**: 
  - External tables for raw data
  - Partitioning & clustering for query optimization
  - BigQuery ML models (linear regression for tip prediction)
- **ETL Scripts**: Python utilities to load parquet files to GCS

**Technologies**: BigQuery, GCS, Kestra, BigQuery ML, Python, SQL

---

### **Module 4: Analytics Engineering** 📊
*Location: `04-Analytics-Engineering/`*

Transform raw data into analytics-ready datasets using dbt.

**Key Components:**
- **dbt Project**: Data transformation workflows
  - Models for data cleaning & aggregation
  - Macros for reusable transformations
  - Tests & documentation
- **Staging & Mart layers**: Best practice dimensional modeling

**Technologies**: dbt, BigQuery, Jinja2, YAML

---

## 🏛️ Architecture

```
┌─────────────────────────────────────────────────┐
│         Data Source: NYC Taxi (GitHub)          │
└────────────────────┬────────────────────────────┘
                     │
        ┌────────────┴────────────┐
        │                         │
        ▼                         ▼
  ┌───────────────┐        ┌──────────────┐
  │ PostgreSQL    │        │ GCS Bucket   │
  │ (Local Dev)   │        │ (Production) │
  └───────┬───────┘        └──────┬───────┘
          │                       │
          └───────────┬───────────┘
                      │
                      ▼
            ┌─────────────────────┐
            │  BigQuery DW        │
            │ • External Tables   │
            │ • Staging Layer     │
            │ • Mart Tables       │
            └──────────┬──────────┘
                       │
                       ▼
            ┌─────────────────────┐
            │  dbt Transformations│
            │ • Models            │
            │ • Tests             │
            │ • Documentation     │
            └──────────┬──────────┘
                       │
                       ▼
            ┌─────────────────────┐
            │ Analytics Dashboard │
            │ (Looker/Tableau)    │
            └─────────────────────┘

              ⚙️  Orchestration: Kestra  ⚙️
```

---

## 🛠️ Tech Stack

| Layer | Technology | Purpose |
|-------|-----------|---------|
| **Containerization** | Docker, Docker Compose | Environment consistency & multi-service orchestration |
| **Infrastructure** | Terraform, Google Cloud | IaC for GCS, BigQuery, service accounts |
| **Data Ingestion** | Python, Click, pandas | CLI-driven ETL scripts |
| **Data Storage** | PostgreSQL, GCS, BigQuery | Raw data, intermediate, warehouse |
| **Orchestration** | Kestra, YAML | Workflow scheduling & monitoring |
| **Transformation** | dbt, SQL, Jinja2 | Analytics-ready data modeling |
| **Database** | BigQuery, BigQuery ML | Warehouse & ML model training |
| **Development** | Jupyter, pgcli | Interactive development & debugging |

---

## 🚀 Quick Start

### Prerequisites
- **Docker Desktop** (Windows/macOS/Linux)
- **Terraform** CLI (v1.0+)
- **Python** 3.13+
- **Google Cloud Account** (with GCS & BigQuery enabled)
- **gcloud CLI** configured

### 1️⃣ Clone & Navigate
```bash
cd data-engineering-Zoomcamp2026-Sefa
```

### 2️⃣ Start PostgreSQL + pgAdmin (Development)
```bash
cd 01-docker-terraform/pipeline
docker compose up -d
# Access pgAdmin at http://localhost:5050
```

### 3️⃣ Run Data Ingestion Pipeline
```bash
cd 01-docker-terraform/pipeline
pip install uv
uv pip install -e .
python main.py
```

### 4️⃣ Start Kestra Orchestration
```bash
cd 02-Workflow-Orchestration
docker compose up -d
# Access Kestra UI at http://localhost:8080
# Login: admin@kestra.io / Admin1234
```

### 5️⃣ Provision GCP Infrastructure (Terraform)
```bash
cd 01-docker-terraform/terraform
terraform init
terraform plan
terraform apply
```

### 6️⃣ Run BigQuery Warehouse Setup
```bash
cd 03-DataWarehouse
# Run SQL scripts in BigQuery console or via:
# - flows/01_ingestion_2019_2020_csv.yaml (in Kestra)
# - homework/load_etl.py (Python)
```

### 7️⃣ Transform Data with dbt
```bash
cd 04-Analytics-Engineering
dbt deps
dbt run
dbt test
dbt docs generate
```

---

## 📁 Folder Structure

```
data-engineering-Zoomcamp2026-Sefa/
│
├── 📄 README.md                          # This file
│
├── 01-docker-terraform/                  # Containerization & IaC
│   ├── pipeline/
│   │   ├── Dockerfile                    # Python environment
│   │   ├── docker-compose.yaml           # Multi-service setup
│   │   ├── pyproject.toml               # Dependencies (uv)
│   │   ├── ingest_data.py               # Data ingestion logic
│   │   ├── main.py                      # CLI entry point
│   │   ├── pipeline.py                  # Pipeline orchestration
│   │   ├── *.ipynb                      # Exploratory notebooks
│   │   └── README.md                    # Module documentation
│   │
│   └── terraform/
│       ├── main.tf                      # Resource definitions
│       ├── variables.tf                 # Input variables
│       ├── keys/my-cred.json            # GCP credentials
│       └── terraform.tfstate            # State file
│
├── 02-Workflow-Orchestration/            # Kestra Workflows
│   ├── docker-compose.yml               # Kestra + PostgreSQL
│   ├── flows/                           # YAML workflow definitions
│   │   ├── 01_Hello_World.yaml
│   │   ├── 02_python.yaml
│   │   ├── 04_postgres_taxi.yaml
│   │   ├── 06_gcp_kv.yaml
│   │   └── ...
│   ├── homework_flows/                  # Assignment workflows
│   └── README.md                        # Module documentation
│
├── 03-DataWarehouse/                     # BigQuery & ML
│   ├── docker-compose.yml               # Local development stack
│   ├── 01_Script_DataWarehouse.sql      # Warehouse setup
│   ├── 02_Script_DataWarehouse_ML.sql   # BigQuery ML scripts
│   ├── flows/
│   │   └── 01_ingestion_2019_2020_csv.yaml
│   ├── homework/
│   │   ├── load_etl.py                  # 2024 parquet loader
│   │   └── HW_Queries_Answers.sql
│   └── README.md                        # Module documentation
│
├── 04-Analytics-Engineering/             # dbt Analytics Layer
│   ├── dbt_project.yml                  # dbt configuration
│   ├── models/
│   │   ├── staging/                    # Staging transformations
│   │   └── marts/                      # Dimensional models
│   ├── macros/                         # Reusable SQL functions
│   ├── tests/                          # Data quality tests
│   └── README.md                       # Module documentation
│
└── notes/                                # Learning Notes
    ├── docker-notes.ipynb
    └── Workflow-Orchestration-Complete.ipynb
```

---

## ⭐ Key Features

### 🔄 **End-to-End Data Pipeline**
- Automated data download from public sources
- Containerized ingestion with type safety
- Workflow orchestration with Kestra
- Data transformation with dbt

### 🔐 **Infrastructure as Code**
- Terraform for repeatable GCP provisioning
- Cloud Storage + BigQuery management
- Service account automation

### 📊 **Production-Ready Patterns**
- Partitioning & clustering for query optimization
- Data quality testing with dbt
- Modular, reusable SQL/Python
- CI/CD ready workflows

### 🐳 **Fully Containerized**
- Docker Compose for local development
- Multiple service orchestration
- Easy environment reproduction

### 📈 **Modern Data Stack**
- Scalable warehouse (BigQuery)
- Analytics engineering (dbt)
- Machine learning integration (BigQuery ML)

---

## 🛠️ Setup Instructions

### Google Cloud Setup
1. Create a project in Google Cloud Console
2. Enable APIs: BigQuery, Cloud Storage, Compute Engine
3. Create a service account with Editor role
4. Download JSON credentials → Save to `01-docker-terraform/terraform/keys/my-cred.json`
5. Update project ID in `01-docker-terraform/terraform/variables.tf`

### Local Development
```bash
# 1. Create Python virtual environment
python -m venv venv
source venv/Scripts/activate  # Windows: venv\Scripts\activate

# 2. Install project dependencies
cd 01-docker-terraform/pipeline
pip install uv
uv pip install -e .

# 3. Configure credentials
export GOOGLE_APPLICATION_CREDENTIALS="$(pwd)/../terraform/keys/my-cred.json"

# 4. Initialize Terraform
cd ../terraform
terraform init
```

---

## 📚 Learning Outcomes

By completing this project, you'll master:

✅ **Containerization** — Docker, multi-container orchestration  
✅ **Infrastructure as Code** — Terraform for cloud resources  
✅ **Data Pipelines** — ETL/ELT patterns, automation  
✅ **Orchestration** — Workflow scheduling with Kestra  
✅ **Data Warehouse** — BigQuery design & optimization  
✅ **Analytics Engineering** — dbt modeling & testing  
✅ **ML Integration** — BigQuery ML for predictions  
✅ **SQL & Python** — Data processing at scale  

---

## 📖 Resources

- [DataTalks.Club Zoomcamp](https://datatalks.club/blog/zoomcamp.html)
- [Terraform Documentation](https://www.terraform.io/docs)
- [Kestra Documentation](https://kestra.io/docs)
- [dbt Documentation](https://docs.getdbt.com)
- [BigQuery Best Practices](https://cloud.google.com/bigquery/docs/best-practices)

---

## 📧 Contact & Attribution

**Course:** DataTalks.Club Data Engineering Zoomcamp 2026  
**Implementation:** Sefa (afesb)  
**Last Updated:** April 2026

---

## 📝 License

This project is for educational purposes as part of the DataTalks.Club Zoomcamp program.
