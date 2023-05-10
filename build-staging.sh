export environment=staging

terraform init -reconfigure -backend-config=config/backend-${environment}.conf

export TF_VAR_env=${environment}
terraform plan -out "planfile"

terraform apply -input=false "planfile"
