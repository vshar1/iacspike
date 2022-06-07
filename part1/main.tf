module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.14.0"

  # insert required variables here
  name = "alta-${var.infra_env}-vpc"
  cidr = var.vpc_cidr

  azs = var.azs

  # Single NAT Gateway, see docs linked above
  enable_nat_gateway     = true
  single_nat_gateway     = true
  one_nat_gateway_per_az = false

  private_subnets = var.private_subnets
  public_subnets  = var.public_subnets

  tags = {
    Name        = "alta-${var.infra_env}-vpc"
    Project     = "alta.io"
    Environment = var.infra_env
    ManagedBy   = "terraform"
  }

  private_subnet_tags = {
    Role = "private"
  }

  public_subnet_tags = {
    Role = "public"
  }
}

module "eks" {
  source = "terraform-aws-modules/eks/aws"
  version = "18.23.0"

  cluster_name    = var.cluster_name
  cluster_version = var.kubernetes_version

  vpc_id     = module.vpc.vpc_id
  subnet_ids = flatten([module.vpc.private_subnets, module.vpc.public_subnets])

  cluster_endpoint_private_access = true
  cluster_endpoint_public_access  = true

  create_cni_ipv6_iam_policy = true

  # Extend cluster security group rules
  cluster_security_group_additional_rules = {
    egress_nodes_ephemeral_ports_tcp = {
      description                = "To node 1025-65535"
      protocol                   = "tcp"
      from_port                  = 1025
      to_port                    = 65535
      type                       = "egress"
      source_node_security_group = true
    }
  }

  # Extend node-to-node security group rules
  node_security_group_additional_rules = {
    ingress_self_all = {
      description = "Node to node all ports/protocols"
      protocol    = "-1"
      from_port   = 0
      to_port     = 0
      type        = "ingress"
      self        = true
    }
    egress_all = {
      description      = "Node all egress"
      protocol         = "-1"
      from_port        = 0
      to_port          = 0
      type             = "egress"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
    }
  }

  self_managed_node_groups = {
    workers = {
      name = format("%s-workers", var.cluster_name)

      subnet_ids = flatten([module.vpc.private_subnets, module.vpc.public_subnets])

      min_size     = 2
      max_size     = 5
      desired_size = 2

      bootstrap_extra_args = "--kubelet-extra-args '--node-labels=node.kubernetes.io/lifecycle=spot'"

      use_mixed_instances_policy = true
      mixed_instances_policy = {
        instances_distribution = {
          on_demand_base_capacity                  = 0
          on_demand_percentage_above_base_capacity = 20
          spot_allocation_strategy                 = "capacity-optimized"
        }

        override = [
          {
            instance_type     = "m5.large"
            weighted_capacity = "1"
          },
          {
            instance_type     = "m6i.large"
            weighted_capacity = "2"
          },
        ]
      }

      block_device_mappings = {
        xvda = {
          device_name = "/dev/xvda"
          ebs = {
            volume_size           = 30
            volume_type           = "gp3"
            iops                  = 2000
            throughput            = 150
            delete_on_termination = true
          }
        }
      }
    }
  }
      tags = {
        Name = format("%s-workers", var.cluster_name)
      }
}

# TODO
# module "load_balancer_controller" {
#   source = "../.."

#   enabled = true

#   cluster_identity_oidc_issuer     = module.eks.cluster_oidc_issuer_url
#   cluster_identity_oidc_issuer_arn = module.eks.oidc_provider_arn
#   cluster_name                     = module.eks.cluster_id

#   depends_on = [module.eks]
# }