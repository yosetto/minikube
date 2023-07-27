variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "aws_amis" {
   default = {
       us-east-1 = "ami-053b0d53c279acc90"
       eu-west-2 = "ami-0ee8244746ec5d6d4"
   }
}

variable "instance_type" {
   description = "Type of AWS EC2 instance."
   default     = "t2.medium"
}

variable "ssh_user" {
   type        = string
   description = "Default user for EC2 instance."
   default     = "ubuntu"
}

variable "key_name" {
  type        = string
  default     = "minikube-key-pair"
  description = "Key-pair created in AWS"
}