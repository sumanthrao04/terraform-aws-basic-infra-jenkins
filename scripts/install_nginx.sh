#!/bin/bash
yum update -y
amazon-linux-extras install nginx1 -y || yum install nginx -y
systemctl enable nginx
systemctl start nginx
echo "<h1>terraform-aws-basic-infra-jenkins - Nginx Server</h1>" > /usr/share/nginx/html/index.html