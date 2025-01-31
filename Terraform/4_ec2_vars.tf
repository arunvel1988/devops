provider "aws" {
  region     = "${var.region}"
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
}

variable "region" {
  description = "AWS region to create resources"
  default     = "us-east-1"
  type        = "string"
}

variable "access_key" {
  default = "access_key"
}

variable "secret_key" {
  default = "secret_key"
}

variable "tags" {
  default = "terraform"
}

variable "amis" {
  type = "map"

  default = {
    "us-west-1" = "ami-08949fb6466dd2cf3"
    "us-east-2" = "ami-05220ffa0e7fce3d1"
    "us-east-1" = "ami-098bb5d92c8886ca1"
  }
}

resource "aws_instance" "ec2" {
  ami           = "${lookup(var.amis, var.region)}"
  instance_type = "t2.micro"

  tags {
    Name = "dev-env"
  }
}