module "eks-cluster" {
  source                     = "../../"
  create_eks_cluster_role    = true
  cluster_role_name          = "eks-cluster-name"
  create_eks_node_group_role = true
  nodes_role_name            = "node-group-role"

  create_key_pair                       = true
  key_name                              = "eks-node-group-key"
  cluster_name                          = "my-eks-cluster"
  role_arn                              = ""
  cluster_version                       = "1.21"
  subnet_ids                            = ["subnet-03338579317d8c855", "subnet-001df8fbaae52c9f7"]
  cluster_additional_security_group_ids = ["sg-0ec21ecae47a5dfd4"]
  cluster_endpoint_private_access       = false
  cluster_endpoint_public_access        = true
  cluster_endpoint_public_access_cidrs  = ["0.0.0.0/0"]
  enabled_cluster_log_type              = ["audit", "api"]
  kubernetes_service_ipv4_cidr          = "10.100.0.0/16"
  kubernetes_ip_family                  = "ipv4"

  node_group_number  = 1
  node_group_name    = "my-eks-node-group"
  node_instance_type = ["t3.medium"]
  node_role_arn      = ""
  scaling_config = {
    desired_size = 1
    max_size     = 1
    min_size     = 1
  }
  update_config = {
    max_unavailable_percentage = 50 # Or Max_unavailable  ( only one of the two options)
    #    max_unavailable = 2
  }
  remote_access = {
    ec2_ssh_key               = ""
    source_security_group_ids = ["sg-02ea136ed31d4087d"]
  }
  node_disk_size     = 20
  node_ami_type      = "AL2_x86_64"
  node_capacity_type = "ON_DEMAND"

  # Addon
  create_addon                   = true
  addon_name                     = "my-addon"
  addon_resolve_conflicts        = "NONE"
  addon_preserve                 = false
  addon_service_account_role_arn = ""



}