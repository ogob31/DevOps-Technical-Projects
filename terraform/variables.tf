variable "region" {
  description = "The AWS region to deploy resources in"
  type        = string
  default     = "us-east-1"

}

variable "terraform-ansible-stack" {
  description = "value"
  type        = string
  default     = "terraform-ansible-stack"
}

variable "instance_type" {
  description = "ubuntu instance type"
  type        = string
  default     = "t2.micro"
}

variable "key_name" {
  description = "Existing AWS key pair name to enable SSH access to the instance"
  type        = string
  default     = "mag key"
}

variable "private_key_path" {
  description = "Path to your local .pem for SSH"
  type        = string
  # Recommend renaming the file to avoid spaces; but path with spaces also works if quoted
  default = "C:/Users/YourUser/Downloads/mag-key.pem"
}

variable "my_ip" {
  description = "my ipIP/CIDR to allow on SSH/8080 (e.g., 1.2.3.4/32). Use 0.0.0.0/0 only for testing."
  type        = string
  default     = "0.0.0.0/0"

}