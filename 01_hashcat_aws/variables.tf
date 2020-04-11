variable "aws_region" {
  description = "The AWS region where the instance will be created."
  type        = string
  default     = "us-east-1"
}

variable "instance_type" {
  description = "The Name tag to set for the EC2 Instance."
  type        = string
  default     = "p2.xlarge"
}

variable "instance_name" {
  description = "The Name tag to set for the EC2 Instance."
  type        = string
  default     = "hcat"
}

variable "hash_type" {
  description = "The hash number from hashcat format."
  type        = number
  default     = 1000
}

variable "hash_file" {
  description = "The file containing hashes that will be cracked by hashcat."
  type        = string
  default     = "./contoso.local_1000.hash"
}
