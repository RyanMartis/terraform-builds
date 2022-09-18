# terraform-builds
- base terraform files for aws provisioning, NGINX and RDS in AWS VPC with surrounding network components
- ensure you have terraform setup locally using terraform documentation (`sudo apt update && sudo apt install terraform`)
- once you clone this repo, you should run a `terraform init` in order for terraform to install the modules needed
- once that it run, you can run `terraform plan --var-file="dev.tfvars"` and then `terraform apply --var-file="dev.tfvars"` to actually setup the AWS infrastructure

# setup aws profile

- you will need an aws access key id and secret key in order to build new AWS resources.
- you can set this up in the IAM section of AWS and generate this for your userid. 
- easiest way to set this up for terraform would be to to make a profile in `~/.aws/credentials` and edit the `provider` section of `main.tf` to match your profile name.

```bash
provider "aws" {
    profile     = "ryan-tf"
    region      = var.aws_region
}
```

```bash
$ cat ~/.aws/credentials
[ryan-tf]
aws_access_key_id     = <add id here>
aws_secret_access_key = <add secret key here>
```

# ssh to RDS DB from EC2

- you will need access your ssh key used during the setup of your ec2 web server 
- your keypair can be made in AWS from the IAM section based on whatever AWS user account you are using to run this terraform script
- modify the `dev.tfvars` assigning a name to `ec2_key_name` to match your AWS account's keypair
- Example of connecting to EC2 and then RDS
- retrieve the RDS endpoint after terraform creates this. 

```bash
ssh -i ~/<aws keypair name>.pem ubuntu@<ec2 public ip>
ubuntu@ip-10-0-1-4:~$ 
ubuntu@ip-10-0-1-4:~$ psql -h terraform-20220918164959551600000001.cqqdzl0dyqwo.us-east-1.rds.amazonaws.com -d postgres -U foo
Password for user foo:
psql (14.5 (Ubuntu 14.5-0ubuntu0.22.04.1), server 14.4)
SSL connection (protocol: TLSv1.2, cipher: ECDHE-RSA-AES256-GCM-SHA384, bits: 256, compression: off)
Type "help" for help.
postgres=>
```

