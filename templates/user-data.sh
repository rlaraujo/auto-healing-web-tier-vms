#!/bin/bash
set -euxo pipefail

yum update -y

yum install -y nginx
systemctl enable nginx
systemctl start nginx

cat <<'HTML' > /usr/share/nginx/html/index.html
${html_content}
HTML

systemctl reload nginx
