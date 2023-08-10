module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 19.0"

  cluster_name    = var.cluster_name
  cluster_version = "1.27"

  cluster_endpoint_private_access  = true
  cluster_endpoint_public_access   = false

  cluster_addons = {
    coredns = {
      most_recent = true
    }
    kube-proxy = {
      most_recent = true
    }
    vpc-cni = {
      most_recent = true
    }
  }
  vpc_id                   = var.vpc_id
  control_plane_subnet_ids = var.subnet_ids
  subnet_ids               = var.subnet_ids

  # EKS Managed Node Group(s)
  eks_managed_node_group_defaults = {
      disk_size      = var.eks_managed_node_group_defaults_disk_size
      instance_types = var.instance_types
  }

  eks_managed_node_groups = {
      default = {
          name         = "core-service"
          min_size     = 2
          max_size     = 2
          desired_size = 2
          labels = {
              nodegroup = "core-service"
          }
      }
        # Enable the below in case you need ci system pods to run on a seperate node altogether
        # ci_system = {
        #     name         = "ci_system"
        #     min_size     = 1
        #     max_size     = 3
        #     desired_size = 1
        #     labels = {
        #         nodegroup = "ci_system"
        #     }
        #     iam_role_additional_policies = ["arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryFullAccess"]
        # }
  }

    # node_security_group_additional_rules = {
    #     # ingress_allow_access_from_control_plane = {
    #     #     type                          = "ingress"
    #     #     protocol                      = "tcp"
    #     #     from_port                     = 9443
    #     #     to_port                       = 9443
    #     #     source_cluster_security_group = true
    #     #     description                   = "Allow access from control plane to webhook port of AWS load balancer controller"
    #     # }
    #     ingress_self_all = {
    #         description = "Node to node all ports/protocols"
    #         protocol    = "-1"
    #         from_port   = 0
    #         to_port     = 0
    #         type        = "ingress"
    #         self        = true
    #     }
    #     egress_all = {
    #         description      = "Node all egress"
    #         protocol         = "-1"
    #         from_port        = 0
    #         to_port          = 0
    #         type             = "egress"
    #         cidr_blocks      = ["0.0.0.0/0"]
    #         ipv6_cidr_blocks = ["::/0"]
    #     }
    # }
    # cluster_security_group_additional_rules = {
    #     ingress_allow_accees_from_platform = {
    #         description = "EKS Cluster allow 443 port to get API call"
    #         type        = "ingress"
    #         from_port   = 443
    #         to_port     = 443
    #         protocol    = "tcp"
    #         cidr_blocks = var.vpc_cidr
    #     }
    # }

    tags = var.tags

  }

module "load_balancer_controller_irsa_role" {
  source = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"

  role_name                              = "${var.cluster_name}-load-balancer-controller"
  attach_load_balancer_controller_policy = true

  oidc_providers = {
    ex = {
      provider_arn               = module.eks.oidc_provider_arn
      namespace_service_accounts = ["kube-system:aws-load-balancer-controller"]
    }
  }
  
  depends_on = [ module.eks ]
}