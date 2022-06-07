# Altana coding excercise

## Terraform

1.1. [Terraform VPC challange](./part1)

Using Terraform Configuration Language, or one of the Terraform CDK languages, create a workspace for AWS with the following resources:
- A VPC with a 10.0.0.0/16 CIDR, DNS support, an Internet Gateway, and NAT Gateways for 3 availability zones :heavy_check_mark:
- 3 /24 private subnets associated with the above NAT Gateways :heavy_check_mark:
- A single EKS cluster in all subnets, with public endpoint access enabled :heavy_check_mark:
- AWS Load Balancer controller with Public-facing ALB :white_check_mark:

    Pre-requisite 
    
    > aws cli installed 
        : aws --version

    > terraform installed
        : terraform --version

    > aws credentials are set
        : aws sts get-caller-identity

Execution

    cd ../part1/
    terraform init
    terraform plan -var-file="dev.tfvars"
    terraform apply -var-file="dev.tfvars"

### Sample Run screenshot as attached ### 

<img src="Preview1.gif"  width="850" height="340"> 
<img src="Preview2.gif"  width="850" height="340">

## Terraform TODO (Not achieved)

1.1. [EKS Pod deployment challange](./part2)

Additionally, we'll want to deploy an application to the EKS Cluster. Using Terraform, Helm, or another templating tool, please write a script that produces Kubernetes manifests to deploy the following:

A Deployment named search-api running a bare nginx container, a corresponding Service targeted to port 80, and a corresponding Ingress for host search.altana.ai
A Deployment named graph-api running a bare nginx container, a corresponding Service targeted to port 80, and a corresponding Ingress for host graph.altana.ai
Your deliverable should be a git repository (zipped and attached) with the following requirements:

Your Terraform scripts or configs
Your Kubernetes scripts or manifests
A README describing how to run your scripts, install prerequisites, etc
Clean code that's easy to read and reason about. It doesn't need to be performant, but it should be simple and correct.

