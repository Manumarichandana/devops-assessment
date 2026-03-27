provider "aws" {
    region = var.region
}
module "ec2" {
    source              = "./modules/ec2"
    
    instance_type       = var.instance_type
    project_name        = var.project_name
    allowed_ssh_cidr    = var.allowed_ssh_cidr
    allowed_http_cidr   = var.allowed_http_cidr
    key_name            = var.key_name
}
