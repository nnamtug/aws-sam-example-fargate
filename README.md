## AWS SAM Example Fargate


This project demonstrates deploying and managing ECS Fargate tasks using AWS SAM, with automated build, deployment, and teardown scripts.


**Note:** Fargate tasks are defined as Docker images. You build and push these images to Amazon ECR, and then ECS Fargate runs them as containers.

**Security Notice:**
When you log in to Amazon ECR using `docker login`, Docker may store your password unencrypted in `~/.docker/config.json` unless you configure a credential helper. This is a standard Docker warning. For improved security, follow the official Docker documentation to set up a credential store:
https://docs.docker.com/engine/reference/commandline/login/#credential-stores

### Setup

1. Clone the repository:
	 ```bash
	 git clone https://github.com/nnamtug/aws-sam-example-fargate.git
	 cd aws-sam-example-fargate
	 ```

2. Configure AWS credentials for your CLI.

3. Install dependencies:

    - [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)
    - [AWS SAM CLI](https://docs.aws.amazon.com/serverless-application-model/latest/developerguide/serverless-sam-cli-install.html)
	- Docker (required for building and running Fargate task images)
	- jq, tomlq


4. Deploy the stack:
	```bash
	sam build
	sam deploy --guided
	```
	This creates the ECS cluster, ECR repository, IAM roles, VPC, subnets, and log group.

5. Refresh resource IDs for scripts:
	```bash
	./refresh-resourceids.sh
	```
	This script extracts resource IDs from the deployed stack and writes them to files for use by other scripts.

### Usage

#### Build and Push Docker Images to Fargate

- Build and push all Fargate task images:
	```bash
	./build-and-push-all-fargate-tasks.sh
	```
	Iterates over all subdirectories in `fargate/`, building and pushing Docker images for each task.
    Use ```sudo```, if your docker installations requires to call docker with elevated priviledges.

#### Launch Tasks

- Launch three tasks per subnet:
	```bash
	./run_three_tasks_per_subnet.sh
	```
	Launches ECS Fargate tasks in each subnet (A, B, C), with a pause between launches. After each launch, the script prints links to the AWS Console for cluster and task monitoring, and at the end, a link to the CloudWatch log group.

#### Clean Up

- Delete all images from ECR before stack deletion:
	```bash
	./delete-ecr-images.sh
	```
	Prompts for confirmation before deleting all images in the ECR repository.

- Delete the stack:
	```bash
	./delete-stack.sh
	```
	Prompts for confirmation, then deletes the CloudFormation stack.

### Monitoring

- Links to the AWS Console for ECS clusters, tasks, and CloudWatch logs are provided by the scripts for easy monitoring.
