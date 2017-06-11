#!/usr/bin/env bash

region=eu-west-1
image_name=daves125125/go-serve
ecr_repo_name=208780420864.dkr.ecr.eu-west-1.amazonaws.com/go-serve:latest
cluster_name=test-cluster

service_name=go-serve-service
service_definition_file_name=aws_ecs_service_definition.json

task_name=go-serve-task
task_definition_file_name=aws_ecs_task_definition.json


# Build Image
env GOOS=linux GOARCH=386 go build -v -o ./build/app
docker build -t "$image_name" .

# Push Image
eval $(aws ecr get-login --no-include-email --region "$region")
docker tag "$image_name":latest "$ecr_repo_name"
docker push "$ecr_repo_name"

# Create New Task Definition
aws ecs register-task-definition --cli-input-json file://"$task_definition_file_name" --region="$region"

# Create Service Definition (Optional)
aws ecs create-service --service-name "$service_name" --cli-input-json file://"$service_definition_file_name" --region="$region"

# Update Service Definition
aws ecs update-service --service "$service_name" --task-definition "$task_name" --cluster="$cluster_name" --region="$region"
