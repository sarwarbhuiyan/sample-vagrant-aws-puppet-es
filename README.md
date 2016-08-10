# Introduction

This allows us to use vagrant and puppet to set up environments on AWS for testing or other purposes.

# Pre-requisites

1. Pick a region in AWS
2. Create a keypair 
3. Get a VPC, subnet id, and security group for your machines. This is required for machines m4 or higher
4. Modify the Vagrant file and environments/production/manifests/site.pp file with above information
5. Set environment variables: 
   a. AWS_ACCESS_KEY to your aws access key
   b. AWS_SECRET_KEY to your aws secret key

NOTE: For some reason in the Vagrant file, it takes the group_id not the group name whereas for the ec2 discovery
settings in elasticsearch.yml, it takes the group name

# Run

```
> vagrant up --provider=aws --no-parallel
```


