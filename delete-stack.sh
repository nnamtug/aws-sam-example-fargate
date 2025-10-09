#!/usr/bin/env bash
set -euo pipefail

stackname=$(tomlq -r '.default.global.parameters.stack_name' samconfig.toml)
region=$(tomlq -r '.default.deploy.parameters.region' samconfig.toml)

echo "You are about to delete the CloudFormation stack:"
echo "  Name   : ${stackname}"
echo "  Region : ${region}"
echo
read -r -p "Are you sure? (y/N): " confirm

if [[ "${confirm}" =~ ^[Yy]$ ]]; then
  echo "Deleting stack ${stackname} in region ${region}..."
  aws cloudformation delete-stack --region "${region}" --stack-name "${stackname}"
  echo "Delete command submitted. Watch it go away by opening the AWS console https://${region}.console.aws.amazon.com/cloudformation/home"
else
  echo "Aborted."
fi
