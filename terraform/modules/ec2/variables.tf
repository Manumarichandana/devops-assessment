
variable "instance_type" {
    description = "ec2 instance type "
    type        = string
    default     = "t2.micro"
    validation {
        condition = contains(["t2.micro", "t3.micro","t2.small", "t3.medium"], var.instance_type)
        error_message = "instance type mustbe one of: t2.micro, t3.micro, t2.small or t3.medium"
    }
}
variable "project_name" {
    description = "name tag for resources"
    type        = string
}
variable "allowed_http_cidr" {
    description = "cidr for http"
    type        = string
}
variable "allowed_ssh_cidr" {
    description = "cidr for ssh"
    type        = string
}
variable "key_name" {
    description = "optional ssh key"
    type        = string
    default     = null
}