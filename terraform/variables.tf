variable "region" {
    description = "aws region where resources will be deployed"
    type        =  string
    default     = "eu-west-2"
    validation {
        condition = contains(["eu-west-2", "us-east-1", "us-west-2"], var.region)
        error_message = "region mustbe one of: eu-west-2, us-east-1, us-west-2"
    }
}
variable "instance_type" {
    description = "ec2 instance type "
    type        = string
    default     = "t3.micro"
    validation {
        condition = contains(["t2.micro", "t3.micro"], var.instance_type)
        error_message = "instance type mustbe one of: t2.micro or t3.micro"
    }
}
variable "project_name" {
    description = "name tag for resources"
    type        = string
    default     = "spectrum-life"
}
variable "allowed_http_cidr" {
    description = "cidr for http"
    type        = string
    default     = "0.0.0.0/0"
}
variable "allowed_ssh_cidr" {
    description = "cidr for ssh"
    type        = string
    default     = "0.0.0.0/0"
}
variable "key_name" {
    description = "optional ssh key"
    type        = string
    default     = null
}