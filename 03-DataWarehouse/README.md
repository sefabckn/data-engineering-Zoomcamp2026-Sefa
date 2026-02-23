## Data Warehouse (BigQuery + Kestra)

This folder contains the **Data Warehouse** work for NYC Taxi data:

- **Ingestion orchestration** with **Kestra** (download CSVs and upload to GCS)
- **Warehouse tables** in **BigQuery** (external tables, partitioning, clustering)
- **BigQuery ML** example (linear regression for tip prediction)
- **Homework**: load 2024 parquet to GCS + run BigQuery queries

## Folder contents

- **`docker-compose.yml`**: local stack for development
  - `pgdatabase`: Postgres for the course DB (port `5432`)
  - `pgadmin`: UI for Postgres (port `8085`)
  - `kestra_postgres` + `kestra`: Kestra server + its Postgres backend (ports `8080`/`8081`)
- **`flows/01_ingestion_2019_2020_csv.yaml`**: Kestra flow that downloads monthly TLC files (2019–2020) and uploads them to GCS
- **`01_Script_DataWarehouse.sql`**: BigQuery SQL for external tables + partitioning/clustering exploration (2019–2020 CSVs)
- **`02_Script_DataWarehouse_ML.sql`**: BigQuery ML (train/evaluate/predict + hyperparameter tuning)
- **`homework/load_etl.py`**: downloads 2024 yellow taxi parquet files (Jan–Jun) and uploads them to a GCS bucket
- **`homework/HW_Queries_Answers.sql`**: BigQuery homework queries + answers (2024 parquet)

## Prerequisites

- **Docker Desktop** (Windows/macOS/Linux)
- **A Google Cloud project** with:
  - **GCS bucket** (for taxi files)
  - **BigQuery dataset** (e.g. `zoomcamp`)
  - Permissions to create tables/models in BigQuery and to upload to GCS
- Optional (for `load_etl.py`):
  - **Python 3.10+**
  - `google-cloud-storage` installed and authenticated via `gcloud auth application-default login`

## Quickstart: start Postgres + Kestra

From this folder:

```bash
docker compose up -d
```

Then open:

- **Kestra UI**: `http://localhost:8080`  
  - Username: `admin@kestra.io`
  - Password: `Admin1234`
- **pgAdmin**: `http://localhost:8085`  
  - Email: `admin@admin.com`
  - Password: `root`

Postgres connection (for `pgdatabase`) if you add it inside pgAdmin:

- **host**: `pgdatabase` (from within Docker) or `localhost` (from your host OS)
- **port**: `5432`
- **db**: `ny_taxi`
- **user/password**: `root` / `root`

## Kestra ingestion flow (2019–2020 CSV → GCS)

The flow in `flows/01_ingestion_2019_2020_csv.yaml`:

- downloads `yellow` or `green` monthly files from the DataTalksClub release assets
- uploads them to `gs://<your-bucket>/<file>.csv`
- is scheduled monthly via a cron trigger

### Required Kestra KV variables

In the Kestra UI, create KV entries (namespace `zoomcamp`) that match the flow:

- `GCP_PROJECT_ID`
- `GCP_LOCATION`
- `GCP_BUCKET_NAME`
- `GCP_CREDS` (service account JSON content)

After setting KV values, you can run the flow manually (select `yellow` or `green`), or rely on the schedule.

## BigQuery: warehouse tables + optimizations

### `01_Script_DataWarehouse.sql`

This script demonstrates:

- creating a **BigQuery external table** over files in GCS
- materializing it into a regular table
- creating **partitioned** and **partitioned + clustered** tables
- observing the impact on bytes processed

Important: the script currently contains hard-coded identifiers like:

- project: `taxi-rides-ny-485508`
- dataset: `zoomcamp`
- bucket: `taxi-rides-ny-485508-terra-bucket`

Replace those with your own GCP project/dataset/bucket before running in BigQuery.

### `02_Script_DataWarehouse_ML.sql`

This script:

- creates a curated ML table (casts categorical IDs to `STRING`)
- trains a `linear_reg` model to predict `tip_amount`
- runs `ML.EVALUATE`, `ML.PREDICT`, and `ML.EXPLAIN_PREDICT`
- includes an example of **hyperparameter tuning** (`num_trials`, `l1_reg`, `l2_reg`)

## Homework (2024 parquet)

### 1) Upload 2024 parquet files to GCS

`homework/load_etl.py` downloads:

- `yellow_tripdata_2024-01..06.parquet` from `https://d37ci6vzurychx.cloudfront.net/trip-data/`

and uploads them to the configured GCS bucket.

Before running, update these constants in `homework/load_etl.py`:

- `BUCKET_NAME`
- `storage.Client(project=...)`

Run:

```bash
python homework/load_etl.py
```

### 2) Run BigQuery homework queries

Open `homework/HW_Queries_Answers.sql` in BigQuery and run it (after replacing project/dataset/bucket names if needed).  
It creates an external table over the parquet files, materializes it, and applies partitioning/clustering optimizations.

## Notes / troubleshooting

- **Windows + Docker**: the `kestra` service mounts `/var/run/docker.sock` for some task execution modes; on Windows this requires Docker Desktop and may behave differently than on Linux. If you hit mount/permission issues, you can comment out that mount for basic UI + flow editing.
- **Ports in use**: if you already use `5432`, `8080`, `8081`, or `8085`, change the host-side port mappings in `docker-compose.yml`.

