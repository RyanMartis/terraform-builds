# terraform-builds
base terraform files for aws provisioning, NGINX and RDS in AWS VPC with surrounding network components


# setup aws profile

- you will need an aws access key id and secret key in order to build new AWS resources.
- easiest way to set this up would be to to make a profile in `~/.aws/credentials` and edit the `provider` section of `main.tf` to match your profile.

```bash
$ cat ~/.aws/credentials
[ryan-tf]
aws_access_key_id     = <add id here>
aws_secret_access_key = <add secret key here>
```


