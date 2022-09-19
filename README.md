### https://github.com/RyanMartis/terraform-builds

# install terraform packages
- ensure you have terraform setup locally using terraform documentation (`sudo apt update && sudo apt install terraform`)
- https://learn.hashicorp.com/tutorials/terraform/install-cli

# Pull down repository and init
- `git clone https://github.com/RyanMartis/terraform-builds.git` & `cd terraform-builds`
- once you clone this repo, you should run a `terraform init` in order for terraform to install the modules needed

# setup aws profile

- you will need an aws access key id and secret key in order to build new AWS resources.
- you can set this up in the IAM section of AWS and generate this for your userid.
    - IAM --> Users --> <user name> --> Security Credentials Tab --> Create access key (you can only have 2 per account)
- easiest way to set this up for terraform would be to to make a profile in `~/.aws/credentials` and edit the `provider` section of `main.tf` to match your profile name.
    - https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-files.html
    - https://registry.terraform.io/providers/hashicorp/aws/latest/docs

```bash
# terraform main.tf provider setup
provider "aws" {
    profile     = "ryan-tf"
    region      = var.aws_region
}
```

```bash
# aws credentials file setup
$ cat ~/.aws/credentials
[ryan-tf]
aws_access_key_id     = <add id here>
aws_secret_access_key = <add secret key here>
```

# EC2 Keypairs
- you will need access to your ssh key used during the setup of your ec2 web server 
- your keypair can be made in AWS from the EC2 section --> Network & Security --> Key Pairs. Download the pem file
- modify the `dev.tfvars` assigning a name to `ec2_key_name` to match your AWS account's keypair

# terraform-builds
- This set of `.tf` files are base terraform files using AWS modules to setup NGINX and RDS in an AWS VPC with the surrounding network/security components
- you can run `terraform plan --var-file="dev.tfvars"` and then `terraform apply --var-file="dev.tfvars"` to actually setup the AWS infrastructure
- provided the aws credentials are correctly setup, terraform will by default use that path `~/.aws/credentials` 

# ssh to RDS DB from EC2
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

# cleardown
- once complete don't forget to delete everything! 
- run `terraform destroy -var-file="dev.tfvars"`
