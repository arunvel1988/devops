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

variable "tag_list" {
  type    = "list"
  default = ["web", "db"]
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
  count = 2

  //ami           = "${lookup(var.amis, var.region)}"
  ami           = "${data.aws_ami.rhel.id}"
  instance_type = "t2.micro"

  tags {
    Name    = "class-instnace ${count.index}"
    Purpose = "${var.tag_list[count.index]}"
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

data "aws_availability_zones" "all" {}

resource "aws_instance" "ec2" {
  count = 2

  //ami           = "${lookup(var.amis, var.region)}"
  ami           = "${data.aws_ami.rhel.id}"
  instance_type = "t2.micro"

  tags {
    Name    = "class-instnace ${count.index}"
    Purpose = "${var.tag_list[count.index]}"
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

