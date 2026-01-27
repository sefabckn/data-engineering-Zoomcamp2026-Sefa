# NYC Taxi Data Ingestion Pipeline

A production-ready data pipeline that ingests NYC yellow taxi data into a PostgreSQL database using Docker, Python, and containerized services.

## 🎯 Learning Outcomes

This project demonstrates key data engineering concepts:
- **Containerization** with Docker for consistent environments
- **CLI Development** using Click for parameterized automation
- **Data Ingestion** with pandas and SQLAlchemy
- **Database Management** with PostgreSQL and pgAdmin
- **Docker Compose** for multi-service orchestration
- **Efficient Dependency Management** with uv package manager

---

## 📚 Architecture Overview

```
┌─────────────────────────────────────────────────┐
│   NYC Taxi Data Source (GitHub CSV.GZ)          │
└─────────────────┬───────────────────────────────┘
                  │
                  ▼
┌─────────────────────────────────────────────────┐
│   Python Ingestion Script (ingest_data.py)      │
│   - Downloads & parses CSV                      │
│   - Chunks data for memory efficiency           │
│   - Type conversion & validation                │
└─────────────────┬───────────────────────────────┘
                  │
                  ▼
┌─────────────────────────────────────────────────┐
│   PostgreSQL Database (Docker Container)        │
│   - Persistent storage (ny_taxi_postgres_data)  │
│   - ny_taxi database                            │
└──────────────────────────────────────────────────┘
                  ▲
                  │
┌─────────────────────────────────────────────────┐
│   pgAdmin UI (Docker Container)                 │
│   - Query visualization & management            │
└─────────────────────────────────────────────────┘
```

---

## 🔑 Key Components

### 1. **Data Type Mapping** (Type Safety)

```python
dtype = {
    "VendorID": "Int64",
    "passenger_count": "Int64",
    "trip_distance": "float64",
    "RatecodeID": "Int64",
    "store_and_fwd_flag": "string",
    "PULocationID": "Int64",
    "DOLocationID": "Int64",
    "payment_type": "Int64",
    "fare_amount": "float64",
    "extra": "float64",
    "mta_tax": "float64",
    "tip_amount": "float64",
    "tolls_amount": "float64",
    "improvement_surcharge": "float64",
    "total_amount": "float64",
    "congestion_surcharge": "float64"
}
```

**Why this matters:**
- Explicit type conversion prevents data type mismatches in the database
- Nullable integers (`Int64` vs `int64`) handle missing values gracefully
- Consistent schema ensures data quality and query performance

### 2. **CLI Parameter Management** (Automation & Flexibility)

```python
@click.command()
@click.option('--pg-user', default='root', help='PostgreSQL username')
@click.option('--pg-pass', default='root', help='PostgreSQL password')
@click.option('--pg-host', default='localhost', help='PostgreSQL host')
@click.option('--pg-port', default='5432', help='PostgreSQL port')
@click.option('--pg-db', default='ny_taxi', help='PostgreSQL database name')
@click.option('--year', default=2021, type=int, help='Year of the data')
@click.option('--month', default=1, type=int, help='Month of the data')
@click.option('--chunksize', default=100000, type=int, help='Chunk size for ingestion')
@click.option('--target-table', default='yellow_taxi_data', help='Target table name')
def main(pg_user, pg_pass, pg_host, pg_port, pg_db, year, month, chunksize, target_table):
```

**Why this matters:**
- Eliminates hardcoding; parameters are injected at runtime
- Default values work out-of-the-box but allow overrides
- Enables easy reuse for different years, months, or table names
- Critical for production pipelines that run on different environments

### 3. **Dynamic URL Construction** (Scalability)

```python
prefix = 'https://github.com/DataTalksClub/nyc-tlc-data/releases/download/yellow/'
url = f'{prefix}/yellow_tripdata_{year}-{month:02d}.csv.gz'
```

**Why this matters:**
- Uses f-strings for clean string interpolation
- `{month:02d}` ensures zero-padded months (e.g., `01` not `1`)
- Allows fetching any year/month without code changes
- Demonstrates dynamic API construction

### 4. **Database Connection** (SQLAlchemy ORM)

```python
engine = create_engine(
    f'postgresql://{pg_user}:{pg_pass}@{pg_host}:{pg_port}/{pg_db}'
)
```

**Why this matters:**
- `create_engine()` establishes connection pooling for efficiency
- Connection string is dynamically built from parameters
- SQLAlchemy abstracts database differences (works with MySQL, SQLite, etc. with same code)
- Follows URI format: `dialect+driver://username:password@host:port/database`

### 5. **Chunked Data Processing** (Memory Efficiency)

