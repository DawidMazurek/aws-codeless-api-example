#!/bin/bash

terraform init -backend-config=backend/backend-staging.tfvars infrastructure
terraform apply -var-file=backend/backend-staging.tfvars -var 'stage=staging' -auto-approve infrastructure
