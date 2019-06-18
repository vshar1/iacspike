# iacspike
Infrastructure as a code spike

## (A) DevOps toolkit Showcase

## Terraform

1.1. [Terraform](./terraform/bootec2)

Pre-requisite -  Set AWS keys
    > source setprofile.sh
    > terraform init
    > terraform apply
    > terraform destroy    

| S.No     | AWS       | AMI/OS  |     ..              | 
| -------- |:---------:| -------:| -------------------:|
| 1        | EC2       | Unix    |  :heavy_check_mark: |


##  Cloudformation

1.1. [Cloudformation ](./cloudformation)

#### Provision a ec2 instance with webserver serving  html page on port 80 

| Description | Command  | Comments | 
|:---------:| -------:| -------- |
| Validate  | aws --region=eu-west-1 cloudformation validate-template --template-body file://ec2spike.yml    |  :heavy_check_mark: |   
| Create    | aws --region=eu-west-1 cloudformation create-stack --stack-name myec2spike --template-body file://ec2spike.yml    |  :heavy_check_mark: | 
| Delete    | aws --region=eu-west-1 cloudformation delete-stack --stack-name myec2spike    |  :heavy_check_mark: |

 
#### Provision a ec2 instance with docker daemon

| Description | Command  | Comments | 
|:---------:| -------:| -------- |
| Create  | aws --region=eu-west-1 cloudformation create-stack --stack-name myec2docker --template-body file://ec2docker.yml --parameters ParameterKey=KeyName,ParameterValue=${AWS_KEY_PAIR_NAME}    |  :heavy_check_mark: |  



