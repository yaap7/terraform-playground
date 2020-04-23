# 01 - hashcat on AWS

## Terraform Versions

This toy was created using those versions:

``` text
Terraform v0.12.24
+ provider.aws v2.57.0
+ provider.http v1.2.0
+ provider.local v1.4.0
+ provider.tls v2.1.1
```

## How to use

``` bash
# grab the dependencies
terraform init
# launch the server creation
terraform apply -var hash_file=wpa2_handshake.txt -var hash_type=2500
```

You can also use `-var instance_type=xxxx` to invoke more cracking power (but it will be more expensive).
