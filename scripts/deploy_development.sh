#!/bin/bash

terraform init -backend-config=backend/backend-development.tfvars infrastructure
terraform apply -var-file=backend/backend-development.tfvars -var 'stage=development' -auto-approve infrastructure
