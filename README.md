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

 
#### Provision a ec2 instance with docker daemon with Jenkins

| Description | Command  | Comments | 
|:---------:| -------:| -------- |
| Create  | aws --region=eu-west-1 cloudformation create-stack --stack-name myec2docker --template-body file://ec2docker.yml --parameters ParameterKey=KeyName,ParameterValue=${AWS_KEY_PAIR_NAME}    |  :heavy_check_mark: |  

##### Build the base Docker Image 
    docker build -t iacspike/jenkins:0.1 . 

###### Build the base Docker Image 
    docker build -t iacspike/jenkins:0.1 . 
 
#### Provision a Nexus instance as a container

| Description | Command  | Comments | 
|:---------:| -------:| -------- |
| Create  | aws --region=eu-west-1 cloudformation create-stack --stack-name myec2nexus --template-body file://ec2nexus.yml --parameters ParameterKey=KeyName,ParameterValue=${AWS_KEY_PAIR_NAME}    |  :heavy_check_mark: |  
| Delete  | aws --region=eu-west-1 cloudformation delete-stack --stack-name myec2nexus  |  :heavy_check_mark: |  

#### Provision a remote Desktop Ubuntu 

1. [Base AMI Image URL](https://aws.amazon.com/marketplace/pp/B07LBG6YGB?qid=1562077424447&ref_=srh_res_product_title&sr=0-1&stl=true#pdp-support)

2. [AMI ID](https://xworkspace/amd64/desktop-v1.1.0-20190325.55-7a90aa02-06a1-4c3a-93cb-c4572cc77c6c-ami-0aaf600fbf44d9153.4_ami-0d8d7288aca78ee6f)

