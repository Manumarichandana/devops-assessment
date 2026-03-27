
data "aws_ami" "amazon_linux" {
    most_recent = true
    owners      = ["amazon"]
    filter {
        name   = "name"
        values = ["amzn2-ami-hvm-*-x86_64-gp2"]
    }
}
resource "aws_security_group" "web_sg" {
    name = "${var.project_name}-sg"
    ingress {
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = [var.allowed_ssh_cidr]
    }
    ingress {
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = [var.allowed_http_cidr]
    }
    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}
resource "aws_instance" "web" {
    ami                     = data.aws_ami.amazon_linux.id
    instance_type           = var.instance_type
    key_name                = var.key_name
    vpc_security_group_ids  = [aws_security_group.web_sg.id]
    user_data               = file("${path.module}/userdata.sh")
    tags                    = {
        project_name = var.project_name
    }
}