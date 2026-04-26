# 🚀 Banking Modern Data Stack

## 📌 Overview

This project is an end-to-end Data Engineering pipeline for a simulated banking system. It generates realistic banking data, captures database changes with CDC, stores raw events as Parquet, loads them into Snowflake, and builds analytics-ready dbt models.

- **Problem solved:** creates a reliable pipeline for customer, account, and transaction analytics.
- **Data sources:** synthetic `customers`, `accounts`, and `transactions` data generated with Faker and stored in PostgreSQL.
- **Final output:** MinIO Parquet files, Snowflake raw tables, dbt staging models, SCD Type 2 snapshots, fact/dimension marts, and a Power BI report file (`banking.pbix`).

## 🏗 Architecture

<img width="100%" alt="Banking Modern Data Stack Architecture" src="https://github.com/user-attachments/assets/7521ea8a-451e-46ff-9db0-71dd6ddf8181" />

Pipeline flow:

1. Faker inserts banking records into PostgreSQL.
2. Debezium captures PostgreSQL changes through logical replication.
3. Kafka streams CDC topics for customers, accounts, and transactions.
4. A Python consumer writes Kafka batches to MinIO as Parquet.
5. Airflow loads MinIO files into Snowflake raw tables.
6. dbt builds staging views, snapshots, dimensions, and facts.
7. Power BI can be used for reporting from the analytics layer.

## 🔄 Data Pipeline

- **Extract / Ingest:** `data-generator/faker_generator.py` creates source records in PostgreSQL using `postgres/schema.sql`. `kafka-debezium/generate_and_post_connector.py` registers the Debezium connector for `public.customers`, `public.accounts`, and `public.transactions`.
- **Transform:** `consumer/kafka_to_minio.py` extracts `payload.after` from CDC messages and writes Parquet files. dbt models parse Snowflake raw data into `stg_customers`, `stg_accounts`, and `stg_transactions`.
- **Load:** `docker/dags/minion_to_snowflake.py` loads MinIO Parquet files into Snowflake with `COPY INTO`. TODO: add Snowflake RAW table DDL scripts; dbt expects a source column named `v`.
- **Orchestration:** Docker Compose runs PostgreSQL, Kafka, Zookeeper, Debezium Connect, MinIO, pgAdmin, Airflow, and the Kafka consumer. Airflow DAGs include `minio_to_snowflake_banking` and `SCD2_snapshots`.
- **Data Quality / Validation:** PostgreSQL constraints enforce keys, relationships, unique emails, non-negative balances, and positive transaction amounts. GitHub Actions runs Ruff, placeholder pytest execution, and `dbt compile`. TODO: add dbt tests for `not_null`, `unique`, `relationships`, accepted values, and source freshness.
- **Analytics / Dashboard:** dbt builds `dim_customer`, `dim_account`, and `fact_transaction`. `banking.pbix` is included for Power BI reporting. TODO: add dashboard screenshots.

## 🛠 Tech Stack

![Tech Stack](https://skillicons.dev/icons?i=py,docker,postgres,kafka,git,githubactions)

Additional tools used: Apache Airflow, Debezium, dbt, Snowflake, MinIO, Power BI, Faker, Pandas, Boto3, Fastparquet, and SQL.

## 📂 Project Structure

```text
banking-modern-datastack/
|-- .github/workflows/          # CI/CD workflows
|-- banking_dbt/                # dbt models, sources, snapshots, and marts
|-- consumer/                   # Kafka-to-MinIO Parquet consumer
|-- data-generator/             # Faker-based source data generator
|-- docker/dags/                # Airflow DAGs
|-- kafka-debezium/             # Debezium connector registration
|-- postgres/                   # PostgreSQL OLTP schema
|-- banking.pbix                # Power BI report file
|-- docker-compose.yml          # Local infrastructure
|-- dockerfile                  # Airflow image with dbt
|-- requirements.txt            # Python dependencies
`-- README.md
```

Runtime folders such as `dbt_venv/`, `banking_dbt/target/`, `docker/postgres/data/`, `docker/minio/data/`, and `docker/logs/` are generated locally.

## ⚙️ How to Run

1. Clone the repository.

```bash
git clone <repo-url>
cd banking-modern-datastack
```

2. Configure environment files.

Create or update `.env`, `consumer/.env`, `data-generator/.env`, `kafka-debezium/.env`, `docker/dags/.env`, and `banking_dbt/.dbt/profiles.yml` with local service credentials and Snowflake credentials.

TODO: add sanitized `.env.example` files.

3. Install local dependencies.

```powershell
python -m venv .venv
.\.venv\Scripts\Activate.ps1
pip install -r requirements.txt
```

4. Start Docker services.

```bash
docker compose up -d --build
```

5. Initialize PostgreSQL.

```bash
docker compose cp postgres/schema.sql postgres:/tmp/schema.sql
docker compose exec postgres psql -U <POSTGRES_USER> -d <POSTGRES_DB> -f /tmp/schema.sql
```

6. Register CDC and generate data.

```bash
python kafka-debezium/generate_and_post_connector.py
python data-generator/faker_generator.py
```

Use `--once` for a single generator iteration. The Kafka consumer writes files after its batch size is reached.

7. Run the warehouse pipeline.

- Airflow: `http://localhost:8080`
- Trigger `minio_to_snowflake_banking`.
- Trigger `SCD2_snapshots` or run dbt manually from `banking_dbt/`.

8. Verify output.

- Kafka Connect: `http://localhost:8083/connectors`
- MinIO console: `http://localhost:9001`
- pgAdmin: `http://localhost:5050`
- Snowflake: check raw tables, snapshots, and marts.

## 📊 Results / Output

- Raw Parquet files in MinIO partitioned by table and date.
- Snowflake raw tables for customers, accounts, and transactions.
- dbt staging views for cleaned source records.
- SCD Type 2 snapshots for customer and account history.
- Analytics marts: `dim_customer`, `dim_account`, and `fact_transaction`.
- Power BI report file: `banking.pbix`.

TODO: add screenshots of Airflow, MinIO, Snowflake, and Power BI outputs.

## 💡 Key Learnings

- Designed a CDC pipeline from an OLTP database to a cloud data warehouse.
- Used Kafka and Debezium for near real-time change capture.
- Built object-storage ingestion with Python, Parquet, and S3-compatible APIs.
- Modeled dimensions, facts, and SCD Type 2 snapshots with dbt.
- Added CI/CD validation with GitHub Actions.

## 🚧 Future Improvements

- Add `.env.example` files and Snowflake RAW table DDL scripts.
- Add dbt schema tests and source freshness checks.
- Add structured logging, Airflow alerts, and consumer metrics.
- Chain the dbt mart refresh task after snapshots in Airflow.
- Add cloud deployment notes and dashboard screenshots.

## 📬 Contact

TODO: Add your preferred contact details.

- GitHub: `<your-github-profile>`
- LinkedIn: `<your-linkedin-profile>`
- Email: `<your-email>`
