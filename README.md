

# Deploying istio with Terraform

- Deploying a service mesh (istio) to establish a dedicated infrastructure layer to secure, connect, and monitor service-to-service communications between microservices.
- Deploying a microservice application on the cluster
- Collecting metrics and traces with istio-addons (Prometheus, Grafana, kiali and jaeger) 

# Technology

- [Istio](https://istio.io/) extends Kubernetes to establish a programmable, application-aware network using the powerful Envoy service proxy. It simplifies observability, traffic management, security, and policy with the leading service mesh.
- [Microservice Application](https://github.com/GoogleCloudPlatform/microservices-demo)
- [Amazon Elastic Kubernetes Service (Amazon EKS)](https://aws.amazon.com/eks/) is a managed container service to run and scale Kubernetes applications in the cloud or on-premises.
- [Prometheus](https://prometheus.io/docs/introduction/overview/) is a free software application used for event monitoring and alerting. It records real-time metrics in a time series database (allowing for high dimensionality) built using a HTTP pull model, with flexible queries and real-time alerting
- [Grafana](https://grafana.com/docs/grafana/latest/introduction/) is a multi-platform open source analytics and interactive visualization web application. It provides charts, graphs, and alerts for the web when connected to supported data sources
- [Kiali](https://kiali.io/) Kiali is a management console for Istio service mesh.
- [jaeger](https://www.jaegertracing.io/) is a distributed tracing system released as open source by Uber Technologies. It is used for monitoring and troubleshooting microservices-based distributed systems.
- [Terraform ](https://kubernetes.io/docs/tasks/tools/) is an infrastructure as code tool that lets you define both cloud and on-prem resources in human-readable configuration files that you can version, reuse, and share. You can then use a consistent workflow to provision and manage all of your infrastructure throughout its lifecycle

# Getting Started

Ensure that you have installed the following tools in your Mac or Linux or Windows Laptop before start working with this module and run Terraform Plan and Apply

1. [aws cli](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html)
2. [terraform](https://learn.hashicorp.com/tutorials/terraform/install-cli)
3. [kubectl](https://kubernetes.io/docs/tasks/tools/)

### Create AWS Profile 

Add the block below to your .aws/credentials file and change the profile_name, aws_access_key_id and aws_secret_access_key with yours.

```shell script
[you-profile-name]
aws_access_key_id = XXXXXXX
aws_secret_access_key = XXXXXXXXXXXXXXXXX
```

### Clone the repo

```shell script
git clone https://github.com/pi-square-io/terraform-istio.git
```

### Set AWS Profile in example.tf 

```hcl
locals {
  aws_account_profile = "you-profile-name" # profile name which chose in the previous step
}
```

 
### Go To example

```shell script
$ cd example
```

### Run Terraform INIT
```shell script
$ terraform init
```

### Run Terraform PLAN

Verify the resources that will be created by this execution.

```shell script
$ terraform plan
```

### Finally, Terraform APPLY

Deploy your environment.

```shell script
$ terraform apply
```

# EKS
<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~>4.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~>4.0 |
| <a name="provider_tls"></a> [tls](#provider\_tls) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_eks_addon.addon](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_addon) | resource |
| [aws_eks_cluster.eks_cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_cluster) | resource |
| [aws_eks_node_group.node](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_node_group) | resource |
| [aws_iam_openid_connect_provider.oicp](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_openid_connect_provider) | resource |
| [aws_iam_role.addon_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.eks_nodes_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.eks_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.AmazonEC2ContainerRegistryReadOnly](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.AmazonEKSClusterPolicy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.AmazonEKSServicePolicy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.AmazonEKSWorkerNodePolicy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.AmazonEKS_CNI_Policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.addon_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_key_pair.generated](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/key_pair) | resource |
| [aws_ssm_parameter.key_pair](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_parameter) | resource |
| [tls_private_key.generated](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/resources/private_key) | resource |
| [aws_iam_policy_document.assume_role_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [tls_certificate.tls_cert](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/data-sources/certificate) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_addon_name"></a> [addon\_name](#input\_addon\_name) | Addon Name 'create\_addon' true | `string` | `null` | no |
| <a name="input_addon_preserve"></a> [addon\_preserve](#input\_addon\_preserve) | indicates if you want to preserve the created resources when deleting the EKS add-on | `bool` | `null` | no |
| <a name="input_addon_resolve_conflicts"></a> [addon\_resolve\_conflicts](#input\_addon\_resolve\_conflicts) | how to resolve parameter value conflicts when migrating an existing add-on to an Amazon EKS add-on or when applying version updates to the add-on | `string` | `null` | no |
| <a name="input_addon_service_account_role_arn"></a> [addon\_service\_account\_role\_arn](#input\_addon\_service\_account\_role\_arn) | Amazon Resource Name (ARN) of an existing IAM role to bind to the add-on's service account. The role must be assigned the IAM permissions required by the add-on. If you don't specify an existing IAM role, then the add-on uses the permissions assigned to the node IAM role | `string` | `null` | no |
| <a name="input_addon_version"></a> [addon\_version](#input\_addon\_version) | Addon Version 'create\_addon' true | `string` | `null` | no |
| <a name="input_cluster_additional_security_group_ids"></a> [cluster\_additional\_security\_group\_ids](#input\_cluster\_additional\_security\_group\_ids) | List of additional, externally created security group IDs to attach to the cluster control plane | `list(string)` | `[]` | no |
| <a name="input_cluster_endpoint_private_access"></a> [cluster\_endpoint\_private\_access](#input\_cluster\_endpoint\_private\_access) | Indicates whether or not the Amazon EKS private API server endpoint is enabled | `bool` | `false` | no |
| <a name="input_cluster_endpoint_public_access"></a> [cluster\_endpoint\_public\_access](#input\_cluster\_endpoint\_public\_access) | Indicates whether or not the Amazon EKS public API server endpoint is enabled | `bool` | `true` | no |
| <a name="input_cluster_endpoint_public_access_cidrs"></a> [cluster\_endpoint\_public\_access\_cidrs](#input\_cluster\_endpoint\_public\_access\_cidrs) | List of CIDR blocks which can access the Amazon EKS public API server endpoint | `list(string)` | <pre>[<br>  "0.0.0.0/0"<br>]</pre> | no |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | EKS Cluster Name | `string` | n/a | yes |
| <a name="input_cluster_role_name"></a> [cluster\_role\_name](#input\_cluster\_role\_name) | EKS Cluster Role Name if you want to create | `string` | `null` | no |
| <a name="input_cluster_version"></a> [cluster\_version](#input\_cluster\_version) | EKS Cluster version (version of kubernetes) | `string` | `null` | no |
| <a name="input_create_addon"></a> [create\_addon](#input\_create\_addon) | Whether to Create AWS OpenId Connect | `bool` | `false` | no |
| <a name="input_create_eks_cluster_role"></a> [create\_eks\_cluster\_role](#input\_create\_eks\_cluster\_role) | whether to Create EKS Cluster Role | `string` | `true` | no |
| <a name="input_create_eks_node_group_role"></a> [create\_eks\_node\_group\_role](#input\_create\_eks\_node\_group\_role) | whether to Create EKS Cluster Role | `string` | `true` | no |
| <a name="input_create_key_pair"></a> [create\_key\_pair](#input\_create\_key\_pair) | whether to create key pair | `bool` | `true` | no |
| <a name="input_enabled_cluster_log_type"></a> [enabled\_cluster\_log\_type](#input\_enabled\_cluster\_log\_type) | List of the desired control plane logging to enable | `list(string)` | `null` | no |
| <a name="input_key_name"></a> [key\_name](#input\_key\_name) | Key Name Which Need to Node Group if 'create\_key\_pair' = true | `string` | `null` | no |
| <a name="input_kubernetes_ip_family"></a> [kubernetes\_ip\_family](#input\_kubernetes\_ip\_family) | The IP family used to assign Kubernetes pod and service addresses. Valid values are ipv4 (default) and ipv6 | `string` | `"ipv4"` | no |
| <a name="input_kubernetes_service_ipv4_cidr"></a> [kubernetes\_service\_ipv4\_cidr](#input\_kubernetes\_service\_ipv4\_cidr) | The CIDR block to assign Kubernetes service IP addresses from. If you don't specify a block, Kubernetes assigns addresses from either the 10.100.0.0/16 or 172.20.0.0/16 CIDR blocks. We recommend that you specify a block that does not overlap with resources in other networks that are peered or connected to your VPC | `string` | `null` | no |
| <a name="input_node_ami_type"></a> [node\_ami\_type](#input\_node\_ami\_type) | Type of Amazon Machine Image (AMI) associated with the EKS Node Group | `string` | `"AL2_x86_64"` | no |
| <a name="input_node_capacity_type"></a> [node\_capacity\_type](#input\_node\_capacity\_type) | Type of capacity associated with the EKS Node Group. Valid values: ON\_DEMAND, SPOT | `string` | `"ON_DEMAND"` | no |
| <a name="input_node_disk_size"></a> [node\_disk\_size](#input\_node\_disk\_size) | Node Group Disk Size | `number` | `20` | no |
| <a name="input_node_group_name"></a> [node\_group\_name](#input\_node\_group\_name) | EKS Node Group Name | `string` | `""` | no |
| <a name="input_node_group_number"></a> [node\_group\_number](#input\_node\_group\_number) | Number of Node Group | `number` | `1` | no |
| <a name="input_node_instance_type"></a> [node\_instance\_type](#input\_node\_instance\_type) | EKS Node Group Instance Type | `list(string)` | <pre>[<br>  "t3.medium"<br>]</pre> | no |
| <a name="input_node_role_arn"></a> [node\_role\_arn](#input\_node\_role\_arn) | Role arn which need to EKS Cluster Node Group | `string` | `null` | no |
| <a name="input_nodes_role_name"></a> [nodes\_role\_name](#input\_nodes\_role\_name) | EKS Cluster Role Name if you want to create | `string` | `null` | no |
| <a name="input_remote_access"></a> [remote\_access](#input\_remote\_access) | EKS Node Group Remote Access | <pre>object({<br>    ec2_ssh_key               = string<br>    source_security_group_ids = list(string)<br>  })</pre> | <pre>{<br>  "ec2_ssh_key": "",<br>  "source_security_group_ids": [<br>    ""<br>  ]<br>}</pre> | no |
| <a name="input_role_arn"></a> [role\_arn](#input\_role\_arn) | Role arn which need to EKS Cluster | `string` | `null` | no |
| <a name="input_scaling_config"></a> [scaling\_config](#input\_scaling\_config) | EKS Node Group Scaling Config | `map(any)` | n/a | yes |
| <a name="input_subnet_ids"></a> [subnet\_ids](#input\_subnet\_ids) | A list of subnet IDs where the EKS cluster (ENIs) will be provisioned along with the nodes/node groups. Node groups can be deployed within a different set of subnet IDs from within the node group configuration | `list(string)` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Maps of tags to assign to Resources | `map(string)` | `{}` | no |
| <a name="input_update_config"></a> [update\_config](#input\_update\_config) | EKS Node Group Update Strategy | `map(any)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_certificate_authority"></a> [certificate\_authority](#output\_certificate\_authority) | n/a |
| <a name="output_cluster_name"></a> [cluster\_name](#output\_cluster\_name) | n/a |
| <a name="output_eks_cluster_endpoint"></a> [eks\_cluster\_endpoint](#output\_eks\_cluster\_endpoint) | n/a |
| <a name="output_identity_oidc_issuer"></a> [identity\_oidc\_issuer](#output\_identity\_oidc\_issuer) | n/a |
<!-- END_TF_DOCS -->

# Helm

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | ~>2.5 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_helm"></a> [helm](#provider\_helm) | ~>2.5 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [helm_release.helm](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_chart"></a> [chart](#input\_chart) | Chart name to be installed. The chart name can be local path, a URL to a chart, or the name of the chart if repository is specified | `string` | n/a | yes |
| <a name="input_create_namespace"></a> [create\_namespace](#input\_create\_namespace) | Create the namespace if it does not yet exist | `bool` | `false` | no |
| <a name="input_name"></a> [name](#input\_name) | Release name | `string` | n/a | yes |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | The namespace to install the release into | `string` | `"default"` | no |
| <a name="input_release_version"></a> [release\_version](#input\_release\_version) | Specify the exact chart version to install. If this is not specified, the latest version is installed. | `string` | `null` | no |
| <a name="input_repository"></a> [repository](#input\_repository) | Repository URL where to locate the requested chart | `string` | `null` | no |
| <a name="input_set"></a> [set](#input\_set) | Value block with custom values to be merged with the values yaml | `list(map(string))` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_name"></a> [name](#output\_name) | n/a |
| <a name="output_namespace"></a> [namespace](#output\_namespace) | n/a |
<!-- END_TF_DOCS -->


