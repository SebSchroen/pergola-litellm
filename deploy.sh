#!/bin/bash
# Script to prepare the stage configuration with secrets and environment variables on Pergola,
# reading them from an external .env file, and triggering the initial build and deployment.
# Usage: ./deploy.sh <project-name> <stage-name>

set -e

if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <project-name> <stage-name>"
    exit 1
fi

PROJECT_NAME=$1
STAGE_NAME=$2

ENV_FILE=".env"
if [ ! -f "$ENV_FILE" ]; then
    echo "Error: $ENV_FILE file not found in current directory."
    exit 1
fi

echo "Loading configuration variables from $ENV_FILE..."
# Read the .env file and build arguments for pergola command
ENV_ARGS=()
while IFS= read -r line || [[ -n "$line" ]]; do
    # Skip empty lines and comments
    if [[ -z "$line" || "$line" =~ ^# ]]; then
        continue
    fi
    ENV_ARGS+=("--env" "$line")
done < "$ENV_FILE"

echo "Configuring environment variables and secrets for project: ${PROJECT_NAME}, stage: ${STAGE_NAME}..."

pergola add config-data default -p "${PROJECT_NAME}" -s "${STAGE_NAME}" "${ENV_ARGS[@]}"

echo "Configuration applied successfully from $ENV_FILE."
echo "Now you can trigger a build and release with:"
echo "  pergola push build -p ${PROJECT_NAME}"
echo "  pergola push release -p ${PROJECT_NAME} -s ${STAGE_NAME} -b <build-name> -c default"
