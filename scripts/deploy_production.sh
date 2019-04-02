#!/bin/bash

terraform init -backend-config=backend/backend-production.tfvars infrastructure
terraform apply -var-file=backend/backend-production.tfvars -var 'stage=production' -auto-approve infrastructure