```python
df_iter = pd.read_csv(
    url,
    chunksize=chunksize,
    dtype=dtype,
    parse_dates=parse_dates
)

first = True

for df_chunk in tqdm(df_iter):
    if first:
        # Create table schema on first chunk
        df_chunk.head(0).to_sql(
            name=target_table,
            con=engine,
            if_exists='replace',
            index=False
        )
        first = False

    # Append remaining chunks
    df_chunk.to_sql(
        name=target_table,
        con=engine,
        if_exists='append',
        index=False
    )
```

**Why this matters:**
- **Chunked reading**: Loads 100,000 rows at a time instead of entire file (NYC taxi data is multi-GB)
- **Two-phase insert**: 
  - First chunk creates table with correct schema
  - Remaining chunks append data
- **Progress tracking**: `tqdm` shows real-time progress bar
- **Memory safety**: Prevents out-of-memory errors with large datasets

---

## 🐳 Docker & Containerization

### Dockerfile Strategy

```dockerfile
FROM python:3.13.11-slim

COPY --from=ghcr.io/astral-sh/uv:latest /uv /bin/

WORKDIR /app
ENV PATH="/app/.venv/bin:$PATH"

COPY "pyproject.toml" "uv.lock" ".python-version" ./
RUN uv sync --locked

COPY ingest_data.py ingest_data.py 

ENTRYPOINT [ "python", "ingest_data.py" ]
```

**Key learnings:**
- **Multi-stage build**: Copy `uv` from official image (reduces image size)
- **Layer caching**: Dependencies copied first (changes rarely) before application code
- **Virtual environment in container**: Ensures isolated, reproducible environment
- **Slim base image**: Python 3.13-slim is only ~150MB vs ~900MB full Python image
- **Locked dependencies**: `uv.lock` ensures identical behavior across environments

### Docker Compose Orchestration

```yaml
services:
  pgdatabase:
    image: postgres:18
    environment:
      - POSTGRES_USER=root
      - POSTGRES_PASSWORD=root
      - POSTGRES_DB=ny_taxi
    volumes:
      - "ny_taxi_postgres_data:/var/lib/postgresql:rw"
    ports:
      - "5432:5432"
```

**Key learnings:**
- **Named volumes**: `ny_taxi_postgres_data` persists data between container restarts
- **Environment variables**: Credentials passed to container (avoid hardcoding)
- **Port mapping**: Host port 5432 → Container port 5432
- **Service discovery**: Containers communicate via service name (`pgdatabase`)

---

## 🚀 Quick Start

### Prerequisites
- Docker & Docker Compose
- Python 3.13+ (if running locally)

### Option 1: Docker Compose (Recommended)

```bash
# Start PostgreSQL and pgAdmin
docker-compose up -d

# Run ingestion with default parameters
docker run -it \
  --network="pipeline_default" \
  -e PYTHONUNBUFFERED=1 \
  -v $(pwd):/app \
  python:3.13-slim \
  python ingest_data.py \
    --pg-host pgdatabase \
    --pg-user root \
    --pg-pass root \
    --pg-db ny_taxi \
    --year 2024 \
    --month 1
```

### Option 2: Local Development

```bash
# Install dependencies
uv sync

# Run ingestion
python ingest_data.py --year 2024 --month 1 --pg-host localhost
```

---

## 📊 Access Data

- **PostgreSQL**: `localhost:5432` (user: `root`, password: `root`)
- **pgAdmin**: `http://localhost:8085` (email: `admin@admin.com`, password: `root`)

### Query Example in pgAdmin

```sql
SELECT 
  tpep_pickup_datetime,
  passenger_count,
  trip_distance,
  fare_amount,
  total_amount
FROM yellow_taxi_data
LIMIT 10;
```

---

## 📦 Dependencies

| Package | Purpose |
|---------|---------|
| `pandas` | Data manipulation & CSV parsing |
| `sqlalchemy` | ORM for database abstraction |
| `psycopg2-binary` | PostgreSQL adapter |
| `click` | CLI framework |
| `tqdm` | Progress bars |
| `pyarrow` | Efficient data formats |

**Dev dependencies:**
- `jupyter`: Interactive notebooks for exploration
- `pgcli`: Command-line PostgreSQL client

---

## 🎓 Concepts Demonstrated

✅ **Data Pipeline Design**: Source → Transform → Load (ETL)
✅ **Containerization**: Reproducible, portable environments
✅ **Type Safety**: Explicit schema definition
✅ **Memory Efficiency**: Chunked processing for large datasets
✅ **Automation**: CLI-driven parameterization
✅ **Database Design**: Relational schema with PostgreSQL
✅ **DevOps**: Docker Compose for local development
✅ **Best Practices**: Virtual environments, locked dependencies, layer caching

---

## 🔄 Next Steps / Enhancements

- Add data validation & error handling
- Implement logging & monitoring
- Add unit tests with pytest
- Parameterize Dockerfile CMD with environment variables
- Create Terraform configuration for cloud deployment
- Add data quality checks (duplicate detection, null value handling)
