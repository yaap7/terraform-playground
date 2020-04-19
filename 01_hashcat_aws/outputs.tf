output "aws_hcat_ip" {
  value = aws_instance.hcat.public_ip
}

output "to_ssh" {
  value = "ssh -o StrictHostKeyChecking=no -i ${local_file.ssh_private_key_pem.filename} ec2-user@${aws_instance.hcat.public_ip}"
}
