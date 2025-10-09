#!/bin/env bash
set -euo pipefail

# Get absolute path of the directory containing this script
script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
project_dir="${script_dir}/../.."

STACK_NAME=$(tomlq '.default.global.parameters.stack_name' ${project_dir}/samconfig.toml | jq -r)
REGION=$(tomlq '.default.deploy.parameters.region' ${project_dir}/samconfig.toml | jq -r)
ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)
REPO_NAME=$(cat ${project_dir}/.resourceids-${STACK_NAME}/ExampleTaskRepository.txt)
IMAGE_TAG="${IMAGE_TAG:-latest}"
ECR_URI="${ACCOUNT_ID}.dkr.ecr.${REGION}.amazonaws.com/${REPO_NAME}:${IMAGE_TAG}"

echo "ECR_URI: ${ECR_URI}"

# login & push
aws ecr get-login-password --region $REGION \
 | docker login --username AWS --password-stdin ${ACCOUNT_ID}.dkr.ecr.${REGION}.amazonaws.com

docker tag docker.io/library/fargate-example-exampletask:latest ${ECR_URI}
docker push ${ECR_URI}

