module "eks-cluster" {
  source            = "../../"
  cluster_role_name = "eks-cluster-role"
  nodes_role_name   = "eks-node-role-name"

  # EKS cluster
  key_name        = "eks-node-group-key"
  cluster_name    = "my-eks-cluster"
  cluster_version = "1.21"
  subnet_ids      = ["subnet-03338579317d8c855", "subnet-001df8fbaae52c9f7"]

  # EKS node group
  node_group_number  = 1
  node_group_name    = "my-eks-node-group"
  node_instance_type = ["t3.medium"]
  scaling_config = {
    desired_size = 1
    max_size     = 1
    min_size     = 1
  }
  update_config = {
    max_unavailable_percentage = 50 # Or Max_unavailable  ( only one of the two options)
    #  max_unavailable = 2
  }
  remote_access = {
    ec2_ssh_key               = ""
    source_security_group_ids = ["sg-02ea136ed31d4087d"]
  }
}