variable "flatcar_ami" {
  type        = string
  description = "AMI for FlatCar in your region"
}
variable "aws_availability_zone" {
  type        = string
  description = "AWS Availability zone"
}

variable "public_worker_1" {
  type        = bool
  default     = false
  description = "Set as true to configure Worker 1 as public"
}

variable "ec2_user" {
  type    = string
  default = "ec2-user"
}

variable "private_key_path" {
  type        = string
  description = "Path to file with public key"
}

variable "public_key_path" {
  type        = string
  description = "Path to file with public key"
}
