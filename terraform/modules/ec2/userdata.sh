#!/bin/bash
yum update -y
amazon-linux-extras install nginx1 -y
 
systemctl start nginx
systemctl enable nginx
 
echo "OK" > /usr/share/nginx/html/health
echo "v1.0" > /usr/share/nginx/html/version