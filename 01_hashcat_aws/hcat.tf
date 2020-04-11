# discover our own IP address
# hope it will not change over time!
data "http" "ifconfig" {
  url = "https://ifconfig.me/ip"
}

resource "aws_security_group" "only_ssh" {
  name        = "${var.instance_name}_only_ssh"
  description = "Allow only SSH"

  tags = {
    Name = "${var.instance_name}_only_ssh"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH from my public IP"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${chomp(data.http.ifconfig.body)}/32"]
  }
}

resource "aws_key_pair" "master" {
  key_name   = var.instance_name
  public_key = tls_private_key.ssh.public_key_openssh
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "hcat" {
  tags = {
    Name = "${var.instance_name}"
  }

  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type

  key_name                    = aws_key_pair.master.key_name
  associate_public_ip_address = true
  security_groups             = [aws_security_group.only_ssh.name]

  connection {
    host        = aws_instance.hcat.public_ip
    type        = "ssh"
    user        = "ubuntu"
    private_key = tls_private_key.ssh.private_key_pem
  }

  provisioner "file" {
    source      = var.hash_file
    destination = "/home/ubuntu/target_hashes.txt"
  }

  provisioner "remote-exec" {
    script = "install-hashcat.sh"
  }
}
