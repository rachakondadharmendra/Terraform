commands :

To bring up the infra use these commands

```
terraform init
terraform plan -out=plan -var="region=us-west-2"
terraform apply plan

```

To bring down the infra use these commands

```
destroy resources
terraform plan -out=plan -destroy -var="region=us-west-2"
terraform apply plan
```
