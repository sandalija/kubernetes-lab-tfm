variable "flatcar_ami" {
  type        = string
  description = "AMI for FlatCar in your region"
}
variable "aws_availability_zone" {
  type        = string
  description = "AWS Availability zone"
}

variable "public_key_path" {
  type        = string
  description = "Path to file with public key"
}