# 🏦 Banking Modern Data Stack

## 📌 Project Overview
This project implements a **production-style end-to-end Modern Data Stack** for the **Banking domain**.

The pipeline simulates **customers, accounts, and transactions**, captures **real-time changes using CDC**, transforms data into **analytics-ready models**, and applies **CI/CD best practices** commonly used in real-world data platforms.

---

## 🏗️ System Architecture

<img width="5647" height="3107" alt="Architecture" src="https://github.com/user-attachments/assets/7521ea8a-451e-46ff-9db0-71dd6ddf8181" />

### Pipeline Flow
1. **Data Generator** simulates banking data using Faker  
2. **PostgreSQL** acts as the OLTP source system  
3. **Kafka + Debezium** captures change data (CDC) from Postgres  
4. **MinIO** stores raw CDC events (S3-compatible)  
5. **Apache Airflow** orchestrates ingestion and transformations  
6. **Snowflake** implements Bronze → Silver → Gold layers  
7. **dbt** builds transformations, marts, and SCD Type-2 snapshots  
8. **GitHub Actions** enables CI/CD workflows  

---

## ⚡ Tech Stack

### Data & Storage
- PostgreSQL (OLTP)
- Snowflake (Cloud Data Warehouse)
- MinIO (Object Storage)

### Streaming & Orchestration
- Apache Kafka
- Debezium (CDC)
- Apache Airflow

### Transformation & Analytics
- dbt
- SQL

### DevOps & Engineering
- Python (Faker)
- Docker & docker-compose
- Git & GitHub Actions

---

## ✅ Key Features
- Realistic banking OLTP schema (customers, accounts, transactions)
- Synthetic data generation for demos
- Change Data Capture (CDC) using Kafka + Debezium
- Medallion Architecture (Bronze, Silver, Gold)
- dbt staging, marts, and snapshots (SCD Type-2)
- Automated orchestration with Airflow
- CI/CD pipelines with data quality checks

---

## 📂 Repository Structure
```text
banking-modern-datastack/
├── .github/workflows/          # CI/CD pipelines
├── banking_dbt/               # dbt project
│   ├── models/
│   │   ├── staging/            # Staging models
│   │   ├── marts/              # Fact & dimension models
│   │   └── sources.yml
│   ├── snapshots/              # SCD Type-2 snapshots
│   └── dbt_project.yml
├── consumer/
│   └── kafka_to_minio.py       # Kafka consumer
├── data-generator/
│   └── faker_generator.py     # Synthetic data generator
├── docker/
│   └── dags/                   # Airflow DAGs
├── kafka-debezium/
│   └── generate_and_post_connector.py
├── postgres/
│   └── schema.sql              # OLTP schema
├── docker-compose.yml
├── dockerfile-airflow.dockerfile
├── requirements.txt
└── README.md
```

---

## ⚙️ Step-by-Step Implementation  

### **1. Data Simulation**  
- Generated synthetic banking data (**customers, accounts, transactions**) using **Faker**.  
- Inserted data into **PostgreSQL (OLTP)** so the system behaves like a real transactional database (**ACID, constraints**).  
- Controlled generation via `config.yaml`.  

---

### **2. Kafka + Debezium CDC**  
- Set up **Kafka Connect & Debezium** to capture changes from **Postgres**.  
- Streamed **CDC events** into **MinIO**.  

---

### **3. Airflow Orchestration**  
- Built DAGs to:  
  - Ingest **MinIO data → Snowflake (Bronze)**.  
  - Schedule **snapshots & incremental loads**.  

---

### **4. Snowflake Warehouse**  
- Organized into **Bronze → Silver → Gold layers**.  
- Created **staging schemas** for ingestion.  

---

### **5. DBT Transformations**  
- **Staging models** → cleaned source data.  
- **Dimension & fact models** → built marts.  
- **Snapshots** → tracked history of accounts & customers.  

---

### **6. CI/CD with GitHub Actions**  
- **ci.yml** → Lint, dbt compile, run tests.  
- **cd.yml** → Deploy DAGs & dbt models on merge.  

---

## 📊 Final Deliverables

- End-to-end CDC pipeline from **PostgreSQL → Snowflake**
- Analytics-ready **dbt models** (fact, dimension, snapshots)
- Fully orchestrated workflows using **Apache Airflow**
- Containerized infrastructure with **Docker & docker-compose**
- **CI/CD-enabled** data workflows using GitHub Actions

---

## 🧠 Key Learnings

- Designing reliable **CDC-based data pipelines**
- Implementing **Medallion Architecture** (Bronze, Silver, Gold)
- Managing **Slowly Changing Dimensions (SCD Type-2)** with dbt
- Orchestrating complex data workflows using **Airflow**
- Applying **CI/CD best practices** in data engineering projects

---

**Concept inspired by**: *Jaya Chandra Kadiveti*



