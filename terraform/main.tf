resource "aws_security_group" "sg_jenkins" {
    name        = "allow_jenkins"
    description = "Allow http ssh & sshD inbound traffic"
    vpc_id = "${var.vpc_id}"
    
    ingress {
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        from_port   = 8080
        to_port     = 8080
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        from_port   = 50022
        to_port     = 50022
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}


data "aws_ami" "jenkins" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ami-jenkins*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["self"]
}

resource "aws_key_pair" "keypair" {
  key_name   = "jenkins_keypair"
  public_key = "${file("~/.ssh/id_rsa.jenkins.pub")}"
}

resource "aws_instance" "jenkins" {
  ami                    = "${data.aws_ami.jenkins.id}"
  instance_type          = "t2.micro"
  key_name               = "${aws_key_pair.keypair.id}"
  vpc_security_group_ids = ["${aws_security_group.sg_jenkins.id}"]
  subnet_id              = "${var.subnet_id}"

  tags {
    Name = "jenkins"
  }
}

