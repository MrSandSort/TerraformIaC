variable "vpc_cidr"{
    type= string 
    default= "10.0.0.0/16"
}

variable "zone"{
    type= list(string)
    default=["us-east-1a", "us-east-1b", "us-east-1c"]
}

variable "public_cidr"{
    type= list(string)
    default=["10.0.96.0/19", "10.0.128.0/19", "10.0.160.0/19"]
}

variable "private_cidr"{
    type=list(string)
    default=["10.0.0.0/24", "10.0.32.0/24", "10.0.64.0/24"]
}