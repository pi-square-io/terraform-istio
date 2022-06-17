# ########
# EKS IAM
# ########

resource "aws_iam_role" "eks_role" {
  count = var.create_eks_cluster_role ? 1 : 0
  name  = var.cluster_role_name

  tags = var.tags

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "AmazonEKSClusterPolicy" {
  count      = var.create_eks_cluster_role ? 1 : 0
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks_role[count.index].name
}

resource "aws_iam_role_policy_attachment" "AmazonEKSServicePolicy" {
  count      = var.create_eks_cluster_role ? 1 : 0
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
  role       = aws_iam_role.eks_role[count.index].name
}

# ##################
# EKS Node Group IAM
# ##################

resource "aws_iam_role" "eks_nodes_role" {
  count = var.create_eks_node_group_role ? 1 : 0
  name  = var.nodes_role_name

  tags               = var.tags
  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "AmazonEKSWorkerNodePolicy" {
  count      = var.create_eks_node_group_role ? 1 : 0
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.eks_nodes_role[count.index].name
}

resource "aws_iam_role_policy_attachment" "AmazonEKS_CNI_Policy" {
  count      = var.create_eks_node_group_role ? 1 : 0
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.eks_nodes_role[count.index].name
}

resource "aws_iam_role_policy_attachment" "AmazonEC2ContainerRegistryReadOnly" {
  count      = var.create_eks_node_group_role ? 1 : 0
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.eks_nodes_role[count.index].name
}

# ###########################################################
# Key pair generation (store it as SSM parameter and locally)
# ###########################################################

resource "tls_private_key" "generated" {
  count     = var.create_key_pair ? 1 : 0
  algorithm = "RSA"
  rsa_bits  = 4096
}
resource "aws_key_pair" "generated" {
  count      = var.create_key_pair ? 1 : 0
  key_name   = var.key_name
  depends_on = [tls_private_key.generated]
  public_key = tls_private_key.generated[count.index].public_key_openssh
}
resource "aws_ssm_parameter" "key_pair" {
  count     = var.create_key_pair ? 1 : 0
  name      = var.key_name
  value     = tls_private_key.generated[count.index].private_key_pem
  type      = "SecureString"
  overwrite = true
}

# ############
#  EKS Cluster
# ############

resource "aws_eks_cluster" "eks_cluster" {
  name                      = var.cluster_name
  role_arn                  = try(aws_iam_role.eks_role[0].arn, var.role_arn)
  enabled_cluster_log_types = var.enabled_cluster_log_type
  version                   = var.cluster_version


  vpc_config {
    subnet_ids              = var.subnet_ids
    endpoint_private_access = var.cluster_endpoint_private_access
    endpoint_public_access  = var.cluster_endpoint_public_access
    public_access_cidrs     = var.cluster_endpoint_public_access_cidrs
  }

  kubernetes_network_config {
    service_ipv4_cidr = var.kubernetes_service_ipv4_cidr
    ip_family         = var.kubernetes_ip_family
  }

  tags = merge(
    var.tags,
    tomap({
      "Name" = var.cluster_name
    })
  )
}


# ##############
# EKS Node Group
# ##############

resource "aws_eks_node_group" "node" {
  count           = var.node_group_number
  cluster_name    = aws_eks_cluster.eks_cluster.name
  node_group_name = var.node_group_name
  node_role_arn   = try(aws_iam_role.eks_nodes_role[0].arn, var.node_role_arn)
  subnet_ids      = var.subnet_ids
  instance_types  = var.node_instance_type
  version         = var.cluster_version
  ami_type        = var.node_ami_type
  capacity_type   = var.node_capacity_type
  disk_size       = var.node_disk_size


  scaling_config {
    desired_size = var.scaling_config.desired_size
    max_size     = var.scaling_config.max_size
    min_size     = var.scaling_config.min_size
  }


  update_config {
    max_unavailable            = lookup(var.update_config, "max_unavailable", null)
    max_unavailable_percentage = lookup(var.update_config, "max_unavailable_percentage", null)
  }

  

  tags = merge(
    var.tags,
    tomap({
      "Name"                = var.node_group_name,
      "propagate_at_launch" = true
    })
  )
}

# #########
# EKS Addon
# #########

resource "aws_eks_addon" "addon" {
  count                    = var.create_addon ? 1 : 0
  cluster_name             = aws_eks_cluster.eks_cluster.name
  addon_name               = var.addon_name
  addon_version            = var.addon_version
  resolve_conflicts        = upper(var.addon_resolve_conflicts)
  preserve                 = var.addon_preserve
  service_account_role_arn = var.addon_service_account_role_arn

  tags = merge(
    var.tags,
    tomap({
      "Name" = var.addon_name
    })
  )
}

data "tls_certificate" "tls_cert" {
  count = var.create_addon ? 1 : 0
  url   = aws_eks_cluster.eks_cluster.identity[0].oidc[0].issuer
}

resource "aws_iam_openid_connect_provider" "oicp" {
  count           = var.create_addon ? 1 : 0
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.tls_cert[count.index].certificates[0].sha1_fingerprint]
  url             = aws_eks_cluster.eks_cluster.identity[0].oidc[0].issuer
}

data "aws_iam_policy_document" "assume_role_policy" {
  count = var.create_addon ? 1 : 0
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    condition {
      test     = "StringEquals"
      variable = "${replace(aws_iam_openid_connect_provider.oicp[count.index].url, "https://", "")}:sub"
      values   = ["system:serviceaccount:kube-system:aws-node"]
    }

    principals {
      identifiers = [aws_iam_openid_connect_provider.oicp[count.index].arn]
      type        = "Federated"
    }
  }
}

resource "aws_iam_role" "addon_role" {
  count              = var.create_addon ? 1 : 0
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy[count.index].json
  name               = "${var.addon_name}-addon-role"
}

resource "aws_iam_role_policy_attachment" "addon_policy" {
  count      = var.create_addon ? 1 : 0
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.addon_role[count.index].name
}