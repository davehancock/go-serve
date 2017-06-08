# go-serve


<h2>Build</h2>
```
env GOOS=linux GOARCH=386 go build -v -o ./build/go-serve 
docker build -t daves125125/go-serve .
```


<h2>Run</h2>
```
docker run -p 8085:8085 -e SERVE_ENV=test daves125125/go-serve
```


<h2>Create Cluster</h2>
```
terraform apply 
```


<h2>AWS CMDs</h2>
```
aws ecr list-images --repository-name=go-serve --region=eu-west-1

```
