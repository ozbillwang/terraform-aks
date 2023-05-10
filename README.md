# terraform-aks

1. Make sure you login the proper subscirption

```
az account show
```

If not, login with it
```
az login
az account set -s <subscription_id or subscription_name>
az account show
```

2. update backend files and environment vairable files in folder `config` with your environment.

* config/backend-${env}.conf
* config/terraform-${env}.tfvars 

3. run terraform commands. 

Script [deploy.sh](deploy.sh) gives the detail on how to deploy this project for different environments
