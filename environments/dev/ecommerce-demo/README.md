
## Initialize Terraform
```bash
terraform init
```

## Terraform Validate
```bash
terraform validate
```

## Terraform Plan to Verify what it is going to create / update / destroy
```bash
terraform plan
```

## Terraform Apply to create resources
```bash
terraform apply 
[or]
terraform apply -auto-approve
```
## Terraform Destroy
```bash
terraform destroy
[or]
terraform plan -destroy  # You can view destroy plan using this command
terraform destroy
```
## Delete Terraform files 
```bash
rm -rf .terraform*
rm -rf terraform.tfstate*
```

## Commands to configure the cluster locally and connect to it / verify it
```bash
aws eks update-kubeconfig \
 --region $(terraform output -raw region) \
 --name $(terraform output -raw cluster_name)
```
```bash
kubectl cluster-info
kubectl get nodes

```
