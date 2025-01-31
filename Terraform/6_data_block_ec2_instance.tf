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

variable "access_key" {}

variable "secret_key" {}

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

data "aws_availability_zones" "all" {}

resource "aws_instance" "ec2" {
  //ami           = "${lookup(var.amis, var.region)}"
  ami           = "${data.aws_ami.rhel.id}"
  instance_type = "t2.micro"

  tags {
    Name = "class-instnace"
  }
}

data "aws_ami" "rhel" {
  most_recent = true

  filter {
    name   = "name"
    values = ["suse-sles-15-v20180816-hvm-ssd-x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["013907871322"] # Canonical
}

output "public_ip" {
  value     = "${aws_instance.ec2.public_ip}"
  sensitive = true
}

output "private_ip" {
  value = "${aws_instance.ec2.private_ip}"
}

output "public_dns" {
  value = "${aws_instance.ec2.public_dns}"
}

output "azs" {
  value = "${data.aws_availability_zones.all.*.names}"
}

output "ami" {
  value = "${aws_instance.ec2.ami}"
}

