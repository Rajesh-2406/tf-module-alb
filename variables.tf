variable "env" {}
variable "tags" {}
variable "subnets" {}
variable "name" {}
variable "vpc_id" {}
variable "port" {
  default = 80
}
variable "sg_subnet_cidr" {}
variable "load_balancer_type" {}
variable "internal" {}