# common
variable env_prefix {
    default = "prod"
}

# variables for vpc
variable vpc_cidr_block {
    default = "10.0.0.0/16"
}


variable "public_subnet_numbers" {
    type = map(number)
    description = "Map of availability zone to a number for public subnets"
    default = {
        us-east-1a = 1
        us-east-1b = 2
        us-east-1c = 3
    }
}

variable "private_subnet_numbers" {
    type = map(number)
    description = "Map of availability zone to a number for private subnets"
    default = {
        us-east-1a = 4
        us-east-1b = 5
        us-east-1c = 6
    }
}


# launch template
variable "custom_ami_name" {
  default = "amzon-linux-nodeapp-3"
}

variable ssh_public_key {
    default = "/home/towhid/.ssh/id_rsa.pub"
}

variable instance_type {
    default = "t2.micro"
}


# certificate manager
variable root_domain {
    default = "smart-techthings.com"
}

variable sub_domain {
    default = "*"
}

variable dns_zone_name {
    default = "smart-techthings.com"
}

# nodeapp.smart-techthings.com
variable dns_record_name {
    default = "nodeapp"
}
