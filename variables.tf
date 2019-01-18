variable "aws_region" {
  description = "AWS region to launch servers."
  default     = "eu-west-1"
}
variable "aws_zone" {
  description = "AWS zone to launch servers."
  default     = "eu-west-1a"
}
variable "aws_bundle" {
  description = "AWS instance size."
  default     = "medium_"
}
variable "aws_blueprint" {
  description = "AWS type of operating system."
  default     = "centos_7_1805_01"
}
variable "ocp_username" {
}
variable "ocp_htpasswd" {
}
variable "ocp_console" {
}
variable "ocp_subdomain" {
}
