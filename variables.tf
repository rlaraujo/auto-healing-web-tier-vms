variable "project_name" {
  description = "Project prefix used across the infrastructure."
  type        = string
  default     = "auto-healing-web-tier"
}

variable "vpc_cidr" {
  description = "The CIDR block used for the VPC."
  type        = string
  default     = "10.10.0.0/16"
}

variable "public_subnet_cidrs" {
  description = "Public subnet CIDR blocks across two AZs."
  type        = list(string)
  default     = ["10.10.1.0/24", "10.10.2.0/24"]
}

variable "instance_type" {
  description = "EC2 instance type for the web tier."
  type        = string
  default     = "t3.micro"
}

variable "min_capacity" {
  description = "Minimum number of healthy web instances behind the load balancer."
  type        = number
  default     = 2
}

variable "desired_capacity" {
  description = "Desired number of web instances running at any time."
  type        = number
  default     = 2
}

variable "max_capacity" {
  description = "Maximum number of web instances allowed by the Auto Scaling Group."
  type        = number
  default     = 3
}
