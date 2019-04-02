#!/bin/bash

terraform init -backend-config=backend/backend-production.tfvars infrastructure
terraform plan -var-file=backend/backend-production.tfvars -var 'stage=production' infrastructure
