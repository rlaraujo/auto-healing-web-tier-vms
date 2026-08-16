#!/bin/bash
set -euxo pipefail

yum update -y

yum install -y docker
systemctl enable docker
systemctl start docker

mkdir -p "$(dirname "${html_path}")"
cat <<'HTML' > "${html_path}"
${html_content}
HTML

docker run -d \
  --name web-tier \
  -p 80:80 \
  -v "${html_path}":/usr/share/nginx/html/index.html:ro \
  nginx:latest

# Keep the container running and let the ALB hit the exposed port 80.
