# terraform-playground

## First project

Create a terraform configuration which launch an AWS instance, install the lastest hashcat binary on it and start a password cracking.

At first I'd like to only use terraform, but maybe Ansible will come to the rescue later.

The `destroy` provisioner will gather the results locally.

### Versions

This toy was created using those versions:

``` text
Terraform v0.12.24
+ provider.aws v2.57.0
+ provider.http v1.2.0
+ provider.local v1.4.0
+ provider.tls v2.1.1
```

### How to use

``` bash
# grab the dependencies
terraform init
# set your own variables
cp template.tfvars terraform.tfvars
nano/vim/emacs terraform.tfvars
# launch the server creation
terraform apply
```
