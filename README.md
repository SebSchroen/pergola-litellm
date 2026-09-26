# Pergola LiteLLM Quickstart Stack

This repository contains the configuration and deployment scripts for running a production-ready **LiteLLM Gateway** backed by a persistent **PostgreSQL** database on the **Pergola** container deployment platform, as well as a local Docker Compose setup.

---

## Architecture

The stack consists of two components:
1. **`litellm`**: The LiteLLM database-backed proxy (`docker.litellm.ai/berriai/litellm-database:latest`), exposing port `4000` with ingress configured.
2. **`db`**: A PostgreSQL 16 database (`postgres:16`) storing models, virtual keys, and spend logs, backed by a persistent volume (`500Mi`).

---

## Repository Structure

- **`pergola.yaml`**: Pergola application manifest defining the `litellm` and `db` components, networking, environment mappings, and persistent storage.
- **`deploy.sh`**: Automation script to inject environment variables/secrets from a local `.env` file into Pergola stage configuration and prepare deployments.
- **`docker-compose.yaml`**: Standard Docker Compose file for local evaluation and testing.
- **`.env`**: Local environment variables and secrets (ignored in git).

---

## Prerequisites

- [Pergola CLI](https://docs.pergola.dev) installed and authenticated.
- Docker & Docker Compose (for local testing).

---

## Local Development (Docker Compose)

To run the stack locally for testing or development:

```bash
docker compose up -d
```

The LiteLLM proxy will be available at `http://localhost:4000`.

---

## Deploying to Pergola

### 1. Configure Environment Variables

Ensure you have a `.env` file in the root directory containing your master key, salt key, database credentials, and optional service IDs. Example:

```env
LITELLM_MASTER_KEY=sk-your-master-key
LITELLM_SALT_KEY=sk-your-salt-key
POSTGRES_USER=userlitellm
POSTGRES_PASSWORD=your-secure-password
POSTGRES_DB=litellm
GOOGLE_PSE_ENGINE_ID=your-engine-id
```

### 2. Run the Deployment Script

Use the provided `deploy.sh` script to upload your environment variables and secrets to your Pergola project stage:

```bash
./deploy.sh <project-name> <stage-name>
```

*Example:*
```bash
./deploy.sh ai-services production
```

### 3. Build and Release

After configuring the stage variables, follow the CLI prompts to build and release:

```bash
# Push and build the project components
pergola push build -p <project-name>

# Trigger a release for the specific stage
pergola push release -p <project-name> -s <stage-name> -b <build-name> -c default
```

---

## Environment Variables Reference

| Variable | Description |
| :--- | :--- |
| `LITELLM_MASTER_KEY` | Master API key used to authenticate administrative requests to LiteLLM. |
| `LITELLM_SALT_KEY` | Cryptographic salt key used by LiteLLM for key hashing. |
| `POSTGRES_USER` | PostgreSQL database username. |
| `POSTGRES_PASSWORD` | PostgreSQL database password. |
| `POSTGRES_DB` | PostgreSQL database name (defaults to `litellm`). |
| `DATABASE_URL` | Constructed connection string for LiteLLM to connect to PostgreSQL. |
| `STORE_MODEL_IN_DB` | Set to `True` to persist model configurations in the database. |
| `GOOGLE_PSE_ENGINE_ID` | Optional Google Programmable Search Engine ID for web search tools. |
