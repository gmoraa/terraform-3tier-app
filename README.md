# Sample 3tier app
This repo contains code for a Node.js multi-tier application.

The application overview is as follows

```
web <=> api <=> db
```

The folders `web` and `api` respectively describe how to install and run each app.

## Architecture
![diagram](/images/diagram.png)

# Terraform

In order to create the resources, provide AWS authentication. The `terraform.tfvars` file is a valid option, just create the file in the Terraform directory with the following structure:

```
aws_access_key = "XXXXXXXXXXXXXXXXXXXX"
aws_secret_key = "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
```

In the same account, you must have 2 Docker images to pull, "api" and "web", both available in the respective directory as a `Dockerfile`. The CI/CD pipeline will update the images on every change to this repository via `.gitlab-ci.yml`.

Once those two requirements are met, execute `terraform init` and `terraform apply` from the same directory.
