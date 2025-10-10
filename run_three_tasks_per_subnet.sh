
#!/bin/env bash
set -euo pipefail

# Get absolute path of the directory containing this script
script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
project_dir="${script_dir}"


STACK_NAME=$(tomlq '.default.global.parameters.stack_name' ${project_dir}/samconfig.toml | jq -r)
REGION=$(tomlq '.default.deploy.parameters.region' ${project_dir}/samconfig.toml | jq -r)
RESOURCE_DIR="${project_dir}/.resourceids-${STACK_NAME}"
CLUSTER_NAME=$(cat $RESOURCE_DIR/FargateCluster.txt)

SLEEP_SECONDS=7

echo "region: $REGION"

SUBNETS=(A B C)
for i in "${!SUBNETS[@]}"; do
  SUBNET_SUFFIX="${SUBNETS[$i]}"
  echo "Launching Fargate task for subnet $SUBNET_SUFFIX"
  aws ecs run-task \
    --region $REGION \
    --cluster $(cat $RESOURCE_DIR/FargateCluster.txt) \
    --task-definition $(cat $RESOURCE_DIR/ExampleTaskDefinition.txt) \
    --network-configuration "awsvpcConfiguration={subnets=[$(cat $RESOURCE_DIR/Subnet${SUBNET_SUFFIX}.txt)],securityGroups=[$(cat $RESOURCE_DIR/MySecurityGroup.txt)],assignPublicIp=ENABLED}" \
    --count 3 | cat

  echo "See what the cluster has to do:"
  echo "https://${REGION}.console.aws.amazon.com/ecs/v2/clusters?region=${REGION}"
  echo ""
  echo "Look how they are playing:"
  echo "https://${REGION}.console.aws.amazon.com/ecs/v2/clusters/${CLUSTER_NAME}/tasks?region=${REGION}"
  if [ "$i" -lt $((${#SUBNETS[@]} - 1)) ]; then
    echo "Sleeping for $SLEEP_SECONDS seconds before next task..."
    sleep $SLEEP_SECONDS
  fi
  done

echo "See the logs in CloudWatch Log Group:"
echo "https://${REGION}.console.aws.amazon.com/cloudwatch/home?region=${REGION}#logsV2:log-groups/log-group/%2Fecs%2F${CLUSTER_NAME}"

echo ""
echo "Remember: You will be charged for the Fargate tasks while they are running."
echo "Bye!"
