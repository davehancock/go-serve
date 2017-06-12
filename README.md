# go-serve


<h2>Build</h2>
```shell
env GOOS=linux GOARCH=386 go build -v -o ./build/go-serve 
docker build -t daves125125/go-serve .
```


<h2>Push Image (Docker Hub)</h2>
```shell
docker push daves125125/go-serve:latest
```


<h2>Push Image (AWS)</h2>
```shell
eval $(aws ecr get-login --no-include-email --region eu-west-1)
docker tag daves125125/go-serve:latest 208780420864.dkr.ecr.eu-west-1.amazonaws.com/go-serve:latest
docker push 208780420864.dkr.ecr.eu-west-1.amazonaws.com/go-serve:latest
```


<h2>Run</h2>
```shell
docker run -p 8085:8085 -e SERVE_ENV=test daves125125/go-serve
```


<h2>Create Cluster</h2>
```shell
terraform apply 
```


<h2>AWS CMDs</h2>
```shell
aws ecr list-images --repository-name=go-serve --region=eu-west-1
aws ecs list-services --cluster test-cluster --region=eu-west-1 
aws ecs list-task-definitions --region=eu-west-1

aws elbv2 describe-target-groups --region=eu-west-1 help

aws ecs create-service --service-name go-serve-service --cli-input-json file://ecs-simple-service-elb.json --region=eu-west-1
aws ecs update-service --service go-serve-service --task-definition go-serve-family --cluster=test-cluster --region=eu-west-1

```


<h2>AWS CD Flow</h2>

- Push new image to ECR and tag with latest
- Create new task definition (using latest ECR tagged image + task file)
- Update Service to use the new task definition (using family + service name)


