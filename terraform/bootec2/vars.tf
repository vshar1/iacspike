variable "AWS_REGION" {
  default = "eu-west-1"
}
variable "AMIS" {
  type = "map"
  default = {
    eu-west-1 = "ami-09693313102a30b2c"
  }
}
