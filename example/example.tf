

module "istio-base" {
  source           = "../modules/helm"
  name             = "istio-base"
  repository       = "https://istio-release.storage.googleapis.com/charts"
  chart            = "base"
  create_namespace = false
  namespace        = kubernetes_namespace.istio-system.metadata.0.name
}




module "istiod" {
  source           = "../modules/helm"
  name             = "istiod"
  repository       = "https://istio-release.storage.googleapis.com/charts"
  chart            = "istiod"
  create_namespace = false
  namespace        = kubernetes_namespace.istio-system.metadata.0.name
  depends_on = [module.istio-base]
}



# module "istio-ingress" {
#   source           = "../modules/helm"
#   name             = "istio-ingress"
#   repository       = "https://istio-release.storage.googleapis.com/charts"
#   chart            = "gateway"
#   create_namespace = false
#   namespace        = kubernetes_namespace.istio-system.metadata.0.name
#   depends_on = [module.istiod]
# }



locals {
  aws_account_profile = "pisquare"
}

locals {
  eks_cluster_name = "my-eks-cluster"
}


data "aws_region" "current" {}

resource "null_resource" "kubeconfig" {
  provisioner "local-exec" {
    command = "aws eks update-kubeconfig --name ${local.eks_cluster_name} --region ${data.aws_region.current.id} --profile ${local.aws_account_profile}"
  }
  depends_on = [module.istiod]
}



## ISTIO

resource "null_resource" "prometheus" {
  provisioner "local-exec" {
    command = "kubectl apply -f ../manifests/istio-addons/prometheus.yaml -n istio-system "
  }
  depends_on = [null_resource.kubeconfig]
}

# resource "null_resource" "istio-addons" {
#   provisioner "local-exec" {
#     command = "kubectl apply -f ../manifests/istio-addons -n istio-system "
#   }
#   depends_on = [null_resource.kubeconfig]
# }

resource "null_resource" "grafana" {
  provisioner "local-exec" {
    command = "kubectl apply -f ../manifests/istio-addons/grafana.yaml -n istio-system "
  }
  depends_on = [null_resource.kubeconfig]
}
resource "null_resource" "jaeger" {
  provisioner "local-exec" {
    command = "kubectl apply -f ../manifests/istio-addons/jaeger.yaml -n istio-system "
  }
  depends_on = [null_resource.kubeconfig]
}
resource "null_resource" "kiali" {
  provisioner "local-exec" {
    command = "kubectl apply -f ../manifests/istio-addons/kiali.yaml -n istio-system "
  }
  depends_on = [null_resource.kubeconfig]
}

## microservice

resource "null_resource" "microservice" {
  provisioner "local-exec" {
    command = "kubectl apply -f ../manifests/microservice/kubernetes-manifests.yaml -n microservice"
  }
  depends_on = [null_resource.kubeconfig]
}


## VPC 
module "vpc" {
  source             = "../modules/vpc"
  availability_zones = var.availability_zones
  cidr_block         = var.cidr_block
  database_subnets   = var.database_subnets
  env                = var.environment
  nat_gateway_count  = var.nat_gateway_count
  private_subnets    = var.private_subnets
  public_subnets     = var.public_subnets
  tags               = local.common_tags
}

## EKS Cluster
module "eks_cluster" {
  source = "../modules/eks"
  cluster_role_name = "eks-cluster-role"
  nodes_role_name   = "eks-node-role-name"

  # EKS cluster
  key_name        = "eks-node-group-key"
  cluster_name    = "my-eks-cluster"
  cluster_version = "1.21"
  subnet_ids            = module.vpc.private_subnets
  # EKS node group
  node_group_number  = 1
  node_group_name    = "my-eks-node-group"
  node_instance_type = ["t3.medium"]
  scaling_config = {
    desired_size = 2
    max_size     = 2
    min_size     = 1
  }
  update_config = {
    max_unavailable_percentage = 50 # Or Max_unavailable  ( only one of the two options)
    #  max_unavailable = 2
  }

}

## ALB Controller
module "iam_alb_controller" {
  source               = "../modules/iam_alb_controller"
  identity_oidc_issuer = module.eks_cluster.identity_oidc_issuer
  ingress_policy_name  = "${var.environment}-alb-policy"
  ingress_role_name    = "${var.environment}-alb-role"
  policy_file          = file("../modules/iam_alb_controller/policy/iam_policy.json")
  service_account_name = var.service_account_name
  tags                 = local.common_tags
#  path                 = "/grafana"
}

module "alb_controller" {
  source               = "../modules/alb_controller"
  cluster_name         = module.eks_cluster.cluster_name
  ingress_role_arn     = module.iam_alb_controller.ingress_role_arn
  service_account_name = var.service_account_name

}