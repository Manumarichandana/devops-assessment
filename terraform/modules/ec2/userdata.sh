#!/bin/bash
yum update -y
amazon-linux-extras install nginx1 -y
 
systemctl start nginx
systemctl enable nginx
 
cat <<EOF > /etc/nginx/conf.d/devops.conf
server {
    listen 80;
 
    location /health {
        return 200 'OK';
        add_header Content-Type text/plain;
    }
 
    location /version {
        return 200 'v1.0.0';
        add_header Content-Type text/plain;
    }
 
    location / {
        return 200 'Chandana DevOps Assessment Running';
        add_header Content-Type text/plain;
    }
}
EOF
 
systemctl restart nginx