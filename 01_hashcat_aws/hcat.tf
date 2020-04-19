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

resource "aws_instance" "hcat" {
  tags = {
    Name = "${var.instance_name}"
  }

  # the AMI is no more dynamic because we need the image
  # containing nVidia driver for Tesla graphic cards
  # Note: I had to subscribe to the following AMI in AWS marketplace to be able to use it:
  # https://aws.amazon.com/marketplace/pp/B07S5G9S1Z?qid=1587305192635&sr=0-5&ref_=srh_res_product_title
  ami           = "ami-0954816923dc67010"
  instance_type = var.instance_type

  key_name                    = aws_key_pair.master.key_name
  associate_public_ip_address = true
  security_groups             = [aws_security_group.only_ssh.name]

  connection {
    host        = self.public_ip
    type        = "ssh"
    user        = "ec2-user"
    private_key = tls_private_key.ssh.private_key_pem
  }

  provisioner "file" {
    source      = var.hash_file
    destination = "/home/ec2-user/target_hashes.txt"
  }

  provisioner "remote-exec" {
    script = "install-hashcat.sh"
  }

  provisioner "remote-exec" {
    inline = ["tmux new -d -s hcat 'hashcat -w 4 -O -m ${var.hash_type} -a 3 --increment /home/ec2-user/target_hashes.txt ; read'"]
  }

}
