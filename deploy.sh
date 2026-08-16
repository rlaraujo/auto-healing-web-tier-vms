#!/usr/bin/env bash
# With `pipefail` enabled, the return value of a pipeline is the status of the last command to exit with a non-zero status, or zero if no command exited with a non-zero status. This makes it easier to detect failures in any part of a pipeline and is particularly useful for debugging and ensuring correct script behavior
set -euo pipefail

# Init terraform and apply the configuration with auto-approval to avoid manual confirmation prompts. The `-upgrade` flag ensures that the latest provider versions are used.
terraform init -upgrade
# Apply the Terraform configuration with auto-approval to avoid manual confirmation prompts. This command will create or update the infrastructure as defined in the Terraform configuration files.
terraform apply -auto-approve
