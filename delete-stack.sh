#!/usr/bin/env bash
set -euo pipefail

STACK_NAME=$(tomlq -r '.default.global.parameters.stack_name' samconfig.toml)
REGION=$(tomlq -r '.default.deploy.parameters.region' samconfig.toml)
REPO_NAME=$(cat .resourceids-${STACK_NAME}/ExampleTaskRepository.txt)

echo "You are about to delete the CloudFormation stack:"
echo "  Name   : ${STACK_NAME}"
echo "  Region : ${REGION}"
echo
read -r -p "Are you sure? (y/N): " confirm

if [[ "${confirm}" =~ ^[Yy]$ ]]; then

  echo "Deleting all images from ECR repository: $REPO_NAME in region $REGION"
  read -p "Are you sure you want to delete ALL images from this repository? Type 'yes' to continue: " CONFIRM
  if [ "$CONFIRM" != "yes" ]; then
    echo "Aborted. No images deleted."
    exit 1
  fi

  # List all image digests
  IMAGE_IDS=$(aws ecr list-images --region "$REGION" --repository-name "$REPO_NAME" --query 'imageIds[*]' --output json)

  if [ "$IMAGE_IDS" != "[]" ]; then
    aws ecr batch-delete-image --region "$REGION" --repository-name "$REPO_NAME" --image-ids "$IMAGE_IDS"
    echo "All images deleted."
  else
    echo "No images found in repository."
  fi


  echo "Deleting stack ${STACK_NAME} in region ${REGION}..."
  aws cloudformation delete-stack --region "${REGION}" --stack-name "${STACK_NAME}"
  echo "Delete command submitted. Watch it go away by opening the AWS console:"
  echo "https://${REGION}.console.aws.amazon.com/cloudformation/home"
else
  echo "Aborted."
fi
