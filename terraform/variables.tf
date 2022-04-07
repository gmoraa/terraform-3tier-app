# AWS Access Key
variable "aws_access_key" {
  type = string
  sensitive = true
  description = "Access key"
}

# AWS Secret Access Key
variable "aws_secret_key" {
  type = string
  sensitive = true
  description = "Secret key"
}