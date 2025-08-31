
variable "vpc_name" {
  description = "VPC Name"
  type        = string
  default     = "myvpc"
}

variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
  default     = "eks-cloud"
}

variable "public_subnet_cidrs" {
  type        = list(string)
  description = "Public Subnet CIDR values"
  default     = ["10.32.1.0/24", "10.32.2.0/24"]
}

variable "private_subnet_cidrs" {
  type        = list(string)
  description = "Private Subnet CIDR values"
  default     = ["10.32.4.0/24", "10.32.5.0/24"]
}

variable "azs" {
  type        = list(string)
  description = "Availability Zones"
  default     = ["eu-north-1a", "eu-north-1b"]
}

variable "private_subnet_names" {
  type    = list(string)
  default = ["Private_subnet1", "Private_subnet2"]
}

variable "public_subnet_names" {
  type    = list(string)
  default = ["Public_subnet_1", "Public_subnet_2"]
}

variable "cidr_block" {
  type    = string
  default = "10.32.0.0/16"
}

variable "ingress_rules" {
  type    = list(number)
  default = [80, 8080, 8000, 443, 8177, 22, 9000, 3000]
}


