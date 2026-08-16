#!/bin/bash
set -euxo pipefail

yum update -y

yum install -y docker
systemctl enable docker
systemctl start docker

docker run -d \
  --name web-tier \
  -p 80:80 \
  rlaraujo/auto-healing-web-tier-vms-image:v1

# Keep the container running and let the ALB hit the exposed port 80.
